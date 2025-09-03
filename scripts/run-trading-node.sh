#!/bin/bash
# Optimized runtime script for Agave trading bot node
# Phase 0, Milestone 0.2: Runtime Environment Setup

set -e

echo "🚀 Starting optimized Agave trading bot node..."

# Detect platform
PLATFORM=$(uname -s)
ARCH=$(uname -m)

echo "📋 Platform: $PLATFORM $ARCH"

# Set thread limits for parallel processing
if command -v nproc &> /dev/null; then
    THREAD_COUNT=$(nproc)
elif command -v sysctl &> /dev/null; then
    THREAD_COUNT=$(sysctl -n hw.ncpu)
else
    THREAD_COUNT=8
fi

export RAYON_NUM_THREADS=$THREAD_COUNT
export SOLANA_RUST_THREAD_LIMIT=$THREAD_COUNT

echo "🧵 Using $THREAD_COUNT threads"

# Configure jemalloc if available
if [[ "$PLATFORM" == "Linux" ]]; then
    # Linux jemalloc configuration
    export MALLOC_CONF="background_thread:true,dirty_decay_ms:1000,muzzy_decay_ms:1000,narenas:4"
    
    # Try to use jemalloc
    if [[ -f "/usr/lib/x86_64-linux-gnu/libjemalloc.so" ]]; then
        export LD_PRELOAD="/usr/lib/x86_64-linux-gnu/libjemalloc.so"
        echo "✅ Using jemalloc (x86_64)"
    elif [[ -f "/usr/lib/aarch64-linux-gnu/libjemalloc.so" ]]; then
        export LD_PRELOAD="/usr/lib/aarch64-linux-gnu/libjemalloc.so"
        echo "✅ Using jemalloc (aarch64)"
    elif command -v pkg-config &> /dev/null && pkg-config --exists jemalloc; then
        JEMALLOC_LIB=$(pkg-config --variable=libdir jemalloc)/libjemalloc.so
        if [[ -f "$JEMALLOC_LIB" ]]; then
            export LD_PRELOAD="$JEMALLOC_LIB"
            echo "✅ Using jemalloc (pkg-config)"
        fi
    else
        echo "⚠️  jemalloc not found, using system allocator"
    fi
elif [[ "$PLATFORM" == "Darwin" ]]; then
    # macOS configuration
    export MallocNanoZone=0
    export MALLOC_CONF="background_thread:true,dirty_decay_ms:1000"
    echo "✅ Configured macOS memory management"
fi

# Trading bot specific optimizations
export SOLANA_METRICS_CONFIG="host=localhost:8086,db=trading_metrics,u=solana,p=solana"

# Validator startup flags optimized for trading bot
VALIDATOR_ARGS=(
    # Core performance flags
    --no-os-network-limits-test
    --no-port-check
    --no-wait-for-vote-to-start-leader
    
    # Ledger management (keep smaller for trading bot)
    --limit-ledger-size 50000000
    
    # Disable non-essential features for trading
    --rpc-pubsub-enable-block-subscription false
    --enable-rpc-obsolete_v1_7 false
    
    # Network optimizations
    --gossip-rumor-validation true
    --turbine-recv-threads 2
    
    # Account management
    --accounts-db-caching-enabled
    --accounts-db-test-hash-calculation
)

# Add custom flags if provided
if [[ $# -gt 0 ]]; then
    VALIDATOR_ARGS+=("$@")
fi

echo "🔧 Runtime configuration:"
echo "   Threads: $THREAD_COUNT"
echo "   Allocator: ${LD_PRELOAD:-system}"
echo "   Args: ${VALIDATOR_ARGS[*]}"

# Check if binary exists
VALIDATOR_BIN="./target/release/agave-validator"
if [[ ! -f "$VALIDATOR_BIN" ]]; then
    echo "❌ Validator binary not found at $VALIDATOR_BIN"
    echo "   Run './scripts/build-optimized.sh' first"
    exit 1
fi

echo "🎯 Starting validator..."

# Record start time
START_TIME=$(date +%s)

# Run the validator with optimizations
exec "$VALIDATOR_BIN" "${VALIDATOR_ARGS[@]}"
