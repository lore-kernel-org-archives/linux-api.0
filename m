From: David Drysdale <drysdale-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 03/11] capsicum: rights values and structure definitions
Date: Mon, 30 Jun 2014 11:28:03 +0100
Message-ID: <1404124096-21445-4-git-send-email-drysdale@google.com>
References: <1404124096-21445-1-git-send-email-drysdale@google.com>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1404124096-21445-1-git-send-email-drysdale-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
Cc: Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Meredydd Luff <meredydd-zPN50pYk8eUaUu29zAJCuw@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, James Morris <james.l.morris-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, David Drysdale <drysdale-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Define (in include/uapi/linux/capsicum.h) values for primary
rights associated with Capsicum capability file descriptors.

Also define the structure that primary rights reside in (struct
cap_rights), and the complete compound rights structure (struct
capsicum_rights).

 - Primary rights describe the main operations that can be
   performed on a file.
 - Secondary rights allow for specific fcntl() and ioctl()
   operations to be policed.

Add functions to manipulate these rights structures.

This change is adapted from the FreeBSD 10.x implementation of
Capsicum, with the aim of preserving compatibility between the
two implementations as closely as possible.

Signed-off-by: David Drysdale <drysdale-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
---
 Documentation/security/capsicum.txt | 102 +++++++++++
 include/linux/capsicum.h            |  50 ++++++
 include/uapi/linux/Kbuild           |   1 +
 include/uapi/linux/capsicum.h       | 343 ++++++++++++++++++++++++++++++++++++
 security/Kconfig                    |  15 ++
 security/Makefile                   |   2 +-
 security/capsicum-rights.c          | 201 +++++++++++++++++++++
 security/capsicum-rights.h          |  10 ++
 8 files changed, 723 insertions(+), 1 deletion(-)
 create mode 100644 Documentation/security/capsicum.txt
 create mode 100644 include/linux/capsicum.h
 create mode 100644 include/uapi/linux/capsicum.h
 create mode 100644 security/capsicum-rights.c
 create mode 100644 security/capsicum-rights.h

