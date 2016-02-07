From: Cristina Moraru <cristina.moraru09@gmail.com>
Subject: [PATCH 3/5] iio: hmc5843: Add ABI documentation file for hmc5843
Date: Mon,  8 Feb 2016 00:21:49 +0200
Message-ID: <1454883711-15489-4-git-send-email-cristina.moraru09@gmail.com>
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

Add ABI file documenting hmc5843 non-standard attributes
meas_conf and meas_conf_available for bias current
configuration.

Signed-off-by: Cristina Moraru <cristina.moraru09@gmail.com>
---
 .../ABI/testing/sysfs-bus-iio-magnetometer-hmc5843        | 15 +++++++++++++++
 1 file changed, 15 insertions(+)
 create mode 100644 Documentation/ABI/testing/sysfs-bus-iio-magnetometer-hmc5843

diff --git a/Documentation/ABI/testing/sysfs-bus-iio-magnetometer-hmc5843 b/Documentation/ABI/testing/sysfs-bus-iio-magnetometer-hmc5843
new file mode 100644
index 0000000..7c3fc4c
--- /dev/null
+++ b/Documentation/ABI/testing/sysfs-bus-iio-magnetometer-hmc5843
@@ -0,0 +1,15 @@
+What:           /sys/bus/iio/devices/iio:deviceX/meas_conf
+What:           /sys/bus/iio/devices/iio:deviceX/meas_conf_available
+KernelVersion:  4.3.0
+Contact:        linux-iio@vger.kernel.org
+Description:
+                Current configuration and available configurations
+		for the bias current.
+		0 - Normal measurement configurations (default)
+		1 - Positive bias configuration
+		2 - Negative bias configuration
+		3 - Only available on HMC5983. Disables magnetic
+		sensor and enables temperature sensor.
+		Note: The effect of this configuration may vary
+		according to the device. For exact documentation
+		check the device's datasheet.
-- 
1.9.1
