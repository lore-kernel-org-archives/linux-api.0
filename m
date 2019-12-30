From: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Subject: Re: [PATCH] move_pages.2: remove ENOENT from the list of possible
 return values
Date: Mon, 30 Dec 2019 19:55:00 +0100
Message-ID: <56530a26-e5b4-1441-521b-8dc6580f90c7@gmail.com>
References: <20191219051347.1278026-1-jhubbard@nvidia.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20191219051347.1278026-1-jhubbard@nvidia.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: John Hubbard <jhubbard@nvidia.com>
Cc: mtk.manpages@gmail.com, linux-man@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, Christopher Lameter <cl@linux.com>, linux-api@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, linux-mm@kvack.org, Michal Hocko <mhocko@suse.com>, Brice Goglin <Brice.Goglin@inria.fr>, Yang Shi <yang.shi@linux.alibaba.com>
List-Id: linux-api@vger.kernel.org

Hello John,

On 12/19/19 6:13 AM, John Hubbard wrote:
> Linux kernel commit e78bbfa82624 ("mm: stop returning -ENOENT from
> sys_move_pages() if nothing got migrated") had the effect of *never*
> returning -ENOENT, in any situation. So we need to update the man page
> to reflect that ENOENT is not a possible return value.
> 
> Acked-by: Michal Hocko <mhocko@suse.com>
> Cc: Brice Goglin <Brice.Goglin@inria.fr>
> Cc: Yang Shi <yang.shi@linux.alibaba.com>
> Cc: Christoph Lameter <cl@linux.com>
> Signed-off-by: John Hubbard <jhubbard@nvidia.com>
> ---
> 
> Hi,
> 
> This fix for the man page was ACK'd by Michal, here:
> 
> https://lore.kernel.org/r/20191218101711.GB21485@dhcp22.suse.cz

Thanks. Patch applied.

Cheers,

Michael

>  man2/move_pages.2 | 6 ------
>  1 file changed, 6 deletions(-)
> 
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


-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Linux/UNIX System Programming Training: http://man7.org/training/
