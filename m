From: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [RFC PATCH v5] Documentation/arch: Add Documentation/arch-TODO
Date: Wed, 13 May 2015 11:47:56 +0200
Message-ID: <20150513094756.GD11030@gmail.com>
References: <20150511192918.GA11361@jtriplet-mobl1>
 <20150512142250.dcb053da81855ae1b5861173@linux-foundation.org>
 <20150512213843.GV21418@twins.programming.kicks-ass.net>
 <20150512144910.0b49c9a7a13336773449db33@linux-foundation.org>
 <20150513083441.GA17336@gmail.com>
 <20150513085636.GA11030@gmail.com>
 <20150513092421.GB11030@gmail.com>
 <20150513094622.GC11030@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20150513094622.GC11030-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>
Cc: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-arch-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>
List-Id: linux-api@vger.kernel.org


(fixed the subject.)

So this is the final version for now:

 - add a fourth table

 - fix errors in earlier tables, in particular I missed some PowerPC 
   Kconfigs

 - introduce the '..' denotion (in the final table) to show features 
   that cannot be supported by an architecture due to hardware 
   dependencies:

		   gcov-profile-all:---------------.
				THP:--------.      |
		      irq-time-acct:-.      |      |
				     |      |      |
		----------------------------------------
		  alpha           | TODO | TODO | TODO |
		  arc             | TODO |  ..  | TODO |
		  arm             |  ok  |  ok  |  ok  |
		  arm64           | TODO |  ok  |  ok  |
		  avr32           | TODO |  ..  | TODO |
		  blackfin        | TODO |  ..  | TODO |
		  c6x             | TODO |  ..  | TODO |

   so in the 'THP' column, if an architecture could in theory support 
   THP, it's listed as 'TODO', if it cannot, it's listed as '..'.

Please let me know about errors in these tables, and I can also add 
more features/facilities as well if I missed any.

Thanks,

    Ingo

==========================>
>From a44b9e91788a2628e1223d143024de4572a924c3 Mon Sep 17 00:00:00 2001
From: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Date: Wed, 13 May 2015 10:30:11 +0200
Subject: [PATCH] Documentation/arch: Add Documentation/arch-TODO

Add a TODO list for missing/incomplete architecture support
for generic kernel features.

Signed-off-by: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 Documentation/arch-TODO | 169 ++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 169 insertions(+)

