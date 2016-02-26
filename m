From: Shilpasri G Bhat <shilpa.bhat-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Subject: [PATCH v10 2/2] cpufreq: powernv: Add sysfs attributes to show throttle stats
Date: Fri, 26 Feb 2016 16:06:52 +0530
Message-ID: <1456483012-29466-3-git-send-email-shilpa.bhat@linux.vnet.ibm.com>
References: <1456483012-29466-1-git-send-email-shilpa.bhat@linux.vnet.ibm.com>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1456483012-29466-1-git-send-email-shilpa.bhat-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linuxppc-dev-mnsaURCQ41sdnm+yROfE0A@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: rjw-LthD3rsA81gm4RdzfppkhA@public.gmane.org, viresh.kumar-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, linux-pm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, ego-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org, shreyas-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org, Shilpasri G Bhat <shilpa.bhat-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

Create sysfs attributes to export throttle information in
/sys/devices/system/cpu/cpuX/cpufreq/throttle_stats directory. The
newly added sysfs files are as follows:

1)/sys/devices/system/cpu/cpuX/cpufreq/throttle_stats/turbo_stat
2)/sys/devices/system/cpu/cpuX/cpufreq/throttle_stats/sub-turbo_stat
3)/sys/devices/system/cpu/cpuX/cpufreq/throttle_stats/unthrottle
4)/sys/devices/system/cpu/cpuX/cpufreq/throttle_stats/powercap
5)/sys/devices/system/cpu/cpuX/cpufreq/throttle_stats/overtemp
6)/sys/devices/system/cpu/cpuX/cpufreq/throttle_stats/supply_fault
7)/sys/devices/system/cpu/cpuX/cpufreq/throttle_stats/overcurrent
8)/sys/devices/system/cpu/cpuX/cpufreq/throttle_stats/occ_reset

Detailed explanation of each attribute is added to
Documentation/ABI/testing/sysfs-devices-system-cpu

CC: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Signed-off-by: Shilpasri G Bhat <shilpa.bhat-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
---
Changes from v9:
- Modified documentation.
- s/throttle_nominal/throttle_sub_turbo

Changes from v8:
- Moved the sysfs attributes from cpu/cpufreq/chipX to cpuX/cpufreq/throttle_stats
- Adhering to one-value-per-file, replace throttle_table with multiple
  sysfs files.
- Using CPUFREQ_POLICY_NOTIFIER to add/remove attribute_group.

 Documentation/ABI/testing/sysfs-devices-system-cpu |  69 +++++++++++
 drivers/cpufreq/powernv-cpufreq.c                  | 127 +++++++++++++++++++--
 2 files changed, 187 insertions(+), 9 deletions(-)

diff --git a/Documentation/ABI/testing/sysfs-devices-system-cpu b/Documentation/ABI/testing/sysfs-devices-system-cpu
index b683e8e..eaa2c87 100644
--- a/Documentation/ABI/testing/sysfs-devices-system-cpu
+++ b/Documentation/ABI/testing/sysfs-devices-system-cpu
@@ -271,3 +271,72 @@ Description:	Parameters for the CPU cache attributes
 			- WriteBack: data is written only to the cache line and
 				     the modified cache line is written to main
 				     memory only when it is replaced
