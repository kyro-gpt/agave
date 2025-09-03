#!/bin/bash
# Optimized build script for Agave trading bot node
# Phase 0, Milestone 0.1: Compiler Optimization Setup

set -e

echo "🚀 Starting optimized Agave build..."

# Set optimized compiler flags
export RUSTFLAGS="-C target-cpu=native -C opt-level=3 -C codegen-units=1"

# Use clang/mold if available for faster linking
if command -v clang &> /dev/null; then
    export CC=clang
    export CXX=clang++
    echo "✅ Using clang compiler"
fi

if command -v mold &> /dev/null; then
    export RUSTFLAGS="$RUSTFLAGS -Clink-arg=-fuse-ld=mold"
    echo "✅ Using mold linker"
elif command -v lld &> /dev/null; then
    export RUSTFLAGS="$RUSTFLAGS -Clink-arg=-fuse-ld=lld"
    echo "✅ Using lld linker"
fi

# Set thread limits for parallel compilation
if command -v nproc &> /dev/null; then
    export RAYON_NUM_THREADS=$(nproc)
elif command -v sysctl &> /dev/null; then
    export RAYON_NUM_THREADS=$(sysctl -n hw.ncpu)
else
    export RAYON_NUM_THREADS=8
fi

echo "🔧 Build flags: $RUSTFLAGS"
echo "🧵 Using $RAYON_NUM_THREADS threads"

# Record build start time
BUILD_START=$(date +%s)

# Build with optimizations
echo "🔨 Building Agave validator..."
cargo build --release --bin agave-validator

# Calculate build time
BUILD_END=$(date +%s)
BUILD_TIME=$((BUILD_END - BUILD_START))

# Get binary size
BINARY_SIZE=$(ls -lh target/release/agave-validator | awk '{print $5}')

echo "✅ Build completed successfully!"
echo "⏱️  Build time: ${BUILD_TIME}s"
echo "📦 Binary size: $BINARY_SIZE"

# Verify the binary works
echo "🧪 Testing binary..."
if ./target/release/agave-validator --help > /dev/null 2>&1; then
    echo "✅ Binary test passed"
else
    echo "❌ Binary test failed"
    exit 1
fi

echo "🎉 Optimized build complete!"
