From: Josh Triplett <josh@joshtriplett.org>
Subject: [PATCH] clone4.2: New manpage documenting clone4(2)
Date: Thu, 12 Mar 2015 18:41:16 -0700
Message-ID: <fda076fb945ac8326acb78840ac6bd50b0cfb993.1426180226.git.josh@joshtriplett.org>
References: <cover.1426180120.git.josh@joshtriplett.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <cover.1426180120.git.josh@joshtriplett.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Al Viro <viro@zeniv.linux.org.uk>, Andrew Morton <akpm@linux-foundation.org>, Andy Lutomirski <luto@amacapital.net>, Ingo Molnar <mingo@redhat.com>, Kees Cook <keescook@chromium.org>, Oleg Nesterov <oleg@redhat.com>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, "H. Peter Anvin" <hpa@zytor.com>, Rik van Riel <riel@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, Thiago Macieira <thiago.macieira@intel.com>, Michael Kerrisk <mtk.manpages@gmail.com>, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, linux-man@vger.kernel.org, linux-fsdevel@vger.kernel.org, x86@kernel.org
List-Id: linux-api@vger.kernel.org

Also includes new cross-reference from clone.2.

Signed-off-by: Josh Triplett <josh@joshtriplett.org>
Signed-off-by: Thiago Macieira <thiago.macieira@intel.com>
---
 man2/clone.2  |   1 +
 man2/clone4.2 | 332 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 333 insertions(+)
 create mode 100644 man2/clone4.2

diff --git a/man2/clone.2 b/man2/clone.2
index 752c01e..7013885 100644
--- a/man2/clone.2
+++ b/man2/clone.2
@@ -1209,6 +1209,7 @@ main(int argc, char *argv[])
 }
 .fi
 .SH SEE ALSO
+.BR clone4 (2),
 .BR fork (2),
 .BR futex (2),
 .BR getpid (2),
