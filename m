From: Joonsoo Kim <js1304-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 2/2] mm/page_ref: add tracepoint to track down page
 reference manipulation
Date: Mon, 15 Feb 2016 23:18:42 +0900
Message-ID: <CAAmzW4Nwe45dn5iPKmK_t1F6=+d1K4xqHAn+CfTxL6uvsxQhqw@mail.gmail.com>
References: <1455505490-12376-1-git-send-email-iamjoonsoo.kim@lge.com>
	<1455505490-12376-2-git-send-email-iamjoonsoo.kim@lge.com>
	<20160215050858.GA556@swordfish>
	<20160215052855.GA2010@swordfish>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160215052855.GA2010@swordfish>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sergey Senozhatsky <sergey.senozhatsky.work-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Michal Nazarewicz <mina86-deATy8a+UHjQT0dZR+AlfA@public.gmane.org>, Minchan Kim <minchan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Mel Gorman <mgorman-3eNAlZScCAx27rWaFMvyedHuzzzSOjJt@public.gmane.org>, Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>, "Kirill A. Shutemov" <kirill.shutemov-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Linux Memory Management List <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Joonsoo Kim <iamjoonsoo.kim-Hm3cg6mZ9cc@public.gmane.org>
List-Id: linux-api@vger.kernel.org

2016-02-15 14:28 GMT+09:00 Sergey Senozhatsky
<sergey.senozhatsky.work-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>:
> On (02/15/16 14:08), Sergey Senozhatsky wrote:
>>
>> will this compile with !CONFIG_TRACEPOINTS config?
>>

Yes, even if !CONFIG_TRACEPOINTS, it is compiled well.

> uh.. sorry, was composed in email client. seems the correct way to do it is
>
> +#if defined CONFIG_DEBUG_PAGE_REF && defined CONFIG_TRACEPOINTS
>
>  #include <linux/tracepoint-defs.h>
>
>  #define page_ref_tracepoint_active(t) static_key_false(&(t).key)
>
>  extern struct tracepoint __tracepoint_page_ref_set;
>  ...
>
>  extern void __page_ref_set(struct page *page, int v);
>  ...
>
> #else
>
>  #define page_ref_tracepoint_active(t) false
>
>  static inline void __page_ref_set(struct page *page, int v)
>  {
>  }
>  ...
>
> #endif
>
>
>
> or add a dependency of PAGE_REF on CONFIG_TRACEPOINTS in Kconfig.

Thanks for catching it.
I will add "depends on CONFIG_TRACEPOINTS" to Kconfig because
this feature has no meaning if !CONFIG_TRACEPOINTS.


Thanks.
