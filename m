From: Shilpasri G Bhat <shilpa.bhat@linux.vnet.ibm.com>
Subject: [PATCH v8 6/6] cpufreq: powernv: Add sysfs attributes to show throttle stats
Date: Wed,  3 Feb 2016 01:11:42 +0530
Message-ID: <1454442102-1229-7-git-send-email-shilpa.bhat@linux.vnet.ibm.com>
References: <1454442102-1229-1-git-send-email-shilpa.bhat@linux.vnet.ibm.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1454442102-1229-1-git-send-email-shilpa.bhat@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
Cc: rjw@rjwysocki.net, viresh.kumar@linaro.org, linux-pm@vger.kernel.org, pc@us.ibm.com, anton@samba.org, ego@linux.vnet.ibm.com, shreyas@linux.vnet.ibm.com, bsingharora@gmail.com, mpe@ellerman.id.au, Shilpasri G Bhat <shilpa.bhat@linux.vnet.ibm.com>, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Create sysfs attributes to export throttle information in
/sys/devices/system/cpu/cpufreq/chipX. The newly added sysfs files are as
follows:

1)/sys/devices/system/cpu/cpufreq/chipX/throttle_table
This table gives the detailed information on number of times Pmax is
limited to different frequencies due to different throttle reasons.
This table contains all frequencies in rows and all throttle reasons
in columns. Each cell represents the throttle count the Pmax was
limited to the frequency in its row and due to the reason in its
column. The 'Unthrottle' column here gives the count of unthrottling
back to Pmax after the frequency was throttled.
	# cat /sys/devices/system/cpu/cpufreq/chip0/throttle_table
	Frequency	Unthrottle	PowerCap	OverTemp	...
	4322000		0		0		0
	4289000		0		0		0
	4256000		0		0		0
	4222000		0		0		0
	4189000		0		0		0
	4156000		3		0		3
	4123000		4		0		4
	...

2)/sys/devices/system/cpu/cpufreq/chipX/throttle_stat
This gives the total number of events of max frequency throttling to
lower frequencies in the turbo range of frequencies and the sub-turbo(at
and below nominal) range of frequencies.
	# cat /sys/devices/system/cpu/cpufreq/chip0/throttle_stat
	turbo 7
	sub-turbo 0

3)/sys/devices/system/cpu/cpufreq/chipX/chip-mask
This gives the list of cpus present in the chip.
	# cat /sys/devices/system/cpu/cpufreq/chip0/chip_mask
	0-31

Signed-off-by: Shilpasri G Bhat <shilpa.bhat@linux.vnet.ibm.com>
Cc: linux-api@vger.kernel.org
---
Changes from v7:
- Replace throttle_frequencies and throttle_reasons/<reason_attributes> 
  sysfs attributes with a 2d table 'throttle_table' which lists the
  all frequencies in rows and throttle reasons in columns.
- Add 'chip_mask' attribute to show the list of cpus in the chip.
- Replace the kobject pointer with the variable in struct chip.
- Add 'pstate' member to struct chip to store last throttled pstate index.
- Fixes in the error-out-paths 'free_*' in init_chip_info() to avoid
  freeing unallocated pointers.
- Explicitly call 'sysfs_remove_group()' while cleaning up before 
  kobject_put()
- Replacements with snprintf(), __ATTR_RO() and container_of()
- Modified commit message and Documentation.

Changes from v6:
- Rename struct chip members 'throt_{nominal/turbo}' to throttle_*
- Rename sysfs throttle_reason attribute 'throttle_reset' to
  'unthrottle_count'
- Add sysfs attribute details in
  Documentation/ABI/testing/sysfs-devices-system-cpu
- Add helper routine get_chip_index_from_kobj() for throttle sysfs
  attribute show() to get chip index from kobject.
- Add the chip id in the pr_warn_once

No changes from v5.

Changes from v4:
- Taken care of Gautham's comments to use inline get_chip_index()

Changes from v3:
- Seperate the patch to contain only the throttle sysfs attribute changes.
- Add helper inline function get_chip_index()

Changes from v2:
- Fixed kbuild test warning.
drivers/cpufreq/powernv-cpufreq.c:609:2: warning: ignoring return
value of 'kstrtoint', declared with attribute warn_unused_result
[-Wunused-result]

Changes from v1:
- Added a kobject to struct chip
- Grouped the throttle reasons under a separate attribute_group and
  exported each reason as individual file.
