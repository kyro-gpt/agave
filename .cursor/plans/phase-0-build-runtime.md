# Phase 0: Build & Runtime Setup

**Duration**: 2 days  
**Risk**: Minimal  
**Expected Gain**: 10-20% performance improvement

## Goals
Configure build and runtime environment for optimal performance with zero code changes.

## Milestones

### Milestone 0.1: Compiler Optimization Setup (Day 1 Morning)
**Tasks:**
1. Update top-level `Cargo.toml` with optimized profiles
2. Set up RUSTFLAGS environment variables
3. Configure mold/clang linker if available
4. Test build with new settings

**Acceptance Criteria:**
- [ ] `cargo build --release` completes successfully
- [ ] Binary size reduced by >10%
- [ ] Compile time acceptable (<20min on target hardware)

**Commands to run:**
```bash
# Add to ~/.bashrc or equivalent
export RUSTFLAGS="-C target-cpu=native -C opt-level=3 -C lto=fat -C codegen-units=1"
export CC=clang
export CXX=clang++

# Test build
time cargo build --release
ls -lh target/release/agave-validator
```

### Milestone 0.2: Runtime Environment Setup (Day 1 Afternoon)
**Tasks:**
1. Configure jemalloc allocator
2. Set thread pool limits
3. Set up basic runtime flags
4. Create startup script template

**Acceptance Criteria:**
- [ ] jemalloc properly loaded
- [ ] Thread limits configured
- [ ] Startup script works on target system

**Commands to run:**
```bash
# Test jemalloc
export LD_PRELOAD=/usr/lib/x86_64-linux-gnu/libjemalloc.so
export MALLOC_CONF="background_thread:true,dirty_decay_ms:1000"
export RAYON_NUM_THREADS=$(nproc)

# Test startup
./target/release/agave-validator --help
```

### Milestone 0.3: Feature Flag Optimization (Day 2 Morning)
**Tasks:**
1. Identify minimal feature set for trading node
2. Create trading-specific build profile
3. Test with minimal features
4. Document feature selection rationale

**Acceptance Criteria:**
- [ ] Minimal feature build works
- [ ] Binary size reduced further
- [ ] No essential functionality lost

**Commands to run:**
```bash
# Test minimal build
cargo build --release --no-default-features \
  --features="runtime,validator,streamer,turbine,accounts-db"
```

### Milestone 0.4: Baseline Benchmarking (Day 2 Afternoon)
**Tasks:**
1. Set up benchmarking infrastructure
2. Run baseline performance tests
3. Document current performance metrics
4. Establish monitoring

**Acceptance Criteria:**
- [ ] Baseline metrics collected
- [ ] Benchmark suite runs successfully
- [ ] Performance monitoring in place

**Benchmark commands:**
```bash
# Memory usage
/usr/bin/time -v ./target/release/agave-validator --dry-run

# Basic functionality test
cargo test --release --workspace
```

## Deliverables
- [ ] Optimized `Cargo.toml` profiles
- [ ] Build script with optimized flags
- [ ] Runtime startup script
- [ ] Baseline performance report
- [ ] Feature flag documentation

## Files to Create/Modify
- `Cargo.toml` (root level)
- `scripts/build-optimized.sh`
- `scripts/run-trading-node.sh`
- `docs/performance-baseline.md`

## Rollback Plan
- Keep backup of original `Cargo.toml`
- Document all environment changes
- Test fallback to default settings

## Next Phase Dependencies
This phase must complete successfully before starting Phase 1, as it establishes the build environment for all subsequent optimizations.
