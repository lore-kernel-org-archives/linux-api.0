From: Piotr Kwapulinski <kwapulinski.piotr-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH v2 0/1] man/set_mempolicy.2,mbind.2: add MPOL_LOCAL NUMA memory policy documentation
Date: Sun,  9 Oct 2016 20:56:01 +0200
Message-ID: <20161009185601.3310-1-kwapulinski.piotr@gmail.com>
References: <alpine.DEB.2.20.1610040333050.10814@east.gentwo.org>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <alpine.DEB.2.20.1610040333050.10814-wcBtFHqTun5QOdAKl3ChDw@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Cc: kirill.shutemov-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, vbabka-AlSwsSmVLrQ@public.gmane.org, rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, mgorman-3eNAlZScCAx27rWaFMvyedHuzzzSOjJt@public.gmane.org, liangchen.linux-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, nzimmer-sJ/iWh9BUns@public.gmane.org, a.p.zijlstra-/NLkJaSkS4VmR6Xm/wNWPw@public.gmane.org, cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org, riel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, lee.schermerhorn-VXdhtT5mjnY@public.gmane.org, jmarchan-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, joe-6d6DIl74uiNBDgjK7y7TUQ@public.gmane.org, corbet-T1hC0tSOHrs@public.gmane.org, iamyooon-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, n-horiguchi-PaJj6Psr51x8UrSeD/g0lQ@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-man-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kwapulinski.piotr-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
List-Id: linux-api@vger.kernel.org

The MPOL_LOCAL mode has been implemented by
Peter Zijlstra <a.p.zijlstra-/NLkJaSkS4VmR6Xm/wNWPw@public.gmane.org>
(commit: 479e2802d09f1e18a97262c4c6f8f17ae5884bd8).
Add the documentation for this mode.

Signed-off-by: Piotr Kwapulinski <kwapulinski.piotr-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
This version adds more details about MPOL_LOCAL mode:
1. difference between MPOL_LOCAL and MPOL_DEFAULT
2. what if local node is overallocated or not allowed by the cpuset
---
 man2/mbind.2         | 28 ++++++++++++++++++++++++----
 man2/set_mempolicy.2 | 19 ++++++++++++++++++-
 2 files changed, 42 insertions(+), 5 deletions(-)

diff --git a/man2/mbind.2 b/man2/mbind.2
index 3ea24f6..1dbda1e 100644
--- a/man2/mbind.2
+++ b/man2/mbind.2
@@ -130,8 +130,9 @@ argument must specify one of
 .BR MPOL_DEFAULT ,
 .BR MPOL_BIND ,
 .BR MPOL_INTERLEAVE ,
+.BR MPOL_PREFERRED ,
 or
-.BR MPOL_PREFERRED .
+.BR MPOL_LOCAL .
 All policy modes except
 .B MPOL_DEFAULT
 require the caller to specify via the
@@ -258,9 +259,26 @@ and
 .I maxnode
 arguments specify the empty set, then the memory is allocated on
 the node of the CPU that triggered the allocation.
-This is the only way to specify "local allocation" for a
-range of memory via
-.BR mbind ().
+
+.B MPOL_LOCAL
+specifies the "local allocation", the memory is allocated on
+the node of the CPU that triggered the allocation, "local node".
+The
+.I nodemask
+and
+.I maxnode
+arguments must specify the empty set. If the "local node" is low
+on free memory the kernel will try to allocate memory from other
+nodes. The kernel will allocate memory from the "local node"
+whenever the memory for this node will be released. If the
+"local node" is not allowed by the process's current cpuset context
+the kernel will try to allocate memory from other nodes. The kernel
+will allocate memory from the "local node" whenever it becomes
+allowed by the process's current cpuset context. In contrast
+.B MPOL_DEFAULT
+reverts to the policy of the process which may have been set with
+.BR set_mempolicy (2).
+It may not be the "local allocation".
 
 If
 .B MPOL_MF_STRICT
@@ -440,6 +458,8 @@ To select explicit "local allocation" for a memory range,
 specify a
 .I mode
 of
+.B MPOL_LOCAL
+or
 .B MPOL_PREFERRED
 with an empty set of nodes.
 This method will work for
diff --git a/man2/set_mempolicy.2 b/man2/set_mempolicy.2
index 1f02037..3592734 100644
--- a/man2/set_mempolicy.2
+++ b/man2/set_mempolicy.2
@@ -79,8 +79,9 @@ argument must specify one of
 .BR MPOL_DEFAULT ,
 .BR MPOL_BIND ,
 .BR MPOL_INTERLEAVE ,
+.BR MPOL_PREFERRED ,
 or
-.BR MPOL_PREFERRED .
+.BR MPOL_LOCAL .
 All modes except
 .B MPOL_DEFAULT
 require the caller to specify via the
@@ -211,6 +212,22 @@ arguments specify the empty set, then the policy
 specifies "local allocation"
 (like the system default policy discussed above).
 
+.B MPOL_LOCAL
+specifies the "local allocation", the memory is allocated on
+the node of the CPU that triggered the allocation, "local node".
+The
+.I nodemask
+and
+.I maxnode
+arguments must specify the empty set. If the "local node" is low
+on free memory the kernel will try to allocate memory from other
+nodes. The kernel will allocate memory from the "local node"
+whenever the memory for this node will be released. If the
+"local node" is not allowed by the process's current cpuset context
+the kernel will try to allocate memory from other nodes. The kernel
+will allocate memory from the "local node" whenever it becomes
+allowed by the process's current cpuset context.
+
 The thread memory policy is preserved across an
 .BR execve (2),
 and is inherited by child threads created using
-- 
2.10.0
