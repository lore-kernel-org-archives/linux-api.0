From: =?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>
Subject: [PATCH bpf-next v8 09/11] bpf: Add a Landlock sandbox example
Date: Tue, 27 Feb 2018 01:41:19 +0100
Message-ID: <20180227004121.3633-10-mic@digikod.net>
References: <20180227004121.3633-1-mic@digikod.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180227004121.3633-1-mic@digikod.net>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: =?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>, Alexei Starovoitov <ast@kernel.org>, Andy Lutomirski <luto@amacapital.net>, Arnaldo Carvalho de Melo <acme@kernel.org>, Casey Schaufler <casey@schaufler-ca.com>, Daniel Borkmann <daniel@iogearbox.net>, David Drysdale <drysdale@google.com>, "David S . Miller" <davem@davemloft.net>, "Eric W . Biederman" <ebiederm@xmission.com>, James Morris <james.l.morris@oracle.com>, Jann Horn <jann@thejh.net>, Jonathan Corbet <corbet@lwn.net>, Michael Kerrisk <mtk.manpages@gmail.com>, Kees Cook <keescook@chromium.org>, Paul Moore <paul@paul-moore.com>, Sargun Dhillon <sargun@sargun.me>, "Serge E . Hallyn" <serge@hallyn.com>, Shuah Khan <shuah@kernel.org>, Tejun Heo <tj@kernel.org>, Thomas Graf <tgraf@suug.ch>
List-Id: linux-api@vger.kernel.org

Add a basic sandbox tool to launch a command which is only allowed to
access in a read only or read-write way a whitelist of file hierarchies.

Add to the bpf_load library the ability to handle a BPF program subtype.

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
* rewrite the example using an inode map
* add to bpf_load the ability to handle subtypes per program type

Changes since v6:
* check return value of load_and_attach()
* allow to write on pipes
* rename BPF_PROG_TYPE_LANDLOCK to BPF_PROG_TYPE_LANDLOCK_RULE
* rename Landlock version to ABI to better reflect its purpose
* use const variable (suggested by Kees Cook)
* remove useless definitions (suggested by Kees Cook)
* add detailed explanations (suggested by Kees Cook)

Changes since v5:
* cosmetic fixes
* rebase

Changes since v4:
* write Landlock rule in C and compiled it with LLVM
* remove cgroup handling
* remove path handling: only handle a read-only environment
* remove errno return codes

Changes since v3:
* remove seccomp and origin field: completely free from seccomp programs
* handle more FS-related hooks
* handle inode hooks and directory traversal
* add faked but consistent view thanks to ENOENT
* add /lib64 in the example
* fix spelling
* rename some types and definitions (e.g. SECCOMP_ADD_LANDLOCK_RULE)

Changes since v2:
* use BPF_PROG_ATTACH for cgroup handling
---
 samples/bpf/Makefile         |   4 +
 samples/bpf/bpf_load.c       |  82 ++++++++++++++++++++-
 samples/bpf/bpf_load.h       |   7 ++
 samples/bpf/landlock1.h      |  14 ++++
 samples/bpf/landlock1_kern.c | 171 +++++++++++++++++++++++++++++++++++++++++++
 samples/bpf/landlock1_user.c | 164 +++++++++++++++++++++++++++++++++++++++++
 6 files changed, 439 insertions(+), 3 deletions(-)
 create mode 100644 samples/bpf/landlock1.h
 create mode 100644 samples/bpf/landlock1_kern.c
 create mode 100644 samples/bpf/landlock1_user.c

diff --git a/samples/bpf/Makefile b/samples/bpf/Makefile
index ec3fc8d88e87..015b1375daa5 100644
--- a/samples/bpf/Makefile
+++ b/samples/bpf/Makefile
@@ -43,6 +43,7 @@ hostprogs-y += xdp_redirect_cpu
 hostprogs-y += xdp_monitor
 hostprogs-y += xdp_rxq_info
 hostprogs-y += syscall_tp
+hostprogs-y += landlock1
 
 # Libbpf dependencies
 LIBBPF := ../../tools/lib/bpf/bpf.o ../../tools/lib/bpf/nlattr.o
@@ -93,6 +94,7 @@ xdp_redirect_cpu-objs := bpf_load.o $(LIBBPF) xdp_redirect_cpu_user.o
 xdp_monitor-objs := bpf_load.o $(LIBBPF) xdp_monitor_user.o
 xdp_rxq_info-objs := bpf_load.o $(LIBBPF) xdp_rxq_info_user.o
 syscall_tp-objs := bpf_load.o $(LIBBPF) syscall_tp_user.o
