From: Boris Brezillon <boris.brezillon@free-electrons.com>
Subject: [PATCH v6 RESEND 01/10] [media] Move mediabus format definition to a
 more standard place
Date: Mon, 10 Nov 2014 18:28:26 +0100
Message-ID: <1415640515-15069-2-git-send-email-boris.brezillon@free-electrons.com>
References: <1415640515-15069-1-git-send-email-boris.brezillon@free-electrons.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
In-Reply-To: <1415640515-15069-1-git-send-email-boris.brezillon@free-electrons.com>
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

Define MEDIA_BUS_FMT macros (re-using the values defined in the
v4l2_mbus_pixelcode enum) into a separate header file so that they can be
used from the DRM/KMS subsystem without any reference to the V4L2
subsystem.

Then set V4L2_MBUS_FMT definitions to the MEDIA_BUS_FMT values using the
V4L2_MBUS_FROM_MEDIA_BUS_FMT macro.

Signed-off-by: Boris Brezillon <boris.brezillon@free-electrons.com>
Acked-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 include/uapi/linux/Kbuild             |   1 +
 include/uapi/linux/media-bus-format.h | 125 +++++++++++++++++++++++
 include/uapi/linux/v4l2-mediabus.h    | 184 +++++++++++++++-------------------
 3 files changed, 206 insertions(+), 104 deletions(-)
 create mode 100644 include/uapi/linux/media-bus-format.h

diff --git a/include/uapi/linux/Kbuild b/include/uapi/linux/Kbuild
index b70237e..ed39ac8 100644
--- a/include/uapi/linux/Kbuild
+++ b/include/uapi/linux/Kbuild
@@ -241,6 +241,7 @@ header-y += map_to_7segment.h
 header-y += matroxfb.h
 header-y += mdio.h
 header-y += media.h
+header-y += media-bus-format.h
 header-y += mei.h
 header-y += memfd.h
 header-y += mempolicy.h
