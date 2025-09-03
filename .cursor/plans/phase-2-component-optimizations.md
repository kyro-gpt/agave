# Phase 2: Component-Specific Optimizations

**Duration**: 15 days (Days 11-25)  
**Risk**: Medium  
**Expected Gain**: 20-40% performance improvement

## Goals
Target specific optimizations for each major component based on profiling and performance analysis. Maintain current functionality while improving efficiency.

## Strategy
Focus on one component at a time, validate thoroughly, then move to next component.

## Milestones

### Milestone 2.1: Banking Stage Deep Optimization (Days 11-14)
**Focus Component**: `core/src/banking_stage/`

#### Sub-milestone 2.1.1: Transaction Scheduler Optimization (Days 11-12)
**Tasks:**
1. Profile transaction scheduler bottlenecks
2. Implement sharded transaction queues
3. Optimize priority queue operations
4. Reduce scheduler lock contention

**Target files:**
- [ ] `transaction_scheduler/prio_graph_scheduler.rs`
- [ ] `transaction_scheduler/scheduler_container.rs`
- [ ] `transaction_scheduler/scheduler_controller.rs`

**Optimizations:**
- [ ] Shard queues by account hash to reduce contention
- [ ] Use SmallVec for small account key lists
- [ ] Replace scheduler locks with parking_lot
- [ ] Batch scheduling decisions

**Acceptance Criteria:**
- [ ] Transaction throughput increases >10%
- [ ] Lock contention reduces >30%
- [ ] Scheduler tests pass
- [ ] No transaction ordering violations

#### Sub-milestone 2.1.2: Consumer Thread Optimization (Days 13-14)
**Tasks:**
1. Optimize account lock holding time
2. Improve batch processing efficiency
3. Reduce consumer thread coordination overhead

**Target files:**
- [ ] `consumer.rs`
- [ ] `consume_worker.rs`
- [ ] `committer.rs`

**Optimizations:**
- [ ] Minimize account lock scope
- [ ] Pre-allocate batch structures
- [ ] Optimize QoS cost calculations
- [ ] Improve error handling paths

**Acceptance Criteria:**
- [ ] Account lock time reduces >20%
- [ ] Batch processing latency improves
- [ ] Consumer tests pass

### Milestone 2.2: Accounts Database Deep Optimization (Days 15-18)
**Focus Component**: `accounts-db/`

#### Sub-milestone 2.2.1: Index Optimization (Days 15-16)
**Tasks:**
1. Implement hierarchical indexing
2. Add bloom filters for existence checks
3. Optimize index update patterns
4. Improve cache locality

**Target files:**
- [ ] `accounts_index.rs`
- [ ] `in_memory_accounts_index.rs`

**Optimizations:**
- [ ] Two-level index with prefix grouping
- [ ] Per-bucket bloom filters
- [ ] Batch index updates
- [ ] Cache-friendly data layout

**Acceptance Criteria:**
- [ ] Index lookup time reduces >15%
- [ ] Memory usage improves
- [ ] Index tests pass

#### Sub-milestone 2.2.2: Storage Optimization (Days 17-18)
**Tasks:**
1. Implement read-ahead for sequential access
2. Optimize storage layout
3. Improve ancient storage packing
4. Add storage-level caching

**Target files:**
- [ ] `append_vec.rs`
- [ ] `account_storage.rs`
- [ ] `accounts_db.rs`

**Optimizations:**
- [ ] Coalesce adjacent account reads
- [ ] Background storage compaction
- [ ] Memory-mapped file improvements
- [ ] Storage fragmentation reduction

**Acceptance Criteria:**
- [ ] Storage I/O latency reduces >25%
- [ ] Storage fragmentation <20%
- [ ] Storage tests pass

### Milestone 2.3: Network Layer Deep Optimization (Days 19-22)
**Focus Component**: `streamer/` and `turbine/`

