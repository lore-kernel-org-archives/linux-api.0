From: Shuah Khan <shuahkh@osg.samsung.com>
Subject: [PATCH 00/31] Sharing media resources across ALSA and au0828 drivers
Date: Wed,  6 Jan 2016 13:26:49 -0700
Message-ID: <cover.1452105878.git.shuahkh@osg.samsung.com>
Return-path: <linux-media-owner@vger.kernel.org>
Sender: linux-media-owner@vger.kernel.org
To: mchehab@osg.samsung.com, tiwai@suse.com, clemens@ladisch.de, hans.verkuil@cisco.com, laurent.pinchart@ideasonboard.com, sakari.ailus@linux.intel.com, javier@osg.samsung.com
Cc: Shuah Khan <shuahkh@osg.samsung.com>, pawel@osciak.com, m.szyprowski@samsung.com, kyungmin.park@samsung.com, perex@perex.cz, arnd@arndb.de, dan.carpenter@oracle.com, tvboxspy@gmail.com, crope@iki.fi, ruchandani.tina@gmail.com, corbet@lwn.net, chehabrafael@gmail.com, k.kozlowski@samsung.com, stefanr@s5r6.in-berlin.de, inki.dae@samsung.com, jh1009.sung@samsung.com, elfring@users.sourceforge.net, prabhakar.csengg@gmail.com, sw0312.kim@samsung.com, p.zabel@pengutronix.de, ricardo.ribalda@gmail.com, labbott@fedoraproject.org, pierre-louis.bossart@linux.intel.com, ricard.wanderlof@axis.com, julian@jusst.de, takamichiho@gmail.com, dominic.sacre@gmx.de, misterpib@gmail.com, daniel@zonque.org, gtmkramer@xs4all.nl, normalperson@yhbt.net, joe@oampo.co.uk, linuxbugs@vittgam.net, johan@oljud.se, linux-kernel@vger.kernel.org, linux-media@vger.kernel.org, linux-api@vger.kernel.orga
List-Id: linux-api@vger.kernel.org

This patch series updates ALSA driver, and au0828 core
driver to use Managed Media controller API and Media
Controller API to share tuner.

Media Controller Next Generation API has been enhanced
to add two new interfaces to register and unregister
entity_notify hooks to allow drivers to take appropriate
actions when as new entities get added to the shared media
device.

Mauro and Takashi: I am hoping you can both coordinate
and decide on ALSA patches once the reviews are done
and the patches look good.

Design Highlights:
1. ALSA to check for resources and hold in snd_usb_hw_params(),
   and release from snd_usb_hw_free(). This change fixed the
   lockdep warnings seen when resources were held in
   TRIGGER_START and released from TRIGGER_STOP which could
   run in IRQ context. I acknowledge Clemens Ladisch for
   suggesting the correct places to hold/free resources to
   avoid IRQ path complications.
2. The Bridge driver (au0828) owns and drives the graph creation
   as well as enabling and disabling tuner. It also keeps state
   information to avoid graph walks in enable_source and
   disable_source handler. I acknowledge Hans Verkuil for his
   suggestions and ideas for this change.

Tested exclusion between digital, analog, and audio to ensure
when tuner has an active link to DVB FE, analog, and audio will
detect and honor the tuner busy conditions and vice versa.

Please find the graphs generated using mc_nextgen_test tool at
various points during testing at:
https://drive.google.com/folderview?id=0B0NIL0BQg-AlRndaaXViSXdPeTA&usp=sharing

This patch series is a rebase and update to the latest Media
Controller Next Gen API of the Media Controller Next Generation
API port.

Rebase highlights:
1. Changes to videobuf2 framework required additional
   v4l2 helper function to enable the tuner from
   vb2_core_streamon(). Patch 9 has this work.
2. Media device initialization and registration steps
   are now split in the latest Media Controller Next Gen
   API. This required changes to au0828 and ALSA to coordinate
   initialization and registration of the Managed Media Device
   they share. Patch 19 shows au0828 changes. ALSA changes
   for this are folded into the main ALSA patch 26.
3. Media device unregistration does more cleanup now. As a
   result, au0828 and ALSA need to coordinate so media device
   is done only once. These changes are in patches: 29, 30,
   and 31.
4. In addition, media device resources cleanup gets done
   before snd_card_disconnect(). This work is in patch 30.

