From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: [PATCH 1/5] video: move mediabus format definition to a more
 standard place
Date: Tue, 23 Sep 2014 14:33:20 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.1409231426220.17074@axis700.grange>
References: <1406031827-12432-1-git-send-email-boris.brezillon@free-electrons.com>
 <1406031827-12432-2-git-send-email-boris.brezillon@free-electrons.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1406031827-12432-2-git-send-email-boris.brezillon@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Boris BREZILLON <boris.brezillon@free-electrons.com>
Cc: Thierry Reding <thierry.reding@gmail.com>, Laurent Pinchart <laurent.pinchart@ideasonboard.com>, David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, Mauro Carvalho Chehab <m.chehab@samsung.com>, linux-media@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Hi Boris,

On Tue, 22 Jul 2014, Boris BREZILLON wrote:

> Rename mediabus formats and move the enum into a separate header file so
> that it can be used by DRM/KMS subsystem without any reference to the V4L2
> subsystem.
> 
> Old V4L2_MBUS_FMT_ definitions are now macros that points to VIDEO_BUS_FMT_
> definitions.
> 
> Signed-off-by: Boris BREZILLON <boris.brezillon@free-electrons.com>

In principle I find this a good idea, certainly it's good to reuse code. 
Just wondering, wouldn't it be better instead of adding those defines to 
define a macro like

#define VIDEO_BUS_TO_MBUS(x)	V4L2_MBUS_ ## x = VIDEO_BUS_ ## x

and then do

enum v4l2_mbus_pixelcode {
	VIDEO_BUS_TO_MBUS(FIXED),
	VIDEO_BUS_TO_MBUS(RGB444_2X8_PADHI_BE),
	...
};

? I'm not very strong on this, I just think an enum is nicer than a bunch 
of defines and this way copy-paste errors are less likely, but if you or 
others strongly disagree - I won't insist :)

Whether or not you decide to accept this proposal you have my

Acked-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>

Thanks
Guennadi

