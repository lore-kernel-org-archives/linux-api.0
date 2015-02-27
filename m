From: Michael Kerrisk <mtk.manpages@gmail.com>
Subject: Re: [PATCH 1/4] mm, documentation: clarify /proc/pid/status VmSwap limitations
Date: Fri, 27 Feb 2015 11:37:35 +0100
Message-ID: <CAHO5Pa2NM6Vt2K6De2jZSEmH-ayDQafYhrJk4AK06Syo_1RUkw@mail.gmail.com>
References: <1424958666-18241-1-git-send-email-vbabka@suse.cz> <1424958666-18241-2-git-send-email-vbabka@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <1424958666-18241-2-git-send-email-vbabka@suse.cz>
Sender: owner-linux-mm@kvack.org
To: Vlastimil Babka <vbabka@suse.cz>
Cc: linux-mm <linux-mm@kvack.org>, Jerome Marchand <jmarchan@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, linux-doc <linux-doc@vger.kernel.org>, Hugh Dickins <hughd@google.com>, Michal Hocko <mhocko@suse.cz>, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>, Cyrill Gorcunov <gorcunov@openvz.org>, Randy Dunlap <rdunlap@infradead.org>, linux-s390 <linux-s390@vger.kernel.org>, Martin Schwidefsky <schwidefsky@de.ibm.com>, Heiko Carstens <heiko.carstens@de.ibm.com>, Peter Zijlstra <peterz@infradead.org>, Paul Mackerras <paulus@samba.org>, Arnaldo Carvalho de Melo <acme@kernel.org>, Oleg Nesterov <oleg@redhat.com>, Linux API <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

[CC += linux-api@]

On Thu, Feb 26, 2015 at 2:51 PM, Vlastimil Babka <vbabka@suse.cz> wrote:
> The documentation for /proc/pid/status does not mention that the value of
> VmSwap counts only swapped out anonymous private pages and not shmem. This is
> not obvious, so document this limitation.
>
> Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
> ---
> I've noticed that proc(5) manpage is currently missing the VmSwap field
> altogether.
>
>  Documentation/filesystems/proc.txt | 2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/Documentation/filesystems/proc.txt b/Documentation/filesystems/proc.txt
> index a07ba61..d4f56ec 100644
> --- a/Documentation/filesystems/proc.txt
> +++ b/Documentation/filesystems/proc.txt
> @@ -231,6 +231,8 @@ Table 1-2: Contents of the status files (as of 2.6.30-rc7)
>   VmLib                       size of shared library code
>   VmPTE                       size of page table entries
>   VmSwap                      size of swap usage (the number of referred swapents)
> +                             by anonymous private data (shmem swap usage is not
> +                             included)
>   Threads                     number of threads
>   SigQ                        number of signals queued/max. number for queue
>   SigPnd                      bitmap of pending signals for the thread
> --
> 2.1.4
>
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo@kvack.org.  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>



-- 
Michael Kerrisk Linux man-pages maintainer;
http://www.kernel.org/doc/man-pages/
Author of "The Linux Programming Interface", http://blog.man7.org/

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
