From: Wu Hao <hao.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v3 01/21] docs: fpga: add a document for Intel FPGA
 driver overview
Date: Tue, 5 Dec 2017 11:57:02 +0800
Message-ID: <20171205035702.GC19730@hao-dev>
References: <1511764948-20972-1-git-send-email-hao.wu@intel.com>
 <1511764948-20972-2-git-send-email-hao.wu@intel.com>
 <CANk1AXSYYaoZsgQTN_VNE5p_iSx9P6R1+hbVV4RX8s9dyWPD=g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CANk1AXSYYaoZsgQTN_VNE5p_iSx9P6R1+hbVV4RX8s9dyWPD=g@mail.gmail.com>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alan Tull <atull-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Moritz Fischer <mdf-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-fpga-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Kang, Luwei" <luwei.kang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Zhang, Yi Z" <yi.z.zhang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Enno Luebbers <enno.luebbers-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Xiao Guangrong <guangrong.xiao-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Mon, Dec 04, 2017 at 01:55:37PM -0600, Alan Tull wrote:
> On Mon, Nov 27, 2017 at 12:42 AM, Wu Hao <hao.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrote:
> > Add a document for Intel FPGA driver overview.
> >
> > Signed-off-by: Enno Luebbers <enno.luebbers-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> > Signed-off-by: Xiao Guangrong <guangrong.xiao-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
> > Signed-off-by: Wu Hao <hao.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> > ----
> > v2: added FME fpga-mgr/bridge/region platform driver to driver organization.
> >     updated open discussion per current implementation.
> >     fixed some typos.
> > v3: use FPGA base region as container device instead of fpga-dev class.
> >     split common enumeration code from pcie driver to functions exposed by
> >     device feature list framework.
> >     update FME performance reporting which supports both integrated (iperf/)
> >     and discrete (dperf/) FPGA solutions.
> > ---
> >  Documentation/fpga/intel-fpga.txt | 261 ++++++++++++++++++++++++++++++++++++++
> >  1 file changed, 261 insertions(+)
> >  create mode 100644 Documentation/fpga/intel-fpga.txt
> >
> > diff --git a/Documentation/fpga/intel-fpga.txt b/Documentation/fpga/intel-fpga.txt
> > new file mode 100644
> > index 0000000..0754733
> > --- /dev/null
> > +++ b/Documentation/fpga/intel-fpga.txt
> > @@ -0,0 +1,261 @@
> > +===============================================================================
> > +                    Intel FPGA driver Overview
> 
> This doesn't look Intel specific to me.  This could all be 'DFL FPGA Framework'

Sure, will rename this doc to dfl-fpga.txt in the next version as we plan to rename
the pcie driver to dfl-pci per your comments on the patch #8, there is no reason to
keep it in this doc as all drivers will be dfl-* in the next version. :)

> 
> > +-------------------------------------------------------------------------------
> > +                Enno Luebbers <enno.luebbers-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> > +                Xiao Guangrong <guangrong.xiao-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
> > +                Wu Hao <hao.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> > +
> > +The Intel FPGA driver provides interfaces for userspace applications to
> > +configure, enumerate, open, and access FPGA accelerators on platforms equipped
> > +with Intel(R) FPGA PCIe based solutions and enables system level management
> > +functions such as FPGA reconfiguration, power management, and virtualization.
> > +
> > +HW Architecture
> > +===============
> > +From the OS's point of view, the FPGA hardware appears as a regular PCIe device.
> > +The FPGA device memory is organized using a predefined data structure (Device
> > +Feature List). Features supported by the particular FPGA device are exposed
> > +through these data structures, as illustrated below:
> > +
> > +  +-------------------------------+  +-------------+
> > +  |              PF               |  |     VF      |
> > +  +-------------------------------+  +-------------+
> > +      ^            ^         ^              ^
> > +      |            |         |              |
> > ++-----|------------|---------|--------------|-------+
> > +|     |            |         |              |       |
> > +|  +-----+     +-------+ +-------+      +-------+   |
> > +|  | FME |     | Port0 | | Port1 |      | Port2 |   |
> > +|  +-----+     +-------+ +-------+      +-------+   |
> > +|                  ^         ^              ^       |
> > +|                  |         |              |       |
> > +|              +-------+ +------+       +-------+   |
> > +|              |  AFU  | |  AFU |       |  AFU  |   |
> > +|              +-------+ +------+       +-------+   |
> > +|                                                   |
> > +|                 FPGA PCIe Device                  |
> > ++---------------------------------------------------+
> > +
> > +The driver supports PCIe SR-IOV to create virtual functions (VFs) which can be
> > +used to assign individual accelerators to virtual machines.
> > +
> > +FME (FPGA Management Engine)
> > +============================
> > +The FPGA Management Engine performs power and thermal management, error
> > +reporting, reconfiguration, performance reporting for integrated and discrete
> > +solution, and other infrastructure functions. Each FPGA has one FME, which is
> > +always accessed through the physical function (PF).
> > +
> > +User-space applications can acquire exclusive access to the FME using open(),
> > +and release it using close().
> > +
> > +The following functions are exposed through ioctls:
> > +
> > +       Get driver API version (FPGA_GET_API_VERSION)
> > +       Check for extensions (FPGA_CHECK_EXTENSION)
> > +       Assign port to PF (FPGA_FME_PORT_ASSIGN)
> > +       Release port from PF (FPGA_FME_PORT_RELEASE)
> > +       Program bitstream (FPGA_FME_PORT_PR)
> > +
> > +More functions are exposed through sysfs
> > +(/sys/class/fpga_region/regionX/fpga-dfl-fme.n/):
> 
> I see that /sys/class/fpga/* has changed to /sys/class/fpga_region/*
> now as requested (thanks!).  It looks like it ended up being pretty
> straightforward (so far, just diffing this doc with the previous v2).

Thanks for the suggestion on using fpga base region. :)

Hao
