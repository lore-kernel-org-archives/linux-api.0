From: Konstantin Khlebnikov <koct9i-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 07/17] mm: madvise MADV_USERFAULT: prepare vm_flags to
 allow more than 32bits
Date: Fri, 7 Nov 2014 00:08:13 +0400
Message-ID: <CALYGNiNWbAadvVzScWsgsdG5bGWir4q8oOWqbDg47C2+kk3=Mw@mail.gmail.com>
References: <1412356087-16115-1-git-send-email-aarcange@redhat.com>
	<1412356087-16115-8-git-send-email-aarcange@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1412356087-16115-8-git-send-email-aarcange-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andrea Arcangeli <aarcange-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: qemu-devel-qX2TKyscuCcdnm+yROfE0A@public.gmane.org, kvm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org" <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Andres Lagar-Cavilla <andreslc-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Dave Hansen <dave-gkUM19QKKo4@public.gmane.org>, Paolo Bonzini <pbonzini-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Rik van Riel <riel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Sasha Levin <sasha.levin-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Peter Feiner <pfeiner-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, "\\Dr. David Alan Gilbert\\" <dgilbert-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Christopher Covington <cov-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Android Kernel Team <kernel-team-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org>, Robert Love <rlove-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Dmitry Adamushko <dmitry.adamushko-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Neil Brown <neilb-l3A5Bk7waGM@public.gmane.org>, Mike
List-Id: linux-api@vger.kernel.org

On Fri, Oct 3, 2014 at 9:07 PM, Andrea Arcangeli <aarcange-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> We run out of 32bits in vm_flags, noop change for 64bit archs.

What? Again?
As I see there are some free bits: 0x200, 0x1000, 0x80000

I prefer to reserve 0x02000000 for VM_ARCH_2

