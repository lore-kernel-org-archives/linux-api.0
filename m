From: Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>
Subject: Re: [PATCH 2/2] mm/page_ref: add tracepoint to track down page
 reference manipulation
Date: Thu, 18 Feb 2016 09:29:26 -0500
Message-ID: <20160218092926.083ca007@gandalf.local.home>
References: <1455505490-12376-1-git-send-email-iamjoonsoo.kim@lge.com>
	<1455505490-12376-2-git-send-email-iamjoonsoo.kim@lge.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1455505490-12376-2-git-send-email-iamjoonsoo.kim-Hm3cg6mZ9cc@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: js1304-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Michal Nazarewicz <mina86-deATy8a+UHjQT0dZR+AlfA@public.gmane.org>, Minchan Kim <minchan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Mel Gorman <mgorman-3eNAlZScCAx27rWaFMvyedHuzzzSOjJt@public.gmane.org>, Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>, "Kirill A. Shutemov" <kirill.shutemov-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Sergey Senozhatsky <sergey.senozhatsky.work-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Joonsoo Kim <iamjoonsoo.kim-Hm3cg6mZ9cc@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Mon, 15 Feb 2016 12:04:50 +0900
js1304-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org wrote:


> diff --git a/include/linux/page_ref.h b/include/linux/page_ref.h
> index 534249c..fd6d9a5 100644
> --- a/include/linux/page_ref.h
> +++ b/include/linux/page_ref.h
> @@ -1,6 +1,54 @@
>  #include <linux/atomic.h>
>  #include <linux/mm_types.h>
>  #include <linux/page-flags.h>
> +#include <linux/tracepoint-defs.h>
> +
> +extern struct tracepoint __tracepoint_page_ref_set;
> +extern struct tracepoint __tracepoint_page_ref_mod;
> +extern struct tracepoint __tracepoint_page_ref_mod_and_test;
> +extern struct tracepoint __tracepoint_page_ref_mod_and_return;
> +extern struct tracepoint __tracepoint_page_ref_mod_unless;
> +extern struct tracepoint __tracepoint_page_ref_freeze;
> +extern struct tracepoint __tracepoint_page_ref_unfreeze;
> +
> +#ifdef CONFIG_DEBUG_PAGE_REF

Please add a comment here. Something to the effect of:

/*
 * Ideally we would want to use the trace_<tracepoint>_enabled() helper
 * functions. But due to include header file issues, that is not
 * feasible. Instead we have to open code the static key functions.
 *
 * See trace_##name##_enabled(void) in include/linux/tracepoint.h
 */

I may have to work on something that lets these helpers be defined in
headers. I have some ideas on how to do that. But for now, this
solution is fine.

-- Steve


> +#define page_ref_tracepoint_active(t) static_key_false(&(t).key)
> +
> +extern void __page_ref_set(struct page *page, int v);
> +extern void __page_ref_mod(struct page *page, int v);
> +extern void __page_ref_mod_and_test(struct page *page, int v, int ret);
> +extern void __page_ref_mod_and_return(struct page *page, int v, int ret);
> +extern void __page_ref_mod_unless(struct page *page, int v, int u);
> +extern void __page_ref_freeze(struct page *page, int v, int ret);
> +extern void __page_ref_unfreeze(struct page *page, int v);
> +
> +#else
> +
> +#define page_ref_tracepoint_active(t) false
> +
> +static inline void __page_ref_set(struct page *page, int v)
> +{
> +}
> +static inline void __page_ref_mod(struct page *page, int v)
> +{
> +}
> +static inline void __page_ref_mod_and_test(struct page *page, int v, int ret)
> +{
> +}
> +static inline void __page_ref_mod_and_return(struct page *page, int v, int ret)
> +{
> +}
> +static inline void __page_ref_mod_unless(struct page *page, int v, int u)
> +{
> +}
> +static inline void __page_ref_freeze(struct page *page, int v, int ret)
> +{
> +}
> +static inline void __page_ref_unfreeze(struct page *page, int v)
> +{
> +}
> +
> +#endif
>  
>
