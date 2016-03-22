From: Viresh Kumar <viresh.kumar-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v11] cpufreq: powernv: Add sysfs attributes to show
 throttle stats
Date: Tue, 22 Mar 2016 08:16:27 +0530
Message-ID: <20160322024627.GP27778@vireshk-i7>
References: <1458579591-27573-1-git-send-email-shilpa.bhat@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1458579591-27573-1-git-send-email-shilpa.bhat-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Shilpasri G Bhat <shilpa.bhat-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Cc: linuxppc-dev-mnsaURCQ41sdnm+yROfE0A@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, ego-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org, linux-pm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, rjw-LthD3rsA81gm4RdzfppkhA@public.gmane.org, shreyas-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On 21-03-16, 22:29, Shilpasri G Bhat wrote:
> +	create_throttle_sysfs = kcalloc(cpu_nr_cores(), sizeof(bool),
> +					GFP_KERNEL);
> +	if (!create_throttle_sysfs) {
> +		kfree(chips);
> +		return -ENOMEM;
> +	}
> +
>  	for (i = 0; i < nr_chips; i++) {
>  		chips[i].id = chip[i];
>  		cpumask_copy(&chips[i].mask, cpumask_of_node(chip[i]));
> @@ -582,6 +655,7 @@ static int init_chip_info(void)
>  
>  static inline void clean_chip_info(void)
>  {
> +	kfree(create_throttle_sysfs);
>  	kfree(chips);
>  }

Why do you need this at all?. You can use policy->driver data, isn't
it ?

-- 
viresh
