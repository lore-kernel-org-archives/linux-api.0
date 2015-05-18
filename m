From: Laurent Pinchart <laurent.pinchart-ryLnwIuWjnjg/C1BVhZhaw@public.gmane.org>
Subject: Re: [PATCH] media: uapi: vsp1: Use __u32 instead of u32
Date: Mon, 18 May 2015 13:30:25 +0300
Message-ID: <2148994.nAnETH4BnO@avalon>
References: <1431799900.15709.84.camel@perches.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1431799900.15709.84.camel-6d6DIl74uiNBDgjK7y7TUQ@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Joe Perches <joe-6d6DIl74uiNBDgjK7y7TUQ@public.gmane.org>
Cc: linux-api <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Hi Joe,

Thank you for the patch.

On Saturday 16 May 2015 11:11:40 Joe Perches wrote:
> Don't use the kernel types in uapi headers.
> 
> Signed-off-by: Joe Perches <joe-6d6DIl74uiNBDgjK7y7TUQ@public.gmane.org>

Acked-by: Laurent Pinchart <laurent.pinchart-ryLnwIuWjnjg/C1BVhZhaw@public.gmane.org>

and applied to my tree.

> ---
>  include/uapi/linux/vsp1.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/include/uapi/linux/vsp1.h b/include/uapi/linux/vsp1.h
> index e18858f..9a82369 100644
> --- a/include/uapi/linux/vsp1.h
> +++ b/include/uapi/linux/vsp1.h
> @@ -28,7 +28,7 @@
>  	_IOWR('V', BASE_VIDIOC_PRIVATE + 1, struct vsp1_lut_config)
> 
>  struct vsp1_lut_config {
> -	u32 lut[256];
> +	__u32 lut[256];
>  };
> 
>  #endif	/* __VSP1_USER_H__ */

-- 
Regards,

Laurent Pinchart
