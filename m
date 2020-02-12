From: Greg KH <gregkh@linuxfoundation.org>
Subject: Re: [PATCH v7 2/2] fpga: dfl: fme: add performance reporting support
Date: Tue, 11 Feb 2020 21:30:35 -0800
Message-ID: <20200212053035.GA382718@kroah.com>
References: <1581306469-22629-1-git-send-email-hao.wu@intel.com>
 <1581306469-22629-3-git-send-email-hao.wu@intel.com>
 <20200210163400.GA21900@willie-the-truck>
 <20200212031929.GB5645@hao-dev>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20200212031929.GB5645@hao-dev>
Sender: linux-kernel-owner@vger.kernel.org
To: Wu Hao <hao.wu@intel.com>
Cc: Will Deacon <will@kernel.org>, mdf@kernel.org, mark.rutland@arm.com, linux-fpga@vger.kernel.org, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, atull@kernel.org, yilun.xu@intel.com, Luwei Kang <luwei.kang@intel.com>
List-Id: linux-api@vger.kernel.org

On Wed, Feb 12, 2020 at 11:19:29AM +0800, Wu Hao wrote:
> On Mon, Feb 10, 2020 at 04:34:01PM +0000, Will Deacon wrote:
> > Hi,
> > 
> > On Mon, Feb 10, 2020 at 11:47:49AM +0800, Wu Hao wrote:
> > > This patch adds support for performance reporting private feature
> > > for FPGA Management Engine (FME). Now it supports several different
> > > performance counters, including 'basic', 'cache', 'fabric', 'vtd'
> > > and 'vtd_sip'. It allows user to use standard linux tools to access
> > > these performance counters.
> > 
> > I had a quick look at this, and it mostly looks alright to me. Just a few
> > high-level comments/questions:
> 
> Hi Will
> 
> Thanks a lot for the review! :)
> 
> > 
> >   - I would still prefer for the PMU drivers to live under drivers/perf/
> 
> Hm.. one possible way is to create a platform device, and introduce a new
> platform device driver under drivers/perf/.

No, do not abuse platform drivers, you have a real device, use it.