diff --git a/Documentation/security/capsicum.txt b/Documentation/security/capsicum.txt
new file mode 100644
index 000000000000..27e950828359
--- /dev/null
+++ b/Documentation/security/capsicum.txt
@@ -0,0 +1,102 @@
+Capsicum Object Capabilities
+============================
+
+Capsicum is a lightweight OS capability and sandbox framework, which allows
+security-aware userspace applications to sandbox parts of their own code in a
+highly granular way, reducing the attack surface in the event of subversion.
+
+Originally developed at the University of Cambridge Computer Laboratory, and
+initially implemented in FreeBSD 9.x, Capsicum extends the POSIX API, providing
+several new OS primitives to support object-capability security on UNIX-like
+operating systems.
+
+Note that Capsicum capability file descriptors are radically different to the
+POSIX.1e capabilities that are already available in Linux:
+ - POSIX.1e capabilities subdivide the root user's authority into different
+   areas of functionality.
+ - Capsicum capabilities restrict individual file descriptors so that
+   only operations permitted by that particular FD's rights are allowed.
+
+
+Overview
+--------
+
+Capability-based security is a security model where objects can only be
+accessed via capabilities, which are unforgeable tokens of authority that only
+give rights to perform certain operations.
+
+Capsicum is a pragmatic blend of capability-based security with standard
+UNIX/POSIX system semantics.  A Capsicum capability is a file descriptor that
+has an associated rights bitmask, and the kernel polices operations using that
+file descriptor, failing operations with insufficient rights.
+
+
+Capability Data Structure
+-------------------------
+
+Internally, a capability is a particular kind of struct file that wraps an
+underlying normal file.   The private data for the wrapper indicates the
+wrapped file, and holds the rights information for the capability.
+
+
+FD to File Conversion
+---------------------
+
+The primary policing of Capsicum capabilities occurs when a user-provided file
+descriptor is converted to a struct file object, normally using one of the
+fgetr() family of functions.
+
+All such operations in the kernel are annotated with information about the
+operations that are going to be performed on the retrieved struct file.  For
+example, a file that is retrieved for a read operation has its fgetr() call
+annotated with CAP_READ, indicating that any capability FD that reaches this
+point needs to include the CAP_READ right to progress further.  If the
+appropriate right is not available, -ENOTCAPABLE is returned.
+
+This change is the most significant change to the kernel, as it affects all
+FD-to-file conversions.  However, for a non-Capsicum build of the kernel the
+impact is minimal as the additional rights parameters to fgetr*() are macroed
+out.
+
+
+Path Traversal
+--------------
+
+Capsicum does allow new files to be accessed beneath a directory for which the
+application has a suitable capability FD (one including the CAP_LOOKUP right),
+using the openat(2) system call.  To prevent escape from the directory, path
+traversals are policed for "/" and ".." components.
+
+
+LSM Interactions
+----------------
+
+The annotation of all fget() calls with intended file operations, expressed
+as combinations of Capsicum rights values, is implemented as mainline kernel
+modifications.
+
+The remainder of the Capsicum functionality is via Linux Security Module (LSM)
+hooks, with Capsicum providing the default implementation when the active LSM
+does not override.  (If the active LSM does choose to override the Capsicum
+implementation, it should ensure that the Capsicum functionality is unaffected,
+by combining the results of the Capsicum implementation with its own.)
+
+The additional hooks added for (and implemented by) Capsicum are:
+ - file_lookup: Allow modification of the result of an fget() operation, so that
+   a rights check can be performed and the normal file underlying a capability
+   can be returned.
+ - file_install: Allow modification of a file that is about to be installed
+   into the file descriptor table, in cases where the new file is derived
+   from another file (that may be a Capsicum capability and so have rights
+   associated with it).
+
+
+New System Calls
+----------------
+
+Capsicum implements the following new system calls:
+ - cap_rights_limit: restrict the rights associated with file descriptor, thus
+   turning it into a capability FD; internally this is implemented by wrapping
+   the original struct file with a capability file (security/capsicum.c)
+ - cap_rights_get: return the rights associated with a capability FD
+   (security/capsicum.c)
diff --git a/include/linux/capsicum.h b/include/linux/capsicum.h
new file mode 100644
index 000000000000..74f79756097a
--- /dev/null
+++ b/include/linux/capsicum.h
@@ -0,0 +1,50 @@
+#ifndef _LINUX_CAPSICUM_H
+#define _LINUX_CAPSICUM_H
+
+#include <stdarg.h>
+#include <uapi/linux/capsicum.h>
+
+struct file;
+/* Complete rights structure (primary and subrights). */
+struct capsicum_rights {
+	struct cap_rights primary;
+	unsigned int fcntls;  /* Only valid if CAP_FCNTL set in primary. */
+	int nioctls;  /* -1=>all; only valid if CAP_IOCTL set in primary */
+	unsigned int *ioctls;
+};
+
+#define CAP_LIST_END	0ULL
+
+#ifdef CONFIG_SECURITY_CAPSICUM
+/* Rights manipulation functions */
+#define cap_rights_init(rights, ...) \
+	_cap_rights_init((rights), __VA_ARGS__, CAP_LIST_END)
+#define cap_rights_set(rights, ...) \
+	_cap_rights_set((rights), __VA_ARGS__, CAP_LIST_END)
+struct capsicum_rights *_cap_rights_init(struct capsicum_rights *rights, ...);
+struct capsicum_rights *_cap_rights_set(struct capsicum_rights *rights, ...);
+struct capsicum_rights *cap_rights_vinit(struct capsicum_rights *rights,
+					 va_list ap);
+struct capsicum_rights *cap_rights_vset(struct capsicum_rights *rights,
+					va_list ap);
+struct capsicum_rights *cap_rights_set_all(struct capsicum_rights *rights);
+bool cap_rights_is_all(const struct capsicum_rights *rights);
+
+#else
+
+#define cap_rights_init(rights, ...) _cap_rights_noop(rights)
+#define cap_rights_set(rights, ...) _cap_rights_noop(rights)
+#define cap_rights_set_all(rights) _cap_rights_noop(rights)
+static inline struct capsicum_rights *
+_cap_rights_noop(struct capsicum_rights *rights)
+{
+	return rights;
+}
+static inline bool cap_rights_is_all(const struct capsicum_rights *rights)
+{
+	return true;
+}
+
+#endif
+
+#endif /* _LINUX_CAPSICUM_H */
diff --git a/include/uapi/linux/Kbuild b/include/uapi/linux/Kbuild
index 6929571b79b0..57410bbee2f6 100644
--- a/include/uapi/linux/Kbuild
+++ b/include/uapi/linux/Kbuild
@@ -73,6 +73,7 @@ header-y += btrfs.h
 header-y += can.h
 header-y += capability.h
 header-y += capi.h
+header-y += capsicum.h
 header-y += cciss_defs.h
 header-y += cciss_ioctl.h
 header-y += cdrom.h
