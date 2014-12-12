From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: [PATCH v10 5/8] tpm: device class for tpm
Date: Fri, 12 Dec 2014 11:46:37 -0800
Message-ID: <1418413600-5400-6-git-send-email-jarkko.sakkinen@linux.intel.com>
References: <1418413600-5400-1-git-send-email-jarkko.sakkinen@linux.intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1418413600-5400-1-git-send-email-jarkko.sakkinen@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Peter Huewe <peterhuewe@gmx.de>, Ashley Lai <ashley@ashleylai.com>, Marcel Selhorst <tpmdd@selhorst.net>
Cc: tpmdd-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org, josh@joshtriplett.org, christophe.ricard@gmail.com, jason.gunthorpe@obsidianresearch.com, stefanb@linux.vnet.ibm.com, linux-api@vger.kernel.org, trousers-tech@lists.sourceforge.net, Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
List-Id: linux-api@vger.kernel.org

Added own device class for TPM. Uses MISC_MAJOR:TPM_MINOR for the
first character device in order to retain backwards compatibility.
Added tpm_dev_release() back attached to the character device.

I've been running this code now for a while on my laptop (Lenovo
T430S) TrouSerS works perfectly without modifications. I don't
believe it breaks anything significantly.

The sysfs attributes that have been placed under the wrong place
and are against sysfs-rules.txt should be probably left to
stagnate under platform device directory and start defining
new sysfs attributes to the char device directory.

Guidelines for future TPM sysfs attributes should be probably
along the lines of

- Single flat set of mandatory sysfs attributes. For example,
  current PPI interface is way way too rich when you only want
  to use it to clear and activate the TPM.

- Define sysfs attribute if and only if there's no way to get
  the value from ring-3. No attributes for TPM properties. It's
  just unnecessary maintenance hurdle that we don't want.

Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Reviewed-by: Jasob Gunthorpe <jason.gunthorpe@obsidianresearch.com>
Reviewed-by: Stephan Berger <stephan.berger@linux.vnet.ibm.com>
---
 Documentation/ABI/stable/sysfs-class-tpm | 22 +++++-----
 drivers/char/tpm/tpm-chip.c              | 72 +++++++++++++++++++++++++++-----
 drivers/char/tpm/tpm-dev.c               | 36 ++--------------
 drivers/char/tpm/tpm-interface.c         | 29 +++++++++++++
 drivers/char/tpm/tpm.h                   | 12 ++++--
 drivers/char/tpm/tpm_i2c_nuvoton.c       |  2 +-
 drivers/char/tpm/tpm_tis.c               |  4 +-
 7 files changed, 116 insertions(+), 61 deletions(-)

diff --git a/Documentation/ABI/stable/sysfs-class-tpm b/Documentation/ABI/stable/sysfs-class-tpm
index a60b45e..9f790ee 100644
--- a/Documentation/ABI/stable/sysfs-class-tpm
+++ b/Documentation/ABI/stable/sysfs-class-tpm
@@ -1,4 +1,4 @@
-What:		/sys/class/misc/tpmX/device/
+What:		/sys/class/tpm/tpmX/device/
 Date:		April 2005
 KernelVersion:	2.6.12
 Contact:	tpmdd-devel@lists.sf.net
@@ -6,7 +6,7 @@ Description:	The device/ directory under a specific TPM instance exposes
 		the properties of that TPM chip
 
 
-What:		/sys/class/misc/tpmX/device/active
+What:		/sys/class/tpm/tpmX/device/active
 Date:		April 2006
 KernelVersion:	2.6.17
 Contact:	tpmdd-devel@lists.sf.net
@@ -18,7 +18,7 @@ Description:	The "active" property prints a '1' if the TPM chip is accepting
 		section 17 for more information on which commands are
 		available.
 
-What:		/sys/class/misc/tpmX/device/cancel
+What:		/sys/class/tpm/tpmX/device/cancel
 Date:		June 2005
 KernelVersion:	2.6.13
 Contact:	tpmdd-devel@lists.sf.net
@@ -26,7 +26,7 @@ Description:	The "cancel" property allows you to cancel the currently
 		pending TPM command. Writing any value to cancel will call the
 		TPM vendor specific cancel operation.
 
