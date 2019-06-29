From: Guenter Roeck <linux@roeck-us.net>
Subject: Re: [PATCH v4 3/3] fpga: dfl: fme: add power management support
Date: Sat, 29 Jun 2019 09:21:29 -0700
Message-ID: <7149d96b-da6d-8e03-997f-0611c1654058@roeck-us.net>
References: <1561611218-5800-1-git-send-email-hao.wu@intel.com>
 <1561611218-5800-4-git-send-email-hao.wu@intel.com>
 <20190628175514.GB25890@roeck-us.net> <20190629003308.GA15139@hao-dev>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190629003308.GA15139@hao-dev>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Wu Hao <hao.wu@intel.com>
Cc: mdf@kernel.org, linux-fpga@vger.kernel.org, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, linux-hwmon@vger.kernel.org, jdelvare@suse.com, atull@kernel.org, gregkh@linuxfoundation.org, Luwei Kang <luwei.kang@intel.com>, Xu Yilun <yilun.xu@intel.com>
List-Id: linux-api@vger.kernel.org

On 6/28/19 5:33 PM, Wu Hao wrote:
> On Fri, Jun 28, 2019 at 10:55:14AM -0700, Guenter Roeck wrote:
>> On Thu, Jun 27, 2019 at 12:53:38PM +0800, Wu Hao wrote:
>>> This patch adds support for power management private feature under
>>> FPGA Management Engine (FME). This private feature driver registers
>>> a hwmon for power (power1_input), thresholds information, e.g.
>>> (power1_max / crit / max_alarm / crit_alarm) and also read-only sysfs
>>> interfaces for other power management information. For configuration,
>>> user could write threshold values via above power1_max / crit sysfs
>>> interface under hwmon too.
>>>
>>> Signed-off-by: Luwei Kang <luwei.kang@intel.com>
>>> Signed-off-by: Xu Yilun <yilun.xu@intel.com>
>>> Signed-off-by: Wu Hao <hao.wu@intel.com>
>>> ---
>>> v2: create a dfl_fme_power hwmon to expose power sysfs interfaces.
>>>      move all sysfs interfaces under hwmon
>>>          consumed          --> hwmon power1_input
>>>          threshold1        --> hwmon power1_cap
>>>          threshold2        --> hwmon power1_crit
>>>          threshold1_status --> hwmon power1_cap_status
>>>          threshold2_status --> hwmon power1_crit_status
>>>          xeon_limit        --> hwmon power1_xeon_limit
>>>          fpga_limit        --> hwmon power1_fpga_limit
>>
>> How do those limits differ from the other limits ?
>> We do have powerX_cap and powerX_cap_max, and from the context
>> it appears that you could possibly at least use power1_cap_max
>> (and power1_cap instead of power1_max) instead of
>> power1_fpga_limit.
> 
> Thanks a lot for the review and comments.
> 
> Actually xeon/fpga_limit are introduced for different purpose. It shows
> the power limit of CPU and FPGA, that may be useful in some integrated
> solution, e.g. CPU and FPGA shares power. We should never these
> interfaces as throttling thresholds.
> 

Ok, your call. Just keep in mind that non-standard attributes won't show
up with the sensors command, and won't be visible for libsensors.

>>
>>>          ltr               --> hwmon power1_ltr
>>> v3: rename some hwmon sysfs interfaces to follow hwmon ABI.
>>> 	power1_cap         --> power1_max
>>> 	power1_cap_status  --> power1_max_alarm
>>> 	power1_crit_status --> power1_crit_alarm
>>
>> power1_cap is standard ABI, and since the value is enforced by HW,
>> it should be usable.
> 
> As you see, in thermal management, threshold1 and threshold2 are
> mapped to temp1_max_alarm and temp1_crit_alarm. So we feel that if
> it will be friendly to user that we keep using max_alarm and crit_alarm
> in power management for threshold1 and threshold2 too.
> 
> Do you think if we can keep this, or it's better to switch back to
> power1_cap?
> 

Again, your call.

