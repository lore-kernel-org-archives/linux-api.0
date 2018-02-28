From: Alan Tull <atull@kernel.org>
Subject: Re: [PATCH v4 15/24] fpga: dfl-fme-pr: add compat_id support for
 dfl-fme-region platform device.
Date: Wed, 28 Feb 2018 17:06:57 -0600
Message-ID: <CANk1AXR9473+QqjF=R2JqqJGPB_XH9k+2qDhh68hN=5Fq4E7uw@mail.gmail.com>
References: <1518513893-4719-1-git-send-email-hao.wu@intel.com> <1518513893-4719-16-git-send-email-hao.wu@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1518513893-4719-16-git-send-email-hao.wu@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Wu Hao <hao.wu@intel.com>
Cc: Moritz Fischer <mdf@kernel.org>, linux-fpga@vger.kernel.org, linux-kernel <linux-kernel@vger.kernel.org>, linux-api@vger.kernel.org, "Kang, Luwei" <luwei.kang@intel.com>, "Zhang, Yi Z" <yi.z.zhang@intel.com>
List-Id: linux-api@vger.kernel.org

On Tue, Feb 13, 2018 at 3:24 AM, Wu Hao <hao.wu@intel.com> wrote:

Hi Hao,

> This patch adds compat_id support when driver creates the platform
> device for dfl-fme-region. It allows dfl-fme-region platform driver
> to create fpga-region with correct compat_id.
>
> Signed-off-by: Wu Hao <hao.wu@intel.com>
> ---
>  drivers/fpga/dfl-fme-pr.c | 20 ++++++++++++++++++++
>  drivers/fpga/dfl-fme-pr.h |  3 +++
>  2 files changed, 23 insertions(+)
>
> diff --git a/drivers/fpga/dfl-fme-pr.c b/drivers/fpga/dfl-fme-pr.c
> index 526e90b..c17170b 100644
> --- a/drivers/fpga/dfl-fme-pr.c
> +++ b/drivers/fpga/dfl-fme-pr.c
> @@ -314,6 +314,25 @@ static void fpga_fme_destroy_bridges(struct feature_platform_data *pdata)
>  }
>
>  /**
> + * fpga_fme_get_region_compat_id - read region compat_id from hardware
> + *
> + * @dev: fme device.
> + */
> +static struct fpga_region_compat_id
> +fpga_fme_get_region_compat_id(struct device *dev)
> +{
> +       struct fpga_region_compat_id compat_id;
> +       void __iomem *fme_pr;
> +
> +       fme_pr = get_feature_ioaddr_by_id(dev, FME_FEATURE_ID_PR_MGMT);
> +
> +       compat_id.id_l = readq(fme_pr + FME_PR_INTFC_ID_L);
> +       compat_id.id_h = readq(fme_pr + FME_PR_INTFC_ID_H);

I tried building for 32 bit ARM and ran into readq and writeq not
being defined.  v2 had proper '#indef readq/writeq', so looks like we
need that after all.

Alan
