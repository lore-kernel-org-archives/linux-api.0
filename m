From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: [RFC PATCH v2 2/3] thread_local_abi: wire up x86 32/64 system call
Date: Tue, 22 Dec 2015 13:02:12 -0500
Message-ID: <1450807333-22104-2-git-send-email-mathieu.desnoyers@efficios.com>
References: <1450807333-22104-1-git-send-email-mathieu.desnoyers@efficios.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1450807333-22104-1-git-send-email-mathieu.desnoyers@efficios.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Paul Turner <pjt@google.com>, Andrew Hunter <ahh@google.com>, Thomas Gleixner <tglx@linutronix.de>, Michael Kerrisk <mtk.manpages@gmail.com>, Russell King <linux@arm.linux.org.uk>
Cc: linux-kernel@vger.kernel.org, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Peter Zijlstra <peterz@infradead.org>, Andy Lutomirski <luto@amacapital.net>, Andi Kleen <andi@firstfloor.org>, Dave Watson <davejwatson@fb.com>, Chris Lameter <cl@linux.com>, Ingo Molnar <mingo@redhat.com>, Ben Maurer <bmaurer@fb.com>, Steven Rostedt <rostedt@goodmis.org>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Josh Triplett <josh@joshtriplett.org>, Linus Torvalds <torvalds@linux-foundation.org>, Andrew Morton <akpm@linux-foundation.org>, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Wire up the thread local ABI on x86 32/64. Call the
thread_local_abi_handle_notify_resume() function on return to
userspace if TIF_NOTIFY_RESUME thread flag is set.

This provides an ABI improving the speed of a getcpu operation
on x86 by removing the need to perform a function call, "lsl"
instruction, or system call on the fast path.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
CC: Russell King <linux@arm.linux.org.uk>
CC: Catalin Marinas <catalin.marinas@arm.com>
CC: Will Deacon <will.deacon@arm.com>
CC: Thomas Gleixner <tglx@linutronix.de>
CC: Paul Turner <pjt@google.com>
CC: Andrew Hunter <ahh@google.com>
CC: Peter Zijlstra <peterz@infradead.org>
CC: Andy Lutomirski <luto@amacapital.net>
CC: Andi Kleen <andi@firstfloor.org>
CC: Dave Watson <davejwatson@fb.com>
CC: Chris Lameter <cl@linux.com>
CC: Ingo Molnar <mingo@redhat.com>
CC: Ben Maurer <bmaurer@fb.com>
CC: Steven Rostedt <rostedt@goodmis.org>
CC: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
CC: Josh Triplett <josh@joshtriplett.org>
CC: Linus Torvalds <torvalds@linux-foundation.org>
CC: Andrew Morton <akpm@linux-foundation.org>
CC: Thomas Gleixner <tglx@linutronix.de>
CC: linux-api@vger.kernel.org
---
 arch/x86/entry/common.c                | 2 ++
 arch/x86/entry/syscalls/syscall_32.tbl | 1 +
 arch/x86/entry/syscalls/syscall_64.tbl | 1 +
 3 files changed, 4 insertions(+)

diff --git a/arch/x86/entry/common.c b/arch/x86/entry/common.c
index a89fdbc..222cacf 100644
--- a/arch/x86/entry/common.c
+++ b/arch/x86/entry/common.c
@@ -249,6 +249,8 @@ static void exit_to_usermode_loop(struct pt_regs *regs, u32 cached_flags)
 		if (cached_flags & _TIF_NOTIFY_RESUME) {
 			clear_thread_flag(TIF_NOTIFY_RESUME);
 			tracehook_notify_resume(regs);
+			if (thread_local_abi_active(current))
+				thread_local_abi_handle_notify_resume(current);
 		}
 
 		if (cached_flags & _TIF_USER_RETURN_NOTIFY)
diff --git a/arch/x86/entry/syscalls/syscall_32.tbl b/arch/x86/entry/syscalls/syscall_32.tbl
index f17705e..c6c385e 100644
--- a/arch/x86/entry/syscalls/syscall_32.tbl
+++ b/arch/x86/entry/syscalls/syscall_32.tbl
@@ -383,3 +383,4 @@
 374	i386	userfaultfd		sys_userfaultfd
 375	i386	membarrier		sys_membarrier
 376	i386	mlock2			sys_mlock2
+377	i386	thread_local_abi	sys_thread_local_abi
diff --git a/arch/x86/entry/syscalls/syscall_64.tbl b/arch/x86/entry/syscalls/syscall_64.tbl
index 314a90b..748aee3 100644
--- a/arch/x86/entry/syscalls/syscall_64.tbl
+++ b/arch/x86/entry/syscalls/syscall_64.tbl
@@ -332,6 +332,7 @@
 323	common	userfaultfd		sys_userfaultfd
 324	common	membarrier		sys_membarrier
 325	common	mlock2			sys_mlock2
+326	common	thread_local_abi	sys_thread_local_abi
 
 #
 # x32-specific system call numbers start at 512 to avoid cache impact
-- 
2.1.4
