From: Daniel Colascione <dancol-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v2 5/6] Let userfaultfd opt out of handling kernel-mode faults
Date: Tue, 11 Feb 2020 14:55:46 -0800
Message-ID: <20200211225547.235083-6-dancol@google.com>
References: <20200211225547.235083-1-dancol@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20200211225547.235083-1-dancol-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dancol-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, timmurray-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, nosh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, nnk-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, lokeshgidra-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, selinux-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

userfaultfd handles page faults from both user and kernel code.  Add a
new UFFD_USER_MODE_ONLY flag for userfaultfd(2) that makes the
resulting userfaultfd object refuse to handle faults from kernel mode,
treating these faults as if SIGBUS were always raised, causing the
kernel code to fail with EFAULT.

A future patch adds a knob allowing administrators to give some
processes the ability to create userfaultfd file objects only if they
pass UFFD_USER_MODE_ONLY, reducing the likelihood that these processes
will exploit userfaultfd's ability to delay kernel page faults to open
timing windows for future exploits.

Signed-off-by: Daniel Colascione <dancol-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
---
 fs/userfaultfd.c                 | 7 ++++++-
 include/uapi/linux/userfaultfd.h | 9 +++++++++
 2 files changed, 15 insertions(+), 1 deletion(-)

diff --git a/fs/userfaultfd.c b/fs/userfaultfd.c
index 11227b94a5a7..47825a804d63 100644
--- a/fs/userfaultfd.c
+++ b/fs/userfaultfd.c
@@ -389,6 +389,9 @@ vm_fault_t handle_userfault(struct vm_fault *vmf, unsigned long reason)
 
 	if (ctx->features & UFFD_FEATURE_SIGBUS)
 		goto out;
+	if ((vmf->flags & FAULT_FLAG_USER) == 0 &&
+	    ctx->flags & UFFD_USER_MODE_ONLY)
+		goto out;
 
 	/*
 	 * If it's already released don't get it. This avoids to loop
@@ -1945,6 +1948,7 @@ static void init_once_userfaultfd_ctx(void *mem)
 
 SYSCALL_DEFINE1(userfaultfd, int, flags)
 {
+	static const int uffd_flags = UFFD_USER_MODE_ONLY;
 	struct userfaultfd_ctx *ctx;
 	int fd;
 
@@ -1954,10 +1958,11 @@ SYSCALL_DEFINE1(userfaultfd, int, flags)
 	BUG_ON(!current->mm);
 
 	/* Check the UFFD_* constants for consistency.  */
+	BUILD_BUG_ON(uffd_flags & UFFD_SHARED_FCNTL_FLAGS);
 	BUILD_BUG_ON(UFFD_CLOEXEC != O_CLOEXEC);
 	BUILD_BUG_ON(UFFD_NONBLOCK != O_NONBLOCK);
 
-	if (flags & ~UFFD_SHARED_FCNTL_FLAGS)
+	if (flags & ~(UFFD_SHARED_FCNTL_FLAGS | uffd_flags))
 		return -EINVAL;
 
 	ctx = kmem_cache_alloc(userfaultfd_ctx_cachep, GFP_KERNEL);
diff --git a/include/uapi/linux/userfaultfd.h b/include/uapi/linux/userfaultfd.h
index 48f1a7c2f1f0..fe3565eae617 100644
--- a/include/uapi/linux/userfaultfd.h
+++ b/include/uapi/linux/userfaultfd.h
@@ -231,4 +231,13 @@ struct uffdio_zeropage {
 	__s64 zeropage;
 };
 
+/*
+ * Flags for the userfaultfd(2) system call itself.
+ */
+
+/*
+ * Create a userfaultfd that can handle page faults only in user mode.
+ */
+#define UFFD_USER_MODE_ONLY 1
+
 #endif /* _LINUX_USERFAULTFD_H */
-- 
2.25.0.225.g125e21ebc7-goog
