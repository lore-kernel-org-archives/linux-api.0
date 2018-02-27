From: =?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>
Subject: [PATCH bpf-next v8 04/11] bpf,landlock: Define an eBPF program type for Landlock hooks
Date: Tue, 27 Feb 2018 01:41:14 +0100
Message-ID: <20180227004121.3633-5-mic@digikod.net>
References: <20180227004121.3633-1-mic@digikod.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <kernel-hardening-return-11974-glkh-kernel-hardening=m.gmane.org@lists.openwall.com>
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
In-Reply-To: <20180227004121.3633-1-mic@digikod.net>
To: linux-kernel@vger.kernel.org
Cc: =?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>, Alexei Starovoitov <ast@kernel.org>, Andy Lutomirski <luto@amacapital.net>, Arnaldo Carvalho de Melo <acme@kernel.org>, Casey Schaufler <casey@schaufler-ca.com>, Daniel Borkmann <daniel@iogearbox.net>, David Drysdale <drysdale@google.com>, "David S . Miller" <davem@davemloft.net>, "Eric W . Biederman" <ebiederm@xmission.com>, James Morris <james.l.morris@oracle.com>, Jann Horn <jann@thejh.net>, Jonathan Corbet <corbet@lwn.net>, Michael Kerrisk <mtk.manpages@gmail.com>, Kees Cook <keescook@chromium.org>, Paul Moore <paul@paul-moore.com>, Sargun Dhillon <sargun@sargun.me>, "Serge E . Hallyn" <serge@hallyn.com>, Shuah Khan <shuah@kernel.org>, Tejun Heo <tj@kernel.org>, Thomas Graf <tgraf@suug.ch>, Tycho
List-Id: linux-api@vger.kernel.org

Add a new type of eBPF program used by Landlock hooks. This type of
program can be chained with the same eBPF program type (according to
subtype rules). A state can be kept with a value available in the
program's context (e.g. named "cookie" for Landlock programs).

This new BPF program type will be registered with the Landlock LSM
initialization.

Add an initial Landlock Kconfig and update the MAINTAINERS file.

Signed-off-by: Mickaël Salaün <mic@digikod.net>
Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Andy Lutomirski <luto@amacapital.net>
Cc: Daniel Borkmann <daniel@iogearbox.net>
Cc: David S. Miller <davem@davemloft.net>
Cc: James Morris <james.l.morris@oracle.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Serge E. Hallyn <serge@hallyn.com>
---

Changes since v7:
* cosmetic fixes
* rename LANDLOCK_SUBTYPE_* to LANDLOCK_*
* cleanup UAPI definitions and move them from bpf.h to landlock.h
  (suggested by Alexei Starovoitov)
* disable Landlock by default (suggested by Alexei Starovoitov)
* rename BPF_PROG_TYPE_LANDLOCK_{RULE,HOOK}
* update the Kconfig
* update the MAINTAINERS file
* replace the IOCTL, LOCK and FCNTL events with FS_PICK, FS_WALK and
  FS_GET hook types
* add the ability to chain programs with an eBPF program file descriptor
  (i.e. the "previous" field in a Landlock subtype) and keep a state
  with a "cookie" value available from the context
* add a "triggers" subtype bitfield to match specific actions (e.g.
  append, chdir, read...)

Changes since v6:
* add 3 more sub-events: IOCTL, LOCK, FCNTL
  https://lkml.kernel.org/r/2fbc99a6-f190-f335-bd14-04bdeed35571@digikod.net
* rename LANDLOCK_VERSION to LANDLOCK_ABI to better reflect its purpose,
  and move it from landlock.h to common.h
* rename BPF_PROG_TYPE_LANDLOCK to BPF_PROG_TYPE_LANDLOCK_RULE: an eBPF
  program could be used for something else than a rule
* simplify struct landlock_context by removing the arch and syscall_nr fields
* remove all eBPF map functions call, remove ABILITY_WRITE
* refactor bpf_landlock_func_proto() (suggested by Kees Cook)
* constify pointers
* fix doc inclusion

Changes since v5:
* rename file hooks.c to init.c
* fix spelling

Changes since v4:
* merge a minimal (not enabled) LSM code and Kconfig in this commit

Changes since v3:
* split commit
* revamp the landlock_context:
  * add arch, syscall_nr and syscall_cmd (ioctl, fcntl…) to be able to
    cross-check action with the event type
  * replace args array with dedicated fields to ease the addition of new
    fields
