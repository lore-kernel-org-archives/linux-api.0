From: Gabriel Laskar <gabriel@lse.epita.fr>
Subject: [PATCH 8/9] include/uapi/drm/vmwgfx_drm.h: use __u{32,64} types instead of uint{32,64}_t
Date: Thu, 12 Nov 2015 19:14:10 +0100
Message-ID: <1447352051-22022-9-git-send-email-gabriel@lse.epita.fr>
References: <1447352051-22022-1-git-send-email-gabriel@lse.epita.fr>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1447352051-22022-1-git-send-email-gabriel@lse.epita.fr>
Sender: linux-kernel-owner@vger.kernel.org
To: DRI devel <dri-devel@lists.freedesktop.org>
Cc: Gabriel Laskar <gabriel@lse.epita.fr>, David Airlie <airlied@linux.ie>, "open list:ABI/API" <linux-api@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

Kernel headers should use linux/types.h

Signed-off-by: Gabriel Laskar <gabriel@lse.epita.fr>
---
 include/uapi/drm/vmwgfx_drm.h | 264 +++++++++++++++++++++---------------------
 1 file changed, 132 insertions(+), 132 deletions(-)

diff --git a/include/uapi/drm/vmwgfx_drm.h b/include/uapi/drm/vmwgfx_drm.h
index 05b2049..ef31f44 100644
--- a/include/uapi/drm/vmwgfx_drm.h
+++ b/include/uapi/drm/vmwgfx_drm.h
@@ -111,9 +111,9 @@ enum drm_vmw_handle_type {
  */
 
 struct drm_vmw_getparam_arg {
-	uint64_t value;
-	uint32_t param;
-	uint32_t pad64;
+	__u64 value;
+	__u32 param;
+	__u32 pad64;
 };
 
 /*************************************************************************/
@@ -134,8 +134,8 @@ struct drm_vmw_getparam_arg {
  */
 
 struct drm_vmw_context_arg {
-	int32_t cid;
-	uint32_t pad64;
+	__s32 cid;
+	__u32 pad64;
 };
 
 /*************************************************************************/
@@ -165,7 +165,7 @@ struct drm_vmw_context_arg {
  * @mip_levels: Number of mip levels for each face.
  * An unused face should have 0 encoded.
  * @size_addr: Address of a user-space array of sruct drm_vmw_size
- * cast to an uint64_t for 32-64 bit compatibility.
+ * cast to an __u64 for 32-64 bit compatibility.
  * The size of the array should equal the total number of mipmap levels.
  * @shareable: Boolean whether other clients (as identified by file descriptors)
  * may reference this surface.
@@ -177,12 +177,12 @@ struct drm_vmw_context_arg {
  */
 
 struct drm_vmw_surface_create_req {
-	uint32_t flags;
-	uint32_t format;
-	uint32_t mip_levels[DRM_VMW_MAX_SURFACE_FACES];
-	uint64_t size_addr;
-	int32_t shareable;
-	int32_t scanout;
+	__u32 flags;
+	__u32 format;
+	__u32 mip_levels[DRM_VMW_MAX_SURFACE_FACES];
+	__u64 size_addr;
+	__s32 shareable;
+	__s32 scanout;
 };
 
 /**
@@ -197,7 +197,7 @@ struct drm_vmw_surface_create_req {
  */
 
 struct drm_vmw_surface_arg {
-	int32_t sid;
+	__s32 sid;
 	enum drm_vmw_handle_type handle_type;
 };
 
@@ -213,10 +213,10 @@ struct drm_vmw_surface_arg {
  */
 
 struct drm_vmw_size {
-	uint32_t width;
-	uint32_t height;
-	uint32_t depth;
-	uint32_t pad64;
+	__u32 width;
+	__u32 height;
+	__u32 depth;
+	__u32 pad64;
 };
 
 /**
@@ -284,13 +284,13 @@ union drm_vmw_surface_reference_arg {
 /**
  * struct drm_vmw_execbuf_arg
  *
- * @commands: User-space address of a command buffer cast to an uint64_t.
+ * @commands: User-space address of a command buffer cast to an __u64.
  * @command-size: Size in bytes of the command buffer.
  * @throttle-us: Sleep until software is less than @throttle_us
  * microseconds ahead of hardware. The driver may round this value
  * to the nearest kernel tick.
  * @fence_rep: User-space address of a struct drm_vmw_fence_rep cast to an
- * uint64_t.
+ * __u64.
  * @version: Allows expanding the execbuf ioctl parameters without breaking
  * backwards compatibility, since user-space will always tell the kernel
  * which version it uses.
@@ -302,14 +302,14 @@ union drm_vmw_surface_reference_arg {
 #define DRM_VMW_EXECBUF_VERSION 2
 
 struct drm_vmw_execbuf_arg {
-	uint64_t commands;
-	uint32_t command_size;
-	uint32_t throttle_us;
-	uint64_t fence_rep;
-	uint32_t version;
-	uint32_t flags;
-	uint32_t context_handle;
-	uint32_t pad64;
+	__u64 commands;
+	__u32 command_size;
+	__u32 throttle_us;
+	__u64 fence_rep;
+	__u32 version;
+	__u32 flags;
+	__u32 context_handle;
+	__u32 pad64;
 };
 
 /**
@@ -338,12 +338,12 @@ struct drm_vmw_execbuf_arg {
  */
 
 struct drm_vmw_fence_rep {
-	uint32_t handle;
-	uint32_t mask;
-	uint32_t seqno;
-	uint32_t passed_seqno;
-	uint32_t pad64;
-	int32_t error;
+	__u32 handle;
+	__u32 mask;
+	__u32 seqno;
+	__u32 passed_seqno;
+	__u32 pad64;
+	__s32 error;
 };
 
 /*************************************************************************/
@@ -373,8 +373,8 @@ struct drm_vmw_fence_rep {
  */
 
 struct drm_vmw_alloc_dmabuf_req {
-	uint32_t size;
-	uint32_t pad64;
+	__u32 size;
+	__u32 pad64;
 };
 
 /**
@@ -391,11 +391,11 @@ struct drm_vmw_alloc_dmabuf_req {
  */
 
 struct drm_vmw_dmabuf_rep {
-	uint64_t map_handle;
-	uint32_t handle;
-	uint32_t cur_gmr_id;
-	uint32_t cur_gmr_offset;
-	uint32_t pad64;
+	__u64 map_handle;
+	__u32 handle;
+	__u32 cur_gmr_id;
+	__u32 cur_gmr_offset;
+	__u32 pad64;
 };
 
 /**
@@ -428,8 +428,8 @@ union drm_vmw_alloc_dmabuf_arg {
  */
 
 struct drm_vmw_unref_dmabuf_arg {
-	uint32_t handle;
-	uint32_t pad64;
+	__u32 handle;
+	__u32 pad64;
 };
 
 /*************************************************************************/
@@ -452,10 +452,10 @@ struct drm_vmw_unref_dmabuf_arg {
  */
 
 struct drm_vmw_rect {
-	int32_t x;
-	int32_t y;
-	uint32_t w;
-	uint32_t h;
+	__s32 x;
+	__s32 y;
+	__u32 w;
+	__u32 h;
 };
 
 /**
@@ -477,21 +477,21 @@ struct drm_vmw_rect {
  */
 
 struct drm_vmw_control_stream_arg {
-	uint32_t stream_id;
-	uint32_t enabled;
+	__u32 stream_id;
+	__u32 enabled;
 
-	uint32_t flags;
-	uint32_t color_key;
+	__u32 flags;
+	__u32 color_key;
 
-	uint32_t handle;
-	uint32_t offset;
-	int32_t format;
-	uint32_t size;
-	uint32_t width;
-	uint32_t height;
-	uint32_t pitch[3];
+	__u32 handle;
+	__u32 offset;
+	__s32 format;
+	__u32 size;
+	__u32 width;
+	__u32 height;
+	__u32 pitch[3];
 
-	uint32_t pad64;
+	__u32 pad64;
 	struct drm_vmw_rect src;
 	struct drm_vmw_rect dst;
 };
@@ -519,12 +519,12 @@ struct drm_vmw_control_stream_arg {
  */
 
 struct drm_vmw_cursor_bypass_arg {
-	uint32_t flags;
-	uint32_t crtc_id;
-	int32_t xpos;
-	int32_t ypos;
-	int32_t xhot;
-	int32_t yhot;
+	__u32 flags;
+	__u32 crtc_id;
+	__s32 xpos;
+	__s32 ypos;
+	__s32 xhot;
+	__s32 yhot;
 };
 
 /*************************************************************************/
@@ -542,8 +542,8 @@ struct drm_vmw_cursor_bypass_arg {
  */
 
 struct drm_vmw_stream_arg {
-	uint32_t stream_id;
-	uint32_t pad64;
+	__u32 stream_id;
+	__u32 pad64;
 };
 
 /*************************************************************************/
@@ -565,7 +565,7 @@ struct drm_vmw_stream_arg {
 /**
  * struct drm_vmw_get_3d_cap_arg
  *
- * @buffer: Pointer to a buffer for capability data, cast to an uint64_t
+ * @buffer: Pointer to a buffer for capability data, cast to an __u64
  * @size: Max size to copy
  *
  * Input argument to the DRM_VMW_GET_3D_CAP_IOCTL
@@ -573,9 +573,9 @@ struct drm_vmw_stream_arg {
  */
 
 struct drm_vmw_get_3d_cap_arg {
-	uint64_t buffer;
-	uint32_t max_size;
-	uint32_t pad64;
+	__u64 buffer;
+	__u32 max_size;
+	__u32 pad64;
 };
 
 /*************************************************************************/
@@ -624,14 +624,14 @@ struct drm_vmw_get_3d_cap_arg {
  */
 
 struct drm_vmw_fence_wait_arg {
-	uint32_t handle;
-	int32_t  cookie_valid;
-	uint64_t kernel_cookie;
-	uint64_t timeout_us;
-	int32_t lazy;
-	int32_t flags;
-	int32_t wait_options;
-	int32_t pad64;
+	__u32 handle;
+	__s32  cookie_valid;
+	__u64 kernel_cookie;
+	__u64 timeout_us;
+	__s32 lazy;
+	__s32 flags;
+	__s32 wait_options;
+	__s32 pad64;
 };
 
 /*************************************************************************/
@@ -655,12 +655,12 @@ struct drm_vmw_fence_wait_arg {
  */
 
 struct drm_vmw_fence_signaled_arg {
-	 uint32_t handle;
-	 uint32_t flags;
-	 int32_t signaled;
-	 uint32_t passed_seqno;
-	 uint32_t signaled_flags;
-	 uint32_t pad64;
+	 __u32 handle;
+	 __u32 flags;
+	 __s32 signaled;
+	 __u32 passed_seqno;
+	 __u32 signaled_flags;
+	 __u32 pad64;
 };
 
 /*************************************************************************/
@@ -681,8 +681,8 @@ struct drm_vmw_fence_signaled_arg {
  */
 
 struct drm_vmw_fence_arg {
-	 uint32_t handle;
-	 uint32_t pad64;
+	 __u32 handle;
+	 __u32 pad64;
 };
 
 
@@ -703,9 +703,9 @@ struct drm_vmw_fence_arg {
 
 struct drm_vmw_event_fence {
 	struct drm_event base;
-	uint64_t user_data;
-	uint32_t tv_sec;
-	uint32_t tv_usec;
+	__u64 user_data;
+	__u32 tv_sec;
+	__u32 tv_usec;
 };
 
 /*
@@ -717,17 +717,17 @@ struct drm_vmw_event_fence {
 /**
  * struct drm_vmw_fence_event_arg
  *
- * @fence_rep: Pointer to fence_rep structure cast to uint64_t or 0 if
+ * @fence_rep: Pointer to fence_rep structure cast to __u64 or 0 if
  * the fence is not supposed to be referenced by user-space.
  * @user_info: Info to be delivered with the event.
  * @handle: Attach the event to this fence only.
  * @flags: A set of flags as defined above.
  */
 struct drm_vmw_fence_event_arg {
-	uint64_t fence_rep;
-	uint64_t user_data;
-	uint32_t handle;
-	uint32_t flags;
+	__u64 fence_rep;
+	__u64 user_data;
+	__u32 handle;
+	__u32 flags;
 };
 
 
@@ -747,7 +747,7 @@ struct drm_vmw_fence_event_arg {
  * @sid: Surface id to present from.
  * @dest_x: X placement coordinate for surface.
  * @dest_y: Y placement coordinate for surface.
- * @clips_ptr: Pointer to an array of clip rects cast to an uint64_t.
+ * @clips_ptr: Pointer to an array of clip rects cast to an __u64.
  * @num_clips: Number of cliprects given relative to the framebuffer origin,
  * in the same coordinate space as the frame buffer.
  * @pad64: Unused 64-bit padding.
@@ -756,13 +756,13 @@ struct drm_vmw_fence_event_arg {
  */
 
 struct drm_vmw_present_arg {
-	uint32_t fb_id;
-	uint32_t sid;
-	int32_t dest_x;
-	int32_t dest_y;
-	uint64_t clips_ptr;
-	uint32_t num_clips;
-	uint32_t pad64;
+	__u32 fb_id;
+	__u32 sid;
+	__s32 dest_x;
+	__s32 dest_y;
+	__u64 clips_ptr;
+	__u32 num_clips;
+	__u32 pad64;
 };
 
 
@@ -780,16 +780,16 @@ struct drm_vmw_present_arg {
  * struct drm_vmw_present_arg
  * @fb_id: fb_id to present / read back from.
  * @num_clips: Number of cliprects.
- * @clips_ptr: Pointer to an array of clip rects cast to an uint64_t.
- * @fence_rep: Pointer to a struct drm_vmw_fence_rep, cast to an uint64_t.
+ * @clips_ptr: Pointer to an array of clip rects cast to an __u64.
+ * @fence_rep: Pointer to a struct drm_vmw_fence_rep, cast to an __u64.
  * If this member is NULL, then the ioctl should not return a fence.
  */
 
 struct drm_vmw_present_readback_arg {
-	 uint32_t fb_id;
-	 uint32_t num_clips;
-	 uint64_t clips_ptr;
-	 uint64_t fence_rep;
+	 __u32 fb_id;
+	 __u32 num_clips;
+	 __u64 clips_ptr;
+	 __u64 fence_rep;
 };
 
 /*************************************************************************/
@@ -805,14 +805,14 @@ struct drm_vmw_present_readback_arg {
  * struct drm_vmw_update_layout_arg
  *
  * @num_outputs: number of active connectors
- * @rects: pointer to array of drm_vmw_rect cast to an uint64_t
+ * @rects: pointer to array of drm_vmw_rect cast to an __u64
  *
  * Input argument to the DRM_VMW_UPDATE_LAYOUT Ioctl.
  */
 struct drm_vmw_update_layout_arg {
-	uint32_t num_outputs;
-	uint32_t pad64;
-	uint64_t rects;
+	__u32 num_outputs;
+	__u32 pad64;
+	__u64 rects;
 };
 
 
@@ -849,10 +849,10 @@ enum drm_vmw_shader_type {
  */
 struct drm_vmw_shader_create_arg {
 	enum drm_vmw_shader_type shader_type;
-	uint32_t size;
-	uint32_t buffer_handle;
-	uint32_t shader_handle;
-	uint64_t offset;
+	__u32 size;
+	__u32 buffer_handle;
+	__u32 shader_handle;
+	__u64 offset;
 };
 
 /*************************************************************************/
@@ -871,8 +871,8 @@ struct drm_vmw_shader_create_arg {
  * Input argument to the DRM_VMW_UNREF_SHADER ioctl.
  */
 struct drm_vmw_shader_arg {
-	uint32_t handle;
-	uint32_t pad64;
+	__u32 handle;
+	__u32 pad64;
 };
 
 /*************************************************************************/
@@ -918,14 +918,14 @@ enum drm_vmw_surface_flags {
  * Part of output argument for the DRM_VMW_GB_SURFACE_REF Ioctl.
  */
 struct drm_vmw_gb_surface_create_req {
-	uint32_t svga3d_flags;
-	uint32_t format;
-	uint32_t mip_levels;
+	__u32 svga3d_flags;
+	__u32 format;
+	__u32 mip_levels;
 	enum drm_vmw_surface_flags drm_surface_flags;
-	uint32_t multisample_count;
-	uint32_t autogen_filter;
-	uint32_t buffer_handle;
-	uint32_t array_size;
+	__u32 multisample_count;
+	__u32 autogen_filter;
+	__u32 buffer_handle;
+	__u32 array_size;
 	struct drm_vmw_size base_size;
 };
 
@@ -944,11 +944,11 @@ struct drm_vmw_gb_surface_create_req {
  * Output argument for the DRM_VMW_GB_SURFACE_CREATE ioctl.
  */
 struct drm_vmw_gb_surface_create_rep {
-	uint32_t handle;
-	uint32_t backup_size;
-	uint32_t buffer_handle;
-	uint32_t buffer_size;
-	uint64_t buffer_map_handle;
+	__u32 handle;
+	__u32 backup_size;
+	__u32 buffer_handle;
+	__u32 buffer_size;
+	__u64 buffer_map_handle;
 };
 
 /**
@@ -1061,8 +1061,8 @@ enum drm_vmw_synccpu_op {
 struct drm_vmw_synccpu_arg {
 	enum drm_vmw_synccpu_op op;
 	enum drm_vmw_synccpu_flags flags;
-	uint32_t handle;
-	uint32_t pad64;
+	__u32 handle;
+	__u32 pad64;
 };
 
 /*************************************************************************/
-- 
2.6.2
