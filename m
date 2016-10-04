From: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 0/1] man/set_mempolicy.2,mbind.2: add MPOL_LOCAL NUMA
 memory policy documentation
Date: Tue, 4 Oct 2016 03:36:53 -0500 (CDT)
Message-ID: <alpine.DEB.2.20.1610040333050.10814@east.gentwo.org>
References: <alpine.DEB.2.10.1609201304450.134671@chino.kir.corp.google.com> <20160927131948.11974-1-kwapulinski.piotr@gmail.com>
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160927131948.11974-1-kwapulinski.piotr-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Piotr Kwapulinski <kwapulinski.piotr-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, kirill.shutemov-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, vbabka-AlSwsSmVLrQ@public.gmane.org, rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, mgorman-3eNAlZScCAx27rWaFMvyedHuzzzSOjJt@public.gmane.org, liangchen.linux-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, nzimmer-sJ/iWh9BUns@public.gmane.org, a.p.zijlstra-/NLkJaSkS4VmR6Xm/wNWPw@public.gmane.org, riel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, lee.schermerhorn-VXdhtT5mjnY@public.gmane.org, jmarchan-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, joe-6d6DIl74uiNBDgjK7y7TUQ@public.gmane.org, corbet-T1hC0tSOHrs@public.gmane.org, iamyooon-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, n-horiguchi-PaJj6Psr51x8UrSeD/g0lQ@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-man-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

Well the difference between MPOL_DEFAULT and MPOL_LOCAL may be confusing.
Mention somewhere in the MPOL_LOCAL description that the policy with
MPOL_DEFAULT reverts to the policy of the process and MPOL_LOCAL to try to
allocate local? Note that MPOL_LOCAL also will not be local if it just
happens that the local node is overallocated. This is usually confusing
for newcomers. The node/zone reclaim must be activated in order to allow
node local reclaim that results in a node local allocation.
