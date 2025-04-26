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

## Repository Structure

- `Dockerfile.build`: Dockerfile for building the FlashAttention wheel
- `Dockerfile.runtime`: Dockerfile for the runtime image
- `docker-compose.yml`: Docker Compose configuration for local development
- `.github/workflows/build-and-publish.yml`: GitHub Actions workflow for automated builds
- `examples/`: Directory containing example scripts
  - `simple_attention.py`: Simple example demonstrating FlashAttention usage
