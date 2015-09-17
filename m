From: Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH v2 0/9] [media] y2038 conversion for subsystem
Date: Thu, 17 Sep 2015 23:19:31 +0200
Message-ID: <1442524780-781677-1-git-send-email-arnd@arndb.de>
Return-path: <linux-media-owner@vger.kernel.org>
Sender: linux-media-owner@vger.kernel.org
To: linux-media@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, y2038@lists.linaro.org, Mauro Carvalho Chehab <mchehab@osg.samsung.com>, linux-api@vger.kernel.org, linux-samsung-soc@vger.kernel.org, Hans Verkuil <hverkuil@xs4all.nl>, Arnd Bergmann <arnd@arndb.de>
List-Id: linux-api@vger.kernel.org

This is my second attempt to convert subsystem-wide code in v4l
for y2038 changes, removing uses of time_t in common files
and adding support for user space that defines time_t as 64 bit.

Based on the initial feedback from Hans Verkuil, I've changed the
ioctl handling to remain 100% compatible with existing headers,
which also makes it more likely that existing source code can
compile without changes.

This comes at a noticeable expense of adding complexity to
the v4l2-ioctl.c file, as we now have to handle two versions
of each ioctl command that passes a time_t in its arguments.

I have not added support for the new binary layout of v4l2_timeval
to v4l2-compat-ioctl32 yet, that is something I can do when the
basic approach has been agreed on.

	Arnd

Arnd Bergmann (9):
  [media] dvb: use ktime_t for internal timeout
  [media] dvb: remove unused systime() function
  [media] dvb: don't use 'time_t' in event ioctl
  [media] exynos4-is: use monotonic timestamps as advertized
  [media] make VIDIOC_DQEVENT work with 64-bit time_t
  [media] use v4l2_get_timestamp where possible
  [media] v4l2: introduce v4l2_timeval
  [media] handle 64-bit time_t in v4l2_buffer
  [media] omap3isp: support 64-bit version of omap3isp_stat_data

 drivers/media/dvb-core/demux.h                   |   2 +-
 drivers/media/dvb-core/dmxdev.c                  |   2 +-
 drivers/media/dvb-core/dvb_demux.c               |  17 +-
 drivers/media/dvb-core/dvb_demux.h               |   4 +-
 drivers/media/dvb-core/dvb_net.c                 |   2 +-
 drivers/media/dvb-frontends/dibx000_common.c     |  10 -
 drivers/media/dvb-frontends/dibx000_common.h     |   2 -
 drivers/media/pci/bt8xx/bttv-driver.c            |   7 +-
 drivers/media/pci/cx18/cx18-mailbox.c            |   2 +-
 drivers/media/pci/meye/meye.h                    |   2 +-
 drivers/media/pci/zoran/zoran.h                  |   2 +-
 drivers/media/platform/coda/coda.h               |   2 +-
 drivers/media/platform/exynos4-is/fimc-capture.c |   8 +-
 drivers/media/platform/exynos4-is/fimc-lite.c    |   7 +-
 drivers/media/platform/omap/omap_vout.c          |   4 +-
 drivers/media/platform/omap3isp/isph3a_aewb.c    |   2 +
 drivers/media/platform/omap3isp/isph3a_af.c      |   2 +
 drivers/media/platform/omap3isp/isphist.c        |   2 +
 drivers/media/platform/omap3isp/ispstat.c        |  20 +-
 drivers/media/platform/omap3isp/ispstat.h        |   4 +-
 drivers/media/platform/s3c-camif/camif-capture.c |   8 +-
 drivers/media/platform/vim2m.c                   |   2 +-
 drivers/media/platform/vivid/vivid-ctrls.c       |   2 +-
 drivers/media/usb/cpia2/cpia2.h                  |   2 +-
 drivers/media/usb/cpia2/cpia2_v4l.c              |   2 +-
 drivers/media/usb/gspca/gspca.c                  |   6 +-
 drivers/media/usb/usbvision/usbvision.h          |   2 +-
 drivers/media/v4l2-core/v4l2-common.c            |   6 +-
 drivers/media/v4l2-core/v4l2-compat-ioctl32.c    |  35 ----
 drivers/media/v4l2-core/v4l2-dev.c               |   1 +
 drivers/media/v4l2-core/v4l2-event.c             |  35 +++-
 drivers/media/v4l2-core/v4l2-ioctl.c             | 227 ++++++++++++++++++++---
 drivers/media/v4l2-core/v4l2-subdev.c            |   6 +
 drivers/staging/media/omap4iss/iss_video.c       |   5 +-
 include/media/v4l2-common.h                      |   2 +-
 include/media/v4l2-event.h                       |   2 +
 include/media/videobuf-core.h                    |   2 +-
 include/trace/events/v4l2.h                      |  12 +-
 include/uapi/linux/dvb/video.h                   |   3 +-
 include/uapi/linux/omap3isp.h                    |  19 ++
 include/uapi/linux/videodev2.h                   |  78 ++++++++
 41 files changed, 415 insertions(+), 145 deletions(-)

-- 
2.1.0.rc2
