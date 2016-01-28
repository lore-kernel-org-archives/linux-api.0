From: Gautham R Shenoy <ego-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Subject: Re: [PATCH v7 6/6] cpufreq: powernv: Add sysfs attributes to show
 throttle stats
Date: Thu, 28 Jan 2016 14:04:36 +0530
Message-ID: <20160128083436.GD13654@in.ibm.com>
References: <1453965941-7363-1-git-send-email-shilpa.bhat@linux.vnet.ibm.com>
 <1453965941-7363-7-git-send-email-shilpa.bhat@linux.vnet.ibm.com>
Reply-To: ego-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1453965941-7363-7-git-send-email-shilpa.bhat-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Shilpasri G Bhat <shilpa.bhat-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Cc: linuxppc-dev-mnsaURCQ41sdnm+yROfE0A@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, rjw-LthD3rsA81gm4RdzfppkhA@public.gmane.org, viresh.kumar-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, linux-pm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, pc-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org, anton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org, ego-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org, shreyas-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org, bsingharora-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, mpe-Gsx/Oe8HsFggBc27wqDAHg@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

Hi Shilpa,

A minor nit.
On Thu, Jan 28, 2016 at 12:55:41PM +0530, Shilpasri G Bhat wrote:

[..snip..]
> +
> +What:		/sys/devices/system/cpu/cpufreq/chip*/throttle_reasons/<reason_attributes>
> +Date:		Jan 2016
> +Contact:	Linux kernel mailing list <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
> +		Linux for PowerPC mailing list <linuxppc-dev-mnsaURCQ41sdnm+yROfE0A@public.gmane.org>
> +Description:	CPU Frequency throttle reason stat for the chip
> +
> +		This directory contains throttle reason files. Each file gives
> +		the total number of times the max frequency is throttled, except
> +		for 'unthrottle_count', which gives the total number of times
> +		the max frequency is unthrottled after being throttled. Below
> +		are the reason attributes.
> +
> +		cpu_over_temperature: Throttled due to cpu over temperature
> +
> +		occ_reset: Throttled due to reset of OCC
> +
> +		over_current: Throttled due to over current

Overcurrent is a single word. No need of the extra space. You could
fix that and add my Reviewed-by.

--
Thanks and Regards
gautham.
