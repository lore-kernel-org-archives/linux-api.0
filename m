From: David Drysdale <drysdale@google.com>
Subject: [PATCHv4 man-pages 3/3] open.2: describe O_BENEATH flag
Date: Thu, 13 Aug 2015 10:32:46 +0100
Message-ID: <1439458366-8223-4-git-send-email-drysdale@google.com>
References: <1439458366-8223-1-git-send-email-drysdale@google.com>
Return-path: <fstests-owner@vger.kernel.org>
In-Reply-To: <1439458366-8223-1-git-send-email-drysdale@google.com>
Sender: fstests-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>, Kees Cook <keescook@chromium.org>, "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Meredydd Luff <meredydd@senatehouse.org>, Will Drewry <wad@chromium.org>, Jorge Lucangeli Obes <jorgelo@google.com>, Ricky Zhou <rickyz@google.com>, Lee Campbell <leecam@google.com>, Julien Tinnes <jln@google.com>, Mike Depinet <mdepinet@google.com>, James Morris <james.l.morris@oracle.com>, Andy Lutomirski <luto@amacapital.net>, Paolo Bonzini <pbonzini@redhat.com>, Paul Moore <paul@paul-moore.com>, Christoph Hellwig <hch@infradead.org>, Michael Kerrisk <mtk.manpages@gmail.com>, Dave Chinner <david@fromorbit.com>, linux-api@vger.kernel.org, linux-arch@vger.kernel.org, linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org, fstests@vger.kernel.org, David Drysdale <drysdale@google.com>
List-Id: linux-api@vger.kernel.org

Signed-off-by: David Drysdale <drysdale@google.com>
---
 man2/open.2 | 44 ++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 44 insertions(+)

diff --git a/man2/open.2 b/man2/open.2
index f49ab3042161..d09511f9ffb0 100644
--- a/man2/open.2
+++ b/man2/open.2
@@ -201,6 +201,43 @@ See
 for further details.
 See also BUGS, below.
 .TP
+.B O_BENEATH " (since Linux 4.??)"
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
+
+This feature allows applications to be sure that the opened file is
+within the specified directory, regardless of the original source of the
+.I pathname
+argument.
+Some security-conscious programs may further ensure
+this by imposing a system call filter (with
+.BR seccomp (2))
+that requires this flag for all
+.BR open ()
+operations, so that the program cannot open files outside of
+specified directories even if subverted.
+.TP
 .BR O_CLOEXEC " (since Linux 2.6.23)"
 .\" NOTE! several other man pages refer to this text
 Enable the close-on-exec flag for the new file descriptor.
@@ -1015,6 +1052,13 @@ did not match the owner of the file and the caller was not privileged
 The operation was prevented by a file seal; see
 .BR fcntl (2).
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
2.5.0.rc2.392.g76e840b
