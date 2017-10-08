From: "Kirill A. Shutemov" <kirill@shutemov.name>
Subject: Re: [PATCHv2 1/2] mm: Introduce wrappers to access mm->nr_ptes
Date: Sun, 8 Oct 2017 15:54:49 +0300
Message-ID: <20171008125449.kgzjilgxzbropewj@node.shutemov.name>
References: <20171005101442.49555-1-kirill.shutemov@linux.intel.com>
 <7e476fd2-5818-c395-cdf2-00b5229c1a73@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <7e476fd2-5818-c395-cdf2-00b5229c1a73@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Dave Hansen <dave.hansen@intel.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>, Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, Michal Hocko <mhocko@kernel.org>
List-Id: linux-api@vger.kernel.org

On Fri, Oct 06, 2017 at 04:10:31PM -0700, Dave Hansen wrote:
> On 10/05/2017 03:14 AM, Kirill A. Shutemov wrote:
> > +++ b/arch/sparc/mm/hugetlbpage.c
> > @@ -396,7 +396,7 @@ static void hugetlb_free_pte_range(struct mmu_gather *tlb, pmd_t *pmd,
> >  
> >  	pmd_clear(pmd);
> >  	pte_free_tlb(tlb, token, addr);
> > -	atomic_long_dec(&tlb->mm->nr_ptes);
> > +	mm_dec_nr_ptes(tlb->mm);
> >  }
> 
> If we're going to go replace all of these, I wonder if we should start
> doing it more generically.
> 
> 	mm_dec_nr_pgtable(PGTABLE_PTE, tlb->mm)
> 
> or even:
> 
> 	mm_dec_nr_pgtable(PGTABLE_LEVEL1, tlb->mm)
> 
> Instead of having a separate batch of functions for each level.

We don't have this kind of consolidation for any other page table related
helpers. Don't see a reason to start here.

This kind of changes can be part of overal page table privitives redesign
once/if we get there.

But feel free to send patches. :)

-- 
 Kirill A. Shutemov