- Moved the sysfs files from /sys/devices/system/node/nodeN to
  /sys/devices/system/cpu/cpufreq/chipN
- As suggested by Paul Clarke replaced 'Nominal' with 'sub-turbo'.

 Documentation/ABI/testing/sysfs-devices-system-cpu |  66 +++++++
 drivers/cpufreq/powernv-cpufreq.c                  | 197 +++++++++++++++++++--
 2 files changed, 253 insertions(+), 10 deletions(-)

diff --git a/Documentation/ABI/testing/sysfs-devices-system-cpu b/Documentation/ABI/testing/sysfs-devices-system-cpu
index b683e8e..84ff57a 100644
--- a/Documentation/ABI/testing/sysfs-devices-system-cpu
+++ b/Documentation/ABI/testing/sysfs-devices-system-cpu
@@ -271,3 +271,69 @@ Description:	Parameters for the CPU cache attributes
 			- WriteBack: data is written only to the cache line and
 				     the modified cache line is written to main
 				     memory only when it is replaced
+
+What:		/sys/devices/system/cpu/cpufreq/chipX/
+Date:		Feb 2016
+Contact:	Linux kernel mailing list <linux-kernel@vger.kernel.org>
+		Linux for PowerPC mailing list <linuxppc-dev@ozlabs.org>
+Description:	POWERNV CPUFreq driver's frequency throttle stats directory for
+		the chip
+
+		This directory contains the CPU frequency throttle attributes
+		for the chip. It is named using the hardware chip-id in the
+		format of 'chip<hw-chip-id>'. This directory contains the below
+		set of attributes:
+		- throttle_table
+		- throttle_stats
+		- chip_mask
+
+What:		/sys/devices/system/cpu/cpufreq/chipX/throttle_table
+Date:		Feb 2016
+Contact:	Linux kernel mailing list <linux-kernel@vger.kernel.org>
+		Linux for PowerPC mailing list <linuxppc-dev@ozlabs.org>
+Description:	POWERNV CPUFreq driver's frequency throttle stats table for the
+		chip
+
+		This table gives the detailed information on number of times
+		Pmax is limited to different frequencies due to different
+		throttle reasons. This table contains all frequencies in rows
+		and all throttle reasons in columns. Each cell represents the
+		throttle count the Pmax was limited to the frequency in its row
+		and due to the reason in its column. The 'Unthrottle' column
+		here gives the count of unthrottling back to Pmax after the
+		frequency was throttled.
+		# cat /sys/devices/system/cpu/cpufreq/chip0/throttle_table
+		Frequency       Unthrottle      PowerCap        OverTemp        ...
+		4322000         0               0               0
+		4289000         0               0               0
+		4256000         0               0               0
+		4222000         0               0               0
+		4189000         0               0               0
+		4156000         3               0               3
+		4123000         0               0               0
+		...
+
+What:		/sys/devices/system/cpu/cpufreq/chipX/throttle_stats
+Date:		Feb 2016
+Contact:	Linux kernel mailing list <linux-kernel@vger.kernel.org>
+		Linux for PowerPC mailing list <linuxppc-dev@ozlabs.org>
+Description:	POWERNV CPUFreq driver's overall frequency throttle stats for
+		the chip
+
+		This attribute gives the total number of events of max
+		frequency throttling to any lower frequency in the turbo (above
+		nominal) and the sub-turbo (at and below nominal) range of
+		frequencies.
+		# cat /sys/devices/system/cpu/cpufreq/chip0/throttle_stat
+		turbo 7
+		sub-turbo 0
+
+What:		/sys/devices/system/cpu/cpufreq/chipX/chip_mask
+Date:		Feb 2016
+Contact:	Linux kernel mailing list <linux-kernel@vger.kernel.org>
+		Linux for PowerPC mailing list <linuxppc-dev@ozlabs.org>
+Description:	POWERNV CPUFreq driver's attribute to show cpu mask of the chip
+
+		This attribute gives the list of cpus present in the chip.
+		# cat /sys/devices/system/cpu/cpufreq/chip0/chip_mask
+		0-31
diff --git a/drivers/cpufreq/powernv-cpufreq.c b/drivers/cpufreq/powernv-cpufreq.c
index 1bbc10a..0f55e7a 100644
--- a/drivers/cpufreq/powernv-cpufreq.c
+++ b/drivers/cpufreq/powernv-cpufreq.c
@@ -60,8 +60,13 @@ static struct chip {
 	bool throttled;
 	bool restore;
 	u8 throttle_reason;
+	s8 pstate;
 	cpumask_t mask;
 	struct work_struct throttle;
+	int throttle_turbo;
+	int throttle_nominal;
+	int *reason[OCC_MAX_THROTTLE_STATUS + 1];
+	struct kobject kobj;
 } *chips;
 
 static int nr_chips;
