Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD0AF45D917;
	Thu,  8 Oct 2026 08:50:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791449452; cv=none; b=TLkA9vmvIDS7Met6GXfimv+SHZSin/rCBbusv0wwCHi7UMTQaoCdKDS7Xo0XApNH5JqHbmEHxlN72QP6Ob12f4rhsrGhpTfuoJiA9pMb/Z9EgBFRn1TTMkB2aMAb1RtUEgZnPku+McL6+0ckFElsCQc9AUE9qM/SOf3wy3gEWCg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791449452; c=relaxed/simple;
	bh=MCiJ2DCf2G3qDI33iJKZiSY9oWKz1ARAQxvkWxxNqL4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jUz5GT8u4ZTaR9+4QcFkwSaSAuqUk58I/9V4YFuifGnoeqxai/uvdC6QQ/JeGYCWafp8Ob15DPQLYnT2vjcX26zFwiLeVDKuGweUPACPAfuOYLx95oKyO89IAY2j6JHRZtY60x1vAXXwL78pbnJ0KL4p/QD0OUfZTChVfnRxd7I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=R3ADswQB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="R3ADswQB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8504B1F00898;
	Thu,  8 Oct 2026 08:50:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791449448;
	bh=K03Do/9CNuOknLkgDDjj32/HbwVkinTQGYgfVC6zuLo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=R3ADswQBfgz5AAxVusJt7cye5IjrTgCk/EDdbOmO3usqEyufY9TXDQlCw8kMPZAWm
	 +Onk5ohIKiWkz2t0SagNAJ/yXnw0nQ42v9lSlmiobRKPpS+JQ3muHP5hJ7O/Tvb+7k
	 W8RCkgYq8oUFHPniS/GSlYby2IuLZi1KK59sh8inWc75D0DKINBCmLw73+TxDujUsL
	 tmf5CKJqqbndX32hdufknuu6vD0qfnaBpmA3wCsRZEfoWGI/LvsNltXBKRF8rLl6yf
	 TyAWM9SDwM1I9gFtHBCbYS7I6bOXHHeNjtf91G6SCUxcejgCgS2PkSVZ/Y1Li2o7bi
	 rXvvX+Tqdfvrg==
From: Sasha Levin <sashal@kernel.org>
To: linux-api@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: Sasha Levin <sashal@kernel.org>,
	linux-doc@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-kbuild@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	workflows@vger.kernel.org,
	tools@kernel.org,
	x86@kernel.org,
	Thomas Gleixner <tglx@kernel.org>,
	"Paul E . McKenney" <paulmck@kernel.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Dmitry Vyukov <dvyukov@google.com>,
	Randy Dunlap <rdunlap@infradead.org>,
	Cyril Hrubis <chrubis@suse.cz>,
	Kees Cook <kees@kernel.org>,
	Jake Edge <jake@lwn.net>,
	David Laight <david.laight.linux@gmail.com>,
	Gabriele Paoloni <gpaoloni@redhat.com>,
	Mauro Carvalho Chehab <mchehab@kernel.org>,
	Christian Brauner <brauner@kernel.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Andrew Morton <akpm@linux-foundation.org>,
	Masahiro Yamada <masahiroy@kernel.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Nathan Chancellor <nathan@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: [PATCH v5 05/11] kernel/api: add API specification for sys_open
Date: Thu,  8 Oct 2026 04:49:45 -0400
Message-ID: <20261008084956.2911790-6-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261008084956.2911790-1-sashal@kernel.org>
References: <20261008084956.2911790-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add KAPI-annotated kerneldoc for the sys_open system call in fs/open.c.

The specification documents parameter constraints (pathname, flags
bitmask, permission mode), 24 error conditions, locking requirements,
side effects, required capabilities, and usage examples.

Assisted-by: LLM
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/open.c | 324 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 324 insertions(+)

diff --git a/fs/open.c b/fs/open.c
index 6b1c14e684a93..92808ab20d52a 100644
--- a/fs/open.c
+++ b/fs/open.c
@@ -1424,6 +1424,330 @@ int do_sys_open(int dfd, const char __user *filename, int flags, umode_t mode)
 }
 
 
