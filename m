From: "Ivan T. Ivanov" <iivanov-NEYub+7Iv8PQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 01/11] coresight-etm4x: Adding CoreSight ETM4x driver
Date: Fri, 24 Apr 2015 18:05:23 +0300
Message-ID: <1429887923.5211.6.camel@mm-sol.com>
References: <1429742451-11465-1-git-send-email-mathieu.poirier@linaro.org>
	 <1429742451-11465-2-git-send-email-mathieu.poirier@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1429742451-11465-2-git-send-email-mathieu.poirier-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mathieu Poirier <mathieu.poirier-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kaixu.xia-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, zhang.chunyan-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org
List-Id: linux-api@vger.kernel.org


On Wed, 2015-04-22 at 16:40 -0600, Mathieu Poirier wrote:
> From: Pratik Patel <pratikp-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
> 
> This driver manages the CoreSight ETMv4 (Embedded Trace Macrocell) IP block
> to support HW assisted tracing on ARMv7 and ARMv8 architectures.
> 
> Signed-off-by: Pratik Patel <pratikp-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
> Signed-off-by: Kaixu Xia <xiakaixu-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
> Signed-off-by: Mathieu Poirier poirier-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>

<snip>

> 

> +       pm_runtime_put(&adev->dev);
> +
> +       desc->type = CORESIGHT_DEV_TYPE_SOURCE;
> +       desc->subtype.source_subtype = CORESIGHT_DEV_SUBTYPE_SOURCE_PROC;
> +       desc->ops = &etm4_cs_ops;
> +       desc->pdata = pdata;
> +       desc->dev = dev;
> +       desc->groups = coresight_etmv4_groups;
> +       drvdata->csdev = coresight_register(desc);
> +       if (IS_ERR(drvdata->csdev)) {
> +               ret = PTR_ERR(drvdata->csdev);
> +               goto err_arch_supported;

double runtime put.

> +       }
> +
> +       dev_info(dev, "%s initialized\n", (char *)id->data);
> +
> +       if (boot_enable) {
> +               coresight_enable(drvdata->csdev);
> +               drvdata->boot_enable = true;
> +       }
> +
> +       return 0;
> +
> +err_arch_supported:
> +       pm_runtime_put(&adev->dev);
> +       if (--etm4_count == 0)
> +               unregister_hotcpu_notifier(&etm4_cpu_notifier);
> +       return ret;
> +}

Regards,
Ivan
