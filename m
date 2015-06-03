From: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [GIT PULL] Documentation/features: Add kernel feature descriptions
 and arch support status files under Documentation/features/
Date: Wed, 3 Jun 2015 13:03:55 +0200
Message-ID: <20150603110355.GA12079@gmail.com>
References: <20150513094756.GD11030@gmail.com>
 <20150513131835.GJ1517@pd.tnic>
 <20150513134842.GA1657@gmail.com>
 <20150513162757.GA21894@x>
 <20150513150523.ddd65d7cd51f820b78f0c8e3@linux-foundation.org>
 <20150514101518.GA27550@gmail.com>
 <20150514103544.GA7027@gmail.com>
 <20150522094931.78a43421@lwn.net>
 <20150523080704.GA25893@gmail.com>
 <20150524124447.0c395540@lwn.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20150524124447.0c395540-T1hC0tSOHrs@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-arch-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Peter Zijlstra <a.p.zijlstra-/NLkJaSkS4VmR6Xm/wNWPw@public.gmane.org>
List-Id: linux-api@vger.kernel.org


* Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org> wrote:

> On Sat, 23 May 2015 10:07:05 +0200
> Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
> 
> > > This seems to have slowed down a bit; I've taken the liberty of 
> > > pulling it into the docs tree. [...]  
> > 
> > Please don't, I've got a different structure for it, so that the Git 
> > log becomes a lot more usable. I'll post it after the weekend.
> 
> OK, fine, dropped.

Thanks!

A week late but I managed to complete it all and moved it into Git, for better 
structure and easy pulling.

Changes relative to the last submission:

  - Added higher level subsystem directories to collect features by 
    subsystem:

      triton:~/tip> ls Documentation/features/
      arch-support.txt  core  debug  io  lib  list-arch.sh  locking  perf  sched  seccomp  time  vm

    each subsystem directory contains the feature directories. For example locking 
    has:

      triton:~/tip> ls Documentation/features/locking/
      cmpxchg-local  lockdep  queued-rwlocks  queued-spinlocks  rwsem-optimized

    It's all pretty straightforward to navigate. Advantages are better 
    visualization, plus git log is able to list changes per subsystem.

  - Prettified the visualization some more.

  - Improved/corrected the support matrices based on feedback to earlier submissions.

  - Updated the support matrices to today's linux-next, so that by the time this
    shows up in upstream in the next merge window it's really recent. 
    Most notably there's a new architecture in linux-next (h8300).

This structure should address all feedback that I got and should minimize the 
maintenance overhead (chance of conflicts).

Please pull it all from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git core/documentation

   # HEAD: ce2073b138515f2da6bebf62277c8d069d1c9589 Documentation/features: Explain kernel feature descriptions and add visualization script

The -tip commits should appear soon as well, if anyone would like to take a look 
at the individual patches.

There's also a combo patch attached to this mail.

Thanks!

	Ingo

------------------>
Ingo Molnar (44):
      Documentation/features/vm: Add feature description and arch support status file for 'numa-memblock'
      Documentation/features/vm: Add feature description and arch support status file for 'PG_uncached'
      Documentation/features/lib: Add feature description and arch support status file for 'strncasecmp'
      Documentation/features/io: Add feature description and arch support status file for 'sg-chain'
      Documentation/features/vm: Add feature description and arch support status file for 'huge-vmap'
      Documentation/features/vm: Add feature description and arch support status file for 'pte_special'
      Documentation/features/vm: Add feature description and arch support status file for 'pmdp_splitting_flush'
      Documentation/features/debug: Add feature description and arch support status file for 'KASAN'
      Documentation/features/time: Add feature description and arch support status file for 'modern-timekeeping'
      Documentation/features/time: Add feature description and arch support status file for 'virt-cpuacct'
      Documentation/features/time: Add feature description and arch support status file for 'irq-time-acct'
      Documentation/features/vm: Add feature description and arch support status file for 'THP'
      Documentation/features/locking: Add feature description and arch support status file for 'rwsem-optimized'
      Documentation/features/sched: Add feature description and arch support status file for 'numa-balancing'
      Documentation/features/io: Add feature description and arch support status file for 'dma-contiguous'
      Documentation/features/io: Add feature description and arch support status file for 'dma_map_attrs'
      Documentation/features/core: Add feature description and arch support status file for 'tracehook'
      Documentation/features/vm: Add feature description and arch support status file for 'ioremap_prot'
      Documentation/features/locking: Add feature description and arch support status file for 'lockdep'
      Documentation/features/debug: Add feature description and arch support status file for 'stackprotector'
      Documentation/features/core: Add feature description and arch support status file for 'jump-labels'
      Documentation/features/seccomp: Add feature description and arch support status file for 'seccomp-filter'
      Documentation/features/time: Add feature description and arch support status file for 'context-tracking'
      Documentation/features/debug: Add feature description and arch support status file for 'kgdb'
      Documentation/features/time: Add feature description and arch support status file for 'clockevents'
      Documentation/features/vm: Add feature description and arch support status file for 'ELF-ASLR'
      Documentation/features/time: Add feature description and arch support status file for 'arch-tick-broadcast'
      Documentation/features/debug: Add feature description and arch support status file for 'kprobes'
      Documentation/features/debug: Add feature description and arch support status file for 'optprobes'
      Documentation/features/debug: Add feature description and arch support status file for 'kprobes-on-ftrace'
      Documentation/features/debug: Add feature description and arch support status file for 'uprobes'
      Documentation/features/debug: Add feature description and arch support status file for 'kretprobes'
      Documentation/features/debug: Add feature description and arch support status file for 'user-ret-profiler'
      Documentation/features/core: Add feature description and arch support status file for 'generic-idle-thread'
      Documentation/features/perf: Add feature description and arch support status file for 'kprobes-event'
      Documentation/features/io: Add feature description and arch support status file for 'dma-api-debug'
      Documentation/features/perf: Add feature description and arch support status file for 'perf-regs'
      Documentation/features/perf: Add feature description and arch support status file for 'perf-stackdump'
      Documentation/features/locking: Add feature description and arch support status file for 'cmpxchg-local'
      Documentation/features/debug: Add feature description and arch support status file for 'gcov-profile-all'
      Documentation/features/locking: Add feature description and arch support status file for 'queued-spinlocks'
      Documentation/features/locking: Add feature description and arch support status file for 'queued-rwlocks'
      Documentation/features/core: Add feature description and arch support status file for 'BPF-JIT'
      Documentation/features: Explain kernel feature descriptions and add visualization script


 Documentation/features/arch-support.txt            | 11 ++++++
 .../features/core/BPF-JIT/arch-support.txt         | 40 ++++++++++++++++++++++
 .../core/generic-idle-thread/arch-support.txt      | 40 ++++++++++++++++++++++
 .../features/core/jump-labels/arch-support.txt     | 40 ++++++++++++++++++++++
 .../features/core/tracehook/arch-support.txt       | 40 ++++++++++++++++++++++
 .../features/debug/KASAN/arch-support.txt          | 40 ++++++++++++++++++++++
 .../debug/gcov-profile-all/arch-support.txt        | 40 ++++++++++++++++++++++
 Documentation/features/debug/kgdb/arch-support.txt | 40 ++++++++++++++++++++++
 .../debug/kprobes-on-ftrace/arch-support.txt       | 40 ++++++++++++++++++++++
 .../features/debug/kprobes/arch-support.txt        | 40 ++++++++++++++++++++++
 .../features/debug/kretprobes/arch-support.txt     | 40 ++++++++++++++++++++++
 .../features/debug/optprobes/arch-support.txt      | 40 ++++++++++++++++++++++
 .../features/debug/stackprotector/arch-support.txt | 40 ++++++++++++++++++++++
 .../features/debug/uprobes/arch-support.txt        | 40 ++++++++++++++++++++++
 .../debug/user-ret-profiler/arch-support.txt       | 40 ++++++++++++++++++++++
 .../features/io/dma-api-debug/arch-support.txt     | 40 ++++++++++++++++++++++
 .../features/io/dma-contiguous/arch-support.txt    | 40 ++++++++++++++++++++++
 .../features/io/dma_map_attrs/arch-support.txt     | 40 ++++++++++++++++++++++
 .../features/io/sg-chain/arch-support.txt          | 40 ++++++++++++++++++++++
 .../features/lib/strncasecmp/arch-support.txt      | 40 ++++++++++++++++++++++
 Documentation/features/list-arch.sh                | 24 +++++++++++++
 .../locking/cmpxchg-local/arch-support.txt         | 40 ++++++++++++++++++++++
 .../features/locking/lockdep/arch-support.txt      | 40 ++++++++++++++++++++++
 .../locking/queued-rwlocks/arch-support.txt        | 40 ++++++++++++++++++++++
 .../locking/queued-spinlocks/arch-support.txt      | 40 ++++++++++++++++++++++
 .../locking/rwsem-optimized/arch-support.txt       | 40 ++++++++++++++++++++++
 .../features/perf/kprobes-event/arch-support.txt   | 40 ++++++++++++++++++++++
 .../features/perf/perf-regs/arch-support.txt       | 40 ++++++++++++++++++++++
 .../features/perf/perf-stackdump/arch-support.txt  | 40 ++++++++++++++++++++++
 .../features/sched/numa-balancing/arch-support.txt | 40 ++++++++++++++++++++++
 .../seccomp/seccomp-filter/arch-support.txt        | 40 ++++++++++++++++++++++
 .../time/arch-tick-broadcast/arch-support.txt      | 40 ++++++++++++++++++++++
 .../features/time/clockevents/arch-support.txt     | 40 ++++++++++++++++++++++
 .../time/context-tracking/arch-support.txt         | 40 ++++++++++++++++++++++
 .../features/time/irq-time-acct/arch-support.txt   | 40 ++++++++++++++++++++++
 .../time/modern-timekeeping/arch-support.txt       | 40 ++++++++++++++++++++++
 .../features/time/virt-cpuacct/arch-support.txt    | 40 ++++++++++++++++++++++
 .../features/vm/ELF-ASLR/arch-support.txt          | 40 ++++++++++++++++++++++
 .../features/vm/PG_uncached/arch-support.txt       | 40 ++++++++++++++++++++++
 Documentation/features/vm/THP/arch-support.txt     | 40 ++++++++++++++++++++++
 .../features/vm/huge-vmap/arch-support.txt         | 40 ++++++++++++++++++++++
 .../features/vm/ioremap_prot/arch-support.txt      | 40 ++++++++++++++++++++++
 .../features/vm/numa-memblock/arch-support.txt     | 40 ++++++++++++++++++++++
 .../vm/pmdp_splitting_flush/arch-support.txt       | 40 ++++++++++++++++++++++
 .../features/vm/pte_special/arch-support.txt       | 40 ++++++++++++++++++++++
 45 files changed, 1755 insertions(+)
 create mode 100644 Documentation/features/arch-support.txt
 create mode 100644 Documentation/features/core/BPF-JIT/arch-support.txt
 create mode 100644 Documentation/features/core/generic-idle-thread/arch-support.txt
 create mode 100644 Documentation/features/core/jump-labels/arch-support.txt
 create mode 100644 Documentation/features/core/tracehook/arch-support.txt
 create mode 100644 Documentation/features/debug/KASAN/arch-support.txt
 create mode 100644 Documentation/features/debug/gcov-profile-all/arch-support.txt
 create mode 100644 Documentation/features/debug/kgdb/arch-support.txt
 create mode 100644 Documentation/features/debug/kprobes-on-ftrace/arch-support.txt
 create mode 100644 Documentation/features/debug/kprobes/arch-support.txt
 create mode 100644 Documentation/features/debug/kretprobes/arch-support.txt
 create mode 100644 Documentation/features/debug/optprobes/arch-support.txt
 create mode 100644 Documentation/features/debug/stackprotector/arch-support.txt
 create mode 100644 Documentation/features/debug/uprobes/arch-support.txt
 create mode 100644 Documentation/features/debug/user-ret-profiler/arch-support.txt
 create mode 100644 Documentation/features/io/dma-api-debug/arch-support.txt
 create mode 100644 Documentation/features/io/dma-contiguous/arch-support.txt
 create mode 100644 Documentation/features/io/dma_map_attrs/arch-support.txt
 create mode 100644 Documentation/features/io/sg-chain/arch-support.txt
 create mode 100644 Documentation/features/lib/strncasecmp/arch-support.txt
 create mode 100644 Documentation/features/list-arch.sh
 create mode 100644 Documentation/features/locking/cmpxchg-local/arch-support.txt
 create mode 100644 Documentation/features/locking/lockdep/arch-support.txt
 create mode 100644 Documentation/features/locking/queued-rwlocks/arch-support.txt
 create mode 100644 Documentation/features/locking/queued-spinlocks/arch-support.txt
 create mode 100644 Documentation/features/locking/rwsem-optimized/arch-support.txt
 create mode 100644 Documentation/features/perf/kprobes-event/arch-support.txt
 create mode 100644 Documentation/features/perf/perf-regs/arch-support.txt
 create mode 100644 Documentation/features/perf/perf-stackdump/arch-support.txt
 create mode 100644 Documentation/features/sched/numa-balancing/arch-support.txt
 create mode 100644 Documentation/features/seccomp/seccomp-filter/arch-support.txt
 create mode 100644 Documentation/features/time/arch-tick-broadcast/arch-support.txt
 create mode 100644 Documentation/features/time/clockevents/arch-support.txt
 create mode 100644 Documentation/features/time/context-tracking/arch-support.txt
 create mode 100644 Documentation/features/time/irq-time-acct/arch-support.txt
 create mode 100644 Documentation/features/time/modern-timekeeping/arch-support.txt
 create mode 100644 Documentation/features/time/virt-cpuacct/arch-support.txt
 create mode 100644 Documentation/features/vm/ELF-ASLR/arch-support.txt
 create mode 100644 Documentation/features/vm/PG_uncached/arch-support.txt
 create mode 100644 Documentation/features/vm/THP/arch-support.txt
 create mode 100644 Documentation/features/vm/huge-vmap/arch-support.txt
 create mode 100644 Documentation/features/vm/ioremap_prot/arch-support.txt
 create mode 100644 Documentation/features/vm/numa-memblock/arch-support.txt
 create mode 100644 Documentation/features/vm/pmdp_splitting_flush/arch-support.txt
 create mode 100644 Documentation/features/vm/pte_special/arch-support.txt

