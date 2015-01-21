From: Michael Ellerman <mpe-Gsx/Oe8HsFggBc27wqDAHg@public.gmane.org>
Subject: [PATCH] selftests/exec: Check if the syscall exists and bail if not
Date: Wed, 21 Jan 2015 18:41:00 +1100
Message-ID: <1421826060-2237-1-git-send-email-mpe@ellerman.id.au>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, geert-Td1EMuHUCqxL1ZNQvxDV9g@public.gmane.org, drysdale-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org, davej-rdkfGonbjUTCLXcRTR1eJlpr/1R2p/CL@public.gmane.org
List-Id: linux-api@vger.kernel.org

On systems which don't implement sys_execveat(), this test produces a
lot of output.

Add a check at the beginning to see if the syscall is present, and if
not just note one error and return.

Signed-off-by: Michael Ellerman <mpe-Gsx/Oe8HsFggBc27wqDAHg@public.gmane.org>
---
 tools/testing/selftests/exec/execveat.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/tools/testing/selftests/exec/execveat.c b/tools/testing/selftests/exec/execveat.c
index e238c9559caf..b87e4a843bea 100644
--- a/tools/testing/selftests/exec/execveat.c
+++ b/tools/testing/selftests/exec/execveat.c
@@ -234,6 +234,14 @@ static int run_tests(void)
 	int fd_cloexec = open_or_die("execveat", O_RDONLY|O_CLOEXEC);
 	int fd_script_cloexec = open_or_die("script", O_RDONLY|O_CLOEXEC);
 
+	/* Check if we have execveat at all, and bail early if not */
+	errno = 0;
+	execveat_(-1, NULL, NULL, NULL, 0);
+	if (errno == -ENOSYS) {
+		printf("[FAIL] ENOSYS calling execveat - no kernel support?\n");
+		return 1;
+	}
+
 	/* Change file position to confirm it doesn't affect anything */
 	lseek(fd, 10, SEEK_SET);
 
-- 
2.1.0
