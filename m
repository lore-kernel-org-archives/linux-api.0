From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: [PATCH v3 10/10] [media] v4l: Forbid usage of V4L2_MBUS_FMT
 definitions inside the kernel
Date: Fri, 07 Nov 2014 15:47:41 +0100
Message-ID: <545CDB8D.4080406@xs4all.nl>
References: <1415369269-5064-1-git-send-email-boris.brezillon@free-electrons.com>
 <1415369269-5064-11-git-send-email-boris.brezillon@free-electrons.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
In-Reply-To: <1415369269-5064-11-git-send-email-boris.brezillon@free-electrons.com>
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

Nitpicks:

On 11/07/14 15:07, Boris Brezillon wrote:
> Place v4l2_mbus_pixelcode in a #ifndef __KERNEL__ section so that kernel
> users don't have access to these definitions.
> 
> We have to keep this definition for user-space users even though they're
> encouraged to move to the new media_bus_format enum.
> 
> Signed-off-by: Boris Brezillon <boris.brezillon@free-electrons.com>
> ---
>  include/uapi/linux/v4l2-mediabus.h | 9 +++++++++
>  1 file changed, 9 insertions(+)
> 
> diff --git a/include/uapi/linux/v4l2-mediabus.h b/include/uapi/linux/v4l2-mediabus.h
> index 3d87db7..4f31d0e 100644
> --- a/include/uapi/linux/v4l2-mediabus.h
> +++ b/include/uapi/linux/v4l2-mediabus.h
> @@ -15,6 +15,14 @@
>  #include <linux/videodev2.h>
>  #include <linux/media-bus-format.h>
>  
> +#ifndef __KERNEL__
> +
> +/*
> + * enum v4l2_mbus_pixelcode and its defintions are now deprecated, and

defintions -> definitions

> + * MEDIA_BUS_FMT_ defintions (defined in media-bus-format.h) should be

and again...

> + * used instead.

I would also add something like this:

"New defines should only be added to media-bus-format.h. The v4l2_mbus_pixelcode
enum is frozen."

> + */
> +
>  #define V4L2_MBUS_FROM_MEDIA_BUS_FMT(name)	\
>  	MEDIA_BUS_FMT_ ## name = V4L2_MBUS_FMT_ ## name
>  
> @@ -102,6 +110,7 @@ enum v4l2_mbus_pixelcode {
>  
>  	V4L2_MBUS_FROM_MEDIA_BUS_FMT(AHSV8888_1X32),
>  };
> +#endif /* __KERNEL__ */
>  
>  /**
>   * struct v4l2_mbus_framefmt - frame format on the media bus
> 

Can you move this struct forward to before the v4l2_mbus_pixelcode enum? That way
the obsolete code is at the end of the header. People might miss this struct
otherwise.

Regards,

	Hans
