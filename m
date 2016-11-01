From: David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v3 0/1] mm/mempolicy.c: forbid static or relative flags
 for local NUMA mode
Date: Mon, 31 Oct 2016 17:21:22 -0700 (PDT)
Message-ID: <alpine.DEB.2.10.1610311721050.91888@chino.kir.corp.google.com>
References: <20160927132532.12110-1-kwapulinski.piotr@gmail.com> <20161027163037.4089-1-kwapulinski.piotr@gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20161027163037.4089-1-kwapulinski.piotr-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Piotr Kwapulinski <kwapulinski.piotr-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, kirill.shutemov-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, vbabka-AlSwsSmVLrQ@public.gmane.org, mhocko-IBi9RG/b67k@public.gmane.org, liangchen.linux-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, mgorman-3eNAlZScCAx27rWaFMvyedHuzzzSOjJt@public.gmane.org, dave.hansen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, nzimmer-sJ/iWh9BUns@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Thu, 27 Oct 2016, Piotr Kwapulinski wrote:

> The MPOL_F_STATIC_NODES and MPOL_F_RELATIVE_NODES flags are irrelevant
> when setting them for MPOL_LOCAL NUMA memory policy via set_mempolicy
> or mbind.
> Return the "invalid argument" from set_mempolicy and mbind whenever
> any of these flags is passed along with MPOL_LOCAL.
> It is consistent with MPOL_PREFERRED passed with empty nodemask.
> It slightly shortens the execution time in paths where these flags
> are used e.g. when trying to rebind the NUMA nodes for changes in
> cgroups cpuset mems (mpol_rebind_preferred()) or when just printing
> the mempolicy structure (/proc/PID/numa_maps).
> Isolated tests done.
> 
> Signed-off-by: Piotr Kwapulinski <kwapulinski.piotr-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

Acked-by: David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
