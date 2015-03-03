From: Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 7/9] selftests/timers: Use implicit rules
Date: Tue,  3 Mar 2015 15:51:40 +1100
Message-ID: <1425358302-16680-7-git-send-email-mpe@ellerman.id.au>
References: <1425358302-16680-1-git-send-email-mpe@ellerman.id.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1425358302-16680-1-git-send-email-mpe@ellerman.id.au>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: shuahkh@osg.samsung.com, davej@codemonkey.org.uk, mmarek@suse.cz, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

There's no need to open-code the build rules, use the implicit ones.

This has the nice side effect of enabling cross compilation.

Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
---
 tools/testing/selftests/timers/Makefile | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/tools/testing/selftests/timers/Makefile b/tools/testing/selftests/timers/Makefile
index 149cee3b7b8a..87340405e4b3 100644
--- a/tools/testing/selftests/timers/Makefile
+++ b/tools/testing/selftests/timers/Makefile
@@ -1,9 +1,9 @@
-all:
-	gcc posix_timers.c -o posix_timers -lrt
-
 TEST_PROGS := posix_timers
+LDLIBS += -lrt
+
+all: $(TEST_PROGS)
 
 include ../lib.mk
 
 clean:
-	rm -f ./posix_timers
+	rm -f $(TEST_PROGS)
-- 
2.1.0
