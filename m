From: Viresh Kumar <viresh.kumar-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v13] cpufreq: powernv: Add sysfs attributes to show
 throttle stats
Date: Tue, 22 Mar 2016 19:55:07 +0530
Message-ID: <20160322142507.GK5272@vireshk-i7>
References: <1458653229-10318-1-git-send-email-shilpa.bhat@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1458653229-10318-1-git-send-email-shilpa.bhat-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Shilpasri G Bhat <shilpa.bhat-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Cc: linuxppc-dev-mnsaURCQ41sdnm+yROfE0A@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, ego-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org, linux-pm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, rjw-LthD3rsA81gm4RdzfppkhA@public.gmane.org, shreyas-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On 22-03-16, 18:57, Shilpasri G Bhat wrote:
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
> CC: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Signed-off-by: Shilpasri G Bhat <shilpa.bhat-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
> ---
> Changes from v12:
> - Removed (void *) typecast
> - Move the definition of ret inside the 'if' block

Sorry for 12 versions :)

Acked-by: Viresh Kumar <viresh.kumar-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>

-- 
viresh
