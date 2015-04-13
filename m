From: Laurent Pinchart <laurent.pinchart+renesas-ryLnwIuWjnjg/C1BVhZhaw@public.gmane.org>
Subject: [RFC/PATCH v2 2/5] drm: Connect live source to framebuffers
Date: Mon, 13 Apr 2015 21:39:44 +0300
Message-ID: <1428950387-6913-3-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
References: <1428950387-6913-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1428950387-6913-1-git-send-email-laurent.pinchart+renesas-ryLnwIuWjnjg/C1BVhZhaw@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org
Cc: linux-media-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-sh-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Magnus Damm <magnus.damm-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Daniel Vetter <daniel.vetter-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Introduce a new live source flag for framebuffers. When a framebuffer is
created with that flag set, a live source is associated with the
framebuffer instead of buffer objects. The framebuffer can then be used
with a plane to connect it with the live source.

Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas-ryLnwIuWjnjg/C1BVhZhaw@public.gmane.org>
---
 drivers/gpu/drm/drm_crtc.c  | 123 +++++++++++++++++++++++++++++++++++---------
 include/uapi/drm/drm_mode.h |   7 +++
 2 files changed, 107 insertions(+), 23 deletions(-)

diff --git a/drivers/gpu/drm/drm_crtc.c b/drivers/gpu/drm/drm_crtc.c
index 1f71978b4f17..838fd5051a00 100644
--- a/drivers/gpu/drm/drm_crtc.c
+++ b/drivers/gpu/drm/drm_crtc.c
@@ -3408,31 +3408,13 @@ static int format_check(const struct drm_mode_fb_cmd2 *r)
 	}
 }
 
