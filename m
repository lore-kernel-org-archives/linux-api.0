From: Sergei Zviagintsev <sergei-E844GTqJAzo@public.gmane.org>
Subject: [PATCH] selftests/kdbus: drop duplicated code from __kdbus_msg_send()
Date: Wed, 17 Jun 2015 17:18:16 +0300
Message-ID: <1434550697-24785-4-git-send-email-sergei@s15v.net>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Daniel Mack <daniel-cYrQPVfZoowdnm+yROfE0A@public.gmane.org>, David Herrmann <dh.herrmann-gM/Ye1E23mwN+BqQ9rBEUg@public.gmane.org>, Djalal Harouni <tixxdz-Umm1ozX2/EEdnm+yROfE0A@public.gmane.org>
Cc: Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Sergei Zviagintsev <sergei-E844GTqJAzo@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Set value of `size' in one step instead of four.

Signed-off-by: Sergei Zviagintsev <sergei-E844GTqJAzo@public.gmane.org>
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
