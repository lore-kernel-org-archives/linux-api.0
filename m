From: Chunyan Zhang <zhang.chunyan-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH V3 6/6] coresight-stm: adding driver for CoreSight STM component
Date: Wed, 17 Feb 2016 11:49:35 +0800
Message-ID: <CAG2=9p8t=j4FfdOGZuCM=3abTcgjL7fiAk52x-+N2pZ+UEtM7A@mail.gmail.com>
References: <1454756672-12790-1-git-send-email-zhang.chunyan@linaro.org>
	<1454756672-12790-7-git-send-email-zhang.chunyan@linaro.org>
	<CANLsYkxvLFu1C+_H9c0EoMebLQu1gnwt9bqY6_R3j+ua2w+xMg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CANLsYkxvLFu1C+_H9c0EoMebLQu1gnwt9bqY6_R3j+ua2w+xMg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mathieu Poirier <mathieu.poirier-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: Alexander Shishkin <alexander.shishkin-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Mike Leach <mike.leach-5wv7dgnIgG8@public.gmane.org>, Michael Williams <Michael.Williams-5wv7dgnIgG8@public.gmane.org>, Al Grant <al.grant-5wv7dgnIgG8@public.gmane.org>, "Jeremiassen, Tor" <tor-l0cyMroinI0@public.gmane.org>, Nicolas GUION <nicolas.guion-qxv4g6HH51o@public.gmane.org>, Mark Brown <broonie-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Rob Herring <robh-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Pratik Patel <pratikp-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, Jon Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, Lyra Zhang <zhang.lyra-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Fri, Feb 12, 2016 at 12:59 AM, Mathieu Poirier
<mathieu.poirier-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org> wrote:
> On 6 February 2016 at 04:04, Chunyan Zhang <zhang.chunyan-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org> wrote:
>> From: Pratik Patel <pratikp-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
>>
>> This driver adds support for the STM CoreSight IP block, allowing any
>> system compoment (HW or SW) to log and aggregate messages via a
>> single entity.
>>
>> The CoreSight STM exposes an application defined number of channels
>> called stimulus port.  Configuration is done using entries in sysfs
>> and channels made available to userspace via configfs.
>>
>> Signed-off-by: Pratik Patel <pratikp-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
>> Signed-off-by: Mathieu Poirier <mathieu.poirier-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
>> Signed-off-by: Chunyan Zhang <zhang.chunyan-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
>> ---
>>  .../ABI/testing/sysfs-bus-coresight-devices-stm    |  53 ++
>>  Documentation/trace/coresight.txt                  |  37 +-
>>  drivers/hwtracing/coresight/Kconfig                |  11 +
>>  drivers/hwtracing/coresight/Makefile               |   1 +
>>  drivers/hwtracing/coresight/coresight-stm.c        | 928 +++++++++++++++++++++
>>  include/linux/coresight-stm.h                      |   6 +
>>  include/uapi/linux/coresight-stm.h                 |  12 +
>>  7 files changed, 1046 insertions(+), 2 deletions(-)
>>  create mode 100644 Documentation/ABI/testing/sysfs-bus-coresight-devices-stm
>>  create mode 100644 drivers/hwtracing/coresight/coresight-stm.c
>>  create mode 100644 include/linux/coresight-stm.h
>>  create mode 100644 include/uapi/linux/coresight-stm.h
>>

[...]

