From: Piotr Kwapulinski <kwapulinski.piotr@gmail.com>
Subject: [PATCH v2 0/1] mm/mempolicy.c: forbid static or relative flags for local NUMA mode
Date: Tue, 27 Sep 2016 15:25:32 +0200
Message-ID: <20160927132532.12110-1-kwapulinski.piotr@gmail.com>
References: <alpine.DEB.2.10.1609201304450.134671@chino.kir.corp.google.com>
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <alpine.DEB.2.10.1609201304450.134671@chino.kir.corp.google.com>
Sender: owner-linux-mm@kvack.org
To: akpm@linux-foundation.org
Cc: kirill.shutemov@linux.intel.com, vbabka@suse.cz, rientjes@google.com, mhocko@kernel.org, mgorman@techsingularity.net, liangchen.linux@gmail.com, nzimmer@sgi.com, a.p.zijlstra@chello.nl, cl@linux.com, riel@redhat.com, lee.schermerhorn@hp.com, jmarchan@redhat.com, joe@perches.com, corbet@lwn.net, iamyooon@gmail.com, n-horiguchi@ah.jp.nec.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org, linux-man@vger.kernel.org, mtk.manpages@gmail.com, linux-doc@vger.kernel.org, linux-api@vger.kernel.org, kwapulinski.piotr@gmail.com
List-Id: linux-api@vger.kernel.org

The MPOL_F_STATIC_NODES and MPOL_F_RELATIVE_NODES flags are irrelevant
when setting them for MPOL_LOCAL NUMA memory policy via set_mempolicy
or mbind.
Return the "invalid argument" from set_mempolicy and mbind whenever
any of these flags is passed along with MPOL_LOCAL.
It is consistent with MPOL_PREFERRED passed with empty nodemask.
It slightly shortens the execution time in paths where these flags
are used e.g. when trying to rebind the NUMA nodes for changes in
cgroups cpuset mems (mpol_rebind_preferred()) or when just printing
the mempolicy structure (/proc/PID/numa_maps).
Isolated tests done.

Signed-off-by: Piotr Kwapulinski <kwapulinski.piotr@gmail.com>
---
Changes since V1:
Adds "mbind" to changelog.
Updates numa_memory_policy.txt.
Based on more recent kernel version.

The following patch updates man-pages:
[PATCH 1/1] man/set_mempolicy.2,mbind.2: forbid static or relative
  flags for local NUMA mode
The following patch set adds documentation for MPOL_LOCAL:
[PATCH 0/1] man/set_mempolicy.2,mbind.2: Add MPOL_LOCAL NUMA memory
  policy documentation
[PATCH 1/1] mm/mempolicy.c: Add MPOL_LOCAL NUMA memory policy
  documentation
---
 Documentation/vm/numa_memory_policy.txt | 8 ++++----
 mm/mempolicy.c                          | 4 +++-
 2 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/Documentation/vm/numa_memory_policy.txt b/Documentation/vm/numa_memory_policy.txt
index 622b927..d246c6c 100644
--- a/Documentation/vm/numa_memory_policy.txt
+++ b/Documentation/vm/numa_memory_policy.txt
@@ -239,8 +239,8 @@ Components of Memory Policies
 
 	    MPOL_F_STATIC_NODES cannot be combined with the
 	    MPOL_F_RELATIVE_NODES flag.  It also cannot be used for
-	    MPOL_PREFERRED policies that were created with an empty nodemask
-	    (local allocation).
+	    MPOL_LOCAL and MPOL_PREFERRED policies that were created with an
+	    empty nodemask (local allocation).
 
 	MPOL_F_RELATIVE_NODES:  This flag specifies that the nodemask passed
 	by the user will be mapped relative to the set of the task or VMA's
@@ -289,8 +289,8 @@ Components of Memory Policies
 
 	    MPOL_F_RELATIVE_NODES cannot be combined with the
 	    MPOL_F_STATIC_NODES flag.  It also cannot be used for
-	    MPOL_PREFERRED policies that were created with an empty nodemask
-	    (local allocation).
+	    MPOL_LOCAL and MPOL_PREFERRED policies that were created with an
+	    empty nodemask (local allocation).
 
 MEMORY POLICY REFERENCE COUNTING
 
diff --git a/mm/mempolicy.c b/mm/mempolicy.c
index 2da72a5..27b07d1 100644
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -276,7 +276,9 @@ static struct mempolicy *mpol_new(unsigned short mode, unsigned short flags,
 				return ERR_PTR(-EINVAL);
 		}
 	} else if (mode == MPOL_LOCAL) {
-		if (!nodes_empty(*nodes))
+		if (!nodes_empty(*nodes) ||
+		    (flags & MPOL_F_STATIC_NODES) ||
+		    (flags & MPOL_F_RELATIVE_NODES))
 			return ERR_PTR(-EINVAL);
 		mode = MPOL_PREFERRED;
 	} else if (nodes_empty(*nodes))
-- 
2.10.0

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
