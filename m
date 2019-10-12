From: Daniel Colascione <dancol@google.com>
Subject: [PATCH 6/7] Allow users to require UFFD_SECURE
Date: Sat, 12 Oct 2019 12:16:01 -0700
Message-ID: <20191012191602.45649-7-dancol@google.com>
References: <20191012191602.45649-1-dancol@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20191012191602.45649-1-dancol@google.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, lokeshgidra@google.com, dancol@google.com, nnk@google.com
Cc: nosh@google.com, timmurray@google.com
List-Id: linux-api@vger.kernel.org

This change adds 2 as an allowable value for
unprivileged_userfaultfd. (Previously, this sysctl could be either 0
or 1.) When unprivileged_userfaultfd is 2, users with CAP_SYS_PTRACE
may create userfaultfd with or without UFFD_SECURE, but users without
CAP_SYS_PTRACE must pass UFFD_SECURE to userfaultfd in order for the
system call to succeed, effectively forcing them to opt into
additional security checks.

Signed-off-by: Daniel Colascione <dancol@google.com>
---
 Documentation/admin-guide/sysctl/vm.rst | 6 ++++--
 fs/userfaultfd.c                        | 4 +++-
 kernel/sysctl.c                         | 2 +-
 3 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/Documentation/admin-guide/sysctl/vm.rst b/Documentation/admin-guide/sysctl/vm.rst
index 64aeee1009ca..6664eec7bd35 100644
--- a/Documentation/admin-guide/sysctl/vm.rst
+++ b/Documentation/admin-guide/sysctl/vm.rst
@@ -842,8 +842,10 @@ unprivileged_userfaultfd
 
 This flag controls whether unprivileged users can use the userfaultfd
 system calls.  Set this to 1 to allow unprivileged users to use the
-userfaultfd system calls, or set this to 0 to restrict userfaultfd to only
-privileged users (with SYS_CAP_PTRACE capability).
+userfaultfd system calls, or set this to 0 to restrict userfaultfd to
+only privileged users (with SYS_CAP_PTRACE capability).  If set to 2,
+unprivileged (non-SYS_CAP_PTRACE) users may use userfaultfd only if
+they pass the UFFD_SECURE, enabling MAC security checks.
 
 The default value is 1.
 
diff --git a/fs/userfaultfd.c b/fs/userfaultfd.c
index 986d23b2cd33..aaed9347973e 100644
--- a/fs/userfaultfd.c
+++ b/fs/userfaultfd.c
@@ -1963,8 +1963,10 @@ SYSCALL_DEFINE1(userfaultfd, int, flags)
 	struct userfaultfd_ctx *ctx;
 	int fd;
 	static const int uffd_flags = UFFD_SECURE | UFFD_USER_MODE_ONLY;
+	bool need_cap_check = sysctl_unprivileged_userfaultfd == 0 ||
+		(sysctl_unprivileged_userfaultfd == 2 && !(flags & UFFD_SECURE));
 
-	if (!sysctl_unprivileged_userfaultfd && !capable(CAP_SYS_PTRACE))
+	if (need_cap_check && !capable(CAP_SYS_PTRACE))
 		return -EPERM;
 
 	BUG_ON(!current->mm);
diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index 00fcea236eba..fc98d5df344e 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -1738,7 +1738,7 @@ static struct ctl_table vm_table[] = {
 		.mode		= 0644,
 		.proc_handler	= proc_dointvec_minmax,
 		.extra1		= SYSCTL_ZERO,
-		.extra2		= SYSCTL_ONE,
+		.extra2		= &two,
 	},
 #endif
 	{ }
-- 
2.23.0.700.g56cf767bdb-goog