diff --git a/include/uapi/linux/media-bus-format.h b/include/uapi/linux/media-bus-format.h
new file mode 100644
index 0000000..23b4090
--- /dev/null
+++ b/include/uapi/linux/media-bus-format.h
@@ -0,0 +1,125 @@
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
+#define MEDIA_BUS_FMT_FIXED			0x0001
+
+/* RGB - next is	0x100e */
+#define MEDIA_BUS_FMT_RGB444_2X8_PADHI_BE	0x1001
+#define MEDIA_BUS_FMT_RGB444_2X8_PADHI_LE	0x1002
+#define MEDIA_BUS_FMT_RGB555_2X8_PADHI_BE	0x1003
+#define MEDIA_BUS_FMT_RGB555_2X8_PADHI_LE	0x1004
+#define MEDIA_BUS_FMT_BGR565_2X8_BE		0x1005
+#define MEDIA_BUS_FMT_BGR565_2X8_LE		0x1006
+#define MEDIA_BUS_FMT_RGB565_2X8_BE		0x1007
+#define MEDIA_BUS_FMT_RGB565_2X8_LE		0x1008
+#define MEDIA_BUS_FMT_RGB666_1X18		0x1009
+#define MEDIA_BUS_FMT_RGB888_1X24		0x100a
+#define MEDIA_BUS_FMT_RGB888_2X12_BE		0x100b
+#define MEDIA_BUS_FMT_RGB888_2X12_LE		0x100c
+#define MEDIA_BUS_FMT_ARGB8888_1X32		0x100d
+
+/* YUV (including grey) - next is	0x2024 */
+#define MEDIA_BUS_FMT_Y8_1X8			0x2001
+#define MEDIA_BUS_FMT_UV8_1X8			0x2015
+#define MEDIA_BUS_FMT_UYVY8_1_5X8		0x2002
+#define MEDIA_BUS_FMT_VYUY8_1_5X8		0x2003
+#define MEDIA_BUS_FMT_YUYV8_1_5X8		0x2004
+#define MEDIA_BUS_FMT_YVYU8_1_5X8		0x2005
+#define MEDIA_BUS_FMT_UYVY8_2X8			0x2006
+#define MEDIA_BUS_FMT_VYUY8_2X8			0x2007
+#define MEDIA_BUS_FMT_YUYV8_2X8			0x2008
+#define MEDIA_BUS_FMT_YVYU8_2X8			0x2009
+#define MEDIA_BUS_FMT_Y10_1X10			0x200a
+#define MEDIA_BUS_FMT_UYVY10_2X10		0x2018
+#define MEDIA_BUS_FMT_VYUY10_2X10		0x2019
+#define MEDIA_BUS_FMT_YUYV10_2X10		0x200b
+#define MEDIA_BUS_FMT_YVYU10_2X10		0x200c
+#define MEDIA_BUS_FMT_Y12_1X12			0x2013
+#define MEDIA_BUS_FMT_UYVY8_1X16		0x200f
+#define MEDIA_BUS_FMT_VYUY8_1X16		0x2010
+#define MEDIA_BUS_FMT_YUYV8_1X16		0x2011
+#define MEDIA_BUS_FMT_YVYU8_1X16		0x2012
+#define MEDIA_BUS_FMT_YDYUYDYV8_1X16		0x2014
+#define MEDIA_BUS_FMT_UYVY10_1X20		0x201a
+#define MEDIA_BUS_FMT_VYUY10_1X20		0x201b
+#define MEDIA_BUS_FMT_YUYV10_1X20		0x200d
+#define MEDIA_BUS_FMT_YVYU10_1X20		0x200e
+#define MEDIA_BUS_FMT_YUV10_1X30		0x2016
+#define MEDIA_BUS_FMT_AYUV8_1X32		0x2017
+#define MEDIA_BUS_FMT_UYVY12_2X12		0x201c
+#define MEDIA_BUS_FMT_VYUY12_2X12		0x201d
+#define MEDIA_BUS_FMT_YUYV12_2X12		0x201e
+#define MEDIA_BUS_FMT_YVYU12_2X12		0x201f
+#define MEDIA_BUS_FMT_UYVY12_1X24		0x2020
+#define MEDIA_BUS_FMT_VYUY12_1X24		0x2021
+#define MEDIA_BUS_FMT_YUYV12_1X24		0x2022
+#define MEDIA_BUS_FMT_YVYU12_1X24		0x2023
+
+/* Bayer - next is	0x3019 */
+#define MEDIA_BUS_FMT_SBGGR8_1X8		0x3001
+#define MEDIA_BUS_FMT_SGBRG8_1X8		0x3013
+#define MEDIA_BUS_FMT_SGRBG8_1X8		0x3002
+#define MEDIA_BUS_FMT_SRGGB8_1X8		0x3014
+#define MEDIA_BUS_FMT_SBGGR10_ALAW8_1X8		0x3015
+#define MEDIA_BUS_FMT_SGBRG10_ALAW8_1X8		0x3016
+#define MEDIA_BUS_FMT_SGRBG10_ALAW8_1X8		0x3017
+#define MEDIA_BUS_FMT_SRGGB10_ALAW8_1X8		0x3018
+#define MEDIA_BUS_FMT_SBGGR10_DPCM8_1X8		0x300b
+#define MEDIA_BUS_FMT_SGBRG10_DPCM8_1X8		0x300c
+#define MEDIA_BUS_FMT_SGRBG10_DPCM8_1X8		0x3009
+#define MEDIA_BUS_FMT_SRGGB10_DPCM8_1X8		0x300d
+#define MEDIA_BUS_FMT_SBGGR10_2X8_PADHI_BE	0x3003
+#define MEDIA_BUS_FMT_SBGGR10_2X8_PADHI_LE	0x3004
+#define MEDIA_BUS_FMT_SBGGR10_2X8_PADLO_BE	0x3005
+#define MEDIA_BUS_FMT_SBGGR10_2X8_PADLO_LE	0x3006
+#define MEDIA_BUS_FMT_SBGGR10_1X10		0x3007
+#define MEDIA_BUS_FMT_SGBRG10_1X10		0x300e
+#define MEDIA_BUS_FMT_SGRBG10_1X10		0x300a
+#define MEDIA_BUS_FMT_SRGGB10_1X10		0x300f
+#define MEDIA_BUS_FMT_SBGGR12_1X12		0x3008
+#define MEDIA_BUS_FMT_SGBRG12_1X12		0x3010
+#define MEDIA_BUS_FMT_SGRBG12_1X12		0x3011
+#define MEDIA_BUS_FMT_SRGGB12_1X12		0x3012
+
+/* JPEG compressed formats - next is	0x4002 */
+#define MEDIA_BUS_FMT_JPEG_1X8			0x4001
+
+/* Vendor specific formats - next is	0x5002 */
+
+/* S5C73M3 sensor specific interleaved UYVY and JPEG */
+#define MEDIA_BUS_FMT_S5C_UYVY_JPEG_1X8		0x5001
+
+/* HSV - next is	0x6002 */
+#define MEDIA_BUS_FMT_AHSV8888_1X32		0x6001
+
+#endif /* __LINUX_MEDIA_BUS_FORMAT_H */
diff --git a/include/uapi/linux/v4l2-mediabus.h b/include/uapi/linux/v4l2-mediabus.h
index 1445e85..2618084 100644
--- a/include/uapi/linux/v4l2-mediabus.h
+++ b/include/uapi/linux/v4l2-mediabus.h
@@ -11,120 +11,96 @@
 #ifndef __LINUX_V4L2_MEDIABUS_H
 #define __LINUX_V4L2_MEDIABUS_H
 
