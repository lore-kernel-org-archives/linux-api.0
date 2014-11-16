From: Josh Triplett <josh@joshtriplett.org>
Subject: [PATCH manpages] Document supplementary user IDs
Date: Sat, 15 Nov 2014 23:08:41 -0800
Message-ID: <3407ca29f3a22f1291252caaeaedbc8d7fe10442.1416121632.git.josh@joshtriplett.org>
References: <6b6bef0eb7328d466e8deef3d2c186a79633e0a7.1416121601.git.josh@joshtriplett.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <6b6bef0eb7328d466e8deef3d2c186a79633e0a7.1416121601.git.josh@joshtriplett.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, Theodore Ts'o <tytso@mit.edu>, Kees Cook <keescook@chromium.org>, mtk.manpages@gmail.com, linux-api@vger.kernel.org, linux-man@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Add new manpages for getusers(2) and setusers(2).  Discuss supplementary
UIDs in credentials(7).  Update manpages for seteuid(2), setfsuid(2),
setresuid(2), setreuid(2), and setuid(2).

Signed-off-by: Josh Triplett <josh@joshtriplett.org>
---
 man2/getusers.2    | 177 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 man2/seteuid.2     |  10 ++-
 man2/setfsuid.2    |   4 +-
 man2/setresuid.2   |   8 ++-
 man2/setreuid.2    |  12 +++-
 man2/setuid.2      |   7 ++-
 man2/setusers.2    |   1 +
 man7/credentials.7 |  21 ++++++-
 8 files changed, 229 insertions(+), 11 deletions(-)
 create mode 100644 man2/getusers.2
 create mode 100644 man2/setusers.2