#### Sub-milestone 2.3.1: Packet Processing Optimization (Days 19-20)
**Tasks:**
1. Implement packet pooling
2. Optimize UDP buffer management
3. Improve batch processing
4. Reduce packet copying

**Target files:**
- [ ] `streamer/src/packet.rs`
- [ ] `streamer/src/streamer.rs`
- [ ] `streamer/src/recvmmsg.rs`

**Optimizations:**
- [ ] Packet buffer pools
- [ ] Zero-copy packet handling
- [ ] Adaptive batch sizing
- [ ] NUMA-aware allocation

**Acceptance Criteria:**
- [ ] Packet processing latency reduces >20%
- [ ] Packet drop rate improves
- [ ] Network tests pass

#### Sub-milestone 2.3.2: Shred Processing Optimization (Days 21-22)
**Tasks:**
1. Optimize shred deduplication
2. Improve signature verification batching
3. Reduce shred processing overhead
4. Implement shred filtering

**Target files:**
- [ ] `turbine/src/sigverify_shreds.rs`
- [ ] `turbine/src/retransmit_stage.rs`
- [ ] `core/src/shred_fetch_stage.rs`

**Optimizations:**
- [ ] CuckooFilter for deduplication
- [ ] Parallel signature verification
- [ ] Shred relevance filtering
- [ ] Batch shred processing

**Acceptance Criteria:**
- [ ] Shred verification throughput >30% increase
- [ ] False positive rate <1%
- [ ] Shred tests pass

### Milestone 2.4: Consensus & Synchronization Optimization (Days 23-24)
**Focus Component**: `core/src/consensus.rs`, replay stage

**Tasks:**
1. Optimize vote processing
2. Improve fork choice calculations
3. Reduce synchronization overhead
4. Implement catch-up optimizations

**Target files:**
- [ ] `consensus.rs`
- [ ] `replay_stage.rs`
- [ ] `cluster_info_vote_listener.rs`

**Optimizations:**
- [ ] Batch vote verification
- [ ] Cache stake weights
- [ ] Prioritize recent slots
- [ ] Skip non-essential processing when behind

**Acceptance Criteria:**
- [ ] Vote processing latency reduces >25%
- [ ] Catch-up speed improves >20%
- [ ] Consensus tests pass

### Milestone 2.5: Phase 2 Integration & Benchmarking (Day 25)
**Tasks:**
1. Integration testing across all optimized components
2. End-to-end performance testing
3. Stress testing under load
4. Performance regression analysis

**Comprehensive benchmarks:**
- [ ] Full validator startup time
- [ ] Transaction processing pipeline
- [ ] Account loading and storage
- [ ] Network packet processing
- [ ] Consensus and vote processing
- [ ] Memory usage and allocation patterns
- [ ] Slot synchronization speed

**Acceptance Criteria:**
- [ ] All workspace tests pass
- [ ] >20% overall performance improvement
- [ ] No functional regressions
- [ ] Memory usage stable or improved
- [ ] Clean commit ready for Phase 3

## Deliverables
- [ ] Optimized component implementations
- [ ] Performance analysis report
- [ ] Component-specific benchmarks
- [ ] Integration test results
- [ ] Documentation updates

## Risk Mitigation
- Component-by-component validation
- Extensive testing at each sub-milestone
- Performance regression monitoring
- Rollback capability at each milestone
- Feature flags for risky optimizations

## Performance Monitoring
Track these metrics throughout Phase 2:
- Transaction latency (p50, p95, p99)
- Slot lag from network tip
- Memory allocation rate
- CPU utilization per component
- Lock contention statistics
- I/O latency and throughput

## Validation Commands
```bash
# After each sub-milestone
cargo test --package <component>
cargo bench --package <component>

# After each milestone
cargo test --workspace
cargo build --release

# After milestone 2.5
./scripts/run-full-benchmark.sh
./scripts/stress-test.sh
```

## Dependencies for Next Phase
All component optimizations must be stable and well-tested before moving to Phase 3 functional improvements.
