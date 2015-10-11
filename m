From: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
Subject: Re: [PATCH v4] scsi: ufs: add ioctl interface for query request
Date: Sun, 11 Oct 2015 21:13:17 +0200
Message-ID: <5532251.sHP7i3bdrH@wuerfel>
References: <1444562547-3100-1-git-send-email-ygardi@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1444562547-3100-1-git-send-email-ygardi-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yaniv Gardi <ygardi-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
Cc: James.Bottomley-JuX6DAaQMKPCXq6kfMZ53/egYHeGw8Jk@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-arm-msm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, santoshsy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-scsi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, subhashj-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org, gbroner-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org, draviv-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org, Noa Rubens <noag-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, Raviv Shvili <rshvili-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, Vinayak Holikatti <vinholikatti-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "James E.J. Bottomley" <JBottomley-wo1vFcy6AUs@public.gmane.org>, "open list:ABI/API" <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Sunday 11 October 2015 14:22:12 Yaniv Gardi wrote:
>   * @cookie: cookie data
> @@ -5106,6 +5308,10 @@ static struct scsi_host_template ufshcd_driver_template = {
>         .eh_device_reset_handler = ufshcd_eh_device_reset_handler,
>         .eh_host_reset_handler   = ufshcd_eh_host_reset_handler,
>         .eh_timed_out           = ufshcd_eh_timed_out,
> +       .ioctl                  = ufshcd_ioctl,
> +#ifdef CONFIG_COMPAT
> +       .compat_ioctl           = ufshcd_ioctl,
> +#endif
>         .this_id                = -1,
>         .sg_tablesize           = SG_ALL,
>         .cmd_per_lun            = UFSHCD_CMD_PER_LUN,
> 

I think I commented before that the #ifdef here is not needed and should
just be removed. Otherwise it looks ok to me now.

	Arnd
