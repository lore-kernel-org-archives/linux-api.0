From: David Drysdale <drysdale@google.com>
Subject: [PATCH 1/6] open.2: describe O_BENEATH flag
Date: Fri, 25 Jul 2014 14:47:08 +0100
Message-ID: <1406296033-32693-13-git-send-email-drysdale@google.com>
References: <1406296033-32693-1-git-send-email-drysdale@google.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1406296033-32693-1-git-send-email-drysdale@google.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, Meredydd Luff <meredydd@senatehouse.org>, Kees Cook <keescook@chromium.org>, James Morris <james.l.morris@oracle.com>, Andy Lutomirski <luto@amacapital.net>, Paolo Bonzini <pbonzini@redhat.com>, Paul Moore <paul@paul-moore.com>, Christoph Hellwig <hch@infradead.org>, linux-api@vger.kernel.org, David Drysdale <drysdale@google.com>
List-Id: linux-api@vger.kernel.org

Signed-off-by: David Drysdale <drysdale@google.com>
---
 man2/open.2 | 33 +++++++++++++++++++++++++++++++--
 1 file changed, 31 insertions(+), 2 deletions(-)

diff --git a/man2/open.2 b/man2/open.2
index 475d9e405908..c3d080fb3bea 100644
--- a/man2/open.2
+++ b/man2/open.2
@@ -705,7 +705,7 @@ in a fully formed state (using
 as described above).
 .RE
 .IP
-.B O_TMPFILE
+.B O_TMPFILE " (since Linux 3.??)"
 requires support by the underlying filesystem;
 only a subset of Linux filesystems provide that support.
 In the initial implementation, support was provided in
@@ -715,6 +715,31 @@ XFS support was added
 .\" commit ab29743117f9f4c22ac44c13c1647fb24fb2bafe
 in Linux 3.15.
 .TP
+.B O_BENEATH
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
@@ -791,7 +816,11 @@ The requested access to the file is not allowed, or search permission
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
2.0.0.526.g5318336
