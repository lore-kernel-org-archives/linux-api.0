From: Zhang Zhen <zhenzhang.zhang@huawei.com>
Subject: [PATCH v2] selftests/mount: output WARN messages when mount test
 skipped
Date: Fri, 3 Apr 2015 09:39:36 +0800
Message-ID: <551DEF58.3090505@huawei.com>
References: <1428024818-28554-1-git-send-email-zhenzhang.zhang@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1428024818-28554-1-git-send-email-zhenzhang.zhang@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-api@vger.kernel.org, "linux-kernel@vger.kernel.org >> Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, shuahkh@osg.samsung.com
List-Id: linux-api@vger.kernel.org

Without this patch, if /proc/self/uid_map is not exist,
the mount test case will skipped and no any prompting.

After applied this patch, the case will prompt why it skipped.
Just as follows:
root@kernel-host:/opt/kernel> make -C tools/testing/selftests TARGETS=mount run_tests
make: Entering directory `/opt/kernel/tools/testing/selftests'
for TARGET in mount; do \
                make -C $TARGET; \
        done;
make[1]: Entering directory `/opt/kernel/tools/testing/selftests/mount'
make[1]: Nothing to be done for `all'.
make[1]: Leaving directory `/opt/kernel/tools/testing/selftests/mount'
for TARGET in mount; do \
                make -C $TARGET run_tests; \
        done;
make[1]: Entering directory `/opt/kernel/tools/testing/selftests/mount'
if [ -f /proc/self/uid_map ] ; then ./unprivileged-remount-test ; else echo "WARN: No /proc/self/uid_map exist, test skipped." ; fi
WARN: No /proc/self/uid_map exist, test skipped.
make[1]: Leaving directory `/opt/kernel/tools/testing/selftests/mount'
make: Leaving directory `/opt/kernel/tools/testing/selftests'

Change v1 -> v2:
- fix syntax error when run kselftest_install.sh

Signed-off-by: Zhang Zhen <zhenzhang.zhang@huawei.com>
---
 tools/testing/selftests/mount/Makefile | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/mount/Makefile b/tools/testing/selftests/mount/Makefile
index a5b367f..038c777 100644
--- a/tools/testing/selftests/mount/Makefile
+++ b/tools/testing/selftests/mount/Makefile
@@ -8,7 +8,12 @@ unprivileged-remount-test: unprivileged-remount-test.c
 include ../lib.mk

 TEST_PROGS := unprivileged-remount-test
-override RUN_TESTS := if [ -f /proc/self/uid_map ] ; then ./unprivileged-remount-test ; fi
+override RUN_TESTS := if [ -f /proc/self/uid_map ] ; \
+		      then	\
+				./unprivileged-remount-test ; \
+		      else	\
+				echo "WARN: No /proc/self/uid_map exist, test skipped." ; \
+		      fi
 override EMIT_TESTS := echo "$(RUN_TESTS)"

 clean:
-- 
1.8.5.5


.
