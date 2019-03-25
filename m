From: Alan Tull <atull@kernel.org>
Subject: Re: [PATCH 02/17] fpga: dfl: fme: align PR buffer size per PR datawidth
Date: Mon, 25 Mar 2019 12:50:40 -0500
Message-ID: <CANk1AXSUMkfQu8QnN-T0B5qeA4vaGxDTvGur9EGyLbGsBFBeKQ@mail.gmail.com>
References: <1553483264-5379-1-git-send-email-hao.wu@intel.com> <1553483264-5379-3-git-send-email-hao.wu@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1553483264-5379-3-git-send-email-hao.wu@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Wu Hao <hao.wu@intel.com>
Cc: Moritz Fischer <mdf@kernel.org>, linux-fpga@vger.kernel.org, linux-kernel <linux-kernel@vger.kernel.org>, linux-api@vger.kernel.org, Xu Yilun <yilun.xu@intel.com>
List-Id: linux-api@vger.kernel.org

On Sun, Mar 24, 2019 at 10:23 PM Wu Hao <hao.wu@intel.com> wrote:

Hi Hao,

Looks good, one question below.

>
> Current driver checks if input bitstream file size is aligned or
> not per PR data width (default 32bits). It requires one additional
> step for end user when they generate the bitstream file, padding
> extra zeros to bitstream file to align its size per PR data width,
> but they don't have to as hardware will drop extra padding bytes
> automatically.
>
> In order to simplify the user steps, this patch aligns PR buffer
> size per PR data width in driver, to allow user to pass unaligned
> size bitstream files to driver.
>
> Signed-off-by: Xu Yilun <yilun.xu@intel.com>
> Signed-off-by: Wu Hao <hao.wu@intel.com>
> ---
>  drivers/fpga/dfl-fme-pr.c | 14 +++++++++-----
>  1 file changed, 9 insertions(+), 5 deletions(-)
>
> diff --git a/drivers/fpga/dfl-fme-pr.c b/drivers/fpga/dfl-fme-pr.c
> index d9ca955..c1fb1fe 100644
> --- a/drivers/fpga/dfl-fme-pr.c
> +++ b/drivers/fpga/dfl-fme-pr.c
> @@ -74,6 +74,7 @@ static int fme_pr(struct platform_device *pdev, unsigned long arg)
>         struct dfl_fme *fme;
>         unsigned long minsz;
>         void *buf = NULL;
> +       size_t length;
>         int ret = 0;
>         u64 v;
>
> @@ -85,9 +86,6 @@ static int fme_pr(struct platform_device *pdev, unsigned long arg)
>         if (port_pr.argsz < minsz || port_pr.flags)
>                 return -EINVAL;
>
> -       if (!IS_ALIGNED(port_pr.buffer_size, 4))
> -               return -EINVAL;
> -
>         /* get fme header region */
>         fme_hdr = dfl_get_feature_ioaddr_by_id(&pdev->dev,
>                                                FME_FEATURE_ID_HEADER);
> @@ -103,7 +101,13 @@ static int fme_pr(struct platform_device *pdev, unsigned long arg)
>                        port_pr.buffer_size))
>                 return -EFAULT;
>
> -       buf = vmalloc(port_pr.buffer_size);
> +       /*
> +        * align PR buffer per PR bandwidth, as HW ignores the extra padding
> +        * data automatically.
> +        */
> +       length = ALIGN(port_pr.buffer_size, 4);
> +
> +       buf = vmalloc(length);

Since it may not be completely filled, would it be worthwhile to alloc
a zero'ed buff?

Alan

>         if (!buf)
>                 return -ENOMEM;
>
> @@ -140,7 +144,7 @@ static int fme_pr(struct platform_device *pdev, unsigned long arg)
>         fpga_image_info_free(region->info);
>
>         info->buf = buf;
> -       info->count = port_pr.buffer_size;
> +       info->count = length;
>         info->region_id = port_pr.port_id;
>         region->info = info;
>
> --
> 2.7.4
>
