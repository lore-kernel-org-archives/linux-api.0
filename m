From: Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
Subject: Re: [PATCH 26/31] sound/usb: Update ALSA driver to use Managed Media
 Controller API
Date: Thu, 7 Jan 2016 13:27:52 -0700
Message-ID: <568ECA48.1060908@osg.samsung.com>
References: <cover.1452105878.git.shuahkh@osg.samsung.com>
 <ebef788534aae7fa740665660e04bdf1523fdbfe.1452105878.git.shuahkh@osg.samsung.com>
 <s5ha8ohfl7f.wl-tiwai@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <s5ha8ohfl7f.wl-tiwai-l3A5Bk7waGM@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Takashi Iwai <tiwai-l3A5Bk7waGM@public.gmane.org>
Cc: hans.verkuil-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org, laurent.pinchart-ryLnwIuWjnjg/C1BVhZhaw@public.gmane.org, clemens-P6GI/4k7KOmELgA04lAiVw@public.gmane.org, sakari.ailus-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, javier-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org, mchehab-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org, alsa-devel-K7yf7f+aM1XWsZ/bQMPhNw@public.gmane.org, arnd-r2nGTMty4D4@public.gmane.org, ricard.wanderlof-VrBV9hrLPhE@public.gmane.org, labbott-rxtnV0ftBwyoClj4AeEUq9i2O/JbrIOy@public.gmane.org, chehabrafael-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, misterpib-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, prabhakar.csengg-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, ricardo.ribalda-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, ruchandani.tina-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, takamichiho-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, tvboxspy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, dominic.sacre-Mmb7MZpHnFY@public.gmane.org, crope-X3B1VOXEql0@public.gmane.org, julian-SZMMDGyaqes@public.gmane.org, pierre-louis.bossart-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, corbet-T1hC0tSOHrs@public.gmane.org, joe-amhYAVlgbXj10XsdtD+oqA@public.gmane.org, johan-v8HUHnYb0Yo@public.gmane.org, dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, pawel-FA/gS7QP4orQT0dZR+AlfA@public.gmane.org, p.zabel-bIcnvbaLZ9MEGnE8C9+IrQ@public.gmane.org, perex-/Fr2/VpizcU@public.gmane.org, stefanr-MtYdepGKPcBMYopoZt5u/LNAH6kLmebB@public.gmane.org, inki.dae-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org, jh1009.sung-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org, k.kozlowski-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org, kyungmin.park-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org, m.szyprowski-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org, sw0312.kim-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org, elfring-Rn4VEauK+AKRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, linux-api-u79uwXL29TbrhsbdSgBK9A@public.gmane.org
List-Id: linux-api@vger.kernel.org

On 01/07/2016 08:44 AM, Takashi Iwai wrote:
> On Wed, 06 Jan 2016 22:05:35 +0100,
> Shuah Khan wrote:
>>
>> diff --git a/sound/usb/Makefile b/sound/usb/Makefile
>> index 2d2d122..665fdd9 100644
>> --- a/sound/usb/Makefile
>> +++ b/sound/usb/Makefile
>> @@ -2,6 +2,18 @@
>>  # Makefile for ALSA
>>  #
>>  
>> +# Media Controller
>> +ifeq ($(CONFIG_MEDIA_CONTROLLER),y)
>> +  ifeq ($(CONFIG_MEDIA_SUPPORT),y)
>> +        KBUILD_CFLAGS += -DUSE_MEDIA_CONTROLLER
>> +  endif
>> +  ifeq ($(CONFIG_MEDIA_SUPPORT_MODULE),y)
>> +    ifeq ($(MODULE),y)
>> +          KBUILD_CFLAGS += -DUSE_MEDIA_CONTROLLER
>> +    endif
>> +  endif
>> +endif
> 
> Can't we define this rather via Kconfig?
> Doing this in Makefile is way too tricky, and it's unclear to users
> whether MC is actually enabled or not.
> 

Yeah doing this in Makefile is a bit tricky
and can lead to confusion.

