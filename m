From: Michal Hocko <mhocko@kernel.org>
Subject: Re: [PATCH v2] mm/mremap: Fail map duplication attempts for private
 mappings
Date: Fri, 21 Jul 2017 16:36:44 +0200
Message-ID: <20170721143644.GC5944@dhcp22.suse.cz>
References: <20170720082058.GF9058@dhcp22.suse.cz>
 <1500583079-26504-1-git-send-email-mike.kravetz@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <owner-linux-mm@kvack.org>
Content-Disposition: inline
In-Reply-To: <1500583079-26504-1-git-send-email-mike.kravetz@oracle.com>
Sender: owner-linux-mm@kvack.org
To: Mike Kravetz <mike.kravetz@oracle.com>
Cc: linux-mm@kvack.org, Linux API <linux-api@vger.kernel.org>, linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, Andrea Arcangeli <aarcange@redhat.com>, Aaron Lu <aaron.lu@intel.com>, "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>, Vlastimil Babka <vbabka@suse.cz>, Anshuman Khandual <khandual@linux.vnet.ibm.com>
List-Id: linux-api@vger.kernel.org

On Thu 20-07-17 13:37:59, Mike Kravetz wrote:
> mremap will create a 'duplicate' mapping if old_size == 0 is
> specified.  Such duplicate mappings make no sense for private
> mappings.

sorry for the nit picking but this is not true strictly speaking.
It makes some sense, arguably (e.g. take an atomic snapshot of the
mapping). It doesn't make any sense with the _current_ implementation.

> If duplication is attempted for a private mapping,
> mremap creates a separate private mapping unrelated to the
> original mapping and makes no modifications to the original.
> This is contrary to the purpose of mremap which should return
> a mapping which is in some way related to the original.
> 
> Therefore, return EINVAL in the case where if an attempt is
> made to duplicate a private mapping.  Also, print a warning
> message (once) if such an attempt is made.
> 
> Signed-off-by: Mike Kravetz <mike.kravetz@oracle.com>

I do not insist on the comment update suggested
http://lkml.kernel.org/r/20170720082058.GF9058@dhcp22.suse.cz
but I would appreciate it...

Other than that looks reasonably to me

Acked-by: Michal Hocko <mhocko@suse.com>

> ---
>  mm/mremap.c | 9 +++++++++
>  1 file changed, 9 insertions(+)
> 
> diff --git a/mm/mremap.c b/mm/mremap.c
> index cd8a1b1..949f6a7 100644
> --- a/mm/mremap.c
> +++ b/mm/mremap.c
> @@ -383,6 +383,15 @@ static struct vm_area_struct *vma_to_resize(unsigned long addr,
>  	if (!vma || vma->vm_start > addr)
>  		return ERR_PTR(-EFAULT);
>  
> +	/*
> +	 * !old_len  is a special case where a mapping is 'duplicated'.
> +	 * Do not allow this for private mappings.
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
> 

-- 
Michal Hocko
SUSE Labs

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
