From: Paul Osmialowski <p.osmialowsk@samsung.com>
Subject: [RFC 7/8] kdbus: selftests extended
Date: Wed, 08 Jul 2015 12:25:09 +0200
Message-ID: <1436351110-5902-8-git-send-email-p.osmialowsk@samsung.com>
References: <1436351110-5902-1-git-send-email-p.osmialowsk@samsung.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-reply-to: <1436351110-5902-1-git-send-email-p.osmialowsk@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Paul Moore <pmoore@redhat.com>, James Morris <james.l.morris@oracle.com>, Casey Schaufler <casey@schaufler-ca.com>, "Serge E. Hallyn" <serge@hallyn.com>, Kees Cook <keescook@chromium.org>, Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>, Stephen Smalley <sds@tycho.nsa.gov>, Neil Brown <neilb@suse.de>, Mark Rustad <mark.d.rustad@intel.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Daniel Mack <daniel@zonque.org>, David Herrmann <dh.herrmann@googlemail.com>, Djalal Harouni <tixxdz@opendz.org>, Shuah Khan <shuahkh@osg.samsung.com>, Al Viro <viro@zeniv.linux.org.uk>, linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org
Cc: Karol Lewandowski <k.lewandowsk@samsung.com>, Paul Osmialowski <p.osmialowsk@samsung.com>, Lukasz Skalski <l.skalski@samsung.com>
List-Id: linux-api@vger.kernel.org

The 'test-send' test case should connect to an already running test-daemon
which creates a bus with known name.

The main goal of this test case is to verify that messages as well as
file descriptors (opened with different open modes) can be transferred
properly.

In order to achieve its goals, this test case opens three files
(/tmp/kdbus-test-send.rd, /tmp/kdbus-test-send.wr,
/tmp/kdbus-test-send.rdwr) with three different open modes (O_RDONLY,
O_WRONLY, O_RDWR). If any of these files exists it is used 'as is',
otherwise it is created with some default content. Then this test tries
to send simple message followed by three messages each one of them
containing an array of opened file descriptors (single element array in the
first message, two element array in the second, three element array in the
third).

The ability to send array of file descriptors required changes in almost
all of the test case files.

Signed-off-by: Karol Lewandowski <k.lewandowsk@samsung.com>
Signed-off-by: Paul Osmialowski <p.osmialowsk@samsung.com>
---
 tools/testing/selftests/kdbus/Makefile           |  1 +
 tools/testing/selftests/kdbus/kdbus-test.c       | 11 +++-
 tools/testing/selftests/kdbus/kdbus-test.h       |  1 +
 tools/testing/selftests/kdbus/kdbus-util.c       | 19 ++++--
 tools/testing/selftests/kdbus/kdbus-util.h       |  2 +-
 tools/testing/selftests/kdbus/test-activator.c   | 20 +++---
 tools/testing/selftests/kdbus/test-chat.c        |  6 +-
 tools/testing/selftests/kdbus/test-connection.c  |  8 ++-
 tools/testing/selftests/kdbus/test-fd.c          |  2 +-
 tools/testing/selftests/kdbus/test-message.c     | 69 +++++++++++--------
 tools/testing/selftests/kdbus/test-metadata-ns.c | 10 +--
 tools/testing/selftests/kdbus/test-monitor.c     |  9 +--
 tools/testing/selftests/kdbus/test-policy-ns.c   |  8 +--
 tools/testing/selftests/kdbus/test-policy-priv.c | 48 ++++++++------
 tools/testing/selftests/kdbus/test-send.c        | 84 ++++++++++++++++++++++++
 tools/testing/selftests/kdbus/test-sync.c        |  2 +-
 tools/testing/selftests/kdbus/test-timeout.c     |  2 +-
 17 files changed, 217 insertions(+), 85 deletions(-)
 create mode 100644 tools/testing/selftests/kdbus/test-send.c

diff --git a/tools/testing/selftests/kdbus/Makefile b/tools/testing/selftests/kdbus/Makefile
index 8f36cb5..f400756 100644
--- a/tools/testing/selftests/kdbus/Makefile
+++ b/tools/testing/selftests/kdbus/Makefile
@@ -27,6 +27,7 @@ OBJS= \
 	test-policy.o		\
 	test-policy-ns.o	\
 	test-policy-priv.o	\
+	test-send.o		\
 	test-sync.o		\
 	test-timeout.o
 
