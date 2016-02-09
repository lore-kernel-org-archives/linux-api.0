From: Jonathan Cameron <jic23-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 2/5] iio: hmc5843: Swap suspend and resume implementations
Date: Tue, 9 Feb 2016 22:14:17 +0000
Message-ID: <56BA64B9.2090903@kernel.org>
References: <1454883711-15489-1-git-send-email-cristina.moraru09@gmail.com>
 <1454883711-15489-3-git-send-email-cristina.moraru09@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1454883711-15489-3-git-send-email-cristina.moraru09-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Cristina Moraru <cristina.moraru09-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, knaack.h-Mmb7MZpHnFY@public.gmane.org, lars-Qo5EllUWu/uELgA04lAiVw@public.gmane.org, pmeerw-jW+XmwGofnusTnJN9+BGXg@public.gmane.org, gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, cristina.opriceana-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, marek-xXXSsgcRVICgSpxsJD1C4w@public.gmane.org, sdliyong-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-iio-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, devel-gWbeCf7V1WCQmaza687I9mD2FQJk+8+b@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tolga.ceylan-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, k.kozlowski-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org, javier-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org, arnd-r2nGTMty4D4@public.gmane.org, geert-Td1EMuHUCqxL1ZNQvxDV9g@public.gmane.org, irina.tirdea-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, daniel.baluta-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, octavia.purdila-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
List-Id: linux-api@vger.kernel.org

On 07/02/16 22:21, Cristina Moraru wrote:
> Swap implementations of hmc5843_common_suspend and
> hmc5843_common_resume functions for they have been
> inversed. Device should go on SLEEP mode on suspend
> and on CONTINUOUS mode on resume.
> 
> Signed-off-by: Cristina Moraru <cristina.moraru09-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
I'd normally apply this as a fix, but to keep things simple with
the move out of staging I've just applied it to the togreg branch
of iio.git - initially pushed out as testing for the autobuilders
to play with it.

It's been there a long time an no one has noticed, so I'm guessing
any hardware platforms with this on aren't going in for power management!

Jonathan
> ---
>  drivers/staging/iio/magnetometer/hmc5843_core.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/staging/iio/magnetometer/hmc5843_core.c b/drivers/staging/iio/magnetometer/hmc5843_core.c
> index 4e2a7ec..dca8d64 100644
> --- a/drivers/staging/iio/magnetometer/hmc5843_core.c
> +++ b/drivers/staging/iio/magnetometer/hmc5843_core.c
> @@ -612,14 +612,14 @@ static const unsigned long hmc5843_scan_masks[] = {0x7, 0};
>  int hmc5843_common_suspend(struct device *dev)
>  {
>  	return hmc5843_set_mode(iio_priv(dev_get_drvdata(dev)),
> -			HMC5843_MODE_CONVERSION_CONTINUOUS);
> +				HMC5843_MODE_SLEEP);
>  }
>  EXPORT_SYMBOL(hmc5843_common_suspend);
>  
>  int hmc5843_common_resume(struct device *dev)
>  {
>  	return hmc5843_set_mode(iio_priv(dev_get_drvdata(dev)),
> -				HMC5843_MODE_SLEEP);
> +		HMC5843_MODE_CONVERSION_CONTINUOUS);
>  }
>  EXPORT_SYMBOL(hmc5843_common_resume);
>  
> 
