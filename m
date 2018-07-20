From: Yu-cheng Yu <yu-cheng.yu@intel.com>
Subject: Re: [RFC PATCH v2 14/27] mm: Handle THP/HugeTLB shadow stack page
 fault
Date: Fri, 20 Jul 2018 07:58:08 -0700
Message-ID: <1532098688.23487.0.camel@intel.com>
References: <20180710222639.8241-1-yu-cheng.yu@intel.com>
         <20180710222639.8241-15-yu-cheng.yu@intel.com>
         <adc8f0b0-e2a5-d3e9-edaf-8d5b3be6a5b6@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <adc8f0b0-e2a5-d3e9-edaf-8d5b3be6a5b6@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, linux-mm@kvack.org, linux-arch@vger.kernel.org, linux-api@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>, Andy Lutomirski <luto@amacapital.net>, Balbir Singh <bsingharora@gmail.com>, Cyrill Gorcunov <gorcunov@gmail.com>, Florian Weimer <fweimer@redhat.com>, "H.J. Lu" <hjl.tools@gmail.com>, Jann Horn <jannh@google.com>, Jonathan Corbet <corbet@lwn.net>, Kees Cook <keescook@chromiun.org>, Mike Kravetz <mike.kravetz@oracle.com>, Nadav Amit <nadav.amit@gmail.com>, Oleg Nesterov <oleg@redhat.com>, Pavel Machek <pavel@ucw.cz>Peter
List-Id: linux-api@vger.kernel.org

On Fri, 2018-07-20 at 07:20 -0700, Dave Hansen wrote:
> On 07/10/2018 03:26 PM, Yu-cheng Yu wrote:
> > 
> > @@ -1193,6 +1195,8 @@ static int
> > do_huge_pmd_wp_page_fallback(struct vm_fault *vmf, pmd_t orig_pmd,
> >  		pte_t entry;
> >  		entry = mk_pte(pages[i], vma->vm_page_prot);
> >  		entry = maybe_mkwrite(pte_mkdirty(entry), vma);
> > +		if (is_shstk_mapping(vma->vm_flags))
> > +			entry = pte_mkdirty_shstk(entry);
> Peter Z was pointing out that we should get rid of all this generic
> code
> manipulation.  We might not easily be able to do it *all*, but we
> can do
> better than what we've got here.
> 
> Basically, if you have code outside of arch/x86 in your patch set
> that
> refers to shadow stacks, you should consider it a bug (for now),
> especially if you have to hack .c files.
> 
> For instance, in the code above, you could move the
> is_shstk_mapping() into:
> 
> static inline pte_t maybe_mkwrite(pte_t pte, struct vm_area_struct
> *vma)
> {
>         if (likely(vma->vm_flags & VM_WRITE))
>                 pte = pte_mkwrite(pte);
> 	
> +	pte = arch_pte_mkwrite(pte, vma);
> +
>         return pte;
> }
> 
> ... and add an arch callback that does:
> 
> static inline pte_t maybe_mkwrite(pte_t pte, struct vm_area_struct
> *vma)
> {
> 	if (!is_shstk_mapping(vma->vm_flags))
> 		return pte;
> 
> 	WARN_ON(... pte bits incompatible with shadow stacks?);
> 
> 	/* Lots of comments of course */
> 	entry = pte_mkdirty_shstk(entry);
> }
> 
> This is just one example.  You are probably going to need a couple
> of
> similar things.  Just remember: the bar is very high to make changes
> to
> .c files outside of arch/x86.  You can do a _bit_ more in non-x86
> headers, but you have the most freedom to patch what you want as
> long as
> it's in arch/x86.

Ok, I will work on that.  Thanks!

Yu-cheng