---
 MAINTAINERS                         |  13 +++
 include/linux/bpf_types.h           |   3 +
 include/uapi/linux/bpf.h            |   1 +
 include/uapi/linux/landlock.h       | 155 +++++++++++++++++++++++++++++++
 security/Kconfig                    |   1 +
 security/Makefile                   |   2 +
 security/landlock/Kconfig           |  18 ++++
 security/landlock/Makefile          |   3 +
 security/landlock/common.h          |  32 +++++++
 security/landlock/init.c            | 180 ++++++++++++++++++++++++++++++++++++
 tools/include/uapi/linux/bpf.h      |   1 +
 tools/include/uapi/linux/landlock.h | 155 +++++++++++++++++++++++++++++++
 12 files changed, 564 insertions(+)
 create mode 100644 include/uapi/linux/landlock.h
 create mode 100644 security/landlock/Kconfig
 create mode 100644 security/landlock/Makefile
 create mode 100644 security/landlock/common.h
 create mode 100644 security/landlock/init.c
 create mode 100644 tools/include/uapi/linux/landlock.h

diff --git a/MAINTAINERS b/MAINTAINERS
index 3bdc260e36b7..ac0809094bae 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -7882,6 +7882,19 @@ S:	Maintained
 F:	net/l3mdev
 F:	include/net/l3mdev.h
 
+LANDLOCK SECURITY MODULE
+M:	Mickaël Salaün <mic@digikod.net>
+S:	Supported
+F:	Documentation/security/landlock/
+F:	include/linux/landlock.h
+F:	include/uapi/linux/landlock.h
+F:	samples/bpf/landlock*
+F:	security/landlock/
+F:	tools/include/uapi/linux/landlock.h
+F:	tools/testing/selftests/landlock/
+K:	landlock
+K:	LANDLOCK
+
 LANTIQ MIPS ARCHITECTURE
 M:	John Crispin <john@phrozen.org>
 L:	linux-mips@linux-mips.org
diff --git a/include/linux/bpf_types.h b/include/linux/bpf_types.h
index 19b8349a3809..0ca019f3ae4a 100644
--- a/include/linux/bpf_types.h
+++ b/include/linux/bpf_types.h
@@ -22,6 +22,9 @@ BPF_PROG_TYPE(BPF_PROG_TYPE_PERF_EVENT, perf_event)
 #ifdef CONFIG_CGROUP_BPF
 BPF_PROG_TYPE(BPF_PROG_TYPE_CGROUP_DEVICE, cg_dev)
 #endif
+#ifdef CONFIG_SECURITY_LANDLOCK
+BPF_PROG_TYPE(BPF_PROG_TYPE_LANDLOCK_HOOK, landlock)
+#endif
 
 BPF_MAP_TYPE(BPF_MAP_TYPE_ARRAY, array_map_ops)
 BPF_MAP_TYPE(BPF_MAP_TYPE_PERCPU_ARRAY, percpu_array_map_ops)
diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index 87885c92ca78..2433aa1a0fd4 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -133,6 +133,7 @@ enum bpf_prog_type {
 	BPF_PROG_TYPE_SOCK_OPS,
 	BPF_PROG_TYPE_SK_SKB,
 	BPF_PROG_TYPE_CGROUP_DEVICE,
+	BPF_PROG_TYPE_LANDLOCK_HOOK,
 };
 
 enum bpf_attach_type {
diff --git a/include/uapi/linux/landlock.h b/include/uapi/linux/landlock.h
new file mode 100644
index 000000000000..49a132092fd9
--- /dev/null
+++ b/include/uapi/linux/landlock.h
@@ -0,0 +1,155 @@
+/*
+ * Landlock - UAPI headers
+ *
+ * Copyright © 2017-2018 Mickaël Salaün <mic@digikod.net>
+ * Copyright © 2018 ANSSI
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2, as
+ * published by the Free Software Foundation.
+ */
+
+#ifndef _UAPI__LINUX_LANDLOCK_H__
+#define _UAPI__LINUX_LANDLOCK_H__
+
+#include <linux/types.h>
+
+#define LANDLOCK_RET_ALLOW	0
+#define LANDLOCK_RET_DENY	1
+
+/**
+ * enum landlock_hook_type - hook type for which a Landlock program is called
+ *
+ * A hook is a policy decision point which exposes the same context type for
+ * each program evaluation.
+ *
+ * @LANDLOCK_HOOK_FS_PICK: called for the last element of a file path
+ * @LANDLOCK_HOOK_FS_WALK: called for each directory of a file path (excluding
+ *			   the directory passed to fs_pick, if any)
+ * @LANDLOCK_HOOK_FS_GET: called for file opening or receiveing or when
+ *			  changing directory or root
+ */
+enum landlock_hook_type {
+	LANDLOCK_HOOK_FS_PICK = 1,
+	LANDLOCK_HOOK_FS_WALK,
+	LANDLOCK_HOOK_FS_GET,
+};
+
+/**
+ * DOC: landlock_subtype_options
+ *
+ * - %LANDLOCK_OPTION_PREVIOUS: specify a previous file descriptor in the
+ *			        dedicated field
+ */
+#define LANDLOCK_OPTION_PREVIOUS			(1ULL << 0)
+
+/**
+ * DOC: landlock_triggers
+ *
+ * A landlock trigger is used as a bitmask in subtype.landlock_hook.triggers
+ * for a fs_pick program.  It defines a set of actions for which the program
+ * should verify an access request.
+ *
+ * - %LANDLOCK_TRIGGER_FS_PICK_APPEND
+ * - %LANDLOCK_TRIGGER_FS_PICK_CHDIR
+ * - %LANDLOCK_TRIGGER_FS_PICK_CHROOT
+ * - %LANDLOCK_TRIGGER_FS_PICK_CREATE
+ * - %LANDLOCK_TRIGGER_FS_PICK_EXECUTE
+ * - %LANDLOCK_TRIGGER_FS_PICK_FCNTL
+ * - %LANDLOCK_TRIGGER_FS_PICK_GETATTR
+ * - %LANDLOCK_TRIGGER_FS_PICK_IOCTL
+ * - %LANDLOCK_TRIGGER_FS_PICK_LINK
+ * - %LANDLOCK_TRIGGER_FS_PICK_LINKTO
+ * - %LANDLOCK_TRIGGER_FS_PICK_LOCK
+ * - %LANDLOCK_TRIGGER_FS_PICK_MAP
+ * - %LANDLOCK_TRIGGER_FS_PICK_MOUNTON
+ * - %LANDLOCK_TRIGGER_FS_PICK_OPEN
+ * - %LANDLOCK_TRIGGER_FS_PICK_READ
+ * - %LANDLOCK_TRIGGER_FS_PICK_READDIR
+ * - %LANDLOCK_TRIGGER_FS_PICK_RECEIVE
+ * - %LANDLOCK_TRIGGER_FS_PICK_RENAME
+ * - %LANDLOCK_TRIGGER_FS_PICK_RENAMETO
+ * - %LANDLOCK_TRIGGER_FS_PICK_RMDIR
+ * - %LANDLOCK_TRIGGER_FS_PICK_SETATTR
+ * - %LANDLOCK_TRIGGER_FS_PICK_TRANSFER
+ * - %LANDLOCK_TRIGGER_FS_PICK_UNLINK
+ * - %LANDLOCK_TRIGGER_FS_PICK_WRITE
+ */
+#define LANDLOCK_TRIGGER_FS_PICK_APPEND			(1ULL << 0)
+#define LANDLOCK_TRIGGER_FS_PICK_CHDIR			(1ULL << 1)
+#define LANDLOCK_TRIGGER_FS_PICK_CHROOT			(1ULL << 2)
+#define LANDLOCK_TRIGGER_FS_PICK_CREATE			(1ULL << 3)
+#define LANDLOCK_TRIGGER_FS_PICK_EXECUTE		(1ULL << 4)
+#define LANDLOCK_TRIGGER_FS_PICK_FCNTL			(1ULL << 5)
+#define LANDLOCK_TRIGGER_FS_PICK_GETATTR		(1ULL << 6)
+#define LANDLOCK_TRIGGER_FS_PICK_IOCTL			(1ULL << 7)
+#define LANDLOCK_TRIGGER_FS_PICK_LINK			(1ULL << 8)
+#define LANDLOCK_TRIGGER_FS_PICK_LINKTO			(1ULL << 9)
+#define LANDLOCK_TRIGGER_FS_PICK_LOCK			(1ULL << 10)
+#define LANDLOCK_TRIGGER_FS_PICK_MAP			(1ULL << 11)
+#define LANDLOCK_TRIGGER_FS_PICK_MOUNTON		(1ULL << 12)
+#define LANDLOCK_TRIGGER_FS_PICK_OPEN			(1ULL << 13)
+#define LANDLOCK_TRIGGER_FS_PICK_READ			(1ULL << 14)
+#define LANDLOCK_TRIGGER_FS_PICK_READDIR		(1ULL << 15)
+#define LANDLOCK_TRIGGER_FS_PICK_RECEIVE		(1ULL << 16)
+#define LANDLOCK_TRIGGER_FS_PICK_RENAME			(1ULL << 17)
+#define LANDLOCK_TRIGGER_FS_PICK_RENAMETO		(1ULL << 18)
+#define LANDLOCK_TRIGGER_FS_PICK_RMDIR			(1ULL << 19)
+#define LANDLOCK_TRIGGER_FS_PICK_SETATTR		(1ULL << 20)
+#define LANDLOCK_TRIGGER_FS_PICK_TRANSFER		(1ULL << 21)
+#define LANDLOCK_TRIGGER_FS_PICK_UNLINK			(1ULL << 22)
+#define LANDLOCK_TRIGGER_FS_PICK_WRITE			(1ULL << 23)
+
+/* inode_lookup */
+/* LOOKUP_ROOT can only be seen for the first fs_walk call */
+#define LANDLOCK_CTX_FS_WALK_INODE_LOOKUP_ROOT		1
+#define LANDLOCK_CTX_FS_WALK_INODE_LOOKUP_DOT		2
+#define LANDLOCK_CTX_FS_WALK_INODE_LOOKUP_DOTDOT	3
+
+/**
+ * struct landlock_ctx_fs_pick - context accessible to a fs_pick program
+ *
+ * @cookie: value saved and restored between calls to chained programs
+ * @chain: chain pointer to identify the current chain
+ * @inode: pointer to the current kernel object that can be used with
+ *	   bpf_inode_get_tag()
+ * @inode_lookup: bitflags to identify how we got there
+ */
+struct landlock_ctx_fs_pick {
+	__u64 cookie;
+	__u64 chain;
+	__u64 inode;
+	__u8 inode_lookup;
+};
+
+/**
+ * struct landlock_ctx_fs_walk - context accessible to a fs_walk program
+ *
+ * @cookie: value saved and restored between calls to chained programs
+ * @chain: chain pointer to identify the current chain
+ * @inode: pointer to the current kernel object that can be used with
+ *	   bpf_inode_get_tag()
+ * @inode_lookup: bitflags to identify how we got there
+ */
+struct landlock_ctx_fs_walk {
+	__u64 cookie;
+	__u64 chain;
+	__u64 inode;
+	__u8 inode_lookup;
+};
+
+/**
+ * struct landlock_ctx_fs_get - context accessible to a fs_get program
+ *
+ * @cookie: value saved and restored between calls to chained programs
+ * @chain: chain pointer to identify the current chain
+ * @tag_object: pointer that can be used to tag a file/inode with
+ *		bpf_landlock_set_tag()
+ */
+struct landlock_ctx_fs_get {
+	__u64 cookie;
+	__u64 chain;
+	__u64 tag_object;
+};
+
+#endif /* _UAPI__LINUX_LANDLOCK_H__ */
diff --git a/security/Kconfig b/security/Kconfig
index c4302067a3ad..649695e88c87 100644
--- a/security/Kconfig
+++ b/security/Kconfig
@@ -237,6 +237,7 @@ source security/tomoyo/Kconfig
 source security/apparmor/Kconfig
 source security/loadpin/Kconfig
 source security/yama/Kconfig
+source security/landlock/Kconfig
 
 source security/integrity/Kconfig
 
diff --git a/security/Makefile b/security/Makefile
index 4d2d3782ddef..808317bd11d1 100644
--- a/security/Makefile
+++ b/security/Makefile
@@ -10,6 +10,7 @@ subdir-$(CONFIG_SECURITY_TOMOYO)        += tomoyo
 subdir-$(CONFIG_SECURITY_APPARMOR)	+= apparmor
 subdir-$(CONFIG_SECURITY_YAMA)		+= yama
 subdir-$(CONFIG_SECURITY_LOADPIN)	+= loadpin
+subdir-$(CONFIG_SECURITY_LANDLOCK)		+= landlock
 
 # always enable default capabilities
 obj-y					+= commoncap.o
@@ -25,6 +26,7 @@ obj-$(CONFIG_SECURITY_TOMOYO)		+= tomoyo/
 obj-$(CONFIG_SECURITY_APPARMOR)		+= apparmor/
 obj-$(CONFIG_SECURITY_YAMA)		+= yama/
 obj-$(CONFIG_SECURITY_LOADPIN)		+= loadpin/
+obj-$(CONFIG_SECURITY_LANDLOCK)	+= landlock/
 obj-$(CONFIG_CGROUP_DEVICE)		+= device_cgroup.o
 
 # Object integrity file lists
diff --git a/security/landlock/Kconfig b/security/landlock/Kconfig
new file mode 100644
index 000000000000..8bd103102008
--- /dev/null
+++ b/security/landlock/Kconfig
@@ -0,0 +1,18 @@
+config SECURITY_LANDLOCK
+	bool "Landlock support"
+	depends on SECURITY
+	depends on BPF_SYSCALL
+	depends on SECCOMP_FILTER
+	default n
+	help
+	  This selects Landlock, a programmatic access control.  It enables to
+	  restrict processes on the fly (i.e. create a sandbox).  The security
+	  policy is a set of eBPF programs, dedicated to deny a list of actions
+	  on specific kernel objects (e.g. file).
+
+	  You need to enable seccomp filter to apply a security policy to a
+	  process hierarchy (e.g. application with built-in sandboxing).
+
+	  See Documentation/security/landlock/ for further information.
+
+	  If you are unsure how to answer this question, answer N.
diff --git a/security/landlock/Makefile b/security/landlock/Makefile
new file mode 100644
index 000000000000..7205f9a7a2ee
--- /dev/null
+++ b/security/landlock/Makefile
@@ -0,0 +1,3 @@
+obj-$(CONFIG_SECURITY_LANDLOCK) := landlock.o
+
+landlock-y := init.o
diff --git a/security/landlock/common.h b/security/landlock/common.h
new file mode 100644
index 000000000000..0906678c0ed0
--- /dev/null
+++ b/security/landlock/common.h
@@ -0,0 +1,32 @@
+/*
+ * Landlock LSM - private headers
+ *
+ * Copyright © 2016-2018 Mickaël Salaün <mic@digikod.net>
+ * Copyright © 2018 ANSSI
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2, as
+ * published by the Free Software Foundation.
+ */
+
+#ifndef _SECURITY_LANDLOCK_COMMON_H
+#define _SECURITY_LANDLOCK_COMMON_H
+
+#include <linux/bpf.h> /* enum bpf_prog_aux */
+#include <linux/filter.h> /* bpf_prog */
+#include <linux/refcount.h> /* refcount_t */
+#include <uapi/linux/landlock.h> /* enum landlock_hook_type */
+
+#define LANDLOCK_NAME "landlock"
+
+/* UAPI bounds and bitmasks */
+
+#define _LANDLOCK_HOOK_LAST LANDLOCK_HOOK_FS_GET
+
+#define _LANDLOCK_OPTION_LAST		LANDLOCK_OPTION_PREVIOUS
+#define _LANDLOCK_OPTION_MASK		((_LANDLOCK_OPTION_LAST << 1ULL) - 1)
+
+#define _LANDLOCK_TRIGGER_FS_PICK_LAST	LANDLOCK_TRIGGER_FS_PICK_WRITE
+#define _LANDLOCK_TRIGGER_FS_PICK_MASK	((_LANDLOCK_TRIGGER_FS_PICK_LAST << 1ULL) - 1)
+
+#endif /* _SECURITY_LANDLOCK_COMMON_H */
diff --git a/security/landlock/init.c b/security/landlock/init.c
new file mode 100644
index 000000000000..ef2ee0742c53
--- /dev/null
+++ b/security/landlock/init.c
@@ -0,0 +1,180 @@
+/*
+ * Landlock LSM - init
+ *
+ * Copyright © 2016-2018 Mickaël Salaün <mic@digikod.net>
+ * Copyright © 2018 ANSSI
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2, as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/bpf.h> /* enum bpf_access_type */
+#include <linux/capability.h> /* capable */
+#include <linux/filter.h> /* struct bpf_prog */
+
+#include "common.h" /* LANDLOCK_* */
+
+static bool bpf_landlock_is_valid_access(int off, int size,
+		enum bpf_access_type type, struct bpf_insn_access_aux *info,
+		const struct bpf_prog_extra *prog_extra)
+{
+	const union bpf_prog_subtype *prog_subtype;
+	enum bpf_reg_type reg_type = NOT_INIT;
+	int max_size = 0;
+
+	if (WARN_ON(!prog_extra))
+		return false;
+	prog_subtype = &prog_extra->subtype;
+
+	if (off < 0)
+		return false;
+	if (size <= 0 || size > sizeof(__u64))
+		return false;
+
+	/* check memory range access */
+	switch (reg_type) {
+	case NOT_INIT:
+		return false;
+	case SCALAR_VALUE:
+		/* allow partial raw value */
+		if (size > max_size)
+			return false;
+		info->ctx_field_size = max_size;
+		break;
+	default:
+		/* deny partial pointer */
+		if (size != max_size)
+			return false;
+	}
+
+	info->reg_type = reg_type;
+	return true;
+}
+
+/*
+ * Check order of Landlock programs
+ *
+ * Keep in sync with enforce.c:is_hook_type_forkable().
+ */
+static bool good_previous_prog(enum landlock_hook_type current_type,
+		const struct bpf_prog *previous)
+{
+	enum landlock_hook_type previous_type;
+
+	if (previous->type != BPF_PROG_TYPE_LANDLOCK_HOOK)
+		return false;
+	if (WARN_ON(!previous->aux->extra))
+		return false;
+	previous_type = previous->aux->extra->subtype.landlock_hook.type;
+	switch (current_type) {
+	case LANDLOCK_HOOK_FS_PICK:
+		switch (previous_type) {
+		case LANDLOCK_HOOK_FS_PICK:
+		case LANDLOCK_HOOK_FS_WALK:
+			return true;
+		default:
+			return false;
+		}
+	case LANDLOCK_HOOK_FS_GET:
+		/* In the future, fs_get could be chained with another fs_get
+		 * (different triggers), but not for now. */
+		if (previous_type != LANDLOCK_HOOK_FS_PICK)
+			return false;
+		return true;
+	case LANDLOCK_HOOK_FS_WALK:
+		return false;
+	}
+	WARN_ON(1);
+	return false;
+}
+
+static bool bpf_landlock_is_valid_subtype(struct bpf_prog_extra *prog_extra)
+{
+	const union bpf_prog_subtype *subtype;
+
+	if (!prog_extra)
+		return false;
+	subtype = &prog_extra->subtype;
+
+	switch (subtype->landlock_hook.type) {
+	case LANDLOCK_HOOK_FS_PICK:
+		if (!subtype->landlock_hook.triggers ||
+				subtype->landlock_hook.triggers &
+				~_LANDLOCK_TRIGGER_FS_PICK_MASK)
+			return false;
+		break;
+	case LANDLOCK_HOOK_FS_WALK:
+	case LANDLOCK_HOOK_FS_GET:
+		if (subtype->landlock_hook.triggers)
+			return false;
+		break;
+	default:
+		return false;
+	}
+
+	if (subtype->landlock_hook.options & ~_LANDLOCK_OPTION_MASK)
+		return false;
+	if (subtype->landlock_hook.options & LANDLOCK_OPTION_PREVIOUS) {
+		struct bpf_prog *previous;
+
+		/* check and save the chained program */
+		previous = bpf_prog_get(subtype->landlock_hook.previous);
+		if (IS_ERR(previous))
+			return false;
+		if (!good_previous_prog(subtype->landlock_hook.type,
+					previous)) {
+			bpf_prog_put(previous);
+			return false;
+		}
+		/* It is not possible to create loops because the current
+		 * program does not exist yet. */
+		prog_extra->landlock_hook.previous = previous;
+	}
+
+	return true;
+}
+
+static const struct bpf_func_proto *bpf_landlock_func_proto(
+		enum bpf_func_id func_id,
+		const struct bpf_prog_extra *prog_extra)
+{
+	u64 hook_type;
+
+	if (WARN_ON(!prog_extra))
+		return NULL;
+	hook_type = prog_extra->subtype.landlock_hook.type;
+
+	/* generic functions */
+	/* TODO: do we need/want update/delete functions for every LL prog?
+	 * => impurity vs. audit */
+	switch (func_id) {
+	case BPF_FUNC_map_lookup_elem:
+		return &bpf_map_lookup_elem_proto;
+	case BPF_FUNC_map_update_elem:
+		return &bpf_map_update_elem_proto;
+	case BPF_FUNC_map_delete_elem:
+		return &bpf_map_delete_elem_proto;
+	default:
+		break;
+	}
+	return NULL;
+}
+
+static void bpf_landlock_put_extra(struct bpf_prog_extra *prog_extra)
+{
+	if (WARN_ON(!prog_extra))
+		return;
+	if (prog_extra->landlock_hook.previous)
+		bpf_prog_put(prog_extra->landlock_hook.previous);
+}
+
+const struct bpf_verifier_ops landlock_verifier_ops = {
+	.get_func_proto	= bpf_landlock_func_proto,
+	.is_valid_access = bpf_landlock_is_valid_access,
+	.is_valid_subtype = bpf_landlock_is_valid_subtype,
+};
+
+const struct bpf_prog_ops landlock_prog_ops = {
+	.put_extra = bpf_landlock_put_extra,
+};
diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index 87885c92ca78..2433aa1a0fd4 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -133,6 +133,7 @@ enum bpf_prog_type {
 	BPF_PROG_TYPE_SOCK_OPS,
 	BPF_PROG_TYPE_SK_SKB,
 	BPF_PROG_TYPE_CGROUP_DEVICE,
+	BPF_PROG_TYPE_LANDLOCK_HOOK,
 };
 
 enum bpf_attach_type {
diff --git a/tools/include/uapi/linux/landlock.h b/tools/include/uapi/linux/landlock.h
new file mode 100644
index 000000000000..49a132092fd9
--- /dev/null
+++ b/tools/include/uapi/linux/landlock.h
@@ -0,0 +1,155 @@
+/*
+ * Landlock - UAPI headers
+ *
+ * Copyright © 2017-2018 Mickaël Salaün <mic@digikod.net>
+ * Copyright © 2018 ANSSI
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2, as
+ * published by the Free Software Foundation.
+ */
+
+#ifndef _UAPI__LINUX_LANDLOCK_H__
+#define _UAPI__LINUX_LANDLOCK_H__
+
+#include <linux/types.h>
+
+#define LANDLOCK_RET_ALLOW	0
+#define LANDLOCK_RET_DENY	1
+
+/**
+ * enum landlock_hook_type - hook type for which a Landlock program is called
+ *
+ * A hook is a policy decision point which exposes the same context type for
+ * each program evaluation.
+ *
+ * @LANDLOCK_HOOK_FS_PICK: called for the last element of a file path
+ * @LANDLOCK_HOOK_FS_WALK: called for each directory of a file path (excluding
+ *			   the directory passed to fs_pick, if any)
+ * @LANDLOCK_HOOK_FS_GET: called for file opening or receiveing or when
+ *			  changing directory or root
+ */
+enum landlock_hook_type {
+	LANDLOCK_HOOK_FS_PICK = 1,
+	LANDLOCK_HOOK_FS_WALK,
+	LANDLOCK_HOOK_FS_GET,
+};
+
+/**
+ * DOC: landlock_subtype_options
+ *
+ * - %LANDLOCK_OPTION_PREVIOUS: specify a previous file descriptor in the
+ *			        dedicated field
+ */
+#define LANDLOCK_OPTION_PREVIOUS			(1ULL << 0)
+
+/**
+ * DOC: landlock_triggers
+ *
+ * A landlock trigger is used as a bitmask in subtype.landlock_hook.triggers
+ * for a fs_pick program.  It defines a set of actions for which the program
+ * should verify an access request.
+ *
+ * - %LANDLOCK_TRIGGER_FS_PICK_APPEND
+ * - %LANDLOCK_TRIGGER_FS_PICK_CHDIR
+ * - %LANDLOCK_TRIGGER_FS_PICK_CHROOT
+ * - %LANDLOCK_TRIGGER_FS_PICK_CREATE
+ * - %LANDLOCK_TRIGGER_FS_PICK_EXECUTE
+ * - %LANDLOCK_TRIGGER_FS_PICK_FCNTL
+ * - %LANDLOCK_TRIGGER_FS_PICK_GETATTR
+ * - %LANDLOCK_TRIGGER_FS_PICK_IOCTL
+ * - %LANDLOCK_TRIGGER_FS_PICK_LINK
+ * - %LANDLOCK_TRIGGER_FS_PICK_LINKTO
+ * - %LANDLOCK_TRIGGER_FS_PICK_LOCK
+ * - %LANDLOCK_TRIGGER_FS_PICK_MAP
+ * - %LANDLOCK_TRIGGER_FS_PICK_MOUNTON
+ * - %LANDLOCK_TRIGGER_FS_PICK_OPEN
+ * - %LANDLOCK_TRIGGER_FS_PICK_READ
+ * - %LANDLOCK_TRIGGER_FS_PICK_READDIR
+ * - %LANDLOCK_TRIGGER_FS_PICK_RECEIVE
+ * - %LANDLOCK_TRIGGER_FS_PICK_RENAME
+ * - %LANDLOCK_TRIGGER_FS_PICK_RENAMETO
+ * - %LANDLOCK_TRIGGER_FS_PICK_RMDIR
+ * - %LANDLOCK_TRIGGER_FS_PICK_SETATTR
+ * - %LANDLOCK_TRIGGER_FS_PICK_TRANSFER
+ * - %LANDLOCK_TRIGGER_FS_PICK_UNLINK
+ * - %LANDLOCK_TRIGGER_FS_PICK_WRITE
+ */
+#define LANDLOCK_TRIGGER_FS_PICK_APPEND			(1ULL << 0)
+#define LANDLOCK_TRIGGER_FS_PICK_CHDIR			(1ULL << 1)
+#define LANDLOCK_TRIGGER_FS_PICK_CHROOT			(1ULL << 2)
+#define LANDLOCK_TRIGGER_FS_PICK_CREATE			(1ULL << 3)
+#define LANDLOCK_TRIGGER_FS_PICK_EXECUTE		(1ULL << 4)
+#define LANDLOCK_TRIGGER_FS_PICK_FCNTL			(1ULL << 5)
+#define LANDLOCK_TRIGGER_FS_PICK_GETATTR		(1ULL << 6)
+#define LANDLOCK_TRIGGER_FS_PICK_IOCTL			(1ULL << 7)
+#define LANDLOCK_TRIGGER_FS_PICK_LINK			(1ULL << 8)
+#define LANDLOCK_TRIGGER_FS_PICK_LINKTO			(1ULL << 9)
+#define LANDLOCK_TRIGGER_FS_PICK_LOCK			(1ULL << 10)
+#define LANDLOCK_TRIGGER_FS_PICK_MAP			(1ULL << 11)
+#define LANDLOCK_TRIGGER_FS_PICK_MOUNTON		(1ULL << 12)
+#define LANDLOCK_TRIGGER_FS_PICK_OPEN			(1ULL << 13)
+#define LANDLOCK_TRIGGER_FS_PICK_READ			(1ULL << 14)
+#define LANDLOCK_TRIGGER_FS_PICK_READDIR		(1ULL << 15)
+#define LANDLOCK_TRIGGER_FS_PICK_RECEIVE		(1ULL << 16)
+#define LANDLOCK_TRIGGER_FS_PICK_RENAME			(1ULL << 17)
+#define LANDLOCK_TRIGGER_FS_PICK_RENAMETO		(1ULL << 18)
+#define LANDLOCK_TRIGGER_FS_PICK_RMDIR			(1ULL << 19)
+#define LANDLOCK_TRIGGER_FS_PICK_SETATTR		(1ULL << 20)
+#define LANDLOCK_TRIGGER_FS_PICK_TRANSFER		(1ULL << 21)
+#define LANDLOCK_TRIGGER_FS_PICK_UNLINK			(1ULL << 22)
+#define LANDLOCK_TRIGGER_FS_PICK_WRITE			(1ULL << 23)
+
+/* inode_lookup */
+/* LOOKUP_ROOT can only be seen for the first fs_walk call */
+#define LANDLOCK_CTX_FS_WALK_INODE_LOOKUP_ROOT		1
+#define LANDLOCK_CTX_FS_WALK_INODE_LOOKUP_DOT		2
+#define LANDLOCK_CTX_FS_WALK_INODE_LOOKUP_DOTDOT	3
+
+/**
+ * struct landlock_ctx_fs_pick - context accessible to a fs_pick program
+ *
+ * @cookie: value saved and restored between calls to chained programs
+ * @chain: chain pointer to identify the current chain
+ * @inode: pointer to the current kernel object that can be used with
+ *	   bpf_inode_get_tag()
+ * @inode_lookup: bitflags to identify how we got there
+ */
+struct landlock_ctx_fs_pick {
+	__u64 cookie;
+	__u64 chain;
+	__u64 inode;
+	__u8 inode_lookup;
+};
+
+/**
+ * struct landlock_ctx_fs_walk - context accessible to a fs_walk program
+ *
+ * @cookie: value saved and restored between calls to chained programs
+ * @chain: chain pointer to identify the current chain
+ * @inode: pointer to the current kernel object that can be used with
+ *	   bpf_inode_get_tag()
+ * @inode_lookup: bitflags to identify how we got there
+ */
+struct landlock_ctx_fs_walk {
+	__u64 cookie;
+	__u64 chain;
+	__u64 inode;
+	__u8 inode_lookup;
+};
+
+/**
+ * struct landlock_ctx_fs_get - context accessible to a fs_get program
+ *
+ * @cookie: value saved and restored between calls to chained programs
+ * @chain: chain pointer to identify the current chain
+ * @tag_object: pointer that can be used to tag a file/inode with
+ *		bpf_landlock_set_tag()
+ */
+struct landlock_ctx_fs_get {
+	__u64 cookie;
+	__u64 chain;
+	__u64 tag_object;
+};
+
+#endif /* _UAPI__LINUX_LANDLOCK_H__ */
-- 
2.16.2
