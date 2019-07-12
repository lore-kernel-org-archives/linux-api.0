From: Michal Hocko <mhocko@kernel.org>
Subject: Re: [PATCH v4 4/4] mm: introduce MADV_PAGEOUT
Date: Fri, 12 Jul 2019 17:01:27 +0200
Message-ID: <20190712150127.GV29483@dhcp22.suse.cz>
References: <20190711012528.176050-1-minchan@kernel.org>
 <20190711012528.176050-5-minchan@kernel.org>
 <20190711184223.GD20341@cmpxchg.org>
 <20190712051828.GA128252@google.com>
 <20190712135809.GB31107@cmpxchg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190712135809.GB31107@cmpxchg.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Minchan Kim <minchan@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>, linux-api@vger.kernel.org, Tim Murray <timmurray@google.com>, Joel Fernandes <joel@joelfernandes.org>, Suren Baghdasaryan <surenb@google.com>, Daniel Colascione <dancol@google.com>, Shakeel Butt <shakeelb@google.com>, Sonny Rao <sonnyrao@google.com>, oleksandr@redhat.com, hdanton@sina.com, lizeb@google.com, Dave Hansen <dave.hansen@intel.com>, "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>
List-Id: linux-api@vger.kernel.org

On Fri 12-07-19 09:58:09, Johannes Weiner wrote:
[...]
> > @@ -423,6 +445,12 @@ static int madvise_cold_pte_range(pmd_t *pmd, unsigned long addr,
> >  
> >  		VM_BUG_ON_PAGE(PageTransCompound(page), page);
> >  
> > +		if (pageout) {
> > +			if (isolate_lru_page(page))
> > +				continue;
> > +			list_add(&page->lru, &page_list);
> > +		}
> > +
> >  		if (pte_young(ptent)) {
> >  			ptent = ptep_get_and_clear_full(mm, addr, pte,
> >  							tlb->fullmm);
> 
> One thought on the ordering here.
> 
> When LRU isolation fails, it would still make sense to clear the young
> bit: we cannot reclaim the page as we wanted to, but the user still
> provided a clear hint that the page is cold and she won't be touching
> it for a while. MADV_PAGEOUT is basically MADV_COLD + try_to_reclaim.
> So IMO isolation should go to the end next to deactivate_page().

Make sense to me

-- 
Michal Hocko
SUSE Labs
