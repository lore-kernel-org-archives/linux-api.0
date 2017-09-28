From: Sakari Ailus <sakari.ailus@linux.intel.com>
Subject: [PATCH v2 1/2] v4l: Add support for V4L2_BUF_TYPE_META_OUTPUT
Date: Thu, 28 Sep 2017 18:24:13 +0300
Message-ID: <1506612254-3946-2-git-send-email-sakari.ailus@linux.intel.com>
References: <1506612254-3946-1-git-send-email-sakari.ailus@linux.intel.com>
Return-path: <linux-media-owner@vger.kernel.org>
In-Reply-To: <1506612254-3946-1-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
To: linux-media@vger.kernel.org
Cc: linux-api@vger.kernel.org, tfiga@chromium.org, yong.zhi@intel.com
List-Id: linux-api@vger.kernel.org

The V4L2_BUF_TYPE_META_OUTPUT mirrors the V4L2_BUF_TYPE_META_CAPTURE with
the exception that it is an OUTPUT type. The use case for this is to pass
buffers to the device that are not image data but metadata. The formats,
just as the metadata capture formats, are typically device specific and
highly structured.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
Reviewed-by: Tomasz Figa <tfiga@chromium.org>
Tested-by: Tian Shu Qiu <tian.shu.qiu@intel.com>
---
 drivers/media/v4l2-core/v4l2-compat-ioctl32.c |  2 ++
 drivers/media/v4l2-core/v4l2-dev.c            | 12 ++++++++----
 drivers/media/v4l2-core/v4l2-ioctl.c          | 25 +++++++++++++++++++++++++
 drivers/media/v4l2-core/videobuf2-v4l2.c      |  1 +
 include/media/v4l2-ioctl.h                    | 17 +++++++++++++++++
 include/uapi/linux/videodev2.h                |  2 ++
 6 files changed, 55 insertions(+), 4 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-compat-ioctl32.c b/drivers/media/v4l2-core/v4l2-compat-ioctl32.c
index 821f2aa..9f5c7d4 100644
--- a/drivers/media/v4l2-core/v4l2-compat-ioctl32.c
+++ b/drivers/media/v4l2-core/v4l2-compat-ioctl32.c
@@ -235,6 +235,7 @@ static int __get_v4l2_format32(struct v4l2_format *kp, struct v4l2_format32 __us
 	case V4L2_BUF_TYPE_SDR_OUTPUT:
 		return get_v4l2_sdr_format(&kp->fmt.sdr, &up->fmt.sdr);
 	case V4L2_BUF_TYPE_META_CAPTURE:
+	case V4L2_BUF_TYPE_META_OUTPUT:
 		return get_v4l2_meta_format(&kp->fmt.meta, &up->fmt.meta);
 	default:
 		pr_info("compat_ioctl32: unexpected VIDIOC_FMT type %d\n",
@@ -284,6 +285,7 @@ static int __put_v4l2_format32(struct v4l2_format *kp, struct v4l2_format32 __us
 	case V4L2_BUF_TYPE_SDR_OUTPUT:
 		return put_v4l2_sdr_format(&kp->fmt.sdr, &up->fmt.sdr);
 	case V4L2_BUF_TYPE_META_CAPTURE:
+	case V4L2_BUF_TYPE_META_OUTPUT:
 		return put_v4l2_meta_format(&kp->fmt.meta, &up->fmt.meta);
 	default:
 		pr_info("compat_ioctl32: unexpected VIDIOC_FMT type %d\n",
diff --git a/drivers/media/v4l2-core/v4l2-dev.c b/drivers/media/v4l2-core/v4l2-dev.c
index c647ba6..3660cb8 100644
--- a/drivers/media/v4l2-core/v4l2-dev.c
+++ b/drivers/media/v4l2-core/v4l2-dev.c
@@ -581,7 +581,8 @@ static void determine_valid_ioctls(struct video_device *vdev)
 			       ops->vidioc_enum_fmt_vid_overlay ||
 			       ops->vidioc_enum_fmt_meta_cap)) ||
 		    (is_tx && (ops->vidioc_enum_fmt_vid_out ||
-			       ops->vidioc_enum_fmt_vid_out_mplane)))
+			       ops->vidioc_enum_fmt_vid_out_mplane ||
+			       ops->vidioc_enum_fmt_meta_out)))
 			set_bit(_IOC_NR(VIDIOC_ENUM_FMT), valid_ioctls);
 		if ((is_rx && (ops->vidioc_g_fmt_vid_cap ||
 			       ops->vidioc_g_fmt_vid_cap_mplane ||
@@ -589,7 +590,8 @@ static void determine_valid_ioctls(struct video_device *vdev)
 			       ops->vidioc_g_fmt_meta_cap)) ||
 		    (is_tx && (ops->vidioc_g_fmt_vid_out ||
 			       ops->vidioc_g_fmt_vid_out_mplane ||
-			       ops->vidioc_g_fmt_vid_out_overlay)))
+			       ops->vidioc_g_fmt_vid_out_overlay ||
+			       ops->vidioc_g_fmt_meta_out)))
 			 set_bit(_IOC_NR(VIDIOC_G_FMT), valid_ioctls);
 		if ((is_rx && (ops->vidioc_s_fmt_vid_cap ||
 			       ops->vidioc_s_fmt_vid_cap_mplane ||
@@ -597,7 +599,8 @@ static void determine_valid_ioctls(struct video_device *vdev)
 			       ops->vidioc_s_fmt_meta_cap)) ||
 		    (is_tx && (ops->vidioc_s_fmt_vid_out ||
 			       ops->vidioc_s_fmt_vid_out_mplane ||
-			       ops->vidioc_s_fmt_vid_out_overlay)))
+			       ops->vidioc_s_fmt_vid_out_overlay ||
+			       ops->vidioc_s_fmt_meta_out)))
 			 set_bit(_IOC_NR(VIDIOC_S_FMT), valid_ioctls);
 		if ((is_rx && (ops->vidioc_try_fmt_vid_cap ||
 			       ops->vidioc_try_fmt_vid_cap_mplane ||
@@ -605,7 +608,8 @@ static void determine_valid_ioctls(struct video_device *vdev)
 			       ops->vidioc_try_fmt_meta_cap)) ||
 		    (is_tx && (ops->vidioc_try_fmt_vid_out ||
 			       ops->vidioc_try_fmt_vid_out_mplane ||
-			       ops->vidioc_try_fmt_vid_out_overlay)))
+			       ops->vidioc_try_fmt_vid_out_overlay ||
+			       ops->vidioc_try_fmt_meta_out)))
 			 set_bit(_IOC_NR(VIDIOC_TRY_FMT), valid_ioctls);
 		SET_VALID_IOCTL(ops, VIDIOC_OVERLAY, vidioc_overlay);
 		SET_VALID_IOCTL(ops, VIDIOC_G_FBUF, vidioc_g_fbuf);
