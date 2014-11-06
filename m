From: Boris Brezillon <boris.brezillon@free-electrons.com>
Subject: [PATCH v2 01/10] [media] Move mediabus format definition to a more
 standard place
Date: Thu,  6 Nov 2014 10:56:59 +0100
Message-ID: <1415267829-4177-2-git-send-email-boris.brezillon@free-electrons.com>
References: <1415267829-4177-1-git-send-email-boris.brezillon@free-electrons.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
In-Reply-To: <1415267829-4177-1-git-send-email-boris.brezillon@free-electrons.com>
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel/>
List-Post: <mailto:driverdev-devel@linuxdriverproject.org>
List-Help: <mailto:driverdev-devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: driverdev-devel-bounces@linuxdriverproject.org
Sender: "devel" <driverdev-devel-bounces@linuxdriverproject.org>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>, Hans Verkuil <hans.verkuil@cisco.com>, Laurent Pinchart <laurent.pinchart@ideasonboard.com>, linux-media@vger.kernel.org
Cc: devel@driverdev.osuosl.org, Boris Brezillon <boris.brezillon@free-electrons.com>, linux-doc@vger.kernel.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, Guennadi Liakhovetski <g.liakhovetski@gmx.de>, linux-arm-kernel@lists.infradead.org
List-Id: linux-api@vger.kernel.org

Rename mediabus formats and move the enum into a separate header file so
that it can be used by DRM/KMS subsystem without any reference to the V4L2
subsystem.

Old v4l2_mbus_pixelcode now points to media_bus_format.

Signed-off-by: Boris Brezillon <boris.brezillon@free-electrons.com>
Acked-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---
 include/uapi/linux/Kbuild             |   1 +
 include/uapi/linux/media-bus-format.h | 131 ++++++++++++++++++++++++++++++++++
 include/uapi/linux/v4l2-mediabus.h    | 114 +----------------------------
 3 files changed, 134 insertions(+), 112 deletions(-)
 create mode 100644 include/uapi/linux/media-bus-format.h

diff --git a/include/uapi/linux/Kbuild b/include/uapi/linux/Kbuild
index b70237e..b2c23f8 100644
--- a/include/uapi/linux/Kbuild
+++ b/include/uapi/linux/Kbuild
@@ -414,6 +414,7 @@ header-y += veth.h
 header-y += vfio.h
 header-y += vhost.h
 header-y += videodev2.h
+header-y += media-bus-format.h
 header-y += virtio_9p.h
 header-y += virtio_balloon.h
 header-y += virtio_blk.h
