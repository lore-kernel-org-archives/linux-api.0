From: Peter Rosin <peda@axentia.se>
Subject: RE: [PATCH 2/2] ASoC: pcm512x: Allow independently overclocking
 PLL, DAC and DSP
Date: Sun, 22 Feb 2015 00:24:12 +0000
Message-ID: <88616b158f38499fa5a466f31d25aa80@EMAIL.axentia.se>
References: <1424120568-24648-1-git-send-email-peda@lysator.liu.se>
 <1424120568-24648-4-git-send-email-peda@lysator.liu.se>
 <20150221093328.GF6236@finisterre.sirena.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20150221093328.GF6236@finisterre.sirena.org.uk>
Content-Language: sv-SE
Sender: linux-kernel-owner@vger.kernel.org
To: Mark Brown <broonie@kernel.org>, Peter Rosin <peda@lysator.liu.se>
Cc: "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>, Liam Girdwood <lgirdwood@gmail.com>, Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>, Lars-Peter Clausen <lars@metafoo.de>, "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

Mark Brown wrote:
> On Mon, Feb 16, 2015 at 10:02:48PM +0100, Peter Rosin wrote:
> > From: Peter Rosin <peda@axentia.se>
> >
> > When using non-standard rates, a relatively small amount of
> > overclocking can make a big difference to a number of cases.
> 
> This is all basically fine but I'm wondering why this is being configured via
> sysfs and not via ALSA controls?  It's going to be more fiddly for people to
> have to work with both control methods when they need to configure these
> things.

Originally, I had the limits in .config. Then Lars-Peter suggested
sysfs (on irc) and perhaps some way to disable overclocking. ALSA
controls were never on the table, but now that you mention it, it sounds
about right. So, I'm fine with having it as ALSA-controls...

*time passes*

...but I'm not sure everybody agrees that overclocking games should
be allowed by any and all users?

If you still want me to convert to ALSA controls, what control do you
suggest? SOC_SINGLE_EXT? Or should I use an enumeration, because
mixers tend to present volume controls as a percentage of max, which
will be confusing: You are now at "volume" 75% (of max 40), when the
value is 30. Eeek. But enumerations from 0% to 40% sounds tedious.

And how would you suggest that I name the controls?
"Max Overclock DAC", "Max Overclock DSP" and "Max Overclock PLL"?

BTW, the only troubles I've had with overclocking "too much" is that it
has stopped working. I have not managed to fry any chip. But that is no
guarantee, of course.

Cheers,
Peter
