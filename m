From: Vlastimil Babka <vbabka@suse.cz>
Subject: Re: [PATCH RFC v2 2/4] mm/mempolicy: remove redundant check in
 get_nodes
Date: Tue, 31 Oct 2017 09:55:35 +0100
Message-ID: <61a0b15c-8a68-230a-5f5b-3f5025dff24a@suse.cz>
References: <1509099265-30868-1-git-send-email-xieyisheng1@huawei.com>
 <1509099265-30868-3-git-send-email-xieyisheng1@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <1509099265-30868-3-git-send-email-xieyisheng1@huawei.com>
Content-Language: en-US
Sender: owner-linux-mm@kvack.org
To: Yisheng Xie <xieyisheng1@huawei.com>, akpm@linux-foundation.org, mhocko@suse.com, mingo@kernel.org, rientjes@google.com, n-horiguchi@ah.jp.nec.com, salls@cs.ucsb.edu
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, tanxiaojun@huawei.com, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On 10/27/2017 12:14 PM, Yisheng Xie wrote:
> We have already checked whether maxnode is a page worth of bits, by:
>     maxnode > PAGE_SIZE*BITS_PER_BYTE
> 
> So no need to check it once more.
> 
> Signed-off-by: Yisheng Xie <xieyisheng1@huawei.com>

Acked-by: Vlastimil Babka <vbabka@suse.cz>

> ---
>  mm/mempolicy.c | 2 --
>  1 file changed, 2 deletions(-)
> 
> diff --git a/mm/mempolicy.c b/mm/mempolicy.c
> index 613e9d0..3b51bb3 100644
> --- a/mm/mempolicy.c
> +++ b/mm/mempolicy.c
> @@ -1280,8 +1280,6 @@ static int get_nodes(nodemask_t *nodes, const unsigned long __user *nmask,
>  	/* When the user specified more nodes than supported just check
>  	   if the non supported part is all zero. */
>  	if (nlongs > BITS_TO_LONGS(MAX_NUMNODES)) {
> -		if (nlongs > PAGE_SIZE/sizeof(long))
> -			return -EINVAL;
>  		for (k = BITS_TO_LONGS(MAX_NUMNODES); k < nlongs; k++) {
>  			unsigned long t;
>  			if (get_user(t, nmask + k))
> 

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
