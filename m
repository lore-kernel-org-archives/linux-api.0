From: Shilpasri G Bhat <shilpa.bhat@linux.vnet.ibm.com>
Subject: Re: [PATCH v7 6/6] cpufreq: powernv: Add sysfs attributes to show
 throttle stats
Date: Thu, 28 Jan 2016 15:24:52 +0530
Message-ID: <56A9E56C.1050505@linux.vnet.ibm.com>
References: <1453965941-7363-1-git-send-email-shilpa.bhat@linux.vnet.ibm.com> <1453965941-7363-7-git-send-email-shilpa.bhat@linux.vnet.ibm.com> <20160128084041.GK3935@vireshk> <56A9E136.8090900@linux.vnet.ibm.com> <20160128094146.GO3935@vireshk>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20160128094146.GO3935@vireshk>
Sender: linux-kernel-owner@vger.kernel.org
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org, rjw@rjwysocki.net, linux-pm@vger.kernel.org, pc@us.ibm.com, anton@samba.org, ego@linux.vnet.ibm.com, shreyas@linux.vnet.ibm.com, bsingharora@gmail.com, mpe@ellerman.id.au, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org



On 01/28/2016 03:11 PM, Viresh Kumar wrote:
> On 28-01-16, 15:06, Shilpasri G Bhat wrote:
>> No these stats are not per-policy. They are per-chip. The throttle event is
>> common for all cores in the chip.
> 
> How do you define a chip? And how is it different then the group of
> CPUs represented by the policy ?
> 

Chip is a group of policies.
Hmm yes I see your point. We anyways maintain frequency stats which is
per-policy. We might as well have throttle stats exported per-policy which
points to per-chip data.
