From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Subject: [RFC/PATCH 1/5] drm: Add live source object
Date: Sun, 15 Mar 2015 23:55:36 +0200
Message-ID: <1426456540-21006-2-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
References: <1426456540-21006-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Return-path: <linux-media-owner@vger.kernel.org>
In-Reply-To: <1426456540-21006-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
To: dri-devel@lists.freedesktop.org
Cc: linux-media@vger.kernel.org, linux-sh@vger.kernel.org, linux-api@vger.kernel.org, Daniel Vetter <daniel.vetter@intel.com>, Rob Clark <robdclark@gmail.com>, Thierry Reding <thierry.reding@gmail.com>, Magnus Damm <magnus.damm@gmail.com>
List-Id: linux-api@vger.kernel.org

Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
---
 drivers/gpu/drm/drm_crtc.c  | 231 ++++++++++++++++++++++++++++++++++++++++++++
 drivers/gpu/drm/drm_ioctl.c |   3 +
 include/drm/drm_crtc.h      |  42 ++++++++
 include/uapi/drm/drm.h      |   4 +
 include/uapi/drm/drm_mode.h |  32 ++++++
 5 files changed, 312 insertions(+)

diff --git a/drivers/gpu/drm/drm_crtc.c b/drivers/gpu/drm/drm_crtc.c
index 5785336695ca..a510c9742a16 100644
--- a/drivers/gpu/drm/drm_crtc.c
+++ b/drivers/gpu/drm/drm_crtc.c
@@ -1261,6 +1261,60 @@ void drm_plane_cleanup(struct drm_plane *plane)
 }
 EXPORT_SYMBOL(drm_plane_cleanup);
 
