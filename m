From: Michal Hocko <miso-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
Subject: [PATCH 1/2] mmap.2: clarify MAP_LOCKED semantic
Date: Wed, 13 May 2015 16:38:11 +0200
Message-ID: <1431527892-2996-2-git-send-email-miso@dhcp22.suse.cz>
References: <1431527892-2996-1-git-send-email-miso@dhcp22.suse.cz>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1431527892-2996-1-git-send-email-miso-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
List-Id: linux-api@vger.kernel.org

From: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>

MAP_LOCKED had a subtly different semantic from mmap(2)+mlock(2) since
it has been introduced.
mlock(2) fails if the memory range cannot get populated to guarantee
that no future major faults will happen on the range. mmap(MAP_LOCKED) on
the other hand silently succeeds even if the range was populated only
partially.

Fixing this subtle difference in the kernel is rather awkward because
the memory population happens after mm locks have been dropped and so
the cleanup before returning failure (munlock) could operate on something
else than the originally mapped area.

E.g. speculative userspace page fault handler catching SEGV and doing
mmap(fault_addr, MAP_FIXED|MAP_LOCKED) might discard portion of a racing
mmap and lead to lost data. Although it is not clear whether such a
usage would be valid, mmap page doesn't explicitly describe requirements
for threaded applications so we cannot exclude this possibility.

This patch makes the semantic of MAP_LOCKED explicit and suggest using
mmap + mlock as the only way to guarantee no later major page faults.

Signed-off-by: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
---
 man2/mmap.2 | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/man2/mmap.2 b/man2/mmap.2
index 54d68cf87e9e..1486be2e96b3 100644
--- a/man2/mmap.2
+++ b/man2/mmap.2
@@ -235,8 +235,19 @@ See the Linux kernel source file
 for further information.
 .TP
 .BR MAP_LOCKED " (since Linux 2.5.37)"
-Lock the pages of the mapped region into memory in the manner of
+Mark the mmaped region to be locked in the same way as
 .BR mlock (2).
+This implementation will try to populate (prefault) the whole range but
+the mmap call doesn't fail with
+.B ENOMEM
+if this fails. Therefore major faults might happen later on. So the semantic
+is not as strong as
+.BR mlock (2).
+.BR mmap (2)
++
+.BR mlock (2)
+should be used when major faults are not acceptable after the initialization
+of the mapping.
 This flag is ignored in older kernels.
 .\" If set, the mapped pages will not be swapped out.
 .TP
-- 
2.1.4
