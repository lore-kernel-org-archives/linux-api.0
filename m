From: Dave Watson <davejwatson-b10kYP2dOMg@public.gmane.org>
Subject: [RFC PATCH 0/3] restartable sequences benchmarks
Date: Thu, 22 Oct 2015 11:06:28 -0700
Message-ID: <cover.1445464158.git.davejwatson@fb.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: davejwatson-b10kYP2dOMg@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org
List-Id: linux-api@vger.kernel.org

We've been testing out restartable sequences + malloc changes for use
at Facebook.  Below are some test results, as well as some possible
changes based on Paul Turner's original patches

https://lkml.org/lkml/2015/6/24/665

I ran one service with several permutations of various mallocs.  The
service is CPU-bound, and hits the allocator quite hard.  Requests/s
are held constant at the source, so we use cpu idle time and latency
as an indicator of service quality. These are average numbers over
several hours.  Machines were dual E5-2660, total 16 cores +
hyperthreading.  This service has ~400 total threads, 70-90 of which
are doing work at any particular time.

                                   RSS CPUIDLE LATENCYMS
jemalloc 4.0.0                     31G   33%     390
jemalloc + this patch              25G   33%     390
jemalloc + this patch using lsl    25G   30%     420
jemalloc + PT's rseq patch         25G   32%     405
glibc malloc 2.20                  27G   30%     420
tcmalloc gperftools trunk (2.2)    21G   30%     480

jemalloc rseq patch used for testing:
https://github.com/djwatson/jemalloc

lsl test - using lsl segment limit to get cpu (i.e. inlined vdso
getcpu on x86) instead of using the thread caching as in this patch.
There has been some suggestions to add the thread-cached getcpu()
feature separately.  It does seem to move the needle in a real service
by about ~3% to have a thread-cached getcpu vs. not.  I don't think we
can use restartable sequences in production without a faster getcpu.

GS-segment / migration only tests

There's been some interest in seeing if we can do this with only gs
segment, here's some numbers for those.  This doesn't have to be gs,
it could just be a migration signal sent to userspace as well, the
same approaches would apply.

GS patch: https://lkml.org/lkml/2014/9/13/59

                                   RSS CPUIDLE LATENCYMS
jemalloc 4.0.0                     31G   33%     390
jemalloc + percpu locking          25G   25%     420
jemalloc + preempt lock / signal   25G   32%     415

* Percpu locking - just lock everything percpu all the time.  If
  scheduled off during the critical section, other threads have to
  wait.

* 'Preempt lock' idea is that we grab a lock, but if we miss the lock,
  send a signal to the offending thread (tid is stored in the lock
  variable) to restart its critical section.  Libunwind was used to
  fixup ips in the signal handler, walking all the frames.  This is
  slower than the kernel preempt check, but happens less often - only
  if there was a preempt during the critical section.  Critical
  sections were inlined using the same scheme as in this patch.  There
  is more overhead than restartable sequences in the hot path (an
  extra unlocked cmpxchg, some accounting). Microbenchmarks showed it
  was 2x slower than rseq, but still faster than atomics.

  Roughly like this: https://gist.github.com/djwatson/9c268681a0dfa797990c

* I also tried a percpu version of stm (software transactional
  memory), but could never write anything better than ~3x slower than
  atomics in a microbenchmark.  I didn't test this in a real service.

Attached are two changes to the original patch:

1) Support more than one critical memory range in the kernel using
   binary search.  This has several advantages:

  * We don't need an extra register ABI to support multiplexing them
    in userspace.  This also avoids some complexity knowing which
    registers/flags might be smashed by a restart.

  * There are no collisions between shared libraries

  * They can be inlined with gcc inline asm.  With optimization on,
    gcc correctly inlines and registers many more regions.  In a real
    service this does seem to improve latency a hair.  A
    microbenchmark shows ~20% faster.

Downsides:  Less control over how we search/jump to the regions, but I
didn't notice any difference in testing a reasonable number of regions
(less than 100).  We could set a max limit?

2) Additional checks in ptrace to single step over critical sections.
   We also prevent setting breakpoints, as these also seem to confuse
   gdb sometimes.

Dave Watson (3):
  restartable sequences: user-space per-cpu critical sections
  restartable sequences: x86 ABI
  restartable sequences: basic user-space self-tests

 arch/Kconfig                                       |   7 +
 arch/x86/Kconfig                                   |   1 +
 arch/x86/entry/common.c                            |   3 +
 arch/x86/entry/syscalls/syscall_64.tbl             |   1 +
 arch/x86/include/asm/restartable_sequences.h       |  44 +++
 arch/x86/kernel/Makefile                           |   2 +
 arch/x86/kernel/ptrace.c                           |   6 +-
 arch/x86/kernel/restartable_sequences.c            |  47 +++
 arch/x86/kernel/signal.c                           |  12 +-
 fs/exec.c                                          |   3 +-
 include/linux/sched.h                              |  39 +++
 include/uapi/asm-generic/unistd.h                  |   4 +-
 init/Kconfig                                       |   9 +
 kernel/Makefile                                    |   2 +-
 kernel/fork.c                                      |   1 +
 kernel/ptrace.c                                    |  15 +-
 kernel/restartable_sequences.c                     | 255 ++++++++++++++++
 kernel/sched/core.c                                |   5 +
 kernel/sched/sched.h                               |   3 +
 kernel/sys_ni.c                                    |   3 +
 tools/testing/selftests/rseq/Makefile              |  14 +
 .../testing/selftests/rseq/basic_percpu_ops_test.c | 331 +++++++++++++++++++++
 tools/testing/selftests/rseq/rseq.c                |  48 +++
 tools/testing/selftests/rseq/rseq.h                |  17 ++
 24 files changed, 862 insertions(+), 10 deletions(-)
 create mode 100644 arch/x86/include/asm/restartable_sequences.h
 create mode 100644 arch/x86/kernel/restartable_sequences.c
 create mode 100644 kernel/restartable_sequences.c
 create mode 100644 tools/testing/selftests/rseq/Makefile
 create mode 100644 tools/testing/selftests/rseq/basic_percpu_ops_test.c
 create mode 100644 tools/testing/selftests/rseq/rseq.c
 create mode 100644 tools/testing/selftests/rseq/rseq.h

-- 
2.4.6
