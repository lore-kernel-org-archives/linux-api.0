From: Yu-cheng Yu <yu-cheng.yu@intel.com>
Subject: Re: [RFC PATCH v2 16/27] mm: Modify can_follow_write_pte/pmd for
 shadow stack
Date: Wed, 11 Jul 2018 10:05:31 -0700
Message-ID: <1531328731.15351.3.camel@intel.com>
References: <20180710222639.8241-1-yu-cheng.yu@intel.com>
         <20180710222639.8241-17-yu-cheng.yu@intel.com>
         <de510df6-7ea9-edc6-9c49-2f80f16472b4@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <de510df6-7ea9-edc6-9c49-2f80f16472b4@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, linux-mm@kvack.org, linux-arch@vger.kernel.org, linux-api@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>, Andy Lutomirski <luto@amacapital.net>, Balbir Singh <bsingharora@gmail.com>, Cyrill Gorcunov <gorcunov@gmail.com>, Florian Weimer <fweimer@redhat.com>, "H.J. Lu" <hjl.tools@gmail.com>, Jann Horn <jannh@google.com>, Jonathan Corbet <corbet@lwn.net>, Kees Cook <keescook@chromiun.org>, Mike Kravetz <mike.kravetz@oracle.com>, Nadav Amit <nadav.amit@gmail.com>, Oleg Nesterov <oleg@redhat.com>, Pavel Machek <pavel@ucw.cz>Peter
List-Id: linux-api@vger.kernel.org

On Tue, 2018-07-10 at 16:37 -0700, Dave Hansen wrote:
> On 07/10/2018 03:26 PM, Yu-cheng Yu wrote:
> > 
> > There are three possible shadow stack PTE settings:
> > 
> >   Normal SHSTK PTE: (R/O + DIRTY_HW)
> >   SHSTK PTE COW'ed: (R/O + DIRTY_HW)
> >   SHSTK PTE shared as R/O data: (R/O + DIRTY_SW)
> > 
> > Update can_follow_write_pte/pmd for the shadow stack.
> First of all, thanks for the excellent patch headers.  It's nice to
> have
> that reference every time even though it's repeated.
> 
> > 
> > -static inline bool can_follow_write_pte(pte_t pte, unsigned int
> > flags)
> > +static inline bool can_follow_write_pte(pte_t pte, unsigned int
> > flags,
> > +					bool shstk)
> >  {
> > +	bool pte_cowed = shstk ? is_shstk_pte(pte):pte_dirty(pte);
> > +
> >  	return pte_write(pte) ||
> > -		((flags & FOLL_FORCE) && (flags & FOLL_COW) &&
> > pte_dirty(pte));
> > +		((flags & FOLL_FORCE) && (flags & FOLL_COW) &&
> > pte_cowed);
> >  }
> Can we just pass the VMA in here?  This use is OK-ish, but I
> generally
> detest true/false function arguments because you can't tell what they
> are when they show up without a named variable.
> 
> But...  Why does this even matter?  Your own example showed that all
> shadowstack PTEs have either DIRTY_HW or DIRTY_SW set, and
> pte_dirty()
> checks both.
> 
> That makes this check seem a bit superfluous.

My understanding is that we don't want to follow write pte if the page
is shared as read-only.  For a SHSTK page, that is (R/O + DIRTY_SW),
which means the SHSTK page has not been COW'ed.  Is that right?

Thanks,
Yu-cheng
