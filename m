From: Brian Norris <computersforpeace@gmail.com>
Subject: [PATCH 1/4] test: firmware_class: report errors properly on failure
Date: Tue,  8 Dec 2015 18:38:31 -0800
Message-ID: <1449628714-66641-1-git-send-email-computersforpeace@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Shuah Khan <shuahkh@osg.samsung.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Ming Lei <ming.lei@canonical.com>
Cc: Kees Cook <keescook@chromium.org>, Brian Norris <computersforpeace@gmail.com>, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, "Luis R. Rodriguez" <mcgrof@suse.com>
List-Id: linux-api@vger.kernel.org

request_firmware() failures currently won't get reported at all (the
error code is discarded). What's more, we get confusing messages, like:

    # echo -n notafile > /sys/devices/virtual/misc/test_firmware/trigger_request
    [ 8280.311856] test_firmware: loading 'notafile'
    [ 8280.317042] test_firmware: load of 'notafile' failed: -2
    [ 8280.322445] test_firmware: loaded: 0
    # echo $?
    0

Report the failures via write() errors, and don't say we "loaded"
anything.

Signed-off-by: Brian Norris <computersforpeace@gmail.com>
---
 lib/test_firmware.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/lib/test_firmware.c b/lib/test_firmware.c
index 86374c1c49a4..841191061816 100644
--- a/lib/test_firmware.c
+++ b/lib/test_firmware.c
@@ -65,14 +65,19 @@ static ssize_t trigger_request_store(struct device *dev,
 	release_firmware(test_firmware);
 	test_firmware = NULL;
 	rc = request_firmware(&test_firmware, name, dev);
-	if (rc)
+	if (rc) {
 		pr_info("load of '%s' failed: %d\n", name, rc);
-	pr_info("loaded: %zu\n", test_firmware ? test_firmware->size : 0);
+		goto out;
+	}
+	pr_info("loaded: %zu\n", test_firmware->size);
+	rc = count;
+
+out:
 	mutex_unlock(&test_fw_mutex);
 
 	kfree(name);
 
-	return count;
+	return rc;
 }
 static DEVICE_ATTR_WO(trigger_request);
 
-- 
2.6.0.rc2.230.g3dd15c0
