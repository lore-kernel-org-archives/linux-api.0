From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Subject: [PATCH v8 00/55] MC next generation patches
Date: Sun, 30 Aug 2015 00:06:11 -0300
Message-ID: <cover.1440902901.git.mchehab@osg.samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel/>
List-Post: <mailto:driverdev-devel@linuxdriverproject.org>
List-Help: <mailto:driverdev-devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: driverdev-devel-bounces@linuxdriverproject.org
Sender: "devel" <driverdev-devel-bounces@linuxdriverproject.org>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: devel@driverdev.osuosl.org, Lars-Peter Clausen <lars@metafoo.de>, Sylwester Nawrocki <s.nawrocki@samsung.com>, Mauro Carvalho Chehab <mchehab@osg.samsung.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-sh@vger.kernel.org, Shuah Khan <shuahkh@osg.samsung.com>, Mauro Carvalho Chehab <mchehab@infradead.org>, Hans Verkuil <hverkuil@xs4all.nl>, Javier Martinez Canillas <javier@osg.samsung.com>, linux-samsung-soc@vger.kernel.org, Laurent Pinchart <laurent.pinchart@ideasonboard.com>, Sakari Ailus <sakari.ailus@linux.intel.com>, linux-api@vger.kernel.org, linux-arm-kernel@lists.infradead.org
List-Id: linux-api@vger.kernel.org

That's the 8th version of the MC next generation patches.

Differences from version 7:

- Patches reworked to make the reviewers happy;
- Bug fixes;
- ALSA changes got their own separate patches;
- Javier patches got integrated into this series;
- media-entity.h structs are now properly documented;
- Tested on both au0828 and omap3isp.

Due to the complexity of this change, other platform drivers may
require some fixes. 

As the patch series sent before, this is not meant to be sent
upstream yet. Its goal is to merge it for Kernel 4.4, in order to
give people enough time to review and fix pending issues.

Regards,
Mauro

Javier Martinez Canillas (6):
  [media] staging: omap4iss: get entity ID using media_entity_id()
  [media] omap3isp: get entity ID using media_entity_id()
  [media] media: use entity.graph_obj.mdev instead of .parent
  [media] media: remove media entity .parent field
  [media] omap3isp: separate links creation from entities init
  [media] omap3isp: create links after all subdevs have been bound

