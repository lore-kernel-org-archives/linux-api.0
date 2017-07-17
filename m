From: Alan Tull <atull@kernel.org>
Subject: Re: [PATCH v2 12/22] fpga: intel: fme: add header sub feature support
Date: Mon, 17 Jul 2017 13:53:30 -0500
Message-ID: <CANk1AXRD8eUSmcdJ9ZXpGDE=HVvxgFJyCMKSfGpJeD6a4TgCmg@mail.gmail.com>
References: <1498441938-14046-1-git-send-email-hao.wu@intel.com> <1498441938-14046-13-git-send-email-hao.wu@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1498441938-14046-13-git-send-email-hao.wu@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Wu Hao <hao.wu@intel.com>
Cc: Moritz Fischer <mdf@kernel.org>, linux-fpga@vger.kernel.org, linux-kernel <linux-kernel@vger.kernel.org>, linux-api@vger.kernel.org, "Kang, Luwei" <luwei.kang@intel.com>, "Zhang, Yi Z" <yi.z.zhang@intel.com>, Tim Whisonant <tim.whisonant@intel.com>, Enno Luebbers <enno.luebbers@intel.com>, Shiva Rao <shiva.rao@intel.com>, Christopher Rauer <christopher.rauer@intel.com>, Xiao Guangrong <guangrong.xiao@linux.intel.com>
List-Id: linux-api@vger.kernel.org

On Sun, Jun 25, 2017 at 8:52 PM, Wu Hao <hao.wu@intel.com> wrote:

Hi Hao,

I'm making my way through this (very large) patchset.  Some minor
comments below.

> From: Kang Luwei <luwei.kang@intel.com>
>
> The header register set is always present for FPGA Management Engine (FME),
> this patch implements init and uinit function for header sub feature and
> introduce several read-only sysfs interfaces for the capability and status.
>
> Sysfs interfaces:
> * /sys/class/fpga/<fpga.x>/<intel-fpga-fme.x>/ports_num
>   Read-only. Number of ports implemented
>
> * /sys/class/fpga/<fpga.x>/<intel-fpga-fme.x>/bitstream_id
>   Read-only. Blue Bitstream identifier number

Blue and Green bitstreams are an Intel implementation terminology.  I
see that you've defined them in drivers/fpga, but it will be helpful
to add in "static region" and "partial reconfiguration region" added
in any API documentation files that use the green/blue terminology to
keep it accessible.

>
> * /sys/class/fpga/<fpga.x>/<intel-fpga-fme.x>/bitstream_metadata
>   Read-only. Blue Bitstream meta data
>
> Signed-off-by: Tim Whisonant <tim.whisonant@intel.com>
> Signed-off-by: Enno Luebbers <enno.luebbers@intel.com>
> Signed-off-by: Shiva Rao <shiva.rao@intel.com>
> Signed-off-by: Christopher Rauer <christopher.rauer@intel.com>
> Signed-off-by: Kang Luwei <luwei.kang@intel.com>
> Signed-off-by: Xiao Guangrong <guangrong.xiao@linux.intel.com>
> Signed-off-by: Wu Hao <hao.wu@intel.com>
> ---
> v2: add sysfs documentation
> ---
>  .../ABI/testing/sysfs-platform-intel-fpga-fme      | 19 ++++++++
>  drivers/fpga/intel-feature-dev.h                   |  3 ++
>  drivers/fpga/intel-fme-main.c                      | 55 ++++++++++++++++++++++
>  3 files changed, 77 insertions(+)
>  create mode 100644 Documentation/ABI/testing/sysfs-platform-intel-fpga-fme
>
> diff --git a/Documentation/ABI/testing/sysfs-platform-intel-fpga-fme b/Documentation/ABI/testing/sysfs-platform-intel-fpga-fme
> new file mode 100644
> index 0000000..783cfa9
> --- /dev/null
> +++ b/Documentation/ABI/testing/sysfs-platform-intel-fpga-fme
> @@ -0,0 +1,19 @@
> +What:          /sys/bus/platform/devices/intel-fpga-fme.0/ports_num
> +Date:          June 2017
> +KernelVersion:  4.12
> +Contact:       Wu Hao <hao.wu@intel.com>
> +Description:   Read-only. One Intel FPGA device may have more than 1
> +               port/Accelerator Function Unit (AFU). It returns the
> +               number of ports on the FPGA device when read it.
> +
> +What:          /sys/bus/platform/devices/intel-fpga-fme.0/bitstream_id
> +Date:          June 2017
> +KernelVersion:  4.12
> +Contact:       Wu Hao <hao.wu@intel.com>
> +Description:   Read-only. It returns Blue Bitstream identifier number.

