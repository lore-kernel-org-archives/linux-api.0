From: Alan Tull <atull@kernel.org>
Subject: Re: [PATCH v2 05/18] Documentation: fpga: dfl: add descriptions for
 virtualization and new interfaces.
Date: Mon, 20 May 2019 13:21:24 -0500
Message-ID: <CANk1AXTh+U-C9TxO7ZZTF+7Nu-_5i=G_0wK0FZ2Go55gPYR0Ng@mail.gmail.com>
References: <1556528151-17221-1-git-send-email-hao.wu@intel.com>
 <1556528151-17221-6-git-send-email-hao.wu@intel.com> <CANk1AXQSL8k=FOLv4_rLfRHBqOi=CW=yP3O8ch4VEa25cj9+Cw@mail.gmail.com>
 <CANk1AXQCp2ozUQDWz__MuiUeDLvGvrfqj3KUYmBa5Z34oxG8NQ@mail.gmail.com> <20190517041116.GC20569@hao-dev>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190517041116.GC20569@hao-dev>
Sender: linux-kernel-owner@vger.kernel.org
To: Wu Hao <hao.wu@intel.com>
Cc: Moritz Fischer <mdf@kernel.org>, linux-fpga@vger.kernel.org, linux-kernel <linux-kernel@vger.kernel.org>, linux-api@vger.kernel.org, Xu Yilun <yilun.xu@intel.com>
List-Id: linux-api@vger.kernel.org

On Thu, May 16, 2019 at 11:27 PM Wu Hao <hao.wu@intel.com> wrote:
>
> On Thu, May 16, 2019 at 12:53:00PM -0500, Alan Tull wrote:
> > On Thu, May 16, 2019 at 12:36 PM Alan Tull <atull@kernel.org> wrote:
> > >
> > > On Mon, Apr 29, 2019 at 4:12 AM Wu Hao <hao.wu@intel.com> wrote:
> >
> > Hi Hao,
> >
> > Most of this patchset looks ready to go upstream or nearly so with
> > pretty straightforward changes .  Patches 17 and 18 need minor changes
> > and please change the scnprintf in the other patches.  The patches
> > that had nontrivial changes are the power and thermal ones involving
> > hwmon.  I'm hoping to send up the patchset minus the hwmon patches in
> > the next version if there's no unforseen issues.  If the hwmon patches
> > are ready then also, that's great, but otherwise those patches don't
> > need to hold up all the rest of the patchset.  How's that sound?
>
> Hi Alan
>
> Thanks for your time for reviewing this patchset.
>
> This sounds good to me. Only thing here is, I need to split the patch which
> updates documentation into 2 patches (to remove hwmon description in doc),
> but for sure, it should be very easy. :)

Yes that sounds good.

Thanks,
Alan


>
> Thanks
> Hao
>
> >
> > Alan
> >
> > > >
> > > > This patch adds virtualization support description for DFL based
> > > > FPGA devices (based on PCIe SRIOV), and introductions to new
> > > > interfaces added by new dfl private feature drivers.
> > > >
> > > > Signed-off-by: Xu Yilun <yilun.xu@intel.com>
> > > > Signed-off-by: Wu Hao <hao.wu@intel.com>
> > >
> > > Acked-by: Alan Tull <atull@kernel.org>
> > >
> > > Thanks,
> > > Alan