Mauro Carvalho Chehab (49):
  [media] media: create a macro to get entity ID
  [media] media: add a common struct to be embed on media graph objects
  [media] media: use media_gobj inside entities
  [media] media: use media_gobj inside pads
  [media] media: use media_gobj inside links
  [media] media: add messages when media device gets (un)registered
  [media] media: add a debug message to warn about gobj creation/removal
  [media] media: rename the function that create pad links
  [media] uapi/media.h: Declare interface types for V4L2 and DVB
  [media] media: add functions to allow creating interfaces
  [media] uapi/media.h: Declare interface types for ALSA
  [media] media: Don't accept early-created links
  [media] media: convert links from array to list
  [media] media: make add link more generic
  [media] media: make media_link more generic to handle interace links
  [media] media: make link debug printk more generic
  [media] media: add support to link interfaces and entities
  [media] media-entity: add a helper function to create interface
  [media] dvbdev: add support for interfaces
  [media] media: add a linked list to track interfaces by mdev
  [media] dvbdev: add support for indirect interface links
  [media] uapi/media.h: Fix entity namespace
  [media] replace all occurrences of MEDIA_ENT_T_DEVNODE_V4L
  [media] replace all occurrences of MEDIA_ENT_T_DEVNODE_DVB
  [media] media: add macros to check if subdev or V4L2 DMA
  [media] media: use macros to check for V4L2 subdev entities
  [media] omap3/omap4/davinci: get rid of MEDIA_ENT_T_V4L2_SUBDEV abuse
  [media] s5c73m3: fix subdev type
  [media] s5k5baf: fix subdev type
  [media] davinci_vbpe: stop MEDIA_ENT_T_V4L2_SUBDEV abuse
  [media] omap4iss: stop MEDIA_ENT_T_V4L2_SUBDEV abuse
  [media] v4l2-subdev: use MEDIA_ENT_T_UNKNOWN for new subdevs
  [media] media controller: get rid of entity subtype on Kernel
  [media] media.h: don't use legacy entity macros at Kernel
  [media] DocBook: update descriptions for the media controller entities
  [media] dvb: modify core to implement interfaces/entities at MC new
    gen
  [media] media: report if a pad is sink or source at debug msg
  [media] uapi/media.h: Add MEDIA_IOC_G_TOPOLOGY ioctl
  [media] media: Use a macro to interate between all interfaces
  [media] media: move mdev list init to gobj
  [media] media-device: add pads and links to media_device
  [media] media_device: add a topology version field
  [media] media-device: add support for MEDIA_IOC_G_TOPOLOGY ioctl
  [media] media-entity: unregister entity links
  [media] remove interface links at media_entity_unregister()
  [media] media-device: remove interfaces and interface links
  [media] v4l2-core: create MC interfaces for devnodes
  [media] au0828: unregister MC at the end
  [media] media-entity.h: document all the structs

 .../DocBook/media/v4l/media-ioc-enum-entities.xml  |  57 +--
 Documentation/media-framework.txt                  |   2 +-
 drivers/media/dvb-core/dmxdev.c                    |   4 +-
 drivers/media/dvb-core/dvb_ca_en50221.c            |   2 +-
 drivers/media/dvb-core/dvb_frontend.c              |  11 +-
 drivers/media/dvb-core/dvb_net.c                   |   2 +-
 drivers/media/dvb-core/dvbdev.c                    | 278 +++++++++---
 drivers/media/dvb-core/dvbdev.h                    |  10 +-
 drivers/media/firewire/firedtv-ci.c                |   2 +-
 drivers/media/i2c/s5c73m3/s5c73m3-core.c           |   8 +-
 drivers/media/i2c/s5k5baf.c                        |   4 +-
 drivers/media/i2c/smiapp/smiapp-core.c             |   4 +-
 drivers/media/media-device.c                       | 245 +++++++++--
 drivers/media/media-entity.c                       | 473 +++++++++++++++++----
 drivers/media/pci/bt8xx/dst_ca.c                   |   3 +-
 drivers/media/pci/ddbridge/ddbridge-core.c         |   2 +-
 drivers/media/pci/ngene/ngene-core.c               |   2 +-
 drivers/media/pci/ttpci/av7110.c                   |   2 +-
 drivers/media/pci/ttpci/av7110_av.c                |   4 +-
 drivers/media/pci/ttpci/av7110_ca.c                |   2 +-
 drivers/media/platform/exynos4-is/common.c         |   3 +-
 drivers/media/platform/exynos4-is/fimc-capture.c   |   5 +-
 drivers/media/platform/exynos4-is/fimc-isp-video.c |   9 +-
 drivers/media/platform/exynos4-is/fimc-lite.c      |  18 +-
 drivers/media/platform/exynos4-is/media-dev.c      |  25 +-
 drivers/media/platform/exynos4-is/media-dev.h      |   8 +-
 drivers/media/platform/omap3isp/isp.c              | 202 +++++----
 drivers/media/platform/omap3isp/ispccdc.c          |  39 +-
 drivers/media/platform/omap3isp/ispccdc.h          |   1 +
 drivers/media/platform/omap3isp/ispccp2.c          |  35 +-
 drivers/media/platform/omap3isp/ispccp2.h          |   1 +
 drivers/media/platform/omap3isp/ispcsi2.c          |  33 +-
 drivers/media/platform/omap3isp/ispcsi2.h          |   1 +
 drivers/media/platform/omap3isp/isppreview.c       |  48 ++-
 drivers/media/platform/omap3isp/isppreview.h       |   1 +
 drivers/media/platform/omap3isp/ispresizer.c       |  46 +-
 drivers/media/platform/omap3isp/ispresizer.h       |   1 +
 drivers/media/platform/omap3isp/ispvideo.c         |  17 +-
 drivers/media/platform/s3c-camif/camif-capture.c   |   2 +-
 drivers/media/platform/s3c-camif/camif-core.c      |   4 +-
 drivers/media/platform/vsp1/vsp1_drv.c             |   4 +-
 drivers/media/platform/vsp1/vsp1_rpf.c             |   2 +-
 drivers/media/platform/vsp1/vsp1_video.c           |  15 +-
 drivers/media/platform/vsp1/vsp1_wpf.c             |   2 +-
 drivers/media/platform/xilinx/xilinx-dma.c         |  10 +-
 drivers/media/platform/xilinx/xilinx-vipp.c        |   4 +-
 drivers/media/usb/au0828/au0828-core.c             |  18 +-
 drivers/media/usb/au0828/au0828-video.c            |   8 +-
 drivers/media/usb/cx231xx/cx231xx-cards.c          |   6 +-
 drivers/media/usb/cx231xx/cx231xx-video.c          |   8 +-
 drivers/media/usb/uvc/uvc_entity.c                 |   2 +-
 drivers/media/v4l2-core/v4l2-dev.c                 | 105 ++++-
 drivers/media/v4l2-core/v4l2-device.c              |  10 +-
 drivers/media/v4l2-core/v4l2-subdev.c              |   6 +-
 drivers/staging/media/davinci_vpfe/dm365_ipipe.c   |   9 +-
 drivers/staging/media/davinci_vpfe/dm365_ipipeif.c |  15 +-
 drivers/staging/media/davinci_vpfe/dm365_isif.c    |  15 +-
 drivers/staging/media/davinci_vpfe/dm365_resizer.c |  33 +-
 .../staging/media/davinci_vpfe/vpfe_mc_capture.c   |  10 +-
 drivers/staging/media/davinci_vpfe/vpfe_video.c    |  17 +-
 drivers/staging/media/omap4iss/iss.c               |  32 +-
 drivers/staging/media/omap4iss/iss_csi2.c          |  13 +-
 drivers/staging/media/omap4iss/iss_ipipe.c         |   9 +-
 drivers/staging/media/omap4iss/iss_ipipeif.c       |  15 +-
 drivers/staging/media/omap4iss/iss_resizer.c       |  13 +-
 drivers/staging/media/omap4iss/iss_video.c         |   9 +-
 include/media/media-device.h                       |  34 +-
 include/media/media-entity.h                       | 305 +++++++++++--
 include/media/v4l2-dev.h                           |   1 +
 include/uapi/linux/media.h                         | 205 ++++++++-
 70 files changed, 1924 insertions(+), 627 deletions(-)

-- 
2.4.3