>> +static int stm_send(void *addr, const void *data, u32 size, u8 max)
>> +{
>> +       u32 len = size;
>> +       u8 paload[8];
>> +
>> +       if (stm_addr_unaligned(data, max)) {
>> +               memcpy(paload, data, size);
>> +               data = paload;
>> +       }
>> +
>> +       /* now we are 64bit/32bit aligned */
>> +#ifdef CONFIG_64BIT
>> +       if (size == 8)
>> +               writeq_relaxed(*(u64 *)data, addr);
>> +#endif
>
> We probably don't need an #ifdef here.  Checking the size of the
> transfer against the fundamental data size will result in the same
> outcome, i.e preventing 64 bit transfers on a 32 bit architecture.  An
> error (understandable by the caller) should probably be returned in
> this case.

I think we still need this #ifdef, since this checking is only for
64-bit architecture, on 32-bit architecture it's unreachable, since if
the transfer data size on 32-bit architecture is larger than the
32-bit fundamental data size, it would be adjusted down in the caller
of this function.

>
>> +       if (size >= 4) {
>> +               writel_relaxed(*(u32 *)data, addr);
>> +               data += 4;
>> +               size -= 4;
>> +       }
>> +
>> +       if (size >= 2) {
>> +               writew_relaxed(*(u16 *)data, addr);
>> +               data += 2;
>> +               size -= 2;
>> +       }
>> +
>> +       if (size == 1)
>> +               writeb_relaxed(*(u8 *)data, addr);
>> +
>> +       return len;
>> +}
>> +
>> +static int stm_generic_link(struct stm_data *stm_data,
>> +                           unsigned int master,  unsigned int channel)
>> +{
>> +       struct stm_drvdata *drvdata = container_of(stm_data,
>> +                                                  struct stm_drvdata, stm);
>> +       if (!drvdata || !drvdata->csdev)
>> +               return -EINVAL;
>> +
>> +       return coresight_enable(drvdata->csdev);
>> +}
>> +
>> +static void stm_generic_unlink(struct stm_data *stm_data,
>> +                              unsigned int master,  unsigned int channel)
>> +{
>> +       struct stm_drvdata *drvdata = container_of(stm_data,
>> +                                                  struct stm_drvdata, stm);
>> +       if (!drvdata || !drvdata->csdev)
>> +               return;
>> +
>> +       stm_disable(drvdata->csdev);
>> +}
>> +
>> +static long stm_generic_set_options(struct stm_data *stm_data,
>> +                                   unsigned int master,
>> +                                   unsigned int channel,
>> +                                   unsigned int nr_chans,
>> +                                   unsigned long options)
>> +{
>> +       struct stm_drvdata *drvdata = container_of(stm_data,
>> +                                                  struct stm_drvdata, stm);
>> +       if (!(drvdata && drvdata->enable))
>> +               return -EINVAL;
>> +
>> +       if (channel >= drvdata->numsp)
>> +               return -EINVAL;
>> +
>> +       switch (options) {
>> +       case STM_OPTION_GUARANTEED:
>> +               set_bit(channel, drvdata->chs.guaranteed);
>> +               break;
>> +
>> +       case STM_OPTION_INVARIANT:
>> +               clear_bit(channel, drvdata->chs.guaranteed);
>> +               break;
>> +
>> +       default:
>> +               return -EINVAL;
>> +       }
>> +
>> +       return 0;
>> +}
>> +
>> +static long stm_generic_get_options(struct stm_data *stm_data,
>> +                                   unsigned int master,
>> +                                   unsigned int channel,
>> +                                   unsigned int nr_chans,
>> +                                   u64 *options)
>> +{
>> +       struct stm_drvdata *drvdata = container_of(stm_data,
>> +                                                  struct stm_drvdata, stm);
>> +       if (!(drvdata && drvdata->enable))
>> +               return -EINVAL;
>> +
>> +       if (channel >= drvdata->numsp)
>> +               return -EINVAL;
>> +
>> +       switch (*options) {
>> +       case STM_OPTION_GUARANTEED:
>> +               *options = test_bit(channel, drvdata->chs.guaranteed);
>> +               break;
>> +
>> +       default:
>> +               return -EINVAL;
>> +       }
>> +
>> +       return 0;
>> +}
>> +
>> +static ssize_t stm_generic_packet(struct stm_data *stm_data,
>> +                                 unsigned int master,
>> +                                 unsigned int channel,
>> +                                 unsigned int packet,
>> +                                 unsigned int flags,
>> +                                 unsigned int size,
>> +                                 const unsigned char *payload)
>> +{
>> +       unsigned long ch_addr;
>> +       struct stm_drvdata *drvdata = container_of(stm_data,
>> +                                                  struct stm_drvdata, stm);
>> +
>> +       if (!(drvdata && drvdata->enable))
>> +               return 0;
>> +
>> +       if (channel >= drvdata->numsp)
>> +               return 0;
>> +
>> +       ch_addr = (unsigned long)stm_channel_addr(drvdata, channel);
>> +
>> +       flags = (flags == STP_PACKET_TIMESTAMPED) ? STM_FLAG_TIMESTAMPED : 0;
>> +       flags |= test_bit(channel, drvdata->chs.guaranteed) ?
>> +                          STM_FLAG_GUARANTEED : 0;
>> +
>> +       if (size > drvdata->write_max)
>> +               size = drvdata->write_max;
>> +
>> +       switch (packet) {
>> +       case STP_PACKET_FLAG:
>> +               ch_addr |= stm_channel_off(STM_PKT_TYPE_FLAG, flags);
>> +
>> +               /* the generic STM API set a size of zero on flag packets. */
>> +               size = 1;
>> +               break;
>> +
>> +       case STP_PACKET_DATA:
>> +               ch_addr |= stm_channel_off(STM_PKT_TYPE_DATA, flags);
>> +               break;
>> +
>> +       default:
>> +               return 0;
>> +       }
>> +
>> +       return stm_send((void *)ch_addr, payload, size, drvdata->write_max);
>> +}
>> +
>> +static ssize_t hwevent_enable_show(struct device *dev,
>> +                                  struct device_attribute *attr, char *buf)
>> +{
>> +       struct stm_drvdata *drvdata = dev_get_drvdata(dev->parent);
>> +       unsigned long val = drvdata->stmheer;
>> +
>> +       return scnprintf(buf, PAGE_SIZE, "%#lx\n", val);
>> +}
>> +
>> +static ssize_t hwevent_enable_store(struct device *dev,
>> +                                   struct device_attribute *attr,
>> +                                   const char *buf, size_t size)
>> +{
>> +       struct stm_drvdata *drvdata = dev_get_drvdata(dev->parent);
>> +       unsigned long val;
>> +       int ret = 0;
>> +
>> +       ret = kstrtoul(buf, 16, &val);
>> +       if (ret)
>> +               return -EINVAL;
>> +
>> +       drvdata->stmheer = val;
>> +       /* HW event enable and trigger go hand in hand */
>> +       drvdata->stmheter = val;
>> +
>> +       return size;
>> +}
>> +static DEVICE_ATTR_RW(hwevent_enable);
>> +
>> +static ssize_t hwevent_select_show(struct device *dev,
>> +                                  struct device_attribute *attr, char *buf)
>> +{
>> +       struct stm_drvdata *drvdata = dev_get_drvdata(dev->parent);
>> +       unsigned long val = drvdata->stmhebsr;
>> +
>> +       return scnprintf(buf, PAGE_SIZE, "%#lx\n", val);
>> +}
>> +
>> +static ssize_t hwevent_select_store(struct device *dev,
>> +                                   struct device_attribute *attr,
>> +                                   const char *buf, size_t size)
>> +{
>> +       struct stm_drvdata *drvdata = dev_get_drvdata(dev->parent);
>> +       unsigned long val;
>> +       int ret = 0;
>> +
>> +       ret = kstrtoul(buf, 16, &val);
>> +       if (ret)
>> +               return -EINVAL;
>> +
>> +       drvdata->stmhebsr = val;
>> +
>> +       return size;
>> +}
>> +static DEVICE_ATTR_RW(hwevent_select);
>> +
>> +static ssize_t port_select_show(struct device *dev,
>> +                               struct device_attribute *attr, char *buf)
>> +{
>> +       struct stm_drvdata *drvdata = dev_get_drvdata(dev->parent);
>> +       unsigned long val;
>> +
>> +       if (!drvdata->enable) {
>> +               val = drvdata->stmspscr;
>> +       } else {
>> +               spin_lock(&drvdata->spinlock);
>> +               val = readl_relaxed(drvdata->base + STMSPSCR);
>> +               spin_unlock(&drvdata->spinlock);
>> +       }
>> +
>> +       return scnprintf(buf, PAGE_SIZE, "%#lx\n", val);
>> +}
>> +
>> +static ssize_t port_select_store(struct device *dev,
>> +                                struct device_attribute *attr,
>> +                                const char *buf, size_t size)
>> +{
>> +       struct stm_drvdata *drvdata = dev_get_drvdata(dev->parent);
>> +       unsigned long val, stmsper;
>> +       int ret = 0;
>> +
>> +       ret = kstrtoul(buf, 16, &val);
>> +       if (ret)
>> +               return ret;
>> +
>> +       spin_lock(&drvdata->spinlock);
>> +       drvdata->stmspscr = val;
>> +
>> +       if (drvdata->enable) {
>> +               CS_UNLOCK(drvdata->base);
>> +               /* Process as per ARM's TRM recommendation */
>> +               stmsper = readl_relaxed(drvdata->base + STMSPER);
>> +               writel_relaxed(0x0, drvdata->base + STMSPER);
>> +               writel_relaxed(drvdata->stmspscr, drvdata->base + STMSPSCR);
>> +               writel_relaxed(stmsper, drvdata->base + STMSPER);
>> +               CS_LOCK(drvdata->base);
>> +       }
>> +       spin_unlock(&drvdata->spinlock);
>> +
>> +       return size;
>> +}
>> +static DEVICE_ATTR_RW(port_select);
>> +
>> +static ssize_t port_enable_show(struct device *dev,
>> +                               struct device_attribute *attr, char *buf)
>> +{
>> +       struct stm_drvdata *drvdata = dev_get_drvdata(dev->parent);
>> +       unsigned long val;
>> +
>> +       if (!drvdata->enable) {
>> +               val = drvdata->stmsper;
>> +       } else {
>> +               spin_lock(&drvdata->spinlock);
>> +               val = readl_relaxed(drvdata->base + STMSPER);
>> +               spin_unlock(&drvdata->spinlock);
>> +       }
>> +
>> +       return scnprintf(buf, PAGE_SIZE, "%#lx\n", val);
>> +}
>> +
>> +static ssize_t port_enable_store(struct device *dev,
>> +                                struct device_attribute *attr,
>> +                                const char *buf, size_t size)
>> +{
>> +       struct stm_drvdata *drvdata = dev_get_drvdata(dev->parent);
>> +       unsigned long val;
>> +       int ret = 0;
>> +
>> +       ret = kstrtoul(buf, 16, &val);
>> +       if (ret)
>> +               return ret;
>> +
>> +       spin_lock(&drvdata->spinlock);
>> +       drvdata->stmsper = val;
>> +
>> +       if (drvdata->enable) {
>> +               CS_UNLOCK(drvdata->base);
>> +               writel_relaxed(drvdata->stmsper, drvdata->base + STMSPER);
>> +               CS_LOCK(drvdata->base);
>> +       }
>> +       spin_unlock(&drvdata->spinlock);
>> +
>> +       return size;
>> +}
>> +static DEVICE_ATTR_RW(port_enable);
>> +
>> +static ssize_t traceid_show(struct device *dev,
>> +                           struct device_attribute *attr, char *buf)
>> +{
>> +       unsigned long val;
>> +       struct stm_drvdata *drvdata = dev_get_drvdata(dev->parent);
>> +
>> +       val = drvdata->traceid;
>> +       return sprintf(buf, "%#lx\n", val);
>> +}
>> +
>> +static ssize_t traceid_store(struct device *dev,
>> +                            struct device_attribute *attr,
>> +                            const char *buf, size_t size)
>> +{
>> +       int ret;
>> +       unsigned long val;
>> +       struct stm_drvdata *drvdata = dev_get_drvdata(dev->parent);
>> +
>> +       ret = kstrtoul(buf, 16, &val);
>> +       if (ret)
>> +               return ret;
>> +
>> +       /* traceid field is 7bit wide on STM32 */
>> +       drvdata->traceid = val & 0x7f;
>> +       return size;
>> +}
>> +static DEVICE_ATTR_RW(traceid);
>> +
>> +#define coresight_simple_func(type, name, offset)                      \
>> +static ssize_t name##_show(struct device *_dev,                                \
>> +                          struct device_attribute *attr, char *buf)    \
>> +{                                                                      \
>> +       type *drvdata = dev_get_drvdata(_dev->parent);                  \
>> +       return scnprintf(buf, PAGE_SIZE, "0x%08x\n",                    \
>> +                        readl_relaxed(drvdata->base + offset));        \
>> +}                                                                      \
>> +DEVICE_ATTR_RO(name)
>> +
>> +#define coresight_stm_simple_func(name, offset)        \
>> +       coresight_simple_func(struct stm_drvdata, name, offset)
>> +
>> +coresight_stm_simple_func(tcsr, STMTCSR);
>> +coresight_stm_simple_func(tsfreqr, STMTSFREQR);
>> +coresight_stm_simple_func(syncr, STMSYNCR);
>> +coresight_stm_simple_func(sper, STMSPER);
>> +coresight_stm_simple_func(spter, STMSPTER);
>> +coresight_stm_simple_func(privmaskr, STMPRIVMASKR);
>> +coresight_stm_simple_func(spscr, STMSPSCR);
>> +coresight_stm_simple_func(spmscr, STMSPMSCR);
>> +coresight_stm_simple_func(spfeat1r, STMSPFEAT1R);
>> +coresight_stm_simple_func(spfeat2r, STMSPFEAT2R);
>> +coresight_stm_simple_func(spfeat3r, STMSPFEAT3R);
>> +coresight_stm_simple_func(devid, CORESIGHT_DEVID);
>> +
>> +static struct attribute *coresight_stm_attrs[] = {
>> +       &dev_attr_hwevent_enable.attr,
>> +       &dev_attr_hwevent_select.attr,
>> +       &dev_attr_port_enable.attr,
>> +       &dev_attr_port_select.attr,
>> +       &dev_attr_traceid.attr,
>> +       NULL,
>> +};
>> +
>> +static struct attribute *coresight_stm_mgmt_attrs[] = {
>> +       &dev_attr_tcsr.attr,
>> +       &dev_attr_tsfreqr.attr,
>> +       &dev_attr_syncr.attr,
>> +       &dev_attr_sper.attr,
>> +       &dev_attr_spter.attr,
>> +       &dev_attr_privmaskr.attr,
>> +       &dev_attr_spscr.attr,
>> +       &dev_attr_spmscr.attr,
>> +       &dev_attr_spfeat1r.attr,
>> +       &dev_attr_spfeat2r.attr,
>> +       &dev_attr_spfeat3r.attr,
>> +       &dev_attr_devid.attr,
>> +       NULL,
>> +};
>> +
>> +static const struct attribute_group coresight_stm_group = {
>> +       .attrs = coresight_stm_attrs,
>> +};
>> +
>> +static const struct attribute_group coresight_stm_mgmt_group = {
>> +       .attrs = coresight_stm_mgmt_attrs,
>> +       .name = "mgmt",
>> +};
>> +
>> +static const struct attribute_group *coresight_stm_groups[] = {
>> +       &coresight_stm_group,
>> +       &coresight_stm_mgmt_group,
>> +       NULL,
>> +};
>> +
>> +static int stm_get_resource_byname(struct device_node *np,
>> +                                  char *ch_base, struct resource *res)
>> +{
>> +       const char *name = NULL;
>> +       int index = 0, found = 0;
>> +
>> +       while (!of_property_read_string_index(np, "reg-names", index, &name)) {
>> +               if (strcmp(ch_base, name)) {
>> +                       index++;
>> +                       continue;
>> +               }
>> +
>> +               /* We have a match and @index is where it's at */
>> +               found = 1;
>> +               break;
>> +       }
>> +
>> +       if (!found)
>> +               return -EINVAL;
>> +
>> +       return of_address_to_resource(np, index, res);
>> +}
>> +
>> +static u32 stm_fundamental_data_size(struct stm_drvdata *drvdata)
>> +{
>> +       u32 stmspfeat2r;
>> +
>> +       stmspfeat2r = readl_relaxed(drvdata->base + STMSPFEAT2R);
>> +       return BMVAL(stmspfeat2r, 12, 15);
>> +}
>> +
>> +static u32 stm_num_stimulus_port(struct stm_drvdata *drvdata)
>> +{
>> +       u32 numsp;
>> +
>> +       numsp = readl_relaxed(drvdata->base + CORESIGHT_DEVID);
>> +       /*
>> +        * NUMPS in STMDEVID is 17 bit long and if equal to 0x0,
>> +        * 32 stimulus ports are supported.
>> +        */
>> +       numsp &= 0x1ffff;
>> +       if (!numsp)
>> +               numsp = STM_32_CHANNEL;
>> +       return numsp;
>> +}
>> +
>> +static void stm_init_default_data(struct stm_drvdata *drvdata)
>> +{
>> +       /* Don't use port selection */
>> +       drvdata->stmspscr = 0x0;
>> +       /*
>> +        * Enable all channel regardless of their number.  When port
>> +        * selection isn't used (see above) STMSPER applies to all
>> +        * 32 channel group available, hence setting all 32 bits to 1
>> +        */
>> +       drvdata->stmsper = ~0x0;
>> +
>> +       /*
>> +        * Select arbitrary value to start with.  If there is a conflict
>> +        * with other tracers the framework will deal with it.
>> +        */
>> +       drvdata->traceid = 0x20;
>> +
>> +       /* Set invariant transaction timing on all channels */
>> +       bitmap_clear(drvdata->chs.guaranteed, 0, drvdata->numsp);
>> +}
>> +
>> +static void stm_init_generic_data(struct stm_drvdata *drvdata)
>> +{
>> +       drvdata->stm.name = dev_name(drvdata->dev);
>> +       drvdata->stm.mstatic = true;
>> +       drvdata->stm.sw_nchannels = drvdata->numsp;
>> +       drvdata->stm.packet = stm_generic_packet;
>> +       drvdata->stm.link = stm_generic_link;
>> +       drvdata->stm.unlink = stm_generic_unlink;
>> +       drvdata->stm.set_options = stm_generic_set_options;
>> +       drvdata->stm.get_options = stm_generic_get_options;
>> +}
>> +
>> +static int stm_probe(struct amba_device *adev, const struct amba_id *id)
>> +{
>> +       int ret;
>> +       void __iomem *base;
>> +       unsigned long *guaranteed;
>> +       struct device *dev = &adev->dev;
>> +       struct coresight_platform_data *pdata = NULL;
>> +       struct stm_drvdata *drvdata;
>> +       struct resource *res = &adev->res;
>> +       struct resource ch_res;
>> +       size_t res_size, bitmap_size;
>> +       struct coresight_desc *desc;
>> +       struct device_node *np = adev->dev.of_node;
>> +
>> +       if (np) {
>> +               pdata = of_get_coresight_platform_data(dev, np);
>> +               if (IS_ERR(pdata))
>> +                       return PTR_ERR(pdata);
>> +               adev->dev.platform_data = pdata;
>> +       }
>> +       drvdata = devm_kzalloc(dev, sizeof(*drvdata), GFP_KERNEL);
>> +       if (!drvdata)
>> +               return -ENOMEM;
>> +
>> +       drvdata->dev = &adev->dev;
>> +       drvdata->atclk = devm_clk_get(&adev->dev, "atclk"); /* optional */
>> +       if (!IS_ERR(drvdata->atclk)) {
>> +               ret = clk_prepare_enable(drvdata->atclk);
>> +               if (ret)
>> +                       return ret;
>> +       }
>> +       dev_set_drvdata(dev, drvdata);
>> +
>> +       base = devm_ioremap_resource(dev, res);
>> +       if (IS_ERR(base))
>> +               return PTR_ERR(base);
>> +       drvdata->base = base;
>> +
>> +       ret = stm_get_resource_byname(np, "stm-stimulus-base", &ch_res);
>> +       if (ret)
>> +               return ret;
>> +
>> +       base = devm_ioremap_resource(dev, &ch_res);
>> +       if (IS_ERR(base))
>> +               return PTR_ERR(base);
>> +       drvdata->chs.base = base;
>> +
>> +       drvdata->write_max = sizeof(u32);
>
> Isn't the fundamental data size the maximum an architecture can stand?
>  Why not simply use that rather than adding another variable?
>
>> +       drvdata->write_64bit = stm_fundamental_data_size(drvdata);
>> +
>> +#ifndef CONFIG_64BIT
>> +       if (drvdata->write_64bit)
>> +               drvdata->write_max = sizeof(u64);
>> +#endif
>
> In most cases the fundamental data size will follow the architecture
> size, i.e, 32 bit architecture with 32 bit fundamental data size, 64
> bit architecture with 64 bit fundamental data size.  A fundamental
> data size of 32 is also possible on a 64 bit architecture.
>
> What needs to be prevented is a 32 bit architecture with a fundamental
> data size of 64.  In those cases the fundamental data size should be
> adjusted to be 32 bit.  To do that I suggest to modify
> stm_fundamental_data_size() to probe the STM's fundamental data size

I will modify that according to your suggestion.

> but to adjust it down if on a 32 bit system.  Knowing whether running
> on a 32/64 bit system is easy when using the IS_ENABLED() macro.
>
>> +
>> +       if (boot_nr_channel) {
>> +               drvdata->numsp = boot_nr_channel;
>> +               res_size = min((resource_size_t)(boot_nr_channel *
>> +                                 BYTES_PER_CHANNEL), resource_size(res));
>> +       } else {
>> +               drvdata->numsp = stm_num_stimulus_port(drvdata);
>> +               res_size = min((resource_size_t)(drvdata->numsp *
>> +                                BYTES_PER_CHANNEL), resource_size(res));
>> +       }
>> +       bitmap_size = BITS_TO_LONGS(drvdata->numsp) * sizeof(long);
>> +
>> +       guaranteed = devm_kzalloc(dev, bitmap_size, GFP_KERNEL);
>> +       if (!guaranteed)
>> +               return -ENOMEM;
>> +       drvdata->chs.guaranteed = guaranteed;
>> +
>> +       spin_lock_init(&drvdata->spinlock);
>> +
>> +       stm_init_default_data(drvdata);
>> +       stm_init_generic_data(drvdata);
>> +
>> +       if (stm_register_device(dev, &drvdata->stm, THIS_MODULE)) {
>> +               dev_info(dev,
>> +                        "stm_register_device failed, probing deffered\n");
>> +               return -EPROBE_DEFER;
>> +       }
>> +
>> +       desc = devm_kzalloc(dev, sizeof(*desc), GFP_KERNEL);
>> +       if (!desc) {
>> +               ret = -ENOMEM;
>> +               goto stm_unregister;
>> +       }
>> +
>> +       desc->type = CORESIGHT_DEV_TYPE_SOURCE;
>> +       desc->subtype.source_subtype = CORESIGHT_DEV_SUBTYPE_SOURCE_SOFTWARE;
>> +       desc->ops = &stm_cs_ops;
>> +       desc->pdata = pdata;
>> +       desc->dev = dev;
>> +       desc->groups = coresight_stm_groups;
>> +       drvdata->csdev = coresight_register(desc);
>> +       if (IS_ERR(drvdata->csdev)) {
>> +               ret = PTR_ERR(drvdata->csdev);
>> +               goto stm_unregister;
>> +       }
>> +
>> +       pm_runtime_put(&adev->dev);
>> +
>> +       dev_info(dev, "%s initialized\n", (char *)id->data);
>> +       return 0;
>> +
>> +stm_unregister:
>> +       stm_unregister_device(&drvdata->stm);
>> +       return ret;
>> +}
>> +
>> +static int stm_remove(struct amba_device *adev)
>> +{
>> +       struct stm_drvdata *drvdata = amba_get_drvdata(adev);
>> +
>> +       stm_unregister_device(&drvdata->stm);
>> +       coresight_unregister(drvdata->csdev);
>> +       return 0;
>> +}
>
> The xyz_remove() functions is not needed for coresight devices -
> unbinding a device from its driver will no longer be possible in the
> 4.6 cycle.