+landlock1-objs := bpf_load.o $(LIBBPF) landlock1_user.o
 
 # Tell kbuild to always build the programs
 always := $(hostprogs-y)
@@ -144,6 +146,7 @@ always += xdp_monitor_kern.o
 always += xdp_rxq_info_kern.o
 always += xdp2skb_meta_kern.o
 always += syscall_tp_kern.o
+always += landlock1_kern.o
 
 HOSTCFLAGS += -I$(objtree)/usr/include
 HOSTCFLAGS += -I$(srctree)/tools/lib/
@@ -188,6 +191,7 @@ HOSTLOADLIBES_xdp_redirect_cpu += -lelf
 HOSTLOADLIBES_xdp_monitor += -lelf
 HOSTLOADLIBES_xdp_rxq_info += -lelf
 HOSTLOADLIBES_syscall_tp += -lelf
+HOSTLOADLIBES_landlock1 += -lelf
 
 # Allows pointing LLC/CLANG to a LLVM backend with bpf support, redefine on cmdline:
 #  make samples/bpf/ LLC=~/git/llvm/build/bin/llc CLANG=~/git/llvm/build/bin/clang
diff --git a/samples/bpf/bpf_load.c b/samples/bpf/bpf_load.c
index 5bb37db6054b..f7c91093b2f5 100644
--- a/samples/bpf/bpf_load.c
+++ b/samples/bpf/bpf_load.c
@@ -12,6 +12,7 @@
 #include <stdlib.h>
 #include <linux/bpf.h>
 #include <linux/filter.h>
+#include <linux/landlock.h>
 #include <linux/perf_event.h>
 #include <linux/netlink.h>
 #include <linux/rtnetlink.h>
@@ -43,6 +44,9 @@ int prog_array_fd = -1;
 struct bpf_map_data map_data[MAX_MAPS];
 int map_data_count = 0;
 
+struct bpf_subtype_data subtype_data[MAX_PROGS];
+int subtype_data_count = 0;
+
 static int populate_prog_array(const char *event, int prog_fd)
 {
 	int ind = atoi(event), err;
@@ -67,12 +71,14 @@ static int load_and_attach(const char *event, struct bpf_insn *prog, int size)
 	bool is_cgroup_sk = strncmp(event, "cgroup/sock", 11) == 0;
 	bool is_sockops = strncmp(event, "sockops", 7) == 0;
 	bool is_sk_skb = strncmp(event, "sk_skb", 6) == 0;
+	bool is_landlock = strncmp(event, "landlock", 8) == 0;
 	size_t insns_cnt = size / sizeof(struct bpf_insn);
 	enum bpf_prog_type prog_type;
 	char buf[256];
 	int fd, efd, err, id;
 	struct perf_event_attr attr = {};
 	union bpf_prog_subtype *st = NULL;
+	struct bpf_subtype_data *sd = NULL;
 
 	attr.type = PERF_TYPE_TRACEPOINT;
 	attr.sample_type = PERF_SAMPLE_RAW;
@@ -97,6 +103,50 @@ static int load_and_attach(const char *event, struct bpf_insn *prog, int size)
 		prog_type = BPF_PROG_TYPE_SOCK_OPS;
 	} else if (is_sk_skb) {
 		prog_type = BPF_PROG_TYPE_SK_SKB;
+	} else if (is_landlock) {
+		int i, prog_id;
+		const char *event_id = (event + 8);
+
+		if (!isdigit(*event_id)) {
+			printf("invalid prog number\n");
+			return -1;
+		}
+		prog_id = atoi(event_id);
+		for (i = 0; i < subtype_data_count; i++) {
+			if (subtype_data[i].name && strcmp(event,
+						subtype_data[i].name) == 0) {
+				/* save the prog_id for a next program */
+				sd = &subtype_data[i];
+				sd->prog_id = prog_id;
+				st = &sd->subtype;
+				free(sd->name);
+				sd->name = NULL;
+				break;
+			}
+		}
+		if (!st) {
+			printf("missing subtype\n");
+			return -1;
+		}
+		/* automatic conversion of program pointer to FD */
+		if (st->landlock_hook.options & LANDLOCK_OPTION_PREVIOUS) {
+			int previous = -1;
+
+			/* assume the previous program is already loaded */
+			for (i = 0; i < subtype_data_count; i++) {
+				if (subtype_data[i].prog_id ==
+						st->landlock_hook.previous) {
+					previous = subtype_data[i].prog_fd;
+					break;
+				}
+			}
+			if (previous == -1) {
+				printf("could not find the previous program\n");
+				return -1;
+			}
+			st->landlock_hook.previous = previous;
+		}
+		prog_type = BPF_PROG_TYPE_LANDLOCK_HOOK;
 	} else {
 		printf("Unknown event '%s'\n", event);
 		return -1;
@@ -108,10 +158,13 @@ static int load_and_attach(const char *event, struct bpf_insn *prog, int size)
 		printf("bpf_load_program() err=%d\n%s", errno, bpf_log_buf);
 		return -1;
 	}
