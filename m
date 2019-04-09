From: Alan Tull <atull@kernel.org>
Subject: Re: [PATCH 13/17] fpga: dfl: fme: add capability sysfs interfaces
Date: Tue, 9 Apr 2019 16:05:09 -0500
Message-ID: <CANk1AXQvsUYHmyZ7XF2LD+eNQ2FV33HageL0Mgbt7-9YVaagdw@mail.gmail.com>
References: <1553483264-5379-1-git-send-email-hao.wu@intel.com> <1553483264-5379-14-git-send-email-hao.wu@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1553483264-5379-14-git-send-email-hao.wu@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Wu Hao <hao.wu@intel.com>
Cc: Moritz Fischer <mdf@kernel.org>, linux-fpga@vger.kernel.org, linux-kernel <linux-kernel@vger.kernel.org>, linux-api@vger.kernel.org, Luwei Kang <luwei.kang@intel.com>, Xu Yilun <yilun.xu@intel.com>
List-Id: linux-api@vger.kernel.org

On Sun, Mar 24, 2019 at 10:24 PM Wu Hao <hao.wu@intel.com> wrote:

Hi Hao,

Looks good...

>
> This patch adds 3 read-only sysfs interfaces for FPGA Management Engine
> (FME) block for capabilities including cache_size, fabric_version and
> socket_id.
>
> Signed-off-by: Luwei Kang <luwei.kang@intel.com>
> Signed-off-by: Xu Yilun <yilun.xu@intel.com>
> Signed-off-by: Wu Hao <hao.wu@intel.com>

Acked-by: Alan Tull <atull@kernel.org>

Thanks,
Alan

> ---
>  Documentation/ABI/testing/sysfs-platform-dfl-fme | 23 ++++++++++++
>  drivers/fpga/dfl-fme-main.c                      | 48 ++++++++++++++++++++++++
>  2 files changed, 71 insertions(+)
>
> diff --git a/Documentation/ABI/testing/sysfs-platform-dfl-fme b/Documentation/ABI/testing/sysfs-platform-dfl-fme
> index 8fa4feb..b8327e9 100644
> --- a/Documentation/ABI/testing/sysfs-platform-dfl-fme
> +++ b/Documentation/ABI/testing/sysfs-platform-dfl-fme
> @@ -21,3 +21,26 @@ Contact:     Wu Hao <hao.wu@intel.com>
>  Description:   Read-only. It returns Bitstream (static FPGA region) meta
>                 data, which includes the synthesis date, seed and other
>                 information of this static FPGA region.
> +
> +What:          /sys/bus/platform/devices/dfl-fme.0/cache_size
> +Date:          March 2019
> +KernelVersion:  5.2
> +Contact:       Wu Hao <hao.wu@intel.com>
> +Description:   Read-only. It returns cache size of this FPGA device.
> +
> +What:          /sys/bus/platform/devices/dfl-fme.0/fabric_version
> +Date:          March 2019
> +KernelVersion:  5.2
> +Contact:       Wu Hao <hao.wu@intel.com>
> +Description:   Read-only. It returns fabric version of this FPGA device.
> +               Userspace applications need this information to select
> +               best data channels per different fabric design.
> +
> +What:          /sys/bus/platform/devices/dfl-fme.0/socket_id
> +Date:          March 2019
> +KernelVersion:  5.2
> +Contact:       Wu Hao <hao.wu@intel.com>
> +Description:   Read-only. It returns socket_id to indicate which socket
> +               this FPGA belongs to, only valid for integrated solution.
> +               User only needs this information, in case standard numa node
> +               can't provide correct information.
> diff --git a/drivers/fpga/dfl-fme-main.c b/drivers/fpga/dfl-fme-main.c
> index 38c6342..8339ee8 100644
> --- a/drivers/fpga/dfl-fme-main.c
> +++ b/drivers/fpga/dfl-fme-main.c
> @@ -75,10 +75,58 @@ static ssize_t bitstream_metadata_show(struct device *dev,
>  }
>  static DEVICE_ATTR_RO(bitstream_metadata);
>
> +static ssize_t cache_size_show(struct device *dev,
> +                              struct device_attribute *attr, char *buf)
> +{
> +       void __iomem *base;
> +       u64 v;
> +
> +       base = dfl_get_feature_ioaddr_by_id(dev, FME_FEATURE_ID_HEADER);
> +
> +       v = readq(base + FME_HDR_CAP);
> +
> +       return scnprintf(buf, PAGE_SIZE, "%u\n",
> +                        (unsigned int)FIELD_GET(FME_CAP_CACHE_SIZE, v));
> +}
> +static DEVICE_ATTR_RO(cache_size);
> +
> +static ssize_t fabric_version_show(struct device *dev,
> +                                  struct device_attribute *attr, char *buf)
> +{
> +       void __iomem *base;
> +       u64 v;
> +
> +       base = dfl_get_feature_ioaddr_by_id(dev, FME_FEATURE_ID_HEADER);
> +
> +       v = readq(base + FME_HDR_CAP);
> +
> +       return scnprintf(buf, PAGE_SIZE, "%u\n",
> +                        (unsigned int)FIELD_GET(FME_CAP_FABRIC_VERID, v));
> +}
> +static DEVICE_ATTR_RO(fabric_version);
> +
> +static ssize_t socket_id_show(struct device *dev,
> +                             struct device_attribute *attr, char *buf)
> +{
> +       void __iomem *base;
> +       u64 v;
> +
> +       base = dfl_get_feature_ioaddr_by_id(dev, FME_FEATURE_ID_HEADER);
> +
> +       v = readq(base + FME_HDR_CAP);
> +
> +       return scnprintf(buf, PAGE_SIZE, "%u\n",
> +                        (unsigned int)FIELD_GET(FME_CAP_SOCKET_ID, v));
> +}
> +static DEVICE_ATTR_RO(socket_id);
> +
>  static const struct attribute *fme_hdr_attrs[] = {
>         &dev_attr_ports_num.attr,
>         &dev_attr_bitstream_id.attr,
>         &dev_attr_bitstream_metadata.attr,
> +       &dev_attr_cache_size.attr,
> +       &dev_attr_fabric_version.attr,
> +       &dev_attr_socket_id.attr,
>         NULL,
>  };
>
> --
> 2.7.4
>
