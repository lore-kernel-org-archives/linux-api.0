Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 464D747729B;
	Thu,  8 Oct 2026 08:51:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791449466; cv=none; b=WRUzek/eBhKn9ykVPoSesxAKOM2IClmnjf1hwVHiF6Jn1ODGXjbMTxBs/3lIsdCkAnw90RvHO1cMwcrijfrgtdlJKU2P6IdS5rMN6ZS5l21DtWs9QdbtTnXjvLrwHXSa3NJ1qc+qDNToj9hEI55la4m86YXkb6BQevNrCqQDBFk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791449466; c=relaxed/simple;
	bh=VRp0Wa/Zj4xLmGFzS1h1cKEdycevxdDSjoTJnxB9oLo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZHirUzcRfCi5sJ+kcIEtaLhyC3IThaITpS1yKBjMns5ZKdzoQqnFzDIRBTJzzZ4Ja7Ph6rbRiOskOAEEzkO71WJ1cN9+JHvlV6FH40i2Fd/Prz/Lci+MCwTQTWB+kI9cKGiIjo2ogC3treD1m1Wa9i3zrAOSK+p9TX1oygu2zL0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=f6KDdk5x; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="f6KDdk5x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F1611F00893;
	Thu,  8 Oct 2026 08:50:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791449461;
	bh=6O1JqW/catUmtSQrv6PyF+9x5i2Ix9izWc0/iEoo5ic=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=f6KDdk5xpkFCOIZwihR2P2Da8O1UEn86+1FhBE/KhKl4bfSJD5E6eOHKQtgo08Tha
	 4z+LEdKak9MTrxQI1wGTk7APTgZYNSrzztWvpmC/aFokiIRXu9PcU+1jcmIqtINFLh
	 0Ikdih1PibRsRn+l3rWh8J7PDjm/d5JPJEabdteEw0gJg3dswoDXFLWOl7Ji1Lwy7G
	 2/9h838OvitnVxgZoDhzIBD4T8rDG+RYyP8zt4giYADDmWumzPQS+MJcIhMgtcGQ1s
	 JKW9y99lpggNZHdBoHIUL7xuaHnPzT24//RyzAMijsSaCx3f3xg0UJMJtYj0BSr/Up
	 +eDhQ0YDDGpjg==
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
Subject: [PATCH v5 07/11] kernel/api: add API specification for sys_read
Date: Thu,  8 Oct 2026 04:49:47 -0400
Message-ID: <20261008084956.2911790-8-sashal@kernel.org>
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

Add KAPI-annotated kerneldoc for the sys_read system call in
fs/read_write.c.

The specification documents parameter constraints (fd, user buffer,
count), error conditions, locking requirements, signal handling
behavior, and short read semantics.

Assisted-by: LLM
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/read_write.c | 297 ++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 297 insertions(+)

diff --git a/fs/read_write.c b/fs/read_write.c
index e8c14e2760b20..b89c688a41992 100644
--- a/fs/read_write.c
+++ b/fs/read_write.c
@@ -720,6 +720,303 @@ ssize_t ksys_read(unsigned int fd, char __user *buf, size_t count)
 	return ret;
 }
 