+
+What:		/sys/devices/system/cpu/cpuX/cpufreq/throttle_stats
+		/sys/devices/system/cpu/cpuX/cpufreq/throttle_stats/turbo_stat
+		/sys/devices/system/cpu/cpuX/cpufreq/throttle_stats/sub_turbo_stat
+		/sys/devices/system/cpu/cpuX/cpufreq/throttle_stats/unthrottle
+		/sys/devices/system/cpu/cpuX/cpufreq/throttle_stats/powercap
+		/sys/devices/system/cpu/cpuX/cpufreq/throttle_stats/overtemp
+		/sys/devices/system/cpu/cpuX/cpufreq/throttle_stats/supply_fault
+		/sys/devices/system/cpu/cpuX/cpufreq/throttle_stats/overcurrent
+		/sys/devices/system/cpu/cpuX/cpufreq/throttle_stats/occ_reset
+Date:		Feb 2016
+Contact:	Linux kernel mailing list <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
+		Linux for PowerPC mailing list <linuxppc-dev-mnsaURCQ41sdnm+yROfE0A@public.gmane.org>
+Description:	POWERNV CPUFreq driver's frequency throttle stats directory and
+		attributes
+
+		'cpuX/cpufreq/throttle_stats' directory contains the CPU frequency
+		throttle stat attributes for the chip. The throttle stats of a cpu
+		is common across all the cpus belonging to a chip. Below are the
+		throttle attributes exported in the 'throttle_stats' directory:
+
+		- turbo_stat : This file gives the total number of times the max
+		frequency is throttled to lower frequency in turbo (at and above
+		nominal frequency) range of frequencies.
+
+		- sub_turbo_stat : This file gives the total number of times the
+		max frequency is throttled to lower frequency in sub-turbo(below
+		nominal frequency) range of frequencies.
+
+		- unthrottle : This file gives the total number of times the max
+		frequency is unthrottled after being throttled.
+
+		- powercap : This file gives the total number of times the max
+		frequency is throttled due to 'Power Capping'.
+
+		- overtemp : This file gives the total number of times the max
+		frequency is throttled due to 'CPU Over Temperature'.
+
+		- supply_fault : This file gives the total number of times the
+		max frequency is throttled due to 'Power Supply Failure'.
+
+		- overcurrent : This file gives the total number of times the
+		max frequency is throttled due to 'Overcurrent'.
+
+		- occ_reset : This file gives the total number of times the max
+		frequency is throttled due to 'OCC Reset'.
+
+		The sysfs attributes representing different throttle reasons like
+		powercap, overtemp, supply_fault, overcurrent and occ_reset map to
+		the reasons provided by OCC firmware for throttling the frequency.
+
+What:		/sys/devices/system/cpu/cpufreq/policyX/throttle_stats
+		/sys/devices/system/cpu/cpufreq/policyX/throttle_stats/turbo_stat
+		/sys/devices/system/cpu/cpufreq/policyX/throttle_stats/sub_turbo_stat
+		/sys/devices/system/cpu/cpufreq/policyX/throttle_stats/unthrottle
+		/sys/devices/system/cpu/cpufreq/policyX/throttle_stats/powercap
+		/sys/devices/system/cpu/cpufreq/policyX/throttle_stats/overtemp
+		/sys/devices/system/cpu/cpufreq/policyX/throttle_stats/supply_fault
+		/sys/devices/system/cpu/cpufreq/policyX/throttle_stats/overcurrent
+		/sys/devices/system/cpu/cpufreq/policyX/throttle_stats/occ_reset
+Date:		Feb 2016
+Contact:	Linux kernel mailing list <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
+		Linux for PowerPC mailing list <linuxppc-dev-mnsaURCQ41sdnm+yROfE0A@public.gmane.org>
+Description:	POWERNV CPUFreq driver's frequency throttle stats directory and
+		attributes
+
+		'policyX/throttle_stats' directory and all the attributes are same as
+		the /sys/devices/system/cpu/cpuX/cpufreq/throttle_stats directory and
+		attributes which give the frequency throttle information of the chip.
diff --git a/drivers/cpufreq/powernv-cpufreq.c b/drivers/cpufreq/powernv-cpufreq.c
index 50bf120..6a753d6 100644
--- a/drivers/cpufreq/powernv-cpufreq.c
+++ b/drivers/cpufreq/powernv-cpufreq.c
@@ -55,6 +55,16 @@ static const char * const throttle_reason[] = {
 	"OCC Reset"
 };
 
