From: Andrey Vagin <avagin@openvz.org>
Subject: [PATCH 7/7] selftest: check the task_diag functinonality
Date: Tue, 17 Feb 2015 11:20:26 +0300
Message-ID: <1424161226-15176-8-git-send-email-avagin@openvz.org>
References: <1424161226-15176-1-git-send-email-avagin@openvz.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1424161226-15176-1-git-send-email-avagin@openvz.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: linux-api@vger.kernel.org, Oleg Nesterov <oleg@redhat.com>, Andrew Morton <akpm@linux-foundation.org>, Cyrill Gorcunov <gorcunov@openvz.org>, Pavel Emelyanov <xemul@parallels.com>, Roger Luethi <rl@hellgate.ch>, Andrey Vagin <avagin@openvz.org>
List-Id: linux-api@vger.kernel.org

Here are two test (example) programs.

task_diag - request information for two processes.
test_diag_all - request information about all processes

Signed-off-by: Andrey Vagin <avagin@openvz.org>
---
 tools/testing/selftests/Makefile                   |   1 +
 tools/testing/selftests/task_diag/Makefile         |  16 ++
 tools/testing/selftests/task_diag/task_diag.c      |  56 ++++++
 tools/testing/selftests/task_diag/task_diag_all.c  |  82 ++++++++
 tools/testing/selftests/task_diag/task_diag_comm.c | 206 +++++++++++++++++++++
 tools/testing/selftests/task_diag/task_diag_comm.h |  47 +++++
 tools/testing/selftests/task_diag/taskdiag.h       |   1 +
 7 files changed, 409 insertions(+)
 create mode 100644 tools/testing/selftests/task_diag/Makefile
 create mode 100644 tools/testing/selftests/task_diag/task_diag.c
 create mode 100644 tools/testing/selftests/task_diag/task_diag_all.c
 create mode 100644 tools/testing/selftests/task_diag/task_diag_comm.c
 create mode 100644 tools/testing/selftests/task_diag/task_diag_comm.h
 create mode 120000 tools/testing/selftests/task_diag/taskdiag.h

diff --git a/tools/testing/selftests/Makefile b/tools/testing/selftests/Makefile
index 4e51122..c73d888 100644
--- a/tools/testing/selftests/Makefile
+++ b/tools/testing/selftests/Makefile
@@ -17,6 +17,7 @@ TARGETS += sysctl
 TARGETS += timers
 TARGETS += user
 TARGETS += vm
+TARGETS += task_diag
 #Please keep the TARGETS list alphabetically sorted
 
 TARGETS_HOTPLUG = cpu-hotplug
