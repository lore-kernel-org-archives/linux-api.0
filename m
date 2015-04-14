From: Laurent Pinchart <laurent.pinchart-ryLnwIuWjnjg/C1BVhZhaw@public.gmane.org>
Subject: [PATCH/RFC 2/2] videobuf2: Repurpose the v4l2_plane data_offset field
Date: Tue, 14 Apr 2015 22:44:49 +0300
Message-ID: <1429040689-23808-3-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1429040689-23808-1-git-send-email-laurent.pinchart@ideasonboard.com>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1429040689-23808-1-git-send-email-laurent.pinchart-ryLnwIuWjnjg/C1BVhZhaw@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-media-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Sakari Ailus <sakari.ailus-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Hans Verkuil <hverkuil-qWit8jRvyhVmR6Xm/wNWPw@public.gmane.org>, Pawel Osciak <pawel-FA/gS7QP4orQT0dZR+AlfA@public.gmane.org>, Marek Szyprowski <m.szyprowski-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>, Mauro Carvalho Chehab <mchehab-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
List-Id: linux-api@vger.kernel.org

The v4l2_plane data_offset field has been repurposed in the V4L2 API.
Update videobuf2 accordingly.

Signed-off-by: Laurent Pinchart <laurent.pinchart-ryLnwIuWjnjg/C1BVhZhaw@public.gmane.org>
---
 drivers/media/v4l2-core/videobuf2-core.c | 46 +++++++++++++++++++++++---------
 include/media/videobuf2-core.h           |  4 +++
 include/media/videobuf2-dma-contig.h     |  2 +-
 3 files changed, 39 insertions(+), 13 deletions(-)

diff --git a/drivers/media/v4l2-core/videobuf2-core.c b/drivers/media/v4l2-core/videobuf2-core.c
index 1329dcc..43f8fc5 100644
--- a/drivers/media/v4l2-core/videobuf2-core.c
+++ b/drivers/media/v4l2-core/videobuf2-core.c
@@ -572,15 +572,29 @@ static int __verify_planes_array(struct vb2_buffer *vb, const struct v4l2_buffer
 }
 
 /**
- * __verify_length() - Verify that the bytesused value for each plane fits in
- * the plane length and that the data offset doesn't exceed the bytesused value.
+ * __verify_length() - Verify for each plane that the data_offset matches driver
+ * constraints and that the bytesused plus data_offset value fits in the plane
+ * length.
  */
-static int __verify_length(struct vb2_buffer *vb, const struct v4l2_buffer *b)
+static int __verify_length(struct vb2_buffer *vb, struct v4l2_buffer *b)
 {
 	unsigned int length;
 	unsigned int bytesused;
+	unsigned int size;
 	unsigned int plane;
 
+	if (V4L2_TYPE_IS_MULTIPLANAR(b->type)) {
+		unsigned int mask = vb->vb2_queue->data_offset_mask;
+
+		for (plane = 0; plane < vb->num_planes; ++plane) {
+			if (b->m.planes[plane].data_offset & ~mask) {
+				if (!mask)
+					b->m.planes[plane].data_offset = 0;
+				return -EINVAL;
+			}
+		}
+	}
+
 	if (!V4L2_TYPE_IS_OUTPUT(b->type))
 		return 0;
 
@@ -590,14 +604,16 @@ static int __verify_length(struct vb2_buffer *vb, const struct v4l2_buffer *b)
 				  b->memory == V4L2_MEMORY_DMABUF)
 			       ? b->m.planes[plane].length
 			       : vb->v4l2_planes[plane].length;
-			bytesused = b->m.planes[plane].bytesused
-				  ? b->m.planes[plane].bytesused : length;
 
-			if (b->m.planes[plane].bytesused > length)
+			if (b->m.planes[plane].data_offset >= length)
 				return -EINVAL;
 
