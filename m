From: Peter Feiner <pfeiner-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 2/3] tools: fix warning in memfd_test
Date: Tue, 23 Sep 2014 12:05:22 -0700
Message-ID: <1411499123-18050-2-git-send-email-pfeiner@google.com>
References: <1411499027-17801-1-git-send-email-pfeiner@google.com>
 <1411499123-18050-1-git-send-email-pfeiner@google.com>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1411499123-18050-1-git-send-email-pfeiner-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
Cc: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, David Herrmann <dh.herrmann-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Hugh Dickens <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Peter Feiner <pfeiner-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

No arguments given after printf format string with "%s" conversion.

Signed-off-by: Peter Feiner <pfeiner-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

---

There are a couple of patches floating around for this one. I'm just
including it so somebody that applies this patch series doesn't get a
broken build :-)
---
 tools/testing/selftests/memfd/memfd_test.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/memfd/memfd_test.c b/tools/testing/selftests/memfd/memfd_test.c
index 3634c90..c343df8 100644
--- a/tools/testing/selftests/memfd/memfd_test.c
+++ b/tools/testing/selftests/memfd/memfd_test.c
@@ -205,7 +205,7 @@ static void mfd_fail_open(int fd, int flags, mode_t mode)
 	sprintf(buf, "/proc/self/fd/%d", fd);
 	r = open(buf, flags, mode);
 	if (r >= 0) {
-		printf("open(%s) didn't fail as expected\n");
+		printf("open(%s) didn't fail as expected\n", buf);
 		abort();
 	}
 }
-- 
2.1.0.rc2.206.gedb03e5
