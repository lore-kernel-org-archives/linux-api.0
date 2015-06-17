From: Sergei Zviagintsev <sergei@s15v.net>
Subject: [PATCH] selftests/kdbus: fix error paths in __kdbus_msg_send()
Date: Wed, 17 Jun 2015 17:18:17 +0300
Message-ID: <1434550697-24785-5-git-send-email-sergei@s15v.net>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Daniel Mack <daniel@zonque.org>, David Herrmann <dh.herrmann@googlemail.com>, Djalal Harouni <tixxdz@opendz.org>
Cc: Shuah Khan <shuahkh@osg.samsung.com>, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, Sergei Zviagintsev <sergei@s15v.net>
List-Id: linux-api@vger.kernel.org

Handle errors properly, free allocated resources.

Signed-off-by: Sergei Zviagintsev <sergei@s15v.net>
---
 tools/testing/selftests/kdbus/kdbus-util.c | 31 ++++++++++++++++++------------
 1 file changed, 19 insertions(+), 12 deletions(-)

diff --git a/tools/testing/selftests/kdbus/kdbus-util.c b/tools/testing/selftests/kdbus/kdbus-util.c
index ae81da63d810..29a0cb1aace2 100644
--- a/tools/testing/selftests/kdbus/kdbus-util.c
+++ b/tools/testing/selftests/kdbus/kdbus-util.c
@@ -452,8 +452,8 @@ static int __kdbus_msg_send(const struct kdbus_conn *conn,
 			    uint64_t cmd_flags,
 			    int cancel_fd)
 {
-	struct kdbus_cmd_send *cmd;
-	struct kdbus_msg *msg;
+	struct kdbus_cmd_send *cmd = NULL;
+	struct kdbus_msg *msg = NULL;
 	const char ref1[1024 * 128 + 3] = "0123456789_0";
 	const char ref2[] = "0123456789_1";
 	struct kdbus_item *item;
@@ -476,14 +476,14 @@ static int __kdbus_msg_send(const struct kdbus_conn *conn,
 		if (write(memfd, "kdbus memfd 1234567", 19) != 19) {
 			ret = -errno;
 			kdbus_printf("writing to memfd failed: %m\n");
-			return ret;
+			goto out;
 		}
 
 		ret = sys_memfd_seal_set(memfd);
 		if (ret < 0) {
 			ret = -errno;
 			kdbus_printf("memfd sealing failed: %m\n");
-			return ret;
+			goto out;
 		}
 
 		size += KDBUS_ITEM_SIZE(sizeof(struct kdbus_memfd));
@@ -496,7 +496,7 @@ static int __kdbus_msg_send(const struct kdbus_conn *conn,
 	if (!msg) {
 		ret = -errno;
 		kdbus_printf("unable to malloc()!?\n");
-		return ret;
+		goto out;
 	}
 
 	if (dst_id == KDBUS_DST_ID_BROADCAST)
@@ -514,7 +514,7 @@ static int __kdbus_msg_send(const struct kdbus_conn *conn,
 	if (timeout) {
 		ret = clock_gettime(CLOCK_MONOTONIC_COARSE, &now);
 		if (ret < 0)
-			return ret;
+			goto out;
 
 		msg->timeout_ns = now.tv_sec * 1000000000ULL +
 				  now.tv_nsec + timeout;
@@ -565,6 +565,12 @@ static int __kdbus_msg_send(const struct kdbus_conn *conn,
 		size += KDBUS_ITEM_SIZE(sizeof(cancel_fd));
 
 	cmd = malloc(size);
+	if (!cmd) {
+		ret = -errno;
+		kdbus_printf("unable to malloc()!?\n");
+		goto out;
+	}
+
 	cmd->size = size;
 	cmd->flags = cmd_flags;
 	cmd->msg_address = (uintptr_t)msg;
@@ -579,12 +585,9 @@ static int __kdbus_msg_send(const struct kdbus_conn *conn,
 	}
 
 	ret = kdbus_cmd_send(conn->fd, cmd);
-	if (memfd >= 0)
-		close(memfd);
-
 	if (ret < 0) {
 		kdbus_printf("error sending message: %d (%m)\n", ret);
-		return ret;
+		goto out;
 	}
 
 	if (cmd_flags & KDBUS_SEND_SYNC_REPLY) {
@@ -598,13 +601,17 @@ static int __kdbus_msg_send(const struct kdbus_conn *conn,
 
 		ret = kdbus_free(conn, cmd->reply.offset);
 		if (ret < 0)
-			return ret;
+			goto out;
 	}
 
+out:
 	free(msg);
 	free(cmd);
 
-	return 0;
+	if (memfd >= 0)
+		close(memfd);
+
+	return ret < 0 ? ret : 0;
 }
 
 int kdbus_msg_send(const struct kdbus_conn *conn, const char *name,
-- 
1.8.3.1
