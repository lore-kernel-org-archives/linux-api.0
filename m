From: Christian Borntraeger <borntraeger@de.ibm.com>
Subject: Re: [PATCH 1/5] mm/vmalloc: query dynamic DEBUG_PAGEALLOC setting
Date: Thu, 4 Feb 2016 09:32:14 +0100
Message-ID: <56B30C8E.200@de.ibm.com>
References: <1454565386-10489-1-git-send-email-iamjoonsoo.kim@lge.com>
 <1454565386-10489-2-git-send-email-iamjoonsoo.kim@lge.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: 7bit
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <1454565386-10489-2-git-send-email-iamjoonsoo.kim@lge.com>
Sender: owner-linux-mm@kvack.org
To: Joonsoo Kim <js1304@gmail.com>, Andrew Morton <akpm@linux-foundation.org>
Cc: David Rientjes <rientjes@google.com>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Takashi Iwai <tiwai@suse.com>, Chris Metcalf <cmetcalf@ezchip.com>, Christoph Lameter <cl@linux.com>, linux-api@vger.kernel.org, Joonsoo Kim <iamjoonsoo.kim@lge.com>
List-Id: linux-api@vger.kernel.org

On 02/04/2016 06:56 AM, Joonsoo Kim wrote:
> We can disable debug_pagealloc processing even if the code is complied
> with CONFIG_DEBUG_PAGEALLOC. This patch changes the code to query
> whether it is enabled or not in runtime.
> 
> Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>

Reviewed-by: Christian Borntraeger <borntraeger@de.ibm.com>


> ---
>  mm/vmalloc.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/mm/vmalloc.c b/mm/vmalloc.c
> index fb42a5b..e0e51bd 100644
> --- a/mm/vmalloc.c
> +++ b/mm/vmalloc.c
> @@ -543,10 +543,10 @@ static void vmap_debug_free_range(unsigned long start, unsigned long end)
>  	 * debugging doesn't do a broadcast TLB flush so it is a lot
>  	 * faster).
>  	 */
> -#ifdef CONFIG_DEBUG_PAGEALLOC
> -	vunmap_page_range(start, end);
> -	flush_tlb_kernel_range(start, end);
> -#endif
> +	if (debug_pagealloc_enabled()) {
> +		vunmap_page_range(start, end);
> +		flush_tlb_kernel_range(start, end);
> +	}
>  }
> 
>  /*
> 

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