diff --git a/tools/testing/selftests/kdbus/kdbus-test.c b/tools/testing/selftests/kdbus/kdbus-test.c
index d3a656f..5a296da 100644
--- a/tools/testing/selftests/kdbus/kdbus-test.c
+++ b/tools/testing/selftests/kdbus/kdbus-test.c
@@ -25,6 +25,7 @@
 enum {
 	TEST_CREATE_BUS		= 1 << 0,
 	TEST_CREATE_CONN	= 1 << 1,
+	TEST_CREATE_CAN_FAIL	= 1 << 2,
 };
 
 struct kdbus_test {
@@ -148,6 +149,12 @@ static const struct kdbus_test tests[] = {
 		.flags	= TEST_CREATE_BUS,
 	},
 	{
+		.name	= "send",
+		.desc	= "send",
+		.func	= kdbus_test_send,
+		.flags	= TEST_CREATE_CONN | TEST_CREATE_CAN_FAIL,
+	},
+	{
 		.name	= "sync-byebye",
 		.desc	= "synchronous replies vs. BYEBYE",
 		.func	= kdbus_test_sync_byebye,
@@ -302,7 +309,7 @@ static int test_prepare_env(const struct kdbus_test *t,
 				       _KDBUS_ATTACH_ALL,
 				       _KDBUS_ATTACH_ALL, &s);
 		free(n);
-		ASSERT_RETURN(ret == 0);
+		ASSERT_RETURN((ret == 0) || (t->flags & TEST_CREATE_CAN_FAIL));
 
 		asprintf(&env->buspath, "%s/%s/bus", args->root, s);
 		free(s);
@@ -331,7 +338,7 @@ static int test_prepare_env(const struct kdbus_test *t,
 		}
 		ASSERT_RETURN(env->buspath);
 		env->conn = kdbus_hello(env->buspath, 0, NULL, 0);
-		ASSERT_RETURN(env->conn);
+		ASSERT_RETURN(env->conn || (t->flags & TEST_CREATE_CAN_FAIL));
 	}
 
 	env->root = args->root;
diff --git a/tools/testing/selftests/kdbus/kdbus-test.h b/tools/testing/selftests/kdbus/kdbus-test.h
index a5c6ae8..604c25c 100644
--- a/tools/testing/selftests/kdbus/kdbus-test.h
+++ b/tools/testing/selftests/kdbus/kdbus-test.h
@@ -75,6 +75,7 @@ int kdbus_test_name_queue(struct kdbus_test_env *env);
 int kdbus_test_policy(struct kdbus_test_env *env);
 int kdbus_test_policy_ns(struct kdbus_test_env *env);
 int kdbus_test_policy_priv(struct kdbus_test_env *env);
+int kdbus_test_send(struct kdbus_test_env *env);
 int kdbus_test_sync_byebye(struct kdbus_test_env *env);
 int kdbus_test_sync_reply(struct kdbus_test_env *env);
 int kdbus_test_timeout(struct kdbus_test_env *env);
diff --git a/tools/testing/selftests/kdbus/kdbus-util.c b/tools/testing/selftests/kdbus/kdbus-util.c
index 26104ca..622ff5a 100644
--- a/tools/testing/selftests/kdbus/kdbus-util.c
+++ b/tools/testing/selftests/kdbus/kdbus-util.c
@@ -454,7 +454,9 @@ static int __kdbus_msg_send(const struct kdbus_conn *conn,
 			    int64_t priority,
 			    uint64_t dst_id,
 			    uint64_t cmd_flags,
-			    int cancel_fd)
+			    int cancel_fd,
+			    int fds_count,
+			    int fds[])
 {
 	struct kdbus_cmd_send *cmd = NULL;
 	struct kdbus_msg *msg = NULL;
@@ -467,6 +469,7 @@ static int __kdbus_msg_send(const struct kdbus_conn *conn,
 	int ret;
 
 	size = sizeof(*msg) + 3 * KDBUS_ITEM_SIZE(sizeof(struct kdbus_vec));
+	size += fds_count > 0 ? KDBUS_ITEM_SIZE(sizeof(int) * fds_count) : 0;
 
 	if (dst_id == KDBUS_DST_ID_BROADCAST)
 		size += KDBUS_ITEM_SIZE(sizeof(struct kdbus_bloom_filter)) + 64;
@@ -564,6 +567,13 @@ static int __kdbus_msg_send(const struct kdbus_conn *conn,
 	}
 	item = KDBUS_ITEM_NEXT(item);
 
+	if (fds_count > 0) {
+		item->type = KDBUS_ITEM_FDS;
+		item->size = KDBUS_ITEM_HEADER_SIZE + sizeof(int) * fds_count;
+		memcpy(&item->fds, fds, sizeof(int) * fds_count);
+		item = KDBUS_ITEM_NEXT(item);
+	}
+
 	size = sizeof(*cmd);
 	if (cancel_fd != -1)
 		size += KDBUS_ITEM_SIZE(sizeof(cancel_fd));
@@ -620,10 +630,10 @@ out:
 
 int kdbus_msg_send(const struct kdbus_conn *conn, const char *name,
 		   uint64_t cookie, uint64_t flags, uint64_t timeout,
-		   int64_t priority, uint64_t dst_id)
+		   int64_t priority, uint64_t dst_id, int fds_count, int fds[])
 {
 	return __kdbus_msg_send(conn, name, cookie, flags, timeout, priority,
-				dst_id, 0, -1);
+				dst_id, 0, -1, fds_count, fds);
 }
 
 int kdbus_msg_send_sync(const struct kdbus_conn *conn, const char *name,
@@ -631,7 +641,8 @@ int kdbus_msg_send_sync(const struct kdbus_conn *conn, const char *name,
 			int64_t priority, uint64_t dst_id, int cancel_fd)
 {
 	return __kdbus_msg_send(conn, name, cookie, flags, timeout, priority,
-				dst_id, KDBUS_SEND_SYNC_REPLY, cancel_fd);
+				dst_id, KDBUS_SEND_SYNC_REPLY, cancel_fd,
+				0, NULL);
 }
 
 int kdbus_msg_send_reply(const struct kdbus_conn *conn,
diff --git a/tools/testing/selftests/kdbus/kdbus-util.h b/tools/testing/selftests/kdbus/kdbus-util.h
index d1a0f1b..7bb28e6 100644
--- a/tools/testing/selftests/kdbus/kdbus-util.h
+++ b/tools/testing/selftests/kdbus/kdbus-util.h
@@ -172,7 +172,7 @@ int kdbus_create_bus(int control_fd, const char *name,
 		     char **path);
 int kdbus_msg_send(const struct kdbus_conn *conn, const char *name,
 		   uint64_t cookie, uint64_t flags, uint64_t timeout,
-		   int64_t priority, uint64_t dst_id);
+		   int64_t priority, uint64_t dst_id, int fds_count, int fds[]);
 int kdbus_msg_send_sync(const struct kdbus_conn *conn, const char *name,
 			uint64_t cookie, uint64_t flags, uint64_t timeout,
 			int64_t priority, uint64_t dst_id, int cancel_fd);
diff --git a/tools/testing/selftests/kdbus/test-activator.c b/tools/testing/selftests/kdbus/test-activator.c
index 3d1b763..c70fafe 100644
--- a/tools/testing/selftests/kdbus/test-activator.c
+++ b/tools/testing/selftests/kdbus/test-activator.c
@@ -84,13 +84,13 @@ static int kdbus_priv_activator(struct kdbus_test_env *env)
 	ret = RUN_UNPRIVILEGED_CONN(unpriv, env->buspath, ({
 		/* Try to talk using the ID */
 		ret = kdbus_msg_send(unpriv, NULL, 0xdeadbeef, 0, 0,
-				     0, activator->id);
+				     0, activator->id, 0, NULL);
 		ASSERT_EXIT(ret == -ENXIO);
 
 		/* Try to talk to the name */
 		ret = kdbus_msg_send(unpriv, "foo.priv.activator",
 				     0xdeadbeef, 0, 0, 0,
-				     KDBUS_DST_ID_NAME);
+				     KDBUS_DST_ID_NAME, 0, NULL);
 		ASSERT_EXIT(ret == -EPERM);
 	}));
 	ASSERT_RETURN(ret >= 0);
@@ -110,7 +110,7 @@ static int kdbus_priv_activator(struct kdbus_test_env *env)
 
 	cookie++;
 	ret = kdbus_msg_send(service, "foo.priv.activator", cookie,
-			     0, 0, 0, KDBUS_DST_ID_NAME);
+			     0, 0, 0, KDBUS_DST_ID_NAME, 0, NULL);
 	ASSERT_RETURN(ret == 0);
 
 	ret = kdbus_starter_poll(activator);
@@ -141,7 +141,7 @@ static int kdbus_priv_activator(struct kdbus_test_env *env)
 		/* Try to talk to the name */
 		ret = kdbus_msg_send(unpriv, "foo.priv.activator",
 				     cookie, 0, 0, 0,
-				     KDBUS_DST_ID_NAME);
+				     KDBUS_DST_ID_NAME, 0, NULL);
 		ASSERT_EXIT(ret == -EPERM);
 	}));
 	ASSERT_RETURN(ret >= 0);
