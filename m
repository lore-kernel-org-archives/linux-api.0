From: Viresh Kumar <viresh.kumar-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v10 2/2] cpufreq: powernv: Add sysfs attributes to show
 throttle stats
Date: Mon, 29 Feb 2016 12:09:17 +0530
Message-ID: <20160229063917.GK2791@vireshk-i7>
References: <1456483012-29466-1-git-send-email-shilpa.bhat@linux.vnet.ibm.com>
 <1456483012-29466-3-git-send-email-shilpa.bhat@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1456483012-29466-3-git-send-email-shilpa.bhat-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: rjw-LthD3rsA81gm4RdzfppkhA@public.gmane.org, Shilpasri G Bhat <shilpa.bhat-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Cc: linuxppc-dev-mnsaURCQ41sdnm+yROfE0A@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-pm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, ego-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org, shreyas-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On 26-02-16, 16:06, Shilpasri G Bhat wrote:
> +static int powernv_cpufreq_policy_notifier(struct notifier_block *nb,
> +					   unsigned long action, void *data)
> +{
> +	struct cpufreq_policy *policy = data;
> +	int ret;
> +
> +	if (action == CPUFREQ_CREATE_POLICY) {
> +		ret = sysfs_create_group(&policy->kobj, &throttle_attr_grp);
> +		if (ret)
> +			pr_info("Failed to create throttle stats directory for cpu %d\n",
> +				policy->cpu);
> +	} else if (action == CPUFREQ_REMOVE_POLICY) {
> +		sysfs_remove_group(&policy->kobj, &throttle_attr_grp);
> +	}
> +
> +	return NOTIFY_DONE;
> +}
> +
> +static struct notifier_block powernv_cpufreq_policy_nb = {
> +	.notifier_call	= powernv_cpufreq_policy_notifier,
> +	.next		= NULL,
> +};
> +
>  static void powernv_cpufreq_stop_cpu(struct cpufreq_policy *policy)
>  {
>  	struct powernv_smp_call_data freq_data;
> @@ -603,6 +708,8 @@ static inline void clean_chip_info(void)
>  
>  static inline void unregister_all_notifiers(void)
>  {
> +	cpufreq_unregister_notifier(&powernv_cpufreq_policy_nb,
> +				    CPUFREQ_POLICY_NOTIFIER);
>  	opal_message_notifier_unregister(OPAL_MSG_OCC,
>  					 &powernv_cpufreq_opal_nb);
>  	unregister_reboot_notifier(&powernv_cpufreq_reboot_nb);
> @@ -628,6 +735,8 @@ static int __init powernv_cpufreq_init(void)
>  
>  	register_reboot_notifier(&powernv_cpufreq_reboot_nb);
>  	opal_message_notifier_register(OPAL_MSG_OCC, &powernv_cpufreq_opal_nb);
> +	cpufreq_register_notifier(&powernv_cpufreq_policy_nb,
> +				  CPUFREQ_POLICY_NOTIFIER);
>  
>  	rc = cpufreq_register_driver(&powernv_cpufreq_driver);
>  	if (!rc)

@Rafael: This driver needs to do this *ugly* notifier hack, just because we
aren't doing kobject_add() for policy->kobj before ->init(). And we did that
because, we wanted to create the policyX structure with the first CPU in
policy->related_cpus mask and related_cpus mask isn't available until we call
->init()..

Should we do something in core to make this easier for this driver?

-- 
viresh
