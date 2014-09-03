From: Pranith Kumar <bobby.prani-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH v3] memfd_test: Make it work on 32-bit systems
Date: Wed,  3 Sep 2014 10:31:16 -0400
Message-ID: <1409754679-22667-1-git-send-email-bobby.prani@gmail.com>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>, David Herrmann <dh.herrmann-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, "open list:KERNEL SELFTEST F..." <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, open list <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

This test currently fails on 32-bit systems since we use u64 type to pass the
flags to fcntl.

This commit changes this to use 'unsigned int' type for flags to fcntl making it
work on 32-bit systems.

Signed-off-by: Pranith Kumar <bobby.prani-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Reviewed-by: David Herrmann <dh.herrmann-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 tools/testing/selftests/memfd/memfd_test.c | 34 ++++++++++++++----------------
 1 file changed, 16 insertions(+), 18 deletions(-)

diff --git a/tools/testing/selftests/memfd/memfd_test.c b/tools/testing/selftests/memfd/memfd_test.c
index 3634c90..cb5001b 100644
--- a/tools/testing/selftests/memfd/memfd_test.c
+++ b/tools/testing/selftests/memfd/memfd_test.c
@@ -59,9 +59,9 @@ static void mfd_fail_new(const char *name, unsigned int flags)
 	}
 }
 
-static __u64 mfd_assert_get_seals(int fd)
+static unsigned int mfd_assert_get_seals(int fd)
 {
-	long r;
+	int r;
 
 	r = fcntl(fd, F_GET_SEALS);
 	if (r < 0) {
@@ -69,50 +69,48 @@ static __u64 mfd_assert_get_seals(int fd)
 		abort();
 	}
 
-	return r;
+	return (unsigned int)r;
 }
 
-static void mfd_assert_has_seals(int fd, __u64 seals)
+static void mfd_assert_has_seals(int fd, unsigned int seals)
 {
-	__u64 s;
+	unsigned int s;
 
 	s = mfd_assert_get_seals(fd);
 	if (s != seals) {
-		printf("%llu != %llu = GET_SEALS(%d)\n",
-		       (unsigned long long)seals, (unsigned long long)s, fd);
+		printf("%u != %u = GET_SEALS(%d)\n", seals, s, fd);
 		abort();
 	}
 }
 
-static void mfd_assert_add_seals(int fd, __u64 seals)
+static void mfd_assert_add_seals(int fd, unsigned int seals)
 {
-	long r;
-	__u64 s;
+	int r;
+	unsigned int s;
 
 	s = mfd_assert_get_seals(fd);
 	r = fcntl(fd, F_ADD_SEALS, seals);
 	if (r < 0) {
-		printf("ADD_SEALS(%d, %llu -> %llu) failed: %m\n",
-		       fd, (unsigned long long)s, (unsigned long long)seals);
+		printf("ADD_SEALS(%d, %u -> %u) failed: %m\n", fd, s, seals);
 		abort();
 	}
 }
 
-static void mfd_fail_add_seals(int fd, __u64 seals)
+static void mfd_fail_add_seals(int fd, unsigned int seals)
 {
-	long r;
-	__u64 s;
+	int r;
+	unsigned int s;
 
 	r = fcntl(fd, F_GET_SEALS);
 	if (r < 0)
 		s = 0;
 	else
-		s = r;
+		s = (unsigned int)r;
 
 	r = fcntl(fd, F_ADD_SEALS, seals);
 	if (r >= 0) {
-		printf("ADD_SEALS(%d, %llu -> %llu) didn't fail as expected\n",
-		       fd, (unsigned long long)s, (unsigned long long)seals);
+		printf("ADD_SEALS(%d, %u -> %u) didn't fail as expected\n",
+				fd, s, seals);
 		abort();
 	}
 }
-- 
2.1.0
