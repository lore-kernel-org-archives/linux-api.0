From: Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.19 09/29] selftests: fib_rule_tests: use pre-defined DEV_ADDR
Date: Thu, 29 Aug 2019 06:49:49 -0400
Message-ID: <20190829105009.2265-9-sashal@kernel.org>
References: <20190829105009.2265-1-sashal@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20190829105009.2265-1-sashal@kernel.org>
Sender: netdev-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Hangbin Liu <liuhangbin@gmail.com>, David Ahern <dsahern@gmail.com>, "David S . Miller" <davem@davemloft.net>, Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

From: Hangbin Liu <liuhangbin@gmail.com>

[ Upstream commit 34632975cafdd07ce80e85c2eda4e9c16b5f2faa ]

DEV_ADDR is defined but not used. Use it in address setting.
Do the same with IPv6 for consistency.

Reported-by: David Ahern <dsahern@gmail.com>
Fixes: fc82d93e57e3 ("selftests: fib_rule_tests: fix local IPv4 address typo")
Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/net/fib_rule_tests.sh | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/net/fib_rule_tests.sh b/tools/testing/selftests/net/fib_rule_tests.sh
index 1ba069967fa2b..ba2d9fab28d0f 100755
--- a/tools/testing/selftests/net/fib_rule_tests.sh
+++ b/tools/testing/selftests/net/fib_rule_tests.sh
@@ -15,6 +15,7 @@ GW_IP6=2001:db8:1::2
 SRC_IP6=2001:db8:1::3
 
 DEV_ADDR=192.51.100.1
+DEV_ADDR6=2001:db8:1::1
 DEV=dummy0
 
 log_test()
@@ -55,8 +56,8 @@ setup()
 
 	$IP link add dummy0 type dummy
 	$IP link set dev dummy0 up
-	$IP address add 192.51.100.1/24 dev dummy0
-	$IP -6 address add 2001:db8:1::1/64 dev dummy0
+	$IP address add $DEV_ADDR/24 dev dummy0
+	$IP -6 address add $DEV_ADDR6/64 dev dummy0
 
 	set +e
 }
-- 
2.20.1
