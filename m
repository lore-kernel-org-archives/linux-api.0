From: Brian Norris <computersforpeace@gmail.com>
Subject: [PATCH v2 3/5] test: firmware_class: add asynchronous request trigger
Date: Wed,  9 Dec 2015 14:50:27 -0800
Message-ID: <1449701429-121423-3-git-send-email-computersforpeace@gmail.com>
References: <1449701429-121423-1-git-send-email-computersforpeace@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1449701429-121423-1-git-send-email-computersforpeace@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Shuah Khan <shuahkh@osg.samsung.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Ming Lei <ming.lei@canonical.com>
Cc: Kees Cook <keescook@chromium.org>, Brian Norris <computersforpeace@gmail.com>, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, "Luis R. Rodriguez" <mcgrof@suse.com>
List-Id: linux-api@vger.kernel.org

We might want to test for bugs like that found in commit f9692b2699bd
("firmware: fix possible use after free on name on asynchronous
request"), where the asynchronous request API had race conditions.

Let's add a simple file that will launch the async request, then wait
until it's complete and report the status. It's not a true async test
(we're using a mutex + wait_for_completion(), so we can't get more than
one going at the same time), but it does help make sure the basic API is
sane, and it can catch some class of bugs.

Signed-off-by: Brian Norris <computersforpeace@gmail.com>
Cc: Luis R. Rodriguez <mcgrof@suse.com>
---
v2:
 * use kstrndup()
 * don't kfree(name) too early!

 lib/test_firmware.c | 65 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 65 insertions(+)

diff --git a/lib/test_firmware.c b/lib/test_firmware.c
index 690b9c35a274..a3e8ec3fb1c5 100644
--- a/lib/test_firmware.c
+++ b/lib/test_firmware.c
@@ -12,6 +12,7 @@
 #include <linux/init.h>
 #include <linux/module.h>
 #include <linux/printk.h>
+#include <linux/completion.h>
 #include <linux/firmware.h>
 #include <linux/device.h>
 #include <linux/fs.h>
@@ -80,6 +81,57 @@ out:
 }
 static DEVICE_ATTR_WO(trigger_request);
 
+static DECLARE_COMPLETION(async_fw_done);
+
+static void trigger_async_request_cb(const struct firmware *fw, void *context)
+{
+	test_firmware = fw;
+	complete(&async_fw_done);
+}
+
+static ssize_t trigger_async_request_store(struct device *dev,
+					   struct device_attribute *attr,
+					   const char *buf, size_t count)
+{
+	int rc;
+	char *name;
+
+	name = kstrndup(buf, count, GFP_KERNEL);
+	if (!name)
+		return -ENOSPC;
+
+	pr_info("loading '%s'\n", name);
+
+	mutex_lock(&test_fw_mutex);
+	release_firmware(test_firmware);
+	test_firmware = NULL;
+	rc = request_firmware_nowait(THIS_MODULE, 1, name, dev, GFP_KERNEL,
+				     NULL, trigger_async_request_cb);
+	if (rc) {
+		pr_info("async load of '%s' failed: %d\n", name, rc);
+		kfree(name);
+		goto out;
+	}
+	/* Free 'name' ASAP, to test for race conditions */
+	kfree(name);
+
+	wait_for_completion(&async_fw_done);
+
+	if (test_firmware) {
+		pr_info("loaded: %zu\n", test_firmware->size);
+		rc = count;
+	} else {
+		pr_err("failed to async load firmware\n");
+		rc = -ENODEV;
+	}
+
+out:
+	mutex_unlock(&test_fw_mutex);
+
+	return rc;
+}
+static DEVICE_ATTR_WO(trigger_async_request);
+
 static int __init test_firmware_init(void)
 {
 	int rc;
@@ -96,9 +148,20 @@ static int __init test_firmware_init(void)
 		goto dereg;
 	}
 
+	rc = device_create_file(test_fw_misc_device.this_device,
+				&dev_attr_trigger_async_request);
+	if (rc) {
+		pr_err("could not create async sysfs interface: %d\n", rc);
+		goto remove_file;
+	}
+
 	pr_warn("interface ready\n");
 
 	return 0;
+
+remove_file:
+	device_remove_file(test_fw_misc_device.this_device,
+			   &dev_attr_trigger_async_request);
 dereg:
 	misc_deregister(&test_fw_misc_device);
 	return rc;
@@ -110,6 +173,8 @@ static void __exit test_firmware_exit(void)
 {
 	release_firmware(test_firmware);
 	device_remove_file(test_fw_misc_device.this_device,
+			   &dev_attr_trigger_async_request);
+	device_remove_file(test_fw_misc_device.this_device,
 			   &dev_attr_trigger_request);
 	misc_deregister(&test_fw_misc_device);
 	pr_warn("removed interface\n");
-- 
2.6.0.rc2.230.g3dd15c0
