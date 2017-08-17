From: Alan Tull <atull@kernel.org>
Subject: Re: [PATCH v2 19/22] fpga: intel: afu: add header sub feature support
Date: Thu, 17 Aug 2017 16:41:00 -0500
Message-ID: <CANk1AXQiNLgE6fmty=7kMCU1Zh2xrH85koeieAngyLkf0eeDqA@mail.gmail.com>
References: <1498441938-14046-1-git-send-email-hao.wu@intel.com>
 <1498441938-14046-20-git-send-email-hao.wu@intel.com> <CANk1AXSb==KikMjw4PJ4Yx97vT5JxDkHR5k2Cb0cdrQFUOZqQw@mail.gmail.com>
 <BE8371DA886269458E0220A16DC1F8277E07F3DE@SHSMSX104.ccr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <BE8371DA886269458E0220A16DC1F8277E07F3DE@SHSMSX104.ccr.corp.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Wu, Hao" <hao.wu@intel.com>
Cc: Moritz Fischer <mdf@kernel.org>, "linux-fpga@vger.kernel.org" <linux-fpga@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>, "Kang, Luwei" <luwei.kang@intel.com>, "Zhang, Yi Z" <yi.z.zhang@intel.com>, "Whisonant, Tim" <tim.whisonant@intel.com>, "Luebbers, Enno" <enno.luebbers@intel.com>, "Rao, Shiva" <shiva.rao@intel.com>, "Rauer, Christopher" <christopher.rauer@intel.com>
List-Id: linux-api@vger.kernel.org

