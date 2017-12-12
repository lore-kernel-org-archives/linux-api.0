From: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v5] mmap.2: MAP_FIXED updated documentation
Date: Tue, 12 Dec 2017 08:55:50 +0100
Message-ID: <20171212075550.GI4779@dhcp22.suse.cz>
References: <20171212002331.6838-1-jhubbard@nvidia.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-man-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20171212002331.6838-1-jhubbard-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
Sender: linux-man-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: john.hubbard-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Cc: Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-man <linux-man-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Michael Ellerman <mpe-Gsx/Oe8HsFggBc27wqDAHg@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-arch-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jann Horn <jannh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Mike Rapoport <rppt-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Cyril Hrubis <chrubis-AlSwsSmVLrQ@public.gmane.org>, Pavel Machek <pavel-+ZI9xUNit7I@public.gmane.org>, John Hubbard <jhubbard-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Mon 11-12-17 16:23:31, john.hubbard-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org wrote:
> From: John Hubbard <jhubbard-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
> 
>     -- Expand the documentation to discuss the hazards in
>        enough detail to allow avoiding them.
> 
>     -- Mention the upcoming MAP_FIXED_SAFE flag.
> 
>     -- Enhance the alignment requirement slightly.
> 
> CC: Michael Ellerman <mpe-Gsx/Oe8HsFggBc27wqDAHg@public.gmane.org>
> CC: Jann Horn <jannh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> CC: Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
> CC: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> CC: Mike Rapoport <rppt-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
> CC: Cyril Hrubis <chrubis-AlSwsSmVLrQ@public.gmane.org>
> CC: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
> CC: Pavel Machek <pavel-+ZI9xUNit7I@public.gmane.org>
> Signed-off-by: John Hubbard <jhubbard-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>

Acked-by: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>

Thanks! I plan to submit my MAP_FIXED_FOO today and will send this
together with my mman update.

> ---
> 
> Changes since v4:
> 
>     -- v2 ("mmap.2: MAP_FIXED is no longer discouraged") was applied already,
>        so v5 is a merge, including rewording of the paragraph transitions.
> 
>     -- We seem to have consensus about what to say about alignment
>        now, and this includes that new wording.
> 
> Changes since v3:
> 
>     -- Removed the "how to use this safely" part, and
>        the SHMLBA part, both as a result of Michal Hocko's
>        review.
> 
>     -- A few tiny wording fixes, at the not-quite-typo level.
> 
> Changes since v2:
> 
>     -- Fixed up the "how to use safely" example, in response
>        to Mike Rapoport's review.
> 
>     -- Changed the alignment requirement from system page
>        size, to SHMLBA. This was inspired by (but not yet
>        recommended by) Cyril Hrubis' review.
> 
>     -- Formatting: underlined /proc/<pid>/maps
> 
> Changes since v1:
> 
>     -- Covered topics recommended by Matthew Wilcox
>        and Jann Horn, in their recent review: the hazards
>        of overwriting pre-exising mappings, and some notes
>        about how to use MAP_FIXED safely.
> 
>     -- Rewrote the commit description accordingly.
> 
>  man2/mmap.2 | 32 ++++++++++++++++++++++++++++++--
>  1 file changed, 30 insertions(+), 2 deletions(-)
> 
> diff --git a/man2/mmap.2 b/man2/mmap.2
> index a5a8eb47a..400cfda2d 100644
> --- a/man2/mmap.2
> +++ b/man2/mmap.2
> @@ -212,8 +212,9 @@ Don't interpret
>  .I addr
>  as a hint: place the mapping at exactly that address.
>  .I addr
> -must be a multiple of the page size.
> -If the memory region specified by
> +must be suitably aligned: for most architectures a multiple of page
> +size is sufficient; however, some architectures may impose additional
> +restrictions. If the memory region specified by
>  .I addr
>  and
>  .I len
> @@ -226,6 +227,33 @@ Software that aspires to be portable should use this option with care, keeping
>  in mind that the exact layout of a process' memory map is allowed to change
>  significantly between kernel versions, C library versions, and operating system
>  releases.
> +.IP
> +Furthermore, this option is extremely hazardous (when used on its own), because
> +it forcibly removes pre-existing mappings, making it easy for a multi-threaded
> +process to corrupt its own address space.
> +.IP
> +For example, thread A looks through
> +.I /proc/<pid>/maps
> +and locates an available
> +address range, while thread B simultaneously acquires part or all of that same
> +address range. Thread A then calls mmap(MAP_FIXED), effectively overwriting
> +the mapping that thread B created.
> +.IP
> +Thread B need not create a mapping directly; simply making a library call
> +that, internally, uses
> +.I dlopen(3)
> +to load some other shared library, will
> +suffice. The dlopen(3) call will map the library into the process's address
> +space. Furthermore, almost any library call may be implemented using this
> +technique.
> +Examples include brk(2), malloc(3), pthread_create(3), and the PAM libraries
> +(http://www.linux-pam.org).
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

-- 
Michal Hocko
SUSE Labs
--
To unsubscribe from this list: send the line "unsubscribe linux-man" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
