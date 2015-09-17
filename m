From: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
Subject: [PATCH v2 8/9] [media] handle 64-bit time_t in v4l2_buffer
Date: Thu, 17 Sep 2015 23:19:39 +0200
Message-ID: <1442524780-781677-9-git-send-email-arnd@arndb.de>
References: <1442524780-781677-1-git-send-email-arnd@arndb.de>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1442524780-781677-1-git-send-email-arnd-r2nGTMty4D4@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-media-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, y2038-cunTk1MwBs8s++Sfvej+rw@public.gmane.org, Mauro Carvalho Chehab <mchehab-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-samsung-soc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Hans Verkuil <hverkuil-qWit8jRvyhVmR6Xm/wNWPw@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
List-Id: linux-api@vger.kernel.org

This is the final change to enable user space with 64-bit time_t
in the core v4l2 code.

Four ioctls are affected here: VIDIOC_QUERYBUF, VIDIOC_QBUF,
VIDIOC_DQBUF, and VIDIOC_PREPARE_BUF. All of them pass a
struct v4l2_buffer, which can either contain a 32-bit time_t
or a 64-bit time on 32-bit architectures.

In this patch, we redefine the in-kernel version of this structure
to use the 64-bit __s64 type through the use of v4l2_timeval.
This means the normal ioctl handling now assumes 64-bit time_t
and so we have to add support for 32-bit time_t in new handlers.

This is somewhat similar to the 32-bit compat handling on 64-bit
architectures, but those also have to modify other fields of
the structure. For now, I leave that compat code alone, as it
handles the normal case (32-bit compat_time_t) correctly, this
has to be done as a follow-up.

Signed-off-by: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
---
 drivers/media/v4l2-core/v4l2-ioctl.c | 174 +++++++++++++++++++++++++++++++++--
 include/uapi/linux/videodev2.h       |  34 ++++++-
 2 files changed, 199 insertions(+), 9 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-ioctl.c b/drivers/media/v4l2-core/v4l2-ioctl.c
index 7aab18dd2ca5..137475c28e8f 100644
--- a/drivers/media/v4l2-core/v4l2-ioctl.c
+++ b/drivers/media/v4l2-core/v4l2-ioctl.c
@@ -438,15 +438,14 @@ static void v4l_print_buffer(const void *arg, bool write_only)
 	const struct v4l2_timecode *tc = &p->timecode;
 	const struct v4l2_plane *plane;
 	int i;
+	/* y2038 safe because of monotonic time */
+	unsigned int seconds = p->timestamp.tv_sec;
 
