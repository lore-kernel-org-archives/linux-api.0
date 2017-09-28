From: Sakari Ailus <sakari.ailus-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: [PATCH v2 0/2] Add V4L2_BUF_TYPE_META_OUTPUT buffer type
Date: Thu, 28 Sep 2017 18:24:12 +0300
Message-ID: <1506612254-3946-1-git-send-email-sakari.ailus@linux.intel.com>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-media-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tfiga-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org, yong.zhi-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
List-Id: linux-api@vger.kernel.org

Hi folks,

Here's a second non-RFC version of the META_OUTPUT buffer type patches.

The V4L2_BUF_TYPE_META_OUTPUT buffer type complements the metadata buffer
types support for OUTPUT buffers, capture being already supported. This is
intended for similar cases than V4L2_BUF_TYPE_META_CAPTURE but for output
buffers, e.g. device parameters that may be complex and highly
hierarchical data structure. Statistics are a current use case for
metadata capture buffers.

Yong: could you take these to your IPU3 ImgU patchset, please? As that
would be the first user, the patches would be merged with the driver
itself.

since v1:

- Correctly determine valid IOCTLs for META_OUTPUT type in
  determine_valid_ioctls().

since RFC:

- Fix make htmldocs build.

- Fix CAPTURE -> OUTPUT in buffer.rst.

- Added " for specifying how the device processes images" in the
  documentation.

Sakari Ailus (2):
  v4l: Add support for V4L2_BUF_TYPE_META_OUTPUT
  docs-rst: v4l: Document V4L2_BUF_TYPE_META_OUTPUT interface

 Documentation/media/uapi/v4l/buffer.rst          |  3 +++
 Documentation/media/uapi/v4l/dev-meta.rst        | 33 ++++++++++++++----------
 Documentation/media/uapi/v4l/vidioc-querycap.rst |  3 +++
 Documentation/media/videodev2.h.rst.exceptions   |  2 ++
 drivers/media/v4l2-core/v4l2-compat-ioctl32.c    |  2 ++
 drivers/media/v4l2-core/v4l2-dev.c               | 12 ++++++---
 drivers/media/v4l2-core/v4l2-ioctl.c             | 25 ++++++++++++++++++
 drivers/media/v4l2-core/videobuf2-v4l2.c         |  1 +
 include/media/v4l2-ioctl.h                       | 17 ++++++++++++
 include/uapi/linux/videodev2.h                   |  2 ++
 10 files changed, 83 insertions(+), 17 deletions(-)

-- 
2.7.4
