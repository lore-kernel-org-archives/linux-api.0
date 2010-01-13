From: Gleb Natapov <gleb@redhat.com>
Subject: Re: [PATCH v4][RESENT] add MAP_UNLOCKED mmap flag
Date: Wed, 13 Jan 2010 11:28:49 +0200
Message-ID: <20100113092849.GS7549@redhat.com>
References: <20100112145144.GQ7549@redhat.com>
 <20100112232145.GA10576@sequoia.sous-sol.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <owner-linux-mm@kvack.org>
Content-Disposition: inline
In-Reply-To: <20100112232145.GA10576@sequoia.sous-sol.org>
Sender: owner-linux-mm@kvack.org
To: Chris Wright <chrisw@sous-sol.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, akpm@linux-foundation.org
List-Id: linux-api@vger.kernel.org

On Tue, Jan 12, 2010 at 03:21:45PM -0800, Chris Wright wrote:
> * Gleb Natapov (gleb@redhat.com) wrote:
> >  v3->v4
> >   - return error if MAP_LOCKED | MAP_UNLOCKED is specified
> ...
> > --- a/mm/mmap.c
> > +++ b/mm/mmap.c
> > @@ -962,6 +962,12 @@ unsigned long do_mmap_pgoff(struct file *file, unsigned long addr,
> >  		if (!can_do_mlock())
> >  			return -EPERM;
> >  
> > +        if (flags & MAP_UNLOCKED)
> > +                vm_flags &= ~VM_LOCKED;
> > +
> > +        if (flags & MAP_UNLOCKED)
> > +                vm_flags &= ~VM_LOCKED;
> > +
> >  	/* mlock MCL_FUTURE? */
> >  	if (vm_flags & VM_LOCKED) {
> >  		unsigned long locked, lock_limit;
> 
> Looks like same patch applied twice rather than adding the
> (MAP_LOCKED | MAP_UNLOCKED) check.
> 
Thanks Chris, will resend.

--
			Gleb.

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
