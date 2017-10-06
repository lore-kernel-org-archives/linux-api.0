From: Dave Hansen <dave.hansen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCHv2 1/2] mm: Introduce wrappers to access mm->nr_ptes
Date: Fri, 6 Oct 2017 16:10:31 -0700
Message-ID: <7e476fd2-5818-c395-cdf2-00b5229c1a73@intel.com>
References: <20171005101442.49555-1-kirill.shutemov@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171005101442.49555-1-kirill.shutemov-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Content-Language: en-US
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Kirill A. Shutemov" <kirill.shutemov-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On 10/05/2017 03:14 AM, Kirill A. Shutemov wrote:
> +++ b/arch/sparc/mm/hugetlbpage.c
> @@ -396,7 +396,7 @@ static void hugetlb_free_pte_range(struct mmu_gather *tlb, pmd_t *pmd,
>  
>  	pmd_clear(pmd);
>  	pte_free_tlb(tlb, token, addr);
> -	atomic_long_dec(&tlb->mm->nr_ptes);
> +	mm_dec_nr_ptes(tlb->mm);
>  }

If we're going to go replace all of these, I wonder if we should start
doing it more generically.

	mm_dec_nr_pgtable(PGTABLE_PTE, tlb->mm)

or even:

	mm_dec_nr_pgtable(PGTABLE_LEVEL1, tlb->mm)

Instead of having a separate batch of functions for each level.
