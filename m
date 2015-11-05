From: Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [RFC] mm: add a new vector based madvise syscall
Date: Thu, 5 Nov 2015 14:01:44 +0100
Message-ID: <563B5338.3020404@suse.cz>
References: <20151029215516.GA3864685@devbig084.prn1.facebook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20151029215516.GA3864685-tb7CFzD8y5b7E6g3fPdp/g2O0Ztt9esIQQ4Iyu8u01E@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Shaohua Li <shli-b10kYP2dOMg@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org
Cc: akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, riel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, mgorman-l3A5Bk7waGM@public.gmane.org, hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, aarcange-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, je-b10kYP2dOMg@public.gmane.org, Kernel-team-b10kYP2dOMg@public.gmane.org, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Minchan Kim <minchan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On 10/29/2015 10:55 PM, Shaohua Li wrote:
> In jemalloc, a free(3) doesn't immediately free the memory to OS even
> the memory is page aligned/size, and hope the memory can be reused soon.
> Later the virtual address becomes fragmented, and more and more free
> memory are aggregated. If the free memory size is large, jemalloc uses
> madvise(DONT_NEED) to actually free the memory back to OS.
> 
> The madvise has significantly overhead paritcularly because of TLB
> flush. jemalloc does madvise for several virtual address space ranges
> one time. Instead of calling madvise for each of the ranges, we
> introduce a new syscall to purge memory for several ranges one time. In
> this way, we can merge several TLB flush for the ranges to one big TLB
> flush. This also reduce mmap_sem locking.
> 
> I'm running a simple memory allocation benchmark. 32 threads do random
> malloc/free/realloc. Corresponding jemalloc patch to utilize this API is
> attached.
> Without patch:
> real    0m18.923s
> user    1m11.819s
> sys     7m44.626s
> each cpu gets around 3000K/s TLB flush interrupt. Perf shows TLB flush
> is hotest functions. mmap_sem read locking (because of page fault) is
> also heavy.
> 
> with patch:
> real    0m15.026s
> user    0m48.548s
> sys     6m41.153s
> each cpu gets around 140k/s TLB flush interrupt. TLB flush isn't hot at
> all. mmap_sem read locking (still because of page fault) becomes the
> sole hot spot.
> 
> Another test malloc a bunch of memory in 48 threads, then all threads
> free the memory. I measure the time of the memory free.
> Without patch: 34.332s
> With patch:    17.429s
> 
> Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
> Cc: Rik van Riel <riel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> Cc: Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>
> Cc: Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
> Cc: Andrea Arcangeli <aarcange-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> Signed-off-by: Shaohua Li <shli-b10kYP2dOMg@public.gmane.org>

First the obligatory (please remember on next submissions):

[CC += linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org]

    Since this is a kernel-user-space API change, please CC linux-api@. The
kernel source file Documentation/SubmitChecklist notes that all Linux kernel
patches that change userspace interfaces should be CCed to
linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, so that the various parties who are interested in API
changes are informed. For further information, see
https://www.kernel.org/doc/man-pages/linux-api-ml.html

Also CCing Minchan. What about MADV_FREE support?

