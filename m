From: Viresh Kumar <viresh.kumar@linaro.org>
Subject: Re: [PATCH v7 6/6] cpufreq: powernv: Add sysfs attributes to show
 throttle stats
Date: Thu, 28 Jan 2016 14:10:41 +0530
Message-ID: <20160128084041.GK3935@vireshk>
References: <1453965941-7363-1-git-send-email-shilpa.bhat@linux.vnet.ibm.com>
 <1453965941-7363-7-git-send-email-shilpa.bhat@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-pm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1453965941-7363-7-git-send-email-shilpa.bhat@linux.vnet.ibm.com>
Sender: linux-pm-owner@vger.kernel.org
To: Shilpasri G Bhat <shilpa.bhat@linux.vnet.ibm.com>
Cc: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org, rjw@rjwysocki.net, linux-pm@vger.kernel.org, pc@us.ibm.com, anton@samba.org, ego@linux.vnet.ibm.com, shreyas@linux.vnet.ibm.com, bsingharora@gmail.com, mpe@ellerman.id.au, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On 28-01-16, 12:55, Shilpasri G Bhat wrote:
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

What about the chip directory ? Shouldn't that be documented? And
shouldn't that mention that this is just for powerpc ?

And before that, I don't think that you are doing this properly. I am
sorry that I never came to a point where I could review it, and you
continued with it, version after version.

But, I really have strong objections to the way this is done. And you
are making things more complex then they are.

So, these stats are per-policy, right ?

Then why aren't they added on the policy->kobj instead, just like
cpufreq-stats? And maybe inside cpufreq-stats folder only?

That will solve many complexities you have in place here and will look
sane as well.

Right now, you have stats as two places, cpu/cpufreq/chip/ and
cpu/cpuX/cpufreq/stats/, which doesn't look wise and adds to
confusion.

What do you say?

-- 
viresh
