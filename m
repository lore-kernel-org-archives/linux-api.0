From: Alexei Starovoitov <ast@kernel.org>
Subject: [PATCH v8 bpf-next 0/9] bpf, tracing: introduce bpf raw tracepoints
Date: Wed, 28 Mar 2018 12:05:31 -0700
Message-ID: <20180328190540.370956-1-ast@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <netdev-owner@vger.kernel.org>
Sender: netdev-owner@vger.kernel.org
To: davem@davemloft.net
Cc: daniel@iogearbox.net, torvalds@linux-foundation.org, peterz@infradead.org, rostedt@goodmis.org, mathieu.desnoyers@efficios.com, netdev@vger.kernel.org, kernel-team@fb.com, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

v7->v8:
- moved 'u32 num_args' from 'struct tracepoint' into 'struct bpf_raw_event_map'
  that increases memory overhead, but can be optimized/compressed later.
  Now it's zero changes in tracepoint.[ch]

v6->v7:
- adopted Steven's bpf_raw_tp_map section approach to find tracepoint
  and corresponding bpf probe function instead of kallsyms approach.
  dropped kernel_tracepoint_find_by_name() patch

v5->v6:
- avoid changing semantics of for_each_kernel_tracepoint() function, instead
  introduce kernel_tracepoint_find_by_name() helper

v4->v5:
- adopted Daniel's fancy REPEAT macro in bpf_trace.c in patch 6
  
v3->v4:
- adopted Linus's CAST_TO_U64 macro to cast any integer, pointer, or small
  struct to u64. That nicely reduced the size of patch 1

v2->v3:
- with Linus's suggestion introduced generic COUNT_ARGS and CONCATENATE macros
  (or rather moved them from apparmor)
  that cleaned up patch 6
- added patch 4 to refactor trace_iwlwifi_dev_ucode_error() from 17 args to 4
  Now any tracepoint with >12 args will have build error

v1->v2:
- simplified api by combing bpf_raw_tp_open(name) + bpf_attach(prog_fd) into
  bpf_raw_tp_open(name, prog_fd) as suggested by Daniel.
  That simplifies bpf_detach as well which is now simple close() of fd.
- fixed memory leak in error path which was spotted by Daniel.
- fixed bpf_get_stackid(), bpf_perf_event_output() called from raw tracepoints
- added more tests
- fixed allyesconfig build caught by buildbot

v1:
This patch set is a different way to address the pressing need to access
task_struct pointers in sched tracepoints from bpf programs.

The first approach simply added these pointers to sched tracepoints:
https://lkml.org/lkml/2017/12/14/753
which Peter nacked.
Few options were discussed and eventually the discussion converged on
doing bpf specific tracepoint_probe_register() probe functions.
Details here:
https://lkml.org/lkml/2017/12/20/929

Patch 1 is kernel wide cleanup of pass-struct-by-value into
pass-struct-by-reference into tracepoints.

Patches 2 and 3 are minor cleanups to address allyesconfig build

Patch 4 refactor trace_iwlwifi_dev_ucode_error from 17 to 4 args

Patch 5 introduces COUNT_ARGS macro

Patch 6 introduces BPF_RAW_TRACEPOINT api.
the auto-cleanup and multiple concurrent users are must have
features of tracing api. For bpf raw tracepoints it looks like:
  // load bpf prog with BPF_PROG_TYPE_RAW_TRACEPOINT type
  prog_fd = bpf_prog_load(...);

  // receive anon_inode fd for given bpf_raw_tracepoint
  // and attach bpf program to it
  raw_tp_fd = bpf_raw_tracepoint_open("xdp_exception", prog_fd);

Ctrl-C of tracing daemon or cmdline tool will automatically
detach bpf program, unload it and unregister tracepoint probe.
More details in patch 6.

Patch 7 - trivial support in libbpf
Patches 8, 9 - user space tests

samples/bpf/test_overhead performance on 1 cpu:

tracepoint    base  kprobe+bpf tracepoint+bpf raw_tracepoint+bpf
task_rename   1.1M   769K        947K            1.0M
urandom_read  789K   697K        750K            755K

Alexei Starovoitov (9):
  treewide: remove large struct-pass-by-value from tracepoint arguments
  net/mediatek: disambiguate mt76 vs mt7601u trace events
  net/mac802154: disambiguate mac80215 vs mac802154 trace events
  net/wireless/iwlwifi: fix iwlwifi_dev_ucode_error tracepoint
  macro: introduce COUNT_ARGS() macro
  bpf: introduce BPF_RAW_TRACEPOINT
  libbpf: add bpf_raw_tracepoint_open helper
  samples/bpf: raw tracepoint test
  selftests/bpf: test for bpf_get_stackid() from raw tracepoints

 drivers/infiniband/hw/hfi1/file_ops.c              |   2 +-
 drivers/infiniband/hw/hfi1/trace_ctxts.h           |  12 +-
 drivers/net/wireless/intel/iwlwifi/dvm/main.c      |   7 +-
 .../wireless/intel/iwlwifi/iwl-devtrace-iwlwifi.h  |  39 ++---
 drivers/net/wireless/intel/iwlwifi/iwl-devtrace.c  |   1 +
 drivers/net/wireless/intel/iwlwifi/mvm/utils.c     |   7 +-
 drivers/net/wireless/mediatek/mt7601u/trace.h      |   6 +-
 include/asm-generic/vmlinux.lds.h                  |  10 ++
 include/linux/bpf_types.h                          |   1 +
 include/linux/kernel.h                             |   7 +
 include/linux/trace_events.h                       |  42 +++++
 include/linux/tracepoint-defs.h                    |   6 +
 include/trace/bpf_probe.h                          |  92 +++++++++++
 include/trace/define_trace.h                       |   1 +
 include/trace/events/f2fs.h                        |   2 +-
 include/uapi/linux/bpf.h                           |  11 ++
 kernel/bpf/syscall.c                               |  78 +++++++++
 kernel/trace/bpf_trace.c                           | 183 +++++++++++++++++++++
 net/mac802154/trace.h                              |   8 +-
 net/wireless/trace.h                               |   2 +-
 samples/bpf/Makefile                               |   1 +
 samples/bpf/bpf_load.c                             |  14 ++
 samples/bpf/test_overhead_raw_tp_kern.c            |  17 ++
 samples/bpf/test_overhead_user.c                   |  12 ++
 security/apparmor/include/path.h                   |   7 +-
 sound/firewire/amdtp-stream-trace.h                |   2 +-
 tools/include/uapi/linux/bpf.h                     |  11 ++
 tools/lib/bpf/bpf.c                                |  11 ++
 tools/lib/bpf/bpf.h                                |   1 +
 tools/testing/selftests/bpf/test_progs.c           |  91 +++++++---
 30 files changed, 607 insertions(+), 77 deletions(-)
 create mode 100644 include/trace/bpf_probe.h
 create mode 100644 samples/bpf/test_overhead_raw_tp_kern.c

-- 
2.9.5
