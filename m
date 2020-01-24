From: Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.4 077/107] selftests: mlxsw: qos_mc_aware: Fix mausezahn invocation
Date: Fri, 24 Jan 2020 09:17:47 -0500
Message-ID: <20200124141817.28793-77-sashal@kernel.org>
References: <20200124141817.28793-1-sashal@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20200124141817.28793-1-sashal@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Petr Machata <petrm@mellanox.com>, Amit Cohen <amitc@mellanox.com>, Ido Schimmel <idosch@mellanox.com>, "David S . Miller" <davem@davemloft.net>, Sasha Levin <sashal@kernel.org>, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

From: Petr Machata <petrm@mellanox.com>

[ Upstream commit fef6d6704944c7be72fd2b77c021f1aed3d5df0d ]

Mausezahn does not recognize "own" as a keyword on source IP address. As a
result, the MC stream is not running at all, and therefore no UC
degradation can be observed even in principle.

Fix the invocation, and tighten the test: due to the minimum shaper
configured at the MC TCs, we always expect about 20% degradation. Fail the
test if it is lower.

Fixes: 573363a68f27 ("selftests: mlxsw: Add qos_lib.sh")
Signed-off-by: Petr Machata <petrm@mellanox.com>
Reported-by: Amit Cohen <amitc@mellanox.com>
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/drivers/net/mlxsw/qos_mc_aware.sh | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/drivers/net/mlxsw/qos_mc_aware.sh b/tools/testing/selftests/drivers/net/mlxsw/qos_mc_aware.sh
index 47315fe48d5af..24dd8ed485802 100755
--- a/tools/testing/selftests/drivers/net/mlxsw/qos_mc_aware.sh
+++ b/tools/testing/selftests/drivers/net/mlxsw/qos_mc_aware.sh
@@ -232,7 +232,7 @@ test_mc_aware()
 	stop_traffic
 	local ucth1=${uc_rate[1]}
 
-	start_traffic $h1 own bc bc
+	start_traffic $h1 192.0.2.65 bc bc
 
 	local d0=$(date +%s)
 	local t0=$(ethtool_stats_get $h3 rx_octets_prio_0)
@@ -254,7 +254,11 @@ test_mc_aware()
 			ret = 100 * ($ucth1 - $ucth2) / $ucth1
 			if (ret > 0) { ret } else { 0 }
 		    ")
-	check_err $(bc <<< "$deg > 25")
+
+	# Minimum shaper of 200Mbps on MC TCs should cause about 20% of
+	# degradation on 1Gbps link.
+	check_err $(bc <<< "$deg < 15") "Minimum shaper not in effect"
+	check_err $(bc <<< "$deg > 25") "MC traffic degrades UC performance too much"
 
 	local interval=$((d1 - d0))
 	local mc_ir=$(rate $u0 $u1 $interval)
-- 
2.20.1