@@ -155,7 +155,7 @@ static int kdbus_priv_activator(struct kdbus_test_env *env)
 
 	cookie++;
 	ret = kdbus_msg_send(client, "foo.priv.activator", cookie,
-			     0, 0, 0, KDBUS_DST_ID_NAME);
+			     0, 0, 0, KDBUS_DST_ID_NAME, 0, NULL);
 	ASSERT_RETURN(ret == 0);
 	ret = kdbus_msg_recv_poll(service, 100, &msg, NULL);
 	ASSERT_RETURN(ret == 0 && msg->cookie == cookie);
@@ -170,7 +170,8 @@ static int kdbus_priv_activator(struct kdbus_test_env *env)
 		/* Try to talk to the name */
 		ret = kdbus_msg_send(unpriv, "foo.priv.activator",
 				     cookie, 0, 0, 0,
-				     KDBUS_DST_ID_NAME);
+				     KDBUS_DST_ID_NAME,
+				     0, NULL);
 		ASSERT_EXIT(ret == -EPERM);
 	}));
 	ASSERT_RETURN(ret >= 0);
@@ -181,7 +182,7 @@ static int kdbus_priv_activator(struct kdbus_test_env *env)
 	/* Same user is able to TALK */
 	cookie++;
 	ret = kdbus_msg_send(client, "foo.priv.activator", cookie,
-			     0, 0, 0, KDBUS_DST_ID_NAME);
+			     0, 0, 0, KDBUS_DST_ID_NAME, 0, NULL);
 	ASSERT_RETURN(ret == 0);
 	ret = kdbus_msg_recv_poll(service, 100, &msg, NULL);
 	ASSERT_RETURN(ret == 0 && msg->cookie == cookie);
@@ -207,7 +208,8 @@ static int kdbus_priv_activator(struct kdbus_test_env *env)
 		/* Try to talk to the name */
 		ret = kdbus_msg_send(unpriv, "foo.priv.activator",
 				     cookie, 0, 0, 0,
-				     KDBUS_DST_ID_NAME);
+				     KDBUS_DST_ID_NAME,
+				     0, NULL);
 		ASSERT_EXIT(ret == 0);
 	}));
 	ASSERT_RETURN(ret >= 0);
@@ -258,7 +260,7 @@ int kdbus_test_activator(struct kdbus_test_env *env)
 	ASSERT_RETURN(ret == 0);
 
 	ret = kdbus_msg_send(env->conn, "foo.test.activator", 0xdeafbeef,
-			     0, 0, 0, KDBUS_DST_ID_NAME);
+			     0, 0, 0, KDBUS_DST_ID_NAME, 0, NULL);
 	ASSERT_RETURN(ret == 0);
 
 	fds[0].fd = activator->fd;
diff --git a/tools/testing/selftests/kdbus/test-chat.c b/tools/testing/selftests/kdbus/test-chat.c
index 71a92d8..e19f595 100644
--- a/tools/testing/selftests/kdbus/test-chat.c
+++ b/tools/testing/selftests/kdbus/test-chat.c
@@ -64,7 +64,7 @@ int kdbus_test_chat(struct kdbus_test_env *env)
 
 	cookie = 0;
 	ret = kdbus_msg_send(conn_b, NULL, 0xc0000000 | cookie, 0, 0, 0,
-			     KDBUS_DST_ID_BROADCAST);
+			     KDBUS_DST_ID_BROADCAST, 0, NULL);
 	ASSERT_RETURN(ret == 0);
 
 	fds[0].fd = conn_a->fd;
@@ -91,7 +91,7 @@ int kdbus_test_chat(struct kdbus_test_env *env)
 			ASSERT_RETURN(ret == 0);
 			ret = kdbus_msg_send(conn_a, NULL,
 					     0xc0000000 | cookie++,
-					     0, 0, 0, conn_b->id);
+					     0, 0, 0, conn_b->id, 0, NULL);
 			ASSERT_RETURN(ret == 0);
 		}
 
@@ -100,7 +100,7 @@ int kdbus_test_chat(struct kdbus_test_env *env)
 			ASSERT_RETURN(ret == 0);
 			ret = kdbus_msg_send(conn_b, NULL,
 					     0xc0000000 | cookie++,
-					     0, 0, 0, conn_a->id);
+					     0, 0, 0, conn_a->id, 0, NULL);
 			ASSERT_RETURN(ret == 0);
 		}
 
diff --git a/tools/testing/selftests/kdbus/test-connection.c b/tools/testing/selftests/kdbus/test-connection.c
index e7c4866..779166f 100644
--- a/tools/testing/selftests/kdbus/test-connection.c
+++ b/tools/testing/selftests/kdbus/test-connection.c
@@ -127,7 +127,7 @@ int kdbus_test_byebye(struct kdbus_test_env *env)
 
 	/* send over 1st connection */
 	ret = kdbus_msg_send(env->conn, NULL, 0, 0, 0, 0,
-			     KDBUS_DST_ID_BROADCAST);
+			     KDBUS_DST_ID_BROADCAST, 0, NULL);
 	ASSERT_RETURN(ret == 0);
 
 	/* say byebye on the 2nd, which must fail */
@@ -513,7 +513,8 @@ int kdbus_test_conn_update(struct kdbus_test_env *env)
 	conn = kdbus_hello(env->buspath, 0, NULL, 0);
 	ASSERT_RETURN(conn);
 
-	ret = kdbus_msg_send(env->conn, NULL, 0x12345678, 0, 0, 0, conn->id);
+	ret = kdbus_msg_send(env->conn, NULL, 0x12345678, 0, 0, 0, conn->id,
+			     0, NULL);
 	ASSERT_RETURN(ret == 0);
 
 	ret = kdbus_msg_recv(conn, &msg, NULL);
@@ -536,7 +537,8 @@ int kdbus_test_conn_update(struct kdbus_test_env *env)
 					     ~KDBUS_ATTACH_TIMESTAMP);
 	ASSERT_RETURN(ret == 0);
 
-	ret = kdbus_msg_send(env->conn, NULL, 0x12345678, 0, 0, 0, conn->id);
+	ret = kdbus_msg_send(env->conn, NULL, 0x12345678, 0, 0, 0, conn->id,
+			     0, NULL);
 	ASSERT_RETURN(ret == 0);
 
 	ret = kdbus_msg_recv(conn, &msg, NULL);
diff --git a/tools/testing/selftests/kdbus/test-fd.c b/tools/testing/selftests/kdbus/test-fd.c
index 2ae0f5a..bfd8980 100644
--- a/tools/testing/selftests/kdbus/test-fd.c
+++ b/tools/testing/selftests/kdbus/test-fd.c
@@ -466,7 +466,7 @@ static int kdbus_test_no_fds(struct kdbus_test_env *env,
 	 */
 	cookie++;
 	ret = kdbus_msg_send(conn_src, NULL, cookie, 0, 0, 0,
-			     conn_dst->id);
+			     conn_dst->id, 0, NULL);
 	ASSERT_RETURN(ret == 0);
 
 	ret = waitpid(pid, &status, 0);