diff --git a/drivers/media/v4l2-core/v4l2-ioctl.c b/drivers/media/v4l2-core/v4l2-ioctl.c
index 7961499..d6587b3 100644
--- a/drivers/media/v4l2-core/v4l2-ioctl.c
+++ b/drivers/media/v4l2-core/v4l2-ioctl.c
@@ -157,6 +157,7 @@ const char *v4l2_type_names[] = {
 	[V4L2_BUF_TYPE_SDR_CAPTURE]        = "sdr-cap",
 	[V4L2_BUF_TYPE_SDR_OUTPUT]         = "sdr-out",
 	[V4L2_BUF_TYPE_META_CAPTURE]       = "meta-cap",
+	[V4L2_BUF_TYPE_META_OUTPUT]	   = "meta-out",
 };
 EXPORT_SYMBOL(v4l2_type_names);
 
@@ -329,6 +330,7 @@ static void v4l_print_format(const void *arg, bool write_only)
 			(sdr->pixelformat >> 24) & 0xff);
 		break;
 	case V4L2_BUF_TYPE_META_CAPTURE:
+	case V4L2_BUF_TYPE_META_OUTPUT:
 		meta = &p->fmt.meta;
 		pr_cont(", dataformat=%c%c%c%c, buffersize=%u\n",
 			(meta->dataformat >>  0) & 0xff,
@@ -962,6 +964,10 @@ static int check_fmt(struct file *file, enum v4l2_buf_type type)
 		if (is_vid && is_rx && ops->vidioc_g_fmt_meta_cap)
 			return 0;
 		break;
+	case V4L2_BUF_TYPE_META_OUTPUT:
+		if (is_vid && is_tx && ops->vidioc_g_fmt_meta_out)
+			return 0;
+		break;
 	default:
 		break;
 	}
@@ -1360,6 +1366,11 @@ static int v4l_enum_fmt(const struct v4l2_ioctl_ops *ops,
 			break;
 		ret = ops->vidioc_enum_fmt_meta_cap(file, fh, arg);
 		break;
+	case V4L2_BUF_TYPE_META_OUTPUT:
+		if (unlikely(!is_tx || !is_vid || !ops->vidioc_enum_fmt_meta_out))
+			break;
+		ret = ops->vidioc_enum_fmt_meta_out(file, fh, arg);
+		break;
 	}
 	if (ret == 0)
 		v4l_fill_fmtdesc(p);
