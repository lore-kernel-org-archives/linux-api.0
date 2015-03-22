From: NeilBrown <neil@brown.name>
Subject: [PATCH 09/14] twl4030_charger: only draw USB current as negotiated
 with host.
Date: Mon, 23 Mar 2015 10:20:29 +1100
Message-ID: <20150322232029.23789.13713.stgit@notabene.brown>
References: <20150322231635.23789.70149.stgit@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20150322231635.23789.70149.stgit@notabene.brown>
Sender: linux-kernel-owner@vger.kernel.org
To: Sebastian Reichel <sre@kernel.org>
Cc: NeilBrown <neilb@suse.de>, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, GTA04 owners <gta04-owner@goldelico.com>, inux-pm@vger.kernel.org, Pavel Machek <pavel@ucw.cz>, linux-omap@vger.kernel.org, Lee Jones <lee.jones@linaro.org>
List-Id: linux-api@vger.kernel.org

From: NeilBrown <neilb@suse.de>

If the phy has been told what current it can draw, it tells us
and now we use that number.

Note that 'vbus_draw' is in mA, while usb_cur is in uA.

Acked-by: Pavel Machek <pavel@ucw.cz>
Signed-off-by: NeilBrown <neilb@suse.de>
---
 drivers/power/twl4030_charger.c |    5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/power/twl4030_charger.c b/drivers/power/twl4030_charger.c
index df031b0123d0..2042e7619954 100644
--- a/drivers/power/twl4030_charger.c
+++ b/drivers/power/twl4030_charger.c
@@ -602,6 +602,7 @@ static void twl4030_bci_usb_work(struct work_struct *data)
 	switch (bci->event) {
 	case USB_EVENT_VBUS:
 	case USB_EVENT_CHARGER:
+	case USB_EVENT_ENUMERATED:
 		twl4030_charger_enable_usb(bci, true);
 		break;
 	case USB_EVENT_NONE:
@@ -614,6 +615,7 @@ static int twl4030_bci_usb_ncb(struct notifier_block *nb, unsigned long val,
 			       void *priv)
 {
 	struct twl4030_bci *bci = container_of(nb, struct twl4030_bci, usb_nb);
+	unsigned int *vbus_draw = priv;
 
 	dev_dbg(bci->dev, "OTG notify %lu\n", val);
 
@@ -624,6 +626,9 @@ static int twl4030_bci_usb_ncb(struct notifier_block *nb, unsigned long val,
 		bci->usb_cur = 100000;
 
 	bci->event = val;
+	if (val == USB_EVENT_ENUMERATED && vbus_draw &&
+	    *vbus_draw * 1000 > bci->usb_cur)
+		bci->usb_cur = *vbus_draw * 1000;
 	schedule_work(&bci->work);
 
 	return NOTIFY_OK;
