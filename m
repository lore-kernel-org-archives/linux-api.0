From: David Drysdale <drysdale@google.com>
Subject: [PATCHv2 man-pages 3/3] open.2: describe O_BENEATH flag
Date: Tue,  4 Nov 2014 09:54:44 +0000
Message-ID: <1415094884-18349-4-git-send-email-drysdale@google.com>
References: <1415094884-18349-1-git-send-email-drysdale@google.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1415094884-18349-1-git-send-email-drysdale@google.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>, Kees Cook <keescook@chromium.org>, "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Meredydd Luff <meredydd@senatehouse.org>, Will Drewry <wad@chromium.org>, Jorge Lucangeli Obes <jorgelo@google.com>, Ricky Zhou <rickyz@google.com>, Lee Campbell <leecam@google.com>, Julien Tinnes <jln@google.com>, Mike Depinet <mdepinet@google.com>, James Morris <james.l.morris@oracle.com>, Andy Lutomirski <luto@amacapital.net>, Paolo Bonzini <pbonzini@redhat.com>, Paul Moore <paul@paul-moore.com>, Christoph Hellwig <hch@infradead.org>, linux-api@vger.kernel.org, linux-security-module@vger.kernel.org, David Drysdale <drysdale@google.com>
List-Id: linux-api@vger.kernel.org

Signed-off-by: David Drysdale <drysdale@google.com>
---
 man2/open.2 | 32 ++++++++++++++++++++++++++++++++
 1 file changed, 32 insertions(+)

diff --git a/man2/open.2 b/man2/open.2
index abc3c35b8b3a..f06edc4aa843 100644
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
+.BR EPERM.
+This occurs even if ".." path component would not actually
+escape the original directory; for example, a
+.I pathname
+of "subdir/../filename" would be rejected.
+Path components that are symbolic links to absolute paths, or that are
+relative paths containing a ".." component, will also cause the
+.BR open ()
+operation to fail with the error
+.BR EPERM.
+.TP
 .B O_TRUNC
 If the file already exists and is a regular file and the access mode allows
 writing (i.e., is
@@ -976,6 +1001,13 @@ flag was specified, but the effective user ID of the caller
 did not match the owner of the file and the caller was not privileged
 .RB ( CAP_FOWNER ).
 .TP
+.B EPERM
+The
+.B O_BENEATH
+flag was specified and the
+.I pathname
+was not beneath the relevant directory.
+.TP
 .B EROFS
 .I pathname
 refers to a file on a read-only filesystem and write access was
--
2.1.0.rc2.206.gedb03e5
