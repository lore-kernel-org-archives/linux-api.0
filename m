From: Peter Rosin <peda@lysator.liu.se>
Subject: [PATCH 1/2] ASoC: pcm512x: Rearrange to not repeat dacsrc_rate / dac_div
Date: Mon, 16 Feb 2015 22:02:47 +0100
Message-ID: <1424120568-24648-3-git-send-email-peda@lysator.liu.se>
References: <1424120568-24648-1-git-send-email-peda@lysator.liu.se>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1424120568-24648-1-git-send-email-peda@lysator.liu.se>
Sender: linux-kernel-owner@vger.kernel.org
To: alsa-devel@alsa-project.org
Cc: Peter Rosin <peda@axentia.se>, Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>, Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>, Lars-Peter Clausen <lars@metafoo.de>, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

From: Peter Rosin <peda@axentia.se>

Signed-off-by: Peter Rosin <peda@axentia.se>
---
 sound/soc/codecs/pcm512x.c |   19 ++++++++++---------
 1 file changed, 10 insertions(+), 9 deletions(-)

diff --git a/sound/soc/codecs/pcm512x.c b/sound/soc/codecs/pcm512x.c
index 884784fb1566..f13ff7578c78 100644
--- a/sound/soc/codecs/pcm512x.c
+++ b/sound/soc/codecs/pcm512x.c
@@ -863,28 +863,29 @@ static int pcm512x_set_dividers(struct snd_soc_dai *dai,
 		dacsrc_rate = sck_rate;
 	}
 
+	osr_div = DIV_ROUND_CLOSEST(dac_rate, osr_rate);
+	if (osr_div > 128) {
+		dev_err(dev, "Failed to find OSR divider\n");
+		return -EINVAL;
+	}
+
 	dac_div = DIV_ROUND_CLOSEST(dacsrc_rate, dac_rate);
 	if (dac_div > 128) {
 		dev_err(dev, "Failed to find DAC divider\n");
 		return -EINVAL;
 	}
+	dac_rate = dacsrc_rate / dac_div;
 
-	ncp_div = DIV_ROUND_CLOSEST(dacsrc_rate / dac_div, 1536000);
-	if (ncp_div > 128 || dacsrc_rate / dac_div / ncp_div > 2048000) {
+	ncp_div = DIV_ROUND_CLOSEST(dac_rate, 1536000);
+	if (ncp_div > 128 || dac_rate / ncp_div > 2048000) {
 		/* run NCP no faster than 2048000 Hz, but why? */
-		ncp_div = DIV_ROUND_UP(dacsrc_rate / dac_div, 2048000);
+		ncp_div = DIV_ROUND_UP(dac_rate, 2048000);
 		if (ncp_div > 128) {
 			dev_err(dev, "Failed to find NCP divider\n");
 			return -EINVAL;
 		}
 	}
 
-	osr_div = DIV_ROUND_CLOSEST(dac_rate, osr_rate);
-	if (osr_div > 128) {
-		dev_err(dev, "Failed to find OSR divider\n");
-		return -EINVAL;
-	}
-
 	idac = mck_rate / (dsp_div * sample_rate);
 
 	ret = regmap_write(pcm512x->regmap, PCM512x_DSP_CLKDIV, dsp_div - 1);
-- 
1.7.10.4
