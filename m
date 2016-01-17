From: Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
Subject: Re: [PATCH v2 26/31] sound/usb: Update ALSA driver to use Managed
 Media Controller API
Date: Sun, 17 Jan 2016 14:22:28 -0700
Message-ID: <569C0614.2000004@osg.samsung.com>
References: <cover.1452800265.git.shuahkh@osg.samsung.com>
 <fd72f02797d595fc1c53b16fccec4d204430995e.1452800273.git.shuahkh@osg.samsung.com>
 <s5hmvs7t133.wl-tiwai@suse.de> <56999103.6000005@osg.samsung.com>
 <s5h1t9huc45.wl-tiwai@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <s5h1t9huc45.wl-tiwai-l3A5Bk7waGM@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Takashi Iwai <tiwai-l3A5Bk7waGM@public.gmane.org>
Cc: hans.verkuil-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org, laurent.pinchart-ryLnwIuWjnjg/C1BVhZhaw@public.gmane.org, clemens-P6GI/4k7KOmELgA04lAiVw@public.gmane.org, sakari.ailus-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, javier-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org, mchehab-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org, alsa-devel-K7yf7f+aM1XWsZ/bQMPhNw@public.gmane.org, arnd-r2nGTMty4D4@public.gmane.org, ricard.wanderlof-VrBV9hrLPhE@public.gmane.org, labbott-rxtnV0ftBwyoClj4AeEUq9i2O/JbrIOy@public.gmane.org, chehabrafael-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, misterpib-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, prabhakar.csengg-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, ricardo.ribalda-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, ruchandani.tina-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, takamichiho-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, tvboxspy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, dominic.sacre-Mmb7MZpHnFY@public.gmane.org, crope-X3B1VOXEql0@public.gmane.org, julian-SZMMDGyaqes@public.gmane.org, pierre-louis.bossart-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, corbet-T1hC0tSOHrs@public.gmane.org, joe-amhYAVlgbXj10XsdtD+oqA@public.gmane.org, johan-v8HUHnYb0Yo@public.gmane.org, dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, pawel-FA/gS7QP4orQT0dZR+AlfA@public.gmane.org, p.zabel-bIcnvbaLZ9MEGnE8C9+IrQ@public.gmane.org, perex-/Fr2/VpizcU@public.gmane.org, stefanr-MtYdepGKPcBMYopoZt5u/LNAH6kLmebB@public.gmane.org, inki.dae-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org, jh1009.sung-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org, k.kozlowski-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org, kyungmin.park-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org, m.szyprowski-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org, sw0312.kim-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org, elfring-Rn4VEauK+AKRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, linux-api-u79uwXL29TbrhsbdSgBK9A@public.gmane.org
List-Id: linux-api@vger.kernel.org