diff --git a/include/uapi/linux/capsicum.h b/include/uapi/linux/capsicum.h
new file mode 100644
index 000000000000..a39ac86fa183
--- /dev/null
+++ b/include/uapi/linux/capsicum.h
@@ -0,0 +1,343 @@
+#ifndef _UAPI_LINUX_CAPSICUM_H
+#define _UAPI_LINUX_CAPSICUM_H
+
+/*-
+ * Copyright (c) 2008-2010 Robert N. M. Watson
+ * Copyright (c) 2012 FreeBSD Foundation
+ * All rights reserved.
+ *
+ * This software was developed at the University of Cambridge Computer
+ * Laboratory with support from a grant from Google, Inc.
+ *
+ * Portions of this software were developed by Pawel Jakub Dawidek under
+ * sponsorship from the FreeBSD Foundation.
+ *
+ * Redistribution and use in source and binary forms, with or without
+ * modification, are permitted provided that the following conditions
+ * are met:
+ * 1. Redistributions of source code must retain the above copyright
+ *    notice, this list of conditions and the following disclaimer.
+ * 2. Redistributions in binary form must reproduce the above copyright
+ *    notice, this list of conditions and the following disclaimer in the
+ *    documentation and/or other materials provided with the distribution.
+ *
+ * THIS SOFTWARE IS PROVIDED BY THE AUTHOR AND CONTRIBUTORS ``AS IS'' AND
+ * ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
+ * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
+ * ARE DISCLAIMED.  IN NO EVENT SHALL THE AUTHOR OR CONTRIBUTORS BE LIABLE
+ * FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
+ * DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
+ * OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
+ * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
+ * LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
+ * OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
+ * SUCH DAMAGE.
+ */
+
+/*
+ * Definitions for Capsicum capabilities facility.
+ */
+#include <linux/types.h>
+
+/*
+ * The top two bits in the first element of the cr_rights[] array contain
+ * total number of elements in the array - 2. This means if those two bits are
+ * equal to 0, we have 2 array elements.
+ * The top two bits in all remaining array elements should be 0.
+ * The next five bits contain array index. Only one bit is used and bit position
+ * in this five-bits range defines array index. This means there can be at most
+ * five array elements.
+ */
+#define CAP_RIGHTS_VERSION_00	0
+/*
+#define CAP_RIGHTS_VERSION_01	1
+#define CAP_RIGHTS_VERSION_02	2
+#define CAP_RIGHTS_VERSION_03	3
+*/
+#define CAP_RIGHTS_VERSION	CAP_RIGHTS_VERSION_00
+
+/* Primary rights */
+struct cap_rights {
+	__u64	cr_rights[CAP_RIGHTS_VERSION + 2];
+};
+
+#define CAPRIGHT(idx, bit)	((1ULL << (57 + (idx))) | (bit))
+
+/*
+ * Possible rights on capabilities.
+ *
+ * Notes:
+ * Some system calls don't require a capability in order to perform an
+ * operation on an fd.  These include: close, dup, dup2.
+ *
+ * sendfile is authorized using CAP_READ on the file and CAP_WRITE on the
+ * socket.
+ *
+ * mmap() and aio*() system calls will need special attention as they may
+ * involve reads or writes depending a great deal on context.
+ */
+
+/* INDEX 0 */
+
+/*
+ * General file I/O.
+ */
+/* Allows for openat(O_RDONLY), read(2), readv(2). */
+#define CAP_READ		CAPRIGHT(0, 0x0000000000000001ULL)
+/* Allows for openat(O_WRONLY | O_APPEND), write(2), writev(2). */
+#define CAP_WRITE		CAPRIGHT(0, 0x0000000000000002ULL)
+/* Allows for lseek(fd, 0, SEEK_CUR). */
+#define CAP_SEEK_TELL		CAPRIGHT(0, 0x0000000000000004ULL)
+/* Allows for lseek(2). */
+#define CAP_SEEK		(CAP_SEEK_TELL | 0x0000000000000008ULL)
+/* Allows for aio_read(2), pread(2), preadv(2). */
+#define CAP_PREAD		(CAP_SEEK | CAP_READ)
+/*
+ * Allows for aio_write(2), openat(O_WRONLY) (without O_APPEND), pwrite(2),
+ * pwritev(2).
+ */
+#define CAP_PWRITE		(CAP_SEEK | CAP_WRITE)
+/* Allows for mmap(PROT_NONE). */
+#define CAP_MMAP		CAPRIGHT(0, 0x0000000000000010ULL)
+/* Allows for mmap(PROT_READ). */
+#define CAP_MMAP_R		(CAP_MMAP | CAP_SEEK | CAP_READ)
+/* Allows for mmap(PROT_WRITE). */
+#define CAP_MMAP_W		(CAP_MMAP | CAP_SEEK | CAP_WRITE)
+/* Allows for mmap(PROT_EXEC). */
+#define CAP_MMAP_X		(CAP_MMAP | CAP_SEEK | 0x0000000000000020ULL)
+/* Allows for mmap(PROT_READ | PROT_WRITE). */
+#define CAP_MMAP_RW		(CAP_MMAP_R | CAP_MMAP_W)
+/* Allows for mmap(PROT_READ | PROT_EXEC). */
+#define CAP_MMAP_RX		(CAP_MMAP_R | CAP_MMAP_X)
+/* Allows for mmap(PROT_WRITE | PROT_EXEC). */
+#define CAP_MMAP_WX		(CAP_MMAP_W | CAP_MMAP_X)
+/* Allows for mmap(PROT_READ | PROT_WRITE | PROT_EXEC). */
+#define CAP_MMAP_RWX		(CAP_MMAP_R | CAP_MMAP_W | CAP_MMAP_X)
+/* Allows for openat(O_CREAT). */
+#define CAP_CREATE		CAPRIGHT(0, 0x0000000000000040ULL)
+/* Allows for openat(O_EXEC) and fexecve(2) in turn. */
+#define CAP_FEXECVE		CAPRIGHT(0, 0x0000000000000080ULL)
+/* Allows for openat(O_SYNC), openat(O_FSYNC), fsync(2), aio_fsync(2). */
+#define CAP_FSYNC		CAPRIGHT(0, 0x0000000000000100ULL)
+/* Allows for openat(O_TRUNC), ftruncate(2). */
+#define CAP_FTRUNCATE		CAPRIGHT(0, 0x0000000000000200ULL)
+
+/* Lookups - used to constrain *at() calls. */
+#define CAP_LOOKUP		CAPRIGHT(0, 0x0000000000000400ULL)
+
+/* VFS methods. */
+/* Allows for fchdir(2). */
+#define CAP_FCHDIR		CAPRIGHT(0, 0x0000000000000800ULL)
+/* Allows for fchflags(2). */
+#define CAP_FCHFLAGS		CAPRIGHT(0, 0x0000000000001000ULL)
+/* Allows for fchflags(2) and chflagsat(2). */
+#define CAP_CHFLAGSAT		(CAP_FCHFLAGS | CAP_LOOKUP)
+/* Allows for fchmod(2). */
+#define CAP_FCHMOD		CAPRIGHT(0, 0x0000000000002000ULL)
+/* Allows for fchmod(2) and fchmodat(2). */
+#define CAP_FCHMODAT		(CAP_FCHMOD | CAP_LOOKUP)
+/* Allows for fchown(2). */
+#define CAP_FCHOWN		CAPRIGHT(0, 0x0000000000004000ULL)
+/* Allows for fchown(2) and fchownat(2). */
+#define CAP_FCHOWNAT		(CAP_FCHOWN | CAP_LOOKUP)
+/* Allows for fcntl(2). */
+#define CAP_FCNTL		CAPRIGHT(0, 0x0000000000008000ULL)
+/*
+ * Allows for flock(2), openat(O_SHLOCK), openat(O_EXLOCK),
+ * fcntl(F_SETLK_REMOTE), fcntl(F_SETLKW), fcntl(F_SETLK), fcntl(F_GETLK).
+ */
+#define CAP_FLOCK		CAPRIGHT(0, 0x0000000000010000ULL)
+/* Allows for fpathconf(2). */
+#define CAP_FPATHCONF		CAPRIGHT(0, 0x0000000000020000ULL)
+/* Allows for UFS background-fsck operations. */
+#define CAP_FSCK		CAPRIGHT(0, 0x0000000000040000ULL)
+/* Allows for fstat(2). */
+#define CAP_FSTAT		CAPRIGHT(0, 0x0000000000080000ULL)
+/* Allows for fstat(2), fstatat(2) and faccessat(2). */
+#define CAP_FSTATAT		(CAP_FSTAT | CAP_LOOKUP)
+/* Allows for fstatfs(2). */
+#define CAP_FSTATFS		CAPRIGHT(0, 0x0000000000100000ULL)
+/* Allows for futimes(2). */
+#define CAP_FUTIMES		CAPRIGHT(0, 0x0000000000200000ULL)
+/* Allows for futimes(2) and futimesat(2). */
+#define CAP_FUTIMESAT		(CAP_FUTIMES | CAP_LOOKUP)
+/* Allows for linkat(2) and renameat(2) (destination directory descriptor). */
+#define CAP_LINKAT		(CAP_LOOKUP | 0x0000000000400000ULL)
+/* Allows for mkdirat(2). */
+#define CAP_MKDIRAT		(CAP_LOOKUP | 0x0000000000800000ULL)
+/* Allows for mkfifoat(2). */
+#define CAP_MKFIFOAT		(CAP_LOOKUP | 0x0000000001000000ULL)
+/* Allows for mknodat(2). */
+#define CAP_MKNODAT		(CAP_LOOKUP | 0x0000000002000000ULL)
+/* Allows for renameat(2). */
+#define CAP_RENAMEAT		(CAP_LOOKUP | 0x0000000004000000ULL)
+/* Allows for symlinkat(2). */
+#define CAP_SYMLINKAT		(CAP_LOOKUP | 0x0000000008000000ULL)
+/*
+ * Allows for unlinkat(2) and renameat(2) if destination object exists and
+ * will be removed.
+ */
+#define CAP_UNLINKAT		(CAP_LOOKUP | 0x0000000010000000ULL)
+
+/* Socket operations. */
+/* Allows for accept(2) and accept4(2). */
+#define CAP_ACCEPT		CAPRIGHT(0, 0x0000000020000000ULL)
+/* Allows for bind(2). */
+#define CAP_BIND		CAPRIGHT(0, 0x0000000040000000ULL)
+/* Allows for connect(2). */
+#define CAP_CONNECT		CAPRIGHT(0, 0x0000000080000000ULL)
+/* Allows for getpeername(2). */
+#define CAP_GETPEERNAME	CAPRIGHT(0, 0x0000000100000000ULL)
+/* Allows for getsockname(2). */
+#define CAP_GETSOCKNAME	CAPRIGHT(0, 0x0000000200000000ULL)
+/* Allows for getsockopt(2). */
+#define CAP_GETSOCKOPT		CAPRIGHT(0, 0x0000000400000000ULL)
+/* Allows for listen(2). */
+#define CAP_LISTEN		CAPRIGHT(0, 0x0000000800000000ULL)
+/* Allows for sctp_peeloff(2). */
+#define CAP_PEELOFF		CAPRIGHT(0, 0x0000001000000000ULL)
+#define CAP_RECV		CAP_READ
+#define CAP_SEND		CAP_WRITE
+/* Allows for setsockopt(2). */
+#define CAP_SETSOCKOPT		CAPRIGHT(0, 0x0000002000000000ULL)
+/* Allows for shutdown(2). */
+#define CAP_SHUTDOWN		CAPRIGHT(0, 0x0000004000000000ULL)
+
+/* Allows for bindat(2) on a directory descriptor. */
+#define CAP_BINDAT		(CAP_LOOKUP | 0x0000008000000000ULL)
+/* Allows for connectat(2) on a directory descriptor. */
+#define CAP_CONNECTAT		(CAP_LOOKUP | 0x0000010000000000ULL)
+
+#define CAP_SOCK_CLIENT \
+	(CAP_CONNECT | CAP_GETPEERNAME | CAP_GETSOCKNAME | CAP_GETSOCKOPT | \
+	 CAP_PEELOFF | CAP_RECV | CAP_SEND | CAP_SETSOCKOPT | CAP_SHUTDOWN)
+#define CAP_SOCK_SERVER \
+	(CAP_ACCEPT | CAP_BIND | CAP_GETPEERNAME | CAP_GETSOCKNAME | \
+	 CAP_GETSOCKOPT | CAP_LISTEN | CAP_PEELOFF | CAP_RECV | CAP_SEND | \
+	 CAP_SETSOCKOPT | CAP_SHUTDOWN)
+
+/* All used bits for index 0. */
+#define CAP_ALL0		CAPRIGHT(0, 0x0000007FFFFFFFFFULL)
+
+/* Available bits for index 0. */
+#define CAP_UNUSED0_40		CAPRIGHT(0, 0x0000008000000000ULL)
+/* ... */
+#define CAP_UNUSED0_57		CAPRIGHT(0, 0x0100000000000000ULL)
+
+/* INDEX 1 */
+
+/* Mandatory Access Control. */
+/* Allows for mac_get_fd(3). */
+#define CAP_MAC_GET		CAPRIGHT(1, 0x0000000000000001ULL)
+/* Allows for mac_set_fd(3). */
+#define CAP_MAC_SET		CAPRIGHT(1, 0x0000000000000002ULL)
+
+/* Methods on semaphores. */
+#define CAP_SEM_GETVALUE	CAPRIGHT(1, 0x0000000000000004ULL)
+#define CAP_SEM_POST		CAPRIGHT(1, 0x0000000000000008ULL)
+#define CAP_SEM_WAIT		CAPRIGHT(1, 0x0000000000000010ULL)
+
+/* Allows select(2) and poll(2) on descriptor. */
+#define CAP_EVENT		CAPRIGHT(1, 0x0000000000000020ULL)
+/* Allows for kevent(2) on kqueue descriptor with eventlist != NULL. */
+#define CAP_KQUEUE_EVENT	CAPRIGHT(1, 0x0000000000000040ULL)
+
+/* Strange and powerful rights that should not be given lightly. */
+/* Allows for ioctl(2). */
+#define CAP_IOCTL		CAPRIGHT(1, 0x0000000000000080ULL)
+#define CAP_TTYHOOK		CAPRIGHT(1, 0x0000000000000100ULL)
+
+/* Process management via process descriptors. */
+/* Allows for pdgetpid(2). */
+#define CAP_PDGETPID		CAPRIGHT(1, 0x0000000000000200ULL)
+/* Allows for pdwait4(2). */
+#define CAP_PDWAIT		CAPRIGHT(1, 0x0000000000000400ULL)
+/* Allows for pdkill(2). */
+#define CAP_PDKILL		CAPRIGHT(1, 0x0000000000000800ULL)
+
+/* Extended attributes. */
+/* Allows for extattr_delete_fd(2). */
+#define CAP_EXTATTR_DELETE	CAPRIGHT(1, 0x0000000000001000ULL)
+/* Allows for extattr_get_fd(2). */
+#define CAP_EXTATTR_GET	CAPRIGHT(1, 0x0000000000002000ULL)
+/* Allows for extattr_list_fd(2). */
+#define CAP_EXTATTR_LIST	CAPRIGHT(1, 0x0000000000004000ULL)
+/* Allows for extattr_set_fd(2). */
+#define CAP_EXTATTR_SET	CAPRIGHT(1, 0x0000000000008000ULL)
+
+/* Access Control Lists. */
+/* Allows for acl_valid_fd_np(3). */
+#define CAP_ACL_CHECK		CAPRIGHT(1, 0x0000000000010000ULL)
+/* Allows for acl_delete_fd_np(3). */
+#define CAP_ACL_DELETE		CAPRIGHT(1, 0x0000000000020000ULL)
+/* Allows for acl_get_fd(3) and acl_get_fd_np(3). */
+#define CAP_ACL_GET		CAPRIGHT(1, 0x0000000000040000ULL)
+/* Allows for acl_set_fd(3) and acl_set_fd_np(3). */
+#define CAP_ACL_SET		CAPRIGHT(1, 0x0000000000080000ULL)
+
+/* Allows for kevent(2) on kqueue descriptor with changelist != NULL. */
+#define CAP_KQUEUE_CHANGE	CAPRIGHT(1, 0x0000000000100000ULL)
+
+#define CAP_KQUEUE		(CAP_KQUEUE_EVENT | CAP_KQUEUE_CHANGE)
+
+/* Modify signalfd signal mask. */
+#define CAP_FSIGNAL             CAPRIGHT(1, 0x0000000000200000ULL)
+
+/* Modify epollfd set of FDs/events */
+#define CAP_EPOLL_CTL           CAPRIGHT(1, 0x0000000000400000ULL)
+
+/* Modify things monitored by inotify/fanotify FD */
+#define CAP_NOTIFY              CAPRIGHT(1, 0x0000000000800000ULL)
+
+/* Allow entry to a namespace associated with a file descriptor */
+#define CAP_SETNS               CAPRIGHT(1, 0x0000000001000000ULL)
+
+/* Allow performance monitoring operations */
+#define CAP_PERFMON             CAPRIGHT(1, 0x0000000002000000ULL)
+
+/* All used bits for index 1. */
+#define CAP_ALL1		CAPRIGHT(1, 0x0000000003FFFFFFULL)
+
+/* Available bits for index 1. */
+#define CAP_UNUSED1_27		CAPRIGHT(1, 0x0000000004000000ULL)
+/* ... */
+#define CAP_UNUSED1_57		CAPRIGHT(1, 0x0100000000000000ULL)
+
+/* Backward compatibility. */
+#define CAP_POLL_EVENT		CAP_EVENT
+
+#define CAP_SET_ALL(rights)		do {				\
+	(rights)->cr_rights[0] =					\
+	    ((__u64)CAP_RIGHTS_VERSION << 62) | CAP_ALL0;		\
+	(rights)->cr_rights[1] = CAP_ALL1;				\
+} while (0)
+
+#define CAP_SET_NONE(rights)	do {					\
+	(rights)->cr_rights[0] =					\
+	    ((__u64)CAP_RIGHTS_VERSION << 62) | CAPRIGHT(0, 0ULL);	\
+	(rights)->cr_rights[1] = CAPRIGHT(1, 0ULL);			\
+} while (0)
+
+#define CAP_IS_ALL(rights)						\
+	(((rights)->cr_rights[0] ==					\
+	  (((__u64)CAP_RIGHTS_VERSION << 62) | CAP_ALL0)) &&	\
+	 ((rights)->cr_rights[1] == CAP_ALL1))
+
+#define CAPRVER(right)		((int)((right) >> 62))
+#define CAPVER(rights)		CAPRVER((rights)->cr_rights[0])
+#define CAPARSIZE(rights)	(CAPVER(rights) + 2)
+#define CAPIDXBIT(right)	((int)(((right) >> 57) & 0x1F))
+
+/*
+ * Allowed fcntl(2) commands.
+ */
+#define CAP_FCNTL_GETFL	(1 << F_GETFL)
+#define CAP_FCNTL_SETFL	(1 << F_SETFL)
+#define CAP_FCNTL_GETOWN	(1 << F_GETOWN)
+#define CAP_FCNTL_SETOWN	(1 << F_SETOWN)
+#define CAP_FCNTL_ALL		(CAP_FCNTL_GETFL | CAP_FCNTL_SETFL | \
+				 CAP_FCNTL_GETOWN | CAP_FCNTL_SETOWN)
+
+#define CAP_IOCTLS_ALL		SSIZE_MAX
+
+#endif /* _UAPI_LINUX_CAPSICUM_H */
diff --git a/security/Kconfig b/security/Kconfig
index beb86b500adf..006020864612 100644
--- a/security/Kconfig
+++ b/security/Kconfig
@@ -117,6 +117,21 @@ config LSM_MMAP_MIN_ADDR
 	  this low address space will need the permission specific to the
 	  systems running LSM.
 
