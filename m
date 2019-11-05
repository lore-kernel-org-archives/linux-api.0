From: Mike Rapoport <rppt@linux.ibm.com>
Subject: [PATCH 1/1] userfaultfd: require CAP_SYS_PTRACE for UFFD_FEATURE_EVENT_FORK
Date: Tue,  5 Nov 2019 17:29:37 +0200
Message-ID: <1572967777-8812-2-git-send-email-rppt@linux.ibm.com>
References: <1572967777-8812-1-git-send-email-rppt@linux.ibm.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1572967777-8812-1-git-send-email-rppt@linux.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Andrea Arcangeli <aarcange@redhat.com>, Andrew Morton <akpm@linux-foundation.org>, Andy Lutomirski <luto@kernel.org>, Daniel Colascione <dancol@google.com>, Jann Horn <jannh@google.com>, Linus Torvalds <torvalds@linux-foundation.org>, Lokesh Gidra <lokeshgidra@google.com>, Nick Kralevich <nnk@google.com>, Nosh Minwalla <nosh@google.com>, Pavel Emelyanov <ovzxemul@gmail.com>, Tim Murray <timmurray@google.com>, linux-api@vger.kernel.org, linux-mm@kvack.org, Mike Rapoport <rppt@linux.ibm.com>
List-Id: linux-api@vger.kernel.org

Current implementation of UFFD_FEATURE_EVENT_FORK modifies the file
descriptor table from the read() implementation of uffd, which may have
security implications for unprivileged use of the userfaultfd.

Limit availability of UFFD_FEATURE_EVENT_FORK only for callers that have
CAP_SYS_PTRACE.

Signed-off-by: Mike Rapoport <rppt@linux.ibm.com>
---
 fs/userfaultfd.c | 18 +++++++++++-------
 1 file changed, 11 insertions(+), 7 deletions(-)

diff --git a/fs/userfaultfd.c b/fs/userfaultfd.c
index f9fd18670e22..d99d166fd892 100644
--- a/fs/userfaultfd.c
+++ b/fs/userfaultfd.c
@@ -1834,13 +1834,12 @@ static int userfaultfd_api(struct userfaultfd_ctx *ctx,
 	if (copy_from_user(&uffdio_api, buf, sizeof(uffdio_api)))
 		goto out;
 	features = uffdio_api.features;
-	if (uffdio_api.api != UFFD_API || (features & ~UFFD_API_FEATURES)) {
-		memset(&uffdio_api, 0, sizeof(uffdio_api));
-		if (copy_to_user(buf, &uffdio_api, sizeof(uffdio_api)))
-			goto out;
-		ret = -EINVAL;
-		goto out;
-	}
+	ret = -EINVAL;
+	if (uffdio_api.api != UFFD_API || (features & ~UFFD_API_FEATURES))
+		goto err_out;
+	ret = -EPERM;
+	if ((features & UFFD_FEATURE_EVENT_FORK) && !capable(CAP_SYS_PTRACE))
+		goto err_out;
 	/* report all available features and ioctls to userland */
 	uffdio_api.features = UFFD_API_FEATURES;
 	uffdio_api.ioctls = UFFD_API_IOCTLS;
@@ -1853,6 +1852,11 @@ static int userfaultfd_api(struct userfaultfd_ctx *ctx,
 	ret = 0;
 out:
 	return ret;
+err_out:
+	memset(&uffdio_api, 0, sizeof(uffdio_api));
+	if (copy_to_user(buf, &uffdio_api, sizeof(uffdio_api)))
+		ret = -EFAULT;
+	goto out;
 }
 
 static long userfaultfd_ioctl(struct file *file, unsigned cmd,
-- 
2.7.4
