From: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH v2] Documentation/arch: Add kernel feature descriptions and
 arch support status under Documentation/features/
Date: Thu, 14 May 2015 12:35:44 +0200
Message-ID: <20150514103544.GA7027@gmail.com>
References: <20150513083441.GA17336@gmail.com>
 <20150513085636.GA11030@gmail.com>
 <20150513092421.GB11030@gmail.com>
 <20150513094622.GC11030@gmail.com>
 <20150513094756.GD11030@gmail.com>
 <20150513131835.GJ1517@pd.tnic>
 <20150513134842.GA1657@gmail.com>
 <20150513162757.GA21894@x>
 <20150513150523.ddd65d7cd51f820b78f0c8e3@linux-foundation.org>
 <20150514101518.GA27550@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20150514101518.GA27550-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-arch-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org


* Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:

> To list an architecture's unsupported features, just do something
> like:
> 
>   $ git grep -lE 'x86.*TODO' Documentation/features/*/arch-support.txt
> 
>   Documentation/features/arch-tick-broadcast/arch-support.txt
>   Documentation/features/strncasecmp/arch-support.txt
> 
> which prints the list of features not yet supported by the 
> architecture.

Another way to visualize the feature support status of an 
architecture, would be to use the simple script I've put into 
Documentation/features/list-arch.sh:

  triton:~/tip> Documentation/features/list-arch.sh
  #
  # Kernel feature support matrix of architecture 'x86':
  #
           arch-tick-broadcast:     |         x86: | TODO |
                       BPF-JIT:     |         x86: |  ok  |
                   clockevents:     |         x86: |  ok  |
                 cmpxchg-local:     |         x86: |  ok  |
              context-tracking:     |         x86: |  ok  |
                 dma-api-debug:     |         x86: |  ok  |
                dma-contiguous:     |         x86: |  ok  |
                 dma_map_attrs:     |         x86: |  ok  |
                      ELF-ASLR:     |         x86: |  ok  |
              gcov-profile-all:     |         x86: |  ok  |
           generic-idle-thread:     |         x86: |  ok  |
                     huge-vmap:     |         x86: |  ok  |
                  ioremap_prot:     |         x86: |  ok  |
                 irq-time-acct:     |         x86: |  ok  |
                   jump-labels:     |         x86: |  ok  |
                         KASAN:     |         x86: |  ok  |
                          kgdb:     |         x86: |  ok  |
                       kprobes:     |         x86: |  ok  |
                 kprobes-event:     |         x86: |  ok  |
             kprobes-on-ftrace:     |         x86: |  ok  |
                    kretprobes:     |         x86: |  ok  |
                       lockdep:     |         x86: |  ok  |
            modern-timekeeping:     |         x86: |  ok  |
                numa-balancing:     |         x86: |  ok  |
                 numa-memblock:     |         x86: |  ok  |
                     optprobes:     |         x86: |  ok  |
                     perf-regs:     |         x86: |  ok  |
                perf-stackdump:     |         x86: |  ok  |
                   PG_uncached:     |         x86: |  ok  |
          pmdp_splitting_flush:     |         x86: |  ok  |
                   pte_special:     |         x86: |  ok  |
                queued-rwlocks:     |         x86: |  ok  |
              queued-spinlocks:     |         x86: |  ok  |
               rwsem-optimized:     |         x86: |  ok  |
                seccomp-filter:     |         x86: |  ok  |
                      sg-chain:     |         x86: |  ok  |
                stackprotector:     |         x86: |  ok  |
                   strncasecmp:     |         x86: | TODO |
                           THP:     |         x86: |  ok  |
                     tracehook:     |         x86: |  ok  |
                       uprobes:     |         x86: |  ok  |
             user-ret-profiler:     |         x86: |  ok  |
                  virt-cpuacct:     |         x86: |  ok  |

Updated patch attached.

This way we can avoid the conflicts by generating the visualization on 
the fly.

Thanks,

	Ingo

===============================>
From: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Date: Thu, 14 May 2015 12:04:00 +0200
Subject: [PATCH] Documentation/arch: Add kernel feature descriptions and arch support status under Documentation/features/

Add arch support matrices for more than 40 generic kernel features
that need per architecture support.

Each feature has its own directory under Documentation/features/feature_name/,
and the arch-support.txt file shows its current arch porting status.

For example, lockdep support is shown the following way:

    triton:~/tip> cat Documentation/features/lockdep/arch-support.txt
    #
    # Feature name:          lockdep
    #         Kconfig:       LOCKDEP_SUPPORT
    #         description:   arch supports the runtime locking correctness debug facility
    #
        -----------------------
        |         arch |status|
        -----------------------
        |       alpha: | TODO |
        |         arc: |  ok  |
        |         arm: |  ok  |
        |       arm64: |  ok  |
        |       avr32: |  ok  |
        |    blackfin: |  ok  |
        |         c6x: | TODO |
        |        cris: | TODO |
        |         frv: | TODO |
        |     hexagon: |  ok  |
        |        ia64: | TODO |
        |        m32r: | TODO |
        |        m68k: | TODO |
        |       metag: |  ok  |
        |  microblaze: |  ok  |
        |        mips: |  ok  |
        |     mn10300: | TODO |
        |       nios2: | TODO |
        |    openrisc: | TODO |
        |      parisc: | TODO |
        |     powerpc: |  ok  |
        |        s390: |  ok  |
        |       score: |  ok  |
        |          sh: |  ok  |
        |       sparc: |  ok  |
        |        tile: |  ok  |
        |          um: |  ok  |
        |   unicore32: |  ok  |
        |         x86: |  ok  |
        |      xtensa: |  ok  |
        -----------------------

For generic kernel features that need architecture support, the
arch-support.txt file in each feature directory shows the arch
support matrix, for all upstream Linux architectures.

The meaning of entries in the tables is:

    | ok |  # feature supported by the architecture
    |TODO|  # feature not yet supported by the architecture
    | .. |  # feature cannot be supported by the hardware

This directory structure can be used in the future to add other
files - such as porting guides, testing description, etc.

The Documentation/features/ hierarchy may also include generic
kernel features that works on every architecture, in that case
the arch-support.txt file will list every architecture as
supported.

To list an architecture's unsupported features, just do something
like:

  $ git grep -lE 'x86.*TODO' Documentation/features/*/arch-support.txt
  Documentation/features/arch-tick-broadcast/arch-support.txt
  Documentation/features/strncasecmp/arch-support.txt

