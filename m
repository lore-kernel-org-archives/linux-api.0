From: Thierry Reding <thierry.reding@gmail.com>
Subject: [PATCH v2 1/4] drm/tegra: Implement more tiling modes
Date: Fri, 27 Jun 2014 10:28:23 +0200
Message-ID: <1403857706-15989-1-git-send-email-thierry.reding@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dri-devel-bounces@lists.freedesktop.org>
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

Tegra124 supports a block-linear mode in addition to the regular pitch
linear and tiled modes. Add support for these by moving the internal
representation into a structure rather than a simple flag.

Signed-off-by: Thierry Reding <treding@nvidia.com>
---
Changes in v2:
- none

 drivers/gpu/drm/tegra/dc.c  | 102 +++++++++++++++++++++++++++++++++++++-------
 drivers/gpu/drm/tegra/dc.h  |   5 +++
 drivers/gpu/drm/tegra/drm.h |   8 +++-
 drivers/gpu/drm/tegra/fb.c  |   9 ++--
 drivers/gpu/drm/tegra/gem.c |   2 +-
 drivers/gpu/drm/tegra/gem.h |  16 ++++++-
 6 files changed, 118 insertions(+), 24 deletions(-)

diff --git a/drivers/gpu/drm/tegra/dc.c b/drivers/gpu/drm/tegra/dc.c
index ef40381f3909..afcca04f5367 100644
--- a/drivers/gpu/drm/tegra/dc.c
+++ b/drivers/gpu/drm/tegra/dc.c
@@ -18,6 +18,7 @@
 struct tegra_dc_soc_info {
 	bool supports_interlacing;
 	bool supports_cursor;
+	bool supports_block_linear;
 };
 
 struct tegra_plane {
@@ -212,15 +213,44 @@ static int tegra_dc_setup_window(struct tegra_dc *dc, unsigned int index,
 	tegra_dc_writel(dc, h_offset, DC_WINBUF_ADDR_H_OFFSET);
 	tegra_dc_writel(dc, v_offset, DC_WINBUF_ADDR_V_OFFSET);
 
-	if (window->tiled) {
-		value = DC_WIN_BUFFER_ADDR_MODE_TILE_UV |
-			DC_WIN_BUFFER_ADDR_MODE_TILE;
+	if (dc->soc->supports_block_linear) {
+		unsigned long height = window->tiling.value;
+
+		switch (window->tiling.mode) {
+		case TEGRA_BO_TILING_MODE_PITCH:
+			value = DC_WINBUF_SURFACE_KIND_PITCH;
+			break;
+
+		case TEGRA_BO_TILING_MODE_TILED:
+			value = DC_WINBUF_SURFACE_KIND_TILED;
+			break;
+
+		case TEGRA_BO_TILING_MODE_BLOCK:
+			value = DC_WINBUF_SURFACE_KIND_BLOCK_HEIGHT(height) |
+				DC_WINBUF_SURFACE_KIND_BLOCK;
+			break;
+		}
+
+		tegra_dc_writel(dc, value, DC_WINBUF_SURFACE_KIND);
 	} else {
-		value = DC_WIN_BUFFER_ADDR_MODE_LINEAR_UV |
-			DC_WIN_BUFFER_ADDR_MODE_LINEAR;
-	}
+		switch (window->tiling.mode) {
+		case TEGRA_BO_TILING_MODE_PITCH:
+			value = DC_WIN_BUFFER_ADDR_MODE_LINEAR_UV |
+				DC_WIN_BUFFER_ADDR_MODE_LINEAR;
+			break;
 
-	tegra_dc_writel(dc, value, DC_WIN_BUFFER_ADDR_MODE);
+		case TEGRA_BO_TILING_MODE_TILED:
+			value = DC_WIN_BUFFER_ADDR_MODE_TILE_UV |
+				DC_WIN_BUFFER_ADDR_MODE_TILE;
+			break;
+
+		case TEGRA_BO_TILING_MODE_BLOCK:
+			DRM_ERROR("hardware doesn't support block linear mode\n");
+			return -EINVAL;
+		}
+
+		tegra_dc_writel(dc, value, DC_WIN_BUFFER_ADDR_MODE);
+	}
 
 	value = WIN_ENABLE;
 
@@ -288,6 +318,7 @@ static int tegra_plane_update(struct drm_plane *plane, struct drm_crtc *crtc,
 	struct tegra_dc *dc = to_tegra_dc(crtc);
 	struct tegra_dc_window window;
 	unsigned int i;
+	int err;
 
 	memset(&window, 0, sizeof(window));
 	window.src.x = src_x >> 16;
@@ -301,7 +332,10 @@ static int tegra_plane_update(struct drm_plane *plane, struct drm_crtc *crtc,
 	window.format = tegra_dc_format(fb->pixel_format, &window.swap);
 	window.bits_per_pixel = fb->bits_per_pixel;
 	window.bottom_up = tegra_fb_is_bottom_up(fb);
-	window.tiled = tegra_fb_is_tiled(fb);
+
+	err = tegra_fb_get_tiling(fb, &window.tiling);
+	if (err < 0)
+		return err;
 
 	for (i = 0; i < drm_format_num_planes(fb->pixel_format); i++) {
 		struct tegra_bo *bo = tegra_fb_get_plane(fb, i);
@@ -402,8 +436,14 @@ static int tegra_dc_set_base(struct tegra_dc *dc, int x, int y,
 {
 	struct tegra_bo *bo = tegra_fb_get_plane(fb, 0);
 	unsigned int h_offset = 0, v_offset = 0;
+	struct tegra_bo_tiling tiling;
 	unsigned int format, swap;
 	unsigned long value;
+	int err;
+
+	err = tegra_fb_get_tiling(fb, &tiling);
+	if (err < 0)
+		return err;
 
 	tegra_dc_writel(dc, WINDOW_A_SELECT, DC_CMD_DISPLAY_WINDOW_HEADER);
 
@@ -417,15 +457,44 @@ static int tegra_dc_set_base(struct tegra_dc *dc, int x, int y,
 	tegra_dc_writel(dc, format, DC_WIN_COLOR_DEPTH);
 	tegra_dc_writel(dc, swap, DC_WIN_BYTE_SWAP);
 
-	if (tegra_fb_is_tiled(fb)) {
-		value = DC_WIN_BUFFER_ADDR_MODE_TILE_UV |
-			DC_WIN_BUFFER_ADDR_MODE_TILE;
+	if (dc->soc->supports_block_linear) {
+		unsigned long height = tiling.value;
+
+		switch (tiling.mode) {
+		case TEGRA_BO_TILING_MODE_PITCH:
+			value = DC_WINBUF_SURFACE_KIND_PITCH;
+			break;
+
+		case TEGRA_BO_TILING_MODE_TILED:
+			value = DC_WINBUF_SURFACE_KIND_TILED;
+			break;
+
+		case TEGRA_BO_TILING_MODE_BLOCK:
+			value = DC_WINBUF_SURFACE_KIND_BLOCK_HEIGHT(height) |
+				DC_WINBUF_SURFACE_KIND_BLOCK;
+			break;
+		}
+
+		tegra_dc_writel(dc, value, DC_WINBUF_SURFACE_KIND);
 	} else {
-		value = DC_WIN_BUFFER_ADDR_MODE_LINEAR_UV |
-			DC_WIN_BUFFER_ADDR_MODE_LINEAR;
-	}
+		switch (tiling.mode) {
+		case TEGRA_BO_TILING_MODE_PITCH:
+			value = DC_WIN_BUFFER_ADDR_MODE_LINEAR_UV |
+				DC_WIN_BUFFER_ADDR_MODE_LINEAR;
+			break;
 
-	tegra_dc_writel(dc, value, DC_WIN_BUFFER_ADDR_MODE);
+		case TEGRA_BO_TILING_MODE_TILED:
+			value = DC_WIN_BUFFER_ADDR_MODE_TILE_UV |
+				DC_WIN_BUFFER_ADDR_MODE_TILE;
+			break;
+
+		case TEGRA_BO_TILING_MODE_BLOCK:
+			DRM_ERROR("hardware doesn't support block linear mode\n");
+			return -EINVAL;
+		}
+
+		tegra_dc_writel(dc, value, DC_WIN_BUFFER_ADDR_MODE);
+	}
 
 	/* make sure bottom-up buffers are properly displayed */
 	if (tegra_fb_is_bottom_up(fb)) {
@@ -1277,16 +1346,19 @@ static const struct host1x_client_ops dc_client_ops = {
 static const struct tegra_dc_soc_info tegra20_dc_soc_info = {
 	.supports_interlacing = false,
 	.supports_cursor = false,
+	.supports_block_linear = false,
 };
 
 static const struct tegra_dc_soc_info tegra30_dc_soc_info = {
 	.supports_interlacing = false,
 	.supports_cursor = false,
+	.supports_block_linear = false,
 };
 
 static const struct tegra_dc_soc_info tegra124_dc_soc_info = {
 	.supports_interlacing = true,
 	.supports_cursor = true,
+	.supports_block_linear = true,
 };
 
 static const struct of_device_id tegra_dc_of_match[] = {
diff --git a/drivers/gpu/drm/tegra/dc.h b/drivers/gpu/drm/tegra/dc.h
index 78c5feff95d2..705c93b00794 100644
--- a/drivers/gpu/drm/tegra/dc.h
+++ b/drivers/gpu/drm/tegra/dc.h
@@ -428,6 +428,11 @@
 #define DC_WINBUF_ADDR_V_OFFSET_NS		0x809
 
 #define DC_WINBUF_UFLOW_STATUS			0x80a
+#define DC_WINBUF_SURFACE_KIND			0x80b
+#define DC_WINBUF_SURFACE_KIND_PITCH	(0 << 0)
+#define DC_WINBUF_SURFACE_KIND_TILED	(1 << 0)
+#define DC_WINBUF_SURFACE_KIND_BLOCK	(2 << 0)
+#define DC_WINBUF_SURFACE_KIND_BLOCK_HEIGHT(x) (((x) & 0x7) << 4)
 
 #define DC_WINBUF_AD_UFLOW_STATUS		0xbca
 #define DC_WINBUF_BD_UFLOW_STATUS		0xdca
diff --git a/drivers/gpu/drm/tegra/drm.h b/drivers/gpu/drm/tegra/drm.h
index 0d30689dff01..96d754e7b3eb 100644
--- a/drivers/gpu/drm/tegra/drm.h
+++ b/drivers/gpu/drm/tegra/drm.h
@@ -19,6 +19,8 @@
 #include <drm/drm_fb_helper.h>
 #include <drm/drm_fixed.h>
 
+#include "gem.h"
+
 struct reset_control;
 
 struct tegra_fb {
@@ -160,7 +162,8 @@ struct tegra_dc_window {
 	unsigned int stride[2];
 	unsigned long base[3];
 	bool bottom_up;
-	bool tiled;
+
+	struct tegra_bo_tiling tiling;
 };
 
 /* from dc.c */
@@ -279,7 +282,8 @@ int tegra_dpaux_train(struct tegra_dpaux *dpaux, struct drm_dp_link *link,
 struct tegra_bo *tegra_fb_get_plane(struct drm_framebuffer *framebuffer,
 				    unsigned int index);
 bool tegra_fb_is_bottom_up(struct drm_framebuffer *framebuffer);
-bool tegra_fb_is_tiled(struct drm_framebuffer *framebuffer);
+int tegra_fb_get_tiling(struct drm_framebuffer *framebuffer,
+			struct tegra_bo_tiling *tiling);
 int tegra_drm_fb_prepare(struct drm_device *drm);
 int tegra_drm_fb_init(struct drm_device *drm);
 void tegra_drm_fb_exit(struct drm_device *drm);
diff --git a/drivers/gpu/drm/tegra/fb.c b/drivers/gpu/drm/tegra/fb.c
index fc1528e0bda1..7790d43ad082 100644
--- a/drivers/gpu/drm/tegra/fb.c
+++ b/drivers/gpu/drm/tegra/fb.c
@@ -46,14 +46,15 @@ bool tegra_fb_is_bottom_up(struct drm_framebuffer *framebuffer)
 	return false;
 }
 
-bool tegra_fb_is_tiled(struct drm_framebuffer *framebuffer)
+int tegra_fb_get_tiling(struct drm_framebuffer *framebuffer,
+			struct tegra_bo_tiling *tiling)
 {
 	struct tegra_fb *fb = to_tegra_fb(framebuffer);
 
-	if (fb->planes[0]->flags & TEGRA_BO_TILED)
-		return true;
+	/* TODO: handle YUV formats? */
+	*tiling = fb->planes[0]->tiling;
 
-	return false;
+	return 0;
 }
 
 static void tegra_fb_destroy(struct drm_framebuffer *framebuffer)
diff --git a/drivers/gpu/drm/tegra/gem.c b/drivers/gpu/drm/tegra/gem.c
index aa85b7b26f10..c1e4e8b6e5ca 100644
--- a/drivers/gpu/drm/tegra/gem.c
+++ b/drivers/gpu/drm/tegra/gem.c
@@ -126,7 +126,7 @@ struct tegra_bo *tegra_bo_create(struct drm_device *drm, unsigned int size,
 		goto err_mmap;
 
 	if (flags & DRM_TEGRA_GEM_CREATE_TILED)
-		bo->flags |= TEGRA_BO_TILED;
+		bo->tiling.mode = TEGRA_BO_TILING_MODE_TILED;
 
 	if (flags & DRM_TEGRA_GEM_CREATE_BOTTOM_UP)
 		bo->flags |= TEGRA_BO_BOTTOM_UP;
diff --git a/drivers/gpu/drm/tegra/gem.h b/drivers/gpu/drm/tegra/gem.h
index 2f3fe96c5154..43a25c853357 100644
--- a/drivers/gpu/drm/tegra/gem.h
+++ b/drivers/gpu/drm/tegra/gem.h
@@ -16,8 +16,18 @@
 #include <drm/drm.h>
 #include <drm/drmP.h>
 
-#define TEGRA_BO_TILED     (1 << 0)
-#define TEGRA_BO_BOTTOM_UP (1 << 1)
+#define TEGRA_BO_BOTTOM_UP (1 << 0)
+
+enum tegra_bo_tiling_mode {
+	TEGRA_BO_TILING_MODE_PITCH,
+	TEGRA_BO_TILING_MODE_TILED,
+	TEGRA_BO_TILING_MODE_BLOCK,
+};
+
+struct tegra_bo_tiling {
+	enum tegra_bo_tiling_mode mode;
+	unsigned long value;
+};
 
 struct tegra_bo {
 	struct drm_gem_object gem;
@@ -26,6 +36,8 @@ struct tegra_bo {
 	struct sg_table *sgt;
 	dma_addr_t paddr;
 	void *vaddr;
+
+	struct tegra_bo_tiling tiling;
 };
 
 static inline struct tegra_bo *to_tegra_bo(struct drm_gem_object *gem)
-- 
2.0.0
