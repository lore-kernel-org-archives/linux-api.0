From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH v7 15/27] mm: Handle shadow stack page fault
Date: Fri, 7 Jun 2019 09:30:52 +0200
Message-ID: <20190607073052.GO3419@hirez.programming.kicks-ass.net>
References: <20190606200646.3951-1-yu-cheng.yu@intel.com>
 <20190606200646.3951-16-yu-cheng.yu@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190606200646.3951-16-yu-cheng.yu@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Yu-cheng Yu <yu-cheng.yu@intel.com>
Cc: x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, linux-mm@kvack.org, linux-arch@vger.kernel.org, linux-api@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>, Andy Lutomirski <luto@amacapital.net>, Balbir Singh <bsingharora@gmail.com>, Borislav Petkov <bp@alien8.de>, Cyrill Gorcunov <gorcunov@gmail.com>, Dave Hansen <dave.hansen@linux.intel.com>, Eugene Syromiatnikov <esyr@redhat.com>, Florian Weimer <fweimer@redhat.com>, "H.J. Lu" <hjl.tools@gmail.com>, Jann Horn <jannh@google.com>, Jonathan Corbet <corbet@lwn.net>, Kees Cook <keescook@chromium.org>, Mike Kravetz <mike.kravetz@oracle.com>, Nadav Amit <nadav.amit@gmail.com>
List-Id: linux-api@vger.kernel.org

On Thu, Jun 06, 2019 at 01:06:34PM -0700, Yu-cheng Yu wrote:

> diff --git a/include/asm-generic/pgtable.h b/include/asm-generic/pgtable.h
> index 75d9d68a6de7..ffcc0be7cadc 100644
> --- a/include/asm-generic/pgtable.h
> +++ b/include/asm-generic/pgtable.h
> @@ -1188,4 +1188,12 @@ static inline bool arch_has_pfn_modify_check(void)
>  #define mm_pmd_folded(mm)	__is_defined(__PAGETABLE_PMD_FOLDED)
>  #endif
>  
> +#ifndef CONFIG_ARCH_HAS_SHSTK
> +#define pte_set_vma_features(pte, vma) pte
> +#define arch_copy_pte_mapping(vma_flags) false

static inline pte_t pte_set_vma_features(pte_t pte, struct vm_area_struct *vma)
{
	return pte;
}

static inline bool arch_copy_pte_mapping(unsigned long vm_flags)
{
	return false;
}

Please, this way we retain function prototype checking.

> +#else
> +pte_t pte_set_vma_features(pte_t pte, struct vm_area_struct *vma);
> +bool arch_copy_pte_mapping(vm_flags_t vm_flags);
> +#endif