I can't think of any specific reason why I added
this check to the Makefile instead of Kconfig.
Looks like I added this in my second version
of the patch series several months ago and didn't
revisit. I will add this to Kconfig.
> 
>> diff --git a/sound/usb/media.c b/sound/usb/media.c
>> new file mode 100644
>> index 0000000..747a66a
>> --- /dev/null
>> +++ b/sound/usb/media.c
>> @@ -0,0 +1,214 @@
>> +/*
>> + * media.c - Media Controller specific ALSA driver code
>> + *
>> + * Copyright (c) 2015 Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
>> + * Copyright (c) 2015 Samsung Electronics Co., Ltd.
>> + *
>> + * This file is released under the GPLv2.
>> + */
>> +
>> +/*
>> + * This file adds Media Controller support to ALSA driver
>> + * to use the Media Controller API to share tuner with DVB
>> + * and V4L2 drivers that control media device. Media device
>> + * is created based on existing quirks framework. Using this
>> + * approach, the media controller API usage can be added for
>> + * a specific device.
>> +*/
>> +
>> +#include <linux/init.h>
>> +#include <linux/list.h>
>> +#include <linux/slab.h>
>> +#include <linux/string.h>
>> +#include <linux/ctype.h>
>> +#include <linux/usb.h>
>> +#include <linux/moduleparam.h>
>> +#include <linux/mutex.h>
>> +#include <linux/usb/audio.h>
>> +#include <linux/usb/audio-v2.h>
>> +#include <linux/module.h>
>> +
>> +#include <sound/control.h>
>> +#include <sound/core.h>
>> +#include <sound/info.h>
>> +#include <sound/pcm.h>
>> +#include <sound/pcm_params.h>
>> +#include <sound/initval.h>
>> +
>> +#include "usbaudio.h"
>> +#include "card.h"
>> +#include "midi.h"
>> +#include "mixer.h"
>> +#include "proc.h"
>> +#include "quirks.h"
>> +#include "endpoint.h"
>> +#include "helper.h"
>> +#include "debug.h"
>> +#include "pcm.h"
>> +#include "format.h"
>> +#include "power.h"
>> +#include "stream.h"
>> +#include "media.h"
> 
> I believe we can get rid of many include files just for MC support...
> 
> 
>> +#ifdef USE_MEDIA_CONTROLLER
> 
> This ifdef can be removed once if we build this object file
> conditionally in Makefile.

Right.

> 
> 
>> @@ -1232,7 +1244,10 @@ static int snd_usb_pcm_open(struct snd_pcm_substream *substream, int direction)
>>  	subs->dsd_dop.channel = 0;
>>  	subs->dsd_dop.marker = 1;
>>  
>> -	return setup_hw_info(runtime, subs);
>> +	ret = setup_hw_info(runtime, subs);
>> +	if (ret == 0)
>> +		ret = media_stream_init(subs, as->pcm, direction);
> 
> Need to call snd_usb_autosuspend() in the error path.

I will add it.

> 
> 
>> --- a/sound/usb/quirks.c
>> +++ b/sound/usb/quirks.c
>> @@ -544,13 +545,19 @@ int snd_usb_create_quirk(struct snd_usb_audio *chip,
>>  		[QUIRK_AUDIO_ALIGN_TRANSFER] = create_align_transfer_quirk,
>>  		[QUIRK_AUDIO_STANDARD_MIXER] = create_standard_mixer_quirk,
>>  	};
>> +	int ret;
>>  
>> +	if (quirk->media_device) {
>> +		/* don't want to fail when media_device_create() fails */
>> +		media_device_create(chip, iface);
>> +	}
> 
> So far, so good...
> 
>>  	if (quirk->type < QUIRK_TYPE_COUNT) {
>> -		return quirk_funcs[quirk->type](chip, iface, driver, quirk);
>> +		ret = quirk_funcs[quirk->type](chip, iface, driver, quirk);
>>  	} else {
>>  		usb_audio_err(chip, "invalid quirk type %d\n", quirk->type);
>>  		return -ENXIO;
>>  	}
>> +	return ret;
> 
> Any reason to change this?

Thanks for catching this. I think I might have
added some debug code to print ret value and
missed it when I cleaned up the debug code.
I will fix it.

thanks,
-- Shuah

-- 
Shuah Khan
Sr. Linux Kernel Developer
Open Source Innovation Group
Samsung Research America (Silicon Valley)
shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org | (970) 217-8978