-			if (b->m.planes[plane].data_offset > 0 &&
-			    b->m.planes[plane].data_offset >= bytesused)
+			size = b->m.planes[plane].bytesused
+			     + b->m.planes[plane].data_offset;
+
+			/* Protect against integer overflows. */
+			if (size < b->m.planes[plane].bytesused ||
+			    size > length)
 				return -EINVAL;
 		}
 	} else {
@@ -1122,11 +1138,13 @@ EXPORT_SYMBOL_GPL(vb2_create_bufs);
  */
 void *vb2_plane_vaddr(struct vb2_buffer *vb, unsigned int plane_no)
 {
+	void *addr;
+
 	if (plane_no > vb->num_planes || !vb->planes[plane_no].mem_priv)
 		return NULL;
 
-	return call_ptr_memop(vb, vaddr, vb->planes[plane_no].mem_priv);
-
+	addr = call_ptr_memop(vb, vaddr, vb->planes[plane_no].mem_priv);
+	return addr + vb->v4l2_planes[plane_no].data_offset;
 }
 EXPORT_SYMBOL_GPL(vb2_plane_vaddr);
 
@@ -1258,6 +1276,11 @@ static void __fill_vb2_buffer(struct vb2_buffer *vb, const struct v4l2_buffer *b
 	}
 
 	if (V4L2_TYPE_IS_MULTIPLANAR(b->type)) {
+		for (plane = 0; plane < vb->num_planes; ++plane) {
+			v4l2_planes[plane].data_offset =
+				b->m.planes[plane].data_offset;
+		}
+
 		if (b->memory == V4L2_MEMORY_USERPTR) {
 			for (plane = 0; plane < vb->num_planes; ++plane) {
 				v4l2_planes[plane].m.userptr =
@@ -1302,7 +1325,6 @@ static void __fill_vb2_buffer(struct vb2_buffer *vb, const struct v4l2_buffer *b
 				else
 					pdst->bytesused = psrc->bytesused ?
 						psrc->bytesused : pdst->length;
-				pdst->data_offset = psrc->data_offset;
 			}
 		}
 	} else {
@@ -1618,7 +1640,7 @@ static void __enqueue_in_driver(struct vb2_buffer *vb)
 	call_void_vb_qop(vb, buf_queue, vb);
 }
 
-static int __buf_prepare(struct vb2_buffer *vb, const struct v4l2_buffer *b)
+static int __buf_prepare(struct vb2_buffer *vb, struct v4l2_buffer *b)
 {
 	struct vb2_queue *q = vb->vb2_queue;
 	int ret;
diff --git a/include/media/videobuf2-core.h b/include/media/videobuf2-core.h
index a5790fd..c51c481 100644
--- a/include/media/videobuf2-core.h
+++ b/include/media/videobuf2-core.h
@@ -362,6 +362,9 @@ struct v4l2_fh;
  *		start_streaming() can be called. Used when a DMA engine
  *		cannot be started unless at least this number of buffers
  *		have been queued into the driver.
+ * @data_offset_mask: the data_offset alignment constraints expressed as a
+ *		mask of bits that can be set in the data_offset value; "0"
+ *		indicates the driver doesn't support data_offset
  *
  * @mmap_lock:	private mutex used when buffers are allocated/freed/mmapped
  * @memory:	current memory type used
@@ -401,6 +404,7 @@ struct vb2_queue {
 	u32				timestamp_flags;
 	gfp_t				gfp_flags;
 	u32				min_buffers_needed;
+	u32				data_offset_mask;
 
 /* private: internal use only */
 	struct mutex			mmap_lock;
diff --git a/include/media/videobuf2-dma-contig.h b/include/media/videobuf2-dma-contig.h
index 8197f87..ff60fac 100644
--- a/include/media/videobuf2-dma-contig.h
+++ b/include/media/videobuf2-dma-contig.h
@@ -21,7 +21,7 @@ vb2_dma_contig_plane_dma_addr(struct vb2_buffer *vb, unsigned int plane_no)
 {
 	dma_addr_t *addr = vb2_plane_cookie(vb, plane_no);
 
-	return *addr;
+	return *addr + vb->v4l2_planes[plane_no].data_offset;
 }
 
 void *vb2_dma_contig_init_ctx(struct device *dev);
-- 
2.0.5
