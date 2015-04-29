From: Greg KH <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
Subject: Re: [PATCH] usb: core: add usb3 lpm sysfs
Date: Wed, 29 Apr 2015 13:06:22 +0200
Message-ID: <20150429110622.GA26820@kroah.com>
References: <20150419034612.GA31576@intel.com>
 <20150428104224.GB540@kroah.com>
 <20150428165127.GA26638@intel.com>
 <20150428211110.GA32383@kroah.com>
 <20150429072004.GA20961@intel.com>
 <20150429090148.GA22743@kroah.com>
 <20150429105730.GA12505@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20150429105730.GA12505-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Zhuang Jin Can <jin.can.zhuang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: rafael.j.wysocki-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@public.gmane.org, dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, pmladek-AlSwsSmVLrQ@public.gmane.org, peter.chen-KZfg59tc24xl57MIdRCFDg@public.gmane.org, jwerner-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Wed, Apr 29, 2015 at 06:57:30PM +0800, Zhuang Jin Can wrote:
> On Wed, Apr 29, 2015 at 11:01:48AM +0200, Greg KH wrote:
> > On Wed, Apr 29, 2015 at 03:20:04PM +0800, Zhuang Jin Can wrote:
> > > On Tue, Apr 28, 2015 at 11:11:10PM +0200, Greg KH wrote:
> > > > On Wed, Apr 29, 2015 at 12:51:27AM +0800, Zhuang Jin Can wrote:
> > > > > Hi Greg KH,
> > > > > 
> > > > > On Tue, Apr 28, 2015 at 12:42:24PM +0200, Greg KH wrote:
> > > > > > On Sun, Apr 19, 2015 at 11:46:12AM +0800, Zhuang Jin Can wrote:
> > > > > > > Some usb3 devices may not support usb3 lpm well.
> > > > > > > The patch adds a sysfs to enable/disable u1 or u2 of the port.The
> > > > > > > settings apply to both before and after device enumeration.
> > > > > > > Supported values are "0" - u1 and u2 are disabled, "u1" - only u1 is
> > > > > > > enabled, "u2" - only u2 is enabled, "u1_u2" - u1 and u2 are enabled.
> > > > > > > 
> > > > > > > The interface is useful for testing some USB3 devices during
> > > > > > > development, and provides a way to disable usb3 lpm if the issues can
> > > > > > > not be fixed in final products.
> > > > > > 
> > > > > > How is a user supposed to "know" to make this setting for a device?  Why
> > > > > > can't the kernel automatically set this value properly?  Why does it
> > > > > > need to be a kernel issue at all?
> > > > > > 
> > > > > By default kernel enables u1 u2 of all USB3 devices. This interface
> > > > > provides the user to change this policy. User may set the policy
> > > > > according to PID/VID of uevent or according to the platform information
> > > > > known by userspace.
> > > > 
> > > > And why would they ever want to do that?
> > > > 
> > > > > It's not a kernel issue, as u1 u2 is mandatory by USB3 compliance. But
> > > > > for some internal hardwired USB3 connection, e.g. SSIC, passing USB3
> > > > > compliance is not mandatory. So the interface provides a way for vendor
> > > > > to ship with u1 or u2 broken products. Of course, this is not encouraged :).
> > > > 
> > > > If the state is broken for those devices, we can't require the user to
> > > > fix it for us, the kernel should do it automatically.
> > > > 
> > > > > > And when you are doing development of broken devices, the kernel doesn't
> > > > > > have to support you, you can run with debugging patches of your own
> > > > > > until you fix your firmware :)
> > > > > > 
> > > > > Understood. But I think other vendor or developer may face the same
> > > > > issue in final product shipment or during development. Moreover, the
> > > > > interface provide the flexibility for developer to separately
> > > > > disable/enable u1 or u2, e.g. If they're debugging an u2 issue, they
> > > > > can disable u1 to simplify the situtation.
> > > > 
> > > > For debugging only, perhaps, but for a "normal" user, please let's
> > > > handle this automatically and don't create a switch that never gets used
> > > > by anyone or anything.
> > > > 
> > > Thanks Greg. Since so far the patch has no interesting value to the
> > > community, I'll drop the patch.
> > 
> > I didn't say that, I said it needed some more work to be accepted.
> Sorry for misunderstanding. Let me explain more why we need this interface.
> 
> We have a modem USB3 device (in stepping C) hardwired to one specific port of xHCI.
> The device was expected to work with u1 u2, however, due to a HW issue, it doesn't
> work stably. To workaround the issue, we let the init.rc script disable u1 u2 for
> this specific port.

Modern Linux systems don't have init.rc scripts anymore :)

> Then maybe we want to start debug u1 issue first, to avoid hitting u2 issue,
> we can disable u2. After u1 issue is resolved, we can enable back u2 to continue to
> debug u2 issue. This provides the flexibility to isolate u1 u2 debugging.
> This is valuable I think :)

I agree.

> The HW issue will be fixed in stepping D, however C and D will have the same PID/VID.
> There's no way for kernel to know the difference between C and D.
> Even after fixing in D, C will still be used for development (to save money..)

That sounds like a big design flaw, what about looking at the version of
the device?  That's what that field in the USB descriptors is for.

> If somehow finally we decide to ship stepping C (suppose HW issue can't be fixed in D in time),
> we'll have to disable both u1 and u2.
> 
> If we fix only u1 issue, we can just disable u2, etc..
> 
> To summarize, it provide users an opptunity to change the u1 u2 policy to
> debug and ship broken products.

That's good, but you need to do it somehow "automatically", as again,
systems don't have a init.rc file anymore :)

thanks,

greg k-h