diff --git a/man2/clone4.2 b/man2/clone4.2
new file mode 100644
index 0000000..c2ce188
--- /dev/null
+++ b/man2/clone4.2
@@ -0,0 +1,332 @@
+.\" Based on clone.2:
+.\" Copyright (c) 1992 Drew Eckhardt <drew@cs.colorado.edu>, March 28, 1992
+.\" and Copyright (c) Michael Kerrisk, 2001, 2002, 2005, 2013
+.\"
+.\" %%%LICENSE_START(GPL_NOVERSION_ONELINE)
+.\" May be distributed under the GNU General Public License.
+.\" %%%LICENSE_END
+.TH CLONE4 2 2015-03-01 "Linux" "Linux Programmer's Manual"
+.SH NAME
+clone4 \- create a child process
+.SH SYNOPSIS
+.nf
+/* Prototype for the glibc wrapper function */
+
+.B #define _GNU_SOURCE
+.B #include <sched.h>
+
+.BI "int clone4(uint64_t " flags ,
+.BI "           size_t " args_size ,
+.BI "           struct clone4_args *" args ,
+.BI "           int (*" "fn" ")(void *), void *" arg );
+
+/* Prototype for the raw system call */
+
+.BI "int clone4(unsigned " flags_high ", unsigned " flags_low ,
+.BI "           unsigned long " args_size ,
+.BI "           struct clone4_args *" args );
+
+struct clone4_args {
+    pid_t *ptid;
+    pid_t *ctid;
+    unsigned long stack_start;
+    unsigned long stack_size;
+    unsigned long tls;
+};
+
+.SH DESCRIPTION
+.BR clone4 ()
+creates a new process, similar to
+.BR clone (2)
+and
+.BR fork (2).
+.BR clone4 ()
+supports additional flags that
+.BR clone (2)
+does not, and accepts arguments via an extensible structure.
+
+.I args
+points to a
+.I clone4_args
+structure, and
+.I args_size
+must contain the size of that structure, as understood by the caller.  If the
+caller passes a shorter structure than the kernel expects, the remaining fields
+will default to 0.  If the caller passes a larger structure than the kernel
+expects (such as one from a newer kernel),
+.BR clone4 ()
+will return
+.BR EINVAL .
+The
+.I clone4_args
+structure may gain additional fields at the end in the future, and callers must
+only pass a size that encompasses the number of fields they understand.  If the
+caller passes 0 for
+.IR args_size ,
+.I args
+is ignored and may be NULL.
+
+In the
+.I clone4_args
+structure,
+.IR ptid ,
+.IR ctid ,
+.IR stack_start ,
+.IR stack_size ,
+and
+.I tls
+have the same semantics as they do with
+.BR clone (2)
+and
+.BR clone2 (2).
+
+In the glibc wrapper,
+.I fn
+and
+.I arg
+have the same semantics as they do with
+.BR clone (2).
+As with
+.BR clone (2),
+the underlying system call works more like
+.BR fork (2),
+returning 0 in the child process; the glibc wrapper simplifies thread execution
+by calling
+.IR fn ( arg )
+and exiting the child when that function exits.
+
+The 64-bit
+.I flags
+argument (split into the 32-bit
+.I flags_high
+and
+.I flags_low
+arguments in the kernel interface)
+accepts all the same flags as
+.BR clone (2),
+with the exception of the obsolete
+.BR CLONE_PID ,
+.BR CLONE_DETACHED ,
+and
+.BR CLONE_STOPPED .
+In addition,
+.I flags
+accepts the following flags:
+
+.TP
+.B CLONE_FD
+Instead of returning a process ID,
+.BR clone4 ()
+with the
+.B CLONE_FD
+flag returns a file descriptor associated with the new process.
+When the new process exits, the kernel will not send a signal to the parent
+process, and will not keep the new process around as a "zombie" process until a
+call to
+.BR waitpid (2)
+or similar.  Instead, the file descriptor will become available for reading,
+and the new process will be immediately reaped.
+
+Unlike using
+.BR signalfd (2)
+for the
+.B SIGCHLD
+signal,
+the file descriptor returned by
+.BR clone4 ()
+with the
+.B CLONE_FD
+flag works even with
+.B SIGCHLD
+unblocked in one or more threads of the parent process, and allows the process
+to have different handlers for different child processes, such as those created
+by a library, without introducing race conditions around process-wide signal
+handling.
+
+.BR clone4 ()
+will never return a file descriptor in the range 0-2 to the caller, to avoid
+ambiguity with the return of 0 in the child process.  Only the calling process
+will have the new file descriptor open; the child process will not.
+
+Since the kernel does not send a termination signal when a child process
+created with
+.B CLONE_FD
+exits, the low byte of flags does not contain a signal number.  Instead, the
+low byte of flags can contain the following additional flags for use with
+.BR CLONE_FD :
+
+.RS
+.TP
+.B CLONEFD_CLOEXEC
+Set the
+.B O_CLOEXEC
+flag on the new open file descriptor.
+See the description of the
+.B O_CLOEXEC
+flag in
+.BR open (2)
+for reasons why this may be useful.
+
+.TP
+.B CLONEFD_NONBLOCK
+Set the
+.B O_NONBLOCK
+flag on the new open file descriptor.
+Using this flag saves extra calls to
+.BR fcntl (2)
+to achieve the same result.
+.RE
+
+.IP
+.BR clone4 ()
+with the
+.B CLONE_FD
+flag returns a file descriptor that supports the following operations:
+.RS
+.TP
+.BR read "(2) (and similar)"
+When the new process exits, reading from the file descriptor produces
+a single
+.I clonefd_info
+structure:
+.nf
+
+struct clonefd_info {
+    uint32_t code;   /* Signal code */
+    uint32_t status; /* Exit status or signal */
+    uint64_t utime;  /* User CPU time */
+    uint64_t stime;  /* System CPU time */
+};
+
+.fi
+.IP
+If the new process has not yet exited,
+.BR read (2)
+either blocks until it does,
+or fails with the error
+.B EAGAIN
+if the file descriptor has been made nonblocking.
+.IP
+Future kernels may extend
+.I clonefd_info
+by appending additional fields to the end.  Callers should read as many bytes
+as they understand; unread data will be discarded, and subsequent reads after
+the first will return 0 to indicate end-of-file.  Callers requesting more bytes
+than the kernel provides (such as callers expecting a newer
+.I clonefd_info
+structure) will receive a shorter structure from older kernels.
+.TP
+.BR poll "(2), " select "(2), " epoll "(7) (and similar)"
+The file descriptor is readable
+(the
+.BR select (2)
+.I readfds
+argument; the
+.BR poll (2)
+.B POLLIN
+flag)
+if the new process has exited.
+.TP
+.BR close (2)
+When the file descriptor is no longer required it should be closed.  If no
+process has a file descriptor open for the new process, no process will receive
+any notification when the new process exits.  The new process will still be
+immediately reaped.
+.RE
+
+.SS C library/kernel ABI differences
+As with
+.BR clone (2),
+the raw
+.BR clone4 ()
+system call corresponds more closely to
+.BR fork (2)
+in that execution in the child continues from the point of the call.
+
+Unlike
+.BR clone (2),
+the raw system call interface for
+.BR clone4 ()
+accepts arguments in the same order on all architectures.
+
+The raw system call accepts
+.I flags
+as two 32-bit arguments,
+.I flags_high
+and
+.IR flags_low ,
+to simplify portability across 32-bit and 64-bit architectures and calling
+conventions.  The glibc wrapper accepts
+.I flags
+as a single 64-bit argument for convenience.
+
+.SH RETURN VALUE
+For the glibc wrapper, on success,
+.BR clone4 ()
+returns the file descriptor (with
+.BR CLONE_FD )
+or new process ID
+(without
+.BR CLONE_FD ),
+and the child process begins running at the specified function.
+
+For the raw syscall, on success,
+.BR clone4 ()
+returns the file descriptor or new process ID to the calling process, and
+returns 0 in the new child process.
+
+On failure,
+.BR clone4 ()
+returns \-1 and sets
+.I errno
+accordingly.
+
+.SH ERRORS
+.BR clone4 ()
+can return any error from
+.BR clone (2),
+as well as the following additional errors:
+.TP
+.B EINVAL
+.I flags
+contained an unknown flag.
+.TP
+.B EINVAL
+.I flags
+included
+.BR CLONE_FD,
+but the kernel configuration does not have the
+.B CONFIG_CLONEFD
+option enabled.
+.TP
+.B EMFILE
+.I flags
+included
+.BR CLONE_FD,
+but the new file descriptor would exceed the process limit on open file descriptors.
+.TP
+.B ENFILE
+.I flags
+included
+.BR CLONE_FD,
+but the new file descriptor would exceed the system-wide limit on open file descriptors.
+.TP
+.B ENODEV
+.I flags
+included
+.BR CLONE_FD,
+but
+.BR clone4 ()
+could not mount the (internal) anonymous inode device.
+
+.SH CONFORMING TO
+.BR clone4 ()
+is Linux-specific and should not be used in programs intended to be portable.
+
+.SH SEE ALSO
+.BR clone (2),
+.BR epoll (7),
+.BR poll (2),
+.BR pthreads (7),
+.BR read (2),
+.BR select (2)
-- 
2.1.4
