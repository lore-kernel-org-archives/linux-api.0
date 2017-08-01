From: Wu Hao <hao.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v2 02/22] fpga: add FPGA device framework
Date: Tue, 1 Aug 2017 16:43:26 +0800
Message-ID: <20170801084326.GB26227@hao-dev>
References: <1498441938-14046-1-git-send-email-hao.wu@intel.com>
 <1498441938-14046-3-git-send-email-hao.wu@intel.com>
 <CANk1AXRoxz7nOY--UYfBtg-3kGFy0gqCz0cbF9mOvzU2+EdzpA@mail.gmail.com>
 <CAL_JsqJfGJwDcXtpBs73TsSKTCwfAPywgyTPwzy1GQotJ7DTzw@mail.gmail.com>
 <CANk1AXTsBQgX+0hYZA6mMhESApB-MkG9CETWExSPOpf7MXeKFw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CANk1AXTsBQgX+0hYZA6mMhESApB-MkG9CETWExSPOpf7MXeKFw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alan Tull <atull-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Rob Herring <robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Moritz Fischer <mdf-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-fpga-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Kang, Luwei" <luwei.kang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Zhang, Yi Z" <yi.z.zhang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Tim Whisonant <tim.whisonant-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Enno Luebbers <enno.luebbers-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Shiva Rao <shiva.rao-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Christopher Rauer <christopher.rauer-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Mon, Jul 31, 2017 at 04:40:16PM -0500, Alan Tull wrote:
> On Thu, Jul 27, 2017 at 2:10 PM, Rob Herring <robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
> > On Thu, Jul 27, 2017 at 11:35 AM, Alan Tull <atull-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
> >> On Sun, Jun 25, 2017 at 8:51 PM, Wu Hao <hao.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrote:
> >>
> >> Hi Rob,
> >>
> >> I was hoping to pick your brain a bit on a DT question.
> >>
> >>> During FPGA device (e.g PCI-based) discovery, platform devices are
> >>> registered for different FPGA function units. But the device node path
> >>> isn't quite friendly to applications.
> >>>
> >>> Consider this case, applications want to access child device's sysfs file
> >>> for some information.
> >>>
> >>> 1) Access using bus-based path (e.g PCI)
> >>>
> >>>   /sys/bus/pci/devices/xxxxx/fpga_func_a.0/sysfs_file
> >>>
> >>>   From the path, it's clear which PCI device is the parent, but not perfect
> >>>   solution for applications. PCI device BDF is not fixed, application may
> >>>   need to search all PCI device to find the actual FPGA Device.
> >>>
> >>> 2) Or access using platform device path
> >>>
> >>>   /sys/bus/platform/devices/fpga_func_a.0/sysfs_file
> >>>
> >>>   Applications find the actual function by name easily, but no information
> >>>   about which fpga device it belongs to. It's quite confusing if multiple
> >>>   FPGA devices are in one system.
> >>
> >> There's a proposal for adding sysfs nodes that correspond to each FPGA
> >> device., with the devices located on each FPGA under them.  It makes
> >> it easier to see which device is on which FPGA.
> >
> > Makes sense.
> >
> >>> 'FPGA Device' class is introduced to resolve this problem. Each node under
> >>> this class represents a fpga device, which may have one or more child
> >>> devices. Applications only need to search under this FPGA Device class
> >>> folder to find the child device node it needs.
> >>>
> >>> For example, for the platform has 2 fpga devices, each fpga device has
> >>> 3 child devices, the hierarchy looks like this.
> >>>
> >>> Two nodes are under /sys/class/fpga/:
> >>> /sys/class/fpga/fpga.0
> >>> /sys/class/fpga/fpga.1
> >>>
> >>> Each node has 1 function A device and 2 function B devices:
> >>> /sys/class/fpga/fpga.0/func_a.0
> >>> /sys/class/fpga/fpga.0/func_b.0
> >>> /sys/class/fpga/fpga.0/func_b.1
> >>>
> >>> /sys/class/fpga/fpga.1/func_a.1
> >>> /sys/class/fpga/fpga.1/func_b.2
> >>> /sys/class/fpga/fpga.1/func_b.3
> >
> > A class is generally what is the function of the device, not how it is
> > attached. Seems like what you want here is a new bus type if the
> > existing PCI and platform bus types don't work.
> >
> >>
> >> I can see the value of having sysfs nodes that correspond to fpga
> >> devices and being able to find devices under them.  I'm thinking what
> >> that would mean for Device Tree when fpga-dev is used on DT enabled
> >> systems.  In Device Tree, what is a fpga-dev?
> >
> > Just properly setting the parent struct device on the functions should
> > be enough to figure out which function is in which fpga. I don't see
> > why a new class is needed.
> >
> >> Currently the DT would have a FPGA bridge corresponding to each FPGA's
> >> hardware bridge and a heirarchy of bridges, regions and devices under
> >> it.  On systems that don't support partial reconfiguration under the
> >> OS (so not main bridge that was controlled by the OS), there would be
> >> a FPGA region, then its child regions, bridges, and devices.
> >
> > The FPGA bridges could instantiate fpga bus type devices instead of
> > platform devices.
> 
> Yes
> 
> Some FPGA use cases already have a base bridge per FPGA that could
> serve as this bus.  But this use case has a static FPGA image +
> reprogrammable child fpga regions.  There's no base bridge under Linux
> since the FPGA was programmed and the bridge enabled before Linux
> boots.   An added base bridge that doesn't touch hardware will be
> required for this type of use.

Hi Alan

Does 'base bridge' mentioned above mean a hardware bridge just like
PCIe or USB?

I tried to use fpga bus type device instead of fpga-dev class today,
it works for me, e.g Intel FPGA device PCIe driver could create a
fpga bus type dev as a child of PCIe device and its sysfs path will be
changed to /sys/bus/fpga/devices/fpga.x/ from /sys/class/fpga/fpga.x/.
For now, this fpga bus type device is only used as container device,
so no driver needed for it.

Do you have any concern on this? I see fpga bus type works fine, but
I didn't see other advantages for this case, as we only use it as a
container device to represent a FPGA device in sysfs hierarchy. :)

Thanks
Hao

> 
> > That's really up to Linux and outside the scope of
> > the bindings.
> 
> Thanks for the feedback.
> 
> Alan Tull
> 
> >
> > Rob