diff --git a/man2/getusers.2 b/man2/getusers.2
new file mode 100644
index 0000000..e5dd371
--- /dev/null
+++ b/man2/getusers.2
@@ -0,0 +1,177 @@
+.\" Copyright 2014 Josh Triplett <josh@joshtriplett.org>
+.\" Based on getgroups.2:
+.\" Copyright 1993 Rickard E. Faith (faith@cs.unc.edu)
+.\"
+.\" %%%LICENSE_START(VERBATIM)
+.\" Permission is granted to make and distribute verbatim copies of this
+.\" manual provided the copyright notice and this permission notice are
+.\" preserved on all copies.
+.\"
+.\" Permission is granted to copy and distribute modified versions of this
+.\" manual under the conditions for verbatim copying, provided that the
+.\" entire resulting derived work is distributed under the terms of a
+.\" permission notice identical to this one.
+.\"
+.\" Since the Linux kernel and libraries are constantly changing, this
+.\" manual page may be incorrect or out-of-date.  The author(s) assume no
+.\" responsibility for errors or omissions, or for damages resulting from
+.\" the use of the information contained herein.  The author(s) may not
+.\" have taken the same level of care in the production of this manual,
+.\" which is licensed free of charge, as they might when working
+.\" professionally.
+.\"
+.\" Formatted or processed versions of this manual, if unaccompanied by
+.\" the source, must acknowledge the copyright and authors of this work.
+.\" %%%LICENSE_END
+.\"
+.\" Modified Thu Oct 31 12:04:29 1996 by Eric S. Raymond <esr@thyrsus.com>
+.\" Modified, 27 May 2004, Michael Kerrisk <mtk.manpages@gmail.com>
+.\"     Added notes on capability requirements
+.\" 2008-05-03, mtk, expanded and rewrote parts of DESCRIPTION and RETURN
+.\"     VALUE, made style of page more consistent with man-pages style.
+.\"
+.TH GETUSERS 2 2014-10-20 "Linux" "Linux Programmer's Manual"
+.SH NAME
+getusers, setusers \- get/set list of supplementary user IDs
+.SH SYNOPSIS
+.B #include <sys/types.h>
+.br
+.B #include <unistd.h>
+.sp
+.BI "int getusers(int " size ", uid_t *" list );
+.sp
+.BI "int setusers(int " size ", const uid_t *" list );
+.sp
+.in -4n
+Feature Test Macro Requirements for glibc (see
+.BR feature_test_macros (7)):
+.in
+.sp
+.BR getusers (),
+.BR setusers ():
+_GNU_SOURCE
+.SH DESCRIPTION
+.PP
+.BR getusers ()
+returns the supplementary user IDs of the calling process in
+.IR list .
+The argument
+.I size
+should be set to the maximum number of items that can be stored in the
+buffer pointed to by
+.IR list .
+If the calling process has more than
+.I size
+supplementary user IDs,
+.BR getusers ()
+returns an error.
+The returned list may or may not include the real, effective, saved, or filesystem user ID of the calling process.
+
+If
+.I size
+is zero,
+.I list
+is not modified, but the total number of supplementary user IDs for the
+process is returned.
+This allows the caller to determine the size of a dynamically allocated
+.I list
+to be used in a further call to
+.BR getusers ().
+.PP
+.BR setusers ()
+sets the supplementary user IDs for the calling process.
+The
+.I size
+argument specifies the number of supplementary user IDs
+in the buffer pointed to by
+.IR list .
+
+Any process may drop user IDs from its supplementary list; however, adding user
+IDs not already present in the supplementary list or in the real, effective, or
+saved user ID requires the
+.B CAP_SETUID
+capability.
+.SH RETURN VALUE
+On success,
+.BR getusers ()
+returns the number of supplementary user IDs.
+On error, \-1 is returned, and
+.I errno
+is set appropriately.
+
+On success,
+.BR setusers ()
+returns 0.
+On error, \-1 is returned, and
+.I errno
+is set appropriately.
+.SH ERRORS
+.TP
+.B EFAULT
+.I list
+has an invalid address.
+.PP
+.BR getusers ()
+can additionally fail with the following error:
+.TP
+.B EINVAL
+.I size
+is less than the number of supplementary user IDs, but is not zero.
+.PP
+.BR setusers ()
+can additionally fail with the following errors:
+.TP
+.B EINVAL
+.I size
+is greater than
+.B NUSERS_MAX
+(65536).
+.TP
+.B ENOMEM
+Out of memory.
+.TP
+.B EPERM
+.I list
+contains user IDs not present in the current supplemental user IDs list,
+and not equal to the real, effective, or saved user ID, and the calling
+process does not have
+.BR CAP_SETUID .
+.SH CONFORMING TO
+.BR getusers (),
+.BR setusers (),
+and supplementary user IDs in general are Linux-specific and should not
+be used in programs intended to be portable.
+.SH NOTES
+A process can have up to
+.B NUSERS_MAX
+supplementary user IDs in addition to the real, effective, and saved
+user IDs.
+The constant
+.B NUSERS_MAX
+is defined in
+.IR <limits.h> .
+The set of supplementary user IDs is inherited from the parent process,
+and preserved across an
+.BR execve (2).
+
+The maximum number of supplementary user IDs can be found at run time
+using
+.BR sysconf (3):
+.nf
+
+    long nusers_max;
+    nusers_max = sysconf(_SC_NUSERS_MAX);
+
+.fi
+The maximum return value of
+.BR getusers ()
+cannot be larger than this value.
+.SH SEE ALSO
+.BR capabilities (7),
+.BR credentials (7),
+.BR getgroups (2),
+.BR getresuid (2),
+.BR getuid (2),
+.BR setgroups (2),
+.BR setresuid (2),
+.BR setuid (2)
diff --git a/man2/seteuid.2 b/man2/seteuid.2
index 4690fd6..1710133 100644
--- a/man2/seteuid.2
+++ b/man2/seteuid.2
@@ -1,4 +1,5 @@
 .\" Copyright (C) 2001 Andries Brouwer (aeb@cwi.nl)
+.\" Copyright 2014 Josh Triplett <josh@joshtriplett.org>
 .\"
 .\" %%%LICENSE_START(VERBATIM)
 .\" Permission is granted to make and distribute verbatim copies of this
@@ -54,7 +55,8 @@ _BSD_SOURCE || _POSIX_C_SOURCE\ >=\ 200112L || _XOPEN_SOURCE\ >=\ 600
 .BR seteuid ()
 sets the effective user ID of the calling process.
 Unprivileged user processes may only set the effective user ID to the
-real user ID, the effective user ID or the saved set-user-ID.
+real user ID, the effective user ID, the saved set-user-ID, or a supplementary
+user ID.
 
 Precisely the same holds for
 .BR setegid ()
@@ -95,9 +97,13 @@ and
 (respectively,
 .IR egid )
 is not the real user (group) ID, the effective user (group) ID,
