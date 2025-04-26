# FlashAttention Docker Images

This repository provides Docker images for [FlashAttention](https://github.com/Dao-AILab/flash-attention), a fast and memory-efficient exact attention implementation.

## Available Images

Pre-built Docker images are available on Docker Hub:

```
javirub/flashattention-pytorch:flashattn2.7.4-pytorch2.7.0-cuda12.8-cudnn9-runtime
```

The image tag format is:
```
flashattn<VERSION>-pytorch<PYTORCH_VERSION>-cuda<CUDA_VERSION>-cudnn9-runtime
```

## Using the Docker Image

### Basic Usage

```bash
docker run --gpus all -it --rm javirub/flashattention-pytorch:latest
```

### With Your Own Code

```bash
docker run --gpus all -it --rm -v $(pwd):/app/workspace javirub/flashattention-pytorch:latest
```

### Running the Example

This repository includes a simple example that demonstrates how to use FlashAttention:

```bash
# Run the example
docker run --gpus all -it --rm -v $(pwd)/examples:/app/examples javirub/flashattention-pytorch:latest python /app/examples/simple_attention.py
```

The example creates random query, key, and value tensors and runs FlashAttention on them.

## Building Locally

### Prerequisites

- Docker
- Docker Compose
- NVIDIA Container Toolkit (for GPU support)

### Building the Wheel

```bash
# Create output directory
mkdir -p wheel_output

# Build the wheel
docker-compose build build-wheel
docker-compose run --rm build-wheel
```

The wheel file will be available in the `wheel_output` directory.

### Building the Runtime Image

```bash
# Set the wheel filename
export WHEEL_FILE=flash_attn-2.7.4-cp311-cp311-linux_x86_64.whl

# Build the runtime image
docker-compose build runtime
```

## Automated Builds

This repository uses GitHub Actions to automatically build and publish Docker images when new versions of FlashAttention are released.

The workflow:
1. Checks daily for new FlashAttention releases
2. Builds the wheel for the new release
3. Creates a new Docker image with the wheel
4. Pushes the image to Docker Hub

You can also manually trigger a build with specific versions:
1. Go to the Actions tab in the GitHub repository
2. Select the "Build and Publish FlashAttention Docker Image" workflow
3. Click "Run workflow"
4. Enter the desired FlashAttention version, PyTorch version, and CUDA version
5. Click "Run workflow"

## Repository Branches

This repository maintains two main branches:

- `main`: The stable branch with the Docker build system and examples
- `latest_compiled`: A branch that is automatically updated with the latest FlashAttention release

The `latest_compiled` branch contains all the Docker build files from the `main` branch, but is regularly updated with the latest code from the official FlashAttention repository. This branch is ideal if you want to work with the most recent version of FlashAttention while using our Docker build system.

### Automatic Updates

The `latest_compiled` branch is automatically updated whenever a new version of FlashAttention is released. This is done through a GitHub Actions workflow that:

1. Checks daily for new FlashAttention releases
2. Updates the `latest_compiled` branch with the latest code from the official repository
3. Preserves our Docker build system and examples

You can also manually trigger an update:
1. Go to the Actions tab in the GitHub repository
2. Select the "Update Latest Compiled Branch" workflow
3. Click "Run workflow"
4. Optionally enter a specific FlashAttention version
5. Click "Run workflow"

### Manual Reset

If you need to manually reset the `latest_compiled` branch to a specific version of FlashAttention, you can use the `reset_branch.sh` script:

```bash
# Make sure you're on the latest_compiled branch
git checkout latest_compiled

# Run the reset script
./reset_branch.sh
```

This script will:
1. Backup our custom files
2. Reset the branch to the v2.7.4 tag from the upstream repository
3. Restore our custom files
4. Commit the changes

You can modify the script to use a different tag if needed.

## Repository Structure

- `Dockerfile.build`: Dockerfile for building the FlashAttention wheel
- `Dockerfile.runtime`: Dockerfile for the runtime image
- `docker-compose.yml`: Docker Compose configuration for local development
- `reset_branch.sh`: Script to reset the latest_compiled branch to a specific FlashAttention version
- `.github/workflows/build-and-publish.yml`: GitHub Actions workflow for automated Docker builds
- `.github/workflows/update-latest-compiled.yml`: GitHub Actions workflow for updating the latest_compiled branch
- `examples/`: Directory containing example scripts
  - `simple_attention.py`: Simple example demonstrating FlashAttention usage
