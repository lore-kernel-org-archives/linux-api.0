From: Sergei Zviagintsev <sergei@s15v.net>
Subject: [PATCH v2 4/5] selftests/kdbus: drop duplicated code from __kdbus_msg_send()
Date: Wed, 17 Jun 2015 19:33:27 +0300
Message-ID: <1434558808-16129-5-git-send-email-sergei@s15v.net>
References: <1434558808-16129-1-git-send-email-sergei@s15v.net>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1434558808-16129-1-git-send-email-sergei@s15v.net>
Sender: linux-kernel-owner@vger.kernel.org
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Daniel Mack <daniel@zonque.org>, David Herrmann <dh.herrmann@googlemail.com>, Djalal Harouni <tixxdz@opendz.org>
Cc: Shuah Khan <shuahkh@osg.samsung.com>, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, Sergei Zviagintsev <sergei@s15v.net>
List-Id: linux-api@vger.kernel.org

Set value of `size' in one step instead of four.

Signed-off-by: Sergei Zviagintsev <sergei@s15v.net>
---
 tools/testing/selftests/kdbus/kdbus-util.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/tools/testing/selftests/kdbus/kdbus-util.c b/tools/testing/selftests/kdbus/kdbus-util.c
index f9102264cfb9..ae81da63d810 100644
--- a/tools/testing/selftests/kdbus/kdbus-util.c
+++ b/tools/testing/selftests/kdbus/kdbus-util.c
@@ -462,10 +462,7 @@ static int __kdbus_msg_send(const struct kdbus_conn *conn,
 	int memfd = -1;
 	int ret;
 
-	size = sizeof(*msg);
-	size += KDBUS_ITEM_SIZE(sizeof(struct kdbus_vec));
-	size += KDBUS_ITEM_SIZE(sizeof(struct kdbus_vec));
-	size += KDBUS_ITEM_SIZE(sizeof(struct kdbus_vec));
+	size = sizeof(*msg) + 3 * KDBUS_ITEM_SIZE(sizeof(struct kdbus_vec));
 
 	if (dst_id == KDBUS_DST_ID_BROADCAST)
 		size += KDBUS_ITEM_SIZE(sizeof(struct kdbus_bloom_filter)) + 64;
-- 
1.8.3.1