-or the saved set-user-ID (saved set-group-ID).
+the saved set-user-ID (saved set-group-ID), or one of the supplementary
+user (group) IDs.
 .SH CONFORMING TO
 4.3BSD, POSIX.1-2001.
+
+Support for supplementary user IDs is Linux-specific and should not be
+used in programs intended to be portable.
 .SH NOTES
 Setting the effective user (group) ID to the
 saved set-user-ID (saved set-group-ID) is
diff --git a/man2/setfsuid.2 b/man2/setfsuid.2
index 57b125e..f15a31c 100644
--- a/man2/setfsuid.2
+++ b/man2/setfsuid.2
@@ -1,4 +1,5 @@
 .\" Copyright (C) 1995, Thomas K. Dyas <tdyas@eden.rutgers.edu>
+.\" Copyright 2014 Josh Triplett <josh@joshtriplett.org>
 .\"
 .\" %%%LICENSE_START(VERBATIM)
 .\" Permission is granted to make and distribute verbatim copies of this
@@ -64,7 +65,8 @@ is a security hole that can expose it to unwanted signals.
 will succeed only if the caller is the superuser or if
 .I fsuid
 matches either the caller's real user ID, effective user ID,
-saved set-user-ID, or current filesystem user ID.
+saved set-user-ID, current filesystem user ID, or any supplementary
+user ID.
 .SH RETURN VALUE
 On both success and failure,
 this call returns the previous filesystem user ID of the caller.
diff --git a/man2/setresuid.2 b/man2/setresuid.2
index 99ab94f..cc0ba54 100644
--- a/man2/setresuid.2
+++ b/man2/setresuid.2
@@ -1,4 +1,5 @@
 .\" Copyright (C) 1997 Andries Brouwer (aeb@cwi.nl)
+.\" Copyright 2014 Josh Triplett <josh@joshtriplett.org>
 .\"
 .\" %%%LICENSE_START(VERBATIM)
 .\" Permission is granted to make and distribute verbatim copies of this
@@ -42,8 +43,8 @@ saved set-user-ID of the calling process.
 Unprivileged user processes
 may change the real UID,
 effective UID, and saved set-user-ID, each to one of:
-the current real UID, the current effective UID or the
-current saved set-user-ID.
+the current real UID, the current effective UID, the
+current saved set-user-ID, or any supplementary UID.
 
 Privileged processes (on Linux, those having the \fBCAP_SETUID\fP capability)
 may set the real UID, effective UID, and
@@ -109,6 +110,9 @@ These calls are available under Linux since Linux 2.1.44.
 .SH CONFORMING TO
 These calls are nonstandard;
 they also appear on HP-UX and some of the BSDs.
+
+Support for supplementary user IDs is Linux-specific and should not be
+used in programs intended to be portable.
 .SH NOTES
 Under HP-UX and FreeBSD, the prototype is found in
 .IR <unistd.h> .
diff --git a/man2/setreuid.2 b/man2/setreuid.2
index c6597e9..3b19b8d 100644
--- a/man2/setreuid.2
+++ b/man2/setreuid.2
@@ -1,4 +1,5 @@
 .\" Copyright (c) 1983, 1991 The Regents of the University of California.
+.\" Copyright 2014 Josh Triplett <josh@joshtriplett.org>
 .\" All rights reserved.
 .\"
 .\" %%%LICENSE_START(BSD_4_CLAUSE_UCB)
@@ -75,10 +76,10 @@ Supplying a value of \-1 for either the real or effective user ID forces
 the system to leave that ID unchanged.
 
 Unprivileged processes may only set the effective user ID to the real user ID,
-the effective user ID, or the saved set-user-ID.
+the effective user ID, the saved set-user-ID, or a supplementary user ID.
 
 Unprivileged users may only set the real user ID to
