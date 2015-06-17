From: Sergei Zviagintsev <sergei-E844GTqJAzo@public.gmane.org>
Subject: [PATCH] selftests/kdbus: drop useless assignment
Date: Wed, 17 Jun 2015 17:18:14 +0300
Message-ID: <1434550697-24785-2-git-send-email-sergei@s15v.net>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Daniel Mack <daniel-cYrQPVfZoowdnm+yROfE0A@public.gmane.org>, David Herrmann <dh.herrmann-gM/Ye1E23mwN+BqQ9rBEUg@public.gmane.org>, Djalal Harouni <tixxdz-Umm1ozX2/EEdnm+yROfE0A@public.gmane.org>
Cc: Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Sergei Zviagintsev <sergei-E844GTqJAzo@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Assign returned file descriptor directly to `fd', without intermediate
`ret' variable.

Signed-off-by: Sergei Zviagintsev <sergei-E844GTqJAzo@public.gmane.org>
---
 tools/testing/selftests/kdbus/kdbus-util.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/tools/testing/selftests/kdbus/kdbus-util.c b/tools/testing/selftests/kdbus/kdbus-util.c
index a3e49b04f3a7..f9102264cfb9 100644
--- a/tools/testing/selftests/kdbus/kdbus-util.c
+++ b/tools/testing/selftests/kdbus/kdbus-util.c
@@ -408,11 +408,9 @@ int sys_memfd_create(const char *name, __u64 size)
 {
 	int ret, fd;
 
-	ret = syscall(__NR_memfd_create, name, MFD_ALLOW_SEALING);
-	if (ret < 0)
-		return ret;
-
-	fd = ret;
+	fd = syscall(__NR_memfd_create, name, MFD_ALLOW_SEALING);
+	if (fd < 0)
+		return fd;
 
 	ret = ftruncate(fd, size);
 	if (ret < 0) {
-- 
1.8.3.1
