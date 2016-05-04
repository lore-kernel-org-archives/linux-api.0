From: Jonathan Cameron <jic23-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 06/13] iio: health/afe440x: Remove unneeded offset
 handling
Date: Wed, 4 May 2016 11:04:02 +0100
Message-ID: <4b396740-4b63-a8ac-b1b5-fe6980272552@kernel.org>
References: <1462135023-14445-1-git-send-email-afd@ti.com>
 <1462135023-14445-7-git-send-email-afd@ti.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-iio-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1462135023-14445-7-git-send-email-afd-l0cyMroinI0@public.gmane.org>
Sender: linux-iio-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Andrew F. Davis" <afd-l0cyMroinI0@public.gmane.org>, Hartmut Knaack <knaack.h-Mmb7MZpHnFY@public.gmane.org>, Lars-Peter Clausen <lars-Qo5EllUWu/uELgA04lAiVw@public.gmane.org>, Peter Meerwald <pmeerw-jW+XmwGofnusTnJN9+BGXg@public.gmane.org>
Cc: linux-iio-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On 01/05/16 21:36, Andrew F. Davis wrote:
> No channel in the afe4403 driver has IIO_CHAN_INFO_OFFSET set so
> remove the handlers for this.
> 
> Signed-off-by: Andrew F. Davis <afd-l0cyMroinI0@public.gmane.org>
Oops :)

Applied.
> ---
>  drivers/iio/health/afe4403.c | 17 -----------------
>  1 file changed, 17 deletions(-)
> 
> diff --git a/drivers/iio/health/afe4403.c b/drivers/iio/health/afe4403.c
> index bcff528..cac6090 100644
> --- a/drivers/iio/health/afe4403.c
> +++ b/drivers/iio/health/afe4403.c
> @@ -293,14 +293,6 @@ static int afe4403_read_raw(struct iio_dev *indio_dev,
>  			if (ret)
>  				return ret;
>  			return IIO_VAL_INT;
> -		case IIO_CHAN_INFO_OFFSET:
> -			ret = regmap_read(afe->regmap, reg_info.offreg,
> -					  val);
> -			if (ret)
> -				return ret;
> -			*val &= reg_info.mask;
> -			*val >>= reg_info.shift;
> -			return IIO_VAL_INT;
>  		}
>  		break;
>  	case IIO_CURRENT:
> @@ -333,15 +325,6 @@ static int afe4403_write_raw(struct iio_dev *indio_dev,
>  	const struct afe440x_reg_info reg_info = afe4403_reg_info[chan->address];
>  
>  	switch (chan->type) {
> -	case IIO_INTENSITY:
> -		switch (mask) {
> -		case IIO_CHAN_INFO_OFFSET:
> -			return regmap_update_bits(afe->regmap,
> -				reg_info.offreg,
> -				reg_info.mask,
> -				(val << reg_info.shift));
> -		}
> -		break;
>  	case IIO_CURRENT:
>  		switch (mask) {
>  		case IIO_CHAN_INFO_RAW:
> 
