#!/bin/bash
set -e

# Create a list of files to preserve (our custom files)
cat > .gitpreserve << EOF
.github/workflows/build-and-publish.yml
.github/workflows/update-latest-compiled.yml
DOCKER.md
Dockerfile.build
Dockerfile.runtime
docker-compose.yml
examples/simple_attention.py
reset_branch.sh
EOF

# Backup our custom files
mkdir -p backup
while read file; do
  mkdir -p backup/$(dirname "$file")
  cp "$file" "backup/$file" 2>/dev/null || true
done < .gitpreserve

# Add upstream remote if it doesn't exist
if ! git remote | grep -q "upstream"; then
  git remote add upstream https://github.com/Dao-AILab/flash-attention.git
fi

# Fetch the v2.7.4 tag from upstream
git fetch upstream --tags

# Reset to the v2.7.4 tag
git reset --hard v2.7.4

# Restore our custom files
while read file; do
  if [ -f "backup/$file" ]; then
    mkdir -p $(dirname "$file")
    cp "backup/$file" "$file"
  fi
done < .gitpreserve

# Cleanup before commit
rm -rf backup
rm -f .gitpreserve

# Commit changes
git add .
git commit -m "Reset latest_compiled branch to FlashAttention v2.7.4"

echo "Branch has been reset to v2.7.4 with custom files preserved."
