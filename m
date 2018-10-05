From: ebiederm@xmission.com (Eric W. Biederman)
Subject: [REVIEW][PATCH 7/6] signal: In sigqueueinfo prefer sig not si_signo
Date: Fri, 05 Oct 2018 09:10:47 +0200
Message-ID: <87woqwamx4.fsf_-_@xmission.com>
References: <87h8idv6nw.fsf@xmission.com>
        <20180925171906.19683-2-ebiederm@xmission.com>
        <20181005060611.GA19061@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181005060611.GA19061@gmail.com> (Andrei Vagin's message of
        "Thu, 4 Oct 2018 23:06:13 -0700")
Sender: linux-kernel-owner@vger.kernel.org
To: Andrei Vagin <avagin@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, linux-arch@vger.kernel.org, Oleg Nesterov <oleg@redhat.com>, Linus Torvalds <torvalds@linux-foundation.org>
List-Id: linux-api@vger.kernel.org


Andrei Vagin <avagin@gmail.com> reported:

> Accoding to the man page, the user should not set si_signo, it has to be set
> by kernel.
>
> $ man 2 rt_sigqueueinfo
>
>     The uinfo argument specifies the data to accompany  the  signal.   This
>        argument  is  a  pointer to a structure of type siginfo_t, described in
>        sigaction(2) (and defined  by  including  <sigaction.h>).   The  caller
>        should set the following fields in this structure:
>
>        si_code
>               This  must  be  one of the SI_* codes in the Linux kernel source
>               file include/asm-generic/siginfo.h, with  the  restriction  that
>               the  code  must  be  negative (i.e., cannot be SI_USER, which is
>               used by the kernel to indicate a signal  sent  by  kill(2))  and
>               cannot  (since  Linux  2.6.39) be SI_TKILL (which is used by the
>               kernel to indicate a signal sent using tgkill(2)).
>
>        si_pid This should be set to a process ID, typically the process ID  of
>               the sender.
>
>        si_uid This  should  be set to a user ID, typically the real user ID of
>               the sender.
>
>        si_value
>               This field contains the user data to accompany the signal.   For
>               more information, see the description of the last (union sigval)
>               argument of sigqueue(3).
>
>        Internally, the kernel sets the si_signo field to the  value  specified
>        in  sig,  so that the receiver of the signal can also obtain the signal
>        number via that field.
>
> On Tue, Sep 25, 2018 at 07:19:02PM +0200, Eric W. Biederman wrote:
>>
>> If there is some application that calls sigqueueinfo directly that has
>> a problem with this added sanity check we can revisit this when we see
>> what kind of crazy that application is doing.
>
>
> I already know two "applications" ;)
>
> https://github.com/torvalds/linux/blob/master/tools/testing/selftests/ptrace/peeksiginfo.c
> https://github.com/checkpoint-restore/criu/blob/master/test/zdtm/static/sigpending.c
>
> Disclaimer: I'm the author of both of them.

Looking at the kernel code the historical behavior has alwasy been to prefer
the signal number passed in by the kernel.

So sigh.  Implmenet __copy_siginfo_from_user and __copy_siginfo_from_user32 to
take that signal number and prefer it.  The user of ptrace will still
use copy_siginfo_from_user and copy_siginfo_from_user32 as they do not and
never have had a signal number there.

Luckily this change has never made it farther than linux-next.

Fixes: e75dc036c445 ("signal: Fail sigqueueinfo if si_signo != sig")
Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
---

Andrei can you verify this fixes your programs?
Thank you very much,
Eric


 kernel/signal.c | 141 ++++++++++++++++++++++++++++--------------------
 1 file changed, 84 insertions(+), 57 deletions(-)

diff --git a/kernel/signal.c b/kernel/signal.c
index 1c2dd117fee0..2bffc5a50183 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -2925,11 +2925,10 @@ int copy_siginfo_to_user(siginfo_t __user *to, const kernel_siginfo_t *from)
 	return 0;
 }
 
