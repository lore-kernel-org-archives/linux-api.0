From: George McCollister <george.mccollister@gmail.com>
Subject: [PATCH 1/2] iio: Add support for waveform output
Date: Wed, 26 Nov 2014 15:45:40 -0600
Message-ID: <1417038344-3801-1-git-send-email-george.mccollister@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel/>
List-Post: <mailto:driverdev-devel@linuxdriverproject.org>
List-Help: <mailto:driverdev-devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: driverdev-devel-bounces@linuxdriverproject.org
Sender: "devel" <driverdev-devel-bounces@linuxdriverproject.org>
Cc: Daniel Baluta <daniel.baluta@intel.com>, "open list:STAGING SUBSYSTEM" <devel@driverdev.osuosl.org>, Lars-Peter Clausen <lars@metafoo.de>, Reyad Attiyat <reyad.attiyat@gmail.com>, "open list:IIO SUBSYSTEM AND..." <linux-iio@vger.kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>, open list <linux-kernel@vger.kernel.org>, Harald Geyer <harald@ccbib.org>, George McCollister <george.mccollister@gmail.com>, Sebastian Reichel <sre@debian.org>, Peter Meerwald <pmeerw@pmeerw.net>, Hartmut Knaack <knaack.h@gmx.de>, "open list:ABI/API" <linux-api@vger.kernel.org>, Jonathan Cameron <jic23@kernel.org>
List-Id: linux-api@vger.kernel.org

Output can be held high or low for a specified period of time.
Support for waveform capture could be added in the future.

Signed-off-by: George McCollister <george.mccollister@gmail.com>
---
 Documentation/ABI/testing/sysfs-bus-iio               | 7 +++++++
 drivers/iio/industrialio-core.c                       | 3 +++
 drivers/staging/iio/Documentation/iio_event_monitor.c | 2 ++
 include/linux/iio/types.h                             | 5 ++++-
 4 files changed, 16 insertions(+), 1 deletion(-)

diff --git a/Documentation/ABI/testing/sysfs-bus-iio b/Documentation/ABI/testing/sysfs-bus-iio
index d760b02..47df169 100644
--- a/Documentation/ABI/testing/sysfs-bus-iio
+++ b/Documentation/ABI/testing/sysfs-bus-iio
@@ -1028,3 +1028,10 @@ Contact:	linux-iio@vger.kernel.org
 Description:
 		Raw value of rotation from true/magnetic north measured with
 		or without compensation from tilt sensors.
+
+What:		/sys/bus/iio/devices/iio:deviceX/out_waveformY_hightime_raw
+What:		/sys/bus/iio/devices/iio:deviceX/out_waveformY_lowtime_raw
+KernelVersion:	3.18
+Contact:	linux-iio@vger.kernel.org
+Description:
+		Raw value of time for output to be held high or low.
diff --git a/drivers/iio/industrialio-core.c b/drivers/iio/industrialio-core.c
index af3e76d..343e784 100644
--- a/drivers/iio/industrialio-core.c
+++ b/drivers/iio/industrialio-core.c
@@ -70,6 +70,7 @@ static const char * const iio_chan_type_name_spec[] = {
 	[IIO_CCT] = "cct",
 	[IIO_PRESSURE] = "pressure",
 	[IIO_HUMIDITYRELATIVE] = "humidityrelative",
+	[IIO_WAVEFORM] = "waveform",
 };
 
 static const char * const iio_modifier_names[] = {
@@ -91,6 +92,8 @@ static const char * const iio_modifier_names[] = {
 	[IIO_MOD_NORTH_TRUE] = "from_north_true",
 	[IIO_MOD_NORTH_MAGN_TILT_COMP] = "from_north_magnetic_tilt_comp",
 	[IIO_MOD_NORTH_TRUE_TILT_COMP] = "from_north_true_tilt_comp",
+	[IIO_MOD_HIGHTIME] = "hightime",
+	[IIO_MOD_LOWTIME] = "lowtime",
 };
 
 /* relies on pairs of these shared then separate */
diff --git a/drivers/staging/iio/Documentation/iio_event_monitor.c b/drivers/staging/iio/Documentation/iio_event_monitor.c
index 569d6f8..690f261 100644
--- a/drivers/staging/iio/Documentation/iio_event_monitor.c
+++ b/drivers/staging/iio/Documentation/iio_event_monitor.c
@@ -49,6 +49,7 @@ static const char * const iio_chan_type_name_spec[] = {
 	[IIO_CCT] = "cct",
 	[IIO_PRESSURE] = "pressure",
 	[IIO_HUMIDITYRELATIVE] = "humidityrelative",
+	[IIO_WAVEFORM] = "waveform",
 };
 
 static const char * const iio_ev_type_text[] = {
@@ -108,6 +109,7 @@ static bool event_is_known(struct iio_event_data *event)
 	case IIO_CCT:
 	case IIO_PRESSURE:
 	case IIO_HUMIDITYRELATIVE:
+	case IIO_WAVEFORM:
 		break;
 	default:
 		return false;
diff --git a/include/linux/iio/types.h b/include/linux/iio/types.h
index 4a2af8a..d3b0af1 100644
--- a/include/linux/iio/types.h
+++ b/include/linux/iio/types.h
@@ -30,6 +30,7 @@ enum iio_chan_type {
 	IIO_CCT,
 	IIO_PRESSURE,
 	IIO_HUMIDITYRELATIVE,
+	IIO_WAVEFORM,
 };
 
 enum iio_modifier {
@@ -59,7 +60,9 @@ enum iio_modifier {
 	IIO_MOD_NORTH_MAGN,
 	IIO_MOD_NORTH_TRUE,
 	IIO_MOD_NORTH_MAGN_TILT_COMP,
-	IIO_MOD_NORTH_TRUE_TILT_COMP
+	IIO_MOD_NORTH_TRUE_TILT_COMP,
+	IIO_MOD_HIGHTIME,
+	IIO_MOD_LOWTIME,
 };
 
 enum iio_event_type {
-- 
2.1.0
