From: Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [PATCH] mm/mempolicy.c: forbid static or relative flags for local
 NUMA mode
Date: Tue, 20 Sep 2016 17:12:16 +0200
Message-ID: <65cb95b8-4521-cc4c-a30c-e6c23731479c@suse.cz>
References: <20160918112943.1645-1-kwapulinski.piotr@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160918112943.1645-1-kwapulinski.piotr-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Piotr Kwapulinski <kwapulinski.piotr-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org
Cc: kirill.shutemov-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, mgorman-3eNAlZScCAx27rWaFMvyedHuzzzSOjJt@public.gmane.org, liangchen.linux-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, nzimmer-sJ/iWh9BUns@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-man-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
List-Id: linux-api@vger.kernel.org

[CC += linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org]

     Since this is a kernel-user-space API change, please CC linux-api@. The 
kernel source file Documentation/SubmitChecklist notes that all Linux kernel 
patches that change userspace interfaces should be CCed to 
linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, so that the various parties who are interested in API 
changes are informed. For further information, see 
https://www.kernel.org/doc/man-pages/linux-api-ml.html

I think man page should document the change? Also I noticed that MPOL_NUMA 
itself is missing in the man page...

On 09/18/2016 01:29 PM, Piotr Kwapulinski wrote:
> The MPOL_F_STATIC_NODES and MPOL_F_RELATIVE_NODES flags are irrelevant
> when setting them for MPOL_LOCAL NUMA memory policy via set_mempolicy.
> Return the "invalid argument" from set_mempolicy whenever
> any of these flags is passed along with MPOL_LOCAL.
> It is consistent with MPOL_PREFERRED passed with empty nodemask.
> It also slightly shortens the execution time in paths where these flags
> are used e.g. when trying to rebind the NUMA nodes for changes in
> cgroups cpuset mems (mpol_rebind_preferred()) or when just printing
> the mempolicy structure (/proc/PID/numa_maps).

Hmm not sure I understand. How does change in mpol_new() affect 
mpol_rebind_preferred()?

Vlastimil

> Isolated tests done.
>
> Signed-off-by: Piotr Kwapulinski <kwapulinski.piotr-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> ---
>  mm/mempolicy.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
>
> diff --git a/mm/mempolicy.c b/mm/mempolicy.c
> index 2da72a5..27b07d1 100644
> --- a/mm/mempolicy.c
> +++ b/mm/mempolicy.c
> @@ -276,7 +276,9 @@ static struct mempolicy *mpol_new(unsigned short mode, unsigned short flags,
>  				return ERR_PTR(-EINVAL);
>  		}
>  	} else if (mode == MPOL_LOCAL) {
> -		if (!nodes_empty(*nodes))
> +		if (!nodes_empty(*nodes) ||
> +		    (flags & MPOL_F_STATIC_NODES) ||
> +		    (flags & MPOL_F_RELATIVE_NODES))
>  			return ERR_PTR(-EINVAL);
>  		mode = MPOL_PREFERRED;
>  	} else if (nodes_empty(*nodes))
>
