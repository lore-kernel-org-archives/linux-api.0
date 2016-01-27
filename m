From: Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [PATCH v1] mm/madvise: pass return code of memory_failure() to
 userspace
Date: Wed, 27 Jan 2016 14:59:11 +0100
Message-ID: <56A8CD2F.5080903@suse.cz>
References: <1453451277-20979-1-git-send-email-n-horiguchi@ah.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1453451277-20979-1-git-send-email-n-horiguchi-PaJj6Psr51x8UrSeD/g0lQ@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Naoya Horiguchi <n-horiguchi-PaJj6Psr51x8UrSeD/g0lQ@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Chen Gong <gong.chen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Naoya Horiguchi <nao.horiguchi-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-man-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-api@vger.kernel.org

[CC += linux-api, linux-man]

On 01/22/2016 09:27 AM, Naoya Horiguchi wrote:
> Currently the return value of memory_failure() is not passed to userspace, which
> is inconvenient for test programs that want to know the result of error handling.
> So let's return it to the caller as we already do in MADV_SOFT_OFFLINE case.
> 
> Signed-off-by: Naoya Horiguchi <n-horiguchi-PaJj6Psr51x8UrSeD/g0lQ@public.gmane.org>
> ---
>  mm/madvise.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git v4.4-mmotm-2016-01-20-16-10/mm/madvise.c v4.4-mmotm-2016-01-20-16-10_patched/mm/madvise.c
> index f56825b..6a77114 100644
> --- v4.4-mmotm-2016-01-20-16-10/mm/madvise.c
> +++ v4.4-mmotm-2016-01-20-16-10_patched/mm/madvise.c
> @@ -555,8 +555,9 @@ static int madvise_hwpoison(int bhv, unsigned long start, unsigned long end)
>  		}
>  		pr_info("Injecting memory failure for page %#lx at %#lx\n",
>  		       page_to_pfn(p), start);
> -		/* Ignore return value for now */
> -		memory_failure(page_to_pfn(p), 0, MF_COUNT_INCREASED);
> +		ret = memory_failure(page_to_pfn(p), 0, MF_COUNT_INCREASED);
> +		if (ret)
> +			return ret;

Can you explain what madvise can newly return for MADV_HWPOISON in which
situations, for the purposes of updated man page?

Thanks,
Vlastimil

>  	}
>  	return 0;
>  }
> 
