From: Peter Feiner <pfeiner-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v2 2/3] tools: adding clean target to user selftest
Date: Tue, 23 Sep 2014 12:55:19 -0700
Message-ID: <1411502120-28219-3-git-send-email-pfeiner@google.com>
References: <1411499027-17801-1-git-send-email-pfeiner@google.com>
 <1411502120-28219-1-git-send-email-pfeiner@google.com>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1411502120-28219-1-git-send-email-pfeiner-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
Cc: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, David Herrmann <dh.herrmann-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Hugh Dickens <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Peter Feiner <pfeiner-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Gets rid of this error when running 'make clean' in the selftests
directory:

make[1]: Entering directory `.../tools/testing/selftests/user'
make[1]: *** No rule to make target `clean'.  Stop.

---

v1 -> v2:
	Separated this from the parallel build patch.
---
 tools/testing/selftests/user/Makefile | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/tools/testing/selftests/user/Makefile b/tools/testing/selftests/user/Makefile
index 396255b..8eb6583 100644
--- a/tools/testing/selftests/user/Makefile
+++ b/tools/testing/selftests/user/Makefile
@@ -3,6 +3,8 @@
 # No binaries, but make sure arg-less "make" doesn't trigger "run_tests"
 all:
 
+clean:
+
 run_tests: all
 	@if /sbin/modprobe test_user_copy ; then \
 		rmmod test_user_copy; \
-- 
2.1.0.rc2.206.gedb03e5
