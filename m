From: Shuah Khan <shuahkh@osg.samsung.com>
Subject: Re: [PATCH REBASE 4.5 26/31] sound/usb: Update ALSA driver to use
 Managed Media Controller API
Date: Mon, 1 Feb 2016 11:00:47 -0700
Message-ID: <56AF9D4F.1030600@osg.samsung.com>
References: <cover.1453336830.git.shuahkh@osg.samsung.com>
 <7a0e6537942ee577c941b75b933aa478ff5d3106.1453336831.git.shuahkh@osg.samsung.com>
 <s5hoac0l7ae.wl-tiwai@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <s5hoac0l7ae.wl-tiwai@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Takashi Iwai <tiwai@suse.de>
Cc: hans.verkuil@cisco.com, laurent.pinchart@ideasonboard.com, clemens@ladisch.de, sakari.ailus@linux.intel.com, javier@osg.samsung.com, mchehab@osg.samsung.com, alsa-devel@alsa-project.org, arnd@arndb.de, ricard.wanderlof@axis.com, labbott@fedoraproject.org, chehabrafael@gmail.com, misterpib@gmail.com, prabhakar.csengg@gmail.com, ricardo.ribalda@gmail.com, ruchandani.tina@gmail.com, takamichiho@gmail.com, tvboxspy@gmail.com, dominic.sacre@gmx.de, crope@iki.fi, julian@jusst.de, pierre-louis.bossart@linux.intel.com, corbet@lwn.net, joe@oampo.co.uk, johan@oljud.se, dan.carpenter@oracle.com, pawel@osciak.com, p.zabel@pengutronix.de, perex@perex.cz, stefanr@s5r6.in-berlin.de, inki.dae@samsung.com, jh1009.sung@samsung.com, k.kozlowski@samsung.com, kyungmin.park@samsung.com, m.szyprowski@samsung.com, sw0312.kim@samsung.com, elfring@users.sourceforge.net, linux-api@vger.kernel.o
List-Id: linux-api@vger.kernel.org