@@ -1463,6 +1474,10 @@ static int v4l_g_fmt(const struct v4l2_ioctl_ops *ops,
 		if (unlikely(!is_rx || !is_vid || !ops->vidioc_g_fmt_meta_cap))
 			break;
 		return ops->vidioc_g_fmt_meta_cap(file, fh, arg);
+	case V4L2_BUF_TYPE_META_OUTPUT:
+		if (unlikely(!is_tx || !is_vid || !ops->vidioc_g_fmt_meta_out))
+			break;
+		return ops->vidioc_g_fmt_meta_out(file, fh, arg);
 	}
 	return -EINVAL;
 }
@@ -1573,6 +1588,11 @@ static int v4l_s_fmt(const struct v4l2_ioctl_ops *ops,
 			break;
 		CLEAR_AFTER_FIELD(p, fmt.meta);
 		return ops->vidioc_s_fmt_meta_cap(file, fh, arg);
+	case V4L2_BUF_TYPE_META_OUTPUT:
+		if (unlikely(!is_tx || !is_vid || !ops->vidioc_s_fmt_meta_out))
+			break;
+		CLEAR_AFTER_FIELD(p, fmt.meta);
+		return ops->vidioc_s_fmt_meta_out(file, fh, arg);
 	}
 	return -EINVAL;
 }
@@ -1663,6 +1683,11 @@ static int v4l_try_fmt(const struct v4l2_ioctl_ops *ops,
 			break;
 		CLEAR_AFTER_FIELD(p, fmt.meta);
 		return ops->vidioc_try_fmt_meta_cap(file, fh, arg);
+	case V4L2_BUF_TYPE_META_OUTPUT:
+		if (unlikely(!is_tx || !is_vid || !ops->vidioc_try_fmt_meta_out))
+			break;
+		CLEAR_AFTER_FIELD(p, fmt.meta);
+		return ops->vidioc_try_fmt_meta_out(file, fh, arg);
 	}
 	return -EINVAL;
 }
diff --git a/drivers/media/v4l2-core/videobuf2-v4l2.c b/drivers/media/v4l2-core/videobuf2-v4l2.c
index 0c06699..f17f6d7 100644
--- a/drivers/media/v4l2-core/videobuf2-v4l2.c
+++ b/drivers/media/v4l2-core/videobuf2-v4l2.c
@@ -545,6 +545,7 @@ int vb2_create_bufs(struct vb2_queue *q, struct v4l2_create_buffers *create)
 		requested_sizes[0] = f->fmt.sdr.buffersize;
 		break;
 	case V4L2_BUF_TYPE_META_CAPTURE:
+	case V4L2_BUF_TYPE_META_OUTPUT:
 		requested_sizes[0] = f->fmt.meta.buffersize;
 		break;
 	default:
diff --git a/include/media/v4l2-ioctl.h b/include/media/v4l2-ioctl.h
index bd53121..696bd13 100644
--- a/include/media/v4l2-ioctl.h
+++ b/include/media/v4l2-ioctl.h
@@ -47,6 +47,9 @@ struct v4l2_fh;
  * @vidioc_enum_fmt_meta_cap: pointer to the function that implements
  *	:ref:`VIDIOC_ENUM_FMT <vidioc_enum_fmt>` ioctl logic
  *	for metadata capture
+ * @vidioc_enum_fmt_meta_out: pointer to the function that implements
+ *	:ref:`VIDIOC_ENUM_FMT <vidioc_enum_fmt>` ioctl logic
+ *	for metadata output
  * @vidioc_g_fmt_vid_cap: pointer to the function that implements
  *	:ref:`VIDIOC_G_FMT <vidioc_g_fmt>` ioctl logic for video capture
  *	in single plane mode
@@ -79,6 +82,8 @@ struct v4l2_fh;
  *	Radio output
  * @vidioc_g_fmt_meta_cap: pointer to the function that implements
  *	:ref:`VIDIOC_G_FMT <vidioc_g_fmt>` ioctl logic for metadata capture
+ * @vidioc_g_fmt_meta_out: pointer to the function that implements
+ *	:ref:`VIDIOC_G_FMT <vidioc_g_fmt>` ioctl logic for metadata output
  * @vidioc_s_fmt_vid_cap: pointer to the function that implements
  *	:ref:`VIDIOC_S_FMT <vidioc_g_fmt>` ioctl logic for video capture
  *	in single plane mode
