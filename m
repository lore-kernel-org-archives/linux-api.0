From: David Rientjes <rientjes@google.com>
Subject: Re: [PATCH] mm: update the description for madvise_remove
Date: Tue, 24 Jun 2014 15:44:33 -0700 (PDT)
Message-ID: <alpine.DEB.2.02.1406241542040.29176@chino.kir.corp.google.com>
References: <53A9116B.9030004@gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <53A9116B.9030004@gmail.com>
Sender: owner-linux-mm@kvack.org
To: Wang Sheng-Hui <shhuiw@gmail.com>, Michael Kerrisk <mtk.manpages@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>, Johannes Weiner <hannes@cmpxchg.org>, Andi Kleen <ak@linux.intel.com>, Vladimir Cernov <gg.kaspersky@gmail.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Tue, 24 Jun 2014, Wang Sheng-Hui wrote:

> 
> Currently, we have more filesystems supporting fallocate, e.g
> ext4/btrfs. Remove the outdated comment for madvise_remove.
> 
> Signed-off-by: Wang Sheng-Hui <shhuiw@gmail.com>
> ---
>  mm/madvise.c | 3 ---
>  1 file changed, 3 deletions(-)
> 
> diff --git a/mm/madvise.c b/mm/madvise.c
> index a402f8f..0938b30 100644
> --- a/mm/madvise.c
> +++ b/mm/madvise.c
> @@ -292,9 +292,6 @@ static long madvise_dontneed(struct vm_area_struct *vma,
>  /*
>   * Application wants to free up the pages and associated backing store.
>   * This is effectively punching a hole into the middle of a file.
> - *
> - * NOTE: Currently, only shmfs/tmpfs is supported for this operation.
> - * Other filesystems return -ENOSYS.
>   */
>  static long madvise_remove(struct vm_area_struct *vma,
>                                 struct vm_area_struct **prev,

[For those without context: this patch has been merged into the -mm tree.]

This reference also exists in the man-page for madvise(2), are you 
planning on removing it as well?

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
