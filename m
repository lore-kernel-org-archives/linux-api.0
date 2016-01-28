From: Viresh Kumar <viresh.kumar-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v7 6/6] cpufreq: powernv: Add sysfs attributes to show
 throttle stats
Date: Thu, 28 Jan 2016 17:10:43 +0530
Message-ID: <20160128114043.GQ3935@vireshk>
References: <1453965941-7363-1-git-send-email-shilpa.bhat@linux.vnet.ibm.com>
 <1453965941-7363-7-git-send-email-shilpa.bhat@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1453965941-7363-7-git-send-email-shilpa.bhat-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Shilpasri G Bhat <shilpa.bhat-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Cc: linuxppc-dev-mnsaURCQ41sdnm+yROfE0A@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, rjw-LthD3rsA81gm4RdzfppkhA@public.gmane.org, linux-pm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, pc-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org, anton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org, ego-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org, shreyas-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org, bsingharora-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, mpe-Gsx/Oe8HsFggBc27wqDAHg@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On 28-01-16, 12:55, Shilpasri G Bhat wrote:
> Create sysfs attributes to export throttle information in
> /sys/devices/system/cpu/cpufreq/chipN. The newly added sysfs files are as
> follows:
> 
> 1)/sys/devices/system/cpu/cpufreq/chip0/throttle_frequencies
>   This gives the throttle stats for each of the available frequencies.
>   The throttle stat of a frequency is the total number of times the max
>   frequency is reduced to that frequency.
>   # cat /sys/devices/system/cpu/cpufreq/chip0/throttle_frequencies
>   4023000 0
>   3990000 0
>   3956000 1
>   3923000 0
>   3890000 0
>   3857000 2
>   3823000 0
>   3790000 0
>   3757000 2
>   3724000 1
>   3690000 1
>   ...
> 
> 2)/sys/devices/system/cpu/cpufreq/chip0/throttle_reasons
>   This directory contains throttle reason files. Each file gives the
>   total number of times the max frequency is throttled, except for
>   'unthrottle_count', which gives the total number of times the max
>   frequency is unthrottled after being throttled.
>   # cd /sys/devices/system/cpu/cpufreq/chip0/throttle_reasons
>   # cat cpu_over_temperature
>   7
>   # cat occ_reset
>   0
>   # cat over_current
>   0
>   # cat power_cap
>   0
>   # cat power_supply_failure
>   0
>   # cat unthrottle_count
>   7

Wouldn't it be better to keep a two dimensional table here, something
like: trans_table ?

You can have "reasons" in the vertical dimension and frequencies in
the horizontal one? So, that user can see which frequencies got
throttled and why?

> diff --git a/Documentation/ABI/testing/sysfs-devices-system-cpu b/Documentation/ABI/testing/sysfs-devices-system-cpu
> index b683e8e..dea4620 100644
> --- a/Documentation/ABI/testing/sysfs-devices-system-cpu
> +++ b/Documentation/ABI/testing/sysfs-devices-system-cpu
> @@ -271,3 +271,48 @@ Description:	Parameters for the CPU cache attributes
>  			- WriteBack: data is written only to the cache line and
>  				     the modified cache line is written to main
>  				     memory only when it is replaced
> +
> +What:		/sys/devices/system/cpu/cpufreq/chip*/throttle_stats

You need documentation for chip*/ as well..

And how can a user know which policies or CPUs belong to a chip?

