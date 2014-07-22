From: Boris BREZILLON <boris.brezillon@free-electrons.com>
Subject: [PATCH 2/5] video: add RGB444_1X12 and RGB565_1X16 bus formats
Date: Tue, 22 Jul 2014 14:23:44 +0200
Message-ID: <1406031827-12432-3-git-send-email-boris.brezillon@free-electrons.com>
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

Add RGB444 format using a 12 bits bus and RGB565 using a 16 bits bus.

These formats will later be used by atmel-hlcdc driver.

Signed-off-by: Boris BREZILLON <boris.brezillon@free-electrons.com>
---
 include/uapi/linux/v4l2-mediabus.h    | 2 ++
 include/uapi/linux/video-bus-format.h | 4 +++-
 2 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/include/uapi/linux/v4l2-mediabus.h b/include/uapi/linux/v4l2-mediabus.h
index 8c31f11..319f860 100644
--- a/include/uapi/linux/v4l2-mediabus.h
+++ b/include/uapi/linux/v4l2-mediabus.h
@@ -30,6 +30,8 @@
 #define V4L2_MBUS_FMT_RGB888_2X12_BE		VIDEO_BUS_FMT_RGB888_2X12_BE
 #define V4L2_MBUS_FMT_RGB888_2X12_LE		VIDEO_BUS_FMT_RGB888_2X12_LE
 #define V4L2_MBUS_FMT_ARGB8888_1X32		VIDEO_BUS_FMT_ARGB8888_1X32
+#define V4L2_BUS_FMT_RGB444_1X12		VIDEO_BUS_FMT_RGB444_1X12
+#define V4L2_BUS_FMT_RGB565_1X16		VIDEO_BUS_FMT_RGB565_1X16
 
 #define V4L2_MBUS_FMT_Y8_1X8			VIDEO_BUS_FMT_Y8_1X8
 #define V4L2_MBUS_FMT_UV8_1X8			VIDEO_BUS_FMT_UV8_1X8
diff --git a/include/uapi/linux/video-bus-format.h b/include/uapi/linux/video-bus-format.h
index 4abbd5d..f85f7ee 100644
--- a/include/uapi/linux/video-bus-format.h
+++ b/include/uapi/linux/video-bus-format.h
@@ -34,7 +34,7 @@
 enum video_bus_format {
 	VIDEO_BUS_FMT_FIXED = 0x0001,
 
-	/* RGB - next is 0x100e */
+	/* RGB - next is 0x1010 */
 	VIDEO_BUS_FMT_RGB444_2X8_PADHI_BE = 0x1001,
 	VIDEO_BUS_FMT_RGB444_2X8_PADHI_LE = 0x1002,
 	VIDEO_BUS_FMT_RGB555_2X8_PADHI_BE = 0x1003,
@@ -48,6 +48,8 @@ enum video_bus_format {
 	VIDEO_BUS_FMT_RGB888_2X12_BE = 0x100b,
 	VIDEO_BUS_FMT_RGB888_2X12_LE = 0x100c,
 	VIDEO_BUS_FMT_ARGB8888_1X32 = 0x100d,
+	VIDEO_BUS_FMT_RGB444_1X12 = 0x100e,
+	VIDEO_BUS_FMT_RGB565_1X16 = 0x100f,
 
 	/* YUV (including grey) - next is 0x2024 */
 	VIDEO_BUS_FMT_Y8_1X8 = 0x2001,
-- 
1.8.3.2
