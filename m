From: Brian Norris <computersforpeace-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH v2 1/5] test: firmware_class: report errors properly on failure
Date: Wed,  9 Dec 2015 14:50:25 -0800
Message-ID: <1449701429-121423-1-git-send-email-computersforpeace@gmail.com>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Ming Lei <ming.lei-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
Cc: Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Brian Norris <computersforpeace-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Luis R. Rodriguez" <mcgrof-IBi9RG/b67k@public.gmane.org>
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

Signed-off-by: Brian Norris <computersforpeace-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Acked-by: Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
---
v2: no change

v1: thread starts here:
    https://lkml.org/lkml/2015/12/8/816

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
