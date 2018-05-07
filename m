From: Alan Tull <atull@kernel.org>
Subject: Re: [PATCH v5 22/28] fpga: dfl: fme-region: add support for compat_id
Date: Mon, 7 May 2018 16:12:53 -0500
Message-ID: <CANk1AXRzjFibdiO=kxDNOkUyrwQ9ASo1h=aHdMRNMXuGd7iW3g@mail.gmail.com>
References: <1525229431-3087-1-git-send-email-hao.wu@intel.com> <1525229431-3087-23-git-send-email-hao.wu@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1525229431-3087-23-git-send-email-hao.wu@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Wu Hao <hao.wu@intel.com>
Cc: Moritz Fischer <mdf@kernel.org>, linux-fpga@vger.kernel.org, linux-kernel <linux-kernel@vger.kernel.org>, linux-api@vger.kernel.org, "Kang, Luwei" <luwei.kang@intel.com>, "Zhang, Yi Z" <yi.z.zhang@intel.com>
List-Id: linux-api@vger.kernel.org

On Tue, May 1, 2018 at 9:50 PM, Wu Hao <hao.wu@intel.com> wrote:

Hi Hao,

> This patch adds compat_id support, it reuses fme manager's
> compat id, as the per region compat id is actually from the
> fme manager's register.
>
> Signed-off-by: Wu Hao <hao.wu@intel.com>
Acked-by: Alan Tull <atull@kernel.org>

> ---
> v5: reuse fme manager's compat_id as per region compat_id
> ---
>  drivers/fpga/dfl-fme-region.c | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/drivers/fpga/dfl-fme-region.c b/drivers/fpga/dfl-fme-region.c
> index 696b313..b82a381 100644
> --- a/drivers/fpga/dfl-fme-region.c
> +++ b/drivers/fpga/dfl-fme-region.c
> @@ -45,6 +45,7 @@ static int fme_region_probe(struct platform_device *pdev)
>         }
>
>         region->priv = pdata;
> +       region->compat_id = mgr->compat_id;
>         platform_set_drvdata(pdev, region);
>
>         ret = fpga_region_register(region);
> --
> 1.8.3.1
>