diff --git a/tools/testing/selftests/kdbus/test-message.c b/tools/testing/selftests/kdbus/test-message.c
index f1615da..d9b8fbd 100644
--- a/tools/testing/selftests/kdbus/test-message.c
+++ b/tools/testing/selftests/kdbus/test-message.c
@@ -51,7 +51,7 @@ int kdbus_test_message_basic(struct kdbus_test_env *env)
 
 	/* send over 1st connection */
 	ret = kdbus_msg_send(sender, NULL, cookie, 0, 0, 0,
-			     KDBUS_DST_ID_BROADCAST);
+			     KDBUS_DST_ID_BROADCAST, 0, NULL);
 	ASSERT_RETURN(ret == 0);
 
 	/* Make sure that we do not get our own broadcasts */
@@ -67,7 +67,7 @@ int kdbus_test_message_basic(struct kdbus_test_env *env)
 
 	/* Msgs that expect a reply must have timeout and cookie */
 	ret = kdbus_msg_send(sender, NULL, 0, KDBUS_MSG_EXPECT_REPLY,
-			     0, 0, conn->id);
+			     0, 0, conn->id, 0, NULL);
 	ASSERT_RETURN(ret == -EINVAL);
 
 	/* Faked replies with a valid reply cookie are rejected */
@@ -123,23 +123,36 @@ int kdbus_test_message_prio(struct kdbus_test_env *env)
 {
 	struct kdbus_conn *a, *b;
 	uint64_t cookie = 0;
+	int ret;
 
 	a = kdbus_hello(env->buspath, 0, NULL, 0);
 	b = kdbus_hello(env->buspath, 0, NULL, 0);
 	ASSERT_RETURN(a && b);
 
-	ASSERT_RETURN(kdbus_msg_send(b, NULL, ++cookie, 0, 0,   25, a->id) == 0);
-	ASSERT_RETURN(kdbus_msg_send(b, NULL, ++cookie, 0, 0, -600, a->id) == 0);
-	ASSERT_RETURN(kdbus_msg_send(b, NULL, ++cookie, 0, 0,   10, a->id) == 0);
-	ASSERT_RETURN(kdbus_msg_send(b, NULL, ++cookie, 0, 0,  -35, a->id) == 0);
-	ASSERT_RETURN(kdbus_msg_send(b, NULL, ++cookie, 0, 0, -100, a->id) == 0);
-	ASSERT_RETURN(kdbus_msg_send(b, NULL, ++cookie, 0, 0,   20, a->id) == 0);
-	ASSERT_RETURN(kdbus_msg_send(b, NULL, ++cookie, 0, 0,  -15, a->id) == 0);
-	ASSERT_RETURN(kdbus_msg_send(b, NULL, ++cookie, 0, 0, -800, a->id) == 0);
-	ASSERT_RETURN(kdbus_msg_send(b, NULL, ++cookie, 0, 0, -150, a->id) == 0);
-	ASSERT_RETURN(kdbus_msg_send(b, NULL, ++cookie, 0, 0,   10, a->id) == 0);
-	ASSERT_RETURN(kdbus_msg_send(b, NULL, ++cookie, 0, 0, -800, a->id) == 0);
-	ASSERT_RETURN(kdbus_msg_send(b, NULL, ++cookie, 0, 0,  -10, a->id) == 0);
+	ret = kdbus_msg_send(b, NULL, ++cookie, 0, 0,   25, a->id, 0, NULL);
+	ASSERT_RETURN(ret == 0);
+	ret = kdbus_msg_send(b, NULL, ++cookie, 0, 0, -600, a->id, 0, NULL);
+	ASSERT_RETURN(ret == 0);
+	ret = kdbus_msg_send(b, NULL, ++cookie, 0, 0,   10, a->id, 0, NULL);
+	ASSERT_RETURN(ret == 0);
+	ret = kdbus_msg_send(b, NULL, ++cookie, 0, 0,  -35, a->id, 0, NULL);
+	ASSERT_RETURN(ret == 0);
+	ret = kdbus_msg_send(b, NULL, ++cookie, 0, 0, -100, a->id, 0, NULL);
+	ASSERT_RETURN(ret == 0);
+	ret = kdbus_msg_send(b, NULL, ++cookie, 0, 0,   20, a->id, 0, NULL);
+	ASSERT_RETURN(ret == 0);
+	ret = kdbus_msg_send(b, NULL, ++cookie, 0, 0,  -15, a->id, 0, NULL);
+	ASSERT_RETURN(ret == 0);
+	ret = kdbus_msg_send(b, NULL, ++cookie, 0, 0, -800, a->id, 0, NULL);
+	ASSERT_RETURN(ret == 0);
+	ret = kdbus_msg_send(b, NULL, ++cookie, 0, 0, -150, a->id, 0, NULL);
+	ASSERT_RETURN(ret == 0);
+	ret = kdbus_msg_send(b, NULL, ++cookie, 0, 0,   10, a->id, 0, NULL);
+	ASSERT_RETURN(ret == 0);
+	ret = kdbus_msg_send(b, NULL, ++cookie, 0, 0, -800, a->id, 0, NULL);
+	ASSERT_RETURN(ret == 0);
+	ret = kdbus_msg_send(b, NULL, ++cookie, 0, 0,  -10, a->id, 0, NULL);
+	ASSERT_RETURN(ret == 0);
 
 	ASSERT_RETURN(msg_recv_prio(a, -200, -800) == 0);
 	ASSERT_RETURN(msg_recv_prio(a, -100, -800) == 0);
@@ -195,7 +208,8 @@ static int kdbus_test_notify_kernel_quota(struct kdbus_test_env *env)
 	 * Now the reader queue is full with kernel notfications,
 	 * but as a user we still have room to push our messages.
 	 */
-	ret = kdbus_msg_send(conn, NULL, 0xdeadbeef, 0, 0, 0, reader->id);
+	ret = kdbus_msg_send(conn, NULL, 0xdeadbeef, 0, 0, 0, reader->id,
+			     0, NULL);
 	ASSERT_RETURN(ret == 0);
 
 	/* More ID kernel notifications that will be lost */
@@ -315,7 +329,8 @@ static int kdbus_test_activator_quota(struct kdbus_test_env *env)
 	for (i = 0; i < KDBUS_CONN_MAX_MSGS; i++) {
 		ret = kdbus_msg_send(sender, "foo.test.activator",
 				     cookie++, 0, 0, 0,
-				     KDBUS_DST_ID_NAME);
+				     KDBUS_DST_ID_NAME,
+				     0, NULL);
 		if (ret < 0)
 			break;
 		activator_msgs_count++;
@@ -328,17 +343,18 @@ static int kdbus_test_activator_quota(struct kdbus_test_env *env)
 	/* Good, activator queue is full now */
 
 	/* ENXIO on direct send (activators can never be addressed by ID) */
-	ret = kdbus_msg_send(conn, NULL, cookie++, 0, 0, 0, activator->id);
+	ret = kdbus_msg_send(conn, NULL, cookie++, 0, 0, 0, activator->id,
+			     0, NULL);
 	ASSERT_RETURN(ret == -ENXIO);
 
 	/* can't queue more */
 	ret = kdbus_msg_send(conn, "foo.test.activator", cookie++,
-			     0, 0, 0, KDBUS_DST_ID_NAME);
+			     0, 0, 0, KDBUS_DST_ID_NAME, 0, NULL);
 	ASSERT_RETURN(ret == -ENOBUFS);
 
 	/* no match installed, so the broadcast will not inc dropped_msgs */
 	ret = kdbus_msg_send(sender, NULL, cookie++, 0, 0, 0,
-			     KDBUS_DST_ID_BROADCAST);
+			     KDBUS_DST_ID_BROADCAST, 0, NULL);
 	ASSERT_RETURN(ret == 0);
 
 	/* Check activator queue */
