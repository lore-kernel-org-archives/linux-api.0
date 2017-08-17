From: Alan Tull <atull@kernel.org>
Subject: Re: [PATCH v2 09/22] fpga: intel: pcie: adds fpga_for_each_port
 callback for fme device
Date: Thu, 17 Aug 2017 16:31:56 -0500
Message-ID: <CANk1AXRQfGViXn+vEErmN6N8LtOsX7Arh-VPPbDjKiEyGGvV-A@mail.gmail.com>
References: <1498441938-14046-1-git-send-email-hao.wu@intel.com> <1498441938-14046-10-git-send-email-hao.wu@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1498441938-14046-10-git-send-email-hao.wu@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Wu Hao <hao.wu@intel.com>
Cc: Moritz Fischer <mdf@kernel.org>, linux-fpga@vger.kernel.org, linux-kernel <linux-kernel@vger.kernel.org>, linux-api@vger.kernel.org, "Kang, Luwei" <luwei.kang@intel.com>, "Zhang, Yi Z" <yi.z.zhang@intel.com>, Tim Whisonant <tim.whisonant@intel.com>, Enno Luebbers <enno.luebbers@intel.com>, Shiva Rao <shiva.rao@intel.com>, Christopher Rauer <christopher.rauer@intel.com>, Xiao Guangrong <guangrong.xiao@linux.intel.com>
List-Id: linux-api@vger.kernel.org

On Sun, Jun 25, 2017 at 8:52 PM, Wu Hao <hao.wu@intel.com> wrote:

Hi Hao,

> For FPGA Management Engine (FME), it requires fpga_for_each_port callback
> for actions on ports, so export this function from PCIe driver by adding
> the callback to the platform data.
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
>  drivers/fpga/intel-feature-dev.h |  9 +++++++++
>  drivers/fpga/intel-pcie.c        | 24 ++++++++++++++++++++++++
>  2 files changed, 33 insertions(+)
>
> diff --git a/drivers/fpga/intel-feature-dev.h b/drivers/fpga/intel-feature-dev.h
> index d64a51e..06b3fb6 100644
> --- a/drivers/fpga/intel-feature-dev.h
> +++ b/drivers/fpga/intel-feature-dev.h
> @@ -235,6 +235,9 @@ struct feature_platform_data {
>         struct platform_device *dev;
>         unsigned int disable_count;     /* count for port disable */
>
> +       struct platform_device *(*fpga_for_each_port)(struct platform_device *,
> +                       void *, int (*match)(struct platform_device *, void *));
> +
>         int num;                        /* number of features */
>         struct feature features[0];
>  };
> @@ -354,4 +357,10 @@ static inline int fpga_port_reset(struct platform_device *pdev)
>
>         return pdata->features[index].ioaddr;
>  }
> +
> +static inline struct device *
> +fpga_feature_dev_to_pcidev(struct platform_device *dev)
> +{
> +       return dev->dev.parent->parent;
> +}
>  #endif
> diff --git a/drivers/fpga/intel-pcie.c b/drivers/fpga/intel-pcie.c
> index 54c0e3a..86ea5c7 100644
> --- a/drivers/fpga/intel-pcie.c
> +++ b/drivers/fpga/intel-pcie.c
> @@ -209,6 +209,27 @@ static int parse_switch_to(struct build_feature_devs_info *binfo, int bar)
>         return parse_start_from(binfo, bar);
>  }
>
> +static struct platform_device *fpga_for_each_port(struct platform_device *pdev,

Regarding the name of this function, isn't this more of a 'find'
function like class_find_device() than a 'for_each' function?

Also please document that the caller will need to put_device().

Thanks,
Alan

> +                    void *data, int (*match)(struct platform_device *, void *))
> +{
> +       struct device *pci_dev = fpga_feature_dev_to_pcidev(pdev);
> +       struct cci_drvdata *drvdata = dev_get_drvdata(pci_dev);
> +       struct feature_platform_data *pdata;
> +       struct platform_device *port_dev;
> +
> +       mutex_lock(&drvdata->lock);
> +       list_for_each_entry(pdata, &drvdata->port_dev_list, node) {
> +               port_dev = pdata->dev;
> +
> +               if (match(port_dev, data) && get_device(&port_dev->dev))
> +                       goto exit;
> +       }
> +       port_dev = NULL;
> +exit:
> +       mutex_unlock(&drvdata->lock);
> +       return port_dev;
> +}
> +
>  static struct build_feature_devs_info *
>  build_info_alloc_and_init(struct pci_dev *pdev)
>  {
> @@ -310,6 +331,9 @@ static int build_info_commit_dev(struct build_feature_devs_info *binfo)
>         if (!pdata)
>                 return -ENOMEM;
>
> +       if (type == FME_ID)
> +               pdata->fpga_for_each_port = fpga_for_each_port;
> +
>         /*
>          * the count should be initialized to 0 to make sure
>          *__fpga_port_enable() following __fpga_port_disable()
> --
> 1.8.3.1
>
