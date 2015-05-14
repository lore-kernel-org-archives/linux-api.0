From: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Subject: Re: [PATCH 2/2] mmap2: clarify MAP_POPULATE
Date: Thu, 14 May 2015 15:36:16 +0200
Message-ID: <5554A4D0.1020405@gmail.com>
References: <1431527892-2996-1-git-send-email-miso@dhcp22.suse.cz> <1431527892-2996-3-git-send-email-miso@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <1431527892-2996-3-git-send-email-miso@dhcp22.suse.cz>
Sender: owner-linux-mm@kvack.org
To: Michal Hocko <miso@dhcp22.suse.cz>
Cc: mtk.manpages@gmail.com, Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, David Rientjes <rientjes@google.com>, LKML <linux-kernel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, linux-mm@kvack.org, Michal Hocko <mhocko@suse.cz>
List-Id: linux-api@vger.kernel.org

On 05/13/2015 04:38 PM, Michal Hocko wrote:
> From: Michal Hocko <mhocko@suse.cz>
> 
> David Rientjes has noticed that MAP_POPULATE wording might promise much
> more than the kernel actually provides and intend to provide. The
> primary usage of the flag is to pre-fault the range. There is no
> guarantee that no major faults will happen later on. The pages might
> have been reclaimed by the time the process tries to access them.

Yes, thanks, Michal -- that's a good point to make clearer.
Applied, with Reviewed-by: from Eric added.

Cheers,

Michael

> Signed-off-by: Michal Hocko <mhocko@suse.cz>
> ---
>  man2/mmap.2 | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/man2/mmap.2 b/man2/mmap.2
> index 1486be2e96b3..dcf306f2f730 100644
> --- a/man2/mmap.2
> +++ b/man2/mmap.2
> @@ -284,7 +284,7 @@ private writable mappings.
>  .BR MAP_POPULATE " (since Linux 2.5.46)"
>  Populate (prefault) page tables for a mapping.
>  For a file mapping, this causes read-ahead on the file.
> -Later accesses to the mapping will not be blocked by page faults.
> +This will help to reduce blocking on page faults later.
>  .BR MAP_POPULATE
>  is supported for private mappings only since Linux 2.6.23.
>  .TP
> 


-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Linux/UNIX System Programming Training: http://man7.org/training/

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
