From: Steven Stewart-Gallus <sstewartgallus00-QKvm5KDIoDa7M0a00MdBSQ@public.gmane.org>
Subject: Re: [PATCH v2 2/2] man2: Document constant for only allowing absolute
 paths
Date: Wed, 09 Jul 2014 23:53:23 +0000 (GMT)
Message-ID: <fb4ef2783fc.53bdd5f3@langara.bc.ca>
References: <fb4eb72f7cd0.53bdd56f@langara.bc.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7BIT
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-disposition: inline
Content-language: en
In-reply-to: <fb4eb72f7cd0.53bdd56f-BTv7Ps/Sm75C8prJL3GQQw@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steven Stewart-Gallus <sstewartgallus00-QKvm5KDIoDa7M0a00MdBSQ@public.gmane.org>
Cc: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Jeff Layton <jlayton-vpEMnDpepFuMZCB2o+C8xQ@public.gmane.org>, "J. Bruce Fields" <bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Signed-off-by: Steven Stewart-Gallus <sstewartgallus00-QKvm5KDIoDa7M0a00MdBSQ@public.gmane.org>

---
 man2/access.2            |   14 +++++++++++++-
 man2/chmod.2             |   14 +++++++++++++-
 man2/chown.2             |   14 +++++++++++++-
 man2/fanotify_mark.2     |   15 ++++++++++++++-
 man2/futimesat.2         |   14 +++++++++++++-
 man2/link.2              |   11 ++++++++++-
 man2/mkdir.2             |   14 +++++++++++++-
 man2/mknod.2             |   14 +++++++++++++-
 man2/open.2              |   14 +++++++++++++-
 man2/open_by_handle_at.2 |    8 ++++++++
 man2/readlink.2          |   14 +++++++++++++-
 man2/rename.2            |   11 ++++++++++-
 man2/stat.2              |   14 +++++++++++++-
 man2/symlink.2           |   14 +++++++++++++-
 man2/unlink.2            |   14 +++++++++++++-
 man2/utimensat.2         |    8 ++++++++
 man3/readdir.3           |   18 ++++++++++++++----
 17 files changed, 207 insertions(+), 18 deletions(-)

diff --git a/man2/access.2 b/man2/access.2
index cdf2f96..f2a030b 100644
--- a/man2/access.2
+++ b/man2/access.2
@@ -141,6 +141,14 @@ directory of the calling process (like
 .BR access ()).
 
 If
+.I dirfd
+is the special value
+.BR AT_FDABSOLUTE ,
+then
+.I pathname
+must be absolute.
+
+If
 .I pathname
 is absolute, then
 .I dirfd
@@ -244,7 +252,11 @@ The following additional errors can occur for
 .TP
 .B EBADF
 .I dirfd
-is not a valid file descriptor.
+is not a valid file descriptor or
+.I dirfd
+is AT_FDABSOLUTE and
+.I pathname
+is relative.
 .TP
 .B EINVAL
 Invalid flag specified in
diff --git a/man2/chmod.2 b/man2/chmod.2
index b46c0fa..1cde0f1 100644
--- a/man2/chmod.2
+++ b/man2/chmod.2
@@ -209,6 +209,14 @@ directory of the calling process (like
 .BR chmod ()).
 
 If
+.I dirfd
+is the special value
+.BR AT_FDABSOLUTE ,
+then
+.I pathname
+must be absolute.
+
+If
 .I pathname
 is absolute, then
 .I dirfd
@@ -306,7 +314,11 @@ The following additional errors can occur for
 .TP
 .B EBADF
 .I dirfd
-is not a valid file descriptor.
+is not a valid file descriptor or
+.I dirfd
+is AT_FDABSOLUTE and
+.I pathname
+is relative.
 .TP
 .B EINVAL
 Invalid flag specified in
diff --git a/man2/chown.2 b/man2/chown.2
index 8f6194e..aafadc5 100644
--- a/man2/chown.2
+++ b/man2/chown.2
@@ -172,6 +172,14 @@ directory of the calling process (like
 .BR chown ()).
 
 If
