From: Piotr Kwapulinski <kwapulinski.piotr-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 1/1] man/set_mempolicy.2,mbind.2: forbid static or relative flags for local NUMA mode
Date: Tue, 27 Sep 2016 15:27:50 +0200
Message-ID: <20160927132750.12188-1-kwapulinski.piotr@gmail.com>
References: <alpine.DEB.2.10.1609201304450.134671@chino.kir.corp.google.com>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <alpine.DEB.2.10.1609201304450.134671-X6Q0R45D7oAcqpCFd4KODRPsWskHk0ljAL8bYrjMMd8@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Cc: kirill.shutemov-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, vbabka-AlSwsSmVLrQ@public.gmane.org, rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, mgorman-3eNAlZScCAx27rWaFMvyedHuzzzSOjJt@public.gmane.org, liangchen.linux-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, nzimmer-sJ/iWh9BUns@public.gmane.org, a.p.zijlstra-/NLkJaSkS4VmR6Xm/wNWPw@public.gmane.org, cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org, riel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, lee.schermerhorn-VXdhtT5mjnY@public.gmane.org, jmarchan-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, joe-6d6DIl74uiNBDgjK7y7TUQ@public.gmane.org, corbet-T1hC0tSOHrs@public.gmane.org, iamyooon-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, n-horiguchi-PaJj6Psr51x8UrSeD/g0lQ@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-man-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kwapulinski.piotr-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
List-Id: linux-api@vger.kernel.org

Add documentation for the following patch:
[PATCH v2 0/1] mm/mempolicy.c: forbid static or relative flags
 for local NUMA mode

Signed-off-by: Piotr Kwapulinski <kwapulinski.piotr-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 man2/mbind.2         | 35 +++++++++++++++++++++++++++++++++++
 man2/set_mempolicy.2 | 35 +++++++++++++++++++++++++++++++++++
 2 files changed, 70 insertions(+)

diff --git a/man2/mbind.2 b/man2/mbind.2
index 3ea24f6..8c50948 100644
--- a/man2/mbind.2
+++ b/man2/mbind.2
@@ -375,6 +375,41 @@ argument specified both
 .B MPOL_F_STATIC_NODES
 and
 .BR MPOL_F_RELATIVE_NODES .
+Or, the
+.I mode
+argument specifies
+.B MPOL_PREFERRED
+and
+.B MPOL_F_STATIC_NODES
+flag and
+.I nodemask
+is empty. Or, the
+.I mode
+argument specifies
+.B MPOL_PREFERRED
+and
+.B MPOL_F_RELATIVE_NODES
+flag and
+.I nodemask
+is empty. Or, the
+.I mode
+is
+.B MPOL_LOCAL
+and
+.I nodemask
+is empty. Or, the
+.I mode
+argument specifies
+.B MPOL_LOCAL
+and
+.B MPOL_F_STATIC_NODES
+flag. Or, the
+.I mode
+argument specifies
+.B MPOL_LOCAL
+and
+.B MPOL_F_RELATIVE_NODES
+flag.
 .TP
 .B EIO
 .B MPOL_MF_STRICT
diff --git a/man2/set_mempolicy.2 b/man2/set_mempolicy.2
index 1f02037..9204941 100644
--- a/man2/set_mempolicy.2
+++ b/man2/set_mempolicy.2
@@ -269,6 +269,41 @@ argument specified both
 .B MPOL_F_STATIC_NODES
 and
 .BR MPOL_F_RELATIVE_NODES .
+Or, the
+.I mode
+argument specifies
+.B MPOL_PREFERRED
+and
+.B MPOL_F_STATIC_NODES
+flag and
+.I nodemask
+is empty. Or, the
+.I mode
+argument specifies
+.B MPOL_PREFERRED
+and
+.B MPOL_F_RELATIVE_NODES
+flag and
+.I nodemask
+is empty. Or, the
+.I mode
+is
+.B MPOL_LOCAL
+and
+.I nodemask
+is empty. Or, the
+.I mode
+argument specifies
+.B MPOL_LOCAL
+and
+.B MPOL_F_STATIC_NODES
+flag. Or, the
+.I mode
+argument specifies
+.B MPOL_LOCAL
+and
+.B MPOL_F_RELATIVE_NODES
+flag.
 .TP
 .B ENOMEM
 Insufficient kernel memory was available.
-- 
2.10.0