Here

> +
> +What:          /sys/bus/platform/devices/intel-fpga-fme.0/bitstream_meta
> +Date:          June 2017
> +KernelVersion:  4.12
> +Contact:       Wu Hao <hao.wu@intel.com>
> +Description:   Read-only. It returns Blue Bitstream meta data.

And here

> diff --git a/drivers/fpga/intel-feature-dev.h b/drivers/fpga/intel-feature-dev.h
> index 635b857..3f97b75 100644
> --- a/drivers/fpga/intel-feature-dev.h
> +++ b/drivers/fpga/intel-feature-dev.h
> @@ -138,6 +138,9 @@ struct feature_fme_header {
>         u64 rsvd[2];
>         struct feature_fme_capability capability;
>         struct feature_fme_port port[MAX_FPGA_PORT_NUM];
> +       u64 rsvd1;
> +       u64 bitstream_id;
> +       u64 bitstream_md;
>  };
>
>  /* FME Thermal Sub Feature Register Set */
> diff --git a/drivers/fpga/intel-fme-main.c b/drivers/fpga/intel-fme-main.c
> index c16cf81..dfbb17c 100644
> --- a/drivers/fpga/intel-fme-main.c
> +++ b/drivers/fpga/intel-fme-main.c
> @@ -21,15 +21,70 @@
>
>  #include "intel-feature-dev.h"
>
> +static ssize_t ports_num_show(struct device *dev,
> +                             struct device_attribute *attr, char *buf)
> +{
> +       struct feature_fme_header *fme_hdr
> +               = get_feature_ioaddr_by_index(dev, FME_FEATURE_ID_HEADER);
> +       struct feature_fme_capability fme_capability;
> +
> +       fme_capability.csr = readq(&fme_hdr->capability);
> +
> +       return scnprintf(buf, PAGE_SIZE, "%d\n", fme_capability.num_ports);
> +}
> +static DEVICE_ATTR_RO(ports_num);
> +
> +static ssize_t bitstream_id_show(struct device *dev,
> +                                struct device_attribute *attr, char *buf)
> +{
> +       struct feature_fme_header *fme_hdr
> +               = get_feature_ioaddr_by_index(dev, FME_FEATURE_ID_HEADER);
> +       u64 bitstream_id = readq(&fme_hdr->bitstream_id);
> +
> +       return scnprintf(buf, PAGE_SIZE, "0x%llx\n",
> +                               (unsigned long long)bitstream_id);
> +}
> +static DEVICE_ATTR_RO(bitstream_id);
> +
> +static ssize_t bitstream_metadata_show(struct device *dev,
> +                                      struct device_attribute *attr, char *buf)
> +{
> +       struct feature_fme_header *fme_hdr
> +               = get_feature_ioaddr_by_index(dev, FME_FEATURE_ID_HEADER);
> +       u64 bitstream_md = readq(&fme_hdr->bitstream_md);
> +
> +       return scnprintf(buf, PAGE_SIZE, "0x%llx\n",
> +                               (unsigned long long)bitstream_md);
> +}
> +static DEVICE_ATTR_RO(bitstream_metadata);
> +
> +static const struct attribute *fme_hdr_attrs[] = {
> +       &dev_attr_ports_num.attr,
> +       &dev_attr_bitstream_id.attr,
> +       &dev_attr_bitstream_metadata.attr,
> +       NULL,
> +};
> +
>  static int fme_hdr_init(struct platform_device *pdev, struct feature *feature)
>  {
> +       struct feature_fme_header *fme_hdr = feature->ioaddr;
> +       int ret;
> +
>         dev_dbg(&pdev->dev, "FME HDR Init.\n");
> +       dev_dbg(&pdev->dev, "FME cap %llx.\n",
> +                               (unsigned long long)fme_hdr->capability.csr);
> +
> +       ret = sysfs_create_files(&pdev->dev.kobj, fme_hdr_attrs);
> +       if (ret)
> +               return ret;
> +
>         return 0;
>  }
>
>  static void fme_hdr_uinit(struct platform_device *pdev, struct feature *feature)
>  {
>         dev_dbg(&pdev->dev, "FME HDR UInit.\n");
> +       sysfs_remove_files(&pdev->dev.kobj, fme_hdr_attrs);
>  }
>
>  struct feature_ops fme_hdr_ops = {
> --
> 1.8.3.1
>
