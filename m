From: Thierry Reding <thierry.reding@gmail.com>
Subject: [PATCH v2 2/4] drm/tegra: Add SET/GET_TILING IOCTLs
Date: Fri, 27 Jun 2014 10:28:24 +0200
Message-ID: <1403857706-15989-2-git-send-email-thierry.reding@gmail.com>
References: <1403857706-15989-1-git-send-email-thierry.reding@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dri-devel-bounces@lists.freedesktop.org>
In-Reply-To: <1403857706-15989-1-git-send-email-thierry.reding@gmail.com>
List-Unsubscribe: <http://lists.freedesktop.org/mailman/options/dri-devel>,
 <mailto:dri-devel-request@lists.freedesktop.org?subject=unsubscribe>
List-Archive: <http://lists.freedesktop.org/archives/dri-devel>
List-Post: <mailto:dri-devel@lists.freedesktop.org>
List-Help: <mailto:dri-devel-request@lists.freedesktop.org?subject=help>
List-Subscribe: <http://lists.freedesktop.org/mailman/listinfo/dri-devel>,
 <mailto:dri-devel-request@lists.freedesktop.org?subject=subscribe>
Errors-To: dri-devel-bounces@lists.freedesktop.org
Sender: "dri-devel" <dri-devel-bounces@lists.freedesktop.org>
To: dri-devel@lists.freedesktop.org
Cc: linux-tegra@vger.kernel.org, =?UTF-8?q?St=C3=A9phane=20Marchesin?= <marcheu@chromium.org>, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

From: Thierry Reding <treding@nvidia.com>

Currently the tiling parameters of buffer objects can only be set at
allocation time, and only a single tiled mode is supported. This new
DRM_TEGRA_GEM_SET_TILING IOCTL allows more modes to be set and also
allows the tiling mode to be changed after the allocation. This will
enable the Tegra DRM driver to import buffers from a GPU and directly
scan them out by configuring the display controller appropriately.

To complement this, the DRM_TEGRA_GEM_GET_TILING IOCTL can query the
current tiling mode of a buffer object. This is necessary when importing
buffers via handle (as is done in Mesa for example) so that userspace
can determine the proper parameters for the 2D or 3D engines.

Signed-off-by: Thierry Reding <treding@nvidia.com>
---
Changes in v2:
- use -ENOENT if no GEM object is found

 drivers/gpu/drm/tegra/drm.c  | 95 ++++++++++++++++++++++++++++++++++++++++++++
 include/uapi/drm/tegra_drm.h | 25 ++++++++++++
 2 files changed, 120 insertions(+)

diff --git a/drivers/gpu/drm/tegra/drm.c b/drivers/gpu/drm/tegra/drm.c
index fd736efd14bd..a029525b598f 100644
--- a/drivers/gpu/drm/tegra/drm.c
+++ b/drivers/gpu/drm/tegra/drm.c
@@ -455,6 +455,99 @@ static int tegra_get_syncpt_base(struct drm_device *drm, void *data,
 
 	return 0;
 }
