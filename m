From: Greg KH <gregkh@linuxfoundation.org>
Subject: Re: [PATCH] usb: core: add usb3 lpm sysfs
Date: Tue, 28 Apr 2015 23:11:10 +0200
Message-ID: <20150428211110.GA32383@kroah.com>
References: <20150419034612.GA31576@intel.com>
 <20150428104224.GB540@kroah.com>
 <20150428165127.GA26638@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20150428165127.GA26638@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Zhuang Jin Can <jin.can.zhuang@intel.com>
Cc: rafael.j.wysocki@intel.com, stern@rowland.harvard.edu, dan.j.williams@intel.com, pmladek@suse.cz, peter.chen@freescale.com, jwerner@chromium.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Wed, Apr 29, 2015 at 12:51:27AM +0800, Zhuang Jin Can wrote:
> Hi Greg KH,
> 
> On Tue, Apr 28, 2015 at 12:42:24PM +0200, Greg KH wrote:
> > On Sun, Apr 19, 2015 at 11:46:12AM +0800, Zhuang Jin Can wrote:
> > > Some usb3 devices may not support usb3 lpm well.
> > > The patch adds a sysfs to enable/disable u1 or u2 of the port.The
> > > settings apply to both before and after device enumeration.
> > > Supported values are "0" - u1 and u2 are disabled, "u1" - only u1 is
> > > enabled, "u2" - only u2 is enabled, "u1_u2" - u1 and u2 are enabled.
> > > 
> > > The interface is useful for testing some USB3 devices during
> > > development, and provides a way to disable usb3 lpm if the issues can
> > > not be fixed in final products.
> > 
> > How is a user supposed to "know" to make this setting for a device?  Why
> > can't the kernel automatically set this value properly?  Why does it
> > need to be a kernel issue at all?
> > 
> By default kernel enables u1 u2 of all USB3 devices. This interface
> provides the user to change this policy. User may set the policy
> according to PID/VID of uevent or according to the platform information
> known by userspace.

And why would they ever want to do that?

> It's not a kernel issue, as u1 u2 is mandatory by USB3 compliance. But
> for some internal hardwired USB3 connection, e.g. SSIC, passing USB3
> compliance is not mandatory. So the interface provides a way for vendor
> to ship with u1 or u2 broken products. Of course, this is not encouraged :).

If the state is broken for those devices, we can't require the user to
fix it for us, the kernel should do it automatically.

> > And when you are doing development of broken devices, the kernel doesn't
> > have to support you, you can run with debugging patches of your own
> > until you fix your firmware :)
> > 
> Understood. But I think other vendor or developer may face the same
> issue in final product shipment or during development. Moreover, the
> interface provide the flexibility for developer to separately
> disable/enable u1 or u2, e.g. If they're debugging an u2 issue, they
> can disable u1 to simplify the situtation.

For debugging only, perhaps, but for a "normal" user, please let's
handle this automatically and don't create a switch that never gets used
by anyone or anything.

thanks,

greg k-h
