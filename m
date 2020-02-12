From: Greg KH <gregkh@linuxfoundation.org>
Subject: Re: [PATCH v7 2/2] fpga: dfl: fme: add performance reporting support
Date: Wed, 12 Feb 2020 05:20:45 -0800
Message-ID: <20200212132045.GC1789899@kroah.com>
References: <1581306469-22629-1-git-send-email-hao.wu@intel.com>
 <1581306469-22629-3-git-send-email-hao.wu@intel.com>
 <20200210163400.GA21900@willie-the-truck>
 <20200212031929.GB5645@hao-dev>
 <20200212053035.GA382718@kroah.com>
 <20200212100211.GA10436@hao-dev>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20200212100211.GA10436@hao-dev>
Sender: linux-kernel-owner@vger.kernel.org
To: Wu Hao <hao.wu@intel.com>
Cc: Will Deacon <will@kernel.org>, mdf@kernel.org, mark.rutland@arm.com, linux-fpga@vger.kernel.org, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, atull@kernel.org, yilun.xu@intel.com, Luwei Kang <luwei.kang@intel.com>
List-Id: linux-api@vger.kernel.org

On Wed, Feb 12, 2020 at 06:02:11PM +0800, Wu Hao wrote:
> On Tue, Feb 11, 2020 at 09:30:35PM -0800, Greg KH wrote:
> > On Wed, Feb 12, 2020 at 11:19:29AM +0800, Wu Hao wrote:
> > > On Mon, Feb 10, 2020 at 04:34:01PM +0000, Will Deacon wrote:
> > > > Hi,
> > > > 
> > > > On Mon, Feb 10, 2020 at 11:47:49AM +0800, Wu Hao wrote:
> > > > > This patch adds support for performance reporting private feature
> > > > > for FPGA Management Engine (FME). Now it supports several different
> > > > > performance counters, including 'basic', 'cache', 'fabric', 'vtd'
> > > > > and 'vtd_sip'. It allows user to use standard linux tools to access
> > > > > these performance counters.
> > > > 
> > > > I had a quick look at this, and it mostly looks alright to me. Just a few
> > > > high-level comments/questions:
> > > 
> > > Hi Will
> > > 
> > > Thanks a lot for the review! :)
> > > 
> > > > 
> > > >   - I would still prefer for the PMU drivers to live under drivers/perf/
> > > 
> > > Hm.. one possible way is to create a platform device, and introduce a new
> > > platform device driver under drivers/perf/.
> > 
> > No, do not abuse platform drivers, you have a real device, use it.
> 
> Sure, thanks for the comments. Then I don't have any other idea to move code to
> drivers/perf/ directory, so probably only can live with current code.

The location of the file in the kernel tree has no bearing on if you use
a platform device, a USB device, or a PCI device.  It is just a location
of a file.

You are interacting with the perf api as the driver's primary userspace
api, so put the driver into the drivers/perf/ directory.  That's all
that Will is asking you to do here.

greg k-h
