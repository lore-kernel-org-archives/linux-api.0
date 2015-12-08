From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH V3][for-next] mm: add a new vector based madvise syscall
Date: Tue, 08 Dec 2015 22:37:47 +0100
Message-ID: <5198777.4WMnOS8J5R@wuerfel>
References: <7c6ce0f1fe29fc22faf72134f4e2674da8d3d149.1449532062.git.shli@fb.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <7c6ce0f1fe29fc22faf72134f4e2674da8d3d149.1449532062.git.shli@fb.com>
Sender: owner-linux-mm@kvack.org
To: Shaohua Li <shli@fb.com>
Cc: linux-mm@kvack.org, linux-api@vger.kernel.org, Kernel-team@fb.com, Andrew Morton <akpm@linux-foundation.org>, Rik van Riel <riel@redhat.com>, Mel Gorman <mgorman@suse.de>, Hugh Dickins <hughd@google.com>, Johannes Weiner <hannes@cmpxchg.org>, Andrea Arcangeli <aarcange@redhat.com>, Andi Kleen <andi@firstfloor.org>, Minchan Kim <minchan@kernel.org>
List-Id: linux-api@vger.kernel.org

On Monday 07 December 2015 15:54:07 Shaohua Li wrote:
> index dc1040a..08466c7 100644
> --- a/arch/x86/entry/syscalls/syscall_64.tbl
> +++ b/arch/x86/entry/syscalls/syscall_64.tbl
> @@ -333,6 +333,7 @@
>  324    common  membarrier              sys_membarrier
>  325    common  mlock2                  sys_mlock2
>  326    common  copy_file_range         sys_copy_file_range
> +327    common  madvisev                sys_madvisev
>  
>  #
>  # x32-specific system call numbers start at 512 to avoid cache impact
> 

An iovec has different sizes on 32-bit and 64-bit user space, so I think
it can't be marked "common" here and you need to implement a
compat_sys_madvisev function instead.

	Arnd

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
