From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v3 1/2] mm: introduce page reference manipulation
 functions
Date: Tue, 23 Feb 2016 15:32:44 -0800
Message-ID: <20160223153244.83a5c3ca430c4248a4a34cc0@linux-foundation.org>
References: <1456212078-22732-1-git-send-email-iamjoonsoo.kim@lge.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <1456212078-22732-1-git-send-email-iamjoonsoo.kim@lge.com>
Sender: owner-linux-mm@kvack.org
To: js1304@gmail.com
Cc: Michal Nazarewicz <mina86@mina86.com>, Minchan Kim <minchan@kernel.org>, Mel Gorman <mgorman@techsingularity.net>, Vlastimil Babka <vbabka@suse.cz>, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>, Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>, Steven Rostedt <rostedt@goodmis.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, Joonsoo Kim <iamjoonsoo.kim@lge.com>
List-Id: linux-api@vger.kernel.org

On Tue, 23 Feb 2016 16:21:17 +0900 js1304@gmail.com wrote:

> From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
> 
> Success of CMA allocation largely depends on success of migration
> and key factor of it is page reference count. Until now, page reference
> is manipulated by direct calling atomic functions so we cannot follow up
> who and where manipulate it. Then, it is hard to find actual reason
> of CMA allocation failure. CMA allocation should be guaranteed to succeed
> so finding offending place is really important.
> 
> In this patch, call sites where page reference is manipulated are converted
> to introduced wrapper function. This is preparation step to add tracepoint
> to each page reference manipulation function. With this facility, we can
> easily find reason of CMA allocation failure. There is no functional change
> in this patch.
> 
> ...
>
> --- a/arch/mips/mm/gup.c
> +++ b/arch/mips/mm/gup.c
> @@ -64,7 +64,7 @@ static inline void get_head_page_multiple(struct page *page, int nr)
>  {
>  	VM_BUG_ON(page != compound_head(page));
>  	VM_BUG_ON(page_count(page) == 0);
> -	atomic_add(nr, &page->_count);
> +	page_ref_add(page, nr);

Seems reasonable.  Those open-coded refcount manipulations have always
bugged me.

The patches will be a bit of a pain to maintain but surprisingly they
apply OK at present.  It's possible that by the time they hit upstream,
some direct ->_count references will still be present and it will
require a second pass to complete the conversion.

After that pass is completed I suggest we rename page._count to
something else (page.ref_count_dont_use_this_directly_you_dope?).  That
way, any attempts to later add direct page._count references will
hopefully break, alerting the programmer to the new regime.


--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