On Wed, Aug 16, 2017 at 12:11 AM, Wu, Hao <hao.wu@intel.com> wrote:
>>  On Sun, Jun 25, 2017 at 8:52 PM, Wu Hao <hao.wu@intel.com> wrote:
>>
>> Hi Hao,
>>
>> > The header register set is always present for the Port/AFU, it is mainly
>> > for capability, control and status of the ports that AFU connected to.
>>
>> So just to be clear, the reset function is acting on the Port, not the
>> AFU, right?
>
> Hi Alan
>
> AFU will be reset as well. Once port reset is issued, a compliant HW
> AFU will reset all its state and stop sending requests, and HW will set
> port reset ack bit when all outstanding requests initiated have been
> drained.
>
> Will add some notes here.
>
>>
>> >
>> > This patch implements header sub feature support.
>>
>> Please add a brief reminder here what the 'header' is.  It's defined
>> in patch 7 as being part of the feature list, but hardly mentioned
>> when I grep intel-fpga.txt.
>
> Sure, will adds some notes here.
>
> Actually the header sub feature means the registers belong to the
> feature device (e.g port and FME), not any sub features (e.g PR,
> Power management).
>
>>
>> > Below user interfaces
>> > are created by this patch.
>> >
>> > Sysfs interface:
>> > * /sys/class/fpga/<fpga.x>/<intel-fpga-port.x>/id
>> >   Read-only. Port ID.
>> >
>> > Ioctl interface:
>> > * FPGA_PORT_RESET
>> >   Reset the FPGA AFU Port.
>> >
>> > Signed-off-by: Tim Whisonant <tim.whisonant@intel.com>
>> > Signed-off-by: Enno Luebbers <enno.luebbers@intel.com>
>> > Signed-off-by: Shiva Rao <shiva.rao@intel.com>
>> > Signed-off-by: Christopher Rauer <christopher.rauer@intel.com>
>> > Signed-off-by: Xiao Guangrong <guangrong.xiao@linux.intel.com>
>> > Signed-off-by: Wu Hao <hao.wu@intel.com>
>> > ---
>> > v2: add sysfs documentation.
>> > ---
>> >  .../ABI/testing/sysfs-platform-intel-fpga-afu      |  7 ++++
>> >  drivers/fpga/intel-afu-main.c                      | 44 +++++++++++++++++++++-
>> >  include/uapi/linux/intel-fpga.h                    | 14 +++++++
>> >  3 files changed, 64 insertions(+), 1 deletion(-)
>> >  create mode 100644 Documentation/ABI/testing/sysfs-platform-intel-fpga-
>> afu
>> >
>> > diff --git a/Documentation/ABI/testing/sysfs-platform-intel-fpga-afu
>> b/Documentation/ABI/testing/sysfs-platform-intel-fpga-afu
>> > new file mode 100644
>> > index 0000000..8ad22c9
>> > --- /dev/null
>> > +++ b/Documentation/ABI/testing/sysfs-platform-intel-fpga-afu
>> > @@ -0,0 +1,7 @@
>> > +What:          /sys/bus/platform/devices/intel-fpga-port.0/id
>> > +Date:          June 2017
>> > +KernelVersion:  4.12
>> > +Contact:       Wu Hao <hao.wu@intel.com>
>> > +Description:   Read-only. It returns id of this port. One Intel FPGA device
>> > +               may have more than one port. Userspace could use this id to
>> > +               distinguish different ports under same FPGA device.
>> > diff --git a/drivers/fpga/intel-afu-main.c b/drivers/fpga/intel-afu-main.c
>> > index 96d0367..2a17cde 100644
>> > --- a/drivers/fpga/intel-afu-main.c
>> > +++ b/drivers/fpga/intel-afu-main.c
>> > @@ -18,25 +18,66 @@
>> >
>> >  #include <linux/kernel.h>
>> >  #include <linux/module.h>
>> > +#include <linux/intel-fpga.h>
>> >
>> >  #include "intel-feature-dev.h"
>> >
>> > +static ssize_t
>> > +id_show(struct device *dev, struct device_attribute *attr, char *buf)
>> > +{
>> > +       int id = fpga_port_id(to_platform_device(dev));
>> > +
>> > +       return scnprintf(buf, PAGE_SIZE, "%d\n", id);
>> > +}
>> > +static DEVICE_ATTR_RO(id);
>> > +
>> > +static const struct attribute *port_hdr_attrs[] = {
>> > +       &dev_attr_id.attr,
>> > +       NULL,
>> > +};
>> > +
>> >  static int port_hdr_init(struct platform_device *pdev, struct feature *feature)
>> >  {
>> >         dev_dbg(&pdev->dev, "PORT HDR Init.\n");
>> >
>> > -       return 0;
>> > +       fpga_port_reset(pdev);
>>
>> So the port will be reset here, which happens during fme_probe().
>> IIUC the PR region is empty then, there is just the static region,
>> right?
>
> port_hdr_init is invoked during afu_probe() function. The fpga_port_reset
> only resets the AFU's state and not empty the PR region. User doesn't need
> to program it again after port reset.
>
> The purpose of this reset in port_hdr_init function, is to make sure that we
> could have a clean start whenever the port driver module is loaded. And
> similar as the one added in afu release.
>
>>
>> > +
>> > +       return sysfs_create_files(&pdev->dev.kobj, port_hdr_attrs);
>>
>> Greg wrote an article that there could be a race condition caused by
>> creating sysfs files this late [1] and I see sysfs_create_files() used
>> very sparingly in the kernel.  I'm thinking that fpga-bridge should
>> provide a place to create sysfs files earlier by adding an
>> attribute_group to fpga_bridge_ops (same for fpga-mgr and fpga-region)
>> and then fpga_bridge_register could do bridge->dev.groups =
>> br_ops->groups.  I'll put a patch for that out soon.
>>
>
> Hm... I understand there could be a race condition if creates sysfs files late.
> Actually the reasons I prefer to have each sub feature to create its own sysfs
> files are, 1) if any sub feature is not present, then related init function won't
> be invoked and related sysfs files won't be created at all. Then end user could
> know which sub features are present by checking these sysfs nodes easily.
> 2) Another point of view is about extension of each sub feature, for example,
> Some new registers introduced when sub feature's revision > n, so each sub
> feature's init function could check the sub feature's revision to decide which
> sysfs interfaces are needed. I think this should be a flexible way for extension.
>
>> >  }
>> >
>> >  static void port_hdr_uinit(struct platform_device *pdev,
>> >                                         struct feature *feature)
>> >  {
>> >         dev_dbg(&pdev->dev, "PORT HDR UInit.\n");
>> > +
>> > +       sysfs_remove_files(&pdev->dev.kobj, port_hdr_attrs);
>> > +}
>> > +
>> > +static long
>> > +port_hdr_ioctl(struct platform_device *pdev, struct feature *feature,
>> > +                                       unsigned int cmd, unsigned long arg)
>> > +{
>> > +       long ret;
>> > +
>> > +       switch (cmd) {
>> > +       case FPGA_PORT_RESET:
>> > +               if (!arg)
>> > +                       ret = fpga_port_reset(pdev);
>>
>> fpga_port_reset() disables and reenables traffic on the port.  Is
>> there ever a time when that would be unsafe to do?  Like while DMA is
>> happening?  When I see a function called 'reset' exposed to userspace,
>> I become concerned that hitting that reset at the wrong time could
>> cause problems.  We've discussed this some, but could you please
>> remind me when userspace would need to reset the port?  Please add
>> documentation of what the intended use of this ioctl would be, when it
>> is valid to request a reset from userspace and when userspace should
>> never do that.
>
> Sure, I will add some more description in uapi header file on this IOCTL.
>
> Per my understanding, this API could be invoked at any time, even there
> is some DMA operation or PR operation at the same time. It should not
> cause any system level problem, but may cause functional failures ( e.g
> DMA or PR operation failure) and it should be recoverable.

OK that was my biggest concern here with the reset.

>
>>
>> The pcie code, the AFU file interface, and the bridge code all do port
>> reset.  This code is spread out over a few patches, but I'll comment
>> here for now.  I'm trying to keep track of everything that resets the
>> port.  The port gets reset in afu_probe, fme_probe, the AFU file
>> release, and intel-pcie.c after parsing the features.  Also the port
>> is esentially reset after doing reprogramming, since that involves a
>> bridge disable/enable.   In the v1 review, the issue raised that the
>> port functionality could be an expansion of fpga-bridge.  If reset
>> were added to the fpga_bridge_ops and a fpga_bridge_reset API added to
>> fpga-bridge, then anything in the kernel that owns the bridge could
>> reset it.  That is of course assuming that this code doesn't need to
>> reset the port before the fpga-bridge is created.
>
> Actually in the pcie code, it needs to enable fpga port (put it out of reset,
> as port is in reset by default), otherwise the AFU MMIO region is not
> accessible. It's only a one time action.
>
> For the AFU interface, it gives application a way to reset the AFU if
> anything goes wrong or application wants to make AFU back to
> default state.
>
> For the bridge code, it just makes sure port is in reset during PR, which
> is requested by the PR flow of Intel FPGA device.
>
> As you know, the fpga-bridge is created under FME module now, and
> port/AFU is another module which could be turned into a VF and assigned
> to a virtual machine, even we added a reset ops to fpga-bridge, we still
> need an interface to do port reset as fpga-bridges (and FME) are always
> in PF in host.  :)

OK

Alan

>
> Thanks
> Hao
>
>>
>> Thanks,
>> Alan Tull
>>
>> [1] http://www.kroah.com/log/blog/2013/06/26/how-to-create-a-sysfs-file-
>> correctly/
>>
>> > +               else
>> > +                       ret = -EINVAL;
>> > +               break;
>> > +       default:
>> > +               dev_dbg(&pdev->dev, "%x cmd not handled", cmd);
>> > +               ret = -ENODEV;
>> > +       }
>> > +
>> > +       return ret;
>> >  }
>> >
>> >  struct feature_ops port_hdr_ops = {
>> >         .init = port_hdr_init,
>> >         .uinit = port_hdr_uinit,
>> > +       .ioctl = port_hdr_ioctl,
>> >  };
>> >
>> >  static struct feature_driver port_feature_drvs[] = {
>> > @@ -76,6 +117,7 @@ static int afu_release(struct inode *inode, struct file
>> *filp)
>> >
>> >         dev_dbg(&pdev->dev, "Device File Release\n");
>> >
>> > +       fpga_port_reset(pdev);
>> >         feature_dev_use_end(pdata);
>> >         return 0;
>> >  }
>> > diff --git a/include/uapi/linux/intel-fpga.h b/include/uapi/linux/intel-fpga.h
>> > index be295ae..be5f813 100644
>> > --- a/include/uapi/linux/intel-fpga.h
>> > +++ b/include/uapi/linux/intel-fpga.h
>> > @@ -30,8 +30,11 @@
>> >  #define FPGA_MAGIC 0xB6
>> >
>> >  #define FPGA_BASE 0
>> > +#define PORT_BASE 0x40
>> >  #define FME_BASE 0x80
>> >
>> > +/* Common IOCTLs for both FME and AFU file descriptor */
>> > +
>> >  /**
>> >   * FPGA_GET_API_VERSION - _IO(FPGA_MAGIC, FPGA_BASE + 0)
>> >   *
>> > @@ -50,6 +53,17 @@
>> >
>> >  #define FPGA_CHECK_EXTENSION   _IO(FPGA_MAGIC, FPGA_BASE + 1)
>> >
>> > +/* IOCTLs for AFU file descriptor */
>> > +
>> > +/**
>> > + * FPGA_PORT_RESET - _IO(FPGA_MAGIC, PORT_BASE + 0)
>> > + *
>> > + * Reset the FPGA AFU Port. No parameters are supported.
>> > + * Return: 0 on success, -errno of failure
>> > + */
>> > +
>> > +#define FPGA_PORT_RESET                _IO(FPGA_MAGIC, PORT_BASE + 0)
>> > +
>> >  /* IOCTLs for FME file descriptor */
>> >
>> >  /**
>> > --
>> > 1.8.3.1
>> >
