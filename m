From: NeilBrown <neil@brown.name>
Subject: [PATCH 14/14] twl4030_charger: assume a 'charger' can supply
 maximum current.
Date: Mon, 23 Mar 2015 10:20:29 +1100
Message-ID: <20150322232029.23789.35538.stgit@notabene.brown>
References: <20150322231635.23789.70149.stgit@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-omap-owner@vger.kernel.org>
In-Reply-To: <20150322231635.23789.70149.stgit@notabene.brown>
Sender: linux-omap-owner@vger.kernel.org
To: Sebastian Reichel <sre@kernel.org>
Cc: NeilBrown <neilb@suse.de>, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, GTA04 owners <gta04-owner@goldelico.com>, inux-pm@vger.kernel.org, Pavel Machek <pavel@ucw.cz>, linux-omap@vger.kernel.org, Lee Jones <lee.jones@linaro.org>
List-Id: linux-api@vger.kernel.org

From: NeilBrown <neilb@suse.de>

If it cannot, we will stop pulling more current when voltage drops.

Signed-off-by: NeilBrown <neilb@suse.de>
---
 drivers/power/twl4030_charger.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/power/twl4030_charger.c b/drivers/power/twl4030_charger.c
index d0199495dddc..6f0dc971d84d 100644
--- a/drivers/power/twl4030_charger.c
+++ b/drivers/power/twl4030_charger.c
@@ -694,8 +694,10 @@ static void twl4030_bci_usb_work(struct work_struct *data)
 	struct twl4030_bci *bci = container_of(data, struct twl4030_bci, work);
 
 	switch (bci->event) {
-	case USB_EVENT_VBUS:
 	case USB_EVENT_CHARGER:
+		bci->usb_cur = USB_MAX_CURRENT;
+		/* FALL THROUGH */
+	case USB_EVENT_VBUS:
 	case USB_EVENT_ENUMERATED:
 		twl4030_charger_enable_usb(bci, true);
 		break;