@@ -196,6 +201,111 @@ static struct freq_attr *powernv_cpu_freq_attr[] = {
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
+static inline int get_chip_index_from_kobj(struct kobject *kobj)
+{
+	int ret;
+	struct chip *chip;
+
+	chip = container_of(kobj, struct chip, kobj);
+
+	ret = get_chip_index(chip->id);
+	if (ret < 0)
+		pr_warn_once("%s Matching chip-id not found %d\n", __func__,
+			     chip->id);
+	return ret;
+}
+
+static const char * const column_str[] = {
+	"Frequency",
+	"Unthrottle",
+	"PowerCap",
+	"OverTemp",
+	"PowerFault",
+	"OverCurrent",
+	"OCCReset"
+};
+
+static ssize_t throttle_table_show(struct kobject *kobj,
+				   struct kobj_attribute *attr, char *buf)
+{
+	int id, count = 0, i, j;
+
+	id = get_chip_index_from_kobj(kobj);
+	if (id < 0)
+		return id;
+
+	for (i = 0; i < ARRAY_SIZE(column_str); i++)
+		count += sprintf(&buf[count], "%s\t", column_str[i]);
+	count += sprintf(&buf[count], "\n");
+
+	for (i = 0; i < powernv_pstate_info.nr_pstates; i++) {
+		count += sprintf(&buf[count], "%d\t\t",
+				 powernv_freqs[i].frequency);
+		for (j = 0; j <= OCC_MAX_THROTTLE_STATUS; j++)
+			count += sprintf(&buf[count], "%d\t\t",
+					 chips[id].reason[j][i]);
+		count += sprintf(&buf[count], "\n");
+	}
+
+	return count;
+}
+
+static struct kobj_attribute attr_throttle_table = __ATTR_RO(throttle_table);
+
+static ssize_t throttle_stat_show(struct kobject *kobj,
+				  struct kobj_attribute *attr, char *buf)
+{
+	int id, count = 0;
+
+	id = get_chip_index_from_kobj(kobj);
+	if (id < 0)
+		return id;
+
+	count += sprintf(&buf[count], "turbo %d\n", chips[id].throttle_turbo);
+	count += sprintf(&buf[count], "sub-turbo %d\n",
+					chips[id].throttle_nominal);
+
+	return count;
+}
+
+static struct kobj_attribute attr_throttle_stat = __ATTR_RO(throttle_stat);
+
+static ssize_t chip_mask_show(struct kobject *kobj,
+			      struct kobj_attribute *attr, char *buf)
+{
+	int id;
+
+	id = get_chip_index_from_kobj(kobj);
+	if (id < 0)
+		return id;
+
+	return cpumap_print_to_pagebuf(true, buf, &chips[id].mask);
+}
+
+static struct kobj_attribute attr_chip_mask = __ATTR_RO(chip_mask);
+
+static struct attribute *throttle_stat_attrs[] = {
+	&attr_throttle_stat.attr,
+	&attr_throttle_table.attr,
+	&attr_chip_mask.attr,
+	NULL
+};
+
+static const struct attribute_group throttle_stat_group = {
+	.attrs = throttle_stat_attrs,
+};
+
 /* Helper routines */
 
 /* Access helpers to power mgt SPR */
@@ -327,13 +437,16 @@ static void powernv_cpufreq_throttle_check(void *data)
 	unsigned int cpu = smp_processor_id();
 	unsigned int chip_id = core_to_chip_map[cpu_core_index_of_thread(cpu)];
 	unsigned long pmsr;
-	int pmsr_pmax, i;
+	int pmsr_pmax, i, index;
 
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
@@ -341,15 +454,27 @@ static void powernv_cpufreq_throttle_check(void *data)
 		if (chips[i].throttled)
 			goto next;
 		chips[i].throttled = true;
-		if (pmsr_pmax < powernv_pstate_info.nominal)
+		if (pmsr_pmax < powernv_pstate_info.nominal) {
 			pr_warn_once("CPU %d on Chip %u has Pmax reduced below nominal frequency (%d < %d)\n",
 				     cpu, chips[i].id, pmsr_pmax,
 				     powernv_pstate_info.nominal);
+			chips[i].throttle_nominal++;
+		} else {
+			chips[i].throttle_turbo++;
+		}
+
+		index  = powernv_pstate_info.max - pmsr_pmax;
+		if (index >= 0 && index < powernv_pstate_info.nr_pstates) {
+			chips[i].reason[chips[i].throttle_reason][index]++;
+			chips[i].pstate = index;
+		}
+
 		trace_powernv_throttle(chips[i].id,
 				      throttle_reason[chips[i].throttle_reason],
 				      pmsr_pmax);
 	} else if (chips[i].throttled) {
 		chips[i].throttled = false;
+		chips[i].reason[chips[i].throttle_reason][chips[i].pstate]++;
 		trace_powernv_throttle(chips[i].id,
 				      throttle_reason[chips[i].throttle_reason],
 				      pmsr_pmax);
@@ -512,9 +637,12 @@ static int powernv_cpufreq_occ_msg(struct notifier_block *nb,
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
 		    omsg.throttle_status <= OCC_MAX_THROTTLE_STATUS)
@@ -556,10 +684,10 @@ static struct cpufreq_driver powernv_cpufreq_driver = {
 static int init_chip_info(void)
 {
 	unsigned int chip[256];
-	unsigned int cpu, i;
+	unsigned int cpu;
 	unsigned int prev_chip_id = UINT_MAX;
 	cpumask_t cpu_mask;
-	int ret = -ENOMEM;
+	int i, j, ret = -ENOMEM;
 
 	core_to_chip_map = kcalloc(cpu_nr_cores(), sizeof(unsigned int),
 				   GFP_KERNEL);
@@ -583,12 +711,51 @@ static int init_chip_info(void)
 		goto free_chip_map;
 
 	for (i = 0; i < nr_chips; i++) {
+		char name[10];
+
 		chips[i].id = chip[i];
 		cpumask_copy(&chips[i].mask, cpumask_of_node(chip[i]));
 		INIT_WORK(&chips[i].throttle, powernv_cpufreq_work_fn);
+
+		for (j = 0; j <= OCC_MAX_THROTTLE_STATUS; j++) {
+			chips[i].reason[j] =
+			     kcalloc(powernv_pstate_info.nr_pstates,
+				     sizeof(int), GFP_KERNEL);
+			if (!chips[i].reason[j]) {
+				ret = -ENOMEM;
+				goto free_chip;
+			}
+		}
+
+		snprintf(name, sizeof(name), "chip%d", chips[i].id);
+		ret = kobject_init_and_add(&chips[i].kobj,
+					   get_ktype(cpufreq_global_kobject),
+					   cpufreq_global_kobject, name);
+		if (ret)
+			goto free_chip;
+
+		ret = sysfs_create_group(&chips[i].kobj, &throttle_stat_group);
+		if (ret) {
+			pr_info("Chip %d failed to create throttle sysfs group\n",
+				chips[i].id);
+			goto free_kobject;
+		}
 	}
 
 	return 0;
+
+free_kobject:
+	kobject_put(&chips[i].kobj);
+free_chip:
+	while (--j >= 0)
+		kfree(chips[i].reason[j]);
+	while (--i >= 0) {
+		sysfs_remove_group(&chips[i].kobj, &throttle_stat_group);
+		kobject_put(&chips[i].kobj);
+		for (j = 0; j <= OCC_MAX_THROTTLE_STATUS; j++)
+			kfree(chips[i].reason[j]);
+	}
+	kfree(chips);
 free_chip_map:
 	kfree(core_to_chip_map);
 out:
@@ -623,9 +790,19 @@ module_init(powernv_cpufreq_init);
 
 static void __exit powernv_cpufreq_exit(void)
 {
+	int i, j;
+
 	unregister_reboot_notifier(&powernv_cpufreq_reboot_nb);
 	opal_message_notifier_unregister(OPAL_MSG_OCC,
 					 &powernv_cpufreq_opal_nb);
+
+	for (i = 0; i < nr_chips; i++) {
+		sysfs_remove_group(&chips[i].kobj, &throttle_stat_group);
+		kobject_put(&chips[i].kobj);
+		for (j = 0; j <= OCC_MAX_THROTTLE_STATUS; j++)
+			kfree(chips[i].reason[j]);
+	}
+
 	kfree(chips);
 	kfree(core_to_chip_map);
 	cpufreq_unregister_driver(&powernv_cpufreq_driver);
-- 
1.9.3