@@ -111,6 +116,8 @@ struct v4l2_fh;
  *	Radio output
  * @vidioc_s_fmt_meta_cap: pointer to the function that implements
  *	:ref:`VIDIOC_S_FMT <vidioc_g_fmt>` ioctl logic for metadata capture
+ * @vidioc_s_fmt_meta_out: pointer to the function that implements
+ *	:ref:`VIDIOC_S_FMT <vidioc_g_fmt>` ioctl logic for metadata output
  * @vidioc_try_fmt_vid_cap: pointer to the function that implements
  *	:ref:`VIDIOC_TRY_FMT <vidioc_g_fmt>` ioctl logic for video capture
  *	in single plane mode
@@ -145,6 +152,8 @@ struct v4l2_fh;
  *	Radio output
  * @vidioc_try_fmt_meta_cap: pointer to the function that implements
  *	:ref:`VIDIOC_TRY_FMT <vidioc_g_fmt>` ioctl logic for metadata capture
+ * @vidioc_try_fmt_meta_out: pointer to the function that implements
+ *	:ref:`VIDIOC_TRY_FMT <vidioc_g_fmt>` ioctl logic for metadata output
  * @vidioc_reqbufs: pointer to the function that implements
  *	:ref:`VIDIOC_REQBUFS <vidioc_reqbufs>` ioctl
  * @vidioc_querybuf: pointer to the function that implements
@@ -317,6 +326,8 @@ struct v4l2_ioctl_ops {
 				       struct v4l2_fmtdesc *f);
 	int (*vidioc_enum_fmt_meta_cap)(struct file *file, void *fh,
 					struct v4l2_fmtdesc *f);
+	int (*vidioc_enum_fmt_meta_out)(struct file *file, void *fh,
+					struct v4l2_fmtdesc *f);
 
 	/* VIDIOC_G_FMT handlers */
 	int (*vidioc_g_fmt_vid_cap)(struct file *file, void *fh,
@@ -345,6 +356,8 @@ struct v4l2_ioctl_ops {
 				    struct v4l2_format *f);
 	int (*vidioc_g_fmt_meta_cap)(struct file *file, void *fh,
 				     struct v4l2_format *f);
+	int (*vidioc_g_fmt_meta_out)(struct file *file, void *fh,
+				     struct v4l2_format *f);
 
 	/* VIDIOC_S_FMT handlers */
 	int (*vidioc_s_fmt_vid_cap)(struct file *file, void *fh,
@@ -373,6 +386,8 @@ struct v4l2_ioctl_ops {
 				    struct v4l2_format *f);
 	int (*vidioc_s_fmt_meta_cap)(struct file *file, void *fh,
 				     struct v4l2_format *f);
+	int (*vidioc_s_fmt_meta_out)(struct file *file, void *fh,
+				     struct v4l2_format *f);
 
 	/* VIDIOC_TRY_FMT handlers */
 	int (*vidioc_try_fmt_vid_cap)(struct file *file, void *fh,
@@ -401,6 +416,8 @@ struct v4l2_ioctl_ops {
 				      struct v4l2_format *f);
 	int (*vidioc_try_fmt_meta_cap)(struct file *file, void *fh,
 				       struct v4l2_format *f);
+	int (*vidioc_try_fmt_meta_out)(struct file *file, void *fh,
+				       struct v4l2_format *f);
 
 	/* Buffer handlers */
 	int (*vidioc_reqbufs)(struct file *file, void *fh,
diff --git a/include/uapi/linux/videodev2.h b/include/uapi/linux/videodev2.h
index 185d6a0..e507b29 100644
--- a/include/uapi/linux/videodev2.h
+++ b/include/uapi/linux/videodev2.h
@@ -144,6 +144,7 @@ enum v4l2_buf_type {
 	V4L2_BUF_TYPE_SDR_CAPTURE          = 11,
 	V4L2_BUF_TYPE_SDR_OUTPUT           = 12,
 	V4L2_BUF_TYPE_META_CAPTURE         = 13,
+	V4L2_BUF_TYPE_META_OUTPUT	   = 14,
 	/* Deprecated, do not use */
 	V4L2_BUF_TYPE_PRIVATE              = 0x80,
 };
@@ -457,6 +458,7 @@ struct v4l2_capability {
 #define V4L2_CAP_READWRITE              0x01000000  /* read/write systemcalls */
 #define V4L2_CAP_ASYNCIO                0x02000000  /* async I/O */
 #define V4L2_CAP_STREAMING              0x04000000  /* streaming I/O ioctls */
+#define V4L2_CAP_META_OUTPUT		0x08000000  /* Is a metadata output device */
 
 #define V4L2_CAP_TOUCH                  0x10000000  /* Is a touch device */
 
-- 
2.7.4
