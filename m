From: Sebastian Reichel <sre@kernel.org>
Subject: [PATCH 9/9] HSI: nokia-modem: Add cmt_speech support
Date: Mon,  2 Mar 2015 05:38:59 +0100
Message-ID: <1425271139-24715-10-git-send-email-sre@kernel.org>
References: <1425271139-24715-1-git-send-email-sre@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1425271139-24715-1-git-send-email-sre@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Sebastian Reichel <sre@kernel.org>
Cc: Peter Ujfalusi <peter.ujfalusi@ti.com>, Kai Vehmanen <kvcontact@nosignal.fi>, Pavel Machek <pavel@ucw.cz>, Pali Rohar <pali.rohar@gmail.com>, Aaro Koskinen <aaro.koskinen@iki.fi>, Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>, linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

This adds cmt_speech support to the nokia-modem driver
and adds Kconfig entries for cmt_speech, so that it can
be built.

Signed-off-by: Sebastian Reichel <sre@kernel.org>
---
 drivers/hsi/clients/Kconfig       | 11 ++++++++++-
 drivers/hsi/clients/Makefile      |  1 +
 drivers/hsi/clients/nokia-modem.c | 31 ++++++++++++++++++++++++++++++-
 3 files changed, 41 insertions(+), 2 deletions(-)

diff --git a/drivers/hsi/clients/Kconfig b/drivers/hsi/clients/Kconfig
index bc60dec..77ee7bc 100644
--- a/drivers/hsi/clients/Kconfig
+++ b/drivers/hsi/clients/Kconfig
@@ -6,13 +6,22 @@ comment "HSI clients"
 
 config NOKIA_MODEM
 	tristate "Nokia Modem"
-	depends on HSI && SSI_PROTOCOL
+	depends on HSI && SSI_PROTOCOL && CMT_SPEECH
 	help
 	Say Y here if you want to add support for the modem on Nokia
 	N900 (Nokia RX-51) hardware.
 
 	If unsure, say N.
 
+config CMT_SPEECH
+	tristate "CMT speech"
+	depends on HSI && PHONET && OMAP_SSI
+	help
+	If you say Y here, you will enable the CMT speech protocol used
+	by Nokia modems.
+
+	If unsure, say N.
+
 config SSI_PROTOCOL
 	tristate "SSI protocol"
 	depends on HSI && PHONET && OMAP_SSI
diff --git a/drivers/hsi/clients/Makefile b/drivers/hsi/clients/Makefile
index 4d5bc0e..2607232 100644
--- a/drivers/hsi/clients/Makefile
+++ b/drivers/hsi/clients/Makefile
@@ -4,4 +4,5 @@
 
 obj-$(CONFIG_NOKIA_MODEM)	+= nokia-modem.o
 obj-$(CONFIG_SSI_PROTOCOL)	+= ssi_protocol.o
+obj-$(CONFIG_CMT_SPEECH)	+= cmt_speech.o
 obj-$(CONFIG_HSI_CHAR)		+= hsi_char.o
diff --git a/drivers/hsi/clients/nokia-modem.c b/drivers/hsi/clients/nokia-modem.c
index 9be4867..ef6ebda 100644
--- a/drivers/hsi/clients/nokia-modem.c
+++ b/drivers/hsi/clients/nokia-modem.c
@@ -46,6 +46,7 @@ struct nokia_modem_device {
 	struct nokia_modem_gpio	*gpios;
 	int			gpio_amount;
 	struct hsi_client	*ssi_protocol;
+	struct hsi_client	*cmt_speech;
 };
 
 static void do_nokia_modem_rst_ind_tasklet(unsigned long data)
@@ -149,6 +150,7 @@ static int nokia_modem_probe(struct device *dev)
 	struct hsi_port *port = hsi_get_port(cl);
 	int irq, pflags, err;
 	struct hsi_board_info ssip;
+	struct hsi_board_info cmtspeech;
 
 	np = dev->of_node;
 	if (!np) {
@@ -214,12 +216,34 @@ static int nokia_modem_probe(struct device *dev)
 		goto error3;
 	}
 
-	/* TODO: register cmt-speech hsi client */
+	cmtspeech.name = "cmt-speech";
+	cmtspeech.tx_cfg = cl->tx_cfg;
+	cmtspeech.rx_cfg = cl->rx_cfg;
+	cmtspeech.platform_data = NULL;
+	cmtspeech.archdata = NULL;
+
+	modem->cmt_speech = hsi_new_client(port, &cmtspeech);
+	if (!modem->cmt_speech) {
+		dev_err(dev, "Could not register cmt-speech device\n");
+		goto error3;
+	}
+
+	err = device_attach(&modem->cmt_speech->device);
+	if (err == 0) {
+		dev_err(dev, "Missing cmt-speech driver\n");
+		err = -EPROBE_DEFER;
+		goto error4;
+	} else if (err < 0) {
+		dev_err(dev, "Could not load cmt-speech driver (%d)\n", err);
+		goto error4;
+	}
 
 	dev_info(dev, "Registered Nokia HSI modem\n");
 
 	return 0;
 
+error4:
+	hsi_remove_client(&modem->cmt_speech->device, NULL);
 error3:
 	hsi_remove_client(&modem->ssi_protocol->device, NULL);
 error2:
@@ -238,6 +262,11 @@ static int nokia_modem_remove(struct device *dev)
 	if (!modem)
 		return 0;
 
+	if (modem->cmt_speech) {
+		hsi_remove_client(&modem->cmt_speech->device, NULL);
+		modem->cmt_speech = NULL;
+	}
+
 	if (modem->ssi_protocol) {
 		hsi_remove_client(&modem->ssi_protocol->device, NULL);
 		modem->ssi_protocol = NULL;
-- 
2.1.4
