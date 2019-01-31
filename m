From: Michal Hocko <mhocko@kernel.org>
Subject: Re: [PATCH 1/3] mm/mincore: make mincore() more conservative
Date: Thu, 31 Jan 2019 10:43:57 +0100
Message-ID: <20190131094357.GQ18811@dhcp22.suse.cz>
References: <nycvar.YFH.7.76.1901051817390.16954@cbobk.fhfr.pm>
 <20190130124420.1834-1-vbabka@suse.cz>
 <20190130124420.1834-2-vbabka@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190130124420.1834-2-vbabka@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-api@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>, Greg KH <gregkh@linuxfoundation.org>, Jann Horn <jannh@google.com>, Jiri Kosina <jkosina@suse.cz>, Dominique Martinet <asmadeus@codewreck.org>, Andy Lutomirski <luto@amacapital.net>, Dave Chinner <david@fromorbit.com>, Kevin Easton <kevin@guarana.org>, Matthew Wilcox <willy@infradead.org>, Cyril Hrubis <chrubis@suse.cz>, Tejun Heo <tj@kernel.org>, "Kirill A . Shutemov" <kirill@shutemov.name>, Daniel Gruss <daniel@gruss.cc>, Jiri Kosina <jikos@kernel.org>
List-Id: linux-api@vger.kernel.org

On Wed 30-01-19 13:44:18, Vlastimil Babka wrote:
> From: Jiri Kosina <jkosina@suse.cz>
> 
> The semantics of what mincore() considers to be resident is not completely
> clear, but Linux has always (since 2.3.52, which is when mincore() was
> initially done) treated it as "page is available in page cache".
> 
> That's potentially a problem, as that [in]directly exposes meta-information
> about pagecache / memory mapping state even about memory not strictly belonging
> to the process executing the syscall, opening possibilities for sidechannel
> attacks.
> 
> Change the semantics of mincore() so that it only reveals pagecache information
> for non-anonymous mappings that belog to files that the calling process could
> (if it tried to) successfully open for writing.

I agree that this is a better way than the original 574823bfab82
("Change mincore() to count "mapped" pages rather than "cached" pages").
One thing is still not clear to me though. Is the new owner/writeable
check OK for the Netflix-like usecases? I mean does happycache have
appropriate access to the cache data? I have tried to re-read the
original thread but couldn't find any confirmation.

I nit below

> Originally-by: Linus Torvalds <torvalds@linux-foundation.org>
> Originally-by: Dominique Martinet <asmadeus@codewreck.org>
> Cc: Dominique Martinet <asmadeus@codewreck.org>
> Cc: Andy Lutomirski <luto@amacapital.net>
> Cc: Dave Chinner <david@fromorbit.com>
> Cc: Kevin Easton <kevin@guarana.org>
> Cc: Matthew Wilcox <willy@infradead.org>
> Cc: Cyril Hrubis <chrubis@suse.cz>
> Cc: Tejun Heo <tj@kernel.org>
> Cc: Kirill A. Shutemov <kirill@shutemov.name>
> Cc: Daniel Gruss <daniel@gruss.cc>
> Signed-off-by: Jiri Kosina <jkosina@suse.cz>
> Signed-off-by: Vlastimil Babka <vbabka@suse.cz>

other than that looks good to me.
Acked-by: Michal Hocko <mhocko@suse.com>

If this still doesn't help happycache kind of workloads then we should
add a capability check IMO but this looks like a decent foundation to
me.

> ---
>  mm/mincore.c | 15 ++++++++++++++-
>  1 file changed, 14 insertions(+), 1 deletion(-)
> 
> diff --git a/mm/mincore.c b/mm/mincore.c
> index 218099b5ed31..747a4907a3ac 100644
> --- a/mm/mincore.c
> +++ b/mm/mincore.c
> @@ -169,6 +169,14 @@ static int mincore_pte_range(pmd_t *pmd, unsigned long addr, unsigned long end,
>  	return 0;
>  }
>  
> +static inline bool can_do_mincore(struct vm_area_struct *vma)
> +{
> +	return vma_is_anonymous(vma) ||
> +		(vma->vm_file &&
> +			(inode_owner_or_capable(file_inode(vma->vm_file))
> +			 || inode_permission(file_inode(vma->vm_file), MAY_WRITE) == 0));
> +}

This is hard to read. Can we do
	if (vma_is_anonymous(vma))
		return true;
	if (!vma->vm_file)
		return false;
	return inode_owner_or_capable(file_inode(vma->vm_file)) ||
		inode_permission(file_inode(vma->vm_file), MAY_WRITE) == 0;

-- 
Michal Hocko
SUSE Labs