+enum throttle_reason_type {
+	NO_THROTTLE = 0,
+	POWERCAP,
+	CPU_OVERTEMP,
+	POWER_SUPPLY_FAILURE,
+	OVERCURRENT,
+	OCC_RESET_THROTTLE,
+	OCC_MAX_REASON
+};
+
 static struct chip {
 	unsigned int id;
 	bool throttled;
@@ -62,6 +72,9 @@ static struct chip {
 	u8 throttle_reason;
 	cpumask_t mask;
 	struct work_struct throttle;
+	int throttle_turbo;
+	int throttle_sub_turbo;
+	int reason[OCC_MAX_REASON];
 } *chips;
 
 static int nr_chips;
@@ -196,6 +209,62 @@ static struct freq_attr *powernv_cpu_freq_attr[] = {
 	NULL,
 };
 
+static inline int get_chip_index(unsigned int id)
+{
+	int i;
+
+	for (i = 0; i < nr_chips; i++)
+		if (chips[i].id == id)
+			return i;
+
+	return -EINVAL;
+}
+
+#define get_chip_id(cpu) core_to_chip_map[cpu_core_index_of_thread(cpu)]
+
+#define throttle_attr(name, member)					\
+static ssize_t name##_show(struct cpufreq_policy *policy, char *buf)	\
+{									\
+	int id;								\
+									\
+	id = get_chip_index(get_chip_id(policy->cpu));			\
+	if (id < 0) {							\
+		pr_warn_once("%s Matching chip-id not found %d\n",	\
+			     __func__, get_chip_id(policy->cpu));	\
+		return id;						\
+	}								\
+									\
+	return sprintf(buf, "%u\n", chips[id].member);			\
+}									\
+									\
+static struct freq_attr throttle_attr_##name = __ATTR_RO(name)		\
+
+throttle_attr(unthrottle, reason[NO_THROTTLE]);
+throttle_attr(powercap, reason[POWERCAP]);
+throttle_attr(overtemp, reason[CPU_OVERTEMP]);
+throttle_attr(supply_fault, reason[POWER_SUPPLY_FAILURE]);
+throttle_attr(overcurrent, reason[OVERCURRENT]);
+throttle_attr(occ_reset, reason[OCC_RESET_THROTTLE]);
+throttle_attr(turbo_stat, throttle_turbo);
+throttle_attr(sub_turbo_stat, throttle_sub_turbo);
+
+static struct attribute *throttle_attrs[] = {
+	&throttle_attr_unthrottle.attr,
+	&throttle_attr_powercap.attr,
+	&throttle_attr_overtemp.attr,
+	&throttle_attr_supply_fault.attr,
+	&throttle_attr_overcurrent.attr,
+	&throttle_attr_occ_reset.attr,
+	&throttle_attr_turbo_stat.attr,
+	&throttle_attr_sub_turbo_stat.attr,
+	NULL,
+};
+
+static const struct attribute_group throttle_attr_grp = {
+	.name	= "throttle_stats",
+	.attrs	= throttle_attrs,
+};
+
 /* Helper routines */
 
 /* Access helpers to power mgt SPR */
@@ -325,15 +394,18 @@ static inline unsigned int get_nominal_index(void)
 static void powernv_cpufreq_throttle_check(void *data)
 {
 	unsigned int cpu = smp_processor_id();
-	unsigned int chip_id = core_to_chip_map[cpu_core_index_of_thread(cpu)];
+	unsigned int chip_id = get_chip_id(cpu);
 	unsigned long pmsr;
 	int pmsr_pmax, i;
 
 	pmsr = get_pmspr(SPRN_PMSR);
 
-	for (i = 0; i < nr_chips; i++)
-		if (chips[i].id == chip_id)
-			break;
+	i = get_chip_index(chip_id);
+	if (unlikely(i < 0)) {
+		pr_warn_once("%s Matching chip-id not found %d\n", __func__,
+			     chip_id);
+		return;
+	}
 
 	/* Check for Pmax Capping */
 	pmsr_pmax = (s8)PMSR_MAX(pmsr);
@@ -341,10 +413,15 @@ static void powernv_cpufreq_throttle_check(void *data)
 		if (chips[i].throttled)
 			goto next;
 		chips[i].throttled = true;
-		if (pmsr_pmax < powernv_pstate_info.nominal)
+		if (pmsr_pmax < powernv_pstate_info.nominal) {
 			pr_warn_once("CPU %d on Chip %u has Pmax reduced below nominal frequency (%d < %d)\n",
 				     cpu, chips[i].id, pmsr_pmax,
 				     powernv_pstate_info.nominal);
+			chips[i].throttle_sub_turbo++;
+		} else {
+			chips[i].throttle_turbo++;
+		}
+
 		trace_powernv_throttle(chips[i].id,
 				      throttle_reason[chips[i].throttle_reason],
 				      pmsr_pmax);
@@ -512,13 +589,18 @@ static int powernv_cpufreq_occ_msg(struct notifier_block *nb,
 			return 0;
 		}
 
-		for (i = 0; i < nr_chips; i++)
-			if (chips[i].id == omsg.chip)
-				break;
+		i = get_chip_index(omsg.chip);
+		if (i < 0) {
+			pr_warn_once("%s Matching chip-id not found %d\n",
+				     __func__, (int)omsg.chip);
+			return i;
+		}
 
 		if (omsg.throttle_status >= 0 &&
-		    omsg.throttle_status <= OCC_MAX_THROTTLE_STATUS)
+		    omsg.throttle_status <= OCC_MAX_THROTTLE_STATUS) {
 			chips[i].throttle_reason = omsg.throttle_status;
+			chips[i].reason[omsg.throttle_status]++;
+		}
 
 		if (!omsg.throttle_status)
 			chips[i].restore = true;
@@ -534,6 +616,29 @@ static struct notifier_block powernv_cpufreq_opal_nb = {
 	.priority	= 0,
 };
 
+static int powernv_cpufreq_policy_notifier(struct notifier_block *nb,
+					   unsigned long action, void *data)
+{
+	struct cpufreq_policy *policy = data;
+	int ret;
+
+	if (action == CPUFREQ_CREATE_POLICY) {
+		ret = sysfs_create_group(&policy->kobj, &throttle_attr_grp);
+		if (ret)
+			pr_info("Failed to create throttle stats directory for cpu %d\n",
+				policy->cpu);
+	} else if (action == CPUFREQ_REMOVE_POLICY) {
+		sysfs_remove_group(&policy->kobj, &throttle_attr_grp);
+	}
+
+	return NOTIFY_DONE;
+}
+
+static struct notifier_block powernv_cpufreq_policy_nb = {
+	.notifier_call	= powernv_cpufreq_policy_notifier,
+	.next		= NULL,
+};
+
 static void powernv_cpufreq_stop_cpu(struct cpufreq_policy *policy)
 {
 	struct powernv_smp_call_data freq_data;
@@ -603,6 +708,8 @@ static inline void clean_chip_info(void)
 
 static inline void unregister_all_notifiers(void)
 {
+	cpufreq_unregister_notifier(&powernv_cpufreq_policy_nb,
+				    CPUFREQ_POLICY_NOTIFIER);
 	opal_message_notifier_unregister(OPAL_MSG_OCC,
 					 &powernv_cpufreq_opal_nb);
 	unregister_reboot_notifier(&powernv_cpufreq_reboot_nb);
@@ -628,6 +735,8 @@ static int __init powernv_cpufreq_init(void)
 
 	register_reboot_notifier(&powernv_cpufreq_reboot_nb);
 	opal_message_notifier_register(OPAL_MSG_OCC, &powernv_cpufreq_opal_nb);
+	cpufreq_register_notifier(&powernv_cpufreq_policy_nb,
+				  CPUFREQ_POLICY_NOTIFIER);
 
 	rc = cpufreq_register_driver(&powernv_cpufreq_driver);
 	if (!rc)
-- 
1.9.3