diff --git a/tools/testing/selftests/task_diag/Makefile b/tools/testing/selftests/task_diag/Makefile
new file mode 100644
index 0000000..d6583c4
--- /dev/null
+++ b/tools/testing/selftests/task_diag/Makefile
@@ -0,0 +1,16 @@
+all: task_diag task_diag_all
+
+run_tests: all
+	@./task_diag && ./task_diag_all && echo "task_diag: [PASS]" || echo "task_diag: [FAIL]"
+
+CFLAGS += -Wall -O2
+
+task_diag.o: task_diag.c task_diag_comm.h
+task_diag_all.o: task_diag_all.c task_diag_comm.h
+task_diag_comm.o: task_diag_comm.c task_diag_comm.h
+
+task_diag_all: task_diag_all.o task_diag_comm.o
+task_diag: task_diag.o task_diag_comm.o
+
+clean:
+	rm -rf task_diag task_diag_all task_diag_comm.o task_diag_all.o task_diag.o
diff --git a/tools/testing/selftests/task_diag/task_diag.c b/tools/testing/selftests/task_diag/task_diag.c
new file mode 100644
index 0000000..fafeeac
--- /dev/null
+++ b/tools/testing/selftests/task_diag/task_diag.c
@@ -0,0 +1,56 @@
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
+
+#include <linux/genetlink.h>
+#include "taskdiag.h"
+#include "task_diag_comm.h"
+
+int main(int argc, char *argv[])
+{
+	int exit_status = 1;
+	int rc, rep_len, id;
+	int nl_sd = -1;
+	struct task_diag_pid req;
+	char buf[4096];
+
+	req.show_flags = TASK_DIAG_SHOW_CRED;
+	req.pid = getpid();
+
+	nl_sd = create_nl_socket(NETLINK_GENERIC);
+	if (nl_sd < 0)
+		return -1;
+
+	id = get_family_id(nl_sd);
+	if (!id)
+		goto err;
+
+	rc = send_cmd(nl_sd, id, getpid(), TASKDIAG_CMD_GET,
+		      TASKDIAG_CMD_ATTR_GET, &req, sizeof(req), 0);
+	pr_info("Sent pid/tgid, retval %d\n", rc);
+	if (rc < 0)
+		goto err;
+
+	rep_len = recv(nl_sd, buf, sizeof(buf), 0);
+	if (rep_len < 0) {
+		pr_perror("Unable to receive a response\n");
+		goto err;
+	}
+	pr_info("received %d bytes\n", rep_len);
+
+	nlmsg_receive(buf, rep_len, &show_task);
+
+	exit_status = 0;
+err:
+	close(nl_sd);
+	return exit_status;
+}
diff --git a/tools/testing/selftests/task_diag/task_diag_all.c b/tools/testing/selftests/task_diag/task_diag_all.c
new file mode 100644
index 0000000..85e1a0a
--- /dev/null
+++ b/tools/testing/selftests/task_diag/task_diag_all.c
@@ -0,0 +1,82 @@
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
+
+#include "task_diag_comm.h"
+#include "taskdiag.h"
+
+int tasks;
+
+
+extern int _show_task(struct nlmsghdr *hdr)
+{
+	tasks++;
+	return show_task(hdr);
+}
+
+int main(int argc, char *argv[])
+{
+	int exit_status = 1;
+	int rc, rep_len, id;
+	int nl_sd = -1;
+	struct {
+		struct task_diag_pid req;
+	} pid_req;
+	char buf[4096];
+
+	quiet = 0;
+
+	pid_req.req.show_flags = 0;
+	pid_req.req.dump_stratagy = TASK_DIAG_DUMP_ALL;
+	pid_req.req.pid = 1;
+
+	nl_sd = create_nl_socket(NETLINK_GENERIC);
+	if (nl_sd < 0)
+		return -1;
+
+	id = get_family_id(nl_sd);
+	if (!id)
+		goto err;
+
+	rc = send_cmd(nl_sd, id, getpid(), TASKDIAG_CMD_GET,
+		      TASKDIAG_CMD_ATTR_GET, &pid_req, sizeof(pid_req), 1);
+	pr_info("Sent pid/tgid, retval %d\n", rc);
+	if (rc < 0)
+		goto err;
+
+	while (1) {
+		int err;
+
+		rep_len = recv(nl_sd, buf, sizeof(buf), 0);
+		pr_info("received %d bytes\n", rep_len);
+
+		if (rep_len < 0) {
+			pr_perror("Unable to receive a response\n");
+			goto err;
+		}
+
+		if (rep_len == 0)
+			break;
+
+		err = nlmsg_receive(buf, rep_len, &_show_task);
+		if (err < 0)
+			goto err;
+		if (err == 0)
+			break;
+	}
+	printf("tasks: %d\n", tasks);
+
+	exit_status = 0;
+err:
+	close(nl_sd);
+	return exit_status;
+}
diff --git a/tools/testing/selftests/task_diag/task_diag_comm.c b/tools/testing/selftests/task_diag/task_diag_comm.c
new file mode 100644
index 0000000..df7780d
--- /dev/null
+++ b/tools/testing/selftests/task_diag/task_diag_comm.c
@@ -0,0 +1,206 @@
+#include <errno.h>
+#include <string.h>
+#include <unistd.h>
+
+#include <sys/types.h>
+#include <sys/socket.h>
+#include <linux/genetlink.h>
+
+#include "taskdiag.h"
+#include "task_diag_comm.h"
+
+int quiet = 0;
+
+/*
+ * Create a raw netlink socket and bind
+ */
+int create_nl_socket(int protocol)
+{
+	int fd;
+	struct sockaddr_nl local;
+
+	fd = socket(AF_NETLINK, SOCK_RAW, protocol);
+	if (fd < 0)
+		return -1;
+
+	memset(&local, 0, sizeof(local));
+	local.nl_family = AF_NETLINK;
+
+	if (bind(fd, (struct sockaddr *) &local, sizeof(local)) < 0)
+		goto error;
+
+	return fd;
+error:
+	close(fd);
+	return -1;
+}
+
+
+int send_cmd(int sd, __u16 nlmsg_type, __u32 nlmsg_pid,
+	     __u8 genl_cmd, __u16 nla_type,
+	     void *nla_data, int nla_len, int dump)
+{
+	struct nlattr *na;
+	struct sockaddr_nl nladdr;
+	int r, buflen;
+	char *buf;
+
+	struct msgtemplate msg;
+
+	msg.n.nlmsg_len = NLMSG_LENGTH(GENL_HDRLEN);
+	msg.n.nlmsg_type = nlmsg_type;
+	msg.n.nlmsg_flags = NLM_F_REQUEST;
+	if (dump)
+		msg.n.nlmsg_flags |= NLM_F_DUMP;
+	msg.n.nlmsg_seq = 0;
+	msg.n.nlmsg_pid = nlmsg_pid;
+	msg.g.cmd = genl_cmd;
+	msg.g.version = 0x1;
+	na = (struct nlattr *) GENLMSG_DATA(&msg);
+	na->nla_type = nla_type;
+	na->nla_len = nla_len + 1 + NLA_HDRLEN;
+	memcpy(NLA_DATA(na), nla_data, nla_len);
+	msg.n.nlmsg_len += NLMSG_ALIGN(na->nla_len);
+
+	buf = (char *) &msg;
+	buflen = msg.n.nlmsg_len;
+	memset(&nladdr, 0, sizeof(nladdr));
+	nladdr.nl_family = AF_NETLINK;
+	r = sendto(sd, buf, buflen, 0, (struct sockaddr *) &nladdr,
+			   sizeof(nladdr));
+	if (r != buflen) {
+		pr_perror("Unable to send %d (%d)", r, buflen);
+		return -1;
+	}
+	return 0;
+}
+
+
+/*
+ * Probe the controller in genetlink to find the family id
+ * for the TASKDIAG family
+ */
+int get_family_id(int sd)
+{
+	char name[100];
+	struct msgtemplate ans;
+
+	int id = 0, rc;
+	struct nlattr *na;
+	int rep_len;
+
+	strcpy(name, TASKDIAG_GENL_NAME);
+	rc = send_cmd(sd, GENL_ID_CTRL, getpid(), CTRL_CMD_GETFAMILY,
+			CTRL_ATTR_FAMILY_NAME, (void *)name,
+			strlen(TASKDIAG_GENL_NAME) + 1, 0);
+	if (rc < 0)
+		return -1;
+
+	rep_len = recv(sd, &ans, sizeof(ans), 0);
+	if (ans.n.nlmsg_type == NLMSG_ERROR ||
+	    (rep_len < 0) || !NLMSG_OK((&ans.n), rep_len))
+		return 0;
+
+	na = (struct nlattr *) GENLMSG_DATA(&ans);
+	na = (struct nlattr *) ((char *) na + NLA_ALIGN(na->nla_len));
+	if (na->nla_type == CTRL_ATTR_FAMILY_ID)
+		id = *(__u16 *) NLA_DATA(na);
+
+	return id;
+}
+
+int nlmsg_receive(void *buf, int len, int (*cb)(struct nlmsghdr *))
+{
+	struct nlmsghdr *hdr;
+
+	for (hdr = (struct nlmsghdr *)buf;
+			NLMSG_OK(hdr, len); hdr = NLMSG_NEXT(hdr, len)) {
+
+		if (hdr->nlmsg_type == NLMSG_DONE) {
+			int *len = (int *)NLMSG_DATA(hdr);
+
+			if (*len < 0) {
+				pr_err("ERROR %d reported by netlink (%s)\n",
+					*len, strerror(-*len));
+				return *len;
+			}
+
+			return 0;
+		}
+
+		if (hdr->nlmsg_type == NLMSG_ERROR) {
+			struct nlmsgerr *err = (struct nlmsgerr *)NLMSG_DATA(hdr);
+
+			if (hdr->nlmsg_len - sizeof(*hdr) < sizeof(struct nlmsgerr)) {
+				pr_err("ERROR truncated\n");
+				return -1;
+			}
+
+			if (err->error == 0)
+				return 0;
+
+			return -1;
+		}
+		if (cb && cb(hdr))
+			return -1;
+	}
+
+	return 1;
+}
+
+int show_task(struct nlmsghdr *hdr)
+{
+	int msg_len;
+	struct msgtemplate *msg;
+	struct nlattr *na;
+	int len;
+
+	msg_len = GENLMSG_PAYLOAD(hdr);
+
+	msg = (struct msgtemplate *)hdr;
+	na = (struct nlattr *) GENLMSG_DATA(msg);
+	len = 0;
+	while (len < msg_len) {
+		len += NLA_ALIGN(na->nla_len);
+		switch (na->nla_type) {
+		case TASK_DIAG_MSG:
+		{
+			struct task_diag_msg *msg;
+
+			/* For nested attributes, na follows */
+			msg = (struct task_diag_msg *) NLA_DATA(na);
+			pr_info("pid %d ppid %d comm %s\n", msg->pid, msg->ppid, msg->comm);
+			break;
+		}
+		case TASK_DIAG_CRED:
+		{
+			struct task_diag_creds *creds;
+
+			creds = (struct task_diag_creds *) NLA_DATA(na);
+			pr_info("uid: %d %d %d %d\n", creds->uid,
+					creds->euid, creds->suid, creds->fsuid);
+			pr_info("gid: %d %d %d %d\n", creds->uid,
+					creds->euid, creds->suid, creds->fsuid);
+			pr_info("CapInh: %08x%08x\n",
+						creds->cap_inheritable.cap[1],
+						creds->cap_inheritable.cap[0]);
+			pr_info("CapPrm: %08x%08x\n",
+						creds->cap_permitted.cap[1],
+						creds->cap_permitted.cap[0]);
+			pr_info("CapEff: %08x%08x\n",
+						creds->cap_effective.cap[1],
+						creds->cap_effective.cap[0]);
+			pr_info("CapBnd: %08x%08x\n", creds->cap_bset.cap[1],
+						creds->cap_bset.cap[0]);
+			break;
+		}
+		default:
+			pr_err("Unknown nla_type %d\n",
+				na->nla_type);
+			return -1;
+		}
+		na = (struct nlattr *) (GENLMSG_DATA(msg) + len);
+	}
+
+	return 0;
+}
diff --git a/tools/testing/selftests/task_diag/task_diag_comm.h b/tools/testing/selftests/task_diag/task_diag_comm.h
new file mode 100644
index 0000000..42f2088
--- /dev/null
+++ b/tools/testing/selftests/task_diag/task_diag_comm.h
@@ -0,0 +1,47 @@
+#ifndef __TASK_DIAG_COMM__
+#define __TASK_DIAG_COMM__
+
+#include <stdio.h>
+
+#include <linux/genetlink.h>
+#include "taskdiag.h"
+
+/*
+ * Generic macros for dealing with netlink sockets. Might be duplicated
+ * elsewhere. It is recommended that commercial grade applications use
+ * libnl or libnetlink and use the interfaces provided by the library
+ */
+#define GENLMSG_DATA(glh)	((void *)(NLMSG_DATA(glh) + GENL_HDRLEN))
+#define GENLMSG_PAYLOAD(glh)	(NLMSG_PAYLOAD(glh, 0) - GENL_HDRLEN)
+#define NLA_DATA(na)		((void *)((char *)(na) + NLA_HDRLEN))
+#define NLA_PAYLOAD(len)	(len - NLA_HDRLEN)
+
+#define pr_err(fmt, ...)				\
+		fprintf(stderr, fmt, ##__VA_ARGS__)
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
+struct msgtemplate {
+	struct nlmsghdr n;
+	struct genlmsghdr g;
+	char body[4096];
+};
+
+extern int create_nl_socket(int protocol);
+extern int send_cmd(int sd, __u16 nlmsg_type, __u32 nlmsg_pid,
+	     __u8 genl_cmd, __u16 nla_type,
+	     void *nla_data, int nla_len, int dump);
+
+extern int get_family_id(int sd);
+extern int nlmsg_receive(void *buf, int len, int (*cb)(struct nlmsghdr *));
+extern int show_task(struct nlmsghdr *hdr);
+
+#endif /* __TASK_DIAG_COMM__ */
diff --git a/tools/testing/selftests/task_diag/taskdiag.h b/tools/testing/selftests/task_diag/taskdiag.h
new file mode 120000
index 0000000..83e857e
--- /dev/null
+++ b/tools/testing/selftests/task_diag/taskdiag.h
@@ -0,0 +1 @@
+../../../../include/uapi/linux/taskdiag.h
\ No newline at end of file
-- 
2.1.0
