From: Guenter Roeck <linux-0h96xk9xTtrk1uMJSBkQmQ@public.gmane.org>
Subject: [PATCH 5/5] i8k: Add support for Dell Precision 490 and Latitude D520
Date: Sat, 21 Jun 2014 08:08:12 -0700
Message-ID: <1403363304-22358-5-git-send-email-linux@roeck-us.net>
References: <1403363304-22358-1-git-send-email-linux@roeck-us.net>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1403363304-22358-1-git-send-email-linux-0h96xk9xTtrk1uMJSBkQmQ@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Guenter Roeck <linux-0h96xk9xTtrk1uMJSBkQmQ@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Both systems need non-standard parameters for fan multiplier
and maximum fan speed.

Signed-off-by: Guenter Roeck <linux-0h96xk9xTtrk1uMJSBkQmQ@public.gmane.org>
---
 drivers/char/i8k.c | 27 +++++++++++++++++++++++++++
 1 file changed, 27 insertions(+)

diff --git a/drivers/char/i8k.c b/drivers/char/i8k.c
index 0b69da0..65525c7 100644
--- a/drivers/char/i8k.c
+++ b/drivers/char/i8k.c
@@ -650,11 +650,21 @@ struct i8k_config_data {
 };
 
 enum i8k_configs {
+	DELL_LATITUDE_D520,
+	DELL_PRECISION_490,
 	DELL_STUDIO,
 	DELL_XPS_M140,
 };
 
 static const struct i8k_config_data i8k_config_data[] = {
+	[DELL_LATITUDE_D520] = {
+		.fan_mult = 1,
+		.fan_max = I8K_FAN_TURBO,
+	},
+	[DELL_PRECISION_490] = {
+		.fan_mult = 1,
+		.fan_max = I8K_FAN_TURBO,
+	},
 	[DELL_STUDIO] = {
 		.fan_mult = 1,
 		.fan_max = I8K_FAN_HIGH,
@@ -688,6 +698,14 @@ static struct dmi_system_id i8k_dmi_table[] __initdata = {
 		},
 	},
 	{
+		.ident = "Dell Latitude D520",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "Latitude D520"),
+		},
+		.driver_data = (void *)&i8k_config_data[DELL_LATITUDE_D520],
+	},
+	{
 		.ident = "Dell Latitude 2",
 		.matches = {
 			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
@@ -709,6 +727,15 @@ static struct dmi_system_id i8k_dmi_table[] __initdata = {
 		},
 	},
 	{
+		.ident = "Dell Precision 490",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
+			DMI_MATCH(DMI_PRODUCT_NAME,
+				  "Precision WorkStation 490"),
+		},
+		.driver_data = (void *)&i8k_config_data[DELL_PRECISION_490],
+	},
+	{
 		.ident = "Dell Precision",
 		.matches = {
 			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
-- 
1.9.1