+
+static int tegra_gem_set_tiling(struct drm_device *drm, void *data,
+				struct drm_file *file)
+{
+	struct drm_tegra_gem_set_tiling *args = data;
+	enum tegra_bo_tiling_mode mode;
+	struct drm_gem_object *gem;
+	unsigned long value = 0;
+	struct tegra_bo *bo;
+
+	switch (args->mode) {
+	case DRM_TEGRA_GEM_TILING_MODE_PITCH:
+		mode = TEGRA_BO_TILING_MODE_PITCH;
+
+		if (args->value != 0)
+			return -EINVAL;
+
+		break;
+
+	case DRM_TEGRA_GEM_TILING_MODE_TILED:
+		mode = TEGRA_BO_TILING_MODE_TILED;
+
+		if (args->value != 0)
+			return -EINVAL;
+
+		break;
+
+	case DRM_TEGRA_GEM_TILING_MODE_BLOCK:
+		mode = TEGRA_BO_TILING_MODE_BLOCK;
+
+		if (args->value > 5)
+			return -EINVAL;
+
+		value = args->value;
+		break;
+
+	default:
+		return -EINVAL;
+	}
+
+	gem = drm_gem_object_lookup(drm, file, args->handle);
+	if (!gem)
+		return -ENOENT;
+
+	bo = to_tegra_bo(gem);
+
+	bo->tiling.mode = mode;
+	bo->tiling.value = value;
+
+	drm_gem_object_unreference(gem);
+
+	return 0;
+}
+
+static int tegra_gem_get_tiling(struct drm_device *drm, void *data,
+				struct drm_file *file)
+{
+	struct drm_tegra_gem_get_tiling *args = data;
+	struct drm_gem_object *gem;
+	struct tegra_bo *bo;
+	int err = 0;
+
+	gem = drm_gem_object_lookup(drm, file, args->handle);
+	if (!gem)
+		return -ENOENT;
+
+	bo = to_tegra_bo(gem);
+
+	switch (bo->tiling.mode) {
+	case TEGRA_BO_TILING_MODE_PITCH:
+		args->mode = DRM_TEGRA_GEM_TILING_MODE_PITCH;
+		args->value = 0;
+		break;
+
+	case TEGRA_BO_TILING_MODE_TILED:
+		args->mode = DRM_TEGRA_GEM_TILING_MODE_TILED;
+		args->value = 0;
+		break;
+
+	case TEGRA_BO_TILING_MODE_BLOCK:
+		args->mode = DRM_TEGRA_GEM_TILING_MODE_BLOCK;
+		args->value = bo->tiling.value;
+		break;
+
+	default:
+		err = -EINVAL;
+		break;
+	}
+
+	drm_gem_object_unreference(gem);
+
+	return err;
+}
 #endif
 
 static const struct drm_ioctl_desc tegra_drm_ioctls[] = {
@@ -469,6 +562,8 @@ static const struct drm_ioctl_desc tegra_drm_ioctls[] = {
 	DRM_IOCTL_DEF_DRV(TEGRA_GET_SYNCPT, tegra_get_syncpt, DRM_UNLOCKED),
 	DRM_IOCTL_DEF_DRV(TEGRA_SUBMIT, tegra_submit, DRM_UNLOCKED),
 	DRM_IOCTL_DEF_DRV(TEGRA_GET_SYNCPT_BASE, tegra_get_syncpt_base, DRM_UNLOCKED),
+	DRM_IOCTL_DEF_DRV(TEGRA_GEM_SET_TILING, tegra_gem_set_tiling, DRM_UNLOCKED),
+	DRM_IOCTL_DEF_DRV(TEGRA_GEM_GET_TILING, tegra_gem_get_tiling, DRM_UNLOCKED),
 #endif
 };
 
diff --git a/include/uapi/drm/tegra_drm.h b/include/uapi/drm/tegra_drm.h
index b75482112428..0829f75eb986 100644
--- a/include/uapi/drm/tegra_drm.h
+++ b/include/uapi/drm/tegra_drm.h
@@ -129,6 +129,27 @@ struct drm_tegra_submit {
 	__u32 reserved[5];	/* future expansion */
 };
 
+#define DRM_TEGRA_GEM_TILING_MODE_PITCH 0
+#define DRM_TEGRA_GEM_TILING_MODE_TILED 1
+#define DRM_TEGRA_GEM_TILING_MODE_BLOCK 2
+
+struct drm_tegra_gem_set_tiling {
+	/* input */
+	__u32 handle;
+	__u32 mode;
+	__u32 value;
+	__u32 pad;
+};
+
+struct drm_tegra_gem_get_tiling {
+	/* input */
+	__u32 handle;
+	/* output */
+	__u32 mode;
+	__u32 value;
+	__u32 pad;
+};
+
 #define DRM_TEGRA_GEM_CREATE		0x00
 #define DRM_TEGRA_GEM_MMAP		0x01
 #define DRM_TEGRA_SYNCPT_READ		0x02
@@ -139,6 +160,8 @@ struct drm_tegra_submit {
 #define DRM_TEGRA_GET_SYNCPT		0x07
 #define DRM_TEGRA_SUBMIT		0x08
 #define DRM_TEGRA_GET_SYNCPT_BASE	0x09
+#define DRM_TEGRA_GEM_SET_TILING	0x0a
+#define DRM_TEGRA_GEM_GET_TILING	0x0b
 
 #define DRM_IOCTL_TEGRA_GEM_CREATE DRM_IOWR(DRM_COMMAND_BASE + DRM_TEGRA_GEM_CREATE, struct drm_tegra_gem_create)
 #define DRM_IOCTL_TEGRA_GEM_MMAP DRM_IOWR(DRM_COMMAND_BASE + DRM_TEGRA_GEM_MMAP, struct drm_tegra_gem_mmap)
@@ -150,5 +173,7 @@ struct drm_tegra_submit {
 #define DRM_IOCTL_TEGRA_GET_SYNCPT DRM_IOWR(DRM_COMMAND_BASE + DRM_TEGRA_GET_SYNCPT, struct drm_tegra_get_syncpt)
 #define DRM_IOCTL_TEGRA_SUBMIT DRM_IOWR(DRM_COMMAND_BASE + DRM_TEGRA_SUBMIT, struct drm_tegra_submit)
 #define DRM_IOCTL_TEGRA_GET_SYNCPT_BASE DRM_IOWR(DRM_COMMAND_BASE + DRM_TEGRA_GET_SYNCPT_BASE, struct drm_tegra_get_syncpt_base)
+#define DRM_IOCTL_TEGRA_GEM_SET_TILING DRM_IOWR(DRM_COMMAND_BASE + DRM_TEGRA_GEM_SET_TILING, struct drm_tegra_gem_set_tiling)
+#define DRM_IOCTL_TEGRA_GEM_GET_TILING DRM_IOWR(DRM_COMMAND_BASE + DRM_TEGRA_GEM_GET_TILING, struct drm_tegra_gem_get_tiling)
 
 #endif
-- 
2.0.0