+	if (sd)
+		sd->prog_fd = fd;
 
 	prog_fd[prog_cnt++] = fd;
 
-	if (is_xdp || is_perf_event || is_cgroup_skb || is_cgroup_sk)
+	if (is_xdp || is_perf_event || is_cgroup_skb || is_cgroup_sk ||
+	    is_landlock)
 		return 0;
 
 	if (is_socket || is_sockops || is_sk_skb) {
@@ -515,6 +568,29 @@ static int do_load_bpf_file(const char *path, fixup_map_cb fixup_map)
 			data_maps = data;
 			for (j = 0; j < MAX_MAPS; j++)
 				map_data[j].fd = -1;
+		} else if (strncmp(shname, "subtype", 7) == 0) {
+			processed_sec[i] = true;
+			if (*(shname + 7) != '/') {
+				printf("invalid name of subtype section");
+				return 1;
+			}
+			if (data->d_size != sizeof(union bpf_prog_subtype)) {
+				printf("invalid size of subtype section: %zd\n",
+				       data->d_size);
+				printf("ref: %zd\n",
+				       sizeof(union bpf_prog_subtype));
+				return 1;
+			}
+			if (subtype_data_count >= MAX_PROGS) {
+				printf("too many subtype sections");
+				return 1;
+			}
+			memcpy(&subtype_data[subtype_data_count].subtype,
+					data->d_buf,
+					sizeof(union bpf_prog_subtype));
+			subtype_data[subtype_data_count].name =
+				strdup((shname + 8));
+			subtype_data_count++;
 		} else if (shdr.sh_type == SHT_SYMTAB) {
 			strtabidx = shdr.sh_link;
 			symbols = data;
@@ -575,7 +651,6 @@ static int do_load_bpf_file(const char *path, fixup_map_cb fixup_map)
 
 	/* load programs */
 	for (i = 1; i < ehdr.e_shnum; i++) {
-
 		if (processed_sec[i])
 			continue;
 
@@ -590,7 +665,8 @@ static int do_load_bpf_file(const char *path, fixup_map_cb fixup_map)
 		    memcmp(shname, "socket", 6) == 0 ||
 		    memcmp(shname, "cgroup/", 7) == 0 ||
 		    memcmp(shname, "sockops", 7) == 0 ||
-		    memcmp(shname, "sk_skb", 6) == 0) {
+		    memcmp(shname, "sk_skb", 6) == 0 ||
+		    memcmp(shname, "landlock", 8) == 0) {
 			ret = load_and_attach(shname, data->d_buf,
 					      data->d_size);
 			if (ret != 0)
diff --git a/samples/bpf/bpf_load.h b/samples/bpf/bpf_load.h
index 453c200b389b..b5abe793e271 100644
--- a/samples/bpf/bpf_load.h
+++ b/samples/bpf/bpf_load.h
@@ -24,6 +24,13 @@ struct bpf_map_data {
 	struct bpf_map_def def;
 };
 
+struct bpf_subtype_data {
+	char *name;
+	int prog_id;
+	int prog_fd;
+	union bpf_prog_subtype subtype;
+};
+
 typedef void (*fixup_map_cb)(struct bpf_map_data *map, int idx);
 
 extern int prog_fd[MAX_PROGS];
diff --git a/samples/bpf/landlock1.h b/samples/bpf/landlock1.h
new file mode 100644
index 000000000000..6d0538816088
--- /dev/null
+++ b/samples/bpf/landlock1.h
@@ -0,0 +1,14 @@
+/*
+ * Landlock sample 1 - common header
+ *
+ * Copyright © 2018 Mickaël Salaün <mic@digikod.net>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2, as
+ * published by the Free Software Foundation.
+ */
+
+#define MAP_MARK_READ		(1ULL << 63)
+#define MAP_MARK_WRITE		(1ULL << 62)
+#define COOKIE_VALUE_FREEZED	(1ULL << 61)
+#define _MAP_MARK_MASK		(MAP_MARK_READ | MAP_MARK_WRITE | COOKIE_VALUE_FREEZED)
diff --git a/samples/bpf/landlock1_kern.c b/samples/bpf/landlock1_kern.c
new file mode 100644
index 000000000000..113243677ddd
--- /dev/null
+++ b/samples/bpf/landlock1_kern.c
@@ -0,0 +1,171 @@
+/*
+ * Landlock sample 1 - whitelist of read only or read-write file hierarchy
+ *
+ * Copyright © 2017-2018 Mickaël Salaün <mic@digikod.net>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2, as
+ * published by the Free Software Foundation.
+ */
+
+/*
+ * This file contains a function that will be compiled to eBPF bytecode thanks
+ * to LLVM/Clang.
+ *
+ * Each SEC() means that the following function or variable will be part of a
+ * custom ELF section. This sections are then processed by the userspace part
+ * (see landlock1_user.c) to extract eBPF bytecode and take into account
+ * variables describing the eBPF program subtype or its license.
+ */
+
+#include <uapi/linux/bpf.h>
+#include <uapi/linux/landlock.h>
+
+#include "bpf_helpers.h"
+#include "landlock1.h" /* MAP_MARK_* */
+
+SEC("maps")
+struct bpf_map_def inode_map = {
+	.type = BPF_MAP_TYPE_INODE,
+	.key_size = sizeof(u32),
+	.value_size = sizeof(u64),
+	.max_entries = 20,
+};
+
+SEC("subtype/landlock1")
+static union bpf_prog_subtype _subtype1 = {
+	.landlock_hook = {
+		.type = LANDLOCK_HOOK_FS_WALK,
+	}
+};
+
+static __always_inline __u64 update_cookie(__u64 cookie, __u8 lookup,
+		void *inode, void *chain, bool freeze)
+{
+	__u64 map_allow = 0;
+
+	if (cookie == 0) {
+		cookie = bpf_inode_get_tag(inode, chain);
+		if (cookie)
+			return cookie;
+		/* only look for the first match in the map, ignore nested
+		 * paths in this example */
+		map_allow = bpf_inode_map_lookup(&inode_map, inode);
+		if (map_allow)
+			cookie = 1 | map_allow;
+	} else {
+		if (cookie & COOKIE_VALUE_FREEZED)
+			return cookie;
+		map_allow = cookie & _MAP_MARK_MASK;
+		cookie &= ~_MAP_MARK_MASK;
+		switch (lookup) {
+		case LANDLOCK_CTX_FS_WALK_INODE_LOOKUP_DOTDOT:
+			cookie--;
+			break;
+		case LANDLOCK_CTX_FS_WALK_INODE_LOOKUP_DOT:
+			break;
+		default:
+			/* ignore _MAP_MARK_MASK overflow in this example */
+			cookie++;
+			break;
+		}
+		if (cookie >= 1)
+			cookie |= map_allow;
+	}
+	/* do not modify the cookie for each fs_pick */
+	if (freeze && cookie)
+		cookie |= COOKIE_VALUE_FREEZED;
+	return cookie;
+}
+
+/*
+ * The function fs_walk() is a simple Landlock program enforced on a set of
+ * processes. This program will be run for each walk through a file path.
+ *
+ * The argument ctx contains the context of the program when it is run, which
+ * enable to evaluate the file path.  This context can change for each run of
+ * the program.
+ */
+SEC("landlock1")
+int fs_walk(struct landlock_ctx_fs_walk *ctx)
+{
+	ctx->cookie = update_cookie(ctx->cookie, ctx->inode_lookup,
+			(void *)ctx->inode, (void *)ctx->chain, false);
+	return LANDLOCK_RET_ALLOW;
+}
+
+SEC("subtype/landlock2")
+static union bpf_prog_subtype _subtype2 = {
+	.landlock_hook = {
+		.type = LANDLOCK_HOOK_FS_PICK,
+		.options = LANDLOCK_OPTION_PREVIOUS,
+		.previous = 1, /* landlock1 */
+		.triggers = LANDLOCK_TRIGGER_FS_PICK_CHDIR |
+			    LANDLOCK_TRIGGER_FS_PICK_GETATTR |
+			    LANDLOCK_TRIGGER_FS_PICK_READDIR |
+			    LANDLOCK_TRIGGER_FS_PICK_TRANSFER |
+			    LANDLOCK_TRIGGER_FS_PICK_OPEN,
+	}
+};
+
+SEC("landlock2")
+int fs_pick_ro(struct landlock_ctx_fs_pick *ctx)
+{
+	ctx->cookie = update_cookie(ctx->cookie, ctx->inode_lookup,
+			(void *)ctx->inode, (void *)ctx->chain, true);
+	if (ctx->cookie & MAP_MARK_READ)
+		return LANDLOCK_RET_ALLOW;
+	return LANDLOCK_RET_DENY;
+}
+
+SEC("subtype/landlock3")
+static union bpf_prog_subtype _subtype3 = {
+	.landlock_hook = {
+		.type = LANDLOCK_HOOK_FS_PICK,
+		.options = LANDLOCK_OPTION_PREVIOUS,
+		.previous = 2, /* landlock2 */
+		.triggers = LANDLOCK_TRIGGER_FS_PICK_APPEND |
+			    LANDLOCK_TRIGGER_FS_PICK_CREATE |
+			    LANDLOCK_TRIGGER_FS_PICK_LINK |
+			    LANDLOCK_TRIGGER_FS_PICK_LINKTO |
+			    LANDLOCK_TRIGGER_FS_PICK_LOCK |
+			    LANDLOCK_TRIGGER_FS_PICK_MOUNTON |
+			    LANDLOCK_TRIGGER_FS_PICK_RENAME |
+			    LANDLOCK_TRIGGER_FS_PICK_RENAMETO |
+			    LANDLOCK_TRIGGER_FS_PICK_RMDIR |
+			    LANDLOCK_TRIGGER_FS_PICK_SETATTR |
+			    LANDLOCK_TRIGGER_FS_PICK_UNLINK |
+			    LANDLOCK_TRIGGER_FS_PICK_WRITE,
+	}
+};
+
+SEC("landlock3")
+int fs_pick_rw(struct landlock_ctx_fs_pick *ctx)
+{
+	ctx->cookie = update_cookie(ctx->cookie, ctx->inode_lookup,
+			(void *)ctx->inode, (void *)ctx->chain, true);
+	if (ctx->cookie & MAP_MARK_WRITE)
+		return LANDLOCK_RET_ALLOW;
+	return LANDLOCK_RET_DENY;
+}
+
+SEC("subtype/landlock4")
+static union bpf_prog_subtype _subtype4 = {
+	.landlock_hook = {
+		.type = LANDLOCK_HOOK_FS_GET,
+		.options = LANDLOCK_OPTION_PREVIOUS,
+		.previous = 3, /* landlock3 */
+	}
+};
+
+SEC("landlock4")
+int fs_get(struct landlock_ctx_fs_get *ctx)
+{
+	/* save the cookie in the tag for relative path lookup */
+	bpf_landlock_set_tag((void *)ctx->tag_object, (void *)ctx->chain,
+			ctx->cookie & ~COOKIE_VALUE_FREEZED);
+	return LANDLOCK_RET_ALLOW;
+}
+
+SEC("license")
+static const char _license[] = "GPL";
diff --git a/samples/bpf/landlock1_user.c b/samples/bpf/landlock1_user.c
new file mode 100644
index 000000000000..e46e0ca182cd
--- /dev/null
+++ b/samples/bpf/landlock1_user.c
@@ -0,0 +1,164 @@
+/*
+ * Landlock sample 1 - partial read-only filesystem
+ *
+ * Copyright © 2017-2018 Mickaël Salaün <mic@digikod.net>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2, as
+ * published by the Free Software Foundation.
+ */
+
+#include "bpf_load.h"
+#include "landlock1.h" /* MAP_MARK_* */
+#include "libbpf.h"
+
+#define _GNU_SOURCE
+#include <errno.h>
+#include <fcntl.h> /* open() */
+#include <linux/bpf.h>
+#include <linux/filter.h>
+#include <linux/landlock.h>
+#include <linux/prctl.h>
+#include <linux/seccomp.h>
+#include <stddef.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <sys/prctl.h>
+#include <sys/syscall.h>
+#include <unistd.h>
+
+#ifndef seccomp
+static int seccomp(unsigned int op, unsigned int flags, void *args)
+{
+	errno = 0;
+	return syscall(__NR_seccomp, op, flags, args);
+}
+#endif
+
+static int apply_sandbox(int prog_fd)
+{
+	int ret = 0;
+
+	/* set up the test sandbox */
+	if (prctl(PR_SET_NO_NEW_PRIVS, 1, 0, 0, 0)) {
+		perror("prctl(no_new_priv)");
+		return 1;
+	}
+	if (seccomp(SECCOMP_PREPEND_LANDLOCK_PROG, 0, &prog_fd)) {
+		perror("seccomp(set_hook)");
+		ret = 1;
+	}
+	close(prog_fd);
+
+	return ret;
+}
+
+#define ENV_FS_PATH_RO_NAME "LL_PATH_RO"
+#define ENV_FS_PATH_RW_NAME "LL_PATH_RW"
+#define ENV_PATH_TOKEN ":"
+
+static int parse_path(char *env_path, const char ***path_list)
+{
+	int i, path_nb = 0;
+
+	if (env_path) {
+		path_nb++;
+		for (i = 0; env_path[i]; i++) {
+			if (env_path[i] == ENV_PATH_TOKEN[0])
+				path_nb++;
+		}
+	}
+	*path_list = malloc(path_nb * sizeof(**path_list));
+	for (i = 0; i < path_nb; i++)
+		(*path_list)[i] = strsep(&env_path, ENV_PATH_TOKEN);
+
+	return path_nb;
+}
+
+static int populate_map(const char *env_var, unsigned long long value,
+		int map_fd)
+{
+	int path_nb, ref_fd, i;
+	char *env_path_name;
+	const char **path_list = NULL;
+
+	env_path_name = getenv(env_var);
+	if (!env_path_name)
+		return 0;
+	env_path_name = strdup(env_path_name);
+	path_nb = parse_path(env_path_name, &path_list);
+
+	for (i = 0; i < path_nb; i++) {
+		ref_fd = open(path_list[i], O_RDONLY | O_CLOEXEC);
+		if (ref_fd < 0) {
+			fprintf(stderr, "Failed to open \"%s\": %s\n",
+					path_list[i],
+					strerror(errno));
+			return 1;
+		}
+		if (bpf_map_update_elem(map_fd, &ref_fd, &value, BPF_ANY)) {
+			fprintf(stderr, "Failed to update the map with"
+					" \"%s\": %s\n", path_list[i],
+					strerror(errno));
+			return 1;
+		}
+		close(ref_fd);
+	}
+	free(env_path_name);
+	return 0;
+}
+
+int main(int argc, char * const argv[], char * const *envp)
+{
+	char filename[256];
+	char *cmd_path;
+	char * const *cmd_argv;
+	int ll_prog;
+
+	if (argc < 2) {
+		fprintf(stderr, "usage: %s <cmd> [args]...\n\n", argv[0]);
+		fprintf(stderr, "Launch a command in a restricted environment.\n");
+		fprintf(stderr, "Environment variables containing paths, each separated by a colon:\n");
+		fprintf(stderr, "* %s: whitelist of allowed files and directories to be read\n",
+				ENV_FS_PATH_RO_NAME);
+		fprintf(stderr, "* %s: whitelist of allowed files and directories to be modified\n",
+				ENV_FS_PATH_RW_NAME);
+		fprintf(stderr, "\nexample:\n"
+				"%s=\"/bin:/lib:/lib64:/usr:${HOME}\" "
+				"%s=\"/tmp:/dev/urandom:/dev/random:/dev/null\" "
+				"%s /bin/sh -i\n",
+				ENV_FS_PATH_RO_NAME, ENV_FS_PATH_RW_NAME, argv[0]);
+		return 1;
+	}
+
+	snprintf(filename, sizeof(filename), "%s_kern.o", argv[0]);
+	if (load_bpf_file(filename)) {
+		printf("%s", bpf_log_buf);
+		return 1;
+	}
+	ll_prog = prog_fd[3]; /* fs_get */
+	if (!ll_prog) {
+		if (errno)
+			printf("load_bpf_file: %s\n", strerror(errno));
+		else
+			printf("load_bpf_file: Error\n");
+		return 1;
+	}
+
+	if (populate_map(ENV_FS_PATH_RO_NAME, MAP_MARK_READ, map_fd[0]))
+		return 1;
+	if (populate_map(ENV_FS_PATH_RW_NAME, MAP_MARK_READ | MAP_MARK_WRITE,
+				map_fd[0]))
+		return 1;
+	close(map_fd[0]);
+
+	fprintf(stderr, "Launching a new sandboxed process\n");
+	if (apply_sandbox(ll_prog))
+		return 1;
+	cmd_path = argv[1];
+	cmd_argv = argv + 1;
+	execve(cmd_path, cmd_argv, envp);
+	perror("Failed to call execve");
+	return 1;
+}
-- 
2.16.2
