From: Mike Rapoport <rppt-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Subject: Re: [PATCH v2] mmap.2: MAP_FIXED updated documentation
Date: Mon, 4 Dec 2017 13:31:13 +0200
Message-ID: <20171204113113.GA13465@rapoport-lnx>
References: <20171204021411.4786-1-jhubbard@nvidia.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20171204021411.4786-1-jhubbard-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: john.hubbard-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Cc: Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-man <linux-man-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Michael Ellerman <mpe-Gsx/Oe8HsFggBc27wqDAHg@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-arch-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jann Horn <jannh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, John Hubbard <jhubbard-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Sun, Dec 03, 2017 at 06:14:11PM -0800, john.hubbard-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org wrote:
> From: John Hubbard <jhubbard-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
> 
> Previously, MAP_FIXED was "discouraged", due to portability
> issues with the fixed address. In fact, there are other, more
> serious issues. Also, in some limited cases, this option can
> be used safely.
> 
> Expand the documentation to discuss both the hazards, and how
> to use it safely.
> 
> The "Portability issues" wording is lifted directly from
> Matthew Wilcox's review. The notes about other libraries
> creating mappings is also from Matthew (lightly edited).
> 
> The suggestion to explain how to use MAP_FIXED safely is
> from Jann Horn.
> 
> Suggested-by: Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
> Suggested-by: Jann Horn <jannh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> Signed-off-by: John Hubbard <jhubbard-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
> ---
> 
> Changed from v1:
> 
>     -- Covered topics recommended by Matthew Wilcox
>        and Jann Horn, in their recent review: the hazards
>        of overwriting pre-exising mappings, and some notes
>        about how to use MAP_FIXED safely.
> 
>     -- Rewrote the commit description accordingly.
> 
>  man2/mmap.2 | 38 ++++++++++++++++++++++++++++++++++++--
>  1 file changed, 36 insertions(+), 2 deletions(-)
> 
> diff --git a/man2/mmap.2 b/man2/mmap.2
> index 385f3bfd5..9038256d4 100644
> --- a/man2/mmap.2
> +++ b/man2/mmap.2
> @@ -222,8 +222,42 @@ part of the existing mapping(s) will be discarded.
>  If the specified address cannot be used,
>  .BR mmap ()
>  will fail.
> -Because requiring a fixed address for a mapping is less portable,
> -the use of this option is discouraged.
> +.IP
> +This option is extremely hazardous (when used on its own) and moderately
> +non-portable.
> +.IP
> +Portability issues: a process's memory map may change significantly from one
> +run to the next, depending on library versions, kernel versions and random
> +numbers.
> +.IP
> +Hazards: this option forcibly removes pre-existing mappings, making it easy
> +for a multi-threaded process to corrupt its own address space.
> +.IP
> +For example, thread A looks through /proc/<pid>/maps and locates an available
> +address range, while thread B simultaneously acquires part or all of that same
> +address range. Thread A then calls mmap(MAP_FIXED), effectively overwriting
> +thread B's mapping.
> +.IP
> +Thread B need not create a mapping directly; simply making a library call
> +that, internally, uses dlopen(3) to load some other shared library, will
> +suffice. The dlopen(3) call will map the library into the process's address
> +space. Furthermore, almost any library call may be implemented using this
> +technique.
> +Examples include brk(2), malloc(3), pthread_create(3), and the PAM libraries
> +(http://www.linux-pam.org).
> +.IP
> +Given the above limitations, one of the very few ways to use this option
> +safely is: mmap() a region, without specifying MAP_FIXED. Then, within that
> +region, call mmap(MAP_FIXED) to suballocate regions. This avoids both the
> +portability problem (because the first mmap call lets the kernel pick the
> +address), and the address space corruption problem (because the region being
> +overwritten is already owned by the calling thread).

Maybe "address space corruption problem caused by implicit calls to mmap"?
The region allocated with the first mmap is not exactly owned by the
thread and a multi-thread application can still corrupt its memory if
different threads use mmap(MAP_FIXED) for overlapping regions.

My 2 cents.

> +.IP
> +Newer kernels
> +(Linux 4.16 and later) have a
> +.B MAP_FIXED_SAFE
> +option that avoids the corruption problem; if available, MAP_FIXED_SAFE
> +should be preferred over MAP_FIXED.
>  .TP
>  .B MAP_GROWSDOWN
>  This flag is used for stacks.
> -- 
> 2.15.1
> 
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo-Bw31MaZKKs0EbZ0PF+XxCw@public.gmane.org  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Don't email: <a href=mailto:"dont-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org"> email-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org </a>
> 

-- 
Sincerely yours,
Mike.
