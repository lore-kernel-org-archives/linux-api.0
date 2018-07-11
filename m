From: Yu-cheng Yu <yu-cheng.yu@intel.com>
Subject: Re: [RFC PATCH v2 15/27] mm/mprotect: Prevent mprotect from
 changing shadow stack
Date: Wed, 11 Jul 2018 09:07:52 -0700
Message-ID: <1531325272.13297.27.camel@intel.com>
References: <20180710222639.8241-1-yu-cheng.yu@intel.com>
         <20180710222639.8241-16-yu-cheng.yu@intel.com>
         <04800c52-1f86-c485-ba7c-2216d8c4966f@linux.intel.com>
         <20180711091232.GU2476@hirez.programming.kicks-ass.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180711091232.GU2476@hirez.programming.kicks-ass.net>
Sender: linux-kernel-owner@vger.kernel.org
To: Peter Zijlstra <peterz@infradead.org>, Dave Hansen <dave.hansen@linux.intel.com>
Cc: x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, linux-mm@kvack.org, linux-arch@vger.kernel.org, linux-api@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>, Andy Lutomirski <luto@amacapital.net>, Balbir Singh <bsingharora@gmail.com>, Cyrill Gorcunov <gorcunov@gmail.com>, Florian Weimer <fweimer@redhat.com>, "H.J. Lu" <hjl.tools@gmail.com>, Jann Horn <jannh@google.com>, Jonathan Corbet <corbet@lwn.net>, Kees Cook <keescook@chromiun.org>, Mike Kravetz <mike.kravetz@oracle.com>, Nadav Amit <nadav.amit@gmail.com>, Oleg Nesterov <oleg@redhat.com>, Pavel Machek <pavel@ucw.cz>, "Ravi V. Shankar" <ravi.v.shankar@intel.com>, Vedvyas
List-Id: linux-api@vger.kernel.org

On Wed, 2018-07-11 at 11:12 +0200, Peter Zijlstra wrote:
> On Tue, Jul 10, 2018 at 04:10:08PM -0700, Dave Hansen wrote:
> > 
> > On 07/10/2018 03:26 PM, Yu-cheng Yu wrote:
> > > 
> > > Signed-off-by: Yu-cheng Yu <yu-cheng.yu@intel.com>
> > This still needs a changelog, even if you think it's simple.
> > > 
> > > --- a/mm/mprotect.c
> > > +++ b/mm/mprotect.c
> > > @@ -446,6 +446,15 @@ static int do_mprotect_pkey(unsigned long
> > > start, size_t len,
> > >  	error = -ENOMEM;
> > >  	if (!vma)
> > >  		goto out;
> > > +
> > > +	/*
> > > +	 * Do not allow changing shadow stack memory.
> > > +	 */
> > > +	if (vma->vm_flags & VM_SHSTK) {
> > > +		error = -EINVAL;
> > > +		goto out;
> > > +	}
> > > +
> > I think this is a _bit_ draconian.  Why shouldn't we be able to use
> > protection keys with a shadow stack?  Or, set it to PROT_NONE?
> Right, and then there's also madvise() and some of the other
> accessors.
> 
> Why do we need to disallow this? AFAICT the worst that can happen is
> that a process wrecks itself, so what?

Agree.  I will remove the patch.
