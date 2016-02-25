From: Joonsoo Kim <iamjoonsoo.kim-Hm3cg6mZ9cc@public.gmane.org>
Subject: Re: [PATCH v3 1/2] mm: introduce page reference manipulation
 functions
Date: Thu, 25 Feb 2016 09:34:55 +0900
Message-ID: <20160225003454.GB9723@js1304-P5Q-DELUXE>
References: <1456212078-22732-1-git-send-email-iamjoonsoo.kim@lge.com>
 <20160223153244.83a5c3ca430c4248a4a34cc0@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160223153244.83a5c3ca430c4248a4a34cc0-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Michal Nazarewicz <mina86-deATy8a+UHjQT0dZR+AlfA@public.gmane.org>, Minchan Kim <minchan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Mel Gorman <mgorman-3eNAlZScCAx27rWaFMvyedHuzzzSOjJt@public.gmane.org>, Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>, "Kirill A. Shutemov" <kirill.shutemov-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Sergey Senozhatsky <sergey.senozhatsky.work-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Tue, Feb 23, 2016 at 03:32:44PM -0800, Andrew Morton wrote:
> On Tue, 23 Feb 2016 16:21:17 +0900 js1304-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org wrote:
> 
> > From: Joonsoo Kim <iamjoonsoo.kim-Hm3cg6mZ9cc@public.gmane.org>
> > 
> > Success of CMA allocation largely depends on success of migration
> > and key factor of it is page reference count. Until now, page reference
> > is manipulated by direct calling atomic functions so we cannot follow up
> > who and where manipulate it. Then, it is hard to find actual reason
> > of CMA allocation failure. CMA allocation should be guaranteed to succeed
> > so finding offending place is really important.
> > 
> > In this patch, call sites where page reference is manipulated are converted
> > to introduced wrapper function. This is preparation step to add tracepoint
> > to each page reference manipulation function. With this facility, we can
> > easily find reason of CMA allocation failure. There is no functional change
> > in this patch.
> > 
> > ...
> >
> > --- a/arch/mips/mm/gup.c
> > +++ b/arch/mips/mm/gup.c
> > @@ -64,7 +64,7 @@ static inline void get_head_page_multiple(struct page *page, int nr)
> >  {
> >  	VM_BUG_ON(page != compound_head(page));
> >  	VM_BUG_ON(page_count(page) == 0);
> > -	atomic_add(nr, &page->_count);
> > +	page_ref_add(page, nr);
> 
> Seems reasonable.  Those open-coded refcount manipulations have always
> bugged me.

I think so.

> 
> The patches will be a bit of a pain to maintain but surprisingly they
> apply OK at present.  It's possible that by the time they hit upstream,
> some direct ->_count references will still be present and it will
> require a second pass to complete the conversion.

In fact, the patch doesn't change direct ->_count reference for
*read*. That's the reason that it is surprisingly OK at present.

It's a good idea to change direct ->_count reference even for read.
How about changing it in rc2 after mering this patch in rc1?

> After that pass is completed I suggest we rename page._count to
> something else (page.ref_count_dont_use_this_directly_you_dope?).  That
> way, any attempts to later add direct page._count references will
> hopefully break, alerting the programmer to the new regime.

Agreed.

Thanks.
