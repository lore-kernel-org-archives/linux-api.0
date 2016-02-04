From: Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
Subject: [PATCH v2 00/22] Sharing media resources across ALSA and au0828 drivers
Date: Wed,  3 Feb 2016 21:03:32 -0700
Message-ID: <cover.1454557589.git.shuahkh@osg.samsung.com>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: mchehab-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org, tiwai-IBi9RG/b67k@public.gmane.org, clemens-P6GI/4k7KOmELgA04lAiVw@public.gmane.org, hans.verkuil-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org, laurent.pinchart-ryLnwIuWjnjg/C1BVhZhaw@public.gmane.org, sakari.ailus-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, javier-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org
Cc: Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>, pawel-FA/gS7QP4orQT0dZR+AlfA@public.gmane.org, m.szyprowski-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org, kyungmin.park-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org, perex-/Fr2/VpizcU@public.gmane.org, arnd-r2nGTMty4D4@public.gmane.org, dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, tvboxspy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, crope-X3B1VOXEql0@public.gmane.org, ruchandani.tina-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, corbet-T1hC0tSOHrs@public.gmane.org, chehabrafael-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, k.kozlowski-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org, stefanr-MtYdepGKPcBMYopoZt5u/LNAH6kLmebB@public.gmane.org, inki.dae-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org, jh1009.sung-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org, elfring-Rn4VEauK+AKRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, prabhakar.csengg-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, sw0312.kim-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org, p.zabel-bIcnvbaLZ9MEGnE8C9+IrQ@public.gmane.org, ricardo.ribalda-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, labbott-rxtnV0ftBwyoClj4AeEUq9i2O/JbrIOy@public.gmane.org, pierre-louis.bossart-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, ricard.wanderlof-VrBV9hrLPhE@public.gmane.org, julian-SZMMDGyaqes@public.gmane.org, takamichiho-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, dominic.sacre-Mmb7MZpHnFY@public.gmane.org, misterpib-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, daniel-cYrQPVfZoowdnm+yROfE0A@public.gmane.org, gtmkramer-qWit8jRvyhVmR6Xm/wNWPw@public.gmane.org, normalperson-rMlxZR9MS24@public.gmane.org, joe-amhYAVlgbXj10XsdtD+oqA@public.gmane.org, linuxbugs-mcfjX3dozePR7s880joybQ@public.gmane.org, johan-v8HUHnYb0Yo@public.gmane.org, klock.android-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, nenggun.kim-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org, j.anaszewski-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org, geliangtang
List-Id: linux-api@vger.kernel.org

This patch series updates ALSA driver, and au0828 core
driver to use Managed Media controller API and Media
Controller API to share media resource (tuner).

This Patch v2 series is based on linux_media master.
This work addresses Mauro and Takashi's comments.

Composite or S-Video connector is the input case
is still under discussion and isn't addressed in
this series.

Patches 3 and 4 need documentation updates and will
be sent later this week.

Shuah Khan (22):
  uapi/media.h: Declare interface types for ALSA
  media: Add ALSA Media Controller function entities
  media: Media Controller register/unregister entity_notify API
  media: Media Controller enable/disable source handler API
  media: Media Controller export non locking __media_entity_setup_link()
  media: Media Controller non-locking
    __media_entity_pipeline_start/stop()
  media: v4l-core add enable/disable source common interfaces
  media: Move au8522_media_pads enum to au8522.h from au8522_priv.h
  media: au8522 change to create MC pad for ALSA Audio Out
  media: Change v4l-core to check if source is free
  media: dvb-frontend invoke enable/disable_source handlers
  media: au0828 video remove au0828_enable_analog_tuner()
  media: au0828 video change to use v4l_enable_media_source()
  media: au0828 change to use Managed Media Controller API
  media: au0828 handle media_init and media_register window
  media: au0828 create tuner to decoder link in disabled state
  media: au0828 disable tuner to demod link
  media: au0828 Use au8522_media_pads enum for pad defines
  media: au0828-core register entity_notify hook
  media: au0828 add enable, disable source handlers
  sound/usb: Use Media Controller API to share media resources
  media: Ensure media device unregister is done only once

 drivers/media/dvb-core/dvb_frontend.c        | 139 ++----------
 drivers/media/dvb-core/dvb_frontend.h        |   3 +
 drivers/media/dvb-frontends/au8522.h         |   8 +
 drivers/media/dvb-frontends/au8522_decoder.c |   1 +
 drivers/media/dvb-frontends/au8522_priv.h    |   8 -
 drivers/media/media-device.c                 |  73 +++++-
 drivers/media/media-devnode.c                |  15 +-
 drivers/media/media-entity.c                 |  51 ++++-
 drivers/media/usb/au0828/au0828-core.c       | 272 +++++++++++++++++++++--
 drivers/media/usb/au0828/au0828-video.c      |  75 +------
 drivers/media/usb/au0828/au0828.h            |   4 +
 drivers/media/v4l2-core/Makefile             |   2 +-
 drivers/media/v4l2-core/v4l2-fh.c            |   2 +
 drivers/media/v4l2-core/v4l2-ioctl.c         |  30 +++
 drivers/media/v4l2-core/v4l2-mc.c            |  60 +++++
 drivers/media/v4l2-core/videobuf2-core.c     |   4 +
 include/media/media-device.h                 |  44 ++++
 include/media/media-devnode.h                |  17 ++
 include/media/media-entity.h                 |  12 +
 include/media/v4l2-dev.h                     |   1 +
 include/media/v4l2-mc.h                      |  52 +++++
 include/uapi/linux/media.h                   |  33 +++
 sound/usb/Kconfig                            |   4 +
 sound/usb/Makefile                           |   2 +
 sound/usb/card.c                             |  14 ++
 sound/usb/card.h                             |   1 +
 sound/usb/media.c                            | 319 +++++++++++++++++++++++++++
 sound/usb/media.h                            |  72 ++++++
 sound/usb/mixer.h                            |   1 +
 sound/usb/pcm.c                              |  28 ++-
 sound/usb/quirks-table.h                     |   1 +
 sound/usb/stream.c                           |   2 +
 sound/usb/usbaudio.h                         |   3 +
 33 files changed, 1117 insertions(+), 236 deletions(-)
 create mode 100644 drivers/media/v4l2-core/v4l2-mc.c
 create mode 100644 sound/usb/media.c
 create mode 100644 sound/usb/media.h

-- 
2.5.0