+/**
+ * sys_read - Read data from a file descriptor
+ * @fd: File descriptor to read from
+ * @buf: User-space buffer to read data into
+ * @count: Maximum number of bytes to read
+ *
+ * long-desc: Reads at most count bytes from fd into the user buffer buf. For
+ *   seekable files (regular files, block devices), the read begins at the
+ *   current file offset, and the file offset is advanced by the number of
+ *   bytes read. For stream files (FMODE_STREAM, such as pipes, FIFOs, and
+ *   sockets), the file offset is not used. Other files, including many
+ *   character devices, keep a file offset although a driver may ignore it.
+ *
+ *   If count is zero, the usual checks still run and the file's read method is
+ *   still called. Common implementations (regular files, pipes, sockets)
+ *   return zero without transferring data.
+ *
+ *   On success the number of bytes read is returned; zero means end of file
+ *   for regular files. A read can return fewer bytes than requested, for
+ *   example near end of file, on a pipe, socket or terminal with less data
+ *   pending, or when a signal arrives after some data was copied.
+ *
+ *   On Linux, read() transfers at most MAX_RW_COUNT (INT_MAX & PAGE_MASK,
+ *   0x7ffff000 with 4KB pages, just under 2GB) bytes per call, regardless of
+ *   whether the filesystem would allow more. This is to avoid issues with
+ *   signed arithmetic overflow on 32-bit systems.
+ *
+ *   POSIX allows reads that are interrupted after reading some data to either
+ *   return -1 (with errno set to EINTR) or return the number of bytes already
+ *   read. Linux follows the latter behavior: if data has been read before a
+ *   signal arrives, the call returns the bytes read rather than failing.
+ *
+ * contexts: process, sleepable
+ *
+ * param: fd
+ *   type: fd, input
+ *   constraint-type: range(0, INT_MAX)
+ *   cdesc: Must be a valid, open file descriptor with read permission.
+ *     The file must have been opened with O_RDONLY or O_RDWR. Special values
+ *     like AT_FDCWD are not valid. File descriptors for directories return
+ *     EISDIR. Standard file descriptors 0 (stdin), 1 (stdout), 2 (stderr) are
+ *     valid if open and readable.
+ *
+ * param: buf
+ *   type: user_ptr, output
+ *   constraint-type: buffer(2)
+ *   cdesc: Must point to a writable user-space region of at least count bytes.
+ *     The range is checked via access_ok() and a range outside user space
+ *     fails with EFAULT. NULL is not rejected by that check. With a count of 0
+ *     the call returns 0 in common cases. With a count above 0 the copy fails
+ *     with EFAULT, or the call returns a short count if some data was copied
+ *     first. The buffer may be partially written if an error occurs mid-read.
+ *     O_DIRECT reads may require block-size alignment (see STATX_DIOALIGN).
+ *
+ * param: count
+ *   type: uint, input
+ *   cdesc: Maximum number of bytes to read. The range buf to buf + count must
+ *     lie within user space or access_ok() fails with EFAULT, which includes
+ *     counts that do not fit in ssize_t on 64-bit kernels. A count of 0 passes
+ *     the same checks and the file's read method is still called, typically
+ *     returning 0 without transferring data. After access_ok() and
+ *     rw_verify_area() succeed, counts above MAX_RW_COUNT (INT_MAX &
+ *     PAGE_MASK, 0x7ffff000 with 4KB pages) are clamped to MAX_RW_COUNT.
+ *
+ * return:
+ *   type: int
+ *   check-type: range
+ *   success: >= 0
+ *   desc: On success, returns the number of bytes read (non-negative). Zero
+ *     indicates end-of-file (EOF) for regular files, or no data available
+ *     from a device that does not block. The return value may be less than
+ *     count if fewer bytes were available (short read). Partial reads are
+ *     not errors. On error, returns a negative error code.
+ *
+ * error: EBADF, Bad file descriptor
+ *   desc: fd is not a valid file descriptor, or fd was not opened for reading.
+ *     This includes file descriptors opened with O_WRONLY, O_PATH, or file
+ *     descriptors that have been closed. Also returned if the file structure
+ *     does not have FMODE_READ set.
+ *
+ * error: EFAULT, Bad address
+ *   desc: buf points outside the accessible address space. The buffer address
+ *     failed access_ok() validation. Can also occur if a fault happens during
+ *     copy_to_user() when transferring data to user space after the read
+ *     completes in kernel space.
+ *
+ * error: EINVAL, Invalid argument
+ *   desc: Returned in several cases: (1) The file has no read or read_iter
+ *     method (FMODE_CAN_READ is not set). (2) The file was opened with
+ *     O_DIRECT and the buffer alignment, offset, or count does not meet the
+ *     filesystem's alignment requirements. (3) For timerfd file descriptors,
+ *     the buffer is smaller than 8 bytes. (4) rw_verify_area() rejects a
+ *     negative file position, or a position plus count that overflows, on a
+ *     file without FOP_UNSIGNED_OFFSET. (5) The count, cast to ssize_t, is
+ *     negative (32-bit kernels only).
+ *
+ * error: EISDIR, Is a directory
+ *   desc: fd refers to a directory. Directories cannot be read using read();
+ *     use getdents64() instead. This error is returned by the generic_read_dir()
+ *     handler installed for directory file operations.
+ *
+ * error: EAGAIN, Resource temporarily unavailable
+ *   desc: fd refers to a file (pipe, socket, device) that is marked non-blocking
+ *     (O_NONBLOCK) and the read would block. Equivalent to EWOULDBLOCK. The
+ *     application should retry the read later or use select/poll/epoll.
+ *
+ * error: EINTR, Interrupted system call
+ *   desc: The call was interrupted by a signal before any data was read. This
+ *     only occurs if no data has been transferred; if some data was read before
+ *     the signal, the call returns the number of bytes read. The caller should
+ *     typically restart the read.
+ *
+ * error: EIO, Input/output error
+ *   desc: A low-level I/O error occurred. For regular files, this typically
+ *     indicates a hardware error on the storage device, a filesystem error,
+ *     or a network filesystem timeout. For terminals, it is returned when a
+ *     background process group reads its controlling terminal and SIGTTIN is
+ *     ignored or blocked, or the process group is orphaned.
+ *
+ * error: EOVERFLOW, Value too large for defined data type
+ *   desc: Returned by rw_verify_area() only for files with FOP_UNSIGNED_OFFSET
+ *     (for example /proc/pid/mem) when the file position is negative, meaning
+ *     above LLONG_MAX, and count is at least -pos so that the read would wrap
+ *     past the end of the 64-bit offset space. Files without
+ *     FOP_UNSIGNED_OFFSET get EINVAL for a negative position or a position
+ *     plus count that overflows.
+ *
+ * error: ENOBUFS, No buffer space available
+ *   desc: Returned when reading from pipe-based watch queues (CONFIG_WATCH_QUEUE)
+ *     when the buffer is too small to hold a complete notification, or when
+ *     reading packets from pipes with PIPE_BUF_FLAG_WHOLE set.
+ *
+ * error: ERESTARTSYS, Restart system call (internal)
+ *   desc: Internal error code indicating the syscall should be restarted. This
+ *     is typically translated to EINTR if SA_RESTART is not set on the signal
+ *     handler, or the syscall is transparently restarted if SA_RESTART is set.
+ *     User space should not see this error code directly.
+ *
+ * error: EACCES, Permission denied
+ *   desc: The security subsystem (LSM such as SELinux or AppArmor) denied
+ *     the read operation via security_file_permission(). This can occur even
+ *     if the file was successfully opened, as LSM policies may enforce checks
+ *     on each operation.
+ *
+ * error: EPERM, Operation not permitted
+ *   desc: Returned by fanotify permission events (CONFIG_FANOTIFY_ACCESS_PERMISSIONS)
+ *     when a user-space fanotify listener denies the read operation via
+ *     fsnotify_file_area_perm().
+ *
+ * error: ENODATA, No data available
+ *   desc: Returned when a filesystem built on netfs (for example AFS or Ceph)
+ *     ends a read subrequest short without making progress.
+ *
+ * error: EOPNOTSUPP, Operation not supported
+ *   desc: Returned by the read method of the file, not by the generic VFS
+ *     path. For example, a socket whose protocol has no receive method
+ *     (sock_no_recvmsg) fails with EOPNOTSUPP. A file with no read method at
+ *     all fails with EINVAL instead.
+ *
+ * lock: file->f_pos_lock
+ *   type: mutex
+ *   acquired: true
+ *   released: true
+ *   desc: For regular files that require atomic position updates (FMODE_ATOMIC_POS),
+ *     the f_pos_lock mutex is acquired by fdget_pos() at syscall entry and released
+ *     by fdput_pos() at syscall exit. This serializes concurrent reads that share
+ *     the same file description. Not acquired for files opened with FMODE_STREAM
+ *     (pipes, sockets) or when the file is not shared.
+ *
+ * lock: Filesystem-specific locks
+ *   type: custom
+ *   acquired: true
+ *   released: true
+ *   desc: The filesystem's read_iter or read method may acquire additional locks.
+ *     For regular files, this typically includes the inode's i_rwsem for certain
+ *     operations. For pipes, the pipe->mutex is acquired. For sockets, socket
+ *     lock is acquired. These are internal to the file operation and released
+ *     before return.
+ *
+ * lock: RCU read-side
+ *   type: rcu
+ *   acquired: true
+ *   released: true
+ *   desc: Taken only when the files_struct is shared with other threads, in
+ *     which case the fd lookup in fdget() uses RCU and takes a file reference.
+ *     A private table needs no RCU. The RCU read lock is acquired and released
+ *     internally by the fd lookup path, not held across the entire syscall.
+ *     fdput() releases the file reference count, not the RCU lock.
+ *
+ * signal: Any signal
+ *   direction: receive
+ *   action: return
+ *   condition: When blocked waiting for data on interruptible operations
+ *   desc: The syscall may be interrupted by signals while waiting for data to
+ *     become available (pipes, sockets, terminals). If interrupted before any
+ *     data is read, returns -EINTR or -ERESTARTSYS. If data has already been
+ *     read, returns the number of bytes read.
+ *   errno: -EINTR
+ *   timing: during
+ *   restartable: yes
+ *
+ * side-effect: file_position
+ *   target: file->f_pos
+ *   condition: For seekable files when read succeeds (returns > 0)
+ *   desc: The file offset (f_pos) is advanced by the number of bytes read.
+ *     For stream files (FMODE_STREAM such as pipes and sockets), the offset
+ *     is not used or modified. The offset update is protected by f_pos_lock
+ *     when the file is shared between threads/processes.
+ *   reversible: no
+ *
+ * side-effect: modify_state
+ *   target: inode access time (atime)
+ *   condition: When the read_iter implementation calls file_accessed() and
+ *     O_NOATIME is not set
+ *   desc: The filesystem's read_iter implementation updates atime via
+ *     file_accessed() and touch_atime(). Buffered reads (filemap_read) do this
+ *     after the data loop, including at EOF and after errors, but not for a
+ *     count of 0. O_DIRECT reads (generic_file_read_iter) do it before the
+ *     I/O. The update may be suppressed by mount options (noatime, relatime),
+ *     the O_NOATIME flag, or if the filesystem does not support atime.
+ *     Relatime updates atime only if it is older than mtime or ctime, or more
+ *     than a day old.
+ *   reversible: no
+ *
+ * side-effect: modify_state
+ *   target: task I/O accounting
+ *   condition: When CONFIG_TASK_XACCT is enabled and the read method is invoked
+ *   desc: Updates the current task's I/O accounting statistics. The rchar field
+ *     (read characters) is incremented by bytes read via add_rchar() only on
+ *     successful reads (ret > 0). The syscr field (syscall read count) is
+ *     incremented via inc_syscr() once the read method has been invoked, even
+ *     if it fails, but not when the FMODE_READ, FMODE_CAN_READ, access_ok() or
+ *     rw_verify_area() checks fail. These statistics are visible in
+ *     /proc/[pid]/io.
+ *   reversible: no
+ *
+ * side-effect: modify_state
+ *   target: fsnotify events
+ *   condition: When read returns > 0
+ *   desc: Generates an FS_ACCESS fsnotify event via fsnotify_access() allowing
+ *     inotify, fanotify, and dnotify watchers to be notified of the read. This
+ *     occurs after data transfer completes successfully.
+ *   reversible: no
+ *
+ * constraint: MAX_RW_COUNT
+ *   desc: After the access_ok() and rw_verify_area() checks pass, the count
+ *     parameter is silently clamped to MAX_RW_COUNT (INT_MAX & PAGE_MASK, just
+ *     under 2GB) to prevent integer overflow in internal calculations. This is
+ *     transparent to the caller. The syscall succeeds but reads at most
+ *     MAX_RW_COUNT bytes.
+ *   expr: actual_count = min(count, MAX_RW_COUNT)
+ *
+ * constraint: File must be open for reading
+ *   desc: The file descriptor must have been opened with O_RDONLY or O_RDWR.
+ *     Files opened with O_WRONLY or O_PATH lack FMODE_READ and return EBADF.
+ *     Files that lack FMODE_CAN_READ because they have no read or read_iter
+ *     method return EINVAL.
+ *   expr: (file->f_mode & FMODE_READ) && (file->f_mode & FMODE_CAN_READ)
+ *
+ * examples: n = read(fd, buf, sizeof(buf));  // Basic read
+ *   n = read(STDIN_FILENO, buf, 1024);  // Read from stdin
+ *   while ((n = read(fd, buf, 4096)) > 0) { process(buf, n); }  // Read loop
+ *   if (read(fd, buf, count) == 0) { handle_eof(); }  // Check for EOF
+ *
+ * notes: The behavior of read() varies significantly depending on the type of
+ *   file descriptor:
+ *
+ *   - Regular files: Reads from current position, advances position, returns 0
+ *     at EOF. Short reads are rare but possible near EOF or on signal.
+ *
+ *   - Pipes and FIFOs: Blocking by default. Returns available data (up to count)
+ *     or blocks until data is available. Returns 0 when all writers have closed.
+ *     O_NONBLOCK returns EAGAIN when empty instead of blocking.
+ *
+ *   - Sockets: Similar to pipes. Specific behavior depends on socket type and
+ *     protocol. MSG_* flags can be specified via recv() for more control.
+ *
+ *   - Terminals: Line-buffered in canonical mode; read returns when newline is
+ *     entered or buffer is full. Raw mode returns immediately when data available.
+ *     Special handling for signals (SIGINT on Ctrl+C, etc.).
+ *
+ *   - Device special files: Behavior is device-specific. Some devices support
+ *     seeking, others do not. Read size may be constrained by device.
+ *
+ *   Race condition: Concurrent reads from the same file description (not just
+ *   file descriptor) can race on the file position. Linux 3.14+ provides atomic
+ *   position updates for regular files via f_pos_lock, but applications should
+ *   use pread() for concurrent positioned reads.
+ *
+ *   O_DIRECT reads bypass the page cache and typically require aligned buffers
+ *   and positions. Alignment requirements are filesystem-specific; use statx()
+ *   with STATX_DIOALIGN (Linux 6.1+) to query. Unaligned O_DIRECT reads fail
+ *   with EINVAL on most filesystems.
+ *
+ *   For splice(2)-like zero-copy reads, consider using splice(), sendfile(),
+ *   or copy_file_range() instead of read() + write().
+ */
 SYSCALL_DEFINE3(read, unsigned int, fd, char __user *, buf, size_t, count)
 {
 	return ksys_read(fd, buf, count);
-- 
2.53.0