+int drm_live_source_init(struct drm_device *dev, struct drm_live_source *src,
+			 const char *name, unsigned long possible_planes,
+			 const uint32_t *formats, uint32_t format_count,
+			 const struct drm_live_source_funcs *funcs)
+{
+	int ret;
+
+	drm_modeset_lock_all(dev);
+
+	ret = drm_mode_object_get(dev, &src->base, DRM_MODE_OBJECT_LIVE_SOURCE);
+	if (ret)
+		goto out;
+
+	src->dev = dev;
+	src->funcs = funcs;
+	if (name)
+		strlcpy(src->name, name, DRM_SOURCE_NAME_LEN);
+	src->possible_planes = possible_planes;
+
+	src->format_types = kmalloc(format_count * sizeof(*src->format_types),
+				    GFP_KERNEL);
+	if (!src->format_types) {
+		DRM_DEBUG_KMS("out of memory when allocating source foramts\n");
+		drm_mode_object_put(dev, &src->base);
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	memcpy(src->format_types, formats,
+	       format_count * sizeof(*src->format_types));
+	src->format_count = format_count;
+
+	list_add_tail(&src->head, &dev->mode_config.live_source_list);
+	dev->mode_config.num_live_source++;
+
+ out:
+	drm_modeset_unlock_all(dev);
+
+	return ret;
+}
+EXPORT_SYMBOL(drm_live_source_init);
+
+void drm_live_source_cleanup(struct drm_live_source *src)
+{
+	struct drm_device *dev = src->dev;
+
+	drm_modeset_lock_all(dev);
+	drm_mode_object_put(dev, &src->base);
+	list_del(&src->head);
+	dev->mode_config.num_live_source--;
+	drm_modeset_unlock_all(dev);
+}
+EXPORT_SYMBOL(drm_live_source_cleanup);
+
 /**
  * drm_plane_index - find the index of a registered plane
  * @plane: plane to find index for
@@ -2612,6 +2666,176 @@ int drm_mode_setplane(struct drm_device *dev, void *data,
 }
 
 /**
+ * drm_mode_getsource_res - get live source info
+ * @dev: DRM device
+ * @data: ioctl data
+ * @file_priv: DRM file info
+ *
+ * Return a live source and set of IDs.
+ */
+int drm_mode_getsource_res(struct drm_device *dev, void *data,
+			   struct drm_file *file_priv)
+{
+	struct drm_mode_get_live_source_res *src_resp = data;
+	struct drm_mode_config *config;
+	struct drm_live_source *src;
+	uint32_t __user *src_ptr;
+	int copied = 0, ret = 0;
+
+	if (!drm_core_check_feature(dev, DRIVER_MODESET))
+		return -EINVAL;
+
+	drm_modeset_lock_all(dev);
+	config = &dev->mode_config;
+
+	/*
+	 * This ioctl is called twice, once to determine how much space is
+	 * needed, and the 2nd time to fill it.
+	 */
+	if (config->num_live_source &&
+	    (src_resp->count_sources >= config->num_live_source)) {
+		src_ptr = (uint32_t __user *)(unsigned long)src_resp->source_id_ptr;
+
+		list_for_each_entry(src, &config->live_source_list, head) {
+			if (put_user(src->base.id, src_ptr + copied)) {
+				ret = -EFAULT;
+				goto out;
+			}
+			copied++;
+		}
+	}
+	src_resp->count_sources = config->num_live_source;
+
+out:
+	drm_modeset_unlock_all(dev);
+	return ret;
+}
+
+/**
+ * drm_mode_getsource - get live source info
+ * @dev: DRM device
+ * @data: ioctl data
+ * @file_priv: DRM file info
+ *
+ * Return live source info, including formats supported, ...
+ */
+int drm_mode_getsource(struct drm_device *dev, void *data,
+		       struct drm_file *file_priv)
+{
+	struct drm_mode_get_live_source *src_resp = data;
+	struct drm_mode_object *obj;
+	struct drm_live_source *src;
+	int ret = 0;
+
+	if (!drm_core_check_feature(dev, DRIVER_MODESET))
+		return -EINVAL;
+
+	obj = drm_mode_object_find(dev, src_resp->source_id,
+				   DRM_MODE_OBJECT_LIVE_SOURCE);
+	if (!obj)
+		return -ENOENT;
+	src = obj_to_live_source(obj);
+
+	src_resp->source_id = src->base.id;
+	strlcpy(src_resp->name, src->name, DRM_SOURCE_NAME_LEN);
+	src_resp->possible_planes = src->possible_planes;
+
+	drm_modeset_lock_all(dev);
+
+	if (src->plane)
+		src_resp->plane_id = src->plane->base.id;
+	else
+		src_resp->plane_id = 0;
+
+	src_resp->width = src->width;
+	src_resp->height = src->height;
+	src_resp->pixel_format = src->pixel_format;
+
+	/*
+	 * This ioctl is called twice, once to determine how much space is
+	 * needed, and the 2nd time to fill it.
+	 */
+	if (src->format_count &&
+	    (src_resp->count_format_types >= src->format_count)) {
+		uint32_t __user *format_ptr;
+
+		format_ptr = (uint32_t __user *)(unsigned long)src_resp->format_type_ptr;
+		if (copy_to_user(format_ptr, src->format_types,
+				 sizeof(uint32_t) * src->format_count)) {
+			ret = -EFAULT;
+			goto out;
+		}
+	}
+	src_resp->count_format_types = src->format_count;
+
+out:
+	drm_modeset_unlock_all(dev);
+	return ret;
+}
+
+/**
+ * drm_mode_setsource - set up or tear down a live source
+ * @dev: DRM device
+ * @data: ioctl data*
+ * @file_priv: DRM file info
+ *
+ * Set live source info, including plane, and other factors.
+ * Or pass a NULL plane to disable.
+ */
+int drm_mode_setsource(struct drm_device *dev, void *data,
+		       struct drm_file *file_priv)
+{
+	struct drm_mode_set_live_source *src_req = data;
+	struct drm_mode_object *obj;
+	struct drm_live_source *src;
+	unsigned int i;
+	int ret = 0;
+
+	if (!drm_core_check_feature(dev, DRIVER_MODESET))
+		return -EINVAL;
+
+	/*
+	 * First, find the live source and plane objects. If not available, we
+	 * don't bother to call the driver.
+	 */
+	obj = drm_mode_object_find(dev, src_req->source_id,
+				   DRM_MODE_OBJECT_LIVE_SOURCE);
+	if (!obj) {
+		DRM_DEBUG_KMS("Unknown live source ID %d\n",
+			      src_req->source_id);
+		return -ENOENT;
+	}
+	src = obj_to_live_source(obj);
+
+	drm_modeset_lock_all(dev);
+
+	if (src->plane) {
+		ret = -EBUSY;
+		goto out;
+	}
+
+	/* Check whether this source supports the pixel format. */
+	for (i = 0; i < src->format_count; i++)
+		if (src_req->pixel_format == src->format_types[i])
+			break;
+
+	if (i == src->format_count) {
+		DRM_DEBUG_KMS("Invalid pixel format 0x%08x for source %u\n",
+			      src_req->pixel_format, src->base.id);
+		ret = -EINVAL;
+		goto out;
+	}
+
+	src->width = src_req->width;
+	src->height = src_req->height;
+	src->pixel_format = src_req->pixel_format;
+
+out:
+	drm_modeset_unlock_all(dev);
+	return ret;
+}
+
+/**
  * drm_mode_set_config_internal - helper to call ->set_config
  * @set: modeset config to set
  *
@@ -5429,6 +5653,7 @@ void drm_mode_config_init(struct drm_device *dev)
 	INIT_LIST_HEAD(&dev->mode_config.property_list);
 	INIT_LIST_HEAD(&dev->mode_config.property_blob_list);
 	INIT_LIST_HEAD(&dev->mode_config.plane_list);
+	INIT_LIST_HEAD(&dev->mode_config.live_source_list);
 	idr_init(&dev->mode_config.crtc_idr);
 	idr_init(&dev->mode_config.tile_idr);
 
@@ -5468,6 +5693,7 @@ void drm_mode_config_cleanup(struct drm_device *dev)
 	struct drm_property *property, *pt;
 	struct drm_property_blob *blob, *bt;
 	struct drm_plane *plane, *plt;
+	struct drm_live_source *src, *psrc;
 
 	list_for_each_entry_safe(encoder, enct, &dev->mode_config.encoder_list,
 				 head) {
@@ -5507,6 +5733,11 @@ void drm_mode_config_cleanup(struct drm_device *dev)
 		plane->funcs->destroy(plane);
 	}
 
+	list_for_each_entry_safe(src, psrc, &dev->mode_config.live_source_list,
+				 head) {
+		src->funcs->destroy(src);
+	}
+
 	list_for_each_entry_safe(crtc, ct, &dev->mode_config.crtc_list, head) {
 		crtc->funcs->destroy(crtc);
 	}
diff --git a/drivers/gpu/drm/drm_ioctl.c b/drivers/gpu/drm/drm_ioctl.c
index a6d773a61c2d..2cb400a8bc8d 100644
--- a/drivers/gpu/drm/drm_ioctl.c
+++ b/drivers/gpu/drm/drm_ioctl.c
@@ -609,10 +609,13 @@ static const struct drm_ioctl_desc drm_ioctls[] = {
 	DRM_IOCTL_DEF(DRM_IOCTL_PRIME_FD_TO_HANDLE, drm_prime_fd_to_handle_ioctl, DRM_AUTH|DRM_UNLOCKED|DRM_RENDER_ALLOW),
 
 	DRM_IOCTL_DEF(DRM_IOCTL_MODE_GETPLANERESOURCES, drm_mode_getplane_res, DRM_CONTROL_ALLOW|DRM_UNLOCKED),
+	DRM_IOCTL_DEF(DRM_IOCTL_MODE_GETSOURCERESOURCES, drm_mode_getsource_res, DRM_CONTROL_ALLOW|DRM_UNLOCKED),
 	DRM_IOCTL_DEF(DRM_IOCTL_MODE_GETCRTC, drm_mode_getcrtc, DRM_CONTROL_ALLOW|DRM_UNLOCKED),
 	DRM_IOCTL_DEF(DRM_IOCTL_MODE_SETCRTC, drm_mode_setcrtc, DRM_MASTER|DRM_CONTROL_ALLOW|DRM_UNLOCKED),
 	DRM_IOCTL_DEF(DRM_IOCTL_MODE_GETPLANE, drm_mode_getplane, DRM_CONTROL_ALLOW|DRM_UNLOCKED),
 	DRM_IOCTL_DEF(DRM_IOCTL_MODE_SETPLANE, drm_mode_setplane, DRM_MASTER|DRM_CONTROL_ALLOW|DRM_UNLOCKED),
+	DRM_IOCTL_DEF(DRM_IOCTL_MODE_GETSOURCE, drm_mode_getsource, DRM_CONTROL_ALLOW|DRM_UNLOCKED),
+	DRM_IOCTL_DEF(DRM_IOCTL_MODE_SETSOURCE, drm_mode_setsource, DRM_MASTER|DRM_CONTROL_ALLOW|DRM_UNLOCKED),
 	DRM_IOCTL_DEF(DRM_IOCTL_MODE_CURSOR, drm_mode_cursor_ioctl, DRM_MASTER|DRM_CONTROL_ALLOW|DRM_UNLOCKED),
 	DRM_IOCTL_DEF(DRM_IOCTL_MODE_GETGAMMA, drm_mode_gamma_get_ioctl, DRM_UNLOCKED),
 	DRM_IOCTL_DEF(DRM_IOCTL_MODE_SETGAMMA, drm_mode_gamma_set_ioctl, DRM_MASTER|DRM_UNLOCKED),
diff --git a/include/drm/drm_crtc.h b/include/drm/drm_crtc.h
index adc9ea5acf02..775a9a84c5bf 100644
--- a/include/drm/drm_crtc.h
+++ b/include/drm/drm_crtc.h
@@ -54,6 +54,7 @@ struct fence;
 #define DRM_MODE_OBJECT_BLOB 0xbbbbbbbb
 #define DRM_MODE_OBJECT_PLANE 0xeeeeeeee
 #define DRM_MODE_OBJECT_BRIDGE 0xbdbdbdbd
+#define DRM_MODE_OBJECT_LIVE_SOURCE 0xe1e1e1e1
 #define DRM_MODE_OBJECT_ANY 0
 
 struct drm_mode_object {
@@ -247,6 +248,7 @@ struct drm_pending_vblank_event;
 struct drm_plane;
 struct drm_bridge;
 struct drm_atomic_state;
+struct drm_live_source;
 
 /**
  * struct drm_crtc_state - mutable CRTC state
@@ -869,6 +871,30 @@ struct drm_plane {
 	struct drm_plane_state *state;
 };
 
+struct drm_live_source_funcs {
+	void (*destroy)(struct drm_live_source *src);
+};
+
+struct drm_live_source {
+	struct drm_device *dev;
+	struct list_head head;
+
+	struct drm_mode_object base;
+
+	char name[DRM_SOURCE_NAME_LEN];
+
+	uint32_t possible_planes;
+	uint32_t *format_types;
+	uint32_t format_count;
+
+	struct drm_plane *plane;
+	unsigned int width;
+	unsigned int height;
+	uint32_t pixel_format;
+
+	const struct drm_live_source_funcs *funcs;
+};
+
 /**
  * struct drm_bridge_funcs - drm_bridge control functions
  * @attach: Called during drm_bridge_attach
@@ -1087,6 +1113,8 @@ struct drm_mode_config {
 	int num_overlay_plane;
 	int num_total_plane;
 	struct list_head plane_list;
+	int num_live_source;
+	struct list_head live_source_list;
 
 	int num_crtc;
 	struct list_head crtc_list;
@@ -1186,6 +1214,7 @@ struct drm_mode_config {
 #define obj_to_property(x) container_of(x, struct drm_property, base)
 #define obj_to_blob(x) container_of(x, struct drm_property_blob, base)
 #define obj_to_plane(x) container_of(x, struct drm_plane, base)
+#define obj_to_live_source(x) container_of(x, struct drm_live_source, base)
 
 struct drm_prop_enum_list {
 	int type;
@@ -1276,6 +1305,13 @@ extern int drm_crtc_check_viewport(const struct drm_crtc *crtc,
 
 extern void drm_encoder_cleanup(struct drm_encoder *encoder);
 
+extern int drm_live_source_init(struct drm_device *dev,
+				struct drm_live_source *src, const char *name,
+				unsigned long possible_planes,
+				const uint32_t *formats, uint32_t format_count,
+				const struct drm_live_source_funcs *funcs);
+extern void drm_live_source_cleanup(struct drm_live_source *src);
+
 extern const char *drm_get_connector_status_name(enum drm_connector_status status);
 extern const char *drm_get_subpixel_order_name(enum subpixel_order order);
 extern const char *drm_get_dpms_name(int val);
@@ -1391,6 +1427,8 @@ extern int drm_mode_getresources(struct drm_device *dev,
 				 void *data, struct drm_file *file_priv);
 extern int drm_mode_getplane_res(struct drm_device *dev, void *data,
 				   struct drm_file *file_priv);
+extern int drm_mode_getsource_res(struct drm_device *dev, void *data,
+				  struct drm_file *file_priv);
 extern int drm_mode_getcrtc(struct drm_device *dev,
 			    void *data, struct drm_file *file_priv);
 extern int drm_mode_getconnector(struct drm_device *dev,
@@ -1402,6 +1440,10 @@ extern int drm_mode_getplane(struct drm_device *dev,
 			       void *data, struct drm_file *file_priv);
 extern int drm_mode_setplane(struct drm_device *dev,
 			       void *data, struct drm_file *file_priv);
+extern int drm_mode_getsource(struct drm_device *dev,
+			      void *data, struct drm_file *file_priv);
+extern int drm_mode_setsource(struct drm_device *dev,
+			      void *data, struct drm_file *file_priv);
 extern int drm_mode_cursor_ioctl(struct drm_device *dev,
 				void *data, struct drm_file *file_priv);
 extern int drm_mode_cursor2_ioctl(struct drm_device *dev,
diff --git a/include/uapi/drm/drm.h b/include/uapi/drm/drm.h
index ff6ef62d084b..d60cb8fa034c 100644
--- a/include/uapi/drm/drm.h
+++ b/include/uapi/drm/drm.h
@@ -787,6 +787,10 @@ struct drm_prime_handle {
 #define DRM_IOCTL_MODE_CURSOR2		DRM_IOWR(0xBB, struct drm_mode_cursor2)
 #define DRM_IOCTL_MODE_ATOMIC		DRM_IOWR(0xBC, struct drm_mode_atomic)
 
+#define DRM_IOCTL_MODE_GETSOURCERESOURCES DRM_IOWR(0xBC, struct drm_mode_get_live_source_res)
+#define DRM_IOCTL_MODE_GETSOURCE	DRM_IOWR(0xBD, struct drm_mode_get_live_source)
+#define DRM_IOCTL_MODE_SETSOURCE	DRM_IOWR(0xBE, struct drm_mode_set_live_source)
+
 /**
  * Device specific ioctls should only be in their respective headers
  * The device specific ioctl range is from 0x40 to 0x9f.
diff --git a/include/uapi/drm/drm_mode.h b/include/uapi/drm/drm_mode.h
index dbeba949462a..ecc1fa3000f4 100644
--- a/include/uapi/drm/drm_mode.h
+++ b/include/uapi/drm/drm_mode.h
@@ -33,6 +33,7 @@
 #define DRM_CONNECTOR_NAME_LEN	32
 #define DRM_DISPLAY_MODE_LEN	32
 #define DRM_PROP_NAME_LEN	32
+#define DRM_SOURCE_NAME_LEN	32
 
 #define DRM_MODE_TYPE_BUILTIN	(1<<0)
 #define DRM_MODE_TYPE_CLOCK_C	((1<<1) | DRM_MODE_TYPE_BUILTIN)
@@ -179,6 +180,37 @@ struct drm_mode_get_plane_res {
 	__u32 count_planes;
 };
 
+struct drm_mode_set_live_source {
+	__u32 source_id;
+
+	__u32 plane_id;
+
+	__u32 width;
+	__u32 height;
+	__u32 pixel_format;
+};
+
+struct drm_mode_get_live_source {
+	__u32 source_id;
+	char name[DRM_SOURCE_NAME_LEN];
+
+	__u32 plane_id;
+
+	__u32 possible_planes;
+
+	__u32 count_format_types;
+	__u64 format_type_ptr;
+
+	__u32 width;
+	__u32 height;
+	__u32 pixel_format;
+};
+
+struct drm_mode_get_live_source_res {
+	__u64 source_id_ptr;
+	__u32 count_sources;
+};
+
 #define DRM_MODE_ENCODER_NONE	0
 #define DRM_MODE_ENCODER_DAC	1
 #define DRM_MODE_ENCODER_TMDS	2
-- 
2.0.5
