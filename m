From: Sebastian Reichel <sre@kernel.org>
Subject: [PATCH 3/9] HSI: cmt_speech: Return error if HSI port not configured
Date: Mon,  2 Mar 2015 05:38:53 +0100
Message-ID: <1425271139-24715-4-git-send-email-sre@kernel.org>
References: <1425271139-24715-1-git-send-email-sre@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1425271139-24715-1-git-send-email-sre@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Sebastian Reichel <sre@kernel.org>
Cc: Peter Ujfalusi <peter.ujfalusi@ti.com>, Kai Vehmanen <kvcontact@nosignal.fi>, Pavel Machek <pavel@ucw.cz>, Pali Rohar <pali.rohar@gmail.com>, Aaro Koskinen <aaro.koskinen@iki.fi>, Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>, linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, Kai Vehmanen <kai.vehmanen@nokia.com>, Joni Lapilainen <joni.lapilainen@gmail.com>
List-Id: linux-api@vger.kernel.org

From: Kai Vehmanen <kai.vehmanen@nokia.com>

If HSI port is not configured by ssi_protocol, return an error from
char device open.

Signed-off-by: Kai Vehmanen <kai.vehmanen@nokia.com>
Acked-by: Carlos Chinea <carlos.chinea@nokia.com>
Signed-off-by: Joni Lapilainen <joni.lapilainen@gmail.com>
Signed-off-by: Sebastian Reichel <sre@kernel.org>
---
 drivers/hsi/clients/cmt_speech.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/hsi/clients/cmt_speech.c b/drivers/hsi/clients/cmt_speech.c
index 389eafb..56846c9 100644
--- a/drivers/hsi/clients/cmt_speech.c
+++ b/drivers/hsi/clients/cmt_speech.c
@@ -1037,6 +1037,13 @@ static int cs_hsi_start(struct cs_hsi_iface **hi, struct hsi_client *cl,
 		dev_err(&cl->device, "Could not get HSI master client\n");
 		goto leave4;
 	}
+	if (!ssip_slave_running(hsi_if->master)) {
+		err = -ENODEV;
+		dev_err(&cl->device,
+				"HSI port not initialized\n");
+		goto leave4;
+	}
+
 	hsi_if->iface_state = CS_STATE_OPENED;
 	local_bh_disable();
 	cs_hsi_read_on_control(hsi_if);
-- 
2.1.4