> ---
>  arch/x86/entry/syscalls/syscall_32.tbl |   1 +
>  arch/x86/entry/syscalls/syscall_64.tbl |   1 +
>  mm/madvise.c                           | 144 ++++++++++++++++++++++++++++++---
>  3 files changed, 134 insertions(+), 12 deletions(-)
> 
> diff --git a/arch/x86/entry/syscalls/syscall_32.tbl b/arch/x86/entry/syscalls/syscall_32.tbl
> index 7663c45..4c99ef5 100644
> --- a/arch/x86/entry/syscalls/syscall_32.tbl
> +++ b/arch/x86/entry/syscalls/syscall_32.tbl
> @@ -382,3 +382,4 @@
>  373	i386	shutdown		sys_shutdown
>  374	i386	userfaultfd		sys_userfaultfd
>  375	i386	membarrier		sys_membarrier
> +376	i386	madvisev		sys_madvisev
> diff --git a/arch/x86/entry/syscalls/syscall_64.tbl b/arch/x86/entry/syscalls/syscall_64.tbl
> index 278842f..1025406 100644
> --- a/arch/x86/entry/syscalls/syscall_64.tbl
> +++ b/arch/x86/entry/syscalls/syscall_64.tbl
> @@ -331,6 +331,7 @@
>  322	64	execveat		stub_execveat
>  323	common	userfaultfd		sys_userfaultfd
>  324	common	membarrier		sys_membarrier
> +325	common	madvisev		sys_madvisev
>  
>  #
>  # x32-specific system call numbers start at 512 to avoid cache impact
> diff --git a/mm/madvise.c b/mm/madvise.c
> index c889fcb..6251103 100644
> --- a/mm/madvise.c
> +++ b/mm/madvise.c
> @@ -20,6 +20,9 @@
>  #include <linux/backing-dev.h>
>  #include <linux/swap.h>
>  #include <linux/swapops.h>
> +#include <linux/uio.h>
> +#include <linux/sort.h>
> +#include <asm/tlb.h>
>  
>  /*
>   * Any behaviour which results in changes to the vma->vm_flags needs to
> @@ -415,6 +418,29 @@ madvise_behavior_valid(int behavior)
>  	}
>  }
>  
> +static bool madvise_range_valid(unsigned long start, size_t len_in, bool *skip)
> +{
> +	size_t len;
> +	unsigned long end;
> +
> +	if (start & ~PAGE_MASK)
> +		return false;
> +	len = (len_in + ~PAGE_MASK) & PAGE_MASK;
> +
> +	/* Check to see whether len was rounded up from small -ve to zero */
> +	if (len_in && !len)
> +		return false;
> +
> +	end = start + len;
> +	if (end < start)
> +		return false;
> +	if (end == start)
> +		*skip = true;
> +	else
> +		*skip = false;
> +	return true;
> +}
> +
>  /*
>   * The madvise(2) system call.
>   *
> @@ -464,8 +490,8 @@ SYSCALL_DEFINE3(madvise, unsigned long, start, size_t, len_in, int, behavior)
>  	int unmapped_error = 0;
>  	int error = -EINVAL;
>  	int write;
> -	size_t len;
>  	struct blk_plug plug;
> +	bool skip;
>  
>  #ifdef CONFIG_MEMORY_FAILURE
>  	if (behavior == MADV_HWPOISON || behavior == MADV_SOFT_OFFLINE)
> @@ -474,20 +500,12 @@ SYSCALL_DEFINE3(madvise, unsigned long, start, size_t, len_in, int, behavior)
>  	if (!madvise_behavior_valid(behavior))
>  		return error;
>  
> -	if (start & ~PAGE_MASK)
> -		return error;
> -	len = (len_in + ~PAGE_MASK) & PAGE_MASK;
> -
> -	/* Check to see whether len was rounded up from small -ve to zero */
> -	if (len_in && !len)
> -		return error;
> -
> -	end = start + len;
> -	if (end < start)
> +	if (!madvise_range_valid(start, len_in, &skip))
>  		return error;
> +	end = start + ((len_in + ~PAGE_MASK) & PAGE_MASK);
>  
>  	error = 0;
> -	if (end == start)
> +	if (skip)
>  		return error;
>  
>  	write = madvise_need_mmap_write(behavior);
> @@ -549,3 +567,105 @@ SYSCALL_DEFINE3(madvise, unsigned long, start, size_t, len_in, int, behavior)
>  
>  	return error;
>  }
> +
> +static int iov_cmp_func(const void *a, const void *b)
> +{
> +	const struct iovec *iova = a;
> +	const struct iovec *iovb = b;
> +	unsigned long addr_a = (unsigned long)iova->iov_base;
> +	unsigned long addr_b = (unsigned long)iovb->iov_base;
> +
> +	if (addr_a > addr_b)
> +		return 1;
> +	if (addr_a < addr_b)
> +		return -1;
> +	return 0;
> +}
> +
> +SYSCALL_DEFINE3(madvisev, const struct iovec __user *, uvector, unsigned long, nr_segs,
> +	int, behavior)
> +{
> +	struct iovec iovstack[UIO_FASTIOV];
> +	struct iovec *iov = NULL;
> +	struct vm_area_struct **vmas = NULL;
> +	unsigned long start, last_start = 0;
> +	size_t len;
> +	struct mmu_gather tlb;
> +	int error;
> +	int i;
> +	bool skip;
> +
> +	if (behavior != MADV_DONTNEED)
> +		return -EINVAL;
> +
> +	error = rw_copy_check_uvector(CHECK_IOVEC_ONLY, uvector, nr_segs,
> +			UIO_FASTIOV, iovstack, &iov);
> +	if (error <= 0)
> +		return error;
> +	/* Make sure address in ascend order */
> +	sort(iov, nr_segs, sizeof(struct iovec), iov_cmp_func, NULL);
> +
> +	vmas = kmalloc(nr_segs * sizeof(struct vm_area_struct *), GFP_KERNEL);
> +	if (!vmas) {
> +		error = -EFAULT;
> +		goto out;
> +	}
> +	for (i = 0; i < nr_segs; i++) {
> +		start = (unsigned long)iov[i].iov_base;
> +		len = ((iov[i].iov_len + ~PAGE_MASK) & PAGE_MASK);
> +		iov[i].iov_len = len;
> +		if (start < last_start) {
> +			error = -EINVAL;
> +			goto out;
> +		}
> +		if (!madvise_range_valid(start, len, &skip)) {
> +			error = -EINVAL;
> +			goto out;
> +		}
> +		if (skip) {
> +			error = 0;
> +			goto out;
> +		}
> +		last_start = start + len;
> +	}
> +
> +	down_read(&current->mm->mmap_sem);
> +	for (i = 0; i < nr_segs; i++) {
> +		start = (unsigned long)iov[i].iov_base;
> +		len = iov[i].iov_len;
> +		vmas[i] = find_vma(current->mm, start);
> +		/*
> +		 * don't allow range cross vma, it doesn't make sense for
> +		 * DONTNEED
> +		 */
> +		if (!vmas[i] || start < vmas[i]->vm_start ||
> +		    start + len > vmas[i]->vm_end) {
> +			error = -ENOMEM;
> +			goto up_out;
> +		}
> +		if (vmas[i]->vm_flags & (VM_LOCKED|VM_HUGETLB|VM_PFNMAP)) {
> +			error = -EINVAL;
> +			goto up_out;
> +		}
> +	}
> +
> +	lru_add_drain();
> +	tlb_gather_mmu(&tlb, current->mm, (unsigned long)iov[0].iov_base,
> +		last_start);
> +	update_hiwater_rss(current->mm);
> +	for (i = 0; i < nr_segs; i++) {
> +		start = (unsigned long)iov[i].iov_base;
> +		len = iov[i].iov_len;
> +		unmap_vmas(&tlb, vmas[i], start, start + len);
> +	}
> +	tlb_finish_mmu(&tlb, (unsigned long)iov[0].iov_base, last_start);
> +	error = 0;
> +
> +up_out:
> +	up_read(&current->mm->mmap_sem);
> +out:
> +	kfree(vmas);
> +	if (iov != iovstack)
> +		kfree(iov);
> +	return error;
> +}
> 
> 
> je.patch
> 
> 
> diff --git a/src/arena.c b/src/arena.c
> index 43733cc..ae2de35 100644
> --- a/src/arena.c
> +++ b/src/arena.c
> @@ -1266,6 +1266,7 @@ arena_dirty_count(arena_t *arena)
>  	return (ndirty);
>  }
>  
> +#define PURGE_VEC 1
>  static size_t
>  arena_compute_npurge(arena_t *arena, bool all)
>  {
> @@ -1280,6 +1281,10 @@ arena_compute_npurge(arena_t *arena, bool all)
>  		threshold = threshold < chunk_npages ? chunk_npages : threshold;
>  
>  		npurge = arena->ndirty - threshold;
> +#if PURGE_VEC
> +		if (npurge < arena->ndirty / 2)
> +			npurge = arena->ndirty / 2;
> +#endif
>  	} else
>  		npurge = arena->ndirty;
>  
> @@ -1366,6 +1371,16 @@ arena_stash_dirty(arena_t *arena, chunk_hooks_t *chunk_hooks, bool all,
>  	return (nstashed);
>  }
>  
> +#if PURGE_VEC
> +#define MAX_IOVEC 32
> +bool pages_purge_vec(struct iovec *iov, unsigned long nr_segs)
> +{
> +	int ret = syscall(325, iov, nr_segs, MADV_DONTNEED);
> +
> +	return !!ret;
> +}
> +#endif
> +
>  static size_t
>  arena_purge_stashed(arena_t *arena, chunk_hooks_t *chunk_hooks,
>      arena_runs_dirty_link_t *purge_runs_sentinel,
> @@ -1374,6 +1389,10 @@ arena_purge_stashed(arena_t *arena, chunk_hooks_t *chunk_hooks,
>  	size_t npurged, nmadvise;
>  	arena_runs_dirty_link_t *rdelm;
>  	extent_node_t *chunkselm;
> +#if PURGE_VEC
> +	struct iovec iovec[MAX_IOVEC];
> +	int vec_index = 0;
> +#endif
>  
>  	if (config_stats)
>  		nmadvise = 0;
> @@ -1418,9 +1437,21 @@ arena_purge_stashed(arena_t *arena, chunk_hooks_t *chunk_hooks,
>  				flag_unzeroed = 0;
>  				flags = CHUNK_MAP_DECOMMITTED;
>  			} else {
> +#if !PURGE_VEC
>  				flag_unzeroed = chunk_purge_wrapper(arena,
>  				    chunk_hooks, chunk, chunksize, pageind <<
>  				    LG_PAGE, run_size) ? CHUNK_MAP_UNZEROED : 0;
> +#else
> +				flag_unzeroed = 0;
> +				iovec[vec_index].iov_base = (void *)((uintptr_t)chunk +
> +					(pageind << LG_PAGE));
> +				iovec[vec_index].iov_len = run_size;
> +				vec_index++;
> +				if (vec_index >= MAX_IOVEC) {
> +					pages_purge_vec(iovec, vec_index);
> +					vec_index = 0;
> +				}
> +#endif
>  				flags = flag_unzeroed;
>  			}
>  			arena_mapbits_large_set(chunk, pageind+npages-1, 0,
> @@ -1449,6 +1480,10 @@ arena_purge_stashed(arena_t *arena, chunk_hooks_t *chunk_hooks,
>  		if (config_stats)
>  			nmadvise++;
>  	}
> +#if PURGE_VEC
> +	if (vec_index > 0)
> +		pages_purge_vec(iovec, vec_index);
> +#endif
>  	malloc_mutex_lock(&arena->lock);
>  
>  	if (config_stats) {
> 
