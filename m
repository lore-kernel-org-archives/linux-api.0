From: Piotr Kwapulinski <kwapulinski.piotr-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 1/1] mm/mempolicy.c: add MPOL_LOCAL NUMA memory policy documentation
Date: Tue, 27 Sep 2016 15:22:54 +0200
Message-ID: <20160927132254.12050-1-kwapulinski.piotr@gmail.com>
References: <alpine.DEB.2.10.1609201304450.134671@chino.kir.corp.google.com>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <alpine.DEB.2.10.1609201304450.134671-X6Q0R45D7oAcqpCFd4KODRPsWskHk0ljAL8bYrjMMd8@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org
Cc: kirill.shutemov-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, vbabka-AlSwsSmVLrQ@public.gmane.org, rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, mgorman-3eNAlZScCAx27rWaFMvyedHuzzzSOjJt@public.gmane.org, liangchen.linux-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, nzimmer-sJ/iWh9BUns@public.gmane.org, a.p.zijlstra-/NLkJaSkS4VmR6Xm/wNWPw@public.gmane.org, cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org, riel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, lee.schermerhorn-VXdhtT5mjnY@public.gmane.org, jmarchan-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, joe-6d6DIl74uiNBDgjK7y7TUQ@public.gmane.org, corbet-T1hC0tSOHrs@public.gmane.org, iamyooon-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, n-horiguchi-PaJj6Psr51x8UrSeD/g0lQ@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-man-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kwapulinski.piotr-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
List-Id: linux-api@vger.kernel.org

The MPOL_LOCAL mode has been implemented by
Peter Zijlstra <a.p.zijlstra-/NLkJaSkS4VmR6Xm/wNWPw@public.gmane.org>
(commit: 479e2802d09f1e18a97262c4c6f8f17ae5884bd8).
Add the documentation for this mode.

Signed-off-by: Piotr Kwapulinski <kwapulinski.piotr-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 Documentation/vm/numa_memory_policy.txt | 8 ++++++++
 mm/mempolicy.c                          | 4 ++++
 2 files changed, 12 insertions(+)

diff --git a/Documentation/vm/numa_memory_policy.txt b/Documentation/vm/numa_memory_policy.txt
index 622b927..dcb490e 100644
--- a/Documentation/vm/numa_memory_policy.txt
+++ b/Documentation/vm/numa_memory_policy.txt
@@ -212,6 +212,14 @@ Components of Memory Policies
 	    the temporary interleaved system default policy works in this
 	    mode.
 
+	MPOL_LOCAL: This mode specifies "local allocation". It must be
+	used along with an empty nodemask. It acts like the MPOL_PREFERRED
+	mode specified with an empty nodemask. For details refer to
+	the MPOL_PREFERRED mode described above.
+
+	    Internally, it is transformed into MPOL_PREFERRED mode with an
+	    empty nodemask.
+
    Linux memory policy supports the following optional mode flags:
 
 	MPOL_F_STATIC_NODES:  This flag specifies that the nodemask passed by
diff --git a/mm/mempolicy.c b/mm/mempolicy.c
index 2da72a5..02dc43e 100644
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -35,6 +35,10 @@
  *                use the process policy. This is what Linux always did
  *		  in a NUMA aware kernel and still does by, ahem, default.
  *
+ * local          "Local allocation". It acts like a special case of
+ *                "preferred" memory policy: NUMA_NO_NODE (see above
+ *                for details).
+ *
  * The process policy is applied for most non interrupt memory allocations
  * in that process' context. Interrupts ignore the policies and always
  * try to allocate on the local CPU. The VMA policy is only applied for memory
-- 
2.10.0
