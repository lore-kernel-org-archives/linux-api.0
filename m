From: Rik van Riel <riel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 2/2] mm,fork: introduce MADV_WIPEONFORK
Date: Fri, 11 Aug 2017 16:27:45 -0400
Message-ID: <1502483265.6577.52.camel@redhat.com>
References: <20170811191942.17487-1-riel@redhat.com>
         <20170811191942.17487-3-riel@redhat.com>
         <CA+55aFzA+7CeCdUi-13DfOeE3FfhtTPMMmBA4UQx8FixXiD4YA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CA+55aFzA+7CeCdUi-13DfOeE3FfhtTPMMmBA4UQx8FixXiD4YA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Mike Kravetz <mike.kravetz-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, linux-mm <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Florian Weimer <fweimer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, colm-ZXBCfW2eEe/k1uMJSBkQmQ@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Will Drewry <wad-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "Kirill A. Shutemov" <kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>, Dave Hansen <dave.hansen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Fri, 2017-08-11 at 12:42 -0700, Linus Torvalds wrote:
> On Fri, Aug 11, 2017 at 12:19 PM,  <riel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> > diff --git a/mm/memory.c b/mm/memory.c
> > index 0e517be91a89..f9b0ad7feb57 100644
> > --- a/mm/memory.c
> > +++ b/mm/memory.c
> > @@ -1134,6 +1134,16 @@ int copy_page_range(struct mm_struct
> > *dst_mm, struct mm_struct *src_mm,
> >                         !vma->anon_vma)
> >                 return 0;
> > 
> > +       /*
> > +        * With VM_WIPEONFORK, the child inherits the VMA from the
> > +        * parent, but not its contents.
> > +        *
> > +        * A child accessing VM_WIPEONFORK memory will see all
> > zeroes;
> > +        * a child accessing VM_DONTCOPY memory receives a
> > segfault.
> > +        */
> > +       if (vma->vm_flags & VM_WIPEONFORK)
> > +               return 0;
> > +
> 
> Is this right?
> 
> Yes, you don't do the page table copies. Fine. But you leave vma with
> the the anon_vma pointer - doesn't that mean that it's still
> connected
> to the original anonvma chain, and we might end up swapping something
> in?

Swapping something in would require there to be a swap entry in
the page table entries, which we are not copying, so this should
not be a correctness issue.

> And even if that ends up not being an issue, I'd expect that you'd
> want to break the anon_vma chain just to not make it grow
> unnecessarily.

This is a good point. I can send a v4 that skips the anon_vma_fork()
call if VM_WIPEONFORK, and calls anon_vma_prepare(), instead.

> So my gut feel is that doing this in "copy_page_range()" is wrong,
> and
> the logic should be moved up to dup_mmap(), where we can also
> short-circuit the anon_vma chain entirely.
> 
> No?

There is another test in copy_page_range already which ends up
skipping the page table copy when it should not be done.

If you want, I can move that test into a should_copy_page_range()
function, and call that from dup_mmap(), skipping the call to
copy_page_range() if should_copy_page_range() returns false.

Having only one of the two sets of tests in dup_mmap(), and
the other in copy_page_range() seems wrong.

Just let me know what you prefer, and I'll put that in v4.

> The madvice() interface looks fine to me.

That was the main reason for adding you to the thread :)

kind regards,

Rik