> 
>>
>>>      update sysfs doc for above sysfs interface changes.
>>>      replace scnprintf with sprintf in sysfs interface.
>>> v4: use HWMON_CHANNEL_INFO.
>>>      update date in sysfs doc.
>>> ---
>>>   Documentation/ABI/testing/sysfs-platform-dfl-fme |  67 +++++++
>>>   drivers/fpga/dfl-fme-main.c                      | 221 +++++++++++++++++++++++
>>>   2 files changed, 288 insertions(+)
>>>
>>> diff --git a/Documentation/ABI/testing/sysfs-platform-dfl-fme b/Documentation/ABI/testing/sysfs-platform-dfl-fme
>>> index 2cd17dc..a669548 100644
>>> --- a/Documentation/ABI/testing/sysfs-platform-dfl-fme
>>> +++ b/Documentation/ABI/testing/sysfs-platform-dfl-fme
>>> @@ -127,6 +127,7 @@ Contact:	Wu Hao <hao.wu@intel.com>
>>>   Description:	Read-Only. Read this file to get the name of hwmon device, it
>>>   		supports values:
>>>   		    'dfl_fme_thermal' - thermal hwmon device name
>>> +		    'dfl_fme_power'   - power hwmon device name
>>>   
>>>   What:		/sys/bus/platform/devices/dfl-fme.0/hwmon/hwmonX/temp1_input
>>>   Date:		June 2019
>>> @@ -183,3 +184,69 @@ Description:	Read-Only. Read this file to get the policy of hardware threshold1
>>>   		(see 'temp1_max'). It only supports two values (policies):
>>>   		    0 - AP2 state (90% throttling)
>>>   		    1 - AP1 state (50% throttling)
>>> +
>>> +What:		/sys/bus/platform/devices/dfl-fme.0/hwmon/hwmonX/power1_input
>>> +Date:		June 2019
>>> +KernelVersion:	5.3
>>> +Contact:	Wu Hao <hao.wu@intel.com>
>>> +Description:	Read-Only. It returns current FPGA power consumption in uW.
>>> +
>>> +What:		/sys/bus/platform/devices/dfl-fme.0/hwmon/hwmonX/power1_max
>>> +Date:		June 2019
>>> +KernelVersion:	5.3
>>> +Contact:	Wu Hao <hao.wu@intel.com>
>>> +Description:	Read-Write. Read this file to get current hardware power
>>> +		threshold1 in uW. If power consumption rises at or above
>>> +		this threshold, hardware starts 50% throttling.
>>> +		Write this file to set current hardware power threshold1 in uW.
>>> +		As hardware only accepts values in Watts, so input value will
>>> +		be round down per Watts (< 1 watts part will be discarded).
>>> +		Write fails with -EINVAL if input parsing fails or input isn't
>>> +		in the valid range (0 - 127000000 uW).
>>> +
>>> +What:		/sys/bus/platform/devices/dfl-fme.0/hwmon/hwmonX/power1_crit
>>> +Date:		June 2019
>>> +KernelVersion:	5.3
>>> +Contact:	Wu Hao <hao.wu@intel.com>
>>> +Description:	Read-Write. Read this file to get current hardware power
>>> +		threshold2 in uW. If power consumption rises at or above
>>> +		this threshold, hardware starts 90% throttling.
>>> +		Write this file to set current hardware power threshold2 in uW.
>>> +		As hardware only accepts values in Watts, so input value will
>>> +		be round down per Watts (< 1 watts part will be discarded).
>>> +		Write fails with -EINVAL if input parsing fails or input isn't
>>> +		in the valid range (0 - 127000000 uW).
>>> +
>>> +What:		/sys/bus/platform/devices/dfl-fme.0/hwmon/hwmonX/power1_max_alarm
>>> +Date:		June 2019
>>> +KernelVersion:	5.3
>>> +Contact:	Wu Hao <hao.wu@intel.com>
>>> +Description:	Read-only. It returns 1 if power consumption is currently at or
>>> +		above hardware threshold1 (see 'power1_max'), otherwise 0.
>>> +
>>> +What:		/sys/bus/platform/devices/dfl-fme.0/hwmon/hwmonX/power1_crit_alarm
>>> +Date:		June 2019
>>> +KernelVersion:	5.3
>>> +Contact:	Wu Hao <hao.wu@intel.com>
>>> +Description:	Read-only. It returns 1 if power consumption is currently at or
>>> +		above hardware threshold2 (see 'power1_crit'), otherwise 0.
>>> +
>>> +What:		/sys/bus/platform/devices/dfl-fme.0/hwmon/hwmonX/power1_xeon_limit
>>> +Date:		June 2019
>>> +KernelVersion:	5.3
>>> +Contact:	Wu Hao <hao.wu@intel.com>
>>> +Description:	Read-Only. It returns power limit for XEON in uW.
>>> +
>>> +What:		/sys/bus/platform/devices/dfl-fme.0/hwmon/hwmonX/power1_fpga_limit
>>> +Date:		June 2019
>>> +KernelVersion:	5.3
>>> +Contact:	Wu Hao <hao.wu@intel.com>
>>> +Description:	Read-Only. It returns power limit for FPGA in uW.
>>> +
>>> +What:		/sys/bus/platform/devices/dfl-fme.0/hwmon/hwmonX/power1_ltr
>>> +Date:		June 2019
>>> +KernelVersion:	5.3
>>> +Contact:	Wu Hao <hao.wu@intel.com>
>>> +Description:	Read-only. Read this file to get current Latency Tolerance
>>> +		Reporting (ltr) value. This ltr impacts the CPU low power
>>> +		state in integrated solution.
>>
>> Does that attribute add any value without any kind of unit or an explanation
>> of its meaning ? What is userspace supposed to do with that information ?
>> Without context, it is just a meaningless number.
> 
> I should add more description here, will fix it in the next version.
> 
>>
>> Also, it appears that the information is supposed to be passed to power
>> management via the set_latency_tolerance() callback. If so, it would be
>> reported there. Would it possibly make more sense to use that interface ?
> 
> If I remember correctly set_latency_tolerance is used to communicate a tolerance
> to device, but actually this is a read-only value, to indicate latency tolerance
> requirement for memory access from FPGA device, as you know FPGA could be
> programmed for different workloads, and different workloads may have different
> latency requirements, if workloads in FPGA don't have any need for immediate
> memory access, then it would be safe for deeper sleep state of system memory.
> 

Hmm, you are correct. Yes, this attribute could definitely benefit from a more
detailed explanation.

Thanks,
Guenter