@@ -357,7 +373,7 @@ static int kdbus_test_activator_quota(struct kdbus_test_env *env)
 	/* Consume the connection pool memory */
 	for (i = 0; i < KDBUS_CONN_MAX_MSGS; i++) {
 		ret = kdbus_msg_send(sender, NULL,
-				     cookie++, 0, 0, 0, conn->id);
+				     cookie++, 0, 0, 0, conn->id, 0, NULL);
 		if (ret < 0)
 			break;
 	}
@@ -424,7 +440,7 @@ static int kdbus_test_activator_quota(struct kdbus_test_env *env)
 
 	/* This one is lost but it is not accounted */
 	ret = kdbus_msg_send(sender, NULL,
-			     cookie++, 0, 0, 0, conn->id);
+			     cookie++, 0, 0, 0, conn->id, 0, NULL);
 	ASSERT_RETURN(ret == -ENOBUFS);
 
 	/* Acquire the name again */
@@ -477,7 +493,8 @@ static int kdbus_test_expected_reply_quota(struct kdbus_test_env *env)
 			ret = kdbus_msg_send(conn, NULL, cookie++,
 					     KDBUS_MSG_EXPECT_REPLY,
 					     100000000ULL, 0,
-					     connections[i]->id);
+					     connections[i]->id,
+					     0, NULL);
 			if (ret < 0)
 				break;
 
@@ -497,7 +514,7 @@ static int kdbus_test_expected_reply_quota(struct kdbus_test_env *env)
 	 * no further requests are allowed
 	 */
 	ret = kdbus_msg_send(conn, NULL, cookie++, KDBUS_MSG_EXPECT_REPLY,
-			     1000000000ULL, 0, connections[8]->id);
+			     1000000000ULL, 0, connections[8]->id, 0, NULL);
 	ASSERT_RETURN(ret == -EMLINK);
 
 	for (i = 0; i < 9; i++)
@@ -575,7 +592,7 @@ int kdbus_test_pool_quota(struct kdbus_test_env *env)
 	ASSERT_RETURN(ret == -ENOBUFS);
 
 	/* We still can pass small messages */
-	ret = kdbus_msg_send(b, NULL, cookie++, 0, 0, 0, c->id);
+	ret = kdbus_msg_send(b, NULL, cookie++, 0, 0, 0, c->id, 0, NULL);
 	ASSERT_RETURN(ret == 0);
 
 	for (i = size; i < (POOL_SIZE / 2 / 3); i += size) {
@@ -630,7 +647,7 @@ int kdbus_test_message_quota(struct kdbus_test_env *env)
 	ret = kdbus_fill_conn_queue(b, a->id, KDBUS_CONN_MAX_MSGS);
 	ASSERT_RETURN(ret == KDBUS_CONN_MAX_MSGS);
 
-	ret = kdbus_msg_send(b, NULL, ++cookie, 0, 0, 0, a->id);
+	ret = kdbus_msg_send(b, NULL, ++cookie, 0, 0, 0, a->id, 0, NULL);
 	ASSERT_RETURN(ret == -ENOBUFS);
 
 	for (i = 0; i < KDBUS_CONN_MAX_MSGS; ++i) {
@@ -644,7 +661,7 @@ int kdbus_test_message_quota(struct kdbus_test_env *env)
 	ret = kdbus_fill_conn_queue(b, a->id, KDBUS_CONN_MAX_MSGS + 1);
 	ASSERT_RETURN(ret == KDBUS_CONN_MAX_MSGS);
 
-	ret = kdbus_msg_send(b, NULL, ++cookie, 0, 0, 0, a->id);
+	ret = kdbus_msg_send(b, NULL, ++cookie, 0, 0, 0, a->id, 0, NULL);
 	ASSERT_RETURN(ret == -ENOBUFS);
 
 	kdbus_conn_free(a);
diff --git a/tools/testing/selftests/kdbus/test-metadata-ns.c b/tools/testing/selftests/kdbus/test-metadata-ns.c
index ccdfae0..4f264ac 100644
--- a/tools/testing/selftests/kdbus/test-metadata-ns.c
+++ b/tools/testing/selftests/kdbus/test-metadata-ns.c
@@ -115,7 +115,7 @@ static int __kdbus_clone_userns_test(const char *bus,
 	 */
 
 	ret = kdbus_msg_send(unpriv_conn, NULL, cookie, 0, 0,
-			     0, conn->id);
+			     0, conn->id, 0, NULL);
 	ASSERT_EXIT(ret == 0);
 
 	/*
@@ -151,7 +151,7 @@ static int __kdbus_clone_userns_test(const char *bus,
 
 		cookie++;
 		ret = kdbus_msg_send(userns_conn, NULL, cookie,
-				     0, 0, 0, conn->id);
+				     0, 0, 0, conn->id, 0, NULL);
 		ASSERT_EXIT(ret == 0);
 
 		/* Parent did send */
@@ -394,7 +394,7 @@ static int kdbus_clone_userns_test(const char *bus,
 	 * Sending to unprivileged connections a unicast
 	 */
 	ret = kdbus_msg_send(conn, NULL, 0xdeadbeef, 0, 0,
-			     0, unpriv_conn_id);
+			     0, unpriv_conn_id, 0, NULL);
 	ASSERT_RETURN(ret == 0);
 
 	/* signal to child that is in its userns */
@@ -406,14 +406,14 @@ static int kdbus_clone_userns_test(const char *bus,
 	 * connections a unicast
 	 */
 	ret = kdbus_msg_send(conn, NULL, 0xdeadbeef, 0, 0,
-			     0, userns_conn_id);
+			     0, userns_conn_id, 0, NULL);
 	ASSERT_RETURN(ret == 0);
 
 	/*
 	 * Sending to unprivileged connections a broadcast
 	 */
 	ret = kdbus_msg_send(conn, NULL, 0xdeadbeef, 0, 0,
-			     0, KDBUS_DST_ID_BROADCAST);
+			     0, KDBUS_DST_ID_BROADCAST, 0, NULL);
 	ASSERT_RETURN(ret == 0);
 
 
diff --git a/tools/testing/selftests/kdbus/test-monitor.c b/tools/testing/selftests/kdbus/test-monitor.c
index e00d738..ae87d87 100644
--- a/tools/testing/selftests/kdbus/test-monitor.c
+++ b/tools/testing/selftests/kdbus/test-monitor.c
@@ -56,7 +56,8 @@ int kdbus_test_monitor(struct kdbus_test_env *env)
 	ret = kdbus_name_acquire(monitor, "foo.bar.baz", NULL);
 	ASSERT_RETURN(ret == -EOPNOTSUPP);
 
-	ret = kdbus_msg_send(env->conn, NULL, cookie, 0, 0,  0, conn->id);
+	ret = kdbus_msg_send(env->conn, NULL, cookie, 0, 0,  0, conn->id,
+			     0, NULL);
 	ASSERT_RETURN(ret == 0);
 
 	/* the recipient should have gotten the message */
@@ -80,7 +81,7 @@ int kdbus_test_monitor(struct kdbus_test_env *env)
 
 	cookie++;
 	ret = kdbus_msg_send(env->conn, NULL, cookie, 0, 0, 0,
-			     KDBUS_DST_ID_BROADCAST);
+			     KDBUS_DST_ID_BROADCAST, 0, NULL);
 	ASSERT_RETURN(ret == 0);
 
 	/* The monitor should get the message. */
