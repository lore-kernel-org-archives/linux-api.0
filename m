From: Laurent Pinchart <laurent.pinchart+renesas-ryLnwIuWjnjg/C1BVhZhaw@public.gmane.org>
Subject: [RFC/PATCH v2 1/5] drm: Add live source object
Date: Mon, 13 Apr 2015 21:39:43 +0300
Message-ID: <1428950387-6913-2-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
References: <1428950387-6913-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1428950387-6913-1-git-send-email-laurent.pinchart+renesas-ryLnwIuWjnjg/C1BVhZhaw@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org
Cc: linux-media-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-sh-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Magnus Damm <magnus.damm-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Daniel Vetter <daniel.vetter-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Live sources represent a hardware connection between a video stream
source and a CRTC, going through a plane. The kernel API lets driver
register live sources, and the userspace API lets applications enumerate
them.

Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas-ryLnwIuWjnjg/C1BVhZhaw@public.gmane.org>
---
 drivers/gpu/drm/drm_crtc.c  | 164 ++++++++++++++++++++++++++++++++++++++++++++
 drivers/gpu/drm/drm_ioctl.c |   2 +
 include/drm/drm_crtc.h      |  35 ++++++++++
 include/uapi/drm/drm.h      |   3 +
 include/uapi/drm/drm_mode.h |  16 +++++
 5 files changed, 220 insertions(+)

diff --git a/drivers/gpu/drm/drm_crtc.c b/drivers/gpu/drm/drm_crtc.c
index b3989e23195e..1f71978b4f17 100644
--- a/drivers/gpu/drm/drm_crtc.c
+++ b/drivers/gpu/drm/drm_crtc.c
@@ -1265,6 +1265,70 @@ void drm_plane_cleanup(struct drm_plane *plane)
 }
 EXPORT_SYMBOL(drm_plane_cleanup);
 
