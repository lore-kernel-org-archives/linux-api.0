From: David Drysdale <drysdale-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH man-pages 3/3] open.2: describe O_BENEATH flag
Date: Mon,  3 Nov 2014 11:48:25 +0000
Message-ID: <1415015305-15494-4-git-send-email-drysdale@google.com>
References: <1415015305-15494-1-git-send-email-drysdale@google.com>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1415015305-15494-1-git-send-email-drysdale-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
Cc: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Meredydd Luff <meredydd-zPN50pYk8eUaUu29zAJCuw@public.gmane.org>, Will Drewry <wad-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Jorge Lucangeli Obes <jorgelo-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Ricky Zhou <rickyz-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Lee Campbell <leecam-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Julien Tinnes <jln-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Mike Depinet <mdepinet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, James Morris <james.l.morris-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Paolo Bonzini <pbonzini-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Paul Moore <paul-r2n+y4ga6xFZroRs9YW3xA@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, David Drysdale <drysdale-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Signed-off-by: David Drysdale <drysdale-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
---
 man2/open.2 | 31 ++++++++++++++++++++++++++++++-
 1 file changed, 30 insertions(+), 1 deletion(-)

diff --git a/man2/open.2 b/man2/open.2
index abc3c35b8b3a..495c7f1e81a4 100644
--- a/man2/open.2
+++ b/man2/open.2
@@ -716,6 +716,31 @@ XFS support was added
 .\" commit ab29743117f9f4c22ac44c13c1647fb24fb2bafe
 in Linux 3.15.
 .TP
+.B O_BENEATH " (since Linux 3.??)"
+Ensure that the
+.I pathname
+is beneath the current working directory (for
+.BR open (2))
+or the
+.I dirfd
+(for
+.BR openat (2)).
+If the
+.I pathname
+is absolute or contains a path component of "..", the
+.BR open ()
+fails with the error
+.BR EACCES.
+This occurs even if ".." path component would not actually
+escape the original directory; for example, a
+.I pathname
+of "subdir/../filename" would be rejected.
+Path components that are symbolic links to absolute paths, or that are
+relative paths containing a ".." component, will also cause the
+.BR open ()
+operation to fail with the error
+.BR EACCES.
+.TP
 .B O_TRUNC
 If the file already exists and is a regular file and the access mode allows
 writing (i.e., is
@@ -792,7 +817,11 @@ The requested access to the file is not allowed, or search permission
 is denied for one of the directories in the path prefix of
 .IR pathname ,
 or the file did not exist yet and write access to the parent directory
-is not allowed.
+is not allowed, or the
+.B O_BENEATH
+flag was specified and the
+.I pathname
+was not beneath the relevant directory.
 (See also
 .BR path_resolution (7).)
 .TP
-- 
2.1.0.rc2.206.gedb03e5
