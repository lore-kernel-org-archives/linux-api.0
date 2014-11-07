From: Boris Brezillon <boris.brezillon@free-electrons.com>
Subject: [PATCH v3 09/10] gpu: ipu-v3: Make use of media_bus_format enum
Date: Fri,  7 Nov 2014 15:07:48 +0100
Message-ID: <1415369269-5064-10-git-send-email-boris.brezillon@free-electrons.com>
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

In order to have subsytem agnostic media bus format definitions we've
moved media bus definition to include/uapi/linux/media-bus-format.h and
prefixed enum values with MEDIA_BUS_FMT instead of V4L2_MBUS_FMT.

Reference new definitions in the ipu-v3 driver.

Signed-off-by: Boris Brezillon <boris.brezillon@free-electrons.com>
---
 drivers/gpu/ipu-v3/ipu-csi.c | 66 ++++++++++++++++++++++----------------------
 1 file changed, 33 insertions(+), 33 deletions(-)

diff --git a/drivers/gpu/ipu-v3/ipu-csi.c b/drivers/gpu/ipu-v3/ipu-csi.c
index d6f56471..752cdd2 100644
--- a/drivers/gpu/ipu-v3/ipu-csi.c
+++ b/drivers/gpu/ipu-v3/ipu-csi.c
@@ -227,83 +227,83 @@ static int ipu_csi_set_testgen_mclk(struct ipu_csi *csi, u32 pixel_clk,
 static int mbus_code_to_bus_cfg(struct ipu_csi_bus_config *cfg, u32 mbus_code)
 {
 	switch (mbus_code) {
-	case V4L2_MBUS_FMT_BGR565_2X8_BE:
-	case V4L2_MBUS_FMT_BGR565_2X8_LE:
-	case V4L2_MBUS_FMT_RGB565_2X8_BE:
-	case V4L2_MBUS_FMT_RGB565_2X8_LE:
+	case MEDIA_BUS_FMT_BGR565_2X8_BE:
+	case MEDIA_BUS_FMT_BGR565_2X8_LE:
+	case MEDIA_BUS_FMT_RGB565_2X8_BE:
+	case MEDIA_BUS_FMT_RGB565_2X8_LE:
 		cfg->data_fmt = CSI_SENS_CONF_DATA_FMT_RGB565;
 		cfg->mipi_dt = MIPI_DT_RGB565;
 		cfg->data_width = IPU_CSI_DATA_WIDTH_8;
 		break;
-	case V4L2_MBUS_FMT_RGB444_2X8_PADHI_BE:
-	case V4L2_MBUS_FMT_RGB444_2X8_PADHI_LE:
+	case MEDIA_BUS_FMT_RGB444_2X8_PADHI_BE:
+	case MEDIA_BUS_FMT_RGB444_2X8_PADHI_LE:
 		cfg->data_fmt = CSI_SENS_CONF_DATA_FMT_RGB444;
 		cfg->mipi_dt = MIPI_DT_RGB444;
 		cfg->data_width = IPU_CSI_DATA_WIDTH_8;
 		break;
-	case V4L2_MBUS_FMT_RGB555_2X8_PADHI_BE:
-	case V4L2_MBUS_FMT_RGB555_2X8_PADHI_LE:
+	case MEDIA_BUS_FMT_RGB555_2X8_PADHI_BE:
+	case MEDIA_BUS_FMT_RGB555_2X8_PADHI_LE:
 		cfg->data_fmt = CSI_SENS_CONF_DATA_FMT_RGB555;
 		cfg->mipi_dt = MIPI_DT_RGB555;
 		cfg->data_width = IPU_CSI_DATA_WIDTH_8;
 		break;
-	case V4L2_MBUS_FMT_UYVY8_2X8:
+	case MEDIA_BUS_FMT_UYVY8_2X8:
 		cfg->data_fmt = CSI_SENS_CONF_DATA_FMT_YUV422_UYVY;
 		cfg->mipi_dt = MIPI_DT_YUV422;
 		cfg->data_width = IPU_CSI_DATA_WIDTH_8;
 		break;
-	case V4L2_MBUS_FMT_YUYV8_2X8:
+	case MEDIA_BUS_FMT_YUYV8_2X8:
 		cfg->data_fmt = CSI_SENS_CONF_DATA_FMT_YUV422_YUYV;
 		cfg->mipi_dt = MIPI_DT_YUV422;
 		cfg->data_width = IPU_CSI_DATA_WIDTH_8;
 		break;
-	case V4L2_MBUS_FMT_UYVY8_1X16:
+	case MEDIA_BUS_FMT_UYVY8_1X16:
 		cfg->data_fmt = CSI_SENS_CONF_DATA_FMT_YUV422_UYVY;
 		cfg->mipi_dt = MIPI_DT_YUV422;
 		cfg->data_width = IPU_CSI_DATA_WIDTH_16;
 		break;
-	case V4L2_MBUS_FMT_YUYV8_1X16:
+	case MEDIA_BUS_FMT_YUYV8_1X16:
 		cfg->data_fmt = CSI_SENS_CONF_DATA_FMT_YUV422_YUYV;
 		cfg->mipi_dt = MIPI_DT_YUV422;
 		cfg->data_width = IPU_CSI_DATA_WIDTH_16;
 		break;
-	case V4L2_MBUS_FMT_SBGGR8_1X8:
-	case V4L2_MBUS_FMT_SGBRG8_1X8:
-	case V4L2_MBUS_FMT_SGRBG8_1X8:
-	case V4L2_MBUS_FMT_SRGGB8_1X8:
+	case MEDIA_BUS_FMT_SBGGR8_1X8:
+	case MEDIA_BUS_FMT_SGBRG8_1X8:
+	case MEDIA_BUS_FMT_SGRBG8_1X8:
+	case MEDIA_BUS_FMT_SRGGB8_1X8:
 		cfg->data_fmt = CSI_SENS_CONF_DATA_FMT_BAYER;
 		cfg->mipi_dt = MIPI_DT_RAW8;
 		cfg->data_width = IPU_CSI_DATA_WIDTH_8;
 		break;
-	case V4L2_MBUS_FMT_SBGGR10_DPCM8_1X8:
-	case V4L2_MBUS_FMT_SGBRG10_DPCM8_1X8:
-	case V4L2_MBUS_FMT_SGRBG10_DPCM8_1X8:
-	case V4L2_MBUS_FMT_SRGGB10_DPCM8_1X8:
-	case V4L2_MBUS_FMT_SBGGR10_2X8_PADHI_BE:
-	case V4L2_MBUS_FMT_SBGGR10_2X8_PADHI_LE:
-	case V4L2_MBUS_FMT_SBGGR10_2X8_PADLO_BE:
-	case V4L2_MBUS_FMT_SBGGR10_2X8_PADLO_LE:
+	case MEDIA_BUS_FMT_SBGGR10_DPCM8_1X8:
+	case MEDIA_BUS_FMT_SGBRG10_DPCM8_1X8:
+	case MEDIA_BUS_FMT_SGRBG10_DPCM8_1X8:
+	case MEDIA_BUS_FMT_SRGGB10_DPCM8_1X8:
+	case MEDIA_BUS_FMT_SBGGR10_2X8_PADHI_BE:
+	case MEDIA_BUS_FMT_SBGGR10_2X8_PADHI_LE:
+	case MEDIA_BUS_FMT_SBGGR10_2X8_PADLO_BE:
+	case MEDIA_BUS_FMT_SBGGR10_2X8_PADLO_LE:
 		cfg->data_fmt = CSI_SENS_CONF_DATA_FMT_BAYER;
 		cfg->mipi_dt = MIPI_DT_RAW10;
 		cfg->data_width = IPU_CSI_DATA_WIDTH_8;
 		break;
-	case V4L2_MBUS_FMT_SBGGR10_1X10:
-	case V4L2_MBUS_FMT_SGBRG10_1X10:
-	case V4L2_MBUS_FMT_SGRBG10_1X10:
-	case V4L2_MBUS_FMT_SRGGB10_1X10:
+	case MEDIA_BUS_FMT_SBGGR10_1X10:
+	case MEDIA_BUS_FMT_SGBRG10_1X10:
+	case MEDIA_BUS_FMT_SGRBG10_1X10:
+	case MEDIA_BUS_FMT_SRGGB10_1X10:
 		cfg->data_fmt = CSI_SENS_CONF_DATA_FMT_BAYER;
 		cfg->mipi_dt = MIPI_DT_RAW10;
 		cfg->data_width = IPU_CSI_DATA_WIDTH_10;
 		break;
-	case V4L2_MBUS_FMT_SBGGR12_1X12:
-	case V4L2_MBUS_FMT_SGBRG12_1X12:
-	case V4L2_MBUS_FMT_SGRBG12_1X12:
-	case V4L2_MBUS_FMT_SRGGB12_1X12:
+	case MEDIA_BUS_FMT_SBGGR12_1X12:
+	case MEDIA_BUS_FMT_SGBRG12_1X12:
+	case MEDIA_BUS_FMT_SGRBG12_1X12:
+	case MEDIA_BUS_FMT_SRGGB12_1X12:
 		cfg->data_fmt = CSI_SENS_CONF_DATA_FMT_BAYER;
 		cfg->mipi_dt = MIPI_DT_RAW12;
 		cfg->data_width = IPU_CSI_DATA_WIDTH_12;
 		break;
-	case V4L2_MBUS_FMT_JPEG_1X8:
+	case MEDIA_BUS_FMT_JPEG_1X8:
 		/* TODO */
 		cfg->data_fmt = CSI_SENS_CONF_DATA_FMT_JPEG;
 		cfg->mipi_dt = MIPI_DT_RAW8;
-- 
1.9.1
