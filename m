From: Chunyan Zhang <zhang.chunyan-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: [PATCH V4 1/4] stm class: provision for statically assigned masterIDs
Date: Tue,  1 Mar 2016 14:35:06 +0800
Message-ID: <1456814109-21311-2-git-send-email-zhang.chunyan@linaro.org>
References: <1456814109-21311-1-git-send-email-zhang.chunyan@linaro.org>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1456814109-21311-1-git-send-email-zhang.chunyan-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: mathieu.poirier-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, alexander.shishkin-VuQAYsv1563Yd54FQh9/CA@public.gmane.org
Cc: mike.leach-5wv7dgnIgG8@public.gmane.org, Michael.Williams-5wv7dgnIgG8@public.gmane.org, al.grant-5wv7dgnIgG8@public.gmane.org, tor-l0cyMroinI0@public.gmane.org, nicolas.guion-qxv4g6HH51o@public.gmane.org, pratikp-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org, zhang.lyra-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

From: Mathieu Poirier <mathieu.poirier-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>

Some architecture like ARM assign masterIDs at the HW design
phase.  Those are therefore unreachable to users, making masterID
management in the generic STM core irrelevant.

In this kind of configuration channels are shared between masters
rather than being allocated on a per master basis.

This patch adds a new 'mshared' flag to struct stm_data that tells the
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

Signed-off-by: Mathieu Poirier <mathieu.poirier-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Signed-off-by: Chunyan Zhang <zhang.chunyan-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
---
 drivers/hwtracing/stm/core.c   | 18 ++++++++++++++++--
 drivers/hwtracing/stm/policy.c | 18 ++++++++++++++++--
 include/linux/stm.h            |  8 ++++++++
 3 files changed, 40 insertions(+), 4 deletions(-)

diff --git a/drivers/hwtracing/stm/core.c b/drivers/hwtracing/stm/core.c
index b6445d9..7f71d54 100644
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
+	if (stm->data->mshared)
+		sw_start = sw_end = STM_SHARED_MASTERID;
+
+	ret = sprintf(buf, "%d %d\n", sw_start, sw_end);
 
 	return ret;
 }
@@ -618,7 +624,15 @@ int stm_register_device(struct device *parent, struct stm_data *stm_data,
 	if (!stm_data->packet || !stm_data->sw_nchannels)
 		return -EINVAL;
 
+	/*
+	 * MasterIDs are assigned at HW design phase. As such the core is
+	 * using a single master for interaction with this device.
+	 */
+	if (stm_data->mshared)
+		stm_data->sw_start = stm_data->sw_end = 1;
+
 	nmasters = stm_data->sw_end - stm_data->sw_start;
+
 	stm = kzalloc(sizeof(*stm) + nmasters * sizeof(void *), GFP_KERNEL);
 	if (!stm)
 		return -ENOMEM;
diff --git a/drivers/hwtracing/stm/policy.c b/drivers/hwtracing/stm/policy.c
index 17a1416..19455db 100644
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
+	if (stm && stm->data->mshared)
+		first_master = last_master = STM_SHARED_MASTERID;
+
+	count = sprintf(page, "%d %d\n", first_master, last_master);
 
 	return count;
 }
@@ -106,6 +113,13 @@ stp_policy_node_masters_store(struct config_item *item, const char *page,
 	if (!stm)
 		goto unlock;
 
+	/*
+	 * masterIDs are allocated in HW, no point in trying to
+	 * change their values.
+	 */
+	if (stm->data->mshared)
+		goto unlock;
+
 	/* must be within [sw_start..sw_end], which is an inclusive range */
 	if (first > INT_MAX || last > INT_MAX || first > last ||
 	    first < stm->data->sw_start ||
diff --git a/include/linux/stm.h b/include/linux/stm.h
index 9d0083d..6fac8b1 100644
--- a/include/linux/stm.h
+++ b/include/linux/stm.h
@@ -18,6 +18,11 @@
 #include <linux/device.h>
 
 /**
+ * The masterIDs are set in hardware and can't be queried
+ */
+#define STM_SHARED_MASTERID -1
+
+/**
  * enum stp_packet_type - STP packets that an STM driver sends
  */
 enum stp_packet_type {
@@ -46,6 +51,8 @@ struct stm_device;
  * struct stm_data - STM device description and callbacks
  * @name:		device name
  * @stm:		internal structure, only used by stm class code
+ * @mshared:		true if masterIDs are assigned in HW.  If so @sw_start
+ *			and @sw_end are set to '1' by the core.
  * @sw_start:		first STP master available to software
  * @sw_end:		last STP master available to software
  * @sw_nchannels:	number of STP channels per master
@@ -71,6 +78,7 @@ struct stm_device;
 struct stm_data {
 	const char		*name;
 	struct stm_device	*stm;
+	bool			mshared;
 	unsigned int		sw_start;
 	unsigned int		sw_end;
 	unsigned int		sw_nchannels;
-- 
1.9.1
