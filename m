From: Michal Hocko <mhocko@kernel.org>
Subject: Re: [PATCH 3/6] lib/bucket_locks: use kvmalloc_array()
Date: Tue, 29 May 2018 16:43:17 +0200
Message-ID: <20180529144317.GA20910@dhcp22.suse.cz>
References: <20180524211135.27760-1-dave@stgolabs.net>
 <20180524211135.27760-4-dave@stgolabs.net>
 <CA+55aFxvNCEBQsxfr=yL3jgxiC8M8wY2MHwVBH+T8qSWyP-WPg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CA+55aFxvNCEBQsxfr=yL3jgxiC8M8wY2MHwVBH+T8qSWyP-WPg@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Davidlohr Bueso <dave@stgolabs.net>, Andrew Morton <akpm@linux-foundation.org>, Thomas Graf <tgraf@suug.ch>, Herbert Xu <herbert@gondor.apana.org.au>, Manfred Spraul <manfred@colorfullife.com>, guillaume.knispel@supersonicimagine.com, Linux API <linux-api@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Davidlohr Bueso <dbueso@suse.de>
List-Id: linux-api@vger.kernel.org

On Thu 24-05-18 14:37:36, Linus Torvalds wrote:
> On Thu, May 24, 2018 at 2:28 PM Davidlohr Bueso <dave@stgolabs.net> wrote:
> 
> >                  if (gfpflags_allow_blocking(gfp))
> > -                       tlocks = kvmalloc(size * sizeof(spinlock_t), gfp);
> > +                       tlocks = kvmalloc_array(size, sizeof(spinlock_t),
> gfp);
> >                  else
> >                          tlocks = kmalloc_array(size, sizeof(spinlock_t),
> gfp);
> 
> Side note: how about we just move that "gfpflags_allow_blocking()" into
> kvmalloc() instead, and make kvmalloc() generally usable?
> 
> Now we have that really odd situation where kvmalloc() takes gfp flags, but
> to quote the comment:
> 
>   * Any use of gfp flags outside of GFP_KERNEL should be consulted with mm
> people.
> 
> and the code:
> 
>          /*
>           * vmalloc uses GFP_KERNEL for some internal allocations (e.g page
> tables)
>           * so the given set of flags has to be compatible.
>           */
>          WARN_ON_ONCE((flags & GFP_KERNEL) != GFP_KERNEL);
> 
> which isn't really all that helpful. Do mm people really want to be
> consulted about random uses?

The purpose was to have a clean usage base after the conversion. If we
are growing a non-trivial use base which wants to use GFP_NOWAIT semantic
then sure we can make kvmalloc never fallback to vmallock. But see
below...

> Maybe we could just make the rule for kvmalloc() be to only fall back on
> vmalloc for allocations that are
> 
>   - larger than page size
> 
>   - blocking and allow GFP_KERNEL (so basically that WARN_ON_ONCE() logic in
> kvmalloc_node).
> 
> Hmm? Isn't that what everybody really *wants* kvmalloc() and friends to do?

... Well, there are users who would like to use kvmalloc for
GFP_NOFS/GFP_NOIO context. Do we want them to fail more likely for
larger order rather than have them fixed (to either drop the NOFS
because it just has been blindly copied from a different code without
too much thinking or use the scope NOFS/NOIO API)? A warn_on tends to be
rather harsh but effective way to push maintainers fix their broken
code...
-- 
Michal Hocko
SUSE Labs
