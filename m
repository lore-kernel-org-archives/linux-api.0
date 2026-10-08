Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBC183DB63F;
	Thu,  8 Oct 2026 08:51:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791449471; cv=none; b=q/p5U7V3kWHUcWd7MeVgjJm7A3MH6gGwioTSkshbefiDQYeLvZOMtyPvXwQkbTcVRJENZtBbJU+uvA6qKf3kUlLIWATNJebUDPAfAVq6LDLQrfOVbw45RFGronAcpMwb47TWW1xMdY94jJkab556kofi0xP1mPxZ07IspobVKX8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791449471; c=relaxed/simple;
	bh=1MsaOP9o2DmTcRq3Qk3GFcNUANPbX0qWJFg4FaF8LwA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QnWxTYtXcOV6oQOGsF8wEaF1NmQ0nFe0ijYAc2URA35eoCAC+ltffTw+VIOZllZh+U0Euz940MKOjRTyM8gz2xyZkxqzXWfrJMnxcOQY1LIVLmHYMNGCV+HpmbBLtJJRx7chHqTyTKlYXuWBoPqK+FsJmnHRjwXyHy8M5TY/ahY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aAMjmLAF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aAMjmLAF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FA951F00898;
	Thu,  8 Oct 2026 08:51:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791449468;
	bh=jt+FinmtMMG6zeqcO5Z2pIEr/6VSJzwzhm4lqWZDhIw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aAMjmLAFu87xL2qIjXjRroIPheYdkEPzkdQcAajd//4xZC6RNlafn7LfVTx4owRAS
	 M6CaOCv5heL5wvtzPASPqJfqIS8ZUX5B5gEfY4ZVfTytuPuL5EhYhozt7p6A8tSep+
	 BkxnOyJfZhgtUd1/7i0d0w8F/bv/DkCuRDv9GHutA3+kaG5nGKoQsjrV0ZjzYZCfJ5
	 dCdXrfjh1KHgdcS5nMHe74hzoqZPMYTSqUafmbWHumkYmyb3lOw4Fli1OukeHRVexO
	 4dF2zxcvsZIzlE7cSvWZEfZ6+oD8oB34njInqspJwEdWr18e/vFCfr0l+85NzW/6MD
	 vAhkrK5E7dOCA==
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
Subject: [PATCH v5 08/11] kernel/api: add API specification for sys_write
Date: Thu,  8 Oct 2026 04:49:48 -0400
Message-ID: <20261008084956.2911790-9-sashal@kernel.org>
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

Add KAPI-annotated kerneldoc for the sys_write system call in
fs/read_write.c.

The specification documents parameter constraints (fd, user buffer,
count), error conditions, locking requirements, signal handling
behavior, and short write semantics.

Assisted-by: LLM
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/read_write.c | 413 ++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 413 insertions(+)

diff --git a/fs/read_write.c b/fs/read_write.c
index b89c688a41992..a9c07c21f5888 100644
--- a/fs/read_write.c
+++ b/fs/read_write.c
@@ -1041,6 +1041,419 @@ ssize_t ksys_write(unsigned int fd, const char __user *buf, size_t count)
 	return ret;
 }
 
