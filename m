Received: from sender4-op-o15.zoho.com (sender4-op-o15.zoho.com [136.143.188.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB04B25C804;
	Thu, 16 Jul 2026 14:47:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=136.143.188.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784213252; cv=pass; b=XTI1AcVOlaKg+8pjBIatiCvpyk2YhcH+HV//CXw2kkUbyvpZvJ7kdr9zDZg+opdmkGL9ocFJkU1Jaj9STMgFQKnGKp0jwGEEZdhXxK53k24JK+sScA5rNBKTFxDyhAb+vpSQtfGXD6cWfxdABakID71HqRrsow1lG+N5wKICqrE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784213252; c=relaxed/simple;
	bh=SXhCDGJG5JahULdA9ieCtfnLBxg7hEbCmVpzjFMRAEI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S7xn68/SCqByTr5P58eL0MHRAKglIUSDgDapCAqugDJ8CY1po16/hjLsYZQMogZREBOPOEcxza4SVWm6huzuOH/hqot/SgRjRH5c2adEsL9QrsbYoLDY0PEWM25S76gmO9X4DrOR01+Qdti8RhKedTKl7EidgCx5LRvdAjnn0+s=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.beauty; spf=pass smtp.mailfrom=linux.beauty; dkim=pass (1024-bit key) header.d=linux.beauty header.i=me@linux.beauty header.b=qsOZlAFy; arc=pass smtp.client-ip=136.143.188.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.beauty
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.beauty
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.beauty header.i=me@linux.beauty header.b="qsOZlAFy"
ARC-Seal: i=1; a=rsa-sha256; t=1784212572; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=HSng2g83+OJhIZUv23KRy4zcnv6vd9QLcFZUWMU2r7qY7AArUJMfMr+4FdOPnIb6uKWEn+C1GqXHyT1p7jecD7ur2r+BBsq9/PK/jeuPrmwYIZWQNwaYedEs7AOgRNlTn9HPx8IaCcXgzuiyh258Nmvd1B8fuXjJJ7nk2Kc2VY8=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1784212572; h=Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=ZxeHj8hO5oq7dr0XeLl4vE0l10KI0S0QKZO8mwMoyxs=; 
	b=NRNo6jPM8WNUPj+Sz0GRbIndB4pJoj1h4aBAd5oeWJv9tDWgSUu936fhq+ymKuO38Qu2M5AlzQ+Un+PKE+QF2rIWLHxem31I/ijQuPGdj6VEvLMy985fvNaBiGXMjfm+qU62UiwOs0AJkKhamGXMI8GE11L3NA1XuEbCX9XOlNc=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=linux.beauty;
	spf=pass  smtp.mailfrom=me@linux.beauty;
	dmarc=pass header.from=<me@linux.beauty>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1784212572;
	s=zmail; d=linux.beauty; i=me@linux.beauty;
	h=From:From:To:To:Cc:Cc:Subject:Subject:Date:Date:Message-ID:In-Reply-To:MIME-Version:Content-Transfer-Encoding:Message-Id:Reply-To;
	bh=ZxeHj8hO5oq7dr0XeLl4vE0l10KI0S0QKZO8mwMoyxs=;
	b=qsOZlAFyesYeOFNzL602w6sydaHJw7z934zNhJHn/XHrOHLS2015UuZAr+fAM6/b
	ZnMn85YBMJn4kotXigL9X9Bz4Y75XATVcxuHIaLRJyHDFT6UFYHz/ZcpJSs5nAQTd4H
	zbgriKm78rljhyyNnFEDVr/frdNdV2o0y6UDQdF8=
Received: by mx.zohomail.com with SMTPS id 1784212568808726.4671094867332;
	Thu, 16 Jul 2026 07:36:08 -0700 (PDT)
From: Li Chen <me@linux.beauty>
To: Christian Brauner <brauner@kernel.org>
Cc: Kees Cook <kees@kernel.org>,
	Gabriel Krisman Bertazi <krisman@kernel.org>,
	Josh Triplett <josh@joshtriplett.org>,
	Mateusz Guzik <mjguzik@gmail.com>,
	Andy Lutomirski <luto@kernel.org>,
	John Ericson <mail@johnericson.me>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <shuah@kernel.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Oleg Nesterov <oleg@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Paul Moore <paul@paul-moore.com>,
	Eric Paris <eparis@redhat.com>,
	=?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>,
	=?UTF-8?q?G=C3=BCnther=20Noack?= <gnoack@google.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Jan Kara <jack@suse.cz>,
	linux-api@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-doc@vger.kernel.org,
	audit@vger.kernel.org,
	linux-security-module@vger.kernel.org,
	linux-arch@vger.kernel.org,
	linux-mm@kvack.org,
	Li Chen <me@linux.beauty>
Subject: [RFC PATCH 24/24] Documentation: describe pidfd spawn builders
Date: Thu, 16 Jul 2026 22:31:50 +0800
Message-ID: <7e385d39490520666cbb613e50968e8bf2242269.1784204592.git.me@linux.beauty>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <cover.1784204592.git.me@linux.beauty>
References: <cover.1784204592.git.me@linux.beauty>
Precedence: bulk
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-ZohoMailClient: External

Document the taskless pidfd lifecycle, source-state and authority
model, optional path configuration, run and file-action ABI, one-shot
failure classification, and embryonic process visibility.

Describe policy and audit interactions, current accounting behavior,
and the features still missing from the initial interface. Add the
document to the userspace API index and PIDFD API maintenance entry.

Assisted-by: Codex:gpt-5.6-sol
Signed-off-by: Li Chen <me@linux.beauty>
---
 Documentation/userspace-api/index.rst       |   1 +
 Documentation/userspace-api/pidfd_spawn.rst | 247 ++++++++++++++++++++
 MAINTAINERS                                 |   1 +
 3 files changed, 249 insertions(+)
 create mode 100644 Documentation/userspace-api/pidfd_spawn.rst

diff --git a/Documentation/userspace-api/index.rst b/Documentation/userspace-api/index.rst
index a68b1bea57a85..28da6a4da7c78 100644
--- a/Documentation/userspace-api/index.rst
+++ b/Documentation/userspace-api/index.rst
@@ -21,6 +21,7 @@ System calls
    ebpf/index
    ioctl/index
    mseal
+   pidfd_spawn
    rseq
 
 Security-related interfaces
diff --git a/Documentation/userspace-api/pidfd_spawn.rst b/Documentation/userspace-api/pidfd_spawn.rst
new file mode 100644
index 0000000000000..2aaf5db85f13b
--- /dev/null
+++ b/Documentation/userspace-api/pidfd_spawn.rst
@@ -0,0 +1,247 @@
+.. SPDX-License-Identifier: GPL-2.0
+
+====================
+Pidfd spawn builders
+====================
+
+Pidfd spawn builders create a new process image with kernel-mediated setup.
+They do not expose a userspace child stub between process creation and exec.
+
+The interface is::
+
+    int fd = pidfd_open(0, PIDFD_EMPTY);
+
+    /* Optional executable-path staging. */
+    pidfd_config(fd, PIDFD_CONFIG_SET_STRING,
+                 PIDFD_CONFIG_KEY_PATH, path, 0);
+
+    pidfd_spawn_run(fd, &args, sizeof(args));
+
+The same fd starts as a taskless pidfs object and becomes the child's pidfd
+when a task is created. The current implementation supports an executable
+path, argv, envp, and ordered ``DUP2``, ``CLOSE_RANGE``, and ``FCHDIR`` file
+actions.
+
+Opening a builder
+=================
+
+``pidfd_open(0, PIDFD_EMPTY)`` returns a close-on-exec builder fd.
+``PIDFD_NONBLOCK`` may be combined with ``PIDFD_EMPTY``. Other flags are
+rejected. ``PIDFD_EMPTY`` is rejected for a nonzero pid.
+
+Opening the builder allocates a pidfs inode and builder state. It does not
+allocate a ``struct pid`` or task, and does not charge ``RLIMIT_NPROC`` or the
+pids cgroup controller. PID allocation and process-count accounting occur when
+``pidfd_spawn_run()`` calls the normal task-creation path.
+
+The pidfs inode has a stable identity before and after task creation. A pidfd
+opened from the eventual numeric pid refers to the same pidfs inode. A poll or
+epoll registration made while the fd is taskless remains attached across
+publication and can report the child's eventual exit.
+
+Process-dependent pidfd operations return ``ESRCH`` while the builder is
+taskless. This includes signal delivery, ``pidfd_getfd()``,
+``PIDFD_GET_INFO``, namespace ioctls, ``setns()``, process memory operations,
+and process-dependent pidfs xattrs. Argument validation may fail before the
+taskless-state check. ``poll()`` reports no event while the builder may still
+publish a task. After a terminal taskless failure, ``poll()`` and ``epoll``
+report ``POLLERR | POLLHUP`` and wake registrations made before the failure.
+Inode-only operations such as ``FS_IOC_GETVERSION`` remain available.
+
+The builder state follows the lifetime of the pidfs inode. Duplicated or
+reopened descriptors and VFS references to that inode keep it alive. Releasing
+the final reference before a run discards the taskless builder without
+creating a process.
+
+Source state and authority
+==========================
+
+The current mode is source-based. The child is created from the calling
+process at run time. State changed after ``pidfd_open()`` but before
+``pidfd_spawn_run()``, including the current directory and file descriptor
+table, is therefore visible to normal process creation. Non-close-on-exec file
+descriptors remain available to the new image unless a file action changes
+them. The exec path applies ``FD_CLOEXEC`` normally.
+
+File and filesystem state are private child copies before file actions run.
+The current backend shares the address space only for its internal
+vfork-style setup and replaces it during exec. Applications must not depend on
+that backend detail.
+
+Configuration and run authority is bound to the mm, exact credential object,
+and child PID namespace recorded when the builder is opened. Passing the fd
+through ``SCM_RIGHTS`` or another fd-passing mechanism does not by itself
+delegate authority to configure or run it. A rejected authority check does not
+consume the builder.
+
+Configuring an executable path
+==============================
+
+The optional configuration command is::
+
+    pidfd_config(fd, PIDFD_CONFIG_SET_STRING,
+                 PIDFD_CONFIG_KEY_PATH, path, 0);
+
+The command copies ``path`` into builder state. Calling it again before a run
+replaces the staged string. The key and value must be valid NUL-terminated
+userspace strings, and ``aux`` must be zero. Unknown commands or keys return
+``EOPNOTSUPP``.
+
+Staging is not required when the run arguments provide ``path``. Supplying a
+run-time path when a path is already staged, or supplying neither form,
+returns ``EINVAL``. This selection is validated before a run-time path pointer
+is dereferenced, so a staged-path conflict takes precedence over a fault in
+that pointer. Relative paths are resolved after ordered file actions from the
+child's resulting working directory. Without an ``FCHDIR`` action, that is
+the working directory copied at run time. The kernel does not search ``PATH``.
+
+Run arguments
+=============
+
+Version 0 of ``struct pidfd_spawn_run_args`` contains:
+
+* ``path``: an optional executable-path pointer;
+* ``argv``: a required argument-vector pointer;
+* ``envp``: an environment-vector pointer, or zero for an empty environment;
+* ``actions``, ``nr_actions``, and ``action_size``: an optional ordered
+  file-action array.
+
+``flags`` and all reserved fields must be zero. The syscall size must be at
+least ``PIDFD_SPAWN_RUN_SIZE_VER0`` and no larger than ``PAGE_SIZE``. Unknown
+trailing bytes in a larger structure must be zero.
+
+``path``, ``argv``, ``envp``, and ``actions`` are full-width userspace virtual
+addresses stored in ``__aligned_u64`` fields on every ABI. Native calls must
+fit the native pointer width. Compat calls must fit ``compat_uptr_t``; nonzero
+upper bits are rejected with ``EFAULT`` before task creation. Entries read
+from compat argv and envp arrays are compat pointers.
+
+File actions
+============
+
+When ``nr_actions`` is zero, ``actions`` and ``action_size`` must also be zero.
+Otherwise ``actions`` must be nonzero and ``action_size`` must be at least
+``PIDFD_SPAWN_ACTION_SIZE_VER0`` and aligned to eight bytes. A larger element
+is accepted only when its unknown tail is zero. The complete action payload is
+limited to 64 KiB; the interface does not impose a fixed action count below
+that byte limit.
+
+Actions execute in array order against child-private file and filesystem
+state before exec:
+
+``PIDFD_SPAWN_ACTION_DUP2``
+    Duplicate ``fd`` onto ``newfd``. If both numbers are equal, clear
+    ``FD_CLOEXEC`` on that descriptor. ``flags`` and reserved fields must be
+    zero.
+
+``PIDFD_SPAWN_ACTION_CLOSE_RANGE``
+    Apply ``close_range(fd, newfd, flags)``. ``newfd`` must not be less than
+    ``fd``. Only ``CLOSE_RANGE_UNSHARE`` and ``CLOSE_RANGE_CLOEXEC`` are
+    accepted.
+
+``PIDFD_SPAWN_ACTION_FCHDIR``
+    Change the child working directory to ``fd``. ``flags``, ``newfd``, and
+    reserved fields must be zero.
+
+An unknown action type returns ``EOPNOTSUPP``. Invalid fields or arguments
+return ``EINVAL``. Errors from applying an otherwise valid action are reported
+as run failures after task publication.
+
+One-shot execution and results
+==============================
+
+After fd type, creator authority, and source ptrace checks succeed, the first
+``pidfd_spawn_run()`` attempt atomically claims the builder before copying its
+run arguments. Argument faults, validation errors, memory-allocation failures,
+process limits, and task-creation failures after that claim are terminal.
+Later configuration and run attempts return ``EBUSY``.
+
+Checks that fail before the claim do not consume the builder. These include an
+invalid fd type, creator-authority mismatch, or an already traced source.
+
+On successful setup and exec, ``pidfd_spawn_run()`` returns the positive child
+pid as seen in the caller's PID namespace. The pidfd remains the stable process
+identity.
+
+A failure before task creation returns a negative error and leaves the fd
+terminal but taskless. Ordinary pidfd operations continue to return ``ESRCH``.
+``poll()`` and ``epoll`` report ``POLLERR | POLLHUP``. The builder cannot be
+retried; a caller must open a new builder.
+
+A setup or exec failure after publication returns a negative error, leaves the
+same fd as the child's pidfd, and makes the child exit with status 127. Normal
+``SIGCHLD``, ``SIG_IGN``, and ``SA_NOCLDWAIT`` rules determine whether it must
+be reaped. ``PIDFD_GET_INFO`` with ``PIDFD_INFO_EXIT`` distinguishes this case
+from a terminal taskless failure.
+
+Internal restart errors after the claim are returned to userspace as
+``EINTR``. The kernel does not automatically restart a consumed run and
+replace its first result with ``EBUSY``.
+
+A fatal signal delivered to the published child determines the child's exit
+status if it wins during setup. It is not reported as an exec setup error, so
+the run can return the positive child pid even when that child exits from the
+signal.
+
+Embryonic process state
+=======================
+
+After task publication and before successful exec completion, the child is in
+an embryonic exec state. It is not yet a normal userspace process image and
+does not have a valid userspace register frame on every architecture.
+
+During this interval:
+
+* direct ptrace access and ``pidfd_getfd()`` are denied;
+* procfs PID lookup and iteration treat the task as absent to other tasks,
+  preventing access to the source address space temporarily shared by the
+  implementation; the embryonic task may resolve its own procfs entries for
+  executable and interpreter lookup;
+* ``PIDFD_GET_INFO`` reports ``PIDFD_COREDUMP_SKIP`` when coredump state is
+  requested;
+* ordinary pidfd identity, signal, wait, and poll mechanisms operate on the
+  published task as their normal permission checks allow.
+
+Successful exec releases the embryonic state before exec event publication. A
+failed setup never exposes the borrowed pre-exec frame to userspace; the child
+exits instead.
+
+Security policy and audit
+=========================
+
+File actions and exec run inside the child kernel path. They do not appear to
+seccomp as separate ``dup2()``, ``close_range()``, ``fchdir()``, or
+``execve()`` syscalls. A source-side seccomp filter can reject
+``pidfd_spawn_run()`` before the builder is claimed. A policy that intends to
+prevent this operation must filter ``pidfd_spawn_run()`` itself; denying only
+the syscall numbers corresponding to its file actions or exec does not mediate
+the equivalent in-kernel work. In particular, an exec-only denylist that
+allows unknown syscalls does not block the initial spawn exec; it must add
+``pidfd_spawn_run()``. A syscall allowlist does not permit the new operation
+until it adds that syscall. Seccomp state inherited by the child remains active
+after exec. LSM checks, including Landlock executable access, still mediate the
+underlying exec.
+
+Audit records the source syscall transaction and a separate
+``AUDIT_PIDFD_SPAWN`` child transaction for executable lookup and exec
+arguments. The child does not emit a synthetic second ``AUDIT_SYSCALL``
+record. The child transaction is selected using the originating
+``pidfd_spawn_run()`` syscall number, so an existing exit rule that names only
+``execve()`` or ``execveat()`` does not select it. Such rules must also select
+``pidfd_spawn_run()`` with the current audit model. File actions are not
+emitted as decoded per-action audit records.
+
+An already traced source is rejected before the claim. The current backend
+does not implement ptrace auto-attach events for the created child.
+
+Current limitations
+===================
+
+The interface does not yet implement the full ``posix_spawn()`` surface. It
+lacks open and close file actions, resetids, signal mask and default controls,
+scheduler attributes, affinity, process groups, sessions, explicit cgroup
+placement, ``PATH`` search, and exec by fd.
+
+It also does not provide pristine or no-source process creation, executable
+metadata caching, or reusable spawn templates. The current implementation is
+source-based and uses the existing vfork/exec machinery internally.
diff --git a/MAINTAINERS b/MAINTAINERS
index 85b1306cb2ff3..0b6d466787a60 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -21288,6 +21288,7 @@ M:	Christian Brauner <christian@brauner.io>
 L:	linux-kernel@vger.kernel.org
 S:	Maintained
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/brauner/linux.git
+F:	Documentation/userspace-api/pidfd_spawn.rst
 F:	fs/pidfd_spawn.c
 F:	include/linux/pidfd_spawn.h
 F:	include/uapi/linux/pidfd_spawn.h
-- 
2.52.0

