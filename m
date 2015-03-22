From: NeilBrown <neil-+NVA1uvv1dVBDLzU/O5InQ@public.gmane.org>
Subject: [PATCH 2/5] usb: phy: twl4030: allow charger to see usb current
 draw limits.
Date: Mon, 23 Mar 2015 09:35:23 +1100
Message-ID: <20150322223523.21765.13883.stgit@notabene.brown>
References: <20150322223307.21765.62974.stgit@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150322223307.21765.62974.stgit-wvvUuzkyo1EYVZTmpyfIwg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Kishon Vijay Abraham I <kishon-l0cyMroinI0@public.gmane.org>
Cc: NeilBrown <neilb-l3A5Bk7waGM@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, GTA04 owners <gta04-owner-xXXSsgcRVICgSpxsJD1C4w@public.gmane.org>, Tony Lindgren <tony-4v6yS6AI5VpBDgjK7y7TUQ@public.gmane.org>, Pavel Machek <pavel-+ZI9xUNit7I@public.gmane.org>
List-Id: linux-api@vger.kernel.org

From: NeilBrown <neilb-l3A5Bk7waGM@public.gmane.org>

The charger needs to know when a USB gadget has been enumerated
and what the agreed maximum current was so that it can adjust
charging accordingly.

So define a "set_power()" function to record the permitted
draw, and pass a pointer to that when sending USB_EVENT_ENUMERATED
notification.

Signed-off-by: NeilBrown <neilb-l3A5Bk7waGM@public.gmane.org>
---
 drivers/phy/phy-twl4030-usb.c |   27 +++++++++++++++++++++------
 1 file changed, 21 insertions(+), 6 deletions(-)

diff --git a/drivers/phy/phy-twl4030-usb.c b/drivers/phy/phy-twl4030-usb.c
index 1a244f34b748..0fcef8717d5b 100644
--- a/drivers/phy/phy-twl4030-usb.c
+++ b/drivers/phy/phy-twl4030-usb.c
@@ -173,6 +173,11 @@ struct twl4030_usb {
 	enum omap_musb_vbus_id_status linkstat;
 	bool			vbus_supplied;
 
+	/* Permitted vbus draw in mA - only meaningful after
+	 * USB_EVENT_ENUMERATED
+	 */
+	unsigned int		vbus_draw;
+
 	struct delayed_work	id_workaround_work;
 };
 
@@ -554,12 +559,7 @@ static irqreturn_t twl4030_usb_irq(int irq, void *_twl)
 	mutex_unlock(&twl->lock);
 
 	if (status_changed) {
-		/* FIXME add a set_power() method so that B-devices can
-		 * configure the charger appropriately.  It's not always
-		 * correct to consume VBUS power, and how much current to
-		 * consume is a function of the USB configuration chosen
-		 * by the host.
-		 *
+		/*
 		 * REVISIT usb_gadget_vbus_connect(...) as needed, ditto
 		 * its disconnect() sibling, when changing to/from the
 		 * USB_LINK_VBUS state.  musb_hdrc won't care until it
@@ -631,6 +631,20 @@ static int twl4030_set_host(struct usb_otg *otg, struct usb_bus *host)
 	return 0;
 }
 
+static int twl4030_set_power(struct usb_phy *phy, unsigned mA)
+{
+	struct twl4030_usb *twl = phy_to_twl(phy);
+
+	if (twl->vbus_draw != mA) {
+		phy->last_event = USB_EVENT_ENUMERATED;
+		twl->vbus_draw = mA;
+		atomic_notifier_call_chain(&phy->notifier,
+					   USB_EVENT_ENUMERATED,
+					   &twl->vbus_draw);
+	}
+	return 0;
+}
+
 static const struct phy_ops ops = {
 	.init		= twl4030_phy_init,
 	.power_on	= twl4030_phy_power_on,
@@ -681,6 +695,7 @@ static int twl4030_usb_probe(struct platform_device *pdev)
 	twl->phy.label		= "twl4030";
 	twl->phy.otg		= otg;
 	twl->phy.type		= USB_PHY_TYPE_USB2;
+	twl->phy.set_power	= twl4030_set_power;
 
 	otg->usb_phy		= &twl->phy;
 	otg->set_host		= twl4030_set_host;
