From: Peter Rosin <peda-SamgB31n2u5IcsJQ0EH25Q@public.gmane.org>
Subject: [PATCH 2/2] ASoC: pcm512x: Allow independently overclocking PLL, DAC and DSP
Date: Mon, 16 Feb 2015 22:02:48 +0100
Message-ID: <1424120568-24648-4-git-send-email-peda@lysator.liu.se>
References: <1424120568-24648-1-git-send-email-peda@lysator.liu.se>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1424120568-24648-1-git-send-email-peda-SamgB31n2u5IcsJQ0EH25Q@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: alsa-devel-K7yf7f+aM1XWsZ/bQMPhNw@public.gmane.org
Cc: Peter Rosin <peda-koto5C5qi+TLoDKTGw+V6w@public.gmane.org>, Liam Girdwood <lgirdwood-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Mark Brown <broonie-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Jaroslav Kysela <perex-/Fr2/VpizcU@public.gmane.org>, Takashi Iwai <tiwai-l3A5Bk7waGM@public.gmane.org>, Lars-Peter Clausen <lars-Qo5EllUWu/uELgA04lAiVw@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

From: Peter Rosin <peda-koto5C5qi+TLoDKTGw+V6w@public.gmane.org>

When using non-standard rates, a relatively small amount of overclocking
can make a big difference to a number of cases.

- Not all rates are possible to achieve with the PLL, due to divider
  restrictions.

- The higher oversampling rates that can be used by the DAC, the
  simpler the analog output filters get (mirror frequencies move up,
  away from the desired spectrum).

- The more work the DSP can perform per sample, the better.

For standard rates, there is little to gain as everything is
designed just right, and the needed overclocking to make a
real difference would be significant.

Signed-off-by: Peter Rosin <peda-koto5C5qi+TLoDKTGw+V6w@public.gmane.org>
---
 Documentation/ABI/testing/sysfs-i2c-pcm512x |   35 ++++++
 sound/soc/codecs/pcm512x.c                  |  172 +++++++++++++++++++++++++--
 2 files changed, 196 insertions(+), 11 deletions(-)
 create mode 100644 Documentation/ABI/testing/sysfs-i2c-pcm512x

