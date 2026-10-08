Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5239475320;
	Thu,  8 Oct 2026 08:50:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791449462; cv=none; b=KUQF9RA8migk6aay/gNdZAvT2FmhMGqlyviguZzEJbjq23dsSGzWkUHulZRGiH7agn9vTVle0n+Mu7HXAotBuxeuivRr9yLVNp0GYalgOOmZ2+G3CZyg4egJLPMU3StvQNcvIBYNNId80W5X+0ENUvuj6YMqlxIcmEa/QjxVZCE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791449462; c=relaxed/simple;
	bh=neWg2zNQIFwd2QqeiYUGRVackzSeR06OKdtwUPaXZVw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WRVS81yGDdSskZ4f67XvZoFKzy5arzlzrrQyDmUu4WVUvDiWYDJ820YUWpWdC6Q5Bp5GyNRsiEMTUq6xymOWugd+XDmtnVjn6XlzO9F2NTzwPYxf/YZCDPwG1aW7fD2ICrRVl+TgItkYujtj0mLY6y/ZiTSwiJwqrm6BmuexruA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HEDtBz2J; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HEDtBz2J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00FD11F0089B;
	Thu,  8 Oct 2026 08:50:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791449455;
	bh=ZXQtEK68jVgj6DZUQJVxHUzcPCxTUmXUguVWpM4le7E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HEDtBz2JRZqZ4Txk5JjEtvIPTBPlPQR4FEvDliKL6PDhD6k7PKe9OP6eO0jX7YxoE
	 ddiaHOydTMf2GsXmpuLNtayxz/oRHzFOZr9baAUhjPYD71eymbYEWG6WJMFtrisHnM
	 EHc8pdjF8pdaCSo47wP/YepmWoaneII9QOT6V00hYGmhOcYmWexZ0ZrE2918BWVds6
	 3E8inyTAzLgwIWDzZbMMbKc3IR3EQi9F8ivGr2cf9PCUYlWdbWi4lVAfQIB/GKRDN1
	 uBEL/3on94oLTaI5uOidulHO/nQ5B33EpzoN524h+o5yr+Dd+AZEcEun438Lvl5t4F
	 VAoB56Cw+aZlw==
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
Subject: [PATCH v5 06/11] kernel/api: add API specification for sys_close
Date: Thu,  8 Oct 2026 04:49:46 -0400
Message-ID: <20261008084956.2911790-7-sashal@kernel.org>
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

Add KAPI-annotated kerneldoc for the sys_close system call in fs/open.c.

The specification documents the file descriptor parameter, error
conditions, locking requirements, side effects on pending I/O, and
the close-on-exec relationship.

Assisted-by: LLM
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/open.c | 233 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 233 insertions(+)

diff --git a/fs/open.c b/fs/open.c
index 92808ab20d52a..9f08c438f162a 100644
--- a/fs/open.c
+++ b/fs/open.c
@@ -1861,6 +1861,239 @@ int filp_close(struct file *filp, fl_owner_t id)
 }
 EXPORT_SYMBOL(filp_close);
 
