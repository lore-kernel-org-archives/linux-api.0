From: Sakari Ailus <sakari.ailus@linux.intel.com>
Subject: [PATCH 0/2] Add V4L2_BUF_TYPE_META_OUTPUT buffer type
Date: Sat, 19 Aug 2017 00:30:54 +0300
Message-ID: <1503091856-18294-1-git-send-email-sakari.ailus@linux.intel.com>
Return-path: <linux-media-owner@vger.kernel.org>
Sender: linux-media-owner@vger.kernel.org
To: linux-media@vger.kernel.org
Cc: linux-api@vger.kernel.org, tfiga@chromium.org, yong.zhi@intel.com
List-Id: linux-api@vger.kernel.org

Hi folks,

Here's a non-RFC version of the META_OUTPUT buffer type patches.

The V4L2_BUF_TYPE_META_OUTPUT buffer type complements the metadata buffer
types support for OUTPUT buffers, capture being already supported. This is
intended for similar cases than V4L2_BUF_TYPE_META_CAPTURE but for output
buffers, e.g. device parameters that may be complex and highly
hierarchical data structure. Statistics are a current use case for
metadata capture buffers.

Yong: could you take these to your IPU3 ImgU patchset, please? As that
would be the first user, the patches would be merged with the driver
itself.

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
 drivers/media/v4l2-core/v4l2-ioctl.c             | 25 ++++++++++++++++++
 drivers/media/v4l2-core/videobuf2-v4l2.c         |  1 +
 include/media/v4l2-ioctl.h                       | 17 ++++++++++++
 include/uapi/linux/videodev2.h                   |  2 ++
 9 files changed, 75 insertions(+), 13 deletions(-)

-- 
2.7.4
