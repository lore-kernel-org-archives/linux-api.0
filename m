From: Jann Horn <jannh@google.com>
Subject: Re: [PATCH V2] mm: Allow userland to request that the kernel clear
 memory on release
Date: Thu, 25 Apr 2019 14:42:52 +0200
Message-ID: <CAG48ez0x6QiFpqXbimB9ZV-jS5UJJWhzg9XiAWncQL+phfKkPA@mail.gmail.com>
References: <CACdnJuup-y1xAO93wr+nr6ARacxJ9YXgaceQK9TLktE7shab1w@mail.gmail.com>
 <20190424211038.204001-1-matthewgarrett@google.com> <20190425121410.GC1144@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190425121410.GC1144@dhcp22.suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
To: Michal Hocko <mhocko@kernel.org>
Cc: Matthew Garrett <matthewgarrett@google.com>, Linux-MM <linux-mm@kvack.org>, kernel list <linux-kernel@vger.kernel.org>, Matthew Garrett <mjg59@google.com>, Linux API <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Thu, Apr 25, 2019 at 2:14 PM Michal Hocko <mhocko@kernel.org> wrote:
[...]
> On Wed 24-04-19 14:10:39, Matthew Garrett wrote:
> > From: Matthew Garrett <mjg59@google.com>
> >
> > Applications that hold secrets and wish to avoid them leaking can use
> > mlock() to prevent the page from being pushed out to swap and
> > MADV_DONTDUMP to prevent it from being included in core dumps. Applications
> > can also use atexit() handlers to overwrite secrets on application exit.
> > However, if an attacker can reboot the system into another OS, they can
> > dump the contents of RAM and extract secrets. We can avoid this by setting
> > CONFIG_RESET_ATTACK_MITIGATION on UEFI systems in order to request that the
> > firmware wipe the contents of RAM before booting another OS, but this means
> > rebooting takes a *long* time - the expected behaviour is for a clean
> > shutdown to remove the request after scrubbing secrets from RAM in order to
> > avoid this.
> >
> > Unfortunately, if an application exits uncleanly, its secrets may still be
> > present in RAM. This can't be easily fixed in userland (eg, if the OOM
> > killer decides to kill a process holding secrets, we're not going to be able
> > to avoid that), so this patch adds a new flag to madvise() to allow userland
> > to request that the kernel clear the covered pages whenever the page
> > reference count hits zero. Since vm_flags is already full on 32-bit, it
> > will only work on 64-bit systems.
[...]
> > diff --git a/mm/madvise.c b/mm/madvise.c
> > index 21a7881a2db4..989c2fde15cf 100644
> > --- a/mm/madvise.c
> > +++ b/mm/madvise.c
> > @@ -92,6 +92,22 @@ static long madvise_behavior(struct vm_area_struct *vma,
> >       case MADV_KEEPONFORK:
> >               new_flags &= ~VM_WIPEONFORK;
> >               break;
> > +     case MADV_WIPEONRELEASE:
> > +             /* MADV_WIPEONRELEASE is only supported on anonymous memory. */
> > +             if (VM_WIPEONRELEASE == 0 || vma->vm_file ||
> > +                 vma->vm_flags & VM_SHARED) {
> > +                     error = -EINVAL;
> > +                     goto out;
> > +             }
> > +             new_flags |= VM_WIPEONRELEASE;
> > +             break;

An interesting effect of this is that it will be possible to set this
on a CoW anon VMA in a fork() child, and then the semantics in the
parent will be subtly different - e.g. if the parent vmsplice()d a
CoWed page into a pipe, then forked an unprivileged child, the child
set MADV_WIPEONRELEASE on its VMA, the parent died somehow, and then
the child died, the page in the pipe would be zeroed out. A child
should not be able to affect its parent like this, I think. If this
was an mmap() flag instead of a madvise() command, that issue could be
avoided. Alternatively, if adding more mmap() flags doesn't work,
perhaps you could scan the VMA and ensure that it contains no pages
yet, or something like that?

> > diff --git a/mm/memory.c b/mm/memory.c
> > index ab650c21bccd..ff78b527660e 100644
> > --- a/mm/memory.c
> > +++ b/mm/memory.c
> > @@ -1091,6 +1091,9 @@ static unsigned long zap_pte_range(struct mmu_gather *tlb,
> >                       page_remove_rmap(page, false);
> >                       if (unlikely(page_mapcount(page) < 0))
> >                               print_bad_pte(vma, addr, ptent, page);
> > +                     if (unlikely(vma->vm_flags & VM_WIPEONRELEASE) &&
> > +                         page_mapcount(page) == 0)
> > +                             clear_highpage(page);
> >                       if (unlikely(__tlb_remove_page(tlb, page))) {
> >                               force_flush = 1;
> >                               addr += PAGE_SIZE;

Should something like this perhaps be added in page_remove_rmap()
instead? That's where the mapcount is decremented; and looking at
other callers of page_remove_rmap(), in particular the following ones
look interesting:

 - do_huge_pmd_wp_page()/do_huge_pmd_wp_page_fallback() might be
relevant in the case where a forking process contains transparent
hugepages?
 - zap_huge_pmd() is relevant when transparent hugepages are used, I
think (otherwise transparent hugepages might not be wiped?)
 - there are various callers related to migration; I think this is
relevant on a NUMA system where memory is moved between nodes to
improve locality (moving memory to a new page and freeing the old one,
in which case you'd want to wipe the old page)

I think all the callers have a reference to the VMA, so perhaps you
could add a VMA parameter to page_remove_rmap() and then look at the
VMA in there?