-int copy_siginfo_from_user(kernel_siginfo_t *to, const siginfo_t __user *from)
+static int post_copy_siginfo_from_user(kernel_siginfo_t *info,
+				       const siginfo_t __user *from)
 {
-	if (copy_from_user(to, from, sizeof(struct kernel_siginfo)))
-		return -EFAULT;
-	if (unlikely(!known_siginfo_layout(to->si_signo, to->si_code))) {
+	if (unlikely(!known_siginfo_layout(info->si_signo, info->si_code))) {
 		char __user *expansion = si_expansion(from);
 		char buf[SI_EXPANSION_SIZE];
 		int i;
@@ -2949,6 +2948,22 @@ int copy_siginfo_from_user(kernel_siginfo_t *to, const siginfo_t __user *from)
 	return 0;
 }
 
+static int __copy_siginfo_from_user(int signo, kernel_siginfo_t *to,
+				    const siginfo_t __user *from)
+{
+	if (copy_from_user(to, from, sizeof(struct kernel_siginfo)))
+		return -EFAULT;
+	to->si_signo = signo;
+	return post_copy_siginfo_from_user(to, from);
+}
+
+int copy_siginfo_from_user(kernel_siginfo_t *to, const siginfo_t __user *from)
+{
+	if (copy_from_user(to, from, sizeof(struct kernel_siginfo)))
+		return -EFAULT;
+	return post_copy_siginfo_from_user(to, from);
+}
+
 #ifdef CONFIG_COMPAT
 int copy_siginfo_to_user32(struct compat_siginfo __user *to,
 			   const struct kernel_siginfo *from)
@@ -3041,88 +3056,106 @@ int __copy_siginfo_to_user32(struct compat_siginfo __user *to,
 	return 0;
 }
 
-int copy_siginfo_from_user32(struct kernel_siginfo *to,
-			     const struct compat_siginfo __user *ufrom)
+static int post_copy_siginfo_from_user32(kernel_siginfo_t *to,
+					 const struct compat_siginfo *from)
 {
-	struct compat_siginfo from;
-
-	if (copy_from_user(&from, ufrom, sizeof(struct compat_siginfo)))
-		return -EFAULT;
-
 	clear_siginfo(to);
-	to->si_signo = from.si_signo;
-	to->si_errno = from.si_errno;
-	to->si_code  = from.si_code;
-	switch(siginfo_layout(from.si_signo, from.si_code)) {
+	to->si_signo = from->si_signo;
+	to->si_errno = from->si_errno;
+	to->si_code  = from->si_code;
+	switch(siginfo_layout(from->si_signo, from->si_code)) {
 	case SIL_KILL:
-		to->si_pid = from.si_pid;
-		to->si_uid = from.si_uid;
+		to->si_pid = from->si_pid;
+		to->si_uid = from->si_uid;
 		break;
 	case SIL_TIMER:
-		to->si_tid     = from.si_tid;
-		to->si_overrun = from.si_overrun;
-		to->si_int     = from.si_int;
+		to->si_tid     = from->si_tid;
+		to->si_overrun = from->si_overrun;
+		to->si_int     = from->si_int;
 		break;
 	case SIL_POLL:
-		to->si_band = from.si_band;
-		to->si_fd   = from.si_fd;
+		to->si_band = from->si_band;
+		to->si_fd   = from->si_fd;
 		break;
 	case SIL_FAULT:
-		to->si_addr = compat_ptr(from.si_addr);
+		to->si_addr = compat_ptr(from->si_addr);
 #ifdef __ARCH_SI_TRAPNO
-		to->si_trapno = from.si_trapno;
+		to->si_trapno = from->si_trapno;
 #endif
 		break;
 	case SIL_FAULT_MCEERR:
-		to->si_addr = compat_ptr(from.si_addr);
+		to->si_addr = compat_ptr(from->si_addr);
 #ifdef __ARCH_SI_TRAPNO
-		to->si_trapno = from.si_trapno;
+		to->si_trapno = from->si_trapno;
 #endif
-		to->si_addr_lsb = from.si_addr_lsb;
+		to->si_addr_lsb = from->si_addr_lsb;
 		break;
 	case SIL_FAULT_BNDERR:
-		to->si_addr = compat_ptr(from.si_addr);
+		to->si_addr = compat_ptr(from->si_addr);
 #ifdef __ARCH_SI_TRAPNO
-		to->si_trapno = from.si_trapno;
+		to->si_trapno = from->si_trapno;
 #endif
-		to->si_lower = compat_ptr(from.si_lower);
-		to->si_upper = compat_ptr(from.si_upper);
+		to->si_lower = compat_ptr(from->si_lower);
+		to->si_upper = compat_ptr(from->si_upper);
 		break;
 	case SIL_FAULT_PKUERR:
-		to->si_addr = compat_ptr(from.si_addr);
+		to->si_addr = compat_ptr(from->si_addr);
 #ifdef __ARCH_SI_TRAPNO
-		to->si_trapno = from.si_trapno;
+		to->si_trapno = from->si_trapno;
 #endif
-		to->si_pkey = from.si_pkey;
+		to->si_pkey = from->si_pkey;
 		break;
 	case SIL_CHLD:
-		to->si_pid    = from.si_pid;
-		to->si_uid    = from.si_uid;
-		to->si_status = from.si_status;
+		to->si_pid    = from->si_pid;
+		to->si_uid    = from->si_uid;
+		to->si_status = from->si_status;
 #ifdef CONFIG_X86_X32_ABI
 		if (in_x32_syscall()) {
-			to->si_utime = from._sifields._sigchld_x32._utime;
-			to->si_stime = from._sifields._sigchld_x32._stime;
+			to->si_utime = from->_sifields._sigchld_x32._utime;
+			to->si_stime = from->_sifields._sigchld_x32._stime;
 		} else
 #endif
 		{
-			to->si_utime = from.si_utime;
-			to->si_stime = from.si_stime;
+			to->si_utime = from->si_utime;
+			to->si_stime = from->si_stime;
 		}
 		break;
 	case SIL_RT:
-		to->si_pid = from.si_pid;
-		to->si_uid = from.si_uid;
-		to->si_int = from.si_int;
+		to->si_pid = from->si_pid;
+		to->si_uid = from->si_uid;
+		to->si_int = from->si_int;
 		break;
 	case SIL_SYS:
-		to->si_call_addr = compat_ptr(from.si_call_addr);
-		to->si_syscall   = from.si_syscall;
-		to->si_arch      = from.si_arch;
+		to->si_call_addr = compat_ptr(from->si_call_addr);
+		to->si_syscall   = from->si_syscall;
+		to->si_arch      = from->si_arch;
 		break;
 	}
 	return 0;
 }
+
+static int __copy_siginfo_from_user32(int signo, struct kernel_siginfo *to,
+				      const struct compat_siginfo __user *ufrom)
+{
+	struct compat_siginfo from;
+
+	if (copy_from_user(&from, ufrom, sizeof(struct compat_siginfo)))
+		return -EFAULT;
+
+	from.si_signo = signo;
+	return post_copy_siginfo_from_user32(to, &from);
+}
+
+int copy_siginfo_from_user32(struct kernel_siginfo *to,
+			     const struct compat_siginfo __user *ufrom)
+{
+	struct compat_siginfo from;
+
+	if (copy_from_user(&from, ufrom, sizeof(struct compat_siginfo)))
+		return -EFAULT;
+
+	return post_copy_siginfo_from_user32(to, &from);
+}
 #endif /* CONFIG_COMPAT */
 
 /**
@@ -3359,9 +3392,6 @@ static int do_rt_sigqueueinfo(pid_t pid, int sig, kernel_siginfo_t *info)
 	    (task_pid_vnr(current) != pid))
 		return -EPERM;
 
-	if (info->si_signo != sig)
-		return -EINVAL;
-
 	/* POSIX.1b doesn't mention process groups.  */
 	return kill_proc_info(sig, info, pid);
 }
@@ -3376,7 +3406,7 @@ SYSCALL_DEFINE3(rt_sigqueueinfo, pid_t, pid, int, sig,
 		siginfo_t __user *, uinfo)
 {
 	kernel_siginfo_t info;
-	int ret = copy_siginfo_from_user(&info, uinfo);
+	int ret = __copy_siginfo_from_user(sig, &info, uinfo);
 	if (unlikely(ret))
 		return ret;
 	return do_rt_sigqueueinfo(pid, sig, &info);
@@ -3389,7 +3419,7 @@ COMPAT_SYSCALL_DEFINE3(rt_sigqueueinfo,
 			struct compat_siginfo __user *, uinfo)
 {
 	kernel_siginfo_t info;
-	int ret = copy_siginfo_from_user32(&info, uinfo);
+	int ret = __copy_siginfo_from_user32(sig, &info, uinfo);
 	if (unlikely(ret))
 		return ret;
 	return do_rt_sigqueueinfo(pid, sig, &info);
@@ -3409,9 +3439,6 @@ static int do_rt_tgsigqueueinfo(pid_t tgid, pid_t pid, int sig, kernel_siginfo_t
 	    (task_pid_vnr(current) != pid))
 		return -EPERM;
 
-	if (info->si_signo != sig)
-		return -EINVAL;
-
 	return do_send_specific(tgid, pid, sig, info);
 }
 
@@ -3419,7 +3446,7 @@ SYSCALL_DEFINE4(rt_tgsigqueueinfo, pid_t, tgid, pid_t, pid, int, sig,
 		siginfo_t __user *, uinfo)
 {
 	kernel_siginfo_t info;
-	int ret = copy_siginfo_from_user(&info, uinfo);
+	int ret = __copy_siginfo_from_user(sig, &info, uinfo);
 	if (unlikely(ret))
 		return ret;
 	return do_rt_tgsigqueueinfo(tgid, pid, sig, &info);
@@ -3433,7 +3460,7 @@ COMPAT_SYSCALL_DEFINE4(rt_tgsigqueueinfo,
 			struct compat_siginfo __user *, uinfo)
 {
 	kernel_siginfo_t info;
-	int ret = copy_siginfo_from_user32(&info, uinfo);
+	int ret = __copy_siginfo_from_user32(sig, &info, uinfo);
 	if (unlikely(ret))
 		return ret;
 	return do_rt_tgsigqueueinfo(tgid, pid, sig, &info);
