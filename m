From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Subject: Re: [PATCH v2 00/22] Sharing media resources across ALSA and au0828
 drivers
Date: Thu, 4 Feb 2016 08:54:19 -0200
Message-ID: <20160204085419.426d1aab@recife.lan>
References: <cover.1454557589.git.shuahkh@osg.samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <cover.1454557589.git.shuahkh@osg.samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Shuah Khan <shuahkh@osg.samsung.com>
Cc: tiwai@suse.com, clemens@ladisch.de, hans.verkuil@cisco.com, laurent.pinchart@ideasonboard.com, sakari.ailus@linux.intel.com, javier@osg.samsung.com, pawel@osciak.com, m.szyprowski@samsung.com, kyungmin.park@samsung.com, perex@perex.cz, arnd@arndb.de, dan.carpenter@oracle.com, tvboxspy@gmail.com, crope@iki.fi, ruchandani.tina@gmail.com, corbet@lwn.net, chehabrafael@gmail.com, k.kozlowski@samsung.com, stefanr@s5r6.in-berlin.de, inki.dae@samsung.com, jh1009.sung@samsung.com, elfring@users.sourceforge.net, prabhakar.csengg@gmail.com, sw0312.kim@samsung.com, p.zabel@pengutronix.de, ricardo.ribalda@gmail.com, labbott@fedoraproject.org, pierre-louis.bossart@linux.intel.com, ricard.wanderlof@axis.com, julian@jusst.de, takamichiho@gmail.com, dominic.sacre@gmx.de, misterpib@gmail.com, daniel@zonque.org, gtmkramer@xs4all.nl, normalperson@yhbt.net, joe@oampo.co.uk, linuxbugs@vittga
List-Id: linux-api@vger.kernel.org

Em Wed, 03 Feb 2016 21:03:32 -0700
Shuah Khan <shuahkh@osg.samsung.com> escreveu:

> This patch series updates ALSA driver, and au0828 core
> driver to use Managed Media controller API and Media
> Controller API to share media resource (tuner).

Please see my comments to patch 20. I guess this series break support
for the digital-only boards below (where .has_analog is not set):

	[AU0828_BOARD_HAUPPAUGE_HVR950Q_MXL] = {
		.name	= "Hauppauge HVR950Q rev xxF8",
		.tuner_type = TUNER_XC5000,
		.tuner_addr = 0x61,
		.i2c_clk_divider = AU0828_I2C_CLK_250KHZ,
	},
	[AU0828_BOARD_DVICO_FUSIONHDTV7] = {
		.name	= "DViCO FusionHDTV USB",
		.tuner_type = TUNER_XC5000,
		.tuner_addr = 0x61,
		.i2c_clk_divider = AU0828_I2C_CLK_250KHZ,
	},
	[AU0828_BOARD_HAUPPAUGE_WOODBURY] = {
		.name = "Hauppauge Woodbury",
		.tuner_type = TUNER_NXP_TDA18271,
		.tuner_addr = 0x60,
		.i2c_clk_divider = AU0828_I2C_CLK_250KHZ,
	},

None of this boards have V4L2. So, only the DVB part of the driver
should be enabled. Well, the DVB core won't be creating a tuner
subdev. So, calling au0828_enable_source() (and disable source) would
return -ENODEV, causing the driver to fail.

> 
> This Patch v2 series is based on linux_media master.
> This work addresses Mauro and Takashi's comments.

It is in a way better shape, but there are still several things I
noticed :)

Please see my per-patch review.

> 
> Composite or S-Video connector is the input case
> is still under discussion and isn't addressed in
> this series.

You need at least address pure DVB boards at patch 20 and
add there a FIXME for the composite/svideo connector pending 
issue.

> 
> Patches 3 and 4 need documentation updates and will
> be sent later this week.

Please send documentation at the same series. Nobody wants to see the
documentation warnings when checking at the main media development
branch or at -next. Also, it helps to better understand the changes.

Regards,
Mauro

> 
> Shuah Khan (22):
>   uapi/media.h: Declare interface types for ALSA
>   media: Add ALSA Media Controller function entities
>   media: Media Controller register/unregister entity_notify API
>   media: Media Controller enable/disable source handler API
>   media: Media Controller export non locking __media_entity_setup_link()
>   media: Media Controller non-locking
>     __media_entity_pipeline_start/stop()
>   media: v4l-core add enable/disable source common interfaces
>   media: Move au8522_media_pads enum to au8522.h from au8522_priv.h
>   media: au8522 change to create MC pad for ALSA Audio Out
>   media: Change v4l-core to check if source is free
>   media: dvb-frontend invoke enable/disable_source handlers
>   media: au0828 video remove au0828_enable_analog_tuner()
>   media: au0828 video change to use v4l_enable_media_source()
>   media: au0828 change to use Managed Media Controller API
>   media: au0828 handle media_init and media_register window
>   media: au0828 create tuner to decoder link in disabled state
>   media: au0828 disable tuner to demod link
>   media: au0828 Use au8522_media_pads enum for pad defines
>   media: au0828-core register entity_notify hook
>   media: au0828 add enable, disable source handlers
>   sound/usb: Use Media Controller API to share media resources
>   media: Ensure media device unregister is done only once
> 
>  drivers/media/dvb-core/dvb_frontend.c        | 139 ++----------
>  drivers/media/dvb-core/dvb_frontend.h        |   3 +
>  drivers/media/dvb-frontends/au8522.h         |   8 +
>  drivers/media/dvb-frontends/au8522_decoder.c |   1 +
>  drivers/media/dvb-frontends/au8522_priv.h    |   8 -
>  drivers/media/media-device.c                 |  73 +++++-
>  drivers/media/media-devnode.c                |  15 +-
>  drivers/media/media-entity.c                 |  51 ++++-
>  drivers/media/usb/au0828/au0828-core.c       | 272 +++++++++++++++++++++--
>  drivers/media/usb/au0828/au0828-video.c      |  75 +------
>  drivers/media/usb/au0828/au0828.h            |   4 +
>  drivers/media/v4l2-core/Makefile             |   2 +-
>  drivers/media/v4l2-core/v4l2-fh.c            |   2 +
>  drivers/media/v4l2-core/v4l2-ioctl.c         |  30 +++
>  drivers/media/v4l2-core/v4l2-mc.c            |  60 +++++
>  drivers/media/v4l2-core/videobuf2-core.c     |   4 +
>  include/media/media-device.h                 |  44 ++++
>  include/media/media-devnode.h                |  17 ++
>  include/media/media-entity.h                 |  12 +
>  include/media/v4l2-dev.h                     |   1 +
>  include/media/v4l2-mc.h                      |  52 +++++
>  include/uapi/linux/media.h                   |  33 +++
>  sound/usb/Kconfig                            |   4 +
>  sound/usb/Makefile                           |   2 +
>  sound/usb/card.c                             |  14 ++
>  sound/usb/card.h                             |   1 +
>  sound/usb/media.c                            | 319 +++++++++++++++++++++++++++
>  sound/usb/media.h                            |  72 ++++++
>  sound/usb/mixer.h                            |   1 +
>  sound/usb/pcm.c                              |  28 ++-
>  sound/usb/quirks-table.h                     |   1 +
>  sound/usb/stream.c                           |   2 +
>  sound/usb/usbaudio.h                         |   3 +
>  33 files changed, 1117 insertions(+), 236 deletions(-)
>  create mode 100644 drivers/media/v4l2-core/v4l2-mc.c
>  create mode 100644 sound/usb/media.c
>  create mode 100644 sound/usb/media.h
> 