-What:		/sys/class/misc/tpmX/device/caps
+What:		/sys/class/tpm/tpmX/device/caps
 Date:		April 2005
 KernelVersion:	2.6.12
 Contact:	tpmdd-devel@lists.sf.net
@@ -43,7 +43,7 @@ Description:	The "caps" property contains TPM manufacturer and version info.
 		the chip supports. Firmware version is that of the chip and
 		is manufacturer specific.
 
-What:		/sys/class/misc/tpmX/device/durations
+What:		/sys/class/tpm/tpmX/device/durations
 Date:		March 2011
 KernelVersion:	3.1
 Contact:	tpmdd-devel@lists.sf.net
@@ -66,7 +66,7 @@ Description:	The "durations" property shows the 3 vendor-specific values
 		scaled to be displayed in usecs. In this case "[adjusted]"
 		will be displayed in place of "[original]".
 
-What:		/sys/class/misc/tpmX/device/enabled
+What:		/sys/class/tpm/tpmX/device/enabled
 Date:		April 2006
 KernelVersion:	2.6.17
 Contact:	tpmdd-devel@lists.sf.net
@@ -75,7 +75,7 @@ Description:	The "enabled" property prints a '1' if the TPM chip is enabled,
 		may be visible but produce a '0' after some operation that
 		disables the TPM.
 
-What:		/sys/class/misc/tpmX/device/owned
+What:		/sys/class/tpm/tpmX/device/owned
 Date:		April 2006
 KernelVersion:	2.6.17
 Contact:	tpmdd-devel@lists.sf.net
@@ -83,7 +83,7 @@ Description:	The "owned" property produces a '1' if the TPM_TakeOwnership
 		ordinal has been executed successfully in the chip. A '0'
 		indicates that ownership hasn't been taken.
 
-What:		/sys/class/misc/tpmX/device/pcrs
+What:		/sys/class/tpm/tpmX/device/pcrs
 Date:		April 2005
 KernelVersion:	2.6.12
 Contact:	tpmdd-devel@lists.sf.net
@@ -106,7 +106,7 @@ Description:	The "pcrs" property will dump the current value of all Platform
 		1.2 chips, PCRs represent SHA-1 hashes, which are 20 bytes
 		long. Use the "caps" property to determine TPM version.
 
-What:		/sys/class/misc/tpmX/device/pubek
+What:		/sys/class/tpm/tpmX/device/pubek
 Date:		April 2005
 KernelVersion:	2.6.12
 Contact:	tpmdd-devel@lists.sf.net
@@ -158,7 +158,7 @@ Description:	The "pubek" property will return the TPM's public endorsement
 		Modulus Length: 256 (bytes)
 		Modulus:	The 256 byte Endorsement Key modulus
 
-What:		/sys/class/misc/tpmX/device/temp_deactivated
+What:		/sys/class/tpm/tpmX/device/temp_deactivated
 Date:		April 2006
 KernelVersion:	2.6.17
 Contact:	tpmdd-devel@lists.sf.net
@@ -167,7 +167,7 @@ Description:	The "temp_deactivated" property returns a '1' if the chip has
 		cycle. Whether a warm boot (reboot) will clear a TPM chip
 		from a temp_deactivated state is platform specific.
 
-What:		/sys/class/misc/tpmX/device/timeouts
+What:		/sys/class/tpm/tpmX/device/timeouts
 Date:		March 2011
 KernelVersion:	3.1
 Contact:	tpmdd-devel@lists.sf.net
diff --git a/drivers/char/tpm/tpm-chip.c b/drivers/char/tpm/tpm-chip.c
index e72b042..7596eef 100644
--- a/drivers/char/tpm/tpm-chip.c
+++ b/drivers/char/tpm/tpm-chip.c
@@ -25,6 +25,7 @@
 #include <linux/mutex.h>
 #include <linux/spinlock.h>
 #include <linux/freezer.h>
+#include <linux/major.h>
 #include "tpm.h"
 #include "tpm_eventlog.h"
 