which will print the list of not yet supported features.

The Documentation/features/list-arch.sh script will print the current
support matrix of one architecture:

  triton:~/tip> Documentation/features/list-arch.sh
  #
  # Kernel feature support matrix of architecture 'x86':
  #
           arch-tick-broadcast:     |         x86: | TODO |
                       BPF-JIT:     |         x86: |  ok  |
                   clockevents:     |         x86: |  ok  |
                 cmpxchg-local:     |         x86: |  ok  |
              context-tracking:     |         x86: |  ok  |
                 dma-api-debug:     |         x86: |  ok  |
                dma-contiguous:     |         x86: |  ok  |
                 dma_map_attrs:     |         x86: |  ok  |
                      ELF-ASLR:     |         x86: |  ok  |
              gcov-profile-all:     |         x86: |  ok  |
           generic-idle-thread:     |         x86: |  ok  |
                     huge-vmap:     |         x86: |  ok  |
                  ioremap_prot:     |         x86: |  ok  |
                 irq-time-acct:     |         x86: |  ok  |
                   jump-labels:     |         x86: |  ok  |
                         KASAN:     |         x86: |  ok  |
                          kgdb:     |         x86: |  ok  |
                       kprobes:     |         x86: |  ok  |
                 kprobes-event:     |         x86: |  ok  |
             kprobes-on-ftrace:     |         x86: |  ok  |
                    kretprobes:     |         x86: |  ok  |
                       lockdep:     |         x86: |  ok  |
            modern-timekeeping:     |         x86: |  ok  |
                numa-balancing:     |         x86: |  ok  |
                 numa-memblock:     |         x86: |  ok  |
                     optprobes:     |         x86: |  ok  |
                     perf-regs:     |         x86: |  ok  |
                perf-stackdump:     |         x86: |  ok  |
                   PG_uncached:     |         x86: |  ok  |
          pmdp_splitting_flush:     |         x86: |  ok  |
                   pte_special:     |         x86: |  ok  |
                queued-rwlocks:     |         x86: |  ok  |
              queued-spinlocks:     |         x86: |  ok  |
               rwsem-optimized:     |         x86: |  ok  |
                seccomp-filter:     |         x86: |  ok  |
                      sg-chain:     |         x86: |  ok  |
                stackprotector:     |         x86: |  ok  |
                   strncasecmp:     |         x86: | TODO |
                           THP:     |         x86: |  ok  |
                     tracehook:     |         x86: |  ok  |
                       uprobes:     |         x86: |  ok  |
             user-ret-profiler:     |         x86: |  ok  |
                  virt-cpuacct:     |         x86: |  ok  |