OK, will remove this.

Thanks for your review,
Chunyan

>
>> +
>> +#ifdef CONFIG_PM
>> +static int stm_runtime_suspend(struct device *dev)
>> +{
>> +       struct stm_drvdata *drvdata = dev_get_drvdata(dev);
>> +
>> +       if (drvdata && !IS_ERR(drvdata->atclk))
>> +               clk_disable_unprepare(drvdata->atclk);
>> +
>> +       return 0;
>> +}
>> +
>> +static int stm_runtime_resume(struct device *dev)
>> +{
>> +       struct stm_drvdata *drvdata = dev_get_drvdata(dev);
>> +
>> +       if (drvdata && !IS_ERR(drvdata->atclk))
>> +               clk_prepare_enable(drvdata->atclk);
>> +
>> +       return 0;
>> +}
>> +#endif
>> +
>> +static const struct dev_pm_ops stm_dev_pm_ops = {
>> +       SET_RUNTIME_PM_OPS(stm_runtime_suspend, stm_runtime_resume, NULL)
>> +};
>> +
>> +static struct amba_id stm_ids[] = {
>> +       {
>> +               .id     = 0x0003b962,
>> +               .mask   = 0x0003ffff,
>> +               .data   = "STM32",
>> +       },
>> +       { 0, 0},
>> +};
>> +
>> +static struct amba_driver stm_driver = {
>> +       .drv = {
>> +               .name   = "coresight-stm",
>> +               .owner  = THIS_MODULE,
>> +               .pm     = &stm_dev_pm_ops,
>> +       },
>> +       .probe          = stm_probe,
>> +       .remove         = stm_remove,
>> +       .id_table       = stm_ids,
>> +};
>> +
>> +module_amba_driver(stm_driver);
>> +
>> +MODULE_LICENSE("GPL v2");
>> +MODULE_DESCRIPTION("CoreSight System Trace Macrocell driver");
>> diff --git a/include/linux/coresight-stm.h b/include/linux/coresight-stm.h
>> new file mode 100644
>> index 0000000..a978bb8
>> --- /dev/null
>> +++ b/include/linux/coresight-stm.h
>> @@ -0,0 +1,6 @@
>> +#ifndef __LINUX_CORESIGHT_STM_H_
>> +#define __LINUX_CORESIGHT_STM_H_
>> +
>> +#include <uapi/linux/coresight-stm.h>
>> +
>> +#endif
>> diff --git a/include/uapi/linux/coresight-stm.h b/include/uapi/linux/coresight-stm.h
>> new file mode 100644
>> index 0000000..fa35f0b
>> --- /dev/null
>> +++ b/include/uapi/linux/coresight-stm.h
>> @@ -0,0 +1,12 @@
>> +#ifndef __UAPI_CORESIGHT_STM_H_
>> +#define __UAPI_CORESIGHT_STM_H_
>> +
>> +#define STM_FLAG_TIMESTAMPED   BIT(3)
>> +#define STM_FLAG_GUARANTEED    BIT(7)
>> +
>> +enum {
>> +       STM_OPTION_GUARANTEED = 0,
>> +       STM_OPTION_INVARIANT,
>> +};
>> +
>> +#endif
>> --
>> 1.9.1
>>