diff --git a/include/uapi/linux/media-bus-format.h b/include/uapi/linux/media-bus-format.h
new file mode 100644
index 0000000..251a902
--- /dev/null
+++ b/include/uapi/linux/media-bus-format.h
@@ -0,0 +1,131 @@
+/*
+ * Media Bus API header
+ *
+ * Copyright (C) 2009, Guennadi Liakhovetski <g.liakhovetski@gmx.de>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#ifndef __LINUX_MEDIA_BUS_FORMAT_H
+#define __LINUX_MEDIA_BUS_FORMAT_H
+
+/*
+ * These bus formats uniquely identify data formats on the data bus. Format 0
+ * is reserved, MEDIA_BUS_FMT_FIXED shall be used by host-client pairs, where
+ * the data format is fixed. Additionally, "2X8" means that one pixel is
+ * transferred in two 8-bit samples, "BE" or "LE" specify in which order those
+ * samples are transferred over the bus: "LE" means that the least significant
+ * bits are transferred first, "BE" means that the most significant bits are
+ * transferred first, and "PADHI" and "PADLO" define which bits - low or high,
+ * in the incomplete high byte, are filled with padding bits.
+ *
+ * The bus formats are grouped by type, bus_width, bits per component, samples
+ * per pixel and order of subsamples. Numerical values are sorted using generic
+ * numerical sort order (8 thus comes before 10).
+ *
+ * As their value can't change when a new bus format is inserted in the
+ * enumeration, the bus formats are explicitly given a numerical value. The next
+ * free values for each category are listed below, update them when inserting
+ * new pixel codes.
+ */
+
+#define MEDIA_BUS_FMT_ENTRY(name, val)	\
+	MEDIA_BUS_FMT_ ## name = val,	\
+	V4L2_MBUS_FMT_ ## name = val
+
+enum media_bus_format {
+	MEDIA_BUS_FMT_ENTRY(FIXED, 0x0001),
+
+	/* RGB - next is 0x100e */
+	MEDIA_BUS_FMT_ENTRY(RGB444_2X8_PADHI_BE, 0x1001),
+	MEDIA_BUS_FMT_ENTRY(RGB444_2X8_PADHI_LE, 0x1002),
+	MEDIA_BUS_FMT_ENTRY(RGB555_2X8_PADHI_BE, 0x1003),
+	MEDIA_BUS_FMT_ENTRY(RGB555_2X8_PADHI_LE, 0x1004),
+	MEDIA_BUS_FMT_ENTRY(BGR565_2X8_BE, 0x1005),
+	MEDIA_BUS_FMT_ENTRY(BGR565_2X8_LE, 0x1006),
+	MEDIA_BUS_FMT_ENTRY(RGB565_2X8_BE, 0x1007),
+	MEDIA_BUS_FMT_ENTRY(RGB565_2X8_LE, 0x1008),
+	MEDIA_BUS_FMT_ENTRY(RGB666_1X18, 0x1009),
+	MEDIA_BUS_FMT_ENTRY(RGB888_1X24, 0x100a),
+	MEDIA_BUS_FMT_ENTRY(RGB888_2X12_BE, 0x100b),
+	MEDIA_BUS_FMT_ENTRY(RGB888_2X12_LE, 0x100c),
+	MEDIA_BUS_FMT_ENTRY(ARGB8888_1X32, 0x100d),
+
+	/* YUV (including grey) - next is 0x2024 */
+	MEDIA_BUS_FMT_ENTRY(Y8_1X8, 0x2001),
+	MEDIA_BUS_FMT_ENTRY(UV8_1X8, 0x2015),
+	MEDIA_BUS_FMT_ENTRY(UYVY8_1_5X8, 0x2002),
+	MEDIA_BUS_FMT_ENTRY(VYUY8_1_5X8, 0x2003),
+	MEDIA_BUS_FMT_ENTRY(YUYV8_1_5X8, 0x2004),
+	MEDIA_BUS_FMT_ENTRY(YVYU8_1_5X8, 0x2005),
+	MEDIA_BUS_FMT_ENTRY(UYVY8_2X8, 0x2006),
+	MEDIA_BUS_FMT_ENTRY(VYUY8_2X8, 0x2007),
+	MEDIA_BUS_FMT_ENTRY(YUYV8_2X8, 0x2008),
+	MEDIA_BUS_FMT_ENTRY(YVYU8_2X8, 0x2009),
+	MEDIA_BUS_FMT_ENTRY(Y10_1X10, 0x200a),
+	MEDIA_BUS_FMT_ENTRY(UYVY10_2X10, 0x2018),
+	MEDIA_BUS_FMT_ENTRY(VYUY10_2X10, 0x2019),
+	MEDIA_BUS_FMT_ENTRY(YUYV10_2X10, 0x200b),
+	MEDIA_BUS_FMT_ENTRY(YVYU10_2X10, 0x200c),
+	MEDIA_BUS_FMT_ENTRY(Y12_1X12, 0x2013),
+	MEDIA_BUS_FMT_ENTRY(UYVY8_1X16, 0x200f),
+	MEDIA_BUS_FMT_ENTRY(VYUY8_1X16, 0x2010),
+	MEDIA_BUS_FMT_ENTRY(YUYV8_1X16, 0x2011),
+	MEDIA_BUS_FMT_ENTRY(YVYU8_1X16, 0x2012),
+	MEDIA_BUS_FMT_ENTRY(YDYUYDYV8_1X16, 0x2014),
+	MEDIA_BUS_FMT_ENTRY(UYVY10_1X20, 0x201a),
+	MEDIA_BUS_FMT_ENTRY(VYUY10_1X20, 0x201b),
+	MEDIA_BUS_FMT_ENTRY(YUYV10_1X20, 0x200d),
+	MEDIA_BUS_FMT_ENTRY(YVYU10_1X20, 0x200e),
+	MEDIA_BUS_FMT_ENTRY(YUV10_1X30, 0x2016),
+	MEDIA_BUS_FMT_ENTRY(AYUV8_1X32, 0x2017),
+	MEDIA_BUS_FMT_ENTRY(UYVY12_2X12, 0x201c),
+	MEDIA_BUS_FMT_ENTRY(VYUY12_2X12, 0x201d),
+	MEDIA_BUS_FMT_ENTRY(YUYV12_2X12, 0x201e),
+	MEDIA_BUS_FMT_ENTRY(YVYU12_2X12, 0x201f),
+	MEDIA_BUS_FMT_ENTRY(UYVY12_1X24, 0x2020),
+	MEDIA_BUS_FMT_ENTRY(VYUY12_1X24, 0x2021),
+	MEDIA_BUS_FMT_ENTRY(YUYV12_1X24, 0x2022),
+	MEDIA_BUS_FMT_ENTRY(YVYU12_1X24, 0x2023),
+
+	/* Bayer - next is 0x3019 */
+	MEDIA_BUS_FMT_ENTRY(SBGGR8_1X8, 0x3001),
+	MEDIA_BUS_FMT_ENTRY(SGBRG8_1X8, 0x3013),
+	MEDIA_BUS_FMT_ENTRY(SGRBG8_1X8, 0x3002),
+	MEDIA_BUS_FMT_ENTRY(SRGGB8_1X8, 0x3014),
+	MEDIA_BUS_FMT_ENTRY(SBGGR10_ALAW8_1X8, 0x3015),
+	MEDIA_BUS_FMT_ENTRY(SGBRG10_ALAW8_1X8, 0x3016),
+	MEDIA_BUS_FMT_ENTRY(SGRBG10_ALAW8_1X8, 0x3017),
+	MEDIA_BUS_FMT_ENTRY(SRGGB10_ALAW8_1X8, 0x3018),
+	MEDIA_BUS_FMT_ENTRY(SBGGR10_DPCM8_1X8, 0x300b),
+	MEDIA_BUS_FMT_ENTRY(SGBRG10_DPCM8_1X8, 0x300c),
+	MEDIA_BUS_FMT_ENTRY(SGRBG10_DPCM8_1X8, 0x3009),
+	MEDIA_BUS_FMT_ENTRY(SRGGB10_DPCM8_1X8, 0x300d),
+	MEDIA_BUS_FMT_ENTRY(SBGGR10_2X8_PADHI_BE, 0x3003),
+	MEDIA_BUS_FMT_ENTRY(SBGGR10_2X8_PADHI_LE, 0x3004),
+	MEDIA_BUS_FMT_ENTRY(SBGGR10_2X8_PADLO_BE, 0x3005),
+	MEDIA_BUS_FMT_ENTRY(SBGGR10_2X8_PADLO_LE, 0x3006),
+	MEDIA_BUS_FMT_ENTRY(SBGGR10_1X10, 0x3007),
+	MEDIA_BUS_FMT_ENTRY(SGBRG10_1X10, 0x300e),
+	MEDIA_BUS_FMT_ENTRY(SGRBG10_1X10, 0x300a),
+	MEDIA_BUS_FMT_ENTRY(SRGGB10_1X10, 0x300f),
+	MEDIA_BUS_FMT_ENTRY(SBGGR12_1X12, 0x3008),
+	MEDIA_BUS_FMT_ENTRY(SGBRG12_1X12, 0x3010),
+	MEDIA_BUS_FMT_ENTRY(SGRBG12_1X12, 0x3011),
+	MEDIA_BUS_FMT_ENTRY(SRGGB12_1X12, 0x3012),
+
+	/* JPEG compressed formats - next is 0x4002 */
+	MEDIA_BUS_FMT_ENTRY(JPEG_1X8, 0x4001),
+
+	/* Vendor specific formats - next is 0x5002 */
+
+	/* S5C73M3 sensor specific interleaved UYVY and JPEG */
+	MEDIA_BUS_FMT_ENTRY(S5C_UYVY_JPEG_1X8, 0x5001),
+
+	/* HSV - next is 0x6002 */
+	MEDIA_BUS_FMT_ENTRY(AHSV8888_1X32, 0x6001),
+};
+
+#endif /* __LINUX_MEDIA_BUS_FORMAT_H */
diff --git a/include/uapi/linux/v4l2-mediabus.h b/include/uapi/linux/v4l2-mediabus.h
index 1445e85..d30526c 100644
--- a/include/uapi/linux/v4l2-mediabus.h
+++ b/include/uapi/linux/v4l2-mediabus.h
@@ -13,119 +13,9 @@
 
 #include <linux/types.h>
 #include <linux/videodev2.h>
