From: Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: Re: pkeys: Remove easily triggered WARN
Date: Mon, 17 Oct 2016 09:54:29 +0200
Message-ID: <20161017075429.GB3511@osiris>
References: <20161014182624.4yzw36n4hd7x56wi@codemonkey.org.uk>
 <20161017071648.GA3511@osiris>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <owner-linux-mm@kvack.org>
Content-Disposition: inline
In-Reply-To: <20161017071648.GA3511@osiris>
Sender: owner-linux-mm@kvack.org
To: Dave Jones <davej@codemonkey.org.uk>, Dave Hansen <dave.hansen@linux.intel.com>, linux-arch@vger.kernel.org, Dave Hansen <dave@sr71.net>, mgorman@techsingularity.net, arnd@arndb.de, linux-api@vger.kernel.org, linux-mm@kvack.org, luto@kernel.org, akpm@linux-foundation.org, torvalds@linux-foundation.org
List-Id: linux-api@vger.kernel.org

On Mon, Oct 17, 2016 at 09:16:48AM +0200, Heiko Carstens wrote:
> On Fri, Oct 14, 2016 at 02:26:24PM -0400, Dave Jones wrote:
> > This easy-to-trigger warning shows up instantly when running
> > Trinity on a kernel with CONFIG_X86_INTEL_MEMORY_PROTECTION_KEYS disabled.
> > 
> > At most this should have been a printk, but the -EINVAL alone should be more
> > than adequate indicator that something isn't available.
> > 
> > Signed-off-by: Dave Jones <davej@codemonkey.org.uk>
> > 
> > diff --git a/include/linux/pkeys.h b/include/linux/pkeys.h
> > index e4c08c1ff0c5..a1bacf1150b2 100644
> > --- a/include/linux/pkeys.h
> > +++ b/include/linux/pkeys.h
> > @@ -25,7 +25,6 @@ static inline int mm_pkey_alloc(struct mm_struct *mm)
> >  
> >  static inline int mm_pkey_free(struct mm_struct *mm, int pkey)
> >  {
> > -	WARN_ONCE(1, "free of protection key when disabled");
> >  	return -EINVAL;
> >  }
> 
> FWIW, are all architectures supposed to wire these new system calls up?
> 
> I decided to ignore these on s390 since we can't make any sane use of
> them. However mips has them already wired up.
> 
> The only difference on s390 (and any other architecture without memory
> protection keys with x86 like semantics) would be that pkey_alloc/pkey_free
> will return -EINVAL instead of -ENOSYS and that we have a new mprotect
> wrapper called pkey_mprotect, if being called with a pkey parameter of -1.

What I wrote is of course not correct... 

There can't be any -ENOSYS if the system call isn't wired up, since the
system call number hasn't been allocated at all for an architecture.

But the question remains: should these be wired up on all architectures?

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
