From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: [PATCH v7 04/10] tpm: rename chip->dev to chip->pdev
Date: Tue, 11 Nov 2014 15:45:07 +0200
Message-ID: <1415713513-16524-5-git-send-email-jarkko.sakkinen@linux.intel.com>
References: <1415713513-16524-1-git-send-email-jarkko.sakkinen@linux.intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1415713513-16524-1-git-send-email-jarkko.sakkinen@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Peter Huewe <peterhuewe@gmx.de>, Ashley Lai <ashley@ashleylai.com>, Marcel Selhorst <tpmdd@selhorst.net>
Cc: tpmdd-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org, josh.triplett@intel.com, christophe.ricard@gmail.com, jason.gunthorpe@obsidianresearch.com, linux-api@vger.kernel.org, trousers-tech@lists.sourceforge.net, Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
List-Id: linux-api@vger.kernel.org

Rename chip->dev to chip->pdev to make it explicit that this not the
character device but actually represents the platform device.

Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
---
 drivers/char/tpm/tpm-chip.c         |  4 ++--
 drivers/char/tpm/tpm-dev.c          | 10 +++++-----
 drivers/char/tpm/tpm-interface.c    | 29 +++++++++++++++--------------
 drivers/char/tpm/tpm-sysfs.c        |  6 +++---
 drivers/char/tpm/tpm.h              |  4 ++--
 drivers/char/tpm/tpm_atmel.c        | 14 +++++++-------
 drivers/char/tpm/tpm_i2c_atmel.c    | 16 ++++++++--------
 drivers/char/tpm/tpm_i2c_infineon.c |  6 +++---
 drivers/char/tpm/tpm_i2c_nuvoton.c  | 22 +++++++++++-----------
 drivers/char/tpm/tpm_i2c_stm_st33.c |  6 +++---
 drivers/char/tpm/tpm_infineon.c     | 22 +++++++++++-----------
 drivers/char/tpm/tpm_nsc.c          | 20 ++++++++++----------
 drivers/char/tpm/tpm_ppi.c          |  4 ++--
 drivers/char/tpm/tpm_tis.c          | 12 ++++++------
 14 files changed, 88 insertions(+), 87 deletions(-)

diff --git a/drivers/char/tpm/tpm-chip.c b/drivers/char/tpm/tpm-chip.c
index 647867c..96ea8eb 100644
--- a/drivers/char/tpm/tpm-chip.c
+++ b/drivers/char/tpm/tpm-chip.c
@@ -45,7 +45,7 @@ struct tpm_chip *tpm_chip_find_get(int chip_num)
 		if (chip_num != TPM_ANY_NUM && chip_num != pos->dev_num)
 			continue;
 
-		if (try_module_get(pos->dev->driver->owner)) {
+		if (try_module_get(pos->pdev->driver->owner)) {
 			chip = pos;
 			break;
 		}
@@ -111,7 +111,7 @@ struct tpm_chip *tpmm_chip_alloc(struct device *dev,
 	scnprintf(chip->devname, sizeof(chip->devname), "%s%d", "tpm",
 		  chip->dev_num);
 
-	chip->dev = dev;
+	chip->pdev = dev;
 	devm_add_action(dev, tpmm_chip_remove, chip);
 	dev_set_drvdata(dev, chip);
 
diff --git a/drivers/char/tpm/tpm-dev.c b/drivers/char/tpm/tpm-dev.c
index d9b774e..3568321 100644
--- a/drivers/char/tpm/tpm-dev.c
+++ b/drivers/char/tpm/tpm-dev.c
@@ -63,7 +63,7 @@ static int tpm_open(struct inode *inode, struct file *file)
 	 * by the check of is_open variable, which is protected
 	 * by driver_lock. */
 	if (test_and_set_bit(0, &chip->is_open)) {
-		dev_dbg(chip->dev, "Another process owns this TPM\n");
+		dev_dbg(chip->pdev, "Another process owns this TPM\n");
 		return -EBUSY;
 	}
 
@@ -81,7 +81,7 @@ static int tpm_open(struct inode *inode, struct file *file)
 	INIT_WORK(&priv->work, timeout_work);
 
 	file->private_data = priv;
-	get_device(chip->dev);
+	get_device(chip->pdev);
 	return 0;
 }
 
@@ -168,7 +168,7 @@ static int tpm_release(struct inode *inode, struct file *file)
 	file->private_data = NULL;
 	atomic_set(&priv->data_pending, 0);
 	clear_bit(0, &priv->chip->is_open);
-	put_device(priv->chip->dev);
+	put_device(priv->chip->pdev);
 	kfree(priv);
 	return 0;
 }
@@ -193,12 +193,12 @@ int tpm_dev_add_device(struct tpm_chip *chip)
 		chip->vendor.miscdev.minor = MISC_DYNAMIC_MINOR;
 
 	chip->vendor.miscdev.name = chip->devname;
