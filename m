From: Peter Feiner <pfeiner@google.com>
Subject: [PATCH v3 2/3] tools: adding clean target to user selftest
Date: Wed, 24 Sep 2014 12:42:10 -0700
Message-ID: <1411587731-25088-3-git-send-email-pfeiner@google.com>
References: <1411499027-17801-1-git-send-email-pfeiner@google.com>
 <1411587731-25088-1-git-send-email-pfeiner@google.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1411587731-25088-1-git-send-email-pfeiner@google.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Shuah Khan <shuahkh@osg.samsung.com>
Cc: linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, David Herrmann <dh.herrmann@gmail.com>, Greg Thelen <gthelen@google.com>, Hugh Dickens <hughd@google.com>, Andrew Morton <akpm@linux-foundation.org>, Peter Feiner <pfeiner@google.com>
List-Id: linux-api@vger.kernel.org

Gets rid of this error when running 'make clean' in the selftests
directory:

make[1]: Entering directory `.../tools/testing/selftests/user'
make[1]: *** No rule to make target `clean'.  Stop.

Signed-off-by: Peter Feiner <pfeiner@google.com>

---

v1 -> v2:
	Separated this from the parallel build patch.
v2 -> v3:
	Added Signed-off-by.
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
