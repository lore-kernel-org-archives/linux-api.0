From: Boris Brezillon <boris.brezillon@free-electrons.com>
Subject: [PATCH v3 10/10] [media] v4l: Forbid usage of V4L2_MBUS_FMT
 definitions inside the kernel
Date: Fri,  7 Nov 2014 15:07:49 +0100
Message-ID: <1415369269-5064-11-git-send-email-boris.brezillon@free-electrons.com>
References: <1415369269-5064-1-git-send-email-boris.brezillon@free-electrons.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
In-Reply-To: <1415369269-5064-1-git-send-email-boris.brezillon@free-electrons.com>
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel/>
List-Post: <mailto:driverdev-devel@linuxdriverproject.org>
List-Help: <mailto:driverdev-devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: driverdev-devel-bounces@linuxdriverproject.org
Sender: "devel" <driverdev-devel-bounces@linuxdriverproject.org>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>, Hans Verkuil <hans.verkuil@cisco.com>, Laurent Pinchart <laurent.pinchart@ideasonboard.com>, linux-media@vger.kernel.org, Sakari Ailus <sakari.ailus@iki.fi>
Cc: devel@driverdev.osuosl.org, Boris Brezillon <boris.brezillon@free-electrons.com>, linux-doc@vger.kernel.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, Guennadi Liakhovetski <g.liakhovetski@gmx.de>, linux-arm-kernel@lists.infradead.org
List-Id: linux-api@vger.kernel.org

Place v4l2_mbus_pixelcode in a #ifndef __KERNEL__ section so that kernel
users don't have access to these definitions.

We have to keep this definition for user-space users even though they're
encouraged to move to the new media_bus_format enum.

Signed-off-by: Boris Brezillon <boris.brezillon@free-electrons.com>
---
 include/uapi/linux/v4l2-mediabus.h | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/include/uapi/linux/v4l2-mediabus.h b/include/uapi/linux/v4l2-mediabus.h
index 3d87db7..4f31d0e 100644
--- a/include/uapi/linux/v4l2-mediabus.h
+++ b/include/uapi/linux/v4l2-mediabus.h
@@ -15,6 +15,14 @@
 #include <linux/videodev2.h>
 #include <linux/media-bus-format.h>
 
+#ifndef __KERNEL__
+
+/*
+ * enum v4l2_mbus_pixelcode and its defintions are now deprecated, and
+ * MEDIA_BUS_FMT_ defintions (defined in media-bus-format.h) should be
+ * used instead.
+ */
+
 #define V4L2_MBUS_FROM_MEDIA_BUS_FMT(name)	\
 	MEDIA_BUS_FMT_ ## name = V4L2_MBUS_FMT_ ## name
 
@@ -102,6 +110,7 @@ enum v4l2_mbus_pixelcode {
 
 	V4L2_MBUS_FROM_MEDIA_BUS_FMT(AHSV8888_1X32),
 };
+#endif /* __KERNEL__ */
 
 /**
  * struct v4l2_mbus_framefmt - frame format on the media bus
-- 
1.9.1
