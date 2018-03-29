From: Alan Tull <atull@kernel.org>
Subject: Re: [PATCH v4 04/24] fpga: add device feature list support
Date: Thu, 29 Mar 2018 16:57:22 -0500
Message-ID: <CANk1AXQVMCySDjG1_aCxyot612Xg+Vf=vLqk3QY2wpruOAjfpw@mail.gmail.com>
References: <1518513893-4719-1-git-send-email-hao.wu@intel.com>
 <1518513893-4719-5-git-send-email-hao.wu@intel.com> <CANk1AXSaE3wQ7jnBkB0TR3kLKnG1XUeHk+LbDSxyRtBxbMNGPw@mail.gmail.com>
 <20180323043304.GA14733@hao-dev> <CANk1AXRbBonnop6Q3=kdXHdZEBoO9cGa6sON7e0GvFwd_TnYfw@mail.gmail.com>
 <20180327023549.GA15476@hao-dev>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180327023549.GA15476@hao-dev>
Sender: linux-kernel-owner@vger.kernel.org
To: Wu Hao <hao.wu@intel.com>
Cc: Moritz Fischer <mdf@kernel.org>, linux-fpga@vger.kernel.org, linux-kernel <linux-kernel@vger.kernel.org>, linux-api@vger.kernel.org, "Kang, Luwei" <luwei.kang@intel.com>, "Zhang, Yi Z" <yi.z.zhang@intel.com>, Tim Whisonant <tim.whisonant@intel.com>, Enno Luebbers <enno.luebbers@intel.com>, Shiva Rao <shiva.rao@intel.com>, Christopher Rauer <christopher.rauer@intel.com>, Xiao Guangrong <guangrong.xiao@linux.intel.com>
List-Id: linux-api@vger.kernel.org

On Mon, Mar 26, 2018 at 9:35 PM, Wu Hao <hao.wu@intel.com> wrote:

Hi Hao,

Currently there is one set of functions that handles port enable,
disable, and reset and it's in dfl.c and dfl.h, so that's not in any
driver module that can be switched out if necessary for a different
implementation of the port.  Finding a way for this patchset to be
structured for DFL to control what low level manager/port drivers are
used is the current challenge that I've got a lot of my attention on.

Thanks for the explanations on how virtualization affects how this can
be implemented.

