From: Andreas Dannenberg <dannenberg@ti.com>
Subject: [PATCH v6 03/14] power: bq24257: Streamline input current limit setup
Date: Thu, 24 Sep 2015 22:26:47 -0500
Message-ID: <1443151618-29742-4-git-send-email-dannenberg@ti.com>
References: <1443151618-29742-1-git-send-email-dannenberg@ti.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-pm-owner@vger.kernel.org>
In-Reply-To: <1443151618-29742-1-git-send-email-dannenberg@ti.com>
Sender: linux-pm-owner@vger.kernel.org
To: Sebastian Reichel <sre@kernel.org>, Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>, David Woodhouse <dwmw2@infradead.org>, Laurentiu Palcu <laurentiu.palcu@intel.com>, Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: Ramakrishna Pallala <ramakrishna.pallala@intel.com>, linux-pm@vger.kernel.org, devicetree@vger.kernel.org, linux-api@vger.kernel.org, Andreas Dannenberg <dannenberg@ti.com>
List-Id: linux-api@vger.kernel.org

The maximum amount of input current the charger should draw is dependent
on the power supply and should only be (re-)configured when the power
supply gets connected and disconnected. However the driver was also
lowering the bq24257's input current limit setting to 500mA when the
battery was removed and restored the previous setting according to the
power supply capabilities when the battery was reconnected although
these events are not impacting the amount of power that can be drawn
from the supply. Furthermore, a re-configuration of the input current
limit to 500mA when the battery gets disconnected is actually dangerous
if the limit was set higher previously and the system draws more than
500mA in which case the system voltage would be reduced in order to
maintain 500mA which could result in the system getting too low of a
supply to maintain operation. Last but not least the mechanism itself
used for battery re-connection detection did not work in corner cases
such as when the device's input current loop becomes active and the
bq24257 device clears its battery fault error resulting in incorrectly
reporting that the battery got reconnected.

This patches removes the impact the battery removal/insertion has on the
input current limit configured for the bq24257 and simplifies the
associated handler routine.

Signed-off-by: Andreas Dannenberg <dannenberg@ti.com>
---
 drivers/power/bq24257_charger.c | 31 ++++++++++++-------------------
 1 file changed, 12 insertions(+), 19 deletions(-)

diff --git a/drivers/power/bq24257_charger.c b/drivers/power/bq24257_charger.c
index 69b53d0..d8939dc 100644
--- a/drivers/power/bq24257_charger.c
+++ b/drivers/power/bq24257_charger.c
@@ -448,14 +448,13 @@ static void bq24257_handle_state_change(struct bq24257_device *bq,
 {
 	int ret;
 	struct bq24257_state old_state;
-	bool reset_iilimit = false;
-	bool config_iilimit = false;
 
 	mutex_lock(&bq->lock);
 	old_state = bq->state;
 	mutex_unlock(&bq->lock);
 
-	if (!new_state->power_good) {			     /* power removed */
+	if (!new_state->power_good) {
+		dev_dbg(bq->dev, "Power removed\n");
 		cancel_delayed_work_sync(&bq->iilimit_setup_work);
 
 		/* activate D+/D- port detection algorithm */
@@ -463,26 +462,20 @@ static void bq24257_handle_state_change(struct bq24257_device *bq,
 		if (ret < 0)
 			goto error;
 
-		reset_iilimit = true;
-	} else if (!old_state.power_good) {		    /* power inserted */
-		config_iilimit = true;
-	} else if (new_state->fault == FAULT_NO_BAT) {	   /* battery removed */
-		cancel_delayed_work_sync(&bq->iilimit_setup_work);
-
-		reset_iilimit = true;
-	} else if (old_state.fault == FAULT_NO_BAT) {    /* battery connected */
-		config_iilimit = true;
-	} else if (new_state->fault == FAULT_TIMER) { /* safety timer expired */
-		dev_err(bq->dev, "Safety timer expired! Battery dead?\n");
-	}
-
-	if (reset_iilimit) {
+		/* reset input current limit */
 		ret = bq24257_field_write(bq, F_IILIMIT, IILIMIT_500);
 		if (ret < 0)
 			goto error;
-	} else if (config_iilimit) {
-		schedule_delayed_work(&bq->iilimit_setup_work,
+	} else if (!old_state.power_good) {
+		dev_dbg(bq->dev, "Power inserted\n");
+		if (bq->iilimit_autoset_enable)
+			/* configure input current limit */
+			schedule_delayed_work(&bq->iilimit_setup_work,
 				      msecs_to_jiffies(BQ24257_ILIM_SET_DELAY));
+	} else if (new_state->fault == FAULT_NO_BAT) {
+		dev_warn(bq->dev, "Battery removed\n");
+	} else if (new_state->fault == FAULT_TIMER) {
+		dev_err(bq->dev, "Safety timer expired! Battery dead?\n");
 	}
 
 	return;
-- 
1.9.1