Signed-off-by: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 Documentation/features/BPF-JIT/arch-support.txt    | 39 ++++++++++++++++++++++
 Documentation/features/ELF-ASLR/arch-support.txt   | 39 ++++++++++++++++++++++
 Documentation/features/KASAN/arch-support.txt      | 39 ++++++++++++++++++++++
 .../features/PG_uncached/arch-support.txt          | 39 ++++++++++++++++++++++
 Documentation/features/THP/arch-support.txt        | 39 ++++++++++++++++++++++
 Documentation/features/arch-support.txt            | 11 ++++++
 .../features/arch-tick-broadcast/arch-support.txt  | 39 ++++++++++++++++++++++
 .../features/clockevents/arch-support.txt          | 39 ++++++++++++++++++++++
 .../features/cmpxchg-local/arch-support.txt        | 39 ++++++++++++++++++++++
 .../features/context-tracking/arch-support.txt     | 39 ++++++++++++++++++++++
 .../features/dma-api-debug/arch-support.txt        | 39 ++++++++++++++++++++++
 .../features/dma-contiguous/arch-support.txt       | 39 ++++++++++++++++++++++
 .../features/dma_map_attrs/arch-support.txt        | 39 ++++++++++++++++++++++
 .../features/gcov-profile-all/arch-support.txt     | 39 ++++++++++++++++++++++
 .../features/generic-idle-thread/arch-support.txt  | 39 ++++++++++++++++++++++
 Documentation/features/huge-vmap/arch-support.txt  | 39 ++++++++++++++++++++++
 .../features/ioremap_prot/arch-support.txt         | 39 ++++++++++++++++++++++
 .../features/irq-time-acct/arch-support.txt        | 39 ++++++++++++++++++++++
 .../features/jump-labels/arch-support.txt          | 39 ++++++++++++++++++++++
 Documentation/features/kgdb/arch-support.txt       | 39 ++++++++++++++++++++++
 .../features/kprobes-event/arch-support.txt        | 39 ++++++++++++++++++++++
 .../features/kprobes-on-ftrace/arch-support.txt    | 39 ++++++++++++++++++++++
 Documentation/features/kprobes/arch-support.txt    | 39 ++++++++++++++++++++++
 Documentation/features/kretprobes/arch-support.txt | 39 ++++++++++++++++++++++
 Documentation/features/list-arch.sh                | 21 ++++++++++++
 Documentation/features/lockdep/arch-support.txt    | 39 ++++++++++++++++++++++
 .../features/modern-timekeeping/arch-support.txt   | 39 ++++++++++++++++++++++
 .../features/numa-balancing/arch-support.txt       | 39 ++++++++++++++++++++++
 .../features/numa-memblock/arch-support.txt        | 39 ++++++++++++++++++++++
 Documentation/features/optprobes/arch-support.txt  | 39 ++++++++++++++++++++++
 Documentation/features/perf-regs/arch-support.txt  | 39 ++++++++++++++++++++++
 .../features/perf-stackdump/arch-support.txt       | 39 ++++++++++++++++++++++
 .../features/pmdp_splitting_flush/arch-support.txt | 39 ++++++++++++++++++++++
 .../features/pte_special/arch-support.txt          | 39 ++++++++++++++++++++++
 .../features/queued-rwlocks/arch-support.txt       | 39 ++++++++++++++++++++++
 .../features/queued-spinlocks/arch-support.txt     | 39 ++++++++++++++++++++++
 .../features/rwsem-optimized/arch-support.txt      | 39 ++++++++++++++++++++++
 .../features/seccomp-filter/arch-support.txt       | 39 ++++++++++++++++++++++
 Documentation/features/sg-chain/arch-support.txt   | 39 ++++++++++++++++++++++
 .../features/stackprotector/arch-support.txt       | 39 ++++++++++++++++++++++
 .../features/strncasecmp/arch-support.txt          | 39 ++++++++++++++++++++++
 Documentation/features/tracehook/arch-support.txt  | 39 ++++++++++++++++++++++
 Documentation/features/uprobes/arch-support.txt    | 39 ++++++++++++++++++++++
 .../features/user-ret-profiler/arch-support.txt    | 39 ++++++++++++++++++++++
 .../features/virt-cpuacct/arch-support.txt         | 39 ++++++++++++++++++++++
 45 files changed, 1709 insertions(+)

