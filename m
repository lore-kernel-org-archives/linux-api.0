From: Alan Tull <atull@kernel.org>
Subject: Re: [PATCH v4 13/24] fpga: region: add compat_id support
Date: Mon, 5 Mar 2018 13:42:41 -0600
Message-ID: <CANk1AXSKUgvwW_Gm9jUgis5sKipgLL+jT_t5cjWyrtzqYmxg5g@mail.gmail.com>
References: <1518513893-4719-1-git-send-email-hao.wu@intel.com>
 <1518513893-4719-14-git-send-email-hao.wu@intel.com> <CANk1AXSMtbnQDAO+XgVEOLh_F13OJyB3LCEPAc6_-U7CXnkfNw@mail.gmail.com>
 <20180301061750.GB8999@hao-dev>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180301061750.GB8999@hao-dev>
Sender: linux-kernel-owner@vger.kernel.org
To: Wu Hao <hao.wu@intel.com>
Cc: Moritz Fischer <mdf@kernel.org>, linux-fpga@vger.kernel.org, linux-kernel <linux-kernel@vger.kernel.org>, linux-api@vger.kernel.org, "Kang, Luwei" <luwei.kang@intel.com>, "Zhang, Yi Z" <yi.z.zhang@intel.com>
List-Id: linux-api@vger.kernel.org

On Thu, Mar 1, 2018 at 12:17 AM, Wu Hao <hao.wu@intel.com> wrote:
> On Wed, Feb 28, 2018 at 04:55:15PM -0600, Alan Tull wrote:
>> On Tue, Feb 13, 2018 at 3:24 AM, Wu Hao <hao.wu@intel.com> wrote:
>>
>> Hi Hao,
>
> Hi Alan,
>
> Thanks for the review.
>
>>
>> > This patch introduces a compat_id member and sysfs interface for each
>> > fpga-region, e.g userspace applications could read the compat_id
>> > from the sysfs interface for compatibility checking before PR.
>> >
>> > Signed-off-by: Wu Hao <hao.wu@intel.com>
>> > ---
>> >  Documentation/ABI/testing/sysfs-class-fpga-region |  5 +++++
>> >  drivers/fpga/fpga-region.c                        | 19 +++++++++++++++++++
>> >  include/linux/fpga/fpga-region.h                  | 13 +++++++++++++
>> >  3 files changed, 37 insertions(+)
>> >  create mode 100644 Documentation/ABI/testing/sysfs-class-fpga-region
>> >
>> > diff --git a/Documentation/ABI/testing/sysfs-class-fpga-region b/Documentation/ABI/testing/sysfs-class-fpga-region
>> > new file mode 100644
>> > index 0000000..419d930
>> > --- /dev/null
>> > +++ b/Documentation/ABI/testing/sysfs-class-fpga-region
>> > @@ -0,0 +1,5 @@
>> > +What:          /sys/class/fpga_region/<region>/compat_id
>> > +Date:          February 2018
>> > +KernelVersion: 4.16
>> > +Contact:       Wu Hao <hao.wu@intel.com>
>> > +Description:   FPGA region id for compatibility check.

It would be helpful to add some explanation here that although the
intended function of compat_id is set, the way the actual value is
defined or calculated is set by the layer that is creating the FPGA
region.

>> > diff --git a/drivers/fpga/fpga-region.c b/drivers/fpga/fpga-region.c
>> > index 660a91b..babec96 100644
>> > --- a/drivers/fpga/fpga-region.c
>> > +++ b/drivers/fpga/fpga-region.c
>> > @@ -162,6 +162,24 @@ int fpga_region_program_fpga(struct fpga_region *region)
>> >  }
>> >  EXPORT_SYMBOL_GPL(fpga_region_program_fpga);
>> >
>> > +static ssize_t compat_id_show(struct device *dev,
>> > +                             struct device_attribute *attr, char *buf)
>> > +{
>> > +       struct fpga_region *region = to_fpga_region(dev);
>>
>> This looks good, but not all users of FPGA are going to use compat_id.
>> How would you feel about making it a pointer in struct fpga_region?
>> With compat_id as a pointer, could check for non-null compat_id
>> pointer and return an error if it wasn't initialized.
>
> It sounds good to me.
>
> if (!region->compat_id)
>         return -ENOENT;

Yes, thanks!

Alan

>
>>
>> > +
>> > +       return sprintf(buf, "%016llx%016llx\n",
>> > +                      (unsigned long long)region->compat_id.id_h,
>> > +                      (unsigned long long)region->compat_id.id_l);
>> > +}
>> > +
>> > +static DEVICE_ATTR_RO(compat_id);
>> > +
>> > +static struct attribute *fpga_region_attrs[] = {
>> > +       &dev_attr_compat_id.attr,
>> > +       NULL,
>> > +};
>> > +ATTRIBUTE_GROUPS(fpga_region);
>> > +
>> >  int fpga_region_register(struct fpga_region *region)
>> >  {
>> >         struct device *dev = region->parent;
>> > @@ -226,6 +244,7 @@ static int __init fpga_region_init(void)
>> >         if (IS_ERR(fpga_region_class))
>> >                 return PTR_ERR(fpga_region_class);
>> >
>> > +       fpga_region_class->dev_groups = fpga_region_groups;
>> >         fpga_region_class->dev_release = fpga_region_dev_release;
>> >
>> >         return 0;
>> > diff --git a/include/linux/fpga/fpga-region.h b/include/linux/fpga/fpga-region.h
>> > index 423c87e..bf97dcc 100644
>> > --- a/include/linux/fpga/fpga-region.h
>> > +++ b/include/linux/fpga/fpga-region.h
>> > @@ -6,6 +6,17 @@
>> >  #include <linux/fpga/fpga-bridge.h>
>> >
>> >  /**
>> > + * struct fpga_region_compat_id - FPGA Region id for compatibility check
>> > + *
>> > + * @id_h: high 64bit of the compat_id
>> > + * @id_l: low 64bit of the compat_id
>> > + */
>> > +struct fpga_region_compat_id {
>> > +       u64 id_h;
>> > +       u64 id_l;
>>
>> I guess each user will choose how to define these bits.
>
> Yes.
>
>>
>> > +};
>> > +
>> > +/**
>> >   * struct fpga_region - FPGA Region structure
>> >   * @dev: FPGA Region device
>> >   * @parent: parent device
>> > @@ -13,6 +24,7 @@
>> >   * @bridge_list: list of FPGA bridges specified in region
>> >   * @mgr: FPGA manager
>> >   * @info: FPGA image info
>> > + * @compat_id: FPGA region id for compatibility check.
>> >   * @priv: private data
>> >   * @get_bridges: optional function to get bridges to a list
>> >   * @groups: optional attribute groups.
>> > @@ -24,6 +36,7 @@ struct fpga_region {
>> >         struct list_head bridge_list;
>> >         struct fpga_manager *mgr;
>> >         struct fpga_image_info *info;
>> > +       struct fpga_region_compat_id compat_id;
>>
>> Here it would be a pointer instead.
>
> Yes. Will update this patch.
>
> Thanks
> Hao
>
>>
>> Alan
>>
>> >         void *priv;
>> >         int (*get_bridges)(struct fpga_region *region);
>> >         const struct attribute_group **groups;
>> > --
>> > 2.7.4
>> >
> --
> To unsubscribe from this list: send the line "unsubscribe linux-fpga" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
