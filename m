From: "Ivan T. Ivanov" <iivanov-NEYub+7Iv8PQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v3 01/11] coresight-etm4x: Adding CoreSight ETM4x driver
Date: Fri, 08 May 2015 11:27:29 +0300
Message-ID: <1431073649.21307.12.camel@mm-sol.com>
References: <1430926047-9125-1-git-send-email-mathieu.poirier@linaro.org>
	 <1430926047-9125-2-git-send-email-mathieu.poirier@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1430926047-9125-2-git-send-email-mathieu.poirier-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mathieu Poirier <mathieu.poirier-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kaixu.xia-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, zhang.chunyan-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org
List-Id: linux-api@vger.kernel.org


Hi Mathieu, 

On Wed, 2015-05-06 at 09:27 -0600, Mathieu Poirier wrote:
> 
> +static struct amba_id etm4_ids[] = {
> +       {       /* ETM 4.0 - Juno board */
> +               .id     = 0x000bb95e,
> +               .mask   = 0x000fffff,
> +               .data   = "ETM 4.0",
> +       },
> +       { 0, 0},
> +};
> +
> 

Any particular reason to remove device ID for the 
Hi6220 board? It happens to be the same ID used in
Qualcomm 8x16 ETM components. 

Regards,
Ivan
