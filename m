From: NeilBrown <neil@brown.name>
Subject: [PATCH 5/5] usb: phy: twl4030: test ID resistance to see if charger
 is present.
Date: Mon, 23 Mar 2015 09:35:23 +1100
Message-ID: <20150322223523.21765.9452.stgit@notabene.brown>
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

If an 'A' plug is inserted, ID should be pulled to ground.
If a 'B' plug, then ID should be floating.

If an Accessory Charger Adapter is inserted, then ID will
be neither grounded nor floating.  In this case tell the
USB subsystem that it is an A plug, and the battery
charging subsystem that it is a charger.

Fortunately, this will treat the Openmoko charger (and
other similar chargers) as a charger.

Acked-by: Pavel Machek <pavel@ucw.cz>
Signed-off-by: NeilBrown <neilb@suse.de>
---
 drivers/phy/phy-twl4030-usb.c |   28 ++++++++++++++++++++++++++++
 1 file changed, 28 insertions(+)

diff --git a/drivers/phy/phy-twl4030-usb.c b/drivers/phy/phy-twl4030-usb.c
index 8dbf9d2a99d1..d81753bad1ca 100644
--- a/drivers/phy/phy-twl4030-usb.c
+++ b/drivers/phy/phy-twl4030-usb.c
@@ -606,9 +606,31 @@ static irqreturn_t twl4030_usb_irq(int irq, void *_twl)
 	struct twl4030_usb *twl = _twl;
 	enum omap_musb_vbus_id_status status;
 	bool status_changed = false;
+	bool found_charger = false;
 
 	status = twl4030_usb_linkstat(twl);
 
+	if (status == OMAP_MUSB_ID_GROUND ||
+	    status == OMAP_MUSB_VBUS_VALID) {
+		/* We should check the resistance on the ID pin.
+		 * If not a Ground or Floating, then this is
+		 * likely a charger
+		 */
+		enum twl4030_id_status sts = twl4030_get_id(twl);
+		if (sts > TWL4030_GROUND &&
+		    sts < TWL4030_FLOATING) {
+			/*
+			 * This might be a charger, or an
+			 * Accessory Charger Adapter.
+			 * In either case we can charge, and it
+			 * makes sense to tell the USB system
+			 * that we might be acting as a HOST.
+			 */
+			status = OMAP_MUSB_ID_GROUND;
+			found_charger = true;
+		}
+	}
+
 	mutex_lock(&twl->lock);
 	if (status >= 0 && status != twl->linkstat) {
 		status_changed =
@@ -633,6 +655,12 @@ static irqreturn_t twl4030_usb_irq(int irq, void *_twl)
 		}
 		omap_musb_mailbox(status);
 	}
+	if (found_charger && twl->phy.last_event != USB_EVENT_CHARGER) {
+		twl->phy.last_event = USB_EVENT_CHARGER;
+		atomic_notifier_call_chain(&twl->phy.notifier,
+					   USB_EVENT_CHARGER,
+					   NULL);
+	}
 
 	/* don't schedule during sleep - irq works right then */
 	if (status == OMAP_MUSB_ID_GROUND && pm_runtime_active(twl->dev)) {
