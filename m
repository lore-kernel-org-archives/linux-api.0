From: NeilBrown <neil@brown.name>
Subject: [PATCH 4/5] usb: phy: twl4030: add support for reading restore on
 ID pin.
Date: Mon, 23 Mar 2015 09:35:23 +1100
Message-ID: <20150322223523.21765.25592.stgit@notabene.brown>
References: <20150322223307.21765.62974.stgit@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20150322223307.21765.62974.stgit@notabene.brown>
Sender: linux-kernel-owner@vger.kernel.org
To: Kishon Vijay Abraham I <kishon@ti.com>
Cc: NeilBrown <neilb@suse.de>, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, GTA04 owners <gta04-owner@goldelico.com>, Tony Lindgren <tony@atomide.com>, Pavel Machek <pavel@ucw.cz>
List-Id: linux-api@vger.kernel.org

From: NeilBrown <neilb@suse.de>

The twl4030 phy can measure, with low precision, the
resistance-to-ground of the ID pin.

Add a function to read the value, and export the result
via sysfs.

If the read fails, which it does sometimes, try again in 50msec.

Acked-by: Pavel Machek <pavel@ucw.cz>
Signed-off-by: NeilBrown <neilb@suse.de>
---
 .../ABI/testing/sysfs-platform-twl4030-usb         |   22 +++++++
 drivers/phy/phy-twl4030-usb.c                      |   63 ++++++++++++++++++++
 2 files changed, 85 insertions(+)

diff --git a/Documentation/ABI/testing/sysfs-platform-twl4030-usb b/Documentation/ABI/testing/sysfs-platform-twl4030-usb
index 512c51be64ae..425d23676f8a 100644
--- a/Documentation/ABI/testing/sysfs-platform-twl4030-usb
+++ b/Documentation/ABI/testing/sysfs-platform-twl4030-usb
@@ -6,3 +6,25 @@ Description:
 	Possible values: "on", "off".
 
 	Changes are notified via select/poll.
+
+What: /sys/bus/platform/devices/*twl4030-usb/id
+Description:
+	Read-only report on measurement of USB-OTG ID pin.
+
+	The ID pin may be floating, grounded, or pulled to
+	ground by a resistor.
+
+	A very course grained reading of the resistance is
+	available.  The numbers given in kilo-ohms are roughly
+	the center-point of the detected range.
+
+	Possible values are:
+		ground
+		102k
+		200k
+		440k
+		floating
+		unknown
+
+	"unknown" indicates a problem with trying to detect
+	the resistance.
diff --git a/drivers/phy/phy-twl4030-usb.c b/drivers/phy/phy-twl4030-usb.c
index 0fcef8717d5b..8dbf9d2a99d1 100644
--- a/drivers/phy/phy-twl4030-usb.c
+++ b/drivers/phy/phy-twl4030-usb.c
@@ -384,6 +384,56 @@ static void twl4030_i2c_access(struct twl4030_usb *twl, int on)
 	}
 }
 
+enum twl4030_id_status {
+	TWL4030_GROUND,
+	TWL4030_102K,
+	TWL4030_200K,
+	TWL4030_440K,
+	TWL4030_FLOATING,
+	TWL4030_ID_UNKNOWN,
+};
+static char *twl4030_id_names[] = {
+	"ground",
+	"102k",
+	"200k",
+	"440k",
+	"floating",
+	"unknown"
+};
+
+enum twl4030_id_status twl4030_get_id(struct twl4030_usb *twl)
+{
+	int ret;
+
+	pm_runtime_get_sync(twl->dev);
+	if (twl->usb_mode == T2_USB_MODE_ULPI)
+		twl4030_i2c_access(twl, 1);
+	ret = twl4030_usb_read(twl, ULPI_OTG_CTRL);
+	if (ret < 0 || !(ret & ULPI_OTG_ID_PULLUP)) {
+		/* Need pull-up to read ID */
+		twl4030_usb_set_bits(twl, ULPI_OTG_CTRL,
+				     ULPI_OTG_ID_PULLUP);
+		mdelay(50);
+	}
+	ret = twl4030_usb_read(twl, ID_STATUS);
+	if (ret < 0 || (ret & 0x1f) == 0) {
+		mdelay(50);
+		ret = twl4030_usb_read(twl, ID_STATUS);
+	}
+
+	if (twl->usb_mode == T2_USB_MODE_ULPI)
+		twl4030_i2c_access(twl, 0);
+	pm_runtime_put_autosuspend(twl->dev);
+
+	if (ret < 0)
+		return TWL4030_ID_UNKNOWN;
+	ret = ffs(ret) - 1;
+	if (ret < TWL4030_GROUND || ret > TWL4030_FLOATING)
+		return TWL4030_ID_UNKNOWN;
+
+	return ret;
+}
+
 static void __twl4030_phy_power(struct twl4030_usb *twl, int on)
 {
 	u8 pwr = twl4030_usb_read(twl, PHY_PWR_CTRL);
@@ -541,6 +591,16 @@ static ssize_t twl4030_usb_vbus_show(struct device *dev,
 }
 static DEVICE_ATTR(vbus, 0444, twl4030_usb_vbus_show, NULL);
 
+static ssize_t twl4030_usb_id_show(struct device *dev,
+				   struct device_attribute *attr,
+				   char *buf)
+{
+	struct twl4030_usb *twl = dev_get_drvdata(dev);
+	return scnprintf(buf, PAGE_SIZE, "%s\n",
+			 twl4030_id_names[twl4030_get_id(twl)]);
+}
+static DEVICE_ATTR(id, 0444, twl4030_usb_id_show, NULL);
+
 static irqreturn_t twl4030_usb_irq(int irq, void *_twl)
 {
 	struct twl4030_usb *twl = _twl;
@@ -729,6 +789,8 @@ static int twl4030_usb_probe(struct platform_device *pdev)
 	platform_set_drvdata(pdev, twl);
 	if (device_create_file(&pdev->dev, &dev_attr_vbus))
 		dev_warn(&pdev->dev, "could not create sysfs file\n");
+	if (device_create_file(&pdev->dev, &dev_attr_id))
+		dev_warn(&pdev->dev, "could not create sysfs file\n");
 
 	ATOMIC_INIT_NOTIFIER_HEAD(&twl->phy.notifier);
 
@@ -774,6 +836,7 @@ static int twl4030_usb_remove(struct platform_device *pdev)
 	pm_runtime_get_sync(twl->dev);
 	cancel_delayed_work(&twl->id_workaround_work);
 	device_remove_file(twl->dev, &dev_attr_vbus);
+	device_remove_file(twl->dev, &dev_attr_id);
 
 	/* set transceiver mode to power on defaults */
 	twl4030_usb_set_mode(twl, -1);
