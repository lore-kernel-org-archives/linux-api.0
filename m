From: Laurent Pinchart <laurent.pinchart+renesas-ryLnwIuWjnjg/C1BVhZhaw@public.gmane.org>
Subject: [RFC/PATCH 2/5] drm: Connect live source to plane
Date: Sun, 15 Mar 2015 23:55:37 +0200
Message-ID: <1426456540-21006-3-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
References: <1426456540-21006-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1426456540-21006-1-git-send-email-laurent.pinchart+renesas-ryLnwIuWjnjg/C1BVhZhaw@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org
Cc: linux-media-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-sh-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Daniel Vetter <daniel.vetter-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Rob Clark <robdclark-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Thierry Reding <thierry.reding-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Magnus Damm <magnus.damm-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas-ryLnwIuWjnjg/C1BVhZhaw@public.gmane.org>
---
 drivers/gpu/drm/armada/armada_overlay.c     |   2 +-
 drivers/gpu/drm/drm_atomic.c                |   7 ++
 drivers/gpu/drm/drm_atomic_helper.c         |   4 +
 drivers/gpu/drm/drm_crtc.c                  | 134 +++++++++++++++++++++++-----
 drivers/gpu/drm/drm_fops.c                  |   6 +-
 drivers/gpu/drm/drm_plane_helper.c          |   1 +
 drivers/gpu/drm/exynos/exynos_drm_crtc.c    |   4 +-
 drivers/gpu/drm/exynos/exynos_drm_plane.c   |   3 +-
 drivers/gpu/drm/exynos/exynos_drm_plane.h   |   3 +-
 drivers/gpu/drm/i915/intel_display.c        |   4 +-
 drivers/gpu/drm/i915/intel_sprite.c         |   2 +-
 drivers/gpu/drm/imx/ipuv3-plane.c           |   3 +-
 drivers/gpu/drm/nouveau/dispnv04/overlay.c  |   6 +-
 drivers/gpu/drm/omapdrm/omap_plane.c        |   1 +
 drivers/gpu/drm/rockchip/rockchip_drm_vop.c |   5 +-
 drivers/gpu/drm/shmobile/shmob_drm_plane.c  |   3 +-
 drivers/gpu/drm/sti/sti_drm_plane.c         |   3 +-
 drivers/gpu/drm/sti/sti_hqvdp.c             |   2 +-
 include/drm/drmP.h                          |   3 +
 include/drm/drm_atomic_helper.h             |   1 +
 include/drm/drm_crtc.h                      |   6 ++
 include/drm/drm_plane_helper.h              |   1 +
 22 files changed, 165 insertions(+), 39 deletions(-)