+/**
+ * sys_close - Close a file descriptor
+ * @fd: The file descriptor to close
+ *
+ * long-desc: Terminates access to an open file descriptor, releasing the file
+ *   descriptor for reuse by subsequent open(), dup(), or similar syscalls.
+ *
+ *   Traditional POSIX advisory record locks held by the process on the
+ *   associated file are released when any of its fds for that inode is
+ *   closed, not only the last one. OFD locks and flock locks are associated
+ *   with the open file description and are only released when the last
+ *   reference to that open file description is dropped.
+ *
+ *   Closing a file descriptor drops one reference to its open file
+ *   description. Other descriptors (dup(), fork(), SCM_RIGHTS messages in
+ *   flight) and operations still running on the file, such as a concurrent
+ *   read(), also hold references. Only when the last reference is dropped are
+ *   the associated resources freed. If the file was previously unlinked, the
+ *   file itself is deleted when the last reference is dropped.
+ *
+ *   Except when close() fails with EBADF, the file descriptor is released even
+ *   when close() returns an error, because it is released before the flush
+ *   that may fail. POSIX leaves the state of the descriptor unspecified after
+ *   EINTR. Retrying close() after an error may close an unrelated file
+ *   descriptor that another thread has since been given.
+ *
+ *   Errors returned from close() come only from the file's ->flush() method,
+ *   called by filp_flush(). Errors from ->release() are not reported.
+ *   Filesystems without a ->flush() method, such as ext4, xfs and btrfs, never
+ *   report write errors from close(). Network filesystems such as NFS, CIFS and
+ *   FUSE implement ->flush() and report deferred write errors (EIO, ENOSPC,
+ *   EDQUOT) at close time. A successful return does not mean the data reached
+ *   storage; call fsync() before close() for that.
+ *
+ *   On close, the following cleanup operations are performed: the ->flush()
+ *   method is called if the file has one, POSIX advisory locks are removed,
+ *   dnotify registrations are cleaned up, and the file reference is released.
+ *   If this was the last reference, additional cleanup includes: fsnotify close
+ *   notification, epoll cleanup, OFD, flock and lease removal, FASYNC cleanup,
+ *   the ->release() method, and the file structure deallocation.
+ *
+ * contexts: process, sleepable
+ *
+ * param: fd
+ *   type: fd, input
+ *   constraint-type: range(0, INT_MAX)
+ *   cdesc: Must be a valid, open file descriptor for the current process.
+ *     The value 0, 1, or 2 (stdin, stdout, stderr) may be closed like any other
+ *     fd, though this is unusual and may cause issues with libraries that assume
+ *     these descriptors are valid. The parameter is unsigned int to match kernel
+ *     file descriptor table indexing. A value that is not open, including any
+ *     value at or above the current table size, fails with EBADF.
+ *
+ * return:
+ *   type: int
+ *   check-type: exact
+ *   success: 0
+ *   desc: Returns 0 on success. On error, returns a negative error code. Except
+ *     for EBADF, the file descriptor is still closed when an error is returned
+ *     and must not be used again. The error comes from the file's ->flush()
+ *     method, not from the fd remaining open. With EBADF, nothing was released.
+ *
+ * error: EBADF, Bad file descriptor
+ *   desc: fd is at or above the file descriptor table size, has no file
+ *     assigned (including a slot reserved by a concurrent open() that has not
+ *     installed its file yet), or was already closed. This is the only error
+ *     for which no file descriptor was released.
+ *
+ * error: EINTR, Interrupted system call
+ *   desc: The flush operation was interrupted by a signal before completion.
+ *     This occurs when a driver's ->flush() method (for example wdm_flush() in
+ *     drivers/usb/class/cdc-wdm.c) performs an interruptible wait that receives
+ *     a signal. The file descriptor is still released and must not be used
+ *     again. Kernel-internal restart codes (ERESTARTSYS,
+ *     ERESTARTNOINTR, ERESTARTNOHAND, ERESTART_RESTARTBLOCK) are converted to
+ *     EINTR because restarting the syscall would be incorrect once the fd is
+ *     freed.
+ *
+ * error: EIO, I/O error
+ *   desc: The file's ->flush() method reported an I/O error, typically a
+ *     deferred write error on a network filesystem such as NFS, CIFS or FUSE,
+ *     or an error from a driver's ->flush(). Previously buffered write data
+ *     may have been lost.
+ *
+ * error: ENOSPC, No space left on device
+ *   desc: The file's ->flush() method reported that there was insufficient
+ *     space to flush buffered writes, for example on NFS when the server runs
+ *     out of space between write() and close().
+ *
+ * error: EDQUOT, Disk quota exceeded
+ *   desc: The file's ->flush() method reported that the user's disk quota was
+ *     exceeded while flushing buffered writes, for example on NFS when the
+ *     quota is exceeded between write() and close().
+ *
+ * lock: files->file_lock
+ *   type: spinlock
+ *   acquired: true
+ *   released: true
+ *   desc: Taken by file_close_fd() to look up and clear the fd slot atomically,
+ *     so two concurrent close() calls on one fd cannot both obtain the struct
+ *     file. Dropped before ->flush() and the final fput. From then on the fd
+ *     number may be handed out again. An fd reserved by a concurrent open() but
+ *     not yet installed has a NULL slot, so close() returns EBADF.
+ *
+ * lock: file->f_lock
+ *   type: spinlock
+ *   acquired: true
+ *   released: true
+ *   desc: Taken from __fput() on the last reference, by eventpoll_release_file()
+ *     when the file is registered with epoll, and by fasync_remove_entry()
+ *     (through the ->fasync() method) when FASYNC is set. Protects the epoll
+ *     and fasync links of the file.
+ *
+ * lock: ep->mtx
+ *   type: mutex
+ *   acquired: true
+ *   released: true
+ *   desc: Acquired during epoll cleanup if the file was monitored by epoll.
+ *     Used to safely remove the file from epoll interest lists.
+ *
+ * lock: flc_lock
+ *   type: spinlock
+ *   acquired: true
+ *   released: true
+ *   desc: File lock context spinlock. Taken by locks_remove_posix() from
+ *     filp_flush() on every close when the file has POSIX locks, and by
+ *     locks_remove_file() from __fput() on the last reference to remove OFD,
+ *     flock, and lease locks.
+ *
+ * signal: pending_signals
+ *   direction: receive
+ *   action: return
+ *   condition: When close-time flush performs interruptible wait
+ *   desc: If the close-time ->flush() method (for example wdm_flush() in
+ *     cdc-wdm) performs an interruptible wait and a signal is pending, the wait
+ *     is interrupted. Any kernel restart codes are converted to EINTR since
+ *     close cannot be restarted after the fd is freed.
+ *   errno: -EINTR
+ *   timing: during
+ *   restartable: no
+ *
+ * side-effect: resource_destroy | irreversible
+ *   target: File descriptor table entry
+ *   desc: The file descriptor is removed from the process's file descriptor
+ *     table, making the fd number available for reuse by subsequent open(),
+ *     dup(), or similar calls. This happens before the flush that may fail, so
+ *     an error return does not undo it.
+ *   condition: Always (when fd is valid)
+ *   reversible: no
+ *
+ * side-effect: lock_release
+ *   target: POSIX advisory locks, OFD locks, flock locks
+ *   desc: POSIX locks held by this process on the inode are removed on every
+ *     close via locks_remove_posix() in filp_flush(), except for O_PATH files.
+ *     OFD and flock locks are removed via locks_remove_file() in __fput() only
+ *     when this is the last reference to the open file description.
+ *   condition: Any close of a non-O_PATH file for POSIX locks, last reference
+ *     for OFD and flock locks
+ *   reversible: no
+ *
+ * side-effect: resource_destroy
+ *   target: File leases
+ *   desc: Any file leases held on the file are removed during locks_remove_file()
+ *     when this is the last reference to the open file description.
+ *   condition: File had leases and this is the last reference
+ *   reversible: no
+ *
+ * side-effect: modify_state
+ *   target: dnotify registrations
+ *   desc: Directory notification (dnotify) registrations associated with this
+ *     file are cleaned up via dnotify_flush(). This only applies to directories.
+ *   condition: File is a directory with dnotify registrations
+ *   reversible: no
+ *
+ * side-effect: modify_state
+ *   target: epoll interest lists
+ *   desc: If the file was being monitored by epoll instances, it is removed
+ *     from those interest lists via eventpoll_release(), which runs from
+ *     __fput() only on the last reference. While other references remain, the
+ *     epoll registrations stay active.
+ *   condition: File was added to epoll instances and this is the last reference
+ *   reversible: no
+ *
+ * side-effect: filesystem
+ *   target: Buffered data
+ *   desc: The file's ->flush() method runs before the file reference is
+ *     dropped (for example on NFS, CIFS and FUSE) and may return errors such as
+ *     EIO, ENOSPC or EDQUOT.
+ *   condition: The filesystem or driver provides a ->flush() method
+ *   reversible: no
+ *
+ * side-effect: free_memory
+ *   target: struct file and related structures
+ *   desc: When this is the last reference to the file, the file structure is
+ *     freed and the dentry and mount references are released.
+ *   condition: This is the last reference to the file
+ *   reversible: no
+ *
+ * side-effect: filesystem
+ *   target: Unlinked file deletion
+ *   desc: If the file was previously unlinked (deleted) but kept open, closing
+ *     the last reference causes the actual file data to be removed from the
+ *     filesystem and the inode to be freed.
+ *   condition: File was unlinked and this is the last reference
+ *   reversible: no
+ *
+ * state-trans: file_descriptor
+ *   from: open
+ *   to: closed/free
+ *   condition: Valid fd passed to close
+ *   desc: The file descriptor transitions from open (usable) to closed (invalid).
+ *     The fd number becomes available for reuse.
+ *
+ * state-trans: file_reference_count
+ *   from: n
+ *   to: n-1 (or freed if n was 1)
+ *   condition: Always on successful fd lookup
+ *   desc: The file's reference count is decremented. If this was the last
+ *     reference, the file is fully cleaned up and freed.
+ *
+ * examples: close(fd);  // Ignoring the result loses ->flush() errors
+ *   if (close(fd) == -1) perror("close");  // Log errors for debugging
+ *   fsync(fd); close(fd);  // Ensure data persistence before closing
+ *
+ * notes: close() drops its reference with fput_close_sync(), so when it is the last
+ *   reference __fput() runs synchronously in the calling task before close()
+ *   returns, instead of being deferred to task work.
+ *
+ *   Calling close() on a file descriptor while another thread is using it
+ *   (e.g., in a blocking read() or write()) does not interrupt the blocked
+ *   operation. The blocked operation continues on the underlying file and
+ *   may complete even after close() returns.
+ */
 /*
  * Careful here! We test whether the file pointer is NULL before
  * releasing the fd. This ensures that one clone task can't release
-- 
2.53.0

