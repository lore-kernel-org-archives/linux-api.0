From: John Hubbard <jhubbard@nvidia.com>
Subject: Re: [PATCH] move_pages.2: not return ENOENT if the page are already
 on the target nodes
Date: Thu, 5 Dec 2019 17:47:35 -0800
Message-ID: <683f6cae-0e0c-d4e4-0929-7fd1a79a2266@nvidia.com>
References: <1575596090-115377-1-git-send-email-yang.shi@linux.alibaba.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1575596090-115377-1-git-send-email-yang.shi@linux.alibaba.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Yang Shi <yang.shi@linux.alibaba.com>, mtk.manpages@gmail.com, cl@linux.com, mhocko@suse.com, cai@lca.pw, akpm@linux-foundation.org
Cc: linux-man@vger.kernel.org, linux-api@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On 12/5/19 5:34 PM, Yang Shi wrote:
...
> 
> diff --git a/man2/move_pages.2 b/man2/move_pages.2
> index 2d96468..2a2f3cd 100644
> --- a/man2/move_pages.2
> +++ b/man2/move_pages.2
> @@ -192,9 +192,8 @@ was specified or an attempt was made to migrate pages of a kernel thread.
>  One of the target nodes is not online.
>  .TP
>  .B ENOENT
> -No pages were found that require moving.
> -All pages are either already
> -on the target node, not present, had an invalid address or could not be
> +No pages were found.
> +All pages are either not present, had an invalid address or could not be
>  moved because they were mapped by multiple processes.

How about this wording (ignoring man formatting for the moment):

No pages were moved, because all requested pages fell into one or more of
the following cases:

* Page not present.
* Page has an invalid address.
* Page is mapped by multiple processes.

Reasoning: I don't like the "no pages were found" all by itself, because it
blindly rewords the meaning of ENOENT. ENOENT is merely the closest
symbol we have. So we use ENOENT and that's fine, but the descriptive text 
should describe what really happened, which is "no pages were moved". If we had 
an ENOPAGESMOVED then we'd use that. :)

thanks,
-- 
John Hubbard
NVIDIA
