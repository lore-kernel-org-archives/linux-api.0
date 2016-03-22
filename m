From: Viresh Kumar <viresh.kumar-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v12] cpufreq: powernv: Add sysfs attributes to show
 throttle stats
Date: Tue, 22 Mar 2016 17:03:07 +0530
Message-ID: <20160322113307.GI5272@vireshk-i7>
References: <1458643717-2847-1-git-send-email-shilpa.bhat@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1458643717-2847-1-git-send-email-shilpa.bhat-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Shilpasri G Bhat <shilpa.bhat-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Cc: linuxppc-dev-mnsaURCQ41sdnm+yROfE0A@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, ego-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org, linux-pm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, rjw-LthD3rsA81gm4RdzfppkhA@public.gmane.org, shreyas-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

I really wanted to Ack this time, but you know I am nitpicking again :(

On 22-03-16, 16:18, Shilpasri G Bhat wrote:
>  static int powernv_cpufreq_cpu_init(struct cpufreq_policy *policy)
>  {
> -	int base, i;
> +	int base, i, ret;
>  
>  	base = cpu_first_thread_sibling(policy->cpu);
>  
>  	for (i = 0; i < threads_per_core; i++)
>  		cpumask_set_cpu(base + i, policy->cpus);
>  
> +	if (!policy->driver_data) {

Declare ret here, as it is going to be used only within the if block.

> +		ret = sysfs_create_group(&policy->kobj, &throttle_attr_grp);
> +		if (ret) {
> +			pr_info("Failed to create throttle stats directory for cpu %d\n",
> +				policy->cpu);
> +			return ret;
> +		}
> +		/*
> +		 * policy->driver_data is used as a flag for one-time
> +		 * creation of throttle sysfs files.
> +		 */
> +		policy->driver_data = (void *)policy;

This is far better then the ugly solution I suggested on our private chat :),
but you should drop (void *) typecast. Its not required.

-- 
viresh
