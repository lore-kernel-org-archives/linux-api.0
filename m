From: Sergei Zviagintsev <sergei-E844GTqJAzo@public.gmane.org>
Subject: [PATCH] selftests/kdbus: remove useless initializations from kdbus_clone_userns_test()
Date: Wed, 17 Jun 2015 17:18:15 +0300
Message-ID: <1434550697-24785-3-git-send-email-sergei@s15v.net>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Daniel Mack <daniel-cYrQPVfZoowdnm+yROfE0A@public.gmane.org>, David Herrmann <dh.herrmann-gM/Ye1E23mwN+BqQ9rBEUg@public.gmane.org>, Djalal Harouni <tixxdz-Umm1ozX2/EEdnm+yROfE0A@public.gmane.org>
Cc: Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Sergei Zviagintsev <sergei-E844GTqJAzo@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Do not initialize efd, unpriv_conn_id, userns_conn_id and monitor. These
vars are assigned to values later in code while initial values are never
used.

Signed-off-by: Sergei Zviagintsev <sergei-E844GTqJAzo@public.gmane.org>
---
 tools/testing/selftests/kdbus/test-metadata-ns.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/tools/testing/selftests/kdbus/test-metadata-ns.c b/tools/testing/selftests/kdbus/test-metadata-ns.c
index 2cb1d4d2a5be..ccdfae06922b 100644
--- a/tools/testing/selftests/kdbus/test-metadata-ns.c
+++ b/tools/testing/selftests/kdbus/test-metadata-ns.c
@@ -281,16 +281,13 @@ out:
 static int kdbus_clone_userns_test(const char *bus,
 				   struct kdbus_conn *conn)
 {
-	int ret;
-	int status;
-	int efd = -1;
+	int ret, status, efd;
 	pid_t pid, ppid;
-	uint64_t unpriv_conn_id = 0;
-	uint64_t userns_conn_id = 0;
+	uint64_t unpriv_conn_id, userns_conn_id;
 	struct kdbus_msg *msg;
 	const struct kdbus_item *item;
 	struct kdbus_pids expected_pids;
-	struct kdbus_conn *monitor = NULL;
+	struct kdbus_conn *monitor;
 
 	kdbus_printf("STARTING TEST 'metadata-ns'.\n");
 
-- 
1.8.3.1
