From: Andrey Vagin <avagin@openvz.org>
Subject: [PATCH 23/24] selftest: check the task_diag functinonality
Date: Mon,  6 Jul 2015 11:47:24 +0300
Message-ID: <1436172445-6979-24-git-send-email-avagin@openvz.org>
References: <1436172445-6979-1-git-send-email-avagin@openvz.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1436172445-6979-1-git-send-email-avagin@openvz.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: linux-api@vger.kernel.org, Andrey Vagin <avagin@openvz.org>, Oleg Nesterov <oleg@redhat.com>, Andrew Morton <akpm@linux-foundation.org>, Cyrill Gorcunov <gorcunov@openvz.org>, Pavel Emelyanov <xemul@parallels.com>, Roger Luethi <rl@hellgate.ch>, Arnd Bergmann <arnd@arndb.de>, Arnaldo Carvalho de Melo <acme@kernel.org>, David Ahern <dsahern@gmail.com>, Andy Lutomirski <luto@amacapital.net>, Pavel Odintsov <pavel.odintsov@gmail.com>
List-Id: linux-api@vger.kernel.org

Here are two test (example) programs.

task_diag - request information for two processes.
test_diag_all - request information about all processes

v2: Fixes from David Ahern:
    * task_diag: Fix 8-byte alignment for vma and vma_stats

Signed-off-by: Andrey Vagin <avagin@openvz.org>
---
 tools/testing/selftests/Makefile                   |   1 +
 tools/testing/selftests/task_diag/Makefile         |  18 +++
 tools/testing/selftests/task_diag/fork.c           |  30 ++++
 tools/testing/selftests/task_diag/run.sh           |   6 +
 tools/testing/selftests/task_diag/task_diag.c      | 115 +++++++++++++++
 tools/testing/selftests/task_diag/task_diag.h      |   1 +
 tools/testing/selftests/task_diag/task_diag_all.c  | 145 +++++++++++++++++++
 tools/testing/selftests/task_diag/task_diag_comm.c | 157 +++++++++++++++++++++
 tools/testing/selftests/task_diag/task_diag_comm.h |  33 +++++
 tools/testing/selftests/task_diag/task_proc_all.c  |  35 +++++
 tools/testing/selftests/task_diag/taskstats.h      |   1 +
 11 files changed, 542 insertions(+)
 create mode 100644 tools/testing/selftests/task_diag/Makefile
 create mode 100644 tools/testing/selftests/task_diag/fork.c
 create mode 100755 tools/testing/selftests/task_diag/run.sh
 create mode 100644 tools/testing/selftests/task_diag/task_diag.c
 create mode 120000 tools/testing/selftests/task_diag/task_diag.h
 create mode 100644 tools/testing/selftests/task_diag/task_diag_all.c
 create mode 100644 tools/testing/selftests/task_diag/task_diag_comm.c
 create mode 100644 tools/testing/selftests/task_diag/task_diag_comm.h
 create mode 100644 tools/testing/selftests/task_diag/task_proc_all.c
 create mode 120000 tools/testing/selftests/task_diag/taskstats.h

diff --git a/tools/testing/selftests/Makefile b/tools/testing/selftests/Makefile
index 95abddc..25a42de 100644
--- a/tools/testing/selftests/Makefile
+++ b/tools/testing/selftests/Makefile
@@ -18,6 +18,7 @@ TARGETS += timers
 TARGETS += user
 TARGETS += vm
 TARGETS += x86
+TARGETS += task_diag
 #Please keep the TARGETS list alphabetically sorted
 
 TARGETS_HOTPLUG = cpu-hotplug