+/**
+ * sys_open - Open or create a file
+ * @filename: Pathname of the file to open or create
+ * @flags: File access mode and behavior flags (O_RDONLY, O_WRONLY, O_RDWR, etc.)
+ * @mode: File permission bits for newly created files (only with O_CREAT/O_TMPFILE)
+ *
+ * long-desc: Opens the file named by filename, relative to the current
+ *   working directory if the path is relative. With O_CREAT, the file is
+ *   created if it does not exist. With O_TMPFILE, filename must name an
+ *   existing directory, in which an unnamed file is created. A new file gets
+ *   mode & ~umask as its permission bits.
+ *
+ *   The low two bits of flags (O_ACCMODE) select the access mode: O_RDONLY,
+ *   O_WRONLY or O_RDWR. File creation and file status flags are ORed in.
+ *
+ *   File creation flags: O_CREAT, O_EXCL, O_NOCTTY, O_TRUNC, O_DIRECTORY,
+ *   O_NOFOLLOW, O_CLOEXEC, O_TMPFILE, O_EMPTYPATH. O_EMPTYPATH permits an
+ *   empty filename, which for open() refers to the current working directory.
+ *
+ *   File status flags: O_APPEND, FASYNC, O_DIRECT, O_DSYNC, O_LARGEFILE,
+ *   O_NOATIME, O_NONBLOCK (O_NDELAY), O_PATH, O_SYNC. These become part of the
+ *   file's open file description and can be retrieved with fcntl(F_GETFL). Only
+ *   O_APPEND, O_NONBLOCK, O_DIRECT, O_NOATIME and FASYNC can be changed later
+ *   with fcntl(F_SETFL).
+ *
+ *   On success the lowest-numbered file descriptor not currently open in the
+ *   process is returned.
+ *
+ *   On 64-bit systems, O_LARGEFILE is automatically added to the flags. On 32-bit
+ *   systems, files larger than 2GB require O_LARGEFILE to be explicitly set.
+ *
+ *   open() is equivalent to openat(AT_FDCWD, filename, flags, mode).
+ *
+ * contexts: process, sleepable
+ *
+ * param: filename
+ *   type: path, input
+ *   constraint-type: user_path
+ *   cdesc: Must be a valid null-terminated path string in user memory.
+ *     Maximum path length is PATH_MAX (4096 bytes) including null terminator.
+ *     For relative paths, resolution starts from current working directory.
+ *     The path is followed (symlinks resolved) unless O_NOFOLLOW is specified.
+ *
+ * param: flags
+ *   type: int, input
+ *   constraint-type: mask(O_RDONLY | O_WRONLY | O_RDWR | O_CREAT | O_EXCL | O_NOCTTY |
+ *                         O_TRUNC | O_APPEND | O_NONBLOCK | O_NDELAY | O_DSYNC | O_SYNC |
+ *                         FASYNC | O_DIRECT | O_LARGEFILE | O_DIRECTORY | O_NOFOLLOW |
+ *                         O_NOATIME | O_CLOEXEC | O_PATH | O_TMPFILE | O_EMPTYPATH)
+ *   cdesc: Should be one of O_RDONLY (0), O_WRONLY (1), or O_RDWR (2) as the
+ *     access mode. Additional flags may be ORed. O_CREAT combined with
+ *     O_DIRECTORY or O_TMPFILE, O_TMPFILE without O_DIRECTORY, and O_TMPFILE
+ *     with read-only mode return EINVAL. With O_PATH, open() silently drops
+ *     every other flag except O_DIRECTORY, O_NOFOLLOW, O_CLOEXEC and
+ *     O_EMPTYPATH (only openat2() rejects them with EINVAL). Unknown flags are
+ *     silently ignored for backward compatibility (unlike openat2 which
+ *     rejects them).
+ *
+ * param: mode
+ *   type: uint, input
+ *   cdesc: Only meaningful when O_CREAT or O_TMPFILE is specified in
+ *     flags. Specifies the file mode bits (permissions and setuid/setgid/sticky
+ *     bits) for a newly created file. The effective mode is (mode & ~umask).
+ *     When O_CREAT/O_TMPFILE is not set, mode is ignored. Mode values exceeding
+ *     S_IALLUGO (07777) are masked off.
+ *
+ * return:
+ *   type: int
+ *   check-type: fd
+ *   success: >= 0
+ *   desc: On success, returns a new file descriptor (non-negative integer).
+ *     The returned file descriptor is the lowest-numbered descriptor not
+ *     currently open for the process. On error, returns a negative error code.
+ *
+ * error: EACCES, Permission denied
+ *   desc: The requested access to the file is not allowed, or search permission
+ *     is denied for one of the directories in the path prefix of pathname, or
+ *     the file did not exist yet and write access to the parent directory is
+ *     not allowed, or O_TRUNC is specified but write permission is denied, or
+ *     pathname is a device special file on a nodev mount, or O_CREAT on an
+ *     existing FIFO or regular file in a sticky directory is refused by
+ *     protected_fifos or protected_regular, or a security module denies the
+ *     open.
+ *
+ * error: EAGAIN, Resource temporarily unavailable
+ *   desc: O_NONBLOCK was specified and a conflicting lease is held on the file,
+ *     so the open would have to wait for the lease to break. break_lease()
+ *     returns -EWOULDBLOCK, which has the same value as EAGAIN.
+ *
+ * error: EBUSY, Device or resource busy
+ *   desc: O_EXCL was specified in flags and pathname refers to a block device
+ *     that is in use by the system (e.g., it is mounted).
+ *
+ * error: EDQUOT, Disk quota exceeded
+ *   desc: O_CREAT is specified and the file does not exist, and the user's quota
+ *     of disk blocks or inodes on the filesystem has been exhausted.
+ *
+ * error: EEXIST, File exists
+ *   desc: O_CREAT and O_EXCL were specified in flags, but pathname already exists.
+ *     This error is atomic with respect to file creation - it prevents race
+ *     conditions (TOCTOU) when creating files.
+ *
+ * error: EFAULT, Bad address
+ *   desc: pathname points outside the process's accessible address space.
+ *
+ * error: EINTR, Interrupted system call
+ *   desc: A signal arrived while the open was blocked waiting for the partner
+ *     of a FIFO open (fifo_open), waiting for a conflicting lease to break
+ *     (__break_lease), or inside a driver's open method. The kernel-internal
+ *     -ERESTARTSYS is reported as EINTR unless the handler uses SA_RESTART.
+ *
+ * error: EINVAL, Invalid argument
+ *   desc: Returned for several conditions: (1) Invalid O_* flag combinations
+ *     (O_CREAT with O_DIRECTORY, O_CREAT with O_TMPFILE, O_TMPFILE without
+ *     O_DIRECTORY, O_TMPFILE with read-only access). (2) O_DIRECT requested
+ *     but the filesystem does not support it.
+ *
+ * error: EISDIR, Is a directory
+ *   desc: pathname refers to a directory and the access requested involved
+ *     writing (O_WRONLY, O_RDWR, or O_TRUNC). Also returned when O_CREAT is
+ *     specified and pathname names an existing directory or ends in a slash.
+ *
+ * error: ELOOP, Too many symbolic links
+ *   desc: Too many symbolic links were encountered in resolving pathname, or
+ *     O_NOFOLLOW was specified but pathname refers to a symbolic link. With
+ *     O_PATH and O_NOFOLLOW the symbolic link itself is opened instead.
+ *
+ * error: EMFILE, Too many open files
+ *   desc: The per-process limit on the number of open file descriptors has been
+ *     reached. This limit is RLIMIT_NOFILE (default typically 1024, max set by
+ *     /proc/sys/fs/nr_open).
+ *
+ * error: ENAMETOOLONG, File name too long
+ *   desc: pathname was too long, exceeding PATH_MAX (4096) bytes, or a single
+ *     path component exceeded NAME_MAX (usually 255) bytes.
+ *
+ * error: ENFILE, Too many open files in system
+ *   desc: The system-wide limit on the total number of open files has been
+ *     reached (/proc/sys/fs/file-max). Processes with CAP_SYS_ADMIN can exceed
+ *     this limit.
+ *
+ * error: ENODEV, No such device
+ *   desc: The filesystem or driver open method failed with ENODEV, or the
+ *     file's inode has no file operations assigned. A device special file with
+ *     no registered device fails with ENXIO instead.
+ *
+ * error: ENOENT, No such file or directory
+ *   desc: A directory component in pathname does not exist or is a dangling
+ *     symbolic link, or O_CREAT is not set and the named file does not exist,
+ *     or pathname is an empty string and O_EMPTYPATH is not specified.
+ *
+ * error: ENOMEM, Out of memory
+ *   desc: The kernel could not allocate sufficient memory for the file structure,
+ *     path lookup structures, or the filename buffer.
+ *
+ * error: ENOSPC, No space left on device
+ *   desc: O_CREAT was specified and the file does not exist, and the directory
+ *     or filesystem containing the file has no room for a new file entry.
+ *
+ * error: ENOTDIR, Not a directory
+ *   desc: A component used as a directory in pathname is not actually a directory,
+ *     or O_DIRECTORY was specified and pathname was not a directory.
+ *
+ * error: ENXIO, No such device or address
+ *   desc: O_NONBLOCK | O_WRONLY is set and the named file is a FIFO and no
+ *     process has the FIFO open for reading. Also returned when opening a device
+ *     special file whose device does not exist (chrdev_open, blkdev_open), or
+ *     when opening a socket inode.
+ *
+ * error: EOPNOTSUPP, Operation not supported
+ *   desc: The filesystem containing pathname does not support O_TMPFILE.
+ *
+ * error: EOVERFLOW, Value too large for defined data type
+ *   desc: pathname refers to a regular file that is too large to be opened.
+ *     This occurs on 32-bit systems without O_LARGEFILE when the file size
+ *     exceeds 2GB (2^31 - 1 bytes).
+ *
+ * error: EPERM, Operation not permitted
+ *   desc: O_NOATIME flag was specified but the effective UID of the caller did
+ *     not match the owner of the file and the caller is not privileged, or the
+ *     file is append-only and O_TRUNC was specified or write mode without
+ *     O_APPEND, or the file is immutable, or a seal prevents the operation.
+ *
+ * error: EROFS, Read-only file system
+ *   desc: pathname refers to a file on a read-only filesystem and write access
+ *     was requested.
+ *
+ * error: ETXTBSY, Text file busy
+ *   desc: Write access or O_TRUNC was requested for an executable image that
+ *     is currently being executed, or O_TRUNC was requested on an active swap
+ *     file. A swap file can otherwise be opened for writing.
+ *
+ * lock: files->file_lock
+ *   type: spinlock
+ *   acquired: true
+ *   released: true
+ *   desc: Acquired when allocating a file descriptor slot. Held briefly during
+ *     fd allocation via alloc_fd() and released before the syscall returns.
+ *
+ * lock: inode->i_rwsem (parent directory)
+ *   type: semaphore
+ *   acquired: true
+ *   released: true
+ *   desc: Conditional, taken only when the final component is not resolved by
+ *     the lockless dcache lookup. lookup_open() takes it exclusively with
+ *     inode_lock() when O_CREAT is set and shared with inode_lock_shared()
+ *     otherwise. Slow-path lookup of path components takes it shared. Released
+ *     when the lookup returns. The open path has no killable variant.
+ *
+ * lock: RCU read-side
+ *   type: rcu
+ *   acquired: true
+ *   released: true
+ *   desc: Path lookup uses RCU mode initially for performance. If RCU lookup
+ *     fails (returns -ECHILD), falls back to reference-based lookup.
+ *
+ * signal: Any signal
+ *   direction: receive
+ *   action: return
+ *   condition: When blocked in an interruptible wait
+ *   desc: The syscall may be interrupted while waiting for the partner of a
+ *     FIFO open (fifo_open), for a conflicting lease to break (__break_lease),
+ *     or inside a driver's open method. The wait returns -ERESTARTSYS, which
+ *     is restarted after the handler with SA_RESTART and reported as EINTR
+ *     otherwise.
+ *   errno: -EINTR
+ *   timing: during
+ *   restartable: yes
+ *
+ * side-effect: resource_create | alloc_memory
+ *   target: file descriptor, file structure, dentry cache
+ *   desc: Allocates a new file descriptor in the process's fd table. Allocates
+ *     a struct file from the filp slab cache. May allocate dentries and inodes
+ *     during path lookup. System-wide file count (nr_files) is incremented.
+ *   reversible: yes
+ *
+ * side-effect: filesystem
+ *   target: filesystem, inode
+ *   condition: When O_CREAT is specified and file doesn't exist
+ *   desc: Creates a new file on the filesystem. Creates new inode, allocates
+ *     data blocks as needed, and creates directory entry. Updates parent
+ *     directory mtime and ctime.
+ *   reversible: no
+ *
+ * side-effect: filesystem
+ *   target: file content
+ *   condition: When O_TRUNC is specified for existing file
+ *   desc: Truncates the file to zero length, releasing data blocks. Updates
+ *     file mtime and ctime. May trigger notifications to lease holders.
+ *   reversible: no
+ *
+ * side-effect: modify_state
+ *   target: inode timestamps
+ *   condition: When a symlink is followed, or O_TRUNC or O_CREAT takes effect
+ *   desc: Opening does not update the atime of the opened file. Reads update it
+ *     later, and O_NOATIME only affects those reads. Following a symlink in
+ *     the path may update the symlink's atime, subject to the mount atime
+ *     options. O_TRUNC and file creation update mtime and ctime.
+ *
+ * capability: CAP_DAC_OVERRIDE
+ *   type: bypass_check
+ *   allows: Bypass file read, write, and execute permission checks
+ *   without: Standard DAC (discretionary access control) checks are applied
+ *   condition: Checked when file permission would otherwise deny access
+ *
+ * capability: CAP_DAC_READ_SEARCH
+ *   type: bypass_check
+ *   allows: Bypass read permission on files and search permission on directories
+ *   without: Must have read permission on file or search permission on directory
+ *   condition: Checked during path traversal and file open
+ *
+ * capability: CAP_FOWNER
+ *   type: bypass_check
+ *   allows: Use O_NOATIME on files not owned by caller
+ *   without: O_NOATIME returns EPERM if caller is not file owner
+ *   condition: Checked when O_NOATIME is specified and caller is not owner
+ *
+ * capability: CAP_SYS_ADMIN
+ *   type: increase_limit
+ *   allows: Exceed the system-wide file limit (file-max)
+ *   without: Returns ENFILE when system limit is reached
+ *   condition: Checked in alloc_empty_file() when nr_files >= max_files
+ *
+ * constraint: RLIMIT_NOFILE (per-process fd limit)
+ *   desc: The returned file descriptor must be less than the process's
+ *     RLIMIT_NOFILE limit. Default is typically 1024, maximum is controlled
+ *     by /proc/sys/fs/nr_open (default 1048576). Exceeding returns EMFILE.
+ *   expr: fd < rlimit(RLIMIT_NOFILE)
+ *
+ * constraint: file-max (system-wide limit)
+ *   desc: System-wide limit on open files in /proc/sys/fs/file-max. Processes
+ *     without CAP_SYS_ADMIN receive ENFILE when this limit is reached. The
+ *     limit is computed based on system memory at boot time.
+ *   expr: nr_files < files_stat.max_files || capable(CAP_SYS_ADMIN)
+ *
+ * constraint: PATH_MAX
+ *   desc: Maximum length of pathname including null terminator is PATH_MAX
+ *     (4096 bytes). Individual path components must not exceed NAME_MAX (255).
+ *
+ * examples: fd = open("/etc/passwd", O_RDONLY);  // Read existing file
+ *   fd = open("/tmp/newfile", O_WRONLY | O_CREAT | O_TRUNC, 0644);  // Create/truncate
+ *   fd = open("/tmp/lockfile", O_WRONLY | O_CREAT | O_EXCL, 0600);  // Exclusive create
+ *   fd = open("/dev/null", O_RDWR);  // Open device
+ *   fd = open("/tmp", O_RDONLY | O_DIRECTORY);  // Open directory
+ *   fd = open("/tmp", O_TMPFILE | O_RDWR, 0600);  // Anonymous temp file
+ *
+ * notes: O_RDONLY is defined as 0, so (flags & O_RDONLY) always evaluates to zero.
+ *   Test access mode using (flags & O_ACCMODE) == O_RDONLY.
+ *
+ *   When O_CREAT is specified without O_EXCL, there is a race condition between
+ *   testing for file existence and creating it. Use O_CREAT | O_EXCL for atomic
+ *   exclusive file creation.
+ *
+ *   O_CLOEXEC should be used in multithreaded programs to prevent file descriptor
+ *   leaks to child processes between fork() and execve().
+ *
+ *   O_DIRECT has alignment requirements that vary by filesystem. Use statx()
+ *   with STATX_DIOALIGN (Linux 6.1+) to query requirements. Unaligned I/O may
+ *   fail with EINVAL or fall back to buffered I/O.
+ *
+ *   O_PATH opens a file descriptor that can be used only for certain operations
+ *   (fstat, dup, fcntl, close, fchdir on directories, as dirfd for *at() calls).
+ *   I/O operations will fail with EBADF.
+ */
 SYSCALL_DEFINE3(open, const char __user *, filename, int, flags, umode_t, mode)
 {
 	if (force_o_largefile())
-- 
2.53.0