+/**
+ * sys_write - Write data to a file descriptor
+ * @fd: File descriptor to write to
+ * @buf: User-space buffer containing data to write
+ * @count: Maximum number of bytes to write
+ *
+ * long-desc: Writes at most count bytes from the user buffer buf to fd. For
+ *   seekable files (regular files, block devices), the write begins at the
+ *   current file offset, and the file offset is advanced by the number of
+ *   bytes written. If the file was opened with O_APPEND, the file offset is
+ *   first set to the end of the file before writing. For stream files
+ *   (FMODE_STREAM, such as pipes, FIFOs, and sockets), the file offset is not
+ *   used and writing occurs at the position defined by the device. Other
+ *   files, including many character devices, keep a file offset although a
+ *   driver may ignore it.
+ *
+ *   Fewer than count bytes may be written, for example when the filesystem
+ *   runs out of space, the write reaches RLIMIT_FSIZE, or a signal arrives
+ *   after some data was written. The caller writes the rest with another
+ *   write() call.
+ *
+ *   On Linux, write() transfers at most MAX_RW_COUNT (INT_MAX & PAGE_MASK,
+ *   0x7ffff000 with 4KB pages, just under 2GB) bytes per call, regardless of
+ *   whether the file or filesystem would allow more. This prevents signed
+ *   arithmetic overflow.
+ *
+ *   For regular files, a successful write() does not guarantee that data has been
+ *   committed to disk. Use fsync(2) or fdatasync(2) if durability is required.
+ *   For O_SYNC or O_DSYNC files, the kernel automatically syncs data on write.
+ *
+ *   POSIX permits writes that are interrupted after partial writes to either
+ *   return -1 with errno=EINTR, or to return the count of bytes already written.
+ *   Linux implements the latter behavior: if some data has been written before
+ *   a signal arrives, write() returns the number of bytes written rather than
+ *   failing with EINTR.
+ *
+ * contexts: process, sleepable
+ *
+ * param: fd
+ *   type: fd, input
+ *   constraint-type: range(0, INT_MAX)
+ *   cdesc: Must be a valid, open file descriptor with write permission.
+ *     The file must have been opened with O_WRONLY or O_RDWR. File descriptors
+ *     opened with O_RDONLY, O_PATH, or that have been closed return EBADF.
+ *     Standard file descriptors 0 (stdin), 1 (stdout), 2 (stderr) are valid if
+ *     open and writable. AT_FDCWD and other special values are not valid.
+ *
+ * param: buf
+ *   type: user_ptr, input
+ *   constraint-type: buffer(2)
+ *   cdesc: Must point to a readable user-space region of at least count bytes.
+ *     The range is checked via access_ok() and a range outside user space
+ *     fails with EFAULT. NULL is not rejected by that check. With a count of 0
+ *     the call returns 0 in common cases. With a count above 0 the copy from
+ *     user space fails with EFAULT, or the call returns a short count if part
+ *     of the buffer was copied first. O_DIRECT writes may require block-size
+ *     alignment (see STATX_DIOALIGN).
+ *
+ * param: count
+ *   type: uint, input
+ *   cdesc: Maximum number of bytes to write. The range buf to buf + count must
+ *     lie within user space or access_ok() fails with EFAULT, which includes
+ *     counts that do not fit in ssize_t on 64-bit kernels. On 32-bit kernels
+ *     such a count reaches rw_verify_area() and fails with EINVAL. A count of
+ *     0 is passed to the file's write method, which typically returns 0 but
+ *     may trigger driver-specific side effects. After the checks pass, counts
+ *     above MAX_RW_COUNT (INT_MAX & PAGE_MASK, 0x7ffff000 with 4KB pages) are
+ *     clamped.
+ *
+ * return:
+ *   type: int
+ *   check-type: range
+ *   success: >= 0
+ *   desc: On success, returns the number of bytes written (non-negative). Zero
+ *     indicates that nothing was written (count was 0, or a device-specific
+ *     write method accepted no data). Non-blocking writes that cannot proceed
+ *     return -EAGAIN instead. The return value may be less than count due to
+ *     resource limits, signal interruption, or device constraints (short
+ *     write). On error, returns a negative error code.
+ *
+ * error: EBADF, Bad file descriptor
+ *   desc: fd is not a valid file descriptor, or fd was not opened for writing.
+ *     This includes file descriptors opened with O_RDONLY, O_PATH, or file
+ *     descriptors that have been closed. Also returned if the file structure
+ *     does not have FMODE_WRITE set.
+ *
+ * error: EFAULT, Bad address
+ *   desc: buf points outside the accessible address space. The buffer address
+ *     failed access_ok() validation. Can also occur if a fault happens during
+ *     copy_from_user() when reading data from user space.
+ *
+ * error: EINVAL, Invalid argument
+ *   desc: Returned in several cases: (1) The file has no write or write_iter
+ *     method (FMODE_CAN_WRITE is not set). (2) The file was opened with
+ *     O_DIRECT and the buffer alignment, offset, or count does not meet the
+ *     filesystem's alignment requirements. (3) rw_verify_area() rejects a
+ *     negative file position, or a position plus count that overflows, on a
+ *     file without FOP_UNSIGNED_OFFSET. (4) The count, cast to ssize_t, is
+ *     negative (32-bit kernels only, as 64-bit kernels fail access_ok() first
+ *     with EFAULT).
+ *
+ * error: EAGAIN, Resource temporarily unavailable
+ *   desc: fd refers to a file (pipe, socket, device) that is marked non-blocking
+ *     (O_NONBLOCK) and the write would block because the buffer is full.
+ *     Equivalent to EWOULDBLOCK. The application should retry later or use
+ *     select/poll/epoll to wait for writability.
+ *
+ * error: EINTR, Interrupted system call
+ *   desc: The call was interrupted by a signal before any data was written. This
+ *     only occurs if no data has been transferred; if some data was written
+ *     before the signal, the call returns the number of bytes written. The
+ *     caller should typically restart the write.
+ *
+ * error: EPIPE, Broken pipe
+ *   desc: fd refers to a pipe or socket whose reading end has been closed.
+ *     When this condition occurs, the calling process also receives a SIGPIPE
+ *     signal. If the signal is caught or ignored, EPIPE is still returned.
+ *     For sockets, MSG_NOSIGNAL (via send()) suppresses the signal. For
+ *     pwritev2(), the RWF_NOSIGNAL flag suppresses it.
+ *
+ * error: EFBIG, File too large
+ *   desc: The write starts at or beyond a file size limit. The generic write
+ *     path returns EFBIG when the starting position is at or beyond
+ *     RLIMIT_FSIZE, in which case the process also receives SIGXFSZ, or at or
+ *     beyond the maximum file size of the filesystem. Without O_LARGEFILE
+ *     (32-bit systems only) that maximum is 2GB minus one byte. A write that
+ *     starts below a limit but would cross it is shortened to end at the
+ *     limit.
+ *
+ * error: ENOSPC, No space left on device
+ *   desc: The device containing the file has no room for the data. This can
+ *     occur mid-write resulting in a short write followed by ENOSPC on retry.
+ *
+ * error: EDQUOT, Disk quota exceeded
+ *   desc: The user's quota of disk blocks on the filesystem has been exhausted.
+ *     Like ENOSPC, this can result in a short write.
+ *
+ * error: EIO, Input/output error
+ *   desc: A low-level I/O error occurred while modifying the inode or writing
+ *     data. This typically indicates hardware failure, filesystem corruption,
+ *     or network filesystem timeout. Some data may have been written.
+ *
+ * error: EPERM, Operation not permitted
+ *   desc: The operation was prevented (1) by a file seal (F_SEAL_WRITE or
+ *     F_SEAL_FUTURE_WRITE on memfd/shmem, or F_SEAL_GROW for a write that
+ *     extends the file), (2) by a filesystem-specific check, for example ext4
+ *     refuses writes to an immutable inode, (3) because the file is a
+ *     read-only block device, (4) by an LSM hook denying the operation, or (5)
+ *     by a fanotify pre-content (FAN_PRE_ACCESS) listener denying the write.
+ *
+ * error: EOVERFLOW, Value too large for defined data type
+ *   desc: Returned by rw_verify_area() only for files with FOP_UNSIGNED_OFFSET
+ *     (for example /proc/pid/mem) when the file position is negative, meaning
+ *     above LLONG_MAX, and count is at least -pos so that the write would wrap
+ *     past the end of the 64-bit offset space. Files without
+ *     FOP_UNSIGNED_OFFSET get EINVAL for a negative position or a position
+ *     plus count that overflows. Exceeding filesystem file size limits is
+ *     EFBIG, not EOVERFLOW.
+ *
+ * error: EDESTADDRREQ, Destination address required
+ *   desc: fd is a datagram socket for which no peer address has been set using
+ *     connect(2). Use sendto(2) to specify the destination address.
+ *
+ * error: ETXTBSY, Text file busy
+ *   desc: The file is being used as a swap file (IS_SWAPFILE).
+ *
+ * error: EXDEV, Cross-device link
+ *   desc: When writing to a pipe that has been configured as a watch queue
+ *     (CONFIG_WATCH_QUEUE), direct write() calls are not supported.
+ *
+ * error: ENOMEM, Out of memory
+ *   desc: Insufficient kernel memory was available for the write operation.
+ *     For pipes, this occurs when allocating pages for the pipe buffer.
+ *
+ * error: ERESTARTSYS, Restart system call (internal)
+ *   desc: Internal error code indicating the syscall should be restarted. This
+ *     is converted to EINTR if SA_RESTART is not set on the signal handler, or
+ *     the syscall is transparently restarted if SA_RESTART is set. User space
+ *     should not see this error code directly.
+ *
+ * error: EACCES, Permission denied
+ *   desc: The security subsystem (LSM such as SELinux or AppArmor) denied the
+ *     write operation via security_file_permission(). This can occur even if
+ *     the file was successfully opened.
+ *
+ * lock: file->f_pos_lock
+ *   type: mutex
+ *   acquired: true
+ *   released: true
+ *   desc: For regular files that require atomic position updates (FMODE_ATOMIC_POS),
+ *     the f_pos_lock mutex is acquired by fdget_pos() at syscall entry and released
+ *     by fdput_pos() at syscall exit. This serializes concurrent writes sharing
+ *     the same file description. Not acquired for stream files (FMODE_STREAM like
+ *     pipes and sockets) or when the file is not shared.
+ *
+ * lock: sb->s_writers (freeze protection)
+ *   type: custom
+ *   acquired: true
+ *   released: true
+ *   desc: For regular files, file_start_write() acquires freeze protection on
+ *     the superblock via sb_start_write() before the write, and file_end_write()
+ *     releases it after. This prevents writes during filesystem freeze. Not
+ *     acquired for non-regular files (pipes, sockets, devices).
+ *
+ * lock: inode->i_rwsem
+ *   type: semaphore
+ *   acquired: true
+ *   released: true
+ *   desc: For regular files using generic_file_write_iter(), the inode's i_rwsem
+ *     is acquired in write mode before modifying file data. This is internal to
+ *     the filesystem and released before return. Not all filesystems use this
+ *     pattern.
+ *
+ * lock: pipe->mutex
+ *   type: mutex
+ *   acquired: true
+ *   released: true
+ *   desc: For pipes and FIFOs, the pipe's mutex is held while modifying pipe
+ *     buffers. Released temporarily while waiting for space, then reacquired.
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
+ * signal: SIGPIPE
+ *   number: SIGPIPE
+ *   direction: send
+ *   action: terminate
+ *   condition: Writing to a pipe or socket with no readers
+ *   desc: When writing to a pipe whose read end is closed, or a socket whose
+ *     peer has closed, SIGPIPE is sent to the calling process. The default
+ *     action terminates the process. Use signal(SIGPIPE, SIG_IGN) to suppress
+ *     for write(). EPIPE is returned regardless of signal disposition.
+ *   timing: during
+ *
+ * signal: SIGXFSZ
+ *   number: SIGXFSZ
+ *   direction: send
+ *   action: coredump
+ *   condition: Write starts at or beyond RLIMIT_FSIZE
+ *   desc: When a write starts at or beyond the soft file size limit
+ *     (RLIMIT_FSIZE), generic_write_check_limits() sends SIGXFSZ and the write
+ *     returns EFBIG. The default action terminates with a core dump. A write
+ *     that starts below the limit but would cross it is shortened to end at
+ *     the limit, with no signal. If RLIMIT_FSIZE is RLIM_INFINITY, no signal
+ *     is sent.
+ *   timing: during
+ *
+ * signal: Any signal
+ *   direction: receive
+ *   action: return
+ *   condition: While blocked waiting for space (pipes, sockets)
+ *   desc: The syscall may be interrupted by signals while waiting for buffer
+ *     space to become available. If interrupted before any data is written,
+ *     returns -EINTR or -ERESTARTSYS. If data was already written, returns the
+ *     byte count. Restartable if SA_RESTART is set and no data was written.
+ *   errno: -EINTR
+ *   timing: during
+ *   restartable: yes
+ *
+ * side-effect: file_position
+ *   target: file->f_pos
+ *   condition: For seekable files when write succeeds (returns > 0)
+ *   desc: The file offset (f_pos) is advanced by the number of bytes written.
+ *     For files opened with O_APPEND, f_pos is first set to file size. For
+ *     stream files (FMODE_STREAM such as pipes and sockets), the offset is not
+ *     used or modified. Position updates are protected by f_pos_lock when
+ *     shared.
+ *   reversible: no
+ *
+ * side-effect: modify_state
+ *   target: inode timestamps (mtime, ctime)
+ *   condition: Before the data is copied, for a non-zero count on the generic
+ *     write path
+ *   desc: Updates the file's modification time (mtime) and change time (ctime)
+ *     via file_update_time(), which runs before the data is copied, so the
+ *     timestamps can change even if the write then fails or is short. The
+ *     update is skipped for inodes flagged NOCMTIME and when the timestamps
+ *     are unchanged. The timestamp precision depends on whether the filesystem
+ *     type sets FS_MGTIME (multigrain timestamps).
+ *   reversible: no
+ *
+ * side-effect: modify_state
+ *   target: SUID/SGID bits (mode) and file capabilities
+ *   condition: Write to a regular file that has S_ISUID, S_ISGID, or file
+ *     capabilities set, with a non-zero count
+ *   desc: file_remove_privs() clears S_ISUID, and clears S_ISGID when S_IXGRP
+ *     is also set or the caller is not in the file's group, unless the caller
+ *     has CAP_FSETID. File capabilities (the security.capability xattr) are
+ *     removed as well, regardless of CAP_FSETID. This is a security feature to
+ *     prevent privilege escalation via modified setuid binaries. It runs before
+ *     the data is copied.
+ *   reversible: no
+ *
+ * side-effect: modify_state
+ *   target: file data
+ *   condition: When write succeeds (returns > 0)
+ *   desc: Modifies the file's data content. For regular files, data is written
+ *     to the page cache (buffered I/O) or directly to storage (O_DIRECT).
+ *     Data is not guaranteed to be persistent until fsync() or fdatasync()
+ *     completes, or writeback has written it to storage.
+ *   reversible: no
+ *
+ * side-effect: modify_state
+ *   target: task I/O accounting
+ *   condition: When CONFIG_TASK_XACCT is enabled and the write method is
+ *     invoked
+ *   desc: Updates the current task's I/O accounting statistics. The wchar field
+ *     (write characters) is incremented by bytes written via add_wchar() only on
+ *     successful writes (ret > 0). The syscw field (syscall write count) is
+ *     incremented via inc_syscw() once the write method has been invoked, even
+ *     if it fails, but not when the FMODE_WRITE, FMODE_CAN_WRITE, access_ok()
+ *     or rw_verify_area() checks fail. These statistics are visible in
+ *     /proc/[pid]/io.
+ *   reversible: no
+ *
+ * side-effect: modify_state
+ *   target: fsnotify events
+ *   condition: When write returns > 0
+ *   desc: Generates an FS_MODIFY fsnotify event via fsnotify_modify(), allowing
+ *     inotify, fanotify, and dnotify watchers to be notified of the write.
+ *
+ * capability: CAP_FSETID
+ *   type: bypass_check
+ *   allows: Keep the SUID and SGID bits set when the file is written
+ *   without: SUID is cleared on write, and SGID is cleared if S_IXGRP is set
+ *     or the caller is not in the file's group
+ *   condition: Checked in setattr_should_drop_suidgid() during
+ *     file_remove_privs()
+ *
+ * constraint: MAX_RW_COUNT
+ *   desc: After the access_ok() and rw_verify_area() checks pass, the count
+ *     parameter is silently clamped to MAX_RW_COUNT (INT_MAX & PAGE_MASK, just
+ *     under 2GB) to prevent integer overflow in internal calculations. This is
+ *     transparent to the caller.
+ *   expr: actual_count = min(count, MAX_RW_COUNT)
+ *
+ * constraint: File must be open for writing
+ *   desc: The file descriptor must have been opened with O_WRONLY or O_RDWR.
+ *     Files opened with O_RDONLY or O_PATH cannot be written and return EBADF.
+ *     The file must have both FMODE_WRITE and FMODE_CAN_WRITE flags set.
+ *   expr: (file->f_mode & FMODE_WRITE) && (file->f_mode & FMODE_CAN_WRITE)
+ *
+ * constraint: RLIMIT_FSIZE
+ *   desc: The size of data written is constrained by the RLIMIT_FSIZE resource
+ *     limit. In generic_write_check_limits(), a write that starts at or beyond
+ *     the limit sends SIGXFSZ and returns EFBIG. A write that starts below the
+ *     limit but would cross it is shortened to limit - pos bytes, with no
+ *     signal.
+ *   expr: pos < rlimit(RLIMIT_FSIZE) || rlimit(RLIMIT_FSIZE) == RLIM_INFINITY
+ *
+ * constraint: File seals
+ *   desc: For memfd or shmem files with F_SEAL_WRITE or F_SEAL_FUTURE_WRITE
+ *     seals applied, all write operations fail with EPERM. With F_SEAL_GROW,
+ *     writes that would extend file size fail with EPERM.
+ *
+ * examples: n = write(fd, buf, sizeof(buf));  // Basic write
+ *   n = write(STDOUT_FILENO, msg, strlen(msg));  // Write to stdout
+ *   // Handle short writes:
+ *   while (total < len) {
+ *     n = write(fd, buf + total, len - total);
+ *     if (n < 0) break;
+ *     total += n;
+ *   }
+ *   // Pipe error handling:
+ *   if (write(pipefd[1], &byte, 1) < 0 && errno == EPIPE)
+ *     handle_broken_pipe();
+ *
+ * notes: The behavior of write() varies significantly depending on the type of
+ *   file descriptor:
+ *
+ *   - Regular files: Writes to the page cache (buffered) or directly to storage
+ *     (O_DIRECT). Short writes are rare except near RLIMIT_FSIZE or disk full.
+ *     O_APPEND is atomic for determining write position.
+ *
+ *   - Pipes and FIFOs: Blocking by default. Writes up to PIPE_BUF (4096 bytes
+ *     on Linux) are guaranteed atomic. Larger writes may be interleaved with
+ *     writes from other processes. Blocks if pipe is full; returns EAGAIN with
+ *     O_NONBLOCK. SIGPIPE/EPIPE if no readers.
+ *
+ *   - Sockets: Behavior depends on socket type and protocol. Stream sockets
+ *     (TCP) may return partial writes. Datagram sockets (UDP) typically write
+ *     complete messages or fail. SIGPIPE/EPIPE for broken connections (unless
+ *     MSG_NOSIGNAL). EDESTADDRREQ for unconnected datagram sockets.
+ *
+ *   - Terminals: May block on flow control. Canonical vs raw mode affects
+ *     behavior. Special characters may be interpreted.
+ *
+ *   - Device special files: Behavior is device-specific. Block devices behave
+ *     similarly to regular files. Character device behavior varies.
+ *
+ *   Race condition considerations: Concurrent writes from threads sharing a
+ *   file description race on the file position. Linux 3.14+ provides atomic
+ *   position updates via f_pos_lock for regular files (FMODE_ATOMIC_POS), but
+ *   for maximum safety, use pwrite() for concurrent positioned writes.
+ *
+ *   O_DIRECT writes bypass the page cache and typically require buffer and
+ *   offset alignment to filesystem block size. Query requirements via statx()
+ *   with STATX_DIOALIGN (Linux 6.1+). Unaligned O_DIRECT writes return EINVAL
+ *   on most filesystems.
+ *
+ *   For zero-copy writes, consider using splice(2), sendfile(2), or vmsplice(2)
+ *   instead of copying data through user-space buffers with write().
+ *
+ *   Partial writes (short writes) must be handled by application code.
+ *   Applications should loop until all data is written or an error occurs.
+ */
 SYSCALL_DEFINE3(write, unsigned int, fd, const char __user *, buf,
 		size_t, count)
 {
-- 
2.53.0