-	chip->vendor.miscdev.parent = chip->dev;
+	chip->vendor.miscdev.parent = chip->pdev;
 
 	rc = misc_register(&chip->vendor.miscdev);
 	if (rc) {
 		chip->vendor.miscdev.name = NULL;
-		dev_err(chip->dev,
+		dev_err(chip->pdev,
 			"unable to misc_register %s, minor %d err=%d\n",
 			chip->vendor.miscdev.name,
 			chip->vendor.miscdev.minor, rc);
diff --git a/drivers/char/tpm/tpm-interface.c b/drivers/char/tpm/tpm-interface.c
index 915c610..e6b08bd 100644
--- a/drivers/char/tpm/tpm-interface.c
+++ b/drivers/char/tpm/tpm-interface.c
@@ -343,7 +343,7 @@ ssize_t tpm_transmit(struct tpm_chip *chip, const char *buf,
 	if (count == 0)
 		return -ENODATA;
 	if (count > bufsiz) {
-		dev_err(chip->dev,
+		dev_err(chip->pdev,
 			"invalid count value %x %zx\n", count, bufsiz);
 		return -E2BIG;
 	}
@@ -352,7 +352,7 @@ ssize_t tpm_transmit(struct tpm_chip *chip, const char *buf,
 
 	rc = chip->ops->send(chip, (u8 *) buf, count);
 	if (rc < 0) {
-		dev_err(chip->dev,
+		dev_err(chip->pdev,
 			"tpm_transmit: tpm_send: error %zd\n", rc);
 		goto out;
 	}
@@ -368,7 +368,7 @@ ssize_t tpm_transmit(struct tpm_chip *chip, const char *buf,
 			goto out_recv;
 
 		if (chip->ops->req_canceled(chip, status)) {
-			dev_err(chip->dev, "Operation Canceled\n");
+			dev_err(chip->pdev, "Operation Canceled\n");
 			rc = -ECANCELED;
 			goto out;
 		}
@@ -378,14 +378,14 @@ ssize_t tpm_transmit(struct tpm_chip *chip, const char *buf,
 	} while (time_before(jiffies, stop));
 
 	chip->ops->cancel(chip);
-	dev_err(chip->dev, "Operation Timed out\n");
+	dev_err(chip->pdev, "Operation Timed out\n");
 	rc = -ETIME;
 	goto out;
 
 out_recv:
 	rc = chip->ops->recv(chip, (u8 *) buf, bufsiz);
 	if (rc < 0)
-		dev_err(chip->dev,
+		dev_err(chip->pdev,
 			"tpm_transmit: tpm_recv: error %zd\n", rc);
 out:
 	mutex_unlock(&chip->tpm_mutex);
@@ -411,7 +411,8 @@ ssize_t tpm_transmit_cmd(struct tpm_chip *chip, void *cmd,
 
 	err = be32_to_cpu(header->return_code);
 	if (err != 0 && desc)
-		dev_err(chip->dev, "A TPM error (%d) occurred %s\n", err, desc);
+		dev_err(chip->pdev, "A TPM error (%d) occurred %s\n", err,
+			desc);
 
 	return err;
 }
@@ -505,7 +506,7 @@ int tpm_get_timeouts(struct tpm_chip *chip)
 	if (rc == TPM_ERR_INVALID_POSTINIT) {
 		/* The TPM is not started, we are the first to talk to it.
 		   Execute a startup command. */
-		dev_info(chip->dev, "Issuing TPM_STARTUP");
+		dev_info(chip->pdev, "Issuing TPM_STARTUP");
 		if (tpm_startup(chip, TPM_ST_CLEAR))
 			return rc;
 
@@ -517,7 +518,7 @@ int tpm_get_timeouts(struct tpm_chip *chip)
 				  NULL);
 	}
 	if (rc) {
-		dev_err(chip->dev,
+		dev_err(chip->pdev,
 			"A TPM error (%zd) occurred attempting to determine the timeouts\n",
 			rc);
 		goto duration;
@@ -556,7 +557,7 @@ int tpm_get_timeouts(struct tpm_chip *chip)
 
 	/* Report adjusted timeouts */
 	if (chip->vendor.timeout_adjusted) {
-		dev_info(chip->dev,
+		dev_info(chip->pdev,
 			 HW_ERR "Adjusting reported timeouts: A %lu->%luus B %lu->%luus C %lu->%luus D %lu->%luus\n",
 			 old_timeout[0], new_timeout[0],
 			 old_timeout[1], new_timeout[1],
@@ -603,7 +604,7 @@ duration:
 		chip->vendor.duration[TPM_MEDIUM] *= 1000;
 		chip->vendor.duration[TPM_LONG] *= 1000;
 		chip->vendor.duration_adjusted = true;
-		dev_info(chip->dev, "Adjusting TPM timeout parameters.");
+		dev_info(chip->pdev, "Adjusting TPM timeout parameters.");
 	}
 	return 0;
 }
@@ -760,7 +761,7 @@ int tpm_do_selftest(struct tpm_chip *chip)
 		 * around 300ms while the self test is ongoing, keep trying
 		 * until the self test duration expires. */
 		if (rc == -ETIME) {
-			dev_info(chip->dev, HW_ERR "TPM command timed out during continue self test");
+			dev_info(chip->pdev, HW_ERR "TPM command timed out during continue self test");
 			msleep(delay_msec);
 			continue;
 		}
@@ -770,7 +771,7 @@ int tpm_do_selftest(struct tpm_chip *chip)
 
 		rc = be32_to_cpu(cmd.header.out.return_code);
 		if (rc == TPM_ERR_DISABLED || rc == TPM_ERR_DEACTIVATED) {
-			dev_info(chip->dev,
+			dev_info(chip->pdev,
 				 "TPM is disabled/deactivated (0x%X)\n", rc);
 			/* TPM is disabled and/or deactivated; driver can
 			 * proceed and TPM does handle commands for
@@ -918,10 +919,10 @@ int tpm_pm_suspend(struct device *dev)
 	}
 
 	if (rc)
-		dev_err(chip->dev,
+		dev_err(chip->pdev,
 			"Error (%d) sending savestate before suspend\n", rc);
 	else if (try > 0)
-		dev_warn(chip->dev, "TPM savestate took %dms\n",
+		dev_warn(chip->pdev, "TPM savestate took %dms\n",
 			 try * TPM_TIMEOUT_RETRY);
 
 	return rc;
diff --git a/drivers/char/tpm/tpm-sysfs.c b/drivers/char/tpm/tpm-sysfs.c
index 8ecb052..ee66fd4 100644
--- a/drivers/char/tpm/tpm-sysfs.c
+++ b/drivers/char/tpm/tpm-sysfs.c
@@ -284,16 +284,16 @@ static const struct attribute_group tpm_dev_group = {
 int tpm_sysfs_add_device(struct tpm_chip *chip)
 {
 	int err;
-	err = sysfs_create_group(&chip->dev->kobj,
+	err = sysfs_create_group(&chip->pdev->kobj,
 				 &tpm_dev_group);
 
 	if (err)
-		dev_err(chip->dev,
+		dev_err(chip->pdev,
 			"failed to create sysfs attributes, %d\n", err);
 	return err;
 }
 
 void tpm_sysfs_del_device(struct tpm_chip *chip)
 {
-	sysfs_remove_group(&chip->dev->kobj, &tpm_dev_group);
+	sysfs_remove_group(&chip->pdev->kobj, &tpm_dev_group);
 }
diff --git a/drivers/char/tpm/tpm.h b/drivers/char/tpm/tpm.h
index 69f4003..b3a7c76 100644
--- a/drivers/char/tpm/tpm.h
+++ b/drivers/char/tpm/tpm.h
@@ -98,7 +98,7 @@ struct tpm_vendor_specific {
 #define TPM_PPI_VERSION_LEN		3
 
 struct tpm_chip {
-	struct device *dev;	/* Device stuff */
+	struct device *pdev;	/* Device stuff */
 	const struct tpm_class_ops *ops;
 
 	int dev_num;		/* /dev/tpm# */
@@ -124,7 +124,7 @@ struct tpm_chip {
 
 static inline void tpm_chip_put(struct tpm_chip *chip)
 {
-	module_put(chip->dev->driver->owner);
+	module_put(chip->pdev->driver->owner);
 }
 
 static inline int tpm_read_index(int base, int index)
diff --git a/drivers/char/tpm/tpm_atmel.c b/drivers/char/tpm/tpm_atmel.c
index 8e2576a..8a52ebe 100644
--- a/drivers/char/tpm/tpm_atmel.c
+++ b/drivers/char/tpm/tpm_atmel.c
@@ -49,7 +49,7 @@ static int tpm_atml_recv(struct tpm_chip *chip, u8 *buf, size_t count)
 	for (i = 0; i < 6; i++) {
 		status = ioread8(chip->vendor.iobase + 1);
 		if ((status & ATML_STATUS_DATA_AVAIL) == 0) {
-			dev_err(chip->dev, "error reading header\n");
+			dev_err(chip->pdev, "error reading header\n");
 			return -EIO;
 		}
 		*buf++ = ioread8(chip->vendor.iobase);
@@ -60,12 +60,12 @@ static int tpm_atml_recv(struct tpm_chip *chip, u8 *buf, size_t count)
 	size = be32_to_cpu(*native_size);
 
 	if (count < size) {
-		dev_err(chip->dev,
+		dev_err(chip->pdev,
 			"Recv size(%d) less than available space\n", size);
 		for (; i < size; i++) {	/* clear the waiting data anyway */
 			status = ioread8(chip->vendor.iobase + 1);
 			if ((status & ATML_STATUS_DATA_AVAIL) == 0) {
-				dev_err(chip->dev, "error reading data\n");
+				dev_err(chip->pdev, "error reading data\n");
 				return -EIO;
 			}
 		}
@@ -76,7 +76,7 @@ static int tpm_atml_recv(struct tpm_chip *chip, u8 *buf, size_t count)
 	for (; i < size; i++) {
 		status = ioread8(chip->vendor.iobase + 1);
 		if ((status & ATML_STATUS_DATA_AVAIL) == 0) {
-			dev_err(chip->dev, "error reading data\n");
+			dev_err(chip->pdev, "error reading data\n");
 			return -EIO;
 		}
 		*buf++ = ioread8(chip->vendor.iobase);
@@ -86,7 +86,7 @@ static int tpm_atml_recv(struct tpm_chip *chip, u8 *buf, size_t count)
 	status = ioread8(chip->vendor.iobase + 1);
 
 	if (status & ATML_STATUS_DATA_AVAIL) {
-		dev_err(chip->dev, "data available is stuck\n");
+		dev_err(chip->pdev, "data available is stuck\n");
 		return -EIO;
 	}
 
@@ -97,9 +97,9 @@ static int tpm_atml_send(struct tpm_chip *chip, u8 *buf, size_t count)
 {
 	int i;
 
-	dev_dbg(chip->dev, "tpm_atml_send:\n");
+	dev_dbg(chip->pdev, "tpm_atml_send:\n");
 	for (i = 0; i < count; i++) {
-		dev_dbg(chip->dev, "%d 0x%x(%d)\n",  i, buf[i], buf[i]);
+		dev_dbg(chip->pdev, "%d 0x%x(%d)\n",  i, buf[i], buf[i]);
  		iowrite8(buf[i], chip->vendor.iobase);
 	}
 
diff --git a/drivers/char/tpm/tpm_i2c_atmel.c b/drivers/char/tpm/tpm_i2c_atmel.c
index 8af3b4a..dfef1ae 100644
--- a/drivers/char/tpm/tpm_i2c_atmel.c
+++ b/drivers/char/tpm/tpm_i2c_atmel.c
@@ -52,7 +52,7 @@ struct priv_data {
 static int i2c_atmel_send(struct tpm_chip *chip, u8 *buf, size_t len)
 {
 	struct priv_data *priv = chip->vendor.priv;
-	struct i2c_client *client = to_i2c_client(chip->dev);
+	struct i2c_client *client = to_i2c_client(chip->pdev);
 	s32 status;
 
 	priv->len = 0;
@@ -62,7 +62,7 @@ static int i2c_atmel_send(struct tpm_chip *chip, u8 *buf, size_t len)
 
 	status = i2c_master_send(client, buf, len);
 
-	dev_dbg(chip->dev,
+	dev_dbg(chip->pdev,
 		"%s(buf=%*ph len=%0zx) -> sts=%d\n", __func__,
 		(int)min_t(size_t, 64, len), buf, len, status);
 	return status;
@@ -71,7 +71,7 @@ static int i2c_atmel_send(struct tpm_chip *chip, u8 *buf, size_t len)
 static int i2c_atmel_recv(struct tpm_chip *chip, u8 *buf, size_t count)
 {
 	struct priv_data *priv = chip->vendor.priv;
-	struct i2c_client *client = to_i2c_client(chip->dev);
+	struct i2c_client *client = to_i2c_client(chip->pdev);
 	struct tpm_output_header *hdr =
 		(struct tpm_output_header *)priv->buffer;
 	u32 expected_len;
@@ -88,7 +88,7 @@ static int i2c_atmel_recv(struct tpm_chip *chip, u8 *buf, size_t count)
 		return -ENOMEM;
 
 	if (priv->len >= expected_len) {
-		dev_dbg(chip->dev,
+		dev_dbg(chip->pdev,
 			"%s early(buf=%*ph count=%0zx) -> ret=%d\n", __func__,
 			(int)min_t(size_t, 64, expected_len), buf, count,
 			expected_len);
@@ -97,7 +97,7 @@ static int i2c_atmel_recv(struct tpm_chip *chip, u8 *buf, size_t count)
 	}
 
 	rc = i2c_master_recv(client, buf, expected_len);
-	dev_dbg(chip->dev,
+	dev_dbg(chip->pdev,
 		"%s reread(buf=%*ph count=%0zx) -> ret=%d\n", __func__,
 		(int)min_t(size_t, 64, expected_len), buf, count,
 		expected_len);
@@ -106,13 +106,13 @@ static int i2c_atmel_recv(struct tpm_chip *chip, u8 *buf, size_t count)
 
 static void i2c_atmel_cancel(struct tpm_chip *chip)
 {
-	dev_err(chip->dev, "TPM operation cancellation was requested, but is not supported");
+	dev_err(chip->pdev, "TPM operation cancellation was requested, but is not supported");
 }
 
 static u8 i2c_atmel_read_status(struct tpm_chip *chip)
 {
 	struct priv_data *priv = chip->vendor.priv;
-	struct i2c_client *client = to_i2c_client(chip->dev);
+	struct i2c_client *client = to_i2c_client(chip->pdev);
 	int rc;
 
 	/* The TPM fails the I2C read until it is ready, so we do the entire
@@ -125,7 +125,7 @@ static u8 i2c_atmel_read_status(struct tpm_chip *chip)
 	/* Once the TPM has completed the command the command remains readable
 	 * until another command is issued. */
 	rc = i2c_master_recv(client, priv->buffer, sizeof(priv->buffer));
-	dev_dbg(chip->dev,
+	dev_dbg(chip->pdev,
 		"%s: sts=%d", __func__, rc);
 	if (rc <= 0)
 		return 0;
diff --git a/drivers/char/tpm/tpm_i2c_infineon.c b/drivers/char/tpm/tpm_i2c_infineon.c
index 03708e6..33c5f36 100644
--- a/drivers/char/tpm/tpm_i2c_infineon.c
+++ b/drivers/char/tpm/tpm_i2c_infineon.c
@@ -446,7 +446,7 @@ static int tpm_tis_i2c_recv(struct tpm_chip *chip, u8 *buf, size_t count)
 	/* read first 10 bytes, including tag, paramsize, and result */
 	size = recv_data(chip, buf, TPM_HEADER_SIZE);
 	if (size < TPM_HEADER_SIZE) {
-		dev_err(chip->dev, "Unable to read header\n");
+		dev_err(chip->pdev, "Unable to read header\n");
 		goto out;
 	}
 
@@ -459,14 +459,14 @@ static int tpm_tis_i2c_recv(struct tpm_chip *chip, u8 *buf, size_t count)
 	size += recv_data(chip, &buf[TPM_HEADER_SIZE],
 			  expected - TPM_HEADER_SIZE);
 	if (size < expected) {
-		dev_err(chip->dev, "Unable to read remainder of result\n");
+		dev_err(chip->pdev, "Unable to read remainder of result\n");
 		size = -ETIME;
 		goto out;
 	}
 
 	wait_for_stat(chip, TPM_STS_VALID, chip->vendor.timeout_c, &status);
 	if (status & TPM_STS_DATA_AVAIL) {	/* retry? */
-		dev_err(chip->dev, "Error left over data\n");
+		dev_err(chip->pdev, "Error left over data\n");
 		size = -EIO;
 		goto out;
 	}
diff --git a/drivers/char/tpm/tpm_i2c_nuvoton.c b/drivers/char/tpm/tpm_i2c_nuvoton.c
index 09f0c46..92ee9fa 100644
--- a/drivers/char/tpm/tpm_i2c_nuvoton.c
+++ b/drivers/char/tpm/tpm_i2c_nuvoton.c
@@ -96,13 +96,13 @@ static s32 i2c_nuvoton_write_buf(struct i2c_client *client, u8 offset, u8 size,
 /* read TPM_STS register */
 static u8 i2c_nuvoton_read_status(struct tpm_chip *chip)
 {
-	struct i2c_client *client = to_i2c_client(chip->dev);
+	struct i2c_client *client = to_i2c_client(chip->pdev);
 	s32 status;
 	u8 data;
 
 	status = i2c_nuvoton_read_buf(client, TPM_STS, 1, &data);
 	if (status <= 0) {
-		dev_err(chip->dev, "%s() error return %d\n", __func__,
+		dev_err(chip->pdev, "%s() error return %d\n", __func__,
 			status);
 		data = TPM_STS_ERR_VAL;
 	}
@@ -127,13 +127,13 @@ static s32 i2c_nuvoton_write_status(struct i2c_client *client, u8 data)
 /* write commandReady to TPM_STS register */
 static void i2c_nuvoton_ready(struct tpm_chip *chip)
 {
-	struct i2c_client *client = to_i2c_client(chip->dev);
+	struct i2c_client *client = to_i2c_client(chip->pdev);
 	s32 status;
 
 	/* this causes the current command to be aborted */
 	status = i2c_nuvoton_write_status(client, TPM_STS_COMMAND_READY);
 	if (status < 0)
-		dev_err(chip->dev,
+		dev_err(chip->pdev,
 			"%s() fail to write TPM_STS.commandReady\n", __func__);
 }
 
@@ -212,7 +212,7 @@ static int i2c_nuvoton_wait_for_stat(struct tpm_chip *chip, u8 mask, u8 value,
 				return 0;
 		} while (time_before(jiffies, stop));
 	}
-	dev_err(chip->dev, "%s(%02x, %02x) -> timeout\n", __func__, mask,
+	dev_err(chip->pdev, "%s(%02x, %02x) -> timeout\n", __func__, mask,
 		value);
 	return -ETIMEDOUT;
 }
@@ -240,7 +240,7 @@ static int i2c_nuvoton_recv_data(struct i2c_client *client,
 					       &chip->vendor.read_queue) == 0) {
 		burst_count = i2c_nuvoton_get_burstcount(client, chip);
 		if (burst_count < 0) {
-			dev_err(chip->dev,
+			dev_err(chip->pdev,
 				"%s() fail to read burstCount=%d\n", __func__,
 				burst_count);
 			return -EIO;
@@ -249,12 +249,12 @@ static int i2c_nuvoton_recv_data(struct i2c_client *client,
 		rc = i2c_nuvoton_read_buf(client, TPM_DATA_FIFO_R,
 					  bytes2read, &buf[size]);
 		if (rc < 0) {
-			dev_err(chip->dev,
+			dev_err(chip->pdev,
 				"%s() fail on i2c_nuvoton_read_buf()=%d\n",
 				__func__, rc);
 			return -EIO;
 		}
-		dev_dbg(chip->dev, "%s(%d):", __func__, bytes2read);
+		dev_dbg(chip->pdev, "%s(%d):", __func__, bytes2read);
 		size += bytes2read;
 	}
 
@@ -264,7 +264,7 @@ static int i2c_nuvoton_recv_data(struct i2c_client *client,
 /* Read TPM command results */
 static int i2c_nuvoton_recv(struct tpm_chip *chip, u8 *buf, size_t count)
 {
-	struct device *dev = chip->dev;
+	struct device *dev = chip->pdev;
 	struct i2c_client *client = to_i2c_client(dev);
 	s32 rc;
 	int expected, status, burst_count, retries, size = 0;
@@ -334,7 +334,7 @@ static int i2c_nuvoton_recv(struct tpm_chip *chip, u8 *buf, size_t count)
 		break;
 	}
 	i2c_nuvoton_ready(chip);
-	dev_dbg(chip->dev, "%s() -> %d\n", __func__, size);
+	dev_dbg(chip->pdev, "%s() -> %d\n", __func__, size);
 	return size;
 }
 
@@ -347,7 +347,7 @@ static int i2c_nuvoton_recv(struct tpm_chip *chip, u8 *buf, size_t count)
  */
 static int i2c_nuvoton_send(struct tpm_chip *chip, u8 *buf, size_t len)
 {
-	struct device *dev = chip->dev;
+	struct device *dev = chip->pdev;
 	struct i2c_client *client = to_i2c_client(dev);
 	u32 ordinal;
 	size_t count = 0;
diff --git a/drivers/char/tpm/tpm_i2c_stm_st33.c b/drivers/char/tpm/tpm_i2c_stm_st33.c
index b9d1a38..64ef510 100644
--- a/drivers/char/tpm/tpm_i2c_stm_st33.c
+++ b/drivers/char/tpm/tpm_i2c_stm_st33.c
@@ -544,7 +544,7 @@ static int tpm_stm_i2c_recv(struct tpm_chip *chip, unsigned char *buf,
 
 	size = recv_data(chip, buf, TPM_HEADER_SIZE);
 	if (size < TPM_HEADER_SIZE) {
-		dev_err(chip->dev, "Unable to read header\n");
+		dev_err(chip->pdev, "Unable to read header\n");
 		goto out;
 	}
 
@@ -557,7 +557,7 @@ static int tpm_stm_i2c_recv(struct tpm_chip *chip, unsigned char *buf,
 	size += recv_data(chip, &buf[TPM_HEADER_SIZE],
 					expected - TPM_HEADER_SIZE);
 	if (size < expected) {
-		dev_err(chip->dev, "Unable to read remainder of result\n");
+		dev_err(chip->pdev, "Unable to read remainder of result\n");
 		size = -ETIME;
 		goto out;
 	}
@@ -671,7 +671,7 @@ tpm_st33_i2c_probe(struct i2c_client *client, const struct i2c_device_id *id)
 				IRQF_TRIGGER_HIGH,
 				"TPM SERIRQ management", chip);
 		if (err < 0) {
-			dev_err(chip->dev , "TPM SERIRQ signals %d not available\n",
+			dev_err(chip->pdev , "TPM SERIRQ signals %d not available\n",
 				gpio_to_irq(platform_data->io_serirq));
 			goto _irq_set;
 		}
diff --git a/drivers/char/tpm/tpm_infineon.c b/drivers/char/tpm/tpm_infineon.c
index dcdb671..6d49213 100644
--- a/drivers/char/tpm/tpm_infineon.c
+++ b/drivers/char/tpm/tpm_infineon.c
@@ -195,9 +195,9 @@ static int wait(struct tpm_chip *chip, int wait_for_bit)
 	}
 	if (i == TPM_MAX_TRIES) {	/* timeout occurs */
 		if (wait_for_bit == STAT_XFE)
-			dev_err(chip->dev, "Timeout in wait(STAT_XFE)\n");
+			dev_err(chip->pdev, "Timeout in wait(STAT_XFE)\n");
 		if (wait_for_bit == STAT_RDA)
-			dev_err(chip->dev, "Timeout in wait(STAT_RDA)\n");
+			dev_err(chip->pdev, "Timeout in wait(STAT_RDA)\n");
 		return -EIO;
 	}
 	return 0;
@@ -220,7 +220,7 @@ static void wait_and_send(struct tpm_chip *chip, u8 sendbyte)
 static void tpm_wtx(struct tpm_chip *chip)
 {
 	number_of_wtx++;
-	dev_info(chip->dev, "Granting WTX (%02d / %02d)\n",
+	dev_info(chip->pdev, "Granting WTX (%02d / %02d)\n",
 		 number_of_wtx, TPM_MAX_WTX_PACKAGES);
 	wait_and_send(chip, TPM_VL_VER);
 	wait_and_send(chip, TPM_CTRL_WTX);
@@ -231,7 +231,7 @@ static void tpm_wtx(struct tpm_chip *chip)
 
 static void tpm_wtx_abort(struct tpm_chip *chip)
 {
-	dev_info(chip->dev, "Aborting WTX\n");
+	dev_info(chip->pdev, "Aborting WTX\n");
 	wait_and_send(chip, TPM_VL_VER);
 	wait_and_send(chip, TPM_CTRL_WTX_ABORT);
 	wait_and_send(chip, 0x00);
@@ -257,7 +257,7 @@ recv_begin:
 	}
 
 	if (buf[0] != TPM_VL_VER) {
-		dev_err(chip->dev,
+		dev_err(chip->pdev,
 			"Wrong transport protocol implementation!\n");
 		return -EIO;
 	}
@@ -272,7 +272,7 @@ recv_begin:
 		}
 
 		if ((size == 0x6D00) && (buf[1] == 0x80)) {
-			dev_err(chip->dev, "Error handling on vendor layer!\n");
+			dev_err(chip->pdev, "Error handling on vendor layer!\n");
 			return -EIO;
 		}
 
@@ -284,7 +284,7 @@ recv_begin:
 	}
 
 	if (buf[1] == TPM_CTRL_WTX) {
-		dev_info(chip->dev, "WTX-package received\n");
+		dev_info(chip->pdev, "WTX-package received\n");
 		if (number_of_wtx < TPM_MAX_WTX_PACKAGES) {
 			tpm_wtx(chip);
 			goto recv_begin;
@@ -295,14 +295,14 @@ recv_begin:
 	}
 
 	if (buf[1] == TPM_CTRL_WTX_ABORT_ACK) {
-		dev_info(chip->dev, "WTX-abort acknowledged\n");
+		dev_info(chip->pdev, "WTX-abort acknowledged\n");
 		return size;
 	}
 
 	if (buf[1] == TPM_CTRL_ERROR) {
-		dev_err(chip->dev, "ERROR-package received:\n");
+		dev_err(chip->pdev, "ERROR-package received:\n");
 		if (buf[4] == TPM_INF_NAK)
-			dev_err(chip->dev,
+			dev_err(chip->pdev,
 				"-> Negative acknowledgement"
 				" - retransmit command!\n");
 		return -EIO;
@@ -321,7 +321,7 @@ static int tpm_inf_send(struct tpm_chip *chip, u8 * buf, size_t count)
 
 	ret = empty_fifo(chip, 1);
 	if (ret) {
-		dev_err(chip->dev, "Timeout while clearing FIFO\n");
+		dev_err(chip->pdev, "Timeout while clearing FIFO\n");
 		return -EIO;
 	}
 
diff --git a/drivers/char/tpm/tpm_nsc.c b/drivers/char/tpm/tpm_nsc.c
index 00c5470..072c298 100644
--- a/drivers/char/tpm/tpm_nsc.c
+++ b/drivers/char/tpm/tpm_nsc.c
@@ -113,7 +113,7 @@ static int nsc_wait_for_ready(struct tpm_chip *chip)
 	}
 	while (time_before(jiffies, stop));
 
-	dev_info(chip->dev, "wait for ready failed\n");
+	dev_info(chip->pdev, "wait for ready failed\n");
 	return -EBUSY;
 }
 
@@ -129,12 +129,12 @@ static int tpm_nsc_recv(struct tpm_chip *chip, u8 * buf, size_t count)
 		return -EIO;
 
 	if (wait_for_stat(chip, NSC_STATUS_F0, NSC_STATUS_F0, &data) < 0) {
-		dev_err(chip->dev, "F0 timeout\n");
+		dev_err(chip->pdev, "F0 timeout\n");
 		return -EIO;
 	}
 	if ((data =
 	     inb(chip->vendor.base + NSC_DATA)) != NSC_COMMAND_NORMAL) {
-		dev_err(chip->dev, "not in normal mode (0x%x)\n",
+		dev_err(chip->pdev, "not in normal mode (0x%x)\n",
 			data);
 		return -EIO;
 	}
@@ -143,7 +143,7 @@ static int tpm_nsc_recv(struct tpm_chip *chip, u8 * buf, size_t count)
 	for (p = buffer; p < &buffer[count]; p++) {
 		if (wait_for_stat
 		    (chip, NSC_STATUS_OBF, NSC_STATUS_OBF, &data) < 0) {
-			dev_err(chip->dev,
+			dev_err(chip->pdev,
 				"OBF timeout (while reading data)\n");
 			return -EIO;
 		}
@@ -154,11 +154,11 @@ static int tpm_nsc_recv(struct tpm_chip *chip, u8 * buf, size_t count)
 
 	if ((data & NSC_STATUS_F0) == 0 &&
 	(wait_for_stat(chip, NSC_STATUS_F0, NSC_STATUS_F0, &data) < 0)) {
-		dev_err(chip->dev, "F0 not set\n");
+		dev_err(chip->pdev, "F0 not set\n");
 		return -EIO;
 	}
 	if ((data = inb(chip->vendor.base + NSC_DATA)) != NSC_COMMAND_EOC) {
-		dev_err(chip->dev,
+		dev_err(chip->pdev,
 			"expected end of command(0x%x)\n", data);
 		return -EIO;
 	}
@@ -189,19 +189,19 @@ static int tpm_nsc_send(struct tpm_chip *chip, u8 * buf, size_t count)
 		return -EIO;
 
 	if (wait_for_stat(chip, NSC_STATUS_IBF, 0, &data) < 0) {
-		dev_err(chip->dev, "IBF timeout\n");
+		dev_err(chip->pdev, "IBF timeout\n");
 		return -EIO;
 	}
 
 	outb(NSC_COMMAND_NORMAL, chip->vendor.base + NSC_COMMAND);
 	if (wait_for_stat(chip, NSC_STATUS_IBR, NSC_STATUS_IBR, &data) < 0) {
-		dev_err(chip->dev, "IBR timeout\n");
+		dev_err(chip->pdev, "IBR timeout\n");
 		return -EIO;
 	}
 
 	for (i = 0; i < count; i++) {
 		if (wait_for_stat(chip, NSC_STATUS_IBF, 0, &data) < 0) {
-			dev_err(chip->dev,
+			dev_err(chip->pdev,
 				"IBF timeout (while writing data)\n");
 			return -EIO;
 		}
@@ -209,7 +209,7 @@ static int tpm_nsc_send(struct tpm_chip *chip, u8 * buf, size_t count)
 	}
 
 	if (wait_for_stat(chip, NSC_STATUS_IBF, 0, &data) < 0) {
-		dev_err(chip->dev, "IBF timeout\n");
+		dev_err(chip->pdev, "IBF timeout\n");
 		return -EIO;
 	}
 	outb(NSC_COMMAND_EOC, chip->vendor.base + NSC_COMMAND);
diff --git a/drivers/char/tpm/tpm_ppi.c b/drivers/char/tpm/tpm_ppi.c
index 6acdb17..659de61 100644
--- a/drivers/char/tpm/tpm_ppi.c
+++ b/drivers/char/tpm/tpm_ppi.c
@@ -358,11 +358,11 @@ int tpm_add_ppi(struct tpm_chip *chip)
 
 	ACPI_FREE(obj);
 
-	return sysfs_create_group(&chip->dev->kobj, &ppi_attr_grp);
+	return sysfs_create_group(&chip->pdev->kobj, &ppi_attr_grp);
 }
 
 void tpm_remove_ppi(struct tpm_chip *chip)
 {
 	if (chip->ppi_version[0] != '\0')
-		sysfs_remove_group(&chip->dev->kobj, &ppi_attr_grp);
+		sysfs_remove_group(&chip->pdev->kobj, &ppi_attr_grp);
 }
diff --git a/drivers/char/tpm/tpm_tis.c b/drivers/char/tpm/tpm_tis.c
index 00ed222..660d9af 100644
--- a/drivers/char/tpm/tpm_tis.c
+++ b/drivers/char/tpm/tpm_tis.c
@@ -238,7 +238,7 @@ static int tpm_tis_recv(struct tpm_chip *chip, u8 *buf, size_t count)
 	/* read first 10 bytes, including tag, paramsize, and result */
 	if ((size =
 	     recv_data(chip, buf, TPM_HEADER_SIZE)) < TPM_HEADER_SIZE) {
-		dev_err(chip->dev, "Unable to read header\n");
+		dev_err(chip->pdev, "Unable to read header\n");
 		goto out;
 	}
 
@@ -251,7 +251,7 @@ static int tpm_tis_recv(struct tpm_chip *chip, u8 *buf, size_t count)
 	if ((size +=
 	     recv_data(chip, &buf[TPM_HEADER_SIZE],
 		       expected - TPM_HEADER_SIZE)) < expected) {
-		dev_err(chip->dev, "Unable to read remainder of result\n");
+		dev_err(chip->pdev, "Unable to read remainder of result\n");
 		size = -ETIME;
 		goto out;
 	}
@@ -260,7 +260,7 @@ static int tpm_tis_recv(struct tpm_chip *chip, u8 *buf, size_t count)
 			  &chip->vendor.int_queue, false);
 	status = tpm_tis_status(chip);
 	if (status & TPM_STS_DATA_AVAIL) {	/* retry? */
-		dev_err(chip->dev, "Error left over data\n");
+		dev_err(chip->pdev, "Error left over data\n");
 		size = -EIO;
 		goto out;
 	}
@@ -433,7 +433,7 @@ static int probe_itpm(struct tpm_chip *chip)
 
 	rc = tpm_tis_send_data(chip, cmd_getticks, len);
 	if (rc == 0) {
-		dev_info(chip->dev, "Detected an iTPM.\n");
+		dev_info(chip->pdev, "Detected an iTPM.\n");
 		rc = 1;
 	} else
 		rc = -EFAULT;
@@ -662,7 +662,7 @@ static int tpm_tis_init(struct device *dev, acpi_handle acpi_dev_handle,
 			if (devm_request_irq
 			    (dev, i, tis_int_probe, IRQF_SHARED,
 			     chip->vendor.miscdev.name, chip) != 0) {
-				dev_info(chip->dev,
+				dev_info(chip->pdev,
 					 "Unable to request irq: %d for probe\n",
 					 i);
 				continue;
@@ -709,7 +709,7 @@ static int tpm_tis_init(struct device *dev, acpi_handle acpi_dev_handle,
 		if (devm_request_irq
 		    (dev, chip->vendor.irq, tis_int_handler, IRQF_SHARED,
 		     chip->vendor.miscdev.name, chip) != 0) {
-			dev_info(chip->dev,
+			dev_info(chip->pdev,
 				 "Unable to request irq: %d for use\n",
 				 chip->vendor.irq);
 			chip->vendor.irq = 0;
-- 
2.1.0