+#include <linux/media-bus-format.h>
 
-/*
- * These pixel codes uniquely identify data formats on the media bus. Mostly
- * they correspond to similarly named V4L2_PIX_FMT_* formats, format 0 is
- * reserved, V4L2_MBUS_FMT_FIXED shall be used by host-client pairs, where the
- * data format is fixed. Additionally, "2X8" means that one pixel is transferred
- * in two 8-bit samples, "BE" or "LE" specify in which order those samples are
- * transferred over the bus: "LE" means that the least significant bits are
- * transferred first, "BE" means that the most significant bits are transferred
- * first, and "PADHI" and "PADLO" define which bits - low or high, in the
- * incomplete high byte, are filled with padding bits.
- *
- * The pixel codes are grouped by type, bus_width, bits per component, samples
- * per pixel and order of subsamples. Numerical values are sorted using generic
- * numerical sort order (8 thus comes before 10).
- *
- * As their value can't change when a new pixel code is inserted in the
- * enumeration, the pixel codes are explicitly given a numerical value. The next
- * free values for each category are listed below, update them when inserting
- * new pixel codes.
- */
-enum v4l2_mbus_pixelcode {
-	V4L2_MBUS_FMT_FIXED = 0x0001,
-
-	/* RGB - next is 0x100e */
-	V4L2_MBUS_FMT_RGB444_2X8_PADHI_BE = 0x1001,
-	V4L2_MBUS_FMT_RGB444_2X8_PADHI_LE = 0x1002,
-	V4L2_MBUS_FMT_RGB555_2X8_PADHI_BE = 0x1003,
-	V4L2_MBUS_FMT_RGB555_2X8_PADHI_LE = 0x1004,
-	V4L2_MBUS_FMT_BGR565_2X8_BE = 0x1005,
-	V4L2_MBUS_FMT_BGR565_2X8_LE = 0x1006,
-	V4L2_MBUS_FMT_RGB565_2X8_BE = 0x1007,
-	V4L2_MBUS_FMT_RGB565_2X8_LE = 0x1008,
-	V4L2_MBUS_FMT_RGB666_1X18 = 0x1009,
-	V4L2_MBUS_FMT_RGB888_1X24 = 0x100a,
-	V4L2_MBUS_FMT_RGB888_2X12_BE = 0x100b,
-	V4L2_MBUS_FMT_RGB888_2X12_LE = 0x100c,
-	V4L2_MBUS_FMT_ARGB8888_1X32 = 0x100d,
-
-	/* YUV (including grey) - next is 0x2024 */
-	V4L2_MBUS_FMT_Y8_1X8 = 0x2001,
-	V4L2_MBUS_FMT_UV8_1X8 = 0x2015,
-	V4L2_MBUS_FMT_UYVY8_1_5X8 = 0x2002,
-	V4L2_MBUS_FMT_VYUY8_1_5X8 = 0x2003,
-	V4L2_MBUS_FMT_YUYV8_1_5X8 = 0x2004,
-	V4L2_MBUS_FMT_YVYU8_1_5X8 = 0x2005,
-	V4L2_MBUS_FMT_UYVY8_2X8 = 0x2006,
-	V4L2_MBUS_FMT_VYUY8_2X8 = 0x2007,
-	V4L2_MBUS_FMT_YUYV8_2X8 = 0x2008,
-	V4L2_MBUS_FMT_YVYU8_2X8 = 0x2009,
-	V4L2_MBUS_FMT_Y10_1X10 = 0x200a,
-	V4L2_MBUS_FMT_UYVY10_2X10 = 0x2018,
-	V4L2_MBUS_FMT_VYUY10_2X10 = 0x2019,
-	V4L2_MBUS_FMT_YUYV10_2X10 = 0x200b,
-	V4L2_MBUS_FMT_YVYU10_2X10 = 0x200c,
-	V4L2_MBUS_FMT_Y12_1X12 = 0x2013,
-	V4L2_MBUS_FMT_UYVY8_1X16 = 0x200f,
-	V4L2_MBUS_FMT_VYUY8_1X16 = 0x2010,
-	V4L2_MBUS_FMT_YUYV8_1X16 = 0x2011,
-	V4L2_MBUS_FMT_YVYU8_1X16 = 0x2012,
-	V4L2_MBUS_FMT_YDYUYDYV8_1X16 = 0x2014,
-	V4L2_MBUS_FMT_UYVY10_1X20 = 0x201a,
-	V4L2_MBUS_FMT_VYUY10_1X20 = 0x201b,
-	V4L2_MBUS_FMT_YUYV10_1X20 = 0x200d,
-	V4L2_MBUS_FMT_YVYU10_1X20 = 0x200e,
-	V4L2_MBUS_FMT_YUV10_1X30 = 0x2016,
-	V4L2_MBUS_FMT_AYUV8_1X32 = 0x2017,
-	V4L2_MBUS_FMT_UYVY12_2X12 = 0x201c,
-	V4L2_MBUS_FMT_VYUY12_2X12 = 0x201d,
-	V4L2_MBUS_FMT_YUYV12_2X12 = 0x201e,
-	V4L2_MBUS_FMT_YVYU12_2X12 = 0x201f,
-	V4L2_MBUS_FMT_UYVY12_1X24 = 0x2020,
-	V4L2_MBUS_FMT_VYUY12_1X24 = 0x2021,
-	V4L2_MBUS_FMT_YUYV12_1X24 = 0x2022,
-	V4L2_MBUS_FMT_YVYU12_1X24 = 0x2023,
-
-	/* Bayer - next is 0x3019 */
-	V4L2_MBUS_FMT_SBGGR8_1X8 = 0x3001,
-	V4L2_MBUS_FMT_SGBRG8_1X8 = 0x3013,
-	V4L2_MBUS_FMT_SGRBG8_1X8 = 0x3002,
-	V4L2_MBUS_FMT_SRGGB8_1X8 = 0x3014,
-	V4L2_MBUS_FMT_SBGGR10_ALAW8_1X8 = 0x3015,
-	V4L2_MBUS_FMT_SGBRG10_ALAW8_1X8 = 0x3016,
-	V4L2_MBUS_FMT_SGRBG10_ALAW8_1X8 = 0x3017,
-	V4L2_MBUS_FMT_SRGGB10_ALAW8_1X8 = 0x3018,
-	V4L2_MBUS_FMT_SBGGR10_DPCM8_1X8 = 0x300b,
-	V4L2_MBUS_FMT_SGBRG10_DPCM8_1X8 = 0x300c,
-	V4L2_MBUS_FMT_SGRBG10_DPCM8_1X8 = 0x3009,
-	V4L2_MBUS_FMT_SRGGB10_DPCM8_1X8 = 0x300d,
-	V4L2_MBUS_FMT_SBGGR10_2X8_PADHI_BE = 0x3003,
-	V4L2_MBUS_FMT_SBGGR10_2X8_PADHI_LE = 0x3004,
-	V4L2_MBUS_FMT_SBGGR10_2X8_PADLO_BE = 0x3005,
-	V4L2_MBUS_FMT_SBGGR10_2X8_PADLO_LE = 0x3006,
-	V4L2_MBUS_FMT_SBGGR10_1X10 = 0x3007,
-	V4L2_MBUS_FMT_SGBRG10_1X10 = 0x300e,
-	V4L2_MBUS_FMT_SGRBG10_1X10 = 0x300a,
-	V4L2_MBUS_FMT_SRGGB10_1X10 = 0x300f,
-	V4L2_MBUS_FMT_SBGGR12_1X12 = 0x3008,
-	V4L2_MBUS_FMT_SGBRG12_1X12 = 0x3010,
-	V4L2_MBUS_FMT_SGRBG12_1X12 = 0x3011,
-	V4L2_MBUS_FMT_SRGGB12_1X12 = 0x3012,
-
-	/* JPEG compressed formats - next is 0x4002 */
-	V4L2_MBUS_FMT_JPEG_1X8 = 0x4001,
-
-	/* Vendor specific formats - next is 0x5002 */
-
-	/* S5C73M3 sensor specific interleaved UYVY and JPEG */
-	V4L2_MBUS_FMT_S5C_UYVY_JPEG_1X8 = 0x5001,
-
-	/* HSV - next is 0x6002 */
-	V4L2_MBUS_FMT_AHSV8888_1X32 = 0x6001,
-};
+#define v4l2_mbus_pixelcode media_bus_format
 
 /**
  * struct v4l2_mbus_framefmt - frame format on the media bus
-- 
1.9.1