+.I dirfd
+is the special value
+.BR AT_FDABSOLUTE ,
+then
+.I pathname
+must be absolute.
+
+If
 .I pathname
 is absolute, then
 .I dirfd
@@ -295,7 +303,11 @@ The following additional errors can occur for
 .TP
 .B EBADF
 .I dirfd
-is not a valid file descriptor.
+is not a valid file descriptor or
+.I dirfd
+is AT_FDABSOLUTE and
+.I pathname
+is relative.
 .TP
 .B EINVAL
 Invalid flag specified in
diff --git a/man2/fanotify_mark.2 b/man2/fanotify_mark.2
index d3c7e7d..13bf51d 100644
--- a/man2/fanotify_mark.2
+++ b/man2/fanotify_mark.2
@@ -214,6 +214,14 @@ is absolute, it defines the filesystem object to be marked, and
 is ignored.
 .IP *
 If
+.I dirfd
+is the special value
+.BR AT_FDABSOLUTE ,
+then
+.I pathname
+must be absolute.
+.IP *
+If
 .I pathname
 is relative, and
 .I dirfd
@@ -244,7 +252,12 @@ is set to indicate the error.
 .TP
 .B EBADF
 An invalid file descriptor was passed in
-.IR fanotify_fd .
+.IR fanotify_fd
+or
+.I dirfd
+is AT_FDABSOLUTE and
+.I pathname
+is relative.
 .TP
 .B EINVAL
 An invalid value was passed in
diff --git a/man2/futimesat.2 b/man2/futimesat.2
index e6e0174..2b9298d 100644
--- a/man2/futimesat.2
+++ b/man2/futimesat.2
@@ -77,6 +77,14 @@ directory of the calling process (like
 .BR utimes (2)).
 
 If
+.I dirfd
+is the special value
+.BR AT_FDABSOLUTE ,
+then
+.I pathname
+must be absolute.
+
+If
 .I pathname
 is absolute, then
 .I dirfd
@@ -98,7 +106,11 @@ The following additional errors can occur for
 .TP
 .B EBADF
 .I dirfd
-is not a valid file descriptor.
+is not a valid file descriptor or
+.I dirfd
+is AT_FDABSOLUTE and
+.I pathname
+is relative.
 .TP
 .B ENOTDIR
 .I pathname
diff --git a/man2/link.2 b/man2/link.2
index 0725cd2..d340235 100644
--- a/man2/link.2
+++ b/man2/link.2
@@ -107,6 +107,14 @@ directory of the calling process (like
 .BR link ()).
 
 If
+.I olddirfd
+is the special value
+.BR AT_FDABSOLUTE ,
+then
+.I oldpath
+must be absolute.
+
+If
 .I oldpath
 is absolute, then
 .I olddirfd
@@ -278,7 +286,8 @@ The following additional errors can occur for
 .I olddirfd
 or
 .I newdirfd
-is not a valid file descriptor.
+is not a valid file descriptor or one of them is AT_FDABSOLUTE and the
+associated path is relative.
 .TP
 .B EINVAL
 An invalid flag value was specified in
diff --git a/man2/mkdir.2 b/man2/mkdir.2
index 71f794f..4c18fcb 100644
--- a/man2/mkdir.2
+++ b/man2/mkdir.2
@@ -103,6 +103,14 @@ directory of the calling process (like
 .BR mkdir ()).
 
 If
+.I dirfd
+is the special value
+.BR AT_FDABSOLUTE ,
+then
+.I pathname
+must be absolute.
+
+If
 .I pathname
 is absolute, then
 .I dirfd
@@ -190,7 +198,11 @@ The following additional errors can occur for
 .TP
 .B EBADF
 .I dirfd
-is not a valid file descriptor.
+is not a valid file descriptor or
+.I dirfd
+is AT_FDABSOLUTE and
+.I pathname
+is relative.
 .TP
 .B ENOTDIR
 .I pathname
