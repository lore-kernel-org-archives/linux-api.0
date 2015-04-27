From: Octavian Purdila <octavian.purdila@intel.com>
Subject: [RFC PATCH 1/3] iio: export mounting matrix information
Date: Mon, 27 Apr 2015 18:01:46 +0300
Message-ID: <1430146908-27919-2-git-send-email-octavian.purdila@intel.com>
References: <1430146908-27919-1-git-send-email-octavian.purdila@intel.com>
Return-path: <linux-acpi-owner@vger.kernel.org>
In-Reply-To: <1430146908-27919-1-git-send-email-octavian.purdila@intel.com>
Sender: linux-acpi-owner@vger.kernel.org
To: jic23@kernel.org
Cc: lars@metafoo.de, pmeerw@pmeerw.net, robert.moore@intel.com, rafael.j.wysocki@intel.com, lenb@kernel.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, linux-iio@vger.kernel.org, linux-acpi@vger.kernel.org, Octavian Purdila <octavian.purdila@intel.com>
List-Id: linux-api@vger.kernel.org

Export a new sysfs attribute that describes the placement of the
sensor on the device in the form of a mounting matrix so that
userspace can do the required correction to get accurate data:

corrected X = MM[0] * X + MM[1] Y + MM[2] * Z
corrected Y = MM[3] * X + MM[4] Y + MM[5] * Z
corrected Z = MM[6] * X + MM[7] Y + MM[8] * Z

This information is read from the device properties of the parent of
the IIO device.

Signed-off-by: Octavian Purdila <octavian.purdila@intel.com>
---
 Documentation/ABI/testing/sysfs-bus-iio | 11 +++++++++
 drivers/iio/industrialio-core.c         | 42 +++++++++++++++++++++++++++++++++
 include/linux/iio/iio.h                 |  9 +++++++
 3 files changed, 62 insertions(+)

diff --git a/Documentation/ABI/testing/sysfs-bus-iio b/Documentation/ABI/testing/sysfs-bus-iio
index 866b4ec..d36476e 100644
--- a/Documentation/ABI/testing/sysfs-bus-iio
+++ b/Documentation/ABI/testing/sysfs-bus-iio
@@ -1375,3 +1375,14 @@ Description:
 		The emissivity ratio of the surface in the field of view of the
 		contactless temperature sensor.  Emissivity varies from 0 to 1,
 		with 1 being the emissivity of a black body.
+
+What:		/sys/bus/iio/devices/iio:deviceX/mounting_matrix
+KernelVersion:	4.2
+Contact:	linux-iio@vger.kernel.org
+Description:
+		A list of 9 floating point values that describes the
+		transformation needed to account for the way the sensor has been
+		placed on the PCB:
+		corrected X = MM[0] * X + MM[1] Y + MM[2] * Z
+		corrected Y = MM[3] * X + MM[4] Y + MM[5] * Z
+		corrected Z = MM[6] * X + MM[7] Y + MM[8] * Z
diff --git a/drivers/iio/industrialio-core.c b/drivers/iio/industrialio-core.c
index 7c98bc1..9000c53 100644
--- a/drivers/iio/industrialio-core.c
+++ b/drivers/iio/industrialio-core.c
@@ -871,6 +871,45 @@ static ssize_t iio_show_dev_name(struct device *dev,
 
 static DEVICE_ATTR(name, S_IRUGO, iio_show_dev_name, NULL);
 
+static bool iio_get_mounting_matrix(struct iio_dev *indio_dev)
+{
+	int i, err;
+
+	err = device_property_read_u32_array(&indio_dev->dev, "mounting-matrix",
+					     indio_dev->mounting_matrix, 9);
+	if (!err) {
+		int *mm = indio_dev->mounting_matrix;
+
+		for (i = IIO_MM_SIZE - 2; i > 0; i -= 2) {
+			mm[i] = mm[i / 2];
+			mm[i + 1] = 0;
+		}
+
+		return true;
+	}
+
+	return false;
+}
+
+static ssize_t iio_show_mounting_matrix(struct device *dev,
+					struct device_attribute *attr,
+					char *buf)
+{
+	struct iio_dev *indio_dev = dev_to_iio_dev(dev);
+	char *tmp = buf;
+	int i;
+
+	for (i = 0; i < IIO_MM_SIZE; i += 2) {
+		tmp += iio_format_value(tmp, IIO_VAL_INT_PLUS_MICRO, 2,
+					&indio_dev->mounting_matrix[i]);
+		if (((i + 2) / 2) % 3)
+			tmp[-1] = ' ';
+	}
+	return tmp - buf;
+}
+
+static DEVICE_ATTR(mounting_matrix, S_IRUGO, iio_show_mounting_matrix, NULL);
+
 static int iio_device_register_sysfs(struct iio_dev *indio_dev)
 {
 	int i, ret = 0, attrcount, attrn, attrcount_orig = 0;
@@ -920,6 +959,9 @@ static int iio_device_register_sysfs(struct iio_dev *indio_dev)
 		indio_dev->chan_attr_group.attrs[attrn++] = &p->dev_attr.attr;
 	if (indio_dev->name)
 		indio_dev->chan_attr_group.attrs[attrn++] = &dev_attr_name.attr;
+	if (iio_get_mounting_matrix(indio_dev))
+		indio_dev->chan_attr_group.attrs[attrn++] =
+			&dev_attr_mounting_matrix.attr;
 
 	indio_dev->groups[indio_dev->groupcounter++] =
 		&indio_dev->chan_attr_group;
diff --git a/include/linux/iio/iio.h b/include/linux/iio/iio.h
index b1e46ae..c1fa852 100644
--- a/include/linux/iio/iio.h
+++ b/include/linux/iio/iio.h
@@ -434,6 +434,8 @@ struct iio_buffer_setup_ops {
 				   const unsigned long *scan_mask);
 };
 
+#define IIO_MM_SIZE		18
+
 /**
  * struct iio_dev - industrial I/O device
  * @id:			[INTERN] used to identify device internally
@@ -469,6 +471,12 @@ struct iio_buffer_setup_ops {
  * @groups:		[INTERN] attribute groups
  * @groupcounter:	[INTERN] index of next attribute group
  * @flags:		[INTERN] file ops related flags including busy flag.
+ * @mounting_matrix:	[INTERN] the mounting matrix is a series of 9
+ *			IIO_VAL_INT_PLUS_MICRO pairs that describes the
+ *			transformation needed to account for the way the sensor
+ *			has been placed on the PCB. See the mounting_matrix
+ *			entry in Documentation/ABI/testing/sysfs-bus-iio about
+ *			details of the transformation operations.
  * @debugfs_dentry:	[INTERN] device specific debugfs dentry.
  * @cached_reg_addr:	[INTERN] cached register address for debugfs reads.
  */
@@ -509,6 +517,7 @@ struct iio_dev {
 	int				groupcounter;
 
 	unsigned long			flags;
+	int				mounting_matrix[IIO_MM_SIZE];
 #if defined(CONFIG_DEBUG_FS)
 	struct dentry			*debugfs_dentry;
 	unsigned			cached_reg_addr;
-- 
1.9.1