-static int framebuffer_check(const struct drm_mode_fb_cmd2 *r)
+static int framebuffer_check_buffers(const struct drm_mode_fb_cmd2 *r,
+				     int hsub, int vsub)
 {
-	int ret, hsub, vsub, num_planes, i;
+	int num_planes, i;
 
-	ret = format_check(r);
-	if (ret) {
-		DRM_DEBUG_KMS("bad framebuffer format %s\n",
-			      drm_get_format_name(r->pixel_format));
-		return ret;
-	}
-
-	hsub = drm_format_horz_chroma_subsampling(r->pixel_format);
-	vsub = drm_format_vert_chroma_subsampling(r->pixel_format);
 	num_planes = drm_format_num_planes(r->pixel_format);
 
-	if (r->width == 0 || r->width % hsub) {
-		DRM_DEBUG_KMS("bad framebuffer width %u\n", r->width);
-		return -EINVAL;
-	}
-
-	if (r->height == 0 || r->height % vsub) {
-		DRM_DEBUG_KMS("bad framebuffer height %u\n", r->height);
-		return -EINVAL;
-	}
-
 	for (i = 0; i < num_planes; i++) {
 		unsigned int width = r->width / (i != 0 ? hsub : 1);
 		unsigned int height = r->height / (i != 0 ? vsub : 1);
@@ -3464,6 +3446,100 @@ static int framebuffer_check(const struct drm_mode_fb_cmd2 *r)
 	return 0;
 }
 
+static int framebuffer_check_sources(struct drm_device *dev,
+				     const struct drm_mode_fb_cmd2 *r)
+{
+	struct drm_mode_object *obj;
+	struct drm_live_source *src;
+	unsigned int cpp;
+	unsigned int i;
+
+	/*
+	 * Ensure that userspace has zeroed unused handles, pitches, offsets and
+	 * modifiers to allow future API extensions.
+	 */
+	if (r->offsets[0] || r->modifier[0])
+		return -EINVAL;
+
+	for (i = 1; i < ARRAY_SIZE(r->handles); ++i) {
+		if (r->handles[i] || r->pitches[i] ||
+		    r->offsets[i] || r->modifier[i])
+			return -EINVAL;
+	}
+
+	/* Validate width, height and pitch. */
+	cpp = drm_format_plane_cpp(r->pixel_format, 0);
+
+	if ((uint64_t) r->width * cpp > UINT_MAX)
+		return -ERANGE;
+
+	if ((uint64_t) r->height * r->pitches[0] > UINT_MAX)
+		return -ERANGE;
+
+	if (r->pitches[0] != r->width * cpp) {
+		DRM_DEBUG_KMS("bad pitch %u for plane %d\n", r->pitches[0], i);
+		return -EINVAL;
+	}
+
+	/*
+	 * Find the live source and check whether it supports the requested
+	 * pixel format.
+	 */
+
+	obj = drm_mode_object_find(dev, r->handles[0],
+				   DRM_MODE_OBJECT_LIVE_SOURCE);
+	if (!obj) {
+		DRM_DEBUG_KMS("bad framebuffer source ID %u\n", r->handles[0]);
+		return -EINVAL;
+	}
+
+	src = obj_to_live_source(obj);
+
+	for (i = 0; i < src->format_count; i++) {
+		if (r->pixel_format == src->format_types[i])
+			break;
+	}
+
+	if (i == src->format_count) {
+		DRM_DEBUG_KMS("bad framebuffer pixel format 0x%08x for source %u\n",
+			      r->pixel_format, r->handles[0]);
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static int framebuffer_check(struct drm_device *dev,
+			     const struct drm_mode_fb_cmd2 *r)
+{
+	int ret, hsub, vsub;
+
+	ret = format_check(r);
+	if (ret) {
+		DRM_DEBUG_KMS("bad framebuffer format %s\n",
+			      drm_get_format_name(r->pixel_format));
+		return ret;
+	}
+
+	hsub = drm_format_horz_chroma_subsampling(r->pixel_format);
+	vsub = drm_format_vert_chroma_subsampling(r->pixel_format);
+
+	if (r->width == 0 || r->width % hsub) {
+		DRM_DEBUG_KMS("bad framebuffer width %u\n", r->width);
+		return -EINVAL;
+	}
+
+	if (r->height == 0 || r->height % vsub) {
+		DRM_DEBUG_KMS("bad framebuffer height %u\n", r->height);
+		return -EINVAL;
+	}
+
+	if (r->flags & DRM_MODE_FB_LIVE_SOURCE)
+		return framebuffer_check_sources(dev, r);
+	else
+		return framebuffer_check_buffers(r, hsub, vsub);
+}
+
 static struct drm_framebuffer *
 internal_framebuffer_create(struct drm_device *dev,
 			    struct drm_mode_fb_cmd2 *r,
@@ -3473,7 +3549,8 @@ internal_framebuffer_create(struct drm_device *dev,
 	struct drm_framebuffer *fb;
 	int ret;
 
-	if (r->flags & ~(DRM_MODE_FB_INTERLACED | DRM_MODE_FB_MODIFIERS)) {
+	if (r->flags & ~(DRM_MODE_FB_INTERLACED | DRM_MODE_FB_MODIFIERS |
+			 DRM_MODE_FB_LIVE_SOURCE)) {
 		DRM_DEBUG_KMS("bad framebuffer flags 0x%08x\n", r->flags);
 		return ERR_PTR(-EINVAL);
 	}
@@ -3495,7 +3572,7 @@ internal_framebuffer_create(struct drm_device *dev,
 		return ERR_PTR(-EINVAL);
 	}
 
-	ret = framebuffer_check(r);
+	ret = framebuffer_check(dev, r);
 	if (ret)
 		return ERR_PTR(ret);
 
diff --git a/include/uapi/drm/drm_mode.h b/include/uapi/drm/drm_mode.h
index e4d09f6f20eb..0cb73fb09d64 100644
--- a/include/uapi/drm/drm_mode.h
+++ b/include/uapi/drm/drm_mode.h
@@ -353,6 +353,7 @@ struct drm_mode_fb_cmd {
 
 #define DRM_MODE_FB_INTERLACED	(1<<0) /* for interlaced framebuffers */
 #define DRM_MODE_FB_MODIFIERS	(1<<1) /* enables ->modifer[] */
+#define DRM_MODE_FB_LIVE_SOURCE	(1<<2) /* connected to a live source */
 
 struct drm_mode_fb_cmd2 {
 	__u32 fb_id;
@@ -380,6 +381,12 @@ struct drm_mode_fb_cmd2 {
 	 * Vendor specific modifier token.  This allows, for example,
 	 * different tiling/swizzling pattern on different planes.
 	 * See discussion above of DRM_FORMAT_MOD_xxx.
+	 *
+	 * If the DRM_MODE_FB_LIVE_SOURCE flag is set the frame buffer input
+	 * comes from a live source instead of from memory. The handles[0]
+	 * field contains the ID of the connected live source object. All other
+	 * handles and all pitches, offsets and modifiers are then ignored by
+	 * the kernel and must be set to zero by applications.
 	 */
 	__u32 handles[4];
 	__u32 pitches[4]; /* pitch for each plane */
-- 
2.0.5
