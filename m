From: Cristina Moraru <cristina.moraru09@gmail.com>
Subject: [PATCH 1/5] iio: hmc5843: Add attribute for available measurement
 config
Date: Mon,  8 Feb 2016 00:21:47 +0200
Message-ID: <1454883711-15489-2-git-send-email-cristina.moraru09@gmail.com>
References: <1454883711-15489-1-git-send-email-cristina.moraru09@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
In-Reply-To: <1454883711-15489-1-git-send-email-cristina.moraru09@gmail.com>
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel/>
List-Post: <mailto:driverdev-devel@linuxdriverproject.org>
List-Help: <mailto:driverdev-devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: driverdev-devel-bounces@linuxdriverproject.org
Sender: "devel" <driverdev-devel-bounces@linuxdriverproject.org>
To: jic23@kernel.org, knaack.h@gmx.de, lars@metafoo.de, pmeerw@pmeerw.net, gregkh@linuxfoundation.org, cristina.opriceana@gmail.com, marek@goldelico.com, sdliyong@gmail.com, linux-iio@vger.kernel.org, devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, tolga.ceylan@gmail.com, k.kozlowski@samsung.com, javier@osg.samsung.com, arnd@arndb.de, geert@linux-m68k.org, irina.tirdea@intel.com, daniel.baluta@intel.com, octavia.purdila@intel.com
Cc: Cristina Moraru <cristina.moraru09@gmail.com>
List-Id: linux-api@vger.kernel.org

Add static attribute meas_conf_available to show available
configurations for the bias current.

API for setting bias measurement configuration:

0 - Normal measurement configuration (default): In normal measurement
    configuration the device follows normal measurement flow. Pins BP
    and BN are left floating and high impedance.

1 - Positive bias configuration: In positive bias configuration, a
    positive current is forced across the resistive load on pins BP
    and BN.

2 - Negative bias configuration. In negative bias configuration, a
    negative current is forced across the resistive load on pins BP
    and BN.

3 - Only available on HMC5983. Magnetic sensor is disabled.
    Temperature sensor is enabled.

Signed-off-by: Cristina Moraru <cristina.moraru09@gmail.com>
---
 drivers/staging/iio/magnetometer/hmc5843_core.c | 83 +++++++++++++++++++------
 1 file changed, 65 insertions(+), 18 deletions(-)

diff --git a/drivers/staging/iio/magnetometer/hmc5843_core.c b/drivers/staging/iio/magnetometer/hmc5843_core.c
index 4aab022..4e2a7ec 100644
--- a/drivers/staging/iio/magnetometer/hmc5843_core.c
+++ b/drivers/staging/iio/magnetometer/hmc5843_core.c
@@ -66,6 +66,34 @@
 #define HMC5843_MEAS_CONF_NEGATIVE_BIAS		0x02
 #define HMC5843_MEAS_CONF_MASK			0x03
 
