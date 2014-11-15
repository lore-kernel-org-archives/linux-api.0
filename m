From: Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>
Subject: [PATCH manpages] getgroups.2: Document unprivileged setgroups calls
Date: Sat, 15 Nov 2014 01:01:52 -0800
Message-ID: <20141115090151.GA15470@thin>
References: <3ccec8a13019b5e8ce7b1d7889677b778b070dc8.1416041823.git.josh@joshtriplett.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-man-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <3ccec8a13019b5e8ce7b1d7889677b778b070dc8.1416041823.git.josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>
Sender: linux-man-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-man-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

Signed-off-by: Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>
---
This should probably also include appropriate documentation for what
kernel introduces this behavior.

 man2/getgroups.2 | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/man2/getgroups.2 b/man2/getgroups.2
index 373c204..edca37c 100644
--- a/man2/getgroups.2
+++ b/man2/getgroups.2
@@ -81,9 +81,10 @@ to be used in a further call to
 .PP
 .BR setgroups ()
 sets the supplementary group IDs for the calling process.
-Appropriate privileges (Linux: the
+Any process may drop groups from its list, but adding groups requires
+appropriate privileges (Linux: the
 .B CAP_SETGID
-capability) are required.
+capability).
 The
 .I size
 argument specifies the number of supplementary group IDs
-- 
2.1.3

--
To unsubscribe from this list: send the line "unsubscribe linux-man" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
