From: Sargun Dhillon <sargun@sargun.me>
Subject: [PATCH v3 2/3] seccomp: Check that seccomp_notif is zeroed out by the user
Date: Sat, 28 Dec 2019 22:24:50 -0800
Message-ID: <20191229062451.9467-2-sargun@sargun.me>
References: <20191229062451.9467-1-sargun@sargun.me>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20191229062451.9467-1-sargun@sargun.me>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-api@vger.kernel.org
Cc: Jann Horn <jannh@google.com>, Christian Brauner <christian.brauner@ubuntu.com>, Kees Cook <keescook@chromium.org>, Aleksa Sarai <cyphar@cyphar.com>, Tycho Andersen <tycho@tycho.ws>, Sargun Dhillon <sargun@sargun.me>
List-Id: linux-api@vger.kernel.org

This patch is a small change in enforcement of the uapi for
SECCOMP_IOCTL_NOTIF_RECV ioctl. Specifically, the datastructure which
is passed (seccomp_notif) must be zeroed out. Previously any of its
members could be set to nonsense values, and we would ignore it.

This ensures all fields are set to their zero value.

Signed-off-by: Sargun Dhillon <sargun@sargun.me>
Cc: Kees Cook <keescook@chromium.org>
Reviewed-by: Christian Brauner <christian.brauner@ubuntu.com>
Reviewed-by: Aleksa Sarai <cyphar@cyphar.com>
Acked-by: Tycho Andersen <tycho@tycho.ws>
---
 kernel/seccomp.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/kernel/seccomp.c b/kernel/seccomp.c
index 12d2227e5786..b6ea3dcb57bf 100644
--- a/kernel/seccomp.c
+++ b/kernel/seccomp.c
@@ -1026,6 +1026,13 @@ static long seccomp_notify_recv(struct seccomp_filter *filter,
 	struct seccomp_notif unotif;
 	ssize_t ret;
 
+	/* Verify that we're not given garbage to keep struct extensible. */
+	ret = check_zeroed_user(buf, sizeof(unotif));
+	if (ret < 0)
+		return ret;
+	if (!ret)
+		return -EINVAL;
+
 	memset(&unotif, 0, sizeof(unotif));
 
 	ret = down_interruptible(&filter->notif->request);
-- 
2.20.1
