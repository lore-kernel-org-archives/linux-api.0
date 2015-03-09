From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 14/14] kdbus: add selftests
Date: Mon,  9 Mar 2015 14:09:20 +0100
Message-ID: <1425906560-13798-15-git-send-email-gregkh@linuxfoundation.org>
References: <1425906560-13798-1-git-send-email-gregkh@linuxfoundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1425906560-13798-1-git-send-email-gregkh@linuxfoundation.org>
Sender: linux-kernel-owner@vger.kernel.org
To: arnd@arndb.de, ebiederm@xmission.com, gnomes@lxorguk.ukuu.org.uk, teg@jklm.no, jkosina@suse.cz, luto@amacapital.net, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: daniel@zonque.org, dh.herrmann@gmail.com, tixxdz@opendz.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>
List-Id: linux-api@vger.kernel.org

=46rom: Daniel Mack <daniel@zonque.org>

This patch adds an extensive test suite for kdbus that checks the most
important code paths in the driver. The idea is to extend the test
suite over time.

Also, this code can serve as another example for how to use the kernel
API from userspace.

The code in the kdbus test suite makes use of the ioctl wrappers
provided by samples/kdbus/kdbus-api.h.

Signed-off-by: Daniel Mack <daniel@zonque.org>
Signed-off-by: David Herrmann <dh.herrmann@gmail.com>
Signed-off-by: Djalal Harouni <tixxdz@opendz.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/Makefile                  |    1 +
 tools/testing/selftests/kdbus/.gitignore          |    3 +
 tools/testing/selftests/kdbus/Makefile            |   46 +
 tools/testing/selftests/kdbus/kdbus-enum.c        |   94 ++
 tools/testing/selftests/kdbus/kdbus-enum.h        |   14 +
 tools/testing/selftests/kdbus/kdbus-test.c        |  923 ++++++++++++
 tools/testing/selftests/kdbus/kdbus-test.h        |   85 ++
 tools/testing/selftests/kdbus/kdbus-util.c        | 1615 +++++++++++++=
++++++++
 tools/testing/selftests/kdbus/kdbus-util.h        |  222 +++
 tools/testing/selftests/kdbus/test-activator.c    |  318 ++++
 tools/testing/selftests/kdbus/test-attach-flags.c |  750 ++++++++++
 tools/testing/selftests/kdbus/test-benchmark.c    |  451 ++++++
 tools/testing/selftests/kdbus/test-bus.c          |  175 +++
 tools/testing/selftests/kdbus/test-chat.c         |  122 ++
 tools/testing/selftests/kdbus/test-connection.c   |  616 ++++++++
 tools/testing/selftests/kdbus/test-daemon.c       |   65 +
 tools/testing/selftests/kdbus/test-endpoint.c     |  341 +++++
 tools/testing/selftests/kdbus/test-fd.c           |  789 ++++++++++
 tools/testing/selftests/kdbus/test-free.c         |   64 +
 tools/testing/selftests/kdbus/test-match.c        |  441 ++++++
 tools/testing/selftests/kdbus/test-message.c      |  731 ++++++++++
 tools/testing/selftests/kdbus/test-metadata-ns.c  |  506 +++++++
 tools/testing/selftests/kdbus/test-monitor.c      |  176 +++
 tools/testing/selftests/kdbus/test-names.c        |  194 +++
 tools/testing/selftests/kdbus/test-policy-ns.c    |  632 ++++++++
 tools/testing/selftests/kdbus/test-policy-priv.c  | 1269 +++++++++++++=
+++
 tools/testing/selftests/kdbus/test-policy.c       |   80 +
 tools/testing/selftests/kdbus/test-sync.c         |  369 +++++
 tools/testing/selftests/kdbus/test-timeout.c      |   99 ++
 29 files changed, 11191 insertions(+)
 create mode 100644 tools/testing/selftests/kdbus/.gitignore
 create mode 100644 tools/testing/selftests/kdbus/Makefile
 create mode 100644 tools/testing/selftests/kdbus/kdbus-enum.c
 create mode 100644 tools/testing/selftests/kdbus/kdbus-enum.h
 create mode 100644 tools/testing/selftests/kdbus/kdbus-test.c
 create mode 100644 tools/testing/selftests/kdbus/kdbus-test.h
 create mode 100644 tools/testing/selftests/kdbus/kdbus-util.c
 create mode 100644 tools/testing/selftests/kdbus/kdbus-util.h
 create mode 100644 tools/testing/selftests/kdbus/test-activator.c
 create mode 100644 tools/testing/selftests/kdbus/test-attach-flags.c
 create mode 100644 tools/testing/selftests/kdbus/test-benchmark.c
 create mode 100644 tools/testing/selftests/kdbus/test-bus.c
 create mode 100644 tools/testing/selftests/kdbus/test-chat.c
 create mode 100644 tools/testing/selftests/kdbus/test-connection.c
 create mode 100644 tools/testing/selftests/kdbus/test-daemon.c
 create mode 100644 tools/testing/selftests/kdbus/test-endpoint.c
 create mode 100644 tools/testing/selftests/kdbus/test-fd.c
 create mode 100644 tools/testing/selftests/kdbus/test-free.c
 create mode 100644 tools/testing/selftests/kdbus/test-match.c
 create mode 100644 tools/testing/selftests/kdbus/test-message.c
 create mode 100644 tools/testing/selftests/kdbus/test-metadata-ns.c
 create mode 100644 tools/testing/selftests/kdbus/test-monitor.c
 create mode 100644 tools/testing/selftests/kdbus/test-names.c
 create mode 100644 tools/testing/selftests/kdbus/test-policy-ns.c
 create mode 100644 tools/testing/selftests/kdbus/test-policy-priv.c
 create mode 100644 tools/testing/selftests/kdbus/test-policy.c
 create mode 100644 tools/testing/selftests/kdbus/test-sync.c
 create mode 100644 tools/testing/selftests/kdbus/test-timeout.c

diff --git a/tools/testing/selftests/Makefile b/tools/testing/selftests=
/Makefile
index 4e511221a0c1..7b51cceae9dd 100644
--- a/tools/testing/selftests/Makefile
+++ b/tools/testing/selftests/Makefile
@@ -5,6 +5,7 @@ TARGETS +=3D exec
 TARGETS +=3D firmware
 TARGETS +=3D ftrace
 TARGETS +=3D kcmp
+TARGETS +=3D kdbus
 TARGETS +=3D memfd
 TARGETS +=3D memory-hotplug
 TARGETS +=3D mount
diff --git a/tools/testing/selftests/kdbus/.gitignore b/tools/testing/s=
elftests/kdbus/.gitignore
new file mode 100644
index 000000000000..7b421f76c888
--- /dev/null
+++ b/tools/testing/selftests/kdbus/.gitignore
@@ -0,0 +1,3 @@
+*.7
+manpage.*
+*.proc
diff --git a/tools/testing/selftests/kdbus/Makefile b/tools/testing/sel=
ftests/kdbus/Makefile
new file mode 100644
index 000000000000..f6cfab26f315
--- /dev/null
+++ b/tools/testing/selftests/kdbus/Makefile
@@ -0,0 +1,46 @@
+CFLAGS +=3D -I../../../../usr/include/
+CFLAGS +=3D -I../../../../samples/kdbus/
+CFLAGS +=3D -I../../../../include/uapi/
+CFLAGS +=3D -std=3Dgnu99
+CFLAGS +=3D -DKBUILD_MODNAME=3D\"kdbus\" -D_GNU_SOURCE
+LDLIBS =3D -pthread -lcap -lm
+
+OBJS=3D \
+	kdbus-enum.o		\
+	kdbus-util.o		\
+	kdbus-test.o		\
+	kdbus-test.o		\
+	test-activator.o	\
+	test-attach-flags.o	\
+	test-benchmark.o	\
+	test-bus.o		\
+	test-chat.o		\
+	test-connection.o	\
+	test-daemon.o		\
+	test-endpoint.o		\
+	test-fd.o		\
+	test-free.o		\
+	test-match.o		\
+	test-message.o		\
+	test-metadata-ns.o	\
+	test-monitor.o		\
+	test-names.o		\
+	test-policy.o		\
+	test-policy-ns.o	\
+	test-policy-priv.o	\
+	test-sync.o		\
+	test-timeout.o
+
+all: kdbus-test
+
+%.o: %.c
+	gcc $(CFLAGS) -c $< -o $@
+
+kdbus-test: $(OBJS)
+	gcc $(CFLAGS) $^ $(LDLIBS) -o $@
+
+run_tests:
+	./kdbus-test --tap
+
+clean:
+	rm -f *.o kdbus-test
diff --git a/tools/testing/selftests/kdbus/kdbus-enum.c b/tools/testing=
/selftests/kdbus/kdbus-enum.c
new file mode 100644
index 000000000000..4f1e5797895f
--- /dev/null
+++ b/tools/testing/selftests/kdbus/kdbus-enum.c
@@ -0,0 +1,94 @@
+/*
+ * Copyright (C) 2013-2015 Kay Sievers
+ *
+ * kdbus is free software; you can redistribute it and/or modify it un=
der
+ * the terms of the GNU Lesser General Public License as published by =
the
+ * Free Software Foundation; either version 2.1 of the License, or (at
+ * your option) any later version.
+ */
+
+#include <stdio.h>
+#include <string.h>
+#include <fcntl.h>
+#include <stdlib.h>
+#include <stddef.h>
+#include <unistd.h>
+#include <stdint.h>
+#include <errno.h>
+
+#include "kdbus-util.h"
+#include "kdbus-enum.h"
+
+struct kdbus_enum_table {
+	long long id;
+	const char *name;
+};
+
+#define TABLE(what) static struct kdbus_enum_table kdbus_table_##what[=
]
+#define ENUM(_id) { .id =3D _id, .name =3D STRINGIFY(_id) }
+#define LOOKUP(what)							\
+	const char *enum_##what(long long id)				\
+	{								\
+		for (size_t i =3D 0; i < ELEMENTSOF(kdbus_table_##what); i++) \
+			if (id =3D=3D kdbus_table_##what[i].id)		\
+				return kdbus_table_##what[i].name;	\
+		return "UNKNOWN";					\
+	}
+
+TABLE(CMD) =3D {
+	ENUM(KDBUS_CMD_BUS_MAKE),
+	ENUM(KDBUS_CMD_ENDPOINT_MAKE),
+	ENUM(KDBUS_CMD_HELLO),
+	ENUM(KDBUS_CMD_SEND),
+	ENUM(KDBUS_CMD_RECV),
+	ENUM(KDBUS_CMD_LIST),
+	ENUM(KDBUS_CMD_NAME_RELEASE),
+	ENUM(KDBUS_CMD_CONN_INFO),
+	ENUM(KDBUS_CMD_MATCH_ADD),
+	ENUM(KDBUS_CMD_MATCH_REMOVE),
+};
+LOOKUP(CMD);
+
+TABLE(MSG) =3D {
+	ENUM(_KDBUS_ITEM_NULL),
+	ENUM(KDBUS_ITEM_PAYLOAD_VEC),
+	ENUM(KDBUS_ITEM_PAYLOAD_OFF),
+	ENUM(KDBUS_ITEM_PAYLOAD_MEMFD),
+	ENUM(KDBUS_ITEM_FDS),
+	ENUM(KDBUS_ITEM_BLOOM_PARAMETER),
+	ENUM(KDBUS_ITEM_BLOOM_FILTER),
+	ENUM(KDBUS_ITEM_DST_NAME),
+	ENUM(KDBUS_ITEM_MAKE_NAME),
+	ENUM(KDBUS_ITEM_ATTACH_FLAGS_SEND),
+	ENUM(KDBUS_ITEM_ATTACH_FLAGS_RECV),
+	ENUM(KDBUS_ITEM_ID),
+	ENUM(KDBUS_ITEM_NAME),
+	ENUM(KDBUS_ITEM_TIMESTAMP),
+	ENUM(KDBUS_ITEM_CREDS),
+	ENUM(KDBUS_ITEM_PIDS),
+	ENUM(KDBUS_ITEM_AUXGROUPS),
+	ENUM(KDBUS_ITEM_OWNED_NAME),
+	ENUM(KDBUS_ITEM_TID_COMM),
+	ENUM(KDBUS_ITEM_PID_COMM),
+	ENUM(KDBUS_ITEM_EXE),
+	ENUM(KDBUS_ITEM_CMDLINE),
+	ENUM(KDBUS_ITEM_CGROUP),
+	ENUM(KDBUS_ITEM_CAPS),
+	ENUM(KDBUS_ITEM_SECLABEL),
+	ENUM(KDBUS_ITEM_AUDIT),
+	ENUM(KDBUS_ITEM_CONN_DESCRIPTION),
+	ENUM(KDBUS_ITEM_NAME_ADD),
+	ENUM(KDBUS_ITEM_NAME_REMOVE),
+	ENUM(KDBUS_ITEM_NAME_CHANGE),
+	ENUM(KDBUS_ITEM_ID_ADD),
+	ENUM(KDBUS_ITEM_ID_REMOVE),
+	ENUM(KDBUS_ITEM_REPLY_TIMEOUT),
+	ENUM(KDBUS_ITEM_REPLY_DEAD),
+};
+LOOKUP(MSG);
+
+TABLE(PAYLOAD) =3D {
+	ENUM(KDBUS_PAYLOAD_KERNEL),
+	ENUM(KDBUS_PAYLOAD_DBUS),
+};
+LOOKUP(PAYLOAD);
diff --git a/tools/testing/selftests/kdbus/kdbus-enum.h b/tools/testing=
/selftests/kdbus/kdbus-enum.h
new file mode 100644
index 000000000000..a67cec3512a7
--- /dev/null
+++ b/tools/testing/selftests/kdbus/kdbus-enum.h
@@ -0,0 +1,14 @@
+/*
+ * Copyright (C) 2013-2015 Kay Sievers
+ *
+ * kdbus is free software; you can redistribute it and/or modify it un=
der
+ * the terms of the GNU Lesser General Public License as published by =
the
+ * Free Software Foundation; either version 2.1 of the License, or (at
+ * your option) any later version.
+ */
+#pragma once
+
+const char *enum_CMD(long long id);
+const char *enum_MSG(long long id);
+const char *enum_MATCH(long long id);
+const char *enum_PAYLOAD(long long id);
diff --git a/tools/testing/selftests/kdbus/kdbus-test.c b/tools/testing=
/selftests/kdbus/kdbus-test.c
new file mode 100644
index 000000000000..a43674ccdeb0
--- /dev/null
+++ b/tools/testing/selftests/kdbus/kdbus-test.c
@@ -0,0 +1,923 @@
+#include <errno.h>
+#include <stdio.h>
+#include <string.h>
+#include <fcntl.h>
+#include <stdlib.h>
+#include <stddef.h>
+#include <time.h>
+#include <unistd.h>
+#include <stdint.h>
+#include <assert.h>
+#include <getopt.h>
+#include <stdbool.h>
+#include <signal.h>
+#include <sys/mount.h>
+#include <sys/prctl.h>
+#include <sys/wait.h>
+#include <sys/syscall.h>
+#include <sys/eventfd.h>
+#include <linux/sched.h>
+
+#include "kdbus-util.h"
+#include "kdbus-enum.h"
+#include "kdbus-test.h"
+
+enum {
+	TEST_CREATE_BUS		=3D 1 << 0,
+	TEST_CREATE_CONN	=3D 1 << 1,
+};
+
+struct kdbus_test {
+	const char *name;
+	const char *desc;
+	int (*func)(struct kdbus_test_env *env);
+	unsigned int flags;
+};
+
+struct kdbus_test_args {
+	bool mntns;
+	bool pidns;
+	bool userns;
+	char *uid_map;
+	char *gid_map;
+	int loop;
+	int wait;
+	int fork;
+	int tap_output;
+	char *module;
+	char *root;
+	char *test;
+	char *busname;
+	char *mask_param_path;
+};
+
+static const struct kdbus_test tests[] =3D {
+	{
+		.name	=3D "bus-make",
+		.desc	=3D "bus make functions",
+		.func	=3D kdbus_test_bus_make,
+		.flags	=3D 0,
+	},
+	{
+		.name	=3D "hello",
+		.desc	=3D "the HELLO command",
+		.func	=3D kdbus_test_hello,
+		.flags	=3D TEST_CREATE_BUS,
+	},
+	{
+		.name	=3D "byebye",
+		.desc	=3D "the BYEBYE command",
+		.func	=3D kdbus_test_byebye,
+		.flags	=3D TEST_CREATE_BUS | TEST_CREATE_CONN,
+	},
+	{
+		.name	=3D "chat",
+		.desc	=3D "a chat pattern",
+		.func	=3D kdbus_test_chat,
+		.flags	=3D TEST_CREATE_BUS,
+	},
+	{
+		.name	=3D "daemon",
+		.desc	=3D "a simple daemon",
+		.func	=3D kdbus_test_daemon,
+		.flags	=3D TEST_CREATE_BUS | TEST_CREATE_CONN,
+	},
+	{
+		.name	=3D "fd-passing",
+		.desc	=3D "file descriptor passing",
+		.func	=3D kdbus_test_fd_passing,
+		.flags	=3D TEST_CREATE_BUS,
+	},
+	{
+		.name	=3D "endpoint",
+		.desc	=3D "custom endpoint",
+		.func	=3D kdbus_test_custom_endpoint,
+		.flags	=3D TEST_CREATE_BUS | TEST_CREATE_CONN,
+	},
+	{
+		.name	=3D "monitor",
+		.desc	=3D "monitor functionality",
+		.func	=3D kdbus_test_monitor,
+		.flags	=3D TEST_CREATE_BUS | TEST_CREATE_CONN,
+	},
+	{
+		.name	=3D "name-basics",
+		.desc	=3D "basic name registry functions",
+		.func	=3D kdbus_test_name_basic,
+		.flags	=3D TEST_CREATE_BUS | TEST_CREATE_CONN,
+	},
+	{
+		.name	=3D "name-conflict",
+		.desc	=3D "name registry conflict details",
+		.func	=3D kdbus_test_name_conflict,
+		.flags	=3D TEST_CREATE_BUS | TEST_CREATE_CONN,
+	},
+	{
+		.name	=3D "name-queue",
+		.desc	=3D "queuing of names",
+		.func	=3D kdbus_test_name_queue,
+		.flags	=3D TEST_CREATE_BUS | TEST_CREATE_CONN,
+	},
+	{
+		.name	=3D "message-basic",
+		.desc	=3D "basic message handling",
+		.func	=3D kdbus_test_message_basic,
+		.flags	=3D TEST_CREATE_BUS | TEST_CREATE_CONN,
+	},
+	{
+		.name	=3D "message-prio",
+		.desc	=3D "handling of messages with priority",
+		.func	=3D kdbus_test_message_prio,
+		.flags	=3D TEST_CREATE_BUS,
+	},
+	{
+		.name	=3D "message-quota",
+		.desc	=3D "message quotas are enforced",
+		.func	=3D kdbus_test_message_quota,
+		.flags	=3D TEST_CREATE_BUS,
+	},
+	{
+		.name	=3D "memory-access",
+		.desc	=3D "memory access",
+		.func	=3D kdbus_test_memory_access,
+		.flags	=3D TEST_CREATE_BUS,
+	},
+	{
+		.name	=3D "timeout",
+		.desc	=3D "timeout",
+		.func	=3D kdbus_test_timeout,
+		.flags	=3D TEST_CREATE_BUS,
+	},
+	{
+		.name	=3D "sync-byebye",
+		.desc	=3D "synchronous replies vs. BYEBYE",
+		.func	=3D kdbus_test_sync_byebye,
+		.flags	=3D TEST_CREATE_BUS,
+	},
+	{
+		.name	=3D "sync-reply",
+		.desc	=3D "synchronous replies",
+		.func	=3D kdbus_test_sync_reply,
+		.flags	=3D TEST_CREATE_BUS,
+	},
+	{
+		.name	=3D "message-free",
+		.desc	=3D "freeing of memory",
+		.func	=3D kdbus_test_free,
+		.flags	=3D TEST_CREATE_BUS | TEST_CREATE_CONN,
+	},
+	{
+		.name	=3D "connection-info",
+		.desc	=3D "retrieving connection information",
+		.func	=3D kdbus_test_conn_info,
+		.flags	=3D TEST_CREATE_BUS | TEST_CREATE_CONN,
+	},
+	{
+		.name	=3D "connection-update",
+		.desc	=3D "updating connection information",
+		.func	=3D kdbus_test_conn_update,
+		.flags	=3D TEST_CREATE_BUS | TEST_CREATE_CONN,
+	},
+	{
+		.name	=3D "writable-pool",
+		.desc	=3D "verifying pools are never writable",
+		.func	=3D kdbus_test_writable_pool,
+		.flags	=3D TEST_CREATE_BUS,
+	},
+	{
+		.name	=3D "policy",
+		.desc	=3D "policy",
+		.func	=3D kdbus_test_policy,
+		.flags	=3D TEST_CREATE_BUS,
+	},
+	{
+		.name	=3D "policy-priv",
+		.desc	=3D "unprivileged bus access",
+		.func	=3D kdbus_test_policy_priv,
+		.flags	=3D TEST_CREATE_BUS,
+	},
+	{
+		.name	=3D "policy-ns",
+		.desc	=3D "policy in user namespaces",
+		.func	=3D kdbus_test_policy_ns,
+		.flags	=3D TEST_CREATE_BUS,
+	},
+	{
+		.name	=3D "metadata-ns",
+		.desc	=3D "metadata in different namespaces",
+		.func	=3D kdbus_test_metadata_ns,
+		.flags	=3D TEST_CREATE_BUS | TEST_CREATE_CONN,
+	},
+	{
+		.name	=3D "match-id-add",
+		.desc	=3D "adding of matches by id",
+		.func	=3D kdbus_test_match_id_add,
+		.flags	=3D TEST_CREATE_BUS | TEST_CREATE_CONN,
+	},
+	{
+		.name	=3D "match-id-remove",
+		.desc	=3D "removing of matches by id",
+		.func	=3D kdbus_test_match_id_remove,
+		.flags	=3D TEST_CREATE_BUS | TEST_CREATE_CONN,
+	},
+	{
+		.name	=3D "match-replace",
+		.desc	=3D "replace of matches with the same cookie",
+		.func	=3D kdbus_test_match_replace,
+		.flags	=3D TEST_CREATE_BUS | TEST_CREATE_CONN,
+	},
+	{
+		.name	=3D "match-name-add",
+		.desc	=3D "adding of matches by name",
+		.func	=3D kdbus_test_match_name_add,
+		.flags	=3D TEST_CREATE_BUS | TEST_CREATE_CONN,
+	},
+	{
+		.name	=3D "match-name-remove",
+		.desc	=3D "removing of matches by name",
+		.func	=3D kdbus_test_match_name_remove,
+		.flags	=3D TEST_CREATE_BUS | TEST_CREATE_CONN,
+	},
+	{
+		.name	=3D "match-name-change",
+		.desc	=3D "matching for name changes",
+		.func	=3D kdbus_test_match_name_change,
+		.flags	=3D TEST_CREATE_BUS | TEST_CREATE_CONN,
+	},
+	{
+		.name	=3D "match-bloom",
+		.desc	=3D "matching with bloom filters",
+		.func	=3D kdbus_test_match_bloom,
+		.flags	=3D TEST_CREATE_BUS | TEST_CREATE_CONN,
+	},
+	{
+		.name	=3D "activator",
+		.desc	=3D "activator connections",
+		.func	=3D kdbus_test_activator,
+		.flags	=3D TEST_CREATE_BUS | TEST_CREATE_CONN,
+	},
+	{
+		.name	=3D "benchmark",
+		.desc	=3D "benchmark",
+		.func	=3D kdbus_test_benchmark,
+		.flags	=3D TEST_CREATE_BUS,
+	},
+	{
+		.name	=3D "benchmark-nomemfds",
+		.desc	=3D "benchmark without using memfds",
+		.func	=3D kdbus_test_benchmark_nomemfds,
+		.flags	=3D TEST_CREATE_BUS,
+	},
+	{
+		.name	=3D "benchmark-uds",
+		.desc	=3D "benchmark comparison to UDS",
+		.func	=3D kdbus_test_benchmark_uds,
+		.flags	=3D TEST_CREATE_BUS,
+	},
+	{
+		/* Last test */
+		.name	=3D "attach-flags",
+		.desc	=3D "attach flags mask",
+		.func	=3D kdbus_test_attach_flags,
+		.flags	=3D 0,
+	},
+};
+
+#define N_TESTS ((int) (sizeof(tests) / sizeof(tests[0])))
+
+static int test_prepare_env(const struct kdbus_test *t,
+			    const struct kdbus_test_args *args,
+			    struct kdbus_test_env *env)
+{
+	if (t->flags & TEST_CREATE_BUS) {
+		char *s;
+		char *n =3D NULL;
+		int ret;
+
+		asprintf(&s, "%s/control", args->root);
+
+		env->control_fd =3D open(s, O_RDWR);
+		free(s);
+		ASSERT_RETURN(env->control_fd >=3D 0);
+
+		if (!args->busname) {
+			n =3D unique_name("test-bus");
+			ASSERT_RETURN(n);
+		}
+
+		ret =3D kdbus_create_bus(env->control_fd,
+				       args->busname ?: n,
+				       _KDBUS_ATTACH_ALL,
+				       _KDBUS_ATTACH_ALL, &s);
+		free(n);
+		ASSERT_RETURN(ret =3D=3D 0);
+
+		asprintf(&env->buspath, "%s/%s/bus", args->root, s);
+		free(s);
+	}
+
+	if (t->flags & TEST_CREATE_CONN) {
+		env->conn =3D kdbus_hello(env->buspath, 0, NULL, 0);
+		ASSERT_RETURN(env->conn);
+	}
+
+	env->root =3D args->root;
+	env->module =3D args->module;
+	env->mask_param_path =3D args->mask_param_path;
+
+	return 0;
+}
+
+void test_unprepare_env(const struct kdbus_test *t, struct kdbus_test_=
env *env)
+{
+	if (env->conn) {
+		kdbus_conn_free(env->conn);
+		env->conn =3D NULL;
+	}
+
+	if (env->control_fd >=3D 0) {
+		close(env->control_fd);
+		env->control_fd =3D -1;
+	}
+
+	if (env->buspath) {
+		free(env->buspath);
+		env->buspath =3D NULL;
+	}
+}
+
+static int test_run(const struct kdbus_test *t,
+		    const struct kdbus_test_args *kdbus_args,
+		    int wait)
+{
+	int ret;
+	struct kdbus_test_env env =3D {};
+
+	ret =3D test_prepare_env(t, kdbus_args, &env);
+	if (ret !=3D TEST_OK)
+		return ret;
+
+	if (wait > 0) {
+		printf("Sleeping %d seconds before running test ...\n", wait);
+		sleep(wait);
+	}
+
+	ret =3D t->func(&env);
+	test_unprepare_env(t, &env);
+	return ret;
+}
+
+static int test_run_forked(const struct kdbus_test *t,
+			   const struct kdbus_test_args *kdbus_args,
+			   int wait)
+{
+	int ret;
+	pid_t pid;
+
+	pid =3D fork();
+	if (pid < 0) {
+		return TEST_ERR;
+	} else if (pid =3D=3D 0) {
+		ret =3D test_run(t, kdbus_args, wait);
+		_exit(ret);
+	}
+
+	pid =3D waitpid(pid, &ret, 0);
+	if (pid <=3D 0)
+		return TEST_ERR;
+	else if (!WIFEXITED(ret))
+		return TEST_ERR;
+	else
+		return WEXITSTATUS(ret);
+}
+
+static void print_test_result(int ret)
+{
+	switch (ret) {
+	case TEST_OK:
+		printf("OK");
+		break;
+	case TEST_SKIP:
+		printf("SKIPPED");
+		break;
+	case TEST_ERR:
+		printf("ERROR");
+		break;
+	}
+}
+
+static int start_all_tests(struct kdbus_test_args *kdbus_args)
+{
+	int ret;
+	unsigned int fail_cnt =3D 0;
+	unsigned int skip_cnt =3D 0;
+	unsigned int ok_cnt =3D 0;
+	unsigned int i;
+
+	if (kdbus_args->tap_output) {
+		printf("1..%d\n", N_TESTS);
+		fflush(stdout);
+	}
+
+	kdbus_util_verbose =3D false;
+
+	for (i =3D 0; i < N_TESTS; i++) {
+		const struct kdbus_test *t =3D tests + i;
+
+		if (!kdbus_args->tap_output) {
+			unsigned int n;
+
+			printf("Testing %s (%s) ", t->desc, t->name);
+			for (n =3D 0; n < 60 - strlen(t->desc) - strlen(t->name); n++)
+				printf(".");
+			printf(" ");
+		}
+
+		ret =3D test_run_forked(t, kdbus_args, 0);
+		switch (ret) {
+		case TEST_OK:
+			ok_cnt++;
+			break;
+		case TEST_SKIP:
+			skip_cnt++;
+			break;
+		case TEST_ERR:
+			fail_cnt++;
+			break;
+		}
+
+		if (kdbus_args->tap_output) {
+			printf("%sok %d - %s%s (%s)\n",
+			       (ret =3D=3D TEST_ERR) ? "not " : "", i + 1,
+			       (ret =3D=3D TEST_SKIP) ? "# SKIP " : "",
+			       t->desc, t->name);
+			fflush(stdout);
+		} else {
+			print_test_result(ret);
+			printf("\n");
+		}
+	}
+
+	if (kdbus_args->tap_output)
+		printf("Failed %d/%d tests, %.2f%% okay\n", fail_cnt, N_TESTS,
+		       100.0 - (fail_cnt * 100.0) / ((float) N_TESTS));
+	else
+		printf("\nSUMMARY: %u tests passed, %u skipped, %u failed\n",
+		       ok_cnt, skip_cnt, fail_cnt);
+
+	return fail_cnt > 0 ? TEST_ERR : TEST_OK;
+}
+
+static int start_one_test(struct kdbus_test_args *kdbus_args)
+{
+	int i, ret;
+	bool test_found =3D false;
+
+	for (i =3D 0; i < N_TESTS; i++) {
+		const struct kdbus_test *t =3D tests + i;
+
+		if (strcmp(t->name, kdbus_args->test))
+			continue;
+
+		do {
+			test_found =3D true;
+			if (kdbus_args->fork)
+				ret =3D test_run_forked(t, kdbus_args,
+						      kdbus_args->wait);
+			else
+				ret =3D test_run(t, kdbus_args,
+					       kdbus_args->wait);
+
+			printf("Testing %s: ", t->desc);
+			print_test_result(ret);
+			printf("\n");
+
+			if (ret !=3D TEST_OK)
+				break;
+		} while (kdbus_args->loop);
+
+		return ret;
+	}
+
+	if (!test_found) {
+		printf("Unknown test-id '%s'\n", kdbus_args->test);
+		return TEST_ERR;
+	}
+
+	return TEST_OK;
+}
+
+static void usage(const char *argv0)
+{
+	unsigned int i, j;
+
+	printf("Usage: %s [options]\n"
+	       "Options:\n"
+	       "\t-a, --tap		Output test results in TAP format\n"
+	       "\t-m, --module <module>	Kdbus module name\n"
+	       "\t-x, --loop		Run in a loop\n"
+	       "\t-f, --fork		Fork before running a test\n"
+	       "\t-h, --help		Print this help\n"
+	       "\t-r, --root <root>	Toplevel of the kdbus hierarchy\n"
+	       "\t-t, --test <test-id>	Run one specific test only, in verbose=
 mode\n"
+	       "\t-b, --bus <busname>	Instead of generating a random bus name=
, take <busname>.\n"
+	       "\t-w, --wait <secs>	Wait <secs> before actually starting test=
\n"
+	       "\t    --mntns		New mount namespace\n"
+	       "\t    --pidns		New PID namespace\n"
+	       "\t    --userns		New user namespace\n"
+	       "\t    --uidmap uid_map	UID map for user namespace\n"
+	       "\t    --gidmap gid_map	GID map for user namespace\n"
+	       "\n", argv0);
+
+	printf("By default, all test are run once, and a summary is printed.\=
n"
+	       "Available tests for --test:\n\n");
+
+	for (i =3D 0; i < N_TESTS; i++) {
+		const struct kdbus_test *t =3D tests + i;
+
+		printf("\t%s", t->name);
+
+		for (j =3D 0; j < 24 - strlen(t->name); j++)
+			printf(" ");
+
+		printf("Test %s\n", t->desc);
+	}
+
+	printf("\n");
+	printf("Note that some tests may, if run specifically by --test, "
+	       "behave differently, and not terminate by themselves.\n");
+
+	exit(EXIT_FAILURE);
+}
+
+void print_kdbus_test_args(struct kdbus_test_args *args)
+{
+	if (args->userns || args->pidns || args->mntns)
+		printf("# Starting tests in new %s%s%s namespaces%s\n",
+			args->mntns ? "MOUNT " : "",
+			args->pidns ? "PID " : "",
+			args->userns ? "USER " : "",
+			args->mntns ? ", kdbusfs will be remounted" : "");
+	else
+		printf("# Starting tests in the same namespaces\n");
+}
+
+void print_metadata_support(void)
+{
+	bool no_meta_audit, no_meta_cgroups, no_meta_seclabel;
+
+	/*
+	 * KDBUS_ATTACH_CGROUP, KDBUS_ATTACH_AUDIT and
+	 * KDBUS_ATTACH_SECLABEL
+	 */
+	no_meta_audit =3D !config_auditsyscall_is_enabled();
+	no_meta_cgroups =3D !config_cgroups_is_enabled();
+	no_meta_seclabel =3D !config_security_is_enabled();
+
+	if (no_meta_audit | no_meta_cgroups | no_meta_seclabel)
+		printf("# Starting tests without %s%s%s metadata support\n",
+		       no_meta_audit ? "AUDIT " : "",
+		       no_meta_cgroups ? "CGROUP " : "",
+		       no_meta_seclabel ? "SECLABEL " : "");
+	else
+		printf("# Starting tests with full metadata support\n");
+}
+
+int run_tests(struct kdbus_test_args *kdbus_args)
+{
+	int ret;
+	static char control[4096];
+
+	snprintf(control, sizeof(control), "%s/control", kdbus_args->root);
+
+	if (access(control, W_OK) < 0) {
+		printf("Unable to locate control node at '%s'.\n",
+			control);
+		return TEST_ERR;
+	}
+
+	if (kdbus_args->test) {
+		ret =3D start_one_test(kdbus_args);
+	} else {
+		do {
+			ret =3D start_all_tests(kdbus_args);
+			if (ret !=3D TEST_OK)
+				break;
+		} while (kdbus_args->loop);
+	}
+
+	return ret;
+}
+
+static void nop_handler(int sig) {}
+
+static int test_prepare_mounts(struct kdbus_test_args *kdbus_args)
+{
+	int ret;
+	char kdbusfs[64] =3D {'\0'};
+
+	snprintf(kdbusfs, sizeof(kdbusfs), "%sfs", kdbus_args->module);
+
+	/* make current mount slave */
+	ret =3D mount(NULL, "/", NULL, MS_SLAVE|MS_REC, NULL);
+	if (ret < 0) {
+		ret =3D -errno;
+		printf("error mount() root: %d (%m)\n", ret);
+		return ret;
+	}
+
+	/* Remount procfs since we need it in our tests */
+	if (kdbus_args->pidns) {
+		ret =3D mount("proc", "/proc", "proc",
+			    MS_NOSUID|MS_NOEXEC|MS_NODEV, NULL);
+		if (ret < 0) {
+			ret =3D -errno;
+			printf("error mount() /proc : %d (%m)\n", ret);
+			return ret;
+		}
+	}
+
+	/* Remount kdbusfs */
+	ret =3D mount(kdbusfs, kdbus_args->root, kdbusfs,
+		    MS_NOSUID|MS_NOEXEC|MS_NODEV, NULL);
+	if (ret < 0) {
+		ret =3D -errno;
+		printf("error mount() %s :%d (%m)\n", kdbusfs, ret);
+		return ret;
+	}
+
+	return 0;
+}
+
+int run_tests_in_namespaces(struct kdbus_test_args *kdbus_args)
+{
+	int ret;
+	int efd =3D -1;
+	int status;
+	pid_t pid, rpid;
+	struct sigaction oldsa;
+	struct sigaction sa =3D {
+		.sa_handler =3D nop_handler,
+		.sa_flags =3D SA_NOCLDSTOP,
+	};
+
+	efd =3D eventfd(0, EFD_CLOEXEC);
+	if (efd < 0) {
+		ret =3D -errno;
+		printf("eventfd() failed: %d (%m)\n", ret);
+		return TEST_ERR;
+	}
+
+	ret =3D sigaction(SIGCHLD, &sa, &oldsa);
+	if (ret < 0) {
+		ret =3D -errno;
+		printf("sigaction() failed: %d (%m)\n", ret);
+		return TEST_ERR;
+	}
+
+	/* setup namespaces */
+	pid =3D syscall(__NR_clone, SIGCHLD|
+		      (kdbus_args->userns ? CLONE_NEWUSER : 0) |
+		      (kdbus_args->mntns ? CLONE_NEWNS : 0) |
+		      (kdbus_args->pidns ? CLONE_NEWPID : 0), NULL);
+	if (pid < 0) {
+		printf("clone() failed: %d (%m)\n", -errno);
+		return TEST_ERR;
+	}
+
+	if (pid =3D=3D 0) {
+		eventfd_t event_status =3D 0;
+
+		ret =3D prctl(PR_SET_PDEATHSIG, SIGKILL);
+		if (ret < 0) {
+			ret =3D -errno;
+			printf("error prctl(): %d (%m)\n", ret);
+			_exit(TEST_ERR);
+		}
+
+		/* reset sighandlers of childs */
+		ret =3D sigaction(SIGCHLD, &oldsa, NULL);
+		if (ret < 0) {
+			ret =3D -errno;
+			printf("sigaction() failed: %d (%m)\n", ret);
+			_exit(TEST_ERR);
+		}
+
+		ret =3D eventfd_read(efd, &event_status);
+		if (ret < 0 || event_status !=3D 1) {
+			printf("error eventfd_read()\n");
+			_exit(TEST_ERR);
+		}
+
+		if (kdbus_args->mntns) {
+			ret =3D test_prepare_mounts(kdbus_args);
+			if (ret < 0) {
+				printf("error preparing mounts\n");
+				_exit(TEST_ERR);
+			}
+		}
+
+		ret =3D run_tests(kdbus_args);
+		_exit(ret);
+	}
+
+	/* Setup userns mapping */
+	if (kdbus_args->userns) {
+		ret =3D userns_map_uid_gid(pid, kdbus_args->uid_map,
+					 kdbus_args->gid_map);
+		if (ret < 0) {
+			printf("error mapping uid and gid in userns\n");
+			eventfd_write(efd, 2);
+			return TEST_ERR;
+		}
+	}
+
+	ret =3D eventfd_write(efd, 1);
+	if (ret < 0) {
+		ret =3D -errno;
+		printf("error eventfd_write(): %d (%m)\n", ret);
+		return TEST_ERR;
+	}
+
+	rpid =3D waitpid(pid, &status, 0);
+	ASSERT_RETURN_VAL(rpid =3D=3D pid, TEST_ERR);
+
+	close(efd);
+
+	if (!WIFEXITED(status) || WEXITSTATUS(status) !=3D 0)
+		return TEST_ERR;
+
+	return TEST_OK;
+}
+
+int start_tests(struct kdbus_test_args *kdbus_args)
+{
+	int ret;
+	bool namespaces;
+	uint64_t kdbus_param_mask;
+	static char fspath[4096], parampath[4096];
+
+	namespaces =3D (kdbus_args->mntns || kdbus_args->pidns ||
+		      kdbus_args->userns);
+
+	/* for pidns we need mntns set */
+	if (kdbus_args->pidns && !kdbus_args->mntns) {
+		printf("Failed: please set both pid and mnt namesapces\n");
+		return TEST_ERR;
+	}
+
+	if (kdbus_args->userns) {
+		if (!config_user_ns_is_enabled()) {
+			printf("User namespace not supported\n");
+			return TEST_ERR;
+		}
+
+		if (!kdbus_args->uid_map || !kdbus_args->gid_map) {
+			printf("Failed: please specify uid or gid mapping\n");
+			return TEST_ERR;
+		}
+	}
+
+	print_kdbus_test_args(kdbus_args);
+	print_metadata_support();
+
+	/* setup kdbus paths */
+	if (!kdbus_args->module)
+		kdbus_args->module =3D "kdbus";
+
+	if (!kdbus_args->root) {
+		snprintf(fspath, sizeof(fspath), "/sys/fs/%s",
+			 kdbus_args->module);
+		kdbus_args->root =3D fspath;
+	}
+
+	snprintf(parampath, sizeof(parampath),
+		 "/sys/module/%s/parameters/attach_flags_mask",
+		 kdbus_args->module);
+	kdbus_args->mask_param_path =3D parampath;
+
+	ret =3D kdbus_sysfs_get_parameter_mask(kdbus_args->mask_param_path,
+					     &kdbus_param_mask);
+	if (ret < 0)
+		return TEST_ERR;
+
+	printf("# Starting tests with an attach_flags_mask=3D0x%llx\n",
+		(unsigned long long)kdbus_param_mask);
+
+	/* Start tests */
+	if (namespaces)
+		ret =3D run_tests_in_namespaces(kdbus_args);
+	else
+		ret =3D run_tests(kdbus_args);
+
+	return ret;
+}
+
+int main(int argc, char *argv[])
+{
+	int t, ret =3D 0;
+	struct kdbus_test_args *kdbus_args;
+	enum {
+		ARG_MNTNS =3D 0x100,
+		ARG_PIDNS,
+		ARG_USERNS,
+		ARG_UIDMAP,
+		ARG_GIDMAP,
+	};
+
+	kdbus_args =3D malloc(sizeof(*kdbus_args));
+	if (!kdbus_args) {
+		printf("unable to malloc() kdbus_args\n");
+		return EXIT_FAILURE;
+	}
+
+	memset(kdbus_args, 0, sizeof(*kdbus_args));
+
+	static const struct option options[] =3D {
+		{ "loop",	no_argument,		NULL, 'x' },
+		{ "help",	no_argument,		NULL, 'h' },
+		{ "root",	required_argument,	NULL, 'r' },
+		{ "test",	required_argument,	NULL, 't' },
+		{ "bus",	required_argument,	NULL, 'b' },
+		{ "wait",	required_argument,	NULL, 'w' },
+		{ "fork",	no_argument,		NULL, 'f' },
+		{ "module",	required_argument,	NULL, 'm' },
+		{ "tap",	no_argument,		NULL, 'a' },
+		{ "mntns",	no_argument,		NULL, ARG_MNTNS },
+		{ "pidns",	no_argument,		NULL, ARG_PIDNS },
+		{ "userns",	no_argument,		NULL, ARG_USERNS },
+		{ "uidmap",	required_argument,	NULL, ARG_UIDMAP },
+		{ "gidmap",	required_argument,	NULL, ARG_GIDMAP },
+		{}
+	};
+
+	srand(time(NULL));
+
+	while ((t =3D getopt_long(argc, argv, "hxfm:r:t:b:w:a", options, NULL=
)) >=3D 0) {
+		switch (t) {
+		case 'x':
+			kdbus_args->loop =3D 1;
+			break;
+
+		case 'm':
+			kdbus_args->module =3D optarg;
+			break;
+
+		case 'r':
+			kdbus_args->root =3D optarg;
+			break;
+
+		case 't':
+			kdbus_args->test =3D optarg;
+			break;
+
+		case 'b':
+			kdbus_args->busname =3D optarg;
+			break;
+
+		case 'w':
+			kdbus_args->wait =3D strtol(optarg, NULL, 10);
+			break;
+
+		case 'f':
+			kdbus_args->fork =3D 1;
+			break;
+
+		case 'a':
+			kdbus_args->tap_output =3D 1;
+			break;
+
+		case ARG_MNTNS:
+			kdbus_args->mntns =3D true;
+			break;
+
+		case ARG_PIDNS:
+			kdbus_args->pidns =3D true;
+			break;
+
+		case ARG_USERNS:
+			kdbus_args->userns =3D true;
+			break;
+
+		case ARG_UIDMAP:
+			kdbus_args->uid_map =3D optarg;
+			break;
+
+		case ARG_GIDMAP:
+			kdbus_args->gid_map =3D optarg;
+			break;
+
+		default:
+		case 'h':
+			usage(argv[0]);
+		}
+	}
+
+	ret =3D start_tests(kdbus_args);
+	if (ret =3D=3D TEST_ERR)
+		return EXIT_FAILURE;
+
+	free(kdbus_args);
+
+	return 0;
+}
diff --git a/tools/testing/selftests/kdbus/kdbus-test.h b/tools/testing=
/selftests/kdbus/kdbus-test.h
new file mode 100644
index 000000000000..647331883763
--- /dev/null
+++ b/tools/testing/selftests/kdbus/kdbus-test.h
@@ -0,0 +1,85 @@
+#ifndef _TEST_KDBUS_H_
+#define _TEST_KDBUS_H_
+
+struct kdbus_test_env {
+	char *buspath;
+	const char *root;
+	const char *module;
+	const char *mask_param_path;
+	int control_fd;
+	struct kdbus_conn *conn;
+};
+
+enum {
+	TEST_OK,
+	TEST_SKIP,
+	TEST_ERR,
+};
+
+#define ASSERT_RETURN_VAL(cond, val)		\
+	if (!(cond)) {			\
+		fprintf(stderr,	"Assertion '%s' failed in %s(), %s:%d\n", \
+			#cond, __func__, __FILE__, __LINE__);	\
+		return val;	\
+	}
+
+#define ASSERT_EXIT_VAL(cond, val)		\
+	if (!(cond)) {			\
+		fprintf(stderr, "Assertion '%s' failed in %s(), %s:%d\n", \
+			#cond, __func__, __FILE__, __LINE__);	\
+		_exit(val);	\
+	}
+
+#define ASSERT_BREAK(cond)		\
+	if (!(cond)) {			\
+		fprintf(stderr, "Assertion '%s' failed in %s(), %s:%d\n", \
+			#cond, __func__, __FILE__, __LINE__);	\
+		break; \
+	}
+
+#define ASSERT_RETURN(cond)		\
+	ASSERT_RETURN_VAL(cond, TEST_ERR)
+
+#define ASSERT_EXIT(cond)		\
+	ASSERT_EXIT_VAL(cond, EXIT_FAILURE)
+
+int kdbus_test_activator(struct kdbus_test_env *env);
+int kdbus_test_attach_flags(struct kdbus_test_env *env);
+int kdbus_test_benchmark(struct kdbus_test_env *env);
+int kdbus_test_benchmark_nomemfds(struct kdbus_test_env *env);
+int kdbus_test_benchmark_uds(struct kdbus_test_env *env);
+int kdbus_test_bus_make(struct kdbus_test_env *env);
+int kdbus_test_byebye(struct kdbus_test_env *env);
+int kdbus_test_chat(struct kdbus_test_env *env);
+int kdbus_test_conn_info(struct kdbus_test_env *env);
+int kdbus_test_conn_update(struct kdbus_test_env *env);
+int kdbus_test_daemon(struct kdbus_test_env *env);
+int kdbus_test_custom_endpoint(struct kdbus_test_env *env);
+int kdbus_test_fd_passing(struct kdbus_test_env *env);
+int kdbus_test_free(struct kdbus_test_env *env);
+int kdbus_test_hello(struct kdbus_test_env *env);
+int kdbus_test_match_bloom(struct kdbus_test_env *env);
+int kdbus_test_match_id_add(struct kdbus_test_env *env);
+int kdbus_test_match_id_remove(struct kdbus_test_env *env);
+int kdbus_test_match_replace(struct kdbus_test_env *env);
+int kdbus_test_match_name_add(struct kdbus_test_env *env);
+int kdbus_test_match_name_change(struct kdbus_test_env *env);
+int kdbus_test_match_name_remove(struct kdbus_test_env *env);
+int kdbus_test_message_basic(struct kdbus_test_env *env);
+int kdbus_test_message_prio(struct kdbus_test_env *env);
+int kdbus_test_message_quota(struct kdbus_test_env *env);
+int kdbus_test_memory_access(struct kdbus_test_env *env);
+int kdbus_test_metadata_ns(struct kdbus_test_env *env);
+int kdbus_test_monitor(struct kdbus_test_env *env);
+int kdbus_test_name_basic(struct kdbus_test_env *env);
+int kdbus_test_name_conflict(struct kdbus_test_env *env);
+int kdbus_test_name_queue(struct kdbus_test_env *env);
+int kdbus_test_policy(struct kdbus_test_env *env);
+int kdbus_test_policy_ns(struct kdbus_test_env *env);
+int kdbus_test_policy_priv(struct kdbus_test_env *env);
+int kdbus_test_sync_byebye(struct kdbus_test_env *env);
+int kdbus_test_sync_reply(struct kdbus_test_env *env);
+int kdbus_test_timeout(struct kdbus_test_env *env);
+int kdbus_test_writable_pool(struct kdbus_test_env *env);
+
+#endif /* _TEST_KDBUS_H_ */
diff --git a/tools/testing/selftests/kdbus/kdbus-util.c b/tools/testing=
/selftests/kdbus/kdbus-util.c
new file mode 100644
index 000000000000..4b376ecfdbed
--- /dev/null
+++ b/tools/testing/selftests/kdbus/kdbus-util.c
@@ -0,0 +1,1615 @@
+/*
+ * Copyright (C) 2013-2015 Daniel Mack
+ * Copyright (C) 2013-2015 Kay Sievers
+ * Copyright (C) 2014-2015 Djalal Harouni
+ *
+ * kdbus is free software; you can redistribute it and/or modify it un=
der
+ * the terms of the GNU Lesser General Public License as published by =
the
+ * Free Software Foundation; either version 2.1 of the License, or (at
+ * your option) any later version.
+ */
+
+#include <stdio.h>
+#include <stdarg.h>
+#include <string.h>
+#include <time.h>
+#include <inttypes.h>
+#include <fcntl.h>
+#include <stdlib.h>
+#include <stddef.h>
+#include <unistd.h>
+#include <stdint.h>
+#include <stdbool.h>
+#include <errno.h>
+#include <assert.h>
+#include <poll.h>
+#include <grp.h>
+#include <sys/capability.h>
+#include <sys/mman.h>
+#include <sys/stat.h>
+#include <sys/time.h>
+#include <linux/unistd.h>
+#include <linux/memfd.h>
+
+#ifndef __NR_memfd_create
+  #ifdef __x86_64__
+    #define __NR_memfd_create 319
+  #elif defined __arm__
+    #define __NR_memfd_create 385
+  #else
+    #define __NR_memfd_create 356
+  #endif
+#endif
+
+#include "kdbus-api.h"
+#include "kdbus-util.h"
+#include "kdbus-enum.h"
+
+#ifndef F_ADD_SEALS
+#define F_LINUX_SPECIFIC_BASE	1024
+#define F_ADD_SEALS     (F_LINUX_SPECIFIC_BASE + 9)
+#define F_GET_SEALS     (F_LINUX_SPECIFIC_BASE + 10)
+
+#define F_SEAL_SEAL     0x0001  /* prevent further seals from being se=
t */
+#define F_SEAL_SHRINK   0x0002  /* prevent file from shrinking */
+#define F_SEAL_GROW     0x0004  /* prevent file from growing */
+#define F_SEAL_WRITE    0x0008  /* prevent writes */
+#endif
+
+int kdbus_util_verbose =3D true;
+
+int kdbus_sysfs_get_parameter_mask(const char *path, uint64_t *mask)
+{
+	int ret;
+	FILE *file;
+	unsigned long long value;
+
+	file =3D fopen(path, "r");
+	if (!file) {
+		ret =3D -errno;
+		kdbus_printf("--- error fopen(): %d (%m)\n", ret);
+		return ret;
+	}
+
+	ret =3D fscanf(file, "%llu", &value);
+	if (ret !=3D 1) {
+		if (ferror(file))
+			ret =3D -errno;
+		else
+			ret =3D -EIO;
+
+		kdbus_printf("--- error fscanf(): %d\n", ret);
+		fclose(file);
+		return ret;
+	}
+
+	*mask =3D (uint64_t)value;
+
+	fclose(file);
+
+	return 0;
+}
+
+int kdbus_sysfs_set_parameter_mask(const char *path, uint64_t mask)
+{
+	int ret;
+	FILE *file;
+
+	file =3D fopen(path, "w");
+	if (!file) {
+		ret =3D -errno;
+		kdbus_printf("--- error open(): %d (%m)\n", ret);
+		return ret;
+	}
+
+	ret =3D fprintf(file, "%llu", (unsigned long long)mask);
+	if (ret <=3D 0) {
+		ret =3D -EIO;
+		kdbus_printf("--- error fprintf(): %d\n", ret);
+	}
+
+	fclose(file);
+
+	return ret > 0 ? 0 : ret;
+}
+
+int kdbus_create_bus(int control_fd, const char *name,
+		     uint64_t req_meta, uint64_t owner_meta,
+		     char **path)
+{
+	struct {
+		struct kdbus_cmd cmd;
+
+		/* bloom size item */
+		struct {
+			uint64_t size;
+			uint64_t type;
+			struct kdbus_bloom_parameter bloom;
+		} bp;
+
+		/* required and owner metadata items */
+		struct {
+			uint64_t size;
+			uint64_t type;
+			uint64_t flags;
+		} attach[2];
+
+		/* name item */
+		struct {
+			uint64_t size;
+			uint64_t type;
+			char str[64];
+		} name;
+	} bus_make;
+	int ret;
+
+	memset(&bus_make, 0, sizeof(bus_make));
+	bus_make.bp.size =3D sizeof(bus_make.bp);
+	bus_make.bp.type =3D KDBUS_ITEM_BLOOM_PARAMETER;
+	bus_make.bp.bloom.size =3D 64;
+	bus_make.bp.bloom.n_hash =3D 1;
+
+	snprintf(bus_make.name.str, sizeof(bus_make.name.str),
+		 "%u-%s", getuid(), name);
+
+	bus_make.attach[0].type =3D KDBUS_ITEM_ATTACH_FLAGS_RECV;
+	bus_make.attach[0].size =3D sizeof(bus_make.attach[0]);
+	bus_make.attach[0].flags =3D req_meta;
+
+	bus_make.attach[1].type =3D KDBUS_ITEM_ATTACH_FLAGS_SEND;
+	bus_make.attach[1].size =3D sizeof(bus_make.attach[0]);
+	bus_make.attach[1].flags =3D owner_meta;
+
+	bus_make.name.type =3D KDBUS_ITEM_MAKE_NAME;
+	bus_make.name.size =3D KDBUS_ITEM_HEADER_SIZE +
+			     strlen(bus_make.name.str) + 1;
+
+	bus_make.cmd.flags =3D KDBUS_MAKE_ACCESS_WORLD;
+	bus_make.cmd.size =3D sizeof(bus_make.cmd) +
+			     bus_make.bp.size +
+			     bus_make.attach[0].size +
+			     bus_make.attach[1].size +
+			     bus_make.name.size;
+
+	kdbus_printf("Creating bus with name >%s< on control fd %d ...\n",
+		     name, control_fd);
+
+	ret =3D kdbus_cmd_bus_make(control_fd, &bus_make.cmd);
+	if (ret < 0) {
+		kdbus_printf("--- error when making bus: %d (%m)\n", ret);
+		return ret;
+	}
+
+	if (ret =3D=3D 0 && path)
+		*path =3D strdup(bus_make.name.str);
+
+	return ret;
+}
+
+struct kdbus_conn *
+kdbus_hello(const char *path, uint64_t flags,
+	    const struct kdbus_item *item, size_t item_size)
+{
+	struct kdbus_cmd_free cmd_free =3D {};
+	int fd, ret;
+	struct {
+		struct kdbus_cmd_hello hello;
+
+		struct {
+			uint64_t size;
+			uint64_t type;
+			char str[16];
+		} conn_name;
+
+		uint8_t extra_items[item_size];
+	} h;
+	struct kdbus_conn *conn;
+
+	memset(&h, 0, sizeof(h));
+
+	if (item_size > 0)
+		memcpy(h.extra_items, item, item_size);
+
+	kdbus_printf("-- opening bus connection %s\n", path);
+	fd =3D open(path, O_RDWR|O_CLOEXEC);
+	if (fd < 0) {
+		kdbus_printf("--- error %d (%m)\n", fd);
+		return NULL;
+	}
+
+	h.hello.flags =3D flags | KDBUS_HELLO_ACCEPT_FD;
+	h.hello.attach_flags_send =3D _KDBUS_ATTACH_ALL;
+	h.hello.attach_flags_recv =3D _KDBUS_ATTACH_ALL;
+	h.conn_name.type =3D KDBUS_ITEM_CONN_DESCRIPTION;
+	strcpy(h.conn_name.str, "this-is-my-name");
+	h.conn_name.size =3D KDBUS_ITEM_HEADER_SIZE + strlen(h.conn_name.str)=
 + 1;
+
+	h.hello.size =3D sizeof(h);
+	h.hello.pool_size =3D POOL_SIZE;
+
+	ret =3D kdbus_cmd_hello(fd, (struct kdbus_cmd_hello *) &h.hello);
+	if (ret < 0) {
+		kdbus_printf("--- error when saying hello: %d (%m)\n", ret);
+		return NULL;
+	}
+	kdbus_printf("-- Our peer ID for %s: %llu -- bus uuid: '%02x%02x%02x%=
02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x'\n",
+		     path, (unsigned long long)h.hello.id,
+		     h.hello.id128[0],  h.hello.id128[1],  h.hello.id128[2],
+		     h.hello.id128[3],  h.hello.id128[4],  h.hello.id128[5],
+		     h.hello.id128[6],  h.hello.id128[7],  h.hello.id128[8],
+		     h.hello.id128[9],  h.hello.id128[10], h.hello.id128[11],
+		     h.hello.id128[12], h.hello.id128[13], h.hello.id128[14],
+		     h.hello.id128[15]);
+
+	cmd_free.size =3D sizeof(cmd_free);
+	cmd_free.offset =3D h.hello.offset;
+	kdbus_cmd_free(fd, &cmd_free);
+
+	conn =3D malloc(sizeof(*conn));
+	if (!conn) {
+		kdbus_printf("unable to malloc()!?\n");
+		return NULL;
+	}
+
+	conn->buf =3D mmap(NULL, POOL_SIZE, PROT_READ, MAP_SHARED, fd, 0);
+	if (conn->buf =3D=3D MAP_FAILED) {
+		free(conn);
+		close(fd);
+		kdbus_printf("--- error mmap (%m)\n");
+		return NULL;
+	}
+
+	conn->fd =3D fd;
+	conn->id =3D h.hello.id;
+	return conn;
+}
+
+struct kdbus_conn *
+kdbus_hello_registrar(const char *path, const char *name,
+		      const struct kdbus_policy_access *access,
+		      size_t num_access, uint64_t flags)
+{
+	struct kdbus_item *item, *items;
+	size_t i, size;
+
+	size =3D KDBUS_ITEM_SIZE(strlen(name) + 1) +
+		num_access * KDBUS_ITEM_SIZE(sizeof(*access));
+
+	items =3D alloca(size);
+
+	item =3D items;
+	item->size =3D KDBUS_ITEM_HEADER_SIZE + strlen(name) + 1;
+	item->type =3D KDBUS_ITEM_NAME;
+	strcpy(item->str, name);
+	item =3D KDBUS_ITEM_NEXT(item);
+
+	for (i =3D 0; i < num_access; i++) {
+		item->size =3D KDBUS_ITEM_HEADER_SIZE +
+			     sizeof(struct kdbus_policy_access);
+		item->type =3D KDBUS_ITEM_POLICY_ACCESS;
+
+		item->policy_access.type =3D access[i].type;
+		item->policy_access.access =3D access[i].access;
+		item->policy_access.id =3D access[i].id;
+
+		item =3D KDBUS_ITEM_NEXT(item);
+	}
+
+	return kdbus_hello(path, flags, items, size);
+}
+
+struct kdbus_conn *kdbus_hello_activator(const char *path, const char =
*name,
+				   const struct kdbus_policy_access *access,
+				   size_t num_access)
+{
+	return kdbus_hello_registrar(path, name, access, num_access,
+				     KDBUS_HELLO_ACTIVATOR);
+}
+
+bool kdbus_item_in_message(struct kdbus_msg *msg, uint64_t type)
+{
+	const struct kdbus_item *item;
+
+	KDBUS_ITEM_FOREACH(item, msg, items)
+		if (item->type =3D=3D type)
+			return true;
+
+	return false;
+}
+
+int kdbus_bus_creator_info(struct kdbus_conn *conn,
+			   uint64_t flags,
+			   uint64_t *offset)
+{
+	struct kdbus_cmd_info *cmd;
+	size_t size =3D sizeof(*cmd);
+	int ret;
+
+	cmd =3D alloca(size);
+	memset(cmd, 0, size);
+	cmd->size =3D size;
+	cmd->attach_flags =3D flags;
+
+	ret =3D kdbus_cmd_bus_creator_info(conn->fd, cmd);
+	if (ret < 0) {
+		kdbus_printf("--- error when requesting info: %d (%m)\n", ret);
+		return ret;
+	}
+
+	if (offset)
+		*offset =3D cmd->offset;
+	else
+		kdbus_free(conn, cmd->offset);
+
+	return 0;
+}
+
+int kdbus_conn_info(struct kdbus_conn *conn, uint64_t id,
+		    const char *name, uint64_t flags,
+		    uint64_t *offset)
+{
+	struct kdbus_cmd_info *cmd;
+	size_t size =3D sizeof(*cmd);
+	struct kdbus_info *info;
+	int ret;
+
+	if (name)
+		size +=3D KDBUS_ITEM_HEADER_SIZE + strlen(name) + 1;
+
+	cmd =3D alloca(size);
+	memset(cmd, 0, size);
+	cmd->size =3D size;
+	cmd->attach_flags =3D flags;
+
+	if (name) {
+		cmd->items[0].size =3D KDBUS_ITEM_HEADER_SIZE + strlen(name) + 1;
+		cmd->items[0].type =3D KDBUS_ITEM_NAME;
+		strcpy(cmd->items[0].str, name);
+	} else {
+		cmd->id =3D id;
+	}
+
+	ret =3D kdbus_cmd_conn_info(conn->fd, cmd);
+	if (ret < 0) {
+		kdbus_printf("--- error when requesting info: %d (%m)\n", ret);
+		return ret;
+	}
+
+	info =3D (struct kdbus_info *) (conn->buf + cmd->offset);
+	if (info->size !=3D cmd->info_size) {
+		kdbus_printf("%s(): size mismatch: %d !=3D %d\n", __func__,
+				(int) info->size, (int) cmd->info_size);
+		return -EIO;
+	}
+
+	if (offset)
+		*offset =3D cmd->offset;
+	else
+		kdbus_free(conn, cmd->offset);
+
+	return 0;
+}
+
+void kdbus_conn_free(struct kdbus_conn *conn)
+{
+	if (!conn)
+		return;
+
+	if (conn->buf)
+		munmap(conn->buf, POOL_SIZE);
+
+	if (conn->fd >=3D 0)
+		close(conn->fd);
+
+	free(conn);
+}
+
+int sys_memfd_create(const char *name, __u64 size)
+{
+	int ret, fd;
+
+	ret =3D syscall(__NR_memfd_create, name, MFD_ALLOW_SEALING);
+	if (ret < 0)
+		return ret;
+
+	fd =3D ret;
+
+	ret =3D ftruncate(fd, size);
+	if (ret < 0) {
+		close(fd);
+		return ret;
+	}
+
+	return fd;
+}
+
+int sys_memfd_seal_set(int fd)
+{
+	return fcntl(fd, F_ADD_SEALS, F_SEAL_SHRINK |
+			 F_SEAL_GROW | F_SEAL_WRITE | F_SEAL_SEAL);
+}
+
+off_t sys_memfd_get_size(int fd, off_t *size)
+{
+	struct stat stat;
+	int ret;
+
+	ret =3D fstat(fd, &stat);
+	if (ret < 0) {
+		kdbus_printf("stat() failed: %m\n");
+		return ret;
+	}
+
+	*size =3D stat.st_size;
+	return 0;
+}
+
+static int __kdbus_msg_send(const struct kdbus_conn *conn,
+			    const char *name,
+			    uint64_t cookie,
+			    uint64_t flags,
+			    uint64_t timeout,
+			    int64_t priority,
+			    uint64_t dst_id,
+			    uint64_t cmd_flags,
+			    int cancel_fd)
+{
+	struct kdbus_cmd_send *cmd;
+	struct kdbus_msg *msg;
+	const char ref1[1024 * 128 + 3] =3D "0123456789_0";
+	const char ref2[] =3D "0123456789_1";
+	struct kdbus_item *item;
+	struct timespec now;
+	uint64_t size;
+	int memfd =3D -1;
+	int ret;
+
+	size =3D sizeof(*msg);
+	size +=3D KDBUS_ITEM_SIZE(sizeof(struct kdbus_vec));
+	size +=3D KDBUS_ITEM_SIZE(sizeof(struct kdbus_vec));
+	size +=3D KDBUS_ITEM_SIZE(sizeof(struct kdbus_vec));
+
+	if (dst_id =3D=3D KDBUS_DST_ID_BROADCAST)
+		size +=3D KDBUS_ITEM_SIZE(sizeof(struct kdbus_bloom_filter)) + 64;
+	else {
+		memfd =3D sys_memfd_create("my-name-is-nice", 1024 * 1024);
+		if (memfd < 0) {
+			kdbus_printf("failed to create memfd: %m\n");
+			return memfd;
+		}
+
+		if (write(memfd, "kdbus memfd 1234567", 19) !=3D 19) {
+			ret =3D -errno;
+			kdbus_printf("writing to memfd failed: %m\n");
+			return ret;
+		}
+
+		ret =3D sys_memfd_seal_set(memfd);
+		if (ret < 0) {
+			ret =3D -errno;
+			kdbus_printf("memfd sealing failed: %m\n");
+			return ret;
+		}
+
+		size +=3D KDBUS_ITEM_SIZE(sizeof(struct kdbus_memfd));
+	}
+
+	if (name)
+		size +=3D KDBUS_ITEM_SIZE(strlen(name) + 1);
+
+	msg =3D malloc(size);
+	if (!msg) {
+		ret =3D -errno;
+		kdbus_printf("unable to malloc()!?\n");
+		return ret;
+	}
+
+	if (dst_id =3D=3D KDBUS_DST_ID_BROADCAST)
+		flags |=3D KDBUS_MSG_SIGNAL;
+
+	memset(msg, 0, size);
+	msg->flags =3D flags;
+	msg->priority =3D priority;
+	msg->size =3D size;
+	msg->src_id =3D conn->id;
+	msg->dst_id =3D name ? 0 : dst_id;
+	msg->cookie =3D cookie;
+	msg->payload_type =3D KDBUS_PAYLOAD_DBUS;
+
+	if (timeout) {
+		ret =3D clock_gettime(CLOCK_MONOTONIC_COARSE, &now);
+		if (ret < 0)
+			return ret;
+
+		msg->timeout_ns =3D now.tv_sec * 1000000000ULL +
+				  now.tv_nsec + timeout;
+	}
+
+	item =3D msg->items;
+
+	if (name) {
+		item->type =3D KDBUS_ITEM_DST_NAME;
+		item->size =3D KDBUS_ITEM_HEADER_SIZE + strlen(name) + 1;
+		strcpy(item->str, name);
+		item =3D KDBUS_ITEM_NEXT(item);
+	}
+
+	item->type =3D KDBUS_ITEM_PAYLOAD_VEC;
+	item->size =3D KDBUS_ITEM_HEADER_SIZE + sizeof(struct kdbus_vec);
+	item->vec.address =3D (uintptr_t)&ref1;
+	item->vec.size =3D sizeof(ref1);
+	item =3D KDBUS_ITEM_NEXT(item);
+
+	/* data padding for ref1 */
+	item->type =3D KDBUS_ITEM_PAYLOAD_VEC;
+	item->size =3D KDBUS_ITEM_HEADER_SIZE + sizeof(struct kdbus_vec);
+	item->vec.address =3D (uintptr_t)NULL;
+	item->vec.size =3D  KDBUS_ALIGN8(sizeof(ref1)) - sizeof(ref1);
+	item =3D KDBUS_ITEM_NEXT(item);
+
+	item->type =3D KDBUS_ITEM_PAYLOAD_VEC;
+	item->size =3D KDBUS_ITEM_HEADER_SIZE + sizeof(struct kdbus_vec);
+	item->vec.address =3D (uintptr_t)&ref2;
+	item->vec.size =3D sizeof(ref2);
+	item =3D KDBUS_ITEM_NEXT(item);
+
+	if (dst_id =3D=3D KDBUS_DST_ID_BROADCAST) {
+		item->type =3D KDBUS_ITEM_BLOOM_FILTER;
+		item->size =3D KDBUS_ITEM_SIZE(sizeof(struct kdbus_bloom_filter)) + =
64;
+		item->bloom_filter.generation =3D 0;
+	} else {
+		item->type =3D KDBUS_ITEM_PAYLOAD_MEMFD;
+		item->size =3D KDBUS_ITEM_HEADER_SIZE + sizeof(struct kdbus_memfd);
+		item->memfd.size =3D 16;
+		item->memfd.fd =3D memfd;
+	}
+	item =3D KDBUS_ITEM_NEXT(item);
+
+	size =3D sizeof(*cmd);
+	if (cancel_fd !=3D -1)
+		size +=3D KDBUS_ITEM_SIZE(sizeof(cancel_fd));
+
+	cmd =3D malloc(size);
+	cmd->size =3D size;
+	cmd->flags =3D cmd_flags;
+	cmd->msg_address =3D (uintptr_t)msg;
+
+	item =3D cmd->items;
+
+	if (cancel_fd !=3D -1) {
+		item->type =3D KDBUS_ITEM_CANCEL_FD;
+		item->size =3D KDBUS_ITEM_HEADER_SIZE + sizeof(cancel_fd);
+		item->fds[0] =3D cancel_fd;
+		item =3D KDBUS_ITEM_NEXT(item);
+	}
+
+	ret =3D kdbus_cmd_send(conn->fd, cmd);
+	if (memfd >=3D 0)
+		close(memfd);
+
+	if (ret < 0) {
+		kdbus_printf("error sending message: %d (%m)\n", ret);
+		return ret;
+	}
+
+	if (cmd_flags & KDBUS_SEND_SYNC_REPLY) {
+		struct kdbus_msg *reply;
+
+		kdbus_printf("SYNC REPLY @offset %llu:\n", cmd->reply.offset);
+		reply =3D (struct kdbus_msg *)(conn->buf + cmd->reply.offset);
+		kdbus_msg_dump(conn, reply);
+
+		kdbus_msg_free(reply);
+
+		ret =3D kdbus_free(conn, cmd->reply.offset);
+		if (ret < 0)
+			return ret;
+	}
+
+	free(msg);
+	free(cmd);
+
+	return 0;
+}
+
+int kdbus_msg_send(const struct kdbus_conn *conn, const char *name,
+		   uint64_t cookie, uint64_t flags, uint64_t timeout,
+		   int64_t priority, uint64_t dst_id)
+{
+	return __kdbus_msg_send(conn, name, cookie, flags, timeout, priority,
+				dst_id, 0, -1);
+}
+
+int kdbus_msg_send_sync(const struct kdbus_conn *conn, const char *nam=
e,
+			uint64_t cookie, uint64_t flags, uint64_t timeout,
+			int64_t priority, uint64_t dst_id, int cancel_fd)
+{
+	return __kdbus_msg_send(conn, name, cookie, flags, timeout, priority,
+				dst_id, KDBUS_SEND_SYNC_REPLY, cancel_fd);
+}
+
+int kdbus_msg_send_reply(const struct kdbus_conn *conn,
+			 uint64_t reply_cookie,
+			 uint64_t dst_id)
+{
+	struct kdbus_cmd_send cmd =3D {};
+	struct kdbus_msg *msg;
+	const char ref1[1024 * 128 + 3] =3D "0123456789_0";
+	struct kdbus_item *item;
+	uint64_t size;
+	int ret;
+
+	size =3D sizeof(struct kdbus_msg);
+	size +=3D KDBUS_ITEM_SIZE(sizeof(struct kdbus_vec));
+
+	msg =3D malloc(size);
+	if (!msg) {
+		kdbus_printf("unable to malloc()!?\n");
+		return -ENOMEM;
+	}
+
+	memset(msg, 0, size);
+	msg->size =3D size;
+	msg->src_id =3D conn->id;
+	msg->dst_id =3D dst_id;
+	msg->cookie_reply =3D reply_cookie;
+	msg->payload_type =3D KDBUS_PAYLOAD_DBUS;
+
+	item =3D msg->items;
+
+	item->type =3D KDBUS_ITEM_PAYLOAD_VEC;
+	item->size =3D KDBUS_ITEM_HEADER_SIZE + sizeof(struct kdbus_vec);
+	item->vec.address =3D (uintptr_t)&ref1;
+	item->vec.size =3D sizeof(ref1);
+	item =3D KDBUS_ITEM_NEXT(item);
+
+	cmd.size =3D sizeof(cmd);
+	cmd.msg_address =3D (uintptr_t)msg;
+
+	ret =3D kdbus_cmd_send(conn->fd, &cmd);
+	if (ret < 0)
+		kdbus_printf("error sending message: %d (%m)\n", ret);
+
+	free(msg);
+
+	return ret;
+}
+
+static char *msg_id(uint64_t id, char *buf)
+{
+	if (id =3D=3D 0)
+		return "KERNEL";
+	if (id =3D=3D ~0ULL)
+		return "BROADCAST";
+	sprintf(buf, "%llu", (unsigned long long)id);
+	return buf;
+}
+
+int kdbus_msg_dump(const struct kdbus_conn *conn, const struct kdbus_m=
sg *msg)
+{
+	const struct kdbus_item *item =3D msg->items;
+	char buf_src[32];
+	char buf_dst[32];
+	uint64_t timeout =3D 0;
+	uint64_t cookie_reply =3D 0;
+	int ret =3D 0;
+
+	if (msg->flags & KDBUS_MSG_EXPECT_REPLY)
+		timeout =3D msg->timeout_ns;
+	else
+		cookie_reply =3D msg->cookie_reply;
+
+	kdbus_printf("MESSAGE: %s (%llu bytes) flags=3D0x%08llx, %s =E2=86=92=
 %s, "
+		     "cookie=3D%llu, timeout=3D%llu cookie_reply=3D%llu priority=3D%=
lli\n",
+		enum_PAYLOAD(msg->payload_type), (unsigned long long)msg->size,
+		(unsigned long long)msg->flags,
+		msg_id(msg->src_id, buf_src), msg_id(msg->dst_id, buf_dst),
+		(unsigned long long)msg->cookie, (unsigned long long)timeout,
+		(unsigned long long)cookie_reply, (long long)msg->priority);
+
+	KDBUS_ITEM_FOREACH(item, msg, items) {
+		if (item->size < KDBUS_ITEM_HEADER_SIZE) {
+			kdbus_printf("  +%s (%llu bytes) invalid data record\n",
+				     enum_MSG(item->type), item->size);
+			ret =3D -EINVAL;
+			break;
+		}
+
+		switch (item->type) {
+		case KDBUS_ITEM_PAYLOAD_OFF: {
+			char *s;
+
+			if (item->vec.offset =3D=3D ~0ULL)
+				s =3D "[\\0-bytes]";
+			else
+				s =3D (char *)msg + item->vec.offset;
+
+			kdbus_printf("  +%s (%llu bytes) off=3D%llu size=3D%llu '%s'\n",
+			       enum_MSG(item->type), item->size,
+			       (unsigned long long)item->vec.offset,
+			       (unsigned long long)item->vec.size, s);
+			break;
+		}
+
+		case KDBUS_ITEM_FDS: {
+			int i, n =3D (item->size - KDBUS_ITEM_HEADER_SIZE) /
+					sizeof(int);
+
+			kdbus_printf("  +%s (%llu bytes, %d fds)\n",
+			       enum_MSG(item->type), item->size, n);
+
+			for (i =3D 0; i < n; i++)
+				kdbus_printf("    fd[%d] =3D %d\n",
+					     i, item->fds[i]);
+
+			break;
+		}
+
+		case KDBUS_ITEM_PAYLOAD_MEMFD: {
+			char *buf;
+			off_t size;
+
+			buf =3D mmap(NULL, item->memfd.size, PROT_READ,
+				   MAP_PRIVATE, item->memfd.fd, 0);
+			if (buf =3D=3D MAP_FAILED) {
+				kdbus_printf("mmap() fd=3D%i size=3D%llu failed: %m\n",
+					     item->memfd.fd, item->memfd.size);
+				break;
+			}
+
+			if (sys_memfd_get_size(item->memfd.fd, &size) < 0) {
+				kdbus_printf("KDBUS_CMD_MEMFD_SIZE_GET failed: %m\n");
+				break;
+			}
+
+			kdbus_printf("  +%s (%llu bytes) fd=3D%i size=3D%llu filesize=3D%ll=
u '%s'\n",
+			       enum_MSG(item->type), item->size, item->memfd.fd,
+			       (unsigned long long)item->memfd.size,
+			       (unsigned long long)size, buf);
+			munmap(buf, item->memfd.size);
+			break;
+		}
+
+		case KDBUS_ITEM_CREDS:
+			kdbus_printf("  +%s (%llu bytes) uid=3D%lld, euid=3D%lld, suid=3D%l=
ld, fsuid=3D%lld, "
+							"gid=3D%lld, egid=3D%lld, sgid=3D%lld, fsgid=3D%lld\n",
+				enum_MSG(item->type), item->size,
+				item->creds.uid, item->creds.euid,
+				item->creds.suid, item->creds.fsuid,
+				item->creds.gid, item->creds.egid,
+				item->creds.sgid, item->creds.fsgid);
+			break;
+
+		case KDBUS_ITEM_PIDS:
+			kdbus_printf("  +%s (%llu bytes) pid=3D%lld, tid=3D%lld, ppid=3D%ll=
d\n",
+				enum_MSG(item->type), item->size,
+				item->pids.pid, item->pids.tid,
+				item->pids.ppid);
+			break;
+
+		case KDBUS_ITEM_AUXGROUPS: {
+			int i, n;
+
+			kdbus_printf("  +%s (%llu bytes)\n",
+				     enum_MSG(item->type), item->size);
+			n =3D (item->size - KDBUS_ITEM_HEADER_SIZE) /
+				sizeof(uint64_t);
+
+			for (i =3D 0; i < n; i++)
+				kdbus_printf("    gid[%d] =3D %lld\n",
+					     i, item->data64[i]);
+			break;
+		}
+
+		case KDBUS_ITEM_NAME:
+		case KDBUS_ITEM_PID_COMM:
+		case KDBUS_ITEM_TID_COMM:
+		case KDBUS_ITEM_EXE:
+		case KDBUS_ITEM_CGROUP:
+		case KDBUS_ITEM_SECLABEL:
+		case KDBUS_ITEM_DST_NAME:
+		case KDBUS_ITEM_CONN_DESCRIPTION:
+			kdbus_printf("  +%s (%llu bytes) '%s' (%zu)\n",
+				     enum_MSG(item->type), item->size,
+				     item->str, strlen(item->str));
+			break;
+
+		case KDBUS_ITEM_OWNED_NAME: {
+			kdbus_printf("  +%s (%llu bytes) '%s' (%zu) flags=3D0x%08llx\n",
+				     enum_MSG(item->type), item->size,
+				     item->name.name, strlen(item->name.name),
+				     item->name.flags);
+			break;
+		}
+
+		case KDBUS_ITEM_CMDLINE: {
+			size_t size =3D item->size - KDBUS_ITEM_HEADER_SIZE;
+			const char *str =3D item->str;
+			int count =3D 0;
+
+			kdbus_printf("  +%s (%llu bytes) ",
+				     enum_MSG(item->type), item->size);
+			while (size) {
+				kdbus_printf("'%s' ", str);
+				size -=3D strlen(str) + 1;
+				str +=3D strlen(str) + 1;
+				count++;
+			}
+
+			kdbus_printf("(%d string%s)\n",
+				     count, (count =3D=3D 1) ? "" : "s");
+			break;
+		}
+
+		case KDBUS_ITEM_AUDIT:
+			kdbus_printf("  +%s (%llu bytes) loginuid=3D%u sessionid=3D%u\n",
+			       enum_MSG(item->type), item->size,
+			       item->audit.loginuid, item->audit.sessionid);
+			break;
+
+		case KDBUS_ITEM_CAPS: {
+			const uint32_t *cap;
+			int n, i;
+
+			kdbus_printf("  +%s (%llu bytes) len=3D%llu bytes, last_cap %d\n",
+				     enum_MSG(item->type), item->size,
+				     (unsigned long long)item->size -
+					KDBUS_ITEM_HEADER_SIZE,
+				     (int) item->caps.last_cap);
+
+			cap =3D item->caps.caps;
+			n =3D (item->size - offsetof(struct kdbus_item, caps.caps))
+				/ 4 / sizeof(uint32_t);
+
+			kdbus_printf("    CapInh=3D");
+			for (i =3D 0; i < n; i++)
+				kdbus_printf("%08x", cap[(0 * n) + (n - i - 1)]);
+
+			kdbus_printf(" CapPrm=3D");
+			for (i =3D 0; i < n; i++)
+				kdbus_printf("%08x", cap[(1 * n) + (n - i - 1)]);
+
+			kdbus_printf(" CapEff=3D");
+			for (i =3D 0; i < n; i++)
+				kdbus_printf("%08x", cap[(2 * n) + (n - i - 1)]);
+
+			kdbus_printf(" CapBnd=3D");
+			for (i =3D 0; i < n; i++)
+				kdbus_printf("%08x", cap[(3 * n) + (n - i - 1)]);
+			kdbus_printf("\n");
+			break;
+		}
+
+		case KDBUS_ITEM_TIMESTAMP:
+			kdbus_printf("  +%s (%llu bytes) seq=3D%llu realtime=3D%lluns monot=
onic=3D%lluns\n",
+			       enum_MSG(item->type), item->size,
+			       (unsigned long long)item->timestamp.seqnum,
+			       (unsigned long long)item->timestamp.realtime_ns,
+			       (unsigned long long)item->timestamp.monotonic_ns);
+			break;
+
+		case KDBUS_ITEM_REPLY_TIMEOUT:
+			kdbus_printf("  +%s (%llu bytes) cookie=3D%llu\n",
+			       enum_MSG(item->type), item->size,
+			       msg->cookie_reply);
+			break;
+
+		case KDBUS_ITEM_NAME_ADD:
+		case KDBUS_ITEM_NAME_REMOVE:
+		case KDBUS_ITEM_NAME_CHANGE:
+			kdbus_printf("  +%s (%llu bytes) '%s', old id=3D%lld, now id=3D%lld=
, old_flags=3D0x%llx new_flags=3D0x%llx\n",
+				enum_MSG(item->type),
+				(unsigned long long) item->size,
+				item->name_change.name,
+				item->name_change.old_id.id,
+				item->name_change.new_id.id,
+				item->name_change.old_id.flags,
+				item->name_change.new_id.flags);
+			break;
+
+		case KDBUS_ITEM_ID_ADD:
+		case KDBUS_ITEM_ID_REMOVE:
+			kdbus_printf("  +%s (%llu bytes) id=3D%llu flags=3D%llu\n",
+			       enum_MSG(item->type),
+			       (unsigned long long) item->size,
+			       (unsigned long long) item->id_change.id,
+			       (unsigned long long) item->id_change.flags);
+			break;
+
+		default:
+			kdbus_printf("  +%s (%llu bytes)\n",
+				     enum_MSG(item->type), item->size);
+			break;
+		}
+	}
+
+	if ((char *)item - ((char *)msg + msg->size) >=3D 8) {
+		kdbus_printf("invalid padding at end of message\n");
+		ret =3D -EINVAL;
+	}
+
+	kdbus_printf("\n");
+
+	return ret;
+}
+
+void kdbus_msg_free(struct kdbus_msg *msg)
+{
+	const struct kdbus_item *item;
+	int nfds, i;
+
+	if (!msg)
+		return;
+
+	KDBUS_ITEM_FOREACH(item, msg, items) {
+		switch (item->type) {
+		/* close all memfds */
+		case KDBUS_ITEM_PAYLOAD_MEMFD:
+			close(item->memfd.fd);
+			break;
+		case KDBUS_ITEM_FDS:
+			nfds =3D (item->size - KDBUS_ITEM_HEADER_SIZE) /
+				sizeof(int);
+
+			for (i =3D 0; i < nfds; i++)
+				close(item->fds[i]);
+
+			break;
+		}
+	}
+}
+
+int kdbus_msg_recv(struct kdbus_conn *conn,
+		   struct kdbus_msg **msg_out,
+		   uint64_t *offset)
+{
+	struct kdbus_cmd_recv recv =3D { .size =3D sizeof(recv) };
+	struct kdbus_msg *msg;
+	int ret;
+
+	ret =3D kdbus_cmd_recv(conn->fd, &recv);
+	if (ret < 0)
+		return ret;
+
+	msg =3D (struct kdbus_msg *)(conn->buf + recv.msg.offset);
+	ret =3D kdbus_msg_dump(conn, msg);
+	if (ret < 0) {
+		kdbus_msg_free(msg);
+		return ret;
+	}
+
+	if (msg_out) {
+		*msg_out =3D msg;
+
+		if (offset)
+			*offset =3D recv.msg.offset;
+	} else {
+		kdbus_msg_free(msg);
+
+		ret =3D kdbus_free(conn, recv.msg.offset);
+		if (ret < 0)
+			return ret;
+	}
+
+	return 0;
+}
+
+/*
+ * Returns: 0 on success, negative errno on failure.
+ *
+ * We must return -ETIMEDOUT, -ECONNREST, -EAGAIN and other errors.
+ * We must return the result of kdbus_msg_recv()
+ */
+int kdbus_msg_recv_poll(struct kdbus_conn *conn,
+			int timeout_ms,
+			struct kdbus_msg **msg_out,
+			uint64_t *offset)
+{
+	int ret;
+
+	do {
+		struct timeval before, after, diff;
+		struct pollfd fd;
+
+		fd.fd =3D conn->fd;
+		fd.events =3D POLLIN | POLLPRI | POLLHUP;
+		fd.revents =3D 0;
+
+		gettimeofday(&before, NULL);
+		ret =3D poll(&fd, 1, timeout_ms);
+		gettimeofday(&after, NULL);
+
+		if (ret =3D=3D 0) {
+			ret =3D -ETIMEDOUT;
+			break;
+		}
+
+		if (ret > 0) {
+			if (fd.revents & POLLIN)
+				ret =3D kdbus_msg_recv(conn, msg_out, offset);
+
+			if (fd.revents & (POLLHUP | POLLERR))
+				ret =3D -ECONNRESET;
+		}
+
+		if (ret =3D=3D 0 || ret !=3D -EAGAIN)
+			break;
+
+		timersub(&after, &before, &diff);
+		timeout_ms -=3D diff.tv_sec * 1000UL +
+			      diff.tv_usec / 1000UL;
+	} while (timeout_ms > 0);
+
+	return ret;
+}
+
+int kdbus_free(const struct kdbus_conn *conn, uint64_t offset)
+{
+	struct kdbus_cmd_free cmd_free =3D {};
+	int ret;
+
+	cmd_free.size =3D sizeof(cmd_free);
+	cmd_free.offset =3D offset;
+	cmd_free.flags =3D 0;
+
+	ret =3D kdbus_cmd_free(conn->fd, &cmd_free);
+	if (ret < 0) {
+		kdbus_printf("KDBUS_CMD_FREE failed: %d (%m)\n", ret);
+		return ret;
+	}
+
+	return 0;
+}
+
+int kdbus_name_acquire(struct kdbus_conn *conn,
+		       const char *name, uint64_t *flags)
+{
+	struct kdbus_cmd *cmd_name;
+	size_t name_len =3D strlen(name) + 1;
+	uint64_t size =3D sizeof(*cmd_name) + KDBUS_ITEM_SIZE(name_len);
+	struct kdbus_item *item;
+	int ret;
+
+	cmd_name =3D alloca(size);
+
+	memset(cmd_name, 0, size);
+
+	item =3D cmd_name->items;
+	item->size =3D KDBUS_ITEM_HEADER_SIZE + name_len;
+	item->type =3D KDBUS_ITEM_NAME;
+	strcpy(item->str, name);
+
+	cmd_name->size =3D size;
+	if (flags)
+		cmd_name->flags =3D *flags;
+
+	ret =3D kdbus_cmd_name_acquire(conn->fd, cmd_name);
+	if (ret < 0) {
+		kdbus_printf("error aquiring name: %s\n", strerror(-ret));
+		return ret;
+	}
+
+	kdbus_printf("%s(): flags after call: 0x%llx\n", __func__,
+		     cmd_name->return_flags);
+
+	if (flags)
+		*flags =3D cmd_name->return_flags;
+
+	return 0;
+}
+
+int kdbus_name_release(struct kdbus_conn *conn, const char *name)
+{
+	struct kdbus_cmd *cmd_name;
+	size_t name_len =3D strlen(name) + 1;
+	uint64_t size =3D sizeof(*cmd_name) + KDBUS_ITEM_SIZE(name_len);
+	struct kdbus_item *item;
+	int ret;
+
+	cmd_name =3D alloca(size);
+
+	memset(cmd_name, 0, size);
+
+	item =3D cmd_name->items;
+	item->size =3D KDBUS_ITEM_HEADER_SIZE + name_len;
+	item->type =3D KDBUS_ITEM_NAME;
+	strcpy(item->str, name);
+
+	cmd_name->size =3D size;
+
+	kdbus_printf("conn %lld giving up name '%s'\n",
+		     (unsigned long long) conn->id, name);
+
+	ret =3D kdbus_cmd_name_release(conn->fd, cmd_name);
+	if (ret < 0) {
+		kdbus_printf("error releasing name: %s\n", strerror(-ret));
+		return ret;
+	}
+
+	return 0;
+}
+
+int kdbus_list(struct kdbus_conn *conn, uint64_t flags)
+{
+	struct kdbus_cmd_list cmd_list =3D {};
+	struct kdbus_info *list, *name;
+	int ret;
+
+	cmd_list.size =3D sizeof(cmd_list);
+	cmd_list.flags =3D flags;
+
+	ret =3D kdbus_cmd_list(conn->fd, &cmd_list);
+	if (ret < 0) {
+		kdbus_printf("error listing names: %d (%m)\n", ret);
+		return ret;
+	}
+
+	kdbus_printf("REGISTRY:\n");
+	list =3D (struct kdbus_info *)(conn->buf + cmd_list.offset);
+
+	KDBUS_FOREACH(name, list, cmd_list.list_size) {
+		uint64_t flags =3D 0;
+		struct kdbus_item *item;
+		const char *n =3D "MISSING-NAME";
+
+		if (name->size =3D=3D sizeof(struct kdbus_cmd))
+			continue;
+
+		KDBUS_ITEM_FOREACH(item, name, items)
+			if (item->type =3D=3D KDBUS_ITEM_OWNED_NAME) {
+				n =3D item->name.name;
+				flags =3D item->name.flags;
+			}
+
+		kdbus_printf("%8llu flags=3D0x%08llx conn=3D0x%08llx '%s'\n",
+			     name->id, (unsigned long long) flags,
+			     name->flags, n);
+	}
+	kdbus_printf("\n");
+
+	ret =3D kdbus_free(conn, cmd_list.offset);
+
+	return ret;
+}
+
+int kdbus_conn_update_attach_flags(struct kdbus_conn *conn,
+				   uint64_t attach_flags_send,
+				   uint64_t attach_flags_recv)
+{
+	int ret;
+	size_t size;
+	struct kdbus_cmd *update;
+	struct kdbus_item *item;
+
+	size =3D sizeof(struct kdbus_cmd);
+	size +=3D KDBUS_ITEM_SIZE(sizeof(uint64_t)) * 2;
+
+	update =3D malloc(size);
+	if (!update) {
+		kdbus_printf("error malloc: %m\n");
+		return -ENOMEM;
+	}
+
+	memset(update, 0, size);
+	update->size =3D size;
+
+	item =3D update->items;
+
+	item->type =3D KDBUS_ITEM_ATTACH_FLAGS_SEND;
+	item->size =3D KDBUS_ITEM_HEADER_SIZE + sizeof(uint64_t);
+	item->data64[0] =3D attach_flags_send;
+	item =3D KDBUS_ITEM_NEXT(item);
+
+	item->type =3D KDBUS_ITEM_ATTACH_FLAGS_RECV;
+	item->size =3D KDBUS_ITEM_HEADER_SIZE + sizeof(uint64_t);
+	item->data64[0] =3D attach_flags_recv;
+	item =3D KDBUS_ITEM_NEXT(item);
+
+	ret =3D kdbus_cmd_update(conn->fd, update);
+	if (ret < 0)
+		kdbus_printf("error conn update: %d (%m)\n", ret);
+
+	free(update);
+
+	return ret;
+}
+
+int kdbus_conn_update_policy(struct kdbus_conn *conn, const char *name=
,
+			     const struct kdbus_policy_access *access,
+			     size_t num_access)
+{
+	struct kdbus_cmd *update;
+	struct kdbus_item *item;
+	size_t i, size;
+	int ret;
+
+	size =3D sizeof(struct kdbus_cmd);
+	size +=3D KDBUS_ITEM_SIZE(strlen(name) + 1);
+	size +=3D num_access * KDBUS_ITEM_SIZE(sizeof(struct kdbus_policy_acc=
ess));
+
+	update =3D malloc(size);
+	if (!update) {
+		kdbus_printf("error malloc: %m\n");
+		return -ENOMEM;
+	}
+
+	memset(update, 0, size);
+	update->size =3D size;
+
+	item =3D update->items;
+
+	item->type =3D KDBUS_ITEM_NAME;
+	item->size =3D KDBUS_ITEM_HEADER_SIZE + strlen(name) + 1;
+	strcpy(item->str, name);
+	item =3D KDBUS_ITEM_NEXT(item);
+
+	for (i =3D 0; i < num_access; i++) {
+		item->size =3D KDBUS_ITEM_HEADER_SIZE +
+			     sizeof(struct kdbus_policy_access);
+		item->type =3D KDBUS_ITEM_POLICY_ACCESS;
+
+		item->policy_access.type =3D access[i].type;
+		item->policy_access.access =3D access[i].access;
+		item->policy_access.id =3D access[i].id;
+
+		item =3D KDBUS_ITEM_NEXT(item);
+	}
+
+	ret =3D kdbus_cmd_update(conn->fd, update);
+	if (ret < 0)
+		kdbus_printf("error conn update: %d (%m)\n", ret);
+
+	free(update);
+
+	return ret;
+}
+
+int kdbus_add_match_id(struct kdbus_conn *conn, uint64_t cookie,
+		       uint64_t type, uint64_t id)
+{
+	struct {
+		struct kdbus_cmd_match cmd;
+		struct {
+			uint64_t size;
+			uint64_t type;
+			struct kdbus_notify_id_change chg;
+		} item;
+	} buf;
+	int ret;
+
+	memset(&buf, 0, sizeof(buf));
+
+	buf.cmd.size =3D sizeof(buf);
+	buf.cmd.cookie =3D cookie;
+	buf.item.size =3D sizeof(buf.item);
+	buf.item.type =3D type;
+	buf.item.chg.id =3D id;
+
+	ret =3D kdbus_cmd_match_add(conn->fd, &buf.cmd);
+	if (ret < 0)
+		kdbus_printf("--- error adding conn match: %d (%m)\n", ret);
+
+	return ret;
+}
+
+int kdbus_add_match_empty(struct kdbus_conn *conn)
+{
+	struct {
+		struct kdbus_cmd_match cmd;
+		struct kdbus_item item;
+	} buf;
+	int ret;
+
+	memset(&buf, 0, sizeof(buf));
+
+	buf.item.size =3D sizeof(uint64_t) * 3;
+	buf.item.type =3D KDBUS_ITEM_ID;
+	buf.item.id =3D KDBUS_MATCH_ID_ANY;
+
+	buf.cmd.size =3D sizeof(buf.cmd) + buf.item.size;
+
+	ret =3D kdbus_cmd_match_add(conn->fd, &buf.cmd);
+	if (ret < 0)
+		kdbus_printf("--- error adding conn match: %d (%m)\n", ret);
+
+	return ret;
+}
+
+static int all_ids_are_mapped(const char *path)
+{
+	int ret;
+	FILE *file;
+	uint32_t inside_id, length;
+
+	file =3D fopen(path, "r");
+	if (!file) {
+		ret =3D -errno;
+		kdbus_printf("error fopen() %s: %d (%m)\n",
+			     path, ret);
+		return ret;
+	}
+
+	ret =3D fscanf(file, "%u\t%*u\t%u", &inside_id, &length);
+	if (ret !=3D 2) {
+		if (ferror(file))
+			ret =3D -errno;
+		else
+			ret =3D -EIO;
+
+		kdbus_printf("--- error fscanf(): %d\n", ret);
+		fclose(file);
+		return ret;
+	}
+
+	fclose(file);
+
+	/*
+	 * If length is 4294967295 which means the invalid uid
+	 * (uid_t) -1 then we are able to map all uid/gids
+	 */
+	if (inside_id =3D=3D 0 && length =3D=3D (uid_t) -1)
+		return 1;
+
+	return 0;
+}
+
+int all_uids_gids_are_mapped()
+{
+	int ret;
+
+	ret =3D all_ids_are_mapped("/proc/self/uid_map");
+	if (ret <=3D 0) {
+		kdbus_printf("--- error not all uids are mapped\n");
+		return 0;
+	}
+
+	ret =3D all_ids_are_mapped("/proc/self/gid_map");
+	if (ret <=3D 0) {
+		kdbus_printf("--- error not all gids are mapped\n");
+		return 0;
+	}
+
+	return 1;
+}
+
+int drop_privileges(uid_t uid, gid_t gid)
+{
+	int ret;
+
+	ret =3D setgroups(0, NULL);
+	if (ret < 0) {
+		ret =3D -errno;
+		kdbus_printf("error setgroups: %d (%m)\n", ret);
+		return ret;
+	}
+
+	ret =3D setresgid(gid, gid, gid);
+	if (ret < 0) {
+		ret =3D -errno;
+		kdbus_printf("error setresgid: %d (%m)\n", ret);
+		return ret;
+	}
+
+	ret =3D setresuid(uid, uid, uid);
+	if (ret < 0) {
+		ret =3D -errno;
+		kdbus_printf("error setresuid: %d (%m)\n", ret);
+		return ret;
+	}
+
+	return ret;
+}
+
+uint64_t now(clockid_t clock)
+{
+	struct timespec spec;
+
+	clock_gettime(clock, &spec);
+	return spec.tv_sec * 1000ULL * 1000ULL * 1000ULL + spec.tv_nsec;
+}
+
+char *unique_name(const char *prefix)
+{
+	unsigned int i;
+	uint64_t u_now;
+	char n[17];
+	char *str;
+	int r;
+
+	/*
+	 * This returns a random string which is guaranteed to be
+	 * globally unique across all calls to unique_name(). We
+	 * compose the string as:
+	 *   <prefix>-<random>-<time>
+	 * With:
+	 *   <prefix>: string provided by the caller
+	 *   <random>: a random alpha string of 16 characters
+	 *   <time>: the current time in micro-seconds since last boot
+	 *
+	 * The <random> part makes the string always look vastly different,
+	 * the <time> part makes sure no two calls return the same string.
+	 */
+
+	u_now =3D now(CLOCK_MONOTONIC);
+
+	for (i =3D 0; i < sizeof(n) - 1; ++i)
+		n[i] =3D 'a' + (rand() % ('z' - 'a'));
+	n[sizeof(n) - 1] =3D 0;
+
+	r =3D asprintf(&str, "%s-%s-%" PRIu64, prefix, n, u_now);
+	if (r < 0)
+		return NULL;
+
+	return str;
+}
+
+static int do_userns_map_id(pid_t pid,
+			    const char *map_file,
+			    const char *map_id)
+{
+	int ret;
+	int fd;
+	char *map;
+	unsigned int i;
+
+	map =3D strndupa(map_id, strlen(map_id));
+	if (!map) {
+		ret =3D -errno;
+		kdbus_printf("error strndupa %s: %d (%m)\n",
+			map_file, ret);
+		return ret;
+	}
+
+	for (i =3D 0; i < strlen(map); i++)
+		if (map[i] =3D=3D ',')
+			map[i] =3D '\n';
+
+	fd =3D open(map_file, O_RDWR);
+	if (fd < 0) {
+		ret =3D -errno;
+		kdbus_printf("error open %s: %d (%m)\n",
+			map_file, ret);
+		return ret;
+	}
+
+	ret =3D write(fd, map, strlen(map));
+	if (ret < 0) {
+		ret =3D -errno;
+		kdbus_printf("error write to %s: %d (%m)\n",
+			     map_file, ret);
+		goto out;
+	}
+
+	ret =3D 0;
+
+out:
+	close(fd);
+	return ret;
+}
+
+int userns_map_uid_gid(pid_t pid,
+		       const char *map_uid,
+		       const char *map_gid)
+{
+	int fd, ret;
+	char file_id[128] =3D {'\0'};
+
+	snprintf(file_id, sizeof(file_id), "/proc/%ld/uid_map",
+		 (long) pid);
+
+	ret =3D do_userns_map_id(pid, file_id, map_uid);
+	if (ret < 0)
+		return ret;
+
+	snprintf(file_id, sizeof(file_id), "/proc/%ld/setgroups",
+		 (long) pid);
+
+	fd =3D open(file_id, O_WRONLY);
+	if (fd >=3D 0) {
+		write(fd, "deny\n", 5);
+		close(fd);
+	}
+
+	snprintf(file_id, sizeof(file_id), "/proc/%ld/gid_map",
+		 (long) pid);
+
+	return do_userns_map_id(pid, file_id, map_gid);
+}
+
+static int do_cap_get_flag(cap_t caps, cap_value_t cap)
+{
+	int ret;
+	cap_flag_value_t flag_set;
+
+	ret =3D cap_get_flag(caps, cap, CAP_EFFECTIVE, &flag_set);
+	if (ret < 0) {
+		ret =3D -errno;
+		kdbus_printf("error cap_get_flag(): %d (%m)\n", ret);
+		return ret;
+	}
+
+	return (flag_set =3D=3D CAP_SET);
+}
+
+/*
+ * Returns:
+ *  1 in case all the requested effective capabilities are set.
+ *  0 in case we do not have the requested capabilities. This value
+ *    will be used to abort tests with TEST_SKIP
+ *  Negative errno on failure.
+ *
+ *  Terminate args with a negative value.
+ */
+int test_is_capable(int cap, ...)
+{
+	int ret;
+	va_list ap;
+	cap_t caps;
+
+	caps =3D cap_get_proc();
+	if (!cap) {
+		ret =3D -errno;
+		kdbus_printf("error cap_get_proc(): %d (%m)\n", ret);
+		return ret;
+	}
+
+	ret =3D do_cap_get_flag(caps, (cap_value_t)cap);
+	if (ret <=3D 0)
+		goto out;
+
+	va_start(ap, cap);
+	while ((cap =3D va_arg(ap, int)) > 0) {
+		ret =3D do_cap_get_flag(caps, (cap_value_t)cap);
+		if (ret <=3D 0)
+			break;
+	}
+	va_end(ap);
+
+out:
+	cap_free(caps);
+	return ret;
+}
+
+int config_user_ns_is_enabled(void)
+{
+	return (access("/proc/self/uid_map", F_OK) =3D=3D 0);
+}
+
+int config_auditsyscall_is_enabled(void)
+{
+	return (access("/proc/self/loginuid", F_OK) =3D=3D 0);
+}
+
+int config_cgroups_is_enabled(void)
+{
+	return (access("/proc/self/cgroup", F_OK) =3D=3D 0);
+}
+
+int config_security_is_enabled(void)
+{
+	int fd;
+	int ret;
+	char buf[128];
+
+	/* CONFIG_SECURITY is disabled */
+	if (access("/proc/self/attr/current", F_OK) !=3D 0)
+		return 0;
+
+	/*
+	 * Now only if read() fails with -EINVAL then we assume
+	 * that SECLABEL and LSM are disabled
+	 */
+	fd =3D open("/proc/self/attr/current", O_RDONLY|O_CLOEXEC);
+	if (fd < 0)
+		return 1;
+
+	ret =3D read(fd, buf, sizeof(buf));
+	if (ret =3D=3D -1 && errno =3D=3D EINVAL)
+		ret =3D 0;
+	else
+		ret =3D 1;
+
+	close(fd);
+
+	return ret;
+}
diff --git a/tools/testing/selftests/kdbus/kdbus-util.h b/tools/testing=
/selftests/kdbus/kdbus-util.h
new file mode 100644
index 000000000000..50ff07140bdd
--- /dev/null
+++ b/tools/testing/selftests/kdbus/kdbus-util.h
@@ -0,0 +1,222 @@
+/*
+ * Copyright (C) 2013-2015 Kay Sievers
+ * Copyright (C) 2013-2015 Daniel Mack
+ *
+ * kdbus is free software; you can redistribute it and/or modify it un=
der
+ * the terms of the GNU Lesser General Public License as published by =
the
+ * Free Software Foundation; either version 2.1 of the License, or (at
+ * your option) any later version.
+ */
+#pragma once
+
+#define BIT(X) (1 << (X))
+
+#include <time.h>
+#include <stdbool.h>
+#include <linux/kdbus.h>
+
+#define _STRINGIFY(x) #x
+#define STRINGIFY(x) _STRINGIFY(x)
+#define ELEMENTSOF(x) (sizeof(x)/sizeof((x)[0]))
+
+#define KDBUS_PTR(addr) ((void *)(uintptr_t)(addr))
+
+#define KDBUS_ALIGN8(l) (((l) + 7) & ~7)
+#define KDBUS_ITEM_HEADER_SIZE offsetof(struct kdbus_item, data)
+#define KDBUS_ITEM_SIZE(s) KDBUS_ALIGN8((s) + KDBUS_ITEM_HEADER_SIZE)
+
+#define KDBUS_ITEM_NEXT(item) \
+	(typeof(item))(((uint8_t *)item) + KDBUS_ALIGN8((item)->size))
+#define KDBUS_ITEM_FOREACH(item, head, first)				\
+	for (item =3D (head)->first;					\
+	     ((uint8_t *)(item) < (uint8_t *)(head) + (head)->size) &&	\
+	       ((uint8_t *)(item) >=3D (uint8_t *)(head));	\
+	     item =3D KDBUS_ITEM_NEXT(item))
+#define KDBUS_FOREACH(iter, first, _size)				\
+	for (iter =3D (first);						\
+	     ((uint8_t *)(iter) < (uint8_t *)(first) + (_size)) &&	\
+	       ((uint8_t *)(iter) >=3D (uint8_t *)(first));		\
+	     iter =3D (void*)(((uint8_t *)iter) + KDBUS_ALIGN8((iter)->size))=
)
+
+
+#define _KDBUS_ATTACH_BITS_SET_NR  (__builtin_popcountll(_KDBUS_ATTACH=
_ALL))
+
+/* Sum of KDBUS_ITEM_* that reflects _KDBUS_ATTACH_ALL */
+#define KDBUS_ATTACH_ITEMS_TYPE_SUM \
+	((((_KDBUS_ATTACH_BITS_SET_NR - 1) * \
+	((_KDBUS_ATTACH_BITS_SET_NR - 1) + 1)) / 2 ) + \
+	(_KDBUS_ITEM_ATTACH_BASE * _KDBUS_ATTACH_BITS_SET_NR))
+
+
+#define POOL_SIZE (16 * 1024LU * 1024LU)
+
+#define UNPRIV_UID 65534
+#define UNPRIV_GID 65534
+
+/* Dump as user of process, useful for user namespace testing */
+#define SUID_DUMP_USER	1
+
+extern int kdbus_util_verbose;
+
+#define kdbus_printf(X...) \
+	if (kdbus_util_verbose) \
+		printf(X)
+
+#define RUN_UNPRIVILEGED(child_uid, child_gid, _child_, _parent_) ({	\
+		pid_t pid, rpid;					\
+		int ret;						\
+									\
+		pid =3D fork();						\
+		if (pid =3D=3D 0) {						\
+			ret =3D drop_privileges(child_uid, child_gid);	\
+			ASSERT_EXIT_VAL(ret =3D=3D 0, ret);			\
+									\
+			_child_;					\
+			_exit(0);					\
+		} else if (pid > 0) {					\
+			_parent_;					\
+			rpid =3D waitpid(pid, &ret, 0);			\
+			ASSERT_RETURN(rpid =3D=3D pid);			\
+			ASSERT_RETURN(WIFEXITED(ret));			\
+			ASSERT_RETURN(WEXITSTATUS(ret) =3D=3D 0);		\
+			ret =3D TEST_OK;					\
+		} else {						\
+			ret =3D pid;					\
+		}							\
+									\
+		ret;							\
+	})
+
+#define RUN_UNPRIVILEGED_CONN(_var_, _bus_, _code_)			\
+	RUN_UNPRIVILEGED(UNPRIV_UID, UNPRIV_GID, ({			\
+		struct kdbus_conn *_var_;				\
+		_var_ =3D kdbus_hello(_bus_, 0, NULL, 0);			\
+		ASSERT_EXIT(_var_);					\
+		_code_;							\
+		kdbus_conn_free(_var_);					\
+	}), ({ 0; }))
+
+#define RUN_CLONE_CHILD(clone_ret, flags, _setup_, _child_body_,	\
+			_parent_setup_, _parent_body_) ({		\
+	pid_t pid, rpid;						\
+	int ret;							\
+	int efd =3D -1;							\
+									\
+	_setup_;							\
+	efd =3D eventfd(0, EFD_CLOEXEC);					\
+	ASSERT_RETURN(efd >=3D 0);					\
+	*clone_ret =3D 0;							\
+	pid =3D syscall(__NR_clone, flags, NULL);				\
+	if (pid =3D=3D 0) {							\
+		eventfd_t event_status =3D 0;				\
+		ret =3D prctl(PR_SET_PDEATHSIG, SIGKILL);			\
+		ASSERT_EXIT(ret =3D=3D 0);					\
+		ret =3D eventfd_read(efd, &event_status);			\
+		if (ret < 0 || event_status !=3D 1) {			\
+			kdbus_printf("error eventfd_read()\n");		\
+			_exit(EXIT_FAILURE);				\
+		}							\
+		_child_body_;						\
+		_exit(0);						\
+	} else if (pid > 0) {						\
+		_parent_setup_;						\
+		ret =3D eventfd_write(efd, 1);				\
+		ASSERT_RETURN(ret >=3D 0);				\
+		_parent_body_;						\
+		rpid =3D waitpid(pid, &ret, 0);				\
+		ASSERT_RETURN(rpid =3D=3D pid);				\
+		ASSERT_RETURN(WIFEXITED(ret));				\
+		ASSERT_RETURN(WEXITSTATUS(ret) =3D=3D 0);			\
+		ret =3D TEST_OK;						\
+	} else {							\
+		ret =3D -errno;						\
+		*clone_ret =3D -errno;					\
+	}								\
+	close(efd);							\
+	ret;								\
+})
+
+/* Enums for parent if it should drop privs or not */
+enum kdbus_drop_parent {
+	DO_NOT_DROP,
+	DROP_SAME_UNPRIV,
+	DROP_OTHER_UNPRIV,
+};
+
+struct kdbus_conn {
+	int fd;
+	uint64_t id;
+	unsigned char *buf;
+};
+
+int kdbus_sysfs_get_parameter_mask(const char *path, uint64_t *mask);
+int kdbus_sysfs_set_parameter_mask(const char *path, uint64_t mask);
+
+int sys_memfd_create(const char *name, __u64 size);
+int sys_memfd_seal_set(int fd);
+off_t sys_memfd_get_size(int fd, off_t *size);
+
+int kdbus_list(struct kdbus_conn *conn, uint64_t flags);
+int kdbus_name_release(struct kdbus_conn *conn, const char *name);
+int kdbus_name_acquire(struct kdbus_conn *conn, const char *name,
+		       uint64_t *flags);
+void kdbus_msg_free(struct kdbus_msg *msg);
+int kdbus_msg_recv(struct kdbus_conn *conn,
+		   struct kdbus_msg **msg, uint64_t *offset);
+int kdbus_msg_recv_poll(struct kdbus_conn *conn, int timeout_ms,
+			struct kdbus_msg **msg_out, uint64_t *offset);
+int kdbus_free(const struct kdbus_conn *conn, uint64_t offset);
+int kdbus_msg_dump(const struct kdbus_conn *conn,
+		   const struct kdbus_msg *msg);
+int kdbus_create_bus(int control_fd, const char *name,
+		     uint64_t req_meta, uint64_t owner_meta,
+		     char **path);
+int kdbus_msg_send(const struct kdbus_conn *conn, const char *name,
+		   uint64_t cookie, uint64_t flags, uint64_t timeout,
+		   int64_t priority, uint64_t dst_id);
+int kdbus_msg_send_sync(const struct kdbus_conn *conn, const char *nam=
e,
+			uint64_t cookie, uint64_t flags, uint64_t timeout,
+			int64_t priority, uint64_t dst_id, int cancel_fd);
+int kdbus_msg_send_reply(const struct kdbus_conn *conn,
+			 uint64_t reply_cookie,
+			 uint64_t dst_id);
+struct kdbus_conn *kdbus_hello(const char *path, uint64_t hello_flags,
+			       const struct kdbus_item *item,
+			       size_t item_size);
+struct kdbus_conn *kdbus_hello_registrar(const char *path, const char =
*name,
+					 const struct kdbus_policy_access *access,
+					 size_t num_access, uint64_t flags);
+struct kdbus_conn *kdbus_hello_activator(const char *path, const char =
*name,
+					 const struct kdbus_policy_access *access,
+					 size_t num_access);
+bool kdbus_item_in_message(struct kdbus_msg *msg, uint64_t type);
+int kdbus_bus_creator_info(struct kdbus_conn *conn,
+			   uint64_t flags,
+			   uint64_t *offset);
+int kdbus_conn_info(struct kdbus_conn *conn, uint64_t id,
+		    const char *name, uint64_t flags, uint64_t *offset);
+void kdbus_conn_free(struct kdbus_conn *conn);
+int kdbus_conn_update_attach_flags(struct kdbus_conn *conn,
+				   uint64_t attach_flags_send,
+				   uint64_t attach_flags_recv);
+int kdbus_conn_update_policy(struct kdbus_conn *conn, const char *name=
,
+			     const struct kdbus_policy_access *access,
+			     size_t num_access);
+
+int kdbus_add_match_id(struct kdbus_conn *conn, uint64_t cookie,
+		       uint64_t type, uint64_t id);
+int kdbus_add_match_empty(struct kdbus_conn *conn);
+
+int all_uids_gids_are_mapped();
+int drop_privileges(uid_t uid, gid_t gid);
+uint64_t now(clockid_t clock);
+char *unique_name(const char *prefix);
+
+int userns_map_uid_gid(pid_t pid,
+		       const char *map_uid,
+		       const char *map_gid);
+int test_is_capable(int cap, ...);
+int config_user_ns_is_enabled(void);
+int config_auditsyscall_is_enabled(void);
+int config_cgroups_is_enabled(void);
+int config_security_is_enabled(void);
diff --git a/tools/testing/selftests/kdbus/test-activator.c b/tools/tes=
ting/selftests/kdbus/test-activator.c
new file mode 100644
index 000000000000..3d1b76370ce8
--- /dev/null
+++ b/tools/testing/selftests/kdbus/test-activator.c
@@ -0,0 +1,318 @@
+#include <stdio.h>
+#include <string.h>
+#include <time.h>
+#include <fcntl.h>
+#include <stdlib.h>
+#include <stdbool.h>
+#include <stddef.h>
+#include <unistd.h>
+#include <stdint.h>
+#include <errno.h>
+#include <assert.h>
+#include <poll.h>
+#include <sys/capability.h>
+#include <sys/types.h>
+#include <sys/wait.h>
+
+#include "kdbus-test.h"
+#include "kdbus-util.h"
+#include "kdbus-enum.h"
+
+static int kdbus_starter_poll(struct kdbus_conn *conn)
+{
+	int ret;
+	struct pollfd fd;
+
+	fd.fd =3D conn->fd;
+	fd.events =3D POLLIN | POLLPRI | POLLHUP;
+	fd.revents =3D 0;
+
+	ret =3D poll(&fd, 1, 100);
+	if (ret =3D=3D 0)
+		return -ETIMEDOUT;
+	else if (ret > 0) {
+		if (fd.revents & POLLIN)
+			return 0;
+
+		if (fd.revents & (POLLHUP | POLLERR))
+			ret =3D -ECONNRESET;
+	}
+
+	return ret;
+}
+
+/* Ensure that kdbus activator logic is safe */
+static int kdbus_priv_activator(struct kdbus_test_env *env)
+{
+	int ret;
+	struct kdbus_msg *msg =3D NULL;
+	uint64_t cookie =3D 0xdeadbeef;
+	uint64_t flags =3D KDBUS_NAME_REPLACE_EXISTING;
+	struct kdbus_conn *activator;
+	struct kdbus_conn *service;
+	struct kdbus_conn *client;
+	struct kdbus_conn *holder;
+	struct kdbus_policy_access *access;
+
+	access =3D (struct kdbus_policy_access[]){
+		{
+			.type =3D KDBUS_POLICY_ACCESS_USER,
+			.id =3D getuid(),
+			.access =3D KDBUS_POLICY_OWN,
+		},
+		{
+			.type =3D KDBUS_POLICY_ACCESS_USER,
+			.id =3D getuid(),
+			.access =3D KDBUS_POLICY_TALK,
+		},
+	};
+
+	activator =3D kdbus_hello_activator(env->buspath, "foo.priv.activator=
",
+					  access, 2);
+	ASSERT_RETURN(activator);
+
+	service =3D kdbus_hello(env->buspath, 0, NULL, 0);
+	ASSERT_RETURN(service);
+
+	client =3D kdbus_hello(env->buspath, 0, NULL, 0);
+	ASSERT_RETURN(client);
+
+	/*
+	 * Make sure that other users can't TALK to the activator
+	 */
+
+	ret =3D RUN_UNPRIVILEGED_CONN(unpriv, env->buspath, ({
+		/* Try to talk using the ID */
+		ret =3D kdbus_msg_send(unpriv, NULL, 0xdeadbeef, 0, 0,
+				     0, activator->id);
+		ASSERT_EXIT(ret =3D=3D -ENXIO);
+
+		/* Try to talk to the name */
+		ret =3D kdbus_msg_send(unpriv, "foo.priv.activator",
+				     0xdeadbeef, 0, 0, 0,
+				     KDBUS_DST_ID_NAME);
+		ASSERT_EXIT(ret =3D=3D -EPERM);
+	}));
+	ASSERT_RETURN(ret >=3D 0);
+
+	/*
+	 * Make sure that we did not receive anything, so the
+	 * service will not be started automatically
+	 */
+
+	ret =3D kdbus_starter_poll(activator);
+	ASSERT_RETURN(ret =3D=3D -ETIMEDOUT);
+
+	/*
+	 * Now try to emulate the starter/service logic and
+	 * acquire the name.
+	 */
+
+	cookie++;
+	ret =3D kdbus_msg_send(service, "foo.priv.activator", cookie,
+			     0, 0, 0, KDBUS_DST_ID_NAME);
+	ASSERT_RETURN(ret =3D=3D 0);
+
+	ret =3D kdbus_starter_poll(activator);
+	ASSERT_RETURN(ret =3D=3D 0);
+
+	/* Policies are still checked, access denied */
+
+	ret =3D RUN_UNPRIVILEGED_CONN(unpriv, env->buspath, ({
+		ret =3D kdbus_name_acquire(unpriv, "foo.priv.activator",
+					 &flags);
+		ASSERT_RETURN(ret =3D=3D -EPERM);
+	}));
+	ASSERT_RETURN(ret >=3D 0);
+
+	ret =3D kdbus_name_acquire(service, "foo.priv.activator",
+				 &flags);
+	ASSERT_RETURN(ret =3D=3D 0);
+
+	/* We read our previous starter message */
+
+	ret =3D kdbus_msg_recv_poll(service, 100, NULL, NULL);
+	ASSERT_RETURN(ret =3D=3D 0);
+
+	/* Try to talk, we still fail */
+
+	cookie++;
+	ret =3D RUN_UNPRIVILEGED_CONN(unpriv, env->buspath, ({
+		/* Try to talk to the name */
+		ret =3D kdbus_msg_send(unpriv, "foo.priv.activator",
+				     cookie, 0, 0, 0,
+				     KDBUS_DST_ID_NAME);
+		ASSERT_EXIT(ret =3D=3D -EPERM);
+	}));
+	ASSERT_RETURN(ret >=3D 0);
+
+	/* Still nothing to read */
+
+	ret =3D kdbus_msg_recv_poll(service, 100, NULL, NULL);
+	ASSERT_RETURN(ret =3D=3D -ETIMEDOUT);
+
+	/* We receive every thing now */
+
+	cookie++;
+	ret =3D kdbus_msg_send(client, "foo.priv.activator", cookie,
+			     0, 0, 0, KDBUS_DST_ID_NAME);
+	ASSERT_RETURN(ret =3D=3D 0);
+	ret =3D kdbus_msg_recv_poll(service, 100, &msg, NULL);
+	ASSERT_RETURN(ret =3D=3D 0 && msg->cookie =3D=3D cookie);
+
+	kdbus_msg_free(msg);
+
+	/* Policies default to deny TALK now */
+	kdbus_conn_free(activator);
+
+	cookie++;
+	ret =3D RUN_UNPRIVILEGED_CONN(unpriv, env->buspath, ({
+		/* Try to talk to the name */
+		ret =3D kdbus_msg_send(unpriv, "foo.priv.activator",
+				     cookie, 0, 0, 0,
+				     KDBUS_DST_ID_NAME);
+		ASSERT_EXIT(ret =3D=3D -EPERM);
+	}));
+	ASSERT_RETURN(ret >=3D 0);
+
+	ret =3D kdbus_msg_recv_poll(service, 100, NULL, NULL);
+	ASSERT_RETURN(ret =3D=3D -ETIMEDOUT);
+
+	/* Same user is able to TALK */
+	cookie++;
+	ret =3D kdbus_msg_send(client, "foo.priv.activator", cookie,
+			     0, 0, 0, KDBUS_DST_ID_NAME);
+	ASSERT_RETURN(ret =3D=3D 0);
+	ret =3D kdbus_msg_recv_poll(service, 100, &msg, NULL);
+	ASSERT_RETURN(ret =3D=3D 0 && msg->cookie =3D=3D cookie);
+
+	kdbus_msg_free(msg);
+
+	access =3D (struct kdbus_policy_access []){
+		{
+			.type =3D KDBUS_POLICY_ACCESS_WORLD,
+			.id =3D getuid(),
+			.access =3D KDBUS_POLICY_TALK,
+		},
+	};
+
+	holder =3D kdbus_hello_registrar(env->buspath, "foo.priv.activator",
+				       access, 1, KDBUS_HELLO_POLICY_HOLDER);
+	ASSERT_RETURN(holder);
+
+	/* Now we are able to TALK to the name */
+
+	cookie++;
+	ret =3D RUN_UNPRIVILEGED_CONN(unpriv, env->buspath, ({
+		/* Try to talk to the name */
+		ret =3D kdbus_msg_send(unpriv, "foo.priv.activator",
+				     cookie, 0, 0, 0,
+				     KDBUS_DST_ID_NAME);
+		ASSERT_EXIT(ret =3D=3D 0);
+	}));
+	ASSERT_RETURN(ret >=3D 0);
+
+	ret =3D kdbus_msg_recv_poll(service, 100, NULL, NULL);
+	ASSERT_RETURN(ret =3D=3D 0);
+
+	ret =3D RUN_UNPRIVILEGED_CONN(unpriv, env->buspath, ({
+		ret =3D kdbus_name_acquire(unpriv, "foo.priv.activator",
+					 &flags);
+		ASSERT_RETURN(ret =3D=3D -EPERM);
+	}));
+	ASSERT_RETURN(ret >=3D 0);
+
+	kdbus_conn_free(service);
+	kdbus_conn_free(client);
+	kdbus_conn_free(holder);
+
+	return 0;
+}
+
+int kdbus_test_activator(struct kdbus_test_env *env)
+{
+	int ret;
+	struct kdbus_conn *activator;
+	struct pollfd fds[2];
+	bool activator_done =3D false;
+	struct kdbus_policy_access access[2];
+
+	access[0].type =3D KDBUS_POLICY_ACCESS_USER;
+	access[0].id =3D getuid();
+	access[0].access =3D KDBUS_POLICY_OWN;
+
+	access[1].type =3D KDBUS_POLICY_ACCESS_WORLD;
+	access[1].access =3D KDBUS_POLICY_TALK;
+
+	activator =3D kdbus_hello_activator(env->buspath, "foo.test.activator=
",
+					  access, 2);
+	ASSERT_RETURN(activator);
+
+	ret =3D kdbus_add_match_empty(env->conn);
+	ASSERT_RETURN(ret =3D=3D 0);
+
+	ret =3D kdbus_list(env->conn, KDBUS_LIST_NAMES |
+				    KDBUS_LIST_UNIQUE |
+				    KDBUS_LIST_ACTIVATORS |
+				    KDBUS_LIST_QUEUED);
+	ASSERT_RETURN(ret =3D=3D 0);
+
+	ret =3D kdbus_msg_send(env->conn, "foo.test.activator", 0xdeafbeef,
+			     0, 0, 0, KDBUS_DST_ID_NAME);
+	ASSERT_RETURN(ret =3D=3D 0);
+
+	fds[0].fd =3D activator->fd;
+	fds[1].fd =3D env->conn->fd;
+
+	kdbus_printf("-- entering poll loop ...\n");
+
+	for (;;) {
+		int i, nfds =3D sizeof(fds) / sizeof(fds[0]);
+
+		for (i =3D 0; i < nfds; i++) {
+			fds[i].events =3D POLLIN | POLLPRI;
+			fds[i].revents =3D 0;
+		}
+
+		ret =3D poll(fds, nfds, 3000);
+		ASSERT_RETURN(ret >=3D 0);
+
+		ret =3D kdbus_list(env->conn, KDBUS_LIST_NAMES);
+		ASSERT_RETURN(ret =3D=3D 0);
+
+		if ((fds[0].revents & POLLIN) && !activator_done) {
+			uint64_t flags =3D KDBUS_NAME_REPLACE_EXISTING;
+
+			kdbus_printf("Starter was called back!\n");
+
+			ret =3D kdbus_name_acquire(env->conn,
+						 "foo.test.activator", &flags);
+			ASSERT_RETURN(ret =3D=3D 0);
+
+			activator_done =3D true;
+		}
+
+		if (fds[1].revents & POLLIN) {
+			kdbus_msg_recv(env->conn, NULL, NULL);
+			break;
+		}
+	}
+
+	/* Check if all uids/gids are mapped */
+	if (!all_uids_gids_are_mapped())
+		return TEST_SKIP;
+
+	/* Check now capabilities, so we run the previous tests */
+	ret =3D test_is_capable(CAP_SETUID, CAP_SETGID, -1);
+	ASSERT_RETURN(ret >=3D 0);
+
+	if (!ret)
+		return TEST_SKIP;
+
+	ret =3D kdbus_priv_activator(env);
+	ASSERT_RETURN(ret =3D=3D 0);
+
+	kdbus_conn_free(activator);
+
+	return TEST_OK;
+}
diff --git a/tools/testing/selftests/kdbus/test-attach-flags.c b/tools/=
testing/selftests/kdbus/test-attach-flags.c
new file mode 100644
index 000000000000..deee7c332f25
--- /dev/null
+++ b/tools/testing/selftests/kdbus/test-attach-flags.c
@@ -0,0 +1,750 @@
+#include <stdio.h>
+#include <string.h>
+#include <stdlib.h>
+#include <stdbool.h>
+#include <stddef.h>
+#include <fcntl.h>
+#include <unistd.h>
+#include <stdint.h>
+#include <errno.h>
+#include <assert.h>
+#include <sys/capability.h>
+#include <sys/mman.h>
+#include <sys/stat.h>
+#include <sys/types.h>
+#include <linux/unistd.h>
+
+#include "kdbus-api.h"
+#include "kdbus-test.h"
+#include "kdbus-util.h"
+#include "kdbus-enum.h"
+
+/*
+ * Should be the sum of the currently supported and compiled-in
+ * KDBUS_ITEMS_* that reflect KDBUS_ATTACH_* flags.
+ */
+static unsigned int KDBUS_TEST_ITEMS_SUM =3D KDBUS_ATTACH_ITEMS_TYPE_S=
UM;
+
+static struct kdbus_conn *__kdbus_hello(const char *path, uint64_t fla=
gs,
+					uint64_t attach_flags_send,
+					uint64_t attach_flags_recv)
+{
+	struct kdbus_cmd_free cmd_free =3D {};
+	int ret, fd;
+	struct kdbus_conn *conn;
+	struct {
+		struct kdbus_cmd_hello hello;
+
+		struct {
+			uint64_t size;
+			uint64_t type;
+			char str[16];
+		} conn_name;
+
+		uint8_t extra_items[0];
+	} h;
+
+	memset(&h, 0, sizeof(h));
+
+	kdbus_printf("-- opening bus connection %s\n", path);
+	fd =3D open(path, O_RDWR|O_CLOEXEC);
+	if (fd < 0) {
+		kdbus_printf("--- error %d (%m)\n", fd);
+		return NULL;
+	}
+
+	h.hello.flags =3D flags | KDBUS_HELLO_ACCEPT_FD;
+	h.hello.attach_flags_send =3D attach_flags_send;
+	h.hello.attach_flags_recv =3D attach_flags_recv;
+	h.conn_name.type =3D KDBUS_ITEM_CONN_DESCRIPTION;
+	strcpy(h.conn_name.str, "this-is-my-name");
+	h.conn_name.size =3D KDBUS_ITEM_HEADER_SIZE + strlen(h.conn_name.str)=
 + 1;
+
+	h.hello.size =3D sizeof(h);
+	h.hello.pool_size =3D POOL_SIZE;
+
+	ret =3D kdbus_cmd_hello(fd, (struct kdbus_cmd_hello *) &h.hello);
+	if (ret < 0) {
+		kdbus_printf("--- error when saying hello: %d (%m)\n", ret);
+		return NULL;
+	}
+
+	kdbus_printf("-- New connection ID : %llu\n",
+		     (unsigned long long)h.hello.id);
+
+	cmd_free.size =3D sizeof(cmd_free);
+	cmd_free.offset =3D h.hello.offset;
+	ret =3D kdbus_cmd_free(fd, &cmd_free);
+	if (ret < 0)
+		return NULL;
+
+	conn =3D malloc(sizeof(*conn));
+	if (!conn) {
+		kdbus_printf("unable to malloc()!?\n");
+		return NULL;
+	}
+
+	conn->buf =3D mmap(NULL, POOL_SIZE, PROT_READ, MAP_SHARED, fd, 0);
+	if (conn->buf =3D=3D MAP_FAILED) {
+		ret =3D -errno;
+		free(conn);
+		close(fd);
+		kdbus_printf("--- error mmap: %d (%m)\n", ret);
+		return NULL;
+	}
+
+	conn->fd =3D fd;
+	conn->id =3D h.hello.id;
+	return conn;
+}
+
+static int kdbus_test_peers_creation(struct kdbus_test_env *env)
+{
+	int ret;
+	int control_fd;
+	char *path;
+	char *busname;
+	char buspath[2048];
+	char control_path[2048];
+	uint64_t attach_flags_mask;
+	struct kdbus_conn *conn;
+
+	snprintf(control_path, sizeof(control_path),
+		 "%s/control", env->root);
+
+	/*
+	 * Set kdbus system-wide mask to 0, this has nothing
+	 * to do with the following tests, bus and connection
+	 * creation nor connection update, but we do it so we are
+	 * sure that everything work as expected
+	 */
+
+	attach_flags_mask =3D 0;
+	ret =3D kdbus_sysfs_set_parameter_mask(env->mask_param_path,
+					     attach_flags_mask);
+	ASSERT_RETURN(ret =3D=3D 0);
+
+
+	/*
+	 * Create bus with a full set of ATTACH flags
+	 */
+
+	control_fd =3D open(control_path, O_RDWR);
+	ASSERT_RETURN(control_fd >=3D 0);
+
+	busname =3D unique_name("test-peers-creation-bus");
+	ASSERT_RETURN(busname);
+
+	ret =3D kdbus_create_bus(control_fd, busname, _KDBUS_ATTACH_ALL,
+			       0, &path);
+	ASSERT_RETURN(ret =3D=3D 0);
+
+	snprintf(buspath, sizeof(buspath), "%s/%s/bus", env->root, path);
+
+	/*
+	 * Create a connection with an empty send attach flags, or
+	 * with just KDBUS_ATTACH_CREDS, this should fail
+	 */
+	conn =3D __kdbus_hello(buspath, 0, 0, 0);
+	ASSERT_RETURN(conn =3D=3D NULL);
+	ASSERT_RETURN(errno =3D=3D ECONNREFUSED);
+
+	conn =3D __kdbus_hello(buspath, 0, KDBUS_ATTACH_CREDS,
+			     _KDBUS_ATTACH_ALL);
+	ASSERT_RETURN(conn =3D=3D NULL);
+	ASSERT_RETURN(errno =3D=3D ECONNREFUSED);
+
+	conn =3D __kdbus_hello(buspath, 0, _KDBUS_ATTACH_ALL, 0);
+	ASSERT_RETURN(conn);
+
+	/* Try to cut back some send attach flags */
+	ret =3D kdbus_conn_update_attach_flags(conn,
+					     KDBUS_ATTACH_CREDS|
+					     KDBUS_ATTACH_PIDS,
+					     _KDBUS_ATTACH_ALL);
+	ASSERT_RETURN(ret =3D=3D -EINVAL);
+
+	ret =3D kdbus_conn_update_attach_flags(conn,
+					     _KDBUS_ATTACH_ALL, 0);
+	ASSERT_RETURN(ret =3D=3D 0);
+
+	kdbus_conn_free(conn);
+	free(path);
+	free(busname);
+	close(control_fd);
+
+
+	/* Test a new bus with KDBUS_ATTACH_PIDS */
+
+	control_fd =3D open(control_path, O_RDWR);
+	ASSERT_RETURN(control_fd >=3D 0);
+
+	busname =3D unique_name("test-peer-flags-bus");
+	ASSERT_RETURN(busname);
+
+	ret =3D kdbus_create_bus(control_fd, busname, KDBUS_ATTACH_PIDS,
+			       0, &path);
+	ASSERT_RETURN(ret =3D=3D 0);
+
+	snprintf(buspath, sizeof(buspath), "%s/%s/bus", env->root, path);
+
+	/*
+	 * Create a connection with an empty send attach flags, or
+	 * all flags except KDBUS_ATTACH_PIDS
+	 */
+	conn =3D __kdbus_hello(buspath, 0, 0, 0);
+	ASSERT_RETURN(conn =3D=3D NULL);
+	ASSERT_RETURN(errno =3D=3D ECONNREFUSED);
+
+	conn =3D __kdbus_hello(buspath, 0,
+			     _KDBUS_ATTACH_ALL & ~KDBUS_ATTACH_PIDS,
+			     _KDBUS_ATTACH_ALL);
+	ASSERT_RETURN(conn =3D=3D NULL);
+	ASSERT_RETURN(errno =3D=3D ECONNREFUSED);
+
+	/* The following should succeed */
+	conn =3D __kdbus_hello(buspath, 0, KDBUS_ATTACH_PIDS, 0);
+	ASSERT_RETURN(conn);
+	kdbus_conn_free(conn);
+
+	conn =3D __kdbus_hello(buspath, 0, _KDBUS_ATTACH_ALL, 0);
+	ASSERT_RETURN(conn);
+
+	ret =3D kdbus_conn_update_attach_flags(conn,
+					     _KDBUS_ATTACH_ALL &
+					     ~KDBUS_ATTACH_PIDS,
+					     _KDBUS_ATTACH_ALL);
+	ASSERT_RETURN(ret =3D=3D -EINVAL);
+
+	ret =3D kdbus_conn_update_attach_flags(conn, 0,
+					     _KDBUS_ATTACH_ALL);
+	ASSERT_RETURN(ret =3D=3D -EINVAL);
+
+	/* Now we want only KDBUS_ATTACH_PIDS */
+	ret =3D kdbus_conn_update_attach_flags(conn,
+					     KDBUS_ATTACH_PIDS, 0);
+	ASSERT_RETURN(ret =3D=3D 0);
+
+	kdbus_conn_free(conn);
+	free(path);
+	free(busname);
+	close(control_fd);
+
+
+	/*
+	 * Create bus with 0 as ATTACH flags, the bus does not
+	 * require any attach flags
+	 */
+
+	control_fd =3D open(control_path, O_RDWR);
+	ASSERT_RETURN(control_fd >=3D 0);
+
+	busname =3D unique_name("test-peer-flags-bus");
+	ASSERT_RETURN(busname);
+
+	ret =3D kdbus_create_bus(control_fd, busname, 0, 0, &path);
+	ASSERT_RETURN(ret =3D=3D 0);
+
+	snprintf(buspath, sizeof(buspath), "%s/%s/bus", env->root, path);
+
+	/* Bus is open it does not require any send attach flags */
+	conn =3D __kdbus_hello(buspath, 0, 0, 0);
+	ASSERT_RETURN(conn);
+	kdbus_conn_free(conn);
+
+	conn =3D __kdbus_hello(buspath, 0, _KDBUS_ATTACH_ALL, 0);
+	ASSERT_RETURN(conn);
+
+	ret =3D kdbus_conn_update_attach_flags(conn, 0, 0);
+	ASSERT_RETURN(ret =3D=3D 0);
+
+	ret =3D kdbus_conn_update_attach_flags(conn, KDBUS_ATTACH_CREDS, 0);
+	ASSERT_RETURN(ret =3D=3D 0);
+
+	kdbus_conn_free(conn);
+	free(path);
+	free(busname);
+	close(control_fd);
+
+	return 0;
+}
+
+static int kdbus_test_peers_info(struct kdbus_test_env *env)
+{
+	int ret;
+	int control_fd;
+	char *path;
+	char *busname;
+	unsigned int i =3D 0;
+	uint64_t offset =3D 0;
+	char buspath[2048];
+	char control_path[2048];
+	uint64_t attach_flags_mask;
+	struct kdbus_item *item;
+	struct kdbus_info *info;
+	struct kdbus_conn *conn;
+	struct kdbus_conn *reader;
+	unsigned long long attach_count =3D 0;
+
+	snprintf(control_path, sizeof(control_path),
+		 "%s/control", env->root);
+
+	attach_flags_mask =3D 0;
+	ret =3D kdbus_sysfs_set_parameter_mask(env->mask_param_path,
+					     attach_flags_mask);
+	ASSERT_RETURN(ret =3D=3D 0);
+
+	control_fd =3D open(control_path, O_RDWR);
+	ASSERT_RETURN(control_fd >=3D 0);
+
+	busname =3D unique_name("test-peers-info-bus");
+	ASSERT_RETURN(busname);
+
+	ret =3D kdbus_create_bus(control_fd, busname, _KDBUS_ATTACH_ALL,
+			       0, &path);
+	ASSERT_RETURN(ret =3D=3D 0);
+
+	snprintf(buspath, sizeof(buspath), "%s/%s/bus", env->root, path);
+
+	/* Create connections with the appropriate flags */
+	conn =3D __kdbus_hello(buspath, 0, _KDBUS_ATTACH_ALL, 0);
+	ASSERT_RETURN(conn);
+
+	reader =3D __kdbus_hello(buspath, 0, _KDBUS_ATTACH_ALL, 0);
+	ASSERT_RETURN(reader);
+
+	ret =3D kdbus_conn_info(reader, conn->id, NULL,
+			      _KDBUS_ATTACH_ALL, &offset);
+	ASSERT_RETURN(ret =3D=3D 0);
+
+	info =3D (struct kdbus_info *)(reader->buf + offset);
+	ASSERT_RETURN(info->id =3D=3D conn->id);
+
+	/* all attach flags are masked, no metadata */
+	KDBUS_ITEM_FOREACH(item, info, items)
+		i++;
+
+	ASSERT_RETURN(i =3D=3D 0);
+
+	kdbus_free(reader, offset);
+
+	/* Set the mask to _KDBUS_ATTACH_ANY */
+	attach_flags_mask =3D _KDBUS_ATTACH_ANY;
+	ret =3D kdbus_sysfs_set_parameter_mask(env->mask_param_path,
+					     attach_flags_mask);
+	ASSERT_RETURN(ret =3D=3D 0);
+
+	ret =3D kdbus_conn_info(reader, conn->id, NULL,
+			      _KDBUS_ATTACH_ALL, &offset);
+	ASSERT_RETURN(ret =3D=3D 0);
+
+	info =3D (struct kdbus_info *)(reader->buf + offset);
+	ASSERT_RETURN(info->id =3D=3D conn->id);
+
+	attach_count =3D 0;
+	KDBUS_ITEM_FOREACH(item, info, items)
+		    attach_count +=3D item->type;
+
+	/*
+	 * All flags have been returned except for:
+	 * KDBUS_ITEM_TIMESTAMP and
+	 * KDBUS_ITEM_OWNED_NAME we do not own any name.
+	 */
+	ASSERT_RETURN(attach_count =3D=3D (KDBUS_TEST_ITEMS_SUM -
+				       KDBUS_ITEM_OWNED_NAME -
+				       KDBUS_ITEM_TIMESTAMP));
+
+	kdbus_free(reader, offset);
+
+	/* Request only OWNED names */
+	ret =3D kdbus_conn_info(reader, conn->id, NULL,
+			      KDBUS_ATTACH_NAMES, &offset);
+	ASSERT_RETURN(ret =3D=3D 0);
+
+	info =3D (struct kdbus_info *)(reader->buf + offset);
+	ASSERT_RETURN(info->id =3D=3D conn->id);
+
+	attach_count =3D 0;
+	KDBUS_ITEM_FOREACH(item, info, items)
+		attach_count +=3D item->type;
+
+	/* we should not get any metadata since we do not own names */
+	ASSERT_RETURN(attach_count =3D=3D 0);
+
+	kdbus_free(reader, offset);
+
+	kdbus_conn_free(conn);
+	kdbus_conn_free(reader);
+
+	return 0;
+}
+
+/**
+ * @kdbus_mask_param:	kdbus module mask parameter (system-wide)
+ * @requested_meta:	The bus owner metadata that we want
+ * @expected_items:	The returned KDBUS_ITEMS_* sum. Used to
+ *			validate the returned metadata items
+ */
+static int kdbus_cmp_bus_creator_metadata(struct kdbus_test_env *env,
+					  struct kdbus_conn *conn,
+					  uint64_t kdbus_mask_param,
+					  uint64_t requested_meta,
+					  unsigned long expected_items)
+{
+	int ret;
+	uint64_t offset =3D 0;
+	struct kdbus_info *info;
+	struct kdbus_item *item;
+	unsigned long attach_count =3D 0;
+
+	ret =3D kdbus_sysfs_set_parameter_mask(env->mask_param_path,
+					     kdbus_mask_param);
+	ASSERT_RETURN(ret =3D=3D 0);
+
+	ret =3D kdbus_bus_creator_info(conn, requested_meta, &offset);
+	ASSERT_RETURN(ret =3D=3D 0);
+
+	info =3D (struct kdbus_info *)(conn->buf + offset);
+
+	KDBUS_ITEM_FOREACH(item, info, items)
+		attach_count +=3D item->type;
+
+	ASSERT_RETURN(attach_count =3D=3D expected_items);
+
+	ret =3D kdbus_free(conn, offset);
+	ASSERT_RETURN(ret =3D=3D 0);
+
+	return 0;
+}
+
+static int kdbus_test_bus_creator_info(struct kdbus_test_env *env)
+{
+	int ret;
+	int control_fd;
+	char *path;
+	char *busname;
+	char buspath[2048];
+	char control_path[2048];
+	uint64_t attach_flags_mask;
+	struct kdbus_conn *conn;
+	unsigned long expected_items =3D 0;
+
+	snprintf(control_path, sizeof(control_path),
+		 "%s/control", env->root);
+
+	control_fd =3D open(control_path, O_RDWR);
+	ASSERT_RETURN(control_fd >=3D 0);
+
+	busname =3D unique_name("test-peers-info-bus");
+	ASSERT_RETURN(busname);
+
+	/*
+	 * Now the bus allows us to see all its KDBUS_ATTACH_*
+	 * items
+	 */
+	ret =3D kdbus_create_bus(control_fd, busname, 0,
+			       _KDBUS_ATTACH_ALL, &path);
+	ASSERT_RETURN(ret =3D=3D 0);
+
+	snprintf(buspath, sizeof(buspath), "%s/%s/bus", env->root, path);
+
+	conn =3D __kdbus_hello(buspath, 0, 0, 0);
+	ASSERT_RETURN(conn);
+
+	/*
+	 * Start with a kdbus module mask set to _KDBUS_ATTACH_ANY
+	 */
+	attach_flags_mask =3D _KDBUS_ATTACH_ANY;
+
+	/*
+	 * All flags will be returned except for:
+	 * KDBUS_ITEM_TIMESTAMP
+	 * KDBUS_ITEM_OWNED_NAME
+	 * KDBUS_ITEM_CONN_DESCRIPTION
+	 *
+	 * An extra flags is always returned KDBUS_ITEM_MAKE_NAME
+	 * which contains the bus name
+	 */
+	expected_items =3D KDBUS_TEST_ITEMS_SUM + KDBUS_ITEM_MAKE_NAME;
+	expected_items -=3D KDBUS_ITEM_TIMESTAMP +
+			  KDBUS_ITEM_OWNED_NAME +
+			  KDBUS_ITEM_CONN_DESCRIPTION;
+	ret =3D kdbus_cmp_bus_creator_metadata(env, conn,
+					     attach_flags_mask,
+					     _KDBUS_ATTACH_ALL,
+					     expected_items);
+	ASSERT_RETURN(ret =3D=3D 0);
+
+	/*
+	 * We should have:
+	 * KDBUS_ITEM_PIDS + KDBUS_ITEM_CREDS + KDBUS_ITEM_MAKE_NAME
+	 */
+	expected_items =3D KDBUS_ITEM_PIDS + KDBUS_ITEM_CREDS +
+			 KDBUS_ITEM_MAKE_NAME;
+	ret =3D kdbus_cmp_bus_creator_metadata(env, conn,
+					     attach_flags_mask,
+					     KDBUS_ATTACH_PIDS |
+					     KDBUS_ATTACH_CREDS,
+					     expected_items);
+	ASSERT_RETURN(ret =3D=3D 0);
+
+	/* KDBUS_ITEM_MAKE_NAME is always returned */
+	expected_items =3D KDBUS_ITEM_MAKE_NAME;
+	ret =3D kdbus_cmp_bus_creator_metadata(env, conn,
+					     attach_flags_mask,
+					     0, expected_items);
+	ASSERT_RETURN(ret =3D=3D 0);
+
+	/*
+	 * Restrict kdbus system-wide mask to KDBUS_ATTACH_PIDS
+	 */
+
+	attach_flags_mask =3D KDBUS_ATTACH_PIDS;
+
+	/*
+	 * We should have:
+	 * KDBUS_ITEM_PIDS + KDBUS_ITEM_MAKE_NAME
+	 */
+	expected_items =3D KDBUS_ITEM_PIDS + KDBUS_ITEM_MAKE_NAME;
+	ret =3D kdbus_cmp_bus_creator_metadata(env, conn,
+					     attach_flags_mask,
+					     _KDBUS_ATTACH_ALL,
+					     expected_items);
+	ASSERT_RETURN(ret =3D=3D 0);
+
+
+	/* system-wide mask to 0 */
+	attach_flags_mask =3D 0;
+
+	/* we should only see: KDBUS_ITEM_MAKE_NAME */
+	expected_items =3D KDBUS_ITEM_MAKE_NAME;
+	ret =3D kdbus_cmp_bus_creator_metadata(env, conn,
+					     attach_flags_mask,
+					     _KDBUS_ATTACH_ALL,
+					     expected_items);
+	ASSERT_RETURN(ret =3D=3D 0);
+
+	kdbus_conn_free(conn);
+	free(path);
+	free(busname);
+	close(control_fd);
+
+
+	/*
+	 * A new bus that hides all its owner metadata
+	 */
+
+	control_fd =3D open(control_path, O_RDWR);
+	ASSERT_RETURN(control_fd >=3D 0);
+
+	busname =3D unique_name("test-peers-info-bus");
+	ASSERT_RETURN(busname);
+
+	ret =3D kdbus_create_bus(control_fd, busname, 0, 0, &path);
+	ASSERT_RETURN(ret =3D=3D 0);
+
+	snprintf(buspath, sizeof(buspath), "%s/%s/bus", env->root, path);
+
+	conn =3D __kdbus_hello(buspath, 0, 0, 0);
+	ASSERT_RETURN(conn);
+
+	/*
+	 * Start with a kdbus module mask set to _KDBUS_ATTACH_ANY
+	 */
+	attach_flags_mask =3D _KDBUS_ATTACH_ANY;
+
+	/*
+	 * We only get the KDBUS_ITEM_MAKE_NAME
+	 */
+	expected_items =3D KDBUS_ITEM_MAKE_NAME;
+	ret =3D kdbus_cmp_bus_creator_metadata(env, conn,
+					     attach_flags_mask,
+					     _KDBUS_ATTACH_ALL,
+					     expected_items);
+	ASSERT_RETURN(ret =3D=3D 0);
+
+	/*
+	 * We still get only kdbus_ITEM_MAKE_NAME
+	 */
+	attach_flags_mask =3D 0;
+	expected_items =3D KDBUS_ITEM_MAKE_NAME;
+	ret =3D kdbus_cmp_bus_creator_metadata(env, conn,
+					     attach_flags_mask,
+					     _KDBUS_ATTACH_ALL,
+					     expected_items);
+	ASSERT_RETURN(ret =3D=3D 0);
+
+	kdbus_conn_free(conn);
+	free(path);
+	free(busname);
+	close(control_fd);
+
+
+	/*
+	 * A new bus that shows only the PID and CREDS metadata
+	 * of the bus owner.
+	 */
+	control_fd =3D open(control_path, O_RDWR);
+	ASSERT_RETURN(control_fd >=3D 0);
+
+	busname =3D unique_name("test-peers-info-bus");
+	ASSERT_RETURN(busname);
+
+	ret =3D kdbus_create_bus(control_fd, busname, 0,
+			       KDBUS_ATTACH_PIDS|
+			       KDBUS_ATTACH_CREDS, &path);
+	ASSERT_RETURN(ret =3D=3D 0);
+
+	snprintf(buspath, sizeof(buspath), "%s/%s/bus", env->root, path);
+
+	conn =3D __kdbus_hello(buspath, 0, 0, 0);
+	ASSERT_RETURN(conn);
+
+	/*
+	 * Start with a kdbus module mask set to _KDBUS_ATTACH_ANY
+	 */
+	attach_flags_mask =3D _KDBUS_ATTACH_ANY;
+
+	/*
+	 * We should have:
+	 * KDBUS_ITEM_PIDS + KDBUS_ITEM_CREDS + KDBUS_ITEM_MAKE_NAME
+	 */
+	expected_items =3D KDBUS_ITEM_PIDS + KDBUS_ITEM_CREDS +
+			 KDBUS_ITEM_MAKE_NAME;
+	ret =3D kdbus_cmp_bus_creator_metadata(env, conn,
+					     attach_flags_mask,
+					     _KDBUS_ATTACH_ALL,
+					     expected_items);
+	ASSERT_RETURN(ret =3D=3D 0);
+
+	expected_items =3D KDBUS_ITEM_CREDS + KDBUS_ITEM_MAKE_NAME;
+	ret =3D kdbus_cmp_bus_creator_metadata(env, conn,
+					     attach_flags_mask,
+					     KDBUS_ATTACH_CREDS,
+					     expected_items);
+	ASSERT_RETURN(ret =3D=3D 0);
+
+	/* KDBUS_ITEM_MAKE_NAME is always returned */
+	expected_items =3D KDBUS_ITEM_MAKE_NAME;
+	ret =3D kdbus_cmp_bus_creator_metadata(env, conn,
+					     attach_flags_mask,
+					     0, expected_items);
+	ASSERT_RETURN(ret =3D=3D 0);
+
+	/*
+	 * Restrict kdbus system-wide mask to KDBUS_ATTACH_PIDS
+	 */
+
+	attach_flags_mask =3D KDBUS_ATTACH_PIDS;
+	/*
+	 * We should have:
+	 * KDBUS_ITEM_PIDS + KDBUS_ITEM_MAKE_NAME
+	 */
+	expected_items =3D KDBUS_ITEM_PIDS + KDBUS_ITEM_MAKE_NAME;
+	ret =3D kdbus_cmp_bus_creator_metadata(env, conn,
+					     attach_flags_mask,
+					     _KDBUS_ATTACH_ALL,
+					     expected_items);
+	ASSERT_RETURN(ret =3D=3D 0);
+
+	/* No KDBUS_ATTACH_CREDS */
+	expected_items =3D KDBUS_ITEM_MAKE_NAME;
+	ret =3D kdbus_cmp_bus_creator_metadata(env, conn,
+					     attach_flags_mask,
+					     KDBUS_ATTACH_CREDS,
+					     expected_items);
+	ASSERT_RETURN(ret =3D=3D 0);
+
+	/* system-wide mask to 0 */
+	attach_flags_mask =3D 0;
+
+	/* we should only see: KDBUS_ITEM_MAKE_NAME */
+	expected_items =3D KDBUS_ITEM_MAKE_NAME;
+	ret =3D kdbus_cmp_bus_creator_metadata(env, conn,
+					     attach_flags_mask,
+					     _KDBUS_ATTACH_ALL,
+					     expected_items);
+	ASSERT_RETURN(ret =3D=3D 0);
+
+
+	kdbus_conn_free(conn);
+	free(path);
+	free(busname);
+	close(control_fd);
+
+	return 0;
+}
+
+int kdbus_test_attach_flags(struct kdbus_test_env *env)
+{
+	int ret;
+	uint64_t flags_mask;
+	uint64_t old_kdbus_flags_mask;
+
+	/* We need CAP_DAC_OVERRIDE to overwrite the kdbus mask */
+	ret =3D test_is_capable(CAP_DAC_OVERRIDE, -1);
+	ASSERT_RETURN(ret >=3D 0);
+
+	/* no enough privileges, SKIP test */
+	if (!ret)
+		return TEST_SKIP;
+
+	/*
+	 * We need to be able to write to
+	 * "/sys/module/kdbus/parameters/attach_flags_mask"
+	 * perhaps we are unprvileged/privileged in its userns
+	 */
+	ret =3D access(env->mask_param_path, W_OK);
+	if (ret < 0) {
+		kdbus_printf("--- access() '%s' failed: %d (%m)\n",
+			     env->mask_param_path, -errno);
+		return TEST_SKIP;
+	}
+
+	ret =3D kdbus_sysfs_get_parameter_mask(env->mask_param_path,
+					     &old_kdbus_flags_mask);
+	ASSERT_RETURN(ret =3D=3D 0);
+
+	/* setup the right KDBUS_TEST_ITEMS_SUM */
+	if (!config_auditsyscall_is_enabled())
+		KDBUS_TEST_ITEMS_SUM -=3D KDBUS_ITEM_AUDIT;
+
+	if (!config_cgroups_is_enabled())
+		KDBUS_TEST_ITEMS_SUM -=3D KDBUS_ITEM_CGROUP;
+
+	if (!config_security_is_enabled())
+		KDBUS_TEST_ITEMS_SUM -=3D KDBUS_ITEM_SECLABEL;
+
+	/*
+	 * Test the connection creation attach flags
+	 */
+	ret =3D kdbus_test_peers_creation(env);
+	/* Restore previous kdbus mask */
+	kdbus_sysfs_set_parameter_mask(env->mask_param_path,
+				       old_kdbus_flags_mask);
+	ASSERT_RETURN(ret =3D=3D 0);
+
+	/*
+	 * Test the CONN_INFO attach flags
+	 */
+	ret =3D kdbus_test_peers_info(env);
+	/* Restore previous kdbus mask */
+	kdbus_sysfs_set_parameter_mask(env->mask_param_path,
+				       old_kdbus_flags_mask);
+	ASSERT_RETURN(ret =3D=3D 0);
+
+	/*
+	 * Test the Bus creator info and its attach flags
+	 */
+	ret =3D kdbus_test_bus_creator_info(env);
+	/* Restore previous kdbus mask */
+	kdbus_sysfs_set_parameter_mask(env->mask_param_path,
+				       old_kdbus_flags_mask);
+	ASSERT_RETURN(ret =3D=3D 0);
+
+	ret =3D kdbus_sysfs_get_parameter_mask(env->mask_param_path,
+					     &flags_mask);
+	ASSERT_RETURN(ret =3D=3D 0 && old_kdbus_flags_mask =3D=3D flags_mask)=
;
+
+	return TEST_OK;
+}
diff --git a/tools/testing/selftests/kdbus/test-benchmark.c b/tools/tes=
ting/selftests/kdbus/test-benchmark.c
new file mode 100644
index 000000000000..8a9744b00508
--- /dev/null
+++ b/tools/testing/selftests/kdbus/test-benchmark.c
@@ -0,0 +1,451 @@
+#include <stdio.h>
+#include <string.h>
+#include <time.h>
+#include <fcntl.h>
+#include <locale.h>
+#include <stdlib.h>
+#include <stddef.h>
+#include <unistd.h>
+#include <stdint.h>
+#include <stdbool.h>
+#include <errno.h>
+#include <assert.h>
+#include <poll.h>
+#include <sys/time.h>
+#include <sys/mman.h>
+#include <sys/socket.h>
+#include <math.h>
+
+#include "kdbus-api.h"
+#include "kdbus-test.h"
+#include "kdbus-util.h"
+#include "kdbus-enum.h"
+
+#define SERVICE_NAME "foo.bar.echo"
+
+/*
+ * To have a banchmark comparison with unix socket, set:
+ * user_memfd	=3D false;
+ * compare_uds	=3D true;
+ * attach_none	=3D true;		do not attached metadata
+ */
+
+static bool use_memfd =3D true;		/* transmit memfd? */
+static bool compare_uds =3D false;		/* unix-socket comparison? */
+static bool attach_none =3D false;		/* clear attach-flags? */
+static char stress_payload[8192];
+
+struct stats {
+	uint64_t count;
+	uint64_t latency_acc;
+	uint64_t latency_low;
+	uint64_t latency_high;
+	uint64_t latency_avg;
+	uint64_t latency_ssquares;
+};
+
+static struct stats stats;
+
+static void reset_stats(void)
+{
+	stats.count =3D 0;
+	stats.latency_acc =3D 0;
+	stats.latency_low =3D UINT64_MAX;
+	stats.latency_high =3D 0;
+	stats.latency_avg =3D 0;
+	stats.latency_ssquares =3D 0;
+}
+
+static void dump_stats(bool is_uds)
+{
+	if (stats.count > 0) {
+		kdbus_printf("stats %s: %'llu packets processed, latency (nsecs) min=
/max/avg/dev %'7llu // %'7llu // %'7llu // %'7.f\n",
+			     is_uds ? " (UNIX)" : "(KDBUS)",
+			     (unsigned long long) stats.count,
+			     (unsigned long long) stats.latency_low,
+			     (unsigned long long) stats.latency_high,
+			     (unsigned long long) stats.latency_avg,
+			     sqrt(stats.latency_ssquares / stats.count));
+	} else {
+		kdbus_printf("*** no packets received. bus stuck?\n");
+	}
+}
+
+static void add_stats(uint64_t prev)
+{
+	uint64_t diff, latency_avg_prev;
+
+	diff =3D now(CLOCK_THREAD_CPUTIME_ID) - prev;
+
+	stats.count++;
+	stats.latency_acc +=3D diff;
+
+	/* see Welford62 */
+	latency_avg_prev =3D stats.latency_avg;
+	stats.latency_avg =3D stats.latency_acc / stats.count;
+	stats.latency_ssquares +=3D (diff - latency_avg_prev) * (diff - stats=
=2Elatency_avg);
+
+	if (stats.latency_low > diff)
+		stats.latency_low =3D diff;
+
+	if (stats.latency_high < diff)
+		stats.latency_high =3D diff;
+}
+
+static int setup_simple_kdbus_msg(struct kdbus_conn *conn,
+				  uint64_t dst_id,
+				  struct kdbus_msg **msg_out)
+{
+	struct kdbus_msg *msg;
+	struct kdbus_item *item;
+	uint64_t size;
+
+	size =3D sizeof(struct kdbus_msg);
+	size +=3D KDBUS_ITEM_SIZE(sizeof(struct kdbus_vec));
+
+	msg =3D malloc(size);
+	ASSERT_RETURN_VAL(msg, -ENOMEM);
+
+	memset(msg, 0, size);
+	msg->size =3D size;
+	msg->src_id =3D conn->id;
+	msg->dst_id =3D dst_id;
+	msg->payload_type =3D KDBUS_PAYLOAD_DBUS;
+
+	item =3D msg->items;
+
+	item->type =3D KDBUS_ITEM_PAYLOAD_VEC;
+	item->size =3D KDBUS_ITEM_HEADER_SIZE + sizeof(struct kdbus_vec);
+	item->vec.address =3D (uintptr_t) stress_payload;
+	item->vec.size =3D sizeof(stress_payload);
+	item =3D KDBUS_ITEM_NEXT(item);
+
+	*msg_out =3D msg;
+
+	return 0;
+}
+
+static int setup_memfd_kdbus_msg(struct kdbus_conn *conn,
+				 uint64_t dst_id,
+				 off_t *memfd_item_offset,
+				 struct kdbus_msg **msg_out)
+{
+	struct kdbus_msg *msg;
+	struct kdbus_item *item;
+	uint64_t size;
+
+	size =3D sizeof(struct kdbus_msg);
+	size +=3D KDBUS_ITEM_SIZE(sizeof(struct kdbus_vec));
+	size +=3D KDBUS_ITEM_SIZE(sizeof(struct kdbus_memfd));
+
+	msg =3D malloc(size);
+	ASSERT_RETURN_VAL(msg, -ENOMEM);
+
+	memset(msg, 0, size);
+	msg->size =3D size;
+	msg->src_id =3D conn->id;
+	msg->dst_id =3D dst_id;
+	msg->payload_type =3D KDBUS_PAYLOAD_DBUS;
+
+	item =3D msg->items;
+
+	item->type =3D KDBUS_ITEM_PAYLOAD_VEC;
+	item->size =3D KDBUS_ITEM_HEADER_SIZE + sizeof(struct kdbus_vec);
+	item->vec.address =3D (uintptr_t) stress_payload;
+	item->vec.size =3D sizeof(stress_payload);
+	item =3D KDBUS_ITEM_NEXT(item);
+
+	item->type =3D KDBUS_ITEM_PAYLOAD_MEMFD;
+	item->size =3D KDBUS_ITEM_HEADER_SIZE + sizeof(struct kdbus_memfd);
+	item->memfd.size =3D sizeof(uint64_t);
+
+	*memfd_item_offset =3D (unsigned char *)item - (unsigned char *)msg;
+	*msg_out =3D msg;
+
+	return 0;
+}
+
+static int
+send_echo_request(struct kdbus_conn *conn, uint64_t dst_id,
+		  void *kdbus_msg, off_t memfd_item_offset)
+{
+	struct kdbus_cmd_send cmd =3D {};
+	int memfd =3D -1;
+	int ret;
+
+	if (use_memfd) {
+		uint64_t now_ns =3D now(CLOCK_THREAD_CPUTIME_ID);
+		struct kdbus_item *item =3D memfd_item_offset + kdbus_msg;
+		memfd =3D sys_memfd_create("memfd-name", 0);
+		ASSERT_RETURN_VAL(memfd >=3D 0, memfd);
+
+		ret =3D write(memfd, &now_ns, sizeof(now_ns));
+		ASSERT_RETURN_VAL(ret =3D=3D sizeof(now_ns), -EAGAIN);
+
+		ret =3D sys_memfd_seal_set(memfd);
+		ASSERT_RETURN_VAL(ret =3D=3D 0, -errno);
+
+		item->memfd.fd =3D memfd;
+	}
+
+	cmd.size =3D sizeof(cmd);
+	cmd.msg_address =3D (uintptr_t)kdbus_msg;
+
+	ret =3D kdbus_cmd_send(conn->fd, &cmd);
+	ASSERT_RETURN_VAL(ret =3D=3D 0, ret);
+
+	close(memfd);
+
+	return 0;
+}
+
+static int
+handle_echo_reply(struct kdbus_conn *conn, uint64_t send_ns)
+{
+	int ret;
+	struct kdbus_cmd_recv recv =3D { .size =3D sizeof(recv) };
+	struct kdbus_msg *msg;
+	const struct kdbus_item *item;
+	bool has_memfd =3D false;
+
+	ret =3D kdbus_cmd_recv(conn->fd, &recv);
+	if (ret =3D=3D -EAGAIN)
+		return ret;
+
+	ASSERT_RETURN_VAL(ret =3D=3D 0, ret);
+
+	if (!use_memfd)
+		goto out;
+
+	msg =3D (struct kdbus_msg *)(conn->buf + recv.msg.offset);
+
+	KDBUS_ITEM_FOREACH(item, msg, items) {
+		switch (item->type) {
+		case KDBUS_ITEM_PAYLOAD_MEMFD: {
+			char *buf;
+
+			buf =3D mmap(NULL, item->memfd.size, PROT_READ,
+				   MAP_PRIVATE, item->memfd.fd, 0);
+			ASSERT_RETURN_VAL(buf !=3D MAP_FAILED, -EINVAL);
+			ASSERT_RETURN_VAL(item->memfd.size =3D=3D sizeof(uint64_t),
+					  -EINVAL);
+
+			add_stats(*(uint64_t*)buf);
+			munmap(buf, item->memfd.size);
+			close(item->memfd.fd);
+			has_memfd =3D true;
+			break;
+		}
+
+		case KDBUS_ITEM_PAYLOAD_OFF:
+			/* ignore */
+			break;
+		}
+	}
+
+out:
+	if (!has_memfd)
+		add_stats(send_ns);
+
+	ret =3D kdbus_free(conn, recv.msg.offset);
+	ASSERT_RETURN_VAL(ret =3D=3D 0, -errno);
+
+	return 0;
+}
+
+static int benchmark(struct kdbus_test_env *env)
+{
+	static char buf[sizeof(stress_payload)];
+	struct kdbus_msg *kdbus_msg =3D NULL;
+	off_t memfd_cached_offset =3D 0;
+	int ret;
+	struct kdbus_conn *conn_a, *conn_b;
+	struct pollfd fds[2];
+	uint64_t start, send_ns, now_ns, diff;
+	unsigned int i;
+	int uds[2];
+
+	setlocale(LC_ALL, "");
+
+	for (i =3D 0; i < sizeof(stress_payload); i++)
+		stress_payload[i] =3D i;
+
+	/* setup kdbus pair */
+
+	conn_a =3D kdbus_hello(env->buspath, 0, NULL, 0);
+	conn_b =3D kdbus_hello(env->buspath, 0, NULL, 0);
+	ASSERT_RETURN(conn_a && conn_b);
+
+	ret =3D kdbus_add_match_empty(conn_a);
+	ASSERT_RETURN(ret =3D=3D 0);
+
+	ret =3D kdbus_add_match_empty(conn_b);
+	ASSERT_RETURN(ret =3D=3D 0);
+
+	ret =3D kdbus_name_acquire(conn_a, SERVICE_NAME, NULL);
+	ASSERT_RETURN(ret =3D=3D 0);
+
+	if (attach_none) {
+		ret =3D kdbus_conn_update_attach_flags(conn_a,
+						     _KDBUS_ATTACH_ALL,
+						     0);
+		ASSERT_RETURN(ret =3D=3D 0);
+	}
+
+	/* setup UDS pair */
+
+	ret =3D socketpair(AF_UNIX, SOCK_SEQPACKET | SOCK_NONBLOCK, 0, uds);
+	ASSERT_RETURN(ret =3D=3D 0);
+
+	/* setup a kdbus msg now */
+	if (use_memfd) {
+		ret =3D setup_memfd_kdbus_msg(conn_b, conn_a->id,
+					    &memfd_cached_offset,
+					    &kdbus_msg);
+		ASSERT_RETURN(ret =3D=3D 0);
+	} else {
+		ret =3D setup_simple_kdbus_msg(conn_b, conn_a->id, &kdbus_msg);
+		ASSERT_RETURN(ret =3D=3D 0);
+	}
+
+	/* start benchmark */
+
+	kdbus_printf("-- entering poll loop ...\n");
+
+	do {
+		/* run kdbus benchmark */
+		fds[0].fd =3D conn_a->fd;
+		fds[1].fd =3D conn_b->fd;
+
+		/* cancel any pending message */
+		handle_echo_reply(conn_a, 0);
+
+		start =3D now(CLOCK_THREAD_CPUTIME_ID);
+		reset_stats();
+
+		send_ns =3D now(CLOCK_THREAD_CPUTIME_ID);
+		ret =3D send_echo_request(conn_b, conn_a->id,
+					kdbus_msg, memfd_cached_offset);
+		ASSERT_RETURN(ret =3D=3D 0);
+
+		while (1) {
+			unsigned int nfds =3D sizeof(fds) / sizeof(fds[0]);
+			unsigned int i;
+
+			for (i =3D 0; i < nfds; i++) {
+				fds[i].events =3D POLLIN | POLLPRI | POLLHUP;
+				fds[i].revents =3D 0;
+			}
+
+			ret =3D poll(fds, nfds, 10);
+			if (ret < 0)
+				break;
+
+			if (fds[0].revents & POLLIN) {
+				ret =3D handle_echo_reply(conn_a, send_ns);
+				ASSERT_RETURN(ret =3D=3D 0);
+
+				send_ns =3D now(CLOCK_THREAD_CPUTIME_ID);
+				ret =3D send_echo_request(conn_b, conn_a->id,
+							kdbus_msg,
+							memfd_cached_offset);
+				ASSERT_RETURN(ret =3D=3D 0);
+			}
+
+			now_ns =3D now(CLOCK_THREAD_CPUTIME_ID);
+			diff =3D now_ns - start;
+			if (diff > 1000000000ULL) {
+				start =3D now_ns;
+
+				dump_stats(false);
+				break;
+			}
+		}
+
+		if (!compare_uds)
+			continue;
+
+		/* run unix-socket benchmark as comparison */
+
+		fds[0].fd =3D uds[0];
+		fds[1].fd =3D uds[1];
+
+		/* cancel any pendign message */
+		read(uds[1], buf, sizeof(buf));
+
+		start =3D now(CLOCK_THREAD_CPUTIME_ID);
+		reset_stats();
+
+		send_ns =3D now(CLOCK_THREAD_CPUTIME_ID);
+		ret =3D write(uds[0], stress_payload, sizeof(stress_payload));
+		ASSERT_RETURN(ret =3D=3D sizeof(stress_payload));
+
+		while (1) {
+			unsigned int nfds =3D sizeof(fds) / sizeof(fds[0]);
+			unsigned int i;
+
+			for (i =3D 0; i < nfds; i++) {
+				fds[i].events =3D POLLIN | POLLPRI | POLLHUP;
+				fds[i].revents =3D 0;
+			}
+
+			ret =3D poll(fds, nfds, 10);
+			if (ret < 0)
+				break;
+
+			if (fds[1].revents & POLLIN) {
+				ret =3D read(uds[1], buf, sizeof(buf));
+				ASSERT_RETURN(ret =3D=3D sizeof(buf));
+
+				add_stats(send_ns);
+
+				send_ns =3D now(CLOCK_THREAD_CPUTIME_ID);
+				ret =3D write(uds[0], buf, sizeof(buf));
+				ASSERT_RETURN(ret =3D=3D sizeof(buf));
+			}
+
+			now_ns =3D now(CLOCK_THREAD_CPUTIME_ID);
+			diff =3D now_ns - start;
+			if (diff > 1000000000ULL) {
+				start =3D now_ns;
+
+				dump_stats(true);
+				break;
+			}
+		}
+
+	} while (kdbus_util_verbose);
+
+	kdbus_printf("-- closing bus connections\n");
+
+	free(kdbus_msg);
+
+	kdbus_conn_free(conn_a);
+	kdbus_conn_free(conn_b);
+
+	return (stats.count > 1) ? TEST_OK : TEST_ERR;
+}
+
+int kdbus_test_benchmark(struct kdbus_test_env *env)
+{
+	use_memfd =3D true;
+	attach_none =3D false;
+	compare_uds =3D false;
+	return benchmark(env);
+}
+
+int kdbus_test_benchmark_nomemfds(struct kdbus_test_env *env)
+{
+	use_memfd =3D false;
+	attach_none =3D false;
+	compare_uds =3D false;
+	return benchmark(env);
+}
+
+int kdbus_test_benchmark_uds(struct kdbus_test_env *env)
+{
+	use_memfd =3D false;
+	attach_none =3D true;
+	compare_uds =3D true;
+	return benchmark(env);
+}
diff --git a/tools/testing/selftests/kdbus/test-bus.c b/tools/testing/s=
elftests/kdbus/test-bus.c
new file mode 100644
index 000000000000..762fb30397d4
--- /dev/null
+++ b/tools/testing/selftests/kdbus/test-bus.c
@@ -0,0 +1,175 @@
+#include <stdio.h>
+#include <string.h>
+#include <fcntl.h>
+#include <stdlib.h>
+#include <stddef.h>
+#include <unistd.h>
+#include <stdint.h>
+#include <errno.h>
+#include <assert.h>
+#include <limits.h>
+#include <sys/mman.h>
+#include <stdbool.h>
+
+#include "kdbus-api.h"
+#include "kdbus-util.h"
+#include "kdbus-enum.h"
+#include "kdbus-test.h"
+
+static struct kdbus_item *kdbus_get_item(struct kdbus_info *info,
+					 uint64_t type)
+{
+	struct kdbus_item *item;
+
+	KDBUS_ITEM_FOREACH(item, info, items)
+		if (item->type =3D=3D type)
+			return item;
+
+	return NULL;
+}
+
+static int test_bus_creator_info(const char *bus_path)
+{
+	int ret;
+	uint64_t offset;
+	struct kdbus_conn *conn;
+	struct kdbus_info *info;
+	struct kdbus_item *item;
+	char *tmp, *busname;
+
+	/* extract the bus-name from @bus_path */
+	tmp =3D strdup(bus_path);
+	ASSERT_RETURN(tmp);
+	busname =3D strrchr(tmp, '/');
+	ASSERT_RETURN(busname);
+	*busname =3D 0;
+	busname =3D strrchr(tmp, '/');
+	ASSERT_RETURN(busname);
+	++busname;
+
+	conn =3D kdbus_hello(bus_path, 0, NULL, 0);
+	ASSERT_RETURN(conn);
+
+	ret =3D kdbus_bus_creator_info(conn, _KDBUS_ATTACH_ALL, &offset);
+	ASSERT_RETURN(ret =3D=3D 0);
+
+	info =3D (struct kdbus_info *)(conn->buf + offset);
+
+	item =3D kdbus_get_item(info, KDBUS_ITEM_MAKE_NAME);
+	ASSERT_RETURN(item);
+	ASSERT_RETURN(!strcmp(item->str, busname));
+
+	ret =3D kdbus_free(conn, offset);
+	ASSERT_RETURN_VAL(ret =3D=3D 0, ret);
+
+	free(tmp);
+	kdbus_conn_free(conn);
+	return 0;
+}
+
+int kdbus_test_bus_make(struct kdbus_test_env *env)
+{
+	struct {
+		struct kdbus_cmd cmd;
+
+		/* bloom size item */
+		struct {
+			uint64_t size;
+			uint64_t type;
+			struct kdbus_bloom_parameter bloom;
+		} bs;
+
+		/* name item */
+		uint64_t n_size;
+		uint64_t n_type;
+		char name[64];
+	} bus_make;
+	char s[PATH_MAX], *name;
+	int ret, control_fd2;
+	uid_t uid;
+
+	name =3D unique_name("");
+	ASSERT_RETURN(name);
+
+	snprintf(s, sizeof(s), "%s/control", env->root);
+	env->control_fd =3D open(s, O_RDWR|O_CLOEXEC);
+	ASSERT_RETURN(env->control_fd >=3D 0);
+
+	control_fd2 =3D open(s, O_RDWR|O_CLOEXEC);
+	ASSERT_RETURN(control_fd2 >=3D 0);
+
+	memset(&bus_make, 0, sizeof(bus_make));
+
+	bus_make.bs.size =3D sizeof(bus_make.bs);
+	bus_make.bs.type =3D KDBUS_ITEM_BLOOM_PARAMETER;
+	bus_make.bs.bloom.size =3D 64;
+	bus_make.bs.bloom.n_hash =3D 1;
+
+	bus_make.n_type =3D KDBUS_ITEM_MAKE_NAME;
+
+	uid =3D getuid();
+
+	/* missing uid prefix */
+	snprintf(bus_make.name, sizeof(bus_make.name), "foo");
+	bus_make.n_size =3D KDBUS_ITEM_HEADER_SIZE + strlen(bus_make.name) + =
1;
+	bus_make.cmd.size =3D sizeof(struct kdbus_cmd) +
+			    sizeof(bus_make.bs) + bus_make.n_size;
+	ret =3D kdbus_cmd_bus_make(env->control_fd, &bus_make.cmd);
+	ASSERT_RETURN(ret =3D=3D -EINVAL);
+
+	/* non alphanumeric character */
+	snprintf(bus_make.name, sizeof(bus_make.name), "%u-blah@123", uid);
+	bus_make.n_size =3D KDBUS_ITEM_HEADER_SIZE + strlen(bus_make.name) + =
1;
+	bus_make.cmd.size =3D sizeof(struct kdbus_cmd) +
+			    sizeof(bus_make.bs) + bus_make.n_size;
+	ret =3D kdbus_cmd_bus_make(env->control_fd, &bus_make.cmd);
+	ASSERT_RETURN(ret =3D=3D -EINVAL);
+
+	/* '-' at the end */
+	snprintf(bus_make.name, sizeof(bus_make.name), "%u-blah-", uid);
+	bus_make.n_size =3D KDBUS_ITEM_HEADER_SIZE + strlen(bus_make.name) + =
1;
+	bus_make.cmd.size =3D sizeof(struct kdbus_cmd) +
+			    sizeof(bus_make.bs) + bus_make.n_size;
+	ret =3D kdbus_cmd_bus_make(env->control_fd, &bus_make.cmd);
+	ASSERT_RETURN(ret =3D=3D -EINVAL);
+
+	/* create a new bus */
+	snprintf(bus_make.name, sizeof(bus_make.name), "%u-%s-1", uid, name);
+	bus_make.n_size =3D KDBUS_ITEM_HEADER_SIZE + strlen(bus_make.name) + =
1;
+	bus_make.cmd.size =3D sizeof(struct kdbus_cmd) +
+			    sizeof(bus_make.bs) + bus_make.n_size;
+	ret =3D kdbus_cmd_bus_make(env->control_fd, &bus_make.cmd);
+	ASSERT_RETURN(ret =3D=3D 0);
+
+	ret =3D kdbus_cmd_bus_make(control_fd2, &bus_make.cmd);
+	ASSERT_RETURN(ret =3D=3D -EEXIST);
+
+	snprintf(s, sizeof(s), "%s/%u-%s-1/bus", env->root, uid, name);
+	ASSERT_RETURN(access(s, F_OK) =3D=3D 0);
+
+	ret =3D test_bus_creator_info(s);
+	ASSERT_RETURN(ret =3D=3D 0);
+
+	/* can't use the same fd for bus make twice, even though a different
+	 * bus name is used
+	 */
+	snprintf(bus_make.name, sizeof(bus_make.name), "%u-%s-2", uid, name);
+	bus_make.n_size =3D KDBUS_ITEM_HEADER_SIZE + strlen(bus_make.name) + =
1;
+	bus_make.cmd.size =3D sizeof(struct kdbus_cmd) +
+			    sizeof(bus_make.bs) + bus_make.n_size;
+	ret =3D kdbus_cmd_bus_make(env->control_fd, &bus_make.cmd);
+	ASSERT_RETURN(ret =3D=3D -EBADFD);
+
+	/* create a new bus, with different fd and different bus name */
+	snprintf(bus_make.name, sizeof(bus_make.name), "%u-%s-2", uid, name);
+	bus_make.n_size =3D KDBUS_ITEM_HEADER_SIZE + strlen(bus_make.name) + =
1;
+	bus_make.cmd.size =3D sizeof(struct kdbus_cmd) +
+			    sizeof(bus_make.bs) + bus_make.n_size;
+	ret =3D kdbus_cmd_bus_make(control_fd2, &bus_make.cmd);
+	ASSERT_RETURN(ret =3D=3D 0);
+
+	close(control_fd2);
+	free(name);
+
+	return TEST_OK;
+}
diff --git a/tools/testing/selftests/kdbus/test-chat.c b/tools/testing/=
selftests/kdbus/test-chat.c
new file mode 100644
index 000000000000..71a92d8b7c85
--- /dev/null
+++ b/tools/testing/selftests/kdbus/test-chat.c
@@ -0,0 +1,122 @@
+#include <stdio.h>
+#include <string.h>
+#include <time.h>
+#include <fcntl.h>
+#include <stdlib.h>
+#include <stddef.h>
+#include <unistd.h>
+#include <stdint.h>
+#include <errno.h>
+#include <assert.h>
+#include <poll.h>
+#include <stdbool.h>
+
+#include "kdbus-test.h"
+#include "kdbus-util.h"
+#include "kdbus-enum.h"
+
+int kdbus_test_chat(struct kdbus_test_env *env)
+{
+	int ret, cookie;
+	struct kdbus_conn *conn_a, *conn_b;
+	struct pollfd fds[2];
+	uint64_t flags;
+	int count;
+
+	conn_a =3D kdbus_hello(env->buspath, 0, NULL, 0);
+	conn_b =3D kdbus_hello(env->buspath, 0, NULL, 0);
+	ASSERT_RETURN(conn_a && conn_b);
+
+	flags =3D KDBUS_NAME_ALLOW_REPLACEMENT;
+	ret =3D kdbus_name_acquire(conn_a, "foo.bar.test", &flags);
+	ASSERT_RETURN(ret =3D=3D 0);
+
+	ret =3D kdbus_name_acquire(conn_a, "foo.bar.baz", NULL);
+	ASSERT_RETURN(ret =3D=3D 0);
+
+	flags =3D KDBUS_NAME_QUEUE;
+	ret =3D kdbus_name_acquire(conn_b, "foo.bar.baz", &flags);
+	ASSERT_RETURN(ret =3D=3D 0);
+
+	ret =3D kdbus_name_acquire(conn_a, "foo.bar.double", NULL);
+	ASSERT_RETURN(ret =3D=3D 0);
+
+	ret =3D kdbus_name_acquire(conn_a, "foo.bar.double", NULL);
+	ASSERT_RETURN(ret =3D=3D -EALREADY);
+
+	ret =3D kdbus_name_release(conn_a, "foo.bar.double");
+	ASSERT_RETURN(ret =3D=3D 0);
+
+	ret =3D kdbus_name_release(conn_a, "foo.bar.double");
+	ASSERT_RETURN(ret =3D=3D -ESRCH);
+
+	ret =3D kdbus_list(conn_b, KDBUS_LIST_UNIQUE |
+				 KDBUS_LIST_NAMES  |
+				 KDBUS_LIST_QUEUED |
+				 KDBUS_LIST_ACTIVATORS);
+	ASSERT_RETURN(ret =3D=3D 0);
+
+	ret =3D kdbus_add_match_empty(conn_a);
+	ASSERT_RETURN(ret =3D=3D 0);
+
+	ret =3D kdbus_add_match_empty(conn_b);
+	ASSERT_RETURN(ret =3D=3D 0);
+
+	cookie =3D 0;
+	ret =3D kdbus_msg_send(conn_b, NULL, 0xc0000000 | cookie, 0, 0, 0,
+			     KDBUS_DST_ID_BROADCAST);
+	ASSERT_RETURN(ret =3D=3D 0);
+
+	fds[0].fd =3D conn_a->fd;
+	fds[1].fd =3D conn_b->fd;
+
+	kdbus_printf("-- entering poll loop ...\n");
+
+	for (count =3D 0;; count++) {
+		int i, nfds =3D sizeof(fds) / sizeof(fds[0]);
+
+		for (i =3D 0; i < nfds; i++) {
+			fds[i].events =3D POLLIN | POLLPRI | POLLHUP;
+			fds[i].revents =3D 0;
+		}
+
+		ret =3D poll(fds, nfds, 3000);
+		ASSERT_RETURN(ret >=3D 0);
+
+		if (fds[0].revents & POLLIN) {
+			if (count > 2)
+				kdbus_name_release(conn_a, "foo.bar.baz");
+
+			ret =3D kdbus_msg_recv(conn_a, NULL, NULL);
+			ASSERT_RETURN(ret =3D=3D 0);
+			ret =3D kdbus_msg_send(conn_a, NULL,
+					     0xc0000000 | cookie++,
+					     0, 0, 0, conn_b->id);
+			ASSERT_RETURN(ret =3D=3D 0);
+		}
+
+		if (fds[1].revents & POLLIN) {
+			ret =3D kdbus_msg_recv(conn_b, NULL, NULL);
+			ASSERT_RETURN(ret =3D=3D 0);
+			ret =3D kdbus_msg_send(conn_b, NULL,
+					     0xc0000000 | cookie++,
+					     0, 0, 0, conn_a->id);
+			ASSERT_RETURN(ret =3D=3D 0);
+		}
+
+		ret =3D kdbus_list(conn_b, KDBUS_LIST_UNIQUE |
+					 KDBUS_LIST_NAMES  |
+					 KDBUS_LIST_QUEUED |
+					 KDBUS_LIST_ACTIVATORS);
+		ASSERT_RETURN(ret =3D=3D 0);
+
+		if (count > 10)
+			break;
+	}
+
+	kdbus_printf("-- closing bus connections\n");
+	kdbus_conn_free(conn_a);
+	kdbus_conn_free(conn_b);
+
+	return TEST_OK;
+}
diff --git a/tools/testing/selftests/kdbus/test-connection.c b/tools/te=
sting/selftests/kdbus/test-connection.c
new file mode 100644
index 000000000000..5c2bf3511daa
--- /dev/null
+++ b/tools/testing/selftests/kdbus/test-connection.c
@@ -0,0 +1,616 @@
+#include <stdio.h>
+#include <string.h>
+#include <fcntl.h>
+#include <stdlib.h>
+#include <stddef.h>
+#include <unistd.h>
+#include <stdint.h>
+#include <errno.h>
+#include <assert.h>
+#include <limits.h>
+#include <sys/types.h>
+#include <sys/capability.h>
+#include <sys/mman.h>
+#include <sys/syscall.h>
+#include <sys/wait.h>
+#include <stdbool.h>
+
+#include "kdbus-api.h"
+#include "kdbus-util.h"
+#include "kdbus-enum.h"
+#include "kdbus-test.h"
+
+int kdbus_test_hello(struct kdbus_test_env *env)
+{
+	struct kdbus_cmd_free cmd_free =3D {};
+	struct kdbus_cmd_hello hello;
+	int fd, ret;
+
+	memset(&hello, 0, sizeof(hello));
+
+	fd =3D open(env->buspath, O_RDWR|O_CLOEXEC);
+	ASSERT_RETURN(fd >=3D 0);
+
+	hello.flags =3D KDBUS_HELLO_ACCEPT_FD;
+	hello.attach_flags_send =3D _KDBUS_ATTACH_ALL;
+	hello.attach_flags_recv =3D _KDBUS_ATTACH_ALL;
+	hello.size =3D sizeof(struct kdbus_cmd_hello);
+	hello.pool_size =3D POOL_SIZE;
+
+	/* an unaligned hello must result in -EFAULT */
+	ret =3D kdbus_cmd_hello(fd, (struct kdbus_cmd_hello *) ((char *) &hel=
lo + 1));
+	ASSERT_RETURN(ret =3D=3D -EFAULT);
+
+	/* a size of 0 must return EMSGSIZE */
+	hello.size =3D 1;
+	hello.flags =3D KDBUS_HELLO_ACCEPT_FD;
+	hello.attach_flags_send =3D _KDBUS_ATTACH_ALL;
+	ret =3D kdbus_cmd_hello(fd, &hello);
+	ASSERT_RETURN(ret =3D=3D -EINVAL);
+
+	hello.size =3D sizeof(struct kdbus_cmd_hello);
+
+	/* check faulty flags */
+	hello.flags =3D 1ULL << 32;
+	hello.attach_flags_send =3D _KDBUS_ATTACH_ALL;
+	ret =3D kdbus_cmd_hello(fd, &hello);
+	ASSERT_RETURN(ret =3D=3D -EINVAL);
+
+	/* check for faulty pool sizes */
+	hello.pool_size =3D 0;
+	hello.flags =3D KDBUS_HELLO_ACCEPT_FD;
+	hello.attach_flags_send =3D _KDBUS_ATTACH_ALL;
+	ret =3D kdbus_cmd_hello(fd, &hello);
+	ASSERT_RETURN(ret =3D=3D -EINVAL);
+
+	hello.pool_size =3D 4097;
+	hello.attach_flags_send =3D _KDBUS_ATTACH_ALL;
+	ret =3D kdbus_cmd_hello(fd, &hello);
+	ASSERT_RETURN(ret =3D=3D -EINVAL);
+
+	hello.pool_size =3D POOL_SIZE;
+
+	/*
+	 * The connection created by the core requires ALL meta flags
+	 * to be sent. An attempt to send less than that should result in
+	 * -ECONNREFUSED.
+	 */
+	hello.attach_flags_send =3D _KDBUS_ATTACH_ALL & ~KDBUS_ATTACH_TIMESTA=
MP;
+	ret =3D kdbus_cmd_hello(fd, &hello);
+	ASSERT_RETURN(ret =3D=3D -ECONNREFUSED);
+
+	hello.attach_flags_send =3D _KDBUS_ATTACH_ALL;
+	hello.offset =3D (__u64)-1;
+
+	/* success test */
+	ret =3D kdbus_cmd_hello(fd, &hello);
+	ASSERT_RETURN(ret =3D=3D 0);
+
+	/* The kernel should have returned some items */
+	ASSERT_RETURN(hello.offset !=3D (__u64)-1);
+	cmd_free.size =3D sizeof(cmd_free);
+	cmd_free.offset =3D hello.offset;
+	ret =3D kdbus_cmd_free(fd, &cmd_free);
+	ASSERT_RETURN(ret >=3D 0);
+
+	close(fd);
+
+	fd =3D open(env->buspath, O_RDWR|O_CLOEXEC);
+	ASSERT_RETURN(fd >=3D 0);
+
+	/* no ACTIVATOR flag without a name */
+	hello.flags =3D KDBUS_HELLO_ACTIVATOR;
+	ret =3D kdbus_cmd_hello(fd, &hello);
+	ASSERT_RETURN(ret =3D=3D -EINVAL);
+
+	close(fd);
+
+	return TEST_OK;
+}
+
+int kdbus_test_byebye(struct kdbus_test_env *env)
+{
+	struct kdbus_conn *conn;
+	struct kdbus_cmd_recv cmd_recv =3D { .size =3D sizeof(cmd_recv) };
+	struct kdbus_cmd cmd_byebye =3D { .size =3D sizeof(cmd_byebye) };
+	int ret;
+
+	/* create a 2nd connection */
+	conn =3D kdbus_hello(env->buspath, 0, NULL, 0);
+	ASSERT_RETURN(conn !=3D NULL);
+
+	ret =3D kdbus_add_match_empty(conn);
+	ASSERT_RETURN(ret =3D=3D 0);
+
+	ret =3D kdbus_add_match_empty(env->conn);
+	ASSERT_RETURN(ret =3D=3D 0);
+
+	/* send over 1st connection */
+	ret =3D kdbus_msg_send(env->conn, NULL, 0, 0, 0, 0,
+			     KDBUS_DST_ID_BROADCAST);
+	ASSERT_RETURN(ret =3D=3D 0);
+
+	/* say byebye on the 2nd, which must fail */
+	ret =3D kdbus_cmd_byebye(conn->fd, &cmd_byebye);
+	ASSERT_RETURN(ret =3D=3D -EBUSY);
+
+	/* receive the message */
+	ret =3D kdbus_cmd_recv(conn->fd, &cmd_recv);
+	ASSERT_RETURN(ret =3D=3D 0);
+
+	ret =3D kdbus_free(conn, cmd_recv.msg.offset);
+	ASSERT_RETURN(ret =3D=3D 0);
+
+	/* and try again */
+	ret =3D kdbus_cmd_byebye(conn->fd, &cmd_byebye);
+	ASSERT_RETURN(ret =3D=3D 0);
+
+	/* a 2nd try should result in -ECONNRESET */
+	ret =3D kdbus_cmd_byebye(conn->fd, &cmd_byebye);
+	ASSERT_RETURN(ret =3D=3D -ECONNRESET);
+
+	kdbus_conn_free(conn);
+
+	return TEST_OK;
+}
+
+/* Get only the first item */
+static struct kdbus_item *kdbus_get_item(struct kdbus_info *info,
+					 uint64_t type)
+{
+	struct kdbus_item *item;
+
+	KDBUS_ITEM_FOREACH(item, info, items)
+		if (item->type =3D=3D type)
+			return item;
+
+	return NULL;
+}
+
+static unsigned int kdbus_count_item(struct kdbus_info *info,
+				     uint64_t type)
+{
+	unsigned int i =3D 0;
+	const struct kdbus_item *item;
+
+	KDBUS_ITEM_FOREACH(item, info, items)
+		if (item->type =3D=3D type)
+			i++;
+
+	return i;
+}
+
+static int kdbus_fuzz_conn_info(struct kdbus_test_env *env, int capabl=
e)
+{
+	int ret;
+	unsigned int cnt =3D 0;
+	uint64_t offset =3D 0;
+	uint64_t kdbus_flags_mask;
+	struct kdbus_info *info;
+	struct kdbus_conn *conn;
+	struct kdbus_conn *privileged;
+	const struct kdbus_item *item;
+	uint64_t valid_flags_set;
+	uint64_t invalid_flags_set;
+	uint64_t valid_flags =3D KDBUS_ATTACH_NAMES |
+			       KDBUS_ATTACH_CREDS |
+			       KDBUS_ATTACH_PIDS |
+			       KDBUS_ATTACH_CONN_DESCRIPTION;
+
+	uint64_t invalid_flags =3D KDBUS_ATTACH_NAMES	|
+				 KDBUS_ATTACH_CREDS	|
+				 KDBUS_ATTACH_PIDS	|
+				 KDBUS_ATTACH_CAPS	|
+				 KDBUS_ATTACH_CGROUP	|
+				 KDBUS_ATTACH_CONN_DESCRIPTION;
+
+	struct kdbus_creds cached_creds;
+	uid_t ruid, euid, suid;
+	gid_t rgid, egid, sgid;
+
+	getresuid(&ruid, &euid, &suid);
+	getresgid(&rgid, &egid, &sgid);
+
+	cached_creds.uid =3D ruid;
+	cached_creds.euid =3D euid;
+	cached_creds.suid =3D suid;
+	cached_creds.fsuid =3D ruid;
+
+	cached_creds.gid =3D rgid;
+	cached_creds.egid =3D egid;
+	cached_creds.sgid =3D sgid;
+	cached_creds.fsgid =3D rgid;
+
+	struct kdbus_pids cached_pids =3D {
+		.pid	=3D getpid(),
+		.tid	=3D syscall(SYS_gettid),
+		.ppid	=3D getppid(),
+	};
+
+	ret =3D kdbus_sysfs_get_parameter_mask(env->mask_param_path,
+					     &kdbus_flags_mask);
+	ASSERT_RETURN(ret =3D=3D 0);
+
+	valid_flags_set =3D valid_flags & kdbus_flags_mask;
+	invalid_flags_set =3D invalid_flags & kdbus_flags_mask;
+
+	ret =3D kdbus_conn_info(env->conn, env->conn->id, NULL,
+			      valid_flags, &offset);
+	ASSERT_RETURN(ret =3D=3D 0);
+
+	info =3D (struct kdbus_info *)(env->conn->buf + offset);
+	ASSERT_RETURN(info->id =3D=3D env->conn->id);
+
+	/* We do not have any well-known name */
+	item =3D kdbus_get_item(info, KDBUS_ITEM_NAME);
+	ASSERT_RETURN(item =3D=3D NULL);
+
+	item =3D kdbus_get_item(info, KDBUS_ITEM_CONN_DESCRIPTION);
+	if (valid_flags_set & KDBUS_ATTACH_CONN_DESCRIPTION) {
+		ASSERT_RETURN(item);
+	} else {
+		ASSERT_RETURN(item =3D=3D NULL);
+	}
+
+	kdbus_free(env->conn, offset);
+
+	conn =3D kdbus_hello(env->buspath, 0, NULL, 0);
+	ASSERT_RETURN(conn);
+
+	privileged =3D kdbus_hello(env->buspath, 0, NULL, 0);
+	ASSERT_RETURN(privileged);
+
+	ret =3D kdbus_conn_info(conn, conn->id, NULL, valid_flags, &offset);
+	ASSERT_RETURN(ret =3D=3D 0);
+
+	info =3D (struct kdbus_info *)(conn->buf + offset);
+	ASSERT_RETURN(info->id =3D=3D conn->id);
+
+	/* We do not have any well-known name */
+	item =3D kdbus_get_item(info, KDBUS_ITEM_NAME);
+	ASSERT_RETURN(item =3D=3D NULL);
+
+	cnt =3D kdbus_count_item(info, KDBUS_ITEM_CREDS);
+	if (valid_flags_set & KDBUS_ATTACH_CREDS) {
+		ASSERT_RETURN(cnt =3D=3D 1);
+
+		item =3D kdbus_get_item(info, KDBUS_ITEM_CREDS);
+		ASSERT_RETURN(item);
+
+		/* Compare received items with cached creds */
+		ASSERT_RETURN(memcmp(&item->creds, &cached_creds,
+				      sizeof(struct kdbus_creds)) =3D=3D 0);
+	} else {
+		ASSERT_RETURN(cnt =3D=3D 0);
+	}
+
+	item =3D kdbus_get_item(info, KDBUS_ITEM_PIDS);
+	if (valid_flags_set & KDBUS_ATTACH_PIDS) {
+		ASSERT_RETURN(item);
+
+		/* Compare item->pids with cached PIDs */
+		ASSERT_RETURN(item->pids.pid =3D=3D cached_pids.pid &&
+			      item->pids.tid =3D=3D cached_pids.tid &&
+			      item->pids.ppid =3D=3D cached_pids.ppid);
+	} else {
+		ASSERT_RETURN(item =3D=3D NULL);
+	}
+
+	/* We did not request KDBUS_ITEM_CAPS */
+	item =3D kdbus_get_item(info, KDBUS_ITEM_CAPS);
+	ASSERT_RETURN(item =3D=3D NULL);
+
+	kdbus_free(conn, offset);
+
+	ret =3D kdbus_name_acquire(conn, "com.example.a", NULL);
+	ASSERT_RETURN(ret >=3D 0);
+
+	ret =3D kdbus_conn_info(conn, conn->id, NULL, valid_flags, &offset);
+	ASSERT_RETURN(ret =3D=3D 0);
+
+	info =3D (struct kdbus_info *)(conn->buf + offset);
+	ASSERT_RETURN(info->id =3D=3D conn->id);
+
+	item =3D kdbus_get_item(info, KDBUS_ITEM_OWNED_NAME);
+	if (valid_flags_set & KDBUS_ATTACH_NAMES) {
+		ASSERT_RETURN(item && !strcmp(item->name.name, "com.example.a"));
+	} else {
+		ASSERT_RETURN(item =3D=3D NULL);
+	}
+
+	kdbus_free(conn, offset);
+
+	ret =3D kdbus_conn_info(conn, 0, "com.example.a", valid_flags, &offse=
t);
+	ASSERT_RETURN(ret =3D=3D 0);
+
+	info =3D (struct kdbus_info *)(conn->buf + offset);
+	ASSERT_RETURN(info->id =3D=3D conn->id);
+
+	kdbus_free(conn, offset);
+
+	/* does not have the necessary caps to drop to unprivileged */
+	if (!capable)
+		goto continue_test;
+
+	ret =3D RUN_UNPRIVILEGED(UNPRIV_UID, UNPRIV_GID, ({
+		ret =3D kdbus_conn_info(conn, conn->id, NULL,
+				      valid_flags, &offset);
+		ASSERT_EXIT(ret =3D=3D 0);
+
+		info =3D (struct kdbus_info *)(conn->buf + offset);
+		ASSERT_EXIT(info->id =3D=3D conn->id);
+
+		if (valid_flags_set & KDBUS_ATTACH_NAMES) {
+			item =3D kdbus_get_item(info, KDBUS_ITEM_OWNED_NAME);
+			ASSERT_EXIT(item &&
+				    strcmp(item->name.name,
+				           "com.example.a") =3D=3D 0);
+		}
+
+		if (valid_flags_set & KDBUS_ATTACH_CREDS) {
+			item =3D kdbus_get_item(info, KDBUS_ITEM_CREDS);
+			ASSERT_EXIT(item);
+
+			/* Compare received items with cached creds */
+			ASSERT_EXIT(memcmp(&item->creds, &cached_creds,
+				    sizeof(struct kdbus_creds)) =3D=3D 0);
+		}
+
+		if (valid_flags_set & KDBUS_ATTACH_PIDS) {
+			item =3D kdbus_get_item(info, KDBUS_ITEM_PIDS);
+			ASSERT_EXIT(item);
+
+			/*
+			 * Compare item->pids with cached pids of
+			 * privileged one.
+			 *
+			 * cmd_info will always return cached pids.
+			 */
+			ASSERT_EXIT(item->pids.pid =3D=3D cached_pids.pid &&
+				    item->pids.tid =3D=3D cached_pids.tid);
+		}
+
+		kdbus_free(conn, offset);
+
+		/*
+		 * Use invalid_flags and make sure that userspace
+		 * do not play with us.
+		 */
+		ret =3D kdbus_conn_info(conn, conn->id, NULL,
+				      invalid_flags, &offset);
+		ASSERT_EXIT(ret =3D=3D 0);
+
+		/*
+		 * Make sure that we return only one creds item and
+		 * it points to the cached creds.
+		 */
+		cnt =3D kdbus_count_item(info, KDBUS_ITEM_CREDS);
+		if (invalid_flags_set & KDBUS_ATTACH_CREDS) {
+			ASSERT_EXIT(cnt =3D=3D 1);
+
+			item =3D kdbus_get_item(info, KDBUS_ITEM_CREDS);
+			ASSERT_EXIT(item);
+
+			/* Compare received items with cached creds */
+			ASSERT_EXIT(memcmp(&item->creds, &cached_creds,
+				    sizeof(struct kdbus_creds)) =3D=3D 0);
+		} else {
+			ASSERT_EXIT(cnt =3D=3D 0);
+		}
+
+		if (invalid_flags_set & KDBUS_ATTACH_PIDS) {
+			cnt =3D kdbus_count_item(info, KDBUS_ITEM_PIDS);
+			ASSERT_EXIT(cnt =3D=3D 1);
+
+			item =3D kdbus_get_item(info, KDBUS_ITEM_PIDS);
+			ASSERT_EXIT(item);
+
+			/* Compare item->pids with cached pids */
+			ASSERT_EXIT(item->pids.pid =3D=3D cached_pids.pid &&
+				    item->pids.tid =3D=3D cached_pids.tid);
+		}
+
+		cnt =3D kdbus_count_item(info, KDBUS_ITEM_CGROUP);
+		if (invalid_flags_set & KDBUS_ATTACH_CGROUP) {
+			ASSERT_EXIT(cnt =3D=3D 1);
+		} else {
+			ASSERT_EXIT(cnt =3D=3D 0);
+		}
+
+		cnt =3D kdbus_count_item(info, KDBUS_ITEM_CAPS);
+		if (invalid_flags_set & KDBUS_ATTACH_CAPS) {
+			ASSERT_EXIT(cnt =3D=3D 1);
+		} else {
+			ASSERT_EXIT(cnt =3D=3D 0);
+		}
+
+		kdbus_free(conn, offset);
+	}),
+	({ 0; }));
+	ASSERT_RETURN(ret =3D=3D 0);
+
+continue_test:
+
+	/* A second name */
+	ret =3D kdbus_name_acquire(conn, "com.example.b", NULL);
+	ASSERT_RETURN(ret >=3D 0);
+
+	ret =3D kdbus_conn_info(conn, conn->id, NULL, valid_flags, &offset);
+	ASSERT_RETURN(ret =3D=3D 0);
+
+	info =3D (struct kdbus_info *)(conn->buf + offset);
+	ASSERT_RETURN(info->id =3D=3D conn->id);
+
+	cnt =3D kdbus_count_item(info, KDBUS_ITEM_OWNED_NAME);
+	if (valid_flags_set & KDBUS_ATTACH_NAMES) {
+		ASSERT_RETURN(cnt =3D=3D 2);
+	} else {
+		ASSERT_RETURN(cnt =3D=3D 0);
+	}
+
+	kdbus_free(conn, offset);
+
+	ASSERT_RETURN(ret =3D=3D 0);
+
+	return 0;
+}
+
+int kdbus_test_conn_info(struct kdbus_test_env *env)
+{
+	int ret;
+	int have_caps;
+	struct {
+		struct kdbus_cmd_info cmd_info;
+
+		struct {
+			uint64_t size;
+			uint64_t type;
+			char str[64];
+		} name;
+	} buf;
+
+	buf.cmd_info.size =3D sizeof(struct kdbus_cmd_info);
+	buf.cmd_info.flags =3D 0;
+	buf.cmd_info.attach_flags =3D 0;
+	buf.cmd_info.id =3D env->conn->id;
+
+	ret =3D kdbus_conn_info(env->conn, env->conn->id, NULL, 0, NULL);
+	ASSERT_RETURN(ret =3D=3D 0);
+
+	/* try to pass a name that is longer than the buffer's size */
+	buf.name.size =3D KDBUS_ITEM_HEADER_SIZE + 1;
+	buf.name.type =3D KDBUS_ITEM_NAME;
+	strcpy(buf.name.str, "foo.bar.bla");
+
+	buf.cmd_info.id =3D 0;
+	buf.cmd_info.size =3D sizeof(buf.cmd_info) + buf.name.size;
+	ret =3D kdbus_cmd_conn_info(env->conn->fd, (struct kdbus_cmd_info *) =
&buf);
+	ASSERT_RETURN(ret =3D=3D -EINVAL);
+
+	/* Pass a non existent name */
+	ret =3D kdbus_conn_info(env->conn, 0, "non.existent.name", 0, NULL);
+	ASSERT_RETURN(ret =3D=3D -ESRCH);
+
+	if (!all_uids_gids_are_mapped())
+		return TEST_SKIP;
+
+	/* Test for caps here, so we run the previous test */
+	have_caps =3D test_is_capable(CAP_SETUID, CAP_SETGID, -1);
+	ASSERT_RETURN(have_caps >=3D 0);
+
+	ret =3D kdbus_fuzz_conn_info(env, have_caps);
+	ASSERT_RETURN(ret =3D=3D 0);
+
+	/* Now if we have skipped some tests then let the user know */
+	if (!have_caps)
+		return TEST_SKIP;
+
+	return TEST_OK;
+}
+
+int kdbus_test_conn_update(struct kdbus_test_env *env)
+{
+	struct kdbus_conn *conn;
+	struct kdbus_msg *msg;
+	int found =3D 0;
+	int ret;
+
+	/*
+	 * kdbus_hello() sets all attach flags. Receive a message by this
+	 * connection, and make sure a timestamp item (just to pick one) is
+	 * present.
+	 */
+	conn =3D kdbus_hello(env->buspath, 0, NULL, 0);
+	ASSERT_RETURN(conn);
+
+	ret =3D kdbus_msg_send(env->conn, NULL, 0x12345678, 0, 0, 0, conn->id=
);
+	ASSERT_RETURN(ret =3D=3D 0);
+
+	ret =3D kdbus_msg_recv(conn, &msg, NULL);
+	ASSERT_RETURN(ret =3D=3D 0);
+
+	found =3D kdbus_item_in_message(msg, KDBUS_ITEM_TIMESTAMP);
+	ASSERT_RETURN(found =3D=3D 1);
+
+	kdbus_msg_free(msg);
+
+	/*
+	 * Now, modify the attach flags and repeat the action. The item must
+	 * now be missing.
+	 */
+	found =3D 0;
+
+	ret =3D kdbus_conn_update_attach_flags(conn,
+					     _KDBUS_ATTACH_ALL,
+					     _KDBUS_ATTACH_ALL &
+					     ~KDBUS_ATTACH_TIMESTAMP);
+	ASSERT_RETURN(ret =3D=3D 0);
+
+	ret =3D kdbus_msg_send(env->conn, NULL, 0x12345678, 0, 0, 0, conn->id=
);
+	ASSERT_RETURN(ret =3D=3D 0);
+
+	ret =3D kdbus_msg_recv(conn, &msg, NULL);
+	ASSERT_RETURN(ret =3D=3D 0);
+
+	found =3D kdbus_item_in_message(msg, KDBUS_ITEM_TIMESTAMP);
+	ASSERT_RETURN(found =3D=3D 0);
+
+	/* Provide a bogus attach_flags value */
+	ret =3D kdbus_conn_update_attach_flags(conn,
+					     _KDBUS_ATTACH_ALL + 1,
+					     _KDBUS_ATTACH_ALL);
+	ASSERT_RETURN(ret =3D=3D -EINVAL);
+
+	kdbus_msg_free(msg);
+
+	kdbus_conn_free(conn);
+
+	return TEST_OK;
+}
+
+int kdbus_test_writable_pool(struct kdbus_test_env *env)
+{
+	struct kdbus_cmd_free cmd_free =3D {};
+	struct kdbus_cmd_hello hello;
+	int fd, ret;
+	void *map;
+
+	fd =3D open(env->buspath, O_RDWR | O_CLOEXEC);
+	ASSERT_RETURN(fd >=3D 0);
+
+	memset(&hello, 0, sizeof(hello));
+	hello.flags =3D KDBUS_HELLO_ACCEPT_FD;
+	hello.attach_flags_send =3D _KDBUS_ATTACH_ALL;
+	hello.attach_flags_recv =3D _KDBUS_ATTACH_ALL;
+	hello.size =3D sizeof(struct kdbus_cmd_hello);
+	hello.pool_size =3D POOL_SIZE;
+	hello.offset =3D (__u64)-1;
+
+	/* success test */
+	ret =3D kdbus_cmd_hello(fd, &hello);
+	ASSERT_RETURN(ret =3D=3D 0);
+
+	/* The kernel should have returned some items */
+	ASSERT_RETURN(hello.offset !=3D (__u64)-1);
+	cmd_free.size =3D sizeof(cmd_free);
+	cmd_free.offset =3D hello.offset;
+	ret =3D kdbus_cmd_free(fd, &cmd_free);
+	ASSERT_RETURN(ret >=3D 0);
+
+	/* pools cannot be mapped writable */
+	map =3D mmap(NULL, POOL_SIZE, PROT_READ | PROT_WRITE, MAP_SHARED, fd,=
 0);
+	ASSERT_RETURN(map =3D=3D MAP_FAILED);
+
+	/* pools can always be mapped readable */
+	map =3D mmap(NULL, POOL_SIZE, PROT_READ, MAP_SHARED, fd, 0);
+	ASSERT_RETURN(map !=3D MAP_FAILED);
+
+	/* make sure we cannot change protection masks to writable */
+	ret =3D mprotect(map, POOL_SIZE, PROT_READ | PROT_WRITE);
+	ASSERT_RETURN(ret < 0);
+
+	munmap(map, POOL_SIZE);
+	close(fd);
+
+	return TEST_OK;
+}
diff --git a/tools/testing/selftests/kdbus/test-daemon.c b/tools/testin=
g/selftests/kdbus/test-daemon.c
new file mode 100644
index 000000000000..8bc2386190d9
--- /dev/null
+++ b/tools/testing/selftests/kdbus/test-daemon.c
@@ -0,0 +1,65 @@
+#include <stdio.h>
+#include <string.h>
+#include <time.h>
+#include <fcntl.h>
+#include <stdlib.h>
+#include <stddef.h>
+#include <unistd.h>
+#include <stdint.h>
+#include <errno.h>
+#include <assert.h>
+#include <poll.h>
+#include <stdbool.h>
+
+#include "kdbus-test.h"
+#include "kdbus-util.h"
+#include "kdbus-enum.h"
+
+int kdbus_test_daemon(struct kdbus_test_env *env)
+{
+	struct pollfd fds[2];
+	int count;
+	int ret;
+
+	/* This test doesn't make any sense in non-interactive mode */
+	if (!kdbus_util_verbose)
+		return TEST_OK;
+
+	printf("Created connection %llu on bus '%s'\n",
+		(unsigned long long) env->conn->id, env->buspath);
+
+	ret =3D kdbus_name_acquire(env->conn, "com.example.kdbus-test", NULL)=
;
+	ASSERT_RETURN(ret =3D=3D 0);
+	printf("  Aquired name: com.example.kdbus-test\n");
+
+	fds[0].fd =3D env->conn->fd;
+	fds[1].fd =3D STDIN_FILENO;
+
+	printf("Monitoring connections:\n");
+
+	for (count =3D 0;; count++) {
+		int i, nfds =3D sizeof(fds) / sizeof(fds[0]);
+
+		for (i =3D 0; i < nfds; i++) {
+			fds[i].events =3D POLLIN | POLLPRI | POLLHUP;
+			fds[i].revents =3D 0;
+		}
+
+		ret =3D poll(fds, nfds, -1);
+		if (ret <=3D 0)
+			break;
+
+		if (fds[0].revents & POLLIN) {
+			ret =3D kdbus_msg_recv(env->conn, NULL, NULL);
+			ASSERT_RETURN(ret =3D=3D 0);
+		}
+
+		/* stdin */
+		if (fds[1].revents & POLLIN)
+			break;
+	}
+
+	printf("Closing bus connection\n");
+
+	return TEST_OK;
+}
diff --git a/tools/testing/selftests/kdbus/test-endpoint.c b/tools/test=
ing/selftests/kdbus/test-endpoint.c
new file mode 100644
index 000000000000..dcc6ab91c4e6
--- /dev/null
+++ b/tools/testing/selftests/kdbus/test-endpoint.c
@@ -0,0 +1,341 @@
+#include <stdio.h>
+#include <string.h>
+#include <fcntl.h>
+#include <stdlib.h>
+#include <stddef.h>
+#include <unistd.h>
+#include <stdint.h>
+#include <errno.h>
+#include <assert.h>
+#include <libgen.h>
+#include <sys/capability.h>
+#include <sys/wait.h>
+#include <stdbool.h>
+
+#include "kdbus-api.h"
+#include "kdbus-util.h"
+#include "kdbus-enum.h"
+#include "kdbus-test.h"
+
+#define KDBUS_SYSNAME_MAX_LEN			63
+
+static int install_name_add_match(struct kdbus_conn *conn, const char =
*name)
+{
+	struct {
+		struct kdbus_cmd_match cmd;
+		struct {
+			uint64_t size;
+			uint64_t type;
+			struct kdbus_notify_name_change chg;
+		} item;
+		char name[64];
+	} buf;
+	int ret;
+
+	/* install the match rule */
+	memset(&buf, 0, sizeof(buf));
+	buf.item.type =3D KDBUS_ITEM_NAME_ADD;
+	buf.item.chg.old_id.id =3D KDBUS_MATCH_ID_ANY;
+	buf.item.chg.new_id.id =3D KDBUS_MATCH_ID_ANY;
+	strncpy(buf.name, name, sizeof(buf.name) - 1);
+	buf.item.size =3D sizeof(buf.item) + strlen(buf.name) + 1;
+	buf.cmd.size =3D sizeof(buf.cmd) + buf.item.size;
+
+	ret =3D kdbus_cmd_match_add(conn->fd, &buf.cmd);
+	if (ret < 0)
+		return ret;
+
+	return 0;
+}
+
+static int create_endpoint(const char *buspath, uid_t uid, const char =
*name,
+			   uint64_t flags)
+{
+	struct {
+		struct kdbus_cmd cmd;
+
+		/* name item */
+		struct {
+			uint64_t size;
+			uint64_t type;
+			/* max should be KDBUS_SYSNAME_MAX_LEN */
+			char str[128];
+		} name;
+	} ep_make;
+	int fd, ret;
+
+	fd =3D open(buspath, O_RDWR);
+	if (fd < 0)
+		return fd;
+
+	memset(&ep_make, 0, sizeof(ep_make));
+
+	snprintf(ep_make.name.str,
+		 /* Use the KDBUS_SYSNAME_MAX_LEN or sizeof(str) */
+		 KDBUS_SYSNAME_MAX_LEN > strlen(name) ?
+		 KDBUS_SYSNAME_MAX_LEN : sizeof(ep_make.name.str),
+		 "%u-%s", uid, name);
+
+	ep_make.name.type =3D KDBUS_ITEM_MAKE_NAME;
+	ep_make.name.size =3D KDBUS_ITEM_HEADER_SIZE +
+			    strlen(ep_make.name.str) + 1;
+
+	ep_make.cmd.flags =3D flags;
+	ep_make.cmd.size =3D sizeof(ep_make.cmd) + ep_make.name.size;
+
+	ret =3D kdbus_cmd_endpoint_make(fd, &ep_make.cmd);
+	if (ret < 0) {
+		kdbus_printf("error creating endpoint: %d (%m)\n", ret);
+		return ret;
+	}
+
+	return fd;
+}
+
+static int unpriv_test_custom_ep(const char *buspath)
+{
+	int ret, ep_fd1, ep_fd2;
+	char *ep1, *ep2, *tmp1, *tmp2;
+
+	tmp1 =3D strdup(buspath);
+	tmp2 =3D strdup(buspath);
+	ASSERT_RETURN(tmp1 && tmp2);
+
+	ret =3D asprintf(&ep1, "%s/%u-%s", dirname(tmp1), getuid(), "apps1");
+	ASSERT_RETURN(ret >=3D 0);
+
+	ret =3D asprintf(&ep2, "%s/%u-%s", dirname(tmp2), getuid(), "apps2");
+	ASSERT_RETURN(ret >=3D 0);
+
+	free(tmp1);
+	free(tmp2);
+
+	/* endpoint only accessible to current uid */
+	ep_fd1 =3D create_endpoint(buspath, getuid(), "apps1", 0);
+	ASSERT_RETURN(ep_fd1 >=3D 0);
+
+	/* endpoint world accessible */
+	ep_fd2 =3D create_endpoint(buspath, getuid(), "apps2",
+				  KDBUS_MAKE_ACCESS_WORLD);
+	ASSERT_RETURN(ep_fd2 >=3D 0);
+
+	ret =3D RUN_UNPRIVILEGED(UNPRIV_UID, UNPRIV_UID, ({
+		int ep_fd;
+		struct kdbus_conn *ep_conn;
+
+		/*
+		 * Make sure that we are not able to create custom
+		 * endpoints
+		 */
+		ep_fd =3D create_endpoint(buspath, getuid(),
+					"unpriv_costum_ep", 0);
+		ASSERT_EXIT(ep_fd =3D=3D -EPERM);
+
+		/*
+		 * Endpoint "apps1" only accessible to same users,
+		 * that own the endpoint. Access denied by VFS
+		 */
+		ep_conn =3D kdbus_hello(ep1, 0, NULL, 0);
+		ASSERT_EXIT(!ep_conn && errno =3D=3D EACCES);
+
+		/* Endpoint "apps2" world accessible */
+		ep_conn =3D kdbus_hello(ep2, 0, NULL, 0);
+		ASSERT_EXIT(ep_conn);
+
+		kdbus_conn_free(ep_conn);
+
+		_exit(EXIT_SUCCESS);
+	}),
+	({ 0; }));
+	ASSERT_RETURN(ret =3D=3D 0);
+
+	close(ep_fd1);
+	close(ep_fd2);
+	free(ep1);
+	free(ep2);
+
+	return 0;
+}
+
+static int update_endpoint(int fd, const char *name)
+{
+	int len =3D strlen(name) + 1;
+	struct {
+		struct kdbus_cmd cmd;
+
+		/* name item */
+		struct {
+			uint64_t size;
+			uint64_t type;
+			char str[KDBUS_ALIGN8(len)];
+		} name;
+
+		struct {
+			uint64_t size;
+			uint64_t type;
+			struct kdbus_policy_access access;
+		} access;
+	} ep_update;
+	int ret;
+
+	memset(&ep_update, 0, sizeof(ep_update));
+
+	ep_update.name.size =3D KDBUS_ITEM_HEADER_SIZE + len;
+	ep_update.name.type =3D KDBUS_ITEM_NAME;
+	strncpy(ep_update.name.str, name, sizeof(ep_update.name.str) - 1);
+
+	ep_update.access.size =3D sizeof(ep_update.access);
+	ep_update.access.type =3D KDBUS_ITEM_POLICY_ACCESS;
+	ep_update.access.access.type =3D KDBUS_POLICY_ACCESS_WORLD;
+	ep_update.access.access.access =3D KDBUS_POLICY_SEE;
+
+	ep_update.cmd.size =3D sizeof(ep_update);
+
+	ret =3D kdbus_cmd_endpoint_update(fd, &ep_update.cmd);
+	if (ret < 0) {
+		kdbus_printf("error updating endpoint: %d (%m)\n", ret);
+		return ret;
+	}
+
+	return 0;
+}
+
+int kdbus_test_custom_endpoint(struct kdbus_test_env *env)
+{
+	char *ep, *tmp;
+	int ret, ep_fd;
+	struct kdbus_msg *msg;
+	struct kdbus_conn *ep_conn;
+	struct kdbus_conn *reader;
+	const char *name =3D "foo.bar.baz";
+	const char *epname =3D "foo";
+	char fake_ep[KDBUS_SYSNAME_MAX_LEN + 1] =3D {'\0'};
+
+	memset(fake_ep, 'X', sizeof(fake_ep) - 1);
+
+	/* Try to create a custom endpoint with a long name */
+	ret =3D create_endpoint(env->buspath, getuid(), fake_ep, 0);
+	ASSERT_RETURN(ret =3D=3D -ENAMETOOLONG);
+
+	/* Try to create a custom endpoint with a different uid */
+	ret =3D create_endpoint(env->buspath, getuid() + 1, "foobar", 0);
+	ASSERT_RETURN(ret =3D=3D -EINVAL);
+
+	/* create a custom endpoint, and open a connection on it */
+	ep_fd =3D create_endpoint(env->buspath, getuid(), "foo", 0);
+	ASSERT_RETURN(ep_fd >=3D 0);
+
+	tmp =3D strdup(env->buspath);
+	ASSERT_RETURN(tmp);
+
+	ret =3D asprintf(&ep, "%s/%u-%s", dirname(tmp), getuid(), epname);
+	free(tmp);
+	ASSERT_RETURN(ret >=3D 0);
+
+	/* Register a connection that listen to broadcasts */
+	reader =3D kdbus_hello(ep, 0, NULL, 0);
+	ASSERT_RETURN(reader);
+
+	/* Register to kernel signals */
+	ret =3D kdbus_add_match_id(reader, 0x1, KDBUS_ITEM_ID_ADD,
+				 KDBUS_MATCH_ID_ANY);
+	ASSERT_RETURN(ret =3D=3D 0);
+
+	ret =3D kdbus_add_match_id(reader, 0x2, KDBUS_ITEM_ID_REMOVE,
+				 KDBUS_MATCH_ID_ANY);
+	ASSERT_RETURN(ret =3D=3D 0);
+
+	ret =3D install_name_add_match(reader, name);
+	ASSERT_RETURN(ret =3D=3D 0);
+
+	/* Monitor connections are not supported on custom endpoints */
+	ep_conn =3D kdbus_hello(ep, KDBUS_HELLO_MONITOR, NULL, 0);
+	ASSERT_RETURN(!ep_conn && errno =3D=3D EOPNOTSUPP);
+
+	ep_conn =3D kdbus_hello(ep, 0, NULL, 0);
+	ASSERT_RETURN(ep_conn);
+
+	/*
+	 * Add a name add match on the endpoint connection, acquire name from
+	 * the unfiltered connection, and make sure the filtered connection
+	 * did not get the notification on the name owner change. Also, the
+	 * endpoint connection may not be able to call conn_info, neither on
+	 * the name nor on the ID.
+	 */
+	ret =3D install_name_add_match(ep_conn, name);
+	ASSERT_RETURN(ret =3D=3D 0);
+
+	ret =3D kdbus_name_acquire(env->conn, name, NULL);
+	ASSERT_RETURN(ret =3D=3D 0);
+
+	ret =3D kdbus_msg_recv(ep_conn, NULL, NULL);
+	ASSERT_RETURN(ret =3D=3D -EAGAIN);
+
+	ret =3D kdbus_conn_info(ep_conn, 0, name, 0, NULL);
+	ASSERT_RETURN(ret =3D=3D -ESRCH);
+
+	ret =3D kdbus_conn_info(ep_conn, 0, "random.crappy.name", 0, NULL);
+	ASSERT_RETURN(ret =3D=3D -ESRCH);
+
+	ret =3D kdbus_conn_info(ep_conn, env->conn->id, NULL, 0, NULL);
+	ASSERT_RETURN(ret =3D=3D -ENXIO);
+
+	ret =3D kdbus_conn_info(ep_conn, 0x0fffffffffffffffULL, NULL, 0, NULL=
);
+	ASSERT_RETURN(ret =3D=3D -ENXIO);
+
+	/* Check that the reader did not receive anything */
+	ret =3D kdbus_msg_recv(reader, NULL, NULL);
+	ASSERT_RETURN(ret =3D=3D -EAGAIN);
+
+	/*
+	 * Release the name again, update the custom endpoint policy,
+	 * and try again. This time, the connection on the custom endpoint
+	 * should have gotten it.
+	 */
+	ret =3D kdbus_name_release(env->conn, name);
+	ASSERT_RETURN(ret =3D=3D 0);
+
+	ret =3D update_endpoint(ep_fd, name);
+	ASSERT_RETURN(ret =3D=3D 0);
+
+	ret =3D kdbus_name_acquire(env->conn, name, NULL);
+	ASSERT_RETURN(ret =3D=3D 0);
+
+	ret =3D kdbus_msg_recv(ep_conn, &msg, NULL);
+	ASSERT_RETURN(ret =3D=3D 0);
+	ASSERT_RETURN(msg->items[0].type =3D=3D KDBUS_ITEM_NAME_ADD);
+	ASSERT_RETURN(msg->items[0].name_change.old_id.id =3D=3D 0);
+	ASSERT_RETURN(msg->items[0].name_change.new_id.id =3D=3D env->conn->i=
d);
+	ASSERT_RETURN(strcmp(msg->items[0].name_change.name, name) =3D=3D 0);
+	kdbus_msg_free(msg);
+
+	ret =3D kdbus_msg_recv(reader, &msg, NULL);
+	ASSERT_RETURN(ret =3D=3D 0);
+	ASSERT_RETURN(strcmp(msg->items[0].name_change.name, name) =3D=3D 0);
+
+	kdbus_msg_free(msg);
+
+	ret =3D kdbus_conn_info(ep_conn, 0, name, 0, NULL);
+	ASSERT_RETURN(ret =3D=3D 0);
+
+	ret =3D kdbus_conn_info(ep_conn, env->conn->id, NULL, 0, NULL);
+	ASSERT_RETURN(ret =3D=3D 0);
+
+	/* If we have privileges test custom endpoints */
+	ret =3D test_is_capable(CAP_SETUID, CAP_SETGID, -1);
+	ASSERT_RETURN(ret >=3D 0);
+
+	/*
+	 * All uids/gids are mapped and we have the necessary caps
+	 */
+	if (ret && all_uids_gids_are_mapped()) {
+		ret =3D unpriv_test_custom_ep(env->buspath);
+		ASSERT_RETURN(ret =3D=3D 0);
+	}
+
+	kdbus_conn_free(reader);
+	kdbus_conn_free(ep_conn);
+	close(ep_fd);
+
+	return TEST_OK;
+}
diff --git a/tools/testing/selftests/kdbus/test-fd.c b/tools/testing/se=
lftests/kdbus/test-fd.c
new file mode 100644
index 000000000000..2ae0f5ae8fd0
--- /dev/null
+++ b/tools/testing/selftests/kdbus/test-fd.c
@@ -0,0 +1,789 @@
+#include <stdio.h>
+#include <string.h>
+#include <time.h>
+#include <fcntl.h>
+#include <stdlib.h>
+#include <stdbool.h>
+#include <stddef.h>
+#include <unistd.h>
+#include <stdint.h>
+#include <errno.h>
+#include <assert.h>
+#include <sys/types.h>
+#include <sys/mman.h>
+#include <sys/socket.h>
+#include <sys/wait.h>
+
+#include "kdbus-api.h"
+#include "kdbus-test.h"
+#include "kdbus-util.h"
+#include "kdbus-enum.h"
+
+#define KDBUS_MSG_MAX_ITEMS     128
+#define KDBUS_USER_MAX_CONN	256
+
+/* maximum number of inflight fds in a target queue per user */
+#define KDBUS_CONN_MAX_FDS_PER_USER	16
+
+/* maximum number of memfd items per message */
+#define KDBUS_MSG_MAX_MEMFD_ITEMS       16
+
+static int make_msg_payload_dbus(uint64_t src_id, uint64_t dst_id,
+				 uint64_t msg_size,
+				 struct kdbus_msg **msg_dbus)
+{
+	struct kdbus_msg *msg;
+
+	msg =3D malloc(msg_size);
+	ASSERT_RETURN_VAL(msg, -ENOMEM);
+
+	memset(msg, 0, msg_size);
+	msg->size =3D msg_size;
+	msg->src_id =3D src_id;
+	msg->dst_id =3D dst_id;
+	msg->payload_type =3D KDBUS_PAYLOAD_DBUS;
+
+	*msg_dbus =3D msg;
+
+	return 0;
+}
+
+static void make_item_memfds(struct kdbus_item *item,
+			     int *memfds, size_t memfd_size)
+{
+	size_t i;
+
+	for (i =3D 0; i < memfd_size; i++) {
+		item->type =3D KDBUS_ITEM_PAYLOAD_MEMFD;
+		item->size =3D KDBUS_ITEM_HEADER_SIZE +
+			     sizeof(struct kdbus_memfd);
+		item->memfd.fd =3D memfds[i];
+		item->memfd.size =3D sizeof(uint64_t); /* const size */
+		item =3D KDBUS_ITEM_NEXT(item);
+	}
+}
+
+static void make_item_fds(struct kdbus_item *item,
+			  int *fd_array, size_t fd_size)
+{
+	size_t i;
+	item->type =3D KDBUS_ITEM_FDS;
+	item->size =3D KDBUS_ITEM_HEADER_SIZE + (sizeof(int) * fd_size);
+
+	for (i =3D 0; i < fd_size; i++)
+		item->fds[i] =3D fd_array[i];
+}
+
+static int memfd_write(const char *name, void *buf, size_t bufsize)
+{
+	ssize_t ret;
+	int memfd;
+
+	memfd =3D sys_memfd_create(name, 0);
+	ASSERT_RETURN_VAL(memfd >=3D 0, memfd);
+
+	ret =3D write(memfd, buf, bufsize);
+	ASSERT_RETURN_VAL(ret =3D=3D (ssize_t)bufsize, -EAGAIN);
+
+	ret =3D sys_memfd_seal_set(memfd);
+	ASSERT_RETURN_VAL(ret =3D=3D 0, -errno);
+
+	return memfd;
+}
+
+static int send_memfds(struct kdbus_conn *conn, uint64_t dst_id,
+		       int *memfds_array, size_t memfd_count)
+{
+	struct kdbus_cmd_send cmd =3D {};
+	struct kdbus_item *item;
+	struct kdbus_msg *msg;
+	uint64_t size;
+	int ret;
+
+	size =3D sizeof(struct kdbus_msg);
+	size +=3D memfd_count * KDBUS_ITEM_SIZE(sizeof(struct kdbus_memfd));
+
+	if (dst_id =3D=3D KDBUS_DST_ID_BROADCAST)
+		size +=3D KDBUS_ITEM_SIZE(sizeof(struct kdbus_bloom_filter)) + 64;
+
+	ret =3D make_msg_payload_dbus(conn->id, dst_id, size, &msg);
+	ASSERT_RETURN_VAL(ret =3D=3D 0, ret);
+
+	item =3D msg->items;
+
+	if (dst_id =3D=3D KDBUS_DST_ID_BROADCAST) {
+		item->type =3D KDBUS_ITEM_BLOOM_FILTER;
+		item->size =3D KDBUS_ITEM_SIZE(sizeof(struct kdbus_bloom_filter)) + =
64;
+		item =3D KDBUS_ITEM_NEXT(item);
+
+		msg->flags |=3D KDBUS_MSG_SIGNAL;
+	}
+
+	make_item_memfds(item, memfds_array, memfd_count);
+
+	cmd.size =3D sizeof(cmd);
+	cmd.msg_address =3D (uintptr_t)msg;
+
+	ret =3D kdbus_cmd_send(conn->fd, &cmd);
+	if (ret < 0) {
+		kdbus_printf("error sending message: %d (%m)\n", ret);
+		return ret;
+	}
+
+	free(msg);
+	return 0;
+}
+
+static int send_fds(struct kdbus_conn *conn, uint64_t dst_id,
+		    int *fd_array, size_t fd_count)
+{
+	struct kdbus_cmd_send cmd =3D {};
+	struct kdbus_item *item;
+	struct kdbus_msg *msg;
+	uint64_t size;
+	int ret;
+
+	size =3D sizeof(struct kdbus_msg);
+	size +=3D KDBUS_ITEM_SIZE(sizeof(int) * fd_count);
+
+	if (dst_id =3D=3D KDBUS_DST_ID_BROADCAST)
+		size +=3D KDBUS_ITEM_SIZE(sizeof(struct kdbus_bloom_filter)) + 64;
+
+	ret =3D make_msg_payload_dbus(conn->id, dst_id, size, &msg);
+	ASSERT_RETURN_VAL(ret =3D=3D 0, ret);
+
+	item =3D msg->items;
+
+	if (dst_id =3D=3D KDBUS_DST_ID_BROADCAST) {
+		item->type =3D KDBUS_ITEM_BLOOM_FILTER;
+		item->size =3D KDBUS_ITEM_SIZE(sizeof(struct kdbus_bloom_filter)) + =
64;
+		item =3D KDBUS_ITEM_NEXT(item);
+
+		msg->flags |=3D KDBUS_MSG_SIGNAL;
+	}
+
+	make_item_fds(item, fd_array, fd_count);
+
+	cmd.size =3D sizeof(cmd);
+	cmd.msg_address =3D (uintptr_t)msg;
+
+	ret =3D kdbus_cmd_send(conn->fd, &cmd);
+	if (ret < 0) {
+		kdbus_printf("error sending message: %d (%m)\n", ret);
+		return ret;
+	}
+
+	free(msg);
+	return ret;
+}
+
+static int send_fds_memfds(struct kdbus_conn *conn, uint64_t dst_id,
+			   int *fds_array, size_t fd_count,
+			   int *memfds_array, size_t memfd_count)
+{
+	struct kdbus_cmd_send cmd =3D {};
+	struct kdbus_item *item;
+	struct kdbus_msg *msg;
+	uint64_t size;
+	int ret;
+
+	size =3D sizeof(struct kdbus_msg);
+	size +=3D memfd_count * KDBUS_ITEM_SIZE(sizeof(struct kdbus_memfd));
+	size +=3D KDBUS_ITEM_SIZE(sizeof(int) * fd_count);
+
+	ret =3D make_msg_payload_dbus(conn->id, dst_id, size, &msg);
+	ASSERT_RETURN_VAL(ret =3D=3D 0, ret);
+
+	item =3D msg->items;
+
+	make_item_fds(item, fds_array, fd_count);
+	item =3D KDBUS_ITEM_NEXT(item);
+	make_item_memfds(item, memfds_array, memfd_count);
+
+	cmd.size =3D sizeof(cmd);
+	cmd.msg_address =3D (uintptr_t)msg;
+
+	ret =3D kdbus_cmd_send(conn->fd, &cmd);
+	if (ret < 0) {
+		kdbus_printf("error sending message: %d (%m)\n", ret);
+		return ret;
+	}
+
+	free(msg);
+	return ret;
+}
+
+/* Return the number of received fds */
+static unsigned int kdbus_item_get_nfds(struct kdbus_msg *msg)
+{
+	unsigned int fds =3D 0;
+	const struct kdbus_item *item;
+
+	KDBUS_ITEM_FOREACH(item, msg, items) {
+		switch (item->type) {
+		case KDBUS_ITEM_FDS: {
+			fds +=3D (item->size - KDBUS_ITEM_HEADER_SIZE) /
+				sizeof(int);
+			break;
+		}
+
+		case KDBUS_ITEM_PAYLOAD_MEMFD:
+			fds++;
+			break;
+
+		default:
+			break;
+		}
+	}
+
+	return fds;
+}
+
+static struct kdbus_msg *
+get_kdbus_msg_with_fd(struct kdbus_conn *conn_src,
+		      uint64_t dst_id, uint64_t cookie, int fd)
+{
+	int ret;
+	uint64_t size;
+	struct kdbus_item *item;
+	struct kdbus_msg *msg;
+
+	size =3D sizeof(struct kdbus_msg);
+	if (fd >=3D 0)
+		size +=3D KDBUS_ITEM_SIZE(sizeof(int));
+
+	ret =3D make_msg_payload_dbus(conn_src->id, dst_id, size, &msg);
+	ASSERT_RETURN_VAL(ret =3D=3D 0, NULL);
+
+	msg->cookie =3D cookie;
+
+	if (fd >=3D 0) {
+		item =3D msg->items;
+
+		make_item_fds(item, (int *)&fd, 1);
+	}
+
+	return msg;
+}
+
+static int kdbus_test_no_fds(struct kdbus_test_env *env,
+			     int *fds, int *memfd)
+{
+	pid_t pid;
+	int ret, status;
+	uint64_t cookie;
+	int connfd1, connfd2;
+	struct kdbus_msg *msg, *msg_sync_reply;
+	struct kdbus_cmd_hello hello;
+	struct kdbus_conn *conn_src, *conn_dst, *conn_dummy;
+	struct kdbus_cmd_send cmd =3D {};
+	struct kdbus_cmd_free cmd_free =3D {};
+
+	conn_src =3D kdbus_hello(env->buspath, 0, NULL, 0);
+	ASSERT_RETURN(conn_src);
+
+	connfd1 =3D open(env->buspath, O_RDWR|O_CLOEXEC);
+	ASSERT_RETURN(connfd1 >=3D 0);
+
+	connfd2 =3D open(env->buspath, O_RDWR|O_CLOEXEC);
+	ASSERT_RETURN(connfd2 >=3D 0);
+
+	/*
+	 * Create connections without KDBUS_HELLO_ACCEPT_FD
+	 * to test if send fd operations are blocked
+	 */
+	conn_dst =3D malloc(sizeof(*conn_dst));
+	ASSERT_RETURN(conn_dst);
+
+	conn_dummy =3D malloc(sizeof(*conn_dummy));
+	ASSERT_RETURN(conn_dummy);
+
+	memset(&hello, 0, sizeof(hello));
+	hello.size =3D sizeof(struct kdbus_cmd_hello);
+	hello.pool_size =3D POOL_SIZE;
+	hello.attach_flags_send =3D _KDBUS_ATTACH_ALL;
+
+	ret =3D kdbus_cmd_hello(connfd1, &hello);
+	ASSERT_RETURN(ret =3D=3D 0);
+
+	cmd_free.size =3D sizeof(cmd_free);
+	cmd_free.offset =3D hello.offset;
+	ret =3D kdbus_cmd_free(connfd1, &cmd_free);
+	ASSERT_RETURN(ret >=3D 0);
+
+	conn_dst->fd =3D connfd1;
+	conn_dst->id =3D hello.id;
+
+	memset(&hello, 0, sizeof(hello));
+	hello.size =3D sizeof(struct kdbus_cmd_hello);
+	hello.pool_size =3D POOL_SIZE;
+	hello.attach_flags_send =3D _KDBUS_ATTACH_ALL;
+
+	ret =3D kdbus_cmd_hello(connfd2, &hello);
+	ASSERT_RETURN(ret =3D=3D 0);
+
+	cmd_free.size =3D sizeof(cmd_free);
+	cmd_free.offset =3D hello.offset;
+	ret =3D kdbus_cmd_free(connfd2, &cmd_free);
+	ASSERT_RETURN(ret >=3D 0);
+
+	conn_dummy->fd =3D connfd2;
+	conn_dummy->id =3D hello.id;
+
+	conn_dst->buf =3D mmap(NULL, POOL_SIZE, PROT_READ,
+			     MAP_SHARED, connfd1, 0);
+	ASSERT_RETURN(conn_dst->buf !=3D MAP_FAILED);
+
+	conn_dummy->buf =3D mmap(NULL, POOL_SIZE, PROT_READ,
+			       MAP_SHARED, connfd2, 0);
+	ASSERT_RETURN(conn_dummy->buf !=3D MAP_FAILED);
+
+	/*
+	 * Send fds to connection that do not accept fd passing
+	 */
+	ret =3D send_fds(conn_src, conn_dst->id, fds, 1);
+	ASSERT_RETURN(ret =3D=3D -ECOMM);
+
+	/*
+	 * memfd are kdbus payload
+	 */
+	ret =3D send_memfds(conn_src, conn_dst->id, memfd, 1);
+	ASSERT_RETURN(ret =3D=3D 0);
+
+	ret =3D kdbus_msg_recv_poll(conn_dst, 100, NULL, NULL);
+	ASSERT_RETURN(ret =3D=3D 0);
+
+	cookie =3D time(NULL);
+
+	pid =3D fork();
+	ASSERT_RETURN_VAL(pid >=3D 0, pid);
+
+	if (pid =3D=3D 0) {
+		struct timespec now;
+
+		/*
+		 * A sync send/reply to a connection that do not
+		 * accept fds should fail if it contains an fd
+		 */
+		msg_sync_reply =3D get_kdbus_msg_with_fd(conn_dst,
+						       conn_dummy->id,
+						       cookie, fds[0]);
+		ASSERT_EXIT(msg_sync_reply);
+
+		ret =3D clock_gettime(CLOCK_MONOTONIC_COARSE, &now);
+		ASSERT_EXIT(ret =3D=3D 0);
+
+		msg_sync_reply->timeout_ns =3D now.tv_sec * 1000000000ULL +
+					     now.tv_nsec + 100000000ULL;
+		msg_sync_reply->flags =3D KDBUS_MSG_EXPECT_REPLY;
+
+		memset(&cmd, 0, sizeof(cmd));
+		cmd.size =3D sizeof(cmd);
+		cmd.msg_address =3D (uintptr_t)msg_sync_reply;
+		cmd.flags =3D KDBUS_SEND_SYNC_REPLY;
+
+		ret =3D kdbus_cmd_send(conn_dst->fd, &cmd);
+		ASSERT_EXIT(ret =3D=3D -ECOMM);
+
+		/*
+		 * Now send a normal message, but the sync reply
+		 * will fail since it contains an fd that the
+		 * original sender do not want.
+		 *
+		 * The original sender will fail with -ETIMEDOUT
+		 */
+		cookie++;
+		ret =3D kdbus_msg_send_sync(conn_dst, NULL, cookie,
+					  KDBUS_MSG_EXPECT_REPLY,
+					  5000000000ULL, 0, conn_src->id, -1);
+		ASSERT_EXIT(ret =3D=3D -EREMOTEIO);
+
+		cookie++;
+		ret =3D kdbus_msg_recv_poll(conn_dst, 100, &msg, NULL);
+		ASSERT_EXIT(ret =3D=3D 0);
+		ASSERT_EXIT(msg->cookie =3D=3D cookie);
+
+		free(msg_sync_reply);
+		kdbus_msg_free(msg);
+
+		_exit(EXIT_SUCCESS);
+	}
+
+	ret =3D kdbus_msg_recv_poll(conn_dummy, 100, NULL, NULL);
+	ASSERT_RETURN(ret =3D=3D -ETIMEDOUT);
+
+	cookie++;
+	ret =3D kdbus_msg_recv_poll(conn_src, 100, &msg, NULL);
+	ASSERT_RETURN(ret =3D=3D 0 && msg->cookie =3D=3D cookie);
+
+	kdbus_msg_free(msg);
+
+	/*
+	 * Try to reply with a kdbus connection handle, this should
+	 * fail with -EOPNOTSUPP
+	 */
+	msg_sync_reply =3D get_kdbus_msg_with_fd(conn_src,
+					       conn_dst->id,
+					       cookie, conn_dst->fd);
+	ASSERT_RETURN(msg_sync_reply);
+
+	msg_sync_reply->cookie_reply =3D cookie;
+
+	memset(&cmd, 0, sizeof(cmd));
+	cmd.size =3D sizeof(cmd);
+	cmd.msg_address =3D (uintptr_t)msg_sync_reply;
+
+	ret =3D kdbus_cmd_send(conn_src->fd, &cmd);
+	ASSERT_RETURN(ret =3D=3D -EOPNOTSUPP);
+
+	free(msg_sync_reply);
+
+	/*
+	 * Try to reply with a normal fd, this should fail even
+	 * if the response is a sync reply
+	 *
+	 * From the sender view we fail with -ECOMM
+	 */
+	msg_sync_reply =3D get_kdbus_msg_with_fd(conn_src,
+					       conn_dst->id,
+					       cookie, fds[0]);
+	ASSERT_RETURN(msg_sync_reply);
+
+	msg_sync_reply->cookie_reply =3D cookie;
+
+	memset(&cmd, 0, sizeof(cmd));
+	cmd.size =3D sizeof(cmd);
+	cmd.msg_address =3D (uintptr_t)msg_sync_reply;
+
+	ret =3D kdbus_cmd_send(conn_src->fd, &cmd);
+	ASSERT_RETURN(ret =3D=3D -ECOMM);
+
+	free(msg_sync_reply);
+
+	/*
+	 * Resend another normal message and check if the queue
+	 * is clear
+	 */
+	cookie++;
+	ret =3D kdbus_msg_send(conn_src, NULL, cookie, 0, 0, 0,
+			     conn_dst->id);
+	ASSERT_RETURN(ret =3D=3D 0);
+
+	ret =3D waitpid(pid, &status, 0);
+	ASSERT_RETURN_VAL(ret >=3D 0, ret);
+
+	kdbus_conn_free(conn_dummy);
+	kdbus_conn_free(conn_dst);
+	kdbus_conn_free(conn_src);
+
+	return (status =3D=3D EXIT_SUCCESS) ? TEST_OK : TEST_ERR;
+}
+
+static int kdbus_send_multiple_fds(struct kdbus_conn *conn_src,
+				   struct kdbus_conn *conn_dst)
+{
+	int ret, i;
+	unsigned int nfds;
+	int fds[KDBUS_CONN_MAX_FDS_PER_USER + 1];
+	int memfds[KDBUS_MSG_MAX_ITEMS + 1];
+	struct kdbus_msg *msg;
+	uint64_t dummy_value;
+
+	dummy_value =3D time(NULL);
+
+	for (i =3D 0; i < KDBUS_CONN_MAX_FDS_PER_USER + 1; i++) {
+		fds[i] =3D open("/dev/null", O_RDWR|O_CLOEXEC);
+		ASSERT_RETURN_VAL(fds[i] >=3D 0, -errno);
+	}
+
+	/* Send KDBUS_CONN_MAX_FDS_PER_USER with one more fd */
+	ret =3D send_fds(conn_src, conn_dst->id, fds,
+		       KDBUS_CONN_MAX_FDS_PER_USER + 1);
+	ASSERT_RETURN(ret =3D=3D -EMFILE);
+
+	/* Retry with the correct KDBUS_CONN_MAX_FDS_PER_USER */
+	ret =3D send_fds(conn_src, conn_dst->id, fds,
+		       KDBUS_CONN_MAX_FDS_PER_USER);
+	ASSERT_RETURN(ret =3D=3D 0);
+
+	ret =3D kdbus_msg_recv(conn_dst, &msg, NULL);
+	ASSERT_RETURN(ret =3D=3D 0);
+
+	/* Check we got the right number of fds */
+	nfds =3D kdbus_item_get_nfds(msg);
+	ASSERT_RETURN(nfds =3D=3D KDBUS_CONN_MAX_FDS_PER_USER);
+
+	kdbus_msg_free(msg);
+
+	for (i =3D 0; i < KDBUS_MSG_MAX_ITEMS + 1; i++, dummy_value++) {
+		memfds[i] =3D memfd_write("memfd-name",
+					&dummy_value,
+					sizeof(dummy_value));
+		ASSERT_RETURN_VAL(memfds[i] >=3D 0, memfds[i]);
+	}
+
+	/* Send KDBUS_MSG_MAX_ITEMS with one more memfd */
+	ret =3D send_memfds(conn_src, conn_dst->id,
+			  memfds, KDBUS_MSG_MAX_ITEMS + 1);
+	ASSERT_RETURN(ret =3D=3D -E2BIG);
+
+	ret =3D send_memfds(conn_src, conn_dst->id,
+			  memfds, KDBUS_MSG_MAX_MEMFD_ITEMS + 1);
+	ASSERT_RETURN(ret =3D=3D -E2BIG);
+
+	/* Retry with the correct KDBUS_MSG_MAX_ITEMS */
+	ret =3D send_memfds(conn_src, conn_dst->id,
+			  memfds, KDBUS_MSG_MAX_MEMFD_ITEMS);
+	ASSERT_RETURN(ret =3D=3D 0);
+
+	ret =3D kdbus_msg_recv(conn_dst, &msg, NULL);
+	ASSERT_RETURN(ret =3D=3D 0);
+
+	/* Check we got the right number of fds */
+	nfds =3D kdbus_item_get_nfds(msg);
+	ASSERT_RETURN(nfds =3D=3D KDBUS_MSG_MAX_MEMFD_ITEMS);
+
+	kdbus_msg_free(msg);
+
+
+	/*
+	 * Combine multiple KDBUS_CONN_MAX_FDS_PER_USER+1 fds and
+	 * 10 memfds
+	 */
+	ret =3D send_fds_memfds(conn_src, conn_dst->id,
+			      fds, KDBUS_CONN_MAX_FDS_PER_USER + 1,
+			      memfds, 10);
+	ASSERT_RETURN(ret =3D=3D -EMFILE);
+
+	ret =3D kdbus_msg_recv(conn_dst, NULL, NULL);
+	ASSERT_RETURN(ret =3D=3D -EAGAIN);
+
+	/*
+	 * Combine multiple KDBUS_CONN_MAX_FDS_PER_USER fds and
+	 * (128 - 1) + 1 memfds, all fds take one item, while each
+	 * memfd takes one item
+	 */
+	ret =3D send_fds_memfds(conn_src, conn_dst->id,
+			      fds, KDBUS_CONN_MAX_FDS_PER_USER,
+			      memfds, (KDBUS_MSG_MAX_ITEMS - 1) + 1);
+	ASSERT_RETURN(ret =3D=3D -E2BIG);
+
+	ret =3D send_fds_memfds(conn_src, conn_dst->id,
+			      fds, KDBUS_CONN_MAX_FDS_PER_USER,
+			      memfds, KDBUS_MSG_MAX_MEMFD_ITEMS + 1);
+	ASSERT_RETURN(ret =3D=3D -E2BIG);
+
+	ret =3D kdbus_msg_recv(conn_dst, NULL, NULL);
+	ASSERT_RETURN(ret =3D=3D -EAGAIN);
+
+	/*
+	 * Send KDBUS_CONN_MAX_FDS_PER_USER fds +
+	 * KDBUS_MSG_MAX_MEMFD_ITEMS memfds
+	 */
+	ret =3D send_fds_memfds(conn_src, conn_dst->id,
+			      fds, KDBUS_CONN_MAX_FDS_PER_USER,
+			      memfds, KDBUS_MSG_MAX_MEMFD_ITEMS);
+	ASSERT_RETURN(ret =3D=3D 0);
+
+	ret =3D kdbus_msg_recv(conn_dst, &msg, NULL);
+	ASSERT_RETURN(ret =3D=3D 0);
+
+	/* Check we got the right number of fds */
+	nfds =3D kdbus_item_get_nfds(msg);
+	ASSERT_RETURN(nfds =3D=3D KDBUS_CONN_MAX_FDS_PER_USER +
+			      KDBUS_MSG_MAX_MEMFD_ITEMS);
+
+	kdbus_msg_free(msg);
+
+
+	/*
+	 * Re-send fds + memfds, close them, but do not receive them
+	 * and try to queue more
+	 */
+	ret =3D send_fds_memfds(conn_src, conn_dst->id,
+			      fds, KDBUS_CONN_MAX_FDS_PER_USER,
+			      memfds, KDBUS_MSG_MAX_MEMFD_ITEMS);
+	ASSERT_RETURN(ret =3D=3D 0);
+
+	/* close old references and get a new ones */
+	for (i =3D 0; i < KDBUS_CONN_MAX_FDS_PER_USER + 1; i++) {
+		close(fds[i]);
+		fds[i] =3D open("/dev/null", O_RDWR|O_CLOEXEC);
+		ASSERT_RETURN_VAL(fds[i] >=3D 0, -errno);
+	}
+
+	/* should fail since we have already fds in the queue */
+	ret =3D send_fds(conn_src, conn_dst->id, fds,
+		       KDBUS_CONN_MAX_FDS_PER_USER);
+	ASSERT_RETURN(ret =3D=3D -EMFILE);
+
+	/* This should succeed */
+	ret =3D send_memfds(conn_src, conn_dst->id,
+			  memfds, KDBUS_MSG_MAX_MEMFD_ITEMS);
+	ASSERT_RETURN(ret =3D=3D 0);
+
+	ret =3D kdbus_msg_recv(conn_dst, &msg, NULL);
+	ASSERT_RETURN(ret =3D=3D 0);
+
+	nfds =3D kdbus_item_get_nfds(msg);
+	ASSERT_RETURN(nfds =3D=3D KDBUS_CONN_MAX_FDS_PER_USER +
+			      KDBUS_MSG_MAX_MEMFD_ITEMS);
+
+	kdbus_msg_free(msg);
+
+	ret =3D kdbus_msg_recv(conn_dst, &msg, NULL);
+	ASSERT_RETURN(ret =3D=3D 0);
+
+	nfds =3D kdbus_item_get_nfds(msg);
+	ASSERT_RETURN(nfds =3D=3D KDBUS_MSG_MAX_MEMFD_ITEMS);
+
+	kdbus_msg_free(msg);
+
+	ret =3D kdbus_msg_recv(conn_dst, NULL, NULL);
+	ASSERT_RETURN(ret =3D=3D -EAGAIN);
+
+	for (i =3D 0; i < KDBUS_CONN_MAX_FDS_PER_USER + 1; i++)
+		close(fds[i]);
+
+	for (i =3D 0; i < KDBUS_MSG_MAX_ITEMS + 1; i++)
+		close(memfds[i]);
+
+	return 0;
+}
+
+int kdbus_test_fd_passing(struct kdbus_test_env *env)
+{
+	struct kdbus_conn *conn_src, *conn_dst;
+	const char *str =3D "stackenblocken";
+	const struct kdbus_item *item;
+	struct kdbus_msg *msg;
+	unsigned int i;
+	uint64_t now;
+	int fds_conn[2];
+	int sock_pair[2];
+	int fds[2];
+	int memfd;
+	int ret;
+
+	now =3D (uint64_t) time(NULL);
+
+	/* create two connections */
+	conn_src =3D kdbus_hello(env->buspath, 0, NULL, 0);
+	conn_dst =3D kdbus_hello(env->buspath, 0, NULL, 0);
+	ASSERT_RETURN(conn_src && conn_dst);
+
+	fds_conn[0] =3D conn_src->fd;
+	fds_conn[1] =3D conn_dst->fd;
+
+	ret =3D socketpair(AF_UNIX, SOCK_STREAM, 0, sock_pair);
+	ASSERT_RETURN(ret =3D=3D 0);
+
+	/* Setup memfd */
+	memfd =3D memfd_write("memfd-name", &now, sizeof(now));
+	ASSERT_RETURN(memfd >=3D 0);
+
+	/* Setup pipes */
+	ret =3D pipe(fds);
+	ASSERT_RETURN(ret =3D=3D 0);
+
+	i =3D write(fds[1], str, strlen(str));
+	ASSERT_RETURN(i =3D=3D strlen(str));
+
+	/*
+	 * Try to ass the handle of a connection as message payload.
+	 * This must fail.
+	 */
+	ret =3D send_fds(conn_src, conn_dst->id, fds_conn, 2);
+	ASSERT_RETURN(ret =3D=3D -ENOTSUP);
+
+	ret =3D send_fds(conn_dst, conn_src->id, fds_conn, 2);
+	ASSERT_RETURN(ret =3D=3D -ENOTSUP);
+
+	ret =3D send_fds(conn_src, conn_dst->id, sock_pair, 2);
+	ASSERT_RETURN(ret =3D=3D -ENOTSUP);
+
+	/*
+	 * Send fds and memfds to connection that do not accept fds
+	 */
+	ret =3D kdbus_test_no_fds(env, fds, (int *)&memfd);
+	ASSERT_RETURN(ret =3D=3D 0);
+
+	/* Try to broadcast file descriptors. This must fail. */
+	ret =3D send_fds(conn_src, KDBUS_DST_ID_BROADCAST, fds, 1);
+	ASSERT_RETURN(ret =3D=3D -ENOTUNIQ);
+
+	/* Try to broadcast memfd. This must succeed. */
+	ret =3D send_memfds(conn_src, KDBUS_DST_ID_BROADCAST, (int *)&memfd, =
1);
+	ASSERT_RETURN(ret =3D=3D 0);
+
+	/* Open code this loop */
+loop_send_fds:
+
+	/*
+	 * Send the read end of the pipe and close it.
+	 */
+	ret =3D send_fds(conn_src, conn_dst->id, fds, 1);
+	ASSERT_RETURN(ret =3D=3D 0);
+	close(fds[0]);
+
+	ret =3D kdbus_msg_recv(conn_dst, &msg, NULL);
+	ASSERT_RETURN(ret =3D=3D 0);
+
+	KDBUS_ITEM_FOREACH(item, msg, items) {
+		if (item->type =3D=3D KDBUS_ITEM_FDS) {
+			char tmp[14];
+			int nfds =3D (item->size - KDBUS_ITEM_HEADER_SIZE) /
+					sizeof(int);
+			ASSERT_RETURN(nfds =3D=3D 1);
+
+			i =3D read(item->fds[0], tmp, sizeof(tmp));
+			if (i !=3D 0) {
+				ASSERT_RETURN(i =3D=3D sizeof(tmp));
+				ASSERT_RETURN(memcmp(tmp, str, sizeof(tmp)) =3D=3D 0);
+
+				/* Write EOF */
+				close(fds[1]);
+
+				/*
+				 * Resend the read end of the pipe,
+				 * the receiver still holds a reference
+				 * to it...
+				 */
+				goto loop_send_fds;
+			}
+
+			/* Got EOF */
+
+			/*
+			 * Close the last reference to the read end
+			 * of the pipe, other references are
+			 * automatically closed just after send.
+			 */
+			close(item->fds[0]);
+		}
+	}
+
+	/*
+	 * Try to resend the read end of the pipe. Must fail with
+	 * -EBADF since both the sender and receiver closed their
+	 * references to it. We assume the above since sender and
+	 * receiver are on the same process.
+	 */
+	ret =3D send_fds(conn_src, conn_dst->id, fds, 1);
+	ASSERT_RETURN(ret =3D=3D -EBADF);
+
+	/* Then we clear out received any data... */
+	kdbus_msg_free(msg);
+
+	ret =3D kdbus_send_multiple_fds(conn_src, conn_dst);
+	ASSERT_RETURN(ret =3D=3D 0);
+
+	close(sock_pair[0]);
+	close(sock_pair[1]);
+	close(memfd);
+
+	kdbus_conn_free(conn_src);
+	kdbus_conn_free(conn_dst);
+
+	return TEST_OK;
+}
diff --git a/tools/testing/selftests/kdbus/test-free.c b/tools/testing/=
selftests/kdbus/test-free.c
new file mode 100644
index 000000000000..f666da3e87cc
--- /dev/null
+++ b/tools/testing/selftests/kdbus/test-free.c
@@ -0,0 +1,64 @@
+#include <stdio.h>
+#include <string.h>
+#include <fcntl.h>
+#include <stdlib.h>
+#include <stddef.h>
+#include <unistd.h>
+#include <stdint.h>
+#include <errno.h>
+#include <assert.h>
+#include <stdbool.h>
+
+#include "kdbus-api.h"
+#include "kdbus-util.h"
+#include "kdbus-enum.h"
+#include "kdbus-test.h"
+
+static int sample_ioctl_call(struct kdbus_test_env *env)
+{
+	int ret;
+	struct kdbus_cmd_list cmd_list =3D {
+		.flags =3D KDBUS_LIST_QUEUED,
+		.size =3D sizeof(cmd_list),
+	};
+
+	ret =3D kdbus_cmd_list(env->conn->fd, &cmd_list);
+	ASSERT_RETURN(ret =3D=3D 0);
+
+	/* DON'T FREE THIS SLICE OF MEMORY! */
+
+	return TEST_OK;
+}
+
+int kdbus_test_free(struct kdbus_test_env *env)
+{
+	int ret;
+	struct kdbus_cmd_free cmd_free =3D {};
+
+	/* free an unallocated buffer */
+	cmd_free.size =3D sizeof(cmd_free);
+	cmd_free.flags =3D 0;
+	cmd_free.offset =3D 0;
+	ret =3D kdbus_cmd_free(env->conn->fd, &cmd_free);
+	ASSERT_RETURN(ret =3D=3D -ENXIO);
+
+	/* free a buffer out of the pool's bounds */
+	cmd_free.size =3D sizeof(cmd_free);
+	cmd_free.offset =3D POOL_SIZE + 1;
+	ret =3D kdbus_cmd_free(env->conn->fd, &cmd_free);
+	ASSERT_RETURN(ret =3D=3D -ENXIO);
+
+	/*
+	 * The user application is responsible for freeing the allocated
+	 * memory with the KDBUS_CMD_FREE ioctl, so let's test what happens
+	 * if we forget about it.
+	 */
+
+	ret =3D sample_ioctl_call(env);
+	ASSERT_RETURN(ret =3D=3D 0);
+
+	ret =3D sample_ioctl_call(env);
+	ASSERT_RETURN(ret =3D=3D 0);
+
+	return TEST_OK;
+}
diff --git a/tools/testing/selftests/kdbus/test-match.c b/tools/testing=
/selftests/kdbus/test-match.c
new file mode 100644
index 000000000000..2360dc1d76a4
--- /dev/null
+++ b/tools/testing/selftests/kdbus/test-match.c
@@ -0,0 +1,441 @@
+#include <stdio.h>
+#include <string.h>
+#include <fcntl.h>
+#include <stdlib.h>
+#include <stddef.h>
+#include <unistd.h>
+#include <stdint.h>
+#include <errno.h>
+#include <assert.h>
+#include <stdbool.h>
+
+#include "kdbus-api.h"
+#include "kdbus-util.h"
+#include "kdbus-enum.h"
+#include "kdbus-test.h"
+
+int kdbus_test_match_id_add(struct kdbus_test_env *env)
+{
+	struct {
+		struct kdbus_cmd_match cmd;
+		struct {
+			uint64_t size;
+			uint64_t type;
+			struct kdbus_notify_id_change chg;
+		} item;
+	} buf;
+	struct kdbus_conn *conn;
+	struct kdbus_msg *msg;
+	int ret;
+
+	memset(&buf, 0, sizeof(buf));
+
+	buf.cmd.size =3D sizeof(buf);
+	buf.cmd.cookie =3D 0xdeafbeefdeaddead;
+	buf.item.size =3D sizeof(buf.item);
+	buf.item.type =3D KDBUS_ITEM_ID_ADD;
+	buf.item.chg.id =3D KDBUS_MATCH_ID_ANY;
+
+	/* match on id add */
+	ret =3D kdbus_cmd_match_add(env->conn->fd, &buf.cmd);
+	ASSERT_RETURN(ret =3D=3D 0);
+
+	/* create 2nd connection */
+	conn =3D kdbus_hello(env->buspath, 0, NULL, 0);
+	ASSERT_RETURN(conn !=3D NULL);
+
+	/* 1st connection should have received a notification */
+	ret =3D kdbus_msg_recv(env->conn, &msg, NULL);
+	ASSERT_RETURN(ret =3D=3D 0);
+
+	ASSERT_RETURN(msg->items[0].type =3D=3D KDBUS_ITEM_ID_ADD);
+	ASSERT_RETURN(msg->items[0].id_change.id =3D=3D conn->id);
+
+	kdbus_conn_free(conn);
+
+	return TEST_OK;
+}
+
+int kdbus_test_match_id_remove(struct kdbus_test_env *env)
+{
+	struct {
+		struct kdbus_cmd_match cmd;
+		struct {
+			uint64_t size;
+			uint64_t type;
+			struct kdbus_notify_id_change chg;
+		} item;
+	} buf;
+	struct kdbus_conn *conn;
+	struct kdbus_msg *msg;
+	size_t id;
+	int ret;
+
+	/* create 2nd connection */
+	conn =3D kdbus_hello(env->buspath, 0, NULL, 0);
+	ASSERT_RETURN(conn !=3D NULL);
+	id =3D conn->id;
+
+	memset(&buf, 0, sizeof(buf));
+	buf.cmd.size =3D sizeof(buf);
+	buf.cmd.cookie =3D 0xdeafbeefdeaddead;
+	buf.item.size =3D sizeof(buf.item);
+	buf.item.type =3D KDBUS_ITEM_ID_REMOVE;
+	buf.item.chg.id =3D id;
+
+	/* register match on 2nd connection */
+	ret =3D kdbus_cmd_match_add(env->conn->fd, &buf.cmd);
+	ASSERT_RETURN(ret =3D=3D 0);
+
+	/* remove 2nd connection again */
+	kdbus_conn_free(conn);
+
+	/* 1st connection should have received a notification */
+	ret =3D kdbus_msg_recv(env->conn, &msg, NULL);
+	ASSERT_RETURN(ret =3D=3D 0);
+
+	ASSERT_RETURN(msg->items[0].type =3D=3D KDBUS_ITEM_ID_REMOVE);
+	ASSERT_RETURN(msg->items[0].id_change.id =3D=3D id);
+
+	return TEST_OK;
+}
+
+int kdbus_test_match_replace(struct kdbus_test_env *env)
+{
+	struct {
+		struct kdbus_cmd_match cmd;
+		struct {
+			uint64_t size;
+			uint64_t type;
+			struct kdbus_notify_id_change chg;
+		} item;
+	} buf;
+	struct kdbus_conn *conn;
+	struct kdbus_msg *msg;
+	size_t id;
+	int ret;
+
+	/* add a match to id_add */
+	ASSERT_RETURN(kdbus_test_match_id_add(env) =3D=3D TEST_OK);
+
+	/* do a replace of the match from id_add to id_remove */
+	memset(&buf, 0, sizeof(buf));
+
+	buf.cmd.size =3D sizeof(buf);
+	buf.cmd.cookie =3D 0xdeafbeefdeaddead;
+	buf.cmd.flags =3D KDBUS_MATCH_REPLACE;
+	buf.item.size =3D sizeof(buf.item);
+	buf.item.type =3D KDBUS_ITEM_ID_REMOVE;
+	buf.item.chg.id =3D KDBUS_MATCH_ID_ANY;
+
+	ret =3D kdbus_cmd_match_add(env->conn->fd, &buf.cmd);
+
+	/* create 2nd connection */
+	conn =3D kdbus_hello(env->buspath, 0, NULL, 0);
+	ASSERT_RETURN(conn !=3D NULL);
+	id =3D conn->id;
+
+	/* 1st connection should _not_ have received a notification */
+	ret =3D kdbus_msg_recv(env->conn, &msg, NULL);
+	ASSERT_RETURN(ret !=3D 0);
+
+	/* remove 2nd connection */
+	kdbus_conn_free(conn);
+
+	/* 1st connection should _now_ have received a notification */
+	ret =3D kdbus_msg_recv(env->conn, &msg, NULL);
+	ASSERT_RETURN(ret =3D=3D 0);
+
+	ASSERT_RETURN(msg->items[0].type =3D=3D KDBUS_ITEM_ID_REMOVE);
+	ASSERT_RETURN(msg->items[0].id_change.id =3D=3D id);
+
+	return TEST_OK;
+}
+
+int kdbus_test_match_name_add(struct kdbus_test_env *env)
+{
+	struct {
+		struct kdbus_cmd_match cmd;
+		struct {
+			uint64_t size;
+			uint64_t type;
+			struct kdbus_notify_name_change chg;
+		} item;
+		char name[64];
+	} buf;
+	struct kdbus_msg *msg;
+	char *name;
+	int ret;
+
+	name =3D "foo.bla.blaz";
+
+	/* install the match rule */
+	memset(&buf, 0, sizeof(buf));
+	buf.item.type =3D KDBUS_ITEM_NAME_ADD;
+	buf.item.chg.old_id.id =3D KDBUS_MATCH_ID_ANY;
+	buf.item.chg.new_id.id =3D KDBUS_MATCH_ID_ANY;
+	strncpy(buf.name, name, sizeof(buf.name) - 1);
+	buf.item.size =3D sizeof(buf.item) + strlen(buf.name) + 1;
+	buf.cmd.size =3D sizeof(buf.cmd) + buf.item.size;
+
+	ret =3D kdbus_cmd_match_add(env->conn->fd, &buf.cmd);
+	ASSERT_RETURN(ret =3D=3D 0);
+
+	/* acquire the name */
+	ret =3D kdbus_name_acquire(env->conn, name, NULL);
+	ASSERT_RETURN(ret =3D=3D 0);
+
+	/* we should have received a notification */
+	ret =3D kdbus_msg_recv(env->conn, &msg, NULL);
+	ASSERT_RETURN(ret =3D=3D 0);
+
+	ASSERT_RETURN(msg->items[0].type =3D=3D KDBUS_ITEM_NAME_ADD);
+	ASSERT_RETURN(msg->items[0].name_change.old_id.id =3D=3D 0);
+	ASSERT_RETURN(msg->items[0].name_change.new_id.id =3D=3D env->conn->i=
d);
+	ASSERT_RETURN(strcmp(msg->items[0].name_change.name, name) =3D=3D 0);
+
+	return TEST_OK;
+}
+
+int kdbus_test_match_name_remove(struct kdbus_test_env *env)
+{
+	struct {
+		struct kdbus_cmd_match cmd;
+		struct {
+			uint64_t size;
+			uint64_t type;
+			struct kdbus_notify_name_change chg;
+		} item;
+		char name[64];
+	} buf;
+	struct kdbus_msg *msg;
+	char *name;
+	int ret;
+
+	name =3D "foo.bla.blaz";
+
+	/* acquire the name */
+	ret =3D kdbus_name_acquire(env->conn, name, NULL);
+	ASSERT_RETURN(ret =3D=3D 0);
+
+	/* install the match rule */
+	memset(&buf, 0, sizeof(buf));
+	buf.item.type =3D KDBUS_ITEM_NAME_REMOVE;
+	buf.item.chg.old_id.id =3D KDBUS_MATCH_ID_ANY;
+	buf.item.chg.new_id.id =3D KDBUS_MATCH_ID_ANY;
+	strncpy(buf.name, name, sizeof(buf.name) - 1);
+	buf.item.size =3D sizeof(buf.item) + strlen(buf.name) + 1;
+	buf.cmd.size =3D sizeof(buf.cmd) + buf.item.size;
+
+	ret =3D kdbus_cmd_match_add(env->conn->fd, &buf.cmd);
+	ASSERT_RETURN(ret =3D=3D 0);
+
+	/* release the name again */
+	kdbus_name_release(env->conn, name);
+	ASSERT_RETURN(ret =3D=3D 0);
+
+	/* we should have received a notification */
+	ret =3D kdbus_msg_recv(env->conn, &msg, NULL);
+	ASSERT_RETURN(ret =3D=3D 0);
+
+	ASSERT_RETURN(msg->items[0].type =3D=3D KDBUS_ITEM_NAME_REMOVE);
+	ASSERT_RETURN(msg->items[0].name_change.old_id.id =3D=3D env->conn->i=
d);
+	ASSERT_RETURN(msg->items[0].name_change.new_id.id =3D=3D 0);
+	ASSERT_RETURN(strcmp(msg->items[0].name_change.name, name) =3D=3D 0);
+
+	return TEST_OK;
+}
+
+int kdbus_test_match_name_change(struct kdbus_test_env *env)
+{
+	struct {
+		struct kdbus_cmd_match cmd;
+		struct {
+			uint64_t size;
+			uint64_t type;
+			struct kdbus_notify_name_change chg;
+		} item;
+		char name[64];
+	} buf;
+	struct kdbus_conn *conn;
+	struct kdbus_msg *msg;
+	uint64_t flags;
+	char *name =3D "foo.bla.baz";
+	int ret;
+
+	/* acquire the name */
+	ret =3D kdbus_name_acquire(env->conn, name, NULL);
+	ASSERT_RETURN(ret =3D=3D 0);
+
+	/* install the match rule */
+	memset(&buf, 0, sizeof(buf));
+	buf.item.type =3D KDBUS_ITEM_NAME_CHANGE;
+	buf.item.chg.old_id.id =3D KDBUS_MATCH_ID_ANY;
+	buf.item.chg.new_id.id =3D KDBUS_MATCH_ID_ANY;
+	strncpy(buf.name, name, sizeof(buf.name) - 1);
+	buf.item.size =3D sizeof(buf.item) + strlen(buf.name) + 1;
+	buf.cmd.size =3D sizeof(buf.cmd) + buf.item.size;
+
+	ret =3D kdbus_cmd_match_add(env->conn->fd, &buf.cmd);
+	ASSERT_RETURN(ret =3D=3D 0);
+
+	/* create a 2nd connection */
+	conn =3D kdbus_hello(env->buspath, 0, NULL, 0);
+	ASSERT_RETURN(conn !=3D NULL);
+
+	/* allow the new connection to own the same name */
+	/* queue the 2nd connection as waiting owner */
+	flags =3D KDBUS_NAME_QUEUE;
+	ret =3D kdbus_name_acquire(conn, name, &flags);
+	ASSERT_RETURN(ret =3D=3D 0);
+	ASSERT_RETURN(flags & KDBUS_NAME_IN_QUEUE);
+
+	/* release name from 1st connection */
+	ret =3D kdbus_name_release(env->conn, name);
+	ASSERT_RETURN(ret =3D=3D 0);
+
+	/* we should have received a notification */
+	ret =3D kdbus_msg_recv(env->conn, &msg, NULL);
+	ASSERT_RETURN(ret =3D=3D 0);
+
+	ASSERT_RETURN(msg->items[0].type =3D=3D KDBUS_ITEM_NAME_CHANGE);
+	ASSERT_RETURN(msg->items[0].name_change.old_id.id =3D=3D env->conn->i=
d);
+	ASSERT_RETURN(msg->items[0].name_change.new_id.id =3D=3D conn->id);
+	ASSERT_RETURN(strcmp(msg->items[0].name_change.name, name) =3D=3D 0);
+
+	kdbus_conn_free(conn);
+
+	return TEST_OK;
+}
+
+static int send_bloom_filter(const struct kdbus_conn *conn,
+			     uint64_t cookie,
+			     const uint8_t *filter,
+			     size_t filter_size,
+			     uint64_t filter_generation)
+{
+	struct kdbus_cmd_send cmd =3D {};
+	struct kdbus_msg *msg;
+	struct kdbus_item *item;
+	uint64_t size;
+	int ret;
+
+	size =3D sizeof(struct kdbus_msg);
+	size +=3D KDBUS_ITEM_SIZE(sizeof(struct kdbus_bloom_filter)) + filter=
_size;
+
+	msg =3D alloca(size);
+
+	memset(msg, 0, size);
+	msg->size =3D size;
+	msg->src_id =3D conn->id;
+	msg->dst_id =3D KDBUS_DST_ID_BROADCAST;
+	msg->flags =3D KDBUS_MSG_SIGNAL;
+	msg->payload_type =3D KDBUS_PAYLOAD_DBUS;
+	msg->cookie =3D cookie;
+
+	item =3D msg->items;
+	item->type =3D KDBUS_ITEM_BLOOM_FILTER;
+	item->size =3D KDBUS_ITEM_SIZE(sizeof(struct kdbus_bloom_filter)) +
+				filter_size;
+
+	item->bloom_filter.generation =3D filter_generation;
+	memcpy(item->bloom_filter.data, filter, filter_size);
+
+	cmd.size =3D sizeof(cmd);
+	cmd.msg_address =3D (uintptr_t)msg;
+
+	ret =3D kdbus_cmd_send(conn->fd, &cmd);
+	if (ret < 0) {
+		kdbus_printf("error sending message: %d (%m)\n", ret);
+		return ret;
+	}
+
+	return 0;
+}
+
+int kdbus_test_match_bloom(struct kdbus_test_env *env)
+{
+	struct {
+		struct kdbus_cmd_match cmd;
+		struct {
+			uint64_t size;
+			uint64_t type;
+			uint8_t data_gen0[64];
+			uint8_t data_gen1[64];
+		} item;
+	} buf;
+	struct kdbus_conn *conn;
+	struct kdbus_msg *msg;
+	uint64_t cookie =3D 0xf000f00f;
+	uint8_t filter[64];
+	int ret;
+
+	/* install the match rule */
+	memset(&buf, 0, sizeof(buf));
+	buf.cmd.size =3D sizeof(buf);
+
+	buf.item.size =3D sizeof(buf.item);
+	buf.item.type =3D KDBUS_ITEM_BLOOM_MASK;
+	buf.item.data_gen0[0] =3D 0x55;
+	buf.item.data_gen0[63] =3D 0x80;
+
+	buf.item.data_gen1[1] =3D 0xaa;
+	buf.item.data_gen1[9] =3D 0x02;
+
+	ret =3D kdbus_cmd_match_add(env->conn->fd, &buf.cmd);
+	ASSERT_RETURN(ret =3D=3D 0);
+
+	/* create a 2nd connection */
+	conn =3D kdbus_hello(env->buspath, 0, NULL, 0);
+	ASSERT_RETURN(conn !=3D NULL);
+
+	/* a message with a 0'ed out filter must not reach the other peer */
+	memset(filter, 0, sizeof(filter));
+	ret =3D send_bloom_filter(conn, ++cookie, filter, sizeof(filter), 0);
+	ASSERT_RETURN(ret =3D=3D 0);
+
+	ret =3D kdbus_msg_recv(env->conn, &msg, NULL);
+	ASSERT_RETURN(ret =3D=3D -EAGAIN);
+
+	/* now set the filter to the connection's mask and expect success */
+	filter[0] =3D 0x55;
+	filter[63] =3D 0x80;
+	ret =3D send_bloom_filter(conn, ++cookie, filter, sizeof(filter), 0);
+	ASSERT_RETURN(ret =3D=3D 0);
+
+	ret =3D kdbus_msg_recv(env->conn, &msg, NULL);
+	ASSERT_RETURN(ret =3D=3D 0);
+	ASSERT_RETURN(msg->cookie =3D=3D cookie);
+
+	/* broaden the filter and try again. this should also succeed. */
+	filter[0] =3D 0xff;
+	filter[8] =3D 0xff;
+	filter[63] =3D 0xff;
+	ret =3D send_bloom_filter(conn, ++cookie, filter, sizeof(filter), 0);
+	ASSERT_RETURN(ret =3D=3D 0);
+
+	ret =3D kdbus_msg_recv(env->conn, &msg, NULL);
+	ASSERT_RETURN(ret =3D=3D 0);
+	ASSERT_RETURN(msg->cookie =3D=3D cookie);
+
+	/* the same filter must not match against bloom generation 1 */
+	ret =3D send_bloom_filter(conn, ++cookie, filter, sizeof(filter), 1);
+	ASSERT_RETURN(ret =3D=3D 0);
+
+	ret =3D kdbus_msg_recv(env->conn, &msg, NULL);
+	ASSERT_RETURN(ret =3D=3D -EAGAIN);
+
+	/* set a different filter and try again */
+	filter[1] =3D 0xaa;
+	filter[9] =3D 0x02;
+	ret =3D send_bloom_filter(conn, ++cookie, filter, sizeof(filter), 1);
+	ASSERT_RETURN(ret =3D=3D 0);
+
+	ret =3D kdbus_msg_recv(env->conn, &msg, NULL);
+	ASSERT_RETURN(ret =3D=3D 0);
+	ASSERT_RETURN(msg->cookie =3D=3D cookie);
+
+	kdbus_conn_free(conn);
+
+	return TEST_OK;
+}
diff --git a/tools/testing/selftests/kdbus/test-message.c b/tools/testi=
ng/selftests/kdbus/test-message.c
new file mode 100644
index 000000000000..f1615dafb7f1
--- /dev/null
+++ b/tools/testing/selftests/kdbus/test-message.c
@@ -0,0 +1,731 @@
+#include <stdio.h>
+#include <string.h>
+#include <fcntl.h>
+#include <stdlib.h>
+#include <stddef.h>
+#include <unistd.h>
+#include <stdint.h>
+#include <errno.h>
+#include <assert.h>
+#include <time.h>
+#include <stdbool.h>
+#include <sys/eventfd.h>
+#include <sys/types.h>
+#include <sys/wait.h>
+
+#include "kdbus-api.h"
+#include "kdbus-util.h"
+#include "kdbus-enum.h"
+#include "kdbus-test.h"
+
+/* maximum number of queued messages from the same individual user */
+#define KDBUS_CONN_MAX_MSGS			256
+
+/* maximum number of queued requests waiting for a reply */
+#define KDBUS_CONN_MAX_REQUESTS_PENDING		128
+
+/* maximum message payload size */
+#define KDBUS_MSG_MAX_PAYLOAD_VEC_SIZE		(2 * 1024UL * 1024UL)
+
+int kdbus_test_message_basic(struct kdbus_test_env *env)
+{
+	struct kdbus_conn *conn;
+	struct kdbus_conn *sender;
+	struct kdbus_msg *msg;
+	uint64_t cookie =3D 0x1234abcd5678eeff;
+	uint64_t offset;
+	int ret;
+
+	sender =3D kdbus_hello(env->buspath, 0, NULL, 0);
+	ASSERT_RETURN(sender !=3D NULL);
+
+	/* create a 2nd connection */
+	conn =3D kdbus_hello(env->buspath, 0, NULL, 0);
+	ASSERT_RETURN(conn !=3D NULL);
+
+	ret =3D kdbus_add_match_empty(conn);
+	ASSERT_RETURN(ret =3D=3D 0);
+
+	ret =3D kdbus_add_match_empty(sender);
+	ASSERT_RETURN(ret =3D=3D 0);
+
+	/* send over 1st connection */
+	ret =3D kdbus_msg_send(sender, NULL, cookie, 0, 0, 0,
+			     KDBUS_DST_ID_BROADCAST);
+	ASSERT_RETURN(ret =3D=3D 0);
+
+	/* Make sure that we do not get our own broadcasts */
+	ret =3D kdbus_msg_recv(sender, NULL, NULL);
+	ASSERT_RETURN(ret =3D=3D -EAGAIN);
+
+	/* ... and receive on the 2nd */
+	ret =3D kdbus_msg_recv_poll(conn, 100, &msg, &offset);
+	ASSERT_RETURN(ret =3D=3D 0);
+	ASSERT_RETURN(msg->cookie =3D=3D cookie);
+
+	kdbus_msg_free(msg);
+
+	/* Msgs that expect a reply must have timeout and cookie */
+	ret =3D kdbus_msg_send(sender, NULL, 0, KDBUS_MSG_EXPECT_REPLY,
+			     0, 0, conn->id);
+	ASSERT_RETURN(ret =3D=3D -EINVAL);
+
+	/* Faked replies with a valid reply cookie are rejected */
+	ret =3D kdbus_msg_send_reply(conn, time(NULL) ^ cookie, sender->id);
+	ASSERT_RETURN(ret =3D=3D -EPERM);
+
+	ret =3D kdbus_free(conn, offset);
+	ASSERT_RETURN(ret =3D=3D 0);
+
+	kdbus_conn_free(sender);
+	kdbus_conn_free(conn);
+
+	return TEST_OK;
+}
+
+static int msg_recv_prio(struct kdbus_conn *conn,
+			 int64_t requested_prio,
+			 int64_t expected_prio)
+{
+	struct kdbus_cmd_recv recv =3D {
+		.size =3D sizeof(recv),
+		.flags =3D KDBUS_RECV_USE_PRIORITY,
+		.priority =3D requested_prio,
+	};
+	struct kdbus_msg *msg;
+	int ret;
+
+	ret =3D kdbus_cmd_recv(conn->fd, &recv);
+	if (ret < 0) {
+		kdbus_printf("error receiving message: %d (%m)\n", -errno);
+		return ret;
+	}
+
+	msg =3D (struct kdbus_msg *)(conn->buf + recv.msg.offset);
+	kdbus_msg_dump(conn, msg);
+
+	if (msg->priority !=3D expected_prio) {
+		kdbus_printf("expected message prio %lld, got %lld\n",
+			     (unsigned long long) expected_prio,
+			     (unsigned long long) msg->priority);
+		return -EINVAL;
+	}
+
+	kdbus_msg_free(msg);
+	ret =3D kdbus_free(conn, recv.msg.offset);
+	if (ret < 0)
+		return ret;
+
+	return 0;
+}
+
+int kdbus_test_message_prio(struct kdbus_test_env *env)
+{
+	struct kdbus_conn *a, *b;
+	uint64_t cookie =3D 0;
+
+	a =3D kdbus_hello(env->buspath, 0, NULL, 0);
+	b =3D kdbus_hello(env->buspath, 0, NULL, 0);
+	ASSERT_RETURN(a && b);
+
+	ASSERT_RETURN(kdbus_msg_send(b, NULL, ++cookie, 0, 0,   25, a->id) =3D=
=3D 0);
+	ASSERT_RETURN(kdbus_msg_send(b, NULL, ++cookie, 0, 0, -600, a->id) =3D=
=3D 0);
+	ASSERT_RETURN(kdbus_msg_send(b, NULL, ++cookie, 0, 0,   10, a->id) =3D=
=3D 0);
+	ASSERT_RETURN(kdbus_msg_send(b, NULL, ++cookie, 0, 0,  -35, a->id) =3D=
=3D 0);
+	ASSERT_RETURN(kdbus_msg_send(b, NULL, ++cookie, 0, 0, -100, a->id) =3D=
=3D 0);
+	ASSERT_RETURN(kdbus_msg_send(b, NULL, ++cookie, 0, 0,   20, a->id) =3D=
=3D 0);
+	ASSERT_RETURN(kdbus_msg_send(b, NULL, ++cookie, 0, 0,  -15, a->id) =3D=
=3D 0);
+	ASSERT_RETURN(kdbus_msg_send(b, NULL, ++cookie, 0, 0, -800, a->id) =3D=
=3D 0);
+	ASSERT_RETURN(kdbus_msg_send(b, NULL, ++cookie, 0, 0, -150, a->id) =3D=
=3D 0);
+	ASSERT_RETURN(kdbus_msg_send(b, NULL, ++cookie, 0, 0,   10, a->id) =3D=
=3D 0);
+	ASSERT_RETURN(kdbus_msg_send(b, NULL, ++cookie, 0, 0, -800, a->id) =3D=
=3D 0);
+	ASSERT_RETURN(kdbus_msg_send(b, NULL, ++cookie, 0, 0,  -10, a->id) =3D=
=3D 0);
+
+	ASSERT_RETURN(msg_recv_prio(a, -200, -800) =3D=3D 0);
+	ASSERT_RETURN(msg_recv_prio(a, -100, -800) =3D=3D 0);
+	ASSERT_RETURN(msg_recv_prio(a, -400, -600) =3D=3D 0);
+	ASSERT_RETURN(msg_recv_prio(a, -400, -600) =3D=3D -EAGAIN);
+	ASSERT_RETURN(msg_recv_prio(a, 10, -150) =3D=3D 0);
+	ASSERT_RETURN(msg_recv_prio(a, 10, -100) =3D=3D 0);
+
+	kdbus_printf("--- get priority (all)\n");
+	ASSERT_RETURN(kdbus_msg_recv(a, NULL, NULL) =3D=3D 0);
+
+	kdbus_conn_free(a);
+	kdbus_conn_free(b);
+
+	return TEST_OK;
+}
+
+static int kdbus_test_notify_kernel_quota(struct kdbus_test_env *env)
+{
+	int ret;
+	unsigned int i;
+	struct kdbus_conn *conn;
+	struct kdbus_conn *reader;
+	struct kdbus_msg *msg =3D NULL;
+	struct kdbus_cmd_recv recv =3D { .size =3D sizeof(recv) };
+
+	reader =3D kdbus_hello(env->buspath, 0, NULL, 0);
+	ASSERT_RETURN(reader);
+
+	conn =3D kdbus_hello(env->buspath, 0, NULL, 0);
+	ASSERT_RETURN(conn);
+
+	/* Register for ID signals */
+	ret =3D kdbus_add_match_id(reader, 0x1, KDBUS_ITEM_ID_ADD,
+				 KDBUS_MATCH_ID_ANY);
+	ASSERT_RETURN(ret =3D=3D 0);
+
+	ret =3D kdbus_add_match_id(reader, 0x2, KDBUS_ITEM_ID_REMOVE,
+				 KDBUS_MATCH_ID_ANY);
+	ASSERT_RETURN(ret =3D=3D 0);
+
+	/* Each iteration two notifications: add and remove ID */
+	for (i =3D 0; i < KDBUS_CONN_MAX_MSGS / 2; i++) {
+		struct kdbus_conn *notifier;
+
+		notifier =3D kdbus_hello(env->buspath, 0, NULL, 0);
+		ASSERT_RETURN(notifier);
+
+		kdbus_conn_free(notifier);
+	}
+
+	/*
+	 * Now the reader queue is full with kernel notfications,
+	 * but as a user we still have room to push our messages.
+	 */
+	ret =3D kdbus_msg_send(conn, NULL, 0xdeadbeef, 0, 0, 0, reader->id);
+	ASSERT_RETURN(ret =3D=3D 0);
+
+	/* More ID kernel notifications that will be lost */
+	kdbus_conn_free(conn);
+
+	conn =3D kdbus_hello(env->buspath, 0, NULL, 0);
+	ASSERT_RETURN(conn);
+
+	kdbus_conn_free(conn);
+
+	/*
+	 * We lost only 3 packets since only signal msgs are
+	 * accounted. The connection ID add/remove notification
+	 */
+	ret =3D kdbus_cmd_recv(reader->fd, &recv);
+	ASSERT_RETURN(ret =3D=3D 0);
+	ASSERT_RETURN(recv.return_flags & KDBUS_RECV_RETURN_DROPPED_MSGS);
+	ASSERT_RETURN(recv.dropped_msgs =3D=3D 3);
+
+	msg =3D (struct kdbus_msg *)(reader->buf + recv.msg.offset);
+	kdbus_msg_free(msg);
+
+	/* Read our queue */
+	for (i =3D 0; i < KDBUS_CONN_MAX_MSGS - 1; i++) {
+		memset(&recv, 0, sizeof(recv));
+		recv.size =3D sizeof(recv);
+
+		ret =3D kdbus_cmd_recv(reader->fd, &recv);
+		ASSERT_RETURN(ret =3D=3D 0);
+		ASSERT_RETURN(!(recv.return_flags &
+			        KDBUS_RECV_RETURN_DROPPED_MSGS));
+
+		msg =3D (struct kdbus_msg *)(reader->buf + recv.msg.offset);
+		kdbus_msg_free(msg);
+	}
+
+	ret =3D kdbus_msg_recv(reader, NULL, NULL);
+	ASSERT_RETURN(ret =3D=3D 0);
+
+	ret =3D kdbus_msg_recv(reader, NULL, NULL);
+	ASSERT_RETURN(ret =3D=3D -EAGAIN);
+
+	kdbus_conn_free(reader);
+
+	return 0;
+}
+
+/* Return the number of message successfully sent */
+static int kdbus_fill_conn_queue(struct kdbus_conn *conn_src,
+				 uint64_t dst_id,
+				 unsigned int max_msgs)
+{
+	unsigned int i;
+	uint64_t cookie =3D 0;
+	size_t size;
+	struct kdbus_cmd_send cmd =3D {};
+	struct kdbus_msg *msg;
+	int ret;
+
+	size =3D sizeof(struct kdbus_msg);
+	msg =3D malloc(size);
+	ASSERT_RETURN_VAL(msg, -ENOMEM);
+
+	memset(msg, 0, size);
+	msg->size =3D size;
+	msg->src_id =3D conn_src->id;
+	msg->dst_id =3D dst_id;
+	msg->payload_type =3D KDBUS_PAYLOAD_DBUS;
+
+	cmd.size =3D sizeof(cmd);
+	cmd.msg_address =3D (uintptr_t)msg;
+
+	for (i =3D 0; i < max_msgs; i++) {
+		msg->cookie =3D cookie++;
+		ret =3D kdbus_cmd_send(conn_src->fd, &cmd);
+		if (ret < 0)
+			break;
+	}
+
+	free(msg);
+
+	return i;
+}
+
+static int kdbus_test_activator_quota(struct kdbus_test_env *env)
+{
+	int ret;
+	unsigned int i;
+	unsigned int activator_msgs_count =3D 0;
+	uint64_t cookie =3D time(NULL);
+	struct kdbus_conn *conn;
+	struct kdbus_conn *sender;
+	struct kdbus_conn *activator;
+	struct kdbus_msg *msg;
+	uint64_t flags =3D KDBUS_NAME_REPLACE_EXISTING;
+	struct kdbus_cmd_recv recv =3D { .size =3D sizeof(recv) };
+	struct kdbus_policy_access access =3D {
+		.type =3D KDBUS_POLICY_ACCESS_USER,
+		.id =3D geteuid(),
+		.access =3D KDBUS_POLICY_OWN,
+	};
+
+	activator =3D kdbus_hello_activator(env->buspath, "foo.test.activator=
",
+					  &access, 1);
+	ASSERT_RETURN(activator);
+
+	conn =3D kdbus_hello(env->buspath, 0, NULL, 0);
+	sender =3D kdbus_hello(env->buspath, 0, NULL, 0);
+	ASSERT_RETURN(conn || sender);
+
+	ret =3D kdbus_list(sender, KDBUS_LIST_NAMES |
+				 KDBUS_LIST_UNIQUE |
+				 KDBUS_LIST_ACTIVATORS |
+				 KDBUS_LIST_QUEUED);
+	ASSERT_RETURN(ret =3D=3D 0);
+
+	for (i =3D 0; i < KDBUS_CONN_MAX_MSGS; i++) {
+		ret =3D kdbus_msg_send(sender, "foo.test.activator",
+				     cookie++, 0, 0, 0,
+				     KDBUS_DST_ID_NAME);
+		if (ret < 0)
+			break;
+		activator_msgs_count++;
+	}
+
+	/* we must have at least sent one message */
+	ASSERT_RETURN_VAL(i > 0, -errno);
+	ASSERT_RETURN(ret =3D=3D -ENOBUFS);
+
+	/* Good, activator queue is full now */
+
+	/* ENXIO on direct send (activators can never be addressed by ID) */
+	ret =3D kdbus_msg_send(conn, NULL, cookie++, 0, 0, 0, activator->id);
+	ASSERT_RETURN(ret =3D=3D -ENXIO);
+
+	/* can't queue more */
+	ret =3D kdbus_msg_send(conn, "foo.test.activator", cookie++,
+			     0, 0, 0, KDBUS_DST_ID_NAME);
+	ASSERT_RETURN(ret =3D=3D -ENOBUFS);
+
+	/* no match installed, so the broadcast will not inc dropped_msgs */
+	ret =3D kdbus_msg_send(sender, NULL, cookie++, 0, 0, 0,
+			     KDBUS_DST_ID_BROADCAST);
+	ASSERT_RETURN(ret =3D=3D 0);
+
+	/* Check activator queue */
+	ret =3D kdbus_cmd_recv(activator->fd, &recv);
+	ASSERT_RETURN(ret =3D=3D 0);
+	ASSERT_RETURN(recv.dropped_msgs =3D=3D 0);
+
+	activator_msgs_count--;
+
+	msg =3D (struct kdbus_msg *)(activator->buf + recv.msg.offset);
+	kdbus_msg_free(msg);
+
+
+	/* Stage 1) of test check the pool memory quota */
+
+	/* Consume the connection pool memory */
+	for (i =3D 0; i < KDBUS_CONN_MAX_MSGS; i++) {
+		ret =3D kdbus_msg_send(sender, NULL,
+				     cookie++, 0, 0, 0, conn->id);
+		if (ret < 0)
+			break;
+	}
+
+	/* consume one message, so later at least one can be moved */
+	memset(&recv, 0, sizeof(recv));
+	recv.size =3D sizeof(recv);
+	ret =3D kdbus_cmd_recv(conn->fd, &recv);
+	ASSERT_RETURN(ret =3D=3D 0);
+	ASSERT_RETURN(recv.dropped_msgs =3D=3D 0);
+	msg =3D (struct kdbus_msg *)(conn->buf + recv.msg.offset);
+	kdbus_msg_free(msg);
+
+	/* Try to acquire the name now */
+	ret =3D kdbus_name_acquire(conn, "foo.test.activator", &flags);
+	ASSERT_RETURN(ret =3D=3D 0);
+
+	/* try to read messages and see if we have lost some */
+	memset(&recv, 0, sizeof(recv));
+	recv.size =3D sizeof(recv);
+	ret =3D kdbus_cmd_recv(conn->fd, &recv);
+	ASSERT_RETURN(ret =3D=3D 0);
+	ASSERT_RETURN(recv.dropped_msgs !=3D 0);
+
+	/* number of dropped msgs < received ones (at least one was moved) */
+	ASSERT_RETURN(recv.dropped_msgs < activator_msgs_count);
+
+	/* Deduct the number of dropped msgs from the activator msgs */
+	activator_msgs_count -=3D recv.dropped_msgs;
+
+	msg =3D (struct kdbus_msg *)(activator->buf + recv.msg.offset);
+	kdbus_msg_free(msg);
+
+	/*
+	 * Release the name and hand it back to activator, now
+	 * we should have 'activator_msgs_count' msgs again in
+	 * the activator queue
+	 */
+	ret =3D kdbus_name_release(conn, "foo.test.activator");
+	ASSERT_RETURN(ret =3D=3D 0);
+
+	/* make sure that we got our previous activator msgs */
+	ret =3D kdbus_msg_recv(activator, &msg, NULL);
+	ASSERT_RETURN(ret =3D=3D 0);
+	ASSERT_RETURN(msg->src_id =3D=3D sender->id);
+
+	activator_msgs_count--;
+
+	kdbus_msg_free(msg);
+
+
+	/* Stage 2) of test check max message quota */
+
+	/* Empty conn queue */
+	for (i =3D 0; i < KDBUS_CONN_MAX_MSGS; i++) {
+		ret =3D kdbus_msg_recv(conn, NULL, NULL);
+		if (ret =3D=3D -EAGAIN)
+			break;
+	}
+
+	/* fill queue with max msgs quota */
+	ret =3D kdbus_fill_conn_queue(sender, conn->id, KDBUS_CONN_MAX_MSGS);
+	ASSERT_RETURN(ret =3D=3D KDBUS_CONN_MAX_MSGS);
+
+	/* This one is lost but it is not accounted */
+	ret =3D kdbus_msg_send(sender, NULL,
+			     cookie++, 0, 0, 0, conn->id);
+	ASSERT_RETURN(ret =3D=3D -ENOBUFS);
+
+	/* Acquire the name again */
+	ret =3D kdbus_name_acquire(conn, "foo.test.activator", &flags);
+	ASSERT_RETURN(ret =3D=3D 0);
+
+	memset(&recv, 0, sizeof(recv));
+	recv.size =3D sizeof(recv);
+
+	/*
+	 * Try to read messages and make sure that we have lost all
+	 * the activator messages due to quota checks. Our queue is
+	 * already full.
+	 */
+	ret =3D kdbus_cmd_recv(conn->fd, &recv);
+	ASSERT_RETURN(ret =3D=3D 0);
+	ASSERT_RETURN(recv.dropped_msgs =3D=3D activator_msgs_count);
+
+	msg =3D (struct kdbus_msg *)(activator->buf + recv.msg.offset);
+	kdbus_msg_free(msg);
+
+	kdbus_conn_free(sender);
+	kdbus_conn_free(conn);
+	kdbus_conn_free(activator);
+
+	return 0;
+}
+
+static int kdbus_test_expected_reply_quota(struct kdbus_test_env *env)
+{
+	int ret;
+	unsigned int i, n;
+	unsigned int count;
+	uint64_t cookie =3D 0x1234abcd5678eeff;
+	struct kdbus_conn *conn;
+	struct kdbus_conn *connections[9];
+
+	conn =3D kdbus_hello(env->buspath, 0, NULL, 0);
+	ASSERT_RETURN(conn);
+
+	for (i =3D 0; i < 9; i++) {
+		connections[i] =3D kdbus_hello(env->buspath, 0, NULL, 0);
+		ASSERT_RETURN(connections[i]);
+	}
+
+	count =3D 0;
+	/* Send 16 messages to 8 different connections */
+	for (i =3D 0; i < 8; i++) {
+		for (n =3D 0; n < 16; n++) {
+			ret =3D kdbus_msg_send(conn, NULL, cookie++,
+					     KDBUS_MSG_EXPECT_REPLY,
+					     100000000ULL, 0,
+					     connections[i]->id);
+			if (ret < 0)
+				break;
+
+			count++;
+		}
+	}
+
+	/*
+	 * We should have queued at least
+	 * KDBUS_CONN_MAX_REQUESTS_PENDING method call
+	 */
+	ASSERT_RETURN(count =3D=3D KDBUS_CONN_MAX_REQUESTS_PENDING);
+
+	/*
+	 * Now try to send a message to the last connection,
+	 * if we have reached KDBUS_CONN_MAX_REQUESTS_PENDING
+	 * no further requests are allowed
+	 */
+	ret =3D kdbus_msg_send(conn, NULL, cookie++, KDBUS_MSG_EXPECT_REPLY,
+			     1000000000ULL, 0, connections[8]->id);
+	ASSERT_RETURN(ret =3D=3D -EMLINK);
+
+	for (i =3D 0; i < 9; i++)
+		kdbus_conn_free(connections[i]);
+
+	kdbus_conn_free(conn);
+
+	return 0;
+}
+
+int kdbus_test_pool_quota(struct kdbus_test_env *env)
+{
+	struct kdbus_conn *a, *b, *c;
+	struct kdbus_cmd_send cmd =3D {};
+	struct kdbus_item *item;
+	struct kdbus_msg *recv_msg;
+	struct kdbus_msg *msg;
+	uint64_t cookie =3D time(NULL);
+	uint64_t size;
+	unsigned int i;
+	char *payload;
+	int ret;
+
+	/* just a guard */
+	if (POOL_SIZE <=3D KDBUS_MSG_MAX_PAYLOAD_VEC_SIZE ||
+	    POOL_SIZE % KDBUS_MSG_MAX_PAYLOAD_VEC_SIZE !=3D 0)
+		return 0;
+
+	payload =3D calloc(KDBUS_MSG_MAX_PAYLOAD_VEC_SIZE, sizeof(char));
+	ASSERT_RETURN_VAL(payload, -ENOMEM);
+
+	a =3D kdbus_hello(env->buspath, 0, NULL, 0);
+	b =3D kdbus_hello(env->buspath, 0, NULL, 0);
+	c =3D kdbus_hello(env->buspath, 0, NULL, 0);
+	ASSERT_RETURN(a && b && c);
+
+	size =3D sizeof(struct kdbus_msg);
+	size +=3D KDBUS_ITEM_SIZE(sizeof(struct kdbus_vec));
+
+	msg =3D malloc(size);
+	ASSERT_RETURN_VAL(msg, -ENOMEM);
+
+	memset(msg, 0, size);
+	msg->size =3D size;
+	msg->src_id =3D a->id;
+	msg->dst_id =3D c->id;
+	msg->payload_type =3D KDBUS_PAYLOAD_DBUS;
+
+	item =3D msg->items;
+	item->type =3D KDBUS_ITEM_PAYLOAD_VEC;
+	item->size =3D KDBUS_ITEM_HEADER_SIZE + sizeof(struct kdbus_vec);
+	item->vec.address =3D (uintptr_t)payload;
+	item->vec.size =3D KDBUS_MSG_MAX_PAYLOAD_VEC_SIZE;
+	item =3D KDBUS_ITEM_NEXT(item);
+
+	cmd.size =3D sizeof(cmd);
+	cmd.msg_address =3D (uintptr_t)msg;
+
+	/*
+	 * Send 2097248 bytes, a user is only allowed to get 33% of half of
+	 * the free space of the pool, the already used space is
+	 * accounted as free space
+	 */
+	size +=3D KDBUS_MSG_MAX_PAYLOAD_VEC_SIZE;
+	for (i =3D size; i < (POOL_SIZE / 2 / 3); i +=3D size) {
+		msg->cookie =3D cookie++;
+
+		ret =3D kdbus_cmd_send(a->fd, &cmd);
+		ASSERT_RETURN_VAL(ret =3D=3D 0, ret);
+	}
+
+	/* Try to get more than 33% */
+	msg->cookie =3D cookie++;
+	ret =3D kdbus_cmd_send(a->fd, &cmd);
+	ASSERT_RETURN(ret =3D=3D -ENOBUFS);
+
+	/* We still can pass small messages */
+	ret =3D kdbus_msg_send(b, NULL, cookie++, 0, 0, 0, c->id);
+	ASSERT_RETURN(ret =3D=3D 0);
+
+	for (i =3D size; i < (POOL_SIZE / 2 / 3); i +=3D size) {
+		ret =3D kdbus_msg_recv(c, &recv_msg, NULL);
+		ASSERT_RETURN(ret =3D=3D 0);
+		ASSERT_RETURN(recv_msg->src_id =3D=3D a->id);
+
+		kdbus_msg_free(recv_msg);
+	}
+
+	ret =3D kdbus_msg_recv(c, &recv_msg, NULL);
+	ASSERT_RETURN(ret =3D=3D 0);
+	ASSERT_RETURN(recv_msg->src_id =3D=3D b->id);
+
+	kdbus_msg_free(recv_msg);
+
+	ret =3D kdbus_msg_recv(c, NULL, NULL);
+	ASSERT_RETURN(ret =3D=3D -EAGAIN);
+
+	free(msg);
+	free(payload);
+
+	kdbus_conn_free(c);
+	kdbus_conn_free(b);
+	kdbus_conn_free(a);
+
+	return 0;
+}
+
+int kdbus_test_message_quota(struct kdbus_test_env *env)
+{
+	struct kdbus_conn *a, *b;
+	uint64_t cookie =3D 0;
+	int ret;
+	int i;
+
+	ret =3D kdbus_test_activator_quota(env);
+	ASSERT_RETURN(ret =3D=3D 0);
+
+	ret =3D kdbus_test_notify_kernel_quota(env);
+	ASSERT_RETURN(ret =3D=3D 0);
+
+	ret =3D kdbus_test_pool_quota(env);
+	ASSERT_RETURN(ret =3D=3D 0);
+
+	ret =3D kdbus_test_expected_reply_quota(env);
+	ASSERT_RETURN(ret =3D=3D 0);
+
+	a =3D kdbus_hello(env->buspath, 0, NULL, 0);
+	b =3D kdbus_hello(env->buspath, 0, NULL, 0);
+
+	ret =3D kdbus_fill_conn_queue(b, a->id, KDBUS_CONN_MAX_MSGS);
+	ASSERT_RETURN(ret =3D=3D KDBUS_CONN_MAX_MSGS);
+
+	ret =3D kdbus_msg_send(b, NULL, ++cookie, 0, 0, 0, a->id);
+	ASSERT_RETURN(ret =3D=3D -ENOBUFS);
+
+	for (i =3D 0; i < KDBUS_CONN_MAX_MSGS; ++i) {
+		ret =3D kdbus_msg_recv(a, NULL, NULL);
+		ASSERT_RETURN(ret =3D=3D 0);
+	}
+
+	ret =3D kdbus_msg_recv(a, NULL, NULL);
+	ASSERT_RETURN(ret =3D=3D -EAGAIN);
+
+	ret =3D kdbus_fill_conn_queue(b, a->id, KDBUS_CONN_MAX_MSGS + 1);
+	ASSERT_RETURN(ret =3D=3D KDBUS_CONN_MAX_MSGS);
+
+	ret =3D kdbus_msg_send(b, NULL, ++cookie, 0, 0, 0, a->id);
+	ASSERT_RETURN(ret =3D=3D -ENOBUFS);
+
+	kdbus_conn_free(a);
+	kdbus_conn_free(b);
+
+	return TEST_OK;
+}
+
+int kdbus_test_memory_access(struct kdbus_test_env *env)
+{
+	struct kdbus_conn *a, *b;
+	struct kdbus_cmd_send cmd =3D {};
+	struct kdbus_item *item;
+	struct kdbus_msg *msg;
+	uint64_t test_addr =3D 0;
+	char line[256];
+	uint64_t size;
+	FILE *f;
+	int ret;
+
+	/*
+	 * Search in /proc/kallsyms for the address of a kernel symbol that
+	 * should always be there, regardless of the config. Use that address
+	 * in a PAYLOAD_VEC item and make sure it's inaccessible.
+	 */
+
+	f =3D fopen("/proc/kallsyms", "r");
+	if (!f)
+		return TEST_SKIP;
+
+	while (fgets(line, sizeof(line), f)) {
+		char *s =3D line;
+
+		if (!strsep(&s, " "))
+			continue;
+
+		if (!strsep(&s, " "))
+			continue;
+
+		if (!strncmp(s, "mutex_lock", 10)) {
+			test_addr =3D strtoull(line, NULL, 16);
+			break;
+		}
+	}
+
+	fclose(f);
+
+	if (!test_addr)
+		return TEST_SKIP;
+
+	a =3D kdbus_hello(env->buspath, 0, NULL, 0);
+	b =3D kdbus_hello(env->buspath, 0, NULL, 0);
+	ASSERT_RETURN(a && b);
+
+	size =3D sizeof(struct kdbus_msg);
+	size +=3D KDBUS_ITEM_SIZE(sizeof(struct kdbus_vec));
+
+	msg =3D alloca(size);
+	ASSERT_RETURN_VAL(msg, -ENOMEM);
+
+	memset(msg, 0, size);
+	msg->size =3D size;
+	msg->src_id =3D a->id;
+	msg->dst_id =3D b->id;
+	msg->payload_type =3D KDBUS_PAYLOAD_DBUS;
+
+	item =3D msg->items;
+	item->type =3D KDBUS_ITEM_PAYLOAD_VEC;
+	item->size =3D KDBUS_ITEM_HEADER_SIZE + sizeof(struct kdbus_vec);
+	item->vec.address =3D test_addr;
+	item->vec.size =3D sizeof(void*);
+	item =3D KDBUS_ITEM_NEXT(item);
+
+	cmd.size =3D sizeof(cmd);
+	cmd.msg_address =3D (uintptr_t)msg;
+
+	ret =3D kdbus_cmd_send(a->fd, &cmd);
+	ASSERT_RETURN(ret =3D=3D -EFAULT);
+
+	kdbus_conn_free(b);
+	kdbus_conn_free(a);
+
+	return 0;
+}
diff --git a/tools/testing/selftests/kdbus/test-metadata-ns.c b/tools/t=
esting/selftests/kdbus/test-metadata-ns.c
new file mode 100644
index 000000000000..2cb1d4d2a5be
--- /dev/null
+++ b/tools/testing/selftests/kdbus/test-metadata-ns.c
@@ -0,0 +1,506 @@
+/*
+ * Test metadata in new namespaces. Even if our tests can run
+ * in a namespaced setup, this test is necessary so we can inspect
+ * metadata on the same kdbusfs but between multiple namespaces
+ */
+
+#include <stdio.h>
+#include <string.h>
+#include <sched.h>
+#include <time.h>
+#include <fcntl.h>
+#include <stdlib.h>
+#include <stddef.h>
+#include <unistd.h>
+#include <stdint.h>
+#include <errno.h>
+#include <assert.h>
+#include <signal.h>
+#include <sys/wait.h>
+#include <sys/prctl.h>
+#include <sys/eventfd.h>
+#include <sys/syscall.h>
+#include <sys/capability.h>
+#include <linux/sched.h>
+
+#include "kdbus-test.h"
+#include "kdbus-util.h"
+#include "kdbus-enum.h"
+
+static const struct kdbus_creds privileged_creds =3D {};
+
+static const struct kdbus_creds unmapped_creds =3D {
+	.uid	=3D UNPRIV_UID,
+	.euid	=3D UNPRIV_UID,
+	.suid	=3D UNPRIV_UID,
+	.fsuid	=3D UNPRIV_UID,
+	.gid	=3D UNPRIV_GID,
+	.egid	=3D UNPRIV_GID,
+	.sgid	=3D UNPRIV_GID,
+	.fsgid	=3D UNPRIV_GID,
+};
+
+static const struct kdbus_pids unmapped_pids =3D {};
+
+/* Get only the first item */
+static struct kdbus_item *kdbus_get_item(struct kdbus_msg *msg,
+					 uint64_t type)
+{
+	struct kdbus_item *item;
+
+	KDBUS_ITEM_FOREACH(item, msg, items)
+		if (item->type =3D=3D type)
+			return item;
+
+	return NULL;
+}
+
+static int kdbus_match_kdbus_creds(struct kdbus_msg *msg,
+				   const struct kdbus_creds *expected_creds)
+{
+	struct kdbus_item *item;
+
+	item =3D kdbus_get_item(msg, KDBUS_ITEM_CREDS);
+	ASSERT_RETURN(item);
+
+	ASSERT_RETURN(memcmp(&item->creds, expected_creds,
+			     sizeof(struct kdbus_creds)) =3D=3D 0);
+
+	return 0;
+}
+
+static int kdbus_match_kdbus_pids(struct kdbus_msg *msg,
+				  const struct kdbus_pids *expected_pids)
+{
+	struct kdbus_item *item;
+
+	item =3D kdbus_get_item(msg, KDBUS_ITEM_PIDS);
+	ASSERT_RETURN(item);
+
+	ASSERT_RETURN(memcmp(&item->pids, expected_pids,
+			     sizeof(struct kdbus_pids)) =3D=3D 0);
+
+	return 0;
+}
+
+static int __kdbus_clone_userns_test(const char *bus,
+				     struct kdbus_conn *conn,
+				     uint64_t grandpa_pid,
+				     int signal_fd)
+{
+	int clone_ret;
+	int ret;
+	struct kdbus_msg *msg =3D NULL;
+	const struct kdbus_item *item;
+	uint64_t cookie =3D time(NULL) ^ 0xdeadbeef;
+	struct kdbus_conn *unpriv_conn =3D NULL;
+	struct kdbus_pids parent_pids =3D {
+		.pid =3D getppid(),
+		.tid =3D getppid(),
+		.ppid =3D grandpa_pid,
+	};
+
+	ret =3D drop_privileges(UNPRIV_UID, UNPRIV_GID);
+	ASSERT_EXIT(ret =3D=3D 0);
+
+	unpriv_conn =3D kdbus_hello(bus, 0, NULL, 0);
+	ASSERT_EXIT(unpriv_conn);
+
+	ret =3D kdbus_add_match_empty(unpriv_conn);
+	ASSERT_EXIT(ret =3D=3D 0);
+
+	/*
+	 * ping privileged connection from this new unprivileged
+	 * one
+	 */
+
+	ret =3D kdbus_msg_send(unpriv_conn, NULL, cookie, 0, 0,
+			     0, conn->id);
+	ASSERT_EXIT(ret =3D=3D 0);
+
+	/*
+	 * Since we just dropped privileges, the dumpable flag
+	 * was just cleared which makes the /proc/$clone_child/uid_map
+	 * to be owned by root, hence any userns uid mapping will fail
+	 * with -EPERM since the mapping will be done by uid 65534.
+	 *
+	 * To avoid this set the dumpable flag again which makes
+	 * procfs update the /proc/$clone_child/ inodes owner to 65534.
+	 *
+	 * Using this we will be able write to /proc/$clone_child/uid_map
+	 * as uid 65534 and map the uid 65534 to 0 inside the user namespace.
+	 */
+	ret =3D prctl(PR_SET_DUMPABLE, SUID_DUMP_USER);
+	ASSERT_EXIT(ret =3D=3D 0);
+
+	/* Make child privileged in its new userns and run tests */
+
+	ret =3D RUN_CLONE_CHILD(&clone_ret,
+			      SIGCHLD | CLONE_NEWUSER | CLONE_NEWPID,
+	({ 0;  /* Clone setup, nothing */ }),
+	({
+		eventfd_t event_status =3D 0;
+		struct kdbus_conn *userns_conn;
+
+		/* ping connection from the new user namespace */
+		userns_conn =3D kdbus_hello(bus, 0, NULL, 0);
+		ASSERT_EXIT(userns_conn);
+
+		ret =3D kdbus_add_match_empty(userns_conn);
+		ASSERT_EXIT(ret =3D=3D 0);
+
+		cookie++;
+		ret =3D kdbus_msg_send(userns_conn, NULL, cookie,
+				     0, 0, 0, conn->id);
+		ASSERT_EXIT(ret =3D=3D 0);
+
+		/* Parent did send */
+		ret =3D eventfd_read(signal_fd, &event_status);
+		ASSERT_RETURN(ret >=3D 0 && event_status =3D=3D 1);
+
+		/*
+		 * Receive from privileged connection
+		 */
+		kdbus_printf("Privileged =E2=86=92 unprivileged/privileged "
+			     "in its userns "
+			     "(different userns and pidns):\n");
+		ret =3D kdbus_msg_recv_poll(userns_conn, 300, &msg, NULL);
+		ASSERT_EXIT(ret =3D=3D 0);
+		ASSERT_EXIT(msg->dst_id =3D=3D userns_conn->id);
+
+		/* Different namespaces no CAPS */
+		item =3D kdbus_get_item(msg, KDBUS_ITEM_CAPS);
+		ASSERT_EXIT(item =3D=3D NULL);
+
+		/* uid/gid not mapped, so we have unpriv cached creds */
+		ret =3D kdbus_match_kdbus_creds(msg, &unmapped_creds);
+		ASSERT_EXIT(ret =3D=3D 0);
+
+		/*
+		 * Diffent pid namepsaces. This is the child pidns
+		 * so it should not see its parent kdbus_pids
+		 */
+		ret =3D kdbus_match_kdbus_pids(msg, &unmapped_pids);
+		ASSERT_EXIT(ret =3D=3D 0);
+
+		kdbus_msg_free(msg);
+
+
+		/*
+		 * Receive broadcast from privileged connection
+		 */
+		kdbus_printf("Privileged =E2=86=92 unprivileged/privileged "
+			     "in its userns "
+			     "(different userns and pidns):\n");
+		ret =3D kdbus_msg_recv_poll(userns_conn, 300, &msg, NULL);
+		ASSERT_EXIT(ret =3D=3D 0);
+		ASSERT_EXIT(msg->dst_id =3D=3D KDBUS_DST_ID_BROADCAST);
+
+		/* Different namespaces no CAPS */
+		item =3D kdbus_get_item(msg, KDBUS_ITEM_CAPS);
+		ASSERT_EXIT(item =3D=3D NULL);
+
+		/* uid/gid not mapped, so we have unpriv cached creds */
+		ret =3D kdbus_match_kdbus_creds(msg, &unmapped_creds);
+		ASSERT_EXIT(ret =3D=3D 0);
+
+		/*
+		 * Diffent pid namepsaces. This is the child pidns
+		 * so it should not see its parent kdbus_pids
+		 */
+		ret =3D kdbus_match_kdbus_pids(msg, &unmapped_pids);
+		ASSERT_EXIT(ret =3D=3D 0);
+
+		kdbus_msg_free(msg);
+
+		kdbus_conn_free(userns_conn);
+	}),
+	({
+		/* Parent setup map child uid/gid */
+		ret =3D userns_map_uid_gid(pid, "0 65534 1", "0 65534 1");
+		ASSERT_EXIT(ret =3D=3D 0);
+	}),
+	({ 0; }));
+	/* Unprivileged was not able to create user namespace */
+	if (clone_ret =3D=3D -EPERM) {
+		kdbus_printf("-- CLONE_NEWUSER TEST Failed for "
+			     "uid: %u\n -- Make sure that your kernel "
+			     "do not allow CLONE_NEWUSER for "
+			     "unprivileged users\n", UNPRIV_UID);
+		ret =3D 0;
+		goto out;
+	}
+
+	ASSERT_EXIT(ret =3D=3D 0);
+
+
+	/*
+	 * Receive from privileged connection
+	 */
+	kdbus_printf("\nPrivileged =E2=86=92 unprivileged (same namespaces):\=
n");
+	ret =3D kdbus_msg_recv_poll(unpriv_conn, 300, &msg, NULL);
+
+	ASSERT_EXIT(ret =3D=3D 0);
+	ASSERT_EXIT(msg->dst_id =3D=3D unpriv_conn->id);
+
+	/* will get the privileged creds */
+	ret =3D kdbus_match_kdbus_creds(msg, &privileged_creds);
+	ASSERT_EXIT(ret =3D=3D 0);
+
+	/* Same pidns so will get the kdbus_pids */
+	ret =3D kdbus_match_kdbus_pids(msg, &parent_pids);
+	ASSERT_RETURN(ret =3D=3D 0);
+
+	kdbus_msg_free(msg);
+
+
+	/*
+	 * Receive broadcast from privileged connection
+	 */
+	kdbus_printf("\nPrivileged =E2=86=92 unprivileged (same namespaces):\=
n");
+	ret =3D kdbus_msg_recv_poll(unpriv_conn, 300, &msg, NULL);
+
+	ASSERT_EXIT(ret =3D=3D 0);
+	ASSERT_EXIT(msg->dst_id =3D=3D KDBUS_DST_ID_BROADCAST);
+
+	/* will get the privileged creds */
+	ret =3D kdbus_match_kdbus_creds(msg, &privileged_creds);
+	ASSERT_EXIT(ret =3D=3D 0);
+
+	ret =3D kdbus_match_kdbus_pids(msg, &parent_pids);
+	ASSERT_RETURN(ret =3D=3D 0);
+
+	kdbus_msg_free(msg);
+
+out:
+	kdbus_conn_free(unpriv_conn);
+
+	return ret;
+}
+
+static int kdbus_clone_userns_test(const char *bus,
+				   struct kdbus_conn *conn)
+{
+	int ret;
+	int status;
+	int efd =3D -1;
+	pid_t pid, ppid;
+	uint64_t unpriv_conn_id =3D 0;
+	uint64_t userns_conn_id =3D 0;
+	struct kdbus_msg *msg;
+	const struct kdbus_item *item;
+	struct kdbus_pids expected_pids;
+	struct kdbus_conn *monitor =3D NULL;
+
+	kdbus_printf("STARTING TEST 'metadata-ns'.\n");
+
+	monitor =3D kdbus_hello(bus, KDBUS_HELLO_MONITOR, NULL, 0);
+	ASSERT_EXIT(monitor);
+
+	/*
+	 * parent will signal to child that is in its
+	 * userns to read its queue
+	 */
+	efd =3D eventfd(0, EFD_CLOEXEC);
+	ASSERT_RETURN_VAL(efd >=3D 0, efd);
+
+	ppid =3D getppid();
+
+	pid =3D fork();
+	ASSERT_RETURN_VAL(pid >=3D 0, -errno);
+
+	if (pid =3D=3D 0) {
+		ret =3D prctl(PR_SET_PDEATHSIG, SIGKILL);
+		ASSERT_EXIT_VAL(ret =3D=3D 0, -errno);
+
+		ret =3D __kdbus_clone_userns_test(bus, conn, ppid, efd);
+		_exit(ret);
+	}
+
+
+	/* Phase 1) privileged receives from unprivileged */
+
+	/*
+	 * Receive from the unprivileged child
+	 */
+	kdbus_printf("\nUnprivileged =E2=86=92 privileged (same namespaces):\=
n");
+	ret =3D kdbus_msg_recv_poll(conn, 300, &msg, NULL);
+	ASSERT_RETURN(ret =3D=3D 0);
+
+	unpriv_conn_id =3D msg->src_id;
+
+	/* Unprivileged user */
+	ret =3D kdbus_match_kdbus_creds(msg, &unmapped_creds);
+	ASSERT_RETURN(ret =3D=3D 0);
+
+	/* Set the expected creds_pids */
+	expected_pids =3D (struct kdbus_pids) {
+		.pid =3D pid,
+		.tid =3D pid,
+		.ppid =3D getpid(),
+	};
+	ret =3D kdbus_match_kdbus_pids(msg, &expected_pids);
+	ASSERT_RETURN(ret =3D=3D 0);
+
+	kdbus_msg_free(msg);
+
+
+	/*
+	 * Receive from the unprivileged that is in his own
+	 * userns and pidns
+	 */
+
+	kdbus_printf("\nUnprivileged/privileged in its userns =E2=86=92 privi=
leged "
+		     "(different userns and pidns)\n");
+	ret =3D kdbus_msg_recv_poll(conn, 300, &msg, NULL);
+	if (ret =3D=3D -ETIMEDOUT)
+		/* perhaps unprivileged userns is not allowed */
+		goto wait;
+
+	ASSERT_RETURN(ret =3D=3D 0);
+
+	userns_conn_id =3D msg->src_id;
+
+	/* We do not share the userns, os no KDBUS_ITEM_CAPS */
+	item =3D kdbus_get_item(msg, KDBUS_ITEM_CAPS);
+	ASSERT_RETURN(item =3D=3D NULL);
+
+	/*
+	 * Compare received items, creds must be translated into
+	 * the receiver user namespace, so the user is unprivileged
+	 */
+	ret =3D kdbus_match_kdbus_creds(msg, &unmapped_creds);
+	ASSERT_RETURN(ret =3D=3D 0);
+
+	/*
+	 * We should have the kdbus_pids since we are the parent
+	 * pidns
+	 */
+	item =3D kdbus_get_item(msg, KDBUS_ITEM_PIDS);
+	ASSERT_RETURN(item);
+
+	ASSERT_RETURN(memcmp(&item->pids, &unmapped_pids,
+			     sizeof(struct kdbus_pids)) !=3D 0);
+
+	/*
+	 * Parent pid of the unprivileged/privileged in its userns
+	 * is the unprivileged child pid that was forked here.
+	 */
+	ASSERT_RETURN((uint64_t)pid =3D=3D item->pids.ppid);
+
+	kdbus_msg_free(msg);
+
+
+	/* Phase 2) Privileged connection sends now 3 packets */
+
+	/*
+	 * Sending to unprivileged connections a unicast
+	 */
+	ret =3D kdbus_msg_send(conn, NULL, 0xdeadbeef, 0, 0,
+			     0, unpriv_conn_id);
+	ASSERT_RETURN(ret =3D=3D 0);
+
+	/* signal to child that is in its userns */
+	ret =3D eventfd_write(efd, 1);
+	ASSERT_EXIT(ret =3D=3D 0);
+
+	/*
+	 * Sending to unprivileged/privilged in its userns
+	 * connections a unicast
+	 */
+	ret =3D kdbus_msg_send(conn, NULL, 0xdeadbeef, 0, 0,
+			     0, userns_conn_id);
+	ASSERT_RETURN(ret =3D=3D 0);
+
+	/*
+	 * Sending to unprivileged connections a broadcast
+	 */
+	ret =3D kdbus_msg_send(conn, NULL, 0xdeadbeef, 0, 0,
+			     0, KDBUS_DST_ID_BROADCAST);
+	ASSERT_RETURN(ret =3D=3D 0);
+
+
+wait:
+	ret =3D waitpid(pid, &status, 0);
+	ASSERT_RETURN(ret >=3D 0);
+
+	ASSERT_RETURN(WIFEXITED(status))
+	ASSERT_RETURN(!WEXITSTATUS(status));
+
+	/* Dump monitor queue */
+	kdbus_printf("\n\nMonitor queue:\n");
+	for (;;) {
+		ret =3D kdbus_msg_recv_poll(monitor, 100, &msg, NULL);
+		if (ret < 0)
+			break;
+
+		if (msg->payload_type =3D=3D KDBUS_PAYLOAD_DBUS) {
+			/*
+			 * Parent pidns should see all the
+			 * pids
+			 */
+			item =3D kdbus_get_item(msg, KDBUS_ITEM_PIDS);
+			ASSERT_RETURN(item);
+
+			ASSERT_RETURN(item->pids.pid !=3D 0 &&
+				      item->pids.tid !=3D 0 &&
+				      item->pids.ppid !=3D 0);
+		}
+
+		kdbus_msg_free(msg);
+	}
+
+	kdbus_conn_free(monitor);
+	close(efd);
+
+	return 0;
+}
+
+int kdbus_test_metadata_ns(struct kdbus_test_env *env)
+{
+	int ret;
+	struct kdbus_conn *holder, *conn;
+	struct kdbus_policy_access policy_access =3D {
+		/* Allow world so we can inspect metadata in namespace */
+		.type =3D KDBUS_POLICY_ACCESS_WORLD,
+		.id =3D geteuid(),
+		.access =3D KDBUS_POLICY_TALK,
+	};
+
+	/*
+	 * We require user-namespaces and all uids/gids
+	 * should be mapped (we can just require the necessary ones)
+	 */
+	if (!config_user_ns_is_enabled() ||
+	    !all_uids_gids_are_mapped())
+		return TEST_SKIP;
+
+	ret =3D test_is_capable(CAP_SETUID, CAP_SETGID, CAP_SYS_ADMIN, -1);
+	ASSERT_RETURN(ret >=3D 0);
+
+	/* no enough privileges, SKIP test */
+	if (!ret)
+		return TEST_SKIP;
+
+	holder =3D kdbus_hello_registrar(env->buspath, "com.example.metadata"=
,
+				       &policy_access, 1,
+				       KDBUS_HELLO_POLICY_HOLDER);
+	ASSERT_RETURN(holder);
+
+	conn =3D kdbus_hello(env->buspath, 0, NULL, 0);
+	ASSERT_RETURN(conn);
+
+	ret =3D kdbus_add_match_empty(conn);
+	ASSERT_RETURN(ret =3D=3D 0);
+
+	ret =3D kdbus_name_acquire(conn, "com.example.metadata", NULL);
+	ASSERT_EXIT(ret >=3D 0);
+
+	ret =3D kdbus_clone_userns_test(env->buspath, conn);
+	ASSERT_RETURN(ret =3D=3D 0);
+
+	kdbus_conn_free(holder);
+	kdbus_conn_free(conn);
+
+	return TEST_OK;
+}
diff --git a/tools/testing/selftests/kdbus/test-monitor.c b/tools/testi=
ng/selftests/kdbus/test-monitor.c
new file mode 100644
index 000000000000..e00d738a3986
--- /dev/null
+++ b/tools/testing/selftests/kdbus/test-monitor.c
@@ -0,0 +1,176 @@
+#include <stdio.h>
+#include <string.h>
+#include <time.h>
+#include <fcntl.h>
+#include <stdlib.h>
+#include <stddef.h>
+#include <unistd.h>
+#include <stdint.h>
+#include <stdbool.h>
+#include <errno.h>
+#include <assert.h>
+#include <signal.h>
+#include <sys/time.h>
+#include <sys/mman.h>
+#include <sys/capability.h>
+#include <sys/wait.h>
+
+#include "kdbus-util.h"
+#include "kdbus-enum.h"
+
+#include "kdbus-util.h"
+#include "kdbus-enum.h"
+#include "kdbus-test.h"
+
+int kdbus_test_monitor(struct kdbus_test_env *env)
+{
+	struct kdbus_conn *monitor, *conn;
+	unsigned int cookie =3D 0xdeadbeef;
+	struct kdbus_msg *msg;
+	uint64_t offset =3D 0;
+	int ret;
+
+	conn =3D kdbus_hello(env->buspath, 0, NULL, 0);
+	ASSERT_RETURN(conn);
+
+	/* add matches to make sure the monitor do not trigger an item add or
+	 * remove on connect and disconnect, respectively.
+	 */
+	ret =3D kdbus_add_match_id(conn, 0x1, KDBUS_ITEM_ID_ADD,
+				 KDBUS_MATCH_ID_ANY);
+	ASSERT_RETURN(ret =3D=3D 0);
+
+	ret =3D kdbus_add_match_id(conn, 0x2, KDBUS_ITEM_ID_REMOVE,
+				 KDBUS_MATCH_ID_ANY);
+	ASSERT_RETURN(ret =3D=3D 0);
+
+	/* register a monitor */
+	monitor =3D kdbus_hello(env->buspath, KDBUS_HELLO_MONITOR, NULL, 0);
+	ASSERT_RETURN(monitor);
+
+	/* make sure we did not receive a monitor connect notification */
+	ret =3D kdbus_msg_recv(conn, &msg, &offset);
+	ASSERT_RETURN(ret =3D=3D -EAGAIN);
+
+	/* check that a monitor cannot acquire a name */
+	ret =3D kdbus_name_acquire(monitor, "foo.bar.baz", NULL);
+	ASSERT_RETURN(ret =3D=3D -EOPNOTSUPP);
+
+	ret =3D kdbus_msg_send(env->conn, NULL, cookie, 0, 0,  0, conn->id);
+	ASSERT_RETURN(ret =3D=3D 0);
+
+	/* the recipient should have gotten the message */
+	ret =3D kdbus_msg_recv(conn, &msg, &offset);
+	ASSERT_RETURN(ret =3D=3D 0);
+	ASSERT_RETURN(msg->cookie =3D=3D cookie);
+	kdbus_msg_free(msg);
+	kdbus_free(conn, offset);
+
+	/* and so should the monitor */
+	ret =3D kdbus_msg_recv(monitor, &msg, &offset);
+	ASSERT_RETURN(ret =3D=3D 0);
+	ASSERT_RETURN(msg->cookie =3D=3D cookie);
+
+	kdbus_msg_free(msg);
+	kdbus_free(monitor, offset);
+
+	/* Installing matches for monitors must fais must fail */
+	ret =3D kdbus_add_match_empty(monitor);
+	ASSERT_RETURN(ret =3D=3D -EOPNOTSUPP);
+
+	cookie++;
+	ret =3D kdbus_msg_send(env->conn, NULL, cookie, 0, 0, 0,
+			     KDBUS_DST_ID_BROADCAST);
+	ASSERT_RETURN(ret =3D=3D 0);
+
+	/* The monitor should get the message. */
+	ret =3D kdbus_msg_recv_poll(monitor, 100, &msg, &offset);
+	ASSERT_RETURN(ret =3D=3D 0);
+	ASSERT_RETURN(msg->cookie =3D=3D cookie);
+
+	kdbus_msg_free(msg);
+	kdbus_free(monitor, offset);
+
+	/*
+	 * Since we are the only monitor, update the attach flags
+	 * and tell we are not interessted in attach flags recv
+	 */
+
+	ret =3D kdbus_conn_update_attach_flags(monitor,
+					     _KDBUS_ATTACH_ALL,
+					     0);
+	ASSERT_RETURN(ret =3D=3D 0);
+
+	cookie++;
+	ret =3D kdbus_msg_send(env->conn, NULL, cookie, 0, 0, 0,
+			     KDBUS_DST_ID_BROADCAST);
+	ASSERT_RETURN(ret =3D=3D 0);
+
+	ret =3D kdbus_msg_recv_poll(monitor, 100, &msg, &offset);
+	ASSERT_RETURN(ret =3D=3D 0);
+	ASSERT_RETURN(msg->cookie =3D=3D cookie);
+
+	ret =3D kdbus_item_in_message(msg, KDBUS_ITEM_TIMESTAMP);
+	ASSERT_RETURN(ret =3D=3D 0);
+
+	kdbus_msg_free(msg);
+	kdbus_free(monitor, offset);
+
+	/*
+	 * Now we are interested in KDBUS_ITEM_TIMESTAMP and
+	 * KDBUS_ITEM_CREDS
+	 */
+	ret =3D kdbus_conn_update_attach_flags(monitor,
+					     _KDBUS_ATTACH_ALL,
+					     KDBUS_ATTACH_TIMESTAMP |
+					     KDBUS_ATTACH_CREDS);
+	ASSERT_RETURN(ret =3D=3D 0);
+
+	cookie++;
+	ret =3D kdbus_msg_send(env->conn, NULL, cookie, 0, 0, 0,
+			     KDBUS_DST_ID_BROADCAST);
+	ASSERT_RETURN(ret =3D=3D 0);
+
+	ret =3D kdbus_msg_recv_poll(monitor, 100, &msg, &offset);
+	ASSERT_RETURN(ret =3D=3D 0);
+	ASSERT_RETURN(msg->cookie =3D=3D cookie);
+
+	ret =3D kdbus_item_in_message(msg, KDBUS_ITEM_TIMESTAMP);
+	ASSERT_RETURN(ret =3D=3D 1);
+
+	ret =3D kdbus_item_in_message(msg, KDBUS_ITEM_CREDS);
+	ASSERT_RETURN(ret =3D=3D 1);
+
+	/* the KDBUS_ITEM_PID_COMM was not requested */
+	ret =3D kdbus_item_in_message(msg, KDBUS_ITEM_PID_COMM);
+	ASSERT_RETURN(ret =3D=3D 0);
+
+	kdbus_msg_free(msg);
+	kdbus_free(monitor, offset);
+
+	kdbus_conn_free(monitor);
+	/* make sure we did not receive a monitor disconnect notification */
+	ret =3D kdbus_msg_recv(conn, &msg, &offset);
+	ASSERT_RETURN(ret =3D=3D -EAGAIN);
+
+	kdbus_conn_free(conn);
+
+	/* Make sure that monitor as unprivileged is not allowed */
+	ret =3D test_is_capable(CAP_SETUID, CAP_SETGID, -1);
+	ASSERT_RETURN(ret >=3D 0);
+
+	if (ret && all_uids_gids_are_mapped()) {
+		ret =3D RUN_UNPRIVILEGED(UNPRIV_UID, UNPRIV_UID, ({
+			monitor =3D kdbus_hello(env->buspath,
+					      KDBUS_HELLO_MONITOR,
+					      NULL, 0);
+			ASSERT_EXIT(!monitor && errno =3D=3D EPERM);
+
+			_exit(EXIT_SUCCESS);
+		}),
+		({ 0; }));
+		ASSERT_RETURN(ret =3D=3D 0);
+	}
+
+	return TEST_OK;
+}
diff --git a/tools/testing/selftests/kdbus/test-names.c b/tools/testing=
/selftests/kdbus/test-names.c
new file mode 100644
index 000000000000..66ebb47370eb
--- /dev/null
+++ b/tools/testing/selftests/kdbus/test-names.c
@@ -0,0 +1,194 @@
+#include <stdio.h>
+#include <string.h>
+#include <time.h>
+#include <fcntl.h>
+#include <stdlib.h>
+#include <stddef.h>
+#include <unistd.h>
+#include <stdint.h>
+#include <errno.h>
+#include <assert.h>
+#include <limits.h>
+#include <getopt.h>
+#include <stdbool.h>
+
+#include "kdbus-api.h"
+#include "kdbus-util.h"
+#include "kdbus-enum.h"
+#include "kdbus-test.h"
+
+static int conn_is_name_owner(const struct kdbus_conn *conn,
+			      const char *needle)
+{
+	struct kdbus_cmd_list cmd_list =3D { .size =3D sizeof(cmd_list) };
+	struct kdbus_info *name, *list;
+	bool found =3D false;
+	int ret;
+
+	cmd_list.flags =3D KDBUS_LIST_NAMES;
+
+	ret =3D kdbus_cmd_list(conn->fd, &cmd_list);
+	ASSERT_RETURN(ret =3D=3D 0);
+
+	list =3D (struct kdbus_info *)(conn->buf + cmd_list.offset);
+	KDBUS_FOREACH(name, list, cmd_list.list_size) {
+		struct kdbus_item *item;
+		const char *n =3D NULL;
+
+		KDBUS_ITEM_FOREACH(item, name, items)
+			if (item->type =3D=3D KDBUS_ITEM_OWNED_NAME)
+				n =3D item->name.name;
+
+		if (name->id =3D=3D conn->id &&
+		    n && strcmp(needle, n) =3D=3D 0) {
+			found =3D true;
+			break;
+		}
+	}
+
+	ret =3D kdbus_free(conn, cmd_list.offset);
+	ASSERT_RETURN(ret =3D=3D 0);
+
+	return found ? 0 : -1;
+}
+
+int kdbus_test_name_basic(struct kdbus_test_env *env)
+{
+	struct kdbus_conn *conn;
+	char *name, *dot_name, *invalid_name, *wildcard_name;
+	int ret;
+
+	name =3D "foo.bla.blaz";
+	dot_name =3D ".bla.blaz";
+	invalid_name =3D "foo";
+	wildcard_name =3D "foo.bla.bl.*";
+
+	/* create a 2nd connection */
+	conn =3D kdbus_hello(env->buspath, 0, NULL, 0);
+	ASSERT_RETURN(conn !=3D NULL);
+
+	/* acquire name "foo.bar.xxx" name */
+	ret =3D kdbus_name_acquire(conn, "foo.bar.xxx", NULL);
+	ASSERT_RETURN(ret =3D=3D 0);
+
+	/* Name is not valid, must fail */
+	ret =3D kdbus_name_acquire(env->conn, dot_name, NULL);
+	ASSERT_RETURN(ret =3D=3D -EINVAL);
+
+	ret =3D kdbus_name_acquire(env->conn, invalid_name, NULL);
+	ASSERT_RETURN(ret =3D=3D -EINVAL);
+
+	ret =3D kdbus_name_acquire(env->conn, wildcard_name, NULL);
+	ASSERT_RETURN(ret =3D=3D -EINVAL);
+
+	/* check that we can acquire a name */
+	ret =3D kdbus_name_acquire(env->conn, name, NULL);
+	ASSERT_RETURN(ret =3D=3D 0);
+
+	ret =3D conn_is_name_owner(env->conn, name);
+	ASSERT_RETURN(ret =3D=3D 0);
+
+	/* ... and release it again */
+	ret =3D kdbus_name_release(env->conn, name);
+	ASSERT_RETURN(ret =3D=3D 0);
+
+	ret =3D conn_is_name_owner(env->conn, name);
+	ASSERT_RETURN(ret !=3D 0);
+
+	/* check that we can't release it again */
+	ret =3D kdbus_name_release(env->conn, name);
+	ASSERT_RETURN(ret =3D=3D -ESRCH);
+
+	/* check that we can't release a name that we don't own */
+	ret =3D kdbus_name_release(env->conn, "foo.bar.xxx");
+	ASSERT_RETURN(ret =3D=3D -EADDRINUSE);
+
+	/* Name is not valid, must fail */
+	ret =3D kdbus_name_release(env->conn, dot_name);
+	ASSERT_RETURN(ret =3D=3D -ESRCH);
+
+	ret =3D kdbus_name_release(env->conn, invalid_name);
+	ASSERT_RETURN(ret =3D=3D -ESRCH);
+
+	ret =3D kdbus_name_release(env->conn, wildcard_name);
+	ASSERT_RETURN(ret =3D=3D -ESRCH);
+
+	kdbus_conn_free(conn);
+
+	return TEST_OK;
+}
+
+int kdbus_test_name_conflict(struct kdbus_test_env *env)
+{
+	struct kdbus_conn *conn;
+	char *name;
+	int ret;
+
+	name =3D "foo.bla.blaz";
+
+	/* create a 2nd connection */
+	conn =3D kdbus_hello(env->buspath, 0, NULL, 0);
+	ASSERT_RETURN(conn !=3D NULL);
+
+	/* allow the new connection to own the same name */
+	/* acquire name from the 1st connection */
+	ret =3D kdbus_name_acquire(env->conn, name, NULL);
+	ASSERT_RETURN(ret =3D=3D 0);
+
+	ret =3D conn_is_name_owner(env->conn, name);
+	ASSERT_RETURN(ret =3D=3D 0);
+
+	/* check that we can't acquire it again from the 1st connection */
+	ret =3D kdbus_name_acquire(env->conn, name, NULL);
+	ASSERT_RETURN(ret =3D=3D -EALREADY);
+
+	/* check that we also can't acquire it again from the 2nd connection =
*/
+	ret =3D kdbus_name_acquire(conn, name, NULL);
+	ASSERT_RETURN(ret =3D=3D -EEXIST);
+
+	kdbus_conn_free(conn);
+
+	return TEST_OK;
+}
+
+int kdbus_test_name_queue(struct kdbus_test_env *env)
+{
+	struct kdbus_conn *conn;
+	const char *name;
+	uint64_t flags;
+	int ret;
+
+	name =3D "foo.bla.blaz";
+
+	flags =3D KDBUS_NAME_ALLOW_REPLACEMENT;
+
+	/* create a 2nd connection */
+	conn =3D kdbus_hello(env->buspath, 0, NULL, 0);
+	ASSERT_RETURN(conn !=3D NULL);
+
+	/* allow the new connection to own the same name */
+	/* acquire name from the 1st connection */
+	ret =3D kdbus_name_acquire(env->conn, name, &flags);
+	ASSERT_RETURN(ret =3D=3D 0);
+
+	ret =3D conn_is_name_owner(env->conn, name);
+	ASSERT_RETURN(ret =3D=3D 0);
+
+	/* queue the 2nd connection as waiting owner */
+	flags =3D KDBUS_NAME_QUEUE;
+	ret =3D kdbus_name_acquire(conn, name, &flags);
+	ASSERT_RETURN(ret =3D=3D 0);
+	ASSERT_RETURN(flags & KDBUS_NAME_IN_QUEUE);
+
+	/* release name from 1st connection */
+	ret =3D kdbus_name_release(env->conn, name);
+	ASSERT_RETURN(ret =3D=3D 0);
+
+	/* now the name should be owned by the 2nd connection */
+	ret =3D conn_is_name_owner(conn, name);
+	ASSERT_RETURN(ret =3D=3D 0);
+
+	kdbus_conn_free(conn);
+
+	return TEST_OK;
+}
diff --git a/tools/testing/selftests/kdbus/test-policy-ns.c b/tools/tes=
ting/selftests/kdbus/test-policy-ns.c
new file mode 100644
index 000000000000..3437012f90af
--- /dev/null
+++ b/tools/testing/selftests/kdbus/test-policy-ns.c
@@ -0,0 +1,632 @@
+/*
+ * Test metadata and policies in new namespaces. Even if our tests
+ * can run in a namespaced setup, this test is necessary so we can
+ * inspect policies on the same kdbusfs but between multiple
+ * namespaces.
+ *
+ * Copyright (C) 2014-2015 Djalal Harouni
+ *
+ * kdbus is free software; you can redistribute it and/or modify it un=
der
+ * the terms of the GNU Lesser General Public License as published by =
the
+ * Free Software Foundation; either version 2.1 of the License, or (at
+ * your option) any later version.
+ */
+
+#include <stdio.h>
+#include <string.h>
+#include <fcntl.h>
+#include <pthread.h>
+#include <sched.h>
+#include <stdlib.h>
+#include <stddef.h>
+#include <stdint.h>
+#include <stdbool.h>
+#include <unistd.h>
+#include <errno.h>
+#include <signal.h>
+#include <sys/wait.h>
+#include <sys/prctl.h>
+#include <sys/eventfd.h>
+#include <sys/syscall.h>
+#include <sys/capability.h>
+#include <linux/sched.h>
+
+#include "kdbus-test.h"
+#include "kdbus-util.h"
+#include "kdbus-enum.h"
+
+#define MAX_CONN	64
+#define POLICY_NAME	"foo.test.policy-test"
+
+#define KDBUS_CONN_MAX_MSGS_PER_USER            16
+
+/**
+ * Note: this test can be used to inspect policy_db->talk_access_hash
+ *
+ * The purpose of these tests:
+ * 1) Check KDBUS_POLICY_TALK
+ * 2) Check the cache state: kdbus_policy_db->talk_access_hash
+ * Should be extended
+ */
+
+/**
+ * Check a list of connections against conn_db[0]
+ * conn_db[0] will own the name "foo.test.policy-test" and the
+ * policy holder connection for this name will update the policy
+ * entries, so different use cases can be tested.
+ */
+static struct kdbus_conn **conn_db;
+
+static void *kdbus_recv_echo(void *ptr)
+{
+	int ret;
+	struct kdbus_conn *conn =3D ptr;
+
+	ret =3D kdbus_msg_recv_poll(conn, 200, NULL, NULL);
+
+	return (void *)(long)ret;
+}
+
+/* Trigger kdbus_policy_set() */
+static int kdbus_set_policy_talk(struct kdbus_conn *conn,
+				 const char *name,
+				 uid_t id, unsigned int type)
+{
+	int ret;
+	struct kdbus_policy_access access =3D {
+		.type =3D type,
+		.id =3D id,
+		.access =3D KDBUS_POLICY_TALK,
+	};
+
+	ret =3D kdbus_conn_update_policy(conn, name, &access, 1);
+	ASSERT_RETURN(ret =3D=3D 0);
+
+	return TEST_OK;
+}
+
+/* return TEST_OK or TEST_ERR on failure */
+static int kdbus_register_same_activator(char *bus, const char *name,
+					 struct kdbus_conn **c)
+{
+	int ret;
+	struct kdbus_conn *activator;
+
+	activator =3D kdbus_hello_activator(bus, name, NULL, 0);
+	if (activator) {
+		*c =3D activator;
+		fprintf(stderr, "--- error was able to register name twice '%s'.\n",
+			name);
+		return TEST_ERR;
+	}
+
+	ret =3D -errno;
+	/* -EEXIST means test succeeded */
+	if (ret =3D=3D -EEXIST)
+		return TEST_OK;
+
+	return TEST_ERR;
+}
+
+/* return TEST_OK or TEST_ERR on failure */
+static int kdbus_register_policy_holder(char *bus, const char *name,
+					struct kdbus_conn **conn)
+{
+	struct kdbus_conn *c;
+	struct kdbus_policy_access access[2];
+
+	access[0].type =3D KDBUS_POLICY_ACCESS_USER;
+	access[0].access =3D KDBUS_POLICY_OWN;
+	access[0].id =3D geteuid();
+
+	access[1].type =3D KDBUS_POLICY_ACCESS_WORLD;
+	access[1].access =3D KDBUS_POLICY_TALK;
+	access[1].id =3D geteuid();
+
+	c =3D kdbus_hello_registrar(bus, name, access, 2,
+				  KDBUS_HELLO_POLICY_HOLDER);
+	ASSERT_RETURN(c);
+
+	*conn =3D c;
+
+	return TEST_OK;
+}
+
+/**
+ * Create new threads for receiving from multiple senders,
+ * The 'conn_db' will be populated by newly created connections.
+ * Caller should free all allocated connections.
+ *
+ * return 0 on success, negative errno on failure.
+ */
+static int kdbus_recv_in_threads(const char *bus, const char *name,
+				 struct kdbus_conn **conn_db)
+{
+	int ret;
+	bool pool_full =3D false;
+	unsigned int sent_packets =3D 0;
+	unsigned int lost_packets =3D 0;
+	unsigned int i, tid;
+	unsigned long dst_id;
+	unsigned long cookie =3D 1;
+	unsigned int thread_nr =3D MAX_CONN - 1;
+	pthread_t thread_id[MAX_CONN - 1] =3D {'\0'};
+
+	dst_id =3D name ? KDBUS_DST_ID_NAME : conn_db[0]->id;
+
+	for (tid =3D 0, i =3D 1; tid < thread_nr; tid++, i++) {
+		ret =3D pthread_create(&thread_id[tid], NULL,
+				     kdbus_recv_echo, (void *)conn_db[0]);
+		if (ret < 0) {
+			ret =3D -errno;
+			kdbus_printf("error pthread_create: %d (%m)\n",
+				      ret);
+			break;
+		}
+
+		/* just free before re-using */
+		kdbus_conn_free(conn_db[i]);
+		conn_db[i] =3D NULL;
+
+		/* We need to create connections here */
+		conn_db[i] =3D kdbus_hello(bus, 0, NULL, 0);
+		if (!conn_db[i]) {
+			ret =3D -errno;
+			break;
+		}
+
+		ret =3D kdbus_add_match_empty(conn_db[i]);
+		if (ret < 0)
+			break;
+
+		ret =3D kdbus_msg_send(conn_db[i], name, cookie++,
+				     0, 0, 0, dst_id);
+		if (ret < 0) {
+			/*
+			 * Receivers are not reading their messages,
+			 * not scheduled ?!
+			 *
+			 * So set the pool full here, perhaps the
+			 * connection pool or queue was full, later
+			 * recheck receivers errors
+			 */
+			if (ret =3D=3D -ENOBUFS || ret =3D=3D -EXFULL)
+				pool_full =3D true;
+			break;
+		}
+
+		sent_packets++;
+	}
+
+	for (tid =3D 0; tid < thread_nr; tid++) {
+		int thread_ret =3D 0;
+
+		if (thread_id[tid]) {
+			pthread_join(thread_id[tid], (void *)&thread_ret);
+			if (thread_ret < 0) {
+				/* Update only if send did not fail */
+				if (ret =3D=3D 0)
+					ret =3D thread_ret;
+
+				lost_packets++;
+			}
+		}
+	}
+
+	/*
+	 * When sending if we did fail with -ENOBUFS or -EXFULL
+	 * then we should have set lost_packet and we should at
+	 * least have sent_packets set to KDBUS_CONN_MAX_MSGS_PER_USER
+	 */
+	if (pool_full) {
+		ASSERT_RETURN(lost_packets > 0);
+
+		/*
+		 * We should at least send KDBUS_CONN_MAX_MSGS_PER_USER
+		 *
+		 * For every send operation we create a thread to
+		 * recv the packet, so we keep the queue clean
+		 */
+		ASSERT_RETURN(sent_packets >=3D KDBUS_CONN_MAX_MSGS_PER_USER);
+
+		/*
+		 * Set ret to zero since we only failed due to
+		 * the receiving threads that have not been
+		 * scheduled
+		 */
+		ret =3D 0;
+	}
+
+	return ret;
+}
+
+/* Return: TEST_OK or TEST_ERR on failure */
+static int kdbus_normal_test(const char *bus, const char *name,
+			     struct kdbus_conn **conn_db)
+{
+	int ret;
+
+	ret =3D kdbus_recv_in_threads(bus, name, conn_db);
+	ASSERT_RETURN(ret >=3D 0);
+
+	return TEST_OK;
+}
+
+static int kdbus_fork_test_by_id(const char *bus,
+				 struct kdbus_conn **conn_db,
+				 int parent_status, int child_status)
+{
+	int ret;
+	pid_t pid;
+	uint64_t cookie =3D 0x9876ecba;
+	struct kdbus_msg *msg =3D NULL;
+	uint64_t offset =3D 0;
+	int status =3D 0;
+
+	/*
+	 * If the child_status is not EXIT_SUCCESS, then we expect
+	 * that sending from the child will fail, thus receiving
+	 * from parent must error with -ETIMEDOUT, and vice versa.
+	 */
+	bool parent_timedout =3D !!child_status;
+	bool child_timedout =3D !!parent_status;
+
+	pid =3D fork();
+	ASSERT_RETURN_VAL(pid >=3D 0, pid);
+
+	if (pid =3D=3D 0) {
+		struct kdbus_conn *conn_src;
+
+		ret =3D prctl(PR_SET_PDEATHSIG, SIGKILL);
+		ASSERT_EXIT(ret =3D=3D 0);
+
+		ret =3D drop_privileges(65534, 65534);
+		ASSERT_EXIT(ret =3D=3D 0);
+
+		conn_src =3D kdbus_hello(bus, 0, NULL, 0);
+		ASSERT_EXIT(conn_src);
+
+		ret =3D kdbus_add_match_empty(conn_src);
+		ASSERT_EXIT(ret =3D=3D 0);
+
+		/*
+		 * child_status is always checked against send
+		 * operations, in case it fails always return
+		 * EXIT_FAILURE.
+		 */
+		ret =3D kdbus_msg_send(conn_src, NULL, cookie,
+				     0, 0, 0, conn_db[0]->id);
+		ASSERT_EXIT(ret =3D=3D child_status);
+
+		ret =3D kdbus_msg_recv_poll(conn_src, 100, NULL, NULL);
+
+		kdbus_conn_free(conn_src);
+
+		/*
+		 * Child kdbus_msg_recv_poll() should timeout since
+		 * the parent_status was set to a non EXIT_SUCCESS
+		 * value.
+		 */
+		if (child_timedout)
+			_exit(ret =3D=3D -ETIMEDOUT ? EXIT_SUCCESS : EXIT_FAILURE);
+
+		_exit(ret =3D=3D 0 ? EXIT_SUCCESS : EXIT_FAILURE);
+	}
+
+	ret =3D kdbus_msg_recv_poll(conn_db[0], 100, &msg, &offset);
+	/*
+	 * If parent_timedout is set then this should fail with
+	 * -ETIMEDOUT since the child_status was set to a non
+	 * EXIT_SUCCESS value. Otherwise, assume
+	 * that kdbus_msg_recv_poll() has succeeded.
+	 */
+	if (parent_timedout) {
+		ASSERT_RETURN_VAL(ret =3D=3D -ETIMEDOUT, TEST_ERR);
+
+		/* timedout no need to continue, we don't have the
+		 * child connection ID, so just terminate. */
+		goto out;
+	} else {
+		ASSERT_RETURN_VAL(ret =3D=3D 0, ret);
+	}
+
+	ret =3D kdbus_msg_send(conn_db[0], NULL, ++cookie,
+			     0, 0, 0, msg->src_id);
+	/*
+	 * parent_status is checked against send operations,
+	 * on failures always return TEST_ERR.
+	 */
+	ASSERT_RETURN_VAL(ret =3D=3D parent_status, TEST_ERR);
+
+	kdbus_msg_free(msg);
+	kdbus_free(conn_db[0], offset);
+
+out:
+	ret =3D waitpid(pid, &status, 0);
+	ASSERT_RETURN_VAL(ret >=3D 0, ret);
+
+	return (status =3D=3D EXIT_SUCCESS) ? TEST_OK : TEST_ERR;
+}
+
+/*
+ * Return: TEST_OK, TEST_ERR or TEST_SKIP
+ * we return TEST_OK only if the children return with the expected
+ * 'expected_status' that is specified as an argument.
+ */
+static int kdbus_fork_test(const char *bus, const char *name,
+			   struct kdbus_conn **conn_db, int expected_status)
+{
+	pid_t pid;
+	int ret =3D 0;
+	int status =3D 0;
+
+	pid =3D fork();
+	ASSERT_RETURN_VAL(pid >=3D 0, pid);
+
+	if (pid =3D=3D 0) {
+		ret =3D prctl(PR_SET_PDEATHSIG, SIGKILL);
+		ASSERT_EXIT(ret =3D=3D 0);
+
+		ret =3D drop_privileges(65534, 65534);
+		ASSERT_EXIT(ret =3D=3D 0);
+
+		ret =3D kdbus_recv_in_threads(bus, name, conn_db);
+		_exit(ret =3D=3D expected_status ? EXIT_SUCCESS : EXIT_FAILURE);
+	}
+
+	ret =3D waitpid(pid, &status, 0);
+	ASSERT_RETURN(ret >=3D 0);
+
+	return (status =3D=3D EXIT_SUCCESS) ? TEST_OK : TEST_ERR;
+}
+
+/* Return EXIT_SUCCESS, EXIT_FAILURE or negative errno */
+static int __kdbus_clone_userns_test(const char *bus,
+				     const char *name,
+				     struct kdbus_conn **conn_db,
+				     int expected_status)
+{
+	int efd;
+	pid_t pid;
+	int ret =3D 0;
+	unsigned int uid =3D 65534;
+	int status;
+
+	ret =3D drop_privileges(uid, uid);
+	ASSERT_RETURN_VAL(ret =3D=3D 0, ret);
+
+	/*
+	 * Since we just dropped privileges, the dumpable flag was just
+	 * cleared which makes the /proc/$clone_child/uid_map to be
+	 * owned by root, hence any userns uid mapping will fail with
+	 * -EPERM since the mapping will be done by uid 65534.
+	 *
+	 * To avoid this set the dumpable flag again which makes procfs
+	 * update the /proc/$clone_child/ inodes owner to 65534.
+	 *
+	 * Using this we will be able write to /proc/$clone_child/uid_map
+	 * as uid 65534 and map the uid 65534 to 0 inside the user
+	 * namespace.
+	 */
+	ret =3D prctl(PR_SET_DUMPABLE, SUID_DUMP_USER);
+	ASSERT_RETURN_VAL(ret =3D=3D 0, ret);
+
+	/* sync parent/child */
+	efd =3D eventfd(0, EFD_CLOEXEC);
+	ASSERT_RETURN_VAL(efd >=3D 0, efd);
+
+	pid =3D syscall(__NR_clone, SIGCHLD|CLONE_NEWUSER, NULL);
+	if (pid < 0) {
+		ret =3D -errno;
+		kdbus_printf("error clone: %d (%m)\n", ret);
+		/*
+		 * Normal user not allowed to create userns,
+		 * so nothing to worry about ?
+		 */
+		if (ret =3D=3D -EPERM) {
+			kdbus_printf("-- CLONE_NEWUSER TEST Failed for uid: %u\n"
+				"-- Make sure that your kernel do not allow "
+				"CLONE_NEWUSER for unprivileged users\n"
+				"-- Upstream Commit: "
+				"https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/c=
ommit/?id=3D5eaf563e\n",
+				uid);
+			ret =3D 0;
+		}
+
+		return ret;
+	}
+
+	if (pid =3D=3D 0) {
+		struct kdbus_conn *conn_src;
+		eventfd_t event_status =3D 0;
+
+		ret =3D prctl(PR_SET_PDEATHSIG, SIGKILL);
+		ASSERT_EXIT(ret =3D=3D 0);
+
+		ret =3D eventfd_read(efd, &event_status);
+		ASSERT_EXIT(ret >=3D 0 && event_status =3D=3D 1);
+
+		/* ping connection from the new user namespace */
+		conn_src =3D kdbus_hello(bus, 0, NULL, 0);
+		ASSERT_EXIT(conn_src);
+
+		ret =3D kdbus_add_match_empty(conn_src);
+		ASSERT_EXIT(ret =3D=3D 0);
+
+		ret =3D kdbus_msg_send(conn_src, name, 0xabcd1234,
+				     0, 0, 0, KDBUS_DST_ID_NAME);
+		kdbus_conn_free(conn_src);
+
+		_exit(ret =3D=3D expected_status ? EXIT_SUCCESS : EXIT_FAILURE);
+	}
+
+	ret =3D userns_map_uid_gid(pid, "0 65534 1", "0 65534 1");
+	ASSERT_RETURN_VAL(ret =3D=3D 0, ret);
+
+	/* Tell child we are ready */
+	ret =3D eventfd_write(efd, 1);
+	ASSERT_RETURN_VAL(ret =3D=3D 0, ret);
+
+	ret =3D waitpid(pid, &status, 0);
+	ASSERT_RETURN_VAL(ret >=3D 0, ret);
+
+	close(efd);
+
+	return status =3D=3D EXIT_SUCCESS ? TEST_OK : TEST_ERR;
+}
+
+static int kdbus_clone_userns_test(const char *bus,
+				   const char *name,
+				   struct kdbus_conn **conn_db,
+				   int expected_status)
+{
+	pid_t pid;
+	int ret =3D 0;
+	int status;
+
+	pid =3D fork();
+	ASSERT_RETURN_VAL(pid >=3D 0, -errno);
+
+	if (pid =3D=3D 0) {
+		ret =3D prctl(PR_SET_PDEATHSIG, SIGKILL);
+		if (ret < 0)
+			_exit(EXIT_FAILURE);
+
+		ret =3D __kdbus_clone_userns_test(bus, name, conn_db,
+						expected_status);
+		_exit(ret);
+	}
+
+	/*
+	 * Receive in the original (root privileged) user namespace,
+	 * must fail with -ETIMEDOUT.
+	 */
+	ret =3D kdbus_msg_recv_poll(conn_db[0], 100, NULL, NULL);
+	ASSERT_RETURN_VAL(ret =3D=3D -ETIMEDOUT, ret);
+
+	ret =3D waitpid(pid, &status, 0);
+	ASSERT_RETURN_VAL(ret >=3D 0, ret);
+
+	return (status =3D=3D EXIT_SUCCESS) ? TEST_OK : TEST_ERR;
+}
+
+int kdbus_test_policy_ns(struct kdbus_test_env *env)
+{
+	int i;
+	int ret;
+	struct kdbus_conn *activator =3D NULL;
+	struct kdbus_conn *policy_holder =3D NULL;
+	char *bus =3D env->buspath;
+
+	ret =3D test_is_capable(CAP_SETUID, CAP_SETGID, -1);
+	ASSERT_RETURN(ret >=3D 0);
+
+	/* no enough privileges, SKIP test */
+	if (!ret)
+		return TEST_SKIP;
+
+	/* we require user-namespaces */
+	if (access("/proc/self/uid_map", F_OK) !=3D 0)
+		return TEST_SKIP;
+
+	/* uids/gids must be mapped */
+	if (!all_uids_gids_are_mapped())
+		return TEST_SKIP;
+
+	conn_db =3D calloc(MAX_CONN, sizeof(struct kdbus_conn *));
+	ASSERT_RETURN(conn_db);
+
+	memset(conn_db, 0, MAX_CONN * sizeof(struct kdbus_conn *));
+
+	conn_db[0] =3D kdbus_hello(bus, 0, NULL, 0);
+	ASSERT_RETURN(conn_db[0]);
+
+	ret =3D kdbus_add_match_empty(conn_db[0]);
+	ASSERT_RETURN(ret =3D=3D 0);
+
+	ret =3D kdbus_fork_test_by_id(bus, conn_db, -EPERM, -EPERM);
+	ASSERT_EXIT(ret =3D=3D 0);
+
+	ret =3D kdbus_register_policy_holder(bus, POLICY_NAME,
+					   &policy_holder);
+	ASSERT_RETURN(ret =3D=3D 0);
+
+	/* Try to register the same name with an activator */
+	ret =3D kdbus_register_same_activator(bus, POLICY_NAME,
+					    &activator);
+	ASSERT_RETURN(ret =3D=3D 0);
+
+	/* Acquire POLICY_NAME */
+	ret =3D kdbus_name_acquire(conn_db[0], POLICY_NAME, NULL);
+	ASSERT_RETURN(ret =3D=3D 0);
+
+	ret =3D kdbus_normal_test(bus, POLICY_NAME, conn_db);
+	ASSERT_RETURN(ret =3D=3D 0);
+
+	ret =3D kdbus_list(conn_db[0], KDBUS_LIST_NAMES |
+				     KDBUS_LIST_UNIQUE |
+				     KDBUS_LIST_ACTIVATORS |
+				     KDBUS_LIST_QUEUED);
+	ASSERT_RETURN(ret =3D=3D 0);
+
+	ret =3D kdbus_fork_test(bus, POLICY_NAME, conn_db, EXIT_SUCCESS);
+	ASSERT_RETURN(ret =3D=3D 0);
+
+	/*
+	 * children connections are able to talk to conn_db[0] since
+	 * current POLICY_NAME TALK type is KDBUS_POLICY_ACCESS_WORLD,
+	 * so expect EXIT_SUCCESS when sending from child. However,
+	 * since the child's connection does not own any well-known
+	 * name, The parent connection conn_db[0] should fail with
+	 * -EPERM but since it is a privileged bus user the TALK is
+	 *  allowed.
+	 */
+	ret =3D kdbus_fork_test_by_id(bus, conn_db,
+				    EXIT_SUCCESS, EXIT_SUCCESS);
+	ASSERT_EXIT(ret =3D=3D 0);
+
+	/*
+	 * Connections that can talk are perhaps being destroyed now.
+	 * Restrict the policy and purge cache entries where the
+	 * conn_db[0] is the destination.
+	 *
+	 * Now only connections with uid =3D=3D 0 are allowed to talk.
+	 */
+	ret =3D kdbus_set_policy_talk(policy_holder, POLICY_NAME,
+				    geteuid(), KDBUS_POLICY_ACCESS_USER);
+	ASSERT_RETURN(ret =3D=3D 0);
+
+	/*
+	 * Testing connections (FORK+DROP) again:
+	 * After setting the policy re-check connections
+	 * we expect the children to fail with -EPERM
+	 */
+	ret =3D kdbus_fork_test(bus, POLICY_NAME, conn_db, -EPERM);
+	ASSERT_RETURN(ret =3D=3D 0);
+
+	/*
+	 * Now expect that both parent and child to fail.
+	 *
+	 * Child should fail with -EPERM since we just restricted
+	 * the POLICY_NAME TALK to uid 0 and its uid is 65534.
+	 *
+	 * Since the parent's connection will timeout when receiving
+	 * from the child, we never continue. FWIW just put -EPERM.
+	 */
+	ret =3D kdbus_fork_test_by_id(bus, conn_db, -EPERM, -EPERM);
+	ASSERT_EXIT(ret =3D=3D 0);
+
+	/* Check if the name can be reached in a new userns */
+	ret =3D kdbus_clone_userns_test(bus, POLICY_NAME, conn_db, -EPERM);
+	ASSERT_RETURN(ret =3D=3D 0);
+
+	for (i =3D 0; i < MAX_CONN; i++)
+		kdbus_conn_free(conn_db[i]);
+
+	kdbus_conn_free(activator);
+	kdbus_conn_free(policy_holder);
+
+	free(conn_db);
+
+	return ret;
+}
diff --git a/tools/testing/selftests/kdbus/test-policy-priv.c b/tools/t=
esting/selftests/kdbus/test-policy-priv.c
new file mode 100644
index 000000000000..a318cccad0d5
--- /dev/null
+++ b/tools/testing/selftests/kdbus/test-policy-priv.c
@@ -0,0 +1,1269 @@
+#include <errno.h>
+#include <stdio.h>
+#include <string.h>
+#include <fcntl.h>
+#include <stdlib.h>
+#include <stdint.h>
+#include <stdbool.h>
+#include <unistd.h>
+#include <time.h>
+#include <sys/capability.h>
+#include <sys/eventfd.h>
+#include <sys/wait.h>
+
+#include "kdbus-test.h"
+#include "kdbus-util.h"
+#include "kdbus-enum.h"
+
+static int test_policy_priv_by_id(const char *bus,
+				  struct kdbus_conn *conn_dst,
+				  bool drop_second_user,
+				  int parent_status,
+				  int child_status)
+{
+	int ret =3D 0;
+	uint64_t expected_cookie =3D time(NULL) ^ 0xdeadbeef;
+
+	ASSERT_RETURN(conn_dst);
+
+	ret =3D RUN_UNPRIVILEGED_CONN(unpriv, bus, ({
+		ret =3D kdbus_msg_send(unpriv, NULL,
+				     expected_cookie, 0, 0, 0,
+				     conn_dst->id);
+		ASSERT_EXIT(ret =3D=3D child_status);
+	}));
+	ASSERT_RETURN(ret >=3D 0);
+
+	ret =3D kdbus_msg_recv_poll(conn_dst, 300, NULL, NULL);
+	ASSERT_RETURN(ret =3D=3D parent_status);
+
+	return 0;
+}
+
+static int test_policy_priv_by_broadcast(const char *bus,
+					 struct kdbus_conn *conn_dst,
+					 int drop_second_user,
+					 int parent_status,
+					 int child_status)
+{
+	int efd;
+	int ret =3D 0;
+	eventfd_t event_status =3D 0;
+	struct kdbus_msg *msg =3D NULL;
+	uid_t second_uid =3D UNPRIV_UID;
+	gid_t second_gid =3D UNPRIV_GID;
+	struct kdbus_conn *child_2 =3D conn_dst;
+	uint64_t expected_cookie =3D time(NULL) ^ 0xdeadbeef;
+
+	/* Drop to another unprivileged user other than UNPRIV_UID */
+	if (drop_second_user =3D=3D DROP_OTHER_UNPRIV) {
+		second_uid =3D UNPRIV_UID - 1;
+		second_gid =3D UNPRIV_GID - 1;
+	}
+
+	/* child will signal parent to send broadcast */
+	efd =3D eventfd(0, EFD_CLOEXEC);
+	ASSERT_RETURN_VAL(efd >=3D 0, efd);
+
+	ret =3D RUN_UNPRIVILEGED(UNPRIV_UID, UNPRIV_GID, ({
+		struct kdbus_conn *child;
+
+		child =3D kdbus_hello(bus, 0, NULL, 0);
+		ASSERT_EXIT(child);
+
+		ret =3D kdbus_add_match_empty(child);
+		ASSERT_EXIT(ret =3D=3D 0);
+
+		/* signal parent */
+		ret =3D eventfd_write(efd, 1);
+		ASSERT_EXIT(ret =3D=3D 0);
+
+		/* Use a little bit high time */
+		ret =3D kdbus_msg_recv_poll(child, 500, &msg, NULL);
+		ASSERT_EXIT(ret =3D=3D child_status);
+
+		/*
+		 * If we expect the child to get the broadcast
+		 * message, then check the received cookie.
+		 */
+		if (ret =3D=3D 0) {
+			ASSERT_EXIT(expected_cookie =3D=3D msg->cookie);
+		}
+
+		/* Use expected_cookie since 'msg' might be NULL */
+		ret =3D kdbus_msg_send(child, NULL, expected_cookie + 1,
+				     0, 0, 0, KDBUS_DST_ID_BROADCAST);
+		ASSERT_EXIT(ret =3D=3D 0);
+
+		kdbus_msg_free(msg);
+		kdbus_conn_free(child);
+	}),
+	({
+		if (drop_second_user =3D=3D DO_NOT_DROP) {
+			ASSERT_RETURN(child_2);
+
+			ret =3D eventfd_read(efd, &event_status);
+			ASSERT_RETURN(ret >=3D 0 && event_status =3D=3D 1);
+
+			ret =3D kdbus_msg_send(child_2, NULL,
+					     expected_cookie, 0, 0, 0,
+					     KDBUS_DST_ID_BROADCAST);
+			ASSERT_RETURN(ret =3D=3D 0);
+
+			/* Use a little bit high time */
+			ret =3D kdbus_msg_recv_poll(child_2, 1000,
+						  &msg, NULL);
+			ASSERT_RETURN(ret =3D=3D parent_status);
+
+			/*
+			 * Check returned cookie in case we expect
+			 * success.
+			 */
+			if (ret =3D=3D 0) {
+				ASSERT_RETURN(msg->cookie =3D=3D
+					      expected_cookie + 1);
+			}
+
+			kdbus_msg_free(msg);
+		} else {
+			/*
+			 * Two unprivileged users will try to
+			 * communicate using broadcast.
+			 */
+			ret =3D RUN_UNPRIVILEGED(second_uid, second_gid, ({
+				child_2 =3D kdbus_hello(bus, 0, NULL, 0);
+				ASSERT_EXIT(child_2);
+
+				ret =3D kdbus_add_match_empty(child_2);
+				ASSERT_EXIT(ret =3D=3D 0);
+
+				ret =3D eventfd_read(efd, &event_status);
+				ASSERT_EXIT(ret >=3D 0 && event_status =3D=3D 1);
+
+				ret =3D kdbus_msg_send(child_2, NULL,
+						expected_cookie, 0, 0, 0,
+						KDBUS_DST_ID_BROADCAST);
+				ASSERT_EXIT(ret =3D=3D 0);
+
+				/* Use a little bit high time */
+				ret =3D kdbus_msg_recv_poll(child_2, 1000,
+							  &msg, NULL);
+				ASSERT_EXIT(ret =3D=3D parent_status);
+
+				/*
+				 * Check returned cookie in case we expect
+				 * success.
+				 */
+				if (ret =3D=3D 0) {
+					ASSERT_EXIT(msg->cookie =3D=3D
+						    expected_cookie + 1);
+				}
+
+				kdbus_msg_free(msg);
+				kdbus_conn_free(child_2);
+			}),
+			({ 0; }));
+			ASSERT_RETURN(ret =3D=3D 0);
+		}
+	}));
+	ASSERT_RETURN(ret =3D=3D 0);
+
+	close(efd);
+
+	return ret;
+}
+
+static void nosig(int sig)
+{
+}
+
+static int test_priv_before_policy_upload(struct kdbus_test_env *env)
+{
+	int ret =3D 0;
+	struct kdbus_conn *conn;
+
+	conn =3D kdbus_hello(env->buspath, 0, NULL, 0);
+	ASSERT_RETURN(conn);
+
+	/*
+	 * Make sure unprivileged bus user cannot acquire names
+	 * before registring any policy holder.
+	 */
+
+	ret =3D RUN_UNPRIVILEGED_CONN(unpriv, env->buspath, ({
+		ret =3D kdbus_name_acquire(unpriv, "com.example.a", NULL);
+		ASSERT_EXIT(ret < 0);
+	}));
+	ASSERT_RETURN(ret =3D=3D 0);
+
+	/*
+	 * Make sure unprivileged bus users cannot talk by default
+	 * to privileged ones, unless a policy holder that allows
+	 * this was uploaded.
+	 */
+
+	ret =3D test_policy_priv_by_id(env->buspath, conn, false,
+				     -ETIMEDOUT, -EPERM);
+	ASSERT_RETURN(ret =3D=3D 0);
+
+	/* Activate matching for a privileged connection */
+	ret =3D kdbus_add_match_empty(conn);
+	ASSERT_RETURN(ret =3D=3D 0);
+
+	/*
+	 * First make sure that BROADCAST with msg flag
+	 * KDBUS_MSG_EXPECT_REPLY will fail with -ENOTUNIQ
+	 */
+	ret =3D RUN_UNPRIVILEGED_CONN(unpriv, env->buspath, ({
+		ret =3D kdbus_msg_send(unpriv, NULL, 0xdeadbeef,
+				     KDBUS_MSG_EXPECT_REPLY,
+				     5000000000ULL, 0,
+				     KDBUS_DST_ID_BROADCAST);
+		ASSERT_EXIT(ret =3D=3D -ENOTUNIQ);
+	}));
+	ASSERT_RETURN(ret =3D=3D 0);
+
+	/*
+	 * Test broadcast with a privileged connection.
+	 *
+	 * The first unprivileged receiver should not get the
+	 * broadcast message sent by the privileged connection,
+	 * since there is no a TALK policy that allows the
+	 * unprivileged to TALK to the privileged connection. It
+	 * will fail with -ETIMEDOUT
+	 *
+	 * Then second case:
+	 * The privileged connection should get the broadcast
+	 * message from the unprivileged one. Since the receiver is
+	 * a privileged bus user and it has default TALK access to
+	 * all connections it will receive those.
+	 */
+
+	ret =3D test_policy_priv_by_broadcast(env->buspath, conn,
+					    DO_NOT_DROP,
+					    0, -ETIMEDOUT);
+	ASSERT_RETURN(ret =3D=3D 0);
+
+
+	/*
+	 * Test broadcast with two unprivileged connections running
+	 * under the same user.
+	 *
+	 * Both connections should succeed.
+	 */
+
+	ret =3D test_policy_priv_by_broadcast(env->buspath, NULL,
+					    DROP_SAME_UNPRIV, 0, 0);
+	ASSERT_RETURN(ret =3D=3D 0);
+
+	/*
+	 * Test broadcast with two unprivileged connections running
+	 * under different users.
+	 *
+	 * Both connections will fail with -ETIMEDOUT.
+	 */
+
+	ret =3D test_policy_priv_by_broadcast(env->buspath, NULL,
+					    DROP_OTHER_UNPRIV,
+					    -ETIMEDOUT, -ETIMEDOUT);
+	ASSERT_RETURN(ret =3D=3D 0);
+
+	kdbus_conn_free(conn);
+
+	return ret;
+}
+
+static int test_broadcast_after_policy_upload(struct kdbus_test_env *e=
nv)
+{
+	int ret;
+	int efd;
+	eventfd_t event_status =3D 0;
+	struct kdbus_msg *msg =3D NULL;
+	struct kdbus_conn *owner_a, *owner_b;
+	struct kdbus_conn *holder_a, *holder_b;
+	struct kdbus_policy_access access =3D {};
+	uint64_t expected_cookie =3D time(NULL) ^ 0xdeadbeef;
+
+	owner_a =3D kdbus_hello(env->buspath, 0, NULL, 0);
+	ASSERT_RETURN(owner_a);
+
+	ret =3D kdbus_name_acquire(owner_a, "com.example.broadcastA", NULL);
+	ASSERT_EXIT(ret >=3D 0);
+
+	/*
+	 * Make sure unprivileged bus users cannot talk by default
+	 * to privileged ones, unless a policy holder that allows
+	 * this was uploaded.
+	 */
+
+	++expected_cookie;
+	ret =3D test_policy_priv_by_id(env->buspath, owner_a, false,
+				     -ETIMEDOUT, -EPERM);
+	ASSERT_RETURN(ret =3D=3D 0);
+
+	/*
+	 * Make sure that privileged won't receive broadcasts unless
+	 * it installs a match. It will fail with -ETIMEDOUT
+	 *
+	 * At same time check that the unprivileged connection will
+	 * not receive the broadcast message from the privileged one
+	 * since the privileged one owns a name with a restricted
+	 * policy TALK (actually the TALK policy is still not
+	 * registered so we fail by default), thus the unprivileged
+	 * receiver is not able to TALK to that name.
+	 */
+
+	ret =3D test_policy_priv_by_broadcast(env->buspath, owner_a,
+					    DO_NOT_DROP,
+					    -ETIMEDOUT, -ETIMEDOUT);
+	ASSERT_RETURN(ret =3D=3D 0);
+
+	/* Activate matching for a privileged connection */
+	ret =3D kdbus_add_match_empty(owner_a);
+	ASSERT_RETURN(ret =3D=3D 0);
+
+	/*
+	 * Redo the previous test. The privileged conn owner_a is
+	 * able to TALK to any connection so it will receive the
+	 * broadcast message now.
+	 */
+
+	ret =3D test_policy_priv_by_broadcast(env->buspath, owner_a,
+					    DO_NOT_DROP,
+					    0, -ETIMEDOUT);
+	ASSERT_RETURN(ret =3D=3D 0);
+
+	/*
+	 * Test that broadcast between two unprivileged users running
+	 * under the same user still succeed.
+	 */
+
+	ret =3D test_policy_priv_by_broadcast(env->buspath, NULL,
+					    DROP_SAME_UNPRIV, 0, 0);
+	ASSERT_RETURN(ret =3D=3D 0);
+
+	/*
+	 * Test broadcast with two unprivileged connections running
+	 * under different users.
+	 *
+	 * Both connections will fail with -ETIMEDOUT.
+	 */
+
+	ret =3D test_policy_priv_by_broadcast(env->buspath, NULL,
+					    DROP_OTHER_UNPRIV,
+					    -ETIMEDOUT, -ETIMEDOUT);
+	ASSERT_RETURN(ret =3D=3D 0);
+
+	access =3D (struct kdbus_policy_access){
+		.type =3D KDBUS_POLICY_ACCESS_USER,
+		.id =3D geteuid(),
+		.access =3D KDBUS_POLICY_OWN,
+	};
+
+	holder_a =3D kdbus_hello_registrar(env->buspath,
+					 "com.example.broadcastA",
+					 &access, 1,
+					 KDBUS_HELLO_POLICY_HOLDER);
+	ASSERT_RETURN(holder_a);
+
+	holder_b =3D kdbus_hello_registrar(env->buspath,
+					 "com.example.broadcastB",
+					 &access, 1,
+					 KDBUS_HELLO_POLICY_HOLDER);
+	ASSERT_RETURN(holder_b);
+
+	/* Free connections and their received messages and restart */
+	kdbus_conn_free(owner_a);
+
+	owner_a =3D kdbus_hello(env->buspath, 0, NULL, 0);
+	ASSERT_RETURN(owner_a);
+
+	/* Activate matching for a privileged connection */
+	ret =3D kdbus_add_match_empty(owner_a);
+	ASSERT_RETURN(ret =3D=3D 0);
+
+	ret =3D kdbus_name_acquire(owner_a, "com.example.broadcastA", NULL);
+	ASSERT_EXIT(ret >=3D 0);
+
+	owner_b =3D kdbus_hello(env->buspath, 0, NULL, 0);
+	ASSERT_RETURN(owner_b);
+
+	ret =3D kdbus_name_acquire(owner_b, "com.example.broadcastB", NULL);
+	ASSERT_EXIT(ret >=3D 0);
+
+	/* Activate matching for a privileged connection */
+	ret =3D kdbus_add_match_empty(owner_b);
+	ASSERT_RETURN(ret =3D=3D 0);
+
+	/*
+	 * Test that even if "com.example.broadcastA" and
+	 * "com.example.broadcastB" do have a TALK access by default
+	 * they are able to signal each other using broadcast due to
+	 * the fact they are privileged connections, they receive
+	 * all broadcasts if the match allows it.
+	 */
+
+	++expected_cookie;
+	ret =3D kdbus_msg_send(owner_a, NULL, expected_cookie, 0,
+			     0, 0, KDBUS_DST_ID_BROADCAST);
+	ASSERT_RETURN(ret =3D=3D 0);
+
+	ret =3D kdbus_msg_recv_poll(owner_b, 100, &msg, NULL);
+	ASSERT_RETURN(ret =3D=3D 0);
+	ASSERT_RETURN(msg->cookie =3D=3D expected_cookie);
+
+	/* Check src ID */
+	ASSERT_RETURN(msg->src_id =3D=3D owner_a->id);
+
+	kdbus_msg_free(msg);
+
+	/* Release name "com.example.broadcastB" */
+
+	ret =3D kdbus_name_release(owner_b, "com.example.broadcastB");
+	ASSERT_EXIT(ret >=3D 0);
+
+	/* KDBUS_POLICY_OWN for unprivileged connections */
+	access =3D (struct kdbus_policy_access){
+		.type =3D KDBUS_POLICY_ACCESS_WORLD,
+		.id =3D geteuid(),
+		.access =3D KDBUS_POLICY_OWN,
+	};
+
+	/* Update the policy so unprivileged will own the name */
+
+	ret =3D kdbus_conn_update_policy(holder_b,
+				       "com.example.broadcastB",
+				       &access, 1);
+	ASSERT_RETURN(ret =3D=3D 0);
+
+	/*
+	 * Send broadcasts from an unprivileged connection that
+	 * owns a name "com.example.broadcastB".
+	 *
+	 * We'll have four destinations here:
+	 *
+	 * 1) destination owner_a: privileged connection that owns
+	 * "com.example.broadcastA". It will receive the broadcast
+	 * since it is a privileged has default TALK access to all
+	 * connections, and it is subscribed to the match.
+	 * Will succeed.
+	 *
+	 * owner_b: privileged connection (running under a different
+	 * uid) that do not own names, but with an empty broadcast
+	 * match, so it will receive broadcasts since it has default
+	 * TALK access to all connection.
+	 *
+	 * unpriv_a: unpriv connection that do not own any name.
+	 * It will receive the broadcast since it is running under
+	 * the same user of the one broadcasting and did install
+	 * matches. It should get the message.
+	 *
+	 * unpriv_b: unpriv connection is not interested in broadcast
+	 * messages, so it did not install broadcast matches. Should
+	 * fail with -ETIMEDOUT
+	 */
+
+	++expected_cookie;
+	efd =3D eventfd(0, EFD_CLOEXEC);
+	ASSERT_RETURN_VAL(efd >=3D 0, efd);
+
+	ret =3D RUN_UNPRIVILEGED(UNPRIV_UID, UNPRIV_UID, ({
+		struct kdbus_conn *unpriv_owner;
+		struct kdbus_conn *unpriv_a, *unpriv_b;
+
+		unpriv_owner =3D kdbus_hello(env->buspath, 0, NULL, 0);
+		ASSERT_EXIT(unpriv_owner);
+
+		unpriv_a =3D kdbus_hello(env->buspath, 0, NULL, 0);
+		ASSERT_EXIT(unpriv_a);
+
+		unpriv_b =3D kdbus_hello(env->buspath, 0, NULL, 0);
+		ASSERT_EXIT(unpriv_b);
+
+		ret =3D kdbus_name_acquire(unpriv_owner,
+					 "com.example.broadcastB",
+					 NULL);
+		ASSERT_EXIT(ret >=3D 0);
+
+		ret =3D kdbus_add_match_empty(unpriv_a);
+		ASSERT_EXIT(ret =3D=3D 0);
+
+		/* Signal that we are doing broadcasts */
+		ret =3D eventfd_write(efd, 1);
+		ASSERT_EXIT(ret =3D=3D 0);
+
+		/*
+		 * Do broadcast from a connection that owns the
+		 * names "com.example.broadcastB".
+		 */
+		ret =3D kdbus_msg_send(unpriv_owner, NULL,
+				     expected_cookie,
+				     0, 0, 0,
+				     KDBUS_DST_ID_BROADCAST);
+		ASSERT_EXIT(ret =3D=3D 0);
+
+		/*
+		 * Unprivileged connection running under the same
+		 * user. It should succeed.
+		 */
+		ret =3D kdbus_msg_recv_poll(unpriv_a, 300, &msg, NULL);
+		ASSERT_EXIT(ret =3D=3D 0 && msg->cookie =3D=3D expected_cookie);
+
+		/*
+		 * Did not install matches, not interested in
+		 * broadcasts
+		 */
+		ret =3D kdbus_msg_recv_poll(unpriv_b, 300, NULL, NULL);
+		ASSERT_EXIT(ret =3D=3D -ETIMEDOUT);
+	}),
+	({
+		ret =3D eventfd_read(efd, &event_status);
+		ASSERT_RETURN(ret >=3D 0 && event_status =3D=3D 1);
+
+		/*
+		 * owner_a must fail with -ETIMEDOUT, since it owns
+		 * name "com.example.broadcastA" and its TALK
+		 * access is restriced.
+		 */
+		ret =3D kdbus_msg_recv_poll(owner_a, 300, &msg, NULL);
+		ASSERT_RETURN(ret =3D=3D 0);
+
+		/* confirm the received cookie */
+		ASSERT_RETURN(msg->cookie =3D=3D expected_cookie);
+
+		kdbus_msg_free(msg);
+
+		/*
+		 * owner_b got the broadcast from an unprivileged
+		 * connection.
+		 */
+		ret =3D kdbus_msg_recv_poll(owner_b, 300, &msg, NULL);
+		ASSERT_RETURN(ret =3D=3D 0);
+
+		/* confirm the received cookie */
+		ASSERT_RETURN(msg->cookie =3D=3D expected_cookie);
+
+		kdbus_msg_free(msg);
+
+	}));
+	ASSERT_RETURN(ret =3D=3D 0);
+
+	close(efd);
+
+	/*
+	 * Test broadcast with two unprivileged connections running
+	 * under different users.
+	 *
+	 * Both connections will fail with -ETIMEDOUT.
+	 */
+
+	ret =3D test_policy_priv_by_broadcast(env->buspath, NULL,
+					    DROP_OTHER_UNPRIV,
+					    -ETIMEDOUT, -ETIMEDOUT);
+	ASSERT_RETURN(ret =3D=3D 0);
+
+	/* Drop received broadcasts by privileged */
+	ret =3D kdbus_msg_recv_poll(owner_a, 100, NULL, NULL);
+	ret =3D kdbus_msg_recv_poll(owner_a, 100, NULL, NULL);
+	ASSERT_RETURN(ret =3D=3D 0);
+
+	ret =3D kdbus_msg_recv(owner_a, NULL, NULL);
+	ASSERT_RETURN(ret =3D=3D -EAGAIN);
+
+	ret =3D kdbus_msg_recv_poll(owner_b, 100, NULL, NULL);
+	ret =3D kdbus_msg_recv_poll(owner_b, 100, NULL, NULL);
+	ASSERT_RETURN(ret =3D=3D 0);
+
+	ret =3D kdbus_msg_recv(owner_b, NULL, NULL);
+	ASSERT_RETURN(ret =3D=3D -EAGAIN);
+
+	/*
+	 * Perform last tests, allow others to talk to name
+	 * "com.example.broadcastA". So now receiving broadcasts
+	 * from it should succeed since the TALK policy allow it.
+	 */
+
+	/* KDBUS_POLICY_OWN for unprivileged connections */
+	access =3D (struct kdbus_policy_access){
+		.type =3D KDBUS_POLICY_ACCESS_WORLD,
+		.id =3D geteuid(),
+		.access =3D KDBUS_POLICY_TALK,
+	};
+
+	ret =3D kdbus_conn_update_policy(holder_a,
+				       "com.example.broadcastA",
+				       &access, 1);
+	ASSERT_RETURN(ret =3D=3D 0);
+
+	/*
+	 * Unprivileged is able to TALK to "com.example.broadcastA"
+	 * now so it will receive its broadcasts
+	 */
+	ret =3D test_policy_priv_by_broadcast(env->buspath, owner_a,
+					    DO_NOT_DROP, 0, 0);
+	ASSERT_RETURN(ret =3D=3D 0);
+
+	++expected_cookie;
+	ret =3D RUN_UNPRIVILEGED_CONN(unpriv, env->buspath, ({
+		ret =3D kdbus_name_acquire(unpriv, "com.example.broadcastB",
+					 NULL);
+		ASSERT_EXIT(ret >=3D 0);
+		ret =3D kdbus_msg_send(unpriv, NULL, expected_cookie,
+				     0, 0, 0, KDBUS_DST_ID_BROADCAST);
+		ASSERT_EXIT(ret =3D=3D 0);
+	}));
+	ASSERT_RETURN(ret =3D=3D 0);
+
+	/* owner_a is privileged it will get the broadcast now. */
+	ret =3D kdbus_msg_recv_poll(owner_a, 300, &msg, NULL);
+	ASSERT_RETURN(ret =3D=3D 0);
+
+	/* confirm the received cookie */
+	ASSERT_RETURN(msg->cookie =3D=3D expected_cookie);
+
+	kdbus_msg_free(msg);
+
+	/*
+	 * owner_a released name "com.example.broadcastA". It should
+	 * receive broadcasts since it is still privileged and has
+	 * the right match.
+	 *
+	 * Unprivileged connection will own a name and will try to
+	 * signal to the privileged connection.
+	 */
+
+	ret =3D kdbus_name_release(owner_a, "com.example.broadcastA");
+	ASSERT_EXIT(ret >=3D 0);
+
+	++expected_cookie;
+	ret =3D RUN_UNPRIVILEGED_CONN(unpriv, env->buspath, ({
+		ret =3D kdbus_name_acquire(unpriv, "com.example.broadcastB",
+					 NULL);
+		ASSERT_EXIT(ret >=3D 0);
+		ret =3D kdbus_msg_send(unpriv, NULL, expected_cookie,
+				     0, 0, 0, KDBUS_DST_ID_BROADCAST);
+		ASSERT_EXIT(ret =3D=3D 0);
+	}));
+	ASSERT_RETURN(ret =3D=3D 0);
+
+	/* owner_a will get the broadcast now. */
+	ret =3D kdbus_msg_recv_poll(owner_a, 300, &msg, NULL);
+	ASSERT_RETURN(ret =3D=3D 0);
+
+	/* confirm the received cookie */
+	ASSERT_RETURN(msg->cookie =3D=3D expected_cookie);
+
+	kdbus_msg_free(msg);
+
+	kdbus_conn_free(owner_a);
+	kdbus_conn_free(owner_b);
+	kdbus_conn_free(holder_a);
+	kdbus_conn_free(holder_b);
+
+	return 0;
+}
+
+static int test_policy_priv(struct kdbus_test_env *env)
+{
+	struct kdbus_conn *conn_a, *conn_b, *conn, *owner;
+	struct kdbus_policy_access access, *acc;
+	sigset_t sset;
+	size_t num;
+	int ret;
+
+	/*
+	 * Make sure we have CAP_SETUID/SETGID so we can drop privileges
+	 */
+
+	ret =3D test_is_capable(CAP_SETUID, CAP_SETGID, -1);
+	ASSERT_RETURN(ret >=3D 0);
+
+	if (!ret)
+		return TEST_SKIP;
+
+	/* make sure that uids and gids are mapped */
+	if (!all_uids_gids_are_mapped())
+		return TEST_SKIP;
+
+	/*
+	 * Setup:
+	 *  conn_a: policy holder for com.example.a
+	 *  conn_b: name holder of com.example.b
+	 */
+
+	signal(SIGUSR1, nosig);
+	sigemptyset(&sset);
+	sigaddset(&sset, SIGUSR1);
+	sigprocmask(SIG_BLOCK, &sset, NULL);
+
+	conn =3D kdbus_hello(env->buspath, 0, NULL, 0);
+	ASSERT_RETURN(conn);
+
+	/*
+	 * Before registering any policy holder, make sure that the
+	 * bus is secure by default. This test is necessary, it catches
+	 * several cases where old D-Bus was vulnerable.
+	 */
+
+	ret =3D test_priv_before_policy_upload(env);
+	ASSERT_RETURN(ret =3D=3D 0);
+
+	/*
+	 * Make sure unprivileged are not able to register policy
+	 * holders
+	 */
+
+	ret =3D RUN_UNPRIVILEGED(UNPRIV_UID, UNPRIV_GID, ({
+		struct kdbus_conn *holder;
+
+		holder =3D kdbus_hello_registrar(env->buspath,
+					       "com.example.a", NULL, 0,
+					       KDBUS_HELLO_POLICY_HOLDER);
+		ASSERT_EXIT(holder =3D=3D NULL && errno =3D=3D EPERM);
+	}),
+	({ 0; }));
+	ASSERT_RETURN(ret =3D=3D 0);
+
+
+	/* Register policy holder */
+
+	conn_a =3D kdbus_hello_registrar(env->buspath, "com.example.a",
+				       NULL, 0, KDBUS_HELLO_POLICY_HOLDER);
+	ASSERT_RETURN(conn_a);
+
+	conn_b =3D kdbus_hello(env->buspath, 0, NULL, 0);
+	ASSERT_RETURN(conn_b);
+
+	ret =3D kdbus_name_acquire(conn_b, "com.example.b", NULL);
+	ASSERT_EXIT(ret >=3D 0);
+
+	/*
+	 * Make sure bus-owners can always acquire names.
+	 */
+	ret =3D kdbus_name_acquire(conn, "com.example.a", NULL);
+	ASSERT_EXIT(ret >=3D 0);
+
+	kdbus_conn_free(conn);
+
+	/*
+	 * Make sure unprivileged users cannot acquire names with default
+	 * policy assigned.
+	 */
+
+	ret =3D RUN_UNPRIVILEGED_CONN(unpriv, env->buspath, ({
+		ret =3D kdbus_name_acquire(unpriv, "com.example.a", NULL);
+		ASSERT_EXIT(ret < 0);
+	}));
+	ASSERT_RETURN(ret >=3D 0);
+
+	/*
+	 * Make sure unprivileged users can acquire names if we make them
+	 * world-accessible.
+	 */
+
+	access =3D (struct kdbus_policy_access){
+		.type =3D KDBUS_POLICY_ACCESS_WORLD,
+		.id =3D 0,
+		.access =3D KDBUS_POLICY_OWN,
+	};
+
+	/*
+	 * Make sure unprivileged/normal connections are not able
+	 * to update policies
+	 */
+
+	ret =3D RUN_UNPRIVILEGED_CONN(unpriv, env->buspath, ({
+		ret =3D kdbus_conn_update_policy(unpriv, "com.example.a",
+					       &access, 1);
+		ASSERT_EXIT(ret =3D=3D -EOPNOTSUPP);
+	}));
+	ASSERT_RETURN(ret =3D=3D 0);
+
+	ret =3D kdbus_conn_update_policy(conn_a, "com.example.a", &access, 1)=
;
+	ASSERT_RETURN(ret =3D=3D 0);
+
+	ret =3D RUN_UNPRIVILEGED_CONN(unpriv, env->buspath, ({
+		ret =3D kdbus_name_acquire(unpriv, "com.example.a", NULL);
+		ASSERT_EXIT(ret >=3D 0);
+	}));
+	ASSERT_RETURN(ret >=3D 0);
+
+	/*
+	 * Make sure unprivileged users can acquire names if we make them
+	 * gid-accessible. But only if the gid matches.
+	 */
+
+	access =3D (struct kdbus_policy_access){
+		.type =3D KDBUS_POLICY_ACCESS_GROUP,
+		.id =3D UNPRIV_GID,
+		.access =3D KDBUS_POLICY_OWN,
+	};
+
+	ret =3D kdbus_conn_update_policy(conn_a, "com.example.a", &access, 1)=
;
+	ASSERT_RETURN(ret =3D=3D 0);
+
+	ret =3D RUN_UNPRIVILEGED_CONN(unpriv, env->buspath, ({
+		ret =3D kdbus_name_acquire(unpriv, "com.example.a", NULL);
+		ASSERT_EXIT(ret >=3D 0);
+	}));
+	ASSERT_RETURN(ret >=3D 0);
+
+	access =3D (struct kdbus_policy_access){
+		.type =3D KDBUS_POLICY_ACCESS_GROUP,
+		.id =3D 1,
+		.access =3D KDBUS_POLICY_OWN,
+	};
+
+	ret =3D kdbus_conn_update_policy(conn_a, "com.example.a", &access, 1)=
;
+	ASSERT_RETURN(ret =3D=3D 0);
+
+	ret =3D RUN_UNPRIVILEGED_CONN(unpriv, env->buspath, ({
+		ret =3D kdbus_name_acquire(unpriv, "com.example.a", NULL);
+		ASSERT_EXIT(ret < 0);
+	}));
+	ASSERT_RETURN(ret >=3D 0);
+
+	/*
+	 * Make sure unprivileged users can acquire names if we make them
+	 * uid-accessible. But only if the uid matches.
+	 */
+
+	access =3D (struct kdbus_policy_access){
+		.type =3D KDBUS_POLICY_ACCESS_USER,
+		.id =3D UNPRIV_UID,
+		.access =3D KDBUS_POLICY_OWN,
+	};
+
+	ret =3D kdbus_conn_update_policy(conn_a, "com.example.a", &access, 1)=
;
+	ASSERT_RETURN(ret =3D=3D 0);
+
+	ret =3D RUN_UNPRIVILEGED_CONN(unpriv, env->buspath, ({
+		ret =3D kdbus_name_acquire(unpriv, "com.example.a", NULL);
+		ASSERT_EXIT(ret >=3D 0);
+	}));
+	ASSERT_RETURN(ret >=3D 0);
+
+	access =3D (struct kdbus_policy_access){
+		.type =3D KDBUS_POLICY_ACCESS_USER,
+		.id =3D 1,
+		.access =3D KDBUS_POLICY_OWN,
+	};
+
+	ret =3D kdbus_conn_update_policy(conn_a, "com.example.a", &access, 1)=
;
+	ASSERT_RETURN(ret =3D=3D 0);
+
+	ret =3D RUN_UNPRIVILEGED_CONN(unpriv, env->buspath, ({
+		ret =3D kdbus_name_acquire(unpriv, "com.example.a", NULL);
+		ASSERT_EXIT(ret < 0);
+	}));
+	ASSERT_RETURN(ret >=3D 0);
+
+	/*
+	 * Make sure unprivileged users cannot acquire names if no owner-poli=
cy
+	 * matches, even if SEE/TALK policies match.
+	 */
+
+	num =3D 4;
+	acc =3D (struct kdbus_policy_access[]){
+		{
+			.type =3D KDBUS_POLICY_ACCESS_GROUP,
+			.id =3D UNPRIV_GID,
+			.access =3D KDBUS_POLICY_SEE,
+		},
+		{
+			.type =3D KDBUS_POLICY_ACCESS_USER,
+			.id =3D UNPRIV_UID,
+			.access =3D KDBUS_POLICY_TALK,
+		},
+		{
+			.type =3D KDBUS_POLICY_ACCESS_WORLD,
+			.id =3D 0,
+			.access =3D KDBUS_POLICY_TALK,
+		},
+		{
+			.type =3D KDBUS_POLICY_ACCESS_WORLD,
+			.id =3D 0,
+			.access =3D KDBUS_POLICY_SEE,
+		},
+	};
+
+	ret =3D kdbus_conn_update_policy(conn_a, "com.example.a", acc, num);
+	ASSERT_RETURN(ret =3D=3D 0);
+
+	ret =3D RUN_UNPRIVILEGED_CONN(unpriv, env->buspath, ({
+		ret =3D kdbus_name_acquire(unpriv, "com.example.a", NULL);
+		ASSERT_EXIT(ret < 0);
+	}));
+	ASSERT_RETURN(ret >=3D 0);
+
+	/*
+	 * Make sure unprivileged users can acquire names if the only matchin=
g
+	 * policy is somewhere in the middle.
+	 */
+
+	num =3D 5;
+	acc =3D (struct kdbus_policy_access[]){
+		{
+			.type =3D KDBUS_POLICY_ACCESS_USER,
+			.id =3D 1,
+			.access =3D KDBUS_POLICY_OWN,
+		},
+		{
+			.type =3D KDBUS_POLICY_ACCESS_USER,
+			.id =3D 2,
+			.access =3D KDBUS_POLICY_OWN,
+		},
+		{
+			.type =3D KDBUS_POLICY_ACCESS_USER,
+			.id =3D UNPRIV_UID,
+			.access =3D KDBUS_POLICY_OWN,
+		},
+		{
+			.type =3D KDBUS_POLICY_ACCESS_USER,
+			.id =3D 3,
+			.access =3D KDBUS_POLICY_OWN,
+		},
+		{
+			.type =3D KDBUS_POLICY_ACCESS_USER,
+			.id =3D 4,
+			.access =3D KDBUS_POLICY_OWN,
+		},
+	};
+
+	ret =3D kdbus_conn_update_policy(conn_a, "com.example.a", acc, num);
+	ASSERT_RETURN(ret =3D=3D 0);
+
+	ret =3D RUN_UNPRIVILEGED_CONN(unpriv, env->buspath, ({
+		ret =3D kdbus_name_acquire(unpriv, "com.example.a", NULL);
+		ASSERT_EXIT(ret >=3D 0);
+	}));
+	ASSERT_RETURN(ret >=3D 0);
+
+	/*
+	 * Clear policies
+	 */
+
+	ret =3D kdbus_conn_update_policy(conn_a, "com.example.a", NULL, 0);
+	ASSERT_RETURN(ret =3D=3D 0);
+
+	/*
+	 * Make sure privileged bus users can _always_ talk to others.
+	 */
+
+	conn =3D kdbus_hello(env->buspath, 0, NULL, 0);
+	ASSERT_RETURN(conn);
+
+	ret =3D kdbus_msg_send(conn, "com.example.b", 0xdeadbeef, 0, 0, 0, 0)=
;
+	ASSERT_EXIT(ret >=3D 0);
+
+	ret =3D kdbus_msg_recv_poll(conn_b, 300, NULL, NULL);
+	ASSERT_EXIT(ret >=3D 0);
+
+	kdbus_conn_free(conn);
+
+	/*
+	 * Make sure unprivileged bus users cannot talk by default.
+	 */
+
+	ret =3D RUN_UNPRIVILEGED_CONN(unpriv, env->buspath, ({
+		ret =3D kdbus_msg_send(unpriv, "com.example.b", 0xdeadbeef, 0, 0,
+				     0, 0);
+		ASSERT_EXIT(ret =3D=3D -EPERM);
+	}));
+	ASSERT_RETURN(ret >=3D 0);
+
+	/*
+	 * Make sure unprivileged bus users can talk to equals, even without
+	 * policy.
+	 */
+
+	access =3D (struct kdbus_policy_access){
+		.type =3D KDBUS_POLICY_ACCESS_USER,
+		.id =3D UNPRIV_UID,
+		.access =3D KDBUS_POLICY_OWN,
+	};
+
+	ret =3D kdbus_conn_update_policy(conn_a, "com.example.c", &access, 1)=
;
+	ASSERT_RETURN(ret =3D=3D 0);
+
+	ret =3D RUN_UNPRIVILEGED_CONN(unpriv, env->buspath, ({
+		struct kdbus_conn *owner;
+
+		owner =3D kdbus_hello(env->buspath, 0, NULL, 0);
+		ASSERT_RETURN(owner);
+
+		ret =3D kdbus_name_acquire(owner, "com.example.c", NULL);
+		ASSERT_EXIT(ret >=3D 0);
+
+		ret =3D kdbus_msg_send(unpriv, "com.example.c", 0xdeadbeef, 0, 0,
+				     0, 0);
+		ASSERT_EXIT(ret >=3D 0);
+		ret =3D kdbus_msg_recv_poll(owner, 100, NULL, NULL);
+		ASSERT_EXIT(ret >=3D 0);
+
+		kdbus_conn_free(owner);
+	}));
+	ASSERT_RETURN(ret >=3D 0);
+
+	/*
+	 * Make sure unprivileged bus users can talk to privileged users if a
+	 * suitable UID policy is set.
+	 */
+
+	access =3D (struct kdbus_policy_access){
+		.type =3D KDBUS_POLICY_ACCESS_USER,
+		.id =3D UNPRIV_UID,
+		.access =3D KDBUS_POLICY_TALK,
+	};
+
+	ret =3D kdbus_conn_update_policy(conn_a, "com.example.b", &access, 1)=
;
+	ASSERT_RETURN(ret =3D=3D 0);
+
+	ret =3D RUN_UNPRIVILEGED_CONN(unpriv, env->buspath, ({
+		ret =3D kdbus_msg_send(unpriv, "com.example.b", 0xdeadbeef, 0, 0,
+				     0, 0);
+		ASSERT_EXIT(ret >=3D 0);
+	}));
+	ASSERT_RETURN(ret >=3D 0);
+
+	ret =3D kdbus_msg_recv_poll(conn_b, 100, NULL, NULL);
+	ASSERT_EXIT(ret >=3D 0);
+
+	/*
+	 * Make sure unprivileged bus users can talk to privileged users if a
+	 * suitable GID policy is set.
+	 */
+
+	access =3D (struct kdbus_policy_access){
+		.type =3D KDBUS_POLICY_ACCESS_GROUP,
+		.id =3D UNPRIV_GID,
+		.access =3D KDBUS_POLICY_TALK,
+	};
+
+	ret =3D kdbus_conn_update_policy(conn_a, "com.example.b", &access, 1)=
;
+	ASSERT_RETURN(ret =3D=3D 0);
+
+	ret =3D RUN_UNPRIVILEGED_CONN(unpriv, env->buspath, ({
+		ret =3D kdbus_msg_send(unpriv, "com.example.b", 0xdeadbeef, 0, 0,
+				     0, 0);
+		ASSERT_EXIT(ret >=3D 0);
+	}));
+	ASSERT_RETURN(ret >=3D 0);
+
+	ret =3D kdbus_msg_recv_poll(conn_b, 100, NULL, NULL);
+	ASSERT_EXIT(ret >=3D 0);
+
+	/*
+	 * Make sure unprivileged bus users can talk to privileged users if a
+	 * suitable WORLD policy is set.
+	 */
+
+	access =3D (struct kdbus_policy_access){
+		.type =3D KDBUS_POLICY_ACCESS_WORLD,
+		.id =3D 0,
+		.access =3D KDBUS_POLICY_TALK,
+	};
+
+	ret =3D kdbus_conn_update_policy(conn_a, "com.example.b", &access, 1)=
;
+	ASSERT_RETURN(ret =3D=3D 0);
+
+	ret =3D RUN_UNPRIVILEGED_CONN(unpriv, env->buspath, ({
+		ret =3D kdbus_msg_send(unpriv, "com.example.b", 0xdeadbeef, 0, 0,
+				     0, 0);
+		ASSERT_EXIT(ret >=3D 0);
+	}));
+	ASSERT_RETURN(ret >=3D 0);
+
+	ret =3D kdbus_msg_recv_poll(conn_b, 100, NULL, NULL);
+	ASSERT_EXIT(ret >=3D 0);
+
+	/*
+	 * Make sure unprivileged bus users cannot talk to privileged users i=
f
+	 * no suitable policy is set.
+	 */
+
+	num =3D 5;
+	acc =3D (struct kdbus_policy_access[]){
+		{
+			.type =3D KDBUS_POLICY_ACCESS_USER,
+			.id =3D 0,
+			.access =3D KDBUS_POLICY_OWN,
+		},
+		{
+			.type =3D KDBUS_POLICY_ACCESS_USER,
+			.id =3D 1,
+			.access =3D KDBUS_POLICY_TALK,
+		},
+		{
+			.type =3D KDBUS_POLICY_ACCESS_USER,
+			.id =3D UNPRIV_UID,
+			.access =3D KDBUS_POLICY_SEE,
+		},
+		{
+			.type =3D KDBUS_POLICY_ACCESS_USER,
+			.id =3D 3,
+			.access =3D KDBUS_POLICY_TALK,
+		},
+		{
+			.type =3D KDBUS_POLICY_ACCESS_USER,
+			.id =3D 4,
+			.access =3D KDBUS_POLICY_TALK,
+		},
+	};
+
+	ret =3D kdbus_conn_update_policy(conn_a, "com.example.b", acc, num);
+	ASSERT_RETURN(ret =3D=3D 0);
+
+	ret =3D RUN_UNPRIVILEGED_CONN(unpriv, env->buspath, ({
+		ret =3D kdbus_msg_send(unpriv, "com.example.b", 0xdeadbeef, 0, 0,
+				     0, 0);
+		ASSERT_EXIT(ret =3D=3D -EPERM);
+	}));
+	ASSERT_RETURN(ret >=3D 0);
+
+	/*
+	 * Make sure unprivileged bus users can talk to privileged users if a
+	 * suitable OWN privilege overwrites TALK.
+	 */
+
+	access =3D (struct kdbus_policy_access){
+		.type =3D KDBUS_POLICY_ACCESS_WORLD,
+		.id =3D 0,
+		.access =3D KDBUS_POLICY_OWN,
+	};
+
+	ret =3D kdbus_conn_update_policy(conn_a, "com.example.b", &access, 1)=
;
+	ASSERT_RETURN(ret =3D=3D 0);
+
+	ret =3D RUN_UNPRIVILEGED_CONN(unpriv, env->buspath, ({
+		ret =3D kdbus_msg_send(unpriv, "com.example.b", 0xdeadbeef, 0, 0,
+				     0, 0);
+		ASSERT_EXIT(ret >=3D 0);
+	}));
+	ASSERT_RETURN(ret >=3D 0);
+
+	ret =3D kdbus_msg_recv_poll(conn_b, 100, NULL, NULL);
+	ASSERT_EXIT(ret >=3D 0);
+
+	/*
+	 * Make sure the TALK cache is reset correctly when policies are
+	 * updated.
+	 */
+
+	access =3D (struct kdbus_policy_access){
+		.type =3D KDBUS_POLICY_ACCESS_WORLD,
+		.id =3D 0,
+		.access =3D KDBUS_POLICY_TALK,
+	};
+
+	ret =3D kdbus_conn_update_policy(conn_a, "com.example.b", &access, 1)=
;
+	ASSERT_RETURN(ret =3D=3D 0);
+
+	ret =3D RUN_UNPRIVILEGED_CONN(unpriv, env->buspath, ({
+		ret =3D kdbus_msg_send(unpriv, "com.example.b", 0xdeadbeef, 0, 0,
+				     0, 0);
+		ASSERT_EXIT(ret >=3D 0);
+
+		ret =3D kdbus_msg_recv_poll(conn_b, 100, NULL, NULL);
+		ASSERT_EXIT(ret >=3D 0);
+
+		ret =3D kdbus_conn_update_policy(conn_a, "com.example.b",
+					       NULL, 0);
+		ASSERT_RETURN(ret =3D=3D 0);
+
+		ret =3D kdbus_msg_send(unpriv, "com.example.b", 0xdeadbeef, 0, 0,
+				     0, 0);
+		ASSERT_EXIT(ret =3D=3D -EPERM);
+	}));
+	ASSERT_RETURN(ret >=3D 0);
+
+	/*
+	 * Make sure the TALK cache is reset correctly when policy holders
+	 * disconnect.
+	 */
+
+	access =3D (struct kdbus_policy_access){
+		.type =3D KDBUS_POLICY_ACCESS_WORLD,
+		.id =3D 0,
+		.access =3D KDBUS_POLICY_OWN,
+	};
+
+	conn =3D kdbus_hello_registrar(env->buspath, "com.example.c",
+				     NULL, 0, KDBUS_HELLO_POLICY_HOLDER);
+	ASSERT_RETURN(conn);
+
+	ret =3D kdbus_conn_update_policy(conn, "com.example.c", &access, 1);
+	ASSERT_RETURN(ret =3D=3D 0);
+
+	owner =3D kdbus_hello(env->buspath, 0, NULL, 0);
+	ASSERT_RETURN(owner);
+
+	ret =3D kdbus_name_acquire(owner, "com.example.c", NULL);
+	ASSERT_RETURN(ret >=3D 0);
+
+	ret =3D RUN_UNPRIVILEGED(UNPRIV_UID, UNPRIV_GID, ({
+		struct kdbus_conn *unpriv;
+
+		/* wait for parent to be finished */
+		sigemptyset(&sset);
+		ret =3D sigsuspend(&sset);
+		ASSERT_RETURN(ret =3D=3D -1 && errno =3D=3D EINTR);
+
+		unpriv =3D kdbus_hello(env->buspath, 0, NULL, 0);
+		ASSERT_RETURN(unpriv);
+
+		ret =3D kdbus_msg_send(unpriv, "com.example.c", 0xdeadbeef, 0, 0,
+				     0, 0);
+		ASSERT_EXIT(ret >=3D 0);
+
+		ret =3D kdbus_msg_recv_poll(owner, 100, NULL, NULL);
+		ASSERT_EXIT(ret >=3D 0);
+
+		/* free policy holder */
+		kdbus_conn_free(conn);
+
+		ret =3D kdbus_msg_send(unpriv, "com.example.c", 0xdeadbeef, 0, 0,
+				     0, 0);
+		ASSERT_EXIT(ret =3D=3D -EPERM);
+
+		kdbus_conn_free(unpriv);
+	}), ({
+		/* make sure policy holder is only valid in child */
+		kdbus_conn_free(conn);
+		kill(pid, SIGUSR1);
+	}));
+	ASSERT_RETURN(ret >=3D 0);
+
+
+	/*
+	 * The following tests are necessary.
+	 */
+
+	ret =3D test_broadcast_after_policy_upload(env);
+	ASSERT_RETURN(ret =3D=3D 0);
+
+	kdbus_conn_free(owner);
+
+	/*
+	 * cleanup resources
+	 */
+
+	kdbus_conn_free(conn_b);
+	kdbus_conn_free(conn_a);
+
+	return TEST_OK;
+}
+
+int kdbus_test_policy_priv(struct kdbus_test_env *env)
+{
+	pid_t pid;
+	int ret;
+
+	/* make sure to exit() if a child returns from fork() */
+	pid =3D getpid();
+	ret =3D test_policy_priv(env);
+	if (pid !=3D getpid())
+		exit(1);
+
+	return ret;
+}
diff --git a/tools/testing/selftests/kdbus/test-policy.c b/tools/testin=
g/selftests/kdbus/test-policy.c
new file mode 100644
index 000000000000..96d20d5e9172
--- /dev/null
+++ b/tools/testing/selftests/kdbus/test-policy.c
@@ -0,0 +1,80 @@
+#include <errno.h>
+#include <stdio.h>
+#include <string.h>
+#include <fcntl.h>
+#include <stdlib.h>
+#include <stdint.h>
+#include <stdbool.h>
+#include <unistd.h>
+
+#include "kdbus-test.h"
+#include "kdbus-util.h"
+#include "kdbus-enum.h"
+
+int kdbus_test_policy(struct kdbus_test_env *env)
+{
+	struct kdbus_conn *conn_a, *conn_b;
+	struct kdbus_policy_access access;
+	int ret;
+
+	/* Invalid name */
+	conn_a =3D kdbus_hello_registrar(env->buspath, ".example.a",
+				       NULL, 0, KDBUS_HELLO_POLICY_HOLDER);
+	ASSERT_RETURN(conn_a =3D=3D NULL);
+
+	conn_a =3D kdbus_hello_registrar(env->buspath, "example",
+				       NULL, 0, KDBUS_HELLO_POLICY_HOLDER);
+	ASSERT_RETURN(conn_a =3D=3D NULL);
+
+	conn_a =3D kdbus_hello_registrar(env->buspath, "com.example.a",
+				       NULL, 0, KDBUS_HELLO_POLICY_HOLDER);
+	ASSERT_RETURN(conn_a);
+
+	conn_b =3D kdbus_hello_registrar(env->buspath, "com.example.b",
+				       NULL, 0, KDBUS_HELLO_POLICY_HOLDER);
+	ASSERT_RETURN(conn_b);
+
+	/*
+	 * Verify there cannot be any duplicate entries, except for specific =
vs.
+	 * wildcard entries.
+	 */
+
+	access =3D (struct kdbus_policy_access){
+		.type =3D KDBUS_POLICY_ACCESS_USER,
+		.id =3D geteuid(),
+		.access =3D KDBUS_POLICY_SEE,
+	};
+
+	ret =3D kdbus_conn_update_policy(conn_a, "com.example.a", &access, 1)=
;
+	ASSERT_RETURN(ret =3D=3D 0);
+
+	ret =3D kdbus_conn_update_policy(conn_b, "com.example.a", &access, 1)=
;
+	ASSERT_RETURN(ret =3D=3D -EEXIST);
+
+	ret =3D kdbus_conn_update_policy(conn_b, "com.example.a.*", &access, =
1);
+	ASSERT_RETURN(ret =3D=3D 0);
+
+	ret =3D kdbus_conn_update_policy(conn_a, "com.example.a.*", &access, =
1);
+	ASSERT_RETURN(ret =3D=3D -EEXIST);
+
+	ret =3D kdbus_conn_update_policy(conn_a, "com.example.*", &access, 1)=
;
+	ASSERT_RETURN(ret =3D=3D 0);
+
+	ret =3D kdbus_conn_update_policy(conn_b, "com.example.a", &access, 1)=
;
+	ASSERT_RETURN(ret =3D=3D 0);
+
+	ret =3D kdbus_conn_update_policy(conn_b, "com.example.*", &access, 1)=
;
+	ASSERT_RETURN(ret =3D=3D -EEXIST);
+
+	/* Invalid name */
+	ret =3D kdbus_conn_update_policy(conn_b, ".example.*", &access, 1);
+	ASSERT_RETURN(ret =3D=3D -EINVAL);
+
+	ret =3D kdbus_conn_update_policy(conn_b, "example", &access, 1);
+	ASSERT_RETURN(ret =3D=3D -EINVAL);
+
+	kdbus_conn_free(conn_b);
+	kdbus_conn_free(conn_a);
+
+	return TEST_OK;
+}
diff --git a/tools/testing/selftests/kdbus/test-sync.c b/tools/testing/=
selftests/kdbus/test-sync.c
new file mode 100644
index 000000000000..e2be910d2ece
--- /dev/null
+++ b/tools/testing/selftests/kdbus/test-sync.c
@@ -0,0 +1,369 @@
+#include <stdio.h>
+#include <string.h>
+#include <time.h>
+#include <fcntl.h>
+#include <stdlib.h>
+#include <stddef.h>
+#include <unistd.h>
+#include <stdint.h>
+#include <errno.h>
+#include <assert.h>
+#include <pthread.h>
+#include <stdbool.h>
+#include <signal.h>
+#include <sys/wait.h>
+#include <sys/eventfd.h>
+
+#include "kdbus-api.h"
+#include "kdbus-test.h"
+#include "kdbus-util.h"
+#include "kdbus-enum.h"
+
+static struct kdbus_conn *conn_a, *conn_b;
+static unsigned int cookie =3D 0xdeadbeef;
+
+static void nop_handler(int sig) {}
+
+static int interrupt_sync(struct kdbus_conn *conn_src,
+			  struct kdbus_conn *conn_dst)
+{
+	pid_t pid;
+	int ret, status;
+	struct kdbus_msg *msg =3D NULL;
+	struct sigaction sa =3D {
+		.sa_handler =3D nop_handler,
+		.sa_flags =3D SA_NOCLDSTOP|SA_RESTART,
+	};
+
+	cookie++;
+	pid =3D fork();
+	ASSERT_RETURN_VAL(pid >=3D 0, pid);
+
+	if (pid =3D=3D 0) {
+		ret =3D sigaction(SIGINT, &sa, NULL);
+		ASSERT_EXIT(ret =3D=3D 0);
+
+		ret =3D kdbus_msg_send_sync(conn_dst, NULL, cookie,
+					  KDBUS_MSG_EXPECT_REPLY,
+					  100000000ULL, 0, conn_src->id, -1);
+		ASSERT_EXIT(ret =3D=3D -ETIMEDOUT);
+
+		_exit(EXIT_SUCCESS);
+	}
+
+	ret =3D kdbus_msg_recv_poll(conn_src, 100, &msg, NULL);
+	ASSERT_RETURN(ret =3D=3D 0 && msg->cookie =3D=3D cookie);
+
+	kdbus_msg_free(msg);
+
+	ret =3D kill(pid, SIGINT);
+	ASSERT_RETURN_VAL(ret =3D=3D 0, ret);
+
+	ret =3D waitpid(pid, &status, 0);
+	ASSERT_RETURN_VAL(ret >=3D 0, ret);
+
+	if (WIFSIGNALED(status))
+		return TEST_ERR;
+
+	ret =3D kdbus_msg_recv_poll(conn_src, 100, NULL, NULL);
+	ASSERT_RETURN(ret =3D=3D -ETIMEDOUT);
+
+	return (status =3D=3D EXIT_SUCCESS) ? TEST_OK : TEST_ERR;
+}
+
+static int close_epipe_sync(const char *bus)
+{
+	pid_t pid;
+	int ret, status;
+	struct kdbus_conn *conn_src;
+	struct kdbus_conn *conn_dst;
+	struct kdbus_msg *msg =3D NULL;
+
+	conn_src =3D kdbus_hello(bus, 0, NULL, 0);
+	ASSERT_RETURN(conn_src);
+
+	ret =3D kdbus_add_match_empty(conn_src);
+	ASSERT_RETURN(ret =3D=3D 0);
+
+	conn_dst =3D kdbus_hello(bus, 0, NULL, 0);
+	ASSERT_RETURN(conn_dst);
+
+	cookie++;
+	pid =3D fork();
+	ASSERT_RETURN_VAL(pid >=3D 0, pid);
+
+	if (pid =3D=3D 0) {
+		uint64_t dst_id;
+
+		/* close our reference */
+		dst_id =3D conn_dst->id;
+		kdbus_conn_free(conn_dst);
+
+		ret =3D kdbus_msg_recv_poll(conn_src, 100, &msg, NULL);
+		ASSERT_EXIT(ret =3D=3D 0 && msg->cookie =3D=3D cookie);
+		ASSERT_EXIT(msg->src_id =3D=3D dst_id);
+
+		cookie++;
+		ret =3D kdbus_msg_send_sync(conn_src, NULL, cookie,
+					  KDBUS_MSG_EXPECT_REPLY,
+					  100000000ULL, 0, dst_id, -1);
+		ASSERT_EXIT(ret =3D=3D -EPIPE);
+
+		_exit(EXIT_SUCCESS);
+	}
+
+	ret =3D kdbus_msg_send(conn_dst, NULL, cookie, 0, 0, 0,
+			     KDBUS_DST_ID_BROADCAST);
+	ASSERT_RETURN(ret =3D=3D 0);
+
+	cookie++;
+	ret =3D kdbus_msg_recv_poll(conn_dst, 100, &msg, NULL);
+	ASSERT_RETURN(ret =3D=3D 0 && msg->cookie =3D=3D cookie);
+
+	kdbus_msg_free(msg);
+
+	/* destroy connection */
+	kdbus_conn_free(conn_dst);
+	kdbus_conn_free(conn_src);
+
+	ret =3D waitpid(pid, &status, 0);
+	ASSERT_RETURN_VAL(ret >=3D 0, ret);
+
+	if (!WIFEXITED(status))
+		return TEST_ERR;
+
+	return (status =3D=3D EXIT_SUCCESS) ? TEST_OK : TEST_ERR;
+}
+
+static int cancel_fd_sync(struct kdbus_conn *conn_src,
+			  struct kdbus_conn *conn_dst)
+{
+	pid_t pid;
+	int cancel_fd;
+	int ret, status;
+	uint64_t counter =3D 1;
+	struct kdbus_msg *msg =3D NULL;
+
+	cancel_fd =3D eventfd(0, 0);
+	ASSERT_RETURN_VAL(cancel_fd >=3D 0, cancel_fd);
+
+	cookie++;
+	pid =3D fork();
+	ASSERT_RETURN_VAL(pid >=3D 0, pid);
+
+	if (pid =3D=3D 0) {
+		ret =3D kdbus_msg_send_sync(conn_dst, NULL, cookie,
+					  KDBUS_MSG_EXPECT_REPLY,
+					  100000000ULL, 0, conn_src->id,
+					  cancel_fd);
+		ASSERT_EXIT(ret =3D=3D -ECANCELED);
+
+		_exit(EXIT_SUCCESS);
+	}
+
+	ret =3D kdbus_msg_recv_poll(conn_src, 100, &msg, NULL);
+	ASSERT_RETURN(ret =3D=3D 0 && msg->cookie =3D=3D cookie);
+
+	kdbus_msg_free(msg);
+
+	ret =3D write(cancel_fd, &counter, sizeof(counter));
+	ASSERT_RETURN(ret =3D=3D sizeof(counter));
+
+	ret =3D waitpid(pid, &status, 0);
+	ASSERT_RETURN_VAL(ret >=3D 0, ret);
+
+	if (WIFSIGNALED(status))
+		return TEST_ERR;
+
+	return (status =3D=3D EXIT_SUCCESS) ? TEST_OK : TEST_ERR;
+}
+
+static int no_cancel_sync(struct kdbus_conn *conn_src,
+			  struct kdbus_conn *conn_dst)
+{
+	pid_t pid;
+	int cancel_fd;
+	int ret, status;
+	struct kdbus_msg *msg =3D NULL;
+
+	/* pass eventfd, but never signal it so it shouldn't have any effect =
*/
+
+	cancel_fd =3D eventfd(0, 0);
+	ASSERT_RETURN_VAL(cancel_fd >=3D 0, cancel_fd);
+
+	cookie++;
+	pid =3D fork();
+	ASSERT_RETURN_VAL(pid >=3D 0, pid);
+
+	if (pid =3D=3D 0) {
+		ret =3D kdbus_msg_send_sync(conn_dst, NULL, cookie,
+					  KDBUS_MSG_EXPECT_REPLY,
+					  100000000ULL, 0, conn_src->id,
+					  cancel_fd);
+		ASSERT_EXIT(ret =3D=3D 0);
+
+		_exit(EXIT_SUCCESS);
+	}
+
+	ret =3D kdbus_msg_recv_poll(conn_src, 100, &msg, NULL);
+	ASSERT_RETURN_VAL(ret =3D=3D 0 && msg->cookie =3D=3D cookie, -1);
+
+	kdbus_msg_free(msg);
+
+	ret =3D kdbus_msg_send_reply(conn_src, cookie, conn_dst->id);
+	ASSERT_RETURN_VAL(ret >=3D 0, ret);
+
+	ret =3D waitpid(pid, &status, 0);
+	ASSERT_RETURN_VAL(ret >=3D 0, ret);
+
+	if (WIFSIGNALED(status))
+		return -1;
+
+	return (status =3D=3D EXIT_SUCCESS) ? 0 : -1;
+}
+
+static void *run_thread_reply(void *data)
+{
+	int ret;
+	unsigned long status =3D TEST_OK;
+
+	ret =3D kdbus_msg_recv_poll(conn_a, 3000, NULL, NULL);
+	if (ret < 0)
+		goto exit_thread;
+
+	kdbus_printf("Thread received message, sending reply ...\n");
+
+	/* using an unknown cookie must fail */
+	ret =3D kdbus_msg_send_reply(conn_a, ~cookie, conn_b->id);
+	if (ret !=3D -EPERM) {
+		status =3D TEST_ERR;
+		goto exit_thread;
+	}
+
+	ret =3D kdbus_msg_send_reply(conn_a, cookie, conn_b->id);
+	if (ret !=3D 0) {
+		status =3D TEST_ERR;
+		goto exit_thread;
+	}
+
+exit_thread:
+	pthread_exit(NULL);
+	return (void *) status;
+}
+
+int kdbus_test_sync_reply(struct kdbus_test_env *env)
+{
+	unsigned long status;
+	pthread_t thread;
+	int ret;
+
+	conn_a =3D kdbus_hello(env->buspath, 0, NULL, 0);
+	conn_b =3D kdbus_hello(env->buspath, 0, NULL, 0);
+	ASSERT_RETURN(conn_a && conn_b);
+
+	pthread_create(&thread, NULL, run_thread_reply, NULL);
+
+	ret =3D kdbus_msg_send_sync(conn_b, NULL, cookie,
+				  KDBUS_MSG_EXPECT_REPLY,
+				  5000000000ULL, 0, conn_a->id, -1);
+
+	pthread_join(thread, (void *) &status);
+	ASSERT_RETURN(status =3D=3D 0);
+	ASSERT_RETURN(ret =3D=3D 0);
+
+	ret =3D interrupt_sync(conn_a, conn_b);
+	ASSERT_RETURN(ret =3D=3D 0);
+
+	ret =3D close_epipe_sync(env->buspath);
+	ASSERT_RETURN(ret =3D=3D 0);
+
+	ret =3D cancel_fd_sync(conn_a, conn_b);
+	ASSERT_RETURN(ret =3D=3D 0);
+
+	ret =3D no_cancel_sync(conn_a, conn_b);
+	ASSERT_RETURN(ret =3D=3D 0);
+
+	kdbus_printf("-- closing bus connections\n");
+
+	kdbus_conn_free(conn_a);
+	kdbus_conn_free(conn_b);
+
+	return TEST_OK;
+}
+
+#define BYEBYE_ME ((void*)0L)
+#define BYEBYE_THEM ((void*)1L)
+
+static void *run_thread_byebye(void *data)
+{
+	struct kdbus_cmd cmd_byebye =3D { .size =3D sizeof(cmd_byebye) };
+	int ret;
+
+	ret =3D kdbus_msg_recv_poll(conn_a, 3000, NULL, NULL);
+	if (ret =3D=3D 0) {
+		kdbus_printf("Thread received message, invoking BYEBYE ...\n");
+		kdbus_msg_recv(conn_a, NULL, NULL);
+		if (data =3D=3D BYEBYE_ME)
+			kdbus_cmd_byebye(conn_b->fd, &cmd_byebye);
+		else if (data =3D=3D BYEBYE_THEM)
+			kdbus_cmd_byebye(conn_a->fd, &cmd_byebye);
+	}
+
+	pthread_exit(NULL);
+	return NULL;
+}
+
+int kdbus_test_sync_byebye(struct kdbus_test_env *env)
+{
+	pthread_t thread;
+	int ret;
+
+	/*
+	 * This sends a synchronous message to a thread, which waits until it
+	 * received the message and then invokes BYEBYE on the *ORIGINAL*
+	 * connection. That is, on the same connection that synchronously wai=
ts
+	 * for an reply.
+	 * This should properly wake the connection up and cause ECONNRESET a=
s
+	 * the connection is disconnected now.
+	 *
+	 * The second time, we do the same but invoke BYEBYE on the *TARGET*
+	 * connection. This should also wake up the synchronous sender as the
+	 * reply cannot be sent by a disconnected target.
+	 */
+
+	conn_a =3D kdbus_hello(env->buspath, 0, NULL, 0);
+	conn_b =3D kdbus_hello(env->buspath, 0, NULL, 0);
+	ASSERT_RETURN(conn_a && conn_b);
+
+	pthread_create(&thread, NULL, run_thread_byebye, BYEBYE_ME);
+
+	ret =3D kdbus_msg_send_sync(conn_b, NULL, cookie,
+				  KDBUS_MSG_EXPECT_REPLY,
+				  5000000000ULL, 0, conn_a->id, -1);
+
+	ASSERT_RETURN(ret =3D=3D -ECONNRESET);
+
+	pthread_join(thread, NULL);
+
+	kdbus_conn_free(conn_a);
+	kdbus_conn_free(conn_b);
+
+	conn_a =3D kdbus_hello(env->buspath, 0, NULL, 0);
+	conn_b =3D kdbus_hello(env->buspath, 0, NULL, 0);
+	ASSERT_RETURN(conn_a && conn_b);
+
+	pthread_create(&thread, NULL, run_thread_byebye, BYEBYE_THEM);
+
+	ret =3D kdbus_msg_send_sync(conn_b, NULL, cookie,
+				  KDBUS_MSG_EXPECT_REPLY,
+				  5000000000ULL, 0, conn_a->id, -1);
+
+	ASSERT_RETURN(ret =3D=3D -EPIPE);
+
+	pthread_join(thread, NULL);
+
+	kdbus_conn_free(conn_a);
+	kdbus_conn_free(conn_b);
+
+	return TEST_OK;
+}
diff --git a/tools/testing/selftests/kdbus/test-timeout.c b/tools/testi=
ng/selftests/kdbus/test-timeout.c
new file mode 100644
index 000000000000..cfd193066a64
--- /dev/null
+++ b/tools/testing/selftests/kdbus/test-timeout.c
@@ -0,0 +1,99 @@
+#include <stdio.h>
+#include <string.h>
+#include <time.h>
+#include <fcntl.h>
+#include <stdlib.h>
+#include <stddef.h>
+#include <unistd.h>
+#include <stdint.h>
+#include <errno.h>
+#include <assert.h>
+#include <poll.h>
+#include <stdbool.h>
+
+#include "kdbus-api.h"
+#include "kdbus-test.h"
+#include "kdbus-util.h"
+#include "kdbus-enum.h"
+
+int timeout_msg_recv(struct kdbus_conn *conn, uint64_t *expected)
+{
+	struct kdbus_cmd_recv recv =3D { .size =3D sizeof(recv) };
+	struct kdbus_msg *msg;
+	int ret;
+
+	ret =3D kdbus_cmd_recv(conn->fd, &recv);
+	if (ret < 0) {
+		kdbus_printf("error receiving message: %d (%m)\n", ret);
+		return ret;
+	}
+
+	msg =3D (struct kdbus_msg *)(conn->buf + recv.msg.offset);
+
+	ASSERT_RETURN_VAL(msg->payload_type =3D=3D KDBUS_PAYLOAD_KERNEL, -EIN=
VAL);
+	ASSERT_RETURN_VAL(msg->src_id =3D=3D KDBUS_SRC_ID_KERNEL, -EINVAL);
+	ASSERT_RETURN_VAL(msg->dst_id =3D=3D conn->id, -EINVAL);
+
+	*expected &=3D ~(1ULL << msg->cookie_reply);
+	kdbus_printf("Got message timeout for cookie %llu\n",
+		     msg->cookie_reply);
+
+	ret =3D kdbus_free(conn, recv.msg.offset);
+	if (ret < 0)
+		return ret;
+
+	return 0;
+}
+
+int kdbus_test_timeout(struct kdbus_test_env *env)
+{
+	struct kdbus_conn *conn_a, *conn_b;
+	struct pollfd fd;
+	int ret, i, n_msgs =3D 4;
+	uint64_t expected =3D 0;
+	uint64_t cookie =3D 0xdeadbeef;
+
+	conn_a =3D kdbus_hello(env->buspath, 0, NULL, 0);
+	conn_b =3D kdbus_hello(env->buspath, 0, NULL, 0);
+	ASSERT_RETURN(conn_a && conn_b);
+
+	fd.fd =3D conn_b->fd;
+
+	/*
+	 * send messages that expect a reply (within 100 msec),
+	 * but never answer it.
+	 */
+	for (i =3D 0; i < n_msgs; i++, cookie++) {
+		kdbus_printf("Sending message with cookie %llu ...\n",
+			     (unsigned long long)cookie);
+		ASSERT_RETURN(kdbus_msg_send(conn_b, NULL, cookie,
+			      KDBUS_MSG_EXPECT_REPLY,
+			      (i + 1) * 100ULL * 1000000ULL, 0,
+			      conn_a->id) =3D=3D 0);
+		expected |=3D 1ULL << cookie;
+	}
+
+	for (;;) {
+		fd.events =3D POLLIN | POLLPRI | POLLHUP;
+		fd.revents =3D 0;
+
+		ret =3D poll(&fd, 1, (n_msgs + 1) * 100);
+		if (ret =3D=3D 0)
+			kdbus_printf("--- timeout\n");
+		if (ret <=3D 0)
+			break;
+
+		if (fd.revents & POLLIN)
+			ASSERT_RETURN(!timeout_msg_recv(conn_b, &expected));
+
+		if (expected =3D=3D 0)
+			break;
+	}
+
+	ASSERT_RETURN(expected =3D=3D 0);
+
+	kdbus_conn_free(conn_a);
+	kdbus_conn_free(conn_b);
+
+	return TEST_OK;
+}
--=20
2.3.1