+config SECURITY_CAPSICUM
+	bool "Capsicum capabilities"
+	default y
+	depends on SECURITY
+	depends on SECURITY_PATH
+	depends on SECCOMP
+	help
+	  Enable the Capsicum capability framework, which implements security
+	  primitives that support fine-grained capabilities on file
+	  descriptors; see Documentation/security/capsicum.txt for more
+	  details.
+
+	  If you are unsure as to whether this is required, answer N.
+
+
 source security/selinux/Kconfig
 source security/smack/Kconfig
 source security/tomoyo/Kconfig
diff --git a/security/Makefile b/security/Makefile
index 05f1c934d74b..c5e1363ae136 100644
--- a/security/Makefile
+++ b/security/Makefile
@@ -14,7 +14,7 @@ obj-y					+= commoncap.o
 obj-$(CONFIG_MMU)			+= min_addr.o
 
 # Object file lists
-obj-$(CONFIG_SECURITY)			+= security.o capability.o
+obj-$(CONFIG_SECURITY)			+= security.o capability.o capsicum-rights.o
 obj-$(CONFIG_SECURITYFS)		+= inode.o
 obj-$(CONFIG_SECURITY_SELINUX)		+= selinux/
 obj-$(CONFIG_SECURITY_SMACK)		+= smack/