+#include <linux/media-bus-format.h>
 #include <linux/types.h>
 #include <linux/videodev2.h>
 
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
+#define V4L2_MBUS_FROM_MEDIA_BUS_FMT(name)	\
+	V4L2_MBUS_FMT_ ## name = MEDIA_BUS_FMT_ ## name
 
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
+enum v4l2_mbus_pixelcode {
+	V4L2_MBUS_FROM_MEDIA_BUS_FMT(FIXED),
 
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
+	V4L2_MBUS_FROM_MEDIA_BUS_FMT(RGB444_2X8_PADHI_BE),
+	V4L2_MBUS_FROM_MEDIA_BUS_FMT(RGB444_2X8_PADHI_LE),
+	V4L2_MBUS_FROM_MEDIA_BUS_FMT(RGB555_2X8_PADHI_BE),
+	V4L2_MBUS_FROM_MEDIA_BUS_FMT(RGB555_2X8_PADHI_LE),
+	V4L2_MBUS_FROM_MEDIA_BUS_FMT(BGR565_2X8_BE),
+	V4L2_MBUS_FROM_MEDIA_BUS_FMT(BGR565_2X8_LE),
+	V4L2_MBUS_FROM_MEDIA_BUS_FMT(RGB565_2X8_BE),
+	V4L2_MBUS_FROM_MEDIA_BUS_FMT(RGB565_2X8_LE),
+	V4L2_MBUS_FROM_MEDIA_BUS_FMT(RGB666_1X18),
+	V4L2_MBUS_FROM_MEDIA_BUS_FMT(RGB888_1X24),
+	V4L2_MBUS_FROM_MEDIA_BUS_FMT(RGB888_2X12_BE),
+	V4L2_MBUS_FROM_MEDIA_BUS_FMT(RGB888_2X12_LE),
+	V4L2_MBUS_FROM_MEDIA_BUS_FMT(ARGB8888_1X32),
 
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
+	V4L2_MBUS_FROM_MEDIA_BUS_FMT(Y8_1X8),
+	V4L2_MBUS_FROM_MEDIA_BUS_FMT(UV8_1X8),
+	V4L2_MBUS_FROM_MEDIA_BUS_FMT(UYVY8_1_5X8),
+	V4L2_MBUS_FROM_MEDIA_BUS_FMT(VYUY8_1_5X8),
+	V4L2_MBUS_FROM_MEDIA_BUS_FMT(YUYV8_1_5X8),
+	V4L2_MBUS_FROM_MEDIA_BUS_FMT(YVYU8_1_5X8),
+	V4L2_MBUS_FROM_MEDIA_BUS_FMT(UYVY8_2X8),
+	V4L2_MBUS_FROM_MEDIA_BUS_FMT(VYUY8_2X8),
+	V4L2_MBUS_FROM_MEDIA_BUS_FMT(YUYV8_2X8),
+	V4L2_MBUS_FROM_MEDIA_BUS_FMT(YVYU8_2X8),
+	V4L2_MBUS_FROM_MEDIA_BUS_FMT(Y10_1X10),
+	V4L2_MBUS_FROM_MEDIA_BUS_FMT(UYVY10_2X10),
+	V4L2_MBUS_FROM_MEDIA_BUS_FMT(VYUY10_2X10),
+	V4L2_MBUS_FROM_MEDIA_BUS_FMT(YUYV10_2X10),
+	V4L2_MBUS_FROM_MEDIA_BUS_FMT(YVYU10_2X10),
+	V4L2_MBUS_FROM_MEDIA_BUS_FMT(Y12_1X12),
+	V4L2_MBUS_FROM_MEDIA_BUS_FMT(UYVY8_1X16),
+	V4L2_MBUS_FROM_MEDIA_BUS_FMT(VYUY8_1X16),
+	V4L2_MBUS_FROM_MEDIA_BUS_FMT(YUYV8_1X16),
+	V4L2_MBUS_FROM_MEDIA_BUS_FMT(YVYU8_1X16),
+	V4L2_MBUS_FROM_MEDIA_BUS_FMT(YDYUYDYV8_1X16),
+	V4L2_MBUS_FROM_MEDIA_BUS_FMT(UYVY10_1X20),
+	V4L2_MBUS_FROM_MEDIA_BUS_FMT(VYUY10_1X20),
+	V4L2_MBUS_FROM_MEDIA_BUS_FMT(YUYV10_1X20),
+	V4L2_MBUS_FROM_MEDIA_BUS_FMT(YVYU10_1X20),
+	V4L2_MBUS_FROM_MEDIA_BUS_FMT(YUV10_1X30),
+	V4L2_MBUS_FROM_MEDIA_BUS_FMT(AYUV8_1X32),
+	V4L2_MBUS_FROM_MEDIA_BUS_FMT(UYVY12_2X12),
+	V4L2_MBUS_FROM_MEDIA_BUS_FMT(VYUY12_2X12),
+	V4L2_MBUS_FROM_MEDIA_BUS_FMT(YUYV12_2X12),
+	V4L2_MBUS_FROM_MEDIA_BUS_FMT(YVYU12_2X12),
+	V4L2_MBUS_FROM_MEDIA_BUS_FMT(UYVY12_1X24),
+	V4L2_MBUS_FROM_MEDIA_BUS_FMT(VYUY12_1X24),
+	V4L2_MBUS_FROM_MEDIA_BUS_FMT(YUYV12_1X24),
+	V4L2_MBUS_FROM_MEDIA_BUS_FMT(YVYU12_1X24),
 
-	/* JPEG compressed formats - next is 0x4002 */
-	V4L2_MBUS_FMT_JPEG_1X8 = 0x4001,
+	V4L2_MBUS_FROM_MEDIA_BUS_FMT(SBGGR8_1X8),
+	V4L2_MBUS_FROM_MEDIA_BUS_FMT(SGBRG8_1X8),
+	V4L2_MBUS_FROM_MEDIA_BUS_FMT(SGRBG8_1X8),
+	V4L2_MBUS_FROM_MEDIA_BUS_FMT(SRGGB8_1X8),
+	V4L2_MBUS_FROM_MEDIA_BUS_FMT(SBGGR10_ALAW8_1X8),
+	V4L2_MBUS_FROM_MEDIA_BUS_FMT(SGBRG10_ALAW8_1X8),
+	V4L2_MBUS_FROM_MEDIA_BUS_FMT(SGRBG10_ALAW8_1X8),
+	V4L2_MBUS_FROM_MEDIA_BUS_FMT(SRGGB10_ALAW8_1X8),
+	V4L2_MBUS_FROM_MEDIA_BUS_FMT(SBGGR10_DPCM8_1X8),
+	V4L2_MBUS_FROM_MEDIA_BUS_FMT(SGBRG10_DPCM8_1X8),
+	V4L2_MBUS_FROM_MEDIA_BUS_FMT(SGRBG10_DPCM8_1X8),
+	V4L2_MBUS_FROM_MEDIA_BUS_FMT(SRGGB10_DPCM8_1X8),
+	V4L2_MBUS_FROM_MEDIA_BUS_FMT(SBGGR10_2X8_PADHI_BE),
+	V4L2_MBUS_FROM_MEDIA_BUS_FMT(SBGGR10_2X8_PADHI_LE),
+	V4L2_MBUS_FROM_MEDIA_BUS_FMT(SBGGR10_2X8_PADLO_BE),
+	V4L2_MBUS_FROM_MEDIA_BUS_FMT(SBGGR10_2X8_PADLO_LE),
+	V4L2_MBUS_FROM_MEDIA_BUS_FMT(SBGGR10_1X10),
+	V4L2_MBUS_FROM_MEDIA_BUS_FMT(SGBRG10_1X10),
+	V4L2_MBUS_FROM_MEDIA_BUS_FMT(SGRBG10_1X10),
+	V4L2_MBUS_FROM_MEDIA_BUS_FMT(SRGGB10_1X10),
+	V4L2_MBUS_FROM_MEDIA_BUS_FMT(SBGGR12_1X12),
+	V4L2_MBUS_FROM_MEDIA_BUS_FMT(SGBRG12_1X12),
+	V4L2_MBUS_FROM_MEDIA_BUS_FMT(SGRBG12_1X12),
+	V4L2_MBUS_FROM_MEDIA_BUS_FMT(SRGGB12_1X12),
 
-	/* Vendor specific formats - next is 0x5002 */
+	V4L2_MBUS_FROM_MEDIA_BUS_FMT(JPEG_1X8),
 
-	/* S5C73M3 sensor specific interleaved UYVY and JPEG */
-	V4L2_MBUS_FMT_S5C_UYVY_JPEG_1X8 = 0x5001,
+	V4L2_MBUS_FROM_MEDIA_BUS_FMT(S5C_UYVY_JPEG_1X8),
 
-	/* HSV - next is 0x6002 */
-	V4L2_MBUS_FMT_AHSV8888_1X32 = 0x6001,
+	V4L2_MBUS_FROM_MEDIA_BUS_FMT(AHSV8888_1X32),
 };
 
 /**
-- 
1.9.1
