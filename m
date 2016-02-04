From: Chunyan Zhang <zhang.chunyan@linaro.org>
Subject: [PATCH V2 2/6] stm class: adds a loop to extract the first valid STM device name
Date: Thu,  4 Feb 2016 16:56:19 +0800
Message-ID: <1454576179-27224-1-git-send-email-zhang.chunyan@linaro.org>
References: <1454487337-30184-3-git-send-email-zhang.chunyan@linaro.org>
Return-path: <linux-doc-owner@vger.kernel.org>
In-Reply-To: <1454487337-30184-3-git-send-email-zhang.chunyan@linaro.org>
Sender: linux-doc-owner@vger.kernel.org
To: mathieu.poirier@linaro.org, alexander.shishkin@linux.intel.com
Cc: robh@kernel.org, broonie@kernel.org, pratikp@codeaurora.org, nicolas.guion@st.com, corbet@lwn.net, mark.rutland@arm.com, mike.leach@arm.com, tor@ti.com, al.grant@arm.com, zhang.lyra@gmail.com, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, linux-api@vger.kernel.org, linux-doc@vger.kernel.org
List-Id: linux-api@vger.kernel.org

The node name of STM master management policy is a concatenation of an
STM device name to which this policy applies and following an arbitrary
string, these two strings are concatenated with a dot.

This patch adds a loop for extracting the STM device name when an
arbitrary number of dot(s) are found in this STM device name.

Signed-off-by: Chunyan Zhang <zhang.chunyan@linaro.org>
---
 drivers/hwtracing/stm/policy.c | 27 ++++++++++++++++-----------
 1 file changed, 16 insertions(+), 11 deletions(-)

diff --git a/drivers/hwtracing/stm/policy.c b/drivers/hwtracing/stm/policy.c
index 11ab6d0..691686e 100644
--- a/drivers/hwtracing/stm/policy.c
+++ b/drivers/hwtracing/stm/policy.c
@@ -321,21 +321,26 @@ stp_policies_make(struct config_group *group, const char *name)
 	/*
 	 * node must look like <device_name>.<policy_name>, where
 	 * <device_name> is the name of an existing stm device and
-	 * <policy_name> is an arbitrary string
+	 * <policy_name> is an arbitrary string, when an arbitrary
+	 * number of dot(s) are found in the <device_name>, the
+	 * first matched STM device name would be extracted.
 	 */
-	p = strchr(devname, '.');
-	if (!p) {
-		kfree(devname);
-		return ERR_PTR(-EINVAL);
-	}
+	for (p = devname; ; p++) {
+		p = strchr(p, '.');
+		if (!p) {
+			kfree(devname);
+			return ERR_PTR(-EINVAL);
+		}
 
-	*p++ = '\0';
+		*p = '\0';
 
-	stm = stm_find_device(devname);
-	kfree(devname);
+		stm = stm_find_device(devname);
+		if (stm)
+			break;
+		*p = '.';
+	}
 
-	if (!stm)
-		return ERR_PTR(-ENODEV);
+	kfree(devname);
 
 	mutex_lock(&stm->policy_mutex);
 	if (stm->policy) {
-- 
1.9.1

