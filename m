From: Daniel Colascione <dancol@google.com>
Subject: [PATCH 3/7] Add a UFFD_SECURE flag to the userfaultfd API.
Date: Sat, 12 Oct 2019 12:15:58 -0700
Message-ID: <20191012191602.45649-4-dancol@google.com>
References: <20191012191602.45649-1-dancol@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20191012191602.45649-1-dancol@google.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, lokeshgidra@google.com, dancol@google.com, nnk@google.com
Cc: nosh@google.com, timmurray@google.com
List-Id: linux-api@vger.kernel.org

The new secure flag makes userfaultfd use a new "secure" anonymous
file object instead of the default one, letting security modules
supervise userfaultfd use.

Requiring that users pass a new flag lets us avoid changing the
semantics for existing callers.

Signed-off-by: Daniel Colascione <dancol@google.com>
---
 fs/userfaultfd.c                 | 28 +++++++++++++++++++++++++---
 include/uapi/linux/userfaultfd.h |  8 ++++++++
 2 files changed, 33 insertions(+), 3 deletions(-)

diff --git a/fs/userfaultfd.c b/fs/userfaultfd.c
index f9fd18670e22..29f920fb236e 100644
--- a/fs/userfaultfd.c
+++ b/fs/userfaultfd.c
@@ -1022,6 +1022,13 @@ static int resolve_userfault_fork(struct userfaultfd_ctx *ctx,
 {
 	int fd;
 
+	/*
+	 * Using a secure-mode UFFD to monitor forks isn't supported
+	 * right now.
+	 */
+	if (new->flags & UFFD_SECURE)
+		return -EOPNOTSUPP;
+
 	fd = anon_inode_getfd("[userfaultfd]", &userfaultfd_fops, new,
 			      O_RDWR | (new->flags & UFFD_SHARED_FCNTL_FLAGS));
 	if (fd < 0)
@@ -1841,6 +1848,18 @@ static int userfaultfd_api(struct userfaultfd_ctx *ctx,
 		ret = -EINVAL;
 		goto out;
 	}
+	if ((ctx->flags & UFFD_SECURE) &&
+	    (features & UFFD_FEATURE_EVENT_FORK)) {
+		/*
+		 * We don't support UFFD_FEATURE_EVENT_FORK on a
+		 * secure-mode UFFD: doing so would need us to
+		 * construct the new file object in the context of the
+		 * fork child, and it's not worth it right now.
+		 */
+		ret = -EINVAL;
+		goto out;
+	}
+
 	/* report all available features and ioctls to userland */
 	uffdio_api.features = UFFD_API_FEATURES;
 	uffdio_api.ioctls = UFFD_API_IOCTLS;
@@ -1942,6 +1961,7 @@ SYSCALL_DEFINE1(userfaultfd, int, flags)
 {
 	struct userfaultfd_ctx *ctx;
 	int fd;
+	static const int uffd_flags = UFFD_SECURE;
 
 	if (!sysctl_unprivileged_userfaultfd && !capable(CAP_SYS_PTRACE))
 		return -EPERM;
@@ -1951,8 +1971,9 @@ SYSCALL_DEFINE1(userfaultfd, int, flags)
 	/* Check the UFFD_* constants for consistency.  */
 	BUILD_BUG_ON(UFFD_CLOEXEC != O_CLOEXEC);
 	BUILD_BUG_ON(UFFD_NONBLOCK != O_NONBLOCK);
+	BUILD_BUG_ON(UFFD_SHARED_FCNTL_FLAGS & uffd_flags);
 
-	if (flags & ~UFFD_SHARED_FCNTL_FLAGS)
+	if (flags & ~(UFFD_SHARED_FCNTL_FLAGS | uffd_flags))
 		return -EINVAL;
 
 	ctx = kmem_cache_alloc(userfaultfd_ctx_cachep, GFP_KERNEL);
@@ -1969,8 +1990,9 @@ SYSCALL_DEFINE1(userfaultfd, int, flags)
 	/* prevent the mm struct to be freed */
 	mmgrab(ctx->mm);
 
-	fd = anon_inode_getfd("[userfaultfd]", &userfaultfd_fops, ctx,
-			      O_RDWR | (flags & UFFD_SHARED_FCNTL_FLAGS));
+	fd = anon_inode_getfd2("[userfaultfd]", &userfaultfd_fops, ctx,
+			       O_RDWR | (flags & UFFD_SHARED_FCNTL_FLAGS),
+			       ((flags & UFFD_SECURE) ? ANON_INODE_SECURE : 0));
 	if (fd < 0) {
 		mmdrop(ctx->mm);
 		kmem_cache_free(userfaultfd_ctx_cachep, ctx);
diff --git a/include/uapi/linux/userfaultfd.h b/include/uapi/linux/userfaultfd.h
index 48f1a7c2f1f0..12d7d40d7f25 100644
--- a/include/uapi/linux/userfaultfd.h
+++ b/include/uapi/linux/userfaultfd.h
@@ -231,4 +231,12 @@ struct uffdio_zeropage {
 	__s64 zeropage;
 };
 
+/*
+ * Flags for the userfaultfd(2) system call itself.
+ */
+
+/*
+ * Create a userfaultfd with MAC security checks enabled.
+ */
+#define UFFD_SECURE 1
 #endif /* _LINUX_USERFAULTFD_H */
-- 
2.23.0.700.g56cf767bdb-goog
