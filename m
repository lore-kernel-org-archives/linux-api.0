From: Alexander Shishkin <alexander.shishkin-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [PATCH V2 1/6] stm class: Add ioctl get_options interface
Date: Fri, 05 Feb 2016 14:55:31 +0200
Message-ID: <87k2mj5nb0.fsf@ashishki-desk.ger.corp.intel.com>
References: <1454487337-30184-1-git-send-email-zhang.chunyan@linaro.org> <1454487337-30184-2-git-send-email-zhang.chunyan@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1454487337-30184-2-git-send-email-zhang.chunyan-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Chunyan Zhang <zhang.chunyan-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, mathieu.poirier-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org
Cc: robh-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, broonie-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, pratikp-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org, nicolas.guion-qxv4g6HH51o@public.gmane.org, corbet-T1hC0tSOHrs@public.gmane.org, mark.rutland-5wv7dgnIgG8@public.gmane.org, mike.leach-5wv7dgnIgG8@public.gmane.org, tor-l0cyMroinI0@public.gmane.org, al.grant-5wv7dgnIgG8@public.gmane.org, zhang.lyra-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

Chunyan Zhang <zhang.chunyan-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org> writes:

> There is already an interface of set_options, but no get_options yet.
> Before setting any options, one would may want to see the current
> status of that option by means of get_options interface. This
> interface has been used in CoreSight STM driver.
>
> Signed-off-by: Chunyan Zhang <zhang.chunyan-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
> ---
>  drivers/hwtracing/stm/core.c | 11 +++++++++++
>  include/linux/stm.h          |  3 +++
>  include/uapi/linux/stm.h     |  1 +
>  3 files changed, 15 insertions(+)
>
> diff --git a/drivers/hwtracing/stm/core.c b/drivers/hwtracing/stm/core.c
> index b6445d9..86bb4e3 100644
> --- a/drivers/hwtracing/stm/core.c
> +++ b/drivers/hwtracing/stm/core.c
> @@ -571,6 +571,17 @@ stm_char_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
>  						    options);
>  
>  		break;
> +
> +	case STP_GET_OPTIONS:
> +		if (stm_data->get_options)
> +			err = stm_data->get_options(stm_data,
> +						    stmf->output.master,
> +						    stmf->output.channel,
> +						    stmf->output.nr_chans,
> +						    &options);
> +
> +		return copy_to_user((void __user *)arg, &options, sizeof(u64));

The return value of copy_to_user() is not what you assume it is.

Regards,
--
Alex