diff --git a/Documentation/arch-TODO b/Documentation/arch-TODO
new file mode 100644
index 000000000000..0880914e1eaf
--- /dev/null
+++ b/Documentation/arch-TODO
@@ -0,0 +1,169 @@
+
+For generic kernel features that need architecture support, this is
+the feature support matrix, for all upstream Linux architectures:
+
+           ELF-ASLR:---------------------------------------------------------.
+        clockevents:--------------------------------------------------.      |
+ modern-timekeeping:-------------------------------------------.      |      |
+               kgdb:------------------------------------.      |      |      |
+   context-tracking:-----------------------------.      |      |      |      |
+     seccomp-filter:----------------------.      |      |      |      |      |
+        jump-labels:---------------.      |      |      |      |      |      |
+     stackprotector:--------.      |      |      |      |      |      |      |
+            lockdep:-.      |      |      |      |      |      |      |      |
+                     |      |      |      |      |      |      |      |      |
+----------------------------------------------------------------------------------
+  alpha           | TODO | TODO | TODO | TODO | TODO | TODO |  ok  |  ok  | TODO |
+  arc             |  ok  | TODO | TODO | TODO | TODO |  ok  |  ok  |  ok  | TODO |
+  arm             |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  | TODO |  ok  |  ok  |
+  arm64           |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
+  avr32           |  ok  | TODO | TODO | TODO | TODO | TODO |  ok  |  ok  | TODO |
+  blackfin        |  ok  | TODO | TODO | TODO | TODO |  ok  | TODO |  ok  | TODO |
+  c6x             | TODO | TODO | TODO | TODO | TODO | TODO |  ok  |  ok  | TODO |
+  cris            | TODO | TODO | TODO | TODO | TODO | TODO | TODO |  ok  | TODO |
+  frv             | TODO | TODO | TODO | TODO | TODO | TODO |  ok  | TODO | TODO |
+  hexagon         |  ok  | TODO | TODO | TODO | TODO |  ok  |  ok  |  ok  | TODO |
+  ia64            | TODO | TODO | TODO | TODO | TODO | TODO |  ok  | TODO | TODO |
+  m32r            | TODO | TODO | TODO | TODO | TODO | TODO | TODO | TODO | TODO |
+  m68k            | TODO | TODO | TODO | TODO | TODO | TODO | TODO |  ok  | TODO |
+  metag           |  ok  | TODO | TODO | TODO | TODO | TODO |  ok  |  ok  | TODO |
+  microblaze      |  ok  | TODO | TODO | TODO | TODO |  ok  |  ok  |  ok  | TODO |
+  mips            |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
+  mn10300         | TODO | TODO | TODO | TODO | TODO |  ok  |  ok  |  ok  | TODO |
+  nios2           | TODO | TODO | TODO | TODO | TODO |  ok  |  ok  |  ok  | TODO |
+  openrisc        | TODO | TODO | TODO | TODO | TODO | TODO |  ok  |  ok  | TODO |
+  parisc          | TODO | TODO | TODO | TODO | TODO | TODO |  ok  | TODO | TODO |
+  powerpc         |  ok  | TODO |  ok  | TODO |  ok  |  ok  |  ok  |  ok  |  ok  |
+  s390            |  ok  | TODO |  ok  |  ok  | TODO | TODO |  ok  |  ok  |  ok  |
+  score           |  ok  | TODO | TODO | TODO | TODO | TODO |  ok  |  ok  | TODO |
+  sh              |  ok  |  ok  | TODO | TODO | TODO |  ok  |  ok  |  ok  | TODO |
+  sparc           |  ok  | TODO |  ok  | TODO |  ok  |  ok  |  ok  |  ok  | TODO |
+  tile            |  ok  | TODO | TODO | TODO |  ok  |  ok  |  ok  |  ok  | TODO |
+  um              |  ok  | TODO | TODO | TODO | TODO | TODO |  ok  |  ok  | TODO |
+  unicore32       |  ok  | TODO | TODO | TODO | TODO | TODO |  ok  |  ok  | TODO |
+  x86             |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
+  xtensa          |  ok  | TODO | TODO | TODO | TODO | TODO |  ok  |  ok  | TODO |
+----------------------------------------------------------------------------------
+
+          tracehook:---------------------------------------------------------.
+     ioremap_prot():--------------------------------------------------.      |
+  user-ret-profiler:-------------------------------------------.      |      |
+         kretprobes:------------------------------------.      |      |      |
+            uprobes:-----------------------------.      |      |      |      |
+  kprobes-on-ftrace:----------------------.      |      |      |      |      |
+          optprobes:---------------.      |      |      |      |      |      |
+            kprobes:--------.      |      |      |      |      |      |      |
+arch-tick-broadcast:-.      |      |      |      |      |      |      |      |
+                     |      |      |      |      |      |      |      |      |
+----------------------------------------------------------------------------------
+  alpha           | TODO | TODO | TODO | TODO | TODO | TODO | TODO | TODO | TODO |
+  arc             | TODO |  ok  | TODO | TODO | TODO |  ok  | TODO |  ok  |  ok  |
+  arm             |  ok  |  ok  |  ok  | TODO |  ok  |  ok  | TODO | TODO |  ok  |
+  arm64           |  ok  | TODO | TODO | TODO | TODO | TODO | TODO | TODO |  ok  |
+  avr32           | TODO |  ok  | TODO | TODO | TODO | TODO | TODO | TODO | TODO |
+  blackfin        | TODO | TODO | TODO | TODO | TODO | TODO | TODO | TODO |  ok  |
+  c6x             | TODO | TODO | TODO | TODO | TODO | TODO | TODO | TODO |  ok  |
+  cris            | TODO | TODO | TODO | TODO | TODO | TODO | TODO | TODO | TODO |
+  frv             | TODO | TODO | TODO | TODO | TODO | TODO | TODO | TODO |  ok  |
+  hexagon         | TODO | TODO | TODO | TODO | TODO | TODO | TODO | TODO |  ok  |
+  ia64            | TODO |  ok  | TODO | TODO | TODO |  ok  | TODO | TODO |  ok  |
+  m32r            | TODO | TODO | TODO | TODO | TODO | TODO | TODO | TODO | TODO |
+  m68k            | TODO | TODO | TODO | TODO | TODO | TODO | TODO | TODO | TODO |
+  metag           | TODO | TODO | TODO | TODO | TODO | TODO | TODO | TODO |  ok  |
+  microblaze      | TODO | TODO | TODO | TODO | TODO | TODO | TODO | TODO | TODO |
+  mips            |  ok  |  ok  | TODO | TODO | TODO |  ok  | TODO | TODO |  ok  |
+  mn10300         | TODO | TODO | TODO | TODO | TODO | TODO | TODO | TODO |  ok  |
+  nios2           | TODO | TODO | TODO | TODO | TODO | TODO | TODO | TODO |  ok  |
+  openrisc        | TODO | TODO | TODO | TODO | TODO | TODO | TODO | TODO |  ok  |
+  parisc          | TODO | TODO | TODO | TODO | TODO | TODO | TODO | TODO | TODO |
+  powerpc         |  ok  |  ok  | TODO | TODO |  ok  |  ok  | TODO |  ok  |  ok  |
+  s390            | TODO |  ok  | TODO | TODO |  ok  |  ok  | TODO | TODO |  ok  |
+  score           | TODO | TODO | TODO | TODO | TODO | TODO | TODO | TODO | TODO |
+  sh              | TODO |  ok  | TODO | TODO | TODO |  ok  | TODO |  ok  |  ok  |
+  sparc           | TODO |  ok  | TODO | TODO | TODO |  ok  | TODO | TODO |  ok  |
+  tile            | TODO |  ok  |  ok  | TODO | TODO |  ok  |  ok  |  ok  |  ok  |
+  um              | TODO | TODO | TODO | TODO | TODO | TODO | TODO | TODO | TODO |
+  unicore32       | TODO | TODO | TODO | TODO | TODO | TODO | TODO | TODO | TODO |
+  x86             | TODO |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
+  xtensa          | TODO | TODO | TODO | TODO | TODO | TODO | TODO | TODO | TODO |
+----------------------------------------------------------------------------------
+
+       virt-cpuacct:---------------------------------------------------------.
+      cmpxchg-local:--------------------------------------------------.      |
+     perf-stackdump:-------------------------------------------.      |      |
+          perf-regs:------------------------------------.      |      |      |
+      dma-api-debug:-----------------------------.      |      |      |      |
+      kprobes-event:----------------------.      |      |      |      |      |
+     dma-contiguous:---------------.      |      |      |      |      |      |
+  dma_*map*_attrs():--------.      |      |      |      |      |      |      |
+generic-idle-thread:-.      |      |      |      |      |      |      |      |
+                     |      |      |      |      |      |      |      |      |
+----------------------------------------------------------------------------------
+  alpha           |  ok  |  ok  | TODO | TODO | TODO | TODO | TODO | TODO |  ok  |
+  arc             |  ok  | TODO | TODO | TODO | TODO | TODO | TODO | TODO | TODO |
+  arm             |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  | TODO |  ok  |
+  arm64           |  ok  |  ok  |  ok  | TODO |  ok  |  ok  |  ok  | TODO |  ok  |
+  avr32           | TODO | TODO | TODO | TODO | TODO | TODO | TODO | TODO | TODO |
+  blackfin        |  ok  | TODO | TODO | TODO | TODO | TODO | TODO | TODO | TODO |
+  c6x             | TODO | TODO | TODO | TODO |  ok  | TODO | TODO | TODO | TODO |
+  cris            | TODO | TODO | TODO | TODO | TODO | TODO | TODO | TODO | TODO |
+  frv             | TODO | TODO | TODO | TODO | TODO | TODO | TODO | TODO | TODO |
+  hexagon         |  ok  |  ok  | TODO |  ok  | TODO | TODO | TODO | TODO | TODO |
+  ia64            |  ok  |  ok  | TODO | TODO |  ok  | TODO | TODO | TODO |  ok  |
+  m32r            | TODO | TODO | TODO | TODO | TODO | TODO | TODO | TODO | TODO |
+  m68k            | TODO | TODO | TODO | TODO | TODO | TODO | TODO | TODO | TODO |
+  metag           |  ok  | TODO | TODO | TODO | TODO | TODO | TODO | TODO | TODO |
+  microblaze      | TODO |  ok  | TODO | TODO |  ok  | TODO | TODO | TODO | TODO |
+  mips            |  ok  |  ok  |  ok  | TODO |  ok  | TODO | TODO | TODO |  ok  |
+  mn10300         | TODO | TODO | TODO | TODO | TODO | TODO | TODO | TODO | TODO |
+  nios2           | TODO | TODO | TODO | TODO | TODO | TODO | TODO | TODO | TODO |
+  openrisc        | TODO |  ok  | TODO | TODO | TODO | TODO | TODO | TODO | TODO |
+  parisc          |  ok  | TODO | TODO | TODO | TODO | TODO | TODO | TODO |  ok  |
+  powerpc         |  ok  |  ok  | TODO |  ok  |  ok  | TODO | TODO | TODO |  ok  |
+  s390            |  ok  |  ok  | TODO |  ok  |  ok  | TODO | TODO |  ok  |  ok  |
+  score           | TODO | TODO | TODO | TODO | TODO | TODO | TODO | TODO | TODO |
+  sh              |  ok  |  ok  | TODO |  ok  |  ok  | TODO | TODO | TODO | TODO |
+  sparc           |  ok  |  ok  | TODO | TODO |  ok  | TODO | TODO | TODO |  ok  |
+  tile            | TODO |  ok  | TODO |  ok  |  ok  | TODO | TODO | TODO |  ok  |
+  um              | TODO | TODO | TODO | TODO | TODO | TODO | TODO | TODO | TODO |
+  unicore32       | TODO |  ok  | TODO | TODO | TODO | TODO | TODO | TODO | TODO |
+  x86             |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
+  xtensa          |  ok  | TODO | TODO | TODO | TODO | TODO | TODO | TODO | TODO |
+----------------------------------------------------------------------------------
+
+   gcov-profile-all:---------------.
+                THP:--------.      |
+      irq-time-acct:-.      |      |
+                     |      |      |
+----------------------------------------
+  alpha           | TODO | TODO | TODO |
+  arc             | TODO |  ..  | TODO |
+  arm             |  ok  |  ok  |  ok  |
+  arm64           | TODO |  ok  |  ok  |
+  avr32           | TODO |  ..  | TODO |
+  blackfin        | TODO |  ..  | TODO |
+  c6x             | TODO |  ..  | TODO |
+  cris            | TODO |  ..  | TODO |
+  frv             | TODO |  ..  | TODO |
+  hexagon         | TODO |  ..  | TODO |
+  ia64            | TODO | TODO | TODO |
+  m32r            | TODO |  ..  | TODO |
+  m68k            | TODO |  ..  | TODO |
+  metag           | TODO |  ..  | TODO |
+  microblaze      | TODO |  ..  |  ok  |
+  mips            |  ok  |  ok  | TODO |
+  mn10300         | TODO |  ..  | TODO |
+  nios2           | TODO |  ..  | TODO |
+  openrisc        | TODO |  ..  | TODO |
+  parisc          | TODO | TODO | TODO |
+  powerpc         | TODO |  ok  |  ok  |
+  s390            | TODO |  ok  |  ok  |
+  score           | TODO |  ..  | TODO |
+  sh              | TODO |  ..  |  ok  |
+  sparc           | TODO |  ok  | TODO |
+  tile            | TODO | TODO | TODO |
+  um              | TODO |  ..  | TODO |
+  unicore32       | TODO |  ..  | TODO |
+  x86             |  ok  |  ok  |  ok  |
+  xtensa          |  ok  |  ..  | TODO |
+----------------------------------------