diff --git a/drivers/gpu/drm/armada/armada_overlay.c b/drivers/gpu/drm/armada/armada_overlay.c
index c5b06fdb459c..4d5708bbee6e 100644
--- a/drivers/gpu/drm/armada/armada_overlay.c
+++ b/drivers/gpu/drm/armada/armada_overlay.c
@@ -99,7 +99,7 @@ static unsigned armada_limit(int start, unsigned size, unsigned max)
 
 static int
 armada_plane_update(struct drm_plane *plane, struct drm_crtc *crtc,
-	struct drm_framebuffer *fb,
+	struct drm_framebuffer *fb, struct drm_live_source *src,
 	int crtc_x, int crtc_y, unsigned crtc_w, unsigned crtc_h,
 	uint32_t src_x, uint32_t src_y, uint32_t src_w, uint32_t src_h)
 {
diff --git a/drivers/gpu/drm/drm_atomic.c b/drivers/gpu/drm/drm_atomic.c
index a6caaae40b9e..0be059be2d58 100644
--- a/drivers/gpu/drm/drm_atomic.c
+++ b/drivers/gpu/drm/drm_atomic.c
@@ -384,6 +384,11 @@ int drm_atomic_plane_set_property(struct drm_plane *plane,
 		drm_atomic_set_fb_for_plane(state, fb);
 		if (fb)
 			drm_framebuffer_unreference(fb);
+	} else if (property == config->prop_src_id) {
+		struct drm_mode_object *obj;
+		obj = drm_mode_object_find(dev, val,
+					   DRM_MODE_OBJECT_LIVE_SOURCE);
+		state->src = obj ? obj_to_live_source(obj) : NULL;
 	} else if (property == config->prop_crtc_id) {
 		struct drm_crtc *crtc = drm_crtc_find(dev, val);
 		return drm_atomic_set_crtc_for_plane(state, crtc);
@@ -432,6 +437,8 @@ drm_atomic_plane_get_property(struct drm_plane *plane,
 
 	if (property == config->prop_fb_id) {
 		*val = (state->fb) ? state->fb->base.id : 0;
+	} else if (property == config->prop_src_id) {
+		*val = (state->src) ? state->src->base.id : 0;
 	} else if (property == config->prop_crtc_id) {
 		*val = (state->crtc) ? state->crtc->base.id : 0;
 	} else if (property == config->prop_crtc_x) {
diff --git a/drivers/gpu/drm/drm_atomic_helper.c b/drivers/gpu/drm/drm_atomic_helper.c
index a7458813af2b..b182d9e6abba 100644
--- a/drivers/gpu/drm/drm_atomic_helper.c
+++ b/drivers/gpu/drm/drm_atomic_helper.c
@@ -1342,6 +1342,7 @@ EXPORT_SYMBOL(drm_atomic_helper_swap_state);
  * @plane: plane object to update
  * @crtc: owning CRTC of owning plane
  * @fb: framebuffer to flip onto plane
+ * @src: live source to connect to the plane
  * @crtc_x: x offset of primary plane on crtc
  * @crtc_y: y offset of primary plane on crtc
  * @crtc_w: width of primary plane rectangle on crtc
@@ -1359,6 +1360,7 @@ EXPORT_SYMBOL(drm_atomic_helper_swap_state);
 int drm_atomic_helper_update_plane(struct drm_plane *plane,
 				   struct drm_crtc *crtc,
 				   struct drm_framebuffer *fb,
+				   struct drm_live_source *src,
 				   int crtc_x, int crtc_y,
 				   unsigned int crtc_w, unsigned int crtc_h,
 				   uint32_t src_x, uint32_t src_y,
@@ -1384,6 +1386,7 @@ retry:
 	if (ret != 0)
 		goto fail;
 	drm_atomic_set_fb_for_plane(plane_state, fb);
+	plane_state->src = src;
 	plane_state->crtc_x = crtc_x;
 	plane_state->crtc_y = crtc_y;
 	plane_state->crtc_h = crtc_h;
@@ -1466,6 +1469,7 @@ retry:
 	if (ret != 0)
 		goto fail;
 	drm_atomic_set_fb_for_plane(plane_state, NULL);
+	plane_state->src = NULL;
 	plane_state->crtc_x = 0;
 	plane_state->crtc_y = 0;
 	plane_state->crtc_h = 0;
diff --git a/drivers/gpu/drm/drm_crtc.c b/drivers/gpu/drm/drm_crtc.c
index a510c9742a16..f11960372307 100644
--- a/drivers/gpu/drm/drm_crtc.c
+++ b/drivers/gpu/drm/drm_crtc.c
@@ -1183,6 +1183,7 @@ int drm_universal_plane_init(struct drm_device *dev, struct drm_plane *plane,
 
 	if (drm_core_check_feature(dev, DRIVER_ATOMIC)) {
 		drm_object_attach_property(&plane->base, config->prop_fb_id, 0);
+		drm_object_attach_property(&plane->base, config->prop_src_id, 0);
 		drm_object_attach_property(&plane->base, config->prop_crtc_id, 0);
 		drm_object_attach_property(&plane->base, config->prop_crtc_x, 0);
 		drm_object_attach_property(&plane->base, config->prop_crtc_y, 0);
@@ -1315,6 +1316,31 @@ void drm_live_source_cleanup(struct drm_live_source *src)
 }
 EXPORT_SYMBOL(drm_live_source_cleanup);
 
+void drm_live_sources_release(struct drm_file *priv)
+{
+	struct drm_device *dev = priv->minor->dev;
+	struct drm_live_source *src, *next;
+	int ret;
+
+	drm_modeset_lock_all(dev);
+	mutex_lock(&priv->sources_lock);
+
+	list_for_each_entry_safe(src, next, &priv->sources, filp_head) {
+		list_del_init(&src->filp_head);
+		if (src->plane) {
+			ret = src->plane->funcs->disable_plane(src->plane);
+			if (ret)
+				DRM_ERROR("failed to disable plane with busy source\n");
+			src->plane->src = NULL;
+			src->plane->crtc = NULL;
+			src->plane = NULL;
+		}
+	}
+
+	mutex_unlock(&priv->sources_lock);
+	drm_modeset_unlock_all(dev);
+}
+
 /**
  * drm_plane_index - find the index of a registered plane
  * @plane: plane to find index for
@@ -1468,6 +1494,12 @@ static int drm_mode_create_standard_properties(struct drm_device *dev)
 	dev->mode_config.prop_fb_id = prop;
 
 	prop = drm_property_create_object(dev, DRM_MODE_PROP_ATOMIC,
+			"SRC_ID", DRM_MODE_OBJECT_FB);
+	if (!prop)
+		return -ENOMEM;
+	dev->mode_config.prop_src_id = prop;
+
+	prop = drm_property_create_object(dev, DRM_MODE_PROP_ATOMIC,
 			"CRTC_ID", DRM_MODE_OBJECT_CRTC);
 	if (!prop)
 		return -ENOMEM;
@@ -2436,6 +2468,8 @@ int drm_mode_getplane(struct drm_device *dev, void *data,
 
 	if (plane->fb)
 		plane_resp->fb_id = plane->fb->base.id;
+	else if (plane->src)
+		plane_resp->fb_id = plane->src->base.id;
 	else
 		plane_resp->fb_id = 0;
 	drm_modeset_unlock(&plane->mutex);
@@ -2492,25 +2526,29 @@ int drm_plane_check_pixel_format(const struct drm_plane *plane, u32 format)
  *
  * src_{x,y,w,h} are provided in 16.16 fixed point format
  */
-static int __setplane_internal(struct drm_plane *plane,
+static int __setplane_internal(struct drm_file *file_priv,
+			       struct drm_plane *plane,
 			       struct drm_crtc *crtc,
 			       struct drm_framebuffer *fb,
+			       struct drm_live_source *src,
 			       int32_t crtc_x, int32_t crtc_y,
 			       uint32_t crtc_w, uint32_t crtc_h,
 			       /* src_{x,y,w,h} values are 16.16 fixed point */
 			       uint32_t src_x, uint32_t src_y,
 			       uint32_t src_w, uint32_t src_h)
 {
+	unsigned int width, height;
+	uint32_t pixel_format;
 	int ret = 0;
-	unsigned int fb_width, fb_height;
 
-	/* No fb means shut it down */
-	if (!fb) {
+	/* No fb and src means shut it down */
+	if (!fb && !src) {
 		plane->old_fb = plane->fb;
 		ret = plane->funcs->disable_plane(plane);
 		if (!ret) {
 			plane->crtc = NULL;
 			plane->fb = NULL;
+			plane->src = NULL;
 		} else {
 			plane->old_fb = NULL;
 		}
@@ -2524,22 +2562,50 @@ static int __setplane_internal(struct drm_plane *plane,
 		goto out;
 	}
 
-	/* Check whether this plane supports the fb pixel format. */
-	ret = drm_plane_check_pixel_format(plane, fb->pixel_format);
+	/* Check whether this plane supports the pixel format. */
+	pixel_format = fb ? fb->pixel_format : src->pixel_format;
+	ret = drm_plane_check_pixel_format(plane, pixel_format);
 	if (ret) {
 		DRM_DEBUG_KMS("Invalid pixel format %s\n",
-			      drm_get_format_name(fb->pixel_format));
+			      drm_get_format_name(pixel_format));
 		goto out;
 	}
 
-	fb_width = fb->width << 16;
-	fb_height = fb->height << 16;
+	/* Check whether the source can be associated with the plane. */
+	if (src) {
+		struct drm_device *dev = plane->dev;
+		unsigned int plane_mask = 1;
+		struct drm_plane *p;
+
+		if (src->plane && src->plane != plane) {
+			ret = -EBUSY;
+			goto out;
+		}
+
+		list_for_each_entry(p, &dev->mode_config.plane_list, head) {
+			if (p == plane)
+				break;
+			plane_mask <<= 1;
+		}
+
+		if (!(src->possible_planes & plane_mask)) {
+			DRM_DEBUG_KMS("Invalid source for plane\n");
+			ret = -EINVAL;
+			goto out;
+		}
+	}
+
+	/* Make sure source coordinates are inside the source. */
+	if (fb) {
+		width = fb->width << 16;
+		height = fb->height << 16;
+	} else {
+		width = src->width << 16;
+		height = src->height << 16;
+	}
 
-	/* Make sure source coordinates are inside the fb. */
-	if (src_w > fb_width ||
-	    src_x > fb_width - src_w ||
-	    src_h > fb_height ||
-	    src_y > fb_height - src_h) {
+	if (src_w > width || src_x > width - src_w ||
+	    src_h > height || src_y > height - src_h) {
 		DRM_DEBUG_KMS("Invalid source coordinates "
 			      "%u.%06ux%u.%06u+%u.%06u+%u.%06u\n",
 			      src_w >> 16, ((src_w & 0xffff) * 15625) >> 10,
@@ -2551,12 +2617,24 @@ static int __setplane_internal(struct drm_plane *plane,
 	}
 
 	plane->old_fb = plane->fb;
-	ret = plane->funcs->update_plane(plane, crtc, fb,
+	ret = plane->funcs->update_plane(plane, crtc, fb, src,
 					 crtc_x, crtc_y, crtc_w, crtc_h,
 					 src_x, src_y, src_w, src_h);
 	if (!ret) {
+		mutex_lock(&file_priv->sources_lock);
+		if (src) {
+			list_add_tail(&src->filp_head, &file_priv->sources);
+			src->plane = plane;
+		}
+		if (plane->src) {
+			list_del(&plane->src->filp_head);
+			plane->src->plane = NULL;
+		}
+		mutex_unlock(&file_priv->sources_lock);
+
 		plane->crtc = crtc;
 		plane->fb = fb;
+		plane->src = src;
 		fb = NULL;
 	} else {
 		plane->old_fb = NULL;
@@ -2572,9 +2650,11 @@ out:
 	return ret;
 }
 
-static int setplane_internal(struct drm_plane *plane,
+static int setplane_internal(struct drm_file *file_priv,
+			     struct drm_plane *plane,
 			     struct drm_crtc *crtc,
 			     struct drm_framebuffer *fb,
+			     struct drm_live_source *src,
 			     int32_t crtc_x, int32_t crtc_y,
 			     uint32_t crtc_w, uint32_t crtc_h,
 			     /* src_{x,y,w,h} values are 16.16 fixed point */
@@ -2584,7 +2664,7 @@ static int setplane_internal(struct drm_plane *plane,
 	int ret;
 
 	drm_modeset_lock_all(plane->dev);
-	ret = __setplane_internal(plane, crtc, fb,
+	ret = __setplane_internal(file_priv, plane, crtc, fb, src,
 				  crtc_x, crtc_y, crtc_w, crtc_h,
 				  src_x, src_y, src_w, src_h);
 	drm_modeset_unlock_all(plane->dev);
@@ -2612,6 +2692,7 @@ int drm_mode_setplane(struct drm_device *dev, void *data,
 	struct drm_plane *plane;
 	struct drm_crtc *crtc = NULL;
 	struct drm_framebuffer *fb = NULL;
+	struct drm_live_source *src = NULL;
 
 	if (!drm_core_check_feature(dev, DRIVER_MODESET))
 		return -EINVAL;
@@ -2628,8 +2709,8 @@ int drm_mode_setplane(struct drm_device *dev, void *data,
 	}
 
 	/*
-	 * First, find the plane, crtc, and fb objects.  If not available,
-	 * we don't bother to call the driver.
+	 * First, find the plane, crtc, and fb or source objects. If not
+	 * available, we don't bother to call the driver.
 	 */
 	plane = drm_plane_find(dev, plane_req->plane_id);
 	if (!plane) {
@@ -2641,7 +2722,16 @@ int drm_mode_setplane(struct drm_device *dev, void *data,
 	if (plane_req->fb_id) {
 		fb = drm_framebuffer_lookup(dev, plane_req->fb_id);
 		if (!fb) {
-			DRM_DEBUG_KMS("Unknown framebuffer ID %d\n",
+			struct drm_mode_object *obj;
+
+			obj = drm_mode_object_find(dev, plane_req->fb_id,
+						   DRM_MODE_OBJECT_LIVE_SOURCE);
+			if (obj)
+				src = obj_to_live_source(obj);
+		}
+
+		if (!fb && !src) {
+			DRM_DEBUG_KMS("Unknown framebuffer or live source ID %d\n",
 				      plane_req->fb_id);
 			return -ENOENT;
 		}
@@ -2658,7 +2748,7 @@ int drm_mode_setplane(struct drm_device *dev, void *data,
 	 * setplane_internal will take care of deref'ing either the old or new
 	 * framebuffer depending on success.
 	 */
-	return setplane_internal(plane, crtc, fb,
+	return setplane_internal(file_priv, plane, crtc, fb, src,
 				 plane_req->crtc_x, plane_req->crtc_y,
 				 plane_req->crtc_w, plane_req->crtc_h,
 				 plane_req->src_x, plane_req->src_y,
@@ -3199,7 +3289,7 @@ static int drm_mode_cursor_universal(struct drm_crtc *crtc,
 	 * setplane_internal will take care of deref'ing either the old or new
 	 * framebuffer depending on success.
 	 */
-	ret = __setplane_internal(crtc->cursor, crtc, fb,
+	ret = __setplane_internal(file_priv, crtc->cursor, crtc, fb, NULL,
 				crtc_x, crtc_y, crtc_w, crtc_h,
 				0, 0, src_w, src_h);
 
diff --git a/drivers/gpu/drm/drm_fops.c b/drivers/gpu/drm/drm_fops.c
index 076dd606b580..28591acf7e7a 100644
--- a/drivers/gpu/drm/drm_fops.c
+++ b/drivers/gpu/drm/drm_fops.c
@@ -167,6 +167,8 @@ static int drm_open_helper(struct file *filp, struct drm_minor *minor)
 	INIT_LIST_HEAD(&priv->lhead);
 	INIT_LIST_HEAD(&priv->fbs);
 	mutex_init(&priv->fbs_lock);
+	INIT_LIST_HEAD(&priv->sources);
+	mutex_init(&priv->sources_lock);
 	INIT_LIST_HEAD(&priv->event_list);
 	init_waitqueue_head(&priv->event_wait);
 	priv->event_space = 4096; /* set aside 4k for event buffer */
@@ -408,8 +410,10 @@ int drm_release(struct inode *inode, struct file *filp)
 
 	drm_events_release(file_priv);
 
-	if (drm_core_check_feature(dev, DRIVER_MODESET))
+	if (drm_core_check_feature(dev, DRIVER_MODESET)) {
 		drm_fb_release(file_priv);
+		drm_live_sources_release(file_priv);
+	}
 
 	if (drm_core_check_feature(dev, DRIVER_GEM))
 		drm_gem_release(dev, file_priv);
diff --git a/drivers/gpu/drm/drm_plane_helper.c b/drivers/gpu/drm/drm_plane_helper.c
index b62b03635050..09bf8d9ba580 100644
--- a/drivers/gpu/drm/drm_plane_helper.c
+++ b/drivers/gpu/drm/drm_plane_helper.c
@@ -222,6 +222,7 @@ EXPORT_SYMBOL(drm_plane_helper_check_update);
  */
 int drm_primary_helper_update(struct drm_plane *plane, struct drm_crtc *crtc,
 			      struct drm_framebuffer *fb,
+			      struct drm_live_source *lsrc,
 			      int crtc_x, int crtc_y,
 			      unsigned int crtc_w, unsigned int crtc_h,
 			      uint32_t src_x, uint32_t src_y,
diff --git a/drivers/gpu/drm/exynos/exynos_drm_crtc.c b/drivers/gpu/drm/exynos/exynos_drm_crtc.c
index 48ccab7fdf63..95ded0286eb9 100644
--- a/drivers/gpu/drm/exynos/exynos_drm_crtc.c
+++ b/drivers/gpu/drm/exynos/exynos_drm_crtc.c
@@ -127,7 +127,7 @@ static int exynos_drm_crtc_mode_set_base(struct drm_crtc *crtc, int x, int y,
 	crtc_w = fb->width - x;
 	crtc_h = fb->height - y;
 
-	return exynos_update_plane(crtc->primary, crtc, fb, 0, 0,
+	return exynos_update_plane(crtc->primary, crtc, fb, NULL, 0, 0,
 				   crtc_w, crtc_h, x, y, crtc_w, crtc_h);
 }
 
@@ -201,7 +201,7 @@ static int exynos_drm_crtc_page_flip(struct drm_crtc *crtc,
 		crtc->primary->fb = fb;
 		crtc_w = fb->width - crtc->x;
 		crtc_h = fb->height - crtc->y;
-		ret = exynos_update_plane(crtc->primary, crtc, fb, 0, 0,
+		ret = exynos_update_plane(crtc->primary, crtc, fb, NULL, 0, 0,
 					  crtc_w, crtc_h, crtc->x, crtc->y,
 					  crtc_w, crtc_h);
 		if (ret) {
diff --git a/drivers/gpu/drm/exynos/exynos_drm_plane.c b/drivers/gpu/drm/exynos/exynos_drm_plane.c
index a5616872eee7..693bfbf6b868 100644
--- a/drivers/gpu/drm/exynos/exynos_drm_plane.c
+++ b/drivers/gpu/drm/exynos/exynos_drm_plane.c
@@ -146,7 +146,8 @@ void exynos_plane_mode_set(struct drm_plane *plane, struct drm_crtc *crtc,
 
 int
 exynos_update_plane(struct drm_plane *plane, struct drm_crtc *crtc,
-		     struct drm_framebuffer *fb, int crtc_x, int crtc_y,
+		     struct drm_framebuffer *fb, struct drm_live_source *src,
+		     int crtc_x, int crtc_y,
 		     unsigned int crtc_w, unsigned int crtc_h,
 		     uint32_t src_x, uint32_t src_y,
 		     uint32_t src_w, uint32_t src_h)
diff --git a/drivers/gpu/drm/exynos/exynos_drm_plane.h b/drivers/gpu/drm/exynos/exynos_drm_plane.h
index 9d3c374e7b3e..bffb282c4860 100644
--- a/drivers/gpu/drm/exynos/exynos_drm_plane.h
+++ b/drivers/gpu/drm/exynos/exynos_drm_plane.h
@@ -16,7 +16,8 @@ void exynos_plane_mode_set(struct drm_plane *plane, struct drm_crtc *crtc,
 			   uint32_t src_x, uint32_t src_y,
 			   uint32_t src_w, uint32_t src_h);
 int exynos_update_plane(struct drm_plane *plane, struct drm_crtc *crtc,
-			struct drm_framebuffer *fb, int crtc_x, int crtc_y,
+			struct drm_framebuffer *fb, struct drm_live_source *src,
+			int crtc_x, int crtc_y,
 			unsigned int crtc_w, unsigned int crtc_h,
 			uint32_t src_x, uint32_t src_y,
 			uint32_t src_w, uint32_t src_h);
diff --git a/drivers/gpu/drm/i915/intel_display.c b/drivers/gpu/drm/i915/intel_display.c
index 1aa1cbd16c19..3b72dc9a5676 100644
--- a/drivers/gpu/drm/i915/intel_display.c
+++ b/drivers/gpu/drm/i915/intel_display.c
@@ -11242,7 +11242,7 @@ static int __intel_set_mode(struct drm_crtc *crtc,
 
 		drm_crtc_get_hv_timing(mode, &hdisplay, &vdisplay);
 		ret = primary->funcs->update_plane(primary, &intel_crtc->base,
-						   fb, 0, 0,
+						   fb, NULL, 0, 0,
 						   hdisplay, vdisplay,
 						   x << 16, y << 16,
 						   hdisplay << 16, vdisplay << 16);
@@ -11717,7 +11717,7 @@ static int intel_crtc_set_config(struct drm_mode_set *set)
 
 		drm_crtc_get_hv_timing(set->mode, &hdisplay, &vdisplay);
 		ret = primary->funcs->update_plane(primary, set->crtc, set->fb,
-						   0, 0, hdisplay, vdisplay,
+						   NULL, 0, 0, hdisplay, vdisplay,
 						   set->x << 16, set->y << 16,
 						   hdisplay << 16, vdisplay << 16);
 
diff --git a/drivers/gpu/drm/i915/intel_sprite.c b/drivers/gpu/drm/i915/intel_sprite.c
index 7051da7015d3..be382d02ce14 100644
--- a/drivers/gpu/drm/i915/intel_sprite.c
+++ b/drivers/gpu/drm/i915/intel_sprite.c
@@ -1364,7 +1364,7 @@ int intel_plane_restore(struct drm_plane *plane)
 	if (!plane->crtc || !plane->fb)
 		return 0;
 
-	return plane->funcs->update_plane(plane, plane->crtc, plane->fb,
+	return plane->funcs->update_plane(plane, plane->crtc, plane->fb, NULL,
 				  plane->state->crtc_x, plane->state->crtc_y,
 				  plane->state->crtc_w, plane->state->crtc_h,
 				  plane->state->src_x, plane->state->src_y,
diff --git a/drivers/gpu/drm/imx/ipuv3-plane.c b/drivers/gpu/drm/imx/ipuv3-plane.c
index 6987e16fe99b..a26d969fab0e 100644
--- a/drivers/gpu/drm/imx/ipuv3-plane.c
+++ b/drivers/gpu/drm/imx/ipuv3-plane.c
@@ -295,7 +295,8 @@ void ipu_plane_disable(struct ipu_plane *ipu_plane)
  */
 
 static int ipu_update_plane(struct drm_plane *plane, struct drm_crtc *crtc,
-			    struct drm_framebuffer *fb, int crtc_x, int crtc_y,
+			    struct drm_framebuffer *fb,
+			    struct drm_live_source *src, int crtc_x, int crtc_y,
 			    unsigned int crtc_w, unsigned int crtc_h,
 			    uint32_t src_x, uint32_t src_y,
 			    uint32_t src_w, uint32_t src_h)
diff --git a/drivers/gpu/drm/nouveau/dispnv04/overlay.c b/drivers/gpu/drm/nouveau/dispnv04/overlay.c
index 9f2498571d09..485d1de72460 100644
--- a/drivers/gpu/drm/nouveau/dispnv04/overlay.c
+++ b/drivers/gpu/drm/nouveau/dispnv04/overlay.c
@@ -91,7 +91,8 @@ cos_mul(int degrees, int factor)
 
 static int
 nv10_update_plane(struct drm_plane *plane, struct drm_crtc *crtc,
-		  struct drm_framebuffer *fb, int crtc_x, int crtc_y,
+		  struct drm_framebuffer *fb, struct drm_live_source *src,
+		  int crtc_x, int crtc_y,
 		  unsigned int crtc_w, unsigned int crtc_h,
 		  uint32_t src_x, uint32_t src_y,
 		  uint32_t src_w, uint32_t src_h)
@@ -341,7 +342,8 @@ err:
 
 static int
 nv04_update_plane(struct drm_plane *plane, struct drm_crtc *crtc,
-		  struct drm_framebuffer *fb, int crtc_x, int crtc_y,
+		  struct drm_framebuffer *fb, struct drm_live_source *src,
+		  int crtc_x, int crtc_y,
 		  unsigned int crtc_w, unsigned int crtc_h,
 		  uint32_t src_x, uint32_t src_y,
 		  uint32_t src_w, uint32_t src_h)
diff --git a/drivers/gpu/drm/omapdrm/omap_plane.c b/drivers/gpu/drm/omapdrm/omap_plane.c
index ee8e2b3a117e..953707c8a795 100644
--- a/drivers/gpu/drm/omapdrm/omap_plane.c
+++ b/drivers/gpu/drm/omapdrm/omap_plane.c
@@ -238,6 +238,7 @@ int omap_plane_mode_set(struct drm_plane *plane,
 
 static int omap_plane_update(struct drm_plane *plane,
 		struct drm_crtc *crtc, struct drm_framebuffer *fb,
+		struct drm_live_source *src,
 		int crtc_x, int crtc_y,
 		unsigned int crtc_w, unsigned int crtc_h,
 		uint32_t src_x, uint32_t src_y,
diff --git a/drivers/gpu/drm/rockchip/rockchip_drm_vop.c b/drivers/gpu/drm/rockchip/rockchip_drm_vop.c
index 9a5c571b95fc..6c0767a03ad8 100644
--- a/drivers/gpu/drm/rockchip/rockchip_drm_vop.c
+++ b/drivers/gpu/drm/rockchip/rockchip_drm_vop.c
@@ -504,8 +504,9 @@ static int vop_win_queue_fb(struct vop_win *vop_win,
 
 static int vop_update_plane_event(struct drm_plane *plane,
 				  struct drm_crtc *crtc,
-				  struct drm_framebuffer *fb, int crtc_x,
-				  int crtc_y, unsigned int crtc_w,
+				  struct drm_framebuffer *fb,
+				  struct drm_live_source *src,
+				  int crtc_x, int crtc_y, unsigned int crtc_w,
 				  unsigned int crtc_h, uint32_t src_x,
 				  uint32_t src_y, uint32_t src_w,
 				  uint32_t src_h,
diff --git a/drivers/gpu/drm/shmobile/shmob_drm_plane.c b/drivers/gpu/drm/shmobile/shmob_drm_plane.c
index 1805bb23b113..236613bcd571 100644
--- a/drivers/gpu/drm/shmobile/shmob_drm_plane.c
+++ b/drivers/gpu/drm/shmobile/shmob_drm_plane.c
@@ -174,7 +174,8 @@ void shmob_drm_plane_setup(struct drm_plane *plane)
 
 static int
 shmob_drm_plane_update(struct drm_plane *plane, struct drm_crtc *crtc,
-		       struct drm_framebuffer *fb, int crtc_x, int crtc_y,
+		       struct drm_framebuffer *fb, struct drm_live_source *src,
+		       int crtc_x, int crtc_y,
 		       unsigned int crtc_w, unsigned int crtc_h,
 		       uint32_t src_x, uint32_t src_y,
 		       uint32_t src_w, uint32_t src_h)
diff --git a/drivers/gpu/drm/sti/sti_drm_plane.c b/drivers/gpu/drm/sti/sti_drm_plane.c
index bb6a29339e10..f43a4341e59c 100644
--- a/drivers/gpu/drm/sti/sti_drm_plane.c
+++ b/drivers/gpu/drm/sti/sti_drm_plane.c
@@ -24,7 +24,8 @@ enum sti_layer_desc sti_layer_default_zorder[] = {
 
 static int
 sti_drm_update_plane(struct drm_plane *plane, struct drm_crtc *crtc,
-		     struct drm_framebuffer *fb, int crtc_x, int crtc_y,
+		     struct drm_framebuffer *fb, struct drm_live_source *src,
+		     int crtc_x, int crtc_y,
 		     unsigned int crtc_w, unsigned int crtc_h,
 		     uint32_t src_x, uint32_t src_y,
 		     uint32_t src_w, uint32_t src_h)
diff --git a/drivers/gpu/drm/sti/sti_hqvdp.c b/drivers/gpu/drm/sti/sti_hqvdp.c
index b0eb62de1b2e..4ec096e62d9e 100644
--- a/drivers/gpu/drm/sti/sti_hqvdp.c
+++ b/drivers/gpu/drm/sti/sti_hqvdp.c
@@ -533,7 +533,7 @@ static int sti_hqvdp_prepare_layer(struct sti_layer *layer, bool first_prepare)
 
 	/* prepare and commit VID plane */
 	hqvdp->vid_plane->funcs->update_plane(hqvdp->vid_plane,
-					layer->crtc, layer->fb,
+					layer->crtc, layer->fb, NULL,
 					layer->dst_x, layer->dst_y,
 					layer->dst_w, layer->dst_h,
 					layer->src_x, layer->src_y,
diff --git a/include/drm/drmP.h b/include/drm/drmP.h
index 63c0b0131f61..6adcdb99482a 100644
--- a/include/drm/drmP.h
+++ b/include/drm/drmP.h
@@ -322,6 +322,9 @@ struct drm_file {
 	struct list_head fbs;
 	struct mutex fbs_lock;
 
+	struct list_head sources;
+	struct mutex sources_lock;
+
 	wait_queue_head_t event_wait;
 	struct list_head event_list;
 	int event_space;
diff --git a/include/drm/drm_atomic_helper.h b/include/drm/drm_atomic_helper.h
index 829280b56874..68b9bb68d015 100644
--- a/include/drm/drm_atomic_helper.h
+++ b/include/drm/drm_atomic_helper.h
@@ -62,6 +62,7 @@ void drm_atomic_helper_swap_state(struct drm_device *dev,
 int drm_atomic_helper_update_plane(struct drm_plane *plane,
 				   struct drm_crtc *crtc,
 				   struct drm_framebuffer *fb,
+				   struct drm_live_source *src,
 				   int crtc_x, int crtc_y,
 				   unsigned int crtc_w, unsigned int crtc_h,
 				   uint32_t src_x, uint32_t src_y,
diff --git a/include/drm/drm_crtc.h b/include/drm/drm_crtc.h
index 775a9a84c5bf..c66e23a60f75 100644
--- a/include/drm/drm_crtc.h
+++ b/include/drm/drm_crtc.h
@@ -759,6 +759,7 @@ struct drm_plane_state {
 
 	struct drm_crtc *crtc;   /* do not write directly, use drm_atomic_set_crtc_for_plane() */
 	struct drm_framebuffer *fb;  /* do not write directly, use drm_atomic_set_fb_for_plane() */
+	struct drm_live_source *src;
 	struct fence *fence;
 
 	/* Signed dest location allows it to be partially off screen */
@@ -793,6 +794,7 @@ struct drm_plane_state {
 struct drm_plane_funcs {
 	int (*update_plane)(struct drm_plane *plane,
 			    struct drm_crtc *crtc, struct drm_framebuffer *fb,
+			    struct drm_live_source *src,
 			    int crtc_x, int crtc_y,
 			    unsigned int crtc_w, unsigned int crtc_h,
 			    uint32_t src_x, uint32_t src_y,
@@ -857,6 +859,7 @@ struct drm_plane {
 
 	struct drm_crtc *crtc;
 	struct drm_framebuffer *fb;
+	struct drm_live_source *src;
 
 	struct drm_framebuffer *old_fb;
 
@@ -878,6 +881,7 @@ struct drm_live_source_funcs {
 struct drm_live_source {
 	struct drm_device *dev;
 	struct list_head head;
+	struct list_head filp_head;
 
 	struct drm_mode_object base;
 
@@ -1149,6 +1153,7 @@ struct drm_mode_config {
 	struct drm_property *prop_crtc_w;
 	struct drm_property *prop_crtc_h;
 	struct drm_property *prop_fb_id;
+	struct drm_property *prop_src_id;
 	struct drm_property *prop_crtc_id;
 	struct drm_property *prop_active;
 
@@ -1311,6 +1316,7 @@ extern int drm_live_source_init(struct drm_device *dev,
 				const uint32_t *formats, uint32_t format_count,
 				const struct drm_live_source_funcs *funcs);
 extern void drm_live_source_cleanup(struct drm_live_source *src);
+extern void drm_live_sources_release(struct drm_file *priv);
 
 extern const char *drm_get_connector_status_name(enum drm_connector_status status);
 extern const char *drm_get_subpixel_order_name(enum subpixel_order order);
diff --git a/include/drm/drm_plane_helper.h b/include/drm/drm_plane_helper.h
index e48157a5a59c..441cd55e094c 100644
--- a/include/drm/drm_plane_helper.h
+++ b/include/drm/drm_plane_helper.h
@@ -93,6 +93,7 @@ extern int drm_plane_helper_check_update(struct drm_plane *plane,
 extern int drm_primary_helper_update(struct drm_plane *plane,
 				     struct drm_crtc *crtc,
 				     struct drm_framebuffer *fb,
+				     struct drm_live_source *src,
 				     int crtc_x, int crtc_y,
 				     unsigned int crtc_w, unsigned int crtc_h,
 				     uint32_t src_x, uint32_t src_y,
-- 
2.0.5
