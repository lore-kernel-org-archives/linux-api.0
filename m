From: "Dmitry V. Levin" <ldv@altlinux.org>
Subject: [PATCH 2/2] samples: make pidfd-metadata fail gracefully on older
 kernels
Date: Sun, 23 Jun 2019 14:28:00 +0300
Message-ID: <20190623112800.GB20697@altlinux.org>
References: <20190620103105.cdxgqfelzlnkmblv@brauner.io>
 <20190620110037.GA4998@altlinux.org>
 <20190620111036.asi3mbcv4ax5ekrw@brauner.io>
 <20190621170613.GA26182@altlinux.org>
 <20190621221339.6yj4vg4zexv4y2j7@brauner.io>
 <20190623112717.GA20697@altlinux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190623112717.GA20697@altlinux.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Christian Brauner <christian@brauner.io>
Cc: Jann Horn <jannh@google.com>, Oleg Nesterov <oleg@redhat.com>, Arnd Bergmann <arnd@arndb.de>, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Initialize pidfd to an invalid descriptor, to fail gracefully on
those kernels that do not implement CLONE_PIDFD and leave pidfd
unchanged.

Signed-off-by: Dmitry V. Levin <ldv@altlinux.org>
---
 samples/pidfd/pidfd-metadata.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/samples/pidfd/pidfd-metadata.c b/samples/pidfd/pidfd-metadata.c
index 14b454448429..c459155daf9a 100644
--- a/samples/pidfd/pidfd-metadata.c
+++ b/samples/pidfd/pidfd-metadata.c
@@ -83,7 +83,7 @@ static int pidfd_metadata_fd(pid_t pid, int pidfd)
 
 int main(int argc, char *argv[])
 {
-	int pidfd = 0, ret = EXIT_FAILURE;
+	int pidfd = -1, ret = EXIT_FAILURE;
 	char buf[4096] = { 0 };
 	pid_t pid;
 	int procfd, statusfd;
@@ -91,7 +91,11 @@ int main(int argc, char *argv[])
 
 	pid = pidfd_clone(CLONE_PIDFD, &pidfd);
 	if (pid < 0)
-		exit(ret);
+		err(ret, "CLONE_PIDFD");
+	if (pidfd == -1) {
+		warnx("CLONE_PIDFD is not supported by the kernel");
+		goto out;
+	}
 
 	procfd = pidfd_metadata_fd(pid, pidfd);
 	close(pidfd);
-- 
ldv