diff --git a/man2/mknod.2 b/man2/mknod.2
index e93c345..4b8b620 100644
--- a/man2/mknod.2
+++ b/man2/mknod.2
@@ -137,6 +137,14 @@ directory of the calling process (like
 .BR mknod (2)).
 
 If
+.I dirfd
+is the special value
+.BR AT_FDABSOLUTE ,
+then
+.I pathname
+must be absolute.
+
+If
 .I pathname
 is absolute, then
 .I dirfd
@@ -230,7 +238,11 @@ The following additional errors can occur for
 .TP
 .B EBADF
 .I dirfd
-is not a valid file descriptor.
+is not a valid file descriptor or
+.I dirfd
+is AT_FDABSOLUTE and
+.I pathname
+is relative.
 .TP
 .B ENOTDIR
 .I pathname
diff --git a/man2/open.2 b/man2/open.2
index df10a22..c65d705 100644
--- a/man2/open.2
+++ b/man2/open.2
@@ -767,6 +767,14 @@ directory of the calling process (like
 .BR open ()).
 
 If
+.I dirfd
+is the special value
+.BR AT_FDABSOLUTE ,
+then
+.I pathname
+must be absolute.
+
+If
 .I pathname
 is absolute, then
 .I dirfd
@@ -998,7 +1006,11 @@ The following additional errors can occur for
 .TP
 .B EBADF
 .I dirfd
-is not a valid file descriptor.
+is not a valid file descriptor or
+.I dirfd
+is AT_FDABSOLUTE and
+.I pathname
+is relative.
 .TP
 .B ENOTDIR
 .I pathname
diff --git a/man2/open_by_handle_at.2 b/man2/open_by_handle_at.2
index 7badac7..70fafb3 100644
--- a/man2/open_by_handle_at.2
+++ b/man2/open_by_handle_at.2
@@ -181,6 +181,14 @@ or
 .BR AT_FDCWD ,
 meaning the current working directory,
 and a handle is returned for the file to which it refers.
+.IP *
+If
+.I dirfd
+is the special value
+.BR AT_FDABSOLUTE ,
+then
+.I pathname
+must be absolute.
 .PP
 The
 .I mount_id
diff --git a/man2/readlink.2 b/man2/readlink.2
index 19102e1..e5a0e13 100644
--- a/man2/readlink.2
+++ b/man2/readlink.2
@@ -127,6 +127,14 @@ directory of the calling process (like
 .BR readlink ()).
 
 If
+.I dirfd
+is the special value
+.BR AT_FDABSOLUTE ,
+then
+.I pathname
+must be absolute.
+
+If
 .I pathname
 is absolute, then
 .I dirfd
@@ -202,7 +210,11 @@ The following additional errors can occur for
 .TP
 .B EBADF
 .I dirfd
-is not a valid file descriptor.
+is not a valid file descriptor or
+.I dirfd
+is AT_FDABSOLUTE and
+.I pathname
+is relative.
 .TP
 .B ENOTDIR
 .I pathname
diff --git a/man2/rename.2 b/man2/rename.2
index a258972..c857886 100644
--- a/man2/rename.2
+++ b/man2/rename.2
@@ -151,6 +151,14 @@ directory of the calling process (like
 .BR rename ()).
 
 If
+.I olddirfd
+is the special value
+.BR AT_FDABSOLUTE ,
+then
+.I oldpath
+must be absolute.
+
+If
 .I oldpath
 is absolute, then
 .I olddirfd
@@ -351,7 +359,8 @@ and
 .I olddirfd
 or
 .I newdirfd
-is not a valid file descriptor.
+is not a valid file descriptor or one of them is AT_FDABSOLUTE and the
+associated path is relative.
 .TP
 .B ENOTDIR
 .I oldpath
diff --git a/man2/stat.2 b/man2/stat.2
index b70797d..c210b0d 100644
--- a/man2/stat.2
+++ b/man2/stat.2
@@ -452,6 +452,14 @@ directory of the calling process (like
 .BR stat ()).
 
 If
