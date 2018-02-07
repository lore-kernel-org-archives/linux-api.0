From: Wu Hao <hao.wu@intel.com>
Subject: Re: [PATCH v3 14/21] fpga: dfl: add fpga manager platform driver for
 FME
Date: Wed, 7 Feb 2018 12:52:01 +0800
Message-ID: <20180207045201.GA22010@hao-dev>
References: <1511764948-20972-15-git-send-email-hao.wu@intel.com>
 <CANk1AXS-ON+Pcxtk-AY1XxH8Paw2aFBjiqhuCz7cA4cyuAQMUA@mail.gmail.com>
 <20180202094213.GB17015@hao-dev>
 <20180203002626.GA51125@eluebber-mac02.jf.intel.com>
 <20180204093706.GA26184@hao-dev>
 <20180205183644.GA52136@eluebber-mac02.local>
 <20180206014700.GA3883@hao-dev>
 <CANk1AXRe85Ns1_cUPdn02yS9Gc6i5cYYhko7snvjfzxQSzUzNA@mail.gmail.com>
 <20180206064706.GB4882@hao-dev>
 <CANk1AXRe2hN6zQENmm_Try63S3qQr6FHg=x2J6GLam7oNZp9xw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CANk1AXRe2hN6zQENmm_Try63S3qQr6FHg=x2J6GLam7oNZp9xw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Alan Tull <atull@kernel.org>
Cc: "Luebbers, Enno" <enno.luebbers@intel.com>, Moritz Fischer <mdf@kernel.org>, linux-fpga@vger.kernel.org, linux-kernel <linux-kernel@vger.kernel.org>, linux-api@vger.kernel.org, "Kang, Luwei" <luwei.kang@intel.com>, "Zhang, Yi Z" <yi.z.zhang@intel.com>, Tim Whisonant <tim.whisonant@intel.com>, Shiva Rao <shiva.rao@intel.com>, Christopher Rauer <christopher.rauer@intel.com>, Xiao Guangrong <guangrong.xiao@linux.intel.com>
List-Id: linux-api@vger.kernel.org

