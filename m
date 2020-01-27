From: Brian Geffon <bgeffon-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2] mm: Add MREMAP_DONTUNMAP to mremap().
Date: Sun, 26 Jan 2020 18:21:39 -0800
Message-ID: <CADyq12wfLfnbRFt3nRjwc=3BcTi8BbUatyxc58r592NLbD04pQ@mail.gmail.com>
References: <20200123014627.71720-1-bgeffon@google.com> <20200124190625.257659-1-bgeffon@google.com>
 <20200126051642.GA39508@ubuntu-x2-xlarge-x86>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20200126051642.GA39508@ubuntu-x2-xlarge-x86>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Nathan Chancellor <natechancellor-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, "Michael S . Tsirkin" <mst-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-mm <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Andrea Arcangeli <aarcange-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Sonny Rao <sonnyrao-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Minchan Kim <minchan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Joel Fernandes <joel-QYYGw3jwrUn5owFQY34kdNi2O/JbrIOy@public.gmane.org>, Yu Zhao <yuzhao-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Jesse Barnes <jsbarnes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, clang-built-linux-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
List-Id: linux-api@vger.kernel.org

Hi Nathan,
Thank you! That was an oversight on my part. I'll address it in the next patch.

Brian


On Sat, Jan 25, 2020 at 9:16 PM Nathan Chancellor
<natechancellor-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>
> Hi Brian,
>
> On Fri, Jan 24, 2020 at 11:06:25AM -0800, Brian Geffon wrote:
> > When remapping an anonymous, private mapping, if MREMAP_DONTUNMAP is
> > set, the source mapping will not be removed. Instead it will be
> > cleared as if a brand new anonymous, private mapping had been created
> > atomically as part of the mremap() call.  If a userfaultfd was watching
> > the source, it will continue to watch the new mapping.  For a mapping
> > that is shared or not anonymous, MREMAP_DONTUNMAP will cause the
> > mremap() call to fail. MREMAP_DONTUNMAP implies that MREMAP_FIXED is
> > also used. The final result is two equally sized VMAs where the
> > destination contains the PTEs of the source.
> >
> > We hope to use this in Chrome OS where with userfaultfd we could write
> > an anonymous mapping to disk without having to STOP the process or worry
> > about VMA permission changes.
> >
> > This feature also has a use case in Android, Lokesh Gidra has said
> > that "As part of using userfaultfd for GC, We'll have to move the physical
> > pages of the java heap to a separate location. For this purpose mremap
> > will be used. Without the MREMAP_DONTUNMAP flag, when I mremap the java
> > heap, its virtual mapping will be removed as well. Therefore, we'll
> > require performing mmap immediately after. This is not only time consuming
> > but also opens a time window where a native thread may call mmap and
> > reserve the java heap's address range for its own usage. This flag
> > solves the problem."
> >
> > Signed-off-by: Brian Geffon <bgeffon-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> > ---
> >  include/uapi/linux/mman.h |  5 +++--
> >  mm/mremap.c               | 37 ++++++++++++++++++++++++++++++-------
> >  2 files changed, 33 insertions(+), 9 deletions(-)
> >
> > diff --git a/include/uapi/linux/mman.h b/include/uapi/linux/mman.h
> > index fc1a64c3447b..923cc162609c 100644
> > --- a/include/uapi/linux/mman.h
> > +++ b/include/uapi/linux/mman.h
> > @@ -5,8 +5,9 @@
> >  #include <asm/mman.h>
> >  #include <asm-generic/hugetlb_encode.h>
> >
> > -#define MREMAP_MAYMOVE       1
> > -#define MREMAP_FIXED 2
> > +#define MREMAP_MAYMOVE               1
> > +#define MREMAP_FIXED         2
> > +#define MREMAP_DONTUNMAP     4
> >
> >  #define OVERCOMMIT_GUESS             0
> >  #define OVERCOMMIT_ALWAYS            1
> > diff --git a/mm/mremap.c b/mm/mremap.c
> > index 122938dcec15..bf97c3eb538b 100644
> > --- a/mm/mremap.c
> > +++ b/mm/mremap.c
> > @@ -318,8 +318,8 @@ unsigned long move_page_tables(struct vm_area_struct *vma,
> >  static unsigned long move_vma(struct vm_area_struct *vma,
> >               unsigned long old_addr, unsigned long old_len,
> >               unsigned long new_len, unsigned long new_addr,
> > -             bool *locked, struct vm_userfaultfd_ctx *uf,
> > -             struct list_head *uf_unmap)
> > +             bool *locked, unsigned long flags,
> > +             struct vm_userfaultfd_ctx *uf, struct list_head *uf_unmap)
> >  {
> >       struct mm_struct *mm = vma->vm_mm;
> >       struct vm_area_struct *new_vma;
> > @@ -408,6 +408,13 @@ static unsigned long move_vma(struct vm_area_struct *vma,
> >       if (unlikely(vma->vm_flags & VM_PFNMAP))
> >               untrack_pfn_moved(vma);
> >
> > +     if (unlikely(!err && (flags & MREMAP_DONTUNMAP))) {
> > +             if (vm_flags & VM_ACCOUNT)
> > +                     vma->vm_flags |= VM_ACCOUNT;
> > +
> > +             goto out;
> > +     }
> > +
> >       if (do_munmap(mm, old_addr, old_len, uf_unmap) < 0) {
> >               /* OOM: unable to split vma, just get accounts right */
> >               vm_unacct_memory(excess >> PAGE_SHIFT);
> > @@ -422,6 +429,7 @@ static unsigned long move_vma(struct vm_area_struct *vma,
> >                       vma->vm_next->vm_flags |= VM_ACCOUNT;
> >       }
> >
> > +out:
> >       if (vm_flags & VM_LOCKED) {
> >               mm->locked_vm += new_len >> PAGE_SHIFT;
> >               *locked = true;
> > @@ -497,7 +505,7 @@ static struct vm_area_struct *vma_to_resize(unsigned long addr,
> >
> >  static unsigned long mremap_to(unsigned long addr, unsigned long old_len,
> >               unsigned long new_addr, unsigned long new_len, bool *locked,
> > -             struct vm_userfaultfd_ctx *uf,
> > +             unsigned long flags, struct vm_userfaultfd_ctx *uf,
> >               struct list_head *uf_unmap_early,
> >               struct list_head *uf_unmap)
> >  {
> > @@ -545,6 +553,17 @@ static unsigned long mremap_to(unsigned long addr, unsigned long old_len,
> >               old_len = new_len;
> >       }
> >
> > +     /*
> > +      * MREMAP_DONTUNMAP expands by old_len + (new_len - old_len), we will
> > +      * check that we can expand by old_len and vma_to_resize will handle
> > +      * the vma growing.
> > +      */
> > +     if (unlikely(flags & MREMAP_DONTUNMAP && !may_expand_vm(mm,
> > +                             vma->vm_flags, old_len >> PAGE_SHIFT))) {
>
> We received a Clang build report that vma is used uninitialized here
> (they aren't being publicly sent to LKML due to GCC vs Clang
> warning/error overlap):
>
> https://groups.google.com/d/msg/clang-built-linux/gE5wRaeHdSI/xVA0MBQVEgAJ
>
> Sure enough, vma is initialized first in the next block. Not sure if
> this section should be moved below that initialization or if something
> else should be done to resolve it but that dereference will obviously be
> fatal.
>
> Cheers,
> Nathan
>
> > +             ret = -ENOMEM;
> > +             goto out;
> > +     }
> > +
> >       vma = vma_to_resize(addr, old_len, new_len, &charged);
> >       if (IS_ERR(vma)) {
> >               ret = PTR_ERR(vma);
> > @@ -561,7 +580,7 @@ static unsigned long mremap_to(unsigned long addr, unsigned long old_len,
> >       if (IS_ERR_VALUE(ret))
> >               goto out1;
> >
> > -     ret = move_vma(vma, addr, old_len, new_len, new_addr, locked, uf,
> > +     ret = move_vma(vma, addr, old_len, new_len, new_addr, locked, flags, uf,
> >                      uf_unmap);
> >       if (!(offset_in_page(ret)))
> >               goto out;
> > @@ -609,12 +628,15 @@ SYSCALL_DEFINE5(mremap, unsigned long, addr, unsigned long, old_len,
> >       addr = untagged_addr(addr);
> >       new_addr = untagged_addr(new_addr);
> >
> > -     if (flags & ~(MREMAP_FIXED | MREMAP_MAYMOVE))
> > +     if (flags & ~(MREMAP_FIXED | MREMAP_MAYMOVE | MREMAP_DONTUNMAP))
> >               return ret;
> >
> >       if (flags & MREMAP_FIXED && !(flags & MREMAP_MAYMOVE))
> >               return ret;
> >
> > +     if (flags & MREMAP_DONTUNMAP && !(flags & MREMAP_FIXED))
> > +             return ret;
> > +
> >       if (offset_in_page(addr))
> >               return ret;
> >
> > @@ -634,7 +656,8 @@ SYSCALL_DEFINE5(mremap, unsigned long, addr, unsigned long, old_len,
> >
> >       if (flags & MREMAP_FIXED) {
> >               ret = mremap_to(addr, old_len, new_addr, new_len,
> > -                             &locked, &uf, &uf_unmap_early, &uf_unmap);
> > +                             &locked, flags, &uf, &uf_unmap_early,
> > +                             &uf_unmap);
> >               goto out;
> >       }
> >
> > @@ -712,7 +735,7 @@ SYSCALL_DEFINE5(mremap, unsigned long, addr, unsigned long, old_len,
> >               }
> >
> >               ret = move_vma(vma, addr, old_len, new_len, new_addr,
> > -                            &locked, &uf, &uf_unmap);
> > +                            &locked, flags, &uf, &uf_unmap);
> >       }
> >  out:
> >       if (offset_in_page(ret)) {
> > --
> > 2.25.0.341.g760bfbb309-goog
> >
