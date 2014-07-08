From: Zhang Yanfei <zhangyanfei-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>
Subject: Re: [PATCH v11 2/7] x86: add pmd_[dirty|mkclean] for THP
Date: Tue, 8 Jul 2014 14:25:51 +0800
Message-ID: <53BB8EEF.6050101@cn.fujitsu.com>
References: <1404799424-1120-1-git-send-email-minchan@kernel.org> <1404799424-1120-3-git-send-email-minchan@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1404799424-1120-3-git-send-email-minchan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Minchan Kim <minchan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Rik van Riel <riel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, KOSAKI Motohiro <kosaki.motohiro-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>, Jason Evans <je-b10kYP2dOMg@public.gmane.org>, "Kirill A. Shutemov" <kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
List-Id: linux-api@vger.kernel.org

On 07/08/2014 02:03 PM, Minchan Kim wrote:
> MADV_FREE needs pmd_dirty and pmd_mkclean for detecting recent
> overwrite of the contents since MADV_FREE syscall is called for
> THP page.
> 
> This patch adds pmd_dirty and pmd_mkclean for THP page MADV_FREE
> support.
> 
> Cc: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
> Cc: Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> Cc: "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
> Cc: x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
> Acked-by: Kirill A. Shutemov <kirill.shutemov-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
> Signed-off-by: Minchan Kim <minchan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

Acked-by: Zhang Yanfei <zhangyanfei-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>

> ---
>  arch/x86/include/asm/pgtable.h | 10 ++++++++++
>  1 file changed, 10 insertions(+)
> 
> diff --git a/arch/x86/include/asm/pgtable.h b/arch/x86/include/asm/pgtable.h
> index 0ec056012618..329865799653 100644
> --- a/arch/x86/include/asm/pgtable.h
> +++ b/arch/x86/include/asm/pgtable.h
> @@ -104,6 +104,11 @@ static inline int pmd_young(pmd_t pmd)
>  	return pmd_flags(pmd) & _PAGE_ACCESSED;
>  }
>  
> +static inline int pmd_dirty(pmd_t pmd)
> +{
> +	return pmd_flags(pmd) & _PAGE_DIRTY;
> +}
> +
>  static inline int pte_write(pte_t pte)
>  {
>  	return pte_flags(pte) & _PAGE_RW;
> @@ -267,6 +272,11 @@ static inline pmd_t pmd_mkold(pmd_t pmd)
>  	return pmd_clear_flags(pmd, _PAGE_ACCESSED);
>  }
>  
> +static inline pmd_t pmd_mkclean(pmd_t pmd)
> +{
> +	return pmd_clear_flags(pmd, _PAGE_DIRTY);
> +}
> +
>  static inline pmd_t pmd_wrprotect(pmd_t pmd)
>  {
>  	return pmd_clear_flags(pmd, _PAGE_RW);
> 


-- 
Thanks.
Zhang Yanfei
