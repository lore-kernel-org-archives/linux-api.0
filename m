From: Hiraku Toyooka <hiraku.toyooka.gu@hitachi.com>
Subject: [PATCH 5/5] selftests/pstore: add testcases for multiple pmsg
 instances
Date: Thu, 05 Nov 2015 11:36:56 +0900
Message-ID: <20151105023656.3367.18383.stgit@arietta>
References: <20151105023644.3367.94795.stgit@arietta>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20151105023644.3367.94795.stgit@arietta>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Tony Luck <tony.luck@intel.com>, Kees Cook <keescook@chromium.org>, linux-api@vger.kernel.org, Anton Vorontsov <anton@enomsg.org>, Shuah Khan <shuahkh@osg.samsung.com>, Mark Salyzyn <salyzyn@android.com>, Colin Cross <ccross@android.com>, Seiji Aguchi <seiji.aguchi.tr@hitachi.com>
List-Id: linux-api@vger.kernel.org

To test multiple pmsg, we should check that /dev/pmsg[N] (N > 0) is
available. After reboot, we should check that pmsg-[backend]-[N] which
keeps content is detected even if pmsg-[backend]-[N-M] (0 < M <= N)
doesn't exist due to lack of contents.

So we add the following testcases.
 - pstore_tests
   - Write unique string to the last /dev/pmsgN
 - pstore_post_reboot_tests
   - Check the last pmsg area is detected

Signed-off-by: Hiraku Toyooka <hiraku.toyooka.gu@hitachi.com>
Cc: Anton Vorontsov <anton@enomsg.org>
Cc: Colin Cross <ccross@android.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Mark Salyzyn <salyzyn@android.com>
Cc: Seiji Aguchi <seiji.aguchi.tr@hitachi.com>
Cc: Shuah Khan <shuahkh@osg.samsung.com>
Cc: Tony Luck <tony.luck@intel.com>
Cc: linux-api@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
---
 tools/testing/selftests/pstore/common_tests        |   21 ++++++++++++++--
 .../selftests/pstore/pstore_post_reboot_tests      |   27 +++++++++++---------
 tools/testing/selftests/pstore/pstore_tests        |   16 ++++++++++--
 3 files changed, 47 insertions(+), 17 deletions(-)