@@ -103,7 +104,7 @@ int kdbus_test_monitor(struct kdbus_test_env *env)
 
 	cookie++;
 	ret = kdbus_msg_send(env->conn, NULL, cookie, 0, 0, 0,
-			     KDBUS_DST_ID_BROADCAST);
+			     KDBUS_DST_ID_BROADCAST, 0, NULL);
 	ASSERT_RETURN(ret == 0);
 
 	ret = kdbus_msg_recv_poll(monitor, 100, &msg, &offset);
@@ -128,7 +129,7 @@ int kdbus_test_monitor(struct kdbus_test_env *env)
 
 	cookie++;
 	ret = kdbus_msg_send(env->conn, NULL, cookie, 0, 0, 0,
-			     KDBUS_DST_ID_BROADCAST);
+			     KDBUS_DST_ID_BROADCAST, 0, NULL);
 	ASSERT_RETURN(ret == 0);
 
 	ret = kdbus_msg_recv_poll(monitor, 100, &msg, &offset);
diff --git a/tools/testing/selftests/kdbus/test-policy-ns.c b/tools/testing/selftests/kdbus/test-policy-ns.c
index 3437012..2d70ee4 100644
--- a/tools/testing/selftests/kdbus/test-policy-ns.c
+++ b/tools/testing/selftests/kdbus/test-policy-ns.c
@@ -180,7 +180,7 @@ static int kdbus_recv_in_threads(const char *bus, const char *name,
 			break;
 
 		ret = kdbus_msg_send(conn_db[i], name, cookie++,
-				     0, 0, 0, dst_id);
+				     0, 0, 0, dst_id, 0, NULL);
 		if (ret < 0) {
 			/*
 			 * Receivers are not reading their messages,
@@ -295,7 +295,7 @@ static int kdbus_fork_test_by_id(const char *bus,
 		 * EXIT_FAILURE.
 		 */
 		ret = kdbus_msg_send(conn_src, NULL, cookie,
-				     0, 0, 0, conn_db[0]->id);
+				     0, 0, 0, conn_db[0]->id, 0, NULL);
 		ASSERT_EXIT(ret == child_status);
 
 		ret = kdbus_msg_recv_poll(conn_src, 100, NULL, NULL);
@@ -331,7 +331,7 @@ static int kdbus_fork_test_by_id(const char *bus,
 	}
 
 	ret = kdbus_msg_send(conn_db[0], NULL, ++cookie,
-			     0, 0, 0, msg->src_id);
+			     0, 0, 0, msg->src_id, 0, NULL);
 	/*
 	 * parent_status is checked against send operations,
 	 * on failures always return TEST_ERR.
@@ -454,7 +454,7 @@ static int __kdbus_clone_userns_test(const char *bus,
 		ASSERT_EXIT(ret == 0);
 
 		ret = kdbus_msg_send(conn_src, name, 0xabcd1234,
-				     0, 0, 0, KDBUS_DST_ID_NAME);
+				     0, 0, 0, KDBUS_DST_ID_NAME, 0, NULL);
 		kdbus_conn_free(conn_src);
 
 		_exit(ret == expected_status ? EXIT_SUCCESS : EXIT_FAILURE);
diff --git a/tools/testing/selftests/kdbus/test-policy-priv.c b/tools/testing/selftests/kdbus/test-policy-priv.c
index a318ccc..14a09c6 100644
--- a/tools/testing/selftests/kdbus/test-policy-priv.c
+++ b/tools/testing/selftests/kdbus/test-policy-priv.c
@@ -29,7 +29,7 @@ static int test_policy_priv_by_id(const char *bus,
 	ret = RUN_UNPRIVILEGED_CONN(unpriv, bus, ({
 		ret = kdbus_msg_send(unpriv, NULL,
 				     expected_cookie, 0, 0, 0,
-				     conn_dst->id);
+				     conn_dst->id, 0, NULL);
 		ASSERT_EXIT(ret == child_status);
 	}));
 	ASSERT_RETURN(ret >= 0);
@@ -92,7 +92,8 @@ static int test_policy_priv_by_broadcast(const char *bus,
 
 		/* Use expected_cookie since 'msg' might be NULL */
 		ret = kdbus_msg_send(child, NULL, expected_cookie + 1,
-				     0, 0, 0, KDBUS_DST_ID_BROADCAST);
+				     0, 0, 0, KDBUS_DST_ID_BROADCAST,
+				     0, NULL);
 		ASSERT_EXIT(ret == 0);
 
 		kdbus_msg_free(msg);
@@ -107,7 +108,8 @@ static int test_policy_priv_by_broadcast(const char *bus,
 
 			ret = kdbus_msg_send(child_2, NULL,
 					     expected_cookie, 0, 0, 0,
-					     KDBUS_DST_ID_BROADCAST);
+					     KDBUS_DST_ID_BROADCAST,
+					     0, NULL);
 			ASSERT_RETURN(ret == 0);
 
 			/* Use a little bit high time */
