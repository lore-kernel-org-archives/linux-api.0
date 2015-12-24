From: Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>
Subject: Re: [RFC PATCH v2 2/3] thread_local_abi: wire up x86 32/64 system call
Date: Wed, 23 Dec 2015 19:42:14 -0800
Message-ID: <1ECDFB6F-7C34-4BBB-A45F-E0D9A4B70737@joshtriplett.org>
References: <1450807333-22104-1-git-send-email-mathieu.desnoyers@efficios.com> <1450807333-22104-2-git-send-email-mathieu.desnoyers@efficios.com>
Mime-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1450807333-22104-2-git-send-email-mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>, Paul Turner <pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrew Hunter <ahh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Russell King <linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Andi Kleen <andi-Vw/NltI1exuRpAAqCnN02g@public.gmane.org>, Dave Watson <davejwatson-b10kYP2dOMg@public.gmane.org>, Chris Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Ben Maurer <bmaurer-b10kYP2dOMg@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, "Paul E. McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On December 22, 2015 10:02:12 AM PST, Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org> wrote:
>Wire up the thread local ABI on x86 32/64. Call the
>thread_local_abi_handle_notify_resume() function on return to
>userspace if TIF_NOTIFY_RESUME thread flag is set.
>
>This provides an ABI improving the speed of a getcpu operation
>on x86 by removing the need to perform a function call, "lsl"
>instruction, or system call on the fast path.
>
>Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
>CC: Russell King <linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org>
>CC: Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>
>CC: Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>
>CC: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
>CC: Paul Turner <pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
>CC: Andrew Hunter <ahh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
>CC: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
>CC: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
>CC: Andi Kleen <andi-Vw/NltI1exuRpAAqCnN02g@public.gmane.org>
>CC: Dave Watson <davejwatson-b10kYP2dOMg@public.gmane.org>
>CC: Chris Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
>CC: Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>CC: Ben Maurer <bmaurer-b10kYP2dOMg@public.gmane.org>
>CC: Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>
>CC: "Paul E. McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
>CC: Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>
>CC: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
>CC: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
>CC: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
>CC: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>---
> arch/x86/entry/common.c                | 2 ++
> arch/x86/entry/syscalls/syscall_32.tbl | 1 +
> arch/x86/entry/syscalls/syscall_64.tbl | 1 +
> 3 files changed, 4 insertions(+)
>
>diff --git a/arch/x86/entry/common.c b/arch/x86/entry/common.c
>index a89fdbc..222cacf 100644
>--- a/arch/x86/entry/common.c
>+++ b/arch/x86/entry/common.c
>@@ -249,6 +249,8 @@ static void exit_to_usermode_loop(struct pt_regs
>*regs, u32 cached_flags)
> 		if (cached_flags & _TIF_NOTIFY_RESUME) {
> 			clear_thread_flag(TIF_NOTIFY_RESUME);
> 			tracehook_notify_resume(regs);
>+			if (thread_local_abi_active(current))
>+				thread_local_abi_handle_notify_resume(current);

Every caller seems likely to duplicate this pattern; why not make the call itself a static inline containing this check and call (or no-op if compiled out)?