@@ -32,6 +33,9 @@ static DECLARE_BITMAP(dev_mask, TPM_NUM_DEVICES);
 static LIST_HEAD(tpm_chip_list);
 static DEFINE_SPINLOCK(driver_lock);
 
+struct class *tpm_class;
+dev_t tpm_devt;
+
 /*
  * tpm_chip_find_get - return tpm_chip for a given chip number
  * @chip_num the device number for the chip
@@ -55,16 +59,14 @@ struct tpm_chip *tpm_chip_find_get(int chip_num)
 }
 
 /**
- * tpmm_chip_remove() - free chip memory and device number
- * @data: points to struct tpm_chip instance
+ * tpm_dev_release() - free chip memory and the device number
+ * @dev: the character device for the TPM chip
  *
- * This is used internally by tpmm_chip_alloc() and called by devres
- * when the device is released. This function does the opposite of
- * tpmm_chip_alloc() freeing memory and the device number.
+ * This is used as the release function for the character device.
  */
-static void tpmm_chip_remove(void *data)
+static void tpm_dev_release(struct device *dev)
 {
-	struct tpm_chip *chip = (struct tpm_chip *) data;
+	struct tpm_chip *chip = container_of(dev, struct tpm_chip, dev);
 
 	spin_lock(&driver_lock);
 	clear_bit(chip->dev_num, dev_mask);
@@ -111,18 +113,68 @@ struct tpm_chip *tpmm_chip_alloc(struct device *dev,
 	scnprintf(chip->devname, sizeof(chip->devname), "tpm%d", chip->dev_num);
 
 	chip->pdev = dev;
-	devm_add_action(dev, tpmm_chip_remove, chip);
+
 	dev_set_drvdata(dev, chip);
 
+	chip->dev.class = tpm_class;
+	chip->dev.release = tpm_dev_release;
+	chip->dev.parent = chip->pdev;
+
+	if (chip->dev_num == 0)
+		chip->dev.devt = MKDEV(MISC_MAJOR, TPM_MINOR);
+	else
+		chip->dev.devt = MKDEV(MAJOR(tpm_devt), chip->dev_num);
+
+	dev_set_name(&chip->dev, chip->devname);
+
+	device_initialize(&chip->dev);
+
+	chip->cdev.owner = chip->pdev->driver->owner;
+	cdev_init(&chip->cdev, &tpm_fops);
+
 	return chip;
 }
 EXPORT_SYMBOL_GPL(tpmm_chip_alloc);
 
+static int tpm_dev_add_device(struct tpm_chip *chip)
+{
+	int rc;
+
+	rc = device_add(&chip->dev);
+	if (rc) {
+		dev_err(&chip->dev,
+			"unable to device_register() %s, major %d, minor %d, err=%d\n",
+			chip->devname, MAJOR(chip->dev.devt),
+			MINOR(chip->dev.devt), rc);
+
+		return rc;
+	}
+
+	rc = cdev_add(&chip->cdev, chip->dev.devt, 1);
+	if (rc) {
+		dev_err(&chip->dev,
+			"unable to cdev_add() %s, major %d, minor %d, err=%d\n",
+			chip->devname, MAJOR(chip->dev.devt),
+			MINOR(chip->dev.devt), rc);
+
+		device_unregister(&chip->dev);
+		return rc;
+	}
+
+	return rc;
+}
+
+static void tpm_dev_del_device(struct tpm_chip *chip)
+{
+	cdev_del(&chip->cdev);
+	device_unregister(&chip->dev);
+}
+
 /*
- * tpm_chip_register() - create a misc driver for the TPM chip
+ * tpm_chip_register() - create a character device for the TPM chip
  * @chip: TPM chip to use.
  *
- * Creates a misc driver for the TPM chip and adds sysfs interfaces for
+ * Creates a character device for the TPM chip and adds sysfs interfaces for
  * the device, PPI and TCPA. As the last step this function adds the
  * chip to the list of TPM chips available for use.
  *
diff --git a/drivers/char/tpm/tpm-dev.c b/drivers/char/tpm/tpm-dev.c
index 3568321..de0337e 100644
--- a/drivers/char/tpm/tpm-dev.c
+++ b/drivers/char/tpm/tpm-dev.c
@@ -17,7 +17,6 @@
  * License.
  *
  */
-#include <linux/miscdevice.h>
 #include <linux/slab.h>
 #include <linux/uaccess.h>
 #include "tpm.h"
@@ -54,9 +53,8 @@ static void timeout_work(struct work_struct *work)
 
 static int tpm_open(struct inode *inode, struct file *file)
 {
-	struct miscdevice *misc = file->private_data;
-	struct tpm_chip *chip = container_of(misc, struct tpm_chip,
-					     vendor.miscdev);
+	struct tpm_chip *chip =
+		container_of(inode->i_cdev, struct tpm_chip, cdev);
 	struct file_priv *priv;
 
 	/* It's assured that the chip will be opened just once,
@@ -173,7 +171,7 @@ static int tpm_release(struct inode *inode, struct file *file)
 	return 0;
 }
 
-static const struct file_operations tpm_fops = {
+const struct file_operations tpm_fops = {
 	.owner = THIS_MODULE,
 	.llseek = no_llseek,
 	.open = tpm_open,
@@ -182,32 +180,4 @@ static const struct file_operations tpm_fops = {
 	.release = tpm_release,
 };
 
-int tpm_dev_add_device(struct tpm_chip *chip)
-{
-	int rc;
 
-	chip->vendor.miscdev.fops = &tpm_fops;
-	if (chip->dev_num == 0)
-		chip->vendor.miscdev.minor = TPM_MINOR;
-	else
-		chip->vendor.miscdev.minor = MISC_DYNAMIC_MINOR;
-
-	chip->vendor.miscdev.name = chip->devname;
-	chip->vendor.miscdev.parent = chip->pdev;
-
-	rc = misc_register(&chip->vendor.miscdev);
-	if (rc) {
-		chip->vendor.miscdev.name = NULL;
-		dev_err(chip->pdev,
-			"unable to misc_register %s, minor %d err=%d\n",
-			chip->vendor.miscdev.name,
-			chip->vendor.miscdev.minor, rc);
-	}
-	return rc;
-}
-
-void tpm_dev_del_device(struct tpm_chip *chip)
-{
-	if (chip->vendor.miscdev.name)
-		misc_deregister(&chip->vendor.miscdev);
-}
diff --git a/drivers/char/tpm/tpm-interface.c b/drivers/char/tpm/tpm-interface.c
index e2af28f..b6f6b17 100644
--- a/drivers/char/tpm/tpm-interface.c
+++ b/drivers/char/tpm/tpm-interface.c
@@ -997,6 +997,35 @@ int tpm_get_random(u32 chip_num, u8 *out, size_t max)
 }
 EXPORT_SYMBOL_GPL(tpm_get_random);
 
+static int __init tpm_init(void)
+{
+	int rc;
+
+	tpm_class = class_create(THIS_MODULE, "tpm");
+	if (IS_ERR(tpm_class)) {
+		pr_err("couldn't create tpm class\n");
+		return PTR_ERR(tpm_class);
+	}
+
+	rc = alloc_chrdev_region(&tpm_devt, 0, TPM_NUM_DEVICES, "tpm");
+	if (rc < 0) {
+		pr_err("tpm: failed to allocate char dev region\n");
+		class_destroy(tpm_class);
+		return rc;
+	}
+
+	return 0;
+}
+
+static void __exit tpm_exit(void)
+{
+	class_destroy(tpm_class);
+	unregister_chrdev_region(tpm_devt, TPM_NUM_DEVICES);
+}
+
+subsys_initcall(tpm_init);
+module_exit(tpm_exit);
+
 MODULE_AUTHOR("Leendert van Doorn (leendert@watson.ibm.com)");
 MODULE_DESCRIPTION("TPM Driver");
 MODULE_VERSION("2.0");
diff --git a/drivers/char/tpm/tpm.h b/drivers/char/tpm/tpm.h
index adf6af8..d46765b 100644
--- a/drivers/char/tpm/tpm.h
+++ b/drivers/char/tpm/tpm.h
@@ -23,11 +23,11 @@
 #include <linux/fs.h>
 #include <linux/mutex.h>
 #include <linux/sched.h>
-#include <linux/miscdevice.h>
 #include <linux/platform_device.h>
 #include <linux/io.h>
 #include <linux/tpm.h>
 #include <linux/acpi.h>
+#include <linux/cdev.h>
 
 enum tpm_const {
 	TPM_MINOR = 224,	/* officially assigned */
@@ -74,7 +74,6 @@ struct tpm_vendor_specific {
 	int region_size;
 	int have_region;
 
-	struct miscdevice miscdev;
 	struct list_head list;
 	int locality;
 	unsigned long timeout_a, timeout_b, timeout_c, timeout_d; /* jiffies */
@@ -104,6 +103,9 @@ enum tpm_chip_flags {
 
 struct tpm_chip {
 	struct device *pdev;	/* Device stuff */
+	struct device dev;
+	struct cdev cdev;
+
 	const struct tpm_class_ops *ops;
 	unsigned int flags;
 
@@ -326,6 +328,10 @@ struct tpm_cmd_t {
 	tpm_cmd_params	params;
 } __packed;
 
+extern struct class *tpm_class;
+extern dev_t tpm_devt;
+extern const struct file_operations tpm_fops;
+
 ssize_t	tpm_getcap(struct device *, __be32, cap_t *, const char *);
 ssize_t tpm_transmit(struct tpm_chip *chip, const char *buf,
 		     size_t bufsiz);
@@ -346,8 +352,6 @@ extern struct tpm_chip *tpmm_chip_alloc(struct device *dev,
 extern int tpm_chip_register(struct tpm_chip *chip);
 extern void tpm_chip_unregister(struct tpm_chip *chip);
 
-int tpm_dev_add_device(struct tpm_chip *chip);
-void tpm_dev_del_device(struct tpm_chip *chip);
 int tpm_sysfs_add_device(struct tpm_chip *chip);
 void tpm_sysfs_del_device(struct tpm_chip *chip);
 
diff --git a/drivers/char/tpm/tpm_i2c_nuvoton.c b/drivers/char/tpm/tpm_i2c_nuvoton.c
index e1eadb0..9d42b7d 100644
--- a/drivers/char/tpm/tpm_i2c_nuvoton.c
+++ b/drivers/char/tpm/tpm_i2c_nuvoton.c
@@ -560,7 +560,7 @@ static int i2c_nuvoton_probe(struct i2c_client *client,
 		rc = devm_request_irq(dev, chip->vendor.irq,
 				      i2c_nuvoton_int_handler,
 				      IRQF_TRIGGER_LOW,
-				      chip->vendor.miscdev.name,
+				      chip->devname,
 				      chip);
 		if (rc) {
 			dev_err(dev, "%s() Unable to request irq: %d for use\n",
diff --git a/drivers/char/tpm/tpm_tis.c b/drivers/char/tpm/tpm_tis.c
index 6b15545..89e1abb 100644
--- a/drivers/char/tpm/tpm_tis.c
+++ b/drivers/char/tpm/tpm_tis.c
@@ -698,7 +698,7 @@ static int tpm_tis_init(struct device *dev, acpi_handle acpi_dev_handle,
 				 TPM_INT_VECTOR(chip->vendor.locality));
 			if (devm_request_irq
 			    (dev, i, tis_int_probe, IRQF_SHARED,
-			     chip->vendor.miscdev.name, chip) != 0) {
+			     chip->devname, chip) != 0) {
 				dev_info(chip->pdev,
 					 "Unable to request irq: %d for probe\n",
 					 i);
@@ -745,7 +745,7 @@ static int tpm_tis_init(struct device *dev, acpi_handle acpi_dev_handle,
 			 TPM_INT_VECTOR(chip->vendor.locality));
 		if (devm_request_irq
 		    (dev, chip->vendor.irq, tis_int_handler, IRQF_SHARED,
-		     chip->vendor.miscdev.name, chip) != 0) {
+		     chip->devname, chip) != 0) {
 			dev_info(chip->pdev,
 				 "Unable to request irq: %d for use\n",
 				 chip->vendor.irq);
-- 
2.1.0
