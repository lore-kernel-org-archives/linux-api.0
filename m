From: Adam Thomson <Adam.Thomson.Opensource@diasemi.com>
Subject: [PATCH v4 8/8] iio: Add ABI documentation for input current readings
Date: Tue, 25 Nov 2014 18:25:39 +0000
Message-ID: <9d3c3451c2cac6035277fb36ffead1a1f8af453e.1416938054.git.Adam.Thomson.Opensource@diasemi.com>
References: <cover.1416938054.git.Adam.Thomson.Opensource@diasemi.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <cover.1416938054.git.Adam.Thomson.Opensource@diasemi.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Lee Jones <lee.jones@linaro.org>, Samuel Ortiz <sameo@linux.intel.com>, Jonathan Cameron <jic23@kernel.org>, linux-iio@vger.kernel.org, Sebastian Reichel <sre@kernel.org>, Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>, David Woodhouse <dwmw2@infradead.org>, linux-pm@vger.kernel.org, Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>, Ian Campbell <ijc+devicetree@hellion.org.uk>, Kumar Gala <galak@codeaurora.org>, Grant Likely <grant.likely@linaro.org>, devicetree@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, Joe Perches <joe@perches.com>, linux-api@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, support.opensource@diasemi.com
List-Id: linux-api@vger.kernel.org

Add information on in_current related readings.

Signed-off-by: Adam Thomson <Adam.Thomson.Opensource@diasemi.com>
---
 Documentation/ABI/testing/sysfs-bus-iio | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/Documentation/ABI/testing/sysfs-bus-iio b/Documentation/ABI/testing/sysfs-bus-iio
index d760b02..37cd4d4 100644
--- a/Documentation/ABI/testing/sysfs-bus-iio
+++ b/Documentation/ABI/testing/sysfs-bus-iio
@@ -92,6 +92,18 @@ Description:
 		is required is a consistent labeling.  Units after application
 		of scale and offset are millivolts.

+What:		/sys/bus/iio/devices/iio:deviceX/in_currentY_raw
+What:		/sys/bus/iio/devices/iio:deviceX/in_currentY_supply_raw
+KernelVersion:	3.17
+Contact:	linux-iio@vger.kernel.org
+Description:
+		Raw (unscaled no bias removal etc.) current measurement from
+		channel Y. In special cases where the channel does not
+		correspond to externally available input one of the named
+		versions may be used. The number must always be specified and
+		unique to allow association with event codes. Units after
+		application of scale and offset are milliamps.
+
 What:		/sys/bus/iio/devices/iio:deviceX/in_capacitanceY_raw
 KernelVersion:	3.2
 Contact:	linux-iio@vger.kernel.org
@@ -227,6 +239,8 @@ What:		/sys/bus/iio/devices/iio:deviceX/in_accel_y_offset
 What:		/sys/bus/iio/devices/iio:deviceX/in_accel_z_offset
 What:		/sys/bus/iio/devices/iio:deviceX/in_voltageY_offset
 What:		/sys/bus/iio/devices/iio:deviceX/in_voltage_offset
+What:		/sys/bus/iio/devices/iio:deviceX/in_currentY_offset
+What:		/sys/bus/iio/devices/iio:deviceX/in_current_offset
 What:		/sys/bus/iio/devices/iio:deviceX/in_tempY_offset
 What:		/sys/bus/iio/devices/iio:deviceX/in_temp_offset
 What:		/sys/bus/iio/devices/iio:deviceX/in_pressureY_offset
@@ -249,8 +263,11 @@ Description:
 		to the _raw output.

 What:		/sys/bus/iio/devices/iio:deviceX/in_voltageY_scale
+What:		/sys/bus/iio/devices/iio:deviceX/in_currentY_scale
 What:		/sys/bus/iio/devices/iio:deviceX/in_voltageY_supply_scale
+What:		/sys/bus/iio/devices/iio:deviceX/in_currentY_supply_scale
 What:		/sys/bus/iio/devices/iio:deviceX/in_voltage_scale
+What:		/sys/bus/iio/devices/iio:deviceX/in_current_scale
 What:		/sys/bus/iio/devices/iio:deviceX/out_voltageY_scale
 What:		/sys/bus/iio/devices/iio:deviceX/out_altvoltageY_scale
 What:		/sys/bus/iio/devices/iio:deviceX/in_accel_scale
--
1.9.3
