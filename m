From: Boris Brezillon <boris.brezillon@free-electrons.com>
Subject: [PATCH 12/15] [media] i2c: Replace v4l2-mediabus.h inclusion with v4l2-mbus.h
Date: Tue,  4 Nov 2014 10:55:07 +0100
Message-ID: <1415094910-15899-13-git-send-email-boris.brezillon@free-electrons.com>
References: <1415094910-15899-1-git-send-email-boris.brezillon@free-electrons.com>
Return-path: <linux-doc-owner@vger.kernel.org>
In-Reply-To: <1415094910-15899-1-git-send-email-boris.brezillon@free-electrons.com>
Sender: linux-doc-owner@vger.kernel.org
To: Mauro Carvalho Chehab <m.chehab@samsung.com>, Hans Verkuil <hans.verkuil@cisco.com>, Laurent Pinchart <laurent.pinchart@ideasonboard.com>, linux-media@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, linux-api@vger.kernel.org, devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, Guennadi Liakhovetski <g.liakhovetski@gmx.de>, Boris Brezillon <boris.brezillon@free-electrons.com>
List-Id: linux-api@vger.kernel.org

The v4l2-mediabus.h header is now deprecated and should be replaced with
v4l2-mbus.h.

Signed-off-by: Boris Brezillon <boris.brezillon@free-electrons.com>
---
 drivers/media/i2c/mt9m032.c               | 2 +-
 drivers/media/i2c/mt9t001.c               | 2 +-
 drivers/media/i2c/mt9v032.c               | 2 +-
 drivers/media/i2c/smiapp/smiapp-core.c    | 2 +-
 drivers/media/i2c/soc_camera/imx074.c     | 2 +-
 drivers/media/i2c/soc_camera/mt9m111.c    | 2 +-
 drivers/media/i2c/soc_camera/mt9t031.c    | 2 +-
 drivers/media/i2c/soc_camera/mt9t112.c    | 2 +-
 drivers/media/i2c/soc_camera/ov2640.c     | 2 +-
 drivers/media/i2c/soc_camera/ov5642.c     | 2 +-
 drivers/media/i2c/soc_camera/ov6650.c     | 2 +-
 drivers/media/i2c/soc_camera/ov772x.c     | 2 +-
 drivers/media/i2c/soc_camera/ov9640.c     | 2 +-
 drivers/media/i2c/soc_camera/ov9740.c     | 2 +-
 drivers/media/i2c/soc_camera/rj54n1cb0c.c | 2 +-
 drivers/media/i2c/soc_camera/tw9910.c     | 2 +-
 drivers/media/i2c/tvp514x.c               | 2 +-
 17 files changed, 17 insertions(+), 17 deletions(-)

diff --git a/drivers/media/i2c/mt9m032.c b/drivers/media/i2c/mt9m032.c
index 45b3fca..502b23f 100644
--- a/drivers/media/i2c/mt9m032.c
+++ b/drivers/media/i2c/mt9m032.c
@@ -28,7 +28,7 @@
 #include <linux/module.h>
 #include <linux/mutex.h>
 #include <linux/slab.h>
-#include <linux/v4l2-mediabus.h>
+#include <linux/v4l2-mbus.h>
 
 #include <media/media-entity.h>
 #include <media/mt9m032.h>
diff --git a/drivers/media/i2c/mt9t001.c b/drivers/media/i2c/mt9t001.c
index d9e9889..f1053f9 100644
--- a/drivers/media/i2c/mt9t001.c
+++ b/drivers/media/i2c/mt9t001.c
@@ -19,7 +19,7 @@
 #include <linux/regulator/consumer.h>
 #include <linux/slab.h>
 #include <linux/videodev2.h>
-#include <linux/v4l2-mediabus.h>
+#include <linux/v4l2-mbus.h>
 
 #include <media/mt9t001.h>
 #include <media/v4l2-ctrls.h>
diff --git a/drivers/media/i2c/mt9v032.c b/drivers/media/i2c/mt9v032.c
index 93687c1..e0c944a 100644
--- a/drivers/media/i2c/mt9v032.c
+++ b/drivers/media/i2c/mt9v032.c
@@ -20,7 +20,7 @@
 #include <linux/regmap.h>
 #include <linux/slab.h>
 #include <linux/videodev2.h>
-#include <linux/v4l2-mediabus.h>
+#include <linux/v4l2-mbus.h>
 #include <linux/module.h>
 
 #include <media/mt9v032.h>