-	pr_cont("%02ld:%02d:%02d.%08ld index=%d, type=%s, "
+	pr_cont("%02d:%02d:%02d.%08ld index=%d, type=%s, "
 		"flags=0x%08x, field=%s, sequence=%d, memory=%s",
-			p->timestamp.tv_sec / 3600,
-			(int)(p->timestamp.tv_sec / 60) % 60,
-			(int)(p->timestamp.tv_sec % 60),
-			(long)p->timestamp.tv_usec,
-			p->index,
-			prt_names(p->type, v4l2_type_names),
+			seconds / 3600, (seconds / 60) % 60,
+			seconds % 60, (long)p->timestamp.tv_usec,
+			p->index, prt_names(p->type, v4l2_type_names),
 			p->flags, prt_names(p->field, v4l2_field_names),
 			p->sequence, prt_names(p->memory, v4l2_memory_names));
 
@@ -1846,6 +1845,123 @@ static int v4l_prepare_buf(const struct v4l2_ioctl_ops *ops,
 	return ret ? ret : ops->vidioc_prepare_buf(file, fh, b);
 }
 
+#ifndef CONFIG_64BIT
+static void v4l_get_buffer_time32(struct v4l2_buffer *to,
+				  const struct v4l2_buffer_time32 *from)
+{
+	to->index		= from->index;
+	to->type		= from->type;
+	to->bytesused		= from->bytesused;
+	to->flags		= from->flags;
+	to->field		= from->field;
+	to->timestamp.tv_sec	= from->timestamp.tv_sec;
+	to->timestamp.tv_usec	= from->timestamp.tv_usec;
+	to->timecode		= from->timecode;
+	to->sequence		= from->sequence;
+	to->memory		= from->memory;
+	to->m.offset		= from->m.offset;
+	to->length		= from->length;
+	to->reserved2		= from->reserved2;
+	to->reserved		= from->reserved;
+}
+
+static void v4l_put_buffer_time32(struct v4l2_buffer_time32 *to,
+				  const struct v4l2_buffer *from)
+{
+	to->index		= from->index;
+	to->type		= from->type;
+	to->bytesused		= from->bytesused;
+	to->flags		= from->flags;
+	to->field		= from->field;
+	to->timestamp.tv_sec	= from->timestamp.tv_sec;
+	to->timestamp.tv_usec	= from->timestamp.tv_usec;
+	to->timecode		= from->timecode;
+	to->sequence		= from->sequence;
+	to->memory		= from->memory;
+	to->m.offset		= from->m.offset;
+	to->length		= from->length;
+	to->reserved2		= from->reserved2;
+	to->reserved		= from->reserved;
+}
+
+static int v4l_querybuf_time32(const struct v4l2_ioctl_ops *ops,
+				struct file *file, void *fh, void *arg)
+{
+	struct v4l2_buffer buffer;
+	int ret;
+
+	v4l_get_buffer_time32(&buffer, arg);
+	ret = v4l_querybuf(ops, file, fh, &buffer);
+	v4l_put_buffer_time32(arg, &buffer);
+
+	return ret;
+}
+
+static int v4l_qbuf_time32(const struct v4l2_ioctl_ops *ops,
+				struct file *file, void *fh, void *arg)
+{
+	struct v4l2_buffer buffer;
+	int ret;
+
+	v4l_get_buffer_time32(&buffer, arg);
+	ret = v4l_qbuf(ops, file, fh, &buffer);
+	v4l_put_buffer_time32(arg, &buffer);
+
+	return ret;
+}
+
+static int v4l_dqbuf_time32(const struct v4l2_ioctl_ops *ops,
+				struct file *file, void *fh, void *arg)
+{
+	struct v4l2_buffer buffer;
+	int ret;
+
+	v4l_get_buffer_time32(&buffer, arg);
+	ret = v4l_dqbuf(ops, file, fh, &buffer);
+	v4l_put_buffer_time32(arg, &buffer);
+
+	return ret;
+}
+
+static int v4l_prepare_buf_time32(const struct v4l2_ioctl_ops *ops,
+				struct file *file, void *fh, void *arg)
+{
+	struct v4l2_buffer buffer;
+	int ret;
+
+	v4l_get_buffer_time32(&buffer, arg);
+	ret = v4l_prepare_buf(ops, file, fh, &buffer);
+
+	return ret;
+}
+
+static void v4l_print_buffer_time32(const void *arg, bool write_only)
+{
+	struct v4l2_buffer buffer;
+
+	v4l_get_buffer_time32(&buffer, arg);
+	v4l_print_buffer(&buffer, write_only);
+}
+
+#ifdef CONFIG_TRACEPOINTS
+static void trace_v4l2_dqbuf_time32(int minor, const struct v4l2_buffer_time32 *arg)
+{
+	struct v4l2_buffer buffer;
+
+	v4l_get_buffer_time32(&buffer, arg);
+	trace_v4l2_dqbuf(minor, &buffer);
+}
+
+static void trace_v4l2_qbuf_time32(int minor, const struct v4l2_buffer_time32 *arg)
+{
+	struct v4l2_buffer buffer;
+
+	v4l_get_buffer_time32(&buffer, arg);
+	trace_v4l2_qbuf(minor, &buffer);
+}
+#endif
+#endif
+
 static int v4l_g_parm(const struct v4l2_ioctl_ops *ops,
 				struct file *file, void *fh, void *arg)
 {
@@ -2408,12 +2524,21 @@ static struct v4l2_ioctl_info v4l2_ioctls[] = {
 	IOCTL_INFO_FNC(VIDIOC_S_FMT, v4l_s_fmt, v4l_print_format, INFO_FL_PRIO),
 	IOCTL_INFO_FNC(VIDIOC_REQBUFS, v4l_reqbufs, v4l_print_requestbuffers, INFO_FL_PRIO | INFO_FL_QUEUE),
 	IOCTL_INFO_FNC(VIDIOC_QUERYBUF, v4l_querybuf, v4l_print_buffer, INFO_FL_QUEUE | INFO_FL_CLEAR(v4l2_buffer, length)),
+#ifndef CONFIG_64BIT
+	IOCTL_INFO_FNC(VIDIOC_QUERYBUF_TIME32, v4l_querybuf_time32, v4l_print_buffer_time32, INFO_FL_QUEUE | INFO_FL_CLEAR(v4l2_buffer, length)),
+#endif
 	IOCTL_INFO_STD(VIDIOC_G_FBUF, vidioc_g_fbuf, v4l_print_framebuffer, 0),
 	IOCTL_INFO_STD(VIDIOC_S_FBUF, vidioc_s_fbuf, v4l_print_framebuffer, INFO_FL_PRIO),
 	IOCTL_INFO_FNC(VIDIOC_OVERLAY, v4l_overlay, v4l_print_u32, INFO_FL_PRIO),
 	IOCTL_INFO_FNC(VIDIOC_QBUF, v4l_qbuf, v4l_print_buffer, INFO_FL_QUEUE),
+#ifndef CONFIG_64BIT
+	IOCTL_INFO_FNC(VIDIOC_QBUF_TIME32, v4l_qbuf_time32, v4l_print_buffer_time32, INFO_FL_QUEUE),
+#endif
 	IOCTL_INFO_STD(VIDIOC_EXPBUF, vidioc_expbuf, v4l_print_exportbuffer, INFO_FL_QUEUE | INFO_FL_CLEAR(v4l2_exportbuffer, flags)),
 	IOCTL_INFO_FNC(VIDIOC_DQBUF, v4l_dqbuf, v4l_print_buffer, INFO_FL_QUEUE),
+#ifndef CONFIG_64BIT
+	IOCTL_INFO_FNC(VIDIOC_DQBUF_TIME32, v4l_dqbuf_time32, v4l_print_buffer_time32, INFO_FL_QUEUE),
+#endif
 	IOCTL_INFO_FNC(VIDIOC_STREAMON, v4l_streamon, v4l_print_buftype, INFO_FL_PRIO | INFO_FL_QUEUE),
 	IOCTL_INFO_FNC(VIDIOC_STREAMOFF, v4l_streamoff, v4l_print_buftype, INFO_FL_PRIO | INFO_FL_QUEUE),
 	IOCTL_INFO_FNC(VIDIOC_G_PARM, v4l_g_parm, v4l_print_streamparm, INFO_FL_CLEAR(v4l2_streamparm, type)),
@@ -2479,6 +2604,9 @@ static struct v4l2_ioctl_info v4l2_ioctls[] = {
 	IOCTL_INFO_FNC(VIDIOC_UNSUBSCRIBE_EVENT, v4l_unsubscribe_event, v4l_print_event_subscription, 0),
 	IOCTL_INFO_FNC(VIDIOC_CREATE_BUFS, v4l_create_bufs, v4l_print_create_buffers, INFO_FL_PRIO | INFO_FL_QUEUE),
 	IOCTL_INFO_FNC(VIDIOC_PREPARE_BUF, v4l_prepare_buf, v4l_print_buffer, INFO_FL_QUEUE),
+#ifndef CONFIG_64BIT
+	IOCTL_INFO_FNC(VIDIOC_PREPARE_BUF_TIME32, v4l_prepare_buf_time32, v4l_print_buffer_time32, INFO_FL_QUEUE),
+#endif
 	IOCTL_INFO_STD(VIDIOC_ENUM_DV_TIMINGS, vidioc_enum_dv_timings, v4l_print_enum_dv_timings, 0),
 	IOCTL_INFO_STD(VIDIOC_QUERY_DV_TIMINGS, vidioc_query_dv_timings, v4l_print_dv_timings, 0),
 	IOCTL_INFO_STD(VIDIOC_DV_TIMINGS_CAP, vidioc_dv_timings_cap, v4l_print_dv_timings_cap, INFO_FL_CLEAR(v4l2_dv_timings_cap, type)),
@@ -2608,6 +2736,12 @@ done:
 		    (cmd == VIDIOC_QBUF || cmd == VIDIOC_DQBUF))
 			return ret;
 
+#ifndef CONFIG_64BIT
+		if (!(dev_debug & V4L2_DEV_DEBUG_STREAMING) &&
+		    (cmd == VIDIOC_QBUF_TIME32 || cmd == VIDIOC_DQBUF_TIME32))
+			return ret;
+#endif
+
 		v4l_printk_ioctl(video_device_node_name(vfd), cmd);
 		if (ret < 0)
 			pr_cont(": error %ld", ret);
@@ -2630,6 +2764,26 @@ static int check_array_args(unsigned int cmd, void *parg, size_t *array_size,
 	int ret = 0;
 
 	switch (cmd) {
+#ifndef CONFIG_64BIT
+	case VIDIOC_PREPARE_BUF_TIME32:
+	case VIDIOC_QUERYBUF_TIME32:
+	case VIDIOC_QBUF_TIME32:
+	case VIDIOC_DQBUF_TIME32: {
+		struct v4l2_buffer_time32 *buf = parg;
+
+		if (V4L2_TYPE_IS_MULTIPLANAR(buf->type) && buf->length > 0) {
+			if (buf->length > VIDEO_MAX_PLANES) {
+				ret = -EINVAL;
+				break;
+			}
+			*user_ptr = (void __user *)buf->m.planes;
+			*kernel_ptr = (void **)&buf->m.planes;
+			*array_size = sizeof(struct v4l2_plane) * buf->length;
+			ret = 1;
+		}
+		break;
+	}
+#endif
 	case VIDIOC_PREPARE_BUF:
 	case VIDIOC_QUERYBUF:
 	case VIDIOC_QBUF:
@@ -2774,6 +2928,12 @@ video_usercopy(struct file *file, unsigned int cmd, unsigned long arg,
 			trace_v4l2_dqbuf(video_devdata(file)->minor, parg);
 		else if (cmd == VIDIOC_QBUF)
 			trace_v4l2_qbuf(video_devdata(file)->minor, parg);
+#ifndef CONFIG_64BIT
+		else if (cmd == VIDIOC_DQBUF_TIME32)
+			trace_v4l2_dqbuf_time32(video_devdata(file)->minor, parg);
+		else if (cmd == VIDIOC_QBUF_TIME32)
+			trace_v4l2_qbuf_time32(video_devdata(file)->minor, parg);
+#endif
 	}
 
 	if (has_array_args) {
diff --git a/include/uapi/linux/videodev2.h b/include/uapi/linux/videodev2.h
index 450b3249ba30..0d3688a97ab8 100644
--- a/include/uapi/linux/videodev2.h
+++ b/include/uapi/linux/videodev2.h
@@ -811,8 +811,8 @@ struct v4l2_plane {
  * time_t, so we have to convert it when accessing user data.
  */
 struct v4l2_timeval {
-	long tv_sec;
-	long tv_usec;
+	__s64 tv_sec;
+	__s64 tv_usec;
 };
 #endif
 
@@ -873,6 +873,32 @@ struct v4l2_buffer {
 	__u32			reserved;
 };
 
+struct v4l2_buffer_time32 {
+	__u32			index;
+	__u32			type;
+	__u32			bytesused;
+	__u32			flags;
+	__u32			field;
+	struct {
+		__s32		tv_sec;
+		__s32		tv_usec;
+	}			timestamp;
+	struct v4l2_timecode	timecode;
+	__u32			sequence;
+
+	/* memory location */
+	__u32			memory;
+	union {
+		__u32           offset;
+		unsigned long   userptr;
+		struct v4l2_plane *planes;
+		__s32		fd;
+	} m;
+	__u32			length;
+	__u32			reserved2;
+	__u32			reserved;
+};
+
 /*  Flags for 'flags' field */
 /* Buffer is mapped (flag) */
 #define V4L2_BUF_FLAG_MAPPED			0x00000001
@@ -2216,12 +2242,15 @@ struct v4l2_create_buffers {
 #define VIDIOC_S_FMT		_IOWR('V',  5, struct v4l2_format)
 #define VIDIOC_REQBUFS		_IOWR('V',  8, struct v4l2_requestbuffers)
 #define VIDIOC_QUERYBUF		_IOWR('V',  9, struct v4l2_buffer)
+#define VIDIOC_QUERYBUF_TIME32	_IOWR('V',  9, struct v4l2_buffer_time32)
 #define VIDIOC_G_FBUF		 _IOR('V', 10, struct v4l2_framebuffer)
 #define VIDIOC_S_FBUF		 _IOW('V', 11, struct v4l2_framebuffer)
 #define VIDIOC_OVERLAY		 _IOW('V', 14, int)
 #define VIDIOC_QBUF		_IOWR('V', 15, struct v4l2_buffer)
+#define VIDIOC_QBUF_TIME32	_IOWR('V', 15, struct v4l2_buffer_time32)
 #define VIDIOC_EXPBUF		_IOWR('V', 16, struct v4l2_exportbuffer)
 #define VIDIOC_DQBUF		_IOWR('V', 17, struct v4l2_buffer)
+#define VIDIOC_DQBUF_TIME32	_IOWR('V', 17, struct v4l2_buffer_time32)
 #define VIDIOC_STREAMON		 _IOW('V', 18, int)
 #define VIDIOC_STREAMOFF	 _IOW('V', 19, int)
 #define VIDIOC_G_PARM		_IOWR('V', 21, struct v4l2_streamparm)
@@ -2292,6 +2321,7 @@ struct v4l2_create_buffers {
    versions */
 #define VIDIOC_CREATE_BUFS	_IOWR('V', 92, struct v4l2_create_buffers)
 #define VIDIOC_PREPARE_BUF	_IOWR('V', 93, struct v4l2_buffer)
+#define VIDIOC_PREPARE_BUF_TIME32 _IOWR('V', 93, struct v4l2_buffer_time32)
 
 /* Experimental selection API */
 #define VIDIOC_G_SELECTION	_IOWR('V', 94, struct v4l2_selection)
-- 
2.1.0.rc2
