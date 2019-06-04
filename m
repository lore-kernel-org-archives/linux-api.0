From: Minchan Kim <minchan@kernel.org>
Subject: Re: [PATCH v1 3/4] mm: account nr_isolated_xxx in
 [isolate|putback]_lru_page
Date: Tue, 4 Jun 2019 13:51:46 +0900
Message-ID: <20190604045146.GD43390@google.com>
References: <20190604042047.13492-1-hdanton@sina.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190604042047.13492-1-hdanton@sina.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Hillf Danton <hdanton@sina.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>, "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>, Michal Hocko <mhocko@suse.com>, Johannes Weiner <hannes@cmpxchg.org>, Tim Murray <timmurray@google.com>, Joel Fernandes <joel@joelfernandes.org>, Suren Baghdasaryan <surenb@google.com>, Daniel Colascione <dancol@google.com>, Shakeel Butt <shakeelb@google.com>, Sonny Rao <sonnyrao@google.com>, Brian Geffon <bgeffon@google.com>, "jannh@google.com" <jannh@google.com>, "oleg@redhat.com" <oleg@redhat.com>, "christian@brauner.io" <christian@brauner.io>, "oleksandr@redhat.com" <oleksandr@redhat.com>
List-Id: linux-api@vger.kernel.org

Hi Hillf,

On Tue, Jun 04, 2019 at 12:20:47PM +0800, Hillf Danton wrote:
> 
> Hi Minchan
> 
> On Mon, 3 Jun 2019 13:37:27 +0800 Minchan Kim wrote:
> > @@ -1181,10 +1179,17 @@ static ICE_noinline int unmap_and_move(new_page_t get_new_page,
> >  		return -ENOMEM;
> > 
> >  	if (page_count(page) == 1) {
> > +		bool is_lru = !__PageMovable(page);
> > +
> >  		/* page was freed from under us. So we are done. */
> >  		ClearPageActive(page);
> >  		ClearPageUnevictable(page);
> > -		if (unlikely(__PageMovable(page))) {
> > +		if (likely(is_lru))
> > +			mod_node_page_state(page_pgdat(page),
> > +						NR_ISOLATED_ANON +
> > +						page_is_file_cache(page),
> > +						hpage_nr_pages(page));

That should be -hpage_nr_pages(page). It's a bug.

> > +		else {
> >  			lock_page(page);
> >  			if (!PageMovable(page))
> >  				__ClearPageIsolated(page);
> 
> As this page will go down the path only through the MIGRATEPAGE_SUCCESS branches,
> with no putback ahead, the current code is, I think, doing right things for this
> work to keep isolated stat balanced.

I guess that's the one you pointed out. Right?
Thanks for the review!

> 
> > @@ -1210,15 +1215,6 @@ static ICE_noinline int unmap_and_move(new_page_t get_new_page,
> >  		 * restored.
> >  		 */
> >  		list_del(&page->lru);
> > -
> > -		/*
> > -		 * Compaction can migrate also non-LRU pages which are
> > -		 * not accounted to NR_ISOLATED_*. They can be recognized
> > -		 * as __PageMovable
> > -		 */
> > -		if (likely(!__PageMovable(page)))
> > -			mod_node_page_state(page_pgdat(page), NR_ISOLATED_ANON +
> > -					page_is_file_cache(page), -hpage_nr_pages(page));
> >  	}
> > 
> 
> BR
> Hillf
> 
