From: Wu Hao <hao.wu@intel.com>
Subject: Re: [PATCH 15/17] fpga: dfl: fme: add power management support
Date: Wed, 17 Apr 2019 15:31:41 +0800
Message-ID: <20190417073141.GA23258@hao-dev>
References: <1553483264-5379-1-git-send-email-hao.wu@intel.com>
 <1553483264-5379-16-git-send-email-hao.wu@intel.com>
 <CANk1AXTji9qm0Nfbme+2=nR-PNavnv__GwzDRazhH78hYkWN6g@mail.gmail.com>
 <CAJYdmeOMm0xTRbKTS68M4uiHJLfphPXNo+eFYguda+SuwnkqmQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAJYdmeOMm0xTRbKTS68M4uiHJLfphPXNo+eFYguda+SuwnkqmQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Moritz Fischer <moritz.fischer.private@gmail.com>
Cc: Alan Tull <atull@kernel.org>, linux-fpga@vger.kernel.org, linux-kernel <linux-kernel@vger.kernel.org>, linux-api@vger.kernel.org, Luwei Kang <luwei.kang@intel.com>, Xu Yilun <yilun.xu@intel.com>
List-Id: linux-api@vger.kernel.org

On Fri, Apr 12, 2019 at 02:05:21PM -0700, Moritz Fischer wrote:
> Hi Hao,
> 
> this looks suspiciously like a hwmon driver ;-)
> 
> https://www.kernel.org/doc/Documentation/hwmon/hwmon-kernel-api.txt

Hi Moritz,

Thanks a lot for the suggestion, yes, agree, and patch for thermal
management should be the similar case too. Let me see if i can make
thermal / power management code to hwmon in the next version. : )

Hao