@@ -142,7 +144,8 @@ static int test_policy_priv_by_broadcast(const char *bus,
 
 				ret = kdbus_msg_send(child_2, NULL,
 						expected_cookie, 0, 0, 0,
-						KDBUS_DST_ID_BROADCAST);
+						KDBUS_DST_ID_BROADCAST,
+						0, NULL);
 				ASSERT_EXIT(ret == 0);
 
 				/* Use a little bit high time */
@@ -218,7 +221,8 @@ static int test_priv_before_policy_upload(struct kdbus_test_env *env)
 		ret = kdbus_msg_send(unpriv, NULL, 0xdeadbeef,
 				     KDBUS_MSG_EXPECT_REPLY,
 				     5000000000ULL, 0,
-				     KDBUS_DST_ID_BROADCAST);
+				     KDBUS_DST_ID_BROADCAST,
+				     0, NULL);
 		ASSERT_EXIT(ret == -ENOTUNIQ);
 	}));
 	ASSERT_RETURN(ret == 0);
@@ -405,7 +409,7 @@ static int test_broadcast_after_policy_upload(struct kdbus_test_env *env)
 
 	++expected_cookie;
 	ret = kdbus_msg_send(owner_a, NULL, expected_cookie, 0,
-			     0, 0, KDBUS_DST_ID_BROADCAST);
+			     0, 0, KDBUS_DST_ID_BROADCAST, 0, NULL);
 	ASSERT_RETURN(ret == 0);
 
 	ret = kdbus_msg_recv_poll(owner_b, 100, &msg, NULL);