diff --git a/drivers/media/i2c/smiapp/smiapp-core.c b/drivers/media/i2c/smiapp/smiapp-core.c
index 82d2e0a..8ccb7fa 100644
--- a/drivers/media/i2c/smiapp/smiapp-core.c
+++ b/drivers/media/i2c/smiapp/smiapp-core.c
@@ -34,7 +34,7 @@
 #include <linux/regulator/consumer.h>
 #include <linux/slab.h>
 #include <linux/smiapp.h>
-#include <linux/v4l2-mediabus.h>
+#include <linux/v4l2-mbus.h>
 #include <media/v4l2-device.h>
 
 #include "smiapp.h"
diff --git a/drivers/media/i2c/soc_camera/imx074.c b/drivers/media/i2c/soc_camera/imx074.c
index f9c0474..48892a1 100644
--- a/drivers/media/i2c/soc_camera/imx074.c
+++ b/drivers/media/i2c/soc_camera/imx074.c
@@ -12,7 +12,7 @@
 
 #include <linux/delay.h>
 #include <linux/i2c.h>
-#include <linux/v4l2-mediabus.h>
+#include <linux/v4l2-mbus.h>
 #include <linux/slab.h>
 #include <linux/videodev2.h>
 #include <linux/module.h>
diff --git a/drivers/media/i2c/soc_camera/mt9m111.c b/drivers/media/i2c/soc_camera/mt9m111.c
index d140c7a..2b1179f 100644
--- a/drivers/media/i2c/soc_camera/mt9m111.c
+++ b/drivers/media/i2c/soc_camera/mt9m111.c
@@ -13,7 +13,7 @@
 #include <linux/log2.h>
 #include <linux/gpio.h>
 #include <linux/delay.h>
-#include <linux/v4l2-mediabus.h>
+#include <linux/v4l2-mbus.h>
 #include <linux/module.h>
 
 #include <media/soc_camera.h>
diff --git a/drivers/media/i2c/soc_camera/mt9t031.c b/drivers/media/i2c/soc_camera/mt9t031.c
index 13177ca..d6b1503 100644
--- a/drivers/media/i2c/soc_camera/mt9t031.c
+++ b/drivers/media/i2c/soc_camera/mt9t031.c
@@ -13,7 +13,7 @@
 #include <linux/log2.h>
 #include <linux/pm.h>
 #include <linux/slab.h>
-#include <linux/v4l2-mediabus.h>
+#include <linux/v4l2-mbus.h>
 #include <linux/videodev2.h>
 #include <linux/module.h>
 
diff --git a/drivers/media/i2c/soc_camera/mt9t112.c b/drivers/media/i2c/soc_camera/mt9t112.c
index 6ef9665..59396de 100644
--- a/drivers/media/i2c/soc_camera/mt9t112.c
+++ b/drivers/media/i2c/soc_camera/mt9t112.c
@@ -22,7 +22,7 @@
 #include <linux/init.h>
 #include <linux/module.h>
 #include <linux/slab.h>
-#include <linux/v4l2-mediabus.h>
+#include <linux/v4l2-mbus.h>
 #include <linux/videodev2.h>
 
 #include <media/mt9t112.h>
diff --git a/drivers/media/i2c/soc_camera/ov2640.c b/drivers/media/i2c/soc_camera/ov2640.c
index bc3ca24..dcc6fa8 100644
--- a/drivers/media/i2c/soc_camera/ov2640.c
+++ b/drivers/media/i2c/soc_camera/ov2640.c
@@ -18,7 +18,7 @@
 #include <linux/i2c.h>
 #include <linux/slab.h>
 #include <linux/delay.h>
-#include <linux/v4l2-mediabus.h>
+#include <linux/v4l2-mbus.h>
 #include <linux/videodev2.h>
 
 #include <media/soc_camera.h>
diff --git a/drivers/media/i2c/soc_camera/ov5642.c b/drivers/media/i2c/soc_camera/ov5642.c
index 5f43e03..73111bd 100644
--- a/drivers/media/i2c/soc_camera/ov5642.c
+++ b/drivers/media/i2c/soc_camera/ov5642.c
@@ -21,7 +21,7 @@
 #include <linux/slab.h>
 #include <linux/videodev2.h>
 #include <linux/module.h>
-#include <linux/v4l2-mediabus.h>
+#include <linux/v4l2-mbus.h>
 
 #include <media/soc_camera.h>
 #include <media/v4l2-clk.h>