+/*
+ * API for setting the measurement configuration to
+ * Normal, Positive bias and Negative bias
+ *
+ * From the datasheet:
+ * 0 - Normal measurement configuration (default): In normal measurement
+ *     configuration the device follows normal measurement flow. Pins BP
+ *     and BN are left floating and high impedance.
+ *
+ * 1 - Positive bias configuration: In positive bias configuration, a
+ *     positive current is forced across the resistive load on pins BP
+ *     and BN.
+ *
+ * 2 - Negative bias configuration. In negative bias configuration, a
+ *     negative current is forced across the resistive load on pins BP
+ *     and BN.
+ *
+ * 3 - Only available on HMC5983. Magnetic sensor is disabled.
+ *     Temperature sensor is enabled.
+ */
+static const int hmc5843_regval_to_meas_conf[] = {
+	0, 1, 2
+};
+
+static const int hmc5983_regval_to_meas_conf[] = {
+	0, 1, 2, 3
+};
+
 /* Scaling factors: 10000000/Gain */
 static const int hmc5843_regval_to_nanoscale[] = {
 	6173, 7692, 10309, 12821, 18868, 21739, 25641, 35714
@@ -109,6 +137,8 @@ static const int hmc5983_regval_to_samp_freq[][2] = {
 /* Describe chip variants */
 struct hmc5843_chip_info {
 	const struct iio_chan_spec *channels;
+	const int *regval_to_meas_conf;
+	const int n_regval_to_meas_conf;
 	const int (*regval_to_samp_freq)[2];
 	const int n_regval_to_samp_freq;
 	const int *regval_to_nanoscale;
@@ -174,24 +204,6 @@ static int hmc5843_read_measurement(struct hmc5843_data *data,
 	return IIO_VAL_INT;
 }
 
-/*
- * API for setting the measurement configuration to
- * Normal, Positive bias and Negative bias
- *
- * From the datasheet:
- * 0 - Normal measurement configuration (default): In normal measurement
- *     configuration the device follows normal measurement flow. Pins BP
- *     and BN are left floating and high impedance.
- *
- * 1 - Positive bias configuration: In positive bias configuration, a
- *     positive current is forced across the resistive load on pins BP
- *     and BN.
- *
- * 2 - Negative bias configuration. In negative bias configuration, a
- *     negative current is forced across the resistive load on pins BP
- *     and BN.
- *
- */
 static int hmc5843_set_meas_conf(struct hmc5843_data *data, u8 meas_conf)
 {
 	int ret;
@@ -248,6 +260,28 @@ static IIO_DEVICE_ATTR(meas_conf,
 			hmc5843_set_measurement_configuration,
 			0);
 
+static ssize_t hmc5843_show_meas_conf_avail(struct device *dev,
+					    struct device_attribute *attr,
+					    char *buf)
+{
+	struct hmc5843_data *data = iio_priv(dev_to_iio_dev(dev));
+
+	size_t len = 0;
+	int i;
+
+	for (i = 0; i < data->variant->n_regval_to_meas_conf; i++)
+		len += scnprintf(buf + len, PAGE_SIZE - len,
+			"%d ", data->variant->regval_to_meas_conf[i]);
+
+	/* replace trailing space by newline */
+	buf[len - 1] = '\n';
+
+	return len;
+}
+
+static IIO_DEVICE_ATTR(meas_conf_available, S_IRUGO,
+	hmc5843_show_meas_conf_avail, NULL, 0);
+
 static
 ssize_t hmc5843_show_samp_freq_avail(struct device *dev,
 				     struct device_attribute *attr, char *buf)
@@ -478,6 +512,7 @@ static const struct iio_chan_spec hmc5883_channels[] = {
 
 static struct attribute *hmc5843_attributes[] = {
 	&iio_dev_attr_meas_conf.dev_attr.attr,
+	&iio_dev_attr_meas_conf_available.dev_attr.attr,
 	&iio_dev_attr_scale_available.dev_attr.attr,
 	&iio_dev_attr_sampling_frequency_available.dev_attr.attr,
 	NULL
@@ -490,6 +525,9 @@ static const struct attribute_group hmc5843_group = {
 static const struct hmc5843_chip_info hmc5843_chip_info_tbl[] = {
 	[HMC5843_ID] = {
 		.channels = hmc5843_channels,
+		.regval_to_meas_conf = hmc5843_regval_to_meas_conf,
+		.n_regval_to_meas_conf =
+				ARRAY_SIZE(hmc5843_regval_to_meas_conf),
 		.regval_to_samp_freq = hmc5843_regval_to_samp_freq,
 		.n_regval_to_samp_freq =
 				ARRAY_SIZE(hmc5843_regval_to_samp_freq),
@@ -499,6 +537,9 @@ static const struct hmc5843_chip_info hmc5843_chip_info_tbl[] = {
 	},
 	[HMC5883_ID] = {
 		.channels = hmc5883_channels,
+		.regval_to_meas_conf = hmc5843_regval_to_meas_conf,
+		.n_regval_to_meas_conf =
+				ARRAY_SIZE(hmc5843_regval_to_meas_conf),
 		.regval_to_samp_freq = hmc5883_regval_to_samp_freq,
 		.n_regval_to_samp_freq =
 				ARRAY_SIZE(hmc5883_regval_to_samp_freq),
@@ -508,6 +549,9 @@ static const struct hmc5843_chip_info hmc5843_chip_info_tbl[] = {
 	},
 	[HMC5883L_ID] = {
 		.channels = hmc5883_channels,
+		.regval_to_meas_conf = hmc5843_regval_to_meas_conf,
+		.n_regval_to_meas_conf =
+				ARRAY_SIZE(hmc5843_regval_to_meas_conf),
 		.regval_to_samp_freq = hmc5883_regval_to_samp_freq,
 		.n_regval_to_samp_freq =
 				ARRAY_SIZE(hmc5883_regval_to_samp_freq),
@@ -517,6 +561,9 @@ static const struct hmc5843_chip_info hmc5843_chip_info_tbl[] = {
 	},
 	[HMC5983_ID] = {
 		.channels = hmc5883_channels,
+		.regval_to_meas_conf = hmc5983_regval_to_meas_conf,
+		.n_regval_to_meas_conf =
+				ARRAY_SIZE(hmc5983_regval_to_meas_conf),
 		.regval_to_samp_freq = hmc5983_regval_to_samp_freq,
 		.n_regval_to_samp_freq =
 				ARRAY_SIZE(hmc5983_regval_to_samp_freq),
-- 
1.9.1
