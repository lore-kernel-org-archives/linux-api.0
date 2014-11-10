From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: [PATCH v5 10/10] [media] v4l: Forbid usage of V4L2_MBUS_FMT
 definitions inside the kernel
Date: Mon, 10 Nov 2014 12:09:19 +0100
Message-ID: <54609CDF.8030303@xs4all.nl>
References: <1415369269-5064-1-git-send-email-boris.brezillon@free-electrons.com>
 <1415461632-31236-1-git-send-email-boris.brezillon@free-electrons.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
In-Reply-To: <1415461632-31236-1-git-send-email-boris.brezillon@free-electrons.com>
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel/>
List-Post: <mailto:driverdev-devel@linuxdriverproject.org>
List-Help: <mailto:driverdev-devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: driverdev-devel-bounces@linuxdriverproject.org
Sender: "devel" <driverdev-devel-bounces@linuxdriverproject.org>
To: Boris Brezillon <boris.brezillon@free-electrons.com>, Mauro Carvalho Chehab <m.chehab@samsung.com>, Hans Verkuil <hans.verkuil@cisco.com>, Laurent Pinchart <laurent.pinchart@ideasonboard.com>, linux-media@vger.kernel.org, Sakari Ailus <sakari.ailus@iki.fi>
Cc: devel@driverdev.osuosl.org, linux-doc@vger.kernel.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, Guennadi Liakhovetski <g.liakhovetski@gmx.de>, linux-arm-kernel@lists.infradead.org
List-Id: linux-api@vger.kernel.org

On 11/08/2014 04:47 PM, Boris Brezillon wrote:
> Place v4l2_mbus_pixelcode in a #ifndef __KERNEL__ section so that kernel
> users don't have access to these definitions.
> 
> We have to keep this definition for user-space users even though they're
> encouraged to move to the new media_bus_format enum.
> 
> Signed-off-by: Boris Brezillon <boris.brezillon@free-electrons.com>
> Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> ---
>  include/uapi/linux/v4l2-mediabus.h | 45 ++++++++++++++++++++++++--------------
>  1 file changed, 28 insertions(+), 17 deletions(-)
> 
> diff --git a/include/uapi/linux/v4l2-mediabus.h b/include/uapi/linux/v4l2-mediabus.h
> index d712df8..5c9410d 100644
> --- a/include/uapi/linux/v4l2-mediabus.h
> +++ b/include/uapi/linux/v4l2-mediabus.h
> @@ -15,6 +15,33 @@
>  #include <linux/types.h>
>  #include <linux/videodev2.h>
>  
> +/**
> + * struct v4l2_mbus_framefmt - frame format on the media bus
> + * @width:	frame width
> + * @height:	frame height
> + * @code:	data format code (from enum v4l2_mbus_pixelcode)
> + * @field:	used interlacing type (from enum v4l2_field)
> + * @colorspace:	colorspace of the data (from enum v4l2_colorspace)
> + */
> +struct v4l2_mbus_framefmt {
> +	__u32			width;
> +	__u32			height;
> +	__u32			code;
> +	__u32			field;
> +	__u32			colorspace;
> +	__u32			reserved[7];
> +};
> +
> +#ifndef __KERNEL__
> +/*
> + * enum v4l2_mbus_pixelcode and its definitions are now deprecated, and
> + * MEDIA_BUS_FMT_ definitions (defined in media-bus-format.h) should be
> + * used instead.
> + *
> + * New defines should only be added to media-bus-format.h. The
> + * v4l2_mbus_pixelcode enum is frozen.
> + */
> +
>  #define V4L2_MBUS_FROM_MEDIA_BUS_FMT(name)	\
>  	MEDIA_BUS_FMT_ ## name = V4L2_MBUS_FMT_ ## name

Shouldn't this be the other way around?

  	V4L2_MBUS_FMT_ ## name = MEDIA_BUS_FMT_ ## name

Regards,

	Hans

>  
> @@ -102,22 +129,6 @@ enum v4l2_mbus_pixelcode {
>  
>  	V4L2_MBUS_FROM_MEDIA_BUS_FMT(AHSV8888_1X32),
>  };
> -
> -/**
> - * struct v4l2_mbus_framefmt - frame format on the media bus
> - * @width:	frame width
> - * @height:	frame height
> - * @code:	data format code (from enum v4l2_mbus_pixelcode)
> - * @field:	used interlacing type (from enum v4l2_field)
> - * @colorspace:	colorspace of the data (from enum v4l2_colorspace)
> - */
> -struct v4l2_mbus_framefmt {
> -	__u32			width;
> -	__u32			height;
> -	__u32			code;
> -	__u32			field;
> -	__u32			colorspace;
> -	__u32			reserved[7];
> -};
> +#endif /* __KERNEL__ */
>  
>  #endif
> 
