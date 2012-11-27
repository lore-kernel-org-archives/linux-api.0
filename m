From: ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org (Eric W. Biederman)
Subject: [PATCH 2/4] clone.2:  Describe the user namespace
Date: Mon, 26 Nov 2012 18:46:46 -0600
Message-ID: <87y5hnq3d5.fsf@xmission.com>
References: <87a9u4rmz0.fsf@xmission.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <87a9u4rmz0.fsf-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org> (Eric W. Biederman's message of
	"Mon, 26 Nov 2012 16:57:55 -0600")
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Serge E. Hallyn" <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>, Linux Containers <containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
List-Id: linux-api@vger.kernel.org


Signed-off-by: "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>
---
 man2/clone.2 |   39 +++++++++++++++++++++++++++++++++++++++
 1 files changed, 39 insertions(+), 0 deletions(-)

diff --git a/man2/clone.2 b/man2/clone.2
index 0582057..4566677 100644
--- a/man2/clone.2
+++ b/man2/clone.2
@@ -366,6 +366,45 @@ in the same
 .BR clone ()
 call.
 .TP
+.BR CLONE_NEWUSER " (since Linux 3.6)"
+If
+.B CLONE_NEWUSER
+is set, the create the process in a new user namespace.  If this flag is not set, then (as with
+.BR fork (2)),
+the process is created in the same user namespace as the calling process.
+
+A user namespace provides an isolated environment for security related identifiers in particular
+uids, gids, keys (see
+.BR keyctl (2)),
+and capabilities.
+
+When a user namespace is created it initially starts out without a mapping of uids and gids
+to the parent user namespace.  The desired mapping of uids to the parent user namespace
+may be set by writting into  
+.IR /proc/[pid]/uid_map.
+The desired mapping of gids to the parent user namespace may be set by writinng into
+.IR /proc/[pid]/gid_map.
+
+The first process in a user namespace starts out with a complete set of capabilities with
+respect to the new user namespace.  
+
+syscalls that return uids and gids will either return the uid or gid mapped into the current
+user namespace if there is a mapping or depending on the context will return either
+the overflowuid (default 65534) or the overflowgid (default 65534). See
+.IR /proc/sys/kernel/overflowuid, /proc/sys/kernel/overflowgid
+
+As of Linux 3.8 no priviliges are needed to create a user namespace,
+and mount, pid, ipc, net, uts namespaces can be created with just
+CAP_SYS_ADMIN privileges in your current user namespace.
+
+Over the years there have been a lot of features that have been added
+to the linux kernel that are only available to privileged users
+because of their potential to confuse setuid root applications.  In
+general it becomes safe to allow the root user in a user namespace to
+use those features because it is impossible while in a user namespace
+to gain more privilege than the root user of a user namespace has.
+
+.TP
 .BR CLONE_NEWPID " (since Linux 2.6.24)"
 .\" This explanation draws a lot of details from
 .\" http://lwn.net/Articles/259217/
-- 
1.7.5.4
