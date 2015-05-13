From: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [RFC PATCH v6] Documentation/arch: Add
 Documentation/arch-features.txt
Date: Wed, 13 May 2015 15:48:42 +0200
Message-ID: <20150513134842.GA1657@gmail.com>
References: <20150511192918.GA11361@jtriplet-mobl1>
 <20150512142250.dcb053da81855ae1b5861173@linux-foundation.org>
 <20150512213843.GV21418@twins.programming.kicks-ass.net>
 <20150512144910.0b49c9a7a13336773449db33@linux-foundation.org>
 <20150513083441.GA17336@gmail.com>
 <20150513085636.GA11030@gmail.com>
 <20150513092421.GB11030@gmail.com>
 <20150513094622.GC11030@gmail.com>
 <20150513094756.GD11030@gmail.com>
 <20150513131835.GJ1517@pd.tnic>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20150513131835.GJ1517-fF5Pk5pvG8Y@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-arch-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org


* Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org> wrote:

> On Wed, May 13, 2015 at 11:47:56AM +0200, Ingo Molnar wrote:
> >  - introduce the '..' denotion (in the final table) to show features 
> >    that cannot be supported by an architecture due to hardware 
> >    dependencies:
> > 
> > 		   gcov-profile-all:---------------.
> > 				THP:--------.      |
> > 		      irq-time-acct:-.      |      |
> > 				     |      |      |
> > 		----------------------------------------
> > 		  alpha           | TODO | TODO | TODO |
> > 		  arc             | TODO |  ..  | TODO |
> > 		  arm             |  ok  |  ok  |  ok  |
> > 		  arm64           | TODO |  ok  |  ok  |
> > 		  avr32           | TODO |  ..  | TODO |
> > 		  blackfin        | TODO |  ..  | TODO |
> > 		  c6x             | TODO |  ..  | TODO |
> > 
> >    so in the 'THP' column, if an architecture could in theory support 
> >    THP, it's listed as 'TODO', if it cannot, it's listed as '..'.
> 
> Shouldn't exactly that explanation be in the text file itself too?

Yeah, indeed, added it.

> Also, how about s/TODO//g for less clutter:

No, I'd like there to be a very visible 'TODO' item for missing 
features.

The 'clutter' shows how badly our generic kernel features are 
propagating :-/ We hope to reduce this clutter in the future.

Updated patch attached - I've added a few more features to the last 
table, and restructured the explanations, now every feature 
description also lists the Kconfig variable that it's tracking, e.g.:

      irq time acct: HAVE_IRQ_TIME_ACCOUNTING
                THP: HAVE_ARCH_TRANSPARENT_HUGEPAGE && 64BIT
   gcov profile all: ARCH_HAS_GCOV_PROFILE_ALL
    rwsem optimized: Optimized asm/rwsem.h
   queued spinlocks: ARCH_USE_QUEUED_SPINLOCKS
     queued rwlocks: ARCH_USE_QUEUED_RWLOCKS
     numa balancing: ARCH_SUPPORTS_NUMA_BALANCING && 64BIT && NUMA

Thanks,

	Ingo

=========================================>
>From 93f6bd67b4348bf4bf27cbac8ffa9f1def4fa6aa Mon Sep 17 00:00:00 2001
From: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Date: Wed, 13 May 2015 10:30:11 +0200
Subject: [PATCH] Documentation/arch: Add Documentation/arch-features.txt

Add a support matrix for various generic kernel features that need
architecture support.

Signed-off-by: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 Documentation/arch-features.txt | 222 ++++++++++++++++++++++++++++++++++++++++
 1 file changed, 222 insertions(+)

