From: Wu Hao <hao.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v7 2/2] fpga: dfl: fme: add performance reporting support
Date: Wed, 12 Feb 2020 18:02:11 +0800
Message-ID: <20200212100211.GA10436@hao-dev>
References: <1581306469-22629-1-git-send-email-hao.wu@intel.com>
 <1581306469-22629-3-git-send-email-hao.wu@intel.com>
 <20200210163400.GA21900@willie-the-truck>
 <20200212031929.GB5645@hao-dev>
 <20200212053035.GA382718@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20200212053035.GA382718-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Greg KH <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
Cc: Will Deacon <will-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, mdf-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, mark.rutland-5wv7dgnIgG8@public.gmane.org, linux-fpga-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, atull-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, yilun.xu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, Luwei Kang <luwei.kang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Tue, Feb 11, 2020 at 09:30:35PM -0800, Greg KH wrote:
> On Wed, Feb 12, 2020 at 11:19:29AM +0800, Wu Hao wrote:
> > On Mon, Feb 10, 2020 at 04:34:01PM +0000, Will Deacon wrote:
> > > Hi,
> > > 
> > > On Mon, Feb 10, 2020 at 11:47:49AM +0800, Wu Hao wrote:
> > > > This patch adds support for performance reporting private feature
> > > > for FPGA Management Engine (FME). Now it supports several different
> > > > performance counters, including 'basic', 'cache', 'fabric', 'vtd'
> > > > and 'vtd_sip'. It allows user to use standard linux tools to access
> > > > these performance counters.
> > > 
> > > I had a quick look at this, and it mostly looks alright to me. Just a few
> > > high-level comments/questions:
> > 
> > Hi Will
> > 
> > Thanks a lot for the review! :)
> > 
> > > 
> > >   - I would still prefer for the PMU drivers to live under drivers/perf/
> > 
> > Hm.. one possible way is to create a platform device, and introduce a new
> > platform device driver under drivers/perf/.
> 
> No, do not abuse platform drivers, you have a real device, use it.

Sure, thanks for the comments. Then I don't have any other idea to move code to
drivers/perf/ directory, so probably only can live with current code.

Thanks
Hao
