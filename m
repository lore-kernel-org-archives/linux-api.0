From: Sargun Dhillon <sargun@sargun.me>
Subject: [PATCH v2 1/2] samples, selftests/seccomp: Zero out seccomp_notif
Date: Sat, 28 Dec 2019 01:48:39 +0000
Message-ID: <20191228014837.GA31774@ircssh-2.c.rugged-nimbus-611.internal>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-api@vger.kernel.org
Cc: tycho@tycho.ws, jannh@google.com, christian.brauner@ubuntu.com, keescook@chromium.org, cyphar@cyphar.com
List-Id: linux-api@vger.kernel.org

The seccomp_notif structure should be zeroed out prior to calling the
SECCOMP_IOCTL_NOTIF_RECV ioctl. Previously, the kernel did not check
whether these structures were zeroed out or not, so these worked.

Signed-off-by: Sargun Dhillon <sargun@sargun.me>
Cc: Kees Cook <keescook@chromium.org>
---
 samples/seccomp/user-trap.c                   | 2 +-
 tools/testing/selftests/seccomp/seccomp_bpf.c | 2 ++
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/samples/seccomp/user-trap.c b/samples/seccomp/user-trap.c
index 6d0125ca8af7..0ca8fb37cd79 100644
--- a/samples/seccomp/user-trap.c
+++ b/samples/seccomp/user-trap.c
@@ -298,7 +298,6 @@ int main(void)
 		req = malloc(sizes.seccomp_notif);
 		if (!req)
 			goto out_close;
-		memset(req, 0, sizeof(*req));
 
 		resp = malloc(sizes.seccomp_notif_resp);
 		if (!resp)
@@ -306,6 +305,7 @@ int main(void)
 		memset(resp, 0, sizeof(*resp));
 
 		while (1) {
+			memset(req, 0, sizes.seccomp_notif);
 			if (ioctl(listener, SECCOMP_IOCTL_NOTIF_RECV, req)) {
 				perror("ioctl recv");
 				goto out_resp;
diff --git a/tools/testing/selftests/seccomp/seccomp_bpf.c b/tools/testing/selftests/seccomp/seccomp_bpf.c
index 6944b898bb53..f53f14971bff 100644
--- a/tools/testing/selftests/seccomp/seccomp_bpf.c
+++ b/tools/testing/selftests/seccomp/seccomp_bpf.c
@@ -3278,6 +3278,7 @@ TEST(user_notification_signal)
 
 	close(sk_pair[1]);
 
+	memset(&req, 0, sizeof(req));
 	EXPECT_EQ(ioctl(listener, SECCOMP_IOCTL_NOTIF_RECV, &req), 0);
 
 	EXPECT_EQ(kill(pid, SIGUSR1), 0);
@@ -3296,6 +3297,7 @@ TEST(user_notification_signal)
 	EXPECT_EQ(ioctl(listener, SECCOMP_IOCTL_NOTIF_SEND, &resp), -1);
 	EXPECT_EQ(errno, ENOENT);
 
+	memset(&req, 0, sizeof(req));
 	EXPECT_EQ(ioctl(listener, SECCOMP_IOCTL_NOTIF_RECV, &req), 0);
 
 	resp.id = req.id;
-- 
2.20.1
