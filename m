From: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCHv3 1/2] proc: mm: export PTE sizes directly in smaps
Date: Wed, 25 Oct 2017 11:28:38 +0200
Message-ID: <20171025092838.4j4u4eeppzh6uto2@dhcp22.suse.cz>
References: <1508891255-15427-1-git-send-email-fan.du@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1508891255-15427-1-git-send-email-fan.du-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Fan Du <fan.du-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, hch-jcswGhMUV9g@public.gmane.org, dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, dave.hansen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Wed 25-10-17 08:27:34, Fan Du wrote:
> From: Dave Hansen <dave.hansen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> 
> /proc/$pid/smaps has a number of fields that are intended to imply the
> kinds of PTEs used to map memory.  "AnonHugePages" obviously tells you
> how many PMDs are being used.  "MMUPageSize" along with the "Hugetlb"
> fields tells you how many PTEs you have for a huge page.
> 
> The current mechanisms work fine when we have one or two page sizes.
> But, they start to get a bit muddled when we mix page sizes inside
> one VMA.  For instance, the DAX folks were proposing adding a set of
> fields like:
> 
> 	DevicePages:
> 	DeviceHugePages:
> 	DeviceGiganticPages:
> 	DeviceGinormousPages:
> 
> to unmuddle things when page sizes get mixed.  That's fine, but
> it does require userspace know the mapping from our various
> arbitrary names to hardware page sizes on each architecture and
> kernel configuration.  That seems rather suboptimal.
> 
> What folks really want is to know how much memory is mapped with
> each page size.  How about we just do *that* instead?
> 
> Patch attached.  Seems harmless enough.  Seems to compile on a
> bunch of random architectures.  Makes smaps look like this:
> 
> Private_Hugetlb:       0 kB
> Swap:                  0 kB
> SwapPss:               0 kB
> KernelPageSize:        4 kB
> MMUPageSize:           4 kB
> Locked:                0 kB
> Ptes@4kB:	      32 kB
> Ptes@2MB:	    2048 kB

Yes, I agree that the current situation is quite messy. But I am
wondering who is going to use this new information and what for?

> The format I used here should be unlikely to break smaps parsers
> unless they're looking for "kB" and now match the 'Ptes@4kB' instead
> of the one at the end of the line.
> 
> Note: hugetlbfs PTEs are unusual.  We can have more than one "pte_t"
> for each hugetlbfs "page".  arm64 has this configuration, and probably
> others.  The code should now handle when an hstate's size is not equal
> to one of the page table entry sizes.  For instance, it assumes that
> hstates between PMD_SIZE and PUD_SIZE are made up of multiple PMDs
> and prints them as such.
> 
> I've tested this on x86 with normal 4k ptes, anonymous huge pages,
> 1G hugetlbfs and 2M hugetlbfs pages.
> 
> 1. I'd like to thank Dan Williams for showing me a mirror as I
>    complained about the bozo that introduced 'AnonHugePages'.

Does the new code add any measurable overhead? I assume it shouldn't
from a quick look at the code. Anyway this is a useful information
because there are people who really want it as cheap as possible.

> [Fan]
> Rebase the original patch from Dave Hansen by fixing a couple of compile
> issues.
> 
> Signed-off-by: Fan Du <fan.du-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Signed-off-by: Dave Hansen <dave.hansen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

nit, the s-o-b ordering should be reverse. The original author should be
first.
-- 
Michal Hocko
SUSE Labs