Media Controller Next Generation API port from Media Controller API:
The patch series below was a port of the Patch v3 - Media Controller API
to Next Gen API and Mixer patch update to address comments and bug fixes:
https://www.mail-archive.com/linux-media@vger.kernel.org/msg93086.html
https://www.mail-archive.com/linux-media@vger.kernel.org/msg93417.html

Patch v3 - Media Controller API:
https://www.mail-archive.com/linux-media@vger.kernel.org/msg92572.html

Mauro Carvalho Chehab (1):
  uapi/media.h: Declare interface types for ALSA

Shuah Khan (30):
  media: Add ALSA Media Controller function entities
  media: Media Controller register/unregister entity_notify API
  media: Media Controller enable/disable source handler API
  media: Media Controller fix to not let stream_count go negative
  media: Media Controller export non locking __media_entity_setup_link()
  media: Media Controller non-locking
    __media_entity_pipeline_start/stop()
  media: v4l-core add v4l_enable/disable_media_tuner() helper functions
  media: v4l2-core add v4l_vb2q_enable_media_tuner() helper
  media: Move au8522_media_pads enum to au8522.h from au8522_priv.h
  media: au8522 change to create MC pad for ALSA Audio Out
  media: au0828 Use au8522_media_pads enum for pad defines
  media: au0828 fix au0828_create_media_graph() entity checks
  media: Change v4l-core to check for tuner availability
  media: dvb-frontend invoke enable/disable_source handlers
  media: au0828 video remove au0828_enable_analog_tuner()
  media: au0828 video change to use v4l_enable_media_tuner()
  media: au0828 change to use Managed Media Controller API
  media: au0828 handle media_init and media_register window
  media: au0828 change to register/unregister entity_notify hook
  media: au0828 create tuner to decoder link in deactivated state
  media: dvb-core create tuner to demod pad link in disabled state
  media: au0828 implement enable_source and disable_source handlers
  media: au0828 fix null pointer reference in
    au0828_create_media_graph()
  media: au0828 fix to not call media_device_unregister_entity_notify()
  sound/usb: Update ALSA driver to use Managed Media Controller API
  sound/usb: Create media mixer function and control interface entities
  media: au0828 create link between ALSA Mixer and decoder
  media: track media device unregister in progress
  sound/usb: Check media device unregister progress state
  media: au0828 change to check media device unregister progress state

 drivers/media/dvb-core/dvb_frontend.c        | 139 ++---------
 drivers/media/dvb-core/dvb_frontend.h        |   3 +
 drivers/media/dvb-core/dvbdev.c              |   3 +-
 drivers/media/dvb-frontends/au8522.h         |   8 +
 drivers/media/dvb-frontends/au8522_decoder.c |   1 +
 drivers/media/dvb-frontends/au8522_priv.h    |   8 -
 drivers/media/media-device.c                 |  66 ++++-
 drivers/media/media-entity.c                 |  65 +++--
 drivers/media/usb/au0828/au0828-core.c       | 355 ++++++++++++++++++++++-----
 drivers/media/usb/au0828/au0828-video.c      |  75 +-----
 drivers/media/usb/au0828/au0828.h            |   9 +
 drivers/media/v4l2-core/v4l2-dev.c           |  48 ++++
 drivers/media/v4l2-core/v4l2-fh.c            |   1 +
 drivers/media/v4l2-core/v4l2-ioctl.c         |  29 +++
 drivers/media/v4l2-core/videobuf2-core.c     |   4 +
 include/media/media-device.h                 |  61 +++++
 include/media/media-entity.h                 |  12 +
 include/media/v4l2-dev.h                     |   5 +
 include/uapi/linux/media.h                   |  17 +-
 sound/usb/Makefile                           |  15 +-
 sound/usb/card.c                             |  16 ++
 sound/usb/card.h                             |   1 +
 sound/usb/media.c                            | 325 ++++++++++++++++++++++++
 sound/usb/media.h                            |  75 ++++++
 sound/usb/mixer.h                            |   1 +
 sound/usb/pcm.c                              |  26 +-
 sound/usb/quirks-table.h                     |   1 +
 sound/usb/quirks.c                           |   9 +-
 sound/usb/stream.c                           |   1 +
 sound/usb/usbaudio.h                         |   2 +
 30 files changed, 1111 insertions(+), 270 deletions(-)
 create mode 100644 sound/usb/media.c
 create mode 100644 sound/usb/media.h

-- 
2.5.0
