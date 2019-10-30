From: Yang Shi <yang.shi@linux.alibaba.com>
Subject: Re: mbind() breaks its API definition since v5.2 by commit
 d883544515aa (mm: mempolicy: make the behavior consistent when MPOL_MF_MOVE*
 and MPOL_MF_STRICT were specified)
Date: Tue, 29 Oct 2019 19:50:11 -0700
Message-ID: <dc4864bf-8fa3-f5c8-f68c-57edc68d4662@linux.alibaba.com>
References: <2019103010274679257634@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <2019103010274679257634@gmail.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Li Xinhai <lixinhai.lxh@gmail.com>, linux-mm <linux-mm@kvack.org>, akpm <akpm@linux-foundation.org>, torvalds <torvalds@linux-foundation.org>
Cc: Vlastimil Babka <vbabka@suse.cz>, Linux API <linux-api@vger.kernel.org>, Michal Hocko <mhocko@kernel.org>, Hugh Dickins <hughd@google.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, lixinhai_lxh <lixinhai_lxh@126.com>
List-Id: linux-api@vger.kernel.org



On 10/29/19 7:27 PM, Li Xinhai wrote:
> One change in do_mbind() of this commit has suspicious usage of return value of
> queue_pages_range(), excerpt as below:
>
> ---
> @@ -1243,10 +1265,15 @@ static long do_mbind(unsigned long start, unsigned long len,
>   	if (err)
>   		goto mpol_out;
>   
> -	err = queue_pages_range(mm, start, end, nmask,
> +	ret = queue_pages_range(mm, start, end, nmask,
>   			  flags | MPOL_MF_INVERT, &pagelist);
> -	if (!err)
> -		err = mbind_range(mm, start, end, new);
> +
> +	if (ret < 0) {      /////// convert to all possible 'ret' to '-EIO' <<<<
> +		err = -EIO;
> +		goto up_out;
> +	}
> +
> +	err = mbind_range(mm, start, end, new);
>   
>   	if (!err) {
>   		int nr_failed = 0;
> ---
>
> Note that inside queue_pages_range(), the call to walk_page_range() may return
> errors from 'test_walk' of 'struct mm_walk_ops', e.g. -EFAULT. Now, those error
> codes are no longer reported to user space application.
>
>  From user space, the mbind() call need to reported error, with EFAULT, as example:
> EFAULT
> Part or all of the memory range specified by nodemask and maxnode points
> outside your accessible address space. Or, there was an unmapped hole in the
> specified memory range specified by addr and len.

Thanks for catching this. That commit was aimed to correct the return 
values for some corner cases in mbind(), but it should not alter the 
errno for other failure cases, i.e. -EFAULT.

Could you please try the below patch (build test only)?

diff --git a/mm/mempolicy.c b/mm/mempolicy.c
index 4ae967b..99df43a 100644
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -1286,7 +1286,7 @@ static long do_mbind(unsigned long start, unsigned 
long len,
                           flags | MPOL_MF_INVERT, &pagelist);

         if (ret < 0) {
-               err = -EIO;
+               err = ret;
                 goto up_out;
         }


>
> Please correct me if this is the intended change(and will have updated API
> definition), or something was misunderstood.
>
> -Xinhai
