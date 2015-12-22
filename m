From: Jonathan Cameron <jic23-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v3 1/5] iio: Make IIO value formating function globally
 available.
Date: Tue, 22 Dec 2015 17:05:24 +0000
Message-ID: <567982D4.2060502@kernel.org>
References: <1450132561-5245-1-git-send-email-afd@ti.com>
 <1450132561-5245-2-git-send-email-afd@ti.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-iio-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1450132561-5245-2-git-send-email-afd-l0cyMroinI0@public.gmane.org>
Sender: linux-iio-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Andrew F. Davis" <afd-l0cyMroinI0@public.gmane.org>, Rob Herring <robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Pawel Moll <pawel.moll-5wv7dgnIgG8@public.gmane.org>, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, Ian Campbell <ijc+devicetree-KcIKpvwj1kUDXYZnReoRVg@public.gmane.org>, Kumar Gala <galak-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, Hartmut Knaack <knaack.h-Mmb7MZpHnFY@public.gmane.org>, Lars-Peter Clausen <lars-Qo5EllUWu/uELgA04lAiVw@public.gmane.org>, Peter Meerwald <pmeerw-jW+XmwGofnusTnJN9+BGXg@public.gmane.org>
Cc: devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-iio-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On 14/12/15 22:35, Andrew F. Davis wrote:
> Make IIO value formating function globally available to allow IIO drivers
> to output values as the core does.
> 
> Signed-off-by: Andrew F. Davis <afd-l0cyMroinI0@public.gmane.org>
Applied to the togreg branch of iio.git - initially pushed out as testing for the
autobuilders to play with it.

Thanks,

Jonathan
> ---
>  drivers/iio/industrialio-core.c | 1 +
>  include/linux/iio/iio.h         | 2 ++
>  2 files changed, 3 insertions(+)
> 
> diff --git a/drivers/iio/industrialio-core.c b/drivers/iio/industrialio-core.c
> index 208358f..eb5909d 100644
> --- a/drivers/iio/industrialio-core.c
> +++ b/drivers/iio/industrialio-core.c
> @@ -470,6 +470,7 @@ ssize_t iio_format_value(char *buf, unsigned int type, int size, int *vals)
>  		return 0;
>  	}
>  }
> +EXPORT_SYMBOL_GPL(iio_format_value);
>  
>  static ssize_t iio_read_channel_info(struct device *dev,
>  				     struct device_attribute *attr,
> diff --git a/include/linux/iio/iio.h b/include/linux/iio/iio.h
> index 19c94c9..b589411 100644
> --- a/include/linux/iio/iio.h
> +++ b/include/linux/iio/iio.h
> @@ -636,6 +636,8 @@ static inline struct dentry *iio_get_debugfs_dentry(struct iio_dev *indio_dev)
>  }
>  #endif
>  
> +ssize_t iio_format_value(char *buf, unsigned int type, int size, int *vals);
> +
>  int iio_str_to_fixpoint(const char *str, int fract_mult, int *integer,
>  	int *fract);
>  
> 