+.I dirfd
+is the special value
+.BR AT_FDABSOLUTE ,
+then
+.I pathname
+must be absolute.
+
+If
 .I pathname
 is absolute, then
 .I dirfd
@@ -581,7 +589,11 @@ The following additional errors can occur for
 .TP
 .B EBADF
 .I dirfd
-is not a valid file descriptor.
+is not a valid file descriptor or
+.I dirfd
+is AT_FDABSOLUTE and
+.I pathname
+is relative.
 .TP
 .B EINVAL
 Invalid flag specified in
diff --git a/man2/symlink.2 b/man2/symlink.2
index 8bd067f..b53ca2d 100644
--- a/man2/symlink.2
+++ b/man2/symlink.2
@@ -133,6 +133,14 @@ directory of the calling process (like
 .BR symlink ()).
 
 If
+.I newdirfd
+is the special value
+.BR AT_FDABSOLUTE ,
+then
+.I linkpath
+must be absolute.
+
+If
 .I linkpath
 is absolute, then
 .I newdirfd
@@ -208,7 +216,11 @@ The following additional errors can occur for
 .TP
 .B EBADF
 .I newdirfd
-is not a valid file descriptor.
+is not a valid file descriptor or
+.I newdirfd
+is AT_FDABSOLUTE and
+.I linkpath
+is relative.
 .TP
 .B ENOENT
 .I linkpath
diff --git a/man2/unlink.2 b/man2/unlink.2
index ccc05bf..b6c1591 100644
--- a/man2/unlink.2
+++ b/man2/unlink.2
@@ -119,6 +119,14 @@ directory of the calling process (like
 and
 .BR rmdir (2)).
 
+If
+.I dirfd
+is the special value
+.BR AT_FDABSOLUTE ,
+then
+.I pathname
+must be absolute.
+
 If the pathname given in
 .I pathname
 is absolute, then
@@ -248,7 +256,11 @@ The following additional errors can occur for
 .TP
 .B EBADF
 .I dirfd
-is not a valid file descriptor.
+is not a valid file descriptor or
+.I dirfd
+is AT_FDABSOLUTE and
+.I pathname
+is relative.
 .TP
 .B EINVAL
 An invalid flag value was specified in
diff --git a/man2/utimensat.2 b/man2/utimensat.2
index 99b985c..c22e1f3 100644
--- a/man2/utimensat.2
+++ b/man2/utimensat.2
@@ -206,6 +206,14 @@ directory of the calling process (like
 .BR utimes (2)).
 
 If
+.I dirfd
+is the special value
+.BR AT_FDABSOLUTE ,
+then
+.I pathname
+must be absolute.
+
+If
 .I pathname
 is absolute, then
 .I dirfd
diff --git a/man3/readdir.3 b/man3/readdir.3
index 898ab31..7eda4a7 100644
--- a/man3/readdir.3
+++ b/man3/readdir.3
@@ -250,10 +250,10 @@ as follows:
 .in +4n
 .nf
 
-name_max = pathconf(dirpath, _PC_NAME_MAX);
+name_max = fpathconf(fddir, _PC_NAME_MAX);
 if (name_max == \-1)         /* Limit not defined, or error */
-    name_max = 255;         /* Take a guess */
-len = offsetof(struct dirent, d_name) + name_max + 1;
+    return ENOSYS;           /* Do not take a guess, that is incorrect */
+len = offsetof(struct dirent, d_name) + name_max + 1u;
 entryp = malloc(len);
 
 .fi
@@ -261,7 +261,17 @@ entryp = malloc(len);
 (POSIX.1 requires that
 .I d_name
 is the last field in a
-.IR "struct dirent" .)
+.IR "struct dirent" ".)"
+Note that
+.I fpathconf
+is used instead of 
+.I pathconf
+to avoid a time of check to time of use security hole. As well,
+.I dirfd
+is not portable to all systems so
+.I readdir_r
+therefore can not be used in a fully portable way. This problem is
+currently under review by the Austin Common Standards Revision Group.
 .SH SEE ALSO
 .BR getdents (2),
 .BR read (2),
-- 
1.7.9.5
