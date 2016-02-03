From: Chunyan Zhang <zhang.chunyan@linaro.org>
Subject: [PATCH V2 3/6] stm class: provision for statically assigned masterIDs
Date: Wed,  3 Feb 2016 16:15:34 +0800
Message-ID: <1454487337-30184-4-git-send-email-zhang.chunyan@linaro.org>
References: <1454487337-30184-1-git-send-email-zhang.chunyan@linaro.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1454487337-30184-1-git-send-email-zhang.chunyan@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
To: mathieu.poirier@linaro.org, alexander.shishkin@linux.intel.com
Cc: robh@kernel.org, broonie@kernel.org, pratikp@codeaurora.org, nicolas.guion@st.com, corbet@lwn.net, mark.rutland@arm.com, mike.leach@arm.com, tor@ti.com, al.grant@arm.com, zhang.lyra@gmail.com, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, linux-api@vger.kernel.org, linux-doc@vger.kernel.org
List-Id: linux-api@vger.kernel.org

From: Mathieu Poirier <mathieu.poirier@linaro.org>

Some architecture like ARM assign masterIDs statically at the HW design
phase, making masterID manipulation in the generic STM core irrelevant.

This patch adds a new 'mstatic' flag to struct stm_data that tells the
core that this specific STM device doesn't need explicit masterID
management.  In the core sw_start/end of masterID are set to '1',
i.e there is only one masterID to deal with.

Also this patch depends on [1], so that the number of masterID
is '1' too.

Finally the lower and upper bound for masterIDs as presented
in ($SYSFS)/class/stm/XYZ.stm/masters and
($SYSFS)/../stp-policy/XYZ.stm.my_policy/some_device/masters
are set to '-1'.  That way users can't confuse them with
architecture where masterID management is required (where any
other value would be valid).

[1] https://lkml.org/lkml/2015/12/22/348

Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
Signed-off-by: Chunyan Zhang <zhang.chunyan@linaro.org>
---
 drivers/hwtracing/stm/core.c   | 18 ++++++++++++++++--
 drivers/hwtracing/stm/policy.c | 19 +++++++++++++++++--
 include/linux/stm.h            |  8 ++++++++
 3 files changed, 41 insertions(+), 4 deletions(-)

diff --git a/drivers/hwtracing/stm/core.c b/drivers/hwtracing/stm/core.c
index 86bb4e3..cd3dc19 100644
--- a/drivers/hwtracing/stm/core.c
+++ b/drivers/hwtracing/stm/core.c
@@ -44,9 +44,15 @@ static ssize_t masters_show(struct device *dev,
 			    char *buf)
 {
 	struct stm_device *stm = to_stm_device(dev);
-	int ret;
+	int ret, sw_start, sw_end;
+
+	sw_start = stm->data->sw_start;
+	sw_end = stm->data->sw_end;
 
-	ret = sprintf(buf, "%u %u\n", stm->data->sw_start, stm->data->sw_end);
+	if (stm->data->mstatic)
+		sw_start = sw_end = STM_STATIC_MASTERID;
+
+	ret = sprintf(buf, "%d %d\n", sw_start, sw_end);
 
 	return ret;
 }
@@ -629,7 +635,15 @@ int stm_register_device(struct device *parent, struct stm_data *stm_data,
 	if (!stm_data->packet || !stm_data->sw_nchannels)
 		return -EINVAL;
 
+	/*
+	 * MasterIDs are statically set in HW. As such the core is
+	 * using a single master for interaction with this device.
+	 */
+	if (stm_data->mstatic)
+		stm_data->sw_start = stm_data->sw_end = 1;
+
 	nmasters = stm_data->sw_end - stm_data->sw_start;
+
 	stm = kzalloc(sizeof(*stm) + nmasters * sizeof(void *), GFP_KERNEL);
 	if (!stm)
 		return -ENOMEM;
diff --git a/drivers/hwtracing/stm/policy.c b/drivers/hwtracing/stm/policy.c
index 691686e..7e70ca2 100644
--- a/drivers/hwtracing/stm/policy.c
+++ b/drivers/hwtracing/stm/policy.c
@@ -80,10 +80,17 @@ static ssize_t
 stp_policy_node_masters_show(struct config_item *item, char *page)
 {
 	struct stp_policy_node *policy_node = to_stp_policy_node(item);
+	struct stm_device *stm = policy_node->policy->stm;
+	int first_master, last_master;
 	ssize_t count;
 
-	count = sprintf(page, "%u %u\n", policy_node->first_master,
-			policy_node->last_master);
+	first_master = policy_node->first_master;
+	last_master = policy_node->last_master;
+
+	if (stm && stm->data->mstatic)
+		first_master = last_master = STM_STATIC_MASTERID;
+
+	count = sprintf(page, "%d %d\n", first_master, last_master);
 
 	return count;
 }
@@ -106,6 +113,13 @@ stp_policy_node_masters_store(struct config_item *item, const char *page,
 	if (!stm)
 		goto unlock;
 
+	/*
+	 * masterIDs are statically allocated in HW, no point in trying to
+	 * change their values.
+	 */
+	if (stm->data->mstatic)
+		goto unlock;
+
 	/* must be within [sw_start..sw_end], which is an inclusive range */
 	if (first > INT_MAX || last > INT_MAX || first > last ||
 	    first < stm->data->sw_start ||
@@ -325,6 +339,7 @@ stp_policies_make(struct config_group *group, const char *name)
 	 * number of dot(s) are found in the <device_name>, the
 	 * first matched STM device name would be extracted.
 	 */
+
 	for (p = devname; ; p++) {
 		p = strchr(p, '.');
 		if (!p) {
diff --git a/include/linux/stm.h b/include/linux/stm.h
index f351d62..c9712a7 100644
--- a/include/linux/stm.h
+++ b/include/linux/stm.h
@@ -18,6 +18,11 @@
 #include <linux/device.h>
 
 /**
+ * The masterIDs are statically set in hardware and can't be queried
+ */
+#define STM_STATIC_MASTERID -1
+
+/**
  * enum stp_packet_type - STP packets that an STM driver sends
  */
 enum stp_packet_type {
@@ -46,6 +51,8 @@ struct stm_device;
  * struct stm_data - STM device description and callbacks
  * @name:		device name
  * @stm:		internal structure, only used by stm class code
+ * @mstatic:		true if masterIDs are assigned in HW.  If so @sw_start
+ *			and @sw_end are set to '1' by the core.
  * @sw_start:		first STP master available to software
  * @sw_end:		last STP master available to software
  * @sw_nchannels:	number of STP channels per master
@@ -71,6 +78,7 @@ struct stm_device;
 struct stm_data {
 	const char		*name;
 	struct stm_device	*stm;
+	bool			mstatic;
 	unsigned int		sw_start;
 	unsigned int		sw_end;
 	unsigned int		sw_nchannels;
-- 
1.9.1
