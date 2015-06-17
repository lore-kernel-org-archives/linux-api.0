From: Sergei Zviagintsev <sergei@s15v.net>
Subject: [PATCH] selftests/kdbus: handle cap_get_proc() error properly
Date: Wed, 17 Jun 2015 17:18:13 +0300
Message-ID: <1434550697-24785-1-git-send-email-sergei@s15v.net>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Daniel Mack <daniel@zonque.org>, David Herrmann <dh.herrmann@googlemail.com>, Djalal Harouni <tixxdz@opendz.org>
Cc: Shuah Khan <shuahkh@osg.samsung.com>, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, Sergei Zviagintsev <sergei@s15v.net>
List-Id: linux-api@vger.kernel.org

Fix typo in checking error value of cap_get_proc(): cap -> caps

Signed-off-by: Sergei Zviagintsev <sergei@s15v.net>
---
 tools/testing/selftests/kdbus/kdbus-util.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/kdbus/kdbus-util.c b/tools/testing/selftests/kdbus/kdbus-util.c
index 1e267d585a14..a3e49b04f3a7 100644
--- a/tools/testing/selftests/kdbus/kdbus-util.c
+++ b/tools/testing/selftests/kdbus/kdbus-util.c
@@ -1547,7 +1547,7 @@ int test_is_capable(int cap, ...)
 	cap_t caps;
 
 	caps = cap_get_proc();
-	if (!cap) {
+	if (!caps) {
 		ret = -errno;
 		kdbus_printf("error cap_get_proc(): %d (%m)\n", ret);
 		return ret;
-- 
1.8.3.1
