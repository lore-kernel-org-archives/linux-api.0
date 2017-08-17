From: Moritz Fischer <moritz.fischer@ettus.com>
Subject: Re: [PATCH v2 20/22] fpga: intel: afu add FPGA_GET_API_VERSION/CHECK_EXTENSION
 ioctls support
Date: Thu, 17 Aug 2017 12:12:00 -0700
Message-ID: <CAAtXAHdyCNBRHdk-9L+AOT7g7BEsxBN-EkdhxO2-aSqdDovTHg@mail.gmail.com>
References: <1498441938-14046-1-git-send-email-hao.wu@intel.com> <1498441938-14046-21-git-send-email-hao.wu@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1498441938-14046-21-git-send-email-hao.wu@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Wu Hao <hao.wu@intel.com>
Cc: Alan Tull <atull@kernel.org>, linux-fpga@vger.kernel.org, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-api@vger.kernel.org, "Kang, Luwei" <luwei.kang@intel.com>, "Zhang, Yi Z" <yi.z.zhang@intel.com>, Tim Whisonant <tim.whisonant@intel.com>, Enno Luebbers <enno.luebbers@intel.com>, Shiva Rao <shiva.rao@intel.com>, Christopher Rauer <christopher.rauer@intel.com>, Xiao Guangrong <guangrong.xiao@linux.intel.com>
List-Id: linux-api@vger.kernel.org

Hi,

On Sun, Jun 25, 2017 at 6:52 PM, Wu Hao <hao.wu@intel.com> wrote:
> FPGA_GET_API_VERSION and FPGA_CHECK_EXTENSION ioctls are common ones which
> need to be supported by all feature devices drivers including FME and AFU.
> This patch implements above 2 ioctls in Intel FPGA Accelerated Function
> Unit (AFU) driver.
>
> Signed-off-by: Tim Whisonant <tim.whisonant@intel.com>
> Signed-off-by: Enno Luebbers <enno.luebbers@intel.com>
> Signed-off-by: Shiva Rao <shiva.rao@intel.com>
> Signed-off-by: Christopher Rauer <christopher.rauer@intel.com>
> Signed-off-by: Xiao Guangrong <guangrong.xiao@linux.intel.com>
> Signed-off-by: Wu Hao <hao.wu@intel.com>
> ---
> v2: rebased
> ---
>  drivers/fpga/intel-afu-main.c | 11 +++++++++++
>  1 file changed, 11 insertions(+)
>
> diff --git a/drivers/fpga/intel-afu-main.c b/drivers/fpga/intel-afu-main.c
> index 2a17cde..22f77f2 100644
> --- a/drivers/fpga/intel-afu-main.c
> +++ b/drivers/fpga/intel-afu-main.c
> @@ -122,6 +122,13 @@ static int afu_release(struct inode *inode, struct file *filp)
>         return 0;
>  }
>
> +static long afu_ioctl_check_extension(struct feature_platform_data *pdata,
> +                                    unsigned long arg)
> +{
> +       /* No extension support for now */

Do you maybe make that an -ENOTSUPP or -EINVAL then?
> +       return 0;
> +}
> +
>  static long afu_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
>  {
>         struct platform_device *pdev = filp->private_data;
> @@ -132,6 +139,10 @@ static long afu_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
>         dev_dbg(&pdev->dev, "%s cmd 0x%x\n", __func__, cmd);
>
>         switch (cmd) {
> +       case FPGA_GET_API_VERSION:
> +               return FPGA_API_VERSION;
> +       case FPGA_CHECK_EXTENSION:
> +               return afu_ioctl_check_extension(pdata, arg);
>         default:
>                 /*
>                  * Let sub-feature's ioctl function to handle the cmd
> --
> 1.8.3.1
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-fpga" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Thanks,

Moritz
