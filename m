From: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCHv3 1/2] proc: mm: export PTE sizes directly in smaps
Date: Thu, 26 Oct 2017 16:19:43 +0200
Message-ID: <20171026141943.fsmd4goiec32qjkf@dhcp22.suse.cz>
References: <1508891255-15427-1-git-send-email-fan.du@intel.com>
 <20171025092838.4j4u4eeppzh6uto2@dhcp22.suse.cz>
 <5A90DA2E42F8AE43BC4A093BF06788481AA50489@SHSMSX104.ccr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <5A90DA2E42F8AE43BC4A093BF06788481AA50489-0J0gbvR4kTg/UvCtAeCM4rfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Du, Fan" <fan.du-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org" <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, "hch-jcswGhMUV9g@public.gmane.org" <hch-jcswGhMUV9g@public.gmane.org>, "Williams, Dan J" <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Hansen, Dave" <dave.hansen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Thu 26-10-17 01:41:26, Du, Fan wrote:
> 
> 
> >-----Original Message-----
> >From: Michal Hocko [mailto:mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org]
> >Sent: Wednesday, October 25, 2017 5:29 PM
> >To: Du, Fan <fan.du-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> >Cc: akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org; hch-jcswGhMUV9g@public.gmane.org; Williams, Dan J
> ><dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>; Hansen, Dave <dave.hansen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>;
> >linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> >Subject: Re: [PATCHv3 1/2] proc: mm: export PTE sizes directly in smaps
> >
> >On Wed 25-10-17 08:27:34, Fan Du wrote:
> >> From: Dave Hansen <dave.hansen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> >>
> >> /proc/$pid/smaps has a number of fields that are intended to imply the
> >> kinds of PTEs used to map memory.  "AnonHugePages" obviously tells you
> >> how many PMDs are being used.  "MMUPageSize" along with the
> >"Hugetlb"
> >> fields tells you how many PTEs you have for a huge page.
> >>
> >> The current mechanisms work fine when we have one or two page sizes.
> >> But, they start to get a bit muddled when we mix page sizes inside
> >> one VMA.  For instance, the DAX folks were proposing adding a set of
> >> fields like:
> >>
> >> 	DevicePages:
> >> 	DeviceHugePages:
> >> 	DeviceGiganticPages:
> >> 	DeviceGinormousPages:
> >>
> >> to unmuddle things when page sizes get mixed.  That's fine, but
> >> it does require userspace know the mapping from our various
> >> arbitrary names to hardware page sizes on each architecture and
> >> kernel configuration.  That seems rather suboptimal.
> >>
> >> What folks really want is to know how much memory is mapped with
> >> each page size.  How about we just do *that* instead?
> >>
> >> Patch attached.  Seems harmless enough.  Seems to compile on a
> >> bunch of random architectures.  Makes smaps look like this:
> >>
> >> Private_Hugetlb:       0 kB
> >> Swap:                  0 kB
> >> SwapPss:               0 kB
> >> KernelPageSize:        4 kB
> >> MMUPageSize:           4 kB
> >> Locked:                0 kB
> >> Ptes@4kB:	      32 kB
> >> Ptes@2MB:	    2048 kB
> >
> >Yes, I agree that the current situation is quite messy. But I am
> >wondering who is going to use this new information and what for?
> 
> It comes from my customer who are using Device DAX, looking for any statistics
> of how much persistent memory mapping has been created, or used by application.

How is this information then used? Just displayed or somebody can make
decisions based on those numbers? Please be more specific about the
usecase.

> Current vm_normal_page implementation doesn't pick up page with DEVMAP pfn.
> The second patch fix this and export DAX mappings into counters introduced in the
> first patch.
> 
> IMO, the user care more about how much persistent memory they used, how about
> a small tweak with smaps_account, and report the total mapping size into RSS/PSS,
> which user are usually more familiar with?

No! Rss and pss is already used by many tools to evaluate misbehaving
tasks. If you start accounting the memory which is not bound to the
process life time then you can break those usecases. This is the reason
why hugetlb is not accounted to rss as well.

-- 
Michal Hocko
SUSE Labs