-the real user ID or the effective user ID.
+the real user ID, the effective user ID, or a supplementary user ID.
 
 If the real user ID is set (i.e.,
 .I ruid
@@ -144,13 +145,18 @@ and a change other than (i)
 swapping the effective user (group) ID with the real user (group) ID,
 or (ii) setting one to the value of the other or (iii) setting the
 effective user (group) ID to the value of the
-saved set-user-ID (saved set-group-ID) was specified.
+saved set-user-ID (saved set-group-ID) or (iv) setting the real or
+effective user (group) ID to a supplementary user (group) ID was
+specified.
 .SH CONFORMING TO
 POSIX.1-2001, 4.3BSD (the
 .BR setreuid ()
 and
 .BR setregid ()
 function calls first appeared in 4.2BSD).
+
+Support for supplementary user IDs is Linux-specific and should not be
+used in programs intended to be portable.
 .SH NOTES
 Setting the effective user (group) ID to the
 saved set-user-ID (saved set-group-ID) is
diff --git a/man2/setuid.2 b/man2/setuid.2
index c6f870e..e2082be 100644
--- a/man2/setuid.2
+++ b/man2/setuid.2
@@ -1,4 +1,5 @@
 .\" Copyright (C), 1994, Graeme W. Wilford (Wilf).
+.\" Copyright 2014 Josh Triplett <josh@joshtriplett.org>
 .\"
 .\" %%%LICENSE_START(VERBATIM)
 .\" Permission is granted to make and distribute verbatim copies of this
@@ -113,11 +114,15 @@ The user is not privileged (Linux: does not have the
 .B CAP_SETUID
 capability) and
 .I uid
-does not match the real UID or saved set-user-ID of the calling process.
+does not match the real UID, saved set-user-ID, or any supplementary
+user ID of the calling process.
 .SH CONFORMING TO
 SVr4, POSIX.1-2001.
 Not quite compatible with the 4.4BSD call, which
 sets all of the real, saved, and effective user IDs.
+
+Support for supplementary user IDs is Linux-specific and should not be
+used in programs intended to be portable.
 .\" SVr4 documents an additional EINVAL error condition.
 .SH NOTES
 Linux has the concept of the filesystem user ID, normally equal to the
diff --git a/man2/setusers.2 b/man2/setusers.2
new file mode 100644
index 0000000..8044989
--- /dev/null
+++ b/man2/setusers.2
@@ -0,0 +1 @@
+.so man2/getusers.2
diff --git a/man7/credentials.7 b/man7/credentials.7
index acb799d..df601e2 100644
--- a/man7/credentials.7
+++ b/man7/credentials.7
@@ -1,4 +1,5 @@
 .\" Copyright (c) 2007 by Michael Kerrisk <mtk.manpages@gmail.com>
+.\" Copyright 2014 Josh Triplett <josh@joshtriplett.org>
 .\"
 .\" %%%LICENSE_START(VERBATIM)
 .\" Permission is granted to make and distribute verbatim copies of this
@@ -232,6 +233,19 @@ by calling
 and
 .BR setfsgid (2).
 .IP *
+Supplementary user IDs.
+This is a set of additional user IDs that the process has
+permission to act as.
+A process can have up to 65536 supplementary user IDs.
+The call
+.I sysconf(_SC_NUSERS_MAX)
+can be used to determine the number of supplementary user IDs
+a process may have.
+A process can obtain its set of supplementary user IDs using
+.BR getusers (2),
+and can modify the set using
+.BR setusers (2).
+.IP *
 Supplementary group IDs.
 This is a set of additional group IDs that are used for permission
 checks when accessing files and other shared resources.
@@ -256,7 +270,7 @@ A child process created by
 inherits copies of its parent's user and groups IDs.
 During an
 .BR execve (2),
-a process's real user and group ID and supplementary
+a process's real user and group ID and supplementary user and
 group IDs are preserved;
 the effective and saved set IDs may be changed, as described in
 .BR execve (2).
@@ -289,7 +303,8 @@ Process IDs, parent process IDs, process group IDs, and session IDs
 are specified in POSIX.1-2001.
 The real, effective, and saved set user and groups IDs,
 and the supplementary group IDs, are specified in POSIX.1-2001.
-The filesystem user and group IDs are a Linux extension.
+The filesystem user and group IDs, and the supplementary user IDs, are
+Linux extensions.
 .SH NOTES
 The POSIX threads specification requires that
 credentials are shared by all of the threads in a process.
@@ -314,6 +329,7 @@ is carried through to all of the POSIX threads in a process.
 .BR getpid (2),
 .BR getppid (2),
 .BR getsid (2),
+.BR getusers (2),
 .BR kill (2),
 .BR killpg (2),
 .BR setegid (2),
@@ -325,6 +341,7 @@ is carried through to all of the POSIX threads in a process.
 .BR setresgid (2),
 .BR setresuid (2),
 .BR setuid (2),
+.BR setusers (2),
 .BR waitpid (2),
 .BR euidaccess (3),
 .BR initgroups (3),
-- 
2.1.3
