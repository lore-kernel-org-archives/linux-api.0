From: Pavel Emelyanov <xemul-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Subject: [PATCH 2/3] posix timers: Add syscall that lists timer IDs armed
 by process
Date: Thu, 14 Feb 2013 20:19:28 +0400
Message-ID: <511D0E90.5090705@parallels.com>
References: <511D0E50.7090505@parallels.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <511D0E50.7090505-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org


The sys_timer_list syscall accepts clock id, buffer size to store
the timers ids and the pointer to the buffer itself.

The number of timers of clockid type is returned and these timers'
ids are put into the provided buffer. If the buffer is not enough
for all timers, then only part of ids are put into it, but the
actual number of timers is reported anyway. If the buffer is bigger
than required, then its tail is left untouched and the number of
timers returned from the syscall denotes how much of ids are there.

Signed-off-by: Pavel Emelyanov <xemul-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
---
 arch/x86/syscalls/syscall_64.tbl |    1 +
 include/linux/syscalls.h         |    2 +
 kernel/posix-timers.c            |   48 ++++++++++++++++++++++++++++++++++++++
 3 files changed, 51 insertions(+), 0 deletions(-)

diff --git a/arch/x86/syscalls/syscall_64.tbl b/arch/x86/syscalls/syscall_64.tbl
index dc97328..72b6ee6 100644
--- a/arch/x86/syscalls/syscall_64.tbl
+++ b/arch/x86/syscalls/syscall_64.tbl
@@ -320,6 +320,7 @@
 311	64	process_vm_writev	sys_process_vm_writev
 312	common	kcmp			sys_kcmp
 313	common	finit_module		sys_finit_module
+314	common	timer_list		sys_timer_list
 
 #
 # x32-specific system call numbers start at 512 to avoid cache impact
diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
index 45e2db2..dc951da 100644
--- a/include/linux/syscalls.h
+++ b/include/linux/syscalls.h
@@ -319,6 +319,8 @@ asmlinkage long sys_timer_settime(timer_t timer_id, int flags,
 				const struct itimerspec __user *new_setting,
 				struct itimerspec __user *old_setting);
 asmlinkage long sys_timer_delete(timer_t timer_id);
+asmlinkage long sys_timer_list(const clockid_t clock_id, int nr,
+				timer_t __user *timer_ids);
 asmlinkage long sys_clock_settime(clockid_t which_clock,
 				const struct timespec __user *tp);
 asmlinkage long sys_clock_gettime(clockid_t which_clock,
diff --git a/kernel/posix-timers.c b/kernel/posix-timers.c
index 9cfb86a..46cee59 100644
--- a/kernel/posix-timers.c
+++ b/kernel/posix-timers.c
@@ -1103,3 +1103,51 @@ long clock_nanosleep_restart(struct restart_block *restart_block)
 
 	return kc->nsleep_restart(restart_block);
 }
+
+SYSCALL_DEFINE3(timer_list, const clockid_t, clock_id,
+		int, unr, timer_t __user *, timer_ids)
+{
+	struct k_itimer *timer;
+	timer_t *buf;
+	int nr = 0, buf_nr;
+
+	spin_lock_irq(&current->sighand->siglock);
+	list_for_each_entry(timer, &current->signal->posix_timers, list)
+		if (timer->it_clock == clock_id)
+			nr++;
+	spin_unlock_irq(&current->sighand->siglock);
+
+	if (!unr)
+		goto out;
+
+try_again:
+	buf_nr = min(nr, unr);
+	buf = kmalloc(buf_nr * sizeof(timer_t), GFP_KERNEL);
+	if (!buf)
+		return -ENOMEM;
+
+	nr = 0;
+	spin_lock_irq(&current->sighand->siglock);
+	list_for_each_entry(timer, &current->signal->posix_timers, list) {
+		if (timer->it_clock != clock_id)
+			continue;
+
+		if (nr < buf_nr)
+			buf[nr] = timer->it_id;
+
+		nr++;
+	}
+	spin_unlock_irq(&current->sighand->siglock);
+
+	if (nr > buf_nr) {
+		kfree(buf);
+		goto try_again;
+	}
+
+	if (copy_to_user(timer_ids, buf, nr * sizeof(timer_t)))
+		unr = -EFAULT;
+
+	kfree(buf);
+out:
+	return nr;
+}
-- 
1.7.6.5
