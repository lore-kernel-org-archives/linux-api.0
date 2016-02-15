From: Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>
Subject: Re: [PATCH 2/2] mm/page_ref: add tracepoint to track down page
 reference manipulation
Date: Mon, 15 Feb 2016 14:08:58 +0900
Message-ID: <20160215050858.GA556@swordfish>
References: <1455505490-12376-1-git-send-email-iamjoonsoo.kim@lge.com>
 <1455505490-12376-2-git-send-email-iamjoonsoo.kim@lge.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <owner-linux-mm@kvack.org>
Content-Disposition: inline
In-Reply-To: <1455505490-12376-2-git-send-email-iamjoonsoo.kim@lge.com>
Sender: owner-linux-mm@kvack.org
To: js1304@gmail.com
Cc: Andrew Morton <akpm@linux-foundation.org>, Michal Nazarewicz <mina86@mina86.com>, Minchan Kim <minchan@kernel.org>, Mel Gorman <mgorman@techsingularity.net>, Vlastimil Babka <vbabka@suse.cz>, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>, Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>, Steven Rostedt <rostedt@goodmis.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, Joonsoo Kim <iamjoonsoo.kim@lge.com>
List-Id: linux-api@vger.kernel.org

Hello Joonsoo,

On (02/15/16 12:04), js1304@gmail.com wrote:
[..]
> <...>-9018  [004]    92.678375: page_ref_set:         pfn=0x17ac9 flags=0x0 count=1 mapcount=0 mapping=(nil) mt=4 val=1
> <...>-9018  [004]    92.678378: kernel_stack:
>  => get_page_from_freelist (ffffffff81176659)
>  => __alloc_pages_nodemask (ffffffff81176d22)
>  => alloc_pages_vma (ffffffff811bf675)
>  => handle_mm_fault (ffffffff8119e693)
>  => __do_page_fault (ffffffff810631ea)
>  => trace_do_page_fault (ffffffff81063543)
>  => do_async_page_fault (ffffffff8105c40a)
>  => async_page_fault (ffffffff817581d8)
> [snip]
> <...>-9018  [004]    92.678379: page_ref_mod:         pfn=0x17ac9 flags=0x40048 count=2 mapcount=1 mapping=0xffff880015a78dc1 mt=4 val=1
> [snip]
[..]
> o Print human-readable page flag through show_page_flags()

not even a nitpick, just for note, the examples don't use show_page_flags().


[..]
> diff --git a/include/linux/page_ref.h b/include/linux/page_ref.h
> index 534249c..fd6d9a5 100644
> --- a/include/linux/page_ref.h
> +++ b/include/linux/page_ref.h
> @@ -1,6 +1,54 @@
>  #include <linux/atomic.h>
>  #include <linux/mm_types.h>
>  #include <linux/page-flags.h>

will this compile with !CONFIG_TRACEPOINTS config?

+#ifdef CONFIG_TRACEPOINTS
 #include <linux/tracepoint-defs.h>

 extern struct tracepoint __tracepoint_page_ref_set;
 extern struct tracepoint __tracepoint_page_ref_mod;
 extern struct tracepoint __tracepoint_page_ref_mod_and_test;
 extern struct tracepoint __tracepoint_page_ref_mod_and_return;
 extern struct tracepoint __tracepoint_page_ref_mod_unless;
 extern struct tracepoint __tracepoint_page_ref_freeze;
 extern struct tracepoint __tracepoint_page_ref_unfreeze;

 #ifdef CONFIG_DEBUG_PAGE_REF
 #define page_ref_tracepoint_active(t) static_key_false(&(t).key)

 extern void __page_ref_set(struct page *page, int v);
 extern void __page_ref_mod(struct page *page, int v);
 extern void __page_ref_mod_and_test(struct page *page, int v, int ret);
 extern void __page_ref_mod_and_return(struct page *page, int v, int ret);
 extern void __page_ref_mod_unless(struct page *page, int v, int u);
 extern void __page_ref_freeze(struct page *page, int v, int ret);
 extern void __page_ref_unfreeze(struct page *page, int v);

 #else

 #define page_ref_tracepoint_active(t) false

 static inline void __page_ref_set(struct page *page, int v)
 {
 }
 static inline void __page_ref_mod(struct page *page, int v)
 {
 }
 static inline void __page_ref_mod_and_test(struct page *page, int v, int ret)
 {
 }
 static inline void __page_ref_mod_and_return(struct page *page, int v, int ret)
 {
 }
 static inline void __page_ref_mod_unless(struct page *page, int v, int u)
 {
 }
 static inline void __page_ref_freeze(struct page *page, int v, int ret)
 {
 }
 static inline void __page_ref_unfreeze(struct page *page, int v)
 {
 }

 #endif /* CONFIG_DEBUG_PAGE_REF */

+#endif /* CONFIG_TRACEPOINTS */

	-ss

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
