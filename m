From: Michal Hocko <mhocko@kernel.org>
Subject: Re: [PATCH v4 3/5] [RFC] arm64: Add support for idle bit in swap PTE
Date: Tue, 6 Aug 2019 10:42:03 +0200
Message-ID: <20190806084203.GJ11812@dhcp22.suse.cz>
References: <20190805170451.26009-1-joel@joelfernandes.org>
 <20190805170451.26009-3-joel@joelfernandes.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190805170451.26009-3-joel@joelfernandes.org>
Sender: linux-kernel-owner@vger.kernel.org
To: "Joel Fernandes (Google)" <joel@joelfernandes.org>
Cc: linux-kernel@vger.kernel.org, Robin Murphy <robin.murphy@arm.com>, Alexey Dobriyan <adobriyan@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, Borislav Petkov <bp@alien8.de>, Brendan Gregg <bgregg@netflix.com>, Catalin Marinas <catalin.marinas@arm.com>, Christian Hansen <chansen3@cisco.com>, dancol@google.com, fmayer@google.com, "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>, joelaf@google.com, Jonathan Corbet <corbet@lwn.net>, Kees Cook <keescook@chromium.org>, kernel-team@android.com, linux-api@vger.kernel.org, linux-doc@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, Mike Rapoport <rppt@linux.ibm.com>, minchan@kernel.org, namhyung@google.com, paulmck@linux.ibm.com, Roman Gushchin <guro@fb.com>, Stephen
List-Id: linux-api@vger.kernel.org

On Mon 05-08-19 13:04:49, Joel Fernandes (Google) wrote:
> This bit will be used by idle page tracking code to correctly identify
> if a page that was swapped out was idle before it got swapped out.
> Without this PTE bit, we lose information about if a page is idle or not
> since the page frame gets unmapped.

And why do we need that? Why cannot we simply assume all swapped out
pages to be idle? They were certainly idle enough to be reclaimed,
right? Or what does idle actualy mean here?

> In this patch we reuse PTE_DEVMAP bit since idle page tracking only
> works on user pages in the LRU. Device pages should not consitute those
> so it should be unused and safe to use.
> 
> Cc: Robin Murphy <robin.murphy@arm.com>
> Signed-off-by: Joel Fernandes (Google) <joel@joelfernandes.org>
> ---
>  arch/arm64/Kconfig                    |  1 +
>  arch/arm64/include/asm/pgtable-prot.h |  1 +
>  arch/arm64/include/asm/pgtable.h      | 15 +++++++++++++++
>  3 files changed, 17 insertions(+)
> 
> diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
> index 3adcec05b1f6..9d1412c693d7 100644
> --- a/arch/arm64/Kconfig
> +++ b/arch/arm64/Kconfig
> @@ -128,6 +128,7 @@ config ARM64
>  	select HAVE_ARCH_MMAP_RND_BITS
>  	select HAVE_ARCH_MMAP_RND_COMPAT_BITS if COMPAT
>  	select HAVE_ARCH_PREL32_RELOCATIONS
> +	select HAVE_ARCH_PTE_SWP_PGIDLE
>  	select HAVE_ARCH_SECCOMP_FILTER
>  	select HAVE_ARCH_STACKLEAK
>  	select HAVE_ARCH_THREAD_STRUCT_WHITELIST
> diff --git a/arch/arm64/include/asm/pgtable-prot.h b/arch/arm64/include/asm/pgtable-prot.h
> index 92d2e9f28f28..917b15c5d63a 100644
> --- a/arch/arm64/include/asm/pgtable-prot.h
> +++ b/arch/arm64/include/asm/pgtable-prot.h
> @@ -18,6 +18,7 @@
>  #define PTE_SPECIAL		(_AT(pteval_t, 1) << 56)
>  #define PTE_DEVMAP		(_AT(pteval_t, 1) << 57)
>  #define PTE_PROT_NONE		(_AT(pteval_t, 1) << 58) /* only when !PTE_VALID */
> +#define PTE_SWP_PGIDLE		PTE_DEVMAP		 /* for idle page tracking during swapout */
>  
>  #ifndef __ASSEMBLY__
>  
> diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pgtable.h
> index 3f5461f7b560..558f5ebd81ba 100644
> --- a/arch/arm64/include/asm/pgtable.h
> +++ b/arch/arm64/include/asm/pgtable.h
> @@ -212,6 +212,21 @@ static inline pte_t pte_mkdevmap(pte_t pte)
>  	return set_pte_bit(pte, __pgprot(PTE_DEVMAP));
>  }
>  
> +static inline int pte_swp_page_idle(pte_t pte)
> +{
> +	return 0;
> +}
> +
> +static inline pte_t pte_swp_mkpage_idle(pte_t pte)
> +{
> +	return set_pte_bit(pte, __pgprot(PTE_SWP_PGIDLE));
> +}
> +
> +static inline pte_t pte_swp_clear_page_idle(pte_t pte)
> +{
> +	return clear_pte_bit(pte, __pgprot(PTE_SWP_PGIDLE));
> +}
> +
>  static inline void set_pte(pte_t *ptep, pte_t pte)
>  {
>  	WRITE_ONCE(*ptep, pte);
> -- 
> 2.22.0.770.g0f2c4a37fd-goog

-- 
Michal Hocko
SUSE Labs