diff --git a/tools/testing/selftests/pstore/common_tests b/tools/testing/selftests/pstore/common_tests
index 3ea64d7..566a25d 100755
--- a/tools/testing/selftests/pstore/common_tests
+++ b/tools/testing/selftests/pstore/common_tests
@@ -27,9 +27,9 @@ show_result() { # result_value
 }
 
 check_files_exist() { # type of pstorefs file
-    if [ -e ${1}-${backend}-0 ]; then
+    if [ -e ${1}0 ]; then
 	prlog "ok"
-	for f in `ls ${1}-${backend}-*`; do
+	for f in `ls ${1}*`; do
             prlog -e "\t${f}"
 	done
     else
@@ -53,6 +53,23 @@ operate_files() { # tested value, files, operation
     fi
 }
 
+check_pmsg_content() { # pmsg filename
+    prev_uuid=`cat $TOP_DIR/prev_uuid`
+    if [ $? -eq 0 ]; then
+	nr_matched=`grep -c "$TEST_STRING_PATTERN" $1`
+	if [ "$nr_matched" = "1" ]; then
+	    grep -q "$TEST_STRING_PATTERN"$prev_uuid $1
+	    show_result $?
+	else
+	    prlog "FAIL"
+	    rc=1
+	fi
+    else
+	prlog "FAIL"
+	rc=1
+    fi
+}
+
 # Parameters
 TEST_STRING_PATTERN="Testing pstore: uuid="
 UUID=`cat /proc/sys/kernel/random/uuid`
diff --git a/tools/testing/selftests/pstore/pstore_post_reboot_tests b/tools/testing/selftests/pstore/pstore_post_reboot_tests
index 6ccb154..272498f 100755
--- a/tools/testing/selftests/pstore/pstore_post_reboot_tests
+++ b/tools/testing/selftests/pstore/pstore_post_reboot_tests
@@ -35,13 +35,13 @@ fi
 cd ${mount_point}
 
 prlog -n "Checking dmesg files exist in pstore filesystem ... "
-check_files_exist dmesg
+check_files_exist dmesg-${backend}-
 
 prlog -n "Checking console files exist in pstore filesystem ... "
-check_files_exist console
+check_files_exist console-${backend}-
 
 prlog -n "Checking pmsg files exist in pstore filesystem ... "
-check_files_exist pmsg
+check_files_exist pmsg-${backend}-
 
 prlog -n "Checking dmesg files contain oops end marker"
 grep_end_trace() {
@@ -54,16 +54,19 @@ prlog -n "Checking console file contains oops end marker ... "
 grep -q "\---\[ end trace" console-${backend}-0
 show_result $?
 
-prlog -n "Checking pmsg file properly keeps the content written before crash ... "
-prev_uuid=`cat $TOP_DIR/prev_uuid`
-if [ $? -eq 0 ]; then
-    nr_matched=`grep -c "$TEST_STRING_PATTERN" pmsg-${backend}-0`
-    if [ $nr_matched -eq 1 ]; then
-	grep -q "$TEST_STRING_PATTERN"$prev_uuid pmsg-${backend}-0
-	show_result $?
+prlog -n "Checking pmsg-"${backend}"-0 properly keeps the content written before crash ... "
+check_pmsg_content pmsg-${backend}-0
+
+prlog -n "Checking the last pmsg area is detected "
+last_num_pmsg=`ls -v pmsg-* | tail -n1 | sed -e "s/^pmsg-${backend}-\([0-9]*\).*$/\1/"`
+last_num_devpmsg=`ls -v /dev/pmsg* | tail -n1 | sed -e "s/^\/dev\/pmsg\([0-9]*\).*$/\1/"`
+#checks the last number of pmsg-*-* and /dev/pmsg* correspond.
+if [ "$last_num_pmsg" -eq "$last_num_devpmsg" ]; then
+    if [ "$last_num_pmsg" = "0" ]; then
+	prlog "... No multiple pmsg-*-* exists. We skip this testcase."
     else
-	prlog "FAIL"
-	rc=1
+	prlog -n "(pmsg-${backend}-${last_num_pmsg}) ... "
+	check_pmsg_content pmsg-${backend}-${last_num_pmsg}
     fi
 else
     prlog "FAIL"
diff --git a/tools/testing/selftests/pstore/pstore_tests b/tools/testing/selftests/pstore/pstore_tests
index f25d2a3..5abf0e5 100755
--- a/tools/testing/selftests/pstore/pstore_tests
+++ b/tools/testing/selftests/pstore/pstore_tests
@@ -13,9 +13,8 @@ prlog -n "Checking pstore console is registered ... "
 dmesg | grep -q "console \[pstore"
 show_result $?
 
-prlog -n "Checking /dev/pmsg0 exists ... "
-test -e /dev/pmsg0
-show_result $?
+prlog -n "Checking /dev/pmsg files exist ... "
+check_files_exist /dev/pmsg
 
 prlog -n "Writing unique string to /dev/pmsg0 ... "
 if [ -e "/dev/pmsg0" ]; then
@@ -27,4 +26,15 @@ else
     rc=1
 fi
 
+last_devpmsg=`ls -v /dev/pmsg* | tail -n1`
+prlog -n "Writing unique string to the last /dev/pmsgN "
+if [ "$last_devpmsg" = "/dev/pmsg0" ]; then
+    prlog "... No multiple /dev/pmsg* exists. We skip this testcase."
+else
+    prlog -n "(${last_devpmsg}) ... "
+    echo "${TEST_STRING_PATTERN}""$UUID" > ${last_devpmsg}
+    show_result $?
+
+fi
+
 exit $rc