> diff --git a/drivers/cpufreq/powernv-cpufreq.c b/drivers/cpufreq/powernv-cpufreq.c
>  static struct chip {
>  	unsigned int id;
>  	bool throttled;
> @@ -62,6 +72,11 @@ static struct chip {
>  	u8 throttle_reason;
>  	cpumask_t mask;
>  	struct work_struct throttle;
> +	int throttle_turbo;
> +	int throttle_nominal;
> +	int reason[OCC_MAX_REASON];
> +	int *pstate_stat;
> +	struct kobject *kobj;
>  } *chips;
>  
>  static int nr_chips;
> @@ -196,6 +211,126 @@ static struct freq_attr *powernv_cpu_freq_attr[] = {
>  	NULL,
>  };
>  
> +static inline int get_chip_index(unsigned int id)
> +{
> +	int i;
> +
> +	for (i = 0; i < nr_chips; i++)
> +		if (chips[i].id == id)
> +			return i;
> +
> +	return -EINVAL;
> +}
> +
> +static inline int get_chip_index_from_kobj(struct kobject *kobj)
> +{
> +	int ret, id;
> +	int len = strlen("chip");
> +
> +	ret = kstrtoint(kobj->name + len, 0, &id);

That doesn't look nice. What about keeping the kobject in the 'struct
chip' and using container of here?

You can register the kobject with: kobject_init_and_add().

> +	if (ret)
> +		return ret;
> +
> +	ret = get_chip_index(id);
> +	if (ret < 0)
> +		pr_warn_once("%s Matching chip-id not found %d\n", __func__,
> +			     id);
> +	return ret;
> +}
> +
> +static ssize_t throttle_freq_show(struct kobject *kobj,
> +				  struct kobj_attribute *attr, char *buf)
> +{
> +	int i, count = 0, id;
> +
> +	id = get_chip_index_from_kobj(kobj);
> +	if (id < 0)
> +		return id;
> +
> +	for (i = 0; i < powernv_pstate_info.nr_pstates; i++)
> +		count += sprintf(&buf[count], "%d %d\n",
> +			       powernv_freqs[i].frequency,
> +			       chips[id].pstate_stat[i]);
> +
> +	return count;
> +}
> +
> +static struct kobj_attribute attr_throttle_frequencies =
> +__ATTR(throttle_frequencies, 0444, throttle_freq_show, NULL);

Use DEVICE_ATTR_RO macro ?

> @@ -583,12 +736,38 @@ static int init_chip_info(void)
>  		goto free_chip_map;
>  
>  	for (i = 0; i < nr_chips; i++) {
> +		char name[10];
> +
>  		chips[i].id = chip[i];
>  		cpumask_copy(&chips[i].mask, cpumask_of_node(chip[i]));
>  		INIT_WORK(&chips[i].throttle, powernv_cpufreq_work_fn);
> +		chips[i].pstate_stat = kcalloc(powernv_pstate_info.nr_pstates,
> +						sizeof(int), GFP_KERNEL);
> +		if (!chips[i].pstate_stat)
> +			goto free;
> +
> +		sprintf(name, "chip%d", chips[i].id);

Always use snprintf ..

> +		chips[i].kobj = kobject_create_and_add(name,
> +						       cpufreq_global_kobject);
> +		if (!chips[i].kobj)
> +			goto free;
> +
> +		ret = sysfs_create_groups(chips[i].kobj, throttle_attr_groups);
> +		if (ret) {
> +			pr_info("Chip %d failed to create throttle sysfs group\n",
> +				chips[i].id);
> +			goto free;
> +		}
>  	}
>  
>  	return 0;
> +free:
> +	nr_chips = i;
> +	for (i = 0; i <= nr_chips; i++) {

Rather do:

        while (--i >= 0) {
                kobject_put(chips[i].kobj);
                kfree(chips[i].pstate_stat);
        }

> +		kobject_put(chips[i].kobj);
> +		kfree(chips[i].pstate_stat);

You haven't removed the sysfs-group. Also make sure you aren't trying
to free/remove resources you haven't allocated, as the earlier part
can fail after 3 different allocations and you are doing same thing
here for all of them.

> +	}
> +	kfree(chips);
>  free_chip_map:
>  	kfree(core_to_chip_map);
>  out:
> @@ -623,9 +802,17 @@ module_init(powernv_cpufreq_init);
>  
>  static void __exit powernv_cpufreq_exit(void)
>  {
> +	int i;
> +
>  	unregister_reboot_notifier(&powernv_cpufreq_reboot_nb);
>  	opal_message_notifier_unregister(OPAL_MSG_OCC,
>  					 &powernv_cpufreq_opal_nb);
> +
> +	for (i = 0; i < nr_chips; i++) {
> +		kobject_put(chips[i].kobj);

remove groups ?

> +		kfree(chips[i].pstate_stat);
> +	}
> +
>  	kfree(chips);
>  	kfree(core_to_chip_map);
>  	cpufreq_unregister_driver(&powernv_cpufreq_driver);
> -- 
> 1.9.3

-- 
viresh