> On Mon, Mar 26, 2018 at 12:21:23PM -0500, Alan Tull wrote:
>> On Thu, Mar 22, 2018 at 11:33 PM, Wu Hao <hao.wu@intel.com> wrote:
>>
>> >> > +
>> >> > +/*
>> >> > + * This function resets the FPGA Port and its accelerator (AFU) by function
>> >> > + * __fpga_port_disable and __fpga_port_enable (set port soft reset bit and
>> >> > + * then clear it). Userspace can do Port reset at any time, e.g during DMA
>> >> > + * or Partial Reconfiguration. But it should never cause any system level
>> >> > + * issue, only functional failure (e.g DMA or PR operation failure) and be
>> >> > + * recoverable from the failure.
>> >> > + *
>> >> > + * Note: the accelerator (AFU) is not accessible when its port is in reset
>> >> > + * (disabled). Any attempts on MMIO access to AFU while in reset, will
>> >> > + * result errors reported via port error reporting sub feature (if present).
>> >> > + */
>> >> > +static inline int __fpga_port_reset(struct platform_device *pdev)
>> >> > +{
>> >> > +       int ret;
>> >> > +
>> >> > +       ret = __fpga_port_disable(pdev);
>> >> > +       if (ret)
>> >> > +               return ret;
>> >> > +
>> >> > +       __fpga_port_enable(pdev);
>> >> > +
>> >> > +       return 0;
>> >> > +}
>> >> > +
>> >> > +static inline int fpga_port_reset(struct platform_device *pdev)
>> >> > +{
>> >> > +       struct feature_platform_data *pdata = dev_get_platdata(&pdev->dev);
>> >> > +       int ret;
>> >> > +
>> >> > +       mutex_lock(&pdata->lock);
>> >> > +       ret = __fpga_port_reset(pdev);
>> >> > +       mutex_unlock(&pdata->lock);
>> >> > +
>> >> > +       return ret;
>> >> > +}
>> >>
>> >> I'm still scratching my head about how the enumeration code also has
>> >> code that handles resetting the PL in a FPGA region and
>> >> enabling/disabling the bridge.  We've discussed this before [1] and I
>> >> know you've looked into it, I'm still trying to figure out how this
>> >> can be made modular, so when someone needs to support a different port
>> >> in the future, it isn't a complete rewrite.
>> >>
>> >> Speaking of resets, one way forward would be to create a reset
>> >> controller for the port (and if possible move the port code to the
>> >> bridge platform driver).  The current linux-next repo adds support for
>> >> reset lookups, so that reset controllers are supported for non-DT
>> >> platforms [2].
>> >>
>> >> So the bridge driver would implement the enable/disable functions and
>> >> create a reset controller, the fpga-region (or whoever else needs it)
>> >> could look the reset controller and use the reset.  By using the
>> >> kernel reset framework, we don't have to have that piece of code
>> >> shared around by having a reset function in a .h file.  And it avoids
>> >> adding extra dependencies between modules.  Also, where necessary, I'd
>> >> rather add functionality to the existing bridge/mgr/region frameworks,
>> >> adding common interfaces at that level to allow reuse (like adding
>> >> status to fpga-mgr).  Ideally, this DFL framework would sit on top of
>> >> mgr and bridge and allow those to be swapped out for reuse of the DFL
>> >> framework on other devices.  Also it will save future headaches as mgr
>> >> or port implementations evolve.
>> >
>> > Thanks a lot for the suggestion. I really really appreciate this.
>>
>> Yes, this is a good discussion, thanks.
>>
>> >
>> > Actually if we consider the virutalization case as I mentioned in [1] below,
>> > that means AFU and its Port will be turned into a PCI VF and assigned (passed
>> > through) to a virtual machine. There is no FME block on that PCI VF device,
>> > (the FME is always kept in PCI PF device in the host) and currently the bridge
>> > is created by FME module for PR functionatily. So in the guest virtual machine,
>> > nobody creates the reset controller actually.
>> >
>> > As I mentioned in [1], one possible method is, put these port reset functions to
>> > AFU (Port) module, and share those functions with FME bridge module.
>>
>> Yes, the port reset functions could move into an AFU driver, and then
>> also the AFU driver could also create a reset controller and register
>> a lookup [2] for the reset.  That would be just a few lines of code.
>> The reset controller would control enabling/disabling the port.  The
>> bridge driver could get the reset controller to use during FPGA
>> programming.  That is instead of sharing a reset function with the
>> bridge driver.   It decouples the FPGA bridge driver and simplifies it
>> to be something that just needs to control a reset instead of needing
>> to include a specific .h file that makes  a port reset function
>> available.
>
> Hi Alan
>
> Thanks a lot for the feedback. :)
>
> The major concern here is, for virtualization case, after we enable the SRIOV
> to create VFs, AFUs(and ports) are turned into VFs from PF. Once AFUs are moved
> from PF to VFs, then we should remove all related user interfaces exported by
> the afu platform device under PF by unregistering these platform devices from
> the system. So in this case the reset controller created by the AFU platform
> driver, should be removed when the AFU platform devices are deleted from the
> system in this case, but we still have FME and FME bridge present on PF, then
> FME bridge can't find the reset controller any longer to do port enable/disable.

OK

>
> Sorry, I found my previous description is not accurate.
>
> VFs could be passed through to a virtual machine, if we let AFU/Port create
> reset controller, then the reset controllers are created in the virtual machine.
> And FME is always in PF in the host, so FME bridge in host have no access to the
> reset controllers in the virtual machine.

