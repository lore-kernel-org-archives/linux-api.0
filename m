From: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 2/2] Add /proc/PID/{smaps, numa_maps} support for DAX
Date: Thu, 26 Oct 2017 16:31:33 +0200
Message-ID: <20171026143133.7rm5wcgikjgmx4sc@dhcp22.suse.cz>
References: <1508891255-15427-1-git-send-email-fan.du@intel.com>
 <1508891255-15427-2-git-send-email-fan.du@intel.com>
 <20171025093045.s3rpcuovld22bhqu@dhcp22.suse.cz>
 <1f673f36-74b0-3321-32a4-a8031d5f268a@intel.com>
 <20171026141604.susqkaniglc5aqw2@dhcp22.suse.cz>
 <97774073-1df0-328a-68f8-f59667bce168@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <97774073-1df0-328a-68f8-f59667bce168-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dave Hansen <dave.hansen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Fan Du <fan.du-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, hch-jcswGhMUV9g@public.gmane.org, dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Thu 26-10-17 07:24:14, Dave Hansen wrote:
> On 10/26/2017 07:16 AM, Michal Hocko wrote:
> >> The original motivation was for DAX.  They have parallel large page
> >> infrastructure separate from hugetlbfs and THP.  Their constraints about
> >> when they can use large pages differ from the normal mm cases, so it is
> >> hard to tell when large pages are in use.  For instance, the file on
> >> *disk* has to be 2MB contiguous and aligned to map with 2MB pages even
> >> if the mmap() address is >2MB and 2MB-aligned.
> > 
> > I assume there is some tool which is going to use this information?
> 
> Actually, I don't remember whether it was tooling or just confused
> humans.  I *think* Dan was trying to write test cases for huge page DAX
> support and couldn't figure out whether or not it was using large pages.

That sounds like a very weak justification to adding new stuff to smaps
to be honest.

> >> But, in general, this seems like the thing that we probably should have
> >> done in the first place for THP.  It's a lot more generic and does not
> >> require someone reading the file to know what the particular
> >> architecture's page sizes are.
> > 
> > I fully agree. This just shows how single usecase focus driven smaps
> > file was. That is why I am asking about usecases when somebody want to
> > try yet another special field there. Smaps has become a dump of of
> > special cases which is not really easy to understand and so people tend
> > to use it incorrectly.
> 
> We just have to be careful not to cram use-cases into the existing
> fields which might make them meaningless.  I fear that Fan Du's latest
> patches do that.

Not only that. There have been reports that reading smaps is too
expensive. Curiously enough the overhead doesn't come up from
the data collection but rather copying to the userspace. So we should be
careful to not print data that is not of general use.

-- 
Michal Hocko
SUSE Labs