diff --git a/Documentation/features/BPF-JIT/arch-support.txt b/Documentation/features/BPF-JIT/arch-support.txt
new file mode 100644
index 000000000000..e412c18cc87e
--- /dev/null
+++ b/Documentation/features/BPF-JIT/arch-support.txt
@@ -0,0 +1,39 @@
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
diff --git a/Documentation/features/ELF-ASLR/arch-support.txt b/Documentation/features/ELF-ASLR/arch-support.txt
new file mode 100644
index 000000000000..1b7322b15ca0
--- /dev/null
+++ b/Documentation/features/ELF-ASLR/arch-support.txt
@@ -0,0 +1,39 @@
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
diff --git a/Documentation/features/KASAN/arch-support.txt b/Documentation/features/KASAN/arch-support.txt
new file mode 100644
index 000000000000..90d82cbc5f02
--- /dev/null
+++ b/Documentation/features/KASAN/arch-support.txt
@@ -0,0 +1,39 @@
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
diff --git a/Documentation/features/PG_uncached/arch-support.txt b/Documentation/features/PG_uncached/arch-support.txt
new file mode 100644
index 000000000000..a3a0ecf49788
--- /dev/null
+++ b/Documentation/features/PG_uncached/arch-support.txt
@@ -0,0 +1,39 @@
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
diff --git a/Documentation/features/THP/arch-support.txt b/Documentation/features/THP/arch-support.txt
new file mode 100644
index 000000000000..88da2621216b
--- /dev/null
+++ b/Documentation/features/THP/arch-support.txt
@@ -0,0 +1,39 @@
+#
+# Feature name:          THP
+#         Kconfig:       HAVE_ARCH_TRANSPARENT_HUGEPAGE && 64BIT
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
diff --git a/Documentation/features/arch-tick-broadcast/arch-support.txt b/Documentation/features/arch-tick-broadcast/arch-support.txt
new file mode 100644
index 000000000000..d6798417428b
--- /dev/null
+++ b/Documentation/features/arch-tick-broadcast/arch-support.txt
@@ -0,0 +1,39 @@
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
diff --git a/Documentation/features/clockevents/arch-support.txt b/Documentation/features/clockevents/arch-support.txt
new file mode 100644
index 000000000000..8ba7fb83825b
--- /dev/null
+++ b/Documentation/features/clockevents/arch-support.txt
@@ -0,0 +1,39 @@
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
diff --git a/Documentation/features/cmpxchg-local/arch-support.txt b/Documentation/features/cmpxchg-local/arch-support.txt
new file mode 100644
index 000000000000..364482dc1340
--- /dev/null
+++ b/Documentation/features/cmpxchg-local/arch-support.txt
@@ -0,0 +1,39 @@
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
diff --git a/Documentation/features/context-tracking/arch-support.txt b/Documentation/features/context-tracking/arch-support.txt
new file mode 100644
index 000000000000..47a15d997694
--- /dev/null
+++ b/Documentation/features/context-tracking/arch-support.txt
@@ -0,0 +1,39 @@
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
diff --git a/Documentation/features/dma-api-debug/arch-support.txt b/Documentation/features/dma-api-debug/arch-support.txt
new file mode 100644
index 000000000000..cfd6bcf41b8a
--- /dev/null
+++ b/Documentation/features/dma-api-debug/arch-support.txt
@@ -0,0 +1,39 @@
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
diff --git a/Documentation/features/dma-contiguous/arch-support.txt b/Documentation/features/dma-contiguous/arch-support.txt
new file mode 100644
index 000000000000..a775a06ed2af
--- /dev/null
+++ b/Documentation/features/dma-contiguous/arch-support.txt
@@ -0,0 +1,39 @@
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
diff --git a/Documentation/features/dma_map_attrs/arch-support.txt b/Documentation/features/dma_map_attrs/arch-support.txt
new file mode 100644
index 000000000000..c6296a6354ac
--- /dev/null
+++ b/Documentation/features/dma_map_attrs/arch-support.txt
@@ -0,0 +1,39 @@
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
diff --git a/Documentation/features/gcov-profile-all/arch-support.txt b/Documentation/features/gcov-profile-all/arch-support.txt
new file mode 100644
index 000000000000..27961d93b4f7
--- /dev/null
+++ b/Documentation/features/gcov-profile-all/arch-support.txt
@@ -0,0 +1,39 @@
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
diff --git a/Documentation/features/generic-idle-thread/arch-support.txt b/Documentation/features/generic-idle-thread/arch-support.txt
new file mode 100644
index 000000000000..30315627905d
--- /dev/null
+++ b/Documentation/features/generic-idle-thread/arch-support.txt
@@ -0,0 +1,39 @@
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
diff --git a/Documentation/features/huge-vmap/arch-support.txt b/Documentation/features/huge-vmap/arch-support.txt
new file mode 100644
index 000000000000..8784e30b1734
--- /dev/null
+++ b/Documentation/features/huge-vmap/arch-support.txt
@@ -0,0 +1,39 @@
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
diff --git a/Documentation/features/ioremap_prot/arch-support.txt b/Documentation/features/ioremap_prot/arch-support.txt
new file mode 100644
index 000000000000..2094b77d924b
--- /dev/null
+++ b/Documentation/features/ioremap_prot/arch-support.txt
@@ -0,0 +1,39 @@
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
diff --git a/Documentation/features/irq-time-acct/arch-support.txt b/Documentation/features/irq-time-acct/arch-support.txt
new file mode 100644
index 000000000000..15a85ecb7700
--- /dev/null
+++ b/Documentation/features/irq-time-acct/arch-support.txt
@@ -0,0 +1,39 @@
+#
+# Feature name:          irq-time-acct
+#         Kconfig:       HAVE_IRQ_TIME_ACCOUNTING
+#         description:   arch supports precise IRQ time accounting
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
+    |      xtensa: |  ok  |
+    -----------------------
diff --git a/Documentation/features/jump-labels/arch-support.txt b/Documentation/features/jump-labels/arch-support.txt
new file mode 100644
index 000000000000..f1c1c72653d6
--- /dev/null
+++ b/Documentation/features/jump-labels/arch-support.txt
@@ -0,0 +1,39 @@
+#
+# Feature name:          jump-labels
+#         Kconfig:       HAVE_ARCH_JUMP_LABEL
+#         description:   arch supports live patched high efficiency branches
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
diff --git a/Documentation/features/kgdb/arch-support.txt b/Documentation/features/kgdb/arch-support.txt
new file mode 100644
index 000000000000..f384b75f1251
--- /dev/null
+++ b/Documentation/features/kgdb/arch-support.txt
@@ -0,0 +1,39 @@
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
diff --git a/Documentation/features/kprobes-event/arch-support.txt b/Documentation/features/kprobes-event/arch-support.txt
new file mode 100644
index 000000000000..f8cf1d54d100
--- /dev/null
+++ b/Documentation/features/kprobes-event/arch-support.txt
@@ -0,0 +1,39 @@
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
diff --git a/Documentation/features/kprobes-on-ftrace/arch-support.txt b/Documentation/features/kprobes-on-ftrace/arch-support.txt
new file mode 100644
index 000000000000..0f4a8c8df472
--- /dev/null
+++ b/Documentation/features/kprobes-on-ftrace/arch-support.txt
@@ -0,0 +1,39 @@
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
diff --git a/Documentation/features/kprobes/arch-support.txt b/Documentation/features/kprobes/arch-support.txt
new file mode 100644
index 000000000000..d5518f7fc567
--- /dev/null
+++ b/Documentation/features/kprobes/arch-support.txt
@@ -0,0 +1,39 @@
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
diff --git a/Documentation/features/kretprobes/arch-support.txt b/Documentation/features/kretprobes/arch-support.txt
new file mode 100644
index 000000000000..13960c4cbe61
--- /dev/null
+++ b/Documentation/features/kretprobes/arch-support.txt
@@ -0,0 +1,39 @@
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
diff --git a/Documentation/features/list-arch.sh b/Documentation/features/list-arch.sh
new file mode 100755
index 000000000000..aa53da231a26
--- /dev/null
+++ b/Documentation/features/list-arch.sh
@@ -0,0 +1,21 @@
+#
+# Small script that visualizes the kernel feature support status
+# of an architecture.
+#
+# (If no arguments are given then it will print the host architecture's status.)
+#
+
+[ $# = 0 ] && ARCH=$(arch | sed 's/x86_64/x86/' | sed 's/i386/x86/')
+
+cd $(dirname $0)
+echo "#"
+echo "# Kernel feature support matrix of architecture '$ARCH':"
+echo "#"
+
+for F in */arch-support.txt; do
+  N=$(git grep -h "Feature name" $F | cut -d: -f2)
+  S=$(git grep -hw $ARCH $F)
+
+  printf "%30s: %s\n" "$N" "$S"
+done
+
diff --git a/Documentation/features/lockdep/arch-support.txt b/Documentation/features/lockdep/arch-support.txt
new file mode 100644
index 000000000000..5bfbb7d64fe0
--- /dev/null
+++ b/Documentation/features/lockdep/arch-support.txt
@@ -0,0 +1,39 @@
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
diff --git a/Documentation/features/modern-timekeeping/arch-support.txt b/Documentation/features/modern-timekeeping/arch-support.txt
new file mode 100644
index 000000000000..14422649183d
--- /dev/null
+++ b/Documentation/features/modern-timekeeping/arch-support.txt
@@ -0,0 +1,39 @@
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
diff --git a/Documentation/features/numa-balancing/arch-support.txt b/Documentation/features/numa-balancing/arch-support.txt
new file mode 100644
index 000000000000..791ceb82b16a
--- /dev/null
+++ b/Documentation/features/numa-balancing/arch-support.txt
@@ -0,0 +1,39 @@
+#
+# Feature name:          numa-balancing
+#         Kconfig:       ARCH_SUPPORTS_NUMA_BALANCING && 64BIT && NUMA
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
diff --git a/Documentation/features/numa-memblock/arch-support.txt b/Documentation/features/numa-memblock/arch-support.txt
new file mode 100644
index 000000000000..477df392fee1
--- /dev/null
+++ b/Documentation/features/numa-memblock/arch-support.txt
@@ -0,0 +1,39 @@
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
diff --git a/Documentation/features/optprobes/arch-support.txt b/Documentation/features/optprobes/arch-support.txt
new file mode 100644
index 000000000000..33907b6f5775
--- /dev/null
+++ b/Documentation/features/optprobes/arch-support.txt
@@ -0,0 +1,39 @@
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
diff --git a/Documentation/features/perf-regs/arch-support.txt b/Documentation/features/perf-regs/arch-support.txt
new file mode 100644
index 000000000000..c820ebab4328
--- /dev/null
+++ b/Documentation/features/perf-regs/arch-support.txt
@@ -0,0 +1,39 @@
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
diff --git a/Documentation/features/perf-stackdump/arch-support.txt b/Documentation/features/perf-stackdump/arch-support.txt
new file mode 100644
index 000000000000..cf42a6fab4e2
--- /dev/null
+++ b/Documentation/features/perf-stackdump/arch-support.txt
@@ -0,0 +1,39 @@
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
diff --git a/Documentation/features/pmdp_splitting_flush/arch-support.txt b/Documentation/features/pmdp_splitting_flush/arch-support.txt
new file mode 100644
index 000000000000..930c6f0095e7
--- /dev/null
+++ b/Documentation/features/pmdp_splitting_flush/arch-support.txt
@@ -0,0 +1,39 @@
+#
+# Feature name:          pmdp_splitting_flush
+#         Kconfig:       #define __HAVE_ARCH_PMDP_SPLITTING_FLUSH
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
diff --git a/Documentation/features/pte_special/arch-support.txt b/Documentation/features/pte_special/arch-support.txt
new file mode 100644
index 000000000000..0ca26d144c04
--- /dev/null
+++ b/Documentation/features/pte_special/arch-support.txt
@@ -0,0 +1,39 @@
+#
+# Feature name:          pte_special
+#         Kconfig:       #define __HAVE_ARCH_PTE_SPECIAL
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
diff --git a/Documentation/features/queued-rwlocks/arch-support.txt b/Documentation/features/queued-rwlocks/arch-support.txt
new file mode 100644
index 000000000000..abaffd1b3b84
--- /dev/null
+++ b/Documentation/features/queued-rwlocks/arch-support.txt
@@ -0,0 +1,39 @@
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
diff --git a/Documentation/features/queued-spinlocks/arch-support.txt b/Documentation/features/queued-spinlocks/arch-support.txt
new file mode 100644
index 000000000000..480e9e657039
--- /dev/null
+++ b/Documentation/features/queued-spinlocks/arch-support.txt
@@ -0,0 +1,39 @@
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
diff --git a/Documentation/features/rwsem-optimized/arch-support.txt b/Documentation/features/rwsem-optimized/arch-support.txt
new file mode 100644
index 000000000000..1572c7a75bb0
--- /dev/null
+++ b/Documentation/features/rwsem-optimized/arch-support.txt
@@ -0,0 +1,39 @@
+#
+# Feature name:          rwsem-optimized
+#         Kconfig:       Optimized asm/rwsem.h
+#         description:   arch provides optimized rwsem APIs
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
+    |         frv: |  ok  |
+    |     hexagon: |  ok  |
+    |        ia64: |  ok  |
+    |        m32r: |  ok  |
+    |        m68k: |  ok  |
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
diff --git a/Documentation/features/seccomp-filter/arch-support.txt b/Documentation/features/seccomp-filter/arch-support.txt
new file mode 100644
index 000000000000..1d242a40f195
--- /dev/null
+++ b/Documentation/features/seccomp-filter/arch-support.txt
@@ -0,0 +1,39 @@
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
diff --git a/Documentation/features/sg-chain/arch-support.txt b/Documentation/features/sg-chain/arch-support.txt
new file mode 100644
index 000000000000..8aff17488ae0
--- /dev/null
+++ b/Documentation/features/sg-chain/arch-support.txt
@@ -0,0 +1,39 @@
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
diff --git a/Documentation/features/stackprotector/arch-support.txt b/Documentation/features/stackprotector/arch-support.txt
new file mode 100644
index 000000000000..543b41d36520
--- /dev/null
+++ b/Documentation/features/stackprotector/arch-support.txt
@@ -0,0 +1,39 @@
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
diff --git a/Documentation/features/strncasecmp/arch-support.txt b/Documentation/features/strncasecmp/arch-support.txt
new file mode 100644
index 000000000000..9ea6e4d4baed
--- /dev/null
+++ b/Documentation/features/strncasecmp/arch-support.txt
@@ -0,0 +1,39 @@
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
diff --git a/Documentation/features/tracehook/arch-support.txt b/Documentation/features/tracehook/arch-support.txt
new file mode 100644
index 000000000000..05e9de795733
--- /dev/null
+++ b/Documentation/features/tracehook/arch-support.txt
@@ -0,0 +1,39 @@
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
diff --git a/Documentation/features/uprobes/arch-support.txt b/Documentation/features/uprobes/arch-support.txt
new file mode 100644
index 000000000000..7c633b846f65
--- /dev/null
+++ b/Documentation/features/uprobes/arch-support.txt
@@ -0,0 +1,39 @@
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
diff --git a/Documentation/features/user-ret-profiler/arch-support.txt b/Documentation/features/user-ret-profiler/arch-support.txt
new file mode 100644
index 000000000000..6ba4d07ff641
--- /dev/null
+++ b/Documentation/features/user-ret-profiler/arch-support.txt
@@ -0,0 +1,39 @@
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
diff --git a/Documentation/features/virt-cpuacct/arch-support.txt b/Documentation/features/virt-cpuacct/arch-support.txt
new file mode 100644
index 000000000000..c9374d33b8ac
--- /dev/null
+++ b/Documentation/features/virt-cpuacct/arch-support.txt
@@ -0,0 +1,39 @@
+#
+# Feature name:          virt-cpuacct
+#         Kconfig:       HAVE_VIRT_CPU_ACCOUNTING || 64BIT
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