On 02/01/2016 09:33 AM, Takashi Iwai wrote:
> On Thu, 21 Jan 2016 19:09:50 +0100,
> Shuah Khan wrote:
>>
>> Change ALSA driver to use Managed Media Managed Controller
>> API to share tuner with DVB and V4L2 drivers that control
>> AU0828 media device.  Media device is created based on a
>> newly added field value in the struct snd_usb_audio_quirk.
>> Using this approach, the media controller API usage can be
>> added for a specific device. In this patch, Media Controller
>> API is enabled for AU0828 hw. snd_usb_create_quirk() will
>> check this new field, if set will create a media device using
>> media_device_get_devres() interface.
>>
>> media_device_get_devres() will allocate a new media device
>> devres or return an existing one, if it finds one.
>>
>> During probe, media usb driver could have created the media
>> device devres. It will then initialze (if necessary) and
>> register the media device if it isn't already initialized
>> and registered. Media device unregister is done from
>> usb_audio_disconnect().
>>
>> During probe, media usb driver could have created the
>> media device devres. It will then register the media
>> device if it isn't already registered. Media device
>> unregister is done from usb_audio_disconnect().
>>
>> New structure media_ctl is added to group the new
>> fields to support media entity and links. This new
>> structure is added to struct snd_usb_substream.
>>
>> A new entity_notify hook and a new ALSA capture media
>> entity are registered from snd_usb_pcm_open() after
>> setting up hardware information for the PCM device.
>>
>> When a new entity is registered, Media Controller API
>> interface media_device_register_entity() invokes all
>> registered entity_notify hooks for the media device.
>> ALSA entity_notify hook parses all the entity list to
>> find a link from decoder it ALSA entity. This indicates
>> that the bridge driver created a link from decoder to
>> ALSA capture entity.
>>
>> ALSA will attempt to enable the tuner to link the tuner
>> to the decoder calling enable_source handler if one is
>> provided by the bridge driver prior to starting Media
>> pipeline from snd_usb_hw_params(). If enable_source returns
>> with tuner busy condition, then snd_usb_hw_params() will fail
>> with -EBUSY. Media pipeline is stopped from snd_usb_hw_free().
>>
>> Signed-off-by: Shuah Khan <shuahkh@osg.samsung.com>
>> ---
>>  sound/usb/Kconfig        |   4 ++
>>  sound/usb/Makefile       |   2 +
>>  sound/usb/card.c         |   7 ++
>>  sound/usb/card.h         |   1 +
>>  sound/usb/media.c        | 184 +++++++++++++++++++++++++++++++++++++++++++++++
>>  sound/usb/media.h        |  55 ++++++++++++++
>>  sound/usb/pcm.c          |  28 ++++++--
>>  sound/usb/quirks-table.h |   1 +
>>  sound/usb/quirks.c       |   5 ++
>>  sound/usb/stream.c       |   2 +
>>  sound/usb/usbaudio.h     |   1 +
>>  11 files changed, 285 insertions(+), 5 deletions(-)
>>  create mode 100644 sound/usb/media.c
>>  create mode 100644 sound/usb/media.h
>>
>> diff --git a/sound/usb/Kconfig b/sound/usb/Kconfig
>> index a452ad7..1a71d93 100644
>> --- a/sound/usb/Kconfig
>> +++ b/sound/usb/Kconfig
>> @@ -15,6 +15,7 @@ config SND_USB_AUDIO
>>  	select SND_RAWMIDI
>>  	select SND_PCM
>>  	select BITREVERSE
>> +	select SND_USB_AUDIO_USE_MEDIA_CONTROLLER	if MEDIA_CONTROLLER
>>  	help
>>  	  Say Y here to include support for USB audio and USB MIDI
>>  	  devices.
>> @@ -22,6 +23,9 @@ config SND_USB_AUDIO
>>  	  To compile this driver as a module, choose M here: the module
>>  	  will be called snd-usb-audio.
>>  
>> +config SND_USB_AUDIO_USE_MEDIA_CONTROLLER
>> +	bool
>> +
>>  config SND_USB_UA101
>>  	tristate "Edirol UA-101/UA-1000 driver"
>>  	select SND_PCM
>> diff --git a/sound/usb/Makefile b/sound/usb/Makefile
>> index 2d2d122..8dca3c4 100644
>> --- a/sound/usb/Makefile
>> +++ b/sound/usb/Makefile
>> @@ -15,6 +15,8 @@ snd-usb-audio-objs := 	card.o \
>>  			quirks.o \
>>  			stream.o
>>  
>> +snd-usb-audio-$(CONFIG_SND_USB_AUDIO_USE_MEDIA_CONTROLLER) += media.o
>> +
>>  snd-usbmidi-lib-objs := midi.o
>>  
>>  # Toplevel Module Dependency
>> diff --git a/sound/usb/card.c b/sound/usb/card.c
>> index 1f09d95..3b226ed 100644
>> --- a/sound/usb/card.c
>> +++ b/sound/usb/card.c
>> @@ -66,6 +66,7 @@
>>  #include "format.h"
>>  #include "power.h"
>>  #include "stream.h"
>> +#include "media.h"
>>  
>>  MODULE_AUTHOR("Takashi Iwai <tiwai@suse.de>");
>>  MODULE_DESCRIPTION("USB Audio");
>> @@ -621,6 +622,12 @@ static void usb_audio_disconnect(struct usb_interface *intf)
>>  		list_for_each_entry(mixer, &chip->mixer_list, list) {
>>  			snd_usb_mixer_disconnect(mixer);
>>  		}
>> +		/*
>> +		 * Nice to check quirk && quirk->media_device
>> +		 * need some special handlings. Doesn't look like
>> +		 * we have access to quirk here
>> +		*/
>> +		media_device_delete(intf);
>>  	}
>>  
>>  	chip->num_interfaces--;
>> diff --git a/sound/usb/card.h b/sound/usb/card.h
>> index 71778ca..c15a03c 100644
>> --- a/sound/usb/card.h
>> +++ b/sound/usb/card.h
>> @@ -156,6 +156,7 @@ struct snd_usb_substream {
>>  	} dsd_dop;
>>  
>>  	bool trigger_tstamp_pending_update; /* trigger timestamp being updated from initial estimate */
>> +	void *media_ctl;
>>  };
>>  
>>  struct snd_usb_stream {
>> diff --git a/sound/usb/media.c b/sound/usb/media.c
>> new file mode 100644
>> index 0000000..0987f40
>> --- /dev/null
>> +++ b/sound/usb/media.c
>> @@ -0,0 +1,184 @@
>> +/*
>> + * media.c - Media Controller specific ALSA driver code
>> + *
>> + * Copyright (c) 2015 Shuah Khan <shuahkh@osg.samsung.com>
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
>> +#include <linux/mutex.h>
>> +#include <linux/slab.h>
>> +#include <linux/usb.h>
>> +
>> +#include <sound/pcm.h>
>> +
>> +#include "usbaudio.h"
>> +#include "card.h"
>> +#include "media.h"
>> +
>> +int media_device_create(struct snd_usb_audio *chip,
>> +			struct usb_interface *iface)
>> +{
>> +	struct media_device *mdev;
>> +	struct usb_device *usbdev = interface_to_usbdev(iface);
>> +	int ret;
>> +
>> +	mdev = media_device_get_devres(&usbdev->dev);
>> +	if (!mdev)
>> +		return -ENOMEM;
>> +	if (!mdev->dev) {
>> +		/* register media device */
>> +		mdev->dev = &usbdev->dev;
>> +		if (usbdev->product)
>> +			strlcpy(mdev->model, usbdev->product,
>> +				sizeof(mdev->model));
>> +		if (usbdev->serial)
>> +			strlcpy(mdev->serial, usbdev->serial,
>> +				sizeof(mdev->serial));
>> +		strcpy(mdev->bus_info, usbdev->devpath);
>> +		mdev->hw_revision = le16_to_cpu(usbdev->descriptor.bcdDevice);
>> +		media_device_init(mdev);
>> +	}
>> +	if (!media_devnode_is_registered(&mdev->devnode)) {
>> +		ret = media_device_register(mdev);
> 
> The device registration in ALSA happens not immediately at the call of
> create but triggered via device dev_register callback.  I don't think
> this would be a big problem but still this may leave some race,
> e.g. MC device appears without the actual sound device during probe.

Creation and register both happen in media_device_create()
when it gets called during quirk handling for au0828 device.
You are right that ALSA attempts to init and register media
device before sound device during probe. As such, au0828
gets to this step of initializing and registering media
device before snd-usb-audio probe runs.

To avoid races with au0828, the following logic is in
place.

The reason for the checks if (!mdev->dev) is that au0828
could have done the media_device_init(mdev) by the time
ALSA attempts media_device_create() and it could have
registered the device as well. Hence, the reason for the
second check if (!media_devnode_is_registered(&mdev->devnode))

Are you concerned about other races within snd-usb-audio?
I can change it to do the media_device_create() step towards
the end of sound probe after the snd_card_register(0 step.
Please let me know your preference.

> 
> 
>> +		if (ret) {
>> +			dev_err(&usbdev->dev,
>> +				"Couldn't register media device. Error: %d\n",
>> +				ret);
>> +			return ret;
>> +		}
>> +	}
>> +	return 0;
>> +}
>> +
>> +void media_device_delete(struct usb_interface *iface)
>> +{
>> +	struct media_device *mdev;
>> +	struct usb_device *usbdev = interface_to_usbdev(iface);
>> +
>> +	mdev = media_device_find_devres(&usbdev->dev);
>> +	if (mdev && media_devnode_is_registered(&mdev->devnode))
>> +		media_device_unregister(mdev);
>> +}
>> +
>> +static int media_enable_source(struct media_ctl *mctl)
>> +{
>> +	if (mctl && mctl->media_dev->enable_source)
>> +		return mctl->media_dev->enable_source(&mctl->media_entity,
>> +						      &mctl->media_pipe);
>> +	return 0;
>> +}
>> +
>> +static void media_disable_source(struct media_ctl *mctl)
>> +{
>> +	if (mctl && mctl->media_dev->disable_source)
>> +		mctl->media_dev->disable_source(&mctl->media_entity);
>> +}
>> +
>> +int media_stream_init(struct snd_usb_substream *subs, struct snd_pcm *pcm,
>> +			int stream)
>> +{
>> +	struct media_device *mdev;
>> +	struct media_ctl *mctl;
>> +	struct device *pcm_dev = &pcm->streams[stream].dev;
>> +	u32 intf_type;
>> +	int ret = 0;
>> +
>> +	mdev = media_device_find_devres(&subs->dev->dev);
>> +	if (!mdev)
>> +		return -ENODEV;
>> +
>> +	if (subs->media_ctl)
>> +		return 0;
>> +
>> +	/* allocate media_ctl */
>> +	mctl = kzalloc(sizeof(*mctl), GFP_KERNEL);
>> +	if (!mctl)
>> +		return -ENOMEM;
>> +
>> +	mctl->media_dev = mdev;
>> +	if (stream == SNDRV_PCM_STREAM_PLAYBACK) {
>> +		intf_type = MEDIA_INTF_T_ALSA_PCM_PLAYBACK;
>> +		mctl->media_entity.function = MEDIA_ENT_F_AUDIO_PLAYBACK;
>> +	} else {
>> +		intf_type = MEDIA_INTF_T_ALSA_PCM_CAPTURE;
>> +		mctl->media_entity.function = MEDIA_ENT_F_AUDIO_CAPTURE;
>> +	}
>> +	mctl->media_entity.name = pcm->name;
>> +	mctl->media_entity.info.dev.major = MAJOR(pcm_dev->devt);
>> +	mctl->media_entity.info.dev.minor = MINOR(pcm_dev->devt);
>> +	mctl->media_pad.flags = MEDIA_PAD_FL_SINK;
> 
> Is it always a sink, no source, no matter which direction, playback or
> capture?
> 

Yes it is always a SINK in both cases. The source is
the audio decoder for both PCM capture and Playback
nodes.

thanks,
-- Shuah


-- 
Shuah Khan
Sr. Linux Kernel Developer
Open Source Innovation Group
Samsung Research America (Silicon Valley)
shuahkh@osg.samsung.com | (970) 217-8978
