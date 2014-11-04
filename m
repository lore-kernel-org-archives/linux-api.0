From: Boris Brezillon <boris.brezillon@free-electrons.com>
Subject: [PATCH 03/15] [media] Make use of the new media_bus_format definitions
Date: Tue,  4 Nov 2014 10:54:58 +0100
Message-ID: <1415094910-15899-4-git-send-email-boris.brezillon@free-electrons.com>
References: <1415094910-15899-1-git-send-email-boris.brezillon@free-electrons.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <1415094910-15899-1-git-send-email-boris.brezillon@free-electrons.com>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: Mauro Carvalho Chehab <m.chehab@samsung.com>, Hans Verkuil <hans.verkuil@cisco.com>, Laurent Pinchart <laurent.pinchart@ideasonboard.com>, linux-media@vger.kernel.org
Cc: devel@driverdev.osuosl.org, Boris Brezillon <boris.brezillon@free-electrons.com>, linux-doc@vger.kernel.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, Guennadi Liakhovetski <g.liakhovetski@gmx.de>, linux-arm-kernel@lists.infradead.org
List-Id: linux-api@vger.kernel.org

Replace references to the v4l2_mbus_pixelcode enum with the new
media_bus_format enum in all common headers.

Signed-off-by: Boris Brezillon <boris.brezillon@free-electrons.com>
---
 include/media/v4l2-mediabus.h    | 2 +-
 include/media/v4l2-subdev.h      | 2 +-
 include/uapi/linux/v4l2-subdev.h | 6 +++---
 3 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/include/media/v4l2-mediabus.h b/include/media/v4l2-mediabus.h
index 395c4a9..4915621 100644
--- a/include/media/v4l2-mediabus.h
+++ b/include/media/v4l2-mediabus.h
@@ -98,7 +98,7 @@ static inline void v4l2_fill_pix_format(struct v4l2_pix_format *pix_fmt,
 
 static inline void v4l2_fill_mbus_format(struct v4l2_mbus_framefmt *mbus_fmt,
 			   const struct v4l2_pix_format *pix_fmt,
-			   enum v4l2_mbus_pixelcode code)
+			   enum media_bus_format code)
 {
 	mbus_fmt->width = pix_fmt->width;
 	mbus_fmt->height = pix_fmt->height;
diff --git a/include/media/v4l2-subdev.h b/include/media/v4l2-subdev.h
index d746572..9af5932 100644
--- a/include/media/v4l2-subdev.h
+++ b/include/media/v4l2-subdev.h
@@ -341,7 +341,7 @@ struct v4l2_subdev_video_ops {
 	int (*query_dv_timings)(struct v4l2_subdev *sd,
 			struct v4l2_dv_timings *timings);
 	int (*enum_mbus_fmt)(struct v4l2_subdev *sd, unsigned int index,
-			     enum v4l2_mbus_pixelcode *code);
+			     enum media_bus_format *code);
 	int (*enum_mbus_fsizes)(struct v4l2_subdev *sd,
 			     struct v4l2_frmsizeenum *fsize);
 	int (*g_mbus_fmt)(struct v4l2_subdev *sd,
diff --git a/include/uapi/linux/v4l2-subdev.h b/include/uapi/linux/v4l2-subdev.h
index a619cdd..7f44f04 100644
--- a/include/uapi/linux/v4l2-subdev.h
+++ b/include/uapi/linux/v4l2-subdev.h
@@ -68,7 +68,7 @@ struct v4l2_subdev_crop {
  * struct v4l2_subdev_mbus_code_enum - Media bus format enumeration
  * @pad: pad number, as reported by the media API
  * @index: format index during enumeration
- * @code: format code (from enum v4l2_mbus_pixelcode)
+ * @code: format code (from enum media_bus_format)
  */
 struct v4l2_subdev_mbus_code_enum {
 	__u32 pad;
@@ -81,7 +81,7 @@ struct v4l2_subdev_mbus_code_enum {
  * struct v4l2_subdev_frame_size_enum - Media bus format enumeration
  * @pad: pad number, as reported by the media API
  * @index: format index during enumeration
- * @code: format code (from enum v4l2_mbus_pixelcode)
+ * @code: format code (from enum media_bus_format)
  */
 struct v4l2_subdev_frame_size_enum {
 	__u32 index;
@@ -109,7 +109,7 @@ struct v4l2_subdev_frame_interval {
  * struct v4l2_subdev_frame_interval_enum - Frame interval enumeration
  * @pad: pad number, as reported by the media API
  * @index: frame interval index during enumeration
- * @code: format code (from enum v4l2_mbus_pixelcode)
+ * @code: format code (from enum media_bus_format)
  * @width: frame width in pixels
  * @height: frame height in pixels
  * @interval: frame interval in seconds
-- 
1.9.1
