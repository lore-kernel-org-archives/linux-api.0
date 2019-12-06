From: Aleksa Sarai <cyphar@cyphar.com>
Subject: [PATCH man-pages 2/2] path_resolution.7: update to mention openat2(2) features
Date: Sat,  7 Dec 2019 01:29:31 +1100
Message-ID: <20191206142931.28138-2-cyphar@cyphar.com>
References: <20191206141338.23338-1-cyphar@cyphar.com>
 <20191206142931.28138-1-cyphar@cyphar.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20191206142931.28138-1-cyphar@cyphar.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Michael Kerrisk <mtk.manpages@gmail.com>
Cc: linux-api@vger.kernel.org, libc-alpha@sourceware.org, linux-man@vger.kernel.org, linux-kernel@vger.kernel.org, Aleksa Sarai <cyphar@cyphar.com>
List-Id: linux-api@vger.kernel.org

Signed-off-by: Aleksa Sarai <cyphar@cyphar.com>
---
 man7/path_resolution.7 | 56 ++++++++++++++++++++++++++++--------------
 1 file changed, 38 insertions(+), 18 deletions(-)

diff --git a/man7/path_resolution.7 b/man7/path_resolution.7
index 07664ed8faec..b4a65cc53120 100644
--- a/man7/path_resolution.7
+++ b/man7/path_resolution.7
@@ -29,30 +29,38 @@ path_resolution \- how a pathname is resolved to a file
 Some UNIX/Linux system calls have as parameter one or more filenames.
 A filename (or pathname) is resolved as follows.
 .SS Step 1: start of the resolution process
-If the pathname starts with the \(aq/\(aq character,
-the starting lookup directory
-is the root directory of the calling process.
-(A process inherits its
-root directory from its parent.
-Usually this will be the root directory
-of the file hierarchy.
-A process may get a different root directory
-by use of the
+If the pathname starts with the \(aq/\(aq character, the starting lookup
+directory is the root directory of the calling process.
+A process inherits its root directory from its parent.
+Usually this will be the root directory of the file hierarchy.
+A process may get a different root directory by use of the
 .BR chroot (2)
-system call.
+system call, or may temporarily use a different root directory by using
+.BR openat2 (2)
+with the
+.B RESOLVE_IN_ROOT
+flag set.
+.PP
 A process may get an entirely private mount namespace in case
 it\(emor one of its ancestors\(emwas started by an invocation of the
 .BR clone (2)
 system call that had the
 .B CLONE_NEWNS
-flag set.)
+flag set.
 This handles the \(aq/\(aq part of the pathname.
 .PP
-If the pathname does not start with the \(aq/\(aq character, the
-starting lookup directory of the resolution process is the current working
-directory of the process.
-(This is also inherited from the parent.
-It can be changed by use of the
+If the pathname does not start with the \(aq/\(aq character, the starting
+lookup directory of the resolution process is the current working directory of
+the process \(em or in the case of
+.BR openat (2)-style
+system calls, the
+.I dfd
+argument (or the current working directory if
+.B AT_FDCWD
+is passed as the
+.I dfd
+argument). The current working directory is inherited from the parent, and can
+be changed by use of the
 .BR chdir (2)
 system call.)
 .PP
@@ -91,7 +99,7 @@ Upon error, that error is returned.
 If the result is not a directory, an
 .B ENOTDIR
 error is returned.
-If the resolution of the symlink is successful and returns a directory,
+If the resolution of the symbolic link is successful and returns a directory,
 we set the current lookup directory to that directory, and go to
 the next component.
 Note that the resolution process here can involve recursion if the
@@ -124,6 +132,12 @@ the kernel's pathname-resolution code
 was reworked to eliminate the use of recursion,
 so that the only limit that remains is the maximum of 40
 resolutions for the entire pathname.
+.PP
+The resolution of symbolic links during this stage can be blocked by using
+.BR openat2 (2),
+with the
+.B RESOLVE_NO_SYMLINKS
+flag set.
 .SS Step 3: find the final entry
 The lookup of the final component of the pathname goes just like
 that of all other components, as described in the previous step,
@@ -145,7 +159,7 @@ The path resolution process will assume that these entries have
 their conventional meanings, regardless of whether they are
 actually present in the physical filesystem.
 .PP
-One cannot walk down past the root: "/.." is the same as "/".
+One cannot walk up past the root: "/.." is the same as "/".
 .SS Mount points
 After a "mount dev path" command, the pathname "path" refers to
 the root of the filesystem hierarchy on the device "dev", and no
@@ -154,6 +168,12 @@ longer to whatever it referred to earlier.
 One can walk out of a mounted filesystem: "path/.." refers to
 the parent directory of "path",
 outside of the filesystem hierarchy on "dev".
+.PP
+Traversal of mount points can be blocked by using
+.BR openat2 (2),
+with the
+.B RESOLVE_NO_XDEV
+flag set (though note that this also restricts bind mount traversal).
 .SS Trailing slashes
 If a pathname ends in a \(aq/\(aq, that forces resolution of the preceding
 component as in Step 2: it has to exist and resolve to a directory.
-- 
2.24.0
