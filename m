From: Peter Rosin <peda-SamgB31n2u5IcsJQ0EH25Q@public.gmane.org>
Subject: [PATCH 0/2] ASoC: pcm512x: Add knobs to allow and control overclocking
Date: Mon, 16 Feb 2015 22:02:45 +0100
Message-ID: <1424120568-24648-1-git-send-email-peda@lysator.liu.se>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: alsa-devel-K7yf7f+aM1XWsZ/bQMPhNw@public.gmane.org
Cc: Peter Rosin <peda-koto5C5qi+TLoDKTGw+V6w@public.gmane.org>, Liam Girdwood <lgirdwood-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Mark Brown <broonie-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Jaroslav Kysela <perex-/Fr2/VpizcU@public.gmane.org>, Takashi Iwai <tiwai-l3A5Bk7waGM@public.gmane.org>, Lars-Peter Clausen <lars-Qo5EllUWu/uELgA04lAiVw@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

From: Peter Rosin <peda-koto5C5qi+TLoDKTGw+V6w@public.gmane.org>

Hi!

I wasn't sure if I should add Documentation/* for these sysfs knobs
or not? A lot of knobs do not seem to have docs (no specific example,
just a gut feeling). And I'm not sure how I should name the doc-file
since the pcm512x driver handles devices connected with both i2c and
spi. And what KernelVersion should I enter? That depends... So, this
isn't perfect, suggestions welcome.

The first patch is a preparatory patch that makes 2/2 slightly simpler.
I can fold them together if that's desired. Or I could split 2/2 up in
three logical patches, one for each of the independent PLL/DSP/DAC
knobs.

Another "feature" that one might want, is that attempts to change the
overclocking should fail with EBUSY when the device is already in use.
But I haven't invested enough time to find out how I should determine
when to fail, so for this version the driver accepts the change but
doesn't enforce the new limit until the clock rates are recalculated.

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