diff --git a/Documentation/arch-features.txt b/Documentation/arch-features.txt
new file mode 100644
index 000000000000..4f6430bc552b
--- /dev/null
+++ b/Documentation/arch-features.txt
@@ -0,0 +1,222 @@
+
+For generic kernel features that need architecture support, this is
+the feature support matrix, for all upstream Linux architectures.
+
+Meaning of entries in the tables:
+
+    ' ok ': feature supported by the architecture
+    'TODO': feature not yet supported by the architecture
+    ' .. ': feature cannot be supported by the hardware
+
+
+
+            lockdep: LOCKDEP_SUPPORT
+     stackprotector: HAVE_CC_STACKPROTECTOR
+        jump labels: HAVE_ARCH_JUMP_LABEL
+     seccomp filter: HAVE_ARCH_SECCOMP_FILTER
+   context tracking: HAVE_CONTEXT_TRACKING
+               kgdb: HAVE_ARCH_KGDB
+ modern timekeeping: !ARCH_USES_GETTIMEOFFSET
+        clockevents: GENERIC_CLOCKEVENTS
+           ELF ASLR: ARCH_HAS_ELF_RANDOMIZE
+
+            lockdep:---------------------------------------------------------.
+     stackprotector:--------------------------------------------------.      |
+        jump labels:-------------------------------------------.      |      |
+     seccomp filter:------------------------------------.      |      |      |
+   context tracking:-----------------------------.      |      |      |      |
+               kgdb:----------------------.      |      |      |      |      |
+ modern timekeeping:---------------.      |      |      |      |      |      |
+        clockevents:--------.      |      |      |      |      |      |      |
+           ELF ASLR:-.      |      |      |      |      |      |      |      |
+                     |      |      |      |      |      |      |      |      |
+----------------------------------------------------------------------------------
+  alpha           | TODO |  ok  |  ok  | TODO | TODO | TODO | TODO | TODO | TODO |
+  arc             | TODO |  ok  |  ok  |  ok  | TODO | TODO | TODO | TODO |  ok  |
+  arm             |  ok  |  ok  | TODO |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
+  arm64           |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
+  avr32           | TODO |  ok  |  ok  | TODO | TODO | TODO | TODO | TODO |  ok  |
+  blackfin        | TODO |  ok  | TODO |  ok  | TODO | TODO | TODO | TODO |  ok  |
+  c6x             | TODO |  ok  |  ok  | TODO | TODO | TODO | TODO | TODO | TODO |
+  cris            | TODO |  ok  | TODO | TODO | TODO | TODO | TODO | TODO | TODO |
+  frv             | TODO | TODO |  ok  | TODO | TODO | TODO | TODO | TODO | TODO |
+  hexagon         | TODO |  ok  |  ok  |  ok  | TODO | TODO | TODO | TODO |  ok  |
+  ia64            | TODO | TODO |  ok  | TODO | TODO | TODO | TODO | TODO | TODO |
+  m32r            | TODO | TODO | TODO | TODO | TODO | TODO | TODO | TODO | TODO |
+  m68k            | TODO |  ok  | TODO | TODO | TODO | TODO | TODO | TODO | TODO |
+  metag           | TODO |  ok  |  ok  | TODO | TODO | TODO | TODO | TODO |  ok  |
+  microblaze      | TODO |  ok  |  ok  |  ok  | TODO | TODO | TODO | TODO |  ok  |
+  mips            |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
+  mn10300         | TODO |  ok  |  ok  |  ok  | TODO | TODO | TODO | TODO | TODO |
+  nios2           | TODO |  ok  |  ok  |  ok  | TODO | TODO | TODO | TODO | TODO |
+  openrisc        | TODO |  ok  |  ok  | TODO | TODO | TODO | TODO | TODO | TODO |
+  parisc          | TODO | TODO |  ok  | TODO | TODO | TODO | TODO | TODO | TODO |
+  powerpc         |  ok  |  ok  |  ok  |  ok  |  ok  | TODO |  ok  | TODO |  ok  |
+  s390            |  ok  |  ok  |  ok  | TODO | TODO |  ok  |  ok  | TODO |  ok  |
+  score           | TODO |  ok  |  ok  | TODO | TODO | TODO | TODO | TODO |  ok  |
+  sh              | TODO |  ok  |  ok  |  ok  | TODO | TODO | TODO |  ok  |  ok  |
+  sparc           | TODO |  ok  |  ok  |  ok  |  ok  | TODO |  ok  | TODO |  ok  |
+  tile            | TODO |  ok  |  ok  |  ok  |  ok  | TODO | TODO | TODO |  ok  |
+  um              | TODO |  ok  |  ok  | TODO | TODO | TODO | TODO | TODO |  ok  |
+  unicore32       | TODO |  ok  |  ok  | TODO | TODO | TODO | TODO | TODO |  ok  |
+  x86             |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
+  xtensa          | TODO |  ok  |  ok  | TODO | TODO | TODO | TODO | TODO |  ok  |
+----------------------------------------------------------------------------------
+
+
+arch tick broadcast: ARCH_HAS_TICK_BROADCAST
+            kprobes: HAVE_KPROBES
+          optprobes: HAVE_OPTPROBES
+  kprobes on ftrace: HAVE_KPROBES_ON_FTRACE
+            uprobes: ARCH_SUPPORTS_UPROBES
+         kretprobes: HAVE_KRETPROBES
+  user ret profiler: HAVE_USER_RETURN_NOTIFIER
+     ioremap_prot(): HAVE_IOREMAP_PROT
+          tracehook: HAVE_ARCH_TRACEHOOK
+
+arch tick broadcast:---------------------------------------------------------.
+            kprobes:--------------------------------------------------.      |
+          optprobes:-------------------------------------------.      |      |
+  kprobes on ftrace:------------------------------------.      |      |      |
+            uprobes:-----------------------------.      |      |      |      |
+         kretprobes:----------------------.      |      |      |      |      |
+  user ret profiler:---------------.      |      |      |      |      |      |
+     ioremap_prot():--------.      |      |      |      |      |      |      |
+          tracehook:-.      |      |      |      |      |      |      |      |
+                     |      |      |      |      |      |      |      |      |
+----------------------------------------------------------------------------------
+  alpha           | TODO | TODO | TODO | TODO | TODO | TODO | TODO | TODO | TODO |
+  arc             |  ok  |  ok  | TODO |  ok  | TODO | TODO | TODO |  ok  | TODO |
+  arm             |  ok  | TODO | TODO |  ok  |  ok  | TODO |  ok  |  ok  |  ok  |
+  arm64           |  ok  | TODO | TODO | TODO | TODO | TODO | TODO | TODO |  ok  |
+  avr32           | TODO | TODO | TODO | TODO | TODO | TODO | TODO |  ok  | TODO |
+  blackfin        |  ok  | TODO | TODO | TODO | TODO | TODO | TODO | TODO | TODO |
+  c6x             |  ok  | TODO | TODO | TODO | TODO | TODO | TODO | TODO | TODO |
+  cris            | TODO | TODO | TODO | TODO | TODO | TODO | TODO | TODO | TODO |
+  frv             |  ok  | TODO | TODO | TODO | TODO | TODO | TODO | TODO | TODO |
+  hexagon         |  ok  | TODO | TODO | TODO | TODO | TODO | TODO | TODO | TODO |
+  ia64            |  ok  | TODO | TODO |  ok  | TODO | TODO | TODO |  ok  | TODO |
+  m32r            | TODO | TODO | TODO | TODO | TODO | TODO | TODO | TODO | TODO |
+  m68k            | TODO | TODO | TODO | TODO | TODO | TODO | TODO | TODO | TODO |
+  metag           |  ok  | TODO | TODO | TODO | TODO | TODO | TODO | TODO | TODO |
+  microblaze      | TODO | TODO | TODO | TODO | TODO | TODO | TODO | TODO | TODO |
+  mips            |  ok  | TODO | TODO |  ok  | TODO | TODO | TODO |  ok  |  ok  |
+  mn10300         |  ok  | TODO | TODO | TODO | TODO | TODO | TODO | TODO | TODO |
+  nios2           |  ok  | TODO | TODO | TODO | TODO | TODO | TODO | TODO | TODO |
+  openrisc        |  ok  | TODO | TODO | TODO | TODO | TODO | TODO | TODO | TODO |
+  parisc          | TODO | TODO | TODO | TODO | TODO | TODO | TODO | TODO | TODO |
+  powerpc         |  ok  |  ok  | TODO |  ok  |  ok  | TODO | TODO |  ok  |  ok  |
+  s390            |  ok  | TODO | TODO |  ok  |  ok  | TODO | TODO |  ok  | TODO |
+  score           | TODO | TODO | TODO | TODO | TODO | TODO | TODO | TODO | TODO |
+  sh              |  ok  |  ok  | TODO |  ok  | TODO | TODO | TODO |  ok  | TODO |
+  sparc           |  ok  | TODO | TODO |  ok  | TODO | TODO | TODO |  ok  | TODO |
+  tile            |  ok  |  ok  |  ok  |  ok  | TODO | TODO |  ok  |  ok  | TODO |
+  um              | TODO | TODO | TODO | TODO | TODO | TODO | TODO | TODO | TODO |
+  unicore32       | TODO | TODO | TODO | TODO | TODO | TODO | TODO | TODO | TODO |
+  x86             |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  | TODO |
+  xtensa          | TODO | TODO | TODO | TODO | TODO | TODO | TODO | TODO | TODO |
+----------------------------------------------------------------------------------
+
+
+generic idle thread: GENERIC_SMP_IDLE_THREAD
+  dma_*map*_attrs(): HAVE_DMA_ATTRS
+     dma contiguous: HAVE_DMA_CONTIGUOUS
+      kprobes event: HAVE_REGS_AND_STACK_ACCESS_API
+      dma api debug: HAVE_DMA_API_DEBUG
+          perf regs: HAVE_PERF_REGS
+     perf stackdump: HAVE_PERF_USER_STACK_DUMP
+      cmpxchg local: HAVE_CMPXCHG_LOCAL
+       virt cpuacct: HAVE_VIRT_CPU_ACCOUNTING || 64BIT
+
+generic idle thread:---------------------------------------------------------.
+  dma_*map*_attrs():--------------------------------------------------.      |
+     dma contiguous:-------------------------------------------.      |      |
+      kprobes event:------------------------------------.      |      |      |
+      dma api debug:-----------------------------.      |      |      |      |
+          perf regs:----------------------.      |      |      |      |      |
+     perf stackdump:---------------.      |      |      |      |      |      |
+      cmpxchg local:--------.      |      |      |      |      |      |      |
+       virt cpuacct:-.      |      |      |      |      |      |      |      |
+                     |      |      |      |      |      |      |      |      |
+----------------------------------------------------------------------------------
+  alpha           |  ok  | TODO | TODO | TODO | TODO | TODO | TODO |  ok  |  ok  |
+  arc             | TODO | TODO | TODO | TODO | TODO | TODO | TODO | TODO |  ok  |
+  arm             |  ok  | TODO |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
+  arm64           |  ok  | TODO |  ok  |  ok  |  ok  | TODO |  ok  |  ok  |  ok  |
+  avr32           | TODO | TODO | TODO | TODO | TODO | TODO | TODO | TODO | TODO |
+  blackfin        | TODO | TODO | TODO | TODO | TODO | TODO | TODO | TODO |  ok  |
+  c6x             | TODO | TODO | TODO | TODO |  ok  | TODO | TODO | TODO | TODO |
+  cris            | TODO | TODO | TODO | TODO | TODO | TODO | TODO | TODO | TODO |
+  frv             | TODO | TODO | TODO | TODO | TODO | TODO | TODO | TODO | TODO |
+  hexagon         | TODO | TODO | TODO | TODO | TODO |  ok  | TODO |  ok  |  ok  |
+  ia64            |  ok  | TODO | TODO | TODO |  ok  | TODO | TODO |  ok  |  ok  |
+  m32r            | TODO | TODO | TODO | TODO | TODO | TODO | TODO | TODO | TODO |
+  m68k            | TODO | TODO | TODO | TODO | TODO | TODO | TODO | TODO | TODO |
+  metag           | TODO | TODO | TODO | TODO | TODO | TODO | TODO | TODO |  ok  |
+  microblaze      | TODO | TODO | TODO | TODO |  ok  | TODO | TODO |  ok  | TODO |
+  mips            |  ok  | TODO | TODO | TODO |  ok  | TODO |  ok  |  ok  |  ok  |
+  mn10300         | TODO | TODO | TODO | TODO | TODO | TODO | TODO | TODO | TODO |
+  nios2           | TODO | TODO | TODO | TODO | TODO | TODO | TODO | TODO | TODO |
+  openrisc        | TODO | TODO | TODO | TODO | TODO | TODO | TODO |  ok  | TODO |
+  parisc          |  ok  | TODO | TODO | TODO | TODO | TODO | TODO | TODO |  ok  |
+  powerpc         |  ok  | TODO | TODO | TODO |  ok  |  ok  | TODO |  ok  |  ok  |
+  s390            |  ok  |  ok  | TODO | TODO |  ok  |  ok  | TODO |  ok  |  ok  |
+  score           | TODO | TODO | TODO | TODO | TODO | TODO | TODO | TODO | TODO |
+  sh              | TODO | TODO | TODO | TODO |  ok  |  ok  | TODO |  ok  |  ok  |
+  sparc           |  ok  | TODO | TODO | TODO |  ok  | TODO | TODO |  ok  |  ok  |
+  tile            |  ok  | TODO | TODO | TODO |  ok  |  ok  | TODO |  ok  | TODO |
+  um              | TODO | TODO | TODO | TODO | TODO | TODO | TODO | TODO | TODO |
+  unicore32       | TODO | TODO | TODO | TODO | TODO | TODO | TODO |  ok  | TODO |
+  x86             |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
+  xtensa          | TODO | TODO | TODO | TODO | TODO | TODO | TODO | TODO |  ok  |
+----------------------------------------------------------------------------------
+
+
+      irq time acct: HAVE_IRQ_TIME_ACCOUNTING
+                THP: HAVE_ARCH_TRANSPARENT_HUGEPAGE && 64BIT
+   gcov profile all: ARCH_HAS_GCOV_PROFILE_ALL
+    rwsem optimized: Optimized asm/rwsem.h
+   queued spinlocks: ARCH_USE_QUEUED_SPINLOCKS
+     queued rwlocks: ARCH_USE_QUEUED_RWLOCKS
+     numa balancing: ARCH_SUPPORTS_NUMA_BALANCING && 64BIT && NUMA
+
+      irq time acct:-------------------------------------------.
+                THP:------------------------------------.      |
+   gcov profile all:-----------------------------.      |      |
+    rwsem optimized:----------------------.      |      |      |
+   queued spinlocks:---------------.      |      |      |      |
+     queued rwlocks:--------.      |      |      |      |      |
+     numa balancing:-.      |      |      |      |      |      |
+                     |      |      |      |      |      |      |
+--------------------------------------------------------------------
+  alpha           | TODO | TODO | TODO |  ok  | TODO | TODO | TODO |
+  arc             |  ..  | TODO | TODO | TODO | TODO |  ..  | TODO |
+  arm             |  ..  | TODO | TODO | TODO |  ok  |  ok  |  ok  |
+  arm64           |  ..  | TODO | TODO | TODO |  ok  |  ok  | TODO |
+  avr32           |  ..  | TODO | TODO | TODO | TODO |  ..  | TODO |
+  blackfin        |  ..  | TODO | TODO | TODO | TODO |  ..  | TODO |
+  c6x             |  ..  | TODO | TODO | TODO | TODO |  ..  | TODO |
+  cris            |  ..  | TODO | TODO | TODO | TODO |  ..  | TODO |
+  frv             |  ..  | TODO | TODO | TODO | TODO |  ..  | TODO |
+  hexagon         |  ..  | TODO | TODO | TODO | TODO |  ..  | TODO |
+  ia64            | TODO | TODO | TODO |  ok  | TODO | TODO | TODO |
+  m32r            |  ..  | TODO | TODO | TODO | TODO |  ..  | TODO |
+  m68k            |  ..  | TODO | TODO | TODO | TODO |  ..  | TODO |
+  metag           |  ..  | TODO | TODO | TODO | TODO |  ..  | TODO |
+  microblaze      |  ..  | TODO | TODO | TODO |  ok  |  ..  | TODO |
+  mips            | TODO | TODO | TODO | TODO | TODO |  ok  |  ok  |
+  mn10300         |  ..  | TODO | TODO | TODO | TODO |  ..  | TODO |
+  nios2           |  ..  | TODO | TODO | TODO | TODO |  ..  | TODO |
+  openrisc        |  ..  | TODO | TODO | TODO | TODO |  ..  | TODO |
+  parisc          |  ..  | TODO | TODO | TODO | TODO | TODO | TODO |
+  powerpc         |  ok  | TODO | TODO | TODO |  ok  |  ok  | TODO |
+  s390            |  ..  | TODO | TODO |  ok  |  ok  |  ok  | TODO |
+  score           |  ..  | TODO | TODO | TODO | TODO |  ..  | TODO |
+  sh              |  ..  | TODO | TODO |  ok  |  ok  |  ..  | TODO |
+  sparc           | TODO | TODO | TODO |  ok  | TODO |  ok  | TODO |
+  tile            | TODO | TODO | TODO | TODO | TODO | TODO | TODO |
+  um              |  ..  | TODO | TODO | TODO | TODO |  ..  | TODO |
+  unicore32       |  ..  | TODO | TODO | TODO | TODO |  ..  | TODO |
+  x86             |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
+  xtensa          |  ..  | TODO | TODO |  ok  | TODO |  ..  |  ok  |
+--------------------------------------------------------------------