diff --git a/Documentation/ABI/testing/sysfs-i2c-pcm512x b/Documentation/ABI/testing/sysfs-i2c-pcm512x
new file mode 100644
index 000000000000..596cd97788db
--- /dev/null
+++ b/Documentation/ABI/testing/sysfs-i2c-pcm512x
@@ -0,0 +1,35 @@
+What:		/sys/bus/i2c/devices/<busnum>-<devaddr>/overclock_pll
+Date:		February 2015
+Contact:	Peter Rosin <peda-koto5C5qi+TLoDKTGw+V6w@public.gmane.org>
+Description:	When the codec acts as clock master, tell the pcm512x
+		to allow overclocking the PLL (as a percentage). Zero
+		disables PLL overclocking.
+
+		Reading: returns the current PLL overclocking setting.
+
+		Writing: set a new PLL overclocking setting.
+		Accepted values: 0..20.
+
+What:		/sys/bus/i2c/devices/<busnum>-<devaddr>/overclock_dac
+Date:		February 2015
+Contact:	Peter Rosin <peda-koto5C5qi+TLoDKTGw+V6w@public.gmane.org>
+Description:	When the codec acts as clock master, tell the pcm512x
+		to allow overclocking the DAC (as a percentage). Zero
+		disables DAC overclocking.
+
+		Reading: returns the current DAC overclocking setting.
+
+		Writing: set a new DAC overclocking setting.
+		Accepted values: 0..40.
+
+What:		/sys/bus/i2c/devices/<busnum>-<devaddr>/overclock_dsp
+Date:		February 2015
+Contact:	Peter Rosin <peda-koto5C5qi+TLoDKTGw+V6w@public.gmane.org>
+Description:	When the codec acts as clock master, tell the pcm512x
+		to allow overclocking the DSP (as a percentage). Zero
+		disables DSP overclocking.
+
+		Reading: returns the current DSP overclocking setting.
+
+		Writing: set a new DSP overclocking setting.
+		Accepted values: 0..40.
diff --git a/sound/soc/codecs/pcm512x.c b/sound/soc/codecs/pcm512x.c
index f13ff7578c78..f4d3dc390aed 100644
--- a/sound/soc/codecs/pcm512x.c
+++ b/sound/soc/codecs/pcm512x.c
@@ -54,6 +54,9 @@ struct pcm512x_priv {
 	int pll_d;
 	int pll_p;
 	unsigned long real_pll;
+	unsigned long overclock_pll;
+	unsigned long overclock_dac;
+	unsigned long overclock_dsp;
 };
 
 /*
@@ -346,6 +349,132 @@ static const struct snd_soc_dapm_route pcm512x_dapm_routes[] = {
 	{ "OUTR", NULL, "DACR" },
 };
 
+static ssize_t pcm512x_overclock_pll(struct device *dev,
+				     struct device_attribute *attr, char *buf)
+{
+	struct pcm512x_priv *pcm512x = dev_get_drvdata(dev);
+
+	return sprintf(buf, "%lu\n", pcm512x->overclock_pll);
+}
+
+static ssize_t pcm512x_overclock_pll_set(struct device *dev,
+					 struct device_attribute *attr,
+					 const char *buf, size_t count)
+{
+	struct pcm512x_priv *pcm512x = dev_get_drvdata(dev);
+	unsigned long value;
+	int ret;
+
+	ret = kstrtoul(buf, 10, &value);
+	if (ret)
+		return ret;
+	if (value > 20)
+		return -EINVAL;
+	pcm512x->overclock_pll = value;
+
+	return count;
+}
+
+static DEVICE_ATTR(overclock_pll, 0644,
+		   pcm512x_overclock_pll, pcm512x_overclock_pll_set);
+
+static ssize_t pcm512x_overclock_dsp(struct device *dev,
+				     struct device_attribute *attr, char *buf)
+{
+	struct pcm512x_priv *pcm512x = dev_get_drvdata(dev);
+
+	return sprintf(buf, "%lu\n", pcm512x->overclock_dsp);
+}
+
+static ssize_t pcm512x_overclock_dsp_set(struct device *dev,
+					 struct device_attribute *attr,
+					 const char *buf, size_t count)
+{
+	struct pcm512x_priv *pcm512x = dev_get_drvdata(dev);
+	unsigned long value;
+	int ret;
+
+	ret = kstrtoul(buf, 10, &value);
+	if (ret)
+		return ret;
+	if (value > 40)
+		return -EINVAL;
+	pcm512x->overclock_dsp = value;
+
+	return count;
+}
+
+static DEVICE_ATTR(overclock_dsp, 0644,
+		   pcm512x_overclock_dsp, pcm512x_overclock_dsp_set);
+
+static ssize_t pcm512x_overclock_dac(struct device *dev,
+				     struct device_attribute *attr, char *buf)
+{
+	struct pcm512x_priv *pcm512x = dev_get_drvdata(dev);
+
+	return sprintf(buf, "%lu\n", pcm512x->overclock_dac);
+}
+
+static ssize_t pcm512x_overclock_dac_set(struct device *dev,
+					 struct device_attribute *attr,
+					 const char *buf, size_t count)
+{
+	struct pcm512x_priv *pcm512x = dev_get_drvdata(dev);
+	unsigned long value;
+	int ret;
+
+	ret = kstrtoul(buf, 10, &value);
+	if (ret)
+		return ret;
+	if (value > 40)
+		return -EINVAL;
+	pcm512x->overclock_dac = value;
+
+	return count;
+}
+
+static DEVICE_ATTR(overclock_dac, 0644,
+		   pcm512x_overclock_dac, pcm512x_overclock_dac_set);
+
+static unsigned long pcm512x_pll_max(struct pcm512x_priv *pcm512x)
+{
+	return 25000000 + 25000000 * pcm512x->overclock_pll / 100;
+}
+
+static unsigned long pcm512x_dsp_max(struct pcm512x_priv *pcm512x)
+{
+	return 50000000 + 50000000 * pcm512x->overclock_dsp / 100;
+}
+
+static unsigned long pcm512x_dac_max(struct pcm512x_priv *pcm512x,
+				     unsigned long rate)
+{
+	return rate + rate * pcm512x->overclock_dac / 100;
+}
+
+static unsigned long pcm512x_sck_max(struct pcm512x_priv *pcm512x)
+{
+	if (!pcm512x->pll_out)
+		return 25000000;
+	return pcm512x_pll_max(pcm512x);
+}
+
+static unsigned long pcm512x_ncp_target(struct pcm512x_priv *pcm512x,
+					unsigned long dac_rate)
+{
+	/*
+	 * If the DAC is not actually overclocked, use the good old
+	 * NCP target rate...
+	 */
+	if (dac_rate <= 6144000)
+		return 1536000;
+	/*
+	 * ...but if the DAC is in fact overclocked, bump the NCP target
+	 * rate to get the recommended dividers even when overclocking.
+	 */
+	return pcm512x_dac_max(pcm512x, 1536000);
+}
+
 static const u32 pcm512x_dai_rates[] = {
 	8000, 11025, 16000, 22050, 32000, 44100, 48000, 64000,
 	88200, 96000, 176400, 192000, 384000,
@@ -359,6 +488,7 @@ static const struct snd_pcm_hw_constraint_list constraints_slave = {
 static int pcm512x_hw_rule_rate(struct snd_pcm_hw_params *params,
 				struct snd_pcm_hw_rule *rule)
 {
+	struct pcm512x_priv *pcm512x = rule->private;
 	struct snd_interval ranges[2];
 	int frame_size;
 
@@ -377,7 +507,7 @@ static int pcm512x_hw_rule_rate(struct snd_pcm_hw_params *params,
 		 */
 		memset(ranges, 0, sizeof(ranges));
 		ranges[0].min = 8000;
-		ranges[0].max = 25000000 / frame_size / 2;
+		ranges[0].max = pcm512x_sck_max(pcm512x) / frame_size / 2;
 		ranges[1].min = DIV_ROUND_UP(16000000, frame_size);
 		ranges[1].max = 384000;
 		break;
@@ -408,7 +538,7 @@ static int pcm512x_dai_startup_master(struct snd_pcm_substream *substream,
 		return snd_pcm_hw_rule_add(substream->runtime, 0,
 					   SNDRV_PCM_HW_PARAM_RATE,
 					   pcm512x_hw_rule_rate,
-					   NULL,
+					   pcm512x,
 					   SNDRV_PCM_HW_PARAM_FRAME_BITS,
 					   SNDRV_PCM_HW_PARAM_CHANNELS, -1);
 
@@ -517,6 +647,8 @@ static unsigned long pcm512x_find_sck(struct snd_soc_dai *dai,
 				      unsigned long bclk_rate)
 {
 	struct device *dev = dai->dev;
+	struct snd_soc_codec *codec = dai->codec;
+	struct pcm512x_priv *pcm512x = snd_soc_codec_get_drvdata(codec);
 	unsigned long sck_rate;
 	int pow2;
 
@@ -527,9 +659,10 @@ static unsigned long pcm512x_find_sck(struct snd_soc_dai *dai,
 	 * as many factors of 2 as possible, as that makes it easier
 	 * to find a fast DAC rate
 	 */
-	pow2 = 1 << fls((25000000 - 16000000) / bclk_rate);
+	pow2 = 1 << fls((pcm512x_pll_max(pcm512x) - 16000000) / bclk_rate);
 	for (; pow2; pow2 >>= 1) {
-		sck_rate = rounddown(25000000, bclk_rate * pow2);
+		sck_rate = rounddown(pcm512x_pll_max(pcm512x),
+				     bclk_rate * pow2);
 		if (sck_rate >= 16000000)
 			break;
 	}
@@ -678,7 +811,7 @@ static unsigned long pcm512x_pllin_dac_rate(struct snd_soc_dai *dai,
 		return 0; /* futile, quit early */
 
 	/* run DAC no faster than 6144000 Hz */
-	for (dac_rate = rounddown(6144000, osr_rate);
+	for (dac_rate = rounddown(pcm512x_dac_max(pcm512x, 6144000), osr_rate);
 	     dac_rate;
 	     dac_rate -= osr_rate) {
 
@@ -805,7 +938,7 @@ static int pcm512x_set_dividers(struct snd_soc_dai *dai,
 	osr_rate = 16 * sample_rate;
 
 	/* run DSP no faster than 50 MHz */
-	dsp_div = mck_rate > 50000000 ? 2 : 1;
+	dsp_div = mck_rate > pcm512x_dsp_max(pcm512x) ? 2 : 1;
 
 	dac_rate = pcm512x_pllin_dac_rate(dai, osr_rate, pllin_rate);
 	if (dac_rate) {
@@ -836,7 +969,8 @@ static int pcm512x_set_dividers(struct snd_soc_dai *dai,
 		dacsrc_rate = pllin_rate;
 	} else {
 		/* run DAC no faster than 6144000 Hz */
-		unsigned long dac_mul = 6144000 / osr_rate;
+		unsigned long dac_mul = pcm512x_dac_max(pcm512x, 6144000)
+			/ osr_rate;
 		unsigned long sck_mul = sck_rate / osr_rate;
 
 		for (; dac_mul; dac_mul--) {
@@ -876,7 +1010,8 @@ static int pcm512x_set_dividers(struct snd_soc_dai *dai,
 	}
 	dac_rate = dacsrc_rate / dac_div;
 
-	ncp_div = DIV_ROUND_CLOSEST(dac_rate, 1536000);
+	ncp_div = DIV_ROUND_CLOSEST(dac_rate,
+				    pcm512x_ncp_target(pcm512x, dac_rate));
 	if (ncp_div > 128 || dac_rate / ncp_div > 2048000) {
 		/* run NCP no faster than 2048000 Hz, but why? */
 		ncp_div = DIV_ROUND_UP(dac_rate, 2048000);
@@ -938,11 +1073,11 @@ static int pcm512x_set_dividers(struct snd_soc_dai *dai,
 		return ret;
 	}
 
-	if (sample_rate <= 48000)
+	if (sample_rate <= pcm512x_dac_max(pcm512x, 48000))
 		fssp = PCM512x_FSSP_48KHZ;
-	else if (sample_rate <= 96000)
+	else if (sample_rate <= pcm512x_dac_max(pcm512x, 96000))
 		fssp = PCM512x_FSSP_96KHZ;
-	else if (sample_rate <= 192000)
+	else if (sample_rate <= pcm512x_dac_max(pcm512x, 192000))
 		fssp = PCM512x_FSSP_192KHZ;
 	else
 		fssp = PCM512x_FSSP_384KHZ;
@@ -1389,6 +1524,18 @@ int pcm512x_probe(struct device *dev, struct regmap *regmap)
 		goto err_pm;
 	}
 
+	ret = device_create_file(dev, &dev_attr_overclock_pll);
+	if (ret < 0)
+		dev_warn(dev, "Failed to add overclock_pll sysfs: %d\n", ret);
+
+	ret = device_create_file(dev, &dev_attr_overclock_dsp);
+	if (ret < 0)
+		dev_warn(dev, "Failed to add overclock_dsp sysfs: %d\n", ret);
+
+	ret = device_create_file(dev, &dev_attr_overclock_dac);
+	if (ret < 0)
+		dev_warn(dev, "Failed to add overclock_dac sysfs: %d\n", ret);
+
 	return 0;
 
 err_pm:
@@ -1407,6 +1554,9 @@ void pcm512x_remove(struct device *dev)
 {
 	struct pcm512x_priv *pcm512x = dev_get_drvdata(dev);
 
+	device_remove_file(dev, &dev_attr_overclock_pll);
+	device_remove_file(dev, &dev_attr_overclock_dsp);
+	device_remove_file(dev, &dev_attr_overclock_dac);
 	snd_soc_unregister_codec(dev);
 	pm_runtime_disable(dev);
 	if (!IS_ERR(pcm512x->sclk))
-- 
1.7.10.4
