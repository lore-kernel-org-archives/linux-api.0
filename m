From: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v2] mm/mremap: Fail map duplication attempts for private
 mappings
Date: Mon, 24 Jul 2017 10:50:46 +0200
Message-ID: <20170724085045.GD25221@dhcp22.suse.cz>
References: <20170720082058.GF9058@dhcp22.suse.cz>
 <1500583079-26504-1-git-send-email-mike.kravetz@oracle.com>
 <20170721143644.GC5944@dhcp22.suse.cz>
 <cb9d9f6a-7095-582f-15a5-62643d65c736@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <cb9d9f6a-7095-582f-15a5-62643d65c736-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mike Kravetz <mike.kravetz-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Andrea Arcangeli <aarcange-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Aaron Lu <aaron.lu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Kirill A . Shutemov" <kirill.shutemov-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>, Anshuman Khandual <khandual-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Fri 21-07-17 14:18:31, Mike Kravetz wrote:
[...]
> >From 5c4a1602bd6a942544ed011dc0a72fd258e874b2 Mon Sep 17 00:00:00 2001
> From: Mike Kravetz <mike.kravetz-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> Date: Wed, 12 Jul 2017 13:52:47 -0700
> Subject: [PATCH] mm/mremap: Fail map duplication attempts for private mappings
> 
> mremap will attempt to create a 'duplicate' mapping if old_size
> == 0 is specified.  In the case of private mappings, mremap
> will actually create a fresh separate private mapping unrelated
> to the original.  This does not fit with the design semantics of
> mremap as the intention is to create a new mapping based on the
> original.
> 
> Therefore, return EINVAL in the case where an attempt is made
> to duplicate a private mapping.  Also, print a warning message
> (once) if such an attempt is made.
> 
> Signed-off-by: Mike Kravetz <mike.kravetz-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>

Acked-by: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>

Thanks!

> ---
>  mm/mremap.c | 13 +++++++++++++
>  1 file changed, 13 insertions(+)
> 
> diff --git a/mm/mremap.c b/mm/mremap.c
> index cd8a1b1..75b167d 100644
> --- a/mm/mremap.c
> +++ b/mm/mremap.c
> @@ -383,6 +383,19 @@ static struct vm_area_struct *vma_to_resize(unsigned long addr,
>  	if (!vma || vma->vm_start > addr)
>  		return ERR_PTR(-EFAULT);
>  
> +	/*
> +	 * !old_len is a special case where an attempt is made to 'duplicate'
> +	 * a mapping.  This makes no sense for private mappings as it will
> +	 * instead create a fresh/new mapping unrelated to the original.  This
> +	 * is contrary to the basic idea of mremap which creates new mappings
> +	 * based on the original.  There are no known use cases for this
> +	 * behavior.  As a result, fail such attempts.
> +	 */
> +	if (!old_len && !(vma->vm_flags & (VM_SHARED | VM_MAYSHARE))) {
> +		pr_warn_once("%s (%d): attempted to duplicate a private mapping with mremap.  This is not supported.\n", current->comm, current->pid);
> +		return ERR_PTR(-EINVAL);
> +	}
> +
>  	if (is_vm_hugetlb_page(vma))
>  		return ERR_PTR(-EINVAL);
>  
> -- 
> 2.7.5

-- 
Michal Hocko
SUSE Labs
