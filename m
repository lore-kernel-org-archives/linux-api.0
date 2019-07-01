From: Wu Hao <hao.wu@intel.com>
Subject: Re: [PATCH v4 05/15] Documentation: fpga: dfl: add descriptions for
 virtualization and new interfaces.
Date: Mon, 1 Jul 2019 14:30:27 +0800
Message-ID: <20190701063027.GA3824@hao-dev>
References: <1561610695-5414-1-git-send-email-hao.wu@intel.com>
 <1561610695-5414-6-git-send-email-hao.wu@intel.com>
 <20190628011256.GB5671@archbook>
 <20190628021333.GB9994@hao-dev>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190628021333.GB9994@hao-dev>
Sender: linux-kernel-owner@vger.kernel.org
To: Moritz Fischer <mdf@kernel.org>
Cc: linux-fpga@vger.kernel.org, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, yilun.xu@intel.com, gregkh@linuxfoundation.org, atull@kernel.org
List-Id: linux-api@vger.kernel.org

On Fri, Jun 28, 2019 at 10:13:33AM +0800, Wu Hao wrote:
> On Thu, Jun 27, 2019 at 06:12:56PM -0700, Moritz Fischer wrote:
> > Hi Wu,
> > 
> > On Thu, Jun 27, 2019 at 12:44:45PM +0800, Wu Hao wrote:
> > > This patch adds virtualization support description for DFL based
> > > FPGA devices (based on PCIe SRIOV), and introductions to new
> > > interfaces added by new dfl private feature drivers.
> > > 
> > > Signed-off-by: Xu Yilun <yilun.xu@intel.com>
> > > Signed-off-by: Wu Hao <hao.wu@intel.com>
> > > Acked-by: Alan Tull <atull@kernel.org>
> > > ---
> > >  Documentation/fpga/dfl.txt | 101 +++++++++++++++++++++++++++++++++++++++++++++
> > >  1 file changed, 101 insertions(+)
> > > 
> > > diff --git a/Documentation/fpga/dfl.txt b/Documentation/fpga/dfl.txt
> > > index 6df4621..a22631f 100644
> > > --- a/Documentation/fpga/dfl.txt
> > > +++ b/Documentation/fpga/dfl.txt
> > 
> > This got re{named,formatted} in linux-next. I've tried to fix it before sending it
> > to Greg.
> 
> Many Thanks for the help! :)
> 
> I think I need rebase thermal/power management (hwmon) and perf support
> patchsets as they update this documentation file too. But I feel we
> can go ahead on code review for the other patches, if there are some
> comments received and something need to fix, i can put fixes together in
> the next version.

Hi Moritz,

I found some descriptions are dropped unexpectedly in your patch, so I 
prepared and sent out a new version (v2) to fix it. Please let me know if
you prefer an increamental patch.

Thanks!
Hao

> 
> Thanks
> Hao
> 
> > 
> > Thanks,
> > Moritz
