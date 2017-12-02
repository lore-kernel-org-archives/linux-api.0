From: john.hubbard-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Subject: [PATCH] mmap.2: MAP_FIXED is no longer discouraged
Date: Fri,  1 Dec 2017 18:16:26 -0800
Message-ID: <20171202021626.26478-1-jhubbard@nvidia.com>
Return-path: <linux-man-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-man-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-man <linux-man-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Michael Ellerman <mpe-Gsx/Oe8HsFggBc27wqDAHg@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-arch-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, John Hubbard <jhubbard-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

From: John Hubbard <jhubbard-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>

MAP_FIXED has been widely used for a very long time, yet the man
page still claims that "the use of this option is discouraged".

The documentation assumes that "less portable" == "must be discouraged".

Instead of discouraging something that is so useful and widely used,
change the documentation to explain its limitations better.

Signed-off-by: John Hubbard <jhubbard-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
---
While reviewing Michal Hocko's man page update for MAP_FIXED_SAFE,
I noticed that MAP_FIXED was no longer reflecting the current
situation, so here is a patch to bring it into the year 2017.

 man2/mmap.2 | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/man2/mmap.2 b/man2/mmap.2
index 385f3bfd5..a5a8eb47a 100644
--- a/man2/mmap.2
+++ b/man2/mmap.2
@@ -222,8 +222,10 @@ part of the existing mapping(s) will be discarded.
 If the specified address cannot be used,
 .BR mmap ()
 will fail.
-Because requiring a fixed address for a mapping is less portable,
-the use of this option is discouraged.
+Software that aspires to be portable should use this option with care, keeping
+in mind that the exact layout of a process' memory map is allowed to change
+significantly between kernel versions, C library versions, and operating system
+releases.
 .TP
 .B MAP_GROWSDOWN
 This flag is used for stacks.
-- 
2.15.1

--
To unsubscribe from this list: send the line "unsubscribe linux-man" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
