From: Shilpasri G Bhat <shilpa.bhat-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Subject: Re: [PATCH v8 6/6] cpufreq: powernv: Add sysfs attributes to show
 throttle stats
Date: Wed, 03 Feb 2016 14:12:25 +0530
Message-ID: <56B1BD71.2050403@linux.vnet.ibm.com>
References: <1454442102-1229-1-git-send-email-shilpa.bhat@linux.vnet.ibm.com> <1454442102-1229-7-git-send-email-shilpa.bhat@linux.vnet.ibm.com> <20160203082700.GZ31828@vireshk>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160203082700.GZ31828@vireshk>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Viresh Kumar <viresh.kumar-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: linuxppc-dev-mnsaURCQ41sdnm+yROfE0A@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, rjw-LthD3rsA81gm4RdzfppkhA@public.gmane.org, linux-pm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, pc-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org, anton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org, ego-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org, shreyas-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org, bsingharora-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, mpe-Gsx/Oe8HsFggBc27wqDAHg@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

Hi,

On 02/03/2016 01:57 PM, Viresh Kumar wrote:
> On 03-02-16, 01:11, Shilpasri G Bhat wrote:
>>  static int init_chip_info(void)
>>  {
>>  	unsigned int chip[256];
>> -	unsigned int cpu, i;
>> +	unsigned int cpu;
>>  	unsigned int prev_chip_id = UINT_MAX;
>>  	cpumask_t cpu_mask;
>> -	int ret = -ENOMEM;
>> +	int i, j, ret = -ENOMEM;
>>  
>>  	core_to_chip_map = kcalloc(cpu_nr_cores(), sizeof(unsigned int),
>>  				   GFP_KERNEL);
>> @@ -583,12 +711,51 @@ static int init_chip_info(void)
>>  		goto free_chip_map;
>>  
>>  	for (i = 0; i < nr_chips; i++) {
>> +		char name[10];
>> +
>>  		chips[i].id = chip[i];
>>  		cpumask_copy(&chips[i].mask, cpumask_of_node(chip[i]));
>>  		INIT_WORK(&chips[i].throttle, powernv_cpufreq_work_fn);
>> +
>> +		for (j = 0; j <= OCC_MAX_THROTTLE_STATUS; j++) {
>> +			chips[i].reason[j] =
>> +			     kcalloc(powernv_pstate_info.nr_pstates,
>> +				     sizeof(int), GFP_KERNEL);
>> +			if (!chips[i].reason[j]) {
>> +				ret = -ENOMEM;
>> +				goto free_chip;
>> +			}
>> +		}
>> +
>> +		snprintf(name, sizeof(name), "chip%d", chips[i].id);
>> +		ret = kobject_init_and_add(&chips[i].kobj,
>> +					   get_ktype(cpufreq_global_kobject),
> 
> Sorry but why do you need to create a kobject here ? A simple
> sysfs_create_group() can create groups (directories) for you.

I need the chip-id in the <attr>_show(). With just sysfs_create_group() I will
get the cpufreq_global_kobject in the <attr>_show() and I will not be able to
figure out the chip-id.

Thanks and Regards,
Shilpa
> 
>> +					   cpufreq_global_kobject, name);
>> +		if (ret)
>> +			goto free_chip;
>> +
>> +		ret = sysfs_create_group(&chips[i].kobj, &throttle_stat_group);
>> +		if (ret) {
>> +			pr_info("Chip %d failed to create throttle sysfs group\n",
>> +				chips[i].id);
>> +			goto free_kobject;
>> +		}
>>  	}
> 
