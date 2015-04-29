From: Octavian Purdila <octavian.purdila@intel.com>
Subject: [RFC PATCH 3/3] iio: accel: bmc150: add support for hwfifo_flush and flush events
Date: Wed, 29 Apr 2015 14:19:00 +0300
Message-ID: <1430306340-5026-4-git-send-email-octavian.purdila@intel.com>
References: <1430306340-5026-1-git-send-email-octavian.purdila@intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1430306340-5026-1-git-send-email-octavian.purdila@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: jic23@kernel.org
Cc: knaack.h@gmx.de, lars@metafoo.de, pmeerw@pmeerw.net, linux-iio@vger.kernel.org, linux-kernel@vger.kernel.org, adriana.reus@intel.com, linux-api@vger.kernel.org, Octavian Purdila <octavian.purdila@intel.com>
List-Id: linux-api@vger.kernel.org

Signed-off-by: Octavian Purdila <octavian.purdila@intel.com>
---
 drivers/iio/accel/bmc150-accel.c | 68 ++++++++++++++++++++++++++++++----------
 1 file changed, 51 insertions(+), 17 deletions(-)

diff --git a/drivers/iio/accel/bmc150-accel.c b/drivers/iio/accel/bmc150-accel.c
index b4ca361..0c5fdf6 100644
--- a/drivers/iio/accel/bmc150-accel.c
+++ b/drivers/iio/accel/bmc150-accel.c
@@ -870,19 +870,6 @@ static ssize_t bmc150_accel_get_fifo_state(struct device *dev,
 	return sprintf(buf, "%d\n", state);
 }
 
-static IIO_CONST_ATTR_HWFIFO_WATERMARK_MIN(1);
-static IIO_CONST_ATTR_HWFIFO_WATERMARK_MAX(BMC150_ACCEL_FIFO_LENGTH);
-static IIO_DEV_ATTR_HWFIFO_ENABLED(bmc150_accel_get_fifo_state);
-static IIO_DEV_ATTR_HWFIFO_WATERMARK(bmc150_accel_get_fifo_watermark);
-
-static const struct attribute *bmc150_accel_fifo_attributes[] = {
-	&iio_const_attr_hwfifo_watermark_min.dev_attr.attr,
-	&iio_const_attr_hwfifo_watermark_max.dev_attr.attr,
-	&iio_dev_attr_hwfifo_watermark.dev_attr.attr,
-	&iio_dev_attr_hwfifo_enabled.dev_attr.attr,
-	NULL,
-};
-
 static int bmc150_accel_set_watermark(struct iio_dev *indio_dev, unsigned val)
 {
 	struct bmc150_accel_data *data = iio_priv(indio_dev);
@@ -952,7 +939,8 @@ static int bmc150_accel_fifo_transfer(const struct i2c_client *client,
 }
 
 static int __bmc150_accel_fifo_flush(struct iio_dev *indio_dev,
-				     unsigned samples, bool irq)
+				     unsigned samples, bool irq,
+				     bool event)
 {
 	struct bmc150_accel_data *data = iio_priv(indio_dev);
 	int ret, i;
@@ -1030,6 +1018,12 @@ static int __bmc150_accel_fifo_flush(struct iio_dev *indio_dev,
 		tstamp += sample_period;
 	}
 
+	if (event)
+		iio_push_event(indio_dev,
+			       IIO_UNMOD_EVENT_CODE(IIO_ACCEL, 0,
+						    IIO_EV_TYPE_HWFIFO_FLUSHED,
+						    IIO_EV_DIR_NONE),
+			       tstamp);
 	return count;
 }
 
@@ -1039,12 +1033,50 @@ static int bmc150_accel_fifo_flush(struct iio_dev *indio_dev, unsigned samples)
 	int ret;
 
 	mutex_lock(&data->mutex);
-	ret = __bmc150_accel_fifo_flush(indio_dev, samples, false);
+	ret = __bmc150_accel_fifo_flush(indio_dev, samples, false, false);
 	mutex_unlock(&data->mutex);
 
 	return ret;
 }
 
+static ssize_t bmc150_accel_sysfs_fifo_flush(struct device *dev,
+					     struct device_attribute *attr,
+					     const char *buf,
+					     size_t len)
+{
+	struct iio_dev *indio_dev = dev_to_iio_dev(dev);
+	struct bmc150_accel_data *data = iio_priv(indio_dev);
+	unsigned int samples;
+	int ret;
+
+	ret = kstrtouint(buf, 10, &samples);
+	if (ret)
+		return ret;
+	if (!samples)
+		return -EINVAL;
+
+	mutex_lock(&data->mutex);
+	ret = __bmc150_accel_fifo_flush(indio_dev, samples, false, true);
+	mutex_unlock(&data->mutex);
+
+	return ret ? ret : len;
+}
+
+static IIO_CONST_ATTR_HWFIFO_WATERMARK_MIN(1);
+static IIO_CONST_ATTR_HWFIFO_WATERMARK_MAX(BMC150_ACCEL_FIFO_LENGTH);
+static IIO_DEV_ATTR_HWFIFO_ENABLED(bmc150_accel_get_fifo_state);
+static IIO_DEV_ATTR_HWFIFO_WATERMARK(bmc150_accel_get_fifo_watermark);
+static IIO_DEV_ATTR_HWFIFO_FLUSH(bmc150_accel_sysfs_fifo_flush);
+
+static const struct attribute *bmc150_accel_fifo_attributes[] = {
+	&iio_const_attr_hwfifo_watermark_min.dev_attr.attr,
+	&iio_const_attr_hwfifo_watermark_max.dev_attr.attr,
+	&iio_dev_attr_hwfifo_watermark.dev_attr.attr,
+	&iio_dev_attr_hwfifo_enabled.dev_attr.attr,
+	&iio_dev_attr_hwfifo_flush.dev_attr.attr,
+	NULL,
+};
+
 static IIO_CONST_ATTR_SAMP_FREQ_AVAIL(
 		"15.620000 31.260000 62.50000 125 250 500 1000 2000");
 
@@ -1346,7 +1378,8 @@ static irqreturn_t bmc150_accel_irq_thread_handler(int irq, void *private)
 
 	if (data->fifo_mode) {
 		ret = __bmc150_accel_fifo_flush(indio_dev,
-						BMC150_ACCEL_FIFO_LENGTH, true);
+						BMC150_ACCEL_FIFO_LENGTH, true,
+						false);
 		if (ret > 0)
 			ack = true;
 	}
@@ -1578,7 +1611,8 @@ static int bmc150_accel_buffer_predisable(struct iio_dev *indio_dev)
 		goto out;
 
 	bmc150_accel_set_interrupt(data, BMC150_ACCEL_INT_WATERMARK, false);
-	__bmc150_accel_fifo_flush(indio_dev, BMC150_ACCEL_FIFO_LENGTH, false);
+	__bmc150_accel_fifo_flush(indio_dev, BMC150_ACCEL_FIFO_LENGTH, false,
+				  false);
 	data->fifo_mode = 0;
 	bmc150_accel_fifo_set_mode(data);
 
-- 
1.9.1
