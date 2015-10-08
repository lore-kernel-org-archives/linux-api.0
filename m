From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH v3] scsi: ufs: add ioctl interface for query request
Date: Thu, 08 Oct 2015 16:03:08 +0200
Message-ID: <5970981.84uI3QIcdF@wuerfel>
References: <1444302569-30740-1-git-send-email-ygardi@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-arm-msm-owner@vger.kernel.org>
In-Reply-To: <1444302569-30740-1-git-send-email-ygardi@codeaurora.org>
Sender: linux-arm-msm-owner@vger.kernel.org
To: Yaniv Gardi <ygardi@codeaurora.org>
Cc: James.Bottomley@hansenpartnership.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-arm-msm@vger.kernel.org, santoshsy@gmail.com, linux-scsi-owner@vger.kernel.org, subhashj@codeaurora.org, gbroner@codeaurora.org, draviv@codeaurora.org, Noa Rubens <noag@codeaurora.org>, Raviv Shvili <rshvili@codeaurora.org>, Vinayak Holikatti <vinholikatti@gmail.com>, "James E.J. Bottomley" <JBottomley@odin.com>, "open list:ABI/API" <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Thursday 08 October 2015 14:09:24 Yaniv Gardi wrote:
> This patch exposes the ioctl interface for UFS driver via SCSI device
> ioctl interface. As of now UFS driver would provide the ioctl for query
> interface to connected UFS device.
> 
> Signed-off-by: Dolev Raviv <draviv@codeaurora.org>
> Signed-off-by: Noa Rubens <noag@codeaurora.org>
> Signed-off-by: Raviv Shvili <rshvili@codeaurora.org>
> Signed-off-by: Gilad Broner <gbroner@codeaurora.org>
> Signed-off-by: Yaniv Gardi <ygardi@codeaurora.org>

Thanks for the changes, looks much better already


> @@ -5106,6 +5308,10 @@ static struct scsi_host_template ufshcd_driver_template = {
>  	.eh_device_reset_handler = ufshcd_eh_device_reset_handler,
>  	.eh_host_reset_handler   = ufshcd_eh_host_reset_handler,
>  	.eh_timed_out		= ufshcd_eh_timed_out,
> +	.ioctl			= ufshcd_ioctl,
> +#ifdef CONFIG_COMPAT
> +	.compat_ioctl		= ufshcd_ioctl,
> +#endif
>  	.this_id		= -1,
>  	.sg_tablesize		= SG_ALL,
>  	.cmd_per_lun		= UFSHCD_CMD_PER_LUN,

no need for the #ifdef here.

> diff --git a/include/scsi/scsi.h b/include/scsi/scsi.h
> index e0a3398..fada160 100644
> --- a/include/scsi/scsi.h
> +++ b/include/scsi/scsi.h
> @@ -284,6 +284,7 @@ static inline int scsi_is_wlun(u64 lun)
>   * Here are some scsi specific ioctl commands which are sometimes useful.
>   *
>   * Note that include/linux/cdrom.h also defines IOCTL 0x5300 - 0x5395
> + * include/uapi/scsi/ufs/ioctl.h defines 0x5388
>   */
>  

The comment is now wrong.


Hmm, the buffer now is not aligned to four bytes, which will make copying it
a bit slower. If that can be a concern, adding a padding byte would help.

	Arnd