diff --git a/drivers/media/i2c/soc_camera/ov6650.c b/drivers/media/i2c/soc_camera/ov6650.c
index 9779b96..0a39b43 100644
--- a/drivers/media/i2c/soc_camera/ov6650.c
+++ b/drivers/media/i2c/soc_camera/ov6650.c
@@ -28,7 +28,7 @@
 #include <linux/delay.h>
 #include <linux/i2c.h>
 #include <linux/slab.h>
-#include <linux/v4l2-mediabus.h>
+#include <linux/v4l2-mbus.h>
 #include <linux/module.h>
 
 #include <media/soc_camera.h>
diff --git a/drivers/media/i2c/soc_camera/ov772x.c b/drivers/media/i2c/soc_camera/ov772x.c
index ccbf3bc..09877b4 100644
--- a/drivers/media/i2c/soc_camera/ov772x.c
+++ b/drivers/media/i2c/soc_camera/ov772x.c
@@ -21,7 +21,7 @@
 #include <linux/i2c.h>
 #include <linux/slab.h>
 #include <linux/delay.h>
-#include <linux/v4l2-mediabus.h>
+#include <linux/v4l2-mbus.h>
 #include <linux/videodev2.h>
 
 #include <media/ov772x.h>
diff --git a/drivers/media/i2c/soc_camera/ov9640.c b/drivers/media/i2c/soc_camera/ov9640.c
index ffbf28f..5c28366 100644
--- a/drivers/media/i2c/soc_camera/ov9640.c
+++ b/drivers/media/i2c/soc_camera/ov9640.c
@@ -24,7 +24,7 @@
 #include <linux/i2c.h>
 #include <linux/slab.h>
 #include <linux/delay.h>
-#include <linux/v4l2-mediabus.h>
+#include <linux/v4l2-mbus.h>
 #include <linux/videodev2.h>
 
 #include <media/soc_camera.h>
diff --git a/drivers/media/i2c/soc_camera/ov9740.c b/drivers/media/i2c/soc_camera/ov9740.c
index fb0de38..52b33bf 100644
--- a/drivers/media/i2c/soc_camera/ov9740.c
+++ b/drivers/media/i2c/soc_camera/ov9740.c
@@ -14,7 +14,7 @@
 #include <linux/module.h>
 #include <linux/i2c.h>
 #include <linux/slab.h>
-#include <linux/v4l2-mediabus.h>
+#include <linux/v4l2-mbus.h>
 
 #include <media/soc_camera.h>
 #include <media/v4l2-clk.h>
diff --git a/drivers/media/i2c/soc_camera/rj54n1cb0c.c b/drivers/media/i2c/soc_camera/rj54n1cb0c.c
index a0d6f68..be5ec59 100644
--- a/drivers/media/i2c/soc_camera/rj54n1cb0c.c
+++ b/drivers/media/i2c/soc_camera/rj54n1cb0c.c
@@ -11,7 +11,7 @@
 #include <linux/delay.h>
 #include <linux/i2c.h>
 #include <linux/slab.h>
-#include <linux/v4l2-mediabus.h>
+#include <linux/v4l2-mbus.h>
 #include <linux/videodev2.h>
 #include <linux/module.h>
 
diff --git a/drivers/media/i2c/soc_camera/tw9910.c b/drivers/media/i2c/soc_camera/tw9910.c
index 9f94495..0011687 100644
--- a/drivers/media/i2c/soc_camera/tw9910.c
+++ b/drivers/media/i2c/soc_camera/tw9910.c
@@ -22,7 +22,7 @@
 #include <linux/slab.h>
 #include <linux/kernel.h>
 #include <linux/delay.h>
-#include <linux/v4l2-mediabus.h>
+#include <linux/v4l2-mbus.h>
 #include <linux/videodev2.h>
 
 #include <media/soc_camera.h>
diff --git a/drivers/media/i2c/tvp514x.c b/drivers/media/i2c/tvp514x.c
index 097b0d8..c6dd8fd 100644
--- a/drivers/media/i2c/tvp514x.c
+++ b/drivers/media/i2c/tvp514x.c
@@ -34,7 +34,7 @@
 #include <linux/delay.h>
 #include <linux/videodev2.h>
 #include <linux/module.h>
-#include <linux/v4l2-mediabus.h>
+#include <linux/v4l2-mbus.h>
 #include <linux/of.h>
 #include <linux/of_graph.h>
 
-- 
1.9.1