> 
> Cheers,
> Moritz
> 
> 
> On Thu, Apr 11, 2019 at 1:08 PM Alan Tull <atull@kernel.org> wrote:
> >
> > On Sun, Mar 24, 2019 at 10:24 PM Wu Hao <hao.wu@intel.com> wrote:
> >
> > Hi Hao,
> >
> > >
> > > This patch adds support for power management private feature under
> > > FPGA Management Engine (FME), sysfs interfaces are introduced for
> > > different power management functions, users could use these sysfs
> > > interface to get current number of consumed power, throttling
> >
> > How about
> > s/number/measurement/
> > ?
> >
> > > thresholds, threshold status and other information, and configure
> > > different value for throttling thresholds too.
> > >
> > > Signed-off-by: Luwei Kang <luwei.kang@intel.com>
> > > Signed-off-by: Xu Yilun <yilun.xu@intel.com>
> > > Signed-off-by: Wu Hao <hao.wu@intel.com>
> > > ---
> > >  Documentation/ABI/testing/sysfs-platform-dfl-fme |  56 +++++
> > >  drivers/fpga/dfl-fme-main.c                      | 257 +++++++++++++++++++++++
> > >  2 files changed, 313 insertions(+)
> > >
> > > diff --git a/Documentation/ABI/testing/sysfs-platform-dfl-fme b/Documentation/ABI/testing/sysfs-platform-dfl-fme
> > > index d3aeb88..4b6448f 100644
> > > --- a/Documentation/ABI/testing/sysfs-platform-dfl-fme
> > > +++ b/Documentation/ABI/testing/sysfs-platform-dfl-fme
> > > @@ -100,3 +100,59 @@ Description:       Read-only. Read this file to get the policy of temperature
> > >                 threshold1. It only supports two value (policy):
> > >                     0 - AP2 state (90% throttling)
> > >                     1 - AP1 state (50% throttling)
> > > +
> > > +What:          /sys/bus/platform/devices/dfl-fme.0/power_mgmt/consumed
> > > +Date:          March 2019
> > > +KernelVersion:  5.2
> > > +Contact:       Wu Hao <hao.wu@intel.com>
> > > +Description:   Read-only. It returns current power consumed by FPGA.
> >
> > What are the units?
> >
> > > +
> > > +What:          /sys/bus/platform/devices/dfl-fme.0/power_mgmt/threshold1
> > > +Date:          March 2019
> > > +KernelVersion:  5.2
> > > +Contact:       Wu Hao <hao.wu@intel.com>
> > > +Description:   Read-Write. Read/Write this file to get/set current power
> > > +               threshold1 in Watts.
> >
> > Perhaps document error codes here and for threshold2 below.
> >
> > > +
> > > +What:          /sys/bus/platform/devices/dfl-fme.0/power_mgmt/threshold2
> > > +Date:          March 2019
> > > +KernelVersion:  5.2
> > > +Contact:       Wu Hao <hao.wu@intel.com>
> > > +Description:   Read-Write. Read/Write this file to get/set current power
> > > +               threshold2 in Watts.
> > > +
> > > +What:          /sys/bus/platform/devices/dfl-fme.0/power_mgmt/threshold1_status
> > > +Date:          March 2019
> > > +KernelVersion:  5.2
> > > +Contact:       Wu Hao <hao.wu@intel.com>
> > > +Description:   Read-only. It returns 1 if power consumption reaches the
> > > +               threshold1, otherwise 0.
> >
> > I'm used to things like this requiring user to reset the status, so it
> > may be worth making it explicit that it will return to zero if
> > consumption drops below threshold if that's what's happening here.
> > If it's correct, perhaps could just say something like 'returns 1 if
> > power consumption is currently at or above threshold1, otherwise 0'
> >
> > > +
> > > +What:          /sys/bus/platform/devices/dfl-fme.0/power_mgmt/threshold2_status
> > > +Date:          March 2019
> > > +KernelVersion:  5.2
> > > +Contact:       Wu Hao <hao.wu@intel.com>
> > > +Description:   Read-only. It returns 1 if power consumption reaches the
> > > +               threshold2, otherwise 0.
> >
> > Same here.
> >
> > > +
> > > +What:          /sys/bus/platform/devices/dfl-fme.0/power_mgmt/ltr
> > > +Date:          March 2019
> > > +KernelVersion:  5.2
> > > +Contact:       Wu Hao <hao.wu@intel.com>
> > > +Description:   Read-only. Read this file to get current Latency Tolerance
> > > +               Reporting (ltr) value, it's only valid for integrated
> > > +               solution as it blocks CPU on low power state.
> >
> > If we're not on the integrated solution, it returns a value but it is
> > not really real?
> >
> > > +
> > > +What:          /sys/bus/platform/devices/dfl-fme.0/power_mgmt/xeon_limit
> > > +Date:          March 2019
> > > +KernelVersion:  5.2
> > > +Contact:       Wu Hao <hao.wu@intel.com>
> > > +Description:   Read-only. Read this file to get power limit for xeon, it
> > > +               is only valid for integrated solution.
> > > +
> > > +What:          /sys/bus/platform/devices/dfl-fme.0/power_mgmt/fpga_limit
> > > +Date:          March 2019
> > > +KernelVersion:  5.2
> > > +Contact:       Wu Hao <hao.wu@intel.com>
> > > +Description:   Read-only. Read this file to get power limit for fpga, it
> > > +               is only valid for integrated solution.
> > > diff --git a/drivers/fpga/dfl-fme-main.c b/drivers/fpga/dfl-fme-main.c
> > > index 449a17d..dafa6580 100644
> > > --- a/drivers/fpga/dfl-fme-main.c
> > > +++ b/drivers/fpga/dfl-fme-main.c
> > > @@ -415,6 +415,259 @@ static const struct dfl_feature_ops fme_thermal_mgmt_ops = {
> > >         .uinit = fme_thermal_mgmt_uinit,
> > >  };
> > >
> > > +#define FME_PWR_STATUS         0x8
> > > +#define FME_LATENCY_TOLERANCE  BIT_ULL(18)
> > > +#define PWR_CONSUMED           GENMASK_ULL(17, 0)
> > > +
> > > +#define FME_PWR_THRESHOLD      0x10
> > > +#define PWR_THRESHOLD1         GENMASK_ULL(6, 0)       /* in Watts */
> > > +#define PWR_THRESHOLD2         GENMASK_ULL(14, 8)      /* in Watts */
> > > +#define PWR_THRESHOLD_MAX      0x7f
> > > +#define PWR_THRESHOLD1_STATUS  BIT_ULL(16)
> > > +#define PWR_THRESHOLD2_STATUS  BIT_ULL(17)
> > > +
> > > +#define FME_PWR_XEON_LIMIT     0x18
> > > +#define XEON_PWR_LIMIT         GENMASK_ULL(14, 0)
> > > +#define XEON_PWR_EN            BIT_ULL(15)
> > > +#define FME_PWR_FPGA_LIMIT     0x20
> > > +#define FPGA_PWR_LIMIT         GENMASK_ULL(14, 0)
> > > +#define FPGA_PWR_EN            BIT_ULL(15)
> > > +
> > > +#define POWER_ATTR(_name, _mode, _show, _store)        \
> > > +struct device_attribute power_attr_##_name =           \
> > > +       __ATTR(_name, _mode, _show, _store)
> > > +
> > > +#define POWER_ATTR_RO(_name, _show)                    \
> > > +       POWER_ATTR(_name, 0444, _show, NULL)
> > > +
> > > +#define POWER_ATTR_RW(_name, _show, _store)            \
> > > +       POWER_ATTR(_name, 0644, _show, _store)
> >
> > Are these #defines necessary?  Seems like you could just use DEVICE_ATTR*
> >
> > > +
> > > +static ssize_t pwr_consumed_show(struct device *dev,
> > > +                                struct device_attribute *attr, char *buf)
> > > +{
> > > +       void __iomem *base;
> > > +       u64 v;
> > > +
> > > +       base = dfl_get_feature_ioaddr_by_id(dev, FME_FEATURE_ID_POWER_MGMT);
> > > +
> > > +       v = readq(base + FME_PWR_STATUS);
> > > +
> > > +       return scnprintf(buf, PAGE_SIZE, "%u\n",
> > > +                        (unsigned int)FIELD_GET(PWR_CONSUMED, v));
> > > +}
> > > +static POWER_ATTR_RO(consumed, pwr_consumed_show);
> > > +
> > > +static ssize_t pwr_threshold1_show(struct device *dev,
> > > +                                  struct device_attribute *attr, char *buf)
> > > +{
> > > +       void __iomem *base;
> > > +       u64 v;
> > > +
> > > +       base = dfl_get_feature_ioaddr_by_id(dev, FME_FEATURE_ID_POWER_MGMT);
> > > +
> > > +       v = readq(base + FME_PWR_THRESHOLD);
> > > +
> > > +       return scnprintf(buf, PAGE_SIZE, "%u\n",
> > > +                        (unsigned int)FIELD_GET(PWR_THRESHOLD1, v));
> > > +}
> > > +
> > > +static ssize_t pwr_threshold1_store(struct device *dev,
> > > +                                   struct device_attribute *attr,
> > > +                                   const char *buf, size_t count)
> > > +{
> > > +       struct dfl_feature_platform_data *pdata = dev_get_platdata(dev);
> > > +       void __iomem *base;
> > > +       u8 threshold;
> > > +       int ret;
> > > +       u64 v;
> > > +
> > > +       ret = kstrtou8(buf, 0, &threshold);
> > > +       if (ret)
> > > +               return ret;
> > > +
> > > +       if (threshold > PWR_THRESHOLD_MAX)
> > > +               return -EINVAL;
> > > +
> > > +       base = dfl_get_feature_ioaddr_by_id(dev, FME_FEATURE_ID_POWER_MGMT);
> > > +
> > > +       mutex_lock(&pdata->lock);
> > > +       v = readq(base + FME_PWR_THRESHOLD);
> > > +       v &= ~PWR_THRESHOLD1;
> > > +       v |= FIELD_PREP(PWR_THRESHOLD1, threshold);
> > > +       writeq(v, base + FME_PWR_THRESHOLD);
> > > +       mutex_unlock(&pdata->lock);
> > > +
> > > +       return count;
> > > +}
> > > +static POWER_ATTR_RW(threshold1, pwr_threshold1_show, pwr_threshold1_store);
> > > +
> > > +static ssize_t pwr_threshold2_show(struct device *dev,
> > > +                                  struct device_attribute *attr, char *buf)
> > > +{
> > > +       void __iomem *base;
> > > +       u64 v;
> > > +
> > > +       base = dfl_get_feature_ioaddr_by_id(dev, FME_FEATURE_ID_POWER_MGMT);
> > > +
> > > +       v = readq(base + FME_PWR_THRESHOLD);
> > > +
> > > +       return scnprintf(buf, PAGE_SIZE, "%u\n",
> > > +                        (unsigned int)FIELD_GET(PWR_THRESHOLD2, v));
> > > +}
> > > +
> > > +static ssize_t pwr_threshold2_store(struct device *dev,
> > > +                                   struct device_attribute *attr,
> > > +                                   const char *buf, size_t count)
> > > +{
> > > +       struct dfl_feature_platform_data *pdata = dev_get_platdata(dev);
> > > +       void __iomem *base;
> > > +       u8 threshold;
> > > +       int ret;
> > > +       u64 v;
> > > +
> > > +       ret = kstrtou8(buf, 0, &threshold);
> > > +       if (ret)
> > > +               return ret;
> > > +
> > > +       if (threshold > PWR_THRESHOLD_MAX)
> > > +               return -EINVAL;
> > > +
> > > +       base = dfl_get_feature_ioaddr_by_id(dev, FME_FEATURE_ID_POWER_MGMT);
> > > +
> > > +       mutex_lock(&pdata->lock);
> > > +       v = readq(base + FME_PWR_THRESHOLD);
> > > +       v &= ~PWR_THRESHOLD2;
> > > +       v |= FIELD_PREP(PWR_THRESHOLD2, threshold);
> > > +       writeq(v, base + FME_PWR_THRESHOLD);
> > > +       mutex_unlock(&pdata->lock);
> > > +
> > > +       return count;
> > > +}
> > > +static POWER_ATTR_RW(threshold2, pwr_threshold2_show, pwr_threshold2_store);
> > > +
> > > +static ssize_t pwr_threshold1_status_show(struct device *dev,
> > > +                                         struct device_attribute *attr,
> > > +                                         char *buf)
> > > +{
> > > +       void __iomem *base;
> > > +       u64 v;
> > > +
> > > +       base = dfl_get_feature_ioaddr_by_id(dev, FME_FEATURE_ID_POWER_MGMT);
> > > +
> > > +       v = readq(base + FME_PWR_THRESHOLD);
> > > +
> > > +       return scnprintf(buf, PAGE_SIZE, "%u\n",
> > > +                        (unsigned int)FIELD_GET(PWR_THRESHOLD1_STATUS, v));
> > > +}
> > > +static POWER_ATTR_RO(threshold1_status, pwr_threshold1_status_show);
> > > +
> > > +static ssize_t pwr_threshold2_status_show(struct device *dev,
> > > +                                         struct device_attribute *attr,
> > > +                                         char *buf)
> > > +{
> > > +       void __iomem *base;
> > > +       u64 v;
> > > +
> > > +       base = dfl_get_feature_ioaddr_by_id(dev, FME_FEATURE_ID_POWER_MGMT);
> > > +
> > > +       v = readq(base + FME_PWR_THRESHOLD);
> > > +
> > > +       return scnprintf(buf, PAGE_SIZE, "%u\n",
> > > +                        (unsigned int)FIELD_GET(PWR_THRESHOLD2_STATUS, v));
> > > +}
> > > +static POWER_ATTR_RO(threshold2_status, pwr_threshold2_status_show);
> > > +
> > > +static ssize_t ltr_show(struct device *dev,
> > > +                       struct device_attribute *attr, char *buf)
> > > +{
> > > +       void __iomem *base;
> > > +       u64 v;
> > > +
> > > +       base = dfl_get_feature_ioaddr_by_id(dev, FME_FEATURE_ID_POWER_MGMT);
> > > +
> > > +       v = readq(base + FME_PWR_STATUS);
> > > +
> > > +       return scnprintf(buf, PAGE_SIZE, "%u\n",
> > > +                        (unsigned int)FIELD_GET(FME_LATENCY_TOLERANCE, v));
> > > +}
> > > +static POWER_ATTR_RO(ltr, ltr_show);
> > > +
> > > +static ssize_t xeon_limit_show(struct device *dev,
> > > +                              struct device_attribute *attr, char *buf)
> > > +{
> > > +       void __iomem *base;
> > > +       u16 xeon_limit = 0;
> > > +       u64 v;
> > > +
> > > +       base = dfl_get_feature_ioaddr_by_id(dev, FME_FEATURE_ID_POWER_MGMT);
> > > +
> > > +       v = readq(base + FME_PWR_XEON_LIMIT);
> > > +
> > > +       if (FIELD_GET(XEON_PWR_EN, v))
> > > +               xeon_limit = FIELD_GET(XEON_PWR_LIMIT, v);
> > > +
> > > +       return scnprintf(buf, PAGE_SIZE, "%u\n", xeon_limit);
> > > +}
> > > +static POWER_ATTR_RO(xeon_limit, xeon_limit_show);
> > > +
> > > +static ssize_t fpga_limit_show(struct device *dev,
> > > +                              struct device_attribute *attr, char *buf)
> > > +{
> > > +       void __iomem *base;
> > > +       u16 fpga_limit = 0;
> > > +       u64 v;
> > > +
> > > +       base = dfl_get_feature_ioaddr_by_id(dev, FME_FEATURE_ID_POWER_MGMT);
> > > +
> > > +       v = readq(base + FME_PWR_FPGA_LIMIT);
> > > +
> > > +       if (FIELD_GET(FPGA_PWR_EN, v))
> > > +               fpga_limit = FIELD_GET(FPGA_PWR_LIMIT, v);
> > > +
> > > +       return scnprintf(buf, PAGE_SIZE, "%u\n", fpga_limit);
> > > +}
> > > +static POWER_ATTR_RO(fpga_limit, fpga_limit_show);
> > > +
> > > +static struct attribute *power_mgmt_attrs[] = {
> > > +       &power_attr_consumed.attr,
> > > +       &power_attr_threshold1.attr,
> > > +       &power_attr_threshold2.attr,
> > > +       &power_attr_threshold1_status.attr,
> > > +       &power_attr_threshold2_status.attr,
> > > +       &power_attr_xeon_limit.attr,
> > > +       &power_attr_fpga_limit.attr,
> > > +       &power_attr_ltr.attr,
> >
> > This is a nit, but I would expect to see these listed in the same
> > order as their show/store functions above.  So ltr_attr would come
> > between threshold2_status_attr and xeon_limit_attr.
> >
> > > +       NULL,
> > > +};
> > > +
> > > +static struct attribute_group power_mgmt_attr_group = {
> > > +       .attrs  = power_mgmt_attrs,
> > > +       .name   = "power_mgmt",
> > > +};
> > > +
> > > +static int fme_power_mgmt_init(struct platform_device *pdev,
> > > +                              struct dfl_feature *feature)
> > > +{
> > > +       return sysfs_create_group(&pdev->dev.kobj, &power_mgmt_attr_group);
> > > +}
> > > +
> > > +static void fme_power_mgmt_uinit(struct platform_device *pdev,
> > > +                                struct dfl_feature *feature)
> > > +{
> > > +       sysfs_remove_group(&pdev->dev.kobj, &power_mgmt_attr_group);
> > > +}
> > > +
> > > +static const struct dfl_feature_id fme_power_mgmt_id_table[] = {
> > > +       {.id = FME_FEATURE_ID_POWER_MGMT,},
> > > +       {0,}
> > > +};
> > > +
> > > +static const struct dfl_feature_ops fme_power_mgmt_ops = {
> > > +       .init = fme_power_mgmt_init,
> > > +       .uinit = fme_power_mgmt_uinit,
> > > +};
> > > +
> > >  static struct dfl_feature_driver fme_feature_drvs[] = {
> > >         {
> > >                 .id_table = fme_hdr_id_table,
> > > @@ -429,6 +682,10 @@ static struct dfl_feature_driver fme_feature_drvs[] = {
> > >                 .ops = &fme_thermal_mgmt_ops,
> > >         },
> > >         {
> > > +               .id_table = fme_power_mgmt_id_table,
> > > +               .ops = &fme_power_mgmt_ops,
> > > +       },
> > > +       {
> > >                 .ops = NULL,
> > >         },
> > >  };
> > > --
> > > 2.7.4
> > >
> >
> > Thanks,
> > Alan
