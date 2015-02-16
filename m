From: Peter Rosin <peda@lysator.liu.se>
Subject: [PATCH 0/2] ASoC: pcm512x: Add knobs to allow and control overclocking
Date: Mon, 16 Feb 2015 22:02:46 +0100
Message-ID: <1424120568-24648-2-git-send-email-peda@lysator.liu.se>
References: <1424120568-24648-1-git-send-email-peda@lysator.liu.se>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1424120568-24648-1-git-send-email-peda@lysator.liu.se>
Sender: linux-kernel-owner@vger.kernel.org
To: alsa-devel@alsa-project.org
Cc: Peter Rosin <peda@axentia.se>, Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>, Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>, Lars-Peter Clausen <lars@metafoo.de>, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

From: Peter Rosin <peda@axentia.se>

Hi!

I wasn't sure if I should add Documentation/* for these sysfs knobs
or not? A lot of knobs do not have docs... And I'm not sure how I
should name the doc-file since the pcm512x driver handles devices
connected with both i2c and spi. So, this isn't perfect, suggestions
welcome.

The first patch is a preparatory patch that makes 2/2 slightly simpler.
I can fold them together if that's desired. Or I could split 2/2 up in
three logical pieces, one for each of the independent PLL/DSP/DAC
knob. Whatever...

Cheers,
Peter

Peter Rosin (2):
  ASoC: pcm512x: Rearrange to not repeat dacsrc_rate / dac_div
  ASoC: pcm512x: Allow independently overclocking PLL, DAC and DSP

 Documentation/ABI/testing/sysfs-i2c-pcm512x |   35 +++++
 sound/soc/codecs/pcm512x.c                  |  189 ++++++++++++++++++++++++---
 2 files changed, 205 insertions(+), 19 deletions(-)
 create mode 100644 Documentation/ABI/testing/sysfs-i2c-pcm512x

-- 
1.7.10.4