> ---
>  include/uapi/linux/Kbuild             |   1 +
>  include/uapi/linux/v4l2-mediabus.h    | 183 ++++++++++++++--------------------
>  include/uapi/linux/video-bus-format.h | 127 +++++++++++++++++++++++
>  3 files changed, 205 insertions(+), 106 deletions(-)
>  create mode 100644 include/uapi/linux/video-bus-format.h
> 
> diff --git a/include/uapi/linux/Kbuild b/include/uapi/linux/Kbuild
> index 24e9033..371874b 100644
> --- a/include/uapi/linux/Kbuild
> +++ b/include/uapi/linux/Kbuild
> @@ -408,6 +408,7 @@ header-y += veth.h
>  header-y += vfio.h
>  header-y += vhost.h
>  header-y += videodev2.h
> +header-y += video-bus-format.h
>  header-y += virtio_9p.h
>  header-y += virtio_balloon.h
>  header-y += virtio_blk.h
> diff --git a/include/uapi/linux/v4l2-mediabus.h b/include/uapi/linux/v4l2-mediabus.h
> index 1445e85..8c31f11 100644
> --- a/include/uapi/linux/v4l2-mediabus.h
> +++ b/include/uapi/linux/v4l2-mediabus.h
> @@ -13,119 +13,90 @@
>  
>  #include <linux/types.h>
>  #include <linux/videodev2.h>
> +#include <linux/video-bus-format.h>
>  
> -/*
> - * These pixel codes uniquely identify data formats on the media bus. Mostly
> - * they correspond to similarly named V4L2_PIX_FMT_* formats, format 0 is
> - * reserved, V4L2_MBUS_FMT_FIXED shall be used by host-client pairs, where the
> - * data format is fixed. Additionally, "2X8" means that one pixel is transferred
> - * in two 8-bit samples, "BE" or "LE" specify in which order those samples are
> - * transferred over the bus: "LE" means that the least significant bits are
> - * transferred first, "BE" means that the most significant bits are transferred
> - * first, and "PADHI" and "PADLO" define which bits - low or high, in the
> - * incomplete high byte, are filled with padding bits.
> - *
> - * The pixel codes are grouped by type, bus_width, bits per component, samples
> - * per pixel and order of subsamples. Numerical values are sorted using generic
> - * numerical sort order (8 thus comes before 10).
> - *
> - * As their value can't change when a new pixel code is inserted in the
> - * enumeration, the pixel codes are explicitly given a numerical value. The next
> - * free values for each category are listed below, update them when inserting
> - * new pixel codes.
> - */
> -enum v4l2_mbus_pixelcode {
> -	V4L2_MBUS_FMT_FIXED = 0x0001,
> -
> -	/* RGB - next is 0x100e */
> -	V4L2_MBUS_FMT_RGB444_2X8_PADHI_BE = 0x1001,
> -	V4L2_MBUS_FMT_RGB444_2X8_PADHI_LE = 0x1002,
> -	V4L2_MBUS_FMT_RGB555_2X8_PADHI_BE = 0x1003,
> -	V4L2_MBUS_FMT_RGB555_2X8_PADHI_LE = 0x1004,
> -	V4L2_MBUS_FMT_BGR565_2X8_BE = 0x1005,
> -	V4L2_MBUS_FMT_BGR565_2X8_LE = 0x1006,
> -	V4L2_MBUS_FMT_RGB565_2X8_BE = 0x1007,
> -	V4L2_MBUS_FMT_RGB565_2X8_LE = 0x1008,
> -	V4L2_MBUS_FMT_RGB666_1X18 = 0x1009,
> -	V4L2_MBUS_FMT_RGB888_1X24 = 0x100a,
> -	V4L2_MBUS_FMT_RGB888_2X12_BE = 0x100b,
> -	V4L2_MBUS_FMT_RGB888_2X12_LE = 0x100c,
> -	V4L2_MBUS_FMT_ARGB8888_1X32 = 0x100d,
> +#define V4L2_MBUS_FMT_FIXED			VIDEO_BUS_FMT_FIXED
>  
> -	/* YUV (including grey) - next is 0x2024 */
> -	V4L2_MBUS_FMT_Y8_1X8 = 0x2001,
> -	V4L2_MBUS_FMT_UV8_1X8 = 0x2015,
> -	V4L2_MBUS_FMT_UYVY8_1_5X8 = 0x2002,
> -	V4L2_MBUS_FMT_VYUY8_1_5X8 = 0x2003,
> -	V4L2_MBUS_FMT_YUYV8_1_5X8 = 0x2004,
> -	V4L2_MBUS_FMT_YVYU8_1_5X8 = 0x2005,
> -	V4L2_MBUS_FMT_UYVY8_2X8 = 0x2006,
> -	V4L2_MBUS_FMT_VYUY8_2X8 = 0x2007,
> -	V4L2_MBUS_FMT_YUYV8_2X8 = 0x2008,
> -	V4L2_MBUS_FMT_YVYU8_2X8 = 0x2009,
> -	V4L2_MBUS_FMT_Y10_1X10 = 0x200a,
> -	V4L2_MBUS_FMT_UYVY10_2X10 = 0x2018,
> -	V4L2_MBUS_FMT_VYUY10_2X10 = 0x2019,
> -	V4L2_MBUS_FMT_YUYV10_2X10 = 0x200b,
> -	V4L2_MBUS_FMT_YVYU10_2X10 = 0x200c,
> -	V4L2_MBUS_FMT_Y12_1X12 = 0x2013,
> -	V4L2_MBUS_FMT_UYVY8_1X16 = 0x200f,
> -	V4L2_MBUS_FMT_VYUY8_1X16 = 0x2010,
> -	V4L2_MBUS_FMT_YUYV8_1X16 = 0x2011,
> -	V4L2_MBUS_FMT_YVYU8_1X16 = 0x2012,
> -	V4L2_MBUS_FMT_YDYUYDYV8_1X16 = 0x2014,
> -	V4L2_MBUS_FMT_UYVY10_1X20 = 0x201a,
> -	V4L2_MBUS_FMT_VYUY10_1X20 = 0x201b,
> -	V4L2_MBUS_FMT_YUYV10_1X20 = 0x200d,
> -	V4L2_MBUS_FMT_YVYU10_1X20 = 0x200e,
> -	V4L2_MBUS_FMT_YUV10_1X30 = 0x2016,
> -	V4L2_MBUS_FMT_AYUV8_1X32 = 0x2017,
> -	V4L2_MBUS_FMT_UYVY12_2X12 = 0x201c,
> -	V4L2_MBUS_FMT_VYUY12_2X12 = 0x201d,
> -	V4L2_MBUS_FMT_YUYV12_2X12 = 0x201e,
> -	V4L2_MBUS_FMT_YVYU12_2X12 = 0x201f,
> -	V4L2_MBUS_FMT_UYVY12_1X24 = 0x2020,
> -	V4L2_MBUS_FMT_VYUY12_1X24 = 0x2021,
> -	V4L2_MBUS_FMT_YUYV12_1X24 = 0x2022,
> -	V4L2_MBUS_FMT_YVYU12_1X24 = 0x2023,
> +#define V4L2_MBUS_FMT_RGB444_2X8_PADHI_BE	VIDEO_BUS_FMT_RGB444_2X8_PADHI_BE
> +#define V4L2_MBUS_FMT_RGB444_2X8_PADHI_LE	VIDEO_BUS_FMT_RGB444_2X8_PADHI_LE
> +#define V4L2_MBUS_FMT_RGB555_2X8_PADHI_BE	VIDEO_BUS_FMT_RGB555_2X8_PADHI_BE
> +#define V4L2_MBUS_FMT_RGB555_2X8_PADHI_LE	VIDEO_BUS_FMT_RGB555_2X8_PADHI_LE
> +#define V4L2_MBUS_FMT_BGR565_2X8_BE		VIDEO_BUS_FMT_BGR565_2X8_BE
> +#define V4L2_MBUS_FMT_BGR565_2X8_LE		VIDEO_BUS_FMT_BGR565_2X8_LE
> +#define V4L2_MBUS_FMT_RGB565_2X8_BE		VIDEO_BUS_FMT_RGB565_2X8_BE
> +#define V4L2_MBUS_FMT_RGB565_2X8_LE		VIDEO_BUS_FMT_RGB565_2X8_LE
> +#define V4L2_MBUS_FMT_RGB666_1X18		VIDEO_BUS_FMT_RGB666_1X18
> +#define V4L2_MBUS_FMT_RGB888_1X24		VIDEO_BUS_FMT_RGB888_1X24
> +#define V4L2_MBUS_FMT_RGB888_2X12_BE		VIDEO_BUS_FMT_RGB888_2X12_BE
> +#define V4L2_MBUS_FMT_RGB888_2X12_LE		VIDEO_BUS_FMT_RGB888_2X12_LE
> +#define V4L2_MBUS_FMT_ARGB8888_1X32		VIDEO_BUS_FMT_ARGB8888_1X32
>  
> -	/* Bayer - next is 0x3019 */
> -	V4L2_MBUS_FMT_SBGGR8_1X8 = 0x3001,
> -	V4L2_MBUS_FMT_SGBRG8_1X8 = 0x3013,
> -	V4L2_MBUS_FMT_SGRBG8_1X8 = 0x3002,
> -	V4L2_MBUS_FMT_SRGGB8_1X8 = 0x3014,
> -	V4L2_MBUS_FMT_SBGGR10_ALAW8_1X8 = 0x3015,
> -	V4L2_MBUS_FMT_SGBRG10_ALAW8_1X8 = 0x3016,
> -	V4L2_MBUS_FMT_SGRBG10_ALAW8_1X8 = 0x3017,
> -	V4L2_MBUS_FMT_SRGGB10_ALAW8_1X8 = 0x3018,
> -	V4L2_MBUS_FMT_SBGGR10_DPCM8_1X8 = 0x300b,
> -	V4L2_MBUS_FMT_SGBRG10_DPCM8_1X8 = 0x300c,
> -	V4L2_MBUS_FMT_SGRBG10_DPCM8_1X8 = 0x3009,
> -	V4L2_MBUS_FMT_SRGGB10_DPCM8_1X8 = 0x300d,
> -	V4L2_MBUS_FMT_SBGGR10_2X8_PADHI_BE = 0x3003,
> -	V4L2_MBUS_FMT_SBGGR10_2X8_PADHI_LE = 0x3004,
> -	V4L2_MBUS_FMT_SBGGR10_2X8_PADLO_BE = 0x3005,
> -	V4L2_MBUS_FMT_SBGGR10_2X8_PADLO_LE = 0x3006,
> -	V4L2_MBUS_FMT_SBGGR10_1X10 = 0x3007,
> -	V4L2_MBUS_FMT_SGBRG10_1X10 = 0x300e,
> -	V4L2_MBUS_FMT_SGRBG10_1X10 = 0x300a,
> -	V4L2_MBUS_FMT_SRGGB10_1X10 = 0x300f,
> -	V4L2_MBUS_FMT_SBGGR12_1X12 = 0x3008,
> -	V4L2_MBUS_FMT_SGBRG12_1X12 = 0x3010,
> -	V4L2_MBUS_FMT_SGRBG12_1X12 = 0x3011,
> -	V4L2_MBUS_FMT_SRGGB12_1X12 = 0x3012,
> +#define V4L2_MBUS_FMT_Y8_1X8			VIDEO_BUS_FMT_Y8_1X8
> +#define V4L2_MBUS_FMT_UV8_1X8			VIDEO_BUS_FMT_UV8_1X8
> +#define V4L2_MBUS_FMT_UYVY8_1_5X8		VIDEO_BUS_FMT_UYVY8_1_5X8
> +#define V4L2_MBUS_FMT_VYUY8_1_5X8		VIDEO_BUS_FMT_VYUY8_1_5X8
> +#define V4L2_MBUS_FMT_YUYV8_1_5X8		VIDEO_BUS_FMT_YUYV8_1_5X8
> +#define V4L2_MBUS_FMT_YVYU8_1_5X8		VIDEO_BUS_FMT_YVYU8_1_5X8
> +#define V4L2_MBUS_FMT_UYVY8_2X8			VIDEO_BUS_FMT_UYVY8_2X8
> +#define V4L2_MBUS_FMT_VYUY8_2X8			VIDEO_BUS_FMT_VYUY8_2X8
> +#define V4L2_MBUS_FMT_YUYV8_2X8			VIDEO_BUS_FMT_YUYV8_2X8
> +#define V4L2_MBUS_FMT_YVYU8_2X8			VIDEO_BUS_FMT_YVYU8_2X8
> +#define V4L2_MBUS_FMT_Y10_1X10			VIDEO_BUS_FMT_Y10_1X10
> +#define V4L2_MBUS_FMT_UYVY10_2X10		VIDEO_BUS_FMT_UYVY10_2X10
> +#define V4L2_MBUS_FMT_VYUY10_2X10		VIDEO_BUS_FMT_VYUY10_2X10
> +#define V4L2_MBUS_FMT_YUYV10_2X10		VIDEO_BUS_FMT_YUYV10_2X10
> +#define V4L2_MBUS_FMT_YVYU10_2X10		VIDEO_BUS_FMT_YVYU10_2X10
> +#define V4L2_MBUS_FMT_Y12_1X12			VIDEO_BUS_FMT_Y12_1X12
> +#define V4L2_MBUS_FMT_UYVY8_1X16		VIDEO_BUS_FMT_UYVY8_1X16
> +#define V4L2_MBUS_FMT_VYUY8_1X16		VIDEO_BUS_FMT_VYUY8_1X16
> +#define V4L2_MBUS_FMT_YUYV8_1X16		VIDEO_BUS_FMT_YUYV8_1X16
> +#define V4L2_MBUS_FMT_YVYU8_1X16		VIDEO_BUS_FMT_YVYU8_1X16
> +#define V4L2_MBUS_FMT_YDYUYDYV8_1X16		VIDEO_BUS_FMT_YDYUYDYV8_1X16
> +#define V4L2_MBUS_FMT_UYVY10_1X20		VIDEO_BUS_FMT_UYVY10_1X20
> +#define V4L2_MBUS_FMT_VYUY10_1X20		VIDEO_BUS_FMT_VYUY10_1X20
> +#define V4L2_MBUS_FMT_YUYV10_1X20		VIDEO_BUS_FMT_YUYV10_1X20
> +#define V4L2_MBUS_FMT_YVYU10_1X20		VIDEO_BUS_FMT_YVYU10_1X20
> +#define V4L2_MBUS_FMT_YUV10_1X30		VIDEO_BUS_FMT_YUV10_1X30
> +#define V4L2_MBUS_FMT_AYUV8_1X32		VIDEO_BUS_FMT_AYUV8_1X32
> +#define V4L2_MBUS_FMT_UYVY12_2X12		VIDEO_BUS_FMT_UYVY12_2X12
> +#define V4L2_MBUS_FMT_VYUY12_2X12		VIDEO_BUS_FMT_VYUY12_2X12
> +#define V4L2_MBUS_FMT_YUYV12_2X12		VIDEO_BUS_FMT_YUYV12_2X12
> +#define V4L2_MBUS_FMT_YVYU12_2X12		VIDEO_BUS_FMT_YVYU12_2X12
> +#define V4L2_MBUS_FMT_UYVY12_1X24		VIDEO_BUS_FMT_UYVY12_1X24
> +#define V4L2_MBUS_FMT_VYUY12_1X24		VIDEO_BUS_FMT_VYUY12_1X24
> +#define V4L2_MBUS_FMT_YUYV12_1X24		VIDEO_BUS_FMT_YUYV12_1X24
> +#define V4L2_MBUS_FMT_YVYU12_1X24		VIDEO_BUS_FMT_YVYU12_1X24
>  
> -	/* JPEG compressed formats - next is 0x4002 */
> -	V4L2_MBUS_FMT_JPEG_1X8 = 0x4001,
> +#define V4L2_MBUS_FMT_SBGGR8_1X8		VIDEO_BUS_FMT_SBGGR8_1X8
> +#define V4L2_MBUS_FMT_SGBRG8_1X8		VIDEO_BUS_FMT_SGBRG8_1X8
> +#define V4L2_MBUS_FMT_SGRBG8_1X8		VIDEO_BUS_FMT_SGRBG8_1X8
> +#define V4L2_MBUS_FMT_SRGGB8_1X8		VIDEO_BUS_FMT_SRGGB8_1X8
> +#define V4L2_MBUS_FMT_SBGGR10_ALAW8_1X8		VIDEO_BUS_FMT_SBGGR10_ALAW8_1X8
> +#define V4L2_MBUS_FMT_SGBRG10_ALAW8_1X8		VIDEO_BUS_FMT_SGBRG10_ALAW8_1X8
> +#define V4L2_MBUS_FMT_SGRBG10_ALAW8_1X8		VIDEO_BUS_FMT_SGRBG10_ALAW8_1X8
> +#define V4L2_MBUS_FMT_SRGGB10_ALAW8_1X8		VIDEO_BUS_FMT_SRGGB10_ALAW8_1X8
> +#define V4L2_MBUS_FMT_SBGGR10_DPCM8_1X8		VIDEO_BUS_FMT_SBGGR10_DPCM8_1X8
> +#define V4L2_MBUS_FMT_SGBRG10_DPCM8_1X8		VIDEO_BUS_FMT_SGBRG10_DPCM8_1X8
> +#define V4L2_MBUS_FMT_SGRBG10_DPCM8_1X8		VIDEO_BUS_FMT_SGRBG10_DPCM8_1X8
> +#define V4L2_MBUS_FMT_SRGGB10_DPCM8_1X8		VIDEO_BUS_FMT_SRGGB10_DPCM8_1X8
> +#define V4L2_MBUS_FMT_SBGGR10_2X8_PADHI_BE	VIDEO_BUS_FMT_SBGGR10_2X8_PADHI_BE
> +#define V4L2_MBUS_FMT_SBGGR10_2X8_PADHI_LE	VIDEO_BUS_FMT_SBGGR10_2X8_PADHI_LE
> +#define V4L2_MBUS_FMT_SBGGR10_2X8_PADLO_BE	VIDEO_BUS_FMT_SBGGR10_2X8_PADLO_BE
> +#define V4L2_MBUS_FMT_SBGGR10_2X8_PADLO_LE	VIDEO_BUS_FMT_SBGGR10_2X8_PADLO_LE
> +#define V4L2_MBUS_FMT_SBGGR10_1X10		VIDEO_BUS_FMT_SBGGR10_1X10
> +#define V4L2_MBUS_FMT_SGBRG10_1X10		VIDEO_BUS_FMT_SGBRG10_1X10
> +#define V4L2_MBUS_FMT_SGRBG10_1X10		VIDEO_BUS_FMT_SGRBG10_1X10
> +#define V4L2_MBUS_FMT_SRGGB10_1X10		VIDEO_BUS_FMT_SRGGB10_1X10
> +#define V4L2_MBUS_FMT_SBGGR12_1X12		VIDEO_BUS_FMT_SBGGR12_1X12
> +#define V4L2_MBUS_FMT_SGBRG12_1X12		VIDEO_BUS_FMT_SGBRG12_1X12
> +#define V4L2_MBUS_FMT_SGRBG12_1X12		VIDEO_BUS_FMT_SGRBG12_1X12
> +#define V4L2_MBUS_FMT_SRGGB12_1X12		VIDEO_BUS_FMT_SRGGB12_1X12
>  
> -	/* Vendor specific formats - next is 0x5002 */
> +#define V4L2_MBUS_FMT_JPEG_1X8			VIDEO_BUS_FMT_JPEG_1X8
>  
> -	/* S5C73M3 sensor specific interleaved UYVY and JPEG */
> -	V4L2_MBUS_FMT_S5C_UYVY_JPEG_1X8 = 0x5001,
> +#define V4L2_MBUS_FMT_S5C_UYVY_JPEG_1X8		VIDEO_BUS_FMT_S5C_UYVY_JPEG_1X8
>  
> -	/* HSV - next is 0x6002 */
> -	V4L2_MBUS_FMT_AHSV8888_1X32 = 0x6001,
> -};
> +#define V4L2_MBUS_FMT_AHSV8888_1X32		VIDEO_BUS_FMT_AHSV8888_1X32
>  
>  /**
>   * struct v4l2_mbus_framefmt - frame format on the media bus
> diff --git a/include/uapi/linux/video-bus-format.h b/include/uapi/linux/video-bus-format.h
> new file mode 100644
> index 0000000..4abbd5d
> --- /dev/null
> +++ b/include/uapi/linux/video-bus-format.h
> @@ -0,0 +1,127 @@
> +/*
> + * Video Bus API header
> + *
> + * Copyright (C) 2009, Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + */
> +
> +#ifndef __LINUX_VIDEO_BUS_FORMAT_H
> +#define __LINUX_VIDEO_BUS_FORMAT_H
> +
> +/*
> + * These bus formats uniquely identify data formats on the data bus. Mostly
> + * they correspond to similarly named VIDEO_PIX_FMT_* formats, format 0 is
> + * reserved, VIDEO_BUS_FMT_FIXED shall be used by host-client pairs, where the
> + * data format is fixed. Additionally, "2X8" means that one pixel is transferred
> + * in two 8-bit samples, "BE" or "LE" specify in which order those samples are
> + * transferred over the bus: "LE" means that the least significant bits are
> + * transferred first, "BE" means that the most significant bits are transferred
> + * first, and "PADHI" and "PADLO" define which bits - low or high, in the
> + * incomplete high byte, are filled with padding bits.
> + *
> + * The bus formats are grouped by type, bus_width, bits per component, samples
> + * per pixel and order of subsamples. Numerical values are sorted using generic
> + * numerical sort order (8 thus comes before 10).
> + *
> + * As their value can't change when a new bus format is inserted in the
> + * enumeration, the bus formats are explicitly given a numerical value. The next
> + * free values for each category are listed below, update them when inserting
> + * new pixel codes.
> + */
> +enum video_bus_format {
> +	VIDEO_BUS_FMT_FIXED = 0x0001,
> +
> +	/* RGB - next is 0x100e */
> +	VIDEO_BUS_FMT_RGB444_2X8_PADHI_BE = 0x1001,
> +	VIDEO_BUS_FMT_RGB444_2X8_PADHI_LE = 0x1002,
> +	VIDEO_BUS_FMT_RGB555_2X8_PADHI_BE = 0x1003,
> +	VIDEO_BUS_FMT_RGB555_2X8_PADHI_LE = 0x1004,
> +	VIDEO_BUS_FMT_BGR565_2X8_BE = 0x1005,
> +	VIDEO_BUS_FMT_BGR565_2X8_LE = 0x1006,
> +	VIDEO_BUS_FMT_RGB565_2X8_BE = 0x1007,
> +	VIDEO_BUS_FMT_RGB565_2X8_LE = 0x1008,
> +	VIDEO_BUS_FMT_RGB666_1X18 = 0x1009,
> +	VIDEO_BUS_FMT_RGB888_1X24 = 0x100a,
> +	VIDEO_BUS_FMT_RGB888_2X12_BE = 0x100b,
> +	VIDEO_BUS_FMT_RGB888_2X12_LE = 0x100c,
> +	VIDEO_BUS_FMT_ARGB8888_1X32 = 0x100d,
> +
> +	/* YUV (including grey) - next is 0x2024 */
> +	VIDEO_BUS_FMT_Y8_1X8 = 0x2001,
> +	VIDEO_BUS_FMT_UV8_1X8 = 0x2015,
> +	VIDEO_BUS_FMT_UYVY8_1_5X8 = 0x2002,
> +	VIDEO_BUS_FMT_VYUY8_1_5X8 = 0x2003,
> +	VIDEO_BUS_FMT_YUYV8_1_5X8 = 0x2004,
> +	VIDEO_BUS_FMT_YVYU8_1_5X8 = 0x2005,
> +	VIDEO_BUS_FMT_UYVY8_2X8 = 0x2006,
> +	VIDEO_BUS_FMT_VYUY8_2X8 = 0x2007,
> +	VIDEO_BUS_FMT_YUYV8_2X8 = 0x2008,
> +	VIDEO_BUS_FMT_YVYU8_2X8 = 0x2009,
> +	VIDEO_BUS_FMT_Y10_1X10 = 0x200a,
> +	VIDEO_BUS_FMT_UYVY10_2X10 = 0x2018,
> +	VIDEO_BUS_FMT_VYUY10_2X10 = 0x2019,
> +	VIDEO_BUS_FMT_YUYV10_2X10 = 0x200b,
> +	VIDEO_BUS_FMT_YVYU10_2X10 = 0x200c,
> +	VIDEO_BUS_FMT_Y12_1X12 = 0x2013,
> +	VIDEO_BUS_FMT_UYVY8_1X16 = 0x200f,
> +	VIDEO_BUS_FMT_VYUY8_1X16 = 0x2010,
> +	VIDEO_BUS_FMT_YUYV8_1X16 = 0x2011,
> +	VIDEO_BUS_FMT_YVYU8_1X16 = 0x2012,
> +	VIDEO_BUS_FMT_YDYUYDYV8_1X16 = 0x2014,
> +	VIDEO_BUS_FMT_UYVY10_1X20 = 0x201a,
> +	VIDEO_BUS_FMT_VYUY10_1X20 = 0x201b,
> +	VIDEO_BUS_FMT_YUYV10_1X20 = 0x200d,
> +	VIDEO_BUS_FMT_YVYU10_1X20 = 0x200e,
> +	VIDEO_BUS_FMT_YUV10_1X30 = 0x2016,
> +	VIDEO_BUS_FMT_AYUV8_1X32 = 0x2017,
> +	VIDEO_BUS_FMT_UYVY12_2X12 = 0x201c,
> +	VIDEO_BUS_FMT_VYUY12_2X12 = 0x201d,
> +	VIDEO_BUS_FMT_YUYV12_2X12 = 0x201e,
> +	VIDEO_BUS_FMT_YVYU12_2X12 = 0x201f,
> +	VIDEO_BUS_FMT_UYVY12_1X24 = 0x2020,
> +	VIDEO_BUS_FMT_VYUY12_1X24 = 0x2021,
> +	VIDEO_BUS_FMT_YUYV12_1X24 = 0x2022,
> +	VIDEO_BUS_FMT_YVYU12_1X24 = 0x2023,
> +
> +	/* Bayer - next is 0x3019 */
> +	VIDEO_BUS_FMT_SBGGR8_1X8 = 0x3001,
> +	VIDEO_BUS_FMT_SGBRG8_1X8 = 0x3013,
> +	VIDEO_BUS_FMT_SGRBG8_1X8 = 0x3002,
> +	VIDEO_BUS_FMT_SRGGB8_1X8 = 0x3014,
> +	VIDEO_BUS_FMT_SBGGR10_ALAW8_1X8 = 0x3015,
> +	VIDEO_BUS_FMT_SGBRG10_ALAW8_1X8 = 0x3016,
> +	VIDEO_BUS_FMT_SGRBG10_ALAW8_1X8 = 0x3017,
> +	VIDEO_BUS_FMT_SRGGB10_ALAW8_1X8 = 0x3018,
> +	VIDEO_BUS_FMT_SBGGR10_DPCM8_1X8 = 0x300b,
> +	VIDEO_BUS_FMT_SGBRG10_DPCM8_1X8 = 0x300c,
> +	VIDEO_BUS_FMT_SGRBG10_DPCM8_1X8 = 0x3009,
> +	VIDEO_BUS_FMT_SRGGB10_DPCM8_1X8 = 0x300d,
> +	VIDEO_BUS_FMT_SBGGR10_2X8_PADHI_BE = 0x3003,
> +	VIDEO_BUS_FMT_SBGGR10_2X8_PADHI_LE = 0x3004,
> +	VIDEO_BUS_FMT_SBGGR10_2X8_PADLO_BE = 0x3005,
> +	VIDEO_BUS_FMT_SBGGR10_2X8_PADLO_LE = 0x3006,
> +	VIDEO_BUS_FMT_SBGGR10_1X10 = 0x3007,
> +	VIDEO_BUS_FMT_SGBRG10_1X10 = 0x300e,
> +	VIDEO_BUS_FMT_SGRBG10_1X10 = 0x300a,
> +	VIDEO_BUS_FMT_SRGGB10_1X10 = 0x300f,
> +	VIDEO_BUS_FMT_SBGGR12_1X12 = 0x3008,
> +	VIDEO_BUS_FMT_SGBRG12_1X12 = 0x3010,
> +	VIDEO_BUS_FMT_SGRBG12_1X12 = 0x3011,
> +	VIDEO_BUS_FMT_SRGGB12_1X12 = 0x3012,
> +
> +	/* JPEG compressed formats - next is 0x4002 */
> +	VIDEO_BUS_FMT_JPEG_1X8 = 0x4001,
> +
> +	/* Vendor specific formats - next is 0x5002 */
> +
> +	/* S5C73M3 sensor specific interleaved UYVY and JPEG */
> +	VIDEO_BUS_FMT_S5C_UYVY_JPEG_1X8 = 0x5001,
> +
> +	/* HSV - next is 0x6002 */
> +	VIDEO_BUS_FMT_AHSV8888_1X32 = 0x6001,
> +};
> +
> +#endif /* __LINUX_VIDEO_BUS_FORMAT_H */
> -- 
> 1.8.3.2
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
