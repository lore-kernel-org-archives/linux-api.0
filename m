From: Shilpasri G Bhat <shilpa.bhat@linux.vnet.ibm.com>
Subject: Re: [PATCH v7 6/6] cpufreq: powernv: Add sysfs attributes to show
 throttle stats
Date: Thu, 28 Jan 2016 15:06:54 +0530
Message-ID: <56A9E136.8090900@linux.vnet.ibm.com>
References: <1453965941-7363-1-git-send-email-shilpa.bhat@linux.vnet.ibm.com> <1453965941-7363-7-git-send-email-shilpa.bhat@linux.vnet.ibm.com> <20160128084041.GK3935@vireshk>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-pm-owner@vger.kernel.org>
In-Reply-To: <20160128084041.GK3935@vireshk>
Sender: linux-pm-owner@vger.kernel.org
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org, rjw@rjwysocki.net, linux-pm@vger.kernel.org, pc@us.ibm.com, anton@samba.org, ego@linux.vnet.ibm.com, shreyas@linux.vnet.ibm.com, bsingharora@gmail.com, mpe@ellerman.id.au, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Hi Viresh,

On 01/28/2016 02:10 PM, Viresh Kumar wrote:
> On 28-01-16, 12:55, Shilpasri G Bhat wrote:
>> diff --git a/Documentation/ABI/testing/sysfs-devices-system-cpu b/Documentation/ABI/testing/sysfs-devices-system-cpu
>> index b683e8e..dea4620 100644
>> --- a/Documentation/ABI/testing/sysfs-devices-system-cpu
>> +++ b/Documentation/ABI/testing/sysfs-devices-system-cpu
>> @@ -271,3 +271,48 @@ Description:	Parameters for the CPU cache attributes
>>  			- WriteBack: data is written only to the cache line and
>>  				     the modified cache line is written to main
>>  				     memory only when it is replaced
>> +
>> +What:		/sys/devices/system/cpu/cpufreq/chip*/throttle_stats
> 
> What about the chip directory ? Shouldn't that be documented? And
> shouldn't that mention that this is just for powerpc ?
> 
> And before that, I don't think that you are doing this properly. I am
> sorry that I never came to a point where I could review it, and you
> continued with it, version after version.
> 
> But, I really have strong objections to the way this is done. And you
> are making things more complex then they are.
> 
> So, these stats are per-policy, right ?

First of all sorry about the version log.
No these stats are not per-policy. They are per-chip. The throttle event is
common for all cores in the chip.

> 
> Then why aren't they added on the policy->kobj instead, just like
> cpufreq-stats? And maybe inside cpufreq-stats folder only?
> 
> That will solve many complexities you have in place here and will look
> sane as well.
> 
> Right now, you have stats as two places, cpu/cpufreq/chip/ and
> cpu/cpuX/cpufreq/stats/, which doesn't look wise and adds to
> confusion.
> 
> What do you say?
> 

Yes agree that it will be much cleaner with policy->kobj. But using policy->kobj
will result in multiple copies of the throttle-chip stats exported for each
policy in the chip. And moving it to cpu/cpuX/cpufreq/stats/
will add a dependency on CONFIG_CPU_FREQ_STAT

We want throttle attributes to be either in cpu/cpufreq or cpu/cpuX/cpufreq. If
multiple copies is not an issue, then I will move it to cpu/cpuX/cpufreq.

Thanks and Regards,
Shilpa

