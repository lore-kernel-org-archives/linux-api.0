From: "Kirill A. Shutemov" <kirill@shutemov.name>
Subject: Re: [RFC PATCH] mm,mremap: Bail out earlier in mremap_to under map
 pressure
Date: Fri, 22 Feb 2019 16:01:25 +0300
Message-ID: <20190222130125.apa2ysnahgfuj2vx@kshutemo-mobl1>
References: <20190221085406.10852-1-osalvador@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190221085406.10852-1-osalvador@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Oscar Salvador <osalvador@suse.de>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, hughd@google.com, vbabka@suse.cz, joel@joelfernandes.org, jglisse@redhat.com, yang.shi@linux.alibaba.com, mgorman@techsingularity.net
List-Id: linux-api@vger.kernel.org

On Thu, Feb 21, 2019 at 09:54:06AM +0100, Oscar Salvador wrote:
> When using mremap() syscall in addition to MREMAP_FIXED flag,
> mremap() calls mremap_to() which does the following:
> 
> 1) unmaps the destination region where we are going to move the map
> 2) If the new region is going to be smaller, we unmap the last part
>    of the old region
> 
> Then, we will eventually call move_vma() to do the actual move.
> 
> move_vma() checks whether we are at least 4 maps below max_map_count
> before going further, otherwise it bails out with -ENOMEM.
> The problem is that we might have already unmapped the vma's in steps
> 1) and 2), so it is not possible for userspace to figure out the state
> of the vma's after it gets -ENOMEM, and it gets tricky for userspace
> to clean up properly on error path.
> 
> While it is true that we can return -ENOMEM for more reasons
> (e.g: see may_expand_vm() or move_page_tables()), I think that we can
> avoid this scenario in concret if we check early in mremap_to() if the
> operation has high chances to succeed map-wise.
> 
> Should not be that the case, we can bail out before we even try to unmap
> anything, so we make sure the vma's are left untouched in case we are likely
> to be short of maps.
> 
> The thumb-rule now is to rely on the worst-scenario case we can have.
> That is when both vma's (old region and new region) are going to be split
> in 3, so we get two more maps to the ones we already hold (one per each).
> If current map count + 2 maps still leads us to 4 maps below the threshold,
> we are going to pass the check in move_vma().
> 
> Of course, this is not free, as it might generate false positives when it is
> true that we are tight map-wise, but the unmap operation can release several
> vma's leading us to a good state.
> 
> Because of that I am sending this as a RFC.
> Another approach was also investigated [1], but it may be too much hassle
> for what it brings.

I believe we don't need the check in move_vma() with this patch. Or do we?

> 
> [1] https://lore.kernel.org/lkml/20190219155320.tkfkwvqk53tfdojt@d104.suse.de/
> 
> Signed-off-by: Oscar Salvador <osalvador@suse.de>
> ---
>  mm/mremap.c | 17 +++++++++++++++++
>  1 file changed, 17 insertions(+)
> 
> diff --git a/mm/mremap.c b/mm/mremap.c
> index 3320616ed93f..e3edef6b7a12 100644
> --- a/mm/mremap.c
> +++ b/mm/mremap.c
> @@ -516,6 +516,23 @@ static unsigned long mremap_to(unsigned long addr, unsigned long old_len,
>  	if (addr + old_len > new_addr && new_addr + new_len > addr)
>  		goto out;
>  
> +	/*
> +	 * move_vma() need us to stay 4 maps below the threshold, otherwise
> +	 * it will bail out at the very beginning.
> +	 * That is a problem if we have already unmaped the regions here
> +	 * (new_addr, and old_addr), because userspace will not know the
> +	 * state of the vma's after it gets -ENOMEM.
> +	 * So, to avoid such scenario we can pre-compute if the whole
> +	 * operation has high chances to success map-wise.
> +	 * Worst-scenario case is when both vma's (new_addr and old_addr) get
> +	 * split in 3 before unmaping it.
> +	 * That means 2 more maps (1 for each) to the ones we already hold.
> +	 * Check whether current map count plus 2 still leads us to 4 maps below
> +	 * the threshold, otherwise return -ENOMEM here to be more safe.
> +	 */
> +	if ((mm->map_count + 2) >= sysctl_max_map_count - 3)

Nit: redundant parentheses around 'mm->map_count + 2'.

> +		return -ENOMEM;
> +
>  	ret = do_munmap(mm, new_addr, new_len, uf_unmap_early);
>  	if (ret)
>  		goto out;
> -- 
> 2.13.7
> 

-- 
 Kirill A. Shutemov
