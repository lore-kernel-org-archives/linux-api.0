From: Zhuang Jin Can <jin.can.zhuang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] usb: core: add usb3 lpm sysfs
Date: Thu, 30 Apr 2015 00:21:32 +0800
Message-ID: <20150429162132.GA21141@intel.com>
References: <20150419034612.GA31576@intel.com>
 <20150428104224.GB540@kroah.com>
 <20150428165127.GA26638@intel.com>
 <20150428211110.GA32383@kroah.com>
 <20150429072004.GA20961@intel.com>
 <20150429090148.GA22743@kroah.com>
 <20150429105730.GA12505@intel.com>
 <20150429110622.GA26820@kroah.com>
Reply-To: jin.can.zhuang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20150429110622.GA26820-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Greg KH <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
Cc: rafael.j.wysocki-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@public.gmane.org, dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, pmladek-AlSwsSmVLrQ@public.gmane.org, peter.chen-KZfg59tc24xl57MIdRCFDg@public.gmane.org, jwerner-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Wed, Apr 29, 2015 at 01:06:22PM +0200, Greg KH wrote:
> On Wed, Apr 29, 2015 at 06:57:30PM +0800, Zhuang Jin Can wrote:
> > On Wed, Apr 29, 2015 at 11:01:48AM +0200, Greg KH wrote:
> > > On Wed, Apr 29, 2015 at 03:20:04PM +0800, Zhuang Jin Can wrote:
> > > > On Tue, Apr 28, 2015 at 11:11:10PM +0200, Greg KH wrote:
> > > > > On Wed, Apr 29, 2015 at 12:51:27AM +0800, Zhuang Jin Can wrote:
> > > > > > Hi Greg KH,
> > > > > > 
> > > > > > On Tue, Apr 28, 2015 at 12:42:24PM +0200, Greg KH wrote:
> > > > > > > On Sun, Apr 19, 2015 at 11:46:12AM +0800, Zhuang Jin Can wrote:
> > > > > > > > Some usb3 devices may not support usb3 lpm well.
> > > > > > > > The patch adds a sysfs to enable/disable u1 or u2 of the port.The
> > > > > > > > settings apply to both before and after device enumeration.
> > > > > > > > Supported values are "0" - u1 and u2 are disabled, "u1" - only u1 is
> > > > > > > > enabled, "u2" - only u2 is enabled, "u1_u2" - u1 and u2 are enabled.
> > > > > > > > 
> > > > > > > > The interface is useful for testing some USB3 devices during
> > > > > > > > development, and provides a way to disable usb3 lpm if the issues can
> > > > > > > > not be fixed in final products.
> > > > > > > 
> > > > > > > How is a user supposed to "know" to make this setting for a device?  Why
> > > > > > > can't the kernel automatically set this value properly?  Why does it
> > > > > > > need to be a kernel issue at all?
> > > > > > > 
> > > > > > By default kernel enables u1 u2 of all USB3 devices. This interface
> > > > > > provides the user to change this policy. User may set the policy
> > > > > > according to PID/VID of uevent or according to the platform information
> > > > > > known by userspace.
> > > > > 
> > > > > And why would they ever want to do that?
> > > > > 
> > > > > > It's not a kernel issue, as u1 u2 is mandatory by USB3 compliance. But
> > > > > > for some internal hardwired USB3 connection, e.g. SSIC, passing USB3
> > > > > > compliance is not mandatory. So the interface provides a way for vendor
> > > > > > to ship with u1 or u2 broken products. Of course, this is not encouraged :).
> > > > > 
> > > > > If the state is broken for those devices, we can't require the user to
> > > > > fix it for us, the kernel should do it automatically.
> > > > > 
> > > > > > > And when you are doing development of broken devices, the kernel doesn't
> > > > > > > have to support you, you can run with debugging patches of your own
> > > > > > > until you fix your firmware :)
> > > > > > > 
> > > > > > Understood. But I think other vendor or developer may face the same
> > > > > > issue in final product shipment or during development. Moreover, the
> > > > > > interface provide the flexibility for developer to separately
> > > > > > disable/enable u1 or u2, e.g. If they're debugging an u2 issue, they
> > > > > > can disable u1 to simplify the situtation.
> > > > > 
> > > > > For debugging only, perhaps, but for a "normal" user, please let's
> > > > > handle this automatically and don't create a switch that never gets used
> > > > > by anyone or anything.
> > > > > 
> > > > Thanks Greg. Since so far the patch has no interesting value to the
> > > > community, I'll drop the patch.
> > > 
> > > I didn't say that, I said it needed some more work to be accepted.
> > Sorry for misunderstanding. Let me explain more why we need this interface.
> > 
> > We have a modem USB3 device (in stepping C) hardwired to one specific port of xHCI.
> > The device was expected to work with u1 u2, however, due to a HW issue, it doesn't
> > work stably. To workaround the issue, we let the init.rc script disable u1 u2 for
> > this specific port.
> 
> Modern Linux systems don't have init.rc scripts anymore :)
> 
In Android, the init process still reads an init.rc where vendor can
define their own policies. Vendors normally provides a whole reference
design (including HW, FW, Kernel, BSP, AOSP) to OEMs. BSP contains
vendor specific configurations including its own init.rc.

> > Then maybe we want to start debug u1 issue first, to avoid hitting u2 issue,
> > we can disable u2. After u1 issue is resolved, we can enable back u2 to continue to
> > debug u2 issue. This provides the flexibility to isolate u1 u2 debugging.
> > This is valuable I think :)
> 
> I agree.
> 
> > The HW issue will be fixed in stepping D, however C and D will have the same PID/VID.
> > There's no way for kernel to know the difference between C and D.
> > Even after fixing in D, C will still be used for development (to save money..)
> 
> That sounds like a big design flaw, what about looking at the version of
> the device?  That's what that field in the USB descriptors is for.
> 
You're right. bcdDevice should be used for this purpose.
However, since we need to live with what we have, we just used the init.rc to disable
u1/u2. Definitely, it's a ugly hack in userspace to make it "automatically" work.

A better solution is to use monitor uevent, reading bcdDevice + PID/VID, and define
a rule in to disable u1/u2 of this device. Android provides an uevent machanism to do this.

However, how to do it automatically, it's out of the scope of the patch.
Without the patch, the only choice is to add a quirk in usb core to do it automatically. And
this should be in another separate patch.
With the patch:
	1. Userspace can also do the quirk with the help of uevent and rules
	2. Developer can isolate u1 u2 debugging.

And I don't think it's necessary for kernel to support this broken modem. Because, the modem
is integrated with the SoC, and SoC goes with init.rc to OEMs. Thus, it doesn't make sense we
add a quirk in kernel to long term support it. The SoC/Modem is going to be replaced by its next
generation, especially in mobile area.

> > If somehow finally we decide to ship stepping C (suppose HW issue can't be fixed in D in time),
> > we'll have to disable both u1 and u2.
> > 
> > If we fix only u1 issue, we can just disable u2, etc..
> > 
> > To summarize, it provide users an opptunity to change the u1 u2 policy to
> > debug and ship broken products.
> 
> That's good, but you need to do it somehow "automatically", as again,
> systems don't have a init.rc file anymore :)
> 

Thanks
Jincan
--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
