From: Thierry Reding <thierry.reding@gmail.com>
Subject: [PATCH v2 3/4] drm/tegra: Add SET/GET_FLAGS IOCTLs
Date: Fri, 27 Jun 2014 10:28:25 +0200
Message-ID: <1403857706-15989-3-git-send-email-thierry.reding@gmail.com>
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

The DRM_TEGRA_GEM_SET_FLAGS IOCTL can be used to set the flags of a
buffer object after it has been allocated or imported. Flags associated
with a buffer object can be queried using the DRM_TEGRA_GEM_GET_FLAGS
IOCTL.

Signed-off-by: Thierry Reding <treding@nvidia.com>
---
Changes in v2:
- use -ENOENT if no GEM object is found

 drivers/gpu/drm/tegra/drm.c  | 49 ++++++++++++++++++++++++++++++++++++++++++++
 include/uapi/drm/tegra_drm.h | 21 +++++++++++++++++++
 2 files changed, 70 insertions(+)

diff --git a/drivers/gpu/drm/tegra/drm.c b/drivers/gpu/drm/tegra/drm.c
index a029525b598f..6e2e714a0649 100644
--- a/drivers/gpu/drm/tegra/drm.c
+++ b/drivers/gpu/drm/tegra/drm.c
@@ -548,6 +548,53 @@ static int tegra_gem_get_tiling(struct drm_device *drm, void *data,
 
 	return err;
 }
+
+static int tegra_gem_set_flags(struct drm_device *drm, void *data,
+			       struct drm_file *file)
+{
+	struct drm_tegra_gem_set_flags *args = data;
+	struct drm_gem_object *gem;
+	struct tegra_bo *bo;
+
+	if (args->flags & ~DRM_TEGRA_GEM_FLAGS)
+		return -EINVAL;
+
+	gem = drm_gem_object_lookup(drm, file, args->handle);
+	if (!gem)
+		return -ENOENT;
+
+	bo = to_tegra_bo(gem);
+	bo->flags = 0;
+
+	if (args->flags & DRM_TEGRA_GEM_BOTTOM_UP)
+		bo->flags |= TEGRA_BO_BOTTOM_UP;
+
+	drm_gem_object_unreference(gem);
+
+	return 0;
+}
+
+static int tegra_gem_get_flags(struct drm_device *drm, void *data,
+			       struct drm_file *file)
+{
+	struct drm_tegra_gem_get_flags *args = data;
+	struct drm_gem_object *gem;
+	struct tegra_bo *bo;
+
+	gem = drm_gem_object_lookup(drm, file, args->handle);
+	if (!gem)
+		return -ENOENT;
+
+	bo = to_tegra_bo(gem);
+	args->flags = 0;
+
+	if (bo->flags & TEGRA_BO_BOTTOM_UP)
+		args->flags |= DRM_TEGRA_GEM_BOTTOM_UP;
+
+	drm_gem_object_unreference(gem);
+
+	return 0;
+}
 #endif
 
 static const struct drm_ioctl_desc tegra_drm_ioctls[] = {
@@ -564,6 +611,8 @@ static const struct drm_ioctl_desc tegra_drm_ioctls[] = {
 	DRM_IOCTL_DEF_DRV(TEGRA_GET_SYNCPT_BASE, tegra_get_syncpt_base, DRM_UNLOCKED),
 	DRM_IOCTL_DEF_DRV(TEGRA_GEM_SET_TILING, tegra_gem_set_tiling, DRM_UNLOCKED),
 	DRM_IOCTL_DEF_DRV(TEGRA_GEM_GET_TILING, tegra_gem_get_tiling, DRM_UNLOCKED),
+	DRM_IOCTL_DEF_DRV(TEGRA_GEM_SET_FLAGS, tegra_gem_set_flags, DRM_UNLOCKED),
+	DRM_IOCTL_DEF_DRV(TEGRA_GEM_GET_FLAGS, tegra_gem_get_flags, DRM_UNLOCKED),
 #endif
 };
 
diff --git a/include/uapi/drm/tegra_drm.h b/include/uapi/drm/tegra_drm.h
index 0829f75eb986..c15d781ecc0f 100644
--- a/include/uapi/drm/tegra_drm.h
+++ b/include/uapi/drm/tegra_drm.h
@@ -150,6 +150,23 @@ struct drm_tegra_gem_get_tiling {
 	__u32 pad;
 };
 
+#define DRM_TEGRA_GEM_BOTTOM_UP		(1 << 0)
+#define DRM_TEGRA_GEM_FLAGS		(DRM_TEGRA_GEM_BOTTOM_UP)
+
+struct drm_tegra_gem_set_flags {
+	/* input */
+	__u32 handle;
+	/* output */
+	__u32 flags;
+};
+
+struct drm_tegra_gem_get_flags {
+	/* input */
+	__u32 handle;
+	/* output */
+	__u32 flags;
+};
+
 #define DRM_TEGRA_GEM_CREATE		0x00
 #define DRM_TEGRA_GEM_MMAP		0x01
 #define DRM_TEGRA_SYNCPT_READ		0x02
@@ -162,6 +179,8 @@ struct drm_tegra_gem_get_tiling {
 #define DRM_TEGRA_GET_SYNCPT_BASE	0x09
 #define DRM_TEGRA_GEM_SET_TILING	0x0a
 #define DRM_TEGRA_GEM_GET_TILING	0x0b
+#define DRM_TEGRA_GEM_SET_FLAGS		0x0c
+#define DRM_TEGRA_GEM_GET_FLAGS		0x0d
 
 #define DRM_IOCTL_TEGRA_GEM_CREATE DRM_IOWR(DRM_COMMAND_BASE + DRM_TEGRA_GEM_CREATE, struct drm_tegra_gem_create)
 #define DRM_IOCTL_TEGRA_GEM_MMAP DRM_IOWR(DRM_COMMAND_BASE + DRM_TEGRA_GEM_MMAP, struct drm_tegra_gem_mmap)
@@ -175,5 +194,7 @@ struct drm_tegra_gem_get_tiling {
 #define DRM_IOCTL_TEGRA_GET_SYNCPT_BASE DRM_IOWR(DRM_COMMAND_BASE + DRM_TEGRA_GET_SYNCPT_BASE, struct drm_tegra_get_syncpt_base)
 #define DRM_IOCTL_TEGRA_GEM_SET_TILING DRM_IOWR(DRM_COMMAND_BASE + DRM_TEGRA_GEM_SET_TILING, struct drm_tegra_gem_set_tiling)
 #define DRM_IOCTL_TEGRA_GEM_GET_TILING DRM_IOWR(DRM_COMMAND_BASE + DRM_TEGRA_GEM_GET_TILING, struct drm_tegra_gem_get_tiling)
+#define DRM_IOCTL_TEGRA_GEM_SET_FLAGS DRM_IOWR(DRM_COMMAND_BASE + DRM_TEGRA_GEM_SET_FLAGS, struct drm_tegra_gem_set_flags)
+#define DRM_IOCTL_TEGRA_GEM_GET_FLAGS DRM_IOWR(DRM_COMMAND_BASE + DRM_TEGRA_GEM_GET_FLAGS, struct drm_tegra_gem_get_flags)
 
 #endif
-- 
2.0.0
