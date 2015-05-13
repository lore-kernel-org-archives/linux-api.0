From: Ingo Molnar <mingo@kernel.org>
Subject: [RFC PATCH v2] Documentation/arch: Add Documentation/arch-TODO
Date: Wed, 13 May 2015 10:56:36 +0200
Message-ID: <20150513085636.GA11030@gmail.com>
References: <20150511192918.GA11361@jtriplet-mobl1>
 <20150512142250.dcb053da81855ae1b5861173@linux-foundation.org>
 <20150512213843.GV21418@twins.programming.kicks-ass.net>
 <20150512144910.0b49c9a7a13336773449db33@linux-foundation.org>
 <20150513083441.GA17336@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-arch-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20150513083441.GA17336@gmail.com>
Sender: linux-arch-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, Jonathan Corbet <corbet@lwn.net>
Cc: Peter Zijlstra <peterz@infradead.org>, Josh Triplett <josh@joshtriplett.org>, Andy Lutomirski <luto@amacapital.net>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>, Linus Torvalds <torvalds@linux-foundation.org>, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org, linux-arch@vger.kernel.org, Borislav Petkov <bp@alien8.de>
List-Id: linux-api@vger.kernel.org


Added a second table with more features listed.

Thanks,

	Ingo

=======================>
>From 32acc8a058a166d177346cfe59b6bc930f9e6471 Mon Sep 17 00:00:00 2001
From: Ingo Molnar <mingo@kernel.org>
Date: Wed, 13 May 2015 10:30:11 +0200
Subject: [PATCH] Documentation/arch: Add Documentation/arch-TODO

Add a TODO list for missing/incomplete architecture support
for generic kernel features.

Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 Documentation/arch-TODO | 89 +++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 89 insertions(+)

diff --git a/Documentation/arch-TODO b/Documentation/arch-TODO
new file mode 100644
index 000000000000..adf05e4c353f
--- /dev/null
+++ b/Documentation/arch-TODO
@@ -0,0 +1,89 @@
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
+  powerpc         |  ok  | TODO |  ok  | TODO | TODO |  ok  |  ok  |  ok  |  ok  |
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