>
> Signed-off-by: Andrea Arcangeli <aarcange-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> ---
>  fs/proc/task_mmu.c       | 4 ++--
>  include/linux/huge_mm.h  | 4 ++--
>  include/linux/ksm.h      | 4 ++--
>  include/linux/mm_types.h | 2 +-
>  mm/huge_memory.c         | 2 +-
>  mm/ksm.c                 | 2 +-
>  mm/madvise.c             | 2 +-
>  mm/mremap.c              | 2 +-
>  8 files changed, 11 insertions(+), 11 deletions(-)
>
> diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
> index c341568..ee1c3a2 100644
> --- a/fs/proc/task_mmu.c
> +++ b/fs/proc/task_mmu.c
> @@ -532,11 +532,11 @@ static void show_smap_vma_flags(struct seq_file *m, struct vm_area_struct *vma)
>         /*
>          * Don't forget to update Documentation/ on changes.
>          */
> -       static const char mnemonics[BITS_PER_LONG][2] = {
> +       static const char mnemonics[BITS_PER_LONG+1][2] = {
>                 /*
>                  * In case if we meet a flag we don't know about.
>                  */
> -               [0 ... (BITS_PER_LONG-1)] = "??",
> +               [0 ... (BITS_PER_LONG)] = "??",
>
>                 [ilog2(VM_READ)]        = "rd",
>                 [ilog2(VM_WRITE)]       = "wr",
> diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
> index 63579cb..3aa10e0 100644
> --- a/include/linux/huge_mm.h
> +++ b/include/linux/huge_mm.h
> @@ -121,7 +121,7 @@ extern void split_huge_page_pmd_mm(struct mm_struct *mm, unsigned long address,
>  #error "hugepages can't be allocated by the buddy allocator"
>  #endif
>  extern int hugepage_madvise(struct vm_area_struct *vma,
> -                           unsigned long *vm_flags, int advice);
> +                           vm_flags_t *vm_flags, int advice);
>  extern void __vma_adjust_trans_huge(struct vm_area_struct *vma,
>                                     unsigned long start,
>                                     unsigned long end,
> @@ -183,7 +183,7 @@ static inline int split_huge_page(struct page *page)
>  #define split_huge_page_pmd_mm(__mm, __address, __pmd) \
>         do { } while (0)
>  static inline int hugepage_madvise(struct vm_area_struct *vma,
> -                                  unsigned long *vm_flags, int advice)
> +                                  vm_flags_t *vm_flags, int advice)
>  {
>         BUG();
>         return 0;
> diff --git a/include/linux/ksm.h b/include/linux/ksm.h
> index 3be6bb1..8b35253 100644
> --- a/include/linux/ksm.h
> +++ b/include/linux/ksm.h
> @@ -18,7 +18,7 @@ struct mem_cgroup;
>
>  #ifdef CONFIG_KSM
>  int ksm_madvise(struct vm_area_struct *vma, unsigned long start,
> -               unsigned long end, int advice, unsigned long *vm_flags);
> +               unsigned long end, int advice, vm_flags_t *vm_flags);
>  int __ksm_enter(struct mm_struct *mm);
>  void __ksm_exit(struct mm_struct *mm);
>
> @@ -94,7 +94,7 @@ static inline int PageKsm(struct page *page)
>
>  #ifdef CONFIG_MMU
>  static inline int ksm_madvise(struct vm_area_struct *vma, unsigned long start,
> -               unsigned long end, int advice, unsigned long *vm_flags)
> +               unsigned long end, int advice, vm_flags_t *vm_flags)
>  {
>         return 0;
>  }
> diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
> index 6e0b286..2c876d1 100644
> --- a/include/linux/mm_types.h
> +++ b/include/linux/mm_types.h
> @@ -217,7 +217,7 @@ struct page_frag {
>  #endif
>  };
>
> -typedef unsigned long __nocast vm_flags_t;
> +typedef unsigned long long __nocast vm_flags_t;
>
>  /*
>   * A region containing a mapping of a non-memory backed file under NOMMU
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index d9a21d06..e913a19 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -1942,7 +1942,7 @@ out:
>  #define VM_NO_THP (VM_SPECIAL | VM_HUGETLB | VM_SHARED | VM_MAYSHARE)
>
>  int hugepage_madvise(struct vm_area_struct *vma,
> -                    unsigned long *vm_flags, int advice)
> +                    vm_flags_t *vm_flags, int advice)
>  {
>         switch (advice) {
>         case MADV_HUGEPAGE:
> diff --git a/mm/ksm.c b/mm/ksm.c
> index fb75902..faf319e 100644
> --- a/mm/ksm.c
> +++ b/mm/ksm.c
> @@ -1736,7 +1736,7 @@ static int ksm_scan_thread(void *nothing)
>  }
>
>  int ksm_madvise(struct vm_area_struct *vma, unsigned long start,
> -               unsigned long end, int advice, unsigned long *vm_flags)
> +               unsigned long end, int advice, vm_flags_t *vm_flags)
>  {
>         struct mm_struct *mm = vma->vm_mm;
>         int err;
> diff --git a/mm/madvise.c b/mm/madvise.c
> index 0938b30..d5aee71 100644
> --- a/mm/madvise.c
> +++ b/mm/madvise.c
> @@ -49,7 +49,7 @@ static long madvise_behavior(struct vm_area_struct *vma,
>         struct mm_struct *mm = vma->vm_mm;
>         int error = 0;
>         pgoff_t pgoff;
> -       unsigned long new_flags = vma->vm_flags;
> +       vm_flags_t new_flags = vma->vm_flags;
>
>         switch (behavior) {
>         case MADV_NORMAL:
> diff --git a/mm/mremap.c b/mm/mremap.c
> index 05f1180..fa7db87 100644
> --- a/mm/mremap.c
> +++ b/mm/mremap.c
> @@ -239,7 +239,7 @@ static unsigned long move_vma(struct vm_area_struct *vma,
>  {
>         struct mm_struct *mm = vma->vm_mm;
>         struct vm_area_struct *new_vma;
> -       unsigned long vm_flags = vma->vm_flags;
> +       vm_flags_t vm_flags = vma->vm_flags;
>         unsigned long new_pgoff;
>         unsigned long moved_len;
>         unsigned long excess = 0;
>
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo-Bw31MaZKKs0EbZ0PF+XxCw@public.gmane.org  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Don't email: <a href=mailto:"dont-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org"> email-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org </a>