@@ -499,7 +503,8 @@ static int test_broadcast_after_policy_upload(struct kdbus_test_env *env)
 		ret = kdbus_msg_send(unpriv_owner, NULL,
 				     expected_cookie,
 				     0, 0, 0,
-				     KDBUS_DST_ID_BROADCAST);
+				     KDBUS_DST_ID_BROADCAST,
+				     0, NULL);
 		ASSERT_EXIT(ret == 0);
 
 		/*
@@ -609,7 +614,7 @@ static int test_broadcast_after_policy_upload(struct kdbus_test_env *env)
 					 NULL);
 		ASSERT_EXIT(ret >= 0);
 		ret = kdbus_msg_send(unpriv, NULL, expected_cookie,
-				     0, 0, 0, KDBUS_DST_ID_BROADCAST);
+				     0, 0, 0, KDBUS_DST_ID_BROADCAST, 0, NULL);
 		ASSERT_EXIT(ret == 0);
 	}));
 	ASSERT_RETURN(ret == 0);
@@ -641,7 +646,7 @@ static int test_broadcast_after_policy_upload(struct kdbus_test_env *env)
 					 NULL);
 		ASSERT_EXIT(ret >= 0);
 		ret = kdbus_msg_send(unpriv, NULL, expected_cookie,
-				     0, 0, 0, KDBUS_DST_ID_BROADCAST);
+				     0, 0, 0, KDBUS_DST_ID_BROADCAST, 0, NULL);
 		ASSERT_EXIT(ret == 0);
 	}));
 	ASSERT_RETURN(ret == 0);
@@ -953,7 +958,8 @@ static int test_policy_priv(struct kdbus_test_env *env)
 	conn = kdbus_hello(env->buspath, 0, NULL, 0);
 	ASSERT_RETURN(conn);
 
-	ret = kdbus_msg_send(conn, "com.example.b", 0xdeadbeef, 0, 0, 0, 0);
+	ret = kdbus_msg_send(conn, "com.example.b", 0xdeadbeef, 0, 0, 0, 0,
+			     0, NULL);
 	ASSERT_EXIT(ret >= 0);
 
 	ret = kdbus_msg_recv_poll(conn_b, 300, NULL, NULL);
@@ -967,7 +973,7 @@ static int test_policy_priv(struct kdbus_test_env *env)
 
 	ret = RUN_UNPRIVILEGED_CONN(unpriv, env->buspath, ({
 		ret = kdbus_msg_send(unpriv, "com.example.b", 0xdeadbeef, 0, 0,
-				     0, 0);
+				     0, 0, 0, NULL);
 		ASSERT_EXIT(ret == -EPERM);
 	}));
 	ASSERT_RETURN(ret >= 0);
@@ -996,7 +1002,7 @@ static int test_policy_priv(struct kdbus_test_env *env)
 		ASSERT_EXIT(ret >= 0);
 
 		ret = kdbus_msg_send(unpriv, "com.example.c", 0xdeadbeef, 0, 0,
-				     0, 0);
+				     0, 0, 0, NULL);
 		ASSERT_EXIT(ret >= 0);
 		ret = kdbus_msg_recv_poll(owner, 100, NULL, NULL);
 		ASSERT_EXIT(ret >= 0);
@@ -1021,7 +1027,7 @@ static int test_policy_priv(struct kdbus_test_env *env)
 
 	ret = RUN_UNPRIVILEGED_CONN(unpriv, env->buspath, ({
 		ret = kdbus_msg_send(unpriv, "com.example.b", 0xdeadbeef, 0, 0,
-				     0, 0);
+				     0, 0, 0, NULL);
 		ASSERT_EXIT(ret >= 0);
 	}));
 	ASSERT_RETURN(ret >= 0);
@@ -1045,7 +1051,7 @@ static int test_policy_priv(struct kdbus_test_env *env)
 
 	ret = RUN_UNPRIVILEGED_CONN(unpriv, env->buspath, ({
 		ret = kdbus_msg_send(unpriv, "com.example.b", 0xdeadbeef, 0, 0,
-				     0, 0);
+				     0, 0, 0, NULL);
 		ASSERT_EXIT(ret >= 0);
 	}));
 	ASSERT_RETURN(ret >= 0);
@@ -1069,7 +1075,7 @@ static int test_policy_priv(struct kdbus_test_env *env)
 
 	ret = RUN_UNPRIVILEGED_CONN(unpriv, env->buspath, ({
 		ret = kdbus_msg_send(unpriv, "com.example.b", 0xdeadbeef, 0, 0,
-				     0, 0);
+				     0, 0, 0, NULL);
 		ASSERT_EXIT(ret >= 0);
 	}));
 	ASSERT_RETURN(ret >= 0);
@@ -1116,7 +1122,7 @@ static int test_policy_priv(struct kdbus_test_env *env)
 
 	ret = RUN_UNPRIVILEGED_CONN(unpriv, env->buspath, ({
 		ret = kdbus_msg_send(unpriv, "com.example.b", 0xdeadbeef, 0, 0,
-				     0, 0);
+				     0, 0, 0, NULL);
 		ASSERT_EXIT(ret == -EPERM);
 	}));
 	ASSERT_RETURN(ret >= 0);
@@ -1137,7 +1143,7 @@ static int test_policy_priv(struct kdbus_test_env *env)
 
 	ret = RUN_UNPRIVILEGED_CONN(unpriv, env->buspath, ({
 		ret = kdbus_msg_send(unpriv, "com.example.b", 0xdeadbeef, 0, 0,
-				     0, 0);
+				     0, 0, 0, NULL);
 		ASSERT_EXIT(ret >= 0);
 	}));
 	ASSERT_RETURN(ret >= 0);
@@ -1161,7 +1167,7 @@ static int test_policy_priv(struct kdbus_test_env *env)
 
 	ret = RUN_UNPRIVILEGED_CONN(unpriv, env->buspath, ({
 		ret = kdbus_msg_send(unpriv, "com.example.b", 0xdeadbeef, 0, 0,
-				     0, 0);
+				     0, 0, 0, NULL);
 		ASSERT_EXIT(ret >= 0);
 
 		ret = kdbus_msg_recv_poll(conn_b, 100, NULL, NULL);
@@ -1172,7 +1178,7 @@ static int test_policy_priv(struct kdbus_test_env *env)
 		ASSERT_RETURN(ret == 0);
 
 		ret = kdbus_msg_send(unpriv, "com.example.b", 0xdeadbeef, 0, 0,
-				     0, 0);
+				     0, 0, 0, NULL);
 		ASSERT_EXIT(ret == -EPERM);
 	}));
 	ASSERT_RETURN(ret >= 0);
@@ -1213,7 +1219,7 @@ static int test_policy_priv(struct kdbus_test_env *env)
 		ASSERT_RETURN(unpriv);
 
 		ret = kdbus_msg_send(unpriv, "com.example.c", 0xdeadbeef, 0, 0,
-				     0, 0);
+				     0, 0, 0, NULL);
 		ASSERT_EXIT(ret >= 0);
 
 		ret = kdbus_msg_recv_poll(owner, 100, NULL, NULL);
@@ -1223,7 +1229,7 @@ static int test_policy_priv(struct kdbus_test_env *env)
 		kdbus_conn_free(conn);
 
 		ret = kdbus_msg_send(unpriv, "com.example.c", 0xdeadbeef, 0, 0,
-				     0, 0);
+				     0, 0, 0, NULL);
 		ASSERT_EXIT(ret == -EPERM);
 
 		kdbus_conn_free(unpriv);
diff --git a/tools/testing/selftests/kdbus/test-send.c b/tools/testing/selftests/kdbus/test-send.c
new file mode 100644
index 0000000..9bd8c8f
--- /dev/null
+++ b/tools/testing/selftests/kdbus/test-send.c
@@ -0,0 +1,84 @@
+#include <stdio.h>
+#include <string.h>
+#include <time.h>
+#include <fcntl.h>
+#include <stdlib.h>
+/* Use in conjunction with test-kdbus-daemon */
+
+#include <unistd.h>
+#include <stddef.h>
+#include <stdint.h>
+#include <errno.h>
+#include <assert.h>
+#include <poll.h>
+#include <sys/ioctl.h>
+
+#include "kdbus-test.h"
+#include "kdbus-util.h"
+#include "kdbus-enum.h"
+
+int get_file(const char *fname, int flags, const char *content)
+{
+	FILE *f;
+
+	if (access(fname, F_OK) < 0) {
+		f = fopen(fname, "w");
+		if (!f)
+			return -1;
+		fprintf(f, "%s\n", content);
+		fclose(f);
+	}
+
+	return open(fname, flags);
+}
+
+int kdbus_test_send(struct kdbus_test_env *env)
+{
+	int ret;
+	int serial = 1;
+	int fds[3];
+	size_t i;
+
+	if (!env->conn)
+		return EXIT_FAILURE;
+
+	fds[0] = get_file("/tmp/kdbus-test-send.rd", O_RDONLY, "foo");
+	fds[1] = get_file("/tmp/kdbus-test-send.wr", O_WRONLY, "bar");
+	fds[2] = get_file("/tmp/kdbus-test-send.rdwr", O_RDWR, "baz");
+
+	for (i = 0; i < ELEMENTSOF(fds); i++) {
+		if (fds[i] < 0) {
+			fprintf(stderr, "Unable to open data/fileN file(s)\n");
+			return EXIT_FAILURE;
+		}
+	}
+
+	ret = kdbus_msg_send(env->conn, "com.example.kdbus-test", serial++,
+			     0, 0, 0, 0, 0, NULL);
+	if (ret < 0)
+		fprintf(stderr, "error sending simple message: %d (%m)\n",
+			ret);
+
+	ret = kdbus_msg_send(env->conn, "com.example.kdbus-test", serial++,
+			     0, 0, 0, 0, 1, fds);
+	if (ret < 0)
+		fprintf(stderr, "error sending message with 1 fd: %d (%m)\n",
+			ret);
+
+	ret = kdbus_msg_send(env->conn, "com.example.kdbus-test", serial++,
+			     0, 0, 0, 0, 2, fds);
+	if (ret < 0)
+		fprintf(stderr, "error sending message with 2 fds: %d (%m)\n",
+			ret);
+
+	ret = kdbus_msg_send(env->conn, "com.example.kdbus-test", serial++,
+			     0, 0, 0, 0, 3, fds);
+	if (ret < 0)
+		fprintf(stderr, "error sending message with 3 fds: %d (%m)\n",
+			ret);
+
+	for (i = 0; i < ELEMENTSOF(fds); i++)
+		close(fds[i]);
+
+	return EXIT_SUCCESS;
+}
diff --git a/tools/testing/selftests/kdbus/test-sync.c b/tools/testing/selftests/kdbus/test-sync.c
index e2be910..77c3c41 100644
--- a/tools/testing/selftests/kdbus/test-sync.c
+++ b/tools/testing/selftests/kdbus/test-sync.c
@@ -113,7 +113,7 @@ static int close_epipe_sync(const char *bus)
 	}
 
 	ret = kdbus_msg_send(conn_dst, NULL, cookie, 0, 0, 0,
-			     KDBUS_DST_ID_BROADCAST);
+			     KDBUS_DST_ID_BROADCAST, 0, NULL);
 	ASSERT_RETURN(ret == 0);
 
 	cookie++;
diff --git a/tools/testing/selftests/kdbus/test-timeout.c b/tools/testing/selftests/kdbus/test-timeout.c
index cfd1930..a5cdaf2 100644
--- a/tools/testing/selftests/kdbus/test-timeout.c
+++ b/tools/testing/selftests/kdbus/test-timeout.c
@@ -69,7 +69,7 @@ int kdbus_test_timeout(struct kdbus_test_env *env)
 		ASSERT_RETURN(kdbus_msg_send(conn_b, NULL, cookie,
 			      KDBUS_MSG_EXPECT_REPLY,
 			      (i + 1) * 100ULL * 1000000ULL, 0,
-			      conn_a->id) == 0);
+			      conn_a->id, 0, NULL) == 0);
 		expected |= 1ULL << cookie;
 	}
 
-- 
1.9.1
