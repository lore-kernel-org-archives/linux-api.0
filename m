From: Zhang Zhen <zhenzhang.zhang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] seltests/zram: fix syntax error
Date: Mon, 14 Sep 2015 12:13:27 +0800
Message-ID: <55F64967.3090508@huawei.com>
References: <1442203768-35696-1-git-send-email-zhenzhang.zhang@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1442203768-35696-1-git-send-email-zhenzhang.zhang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org, naresh.kamboju-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, alexey.kodanev-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org
Cc: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

Not all shells define a variable UID. This is a bash and zsh feature only.
In other shells, the UID variable is not defined, so here test command
expands to [ != 0 ] which is a syntax error.

Without this patch:
root@HGH1000007090:/opt/work/linux/tools/testing/selftests/zram# sh zram.sh
zram.sh: 8: [: !=: unexpected operator
zram.sh : No zram.ko module or /dev/zram0 device file not found
zram.sh : CONFIG_ZRAM is not set

With this patch:
root@HGH1000007090:/opt/work/linux/tools/testing/selftests/zram# sh ./zram.sh
zram.sh : No zram.ko module or /dev/zram0 device file not found
zram.sh : CONFIG_ZRAM is not set

Signed-off-by: Zhang Zhen <zhenzhang.zhang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
---
 tools/testing/selftests/zram/zram.sh     | 10 +---------
 tools/testing/selftests/zram/zram_lib.sh |  3 ++-
 2 files changed, 3 insertions(+), 10 deletions(-)

diff --git a/tools/testing/selftests/zram/zram.sh b/tools/testing/selftests/zram/zram.sh
index 20de9a7..683a292 100755
--- a/tools/testing/selftests/zram/zram.sh
+++ b/tools/testing/selftests/zram/zram.sh
@@ -1,15 +1,7 @@
 #!/bin/bash
 TCID="zram.sh"

-check_prereqs()
-{
-	local msg="skip all tests:"
-
-	if [ $UID != 0 ]; then
-		echo $msg must be run as root >&2
-		exit 0
-	fi
-}
+. ./zram_lib.sh

 run_zram () {
 echo "--------------------"
diff --git a/tools/testing/selftests/zram/zram_lib.sh b/tools/testing/selftests/zram/zram_lib.sh
index 424e68e..f561a17 100755
--- a/tools/testing/selftests/zram/zram_lib.sh
+++ b/tools/testing/selftests/zram/zram_lib.sh
@@ -23,8 +23,9 @@ trap INT
 check_prereqs()
 {
 	local msg="skip all tests:"
+	local uid=$(id -u)

-	if [ $UID != 0 ]; then
+	if [ $uid -ne 0 ]; then
 		echo $msg must be run as root >&2
 		exit 0
 	fi
-- 
1.9.1


.
