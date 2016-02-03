From: Gautham R Shenoy <ego-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Subject: Re: [PATCH v8 6/6] cpufreq: powernv: Add sysfs attributes to show
 throttle stats
Date: Wed, 3 Feb 2016 17:32:58 +0530
Message-ID: <20160203120258.GA32294@in.ibm.com>
References: <1454442102-1229-1-git-send-email-shilpa.bhat@linux.vnet.ibm.com>
 <1454442102-1229-7-git-send-email-shilpa.bhat@linux.vnet.ibm.com>
 <20160203082700.GZ31828@vireshk>
 <56B1BD71.2050403@linux.vnet.ibm.com>
 <20160203090357.GA31828@vireshk>
Reply-To: ego-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160203090357.GA31828@vireshk>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Viresh Kumar <viresh.kumar-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: Shilpasri G Bhat <shilpa.bhat-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, linuxppc-dev-mnsaURCQ41sdnm+yROfE0A@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, rjw-LthD3rsA81gm4RdzfppkhA@public.gmane.org, linux-pm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, pc-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org, anton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org, ego-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org, shreyas-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org, bsingharora-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, mpe-Gsx/Oe8HsFggBc27wqDAHg@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

Hi Viresh,

> 
> What I can suggest is:
> - Move this directory inside cpuX/cpufreq/ directory, in a similar way
>   as to how we create 'stats' directory today.
> - You can then get policy->cpu, to get chip->id out of it.
> - The only disadvantage here is that the same chip directory will be
>   replicated in multiple policies, but that makes it more readable.

Thinking about it, having a sysfs group attached to a policy kobject
looks ok if replication of the same chip information across multiple
policies is not objectionable.

Regarding the table-format, it breaks the sysfs's one-value-per-file
rule. So I would still prefer each throttle reason being a separate
file which gives the number of times the chip frequency was throttled
due to that reason. We can live without the per-frequency
throttle stats listed in the throttle_status.

So, would the following be sysfs group structure be acceptable?

$ls -1 /sys/devices/system/cpu/cpuX/cpufreq/throttle_stats/
unthrottle
powercap
overtemp
supply_fault
overcurrent
occ_reset
turbo_stat
sub_turbo_stat

--
Thanks and Regards
gautham.