Thanks for the explanation.  Does the current implementation allows
the port's PORT_CTRL_SFTRST reset bit to be controlled by PF and VF at
the same time?  Or is the idea that the VF has to be given up in order
to allow the FME PF to be able to reprogram?  After the AFU and port
is turned into a VF, is the port's memory range is mapped in both the
PF and the VF?

>
>>
>> > I think
>> > that will make the code in the common DFL framework a little more clean,
>>
>> Yes, IIUC that may also make it easier as the port/AFU gets added
>> functionality that is intended to be controlled by the VF anyway
>> (while the only port-related thing that is needed by the FME is port
>> enable/disable).
>>
>> > but it
>> > will introduce some module dependency here for sure, (e.g FME modules can't
>> > finish PR without AFU (Port) Module loaded).
>>
>> That sounds like an OK type of dependency, i.e. if the modules are not
>> all loaded, it doesn't work. :-)
>
> Find a reset controller by lookup, if not found, return error code. It seems
> not a really hard module dependency between port/afu and FME bridge modules.

That was what I was hoping would work here.  But if the module isn't
loaded because it failed due to the reset controller in the AFU driver
went away, then, yes, that won't work.

> But if in FME bridge, it uses functions exposed by port/afu module, that's a
> hard dependency. : )

Yes I'm trying to find ways to get away from that kind of hard
dependency.  So when someone uses this with a different port, it won't
be a huge rewrite of dfl.c and dfl.h.  I understand that the port is
used by both the AFU and the PR code, that's why it's in a file that
is included by both of them.  That's going to be a problem as soon as
this is used with a different port.

>
> I can try to move related code to afu/port driver instead in the next version
> for sure, but I can't create the reset controller per the reason above. Please
> let me know if more thoughts on this. : )

Maybe that is the way forward.  I'm still thinking about this.  So the
DFL will create a AFU driver that includes the port.  If someone
implements a different port, there would be a different id to cause
that AFU driver to be loaded instead.  It seems a shame that more of
the AFU code couldn't be reused. That was the original idea of
fpga-bridge.  Unfortunately it seems that the bridge is needed by both
the VF and PF so it's complicated by that.

>
>>
>> > But anyway it may be still
>> > acceptable for users as all these modules could be loaded automatically. How do
>> > you think? :)
>>
>> The other thing I want to get right now is if there is a different
>> AFU/port that needs a different driver.  Can the DFL be changed to
>> specify what AFU/port to load?  I really really want to avoid large
>> code rewrites in the future that we can anticipate now.  Such as
>> someone implements their own static image, it has DFL, but the port is
>> somewhat different.  Instead of seeing features as just something that
>> gets added, the DFL also specifies what port driver and mgr driver to
>> load.  The stuff we discussed above is a good step towards that, but
>> not all of it.
>
> I'm not sure if any vendor

Since this is open source, it's important to remember that vendors
aren't the only ones driving development of Linux.  Any user of FPGA
under Linux can (and has) come along and add to this subsystem.  This
code should not discourage that.

> wants to create a totally different port here, if
> yes, then it could have a different feature id in Device Feature Header (DFH).
> I think it's possible to use that feature id to decide which driver to load
> (or which platform device to create).

I think it's what we need.

> But vendors don't have to do that, as it
> could reuse current port driver and private features added already, or even
> add some new vendor specific private feature under the port to save cost.

They would have to implement a static image with port registers that
function the same way for at least port enable/disable/reset.  If they
need to tweak the driver implementation for their hardware then that's
not possible or it's ugly at least.  This is also the case if you have
some newer version of you port while keeping legacy support for your
original port.

I understand that virtualization is making this hard.  Thanks for
thinking about how this can move forward on this issue.

Alan

>
> Thanks
> Hao
>
>>
>> Alan
>>
>> >
>> > Thanks
>> > Hao
>> >
>> >
>> >>
>> >> Alan
>> >>
>> >> [1] https://lkml.org/lkml/2017/12/22/398
>> >> [2] https://patchwork.kernel.org/patch/10247475/
