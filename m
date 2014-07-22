From: Boris BREZILLON <boris.brezillon@free-electrons.com>
Subject: [PATCH 4/5] drm: panel: simple-panel: add support for bus_format
 retrieval
Date: Tue, 22 Jul 2014 14:23:46 +0200
Message-ID: <1406031827-12432-5-git-send-email-boris.brezillon@free-electrons.com>
References: <1406031827-12432-1-git-send-email-boris.brezillon@free-electrons.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dri-devel-bounces@lists.freedesktop.org>
In-Reply-To: <1406031827-12432-1-git-send-email-boris.brezillon@free-electrons.com>
List-Unsubscribe: <http://lists.freedesktop.org/mailman/options/dri-devel>,
 <mailto:dri-devel-request@lists.freedesktop.org?subject=unsubscribe>
List-Archive: <http://lists.freedesktop.org/archives/dri-devel>
List-Post: <mailto:dri-devel@lists.freedesktop.org>
List-Help: <mailto:dri-devel-request@lists.freedesktop.org?subject=help>
List-Subscribe: <http://lists.freedesktop.org/mailman/listinfo/dri-devel>,
 <mailto:dri-devel-request@lists.freedesktop.org?subject=subscribe>
Errors-To: dri-devel-bounces@lists.freedesktop.org
Sender: "dri-devel" <dri-devel-bounces@lists.freedesktop.org>
To: Thierry Reding <thierry.reding@gmail.com>, Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org, Mauro Carvalho Chehab <m.chehab@samsung.com>, linux-media@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Provide a way to specify panel requirement in terms of supported media bus
format (particularly useful for panels connected to an RGB or LVDS bus).

Signed-off-by: Boris BREZILLON <boris.brezillon@free-electrons.com>
---
 drivers/gpu/drm/panel/panel-simple.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/gpu/drm/panel/panel-simple.c b/drivers/gpu/drm/panel/panel-simple.c
index 3f76944..42fd6d1 100644
--- a/drivers/gpu/drm/panel/panel-simple.c
+++ b/drivers/gpu/drm/panel/panel-simple.c
@@ -41,6 +41,8 @@ struct panel_desc {
 		unsigned int width;
 		unsigned int height;
 	} size;
+
+	enum video_bus_format bus_format;
 };
 
 struct panel_simple {
@@ -89,6 +91,9 @@ static int panel_simple_get_fixed_modes(struct panel_simple *panel)
 
 	connector->display_info.width_mm = panel->desc->size.width;
 	connector->display_info.height_mm = panel->desc->size.height;
+	if (panel->desc->bus_format)
+		drm_display_info_set_bus_formats(&connector->display_info,
+						 &panel->desc->bus_format, 1);
 
 	return num;
 }
-- 
1.8.3.2
