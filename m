From: Daniel Colascione <dancol@google.com>
Subject: [PATCH v2 6/6] Add a new sysctl for limiting userfaultfd to user mode faults
Date: Tue, 11 Feb 2020 14:55:47 -0800
Message-ID: <20200211225547.235083-7-dancol@google.com>
References: <20200211225547.235083-1-dancol@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20200211225547.235083-1-dancol@google.com>
Sender: linux-kernel-owner@vger.kernel.org
To: dancol@google.com, timmurray@google.com, nosh@google.com, nnk@google.com, lokeshgidra@google.com, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, selinux@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Add a new sysctl knob unprivileged_userfaultfd_user_mode_only.
This sysctl can be set to either zero or one. When zero (the default)
the system lets all users call userfaultfd with or without
UFFD_USER_MODE_ONLY, modulo other access controls. When
unprivileged_userfaultfd_user_mode_only is set to one, users without
CAP_SYS_PTRACE must pass UFFD_USER_MODE_ONLY to userfaultfd or the API
will fail with EPERM. This facility allows administrators to reduce
the likelihood that an attacker with access to userfaultfd can delay
faulting kernel code to widen timing windows for other exploits.

Signed-off-by: Daniel Colascione <dancol@google.com>
---
 Documentation/admin-guide/sysctl/vm.rst | 13 +++++++++++++
 fs/userfaultfd.c                        | 11 ++++++++++-
 include/linux/userfaultfd_k.h           |  1 +
 kernel/sysctl.c                         |  9 +++++++++
 4 files changed, 33 insertions(+), 1 deletion(-)

diff --git a/Documentation/admin-guide/sysctl/vm.rst b/Documentation/admin-guide/sysctl/vm.rst
index 64aeee1009ca..1f416aff68b9 100644
--- a/Documentation/admin-guide/sysctl/vm.rst
+++ b/Documentation/admin-guide/sysctl/vm.rst
@@ -847,6 +847,19 @@ privileged users (with SYS_CAP_PTRACE capability).
 
 The default value is 1.
 
+unprivileged_userfaultfd_user_mode_only
+========================================
+
+This flag controls whether unprivileged users can use the userfaultfd
+system calls to handle page faults in kernel mode.  If set to zero,
+userfaultfd works with or without UFFD_USER_MODE_ONLY, modulo
+unprivileged_userfaultfd above.  If set to one, users without
+SYS_CAP_PTRACE must pass UFFD_USER_MODE_ONLY in order for userfaultfd
+to succeed.  Prohibiting use of userfaultfd for handling faults from
+kernel mode may make certain vulnerabilities more difficult
+to exploit.
+
+The default value is 0.
 
 user_reserve_kbytes
 ===================
diff --git a/fs/userfaultfd.c b/fs/userfaultfd.c
index 47825a804d63..d39bdf177f8c 100644
--- a/fs/userfaultfd.c
+++ b/fs/userfaultfd.c
@@ -29,6 +29,7 @@
 #include <linux/hugetlb.h>
 
 int sysctl_unprivileged_userfaultfd __read_mostly = 1;
+int sysctl_unprivileged_userfaultfd_user_mode_only __read_mostly = 0;
 
 static struct kmem_cache *userfaultfd_ctx_cachep __read_mostly;
 
@@ -1951,8 +1952,16 @@ SYSCALL_DEFINE1(userfaultfd, int, flags)
 	static const int uffd_flags = UFFD_USER_MODE_ONLY;
 	struct userfaultfd_ctx *ctx;
 	int fd;
+	bool need_cap_check = false;
 
-	if (!sysctl_unprivileged_userfaultfd && !capable(CAP_SYS_PTRACE))
+	if (!sysctl_unprivileged_userfaultfd)
+		need_cap_check = true;
+
+	if (sysctl_unprivileged_userfaultfd_user_mode_only &&
+	    (flags & UFFD_USER_MODE_ONLY) == 0)
+		need_cap_check = true;
+
+	if (need_cap_check && !capable(CAP_SYS_PTRACE))
 		return -EPERM;
 
 	BUG_ON(!current->mm);
diff --git a/include/linux/userfaultfd_k.h b/include/linux/userfaultfd_k.h
index 549c8b0cca52..efe14abb2dc8 100644
--- a/include/linux/userfaultfd_k.h
+++ b/include/linux/userfaultfd_k.h
@@ -29,6 +29,7 @@
 #define UFFD_FLAGS_SET (EFD_SHARED_FCNTL_FLAGS)
 
 extern int sysctl_unprivileged_userfaultfd;
+extern int sysctl_unprivileged_userfaultfd_user_mode_only;
 
 extern const struct file_operations userfaultfd_fops;
 
diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index d396aaaf19a3..0650063c3741 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -1740,6 +1740,15 @@ static struct ctl_table vm_table[] = {
 		.extra1		= SYSCTL_ZERO,
 		.extra2		= SYSCTL_ONE,
 	},
+	{
+		.procname	= "unprivileged_userfaultfd_user_mode_only",
+		.data		= &sysctl_unprivileged_userfaultfd_user_mode_only,
+		.maxlen		= sizeof(sysctl_unprivileged_userfaultfd_user_mode_only),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec_minmax,
+		.extra1		= SYSCTL_ZERO,
+		.extra2		= SYSCTL_ONE,
+	},
 #endif
 	{ }
 };
-- 
2.25.0.225.g125e21ebc7-goog
