From: "Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 26/34] mm: implement new mprotect_key() system call
Date: Sat, 05 Dec 2015 07:50:51 +0100
Message-ID: <5662894B.7090903@gmail.com>
References: <20151204011424.8A36E365@viggo.jf.intel.com> <20151204011500.69487A6C@viggo.jf.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20151204011500.69487A6C-LXbPSdftPKxrdx17CPfAsdBPR1lH4CV8@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dave Hansen <dave-gkUM19QKKo4@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, dave.hansen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

Dave,

On 12/04/2015 02:15 AM, Dave Hansen wrote:
> From: Dave Hansen <dave.hansen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
> 
> mprotect_key() is just like mprotect, except it also takes a
> protection key as an argument.  On systems that do not support
> protection keys, it still works, but requires that key=0.
> Otherwise it does exactly what mprotect does.

Is there a man page for this API?

Thanks,

Michael


> I expect it to get used like this, if you want to guarantee that
> any mapping you create can *never* be accessed without the right
> protection keys set up.
> 
> 	pkey_deny_access(11); // random pkey
> 	int real_prot = PROT_READ|PROT_WRITE;
> 	ptr = mmap(NULL, PAGE_SIZE, PROT_NONE, MAP_ANONYMOUS|MAP_PRIVATE, -1, 0);
> 	ret = mprotect_key(ptr, PAGE_SIZE, real_prot, 11);
> 
> This way, there is *no* window where the mapping is accessible
> since it was always either PROT_NONE or had a protection key set.
> 
> We settled on 'unsigned long' for the type of the key here.  We
> only need 4 bits on x86 today, but I figured that other
> architectures might need some more space.
> 
> Signed-off-by: Dave Hansen <dave.hansen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
> Cc: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> ---
> 
>  b/arch/x86/include/asm/mmu_context.h |   10 +++++++--
>  b/include/linux/pkeys.h              |    7 +++++-
>  b/mm/Kconfig                         |    7 ++++++
>  b/mm/mprotect.c                      |   36 +++++++++++++++++++++++++++++------
>  4 files changed, 51 insertions(+), 9 deletions(-)
> 
> diff -puN arch/x86/include/asm/mmu_context.h~pkeys-85-mprotect_pkey arch/x86/include/asm/mmu_context.h
> --- a/arch/x86/include/asm/mmu_context.h~pkeys-85-mprotect_pkey	2015-12-03 16:21:30.181877894 -0800
> +++ b/arch/x86/include/asm/mmu_context.h	2015-12-03 16:21:30.190878302 -0800
> @@ -4,6 +4,7 @@
>  #include <asm/desc.h>
>  #include <linux/atomic.h>
>  #include <linux/mm_types.h>
> +#include <linux/pkeys.h>
>  
>  #include <trace/events/tlb.h>
>  
> @@ -243,10 +244,14 @@ static inline void arch_unmap(struct mm_
>  		mpx_notify_unmap(mm, vma, start, end);
>  }
>  
> +#ifdef CONFIG_X86_INTEL_MEMORY_PROTECTION_KEYS
> +/*
> + * If the config option is off, we get the generic version from
> + * include/linux/pkeys.h.
> + */
>  static inline int vma_pkey(struct vm_area_struct *vma)
>  {
>  	u16 pkey = 0;
> -#ifdef CONFIG_X86_INTEL_MEMORY_PROTECTION_KEYS
>  	unsigned long vma_pkey_mask = VM_PKEY_BIT0 | VM_PKEY_BIT1 |
>  				      VM_PKEY_BIT2 | VM_PKEY_BIT3;
>  	/*
> @@ -259,9 +264,10 @@ static inline int vma_pkey(struct vm_are
>  	 */
>  	pkey = (vma->vm_flags >> vm_pkey_shift) &
>  	       (vma_pkey_mask >> vm_pkey_shift);
> -#endif
> +
>  	return pkey;
>  }
> +#endif
>  
>  static inline bool __pkru_allows_pkey(u16 pkey, bool write)
>  {
> diff -puN include/linux/pkeys.h~pkeys-85-mprotect_pkey include/linux/pkeys.h
> --- a/include/linux/pkeys.h~pkeys-85-mprotect_pkey	2015-12-03 16:21:30.183877985 -0800
> +++ b/include/linux/pkeys.h	2015-12-03 16:21:30.190878302 -0800
> @@ -2,10 +2,10 @@
>  #define _LINUX_PKEYS_H
>  
>  #include <linux/mm_types.h>
> -#include <asm/mmu_context.h>
>  
>  #ifdef CONFIG_ARCH_HAS_PKEYS
>  #include <asm/pkeys.h>
> +#include <asm/mmu_context.h>
>  #else /* ! CONFIG_ARCH_HAS_PKEYS */
>  
>  /*
> @@ -17,6 +17,11 @@ static inline bool arch_validate_pkey(in
>  {
>  	return true;
>  }
> +
> +static inline int vma_pkey(struct vm_area_struct *vma)
> +{
> +	return 0;
> +}
>  #endif /* ! CONFIG_ARCH_HAS_PKEYS */
>  
>  #endif /* _LINUX_PKEYS_H */
> diff -puN mm/Kconfig~pkeys-85-mprotect_pkey mm/Kconfig
> --- a/mm/Kconfig~pkeys-85-mprotect_pkey	2015-12-03 16:21:30.185878075 -0800
> +++ b/mm/Kconfig	2015-12-03 16:21:30.190878302 -0800
> @@ -673,3 +673,10 @@ config ARCH_USES_HIGH_VMA_FLAGS
>  	bool
>  config ARCH_HAS_PKEYS
>  	bool
> +
> +config NR_PROTECTION_KEYS
> +	int
> +	# Everything supports a _single_ key, so allow folks to
> +	# at least call APIs that take keys, but require that the
> +	# key be 0.
> +	default 1
> diff -puN mm/mprotect.c~pkeys-85-mprotect_pkey mm/mprotect.c
> --- a/mm/mprotect.c~pkeys-85-mprotect_pkey	2015-12-03 16:21:30.186878121 -0800
> +++ b/mm/mprotect.c	2015-12-03 16:21:30.191878347 -0800
> @@ -24,6 +24,7 @@
>  #include <linux/migrate.h>
>  #include <linux/perf_event.h>
>  #include <linux/ksm.h>
> +#include <linux/pkeys.h>
>  #include <asm/uaccess.h>
>  #include <asm/pgtable.h>
>  #include <asm/cacheflush.h>
> @@ -344,10 +345,13 @@ fail:
>  	return error;
>  }
>  
> -SYSCALL_DEFINE3(mprotect, unsigned long, start, size_t, len,
> -		unsigned long, prot)
> +/*
> + * pkey=-1 when doing a legacy mprotect()
> + */
> +static int do_mprotect_pkey(unsigned long start, size_t len,
> +		unsigned long prot, int pkey)
>  {
> -	unsigned long vm_flags, nstart, end, tmp, reqprot;
> +	unsigned long nstart, end, tmp, reqprot;
>  	struct vm_area_struct *vma, *prev;
>  	int error = -EINVAL;
>  	const int grows = prot & (PROT_GROWSDOWN|PROT_GROWSUP);
> @@ -373,8 +377,6 @@ SYSCALL_DEFINE3(mprotect, unsigned long,
>  	if ((prot & PROT_READ) && (current->personality & READ_IMPLIES_EXEC))
>  		prot |= PROT_EXEC;
>  
> -	vm_flags = calc_vm_prot_bits(prot, 0);
> -
>  	down_write(&current->mm->mmap_sem);
>  
>  	vma = find_vma(current->mm, start);
> @@ -407,7 +409,14 @@ SYSCALL_DEFINE3(mprotect, unsigned long,
>  
>  		/* Here we know that vma->vm_start <= nstart < vma->vm_end. */
>  
> -		newflags = vm_flags;
> +		/*
> +		 * If this is a vanilla, non-pkey mprotect, inherit the
> +		 * pkey from the VMA we are working on.
> +		 */
> +		if (pkey == -1)
> +			newflags = calc_vm_prot_bits(prot, vma_pkey(vma));
> +		else
> +			newflags = calc_vm_prot_bits(prot, pkey);
>  		newflags |= (vma->vm_flags & ~(VM_READ | VM_WRITE | VM_EXEC));
>  
>  		/* newflags >> 4 shift VM_MAY% in place of VM_% */
> @@ -443,3 +452,18 @@ out:
>  	up_write(&current->mm->mmap_sem);
>  	return error;
>  }
> +
> +SYSCALL_DEFINE3(mprotect, unsigned long, start, size_t, len,
> +		unsigned long, prot)
> +{
> +	return do_mprotect_pkey(start, len, prot, -1);
> +}
> +
> +SYSCALL_DEFINE4(pkey_mprotect, unsigned long, start, size_t, len,
> +		unsigned long, prot, int, pkey)
> +{
> +	if (!arch_validate_pkey(pkey))
> +		return -EINVAL;
> +
> +	return do_mprotect_pkey(start, len, prot, pkey);
> +}
> _
> --
> To unsubscribe from this list: send the line "unsubscribe linux-api" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 


-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Linux/UNIX System Programming Training: http://man7.org/training/
