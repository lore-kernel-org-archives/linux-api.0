From: Yu-cheng Yu <yu-cheng.yu@intel.com>
Subject: Re: [RFC PATCH v2 14/27] mm: Handle THP/HugeTLB shadow stack page
 fault
Date: Wed, 11 Jul 2018 09:11:03 -0700
Message-ID: <1531325463.13297.30.camel@intel.com>
References: <20180710222639.8241-1-yu-cheng.yu@intel.com>
         <20180710222639.8241-15-yu-cheng.yu@intel.com>
         <20180711091022.GT2476@hirez.programming.kicks-ass.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180711091022.GT2476@hirez.programming.kicks-ass.net>
Sender: linux-kernel-owner@vger.kernel.org
To: Peter Zijlstra <peterz@infradead.org>
Cc: x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, linux-mm@kvack.org, linux-arch@vger.kernel.org, linux-api@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>, Andy Lutomirski <luto@amacapital.net>, Balbir Singh <bsingharora@gmail.com>, Cyrill Gorcunov <gorcunov@gmail.com>, Dave Hansen <dave.hansen@linux.intel.com>, Florian Weimer <fweimer@redhat.com>, "H.J. Lu" <hjl.tools@gmail.com>, Jann Horn <jannh@google.com>, Jonathan Corbet <corbet@lwn.net>, Kees Cook <keescook@chromiun.org>, Mike Kravetz <mike.kravetz@oracle.com>, Nadav Amit <nadav.amit@gmail.com>, Oleg Nesterov <oleg@redhat.com>, Pavel Machek <pavel@ucw.cz>, Ravi V. Shan
List-Id: linux-api@vger.kernel.org

On Wed, 2018-07-11 at 11:10 +0200, Peter Zijlstra wrote:
> On Tue, Jul 10, 2018 at 03:26:26PM -0700, Yu-cheng Yu wrote:
> > 
> > diff --git a/mm/memory.c b/mm/memory.c
> > index a2695dbc0418..f7c46d61eaea 100644
> > --- a/mm/memory.c
> > +++ b/mm/memory.c
> > @@ -4108,7 +4108,13 @@ static int __handle_mm_fault(struct
> > vm_area_struct *vma, unsigned long address,
> >  			if (pmd_protnone(orig_pmd) &&
> > vma_is_accessible(vma))
> >  				return do_huge_pmd_numa_page(&vmf,
> > orig_pmd);
> >  
> > -			if (dirty && !pmd_write(orig_pmd)) {
> > +			/*
> > +			 * Shadow stack trans huge PMDs are copy-
> > on-access,
> > +			 * so wp_huge_pmd() on them no mater if we
> > have a
> > +			 * write fault or not.
> > +			 */
> > +			if (is_shstk_mapping(vma->vm_flags) ||
> > +			    (dirty && !pmd_write(orig_pmd))) {
> >  				ret = wp_huge_pmd(&vmf, orig_pmd);
> >  				if (!(ret & VM_FAULT_FALLBACK))
> >  					return ret;
> Can't we do this (and the do_wp_page thing) by setting
> FAULT_FLAG_WRITE
> in the arch fault handler on shadow stack faults?

This can work.  I don't know if that will create other issues.
Let me think about that.

Yu-cheng
