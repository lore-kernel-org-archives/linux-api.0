From: =?UTF-8?Q?Ren=c3=a9_Nyffenegger?= <mail@renenyffenegger.ch>
Subject: [PATCH] Use pid_t instead of int
Date: Sun, 8 May 2016 21:38:02 +0200
Message-ID: <572F959A.7090209@renenyffenegger.ch>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, Josh Triplett <josh@joshtriplett.org>, Al Viro <viro@zeniv.linux.org.uk>, "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>, Zach Brown <zab@redhat.com>, Milosz Tanski <milosz@adfin.com>, Arnd Bergmann <arnd@arndb.de>, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: =?UTF-8?Q?Ren=c3=a9_Nyffenegger?= <mail@renenyffenegger.ch>
List-Id: linux-api@vger.kernel.org

Use pid_t instead of int in the declarations of sys_kill, sys_tgkill,
sys_tkill and sys_rt_sigqueueinfo in include/linux/syscalls.h

Signed-off-by: Ren=C3=A9 Nyffenegger <mail@renenyffenegger.ch>
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
+asmlinkage long sys_tgkill(int tgid, pid_t pid, int sig);
+asmlinkage long sys_tkill(pid_t pid, int sig);
+asmlinkage long sys_rt_sigqueueinfo(pid_t pid, int sig, siginfo_t __us=
er *uinfo);
 asmlinkage long sys_sgetmask(void);
 asmlinkage long sys_ssetmask(int newmask);
 asmlinkage long sys_signal(int sig, __sighandler_t handler);
--=20
2.8.0
