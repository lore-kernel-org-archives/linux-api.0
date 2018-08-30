From: Randy Dunlap <rdunlap@infradead.org>
Subject: Re: [RFC PATCH v3 12/24] x86/mm: Modify ptep_set_wrprotect and
 pmdp_set_wrprotect for _PAGE_DIRTY_SW
Date: Thu, 30 Aug 2018 12:59:21 -0700
Message-ID: <9879c17a-24da-d84a-5a7c-30bcbb473914@infradead.org>
References: <20180830143904.3168-1-yu-cheng.yu@intel.com>
 <20180830143904.3168-13-yu-cheng.yu@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180830143904.3168-13-yu-cheng.yu@intel.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Yu-cheng Yu <yu-cheng.yu@intel.com>, x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, linux-mm@kvack.org, linux-arch@vger.kernel.org, linux-api@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>, Andy Lutomirski <luto@amacapital.net>, Balbir Singh <bsingharora@gmail.com>, Cyrill Gorcunov <gorcunov@gmail.com>, Dave Hansen <dave.hansen@linux.intel.com>, Florian Weimer <fweimer@redhat.com>, "H.J. Lu" <hjl.tools@gmail.com>, Jann Horn <jannh@google.com>, Jonathan Corbet <corbet@lwn.net>, Kees Cook <keescook@chromiun.org>, Mike Kravetz <mike.kravetz@oracle.com>, Nadav Amit <nadav.amit@gmail.com>, Oleg Nesterov <oleg@redhat.com>, Pavel
List-Id: linux-api@vger.kernel.org

On 08/30/2018 07:38 AM, Yu-cheng Yu wrote:
> When Shadow Stack is enabled, the read-only and PAGE_DIRTY_HW PTE
> setting is reserved only for the Shadow Stack.  To track dirty of
> non-Shadow Stack read-only PTEs, we use PAGE_DIRTY_SW.
> 
> Update ptep_set_wrprotect() and pmdp_set_wrprotect().
> 
> Signed-off-by: Yu-cheng Yu <yu-cheng.yu@intel.com>
> ---
>  arch/x86/include/asm/pgtable.h | 42 ++++++++++++++++++++++++++++++++++
>  1 file changed, 42 insertions(+)
> 
> diff --git a/arch/x86/include/asm/pgtable.h b/arch/x86/include/asm/pgtable.h
> index 4d50de77ea96..556ef258eeff 100644
> --- a/arch/x86/include/asm/pgtable.h
> +++ b/arch/x86/include/asm/pgtable.h
> @@ -1203,7 +1203,28 @@ static inline pte_t ptep_get_and_clear_full(struct mm_struct *mm,
>  static inline void ptep_set_wrprotect(struct mm_struct *mm,
>  				      unsigned long addr, pte_t *ptep)
>  {
> +	pte_t pte;
> +
>  	clear_bit(_PAGE_BIT_RW, (unsigned long *)&ptep->pte);
> +	pte = *ptep;
> +
> +	/*
> +	 * Some processors can start a write, but ending up seeing

	                                      but end up seeing

> +	 * a read-only PTE by the time they get to the Dirty bit.
> +	 * In this case, they will set the Dirty bit, leaving a
> +	 * read-only, Dirty PTE which looks like a Shadow Stack PTE.
> +	 *
> +	 * However, this behavior has been improved and will not occur
> +	 * on processors supporting Shadow Stacks.  Without this
> +	 * guarantee, a transition to a non-present PTE and flush the
> +	 * TLB would be needed.
> +	 *
> +	 * When change a writable PTE to read-only and if the PTE has

	        changing

> +	 * _PAGE_DIRTY_HW set, we move that bit to _PAGE_DIRTY_SW so
> +	 * that the PTE is not a valid Shadow Stack PTE.
> +	 */
> +	pte = pte_move_flags(pte, _PAGE_DIRTY_HW, _PAGE_DIRTY_SW);
> +	set_pte_at(mm, addr, ptep, pte);
>  }
>  
>  #define flush_tlb_fix_spurious_fault(vma, address) do { } while (0)
> @@ -1266,7 +1287,28 @@ static inline pud_t pudp_huge_get_and_clear(struct mm_struct *mm,
>  static inline void pmdp_set_wrprotect(struct mm_struct *mm,
>  				      unsigned long addr, pmd_t *pmdp)
>  {
> +	pmd_t pmd;
> +
>  	clear_bit(_PAGE_BIT_RW, (unsigned long *)pmdp);
> +	pmd = *pmdp;
> +
> +	/*
> +	 * Some processors can start a write, but ending up seeing

	                                      but end up seeing

> +	 * a read-only PTE by the time they get to the Dirty bit.
> +	 * In this case, they will set the Dirty bit, leaving a
> +	 * read-only, Dirty PTE which looks like a Shadow Stack PTE.
> +	 *
> +	 * However, this behavior has been improved and will not occur
> +	 * on processors supporting Shadow Stacks.  Without this
> +	 * guarantee, a transition to a non-present PTE and flush the
> +	 * TLB would be needed.
> +	 *
> +	 * When change a writable PTE to read-only and if the PTE has

	        changing

> +	 * _PAGE_DIRTY_HW set, we move that bit to _PAGE_DIRTY_SW so
> +	 * that the PTE is not a valid Shadow Stack PTE.
> +	 */
> +	pmd = pmd_move_flags(pmd, _PAGE_DIRTY_HW, _PAGE_DIRTY_SW);
> +	set_pmd_at(mm, addr, pmdp, pmd);
>  }
>  
>  #define pud_write pud_write
> 


-- 
~Randy
