From: =?UTF-8?Q?Ren=c3=a9_Nyffenegger?= <mail-gLCNRsNSrVdVZEhyV+6z5nIPMjoJpjVV@public.gmane.org>
Subject: Re: [PATCH] Use pid_t instead of int
Date: Mon, 9 May 2016 08:36:10 +0200
Message-ID: <57302FDA.7020205@renenyffenegger.ch>
References: <572F959A.7090209@renenyffenegger.ch>
 <CALCETrVyT6R6mYnVuv9vqmeCC7_TB2KZPCqfcmMyLvjbZPs+Ag@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CALCETrVyT6R6mYnVuv9vqmeCC7_TB2KZPCqfcmMyLvjbZPs+Ag-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>, Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, "Steven Rostedt (Red Hat)" <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Zach Brown <zab-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Milosz Tanski <milosz-B5zB6C1i6pkAvxtiuMwx3w@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, =?UTF-8?Q?Ren=c3=a9_Nyffenegger?= <mail-gLCNRsNSrVdVZEhyV+6z5nIPMjoJpjVV@public.gmane.org>
List-Id: linux-api@vger.kernel.org

=46rom: Ren=C3=A9 Nyffenegger <mail-gLCNRsNSrVdVZEhyV+6z5nIPMjoJpjVV@public.gmane.org>

In include/linux/syscalls.h, the four functions sys_kill, sys_tgkill,
sys_tkill and sys_rt_sigqueueinfo are declared with "int pid" and
"int tgid".

However, in kernel/signal.c, the corresponding definitions use
the more appropriate "pid_t" (which is a typedef'd int).

This patch changes "int" to "pid_t" in the declarations of
sys_kill, sys_tgkill, sys_tkill and sys_rt_sigqueueinfo in
include/linux/syscalls.h in order to harmonize the function
declarations with their respective definitions.

Signed-off-by: Ren=C3=A9 Nyffenegger <mail-gLCNRsNSrVdVZEhyV+6z5nIPMjoJpjVV@public.gmane.org>
---
 include/linux/syscalls.h | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
index d795472..d507e75 100644
--- a/include/linux/syscalls.h
+++ b/include/linux/syscalls.h
@@ -371,10 +371,10 @@ asmlinkage long sys_rt_sigtimedwait(const sigset_=
t __user *uthese,
 				size_t sigsetsize);
 asmlinkage long sys_rt_tgsigqueueinfo(pid_t tgid, pid_t  pid, int sig,
 		siginfo_t __user *uinfo);
-asmlinkage long sys_kill(int pid, int sig);
-asmlinkage long sys_tgkill(int tgid, int pid, int sig);
-asmlinkage long sys_tkill(int pid, int sig);
-asmlinkage long sys_rt_sigqueueinfo(int pid, int sig, siginfo_t __user=
 *uinfo);
+asmlinkage long sys_kill(pid_t pid, int sig);
+asmlinkage long sys_tgkill(pid_t tgid, pid_t pid, int sig);
+asmlinkage long sys_tkill(pid_t pid, int sig);
+asmlinkage long sys_rt_sigqueueinfo(pid_t pid, int sig, siginfo_t __us=
er *uinfo);
 asmlinkage long sys_sgetmask(void);
 asmlinkage long sys_ssetmask(int newmask);
 asmlinkage long sys_signal(int sig, __sighandler_t handler);
--=20
2.8.0
