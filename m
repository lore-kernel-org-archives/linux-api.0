From: Joonsoo Kim <iamjoonsoo.kim-Hm3cg6mZ9cc@public.gmane.org>
Subject: Re: [PATCH 1/2] mm: introduce page reference manipulation functions
Date: Tue, 10 Nov 2015 09:28:42 +0900
Message-ID: <20151110002842.GC13894@js1304-P5Q-DELUXE>
References: <1447053784-27811-1-git-send-email-iamjoonsoo.kim@lge.com>
 <20151109075337.GC472@swordfish>
 <CAAmzW4MugYCu1+ZsRp63o=26eTuJG22C+nNrGBhDJvQDOzbQJw@mail.gmail.com>
 <20151109114537.GA3903@node.shutemov.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20151109114537.GA3903-sVvlyX1904swdBt8bTSxpkEMvNT87kid@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Kirill A. Shutemov" <kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>
Cc: Sergey Senozhatsky <sergey.senozhatsky.work-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Michal Nazarewicz <mina86-deATy8a+UHjQT0dZR+AlfA@public.gmane.org>, Minchan Kim <minchan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>, Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>, "Kirill A. Shutemov" <kirill.shutemov-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Linux Memory Management List <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Mon, Nov 09, 2015 at 01:45:37PM +0200, Kirill A. Shutemov wrote:
> On Mon, Nov 09, 2015 at 05:00:32PM +0900, Joonsoo Kim wrote:
> > 2015-11-09 16:53 GMT+09:00 Sergey Senozhatsky
> > <sergey.senozhatsky.work-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>:
> > > Hi,
> > >
> > > On (11/09/15 16:23), Joonsoo Kim wrote:
> > > [..]
> > >> +static inline int page_count(struct page *page)
> > >> +{
> > >> +     return atomic_read(&compound_head(page)->_count);
> > >> +}
> > >> +
> > >> +static inline void set_page_count(struct page *page, int v)
> > >> +{
> > >> +     atomic_set(&page->_count, v);
> > >> +}
> > >> +
> > >> +/*
> > >> + * Setup the page count before being freed into the page allocator for
> > >> + * the first time (boot or memory hotplug)
> > >> + */
> > >> +static inline void init_page_count(struct page *page)
> > >> +{
> > >> +     set_page_count(page, 1);
> > >> +}
> > >> +
> > >> +static inline void page_ref_add(struct page *page, int nr)
> > >> +{
> > >> +     atomic_add(nr, &page->_count);
> > >> +}
> > >
> > > Since page_ref_FOO wrappers operate with page->_count and there
> > > are already page_count()/set_page_count()/etc. may be name new
> > > wrappers in page_count_FOO() manner?
> > 
> > Hello,
> > 
> > I used that page_count_ before but change my mind.
> > I think that ref is more relevant to this operation.
> > Perhaps, it'd be better to change page_count()/set_page_count()
> > to page_ref()/set_page_ref().
> 
> What about get_page() vs. page_cache_get() and put_page() vs.
> page_cache_release()? Two different helpers for the same thing is annyoing
> me for some time (plus PAGE_SIZE vs. PAGE_CACHE_SIZE, etc.).
> 
> If you want coherent API you might want to get them consitent too.

In fact, consistent naming is out of interest of this patchset. :)

Thanks.