diff --git a/Documentation/features/arch-support.txt b/Documentation/features/arch-support.txt
new file mode 100644
index 000000000000..d22a1095e661
--- /dev/null
+++ b/Documentation/features/arch-support.txt
@@ -0,0 +1,11 @@
+
+For generic kernel features that need architecture support, the
+arch-support.txt file in each feature directory shows the arch
+support matrix, for all upstream Linux architectures.
+
+The meaning of entries in the tables is:
+
+    | ok |  # feature supported by the architecture
+    |TODO|  # feature not yet supported by the architecture
+    | .. |  # feature cannot be supported by the hardware
+
diff --git a/Documentation/features/core/BPF-JIT/arch-support.txt b/Documentation/features/core/BPF-JIT/arch-support.txt
new file mode 100644
index 000000000000..c1b4f917238f
--- /dev/null
+++ b/Documentation/features/core/BPF-JIT/arch-support.txt
@@ -0,0 +1,40 @@
+#
+# Feature name:          BPF-JIT
+#         Kconfig:       HAVE_BPF_JIT
+#         description:   arch supports BPF JIT optimizations
+#
+    -----------------------
+    |         arch |status|
+    -----------------------
+    |       alpha: | TODO |
+    |         arc: | TODO |
+    |         arm: |  ok  |
+    |       arm64: |  ok  |
+    |       avr32: | TODO |
+    |    blackfin: | TODO |
+    |         c6x: | TODO |
+    |        cris: | TODO |
+    |         frv: | TODO |
+    |       h8300: | TODO |
+    |     hexagon: | TODO |
+    |        ia64: | TODO |
+    |        m32r: | TODO |
+    |        m68k: | TODO |
+    |       metag: | TODO |
+    |  microblaze: | TODO |
+    |        mips: |  ok  |
+    |     mn10300: | TODO |
+    |       nios2: | TODO |
+    |    openrisc: | TODO |
+    |      parisc: | TODO |
+    |     powerpc: |  ok  |
+    |        s390: |  ok  |
+    |       score: | TODO |
+    |          sh: | TODO |
+    |       sparc: |  ok  |
+    |        tile: | TODO |
+    |          um: | TODO |
+    |   unicore32: | TODO |
+    |         x86: |  ok  |
+    |      xtensa: | TODO |
+    -----------------------
diff --git a/Documentation/features/core/generic-idle-thread/arch-support.txt b/Documentation/features/core/generic-idle-thread/arch-support.txt
new file mode 100644
index 000000000000..6d930fcbe519
--- /dev/null
+++ b/Documentation/features/core/generic-idle-thread/arch-support.txt
@@ -0,0 +1,40 @@
+#
+# Feature name:          generic-idle-thread
+#         Kconfig:       GENERIC_SMP_IDLE_THREAD
+#         description:   arch makes use of the generic SMP idle thread facility
+#
+    -----------------------
+    |         arch |status|
+    -----------------------
+    |       alpha: |  ok  |
+    |         arc: |  ok  |
+    |         arm: |  ok  |
+    |       arm64: |  ok  |
+    |       avr32: | TODO |
+    |    blackfin: |  ok  |
+    |         c6x: | TODO |
+    |        cris: | TODO |
+    |         frv: | TODO |
+    |       h8300: | TODO |
+    |     hexagon: |  ok  |
+    |        ia64: |  ok  |
+    |        m32r: | TODO |
+    |        m68k: | TODO |
+    |       metag: |  ok  |
+    |  microblaze: | TODO |
+    |        mips: |  ok  |
+    |     mn10300: | TODO |
+    |       nios2: | TODO |
+    |    openrisc: | TODO |
+    |      parisc: |  ok  |
+    |     powerpc: |  ok  |
+    |        s390: |  ok  |
+    |       score: | TODO |
+    |          sh: |  ok  |
+    |       sparc: |  ok  |
+    |        tile: | TODO |
+    |          um: | TODO |
+    |   unicore32: | TODO |
+    |         x86: |  ok  |
+    |      xtensa: |  ok  |
+    -----------------------
diff --git a/Documentation/features/core/jump-labels/arch-support.txt b/Documentation/features/core/jump-labels/arch-support.txt
new file mode 100644
index 000000000000..136868b636e6
--- /dev/null
+++ b/Documentation/features/core/jump-labels/arch-support.txt
@@ -0,0 +1,40 @@
+#
+# Feature name:          jump-labels
+#         Kconfig:       HAVE_ARCH_JUMP_LABEL
+#         description:   arch supports live patched, high efficiency branches
+#
+    -----------------------
+    |         arch |status|
+    -----------------------
+    |       alpha: | TODO |
+    |         arc: | TODO |
+    |         arm: |  ok  |
+    |       arm64: |  ok  |
+    |       avr32: | TODO |
+    |    blackfin: | TODO |
+    |         c6x: | TODO |
+    |        cris: | TODO |
+    |         frv: | TODO |
+    |       h8300: | TODO |
+    |     hexagon: | TODO |
+    |        ia64: | TODO |
+    |        m32r: | TODO |
+    |        m68k: | TODO |
+    |       metag: | TODO |
+    |  microblaze: | TODO |
+    |        mips: |  ok  |
+    |     mn10300: | TODO |
+    |       nios2: | TODO |
+    |    openrisc: | TODO |
+    |      parisc: | TODO |
+    |     powerpc: |  ok  |
+    |        s390: |  ok  |
+    |       score: | TODO |
+    |          sh: | TODO |
+    |       sparc: |  ok  |
+    |        tile: | TODO |
+    |          um: | TODO |
+    |   unicore32: | TODO |
+    |         x86: |  ok  |
+    |      xtensa: | TODO |
+    -----------------------
diff --git a/Documentation/features/core/tracehook/arch-support.txt b/Documentation/features/core/tracehook/arch-support.txt
new file mode 100644
index 000000000000..728061d763b1
--- /dev/null
+++ b/Documentation/features/core/tracehook/arch-support.txt
@@ -0,0 +1,40 @@
+#
+# Feature name:          tracehook
+#         Kconfig:       HAVE_ARCH_TRACEHOOK
+#         description:   arch supports tracehook (ptrace) register handling APIs
+#
+    -----------------------
+    |         arch |status|
+    -----------------------
+    |       alpha: | TODO |
+    |         arc: |  ok  |
+    |         arm: |  ok  |
+    |       arm64: |  ok  |
+    |       avr32: | TODO |
+    |    blackfin: |  ok  |
+    |         c6x: |  ok  |
+    |        cris: | TODO |
+    |         frv: |  ok  |
+    |       h8300: | TODO |
+    |     hexagon: |  ok  |
+    |        ia64: |  ok  |
+    |        m32r: | TODO |
+    |        m68k: | TODO |
+    |       metag: |  ok  |
+    |  microblaze: | TODO |
+    |        mips: |  ok  |
+    |     mn10300: |  ok  |
+    |       nios2: |  ok  |
+    |    openrisc: |  ok  |
+    |      parisc: | TODO |
+    |     powerpc: |  ok  |
+    |        s390: |  ok  |
+    |       score: | TODO |
+    |          sh: |  ok  |
+    |       sparc: |  ok  |
+    |        tile: |  ok  |
+    |          um: | TODO |
+    |   unicore32: | TODO |
+    |         x86: |  ok  |
+    |      xtensa: | TODO |
+    -----------------------
diff --git a/Documentation/features/debug/KASAN/arch-support.txt b/Documentation/features/debug/KASAN/arch-support.txt
new file mode 100644
index 000000000000..14531da2fb54
--- /dev/null
+++ b/Documentation/features/debug/KASAN/arch-support.txt
@@ -0,0 +1,40 @@
+#
+# Feature name:          KASAN
+#         Kconfig:       HAVE_ARCH_KASAN
+#         description:   arch supports the KASAN runtime memory checker
+#
+    -----------------------
+    |         arch |status|
+    -----------------------
+    |       alpha: | TODO |
+    |         arc: | TODO |
+    |         arm: | TODO |
+    |       arm64: | TODO |
+    |       avr32: | TODO |
+    |    blackfin: | TODO |
+    |         c6x: | TODO |
+    |        cris: | TODO |
+    |         frv: | TODO |
+    |       h8300: | TODO |
+    |     hexagon: | TODO |
+    |        ia64: | TODO |
+    |        m32r: | TODO |
+    |        m68k: | TODO |
+    |       metag: | TODO |
+    |  microblaze: | TODO |
+    |        mips: | TODO |
+    |     mn10300: | TODO |
+    |       nios2: | TODO |
+    |    openrisc: | TODO |
+    |      parisc: | TODO |
+    |     powerpc: | TODO |
+    |        s390: | TODO |
+    |       score: | TODO |
+    |          sh: | TODO |
+    |       sparc: | TODO |
+    |        tile: | TODO |
+    |          um: | TODO |
+    |   unicore32: | TODO |
+    |         x86: |  ok  |
+    |      xtensa: | TODO |
+    -----------------------
diff --git a/Documentation/features/debug/gcov-profile-all/arch-support.txt b/Documentation/features/debug/gcov-profile-all/arch-support.txt
new file mode 100644
index 000000000000..38dea8eeba0a
--- /dev/null
+++ b/Documentation/features/debug/gcov-profile-all/arch-support.txt
@@ -0,0 +1,40 @@
+#
+# Feature name:          gcov-profile-all
+#         Kconfig:       ARCH_HAS_GCOV_PROFILE_ALL
+#         description:   arch supports whole-kernel GCOV code coverage profiling
+#
+    -----------------------
+    |         arch |status|
+    -----------------------
+    |       alpha: | TODO |
+    |         arc: | TODO |
+    |         arm: |  ok  |
+    |       arm64: |  ok  |
+    |       avr32: | TODO |
+    |    blackfin: | TODO |
+    |         c6x: | TODO |
+    |        cris: | TODO |
+    |         frv: | TODO |
+    |       h8300: | TODO |
+    |     hexagon: | TODO |
+    |        ia64: | TODO |
+    |        m32r: | TODO |
+    |        m68k: | TODO |
+    |       metag: | TODO |
+    |  microblaze: |  ok  |
+    |        mips: | TODO |
+    |     mn10300: | TODO |
+    |       nios2: | TODO |
+    |    openrisc: | TODO |
+    |      parisc: | TODO |
+    |     powerpc: |  ok  |
+    |        s390: |  ok  |
+    |       score: | TODO |
+    |          sh: |  ok  |
+    |       sparc: | TODO |
+    |        tile: | TODO |
+    |          um: | TODO |
+    |   unicore32: | TODO |
+    |         x86: |  ok  |
+    |      xtensa: | TODO |
+    -----------------------
diff --git a/Documentation/features/debug/kgdb/arch-support.txt b/Documentation/features/debug/kgdb/arch-support.txt
new file mode 100644
index 000000000000..862e15d6f79e
--- /dev/null
+++ b/Documentation/features/debug/kgdb/arch-support.txt
@@ -0,0 +1,40 @@
+#
+# Feature name:          kgdb
+#         Kconfig:       HAVE_ARCH_KGDB
+#         description:   arch supports the kGDB kernel debugger
+#
+    -----------------------
+    |         arch |status|
+    -----------------------
+    |       alpha: | TODO |
+    |         arc: |  ok  |
+    |         arm: |  ok  |
+    |       arm64: |  ok  |
+    |       avr32: | TODO |
+    |    blackfin: |  ok  |
+    |         c6x: | TODO |
+    |        cris: | TODO |
+    |         frv: | TODO |
+    |       h8300: | TODO |
+    |     hexagon: |  ok  |
+    |        ia64: | TODO |
+    |        m32r: | TODO |
+    |        m68k: | TODO |
+    |       metag: | TODO |
+    |  microblaze: |  ok  |
+    |        mips: |  ok  |
+    |     mn10300: |  ok  |
+    |       nios2: |  ok  |
+    |    openrisc: | TODO |
+    |      parisc: | TODO |
+    |     powerpc: |  ok  |
+    |        s390: | TODO |
+    |       score: | TODO |
+    |          sh: |  ok  |
+    |       sparc: |  ok  |
+    |        tile: |  ok  |
+    |          um: | TODO |
+    |   unicore32: | TODO |
+    |         x86: |  ok  |
+    |      xtensa: | TODO |
+    -----------------------
diff --git a/Documentation/features/debug/kprobes-on-ftrace/arch-support.txt b/Documentation/features/debug/kprobes-on-ftrace/arch-support.txt
new file mode 100644
index 000000000000..40f44d041fb4
--- /dev/null
+++ b/Documentation/features/debug/kprobes-on-ftrace/arch-support.txt
@@ -0,0 +1,40 @@
+#
+# Feature name:          kprobes-on-ftrace
+#         Kconfig:       HAVE_KPROBES_ON_FTRACE
+#         description:   arch supports combined kprobes and ftrace live patching
+#
+    -----------------------
+    |         arch |status|
+    -----------------------
+    |       alpha: | TODO |
+    |         arc: | TODO |
+    |         arm: | TODO |
+    |       arm64: | TODO |
+    |       avr32: | TODO |
+    |    blackfin: | TODO |
+    |         c6x: | TODO |
+    |        cris: | TODO |
+    |         frv: | TODO |
+    |       h8300: | TODO |
+    |     hexagon: | TODO |
+    |        ia64: | TODO |
+    |        m32r: | TODO |
+    |        m68k: | TODO |
+    |       metag: | TODO |
+    |  microblaze: | TODO |
+    |        mips: | TODO |
+    |     mn10300: | TODO |
+    |       nios2: | TODO |
+    |    openrisc: | TODO |
+    |      parisc: | TODO |
+    |     powerpc: | TODO |
+    |        s390: | TODO |
+    |       score: | TODO |
+    |          sh: | TODO |
+    |       sparc: | TODO |
+    |        tile: | TODO |
+    |          um: | TODO |
+    |   unicore32: | TODO |
+    |         x86: |  ok  |
+    |      xtensa: | TODO |
+    -----------------------
diff --git a/Documentation/features/debug/kprobes/arch-support.txt b/Documentation/features/debug/kprobes/arch-support.txt
new file mode 100644
index 000000000000..a44bfff6940b
--- /dev/null
+++ b/Documentation/features/debug/kprobes/arch-support.txt
@@ -0,0 +1,40 @@
+#
+# Feature name:          kprobes
+#         Kconfig:       HAVE_KPROBES
+#         description:   arch supports live patched kernel probe
+#
+    -----------------------
+    |         arch |status|
+    -----------------------
+    |       alpha: | TODO |
+    |         arc: |  ok  |
+    |         arm: |  ok  |
+    |       arm64: | TODO |
+    |       avr32: |  ok  |
+    |    blackfin: | TODO |
+    |         c6x: | TODO |
+    |        cris: | TODO |
+    |         frv: | TODO |
+    |       h8300: | TODO |
+    |     hexagon: | TODO |
+    |        ia64: |  ok  |
+    |        m32r: | TODO |
+    |        m68k: | TODO |
+    |       metag: | TODO |
+    |  microblaze: | TODO |
+    |        mips: |  ok  |
+    |     mn10300: | TODO |
+    |       nios2: | TODO |
+    |    openrisc: | TODO |
+    |      parisc: | TODO |
+    |     powerpc: |  ok  |
+    |        s390: |  ok  |
+    |       score: | TODO |
+    |          sh: |  ok  |
+    |       sparc: |  ok  |
+    |        tile: |  ok  |
+    |          um: | TODO |
+    |   unicore32: | TODO |
+    |         x86: |  ok  |
+    |      xtensa: | TODO |
+    -----------------------
diff --git a/Documentation/features/debug/kretprobes/arch-support.txt b/Documentation/features/debug/kretprobes/arch-support.txt
new file mode 100644
index 000000000000..d87c1ce24204
--- /dev/null
+++ b/Documentation/features/debug/kretprobes/arch-support.txt
@@ -0,0 +1,40 @@
+#
+# Feature name:          kretprobes
+#         Kconfig:       HAVE_KRETPROBES
+#         description:   arch supports kernel function-return probes
+#
+    -----------------------
+    |         arch |status|
+    -----------------------
+    |       alpha: | TODO |
+    |         arc: |  ok  |
+    |         arm: |  ok  |
+    |       arm64: | TODO |
+    |       avr32: | TODO |
+    |    blackfin: | TODO |
+    |         c6x: | TODO |
+    |        cris: | TODO |
+    |         frv: | TODO |
+    |       h8300: | TODO |
+    |     hexagon: | TODO |
+    |        ia64: |  ok  |
+    |        m32r: | TODO |
+    |        m68k: | TODO |
+    |       metag: | TODO |
+    |  microblaze: | TODO |
+    |        mips: |  ok  |
+    |     mn10300: | TODO |
+    |       nios2: | TODO |
+    |    openrisc: | TODO |
+    |      parisc: | TODO |
+    |     powerpc: |  ok  |
+    |        s390: |  ok  |
+    |       score: | TODO |
+    |          sh: |  ok  |
+    |       sparc: |  ok  |
+    |        tile: |  ok  |
+    |          um: | TODO |
+    |   unicore32: | TODO |
+    |         x86: |  ok  |
+    |      xtensa: | TODO |
+    -----------------------
diff --git a/Documentation/features/debug/optprobes/arch-support.txt b/Documentation/features/debug/optprobes/arch-support.txt
new file mode 100644
index 000000000000..b8999d8544ca
--- /dev/null
+++ b/Documentation/features/debug/optprobes/arch-support.txt
@@ -0,0 +1,40 @@
+#
+# Feature name:          optprobes
+#         Kconfig:       HAVE_OPTPROBES
+#         description:   arch supports live patched optprobes
+#
+    -----------------------
+    |         arch |status|
+    -----------------------
+    |       alpha: | TODO |
+    |         arc: | TODO |
+    |         arm: |  ok  |
+    |       arm64: | TODO |
+    |       avr32: | TODO |
+    |    blackfin: | TODO |
+    |         c6x: | TODO |
+    |        cris: | TODO |
+    |         frv: | TODO |
+    |       h8300: | TODO |
+    |     hexagon: | TODO |
+    |        ia64: | TODO |
+    |        m32r: | TODO |
+    |        m68k: | TODO |
+    |       metag: | TODO |
+    |  microblaze: | TODO |
+    |        mips: | TODO |
+    |     mn10300: | TODO |
+    |       nios2: | TODO |
+    |    openrisc: | TODO |
+    |      parisc: | TODO |
+    |     powerpc: | TODO |
+    |        s390: | TODO |
+    |       score: | TODO |
+    |          sh: | TODO |
+    |       sparc: | TODO |
+    |        tile: |  ok  |
+    |          um: | TODO |
+    |   unicore32: | TODO |
+    |         x86: |  ok  |
+    |      xtensa: | TODO |
+    -----------------------
diff --git a/Documentation/features/debug/stackprotector/arch-support.txt b/Documentation/features/debug/stackprotector/arch-support.txt
new file mode 100644
index 000000000000..0fa423313409
--- /dev/null
+++ b/Documentation/features/debug/stackprotector/arch-support.txt
@@ -0,0 +1,40 @@
+#
+# Feature name:          stackprotector
+#         Kconfig:       HAVE_CC_STACKPROTECTOR
+#         description:   arch supports compiler driven stack overflow protection
+#
+    -----------------------
+    |         arch |status|
+    -----------------------
+    |       alpha: | TODO |
+    |         arc: | TODO |
+    |         arm: |  ok  |
+    |       arm64: |  ok  |
+    |       avr32: | TODO |
+    |    blackfin: | TODO |
+    |         c6x: | TODO |
+    |        cris: | TODO |
+    |         frv: | TODO |
+    |       h8300: | TODO |
+    |     hexagon: | TODO |
+    |        ia64: | TODO |
+    |        m32r: | TODO |
+    |        m68k: | TODO |
+    |       metag: | TODO |
+    |  microblaze: | TODO |
+    |        mips: |  ok  |
+    |     mn10300: | TODO |
+    |       nios2: | TODO |
+    |    openrisc: | TODO |
+    |      parisc: | TODO |
+    |     powerpc: | TODO |
+    |        s390: | TODO |
+    |       score: | TODO |
+    |          sh: |  ok  |
+    |       sparc: | TODO |
+    |        tile: | TODO |
+    |          um: | TODO |
+    |   unicore32: | TODO |
+    |         x86: |  ok  |
+    |      xtensa: | TODO |
+    -----------------------
diff --git a/Documentation/features/debug/uprobes/arch-support.txt b/Documentation/features/debug/uprobes/arch-support.txt
new file mode 100644
index 000000000000..4efe36c3ace9
--- /dev/null
+++ b/Documentation/features/debug/uprobes/arch-support.txt
@@ -0,0 +1,40 @@
+#
+# Feature name:          uprobes
+#         Kconfig:       ARCH_SUPPORTS_UPROBES
+#         description:   arch supports live patched user probes
+#
+    -----------------------
+    |         arch |status|
+    -----------------------
+    |       alpha: | TODO |
+    |         arc: | TODO |
+    |         arm: |  ok  |
+    |       arm64: | TODO |
+    |       avr32: | TODO |
+    |    blackfin: | TODO |
+    |         c6x: | TODO |
+    |        cris: | TODO |
+    |         frv: | TODO |
+    |       h8300: | TODO |
+    |     hexagon: | TODO |
+    |        ia64: | TODO |
+    |        m32r: | TODO |
+    |        m68k: | TODO |
+    |       metag: | TODO |
+    |  microblaze: | TODO |
+    |        mips: | TODO |
+    |     mn10300: | TODO |
+    |       nios2: | TODO |
+    |    openrisc: | TODO |
+    |      parisc: | TODO |
+    |     powerpc: |  ok  |
+    |        s390: |  ok  |
+    |       score: | TODO |
+    |          sh: | TODO |
+    |       sparc: | TODO |
+    |        tile: | TODO |
+    |          um: | TODO |
+    |   unicore32: | TODO |
+    |         x86: |  ok  |
+    |      xtensa: | TODO |
+    -----------------------
diff --git a/Documentation/features/debug/user-ret-profiler/arch-support.txt b/Documentation/features/debug/user-ret-profiler/arch-support.txt
new file mode 100644
index 000000000000..44cc1ff3f603
--- /dev/null
+++ b/Documentation/features/debug/user-ret-profiler/arch-support.txt
@@ -0,0 +1,40 @@
+#
+# Feature name:          user-ret-profiler
+#         Kconfig:       HAVE_USER_RETURN_NOTIFIER
+#         description:   arch supports user-space return from system call profiler
+#
+    -----------------------
+    |         arch |status|
+    -----------------------
+    |       alpha: | TODO |
+    |         arc: | TODO |
+    |         arm: | TODO |
+    |       arm64: | TODO |
+    |       avr32: | TODO |
+    |    blackfin: | TODO |
+    |         c6x: | TODO |
+    |        cris: | TODO |
+    |         frv: | TODO |
+    |       h8300: | TODO |
+    |     hexagon: | TODO |
+    |        ia64: | TODO |
+    |        m32r: | TODO |
+    |        m68k: | TODO |
+    |       metag: | TODO |
+    |  microblaze: | TODO |
+    |        mips: | TODO |
+    |     mn10300: | TODO |
+    |       nios2: | TODO |
+    |    openrisc: | TODO |
+    |      parisc: | TODO |
+    |     powerpc: | TODO |
+    |        s390: | TODO |
+    |       score: | TODO |
+    |          sh: | TODO |
+    |       sparc: | TODO |
+    |        tile: |  ok  |
+    |          um: | TODO |
+    |   unicore32: | TODO |
+    |         x86: |  ok  |
+    |      xtensa: | TODO |
+    -----------------------
diff --git a/Documentation/features/io/dma-api-debug/arch-support.txt b/Documentation/features/io/dma-api-debug/arch-support.txt
new file mode 100644
index 000000000000..4f4a3443b114
--- /dev/null
+++ b/Documentation/features/io/dma-api-debug/arch-support.txt
@@ -0,0 +1,40 @@
+#
+# Feature name:          dma-api-debug
+#         Kconfig:       HAVE_DMA_API_DEBUG
+#         description:   arch supports DMA debug facilities
+#
+    -----------------------
+    |         arch |status|
+    -----------------------
+    |       alpha: | TODO |
+    |         arc: | TODO |
+    |         arm: |  ok  |
+    |       arm64: |  ok  |
+    |       avr32: | TODO |
+    |    blackfin: | TODO |
+    |         c6x: |  ok  |
+    |        cris: | TODO |
+    |         frv: | TODO |
+    |       h8300: | TODO |
+    |     hexagon: | TODO |
+    |        ia64: |  ok  |
+    |        m32r: | TODO |
+    |        m68k: | TODO |
+    |       metag: | TODO |
+    |  microblaze: |  ok  |
+    |        mips: |  ok  |
+    |     mn10300: | TODO |
+    |       nios2: | TODO |
+    |    openrisc: | TODO |
+    |      parisc: | TODO |
+    |     powerpc: |  ok  |
+    |        s390: |  ok  |
+    |       score: | TODO |
+    |          sh: |  ok  |
+    |       sparc: |  ok  |
+    |        tile: |  ok  |
+    |          um: | TODO |
+    |   unicore32: | TODO |
+    |         x86: |  ok  |
+    |      xtensa: | TODO |
+    -----------------------
diff --git a/Documentation/features/io/dma-contiguous/arch-support.txt b/Documentation/features/io/dma-contiguous/arch-support.txt
new file mode 100644
index 000000000000..a97e8e3f4ebb
--- /dev/null
+++ b/Documentation/features/io/dma-contiguous/arch-support.txt
@@ -0,0 +1,40 @@
+#
+# Feature name:          dma-contiguous
+#         Kconfig:       HAVE_DMA_CONTIGUOUS
+#         description:   arch supports the DMA CMA (continuous memory allocator)
+#
+    -----------------------
+    |         arch |status|
+    -----------------------
+    |       alpha: | TODO |
+    |         arc: | TODO |
+    |         arm: |  ok  |
+    |       arm64: |  ok  |
+    |       avr32: | TODO |
+    |    blackfin: | TODO |
+    |         c6x: | TODO |
+    |        cris: | TODO |
+    |         frv: | TODO |
+    |       h8300: | TODO |
+    |     hexagon: | TODO |
+    |        ia64: | TODO |
+    |        m32r: | TODO |
+    |        m68k: | TODO |
+    |       metag: | TODO |
+    |  microblaze: | TODO |
+    |        mips: |  ok  |
+    |     mn10300: | TODO |
+    |       nios2: | TODO |
+    |    openrisc: | TODO |
+    |      parisc: | TODO |
+    |     powerpc: | TODO |
+    |        s390: | TODO |
+    |       score: | TODO |
+    |          sh: | TODO |
+    |       sparc: | TODO |
+    |        tile: | TODO |
+    |          um: | TODO |
+    |   unicore32: | TODO |
+    |         x86: |  ok  |
+    |      xtensa: | TODO |
+    -----------------------
diff --git a/Documentation/features/io/dma_map_attrs/arch-support.txt b/Documentation/features/io/dma_map_attrs/arch-support.txt
new file mode 100644
index 000000000000..51d0f1c02a3e
--- /dev/null
+++ b/Documentation/features/io/dma_map_attrs/arch-support.txt
@@ -0,0 +1,40 @@
+#
+# Feature name:          dma_map_attrs
+#         Kconfig:       HAVE_DMA_ATTRS
+#         description:   arch provides dma_*map*_attrs() APIs
+#
+    -----------------------
+    |         arch |status|
+    -----------------------
+    |       alpha: |  ok  |
+    |         arc: | TODO |
+    |         arm: |  ok  |
+    |       arm64: |  ok  |
+    |       avr32: | TODO |
+    |    blackfin: | TODO |
+    |         c6x: | TODO |
+    |        cris: | TODO |
+    |         frv: | TODO |
+    |       h8300: |  ok  |
+    |     hexagon: |  ok  |
+    |        ia64: |  ok  |
+    |        m32r: | TODO |
+    |        m68k: | TODO |
+    |       metag: | TODO |
+    |  microblaze: |  ok  |
+    |        mips: |  ok  |
+    |     mn10300: | TODO |
+    |       nios2: | TODO |
+    |    openrisc: |  ok  |
+    |      parisc: | TODO |
+    |     powerpc: |  ok  |
+    |        s390: |  ok  |
+    |       score: | TODO |
+    |          sh: |  ok  |
+    |       sparc: |  ok  |
+    |        tile: |  ok  |
+    |          um: | TODO |
+    |   unicore32: |  ok  |
+    |         x86: |  ok  |
+    |      xtensa: | TODO |
+    -----------------------
diff --git a/Documentation/features/io/sg-chain/arch-support.txt b/Documentation/features/io/sg-chain/arch-support.txt
new file mode 100644
index 000000000000..b9b675539b9d
--- /dev/null
+++ b/Documentation/features/io/sg-chain/arch-support.txt
@@ -0,0 +1,40 @@
+#
+# Feature name:          sg-chain
+#         Kconfig:       ARCH_HAS_SG_CHAIN
+#         description:   arch supports chained scatter-gather lists
+#
+    -----------------------
+    |         arch |status|
+    -----------------------
+    |       alpha: | TODO |
+    |         arc: | TODO |
+    |         arm: |  ok  |
+    |       arm64: |  ok  |
+    |       avr32: | TODO |
+    |    blackfin: | TODO |
+    |         c6x: | TODO |
+    |        cris: | TODO |
+    |         frv: | TODO |
+    |       h8300: | TODO |
+    |     hexagon: | TODO |
+    |        ia64: |  ok  |
+    |        m32r: | TODO |
+    |        m68k: | TODO |
+    |       metag: | TODO |
+    |  microblaze: | TODO |
+    |        mips: | TODO |
+    |     mn10300: | TODO |
+    |       nios2: | TODO |
+    |    openrisc: | TODO |
+    |      parisc: | TODO |
+    |     powerpc: |  ok  |
+    |        s390: |  ok  |
+    |       score: | TODO |
+    |          sh: | TODO |
+    |       sparc: |  ok  |
+    |        tile: | TODO |
+    |          um: | TODO |
+    |   unicore32: | TODO |
+    |         x86: |  ok  |
+    |      xtensa: | TODO |
+    -----------------------
diff --git a/Documentation/features/lib/strncasecmp/arch-support.txt b/Documentation/features/lib/strncasecmp/arch-support.txt
new file mode 100644
index 000000000000..12b1c9358e57
--- /dev/null
+++ b/Documentation/features/lib/strncasecmp/arch-support.txt
@@ -0,0 +1,40 @@
+#
+# Feature name:          strncasecmp
+#         Kconfig:       __HAVE_ARCH_STRNCASECMP
+#         description:   arch provides an optimized strncasecmp() function
+#
+    -----------------------
+    |         arch |status|
+    -----------------------
+    |       alpha: | TODO |
+    |         arc: | TODO |
+    |         arm: | TODO |
+    |       arm64: | TODO |
+    |       avr32: | TODO |
+    |    blackfin: | TODO |
+    |         c6x: | TODO |
+    |        cris: | TODO |
+    |         frv: | TODO |
+    |       h8300: | TODO |
+    |     hexagon: | TODO |
+    |        ia64: | TODO |
+    |        m32r: | TODO |
+    |        m68k: | TODO |
+    |       metag: | TODO |
+    |  microblaze: | TODO |
+    |        mips: | TODO |
+    |     mn10300: | TODO |
+    |       nios2: | TODO |
+    |    openrisc: | TODO |
+    |      parisc: | TODO |
+    |     powerpc: | TODO |
+    |        s390: | TODO |
+    |       score: | TODO |
+    |          sh: | TODO |
+    |       sparc: | TODO |
+    |        tile: | TODO |
+    |          um: | TODO |
+    |   unicore32: | TODO |
+    |         x86: | TODO |
+    |      xtensa: | TODO |
+    -----------------------
diff --git a/Documentation/features/list-arch.sh b/Documentation/features/list-arch.sh
new file mode 100644
index 000000000000..6065124a072f
--- /dev/null
+++ b/Documentation/features/list-arch.sh
@@ -0,0 +1,24 @@
+#
+# Small script that visualizes the kernel feature support status
+# of an architecture.
+#
+# (If no arguments are given then it will print the host architecture's status.)
+#
+
+ARCH=${1:-$(arch | sed 's/x86_64/x86/' | sed 's/i386/x86/')}
+
+cd $(dirname $0)
+echo "#"
+echo "# Kernel feature support matrix of the '$ARCH' architecture:"
+echo "#"
+
+for F in */*/arch-support.txt; do
+  SUBSYS=$(echo $F | cut -d/ -f1)
+  N=$(grep -h "^# Feature name:"        $F | cut -c25-)
+  C=$(grep -h "^#         Kconfig:"     $F | cut -c25-)
+  D=$(grep -h "^#         description:" $F | cut -c25-)
+  S=$(grep -hw $ARCH $F | cut -d\| -f3)
+
+  printf "%10s/%-22s:%s| %35s # %s\n" "$SUBSYS" "$N" "$S" "$C" "$D"
+done
+
diff --git a/Documentation/features/locking/cmpxchg-local/arch-support.txt b/Documentation/features/locking/cmpxchg-local/arch-support.txt
new file mode 100644
index 000000000000..d9c310889bc1
--- /dev/null
+++ b/Documentation/features/locking/cmpxchg-local/arch-support.txt
@@ -0,0 +1,40 @@
+#
+# Feature name:          cmpxchg-local
+#         Kconfig:       HAVE_CMPXCHG_LOCAL
+#         description:   arch supports the this_cpu_cmpxchg() API
+#
+    -----------------------
+    |         arch |status|
+    -----------------------
+    |       alpha: | TODO |
+    |         arc: | TODO |
+    |         arm: | TODO |
+    |       arm64: | TODO |
+    |       avr32: | TODO |
+    |    blackfin: | TODO |
+    |         c6x: | TODO |
+    |        cris: | TODO |
+    |         frv: | TODO |
+    |       h8300: | TODO |
+    |     hexagon: | TODO |
+    |        ia64: | TODO |
+    |        m32r: | TODO |
+    |        m68k: | TODO |
+    |       metag: | TODO |
+    |  microblaze: | TODO |
+    |        mips: | TODO |
+    |     mn10300: | TODO |
+    |       nios2: | TODO |
+    |    openrisc: | TODO |
+    |      parisc: | TODO |
+    |     powerpc: | TODO |
+    |        s390: |  ok  |
+    |       score: | TODO |
+    |          sh: | TODO |
+    |       sparc: | TODO |
+    |        tile: | TODO |
+    |          um: | TODO |
+    |   unicore32: | TODO |
+    |         x86: |  ok  |
+    |      xtensa: | TODO |
+    -----------------------
diff --git a/Documentation/features/locking/lockdep/arch-support.txt b/Documentation/features/locking/lockdep/arch-support.txt
new file mode 100644
index 000000000000..cf90635bdcbb
--- /dev/null
+++ b/Documentation/features/locking/lockdep/arch-support.txt
@@ -0,0 +1,40 @@
+#
+# Feature name:          lockdep
+#         Kconfig:       LOCKDEP_SUPPORT
+#         description:   arch supports the runtime locking correctness debug facility
+#
+    -----------------------
+    |         arch |status|
+    -----------------------
+    |       alpha: | TODO |
+    |         arc: |  ok  |
+    |         arm: |  ok  |
+    |       arm64: |  ok  |
+    |       avr32: |  ok  |
+    |    blackfin: |  ok  |
+    |         c6x: | TODO |
+    |        cris: | TODO |
+    |         frv: | TODO |
+    |       h8300: | TODO |
+    |     hexagon: |  ok  |
+    |        ia64: | TODO |
+    |        m32r: | TODO |
+    |        m68k: | TODO |
+    |       metag: |  ok  |
+    |  microblaze: |  ok  |
+    |        mips: |  ok  |
+    |     mn10300: | TODO |
+    |       nios2: | TODO |
+    |    openrisc: | TODO |
+    |      parisc: | TODO |
+    |     powerpc: |  ok  |
+    |        s390: |  ok  |
+    |       score: |  ok  |
+    |          sh: |  ok  |
+    |       sparc: |  ok  |
+    |        tile: |  ok  |
+    |          um: |  ok  |
+    |   unicore32: |  ok  |
+    |         x86: |  ok  |
+    |      xtensa: |  ok  |
+    -----------------------
diff --git a/Documentation/features/locking/queued-rwlocks/arch-support.txt b/Documentation/features/locking/queued-rwlocks/arch-support.txt
new file mode 100644
index 000000000000..68c3a5ddd9b9
--- /dev/null
+++ b/Documentation/features/locking/queued-rwlocks/arch-support.txt
@@ -0,0 +1,40 @@
+#
+# Feature name:          queued-rwlocks
+#         Kconfig:       ARCH_USE_QUEUED_RWLOCKS
+#         description:   arch supports queued rwlocks
+#
+    -----------------------
+    |         arch |status|
+    -----------------------
+    |       alpha: | TODO |
+    |         arc: | TODO |
+    |         arm: | TODO |
+    |       arm64: | TODO |
+    |       avr32: | TODO |
+    |    blackfin: | TODO |
+    |         c6x: | TODO |
+    |        cris: | TODO |
+    |         frv: | TODO |
+    |       h8300: | TODO |
+    |     hexagon: | TODO |
+    |        ia64: | TODO |
+    |        m32r: | TODO |
+    |        m68k: | TODO |
+    |       metag: | TODO |
+    |  microblaze: | TODO |
+    |        mips: | TODO |
+    |     mn10300: | TODO |
+    |       nios2: | TODO |
+    |    openrisc: | TODO |
+    |      parisc: | TODO |
+    |     powerpc: | TODO |
+    |        s390: | TODO |
+    |       score: | TODO |
+    |          sh: | TODO |
+    |       sparc: | TODO |
+    |        tile: | TODO |
+    |          um: | TODO |
+    |   unicore32: | TODO |
+    |         x86: |  ok  |
+    |      xtensa: | TODO |
+    -----------------------
diff --git a/Documentation/features/locking/queued-spinlocks/arch-support.txt b/Documentation/features/locking/queued-spinlocks/arch-support.txt
new file mode 100644
index 000000000000..e973b1a9572f
--- /dev/null
+++ b/Documentation/features/locking/queued-spinlocks/arch-support.txt
@@ -0,0 +1,40 @@
+#
+# Feature name:          queued-spinlocks
+#         Kconfig:       ARCH_USE_QUEUED_SPINLOCKS
+#         description:   arch supports queued spinlocks
+#
+    -----------------------
+    |         arch |status|
+    -----------------------
+    |       alpha: | TODO |
+    |         arc: | TODO |
+    |         arm: | TODO |
+    |       arm64: | TODO |
+    |       avr32: | TODO |
+    |    blackfin: | TODO |
+    |         c6x: | TODO |
+    |        cris: | TODO |
+    |         frv: | TODO |
+    |       h8300: | TODO |
+    |     hexagon: | TODO |
+    |        ia64: | TODO |
+    |        m32r: | TODO |
+    |        m68k: | TODO |
+    |       metag: | TODO |
+    |  microblaze: | TODO |
+    |        mips: | TODO |
+    |     mn10300: | TODO |
+    |       nios2: | TODO |
+    |    openrisc: | TODO |
+    |      parisc: | TODO |
+    |     powerpc: | TODO |
+    |        s390: | TODO |
+    |       score: | TODO |
+    |          sh: | TODO |
+    |       sparc: | TODO |
+    |        tile: | TODO |
+    |          um: | TODO |
+    |   unicore32: | TODO |
+    |         x86: |  ok  |
+    |      xtensa: | TODO |
+    -----------------------
diff --git a/Documentation/features/locking/rwsem-optimized/arch-support.txt b/Documentation/features/locking/rwsem-optimized/arch-support.txt
new file mode 100644
index 000000000000..ac93d7ab66c4
--- /dev/null
+++ b/Documentation/features/locking/rwsem-optimized/arch-support.txt
@@ -0,0 +1,40 @@
+#
+# Feature name:          rwsem-optimized
+#         Kconfig:       Optimized asm/rwsem.h
+#         description:   arch provides optimized rwsem APIs
+#
+    -----------------------
+    |         arch |status|
+    -----------------------
+    |       alpha: |  ok  |
+    |         arc: | TODO |
+    |         arm: | TODO |
+    |       arm64: | TODO |
+    |       avr32: | TODO |
+    |    blackfin: | TODO |
+    |         c6x: | TODO |
+    |        cris: | TODO |
+    |         frv: | TODO |
+    |       h8300: | TODO |
+    |     hexagon: | TODO |
+    |        ia64: |  ok  |
+    |        m32r: | TODO |
+    |        m68k: | TODO |
+    |       metag: | TODO |
+    |  microblaze: | TODO |
+    |        mips: | TODO |
+    |     mn10300: | TODO |
+    |       nios2: | TODO |
+    |    openrisc: | TODO |
+    |      parisc: | TODO |
+    |     powerpc: | TODO |
+    |        s390: |  ok  |
+    |       score: | TODO |
+    |          sh: |  ok  |
+    |       sparc: |  ok  |
+    |        tile: | TODO |
+    |          um: | TODO |
+    |   unicore32: | TODO |
+    |         x86: |  ok  |
+    |      xtensa: |  ok  |
+    -----------------------
diff --git a/Documentation/features/perf/kprobes-event/arch-support.txt b/Documentation/features/perf/kprobes-event/arch-support.txt
new file mode 100644
index 000000000000..9855ad044386
--- /dev/null
+++ b/Documentation/features/perf/kprobes-event/arch-support.txt
@@ -0,0 +1,40 @@
+#
+# Feature name:          kprobes-event
+#         Kconfig:       HAVE_REGS_AND_STACK_ACCESS_API
+#         description:   arch supports kprobes with perf events
+#
+    -----------------------
+    |         arch |status|
+    -----------------------
+    |       alpha: | TODO |
+    |         arc: | TODO |
+    |         arm: |  ok  |
+    |       arm64: | TODO |
+    |       avr32: | TODO |
+    |    blackfin: | TODO |
+    |         c6x: | TODO |
+    |        cris: | TODO |
+    |         frv: | TODO |
+    |       h8300: | TODO |
+    |     hexagon: |  ok  |
+    |        ia64: | TODO |
+    |        m32r: | TODO |
+    |        m68k: | TODO |
+    |       metag: | TODO |
+    |  microblaze: | TODO |
+    |        mips: | TODO |
+    |     mn10300: | TODO |
+    |       nios2: | TODO |
+    |    openrisc: | TODO |
+    |      parisc: | TODO |
+    |     powerpc: |  ok  |
+    |        s390: |  ok  |
+    |       score: | TODO |
+    |          sh: |  ok  |
+    |       sparc: | TODO |
+    |        tile: |  ok  |
+    |          um: | TODO |
+    |   unicore32: | TODO |
+    |         x86: |  ok  |
+    |      xtensa: | TODO |
+    -----------------------
diff --git a/Documentation/features/perf/perf-regs/arch-support.txt b/Documentation/features/perf/perf-regs/arch-support.txt
new file mode 100644
index 000000000000..e2b4a78ec543
--- /dev/null
+++ b/Documentation/features/perf/perf-regs/arch-support.txt
@@ -0,0 +1,40 @@
+#
+# Feature name:          perf-regs
+#         Kconfig:       HAVE_PERF_REGS
+#         description:   arch supports perf events register access
+#
+    -----------------------
+    |         arch |status|
+    -----------------------
+    |       alpha: | TODO |
+    |         arc: | TODO |
+    |         arm: |  ok  |
+    |       arm64: |  ok  |
+    |       avr32: | TODO |
+    |    blackfin: | TODO |
+    |         c6x: | TODO |
+    |        cris: | TODO |
+    |         frv: | TODO |
+    |       h8300: | TODO |
+    |     hexagon: | TODO |
+    |        ia64: | TODO |
+    |        m32r: | TODO |
+    |        m68k: | TODO |
+    |       metag: | TODO |
+    |  microblaze: | TODO |
+    |        mips: | TODO |
+    |     mn10300: | TODO |
+    |       nios2: | TODO |
+    |    openrisc: | TODO |
+    |      parisc: | TODO |
+    |     powerpc: | TODO |
+    |        s390: | TODO |
+    |       score: | TODO |
+    |          sh: | TODO |
+    |       sparc: | TODO |
+    |        tile: | TODO |
+    |          um: | TODO |
+    |   unicore32: | TODO |
+    |         x86: |  ok  |
+    |      xtensa: | TODO |
+    -----------------------
diff --git a/Documentation/features/perf/perf-stackdump/arch-support.txt b/Documentation/features/perf/perf-stackdump/arch-support.txt
new file mode 100644
index 000000000000..3dc24b0673c0
--- /dev/null
+++ b/Documentation/features/perf/perf-stackdump/arch-support.txt
@@ -0,0 +1,40 @@
+#
+# Feature name:          perf-stackdump
+#         Kconfig:       HAVE_PERF_USER_STACK_DUMP
+#         description:   arch supports perf events stack dumps
+#
+    -----------------------
+    |         arch |status|
+    -----------------------
+    |       alpha: | TODO |
+    |         arc: | TODO |
+    |         arm: |  ok  |
+    |       arm64: |  ok  |
+    |       avr32: | TODO |
+    |    blackfin: | TODO |
+    |         c6x: | TODO |
+    |        cris: | TODO |
+    |         frv: | TODO |
+    |       h8300: | TODO |
+    |     hexagon: | TODO |
+    |        ia64: | TODO |
+    |        m32r: | TODO |
+    |        m68k: | TODO |
+    |       metag: | TODO |
+    |  microblaze: | TODO |
+    |        mips: | TODO |
+    |     mn10300: | TODO |
+    |       nios2: | TODO |
+    |    openrisc: | TODO |
+    |      parisc: | TODO |
+    |     powerpc: | TODO |
+    |        s390: | TODO |
+    |       score: | TODO |
+    |          sh: | TODO |
+    |       sparc: | TODO |
+    |        tile: | TODO |
+    |          um: | TODO |
+    |   unicore32: | TODO |
+    |         x86: |  ok  |
+    |      xtensa: | TODO |
+    -----------------------
diff --git a/Documentation/features/sched/numa-balancing/arch-support.txt b/Documentation/features/sched/numa-balancing/arch-support.txt
new file mode 100644
index 000000000000..ac7cd6b1502b
--- /dev/null
+++ b/Documentation/features/sched/numa-balancing/arch-support.txt
@@ -0,0 +1,40 @@
+#
+# Feature name:          numa-balancing
+#         Kconfig:       ARCH_SUPPORTS_NUMA_BALANCING
+#         description:   arch supports NUMA balancing
+#
+    -----------------------
+    |         arch |status|
+    -----------------------
+    |       alpha: | TODO |
+    |         arc: |  ..  |
+    |         arm: |  ..  |
+    |       arm64: |  ..  |
+    |       avr32: |  ..  |
+    |    blackfin: |  ..  |
+    |         c6x: |  ..  |
+    |        cris: |  ..  |
+    |         frv: |  ..  |
+    |       h8300: |  ..  |
+    |     hexagon: |  ..  |
+    |        ia64: | TODO |
+    |        m32r: |  ..  |
+    |        m68k: |  ..  |
+    |       metag: |  ..  |
+    |  microblaze: |  ..  |
+    |        mips: | TODO |
+    |     mn10300: |  ..  |
+    |       nios2: |  ..  |
+    |    openrisc: |  ..  |
+    |      parisc: |  ..  |
+    |     powerpc: |  ok  |
+    |        s390: |  ..  |
+    |       score: |  ..  |
+    |          sh: |  ..  |
+    |       sparc: | TODO |
+    |        tile: | TODO |
+    |          um: |  ..  |
+    |   unicore32: |  ..  |
+    |         x86: |  ok  |
+    |      xtensa: |  ..  |
+    -----------------------
diff --git a/Documentation/features/seccomp/seccomp-filter/arch-support.txt b/Documentation/features/seccomp/seccomp-filter/arch-support.txt
new file mode 100644
index 000000000000..bea800910342
--- /dev/null
+++ b/Documentation/features/seccomp/seccomp-filter/arch-support.txt
@@ -0,0 +1,40 @@
+#
+# Feature name:          seccomp-filter
+#         Kconfig:       HAVE_ARCH_SECCOMP_FILTER
+#         description:   arch supports seccomp filters
+#
+    -----------------------
+    |         arch |status|
+    -----------------------
+    |       alpha: | TODO |
+    |         arc: | TODO |
+    |         arm: |  ok  |
+    |       arm64: |  ok  |
+    |       avr32: | TODO |
+    |    blackfin: | TODO |
+    |         c6x: | TODO |
+    |        cris: | TODO |
+    |         frv: | TODO |
+    |       h8300: | TODO |
+    |     hexagon: | TODO |
+    |        ia64: | TODO |
+    |        m32r: | TODO |
+    |        m68k: | TODO |
+    |       metag: | TODO |
+    |  microblaze: | TODO |
+    |        mips: |  ok  |
+    |     mn10300: | TODO |
+    |       nios2: | TODO |
+    |    openrisc: | TODO |
+    |      parisc: | TODO |
+    |     powerpc: | TODO |
+    |        s390: |  ok  |
+    |       score: | TODO |
+    |          sh: | TODO |
+    |       sparc: | TODO |
+    |        tile: | TODO |
+    |          um: | TODO |
+    |   unicore32: | TODO |
+    |         x86: |  ok  |
+    |      xtensa: | TODO |
+    -----------------------
diff --git a/Documentation/features/time/arch-tick-broadcast/arch-support.txt b/Documentation/features/time/arch-tick-broadcast/arch-support.txt
new file mode 100644
index 000000000000..8acb439a4a17
--- /dev/null
+++ b/Documentation/features/time/arch-tick-broadcast/arch-support.txt
@@ -0,0 +1,40 @@
+#
+# Feature name:          arch-tick-broadcast
+#         Kconfig:       ARCH_HAS_TICK_BROADCAST
+#         description:   arch provides tick_broadcast()
+#
+    -----------------------
+    |         arch |status|
+    -----------------------
+    |       alpha: | TODO |
+    |         arc: | TODO |
+    |         arm: |  ok  |
+    |       arm64: |  ok  |
+    |       avr32: | TODO |
+    |    blackfin: | TODO |
+    |         c6x: | TODO |
+    |        cris: | TODO |
+    |         frv: | TODO |
+    |       h8300: | TODO |
+    |     hexagon: | TODO |
+    |        ia64: | TODO |
+    |        m32r: | TODO |
+    |        m68k: | TODO |
+    |       metag: | TODO |
+    |  microblaze: | TODO |
+    |        mips: |  ok  |
+    |     mn10300: | TODO |
+    |       nios2: | TODO |
+    |    openrisc: | TODO |
+    |      parisc: | TODO |
+    |     powerpc: |  ok  |
+    |        s390: | TODO |
+    |       score: | TODO |
+    |          sh: | TODO |
+    |       sparc: | TODO |
+    |        tile: | TODO |
+    |          um: | TODO |
+    |   unicore32: | TODO |
+    |         x86: | TODO |
+    |      xtensa: | TODO |
+    -----------------------
diff --git a/Documentation/features/time/clockevents/arch-support.txt b/Documentation/features/time/clockevents/arch-support.txt
new file mode 100644
index 000000000000..ff670b2207f1
--- /dev/null
+++ b/Documentation/features/time/clockevents/arch-support.txt
@@ -0,0 +1,40 @@
+#
+# Feature name:          clockevents
+#         Kconfig:       GENERIC_CLOCKEVENTS
+#         description:   arch support generic clock events
+#
+    -----------------------
+    |         arch |status|
+    -----------------------
+    |       alpha: |  ok  |
+    |         arc: |  ok  |
+    |         arm: |  ok  |
+    |       arm64: |  ok  |
+    |       avr32: |  ok  |
+    |    blackfin: |  ok  |
+    |         c6x: |  ok  |
+    |        cris: |  ok  |
+    |         frv: | TODO |
+    |       h8300: |  ok  |
+    |     hexagon: |  ok  |
+    |        ia64: | TODO |
+    |        m32r: | TODO |
+    |        m68k: |  ok  |
+    |       metag: |  ok  |
+    |  microblaze: |  ok  |
+    |        mips: |  ok  |
+    |     mn10300: |  ok  |
+    |       nios2: |  ok  |
+    |    openrisc: |  ok  |
+    |      parisc: | TODO |
+    |     powerpc: |  ok  |
+    |        s390: |  ok  |
+    |       score: |  ok  |
+    |          sh: |  ok  |
+    |       sparc: |  ok  |
+    |        tile: |  ok  |
+    |          um: |  ok  |
+    |   unicore32: |  ok  |
+    |         x86: |  ok  |
+    |      xtensa: |  ok  |
+    -----------------------
diff --git a/Documentation/features/time/context-tracking/arch-support.txt b/Documentation/features/time/context-tracking/arch-support.txt
new file mode 100644
index 000000000000..a1e3eea7003f
--- /dev/null
+++ b/Documentation/features/time/context-tracking/arch-support.txt
@@ -0,0 +1,40 @@
+#
+# Feature name:          context-tracking
+#         Kconfig:       HAVE_CONTEXT_TRACKING
+#         description:   arch supports context tracking for NO_HZ_FULL
+#
+    -----------------------
+    |         arch |status|
+    -----------------------
+    |       alpha: | TODO |
+    |         arc: | TODO |
+    |         arm: |  ok  |
+    |       arm64: |  ok  |
+    |       avr32: | TODO |
+    |    blackfin: | TODO |
+    |         c6x: | TODO |
+    |        cris: | TODO |
+    |         frv: | TODO |
+    |       h8300: | TODO |
+    |     hexagon: | TODO |
+    |        ia64: | TODO |
+    |        m32r: | TODO |
+    |        m68k: | TODO |
+    |       metag: | TODO |
+    |  microblaze: | TODO |
+    |        mips: |  ok  |
+    |     mn10300: | TODO |
+    |       nios2: | TODO |
+    |    openrisc: | TODO |
+    |      parisc: | TODO |
+    |     powerpc: |  ok  |
+    |        s390: | TODO |
+    |       score: | TODO |
+    |          sh: | TODO |
+    |       sparc: |  ok  |
+    |        tile: |  ok  |
+    |          um: | TODO |
+    |   unicore32: | TODO |
+    |         x86: |  ok  |
+    |      xtensa: | TODO |
+    -----------------------
diff --git a/Documentation/features/time/irq-time-acct/arch-support.txt b/Documentation/features/time/irq-time-acct/arch-support.txt
new file mode 100644
index 000000000000..e63316239938
--- /dev/null
+++ b/Documentation/features/time/irq-time-acct/arch-support.txt
@@ -0,0 +1,40 @@
+#
+# Feature name:          irq-time-acct
+#         Kconfig:       HAVE_IRQ_TIME_ACCOUNTING
+#         description:   arch supports precise IRQ time accounting
+#
+    -----------------------
+    |         arch |status|
+    -----------------------
+    |       alpha: |  ..  |
+    |         arc: | TODO |
+    |         arm: |  ok  |
+    |       arm64: |  ..  |
+    |       avr32: | TODO |
+    |    blackfin: | TODO |
+    |         c6x: | TODO |
+    |        cris: | TODO |
+    |         frv: | TODO |
+    |       h8300: | TODO |
+    |     hexagon: | TODO |
+    |        ia64: |  ..  |
+    |        m32r: | TODO |
+    |        m68k: | TODO |
+    |       metag: | TODO |
+    |  microblaze: | TODO |
+    |        mips: |  ok  |
+    |     mn10300: | TODO |
+    |       nios2: | TODO |
+    |    openrisc: | TODO |
+    |      parisc: |  ..  |
+    |     powerpc: |  ..  |
+    |        s390: |  ..  |
+    |       score: | TODO |
+    |          sh: | TODO |
+    |       sparc: |  ..  |
+    |        tile: |  ..  |
+    |          um: | TODO |
+    |   unicore32: | TODO |
+    |         x86: |  ok  |
+    |      xtensa: |  ok  |
+    -----------------------
diff --git a/Documentation/features/time/modern-timekeeping/arch-support.txt b/Documentation/features/time/modern-timekeeping/arch-support.txt
new file mode 100644
index 000000000000..17f68a02e84d
--- /dev/null
+++ b/Documentation/features/time/modern-timekeeping/arch-support.txt
@@ -0,0 +1,40 @@
+#
+# Feature name:          modern-timekeeping
+#         Kconfig:       !ARCH_USES_GETTIMEOFFSET
+#         description:   arch does not use arch_gettimeoffset() anymore
+#
+    -----------------------
+    |         arch |status|
+    -----------------------
+    |       alpha: |  ok  |
+    |         arc: |  ok  |
+    |         arm: | TODO |
+    |       arm64: |  ok  |
+    |       avr32: |  ok  |
+    |    blackfin: | TODO |
+    |         c6x: |  ok  |
+    |        cris: | TODO |
+    |         frv: |  ok  |
+    |       h8300: |  ok  |
+    |     hexagon: |  ok  |
+    |        ia64: |  ok  |
+    |        m32r: | TODO |
+    |        m68k: | TODO |
+    |       metag: |  ok  |
+    |  microblaze: |  ok  |
+    |        mips: |  ok  |
+    |     mn10300: |  ok  |
+    |       nios2: |  ok  |
+    |    openrisc: |  ok  |
+    |      parisc: |  ok  |
+    |     powerpc: |  ok  |
+    |        s390: |  ok  |
+    |       score: |  ok  |
+    |          sh: |  ok  |
+    |       sparc: |  ok  |
+    |        tile: |  ok  |
+    |          um: |  ok  |
+    |   unicore32: |  ok  |
+    |         x86: |  ok  |
+    |      xtensa: |  ok  |
+    -----------------------
diff --git a/Documentation/features/time/virt-cpuacct/arch-support.txt b/Documentation/features/time/virt-cpuacct/arch-support.txt
new file mode 100644
index 000000000000..cf3c3e383d15
--- /dev/null
+++ b/Documentation/features/time/virt-cpuacct/arch-support.txt
@@ -0,0 +1,40 @@
+#
+# Feature name:          virt-cpuacct
+#         Kconfig:       HAVE_VIRT_CPU_ACCOUNTING
+#         description:   arch supports precise virtual CPU time accounting
+#
+    -----------------------
+    |         arch |status|
+    -----------------------
+    |       alpha: |  ok  |
+    |         arc: | TODO |
+    |         arm: |  ok  |
+    |       arm64: |  ok  |
+    |       avr32: | TODO |
+    |    blackfin: | TODO |
+    |         c6x: | TODO |
+    |        cris: | TODO |
+    |         frv: | TODO |
+    |       h8300: | TODO |
+    |     hexagon: | TODO |
+    |        ia64: |  ok  |
+    |        m32r: | TODO |
+    |        m68k: | TODO |
+    |       metag: | TODO |
+    |  microblaze: | TODO |
+    |        mips: |  ok  |
+    |     mn10300: | TODO |
+    |       nios2: | TODO |
+    |    openrisc: | TODO |
+    |      parisc: |  ok  |
+    |     powerpc: |  ok  |
+    |        s390: |  ok  |
+    |       score: | TODO |
+    |          sh: | TODO |
+    |       sparc: |  ok  |
+    |        tile: |  ok  |
+    |          um: | TODO |
+    |   unicore32: | TODO |
+    |         x86: |  ok  |
+    |      xtensa: | TODO |
+    -----------------------
diff --git a/Documentation/features/vm/ELF-ASLR/arch-support.txt b/Documentation/features/vm/ELF-ASLR/arch-support.txt
new file mode 100644
index 000000000000..ec4dd28e1297
--- /dev/null
+++ b/Documentation/features/vm/ELF-ASLR/arch-support.txt
@@ -0,0 +1,40 @@
+#
+# Feature name:          ELF-ASLR
+#         Kconfig:       ARCH_HAS_ELF_RANDOMIZE
+#         description:   arch randomizes the stack, heap and binary images of ELF binaries
+#
+    -----------------------
+    |         arch |status|
+    -----------------------
+    |       alpha: | TODO |
+    |         arc: | TODO |
+    |         arm: |  ok  |
+    |       arm64: |  ok  |
+    |       avr32: | TODO |
+    |    blackfin: | TODO |
+    |         c6x: | TODO |
+    |        cris: | TODO |
+    |         frv: | TODO |
+    |       h8300: | TODO |
+    |     hexagon: | TODO |
+    |        ia64: | TODO |
+    |        m32r: | TODO |
+    |        m68k: | TODO |
+    |       metag: | TODO |
+    |  microblaze: | TODO |
+    |        mips: |  ok  |
+    |     mn10300: | TODO |
+    |       nios2: | TODO |
+    |    openrisc: | TODO |
+    |      parisc: | TODO |
+    |     powerpc: |  ok  |
+    |        s390: |  ok  |
+    |       score: | TODO |
+    |          sh: | TODO |
+    |       sparc: | TODO |
+    |        tile: | TODO |
+    |          um: | TODO |
+    |   unicore32: | TODO |
+    |         x86: |  ok  |
+    |      xtensa: | TODO |
+    -----------------------
diff --git a/Documentation/features/vm/PG_uncached/arch-support.txt b/Documentation/features/vm/PG_uncached/arch-support.txt
new file mode 100644
index 000000000000..991974275a3e
--- /dev/null
+++ b/Documentation/features/vm/PG_uncached/arch-support.txt
@@ -0,0 +1,40 @@
+#
+# Feature name:          PG_uncached
+#         Kconfig:       ARCH_USES_PG_UNCACHED
+#         description:   arch supports the PG_uncached page flag
+#
+    -----------------------
+    |         arch |status|
+    -----------------------
+    |       alpha: | TODO |
+    |         arc: | TODO |
+    |         arm: | TODO |
+    |       arm64: | TODO |
+    |       avr32: | TODO |
+    |    blackfin: | TODO |
+    |         c6x: | TODO |
+    |        cris: | TODO |
+    |         frv: | TODO |
+    |       h8300: | TODO |
+    |     hexagon: | TODO |
+    |        ia64: |  ok  |
+    |        m32r: | TODO |
+    |        m68k: | TODO |
+    |       metag: | TODO |
+    |  microblaze: | TODO |
+    |        mips: | TODO |
+    |     mn10300: | TODO |
+    |       nios2: | TODO |
+    |    openrisc: | TODO |
+    |      parisc: | TODO |
+    |     powerpc: | TODO |
+    |        s390: | TODO |
+    |       score: | TODO |
+    |          sh: | TODO |
+    |       sparc: | TODO |
+    |        tile: | TODO |
+    |          um: | TODO |
+    |   unicore32: | TODO |
+    |         x86: |  ok  |
+    |      xtensa: | TODO |
+    -----------------------
diff --git a/Documentation/features/vm/THP/arch-support.txt b/Documentation/features/vm/THP/arch-support.txt
new file mode 100644
index 000000000000..972d02c2a74c
--- /dev/null
+++ b/Documentation/features/vm/THP/arch-support.txt
@@ -0,0 +1,40 @@
+#
+# Feature name:          THP
+#         Kconfig:       HAVE_ARCH_TRANSPARENT_HUGEPAGE
+#         description:   arch supports transparent hugepages
+#
+    -----------------------
+    |         arch |status|
+    -----------------------
+    |       alpha: | TODO |
+    |         arc: |  ..  |
+    |         arm: |  ok  |
+    |       arm64: |  ok  |
+    |       avr32: |  ..  |
+    |    blackfin: |  ..  |
+    |         c6x: |  ..  |
+    |        cris: |  ..  |
+    |         frv: |  ..  |
+    |       h8300: |  ..  |
+    |     hexagon: |  ..  |
+    |        ia64: | TODO |
+    |        m32r: |  ..  |
+    |        m68k: |  ..  |
+    |       metag: |  ..  |
+    |  microblaze: |  ..  |
+    |        mips: |  ok  |
+    |     mn10300: |  ..  |
+    |       nios2: |  ..  |
+    |    openrisc: |  ..  |
+    |      parisc: | TODO |
+    |     powerpc: |  ok  |
+    |        s390: |  ok  |
+    |       score: |  ..  |
+    |          sh: |  ..  |
+    |       sparc: |  ok  |
+    |        tile: | TODO |
+    |          um: |  ..  |
+    |   unicore32: |  ..  |
+    |         x86: |  ok  |
+    |      xtensa: |  ..  |
+    -----------------------
diff --git a/Documentation/features/vm/huge-vmap/arch-support.txt b/Documentation/features/vm/huge-vmap/arch-support.txt
new file mode 100644
index 000000000000..af6816bccb43
--- /dev/null
+++ b/Documentation/features/vm/huge-vmap/arch-support.txt
@@ -0,0 +1,40 @@
+#
+# Feature name:          huge-vmap
+#         Kconfig:       HAVE_ARCH_HUGE_VMAP
+#         description:   arch supports the ioremap_pud_enabled() and ioremap_pmd_enabled() VM APIs
+#
+    -----------------------
+    |         arch |status|
+    -----------------------
+    |       alpha: | TODO |
+    |         arc: | TODO |
+    |         arm: | TODO |
+    |       arm64: | TODO |
+    |       avr32: | TODO |
+    |    blackfin: | TODO |
+    |         c6x: | TODO |
+    |        cris: | TODO |
+    |         frv: | TODO |
+    |       h8300: | TODO |
+    |     hexagon: | TODO |
+    |        ia64: | TODO |
+    |        m32r: | TODO |
+    |        m68k: | TODO |
+    |       metag: | TODO |
+    |  microblaze: | TODO |
+    |        mips: | TODO |
+    |     mn10300: | TODO |
+    |       nios2: | TODO |
+    |    openrisc: | TODO |
+    |      parisc: | TODO |
+    |     powerpc: | TODO |
+    |        s390: | TODO |
+    |       score: | TODO |
+    |          sh: | TODO |
+    |       sparc: | TODO |
+    |        tile: | TODO |
+    |          um: | TODO |
+    |   unicore32: | TODO |
+    |         x86: |  ok  |
+    |      xtensa: | TODO |
+    -----------------------
diff --git a/Documentation/features/vm/ioremap_prot/arch-support.txt b/Documentation/features/vm/ioremap_prot/arch-support.txt
new file mode 100644
index 000000000000..90c53749fde7
--- /dev/null
+++ b/Documentation/features/vm/ioremap_prot/arch-support.txt
@@ -0,0 +1,40 @@
+#
+# Feature name:          ioremap_prot
+#         Kconfig:       HAVE_IOREMAP_PROT
+#         description:   arch has ioremap_prot()
+#
+    -----------------------
+    |         arch |status|
+    -----------------------
+    |       alpha: | TODO |
+    |         arc: |  ok  |
+    |         arm: | TODO |
+    |       arm64: | TODO |
+    |       avr32: | TODO |
+    |    blackfin: | TODO |
+    |         c6x: | TODO |
+    |        cris: | TODO |
+    |         frv: | TODO |
+    |       h8300: | TODO |
+    |     hexagon: | TODO |
+    |        ia64: | TODO |
+    |        m32r: | TODO |
+    |        m68k: | TODO |
+    |       metag: | TODO |
+    |  microblaze: | TODO |
+    |        mips: | TODO |
+    |     mn10300: | TODO |
+    |       nios2: | TODO |
+    |    openrisc: | TODO |
+    |      parisc: | TODO |
+    |     powerpc: |  ok  |
+    |        s390: | TODO |
+    |       score: | TODO |
+    |          sh: |  ok  |
+    |       sparc: | TODO |
+    |        tile: |  ok  |
+    |          um: | TODO |
+    |   unicore32: | TODO |
+    |         x86: |  ok  |
+    |      xtensa: | TODO |
+    -----------------------
diff --git a/Documentation/features/vm/numa-memblock/arch-support.txt b/Documentation/features/vm/numa-memblock/arch-support.txt
new file mode 100644
index 000000000000..e7c252a0c531
--- /dev/null
+++ b/Documentation/features/vm/numa-memblock/arch-support.txt
@@ -0,0 +1,40 @@
+#
+# Feature name:          numa-memblock
+#         Kconfig:       HAVE_MEMBLOCK_NODE_MAP
+#         description:   arch supports NUMA aware memblocks
+#
+    -----------------------
+    |         arch |status|
+    -----------------------
+    |       alpha: | TODO |
+    |         arc: |  ..  |
+    |         arm: |  ..  |
+    |       arm64: |  ..  |
+    |       avr32: |  ..  |
+    |    blackfin: |  ..  |
+    |         c6x: |  ..  |
+    |        cris: |  ..  |
+    |         frv: |  ..  |
+    |       h8300: |  ..  |
+    |     hexagon: |  ..  |
+    |        ia64: |  ok  |
+    |        m32r: | TODO |
+    |        m68k: |  ..  |
+    |       metag: |  ok  |
+    |  microblaze: |  ok  |
+    |        mips: |  ok  |
+    |     mn10300: | TODO |
+    |       nios2: |  ..  |
+    |    openrisc: |  ..  |
+    |      parisc: |  ..  |
+    |     powerpc: |  ok  |
+    |        s390: |  ok  |
+    |       score: |  ok  |
+    |          sh: |  ok  |
+    |       sparc: |  ok  |
+    |        tile: | TODO |
+    |          um: |  ..  |
+    |   unicore32: |  ..  |
+    |         x86: |  ok  |
+    |      xtensa: |  ..  |
+    -----------------------
diff --git a/Documentation/features/vm/pmdp_splitting_flush/arch-support.txt b/Documentation/features/vm/pmdp_splitting_flush/arch-support.txt
new file mode 100644
index 000000000000..26f74b457e0b
--- /dev/null
+++ b/Documentation/features/vm/pmdp_splitting_flush/arch-support.txt
@@ -0,0 +1,40 @@
+#
+# Feature name:          pmdp_splitting_flush
+#         Kconfig:       __HAVE_ARCH_PMDP_SPLITTING_FLUSH
+#         description:   arch supports the pmdp_splitting_flush() VM API
+#
+    -----------------------
+    |         arch |status|
+    -----------------------
+    |       alpha: | TODO |
+    |         arc: | TODO |
+    |         arm: |  ok  |
+    |       arm64: |  ok  |
+    |       avr32: | TODO |
+    |    blackfin: | TODO |
+    |         c6x: | TODO |
+    |        cris: | TODO |
+    |         frv: | TODO |
+    |       h8300: | TODO |
+    |     hexagon: | TODO |
+    |        ia64: | TODO |
+    |        m32r: | TODO |
+    |        m68k: | TODO |
+    |       metag: | TODO |
+    |  microblaze: | TODO |
+    |        mips: |  ok  |
+    |     mn10300: | TODO |
+    |       nios2: | TODO |
+    |    openrisc: | TODO |
+    |      parisc: | TODO |
+    |     powerpc: |  ok  |
+    |        s390: |  ok  |
+    |       score: | TODO |
+    |          sh: | TODO |
+    |       sparc: | TODO |
+    |        tile: | TODO |
+    |          um: | TODO |
+    |   unicore32: | TODO |
+    |         x86: |  ok  |
+    |      xtensa: | TODO |
+    -----------------------
diff --git a/Documentation/features/vm/pte_special/arch-support.txt b/Documentation/features/vm/pte_special/arch-support.txt
new file mode 100644
index 000000000000..aaaa21db6226
--- /dev/null
+++ b/Documentation/features/vm/pte_special/arch-support.txt
@@ -0,0 +1,40 @@
+#
+# Feature name:          pte_special
+#         Kconfig:       __HAVE_ARCH_PTE_SPECIAL
+#         description:   arch supports the pte_special()/pte_mkspecial() VM APIs
+#
+    -----------------------
+    |         arch |status|
+    -----------------------
+    |       alpha: | TODO |
+    |         arc: | TODO |
+    |         arm: |  ok  |
+    |       arm64: |  ok  |
+    |       avr32: | TODO |
+    |    blackfin: | TODO |
+    |         c6x: | TODO |
+    |        cris: | TODO |
+    |         frv: | TODO |
+    |       h8300: | TODO |
+    |     hexagon: | TODO |
+    |        ia64: | TODO |
+    |        m32r: | TODO |
+    |        m68k: | TODO |
+    |       metag: | TODO |
+    |  microblaze: | TODO |
+    |        mips: | TODO |
+    |     mn10300: | TODO |
+    |       nios2: | TODO |
+    |    openrisc: | TODO |
+    |      parisc: | TODO |
+    |     powerpc: |  ok  |
+    |        s390: |  ok  |
+    |       score: | TODO |
+    |          sh: |  ok  |
+    |       sparc: |  ok  |
+    |        tile: | TODO |
+    |          um: | TODO |
+    |   unicore32: | TODO |
+    |         x86: |  ok  |
+    |      xtensa: | TODO |
+    -----------------------
