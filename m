From: Maninder Singh <maninder1.s@samsung.com>
Subject: [PATCH 1/1] selftest/net: fix protocol family to work for IPv4.
Date: Thu,  2 Aug 2018 15:27:27 +0530
Message-ID: <20180802100201epcas5p390bb362ccabaa99087eff88af37bffb2~HCQZjTEZd0101301013epcas5p3C@epcas5p3.samsung.com>
References: <CGME20180802100201epcas5p390bb362ccabaa99087eff88af37bffb2@epcas5p3.samsung.com>
Content-Type: text/plain; charset="utf-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: davem@davemloft.net, shuahkh@osg.samsung.com
Cc: netdev@vger.kernel.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, edumazet@google.com, pankaj.m@samsung.com, a.sahrawat@samsung.com, Maninder Singh <maninder1.s@samsung.com>, Vaneet Narang <v.narang@samsung.com>
List-Id: linux-api@vger.kernel.org

use actual protocol family passed by user rather than hardcoded
AF_INTE6 to cerate sockets.
current code is not working for IPv4.

Signed-off-by: Maninder Singh <maninder1.s@samsung.com>
Signed-off-by: Vaneet Narang <v.narang@samsung.com>
---
 tools/testing/selftests/net/tcp_mmap.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/net/tcp_mmap.c b/tools/testing/selftests/net/tcp_mmap.c
index 77f7627..e8c5dff 100644
--- a/tools/testing/selftests/net/tcp_mmap.c
+++ b/tools/testing/selftests/net/tcp_mmap.c
@@ -402,7 +402,7 @@ int main(int argc, char *argv[])
 		exit(1);
 	}
 
-	fd = socket(AF_INET6, SOCK_STREAM, 0);
+	fd = socket(cfg_family, SOCK_STREAM, 0);
 	if (fd == -1) {
 		perror("socket");
 		exit(1);
-- 
1.9.1
