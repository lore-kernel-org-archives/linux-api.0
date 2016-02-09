From: Viresh Kumar <viresh.kumar-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v9] cpufreq: powernv: Add sysfs attributes to show
 throttle stats
Date: Tue, 9 Feb 2016 10:50:04 +0530
Message-ID: <20160209052004.GA15734@vireshk>
References: <1454942667-13424-1-git-send-email-shilpa.bhat@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1454942667-13424-1-git-send-email-shilpa.bhat-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Shilpasri G Bhat <shilpa.bhat-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Cc: linuxppc-dev-mnsaURCQ41sdnm+yROfE0A@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, rjw-LthD3rsA81gm4RdzfppkhA@public.gmane.org, linux-pm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, pc-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org, anton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org, ego-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org, shreyas-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org, bsingharora-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On 08-02-16, 20:14, Shilpasri G Bhat wrote:
> Create sysfs attributes to export throttle information in
> /sys/devices/system/cpu/cpuX/cpufreq/throttle_stats directory. The
> newly added sysfs files are as follows:
> 
> 1)/sys/devices/system/cpu/cpuX/cpufreq/throttle_stats/turbo_stat
> 2)/sys/devices/system/cpu/cpuX/cpufreq/throttle_stats/sub-turbo_stat
> 3)/sys/devices/system/cpu/cpuX/cpufreq/throttle_stats/unthrottle
> 4)/sys/devices/system/cpu/cpuX/cpufreq/throttle_stats/powercap
> 5)/sys/devices/system/cpu/cpuX/cpufreq/throttle_stats/overtemp
> 6)/sys/devices/system/cpu/cpuX/cpufreq/throttle_stats/supply_fault
> 7)/sys/devices/system/cpu/cpuX/cpufreq/throttle_stats/overcurrent
> 8)/sys/devices/system/cpu/cpuX/cpufreq/throttle_stats/occ_reset
> 
> Detailed explanation of each attribute is added to
> Documentation/ABI/testing/sysfs-devices-system-cpu
> 
> Signed-off-by: Shilpasri G Bhat <shilpa.bhat-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
> ---
> Changes from v8:
> - Moved the sysfs attributes from cpu/cpufreq/chipX to cpuX/cpufreq/throttle_stats
> - Adhering to one-value-per-file, replace throttle_table with multiple
>   sysfs files.
> - Using CPUFREQ_POLICY_NOTIFIER to add/remove attribute_group.

Looks far better and sensible, but there are few bugs we have to fix
first.

>  static void powernv_cpufreq_stop_cpu(struct cpufreq_policy *policy)
>  {
>  	struct powernv_smp_call_data freq_data;
> @@ -589,6 +694,7 @@ static int init_chip_info(void)
>  	}
>  
>  	return 0;
> +

Unrelated change.

>  free_chip_map:
>  	kfree(core_to_chip_map);
>  out:
> @@ -615,6 +721,8 @@ static int __init powernv_cpufreq_init(void)
>  	if (rc)
>  		return rc;
>  
> +	cpufreq_register_notifier(&powernv_cpufreq_policy_nb,
> +				  CPUFREQ_POLICY_NOTIFIER);
>  	register_reboot_notifier(&powernv_cpufreq_reboot_nb);
>  	opal_message_notifier_register(OPAL_MSG_OCC, &powernv_cpufreq_opal_nb);
>  	return cpufreq_register_driver(&powernv_cpufreq_driver);

If this fails, you don't unregister the notifiers. Actually, the BUG
is already there, and you must fix that first.

> @@ -626,6 +734,8 @@ static void __exit powernv_cpufreq_exit(void)
>  	unregister_reboot_notifier(&powernv_cpufreq_reboot_nb);
>  	opal_message_notifier_unregister(OPAL_MSG_OCC,
>  					 &powernv_cpufreq_opal_nb);
> +	cpufreq_unregister_notifier(&powernv_cpufreq_policy_nb,
> +				    CPUFREQ_POLICY_NOTIFIER);
>  	kfree(chips);
>  	kfree(core_to_chip_map);
>  	cpufreq_unregister_driver(&powernv_cpufreq_driver);

This is even more stupid. You remove the driver after freeing all
resources :)

Make this reverse of init..

Fix existing issues first and then apply this patch on the top.

-- 
viresh
