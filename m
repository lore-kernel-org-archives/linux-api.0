From: Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH 1/2] mm: introduce MAP_FIXED_SAFE
Date: Wed, 13 Dec 2017 04:50:53 -0800
Message-ID: <20171213125053.GB2384@bombadil.infradead.org>
References: <20171213092550.2774-1-mhocko@kernel.org>
 <20171213092550.2774-2-mhocko@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20171213092550.2774-2-mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Khalid Aziz <khalid.aziz-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Michael Ellerman <mpe-Gsx/Oe8HsFggBc27wqDAHg@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Russell King - ARM Linux <linux-I+IVW8TIWO2tmTQ+vhA3Yw@public.gmane.org>, Andrea Arcangeli <aarcange-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-arch-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Florian Weimer <fweimer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, John Hubbard <jhubbard-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Wed, Dec 13, 2017 at 10:25:49AM +0100, Michal Hocko wrote:
> +++ b/mm/mmap.c
> @@ -1342,6 +1342,10 @@ unsigned long do_mmap(struct file *file, unsigned long addr,
>  		if (!(file && path_noexec(&file->f_path)))
>  			prot |= PROT_EXEC;
>  
> +	/* force arch specific MAP_FIXED handling in get_unmapped_area */
> +	if (flags & MAP_FIXED_SAFE)
> +		flags |= MAP_FIXED;
> +
>  	if (!(flags & MAP_FIXED))
>  		addr = round_hint_to_min(addr);
>  

We're up to 22 MAP_ flags now.  We'll run out soon.  Let's preserve half
of a flag by giving userspace the definition:

#define MAP_FIXED_SAFE	(MAP_FIXED | _MAP_NOT_HINT)

then in here:

	if ((flags & _MAP_NOT_HINT) && !(flags & MAP_FIXED))
		return -EINVAL;

Now we can use _MAP_NOT_HINT all by itself in the future to mean
something else.
