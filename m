From: Jonathan Cameron <jic23-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 05/13] iio: health/afe440x: Fix scan_index assignment
Date: Wed, 4 May 2016 11:03:27 +0100
Message-ID: <d2c4fafd-2fd0-ab63-df23-4a6fda897554@kernel.org>
References: <1462135023-14445-1-git-send-email-afd@ti.com>
 <1462135023-14445-6-git-send-email-afd@ti.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1462135023-14445-6-git-send-email-afd-l0cyMroinI0@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Andrew F. Davis" <afd-l0cyMroinI0@public.gmane.org>, Hartmut Knaack <knaack.h-Mmb7MZpHnFY@public.gmane.org>, Lars-Peter Clausen <lars-Qo5EllUWu/uELgA04lAiVw@public.gmane.org>, Peter Meerwald <pmeerw-jW+XmwGofnusTnJN9+BGXg@public.gmane.org>
Cc: linux-iio-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On 01/05/16 21:36, Andrew F. Davis wrote:
> The LED channels are not scannable and so scan_index should
> be negative, fix this here.
> 
> Signed-off-by: Andrew F. Davis <afd-l0cyMroinI0@public.gmane.org>
Good point.  I've applied this to the togreg branch, but if
you want me to push this one out as a fix it definitely qualifies.

Jonathan
> ---
>  drivers/iio/health/afe440x.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/iio/health/afe440x.h b/drivers/iio/health/afe440x.h
> index 544bbab..583d071 100644
> --- a/drivers/iio/health/afe440x.h
> +++ b/drivers/iio/health/afe440x.h
> @@ -125,7 +125,7 @@ struct afe440x_reg_info {
>  		.type = IIO_CURRENT,				\
>  		.channel = _index,				\
>  		.address = _index,				\
> -		.scan_index = _index,				\
> +		.scan_index = -1,				\
>  		.extend_name = _name,				\
>  		.info_mask_separate = BIT(IIO_CHAN_INFO_RAW) |	\
>  			BIT(IIO_CHAN_INFO_SCALE),		\
> 