On Tue, Feb 06, 2018 at 12:53:44PM -0600, Alan Tull wrote:
> On Tue, Feb 6, 2018 at 12:47 AM, Wu Hao <hao.wu@intel.com> wrote:
> > On Mon, Feb 05, 2018 at 10:25:54PM -0600, Alan Tull wrote:
> >> On Mon, Feb 5, 2018 at 7:47 PM, Wu Hao <hao.wu@intel.com> wrote:
> >> > On Mon, Feb 05, 2018 at 10:36:45AM -0800, Luebbers, Enno wrote:
> >> >> Hi Hao,
> >> >>
> >> >> On Sun, Feb 04, 2018 at 05:37:06PM +0800, Wu Hao wrote:
> >> >> > On Fri, Feb 02, 2018 at 04:26:26PM -0800, Luebbers, Enno wrote:
> >> >> > > Hi Hao, Alan,
> >> >> > >
> >> >> > > On Fri, Feb 02, 2018 at 05:42:13PM +0800, Wu Hao wrote:
> >> >> > > > On Thu, Feb 01, 2018 at 04:00:36PM -0600, Alan Tull wrote:
> >> >> > > > > On Mon, Nov 27, 2017 at 12:42 AM, Wu Hao <hao.wu@intel.com> wrote:
> >> >> > > > >
> >> >> > > > > Hi Hao,
> >> >> > > > >
> >> >> > > > > A few comments below.   Besides that, looks good.
> >> >> > > > >
> >> >> > > > > > This patch adds fpga manager driver for FPGA Management Engine (FME). It
> >> >> > > > > > implements fpga_manager_ops for FPGA Partial Reconfiguration function.
> >> >> > > > > >
> >> >> > > > > > Signed-off-by: Tim Whisonant <tim.whisonant@intel.com>
> >> >> > > > > > Signed-off-by: Enno Luebbers <enno.luebbers@intel.com>
> >> >> > > > > > Signed-off-by: Shiva Rao <shiva.rao@intel.com>
> >> >> > > > > > Signed-off-by: Christopher Rauer <christopher.rauer@intel.com>
> >> >> > > > > > Signed-off-by: Kang Luwei <luwei.kang@intel.com>
> >> >> > > > > > Signed-off-by: Xiao Guangrong <guangrong.xiao@linux.intel.com>
> >> >> > > > > > Signed-off-by: Wu Hao <hao.wu@intel.com>
> >> >> > > > > > ----
> >> >> > > > > > v3: rename driver to dfl-fpga-fme-mgr
> >> >> > > > > >     implemented status callback for fpga manager
> >> >> > > > > >     rebased due to fpga api changes
> >> >> > > > > > ---
> >> >> > > > > >  .../ABI/testing/sysfs-platform-fpga-dfl-fme-mgr    |   8 +
> >> >> > > > > >  drivers/fpga/Kconfig                               |   6 +
> >> >> > > > > >  drivers/fpga/Makefile                              |   1 +
> >> >> > > > > >  drivers/fpga/fpga-dfl-fme-mgr.c                    | 318 +++++++++++++++++++++
> >> >> > > > > >  drivers/fpga/fpga-dfl.h                            |  39 ++-
> >> >> > > > > >  5 files changed, 371 insertions(+), 1 deletion(-)
> >> >> > > > > >  create mode 100644 Documentation/ABI/testing/sysfs-platform-fpga-dfl-fme-mgr
> >> >> > > > > >  create mode 100644 drivers/fpga/fpga-dfl-fme-mgr.c
> >> >> > > > > >
> >> >> > > > > > diff --git a/Documentation/ABI/testing/sysfs-platform-fpga-dfl-fme-mgr b/Documentation/ABI/testing/sysfs-platform-fpga-dfl-fme-mgr
> >> >> > > > > > new file mode 100644
> >> >> > > > > > index 0000000..2d4f917
> >> >> > > > > > --- /dev/null
> >> >> > > > > > +++ b/Documentation/ABI/testing/sysfs-platform-fpga-dfl-fme-mgr
> >> >> > > > > > @@ -0,0 +1,8 @@
> >> >> > > > > > +What:          /sys/bus/platform/devices/fpga-dfl-fme-mgr.0/interface_id
> >> >> > > > > > +Date:          November 2017
> >> >> > > > > > +KernelVersion:  4.15
> >> >> > > > > > +Contact:       Wu Hao <hao.wu@intel.com>
> >> >> > > > > > +Description:   Read-only. It returns interface id of partial reconfiguration
> >> >> > > > > > +               hardware. Userspace could use this information to check if
> >> >> > > > > > +               current hardware is compatible with given image before FPGA
> >> >> > > > > > +               programming.
> >> >> > > > >
> >> >> > > > > I'm a little confused by this.  I can understand that the PR bitstream
> >> >> > > > > has a dependency on the FPGA's static image, but I don't understand
> >> >> > > > > the dependency of the bistream on the hardware that is used to program
> >> >> > > > > the bitstream to the FPGA.
> >> >> > > >
> >> >> > > > Sorry for the confusion, the interface_id is used to indicate the version of
> >> >> > > > the hardware for partial reconfiguration (it's part of the static image of
> >> >> > > > the FPGA device). Will improve the description on this.
> >> >> > > >
> >> >> > >
> >> >> > > The interface_id expresses the compatibility of the static region with PR
> >> >> > > bitstreams generated for it. It changes every time a new static region is
> >> >> > > generated.
> >> >> > >
> >> >> > > Would it make more sense to have the interface_id exposed as part of the FME
> >> >> > > device (which represents the static region)? I'm not sure - it kind of also
> >> >> > > makes sense here, where you would have all the information in one place (if the
> >> >> > > interface_id matches, I can use this component to program a bitstream).
> >> >> >
> >> >> > Hi Enno
> >> >> >
> >> >> > Yes, this interface is under fpga-dfl-fme-mgr.0, and fpga-dfl-fme-mgr.0 is
> >> >> > under fpga-dfl-fme.0. It's part of the FME device for sure. From another
> >> >> > point of view, it means if anyone wants to do PR on this Intel FPGA device,
> >> >> > he needs to find the FME device firstly, and then check if any fpga manager
> >> >> > created under this FME device, if yes, check the interface_id before PR via
> >> >> > the FME device node ioctl.
> >> >>
> >> >> That sounds good, thank you!
> >> >>
> >> >> >
> >> >> > >
> >> >> > > Sorry for my limited understanding of the infrastructure - would this same
> >> >> > > "fpga-dfl-fme-mgr.0" be used for PR if we had multiple PR regions? In that case
> >> >> > > it would need to expose multiple interface_ids (or we'd have to track both
> >> >> > > interface IDs and an identifier for the target PR region).
> >> >> >
> >> >> > Yes, the fpga manager could be shared with different PR regions.
> >> >> >
> >> >> > Sorry, I'm not sure where we need to expose multiple interface_ids and why.
> >> >>
> >> >> It's basically a question of how to determine bitstream compatibility - either,
> >> >> there's a separate interface_id per reconfigurable region, or there is a single
> >> >> interface_id for the entire device. Both make sense from a certain perspective.
> >> >>
> >> >> If there are multiple interface_ids per device (one per region), the driver
> >> >> would need to expose all of them. If there's only a single one, the driver only
> >> >> exposes that one ID - compatibility would be determined by looking at both that
> >> >> single interface_id _and_ the identifier/number of the targeted region.
> >> >>
> >> >> I would prefer a separate interface_id per region - it seems more generic and
> >> >> flexible.
> >>
> >> Hi Enno,
> >>
> >> I agree with this.
> >>
> >> >
> >> > It's possible to have per region interface_id (or even both per dev interface_id
> >> > and per region interface_id at the same time), but per FME PR sub feature
> >> > implementation, it supports multiple PR regions, but only provide one interface
> >> > id, so at least in this case, it's not per-region information per my
> >> > understanding. We can consider it later when hardware really supports it. : )
> >>
> >> Hi Hao,
> >>
> >> I understand that in the case of this PR hardware, the region to
> >> program is selected when the region_id to program is written to a PR
> >> hardware control register.  For another example, Arria10 has a hard PR
> >> hardware and the PR bitstream lands in the area of the FPGA for which
> >> it was compiled.  In that case, for the PR bitstream to be compatible
> >> with a PR region, the layout of the edge connections also needs to be
> >> compatible, so compatibility is per-region in that case instead of
> >> per-PR hardware.
> >
> > Hi Alan,
> >
> > Thanks a lot for the explanation. :)
> >
> > I fully understand the consideration of adding per-region interface_id.
> >
> >> And besides, as I said yesterday, the hard PR
> >> hardware would not know what the static region ID is when this
> >> framework is used with such a device.
> >
> > Yes, is it possible that hard PR hardware with different versions, requires
> > different images or different methods for compatibility checking?
> 
> Because it is really hardware and not something in the FPGA fabric,
> the hard PR hardware isn't going to change versions very often.  It
> has to be designed to be flexible and not add any constraints on the
> PR regions.  If some feature is added or a bug is fixed, that's just a
> driver issue at most and should not affect PR region compatibility.
> PR region compatibility would only be dependent on the static FPGA
> image and the regions that are created in it.  It could be exported in
> terms of a single static region ID or per-region ID.
> 
> >
> >>
> >> That's why I think making the id per-region may be more future proof,
> >> even if it may see unnecessary in the case of the original blue bits
> >> this was written for.
> >
> > I feel that per-PR hardware interface id is useful in some cases, and maybe
> > in some cases, both per-PR hardware and per-region interface ids are needed
> > for its compatibility checking, so shall we leave developers to decide to
> > implement per-PR hardware or per-region or both interface ids based on their
> > own hardware implementations? How do you think? :)
> 
> That gives us 3 sets of id's.  Seems overly complicated and the
> userspace would have to figure out which set of id's to use.  I want
> to see an interface that isn't more complicated than it needs to be
> but still can be expected to be ok for the future (as far as we can
> anticipate).
> 
> Would per-region id's cause any problems that you can see?  I
> understand that the region id's would all be the same value for a
> given PR hardware in your use case, but that doesn't seem like it
> would be hard to implement or that it opens up some possible failure.

Hi Alan

No, I don't have any concern on per-region id at all. I will remove this
sysfs interface_id interface from this driver, and another patch to add
a common sysfs interface under the fpga-region. I feel maybe we can use
"compat_id" instead of "id" here to avoid confusion for that sysfs
interface under fpga-region, as we added a region_id to fpga_image_info,
and they have totally different purposes. How do you think?

Thanks
Hao
