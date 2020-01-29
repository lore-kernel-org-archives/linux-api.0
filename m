From: Yang Shi <yang.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
Subject: [PATCH] move_pages.2: Returning positive value is a new error case
Date: Thu, 30 Jan 2020 02:30:32 +0800
Message-ID: <1580322632-93332-1-git-send-email-yang.shi@linux.alibaba.com>
Return-path: <linux-man-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-man-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: mhocko-IBi9RG/b67k@public.gmane.org, mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org
Cc: yang.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org, linux-man-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

Since commit a49bd4d71637 ("mm, numa: rework do_pages_move"),
the semantic of move_pages() has changed to return the number of
non-migrated pages if they were result of a non-fatal reasons (usually a
busy page).  This was an unintentional change that hasn't been noticed
except for LTP tests which checked for the documented behavior.

There are two ways to go around this change.  We can even get back to the
original behavior and return -EAGAIN whenever migrate_pages is not able
to migrate pages due to non-fatal reasons.  Another option would be to
simply continue with the changed semantic and extend move_pages
documentation to clarify that -errno is returned on an invalid input or
when migration simply cannot succeed (e.g. -ENOMEM, -EBUSY) or the
number of pages that couldn't have been migrated due to ephemeral
reasons (e.g. page is pinned or locked for other reasons).

We decided to keep the second option in kernel because this behavior is in
place for some time without anybody complaining and possibly new users
depending on it.  Also it allows to have a slightly easier error handling
as the caller knows that it is worth to retry when err > 0.

Update man pages to reflect the new semantic.

Cc: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Cc: Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Signed-off-by: Yang Shi <yang.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
---
 man2/move_pages.2 | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/man2/move_pages.2 b/man2/move_pages.2
index 1bf1053..c6cf3f8 100644
--- a/man2/move_pages.2
+++ b/man2/move_pages.2
@@ -164,9 +164,13 @@ returns zero.
 .\" do the right thing?
 On error, it returns \-1, and sets
 .I errno
-to indicate the error.
+to indicate the error. Or positive value to report the number of
+non-migrated pages.
 .SH ERRORS
 .TP
+.B Positive value
+The number of non-migrated pages if they were result of a non-fatal
+reasons since version 4.17.
 .B E2BIG
 Too many pages to move.
 Since Linux 2.6.29,
-- 
1.8.3.1
