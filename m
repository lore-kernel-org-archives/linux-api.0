From: Zhang Zhen <zhenzhang.zhang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] selftests/mount: output error messages when mount test fail
Date: Thu, 2 Apr 2015 14:52:30 +0800
Message-ID: <551CE72E.3050303@huawei.com>
References: <1427957214-40367-1-git-send-email-zhenzhang.zhang@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1427957214-40367-1-git-send-email-zhenzhang.zhang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org, mpe-Gsx/Oe8HsFggBc27wqDAHg@public.gmane.org, ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org
List-Id: linux-api@vger.kernel.org

Without this patch, if /proc/self/uid_map is not exist,
the mount test case will fail and no any prompting.

After applied this patch, the case will prompt why it fail.
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
ERROR: No /proc/self/uid_map exist
make[1]: Leaving directory `/opt/kernel/tools/testing/selftests/mount'
make: Leaving directory `/opt/kernel/tools/testing/selftests'

Signed-off-by: Zhang Zhen <zhenzhang.zhang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
---
 tools/testing/selftests/mount/Makefile | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/mount/Makefile b/tools/testing/selftests/mount/Makefile
index a5b367f..b3266db 100644
--- a/tools/testing/selftests/mount/Makefile
+++ b/tools/testing/selftests/mount/Makefile
@@ -8,7 +8,12 @@ unprivileged-remount-test: unprivileged-remount-test.c
 include ../lib.mk

 TEST_PROGS := unprivileged-remount-test
-override RUN_TESTS := if [ -f /proc/self/uid_map ] ; then ./unprivileged-remount-test ; fi
+override RUN_TESTS :=  @if [ -f /proc/self/uid_map ] ; \
+			then	\
+				./unprivileged-remount-test ; \
+			else	\
+				echo "ERROR: No /proc/self/uid_map exist" ; \
+			fi
 override EMIT_TESTS := echo "$(RUN_TESTS)"

 clean:
-- 
1.8.5.5


.
