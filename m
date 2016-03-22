From: Shilpasri G Bhat <shilpa.bhat@linux.vnet.ibm.com>
Subject: [PATCH v13] cpufreq: powernv: Add sysfs attributes to show throttle stats
Date: Tue, 22 Mar 2016 18:57:09 +0530
Message-ID: <1458653229-10318-1-git-send-email-shilpa.bhat@linux.vnet.ibm.com>
Return-path: <linux-pm-owner@vger.kernel.org>
Sender: linux-pm-owner@vger.kernel.org
To: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
Cc: ego@linux.vnet.ibm.com, linux-pm@vger.kernel.org, viresh.kumar@linaro.org, rjw@rjwysocki.net, shreyas@linux.vnet.ibm.com, Shilpasri G Bhat <shilpa.bhat@linux.vnet.ibm.com>, linux-api@vger.kernel.org
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

CC: linux-api@vger.kernel.org
Signed-off-by: Shilpasri G Bhat <shilpa.bhat@linux.vnet.ibm.com>
---
Changes from v12:
- Removed (void *) typecast
- Move the definition of ret inside the 'if' block

Changes from v11:
- Removed '*create_throttle_sysfs' 
- policy->driver_data is used instead to maintain the flag for
  one-time creation of throttle sysfs files.

Changes from v10:
- Removed policy_notifiers to use driver->init() instead to create sysfs
- sysfs attributes are removed by kobject_put(policy->kobj)
- Rebased on top of
  http://lkml.iu.edu/hypermail/linux/kernel/1603.2/02268.html

Changes from v9:
- Modified documentation.
- s/throttle_nominal/throttle_sub_turbo

Changes from v8:
- Moved the sysfs attributes from cpu/cpufreq/chipX to cpuX/cpufreq/throttle_stats
- Adhering to one-value-per-file, replace throttle_table with multiple
  sysfs files.
- Using CPUFREQ_POLICY_NOTIFIER to add/remove attribute_group.

 Documentation/ABI/testing/sysfs-devices-system-cpu | 69 ++++++++++++++++++++
 drivers/cpufreq/powernv-cpufreq.c                  | 74 +++++++++++++++++++++-
 2 files changed, 141 insertions(+), 2 deletions(-)

diff --git a/Documentation/ABI/testing/sysfs-devices-system-cpu b/Documentation/ABI/testing/sysfs-devices-system-cpu
index b683e8e..1650133 100644
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
+Date:		March 2016
+Contact:	Linux kernel mailing list <linux-kernel@vger.kernel.org>
+		Linux for PowerPC mailing list <linuxppc-dev@ozlabs.org>
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
+Date:		March 2016
+Contact:	Linux kernel mailing list <linux-kernel@vger.kernel.org>
+		Linux for PowerPC mailing list <linuxppc-dev@ozlabs.org>
+Description:	POWERNV CPUFreq driver's frequency throttle stats directory and
+		attributes
+
+		'policyX/throttle_stats' directory and all the attributes are same as
+		the /sys/devices/system/cpu/cpuX/cpufreq/throttle_stats directory and
+		attributes which give the frequency throttle information of the chip.
diff --git a/drivers/cpufreq/powernv-cpufreq.c b/drivers/cpufreq/powernv-cpufreq.c
index a00bcc2..39ac78c 100644
--- a/drivers/cpufreq/powernv-cpufreq.c
+++ b/drivers/cpufreq/powernv-cpufreq.c
@@ -54,6 +54,16 @@ static const char * const throttle_reason[] = {
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
@@ -61,6 +71,9 @@ static struct chip {
 	u8 throttle_reason;
 	cpumask_t mask;
 	struct work_struct throttle;
+	int throttle_turbo;
+	int throttle_sub_turbo;
+	int reason[OCC_MAX_REASON];
 } *chips;
 
 static int nr_chips;
@@ -196,6 +209,42 @@ static struct freq_attr *powernv_cpu_freq_attr[] = {
 	NULL,
 };
 
+#define throttle_attr(name, member)					\
+static ssize_t name##_show(struct cpufreq_policy *policy, char *buf)	\
+{									\
+	struct chip *chip = per_cpu(chip_info, policy->cpu);		\
+									\
+	return sprintf(buf, "%u\n", chip->member);			\
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
@@ -338,10 +387,14 @@ static void powernv_cpufreq_throttle_check(void *data)
 		if (chip->throttled)
 			goto next;
 		chip->throttled = true;
-		if (pmsr_pmax < powernv_pstate_info.nominal)
+		if (pmsr_pmax < powernv_pstate_info.nominal) {
 			pr_warn_once("CPU %d on Chip %u has Pmax reduced below nominal frequency (%d < %d)\n",
 				     cpu, chip->id, pmsr_pmax,
 				     powernv_pstate_info.nominal);
+			chip->throttle_sub_turbo++;
+		} else {
+			chip->throttle_turbo++;
+		}
 		trace_powernv_throttle(chip->id,
 				      throttle_reason[chip->throttle_reason],
 				      pmsr_pmax);
@@ -408,6 +461,21 @@ static int powernv_cpufreq_cpu_init(struct cpufreq_policy *policy)
 	for (i = 0; i < threads_per_core; i++)
 		cpumask_set_cpu(base + i, policy->cpus);
 
+	if (!policy->driver_data) {
+		int ret;
+
+		ret = sysfs_create_group(&policy->kobj, &throttle_attr_grp);
+		if (ret) {
+			pr_info("Failed to create throttle stats directory for cpu %d\n",
+				policy->cpu);
+			return ret;
+		}
+		/*
+		 * policy->driver_data is used as a flag for one-time
+		 * creation of throttle sysfs files.
+		 */
+		policy->driver_data = policy;
+	}
 	return cpufreq_table_validate_and_show(policy, powernv_freqs);
 }
 
@@ -514,8 +582,10 @@ static int powernv_cpufreq_occ_msg(struct notifier_block *nb,
 				break;
 
 		if (omsg.throttle_status >= 0 &&
-		    omsg.throttle_status <= OCC_MAX_THROTTLE_STATUS)
+		    omsg.throttle_status <= OCC_MAX_THROTTLE_STATUS) {
 			chips[i].throttle_reason = omsg.throttle_status;
+			chips[i].reason[omsg.throttle_status]++;
+		}
 
 		if (!omsg.throttle_status)
 			chips[i].restore = true;
-- 
1.9.3

