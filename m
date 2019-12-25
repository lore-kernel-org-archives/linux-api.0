From: Sargun Dhillon <sargun@sargun.me>
Subject: [PATCH] seccomp: Check flags on seccomp_notif is unset
Date: Wed, 25 Dec 2019 21:45:33 +0000
Message-ID: <20191225214530.GA27780@ircssh-2.c.rugged-nimbus-611.internal>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-api@vger.kernel.org
Cc: tycho@tycho.ws, jannh@google.com, christian.brauner@ubuntu.com, keescook@chromium.org
List-Id: linux-api@vger.kernel.org

This patch is a small change in enforcement of the uapi for
SECCOMP_IOCTL_NOTIF_RECV ioctl. Specificaly, the datastructure which is
passed (seccomp_notif), has a flags member. Previously that could be
set to a nonsense value, and we would ignore it. This ensures that
no flags are set.

Signed-off-by: Sargun Dhillon <sargun@sargun.me>
Cc: Kees Cook <keescook@chromium.org>
---
 kernel/seccomp.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/kernel/seccomp.c b/kernel/seccomp.c
index 12d2227e5786..455925557490 100644
--- a/kernel/seccomp.c
+++ b/kernel/seccomp.c
@@ -1026,6 +1026,13 @@ static long seccomp_notify_recv(struct seccomp_filter *filter,
 	struct seccomp_notif unotif;
 	ssize_t ret;
 
+	if (copy_from_user(&unotif, buf, sizeof(unotif)))
+		return -EFAULT;
+
+	/* flags is reserved right now, make sure it's unset */
+	if (unotif.flags)
+		return -EINVAL;
+
 	memset(&unotif, 0, sizeof(unotif));
 
 	ret = down_interruptible(&filter->notif->request);
-- 
2.20.1