diff --git a/security/capsicum-rights.c b/security/capsicum-rights.c
new file mode 100644
index 000000000000..0a5695fa0e61
--- /dev/null
+++ b/security/capsicum-rights.c
@@ -0,0 +1,201 @@
+/*-
+ * Copyright (c) 2013 FreeBSD Foundation
+ * All rights reserved.
+ *
+ * This software was developed by Pawel Jakub Dawidek under sponsorship from
+ * the FreeBSD Foundation.
+ *
+ * Redistribution and use in source and binary forms, with or without
+ * modification, are permitted provided that the following conditions
+ * are met:
+ * 1. Redistributions of source code must retain the above copyright
+ *    notice, this list of conditions and the following disclaimer.
+ * 2. Redistributions in binary form must reproduce the above copyright
+ *    notice, this list of conditions and the following disclaimer in the
+ *    documentation and/or other materials provided with the distribution.
+ *
+ * THIS SOFTWARE IS PROVIDED BY THE AUTHOR AND CONTRIBUTORS ``AS IS'' AND
+ * ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
+ * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
+ * ARE DISCLAIMED.  IN NO EVENT SHALL THE AUTHOR OR CONTRIBUTORS BE LIABLE
+ * FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
+ * DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
+ * OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
+ * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
+ * LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
+ * OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
+ * SUCH DAMAGE.
+ */
+
+#include <stdarg.h>
+#include <linux/capsicum.h>
+#include <linux/slab.h>
+#include <linux/fcntl.h>
+#include <linux/bug.h>
+
+#include "capsicum-rights.h"
+
+#ifdef CONFIG_SECURITY_CAPSICUM
+#define CAPARSIZE_MIN	(CAP_RIGHTS_VERSION_00 + 2)
+#define CAPARSIZE_MAX	(CAP_RIGHTS_VERSION + 2)
+
+/*
+ * -1 indicates invalid index value, otherwise log2(v), ie.:
+ * 0x001 -> 0, 0x002 -> 1, 0x004 -> 2, 0x008 -> 3, 0x010 -> 4, rest -> -1
+ */
+static const int bit2idx[] = {
+	-1, 0, 1, -1, 2, -1, -1, -1, 3, -1, -1, -1, -1, -1, -1, -1,
+	4, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1
+};
+
+static inline int right_to_index(__u64 right)
+{
+	return bit2idx[CAPIDXBIT(right)];
+}
+
+static inline bool has_right(const struct capsicum_rights *rights, u64 right)
+{
+	int idx = right_to_index(right);
+	return (rights->primary.cr_rights[idx] & right) == right;
+}
+
+struct capsicum_rights *
+cap_rights_vset(struct capsicum_rights *rights, va_list ap)
+{
+	u64 right;
+	int i, n;
+
+	n = CAPARSIZE(&rights->primary);
+	BUG_ON(n < CAPARSIZE_MIN || n > CAPARSIZE_MAX);
+
+	while (true) {
+		right = va_arg(ap, u64);
+		if (right == 0)
+			break;
+		BUG_ON(CAPRVER(right) != 0);
+		i = right_to_index(right);
+		BUG_ON(i < 0 || i >= n);
+		BUG_ON(CAPIDXBIT(rights->primary.cr_rights[i]) !=
+		       CAPIDXBIT(right));
+		rights->primary.cr_rights[i] |= right;
+	}
+	return rights;
+}
+EXPORT_SYMBOL(cap_rights_vset);
+
+struct capsicum_rights *
+cap_rights_vinit(struct capsicum_rights *rights, va_list ap)
+{
+	CAP_SET_NONE(&rights->primary);
+	rights->nioctls = 0;
+	rights->ioctls = NULL;
+	rights->fcntls = 0;
+	cap_rights_vset(rights, ap);
+	return rights;
+}
+EXPORT_SYMBOL(cap_rights_vinit);
+
+bool cap_rights_regularize(struct capsicum_rights *rights)
+{
+	bool changed = false;
+	if (!has_right(rights, CAP_FCNTL) && rights->fcntls != 0x00) {
+		changed = true;
+		rights->fcntls = 0x00;
+	}
+	if (!has_right(rights, CAP_IOCTL) && (rights->nioctls != 0)) {
+		changed = true;
+		kfree(rights->ioctls);
+		rights->nioctls = 0;
+		rights->ioctls = NULL;
+	}
+	return changed;
+}
+
+struct capsicum_rights *_cap_rights_init(struct capsicum_rights *rights, ...)
+{
+	va_list ap;
+	va_start(ap, rights);
+	cap_rights_vinit(rights, ap);
+	va_end(ap);
+	return rights;
+}
+EXPORT_SYMBOL(_cap_rights_init);
+
+struct capsicum_rights *_cap_rights_set(struct capsicum_rights *rights, ...)
+{
+	va_list ap;
+	va_start(ap, rights);
+	cap_rights_vset(rights, ap);
+	va_end(ap);
+	return rights;
+}
+EXPORT_SYMBOL(_cap_rights_set);
+
+struct capsicum_rights *cap_rights_set_all(struct capsicum_rights *rights)
+{
+	CAP_SET_ALL(&rights->primary);
+	rights->nioctls = -1;
+	rights->ioctls = NULL;
+	rights->fcntls = CAP_FCNTL_ALL;
+	return rights;
+}
+EXPORT_SYMBOL(cap_rights_set_all);
+
+static bool cap_rights_ioctls_contains(const struct capsicum_rights *big,
+				       const struct capsicum_rights *little)
+{
+	int i, j;
+
+	if (big->nioctls == -1)
+		return true;
+	if (big->nioctls < little->nioctls)
+		return false;
+	for (i = 0; i < little->nioctls; i++) {
+		for (j = 0; j < big->nioctls; j++) {
+			if (little->ioctls[i] == big->ioctls[j])
+				break;
+		}
+		if (j == big->nioctls)
+			return false;
+	}
+	return true;
+}
+
+static bool cap_rights_primary_contains(const struct cap_rights *big,
+					const struct cap_rights *little)
+{
+	unsigned int i, n;
+
+	BUG_ON(CAPVER(big) != CAP_RIGHTS_VERSION_00);
+	BUG_ON(CAPVER(little) != CAP_RIGHTS_VERSION_00);
+
+	n = CAPARSIZE(big);
+	BUG_ON(n < CAPARSIZE_MIN || n > CAPARSIZE_MAX);
+
+	for (i = 0; i < n; i++) {
+		if ((big->cr_rights[i] & little->cr_rights[i]) !=
+		    little->cr_rights[i]) {
+			return false;
+		}
+	}
+	return true;
+}
+
+bool cap_rights_contains(const struct capsicum_rights *big,
+			const struct capsicum_rights *little)
+{
+	return cap_rights_primary_contains(&big->primary,
+					   &little->primary) &&
+	       ((big->fcntls & little->fcntls) == little->fcntls) &&
+	       cap_rights_ioctls_contains(big, little);
+}
+
+bool cap_rights_is_all(const struct capsicum_rights *rights)
+{
+	return CAP_IS_ALL(&rights->primary) &&
+	       rights->fcntls == CAP_FCNTL_ALL &&
+	       rights->nioctls == -1;
+}
+EXPORT_SYMBOL(cap_rights_is_all);
+
+#endif  /* CONFIG_SECURITY_CAPSICUM */
diff --git a/security/capsicum-rights.h b/security/capsicum-rights.h
new file mode 100644
index 000000000000..b7143e3d65b7
--- /dev/null
+++ b/security/capsicum-rights.h
@@ -0,0 +1,10 @@
+#ifndef _CAPSICUM_RIGHTS_H
+#define _CAPSICUM_RIGHTS_H
+
+#ifdef CONFIG_SECURITY_CAPSICUM
+bool cap_rights_regularize(struct capsicum_rights *rights);
+bool cap_rights_contains(const struct capsicum_rights *big,
+			 const struct capsicum_rights *little);
+#endif
+
+#endif /* _CAPSICUM_RIGHTS_H */
-- 
2.0.0.526.g5318336
