From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH v7 18/27] mm: Introduce do_mmap_locked()
Date: Fri, 7 Jun 2019 09:47:07 +0200
Message-ID: <20190607074707.GD3463@hirez.programming.kicks-ass.net>
References: <20190606200646.3951-1-yu-cheng.yu@intel.com>
 <20190606200646.3951-19-yu-cheng.yu@intel.com>
 <20190607074322.GP3419@hirez.programming.kicks-ass.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190607074322.GP3419@hirez.programming.kicks-ass.net>
Sender: linux-kernel-owner@vger.kernel.org
To: Yu-cheng Yu <yu-cheng.yu@intel.com>
Cc: x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, linux-mm@kvack.org, linux-arch@vger.kernel.org, linux-api@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>, Andy Lutomirski <luto@amacapital.net>, Balbir Singh <bsingharora@gmail.com>, Borislav Petkov <bp@alien8.de>, Cyrill Gorcunov <gorcunov@gmail.com>, Dave Hansen <dave.hansen@linux.intel.com>, Eugene Syromiatnikov <esyr@redhat.com>, Florian Weimer <fweimer@redhat.com>, "H.J. Lu" <hjl.tools@gmail.com>, Jann Horn <jannh@google.com>, Jonathan Corbet <corbet@lwn.net>, Kees Cook <keescook@chromium.org>, Mike Kravetz <mike.kravetz@oracle.com>, Nadav Amit <nadav.amit@gmail.com>
List-Id: linux-api@vger.kernel.org

On Fri, Jun 07, 2019 at 09:43:22AM +0200, Peter Zijlstra wrote:
> On Thu, Jun 06, 2019 at 01:06:37PM -0700, Yu-cheng Yu wrote:
> > There are a few places that need do_mmap() with mm->mmap_sem held.
> > Create an in-line function for that.
> > 
> > Signed-off-by: Yu-cheng Yu <yu-cheng.yu@intel.com>
> > ---
> >  include/linux/mm.h | 18 ++++++++++++++++++
> >  1 file changed, 18 insertions(+)
> > 
> > diff --git a/include/linux/mm.h b/include/linux/mm.h
> > index 398f1e1c35e5..7cf014604848 100644
> > --- a/include/linux/mm.h
> > +++ b/include/linux/mm.h
> > @@ -2411,6 +2411,24 @@ static inline void mm_populate(unsigned long addr, unsigned long len)
> >  static inline void mm_populate(unsigned long addr, unsigned long len) {}
> >  #endif
> >  
> > +static inline unsigned long do_mmap_locked(unsigned long addr,
> > +	unsigned long len, unsigned long prot, unsigned long flags,
> > +	vm_flags_t vm_flags)
> > +{
> > +	struct mm_struct *mm = current->mm;
> > +	unsigned long populate;
> > +
> > +	down_write(&mm->mmap_sem);
> > +	addr = do_mmap(NULL, addr, len, prot, flags, vm_flags, 0,
> > +		       &populate, NULL);
> 
> Funny thing how do_mmap() takes a file pointer as first argument and
> this thing explicitly NULLs that. That more or less invalidates the name
> do_mmap_locked().
> 
> > +	up_write(&mm->mmap_sem);
> > +
> > +	if (populate)
> > +		mm_populate(addr, populate);
> > +
> > +	return addr;
> > +}

You also don't retain that last @uf argument.

I'm thikning you're better off adding a helper to the cet.c file; call
it cet_mmap() or whatever.
