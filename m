From: Michal Hocko <mhocko@kernel.org>
Subject: Re: [PATCH] mm/madvise: allow MADV_DONTNEED to free memory that is
 MLOCK_ONFAULT
Date: Mon, 11 Jun 2018 17:03:30 +0200
Message-ID: <20180611150330.GQ13364@dhcp22.suse.cz>
References: <1528484212-7199-1-git-send-email-jbaron@akamai.com>
 <20180611072005.GC13364@dhcp22.suse.cz>
 <4c4de46d-c55a-99a8-469f-e1e634fb8525@akamai.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4c4de46d-c55a-99a8-469f-e1e634fb8525@akamai.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jason Baron <jbaron@akamai.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, Vlastimil Babka <vbabka@suse.cz>, Joonsoo Kim <iamjoonsoo.kim@lge.com>, Mel Gorman <mgorman@suse.de>, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>, linux-api@vger.kernel.org, emunson@mgebm.net
List-Id: linux-api@vger.kernel.org

On Mon 11-06-18 10:51:44, Jason Baron wrote:
> On 06/11/2018 03:20 AM, Michal Hocko wrote:
> > [CCing linux-api - please make sure to CC this mailing list anytime you
> >  are touching user visible apis]
> > 
> > On Fri 08-06-18 14:56:52, Jason Baron wrote:
> >> In order to free memory that is marked MLOCK_ONFAULT, the memory region
> >> needs to be first unlocked, before calling MADV_DONTNEED. And if the region
> >> is to be reused as MLOCK_ONFAULT, we require another call to mlock2() with
> >> the MLOCK_ONFAULT flag.
> >>
> >> Let's simplify freeing memory that is set MLOCK_ONFAULT, by allowing
> >> MADV_DONTNEED to work directly for memory that is set MLOCK_ONFAULT.
> > 
> > I do not understand the point here. How is MLOCK_ONFAULT any different
> > from the regular mlock here? If you want to free mlocked memory then
> > fine but the behavior should be consistent. MLOCK_ONFAULT is just a way
> > to say that we do not want to pre-populate the mlocked area and do that
> > lazily on the page fault time. madvise should make any difference here.
> >
> 
> The difference for me is after the page has been freed, MLOCK_ONFAULT
> will re-populate the range if its accessed again. Whereas with regular
> mlock I don't think it will because its normally done at mlock() or
> mmap() time.

The vma would still be locked so we would effectively turn it into
ONFAULT IIRC.

> In any case, the state of a region being locked with
> regular mlock and pages not present does not currently exist, whereas it
> does for MLOCK_ONFAULT, so it seems more natural to do it only for
> MLOCK_ONFAULT. Finally, the use-case we had for this, didn't need
> regular mlock().

So can we start discussing whether we want to allow MADV_DONTNEED on
mlocked areas and what downsides it might have? Sure it would turn the
strong mlock guarantee to have the whole vma resident but is this
acceptable for something that is an explicit request from the owner of
the memory?
-- 
Michal Hocko
SUSE Labs
