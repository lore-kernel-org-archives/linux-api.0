From: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] mm: introduce MADV_CLR_HUGEPAGE
Date: Wed, 31 May 2017 12:22:03 +0200
Message-ID: <20170531102203.GE27783@dhcp22.suse.cz>
References: <20170524142735.GF3063@rapoport-lnx>
 <20170530074408.GA7969@dhcp22.suse.cz>
 <20170530101921.GA25738@rapoport-lnx>
 <20170530103930.GB7969@dhcp22.suse.cz>
 <20170530140456.GA8412@redhat.com>
 <20170530143941.GK7969@dhcp22.suse.cz>
 <20170530145632.GL7969@dhcp22.suse.cz>
 <20170530160610.GC8412@redhat.com>
 <e371b76b-d091-72d0-16c3-5227820595f0@suse.cz>
 <20170531082414.GB27783@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170531082414.GB27783-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>
Cc: Andrea Arcangeli <aarcange-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Mike Rapoport <rppt-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, "Kirill A. Shutemov" <kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, "Kirill A. Shutemov" <kirill.shutemov-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Pavel Emelyanov <xemul-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>, linux-mm <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, lkml <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Wed 31-05-17 10:24:14, Michal Hocko wrote:
[...]

JFTR we also need to update MMF_INIT_MASK as well.
+#define MMF_INIT_MASK          (MMF_DUMPABLE_MASK | MMF_DUMP_FILTER_MASK | MMF_DISABLE_THP)

> diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
> index a3762d49ba39..9da053ced864 100644
> --- a/include/linux/huge_mm.h
> +++ b/include/linux/huge_mm.h
> @@ -92,6 +92,7 @@ extern bool is_vma_temporary_stack(struct vm_area_struct *vma);
>  	   (1<<TRANSPARENT_HUGEPAGE_REQ_MADV_FLAG) &&			\
>  	   ((__vma)->vm_flags & VM_HUGEPAGE))) &&			\
>  	 !((__vma)->vm_flags & VM_NOHUGEPAGE) &&			\
> +	 !test_bit(MMF_DISABLE_THP, &(__vma)->vm_mm->flags) &&		\
>  	 !is_vma_temporary_stack(__vma))
>  #define transparent_hugepage_use_zero_page()				\
>  	(transparent_hugepage_flags &					\
> diff --git a/include/linux/khugepaged.h b/include/linux/khugepaged.h
> index 5d9a400af509..f0d7335336cd 100644
> --- a/include/linux/khugepaged.h
> +++ b/include/linux/khugepaged.h
> @@ -48,7 +48,8 @@ static inline int khugepaged_enter(struct vm_area_struct *vma,
>  	if (!test_bit(MMF_VM_HUGEPAGE, &vma->vm_mm->flags))
>  		if ((khugepaged_always() ||
>  		     (khugepaged_req_madv() && (vm_flags & VM_HUGEPAGE))) &&
> -		    !(vm_flags & VM_NOHUGEPAGE))
> +		    !(vm_flags & VM_NOHUGEPAGE) &&
> +		    !test_bit(MMF_DISABLE_THP, &vma->vm_mm->flags))
>  			if (__khugepaged_enter(vma->vm_mm))
>  				return -ENOMEM;
>  	return 0;
> diff --git a/include/linux/sched/coredump.h b/include/linux/sched/coredump.h
> index 69eedcef8f03..2c07b244090a 100644
> --- a/include/linux/sched/coredump.h
> +++ b/include/linux/sched/coredump.h
> @@ -68,6 +68,7 @@ static inline int get_dumpable(struct mm_struct *mm)
>  #define MMF_OOM_SKIP		21	/* mm is of no interest for the OOM killer */
>  #define MMF_UNSTABLE		22	/* mm is unstable for copy_from_user */
>  #define MMF_HUGE_ZERO_PAGE	23      /* mm has ever used the global huge zero page */
> +#define MMF_DISABLE_THP		24	/* disable THP for all VMAs */
>  
>  #define MMF_INIT_MASK		(MMF_DUMPABLE_MASK | MMF_DUMP_FILTER_MASK)
>  
> diff --git a/kernel/sys.c b/kernel/sys.c
> index 8a94b4eabcaa..e48f0636c7fd 100644
> --- a/kernel/sys.c
> +++ b/kernel/sys.c
> @@ -2266,7 +2266,7 @@ SYSCALL_DEFINE5(prctl, int, option, unsigned long, arg2, unsigned long, arg3,
>  	case PR_GET_THP_DISABLE:
>  		if (arg2 || arg3 || arg4 || arg5)
>  			return -EINVAL;
> -		error = !!(me->mm->def_flags & VM_NOHUGEPAGE);
> +		error = !!test_bit(MMF_DISABLE_THP, &me->mm->flags);
>  		break;
>  	case PR_SET_THP_DISABLE:
>  		if (arg3 || arg4 || arg5)
> @@ -2274,9 +2274,9 @@ SYSCALL_DEFINE5(prctl, int, option, unsigned long, arg2, unsigned long, arg3,
>  		if (down_write_killable(&me->mm->mmap_sem))
>  			return -EINTR;
>  		if (arg2)
> -			me->mm->def_flags |= VM_NOHUGEPAGE;
> +			set_bit(MMF_DISABLE_THP, &me->mm->flags);
>  		else
> -			me->mm->def_flags &= ~VM_NOHUGEPAGE;
> +			clear_bit(MMF_DISABLE_THP, &me->mm->flags);
>  		up_write(&me->mm->mmap_sem);
>  		break;
>  	case PR_MPX_ENABLE_MANAGEMENT:
> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> index ce29e5cc7809..57e31f4752b3 100644
> --- a/mm/khugepaged.c
> +++ b/mm/khugepaged.c
> @@ -818,7 +818,8 @@ khugepaged_alloc_page(struct page **hpage, gfp_t gfp, int node)
>  static bool hugepage_vma_check(struct vm_area_struct *vma)
>  {
>  	if ((!(vma->vm_flags & VM_HUGEPAGE) && !khugepaged_always()) ||
> -	    (vma->vm_flags & VM_NOHUGEPAGE))
> +	    (vma->vm_flags & VM_NOHUGEPAGE) ||
> +	    test_bit(MMF_DISABLE_THP, &vma->vm_mm->flags))
>  		return false;
>  	if (shmem_file(vma->vm_file)) {
>  		if (!IS_ENABLED(CONFIG_TRANSPARENT_HUGE_PAGECACHE))
> diff --git a/mm/shmem.c b/mm/shmem.c
> index e67d6ba4e98e..27fe1bbf813b 100644
> --- a/mm/shmem.c
> +++ b/mm/shmem.c
> @@ -1977,10 +1977,11 @@ static int shmem_fault(struct vm_fault *vmf)
>  	}
>  
>  	sgp = SGP_CACHE;
> -	if (vma->vm_flags & VM_HUGEPAGE)
> -		sgp = SGP_HUGE;
> -	else if (vma->vm_flags & VM_NOHUGEPAGE)
> +	
> +	if ((vma->vm_flags & VM_NOHUGEPAGE) || test_bit(MMF_DISABLE_THP, &vma->vm_mm->flags))
>  		sgp = SGP_NOHUGE;
> +	else if (vma->vm_flags & VM_HUGEPAGE)
> +		sgp = SGP_HUGE;
>  
>  	error = shmem_getpage_gfp(inode, vmf->pgoff, &vmf->page, sgp,
>  				  gfp, vma, vmf, &ret);
> -- 
> Michal Hocko
> SUSE Labs

-- 
Michal Hocko
SUSE Labs
