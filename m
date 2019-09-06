From: Alexei Starovoitov <ast@kernel.org>
Subject: [PATCH v4 bpf-next 0/4] CAP_BPF and CAP_TRACING
Date: Fri, 6 Sep 2019 16:10:49 -0700
Message-ID: <20190906231053.1276792-1-ast@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8BIT
Return-path: <netdev-owner@vger.kernel.org>
Sender: netdev-owner@vger.kernel.org
To: davem@davemloft.net
Cc: daniel@iogearbox.net, peterz@infradead.org, luto@amacapital.net, netdev@vger.kernel.org, bpf@vger.kernel.org, kernel-team@fb.com, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

v3->v4:
- rebase and typo fixes
- split selftests into separate patch
- update perf* docs with CAP_TRACING
- add a note to commit log that existing unpriv bpf behavior is not changing

v2->v3:
- dropped ftrace and kallsyms from CAP_TRACING description.
  In the future these mechanisms can start using it too.
- added CAP_SYS_ADMIN backward compatibility.

Alexei Starovoitov (4):
  capability: introduce CAP_BPF and CAP_TRACING
  bpf: implement CAP_BPF
  perf: implement CAP_TRACING
  selftests/bpf: use CAP_BPF and CAP_TRACING in tests

 Documentation/admin-guide/perf-security.rst |  4 +-
 Documentation/admin-guide/sysctl/kernel.rst | 10 ++---
 arch/powerpc/perf/core-book3s.c             |  4 +-
 arch/x86/events/intel/bts.c                 |  2 +-
 arch/x86/events/intel/core.c                |  2 +-
 arch/x86/events/intel/p4.c                  |  2 +-
 include/linux/capability.h                  | 18 ++++++++
 include/uapi/linux/capability.h             | 49 ++++++++++++++++++++-
 kernel/bpf/arraymap.c                       |  2 +-
 kernel/bpf/cgroup.c                         |  2 +-
 kernel/bpf/core.c                           |  4 +-
 kernel/bpf/hashtab.c                        |  4 +-
 kernel/bpf/lpm_trie.c                       |  2 +-
 kernel/bpf/queue_stack_maps.c               |  2 +-
 kernel/bpf/reuseport_array.c                |  2 +-
 kernel/bpf/stackmap.c                       |  2 +-
 kernel/bpf/syscall.c                        | 32 ++++++++------
 kernel/bpf/verifier.c                       |  2 +-
 kernel/events/core.c                        | 14 +++---
 kernel/events/hw_breakpoint.c               |  2 +-
 kernel/trace/bpf_trace.c                    |  2 +-
 kernel/trace/trace_event_perf.c             |  4 +-
 net/core/bpf_sk_storage.c                   |  2 +-
 net/core/filter.c                           | 10 +++--
 security/selinux/include/classmap.h         |  4 +-
 tools/testing/selftests/bpf/test_verifier.c | 46 +++++++++++++++----
 26 files changed, 165 insertions(+), 64 deletions(-)

-- 
2.20.0
