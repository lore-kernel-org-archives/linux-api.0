From: Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 08/15] kexec: New syscall kexec_file_load() declaration
Date: Thu, 26 Jun 2014 16:33:37 -0400
Message-ID: <1403814824-7587-9-git-send-email-vgoyal@redhat.com>
References: <1403814824-7587-1-git-send-email-vgoyal@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kexec-bounces+glkk-kexec=m.gmane.org-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>
In-Reply-To: <1403814824-7587-1-git-send-email-vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/kexec>,
 <mailto:kexec-request-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/kexec/>
List-Post: <mailto:kexec-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>
List-Help: <mailto:kexec-request-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/kexec>,
 <mailto:kexec-request-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org?subject=subscribe>
Sender: "kexec" <kexec-bounces-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>
Errors-To: kexec-bounces+glkk-kexec=m.gmane.org-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kexec-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org
Cc: mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org, bhe-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, greg-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org, Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org, ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org, hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, chaowang-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
List-Id: linux-api@vger.kernel.org

This is the new syscall kexec_file_load() declaration/interface. I have
reserved the syscall number only for x86_64 so far. Other architectures
(including i386) can reserve syscall number when they enable the support
for this new syscall.

Signed-off-by: Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
CC: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
---
 arch/x86/syscalls/syscall_64.tbl | 1 +
 include/linux/syscalls.h         | 4 ++++
 kernel/kexec.c                   | 7 +++++++
 kernel/sys_ni.c                  | 1 +
 4 files changed, 13 insertions(+)

diff --git a/arch/x86/syscalls/syscall_64.tbl b/arch/x86/syscalls/syscall_64.tbl
index ec255a1..6d35459 100644
--- a/arch/x86/syscalls/syscall_64.tbl
+++ b/arch/x86/syscalls/syscall_64.tbl
@@ -323,6 +323,7 @@
 314	common	sched_setattr		sys_sched_setattr
 315	common	sched_getattr		sys_sched_getattr
 316	common	renameat2		sys_renameat2
+317	common	kexec_file_load		sys_kexec_file_load
 
 #
 # x32-specific system call numbers start at 512 to avoid cache impact
diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
index b0881a0..9e98193 100644
--- a/include/linux/syscalls.h
+++ b/include/linux/syscalls.h
@@ -317,6 +317,10 @@ asmlinkage long sys_restart_syscall(void);
 asmlinkage long sys_kexec_load(unsigned long entry, unsigned long nr_segments,
 				struct kexec_segment __user *segments,
 				unsigned long flags);
+asmlinkage long sys_kexec_file_load(int kernel_fd, int initrd_fd,
+				    unsigned long cmdline_len,
+				    const char __user *cmdline_ptr,
+				    unsigned long flags);
 
 asmlinkage long sys_exit(int error_code);
 asmlinkage long sys_exit_group(int error_code);
diff --git a/kernel/kexec.c b/kernel/kexec.c
index c69ce00..bdda717 100644
--- a/kernel/kexec.c
+++ b/kernel/kexec.c
@@ -1057,6 +1057,13 @@ COMPAT_SYSCALL_DEFINE4(kexec_load, compat_ulong_t, entry,
 }
 #endif
 
+SYSCALL_DEFINE5(kexec_file_load, int, kernel_fd, int, initrd_fd,
+		unsigned long, cmdline_len, const char __user *, cmdline_ptr,
+		unsigned long, flags)
+{
+	return -ENOSYS;
+}
+
 void crash_kexec(struct pt_regs *regs)
 {
 	/* Take the kexec_mutex here to prevent sys_kexec_load
diff --git a/kernel/sys_ni.c b/kernel/sys_ni.c
index 36441b5..51ea89f 100644
--- a/kernel/sys_ni.c
+++ b/kernel/sys_ni.c
@@ -25,6 +25,7 @@ cond_syscall(sys_swapon);
 cond_syscall(sys_swapoff);
 cond_syscall(sys_kexec_load);
 cond_syscall(compat_sys_kexec_load);
+cond_syscall(sys_kexec_file_load);
 cond_syscall(sys_init_module);
 cond_syscall(sys_finit_module);
 cond_syscall(sys_delete_module);
-- 
1.9.0