On 01/16/2016 02:06 AM, Takashi Iwai wrote:
> On Sat, 16 Jan 2016 01:38:27 +0100,
> Shuah Khan wrote:
>>
>> On 01/15/2016 06:38 AM, Takashi Iwai wrote:
>>> On Thu, 14 Jan 2016 20:52:28 +0100,
>>> Shuah Khan wrote:
>>>>
>>>> Change ALSA driver to use Managed Media Managed Controller
>>>> API to share tuner with DVB and V4L2 drivers that control
>>>> AU0828 media device.  Media device is created based on a
>>>> newly added field value in the struct snd_usb_audio_quirk.
>>>> Using this approach, the media controller API usage can be
>>>> added for a specific device. In this patch, Media Controller
>>>> API is enabled for AU0828 hw. snd_usb_create_quirk() will
>>>> check this new field, if set will create a media device using
>>>> media_device_get_devres() interface.
>>>>
>>>> media_device_get_devres() will allocate a new media device
>>>> devres or return an existing one, if it finds one.
>>>>
>>>> During probe, media usb driver could have created the media
>>>> device devres. It will then initialze (if necessary) and
>>>> register the media device if it isn't already initialized
>>>> and registered. Media device unregister is done from
>>>> usb_audio_disconnect().
>>>>
>>>> During probe, media usb driver could have created the
>>>> media device devres. It will then register the media
>>>> device if it isn't already registered. Media device
>>>> unregister is done from usb_audio_disconnect().
>>>>
>>>> New structure media_ctl is added to group the new
>>>> fields to support media entity and links. This new
>>>> structure is added to struct snd_usb_substream.
>>>>
>>>> A new entity_notify hook and a new ALSA capture media
>>>> entity are registered from snd_usb_pcm_open() after
>>>> setting up hardware information for the PCM device.
>>>>
>>>> When a new entity is registered, Media Controller API
>>>> interface media_device_register_entity() invokes all
>>>> registered entity_notify hooks for the media device.
>>>> ALSA entity_notify hook parses all the entity list to
>>>> find a link from decoder it ALSA entity. This indicates
>>>> that the bridge driver created a link from decoder to
>>>> ALSA capture entity.
>>>>
>>>> ALSA will attempt to enable the tuner to link the tuner
>>>> to the decoder calling enable_source handler if one is
>>>> provided by the bridge driver prior to starting Media
>>>> pipeline from snd_usb_hw_params(). If enable_source returns
>>>> with tuner busy condition, then snd_usb_hw_params() will fail
>>>> with -EBUSY. Media pipeline is stopped from snd_usb_hw_free().
>>>>
>>>> Signed-off-by: Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
>>>> ---
>>>> Changes since v1: Addressed Takasi Iwai's comments on v1
>>>> - Move config defines to Kconfig and add logic
>>>>   to Makefile to conditionally compile media.c
>>>> - Removed extra includes from media.c
>>>> - Added snd_usb_autosuspend() in error leg
>>>> - Removed debug related code that was missed in v1
>>>>
>>>>  sound/usb/Kconfig        |   7 ++
>>>>  sound/usb/Makefile       |   4 +
>>>>  sound/usb/card.c         |   7 ++
>>>>  sound/usb/card.h         |   1 +
>>>>  sound/usb/media.c        | 190 +++++++++++++++++++++++++++++++++++++++++++++++
>>>>  sound/usb/media.h        |  56 ++++++++++++++
>>>>  sound/usb/pcm.c          |  28 +++++--
>>>>  sound/usb/quirks-table.h |   1 +
>>>>  sound/usb/quirks.c       |   5 ++
>>>>  sound/usb/stream.c       |   2 +
>>>>  sound/usb/usbaudio.h     |   1 +
>>>>  11 files changed, 297 insertions(+), 5 deletions(-)
>>>>  create mode 100644 sound/usb/media.c
>>>>  create mode 100644 sound/usb/media.h
>>>>
>>>> diff --git a/sound/usb/Kconfig b/sound/usb/Kconfig
>>>> index a452ad7..8d5cdab 100644
>>>> --- a/sound/usb/Kconfig
>>>> +++ b/sound/usb/Kconfig
>>>> @@ -15,6 +15,7 @@ config SND_USB_AUDIO
>>>>  	select SND_RAWMIDI
>>>>  	select SND_PCM
>>>>  	select BITREVERSE
>>>> +	select SND_USB_AUDIO_USE_MEDIA_CONTROLLER if MEDIA_CONTROLLER && (MEDIA_SUPPORT || MEDIA_SUPPORT_MODULE)
>>>
>>> This looks wrong as a Kconfig syntax.  "... if MEDIA_CONTROLLER"
>>> should work, I suppose?
>>
>> The conditional select syntax is used in several Kconfig
>> files. You are right about (MEDIA_SUPPORT || MEDIA_SUPPORT_MODULE)
>> Adding checks for that is unnecessary.
> 
> Well, my point was that check should be like:
>    select SND_USB_AUDIO_XXX if MEDIA_CONTROLLER && MEDIA_SUPPORT

Thank you for your patience in helping me through this.

I looked into this more and there is no need to check
for MEDIA_SUPPORT. MEDIA_CONTROLLER defined in

if MEDIA_SUPPORT
endif # MEDIA_SUPPORT

block, checking for MEDIA_SUPPORT is unnecessary.

> 
> There is a revere-select, so this menu itself doesn't play any role.
> 
> If you want this item selectable, drop select from SND_USB_AUDIO but
> just have proper dependencies for this item:

Yes Agreed.

> 
> config SND_USB_AUDIO_USE_MEDIA_CONTROLLER
> 	bool "USB Audio/MIDI driver with Media Controller Support"
> 	depends on SND_USB_AUDIO
> 	depends on MEDIA_CONTROLLER
> 	default y
> 
> (Whether default y or not is a remaining question: usually we keep it 
>  empty (i.e. no), but I put it here since you had it.)
> 
> If you want this auto-selected unconditionally, drop the prompt and
> superfluous dependency (and don't set default y):

Yes I want this auto-selected unconditionally so it won't be
disabled by mistake which would lead to errors because ALSA
will be out of sync with DVB and Analog in the way they try
to get access to media resources.

Yes the below will work.

> 
> config SND_USB_AUDIO
> 	....
> 	select SND_USB_AUDIO_USE_MEDIA_CONTROLLER if MEDIA_CONTROLLER
> 	....
> 
> config SND_USB_AUDIO_USE_MEDIA_CONTROLLER
> 	bool
> 

thanks,
-- Shuah

-- 
Shuah Khan
Sr. Linux Kernel Developer
Open Source Innovation Group
Samsung Research America (Silicon Valley)
shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org | (970) 217-8978
