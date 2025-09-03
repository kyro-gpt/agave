# Phase 1: Low-Hanging Fruit Optimizations

**Duration**: 8 days (Days 3-10)  
**Risk**: Low  
**Expected Gain**: 15-30% performance improvement

## Goals
Implement quick performance wins with minimal functional changes, focusing on data structure replacements and basic algorithmic improvements.

## Strategy
Start with accounts-db component first, validate improvements, then expand to other components.

## Milestones

### Milestone 1.1: FxHashMap Migration - Accounts DB (Days 3-4)
**Focus Component**: `accounts-db/`

**Tasks:**
1. Audit HashMap usage in accounts-db
2. Replace std::HashMap with FxHashMap in safe locations
3. Add rustc-hash dependency
4. Run tests and benchmarks

**Sub-tasks:**
- [ ] `accounts-db/src/accounts_index.rs` - Replace AccountMap
- [ ] `accounts-db/src/accounts_cache.rs` - Replace cache maps
- [ ] `accounts-db/src/accounts_db.rs` - Replace storage maps
- [ ] Add capacity hints where size is known

**Acceptance Criteria:**
- [ ] All accounts-db tests pass
- [ ] Benchmark shows >5% memory reduction
- [ ] No functional changes in behavior
- [ ] Build completes successfully

**Commands to validate:**
```bash
cd accounts-db
cargo test
cargo bench
# Check memory usage in benchmarks
```

### Milestone 1.2: Clone Reduction - Accounts DB (Day 5)
**Focus Component**: `accounts-db/`

**Tasks:**
1. Identify unnecessary clones in hot paths
2. Replace with references where lifetime permits
3. Use Arc for shared ownership
4. Optimize string handling

**Target areas:**
- [ ] Account data cloning in load paths
- [ ] Pubkey cloning in index operations
- [ ] Storage info cloning

**Acceptance Criteria:**
- [ ] Reduced allocations in flamegraph
- [ ] Tests pass
- [ ] Benchmark improvement >3%

### Milestone 1.3: Vector Pre-allocation - Accounts DB (Day 6)
**Focus Component**: `accounts-db/`

**Tasks:**
1. Find Vec::new() in loops
2. Replace with Vec::with_capacity()
3. Pre-size other collections
4. Optimize batch operations

**Target areas:**
- [ ] Account loading batches
- [ ] Index update batches
- [ ] Storage flush operations

**Acceptance Criteria:**
- [ ] Reduced allocation churn
- [ ] Tests pass
- [ ] Memory allocator stats improve

### Milestone 1.4: Expand FxHashMap to Banking Stage (Day 7)
**Focus Component**: `core/src/banking_stage/`

**Tasks:**
1. Apply same FxHashMap migration pattern
2. Focus on scheduler and consumer maps
3. Test transaction processing pipeline

**Target files:**
- [ ] `transaction_scheduler/` maps
- [ ] `consumer.rs` temporary maps
- [ ] QoS service maps

**Acceptance Criteria:**
- [ ] Banking stage tests pass
- [ ] No regression in transaction throughput
- [ ] Memory usage improvement

### Milestone 1.5: Expand to Network Layer (Day 8)
**Focus Component**: `streamer/` and `turbine/`

**Tasks:**
1. Replace HashMap in packet processing
2. Optimize shred deduplication maps
3. Improve retransmit caches

**Target areas:**
- [ ] Packet deduplication maps
- [ ] Shred cache maps
- [ ] Peer connection maps

**Acceptance Criteria:**
- [ ] Network tests pass
- [ ] Packet processing latency maintained
- [ ] Memory footprint reduced

### Milestone 1.6: Lock Optimization - Phase 1 (Day 9)
**Focus**: Replace std locks with parking_lot where safe

**Tasks:**
1. Identify short-held locks in hot paths
2. Replace with parking_lot equivalents
3. Measure lock contention reduction

**Target areas:**
- [ ] Banking stage consumer locks
- [ ] Accounts cache locks
- [ ] Simple coordination locks

**Acceptance Criteria:**
- [ ] Lock contention metrics improve
- [ ] No deadlocks introduced
- [ ] Tests pass

### Milestone 1.7: Phase 1 Integration & Benchmarking (Day 10)
**Tasks:**
1. Integration testing across all modified components
2. Comprehensive benchmarking
3. Performance regression testing
4. Documentation updates

**Benchmarks to run:**
- [ ] End-to-end validator startup time
- [ ] Transaction processing throughput
- [ ] Account loading performance
- [ ] Memory usage under load
- [ ] Slot catch-up speed

**Acceptance Criteria:**
- [ ] All tests pass across workspace
- [ ] >15% performance improvement demonstrated
- [ ] No functional regressions
- [ ] Clean commit ready for Phase 2

## Deliverables
- [ ] Modified source files with FxHashMap migrations
- [ ] Updated Cargo.toml dependencies
- [ ] Performance improvement report
- [ ] Test results documentation
- [ ] Commit with all Phase 1 changes

## Files Expected to Change
```
accounts-db/Cargo.toml
accounts-db/src/accounts_index.rs
accounts-db/src/accounts_cache.rs
accounts-db/src/accounts_db.rs
core/src/banking_stage/transaction_scheduler/*.rs
core/src/banking_stage/consumer.rs
streamer/src/packet.rs
turbine/src/retransmit_stage.rs
turbine/src/sigverify_shreds.rs
```

## Risk Mitigation
- Test each component individually before moving to next
- Keep detailed before/after metrics
- Maintain rollback commits at each milestone
- Run stress tests after each major change

## Validation Commands
```bash
# After each milestone
cargo test --workspace
cargo build --release

# After milestone 1.7
cargo bench --workspace
# Run end-to-end validator test
# Memory profiling with jemalloc stats
```

## Dependencies for Next Phase
Phase 1 must complete with stable, tested improvements before beginning component-specific optimizations in Phase 2.
