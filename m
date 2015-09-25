From: Andreas Dannenberg <dannenberg@ti.com>
Subject: [PATCH v7 15/15] Documentation: power: bq24257: Document exported sysfs entries
Date: Fri, 25 Sep 2015 10:54:20 -0500
Message-ID: <1443196460-26156-16-git-send-email-dannenberg@ti.com>
References: <1443196460-26156-1-git-send-email-dannenberg@ti.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-pm-owner@vger.kernel.org>
In-Reply-To: <1443196460-26156-1-git-send-email-dannenberg@ti.com>
Sender: linux-pm-owner@vger.kernel.org
To: Sebastian Reichel <sre@kernel.org>, Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>, David Woodhouse <dwmw2@infradead.org>, Laurentiu Palcu <laurentiu.palcu@intel.com>, Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: Ramakrishna Pallala <ramakrishna.pallala@intel.com>, linux-pm@vger.kernel.org, devicetree@vger.kernel.org, linux-api@vger.kernel.org, Andreas Dannenberg <dannenberg@ti.com>
List-Id: linux-api@vger.kernel.org

Document the settings exported by bq24257 charger driver through sysfs
entries:
- ovp_voltage
- in_dpm_voltage
- high_impedance_enable
- sysoff_enable

Signed-off-by: Andreas Dannenberg <dannenberg@ti.com>
---
 Documentation/ABI/testing/sysfs-class-power | 58 +++++++++++++++++++++++++++++
 1 file changed, 58 insertions(+)

diff --git a/Documentation/ABI/testing/sysfs-class-power b/Documentation/ABI/testing/sysfs-class-power
index 369d2a2..d96b5fc 100644
--- a/Documentation/ABI/testing/sysfs-class-power
+++ b/Documentation/ABI/testing/sysfs-class-power
@@ -74,3 +74,61 @@ Description:
 
 		Valid values:
 		- 0 - 70 (minutes), step by 10 (rounded down)
+
+What:		/sys/class/power_supply/bq24257-charger/ovp_voltage
+Date:		September 2015
+KernelVersion: 4.3.0
+Contact:	Andreas Dannenberg <dannenberg@ti.com>
+Description:
+		This entry configures the overvoltage protection feature of bq24257-
+		type charger devices. This feature protects the device and other
+		components against damage from overvoltage on the input supply. See
+		device datasheet for details.
+
+		Valid values:
+		- 6000000, 6500000, 7000000, 8000000, 9000000, 9500000, 10000000,
+		  10500000 (all uV)
+
+What:		/sys/class/power_supply/bq24257-charger/in_dpm_voltage
+Date:		September 2015
+KernelVersion: 4.3.0
+Contact:	Andreas Dannenberg <dannenberg@ti.com>
+Description:
+		This entry configures the input dynamic power path management voltage of
+		bq24257-type charger devices. Once the supply drops to the configured
+		voltage, the input current limit is reduced down to prevent the further
+		drop of the supply. When the IC enters this mode, the charge current is
+		lower than the set value. See device datasheet for details.
+
+		Valid values:
+		- 4200000, 4280000, 4360000, 4440000, 4520000, 4600000, 4680000,
+		  4760000 (all uV)
+
+What:		/sys/class/power_supply/bq24257-charger/high_impedance_enable
+Date:		September 2015
+KernelVersion: 4.3.0
+Contact:	Andreas Dannenberg <dannenberg@ti.com>
+Description:
+		This entry allows enabling the high-impedance mode of bq24257-type
+		charger devices. If enabled, it places the charger IC into low power
+		standby mode with the switch mode controller disabled. When disabled,
+		the charger operates normally. See device datasheet for details.
+
+		Valid values:
+		- 1: enabled
+		- 0: disabled
+
+What:		/sys/class/power_supply/bq24257-charger/sysoff_enable
+Date:		September 2015
+KernelVersion: 4.3.0
+Contact:	Andreas Dannenberg <dannenberg@ti.com>
+Description:
+		This entry allows enabling the sysoff mode of bq24257-type charger
+		devices. If enabled and the input is removed, the internal battery FET
+		is turned off in order to reduce the leakage from the BAT pin to less
+		than 1uA. Note that on some devices/systems this disconnects the battery
+		from the system. See device datasheet for details.
+
+		Valid values:
+		- 1: enabled
+		- 0: disabled
-- 
1.9.1

