From: Chunyan Zhang <zhang.chunyan@linaro.org>
Subject: [PATCH V3 2/6] stm class: Support devices with multiple instances
Date: Sat,  6 Feb 2016 19:04:28 +0800
Message-ID: <1454756672-12790-3-git-send-email-zhang.chunyan@linaro.org>
References: <1454756672-12790-1-git-send-email-zhang.chunyan@linaro.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1454756672-12790-1-git-send-email-zhang.chunyan@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
To: mathieu.poirier@linaro.org, alexander.shishkin@linux.intel.com
Cc: mike.leach@arm.com, Michael.Williams@arm.com, al.grant@arm.com, tor@ti.com, nicolas.guion@st.com, broonie@kernel.org, robh@kernel.org, pratikp@codeaurora.org, corbet@lwn.net, mark.rutland@arm.com, zhang.lyra@gmail.com, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, linux-api@vger.kernel.org, linux-doc@vger.kernel.org
List-Id: linux-api@vger.kernel.org

From: Alexander Shishkin <alexander.shishkin@linux.intel.com>

By convention, the name of the stm policy directory in configfs consists of
the device name to which it applies and the actual policy name, separated
by a dot. Now, some devices already have dots in their names that separate
name of the actual device from its instance identifier. Such devices will
result in two (or more, who can tell) dots in the policy directory name.

Existing policy code, however, will treat the first dot as the one that
separates device name from policy name, therefore failing the above case.

This patch makes the last dot in the directory name be the separator, thus
prohibiting dots from being used in policy names.

Suggested-by: Chunyan Zhang <zhang.chunyan@linaro.org>
Signed-off-by: Alexander Shishkin <alexander.shishkin@linux.intel.com>
---
 drivers/hwtracing/stm/policy.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/hwtracing/stm/policy.c b/drivers/hwtracing/stm/policy.c
index 11ab6d0..17a1416 100644
--- a/drivers/hwtracing/stm/policy.c
+++ b/drivers/hwtracing/stm/policy.c
@@ -320,10 +320,11 @@ stp_policies_make(struct config_group *group, const char *name)
 
 	/*
 	 * node must look like <device_name>.<policy_name>, where
-	 * <device_name> is the name of an existing stm device and
-	 * <policy_name> is an arbitrary string
+	 * <device_name> is the name of an existing stm device; may
+	 *               contain dots;
+	 * <policy_name> is an arbitrary string; may not contain dots
 	 */
-	p = strchr(devname, '.');
+	p = strrchr(devname, '.');
 	if (!p) {
 		kfree(devname);
 		return ERR_PTR(-EINVAL);
-- 
1.9.1