diff --git a/tools/testing/selftests/task_diag/Makefile b/tools/testing/selftests/task_diag/Makefile
new file mode 100644
index 0000000..7104573
--- /dev/null
+++ b/tools/testing/selftests/task_diag/Makefile
@@ -0,0 +1,18 @@
+all: task_diag task_diag_all fork task_proc_all fork
+
+CFLAGS += -Wall -O2 -I/usr/include/libnl3
+LDFLAGS += -lnl-3 -lnl-genl-3
+TEST_PROGS := run.sh
+include ../lib.mk
+
+task_diag.o: task_diag.c task_diag_comm.h
+task_diag_all.o: task_diag_all.c task_diag_comm.h
+task_diag_comm.o: task_diag_comm.c task_diag_comm.h
+
+task_diag_all: task_diag_all.o task_diag_comm.o
+task_diag: task_diag.o task_diag_comm.o
+fork: fork.c
+task_proc_all: task_proc_all.c
+
+clean:
+	rm -rf task_diag task_diag_all task_diag_comm.o task_diag_all.o task_diag.o fork task_proc_all
diff --git a/tools/testing/selftests/task_diag/fork.c b/tools/testing/selftests/task_diag/fork.c
new file mode 100644
index 0000000..c6e17d1
--- /dev/null
+++ b/tools/testing/selftests/task_diag/fork.c
@@ -0,0 +1,30 @@
+#include <unistd.h>
+#include <string.h>
+#include <stdio.h>
+#include <stdlib.h>
+
+int main(int argc, char **argv)
+{
+	int i, n;
+
+	if (argc < 2)
+		return 1;
+
+	n = atoi(argv[1]);
+	for (i = 0; i < n; i++) {
+		pid_t pid;
+
+		pid = fork();
+		if (pid < 0) {
+			printf("Unable to fork: %m\n");
+			return 1;
+		}
+		if (pid == 0) {
+			while (1)
+				sleep(1000);
+			return 0;
+		}
+	}
+
+	return 0;
+}
diff --git a/tools/testing/selftests/task_diag/run.sh b/tools/testing/selftests/task_diag/run.sh
new file mode 100755
index 0000000..62250a5
--- /dev/null
+++ b/tools/testing/selftests/task_diag/run.sh
@@ -0,0 +1,6 @@
+#!/bin/sh
+./fork 1000
+nproc=`./task_diag_all A | grep 'pid.*tgid.*ppid.*comm fork$' | wc -l`
+killall -9 fork
+[ "$nproc" -eq 1000 ] && exit 0
+echo "Unexpected number of tasks '$nproc'" 1>&2
diff --git a/tools/testing/selftests/task_diag/task_diag.c b/tools/testing/selftests/task_diag/task_diag.c
new file mode 100644
index 0000000..ff232a1
--- /dev/null
+++ b/tools/testing/selftests/task_diag/task_diag.c
@@ -0,0 +1,115 @@
+#include <stdio.h>
+#include <stdlib.h>
+#include <errno.h>
+#include <unistd.h>
+#include <poll.h>
+#include <string.h>
+#include <fcntl.h>
+#include <sys/types.h>
+#include <sys/stat.h>
+#include <sys/socket.h>
+#include <sys/wait.h>
+#include <signal.h>
+#include <dirent.h>
+
+#include <linux/netlink.h>
+#include <netlink/socket.h>
+#include <linux/genetlink.h>
+#include <netlink/genl/ctrl.h>
+#include <netlink/genl/genl.h>
+#include <netlink/genl/mngt.h>
+
+#include "task_diag.h"
+#include "taskstats.h"
+#include "task_diag_comm.h"
+
+int main(int argc, char *argv[])
+{
+	struct nl_sock *sock;
+	int exit_status = 1;
+	int id;
+	struct task_diag_pid req;
+	struct nl_msg *msg;
+	void *hdr;
+	int err;
+
+
+	req.pid = 0;
+	if (argc >= 2)
+		req.pid = atoi(argv[1]);
+	if (req.pid == 0) {
+		pr_err("Usage: %s PID\n", argv[0]);
+		return 1;
+	}
+	req.show_flags = TASK_DIAG_SHOW_BASE | TASK_DIAG_SHOW_CRED |
+				TASK_DIAG_SHOW_VMA | TASK_DIAG_SHOW_VMA_STAT;
+
+	sock = nl_socket_alloc();
+	if (sock == NULL)
+		return -1;
+	nl_connect(sock, NETLINK_GENERIC);
+
+	err = genl_register_family(&ops);
+	if (err < 0) {
+		pr_err("Unable to register Generic Netlink family");
+		return -1;
+	}
+
+	err = genl_ops_resolve(sock, &ops);
+	if (err < 0) {
+		pr_err("Unable to resolve family name");
+		return -1;
+	}
+
+	id = genl_ctrl_resolve(sock, TASKSTATS_GENL_NAME);
+	if (id == GENL_ID_GENERATE)
+		return -1;
+
+	msg = nlmsg_alloc();
+	if (msg == NULL) {
+		pr_err("Unable to allocate netlink message");
+		return -1;
+	}
+
+	hdr = genlmsg_put(msg, NL_AUTO_PORT, NL_AUTO_SEQ, id,
+			  0, 0, TASK_DIAG_CMD_GET, 0);
+	if (hdr == NULL) {
+		pr_err("Unable to write genl header");
+		return -1;
+	}
+
+	err = nla_put(msg, TASKSTATS_CMD_GET,
+				sizeof(struct task_diag_pid), &req);
+	if (err < 0) {
+		pr_err("Unable to add attribute: %s", nl_geterror(err));
+		return -1;
+	}
+
+	err = nl_send_auto_complete(sock, msg);
+	if (err < 0) {
+		pr_err("Unable to send message: %s", nl_geterror(err));
+		return -1;
+	}
+
+	nlmsg_free(msg);
+
+	err = nl_socket_modify_cb(sock, NL_CB_VALID,
+				NL_CB_CUSTOM, parse_cb, NULL);
+	if (err < 0) {
+		pr_err("Unable to modify valid message callback");
+		goto err;
+	}
+
+
+	err = nl_recvmsgs_default(sock);
+	if (err < 0) {
+		pr_err("Unable to receive message: %s", nl_geterror(err));
+		goto err;
+	}
+
+	exit_status = 0;
+err:
+	nl_close(sock);
+	nl_socket_free(sock);
+	return exit_status;
+}
diff --git a/tools/testing/selftests/task_diag/task_diag.h b/tools/testing/selftests/task_diag/task_diag.h
new file mode 120000
index 0000000..d20a38c
--- /dev/null
+++ b/tools/testing/selftests/task_diag/task_diag.h
@@ -0,0 +1 @@
+../../../../include/uapi/linux/task_diag.h
\ No newline at end of file
diff --git a/tools/testing/selftests/task_diag/task_diag_all.c b/tools/testing/selftests/task_diag/task_diag_all.c
new file mode 100644
index 0000000..53eb713
--- /dev/null
+++ b/tools/testing/selftests/task_diag/task_diag_all.c
@@ -0,0 +1,145 @@
+#include <stdio.h>
+#include <stdlib.h>
+#include <errno.h>
+#include <unistd.h>
+#include <poll.h>
+#include <string.h>
+#include <fcntl.h>
+#include <sys/types.h>
+#include <sys/stat.h>
+#include <sys/socket.h>
+#include <sys/wait.h>
+#include <signal.h>
+#include <dirent.h>
+
+#include <linux/netlink.h>
+#include <netlink/socket.h>
+#include <linux/genetlink.h>
+#include <netlink/genl/ctrl.h>
+#include <netlink/genl/genl.h>
+#include <netlink/genl/mngt.h>
+
+#include "task_diag.h"
+#include "taskstats.h"
+#include "task_diag_comm.h"
+
+int main(int argc, char *argv[])
+{
+	struct nl_sock *sock;
+	int exit_status = 1;
+	int id;
+	struct task_diag_pid req;
+	struct nl_msg *msg;
+	__u32 last_pid = 0;
+	void *hdr;
+	int err;
+
+	req.show_flags = TASK_DIAG_SHOW_BASE | TASK_DIAG_SHOW_CRED |
+				TASK_DIAG_SHOW_VMA | TASK_DIAG_SHOW_VMA_STAT;
+
+	if (argc < 2) {
+		pr_err("Usage: %s type pid", argv[0]);
+		return 1;
+	}
+
+	req.pid = 0; /* dump all tasks by default */
+	if (argc > 2)
+		req.pid = atoi(argv[2]);
+
+	switch (argv[1][0]) {
+	case 'c':
+		req.dump_strategy = TASK_DIAG_DUMP_CHILDREN;
+		break;
+	case 't':
+		req.dump_strategy = TASK_DIAG_DUMP_THREAD;
+		break;
+	case 'o':
+		req.dump_strategy = TASK_DIAG_DUMP_ONE;
+		break;
+	case 'a':
+		req.dump_strategy = TASK_DIAG_DUMP_ALL;
+		req.pid = 0;
+		break;
+	case 'A':
+		req.dump_strategy = TASK_DIAG_DUMP_ALL_THREAD;
+		req.pid = 0;
+		break;
+	default:
+		pr_err("Usage: %s type pid", argv[0]);
+		return 1;
+	}
+
+	sock = nl_socket_alloc();
+	if (sock == NULL)
+		return -1;
+	nl_connect(sock, NETLINK_GENERIC);
+
+	err = genl_register_family(&ops);
+	if (err < 0) {
+		pr_err("Unable to register Generic Netlink family");
+		return -1;
+	}
+
+	err = genl_ops_resolve(sock, &ops);
+	if (err < 0) {
+		pr_err("Unable to resolve family name");
+		return -1;
+	}
+
+	id = genl_ctrl_resolve(sock, TASKSTATS_GENL_NAME);
+	if (id == GENL_ID_GENERATE)
+		return -1;
+
+	msg = nlmsg_alloc();
+	if (msg == NULL) {
+		pr_err("Unable to allocate netlink message");
+		return -1;
+	}
+
+	hdr = genlmsg_put(msg, NL_AUTO_PORT, NL_AUTO_SEQ, id,
+			  0, NLM_F_DUMP, TASK_DIAG_CMD_GET, 0);
+	if (hdr == NULL) {
+		pr_err("Unable to write genl header");
+		return -1;
+	}
+
+	err = nla_put(msg, TASKSTATS_CMD_GET, sizeof(req), &req);
+	if (err < 0) {
+		pr_err("Unable to add attribute: %s", nl_geterror(err));
+		return -1;
+	}
+
+	err = nl_send_auto_complete(sock, msg);
+	if (err < 0) {
+		pr_err("Unable to send message: %s", nl_geterror(err));
+		return -1;
+	}
+
+	nlmsg_free(msg);
+
+	err = nl_socket_modify_cb(sock, NL_CB_VALID, NL_CB_CUSTOM,
+			parse_cb, &last_pid);
+	if (err < 0) {
+		pr_err("Unable to modify valid message callback");
+		goto err;
+	}
+	err = nl_socket_modify_cb(sock, NL_CB_FINISH, NL_CB_CUSTOM,
+			parse_cb, &last_pid);
+	if (err < 0) {
+		pr_err("Unable to modify valid message callback");
+		goto err;
+	}
+
+
+	err = nl_recvmsgs_default(sock);
+	if (err < 0) {
+		pr_err("Unable to receive message: %s", nl_geterror(err));
+		goto err;
+	}
+
+	exit_status = 0;
+err:
+	nl_close(sock);
+	nl_socket_free(sock);
+	return exit_status;
+}
diff --git a/tools/testing/selftests/task_diag/task_diag_comm.c b/tools/testing/selftests/task_diag/task_diag_comm.c
new file mode 100644
index 0000000..480c7cf
--- /dev/null
+++ b/tools/testing/selftests/task_diag/task_diag_comm.c
@@ -0,0 +1,157 @@
+#include <errno.h>
+#include <string.h>
+#include <unistd.h>
+
+#include <sys/types.h>
+#include <sys/socket.h>
+#include <linux/netlink.h>
+#include <linux/genetlink.h>
+#include <netlink/cli/utils.h>
+
+#include "task_diag.h"
+#include "taskstats.h"
+#include "task_diag_comm.h"
+
+int quiet;
+
+static struct nla_policy attr_policy[TASK_DIAG_ATTR_MAX + 1] = {
+	[TASK_DIAG_PID] = { .type = NLA_U32},
+	[TASK_DIAG_BASE] = { .minlen = sizeof(struct task_diag_base) },
+	[TASK_DIAG_CRED] = { .minlen = sizeof(struct task_diag_creds) },
+};
+
+#define PSS_SHIFT 12
+static int parse_cmd_new(struct nl_cache_ops *unused, struct genl_cmd *cmd,
+			 struct genl_info *info, void *arg)
+{
+	struct nlattr **attrs;
+
+	attrs = info->attrs;
+	__u32 *last_pid = (__u32 *)arg, pid;
+
+	if (arg) {
+		pid = *((__u32 *)nla_data(attrs[TASK_DIAG_PID]));
+
+		if (pid != *last_pid)
+			pr_info("Start getting information about %d\n", pid);
+		else
+			pr_info("Continue getting information about %d\n", pid);
+
+		*last_pid = pid;
+	}
+
+	if (attrs[TASK_DIAG_BASE]) {
+		struct task_diag_base *msg;
+
+		/* For nested attributes, na follows */
+		msg = nla_data(attrs[TASK_DIAG_BASE]);
+		pr_info("pid %d tgid %d ppid %d comm %s\n",
+			msg->pid, msg->tgid, msg->ppid, msg->comm);
+	}
+
+	if (attrs[TASK_DIAG_CRED]) {
+		struct task_diag_creds *creds;
+
+		creds = nla_data(attrs[TASK_DIAG_CRED]);
+		pr_info("uid: %d %d %d %d\n", creds->uid,
+				creds->euid, creds->suid, creds->fsuid);
+		pr_info("gid: %d %d %d %d\n", creds->uid,
+				creds->euid, creds->suid, creds->fsuid);
+		pr_info("CapInh: %08x%08x\n",
+					creds->cap_inheritable.cap[1],
+					creds->cap_inheritable.cap[0]);
+		pr_info("CapPrm: %08x%08x\n",
+					creds->cap_permitted.cap[1],
+					creds->cap_permitted.cap[0]);
+		pr_info("CapEff: %08x%08x\n",
+					creds->cap_effective.cap[1],
+					creds->cap_effective.cap[0]);
+		pr_info("CapBnd: %08x%08x\n", creds->cap_bset.cap[1],
+					creds->cap_bset.cap[0]);
+	}
+
+	if (attrs[TASK_DIAG_VMA]) {
+		struct task_diag_vma *vma_tmp, vma;
+
+		task_diag_for_each_vma(vma_tmp, attrs[TASK_DIAG_VMA]) {
+			char *name;
+			struct task_diag_vma_stat *stat_tmp, stat;
+
+			name = task_diag_vma_name(vma_tmp);
+			if (name == NULL)
+				name = "";
+
+			memcpy(&vma, vma_tmp, sizeof(vma));
+			pr_info("%016llx-%016llx %016llx %s\n",
+				vma.start, vma.end, vma.vm_flags, name);
+
+			stat_tmp = task_diag_vma_stat(vma_tmp);
+			if (stat_tmp)
+				memcpy(&stat, stat_tmp, sizeof(stat));
+			else
+				memset(&stat, 0, sizeof(stat));
+
+			pr_info(
+				   "Size:           %8llu kB\n"
+				   "Rss:            %8llu kB\n"
+				   "Pss:            %8llu kB\n"
+				   "Shared_Clean:   %8llu kB\n"
+				   "Shared_Dirty:   %8llu kB\n"
+				   "Private_Clean:  %8llu kB\n"
+				   "Private_Dirty:  %8llu kB\n"
+				   "Referenced:     %8llu kB\n"
+				   "Anonymous:      %8llu kB\n"
+				   "AnonHugePages:  %8llu kB\n"
+				   "Swap:           %8llu kB\n",
+				   (vma.end - vma.start) >> 10,
+				   stat.resident >> 10,
+				   (stat.pss >> (10 + PSS_SHIFT)),
+				   stat.shared_clean  >> 10,
+				   stat.shared_dirty  >> 10,
+				   stat.private_clean >> 10,
+				   stat.private_dirty >> 10,
+				   stat.referenced >> 10,
+				   stat.anonymous >> 10,
+				   stat.anonymous_thp >> 10,
+				   stat.swap >> 10);
+		}
+	}
+
+	return 0;
+}
+
+static struct genl_cmd cmds[] = {
+	{
+		.c_id	   = TASK_DIAG_CMD_GET,
+		.c_name	 = "taskstats_new()",
+		.c_maxattr      = TASK_DIAG_ATTR_MAX,
+		.c_attr_policy  = attr_policy,
+		.c_msg_parser   = &parse_cmd_new,
+	},
+};
+
+#define ARRAY_SIZE(X) (sizeof(X) / sizeof((X)[0]))
+
+struct genl_ops ops = {
+	.o_name = TASKSTATS_GENL_NAME,
+	.o_cmds = cmds,
+	.o_ncmds = ARRAY_SIZE(cmds),
+};
+
+int parse_cb(struct nl_msg *msg, void *arg)
+{
+	struct nlmsghdr *hdr = nlmsg_hdr(msg);
+
+	if (hdr->nlmsg_type == NLMSG_DONE) {
+		int *ret = nlmsg_data(hdr);
+
+		if (*ret < 0) {
+			pr_err("An error message is received: %s\n",
+							strerror(-*ret));
+			return *ret;
+		}
+		return 0;
+	}
+
+	return genl_handle_msg(msg, arg);
+}
diff --git a/tools/testing/selftests/task_diag/task_diag_comm.h b/tools/testing/selftests/task_diag/task_diag_comm.h
new file mode 100644
index 0000000..5f6ba07
--- /dev/null
+++ b/tools/testing/selftests/task_diag/task_diag_comm.h
@@ -0,0 +1,33 @@
+#ifndef __TASK_DIAG_COMM__
+#define __TASK_DIAG_COMM__
+
+#include <stdio.h>
+
+#include <linux/genetlink.h>
+#include "task_diag.h"
+
+/*
+ * Generic macros for dealing with netlink sockets. Might be duplicated
+ * elsewhere. It is recommended that commercial grade applications use
+ * libnl or libnetlink and use the interfaces provided by the library
+ */
+#define GENLMSG_DATA(glh)	((void *)(NLMSG_DATA(glh) + GENL_HDRLEN))
+#define GENLMSG_PAYLOAD(glh)	(NLMSG_PAYLOAD(glh, 0) - GENL_HDRLEN)
+
+#define pr_err(fmt, ...)				\
+		fprintf(stderr, fmt"\n", ##__VA_ARGS__)
+
+#define pr_perror(fmt, ...)				\
+		fprintf(stderr, fmt " : %m\n", ##__VA_ARGS__)
+
+extern int quiet;
+#define pr_info(fmt, arg...)			\
+	do {					\
+		if (!quiet)			\
+			printf(fmt, ##arg);	\
+	} while (0)				\
+
+struct genl_ops ops;
+int parse_cb(struct nl_msg *msg, void *arg);
+
+#endif /* __TASK_DIAG_COMM__ */
diff --git a/tools/testing/selftests/task_diag/task_proc_all.c b/tools/testing/selftests/task_diag/task_proc_all.c
new file mode 100644
index 0000000..07ee80c
--- /dev/null
+++ b/tools/testing/selftests/task_diag/task_proc_all.c
@@ -0,0 +1,35 @@
+#include <stdio.h>
+#include <unistd.h>
+#include <sys/types.h>
+#include <dirent.h>
+#include <sys/stat.h>
+#include <fcntl.h>
+
+
+int main(int argc, char **argv)
+{
+	DIR *d;
+	int fd, tasks = 0;
+	struct dirent *de;
+	char buf[4096];
+
+	d = opendir("/proc");
+	if (d == NULL)
+		return 1;
+
+	while ((de = readdir(d))) {
+		if (de->d_name[0] < '0' || de->d_name[0] > '9')
+			continue;
+		snprintf(buf, sizeof(buf), "/proc/%s/stat", de->d_name);
+		fd = open(buf, O_RDONLY);
+		read(fd, buf, sizeof(buf));
+		close(fd);
+		tasks++;
+	}
+
+	closedir(d);
+
+	printf("tasks: %d\n", tasks);
+
+	return 0;
+}
diff --git a/tools/testing/selftests/task_diag/taskstats.h b/tools/testing/selftests/task_diag/taskstats.h
new file mode 120000
index 0000000..fa9523b
--- /dev/null
+++ b/tools/testing/selftests/task_diag/taskstats.h
@@ -0,0 +1 @@
+../../../../include/uapi/linux/taskstats.h
\ No newline at end of file
-- 
2.1.0
