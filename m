From: Boris BREZILLON <boris.brezillon-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org>
Subject: [PATCH 0/5] video: describe data bus formats
Date: Tue, 22 Jul 2014 14:23:42 +0200
Message-ID: <1406031827-12432-1-git-send-email-boris.brezillon@free-electrons.com>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Thierry Reding <thierry.reding-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Laurent Pinchart <laurent.pinchart-ryLnwIuWjnjg/C1BVhZhaw@public.gmane.org>
Cc: David Airlie <airlied-cv59FeDIM0c@public.gmane.org>, dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mauro Carvalho Chehab <m.chehab-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>, linux-media-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Boris BREZILLON <boris.brezillon-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Hello,

This patch series is a proposal to describe the different data formats used
by HW components to connect with each other.

This is just a copy of the existing V4L2_MBUS_FMT defintions with a neutral
name so that it can be used by V4L2 and DRM/KMS subsystem.

This series also makes use of this video_bus_format enum in the DRM/KMS
subsystem to define the data fomats supported on the connector <-> device
link.

The video bus formats are not documented yet (and I don't know where this doc
should be stored), but I'm pretty sure this version won't be the last one ;-).

Best Regards,

Boris

Boris BREZILLON (5):
  video: move mediabus format definition to a more standard place
  video: add RGB444_1X12 and RGB565_1X16 bus formats
  drm: add bus_formats and nbus_formats fields to drm_display_info
  drm: panel: simple-panel: add support for bus_format retrieval
  drm: panel: simple-panel: add bus format information for foxlink panel

 drivers/gpu/drm/drm_crtc.c            |  28 +++++
 drivers/gpu/drm/panel/panel-simple.c  |   6 ++
 include/drm/drm_crtc.h                |   8 ++
 include/uapi/linux/Kbuild             |   1 +
 include/uapi/linux/v4l2-mediabus.h    | 185 +++++++++++++++-------------------
 include/uapi/linux/video-bus-format.h | 129 ++++++++++++++++++++++++
 6 files changed, 251 insertions(+), 106 deletions(-)
 create mode 100644 include/uapi/linux/video-bus-format.h

-- 
1.8.3.2
