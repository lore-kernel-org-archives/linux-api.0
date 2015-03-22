From: NeilBrown <neil-+NVA1uvv1dVBDLzU/O5InQ@public.gmane.org>
Subject: [PATCH 1/5] usb: phy: twl4030: make runtime pm more reliable.
Date: Mon, 23 Mar 2015 09:35:23 +1100
Message-ID: <20150322223523.21765.3199.stgit@notabene.brown>
References: <20150322223307.21765.62974.stgit@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150322223307.21765.62974.stgit-wvvUuzkyo1EYVZTmpyfIwg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Kishon Vijay Abraham I <kishon-l0cyMroinI0@public.gmane.org>
Cc: Tony Lindgren <tony-4v6yS6AI5VpBDgjK7y7TUQ@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, GTA04 owners <gta04-owner-xXXSsgcRVICgSpxsJD1C4w@public.gmane.org>, NeilBrown <neilb-l3A5Bk7waGM@public.gmane.org>, Pavel Machek <pavel-+ZI9xUNit7I@public.gmane.org>
List-Id: linux-api@vger.kernel.org

From: NeilBrown <neilb-l3A5Bk7waGM@public.gmane.org>

A construct like:

        if (pm_runtime_suspended(twl->dev))
               pm_runtime_get_sync(twl->dev);

is against the spirit of the runtime_pm interface as it
makes the internal refcounting useless.

In this case it is also racy, particularly as 'put_autosuspend'
is use to drop a reference.
When that happens a timer is started and the device is
runtime-suspended after the timeout.
If the above code runs in this window, the device will not be
found to be suspended so no pm_runtime reference is taken.
When the timer expires the device will be suspended, which is
against the intention of the code.

So be more direct is taking and dropping references.
If twl->linkstat is VBUS_VALID or ID_GROUND, then hold a
pm_runtime reference, otherwise don't.
Define "cable_present()" to test for this condition.

Tested-by: Tony Lindgren <tony-4v6yS6AI5VpBDgjK7y7TUQ@public.gmane.org>
Signed-off-by: NeilBrown <neilb-l3A5Bk7waGM@public.gmane.org>
---
 drivers/phy/phy-twl4030-usb.c |   29 ++++++++++++++++++++---------
 1 file changed, 20 insertions(+), 9 deletions(-)

diff --git a/drivers/phy/phy-twl4030-usb.c b/drivers/phy/phy-twl4030-usb.c
index 8e87f54671f3..1a244f34b748 100644
--- a/drivers/phy/phy-twl4030-usb.c
+++ b/drivers/phy/phy-twl4030-usb.c
@@ -144,6 +144,16 @@
 #define PMBR1				0x0D
 #define GPIO_USB_4PIN_ULPI_2430C	(3 << 0)
 
+/*
+ * If VBUS is valid or ID is ground, then we know a
+ * cable is present and we need to be runtime-enabled
+ */
+static inline bool cable_present(enum omap_musb_vbus_id_status stat)
+{
+	return stat == OMAP_MUSB_VBUS_VALID ||
+		stat == OMAP_MUSB_ID_GROUND;
+}
+
 struct twl4030_usb {
 	struct usb_phy		phy;
 	struct device		*dev;
@@ -536,8 +546,10 @@ static irqreturn_t twl4030_usb_irq(int irq, void *_twl)
 
 	mutex_lock(&twl->lock);
 	if (status >= 0 && status != twl->linkstat) {
+		status_changed =
+			cable_present(twl->linkstat) !=
+			cable_present(status);
 		twl->linkstat = status;
-		status_changed = true;
 	}
 	mutex_unlock(&twl->lock);
 
@@ -553,15 +565,11 @@ static irqreturn_t twl4030_usb_irq(int irq, void *_twl)
 		 * USB_LINK_VBUS state.  musb_hdrc won't care until it
 		 * starts to handle softconnect right.
 		 */
-		if ((status == OMAP_MUSB_VBUS_VALID) ||
-		    (status == OMAP_MUSB_ID_GROUND)) {
-			if (pm_runtime_suspended(twl->dev))
-				pm_runtime_get_sync(twl->dev);
+		if (cable_present(status)) {
+			pm_runtime_get_sync(twl->dev);
 		} else {
-			if (pm_runtime_active(twl->dev)) {
-				pm_runtime_mark_last_busy(twl->dev);
-				pm_runtime_put_autosuspend(twl->dev);
-			}
+			pm_runtime_mark_last_busy(twl->dev);
+			pm_runtime_put_autosuspend(twl->dev);
 		}
 		omap_musb_mailbox(status);
 	}
@@ -768,6 +776,9 @@ static int twl4030_usb_remove(struct platform_device *pdev)
 
 	/* disable complete OTG block */
 	twl4030_usb_clear_bits(twl, POWER_CTRL, POWER_CTRL_OTG_ENAB);
+
+	if (cable_present(twl->linkstat))
+		pm_runtime_put_noidle(twl->dev);
 	pm_runtime_mark_last_busy(twl->dev);
 	pm_runtime_put(twl->dev);
 
