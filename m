From: Sergey Senozhatsky <sergey.senozhatsky.work-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 2/2] mm/page_ref: add tracepoint to track down page
 reference manipulation
Date: Fri, 19 Feb 2016 09:34:21 +0900
Message-ID: <20160219003421.GA587@swordfish>
References: <1455505490-12376-1-git-send-email-iamjoonsoo.kim@lge.com>
 <1455505490-12376-2-git-send-email-iamjoonsoo.kim@lge.com>
 <20160218092926.083ca007@gandalf.local.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160218092926.083ca007-f9ZlEuEWxVcJvu8Pb33WZ0EMvNT87kid@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>
Cc: js1304-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Michal Nazarewicz <mina86-deATy8a+UHjQT0dZR+AlfA@public.gmane.org>, Minchan Kim <minchan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Mel Gorman <mgorman-3eNAlZScCAx27rWaFMvyedHuzzzSOjJt@public.gmane.org>, Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>, "Kirill A. Shutemov" <kirill.shutemov-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Sergey Senozhatsky <sergey.senozhatsky.work-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Joonsoo Kim <iamjoonsoo.kim-Hm3cg6mZ9cc@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On (02/18/16 09:29), Steven Rostedt wrote:
> > diff --git a/include/linux/page_ref.h b/include/linux/page_ref.h
> > index 534249c..fd6d9a5 100644
> > --- a/include/linux/page_ref.h
> > +++ b/include/linux/page_ref.h
> > @@ -1,6 +1,54 @@
> >  #include <linux/atomic.h>
> >  #include <linux/mm_types.h>
> >  #include <linux/page-flags.h>
> > +#include <linux/tracepoint-defs.h>
> > +
> > +extern struct tracepoint __tracepoint_page_ref_set;
> > +extern struct tracepoint __tracepoint_page_ref_mod;
> > +extern struct tracepoint __tracepoint_page_ref_mod_and_test;
> > +extern struct tracepoint __tracepoint_page_ref_mod_and_return;
> > +extern struct tracepoint __tracepoint_page_ref_mod_unless;
> > +extern struct tracepoint __tracepoint_page_ref_freeze;
> > +extern struct tracepoint __tracepoint_page_ref_unfreeze;
> > +
> > +#ifdef CONFIG_DEBUG_PAGE_REF
> 
> Please add a comment here. Something to the effect of:
> 
> /*
>  * Ideally we would want to use the trace_<tracepoint>_enabled() helper
>  * functions. But due to include header file issues, that is not
>  * feasible. Instead we have to open code the static key functions.
>  *
>  * See trace_##name##_enabled(void) in include/linux/tracepoint.h
>  */
> 

not sure if it's worth mentioning in the comment, but the other
concern here is the performance impact of an extra function call,
I believe. otherwise, Joonsoo would just do:

in include/linux/page_ref.h

static inline void set_page_count(struct page *page, int v)
{
	atomic_set(&page->_count, v);
	__page_ref_set(page, v);
}
...



and in mm/debug_page_ref.c

void __page_ref_set(struct page *page, int v)
{
	if (trace_page_ref_set_enabled())
		trace_page_ref_set(page, v);
}
EXPORT_SYMBOL(__page_ref_set);
EXPORT_TRACEPOINT_SYMBOL(page_ref_set);
...

	-ss