+int drm_live_source_init(struct drm_device *dev, struct drm_live_source *src,
+			 const char *name, unsigned long possible_planes,
+			 const uint32_t *formats, uint32_t format_count,
+			 const struct drm_live_source_funcs *funcs)
+{
+	unsigned int i;
+	int ret;
+
+	/* Multi-planar live sources are not supported for now. */
+	for (i = 0; i < format_count; ++i) {
+		if (drm_format_num_planes(formats[i]) != 1) {
+			DRM_DEBUG_KMS("multiplanar live sources unsupported\n");
+			return -EINVAL;
+		}
+	}
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
+	src->format_types = kmalloc_array(format_count,
+					  sizeof(*src->format_types),
+					  GFP_KERNEL);
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
@@ -2616,6 +2680,99 @@ int drm_mode_setplane(struct drm_device *dev, void *data,
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
+			return -EFAULT;
+		}
+	}
+	src_resp->count_format_types = src->format_count;
+
+	return 0;
+}
+
+/**
  * drm_mode_set_config_internal - helper to call ->set_config
  * @set: modeset config to set
  *
@@ -5435,6 +5592,7 @@ void drm_mode_config_init(struct drm_device *dev)
 	INIT_LIST_HEAD(&dev->mode_config.property_list);
 	INIT_LIST_HEAD(&dev->mode_config.property_blob_list);
 	INIT_LIST_HEAD(&dev->mode_config.plane_list);
+	INIT_LIST_HEAD(&dev->mode_config.live_source_list);
 	idr_init(&dev->mode_config.crtc_idr);
 	idr_init(&dev->mode_config.tile_idr);
 
@@ -5474,6 +5632,7 @@ void drm_mode_config_cleanup(struct drm_device *dev)
 	struct drm_property *property, *pt;
 	struct drm_property_blob *blob, *bt;
 	struct drm_plane *plane, *plt;
+	struct drm_live_source *src, *psrc;
 
 	list_for_each_entry_safe(encoder, enct, &dev->mode_config.encoder_list,
 				 head) {
@@ -5513,6 +5672,11 @@ void drm_mode_config_cleanup(struct drm_device *dev)
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
index 266dcd6cdf3b..e3b01a19f9ac 100644
--- a/drivers/gpu/drm/drm_ioctl.c
+++ b/drivers/gpu/drm/drm_ioctl.c
@@ -614,10 +614,12 @@ static const struct drm_ioctl_desc drm_ioctls[] = {
 	DRM_IOCTL_DEF(DRM_IOCTL_PRIME_FD_TO_HANDLE, drm_prime_fd_to_handle_ioctl, DRM_AUTH|DRM_UNLOCKED|DRM_RENDER_ALLOW),
 
 	DRM_IOCTL_DEF(DRM_IOCTL_MODE_GETPLANERESOURCES, drm_mode_getplane_res, DRM_CONTROL_ALLOW|DRM_UNLOCKED),
+	DRM_IOCTL_DEF(DRM_IOCTL_MODE_GETSOURCERESOURCES, drm_mode_getsource_res, DRM_CONTROL_ALLOW|DRM_UNLOCKED),
 	DRM_IOCTL_DEF(DRM_IOCTL_MODE_GETCRTC, drm_mode_getcrtc, DRM_CONTROL_ALLOW|DRM_UNLOCKED),
 	DRM_IOCTL_DEF(DRM_IOCTL_MODE_SETCRTC, drm_mode_setcrtc, DRM_MASTER|DRM_CONTROL_ALLOW|DRM_UNLOCKED),
 	DRM_IOCTL_DEF(DRM_IOCTL_MODE_GETPLANE, drm_mode_getplane, DRM_CONTROL_ALLOW|DRM_UNLOCKED),
 	DRM_IOCTL_DEF(DRM_IOCTL_MODE_SETPLANE, drm_mode_setplane, DRM_MASTER|DRM_CONTROL_ALLOW|DRM_UNLOCKED),
+	DRM_IOCTL_DEF(DRM_IOCTL_MODE_GETSOURCE, drm_mode_getsource, DRM_CONTROL_ALLOW|DRM_UNLOCKED),
 	DRM_IOCTL_DEF(DRM_IOCTL_MODE_CURSOR, drm_mode_cursor_ioctl, DRM_MASTER|DRM_CONTROL_ALLOW|DRM_UNLOCKED),
 	DRM_IOCTL_DEF(DRM_IOCTL_MODE_GETGAMMA, drm_mode_gamma_get_ioctl, DRM_UNLOCKED),
 	DRM_IOCTL_DEF(DRM_IOCTL_MODE_SETGAMMA, drm_mode_gamma_set_ioctl, DRM_MASTER|DRM_UNLOCKED),
diff --git a/include/drm/drm_crtc.h b/include/drm/drm_crtc.h
index 2e80ad1aea84..4d111d8a1782 100644
--- a/include/drm/drm_crtc.h
+++ b/include/drm/drm_crtc.h
@@ -53,6 +53,7 @@ struct fence;
 #define DRM_MODE_OBJECT_FB 0xfbfbfbfb
 #define DRM_MODE_OBJECT_BLOB 0xbbbbbbbb
 #define DRM_MODE_OBJECT_PLANE 0xeeeeeeee
+#define DRM_MODE_OBJECT_LIVE_SOURCE 0xe1e1e1e1
 #define DRM_MODE_OBJECT_ANY 0
 
 struct drm_mode_object {
@@ -246,6 +247,7 @@ struct drm_pending_vblank_event;
 struct drm_plane;
 struct drm_bridge;
 struct drm_atomic_state;
+struct drm_live_source;
 
 /**
  * struct drm_crtc_state - mutable CRTC state
@@ -868,6 +870,25 @@ struct drm_plane {
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
+	const struct drm_live_source_funcs *funcs;
+};
+
 /**
  * struct drm_bridge_funcs - drm_bridge control functions
  * @attach: Called during drm_bridge_attach
@@ -1086,6 +1107,8 @@ struct drm_mode_config {
 	int num_overlay_plane;
 	int num_total_plane;
 	struct list_head plane_list;
+	int num_live_source;
+	struct list_head live_source_list;
 
 	int num_crtc;
 	struct list_head crtc_list;
@@ -1185,6 +1208,7 @@ struct drm_mode_config {
 #define obj_to_property(x) container_of(x, struct drm_property, base)
 #define obj_to_blob(x) container_of(x, struct drm_property_blob, base)
 #define obj_to_plane(x) container_of(x, struct drm_plane, base)
+#define obj_to_live_source(x) container_of(x, struct drm_live_source, base)
 
 struct drm_prop_enum_list {
 	int type;
@@ -1275,6 +1299,13 @@ extern int drm_crtc_check_viewport(const struct drm_crtc *crtc,
 
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
@@ -1390,6 +1421,8 @@ extern int drm_mode_getresources(struct drm_device *dev,
 				 void *data, struct drm_file *file_priv);
 extern int drm_mode_getplane_res(struct drm_device *dev, void *data,
 				   struct drm_file *file_priv);
+extern int drm_mode_getsource_res(struct drm_device *dev, void *data,
+				  struct drm_file *file_priv);
 extern int drm_mode_getcrtc(struct drm_device *dev,
 			    void *data, struct drm_file *file_priv);
 extern int drm_mode_getconnector(struct drm_device *dev,
@@ -1401,6 +1434,8 @@ extern int drm_mode_getplane(struct drm_device *dev,
 			       void *data, struct drm_file *file_priv);
 extern int drm_mode_setplane(struct drm_device *dev,
 			       void *data, struct drm_file *file_priv);
+extern int drm_mode_getsource(struct drm_device *dev,
+			      void *data, struct drm_file *file_priv);
 extern int drm_mode_cursor_ioctl(struct drm_device *dev,
 				void *data, struct drm_file *file_priv);
 extern int drm_mode_cursor2_ioctl(struct drm_device *dev,
diff --git a/include/uapi/drm/drm.h b/include/uapi/drm/drm.h
index ff6ef62d084b..92621bd5194b 100644
--- a/include/uapi/drm/drm.h
+++ b/include/uapi/drm/drm.h
@@ -787,6 +787,9 @@ struct drm_prime_handle {
 #define DRM_IOCTL_MODE_CURSOR2		DRM_IOWR(0xBB, struct drm_mode_cursor2)
 #define DRM_IOCTL_MODE_ATOMIC		DRM_IOWR(0xBC, struct drm_mode_atomic)
 
+#define DRM_IOCTL_MODE_GETSOURCERESOURCES DRM_IOWR(0xBD, struct drm_mode_get_live_source_res)
+#define DRM_IOCTL_MODE_GETSOURCE	DRM_IOWR(0xBE, struct drm_mode_get_live_source)
+
 /**
  * Device specific ioctls should only be in their respective headers
  * The device specific ioctl range is from 0x40 to 0x9f.
diff --git a/include/uapi/drm/drm_mode.h b/include/uapi/drm/drm_mode.h
index dbeba949462a..e4d09f6f20eb 100644
--- a/include/uapi/drm/drm_mode.h
+++ b/include/uapi/drm/drm_mode.h
@@ -33,6 +33,7 @@
 #define DRM_CONNECTOR_NAME_LEN	32
 #define DRM_DISPLAY_MODE_LEN	32
 #define DRM_PROP_NAME_LEN	32
+#define DRM_SOURCE_NAME_LEN	32
 
 #define DRM_MODE_TYPE_BUILTIN	(1<<0)
 #define DRM_MODE_TYPE_CLOCK_C	((1<<1) | DRM_MODE_TYPE_BUILTIN)
@@ -179,6 +180,21 @@ struct drm_mode_get_plane_res {
 	__u32 count_planes;
 };
 
+struct drm_mode_get_live_source {
+	__u32 source_id;
+	char name[DRM_SOURCE_NAME_LEN];
+
+	__u32 possible_planes;
+
+	__u32 count_format_types;
+	__u64 format_type_ptr;
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
