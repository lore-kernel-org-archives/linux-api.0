From: Sakari Ailus <sakari.ailus@linux.intel.com>
Subject: [PATCH 2/2] docs-rst: v4l: Document V4L2_BUF_TYPE_META_OUTPUT interface
Date: Sat, 19 Aug 2017 00:30:56 +0300
Message-ID: <1503091856-18294-3-git-send-email-sakari.ailus@linux.intel.com>
References: <1503091856-18294-1-git-send-email-sakari.ailus@linux.intel.com>
Return-path: <linux-media-owner@vger.kernel.org>
In-Reply-To: <1503091856-18294-1-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
To: linux-media@vger.kernel.org
Cc: linux-api@vger.kernel.org, tfiga@chromium.org, yong.zhi@intel.com
List-Id: linux-api@vger.kernel.org

Document the interface for metadata output, including
V4L2_BUF_TYPE_META_OUTPUT buffer type and V4L2_CAP_META_OUTPUT capability
bits.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 Documentation/media/uapi/v4l/buffer.rst          |  3 +++
 Documentation/media/uapi/v4l/dev-meta.rst        | 33 ++++++++++++++----------
 Documentation/media/uapi/v4l/vidioc-querycap.rst |  3 +++
 Documentation/media/videodev2.h.rst.exceptions   |  2 ++
 4 files changed, 28 insertions(+), 13 deletions(-)

diff --git a/Documentation/media/uapi/v4l/buffer.rst b/Documentation/media/uapi/v4l/buffer.rst
index ae6ee73..33b932e 100644
--- a/Documentation/media/uapi/v4l/buffer.rst
+++ b/Documentation/media/uapi/v4l/buffer.rst
@@ -452,6 +452,9 @@ enum v4l2_buf_type
     * - ``V4L2_BUF_TYPE_META_CAPTURE``
       - 13
       - Buffer for metadata capture, see :ref:`metadata`.
+    * - ``V4L2_BUF_TYPE_META_OUTPUT``
+      - 14
+      - Buffer for metadata output, see :ref:`metadata`.
 
 
 
diff --git a/Documentation/media/uapi/v4l/dev-meta.rst b/Documentation/media/uapi/v4l/dev-meta.rst
index 62518ad..a1e54bc 100644
--- a/Documentation/media/uapi/v4l/dev-meta.rst
+++ b/Documentation/media/uapi/v4l/dev-meta.rst
@@ -7,21 +7,27 @@ Metadata Interface
 ******************
 
 Metadata refers to any non-image data that supplements video frames with
-additional information. This may include statistics computed over the image
-or frame capture parameters supplied by the image source. This interface is
-intended for transfer of metadata to userspace and control of that operation.
+additional information. This may include statistics computed over the image,
+frame capture parameters supplied by the image source or device specific
+parameters for specifying how the device processes images. This interface is
+intended for transfer of metadata between the userspace and the hardware and
+control of that operation.
 
-The metadata interface is implemented on video capture device nodes. The device
-can be dedicated to metadata or can implement both video and metadata capture
-as specified in its reported capabilities.
+The metadata interface is implemented on video device nodes. The device can be
+dedicated to metadata or can support both video and metadata as specified in its
+reported capabilities.
 
 Querying Capabilities
 =====================
 
-Device nodes supporting the metadata interface set the ``V4L2_CAP_META_CAPTURE``
-flag in the ``device_caps`` field of the
+Device nodes supporting the metadata capture interface set the
+``V4L2_CAP_META_CAPTURE`` flag in the ``device_caps`` field of the
 :c:type:`v4l2_capability` structure returned by the :c:func:`VIDIOC_QUERYCAP`
-ioctl. That flag means the device can capture metadata to memory.
+ioctl. That flag means the device can capture metadata to memory. Similarly,
+device nodes supporting metadata output interface set the
+``V4L2_CAP_META_OUTPUT`` flag in the ``device_caps`` field of
+:c:type:`v4l2_capability` structure. That flag means the device can read
+metadata from memory.
 
 At least one of the read/write or streaming I/O methods must be supported.
 
@@ -35,10 +41,11 @@ to the basic :ref:`format` ioctls, the :c:func:`VIDIOC_ENUM_FMT` ioctl must be
 supported as well.
 
 To use the :ref:`format` ioctls applications set the ``type`` field of the
-:c:type:`v4l2_format` structure to ``V4L2_BUF_TYPE_META_CAPTURE`` and use the
-:c:type:`v4l2_meta_format` ``meta`` member of the ``fmt`` union as needed per
-the desired operation. Both drivers and applications must set the remainder of
-the :c:type:`v4l2_format` structure to 0.
+:c:type:`v4l2_format` structure to ``V4L2_BUF_TYPE_META_CAPTURE`` or to
+``V4L2_BUF_TYPE_META_OUTPUT`` and use the :c:type:`v4l2_meta_format` ``meta``
+member of the ``fmt`` union as needed per the desired operation. Both drivers
+and applications must set the remainder of the :c:type:`v4l2_format` structure
+to 0.
 
 .. _v4l2-meta-format:
 
diff --git a/Documentation/media/uapi/v4l/vidioc-querycap.rst b/Documentation/media/uapi/v4l/vidioc-querycap.rst
index 12e0d9a..36bf879 100644
--- a/Documentation/media/uapi/v4l/vidioc-querycap.rst
+++ b/Documentation/media/uapi/v4l/vidioc-querycap.rst
@@ -249,6 +249,9 @@ specification the ioctl returns an ``EINVAL`` error code.
     * - ``V4L2_CAP_STREAMING``
       - 0x04000000
       - The device supports the :ref:`streaming <mmap>` I/O method.
+    * - ``V4L2_CAP_META_OUTPUT``
+      - 0x08000000
+      - The device supports the :ref:`metadata` output interface.
     * - ``V4L2_CAP_TOUCH``
       - 0x10000000
       - This is a touch device.
diff --git a/Documentation/media/videodev2.h.rst.exceptions b/Documentation/media/videodev2.h.rst.exceptions
index a5cb0a8..32172db 100644
--- a/Documentation/media/videodev2.h.rst.exceptions
+++ b/Documentation/media/videodev2.h.rst.exceptions
@@ -28,6 +28,7 @@ replace symbol V4L2_FIELD_TOP :c:type:`v4l2_field`
 
 # Documented enum v4l2_buf_type
 replace symbol V4L2_BUF_TYPE_META_CAPTURE :c:type:`v4l2_buf_type`
+replace symbol V4L2_BUF_TYPE_META_OUTPUT :c:type:`v4l2_buf_type`
 replace symbol V4L2_BUF_TYPE_SDR_CAPTURE :c:type:`v4l2_buf_type`
 replace symbol V4L2_BUF_TYPE_SDR_OUTPUT :c:type:`v4l2_buf_type`
 replace symbol V4L2_BUF_TYPE_SLICED_VBI_CAPTURE :c:type:`v4l2_buf_type`
@@ -157,6 +158,7 @@ replace define V4L2_CAP_META_CAPTURE device-capabilities
 replace define V4L2_CAP_READWRITE device-capabilities
 replace define V4L2_CAP_ASYNCIO device-capabilities
 replace define V4L2_CAP_STREAMING device-capabilities
+replace define V4L2_CAP_META_OUTPUT device-capabilities
 replace define V4L2_CAP_DEVICE_CAPS device-capabilities
 replace define V4L2_CAP_TOUCH device-capabilities
 
-- 
2.7.4
