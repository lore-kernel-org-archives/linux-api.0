From: Paul Bolle <pebolle-IWqWACnzNjzz+pZb47iToQ@public.gmane.org>
Subject: Re: [PATCH] coresight-stm: adding driver for CoreSight STM component
Date: Thu, 05 Feb 2015 10:26:02 +0100
Message-ID: <1423128362.27378.12.camel@x220>
References: <1423088550-15780-1-git-send-email-mathieu.poirier@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1423088550-15780-1-git-send-email-mathieu.poirier-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: mathieu.poirier-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org
Cc: corbet-T1hC0tSOHrs@public.gmane.org, pratikp-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org, al.grant-5wv7dgnIgG8@public.gmane.org, liviu.dudau-5wv7dgnIgG8@public.gmane.org, kaixu.xia-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, jeenu.viswambharan-5wv7dgnIgG8@public.gmane.org, gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Wed, 2015-02-04 at 15:22 -0700, mathieu.poirier-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org wrote:
> From: Pratik Patel <pratikp-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
> 
> This driver adds support for the STM CoreSight IP block,
> allowing any system compoment (HW or SW) to log and
> aggregate messages via a single entity.
> 
> The STM exposes an application defined number of channels
> called stimulus port.  Configuration is done using entries
> in sysfs and channels made available to userspace via devfs.
> 
> Signed-off-by: Pratik Patel <pratikp-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
> Signed-off-by: Mathieu Poirier <mathieu.poirier-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
>[...]
> +/**
> + * struct stm_node - aggregation of channel information for userspace access
> + * @channel_id:		the channel number associated to this file descriptor.
> + * @options:		options for this channel - none, timestamped,
> +i			guaranteed.

Did you perhaps use vim?

> + * @drvdata:		STM driver specifics.
> + */
> +struct stm_node {
> +	int			channel_id;
> +	u32			options;
> +	struct stm_drvdata	*drvdata;
> +};


Paul Bolle
