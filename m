From: Mikko Rapeli <mikko.rapeli@iki.fi>
Subject: [PATCH 15/98] include/uapi/drm/qxl_drm.h: use __s32, __u32 and __u64 from linux/types.h
Date: Sat, 30 May 2015 17:38:07 +0200
Message-ID: <1433000370-19509-16-git-send-email-mikko.rapeli@iki.fi>
References: <1433000370-19509-1-git-send-email-mikko.rapeli@iki.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1433000370-19509-1-git-send-email-mikko.rapeli@iki.fi>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Mikko Rapeli <mikko.rapeli@iki.fi>, David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

=46ixes userspace compilation errors like:

error: unknown type name =E2=80=98uint32_t=E2=80=99

Signed-off-by: Mikko Rapeli <mikko.rapeli@iki.fi>
---
 include/uapi/drm/qxl_drm.h | 74 +++++++++++++++++++++++---------------=
--------
 1 file changed, 37 insertions(+), 37 deletions(-)

diff --git a/include/uapi/drm/qxl_drm.h b/include/uapi/drm/qxl_drm.h
index ebebd36..dface36 100644
--- a/include/uapi/drm/qxl_drm.h
+++ b/include/uapi/drm/qxl_drm.h
@@ -30,7 +30,7 @@
 /* Please note that modifications to all structs defined here are
  * subject to backwards-compatibility constraints.
  *
- * Do not use pointers, use uint64_t instead for 32 bit / 64 bit user/=
kernel
+ * Do not use pointers, use __u64 instead for 32 bit / 64 bit user/ker=
nel
  * compatibility Keep fields aligned to their size
  */
=20
@@ -48,14 +48,14 @@
 #define DRM_QXL_ALLOC_SURF  0x06
=20
 struct drm_qxl_alloc {
-	uint32_t size;
-	uint32_t handle; /* 0 is an invalid handle */
+	__u32 size;
+	__u32 handle; /* 0 is an invalid handle */
 };
=20
 struct drm_qxl_map {
-	uint64_t offset; /* use for mmap system call */
-	uint32_t handle;
-	uint32_t pad;
+	__u64 offset; /* use for mmap system call */
+	__u32 handle;
+	__u32 pad;
 };
=20
 /*
@@ -68,59 +68,59 @@ struct drm_qxl_map {
 #define QXL_RELOC_TYPE_SURF 2
=20
 struct drm_qxl_reloc {
-	uint64_t src_offset; /* offset into src_handle or src buffer */
-	uint64_t dst_offset; /* offset in dest handle */
-	uint32_t src_handle; /* dest handle to compute address from */
-	uint32_t dst_handle; /* 0 if to command buffer */
-	uint32_t reloc_type;
-	uint32_t pad;
+	__u64 src_offset; /* offset into src_handle or src buffer */
+	__u64 dst_offset; /* offset in dest handle */
+	__u32 src_handle; /* dest handle to compute address from */
+	__u32 dst_handle; /* 0 if to command buffer */
+	__u32 reloc_type;
+	__u32 pad;
 };
=20
 struct drm_qxl_command {
-	uint64_t	 __user command; /* void* */
-	uint64_t	 __user relocs; /* struct drm_qxl_reloc* */
-	uint32_t		type;
-	uint32_t		command_size;
-	uint32_t		relocs_num;
-	uint32_t                pad;
+	__u64	 __user command; /* void* */
+	__u64	 __user relocs; /* struct drm_qxl_reloc* */
+	__u32		type;
+	__u32		command_size;
+	__u32		relocs_num;
+	__u32                pad;
 };
=20
 /* XXX: call it drm_qxl_commands? */
 struct drm_qxl_execbuffer {
-	uint32_t		flags;		/* for future use */
-	uint32_t		commands_num;
-	uint64_t	 __user commands;	/* struct drm_qxl_command* */
+	__u32		flags;		/* for future use */
+	__u32		commands_num;
+	__u64	 __user commands;	/* struct drm_qxl_command* */
 };
=20
 struct drm_qxl_update_area {
-	uint32_t handle;
-	uint32_t top;
-	uint32_t left;
-	uint32_t bottom;
-	uint32_t right;
-	uint32_t pad;
+	__u32 handle;
+	__u32 top;
+	__u32 left;
+	__u32 bottom;
+	__u32 right;
+	__u32 pad;
 };
=20
 #define QXL_PARAM_NUM_SURFACES 1 /* rom->n_surfaces */
 #define QXL_PARAM_MAX_RELOCS 2
 struct drm_qxl_getparam {
-	uint64_t param;
-	uint64_t value;
+	__u64 param;
+	__u64 value;
 };
=20
 /* these are one bit values */
 struct drm_qxl_clientcap {
-	uint32_t index;
-	uint32_t pad;
+	__u32 index;
+	__u32 pad;
 };
=20
 struct drm_qxl_alloc_surf {
-	uint32_t format;
-	uint32_t width;
-	uint32_t height;
-	int32_t stride;
-	uint32_t handle;
-	uint32_t pad;
+	__u32 format;
+	__u32 width;
+	__u32 height;
+	__s32 stride;
+	__u32 handle;
+	__u32 pad;
 };
=20
 #define DRM_IOCTL_QXL_ALLOC \
--=20
2.1.4
