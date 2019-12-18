From: Michal Hocko <mhocko@kernel.org>
Subject: Re: [PATCH] move_pages.2: not return ENOENT if the page are already
 on the target nodes
Date: Wed, 18 Dec 2019 11:17:11 +0100
Message-ID: <20191218101711.GB21485@dhcp22.suse.cz>
References: <1575596090-115377-1-git-send-email-yang.shi@linux.alibaba.com>
 <0dc96e40-5f2b-a2fe-6e5f-b6f3d5e9ebde@nvidia.com>
 <95170ea5-5b62-9168-fcd9-93b43330a1b4@linux.alibaba.com>
 <092adc11-7039-9343-7067-0e0199c9dc13@gmail.com>
 <51dd767a-221f-882d-c7f6-45bd0c217a67@nvidia.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <51dd767a-221f-882d-c7f6-45bd0c217a67@nvidia.com>
Sender: linux-kernel-owner@vger.kernel.org
To: John Hubbard <jhubbard@nvidia.com>
Cc: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>, Yang Shi <yang.shi@linux.alibaba.com>, cl@linux.com, cai@lca.pw, akpm@linux-foundation.org, linux-man@vger.kernel.org, linux-api@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Tue 17-12-19 23:36:09, John Hubbard wrote:
[...]
> diff --git a/man2/move_pages.2 b/man2/move_pages.2
> index 2d96468fa..1bf1053f2 100644
> --- a/man2/move_pages.2
> +++ b/man2/move_pages.2
> @@ -191,12 +191,6 @@ was specified or an attempt was made to migrate pages of a kernel thread.
>  .B ENODEV
>  One of the target nodes is not online.
>  .TP
> -.B ENOENT
> -No pages were found that require moving.
> -All pages are either already
> -on the target node, not present, had an invalid address or could not be
> -moved because they were mapped by multiple processes.
> -.TP
>  .B EPERM
>  The caller specified
>  .B MPOL_MF_MOVE_ALL
> 
> ...But I'm not sure if we should change the implementation, instead, so
> that it *can* return ENOENT. That's the main question to resolve before
> creating any more patches, I think.

I would start by dropping any note about ENOENT first. I am not really
sure there is a reasonable usecase for it but maybe somebody comes up
with something and only then we should consider it.

Feel free to add
Acked-by: Michal Hocko <mhocko@suse.com>

ideally with a kernel commit which removed the ENOENT.
-- 
Michal Hocko
SUSE Labs
