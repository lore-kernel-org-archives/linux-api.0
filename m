From: Wu Hao <hao.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v7 2/2] fpga: dfl: fme: add performance reporting support
Date: Wed, 12 Feb 2020 11:19:29 +0800
Message-ID: <20200212031929.GB5645@hao-dev>
References: <1581306469-22629-1-git-send-email-hao.wu@intel.com>
 <1581306469-22629-3-git-send-email-hao.wu@intel.com>
 <20200210163400.GA21900@willie-the-truck>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20200210163400.GA21900@willie-the-truck>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Will Deacon <will-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: mdf-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, mark.rutland-5wv7dgnIgG8@public.gmane.org, gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, linux-fpga-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, atull-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, yilun.xu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, Luwei Kang <luwei.kang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Mon, Feb 10, 2020 at 04:34:01PM +0000, Will Deacon wrote:
> Hi,
> 
> On Mon, Feb 10, 2020 at 11:47:49AM +0800, Wu Hao wrote:
> > This patch adds support for performance reporting private feature
> > for FPGA Management Engine (FME). Now it supports several different
> > performance counters, including 'basic', 'cache', 'fabric', 'vtd'
> > and 'vtd_sip'. It allows user to use standard linux tools to access
> > these performance counters.
> 
> I had a quick look at this, and it mostly looks alright to me. Just a few
> high-level comments/questions:

Hi Will

Thanks a lot for the review! :)

> 
>   - I would still prefer for the PMU drivers to live under drivers/perf/

Hm.. one possible way is to create a platform device, and introduce a new
platform device driver under drivers/perf/.

> 
>   - You should probably give the PMU a better name than "fme%d", for example
>     "intel_fpga_dfl_fme%d".

Sure. as it's not intel only, so will use "fpga_dfl_fme" or "dfl_fme" instead.

> 
>   - CPU0 can be hotplugged off on non-x86 systems. How do you cope with
>     that?

Oh.. then we can't just always return CPU0 for cpumask, have to switch
to another available cpu. Will add code to handle this case in the next
version. Thanks!

> 
>   - readq() will emit 2x32-bit reads on some architectures. What happens
>     in this case?

64bit counter may increase and carry out of bit31 between 2-32bit reads,
we probably need some more code (add extra reads?) to handle this case.


Thanks again for these valuable comments, will try to fix all of them in
the next version. : )

Hao

> 
> Will
