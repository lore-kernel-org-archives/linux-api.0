From: Francis Giraldeau <francis.giraldeau-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Ping: [PATCH v15 00/13] support "task_isolation" mode
Date: Thu, 8 Sep 2016 12:21:39 -0400
Message-ID: <f06314d5-9aee-b6e2-06dc-69bf6c0a9504@gmail.com>
References: <1471382376-5443-1-git-send-email-cmetcalf@mellanox.com>
 <d00bbe64-6e2c-51ce-1dfb-72ef1c4a04fa@mellanox.com>
 <057a958c-4491-b449-ae59-7d331afc872d@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <057a958c-4491-b449-ae59-7d331afc872d-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Chris Metcalf <cmetcalf-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Gilad Ben Yossef <giladb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Rik van Riel <riel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Frederic Weisbecker <fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, "Paul E. McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Viresh Kumar <viresh.kumar-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Daniel Lezcano <daniel.lezcano-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On 2016-09-07 05:11 PM, Francis Giraldeau wrote:
> The syscall test fails on x86:
>     $ sudo ./isolation
>     [...]
>     test_syscall: FAIL (0x100)
>     test_syscall (SIGUSR1): FAIL (0x100)

The fix is indeed very simple:

diff --git a/arch/x86/include/asm/thread_info.h b/arch/x86/include/asm/thread_info.h
index 7255367..449e2b5 100644
--- a/arch/x86/include/asm/thread_info.h
+++ b/arch/x86/include/asm/thread_info.h
@@ -139,7 +139,7 @@ struct thread_info {
 #define _TIF_WORK_SYSCALL_ENTRY        \
        (_TIF_SYSCALL_TRACE | _TIF_SYSCALL_EMU | _TIF_SYSCALL_AUDIT |   \
         _TIF_SECCOMP | _TIF_SYSCALL_TRACEPOINT |       \
-        _TIF_NOHZ)
+        _TIF_NOHZ | _TIF_TASK_ISOLATION)
 
 /* work to do on any return to user space */
 #define _TIF_ALLWORK_MASK                                              \


I updated the branch accordingly:

https://github.com/giraldeau/linux/commit/057761af7bde087fa10aa42554a13a7b69071938

Thanks,

Francis
