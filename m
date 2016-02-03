From: Viresh Kumar <viresh.kumar@linaro.org>
Subject: Re: [PATCH v8 6/6] cpufreq: powernv: Add sysfs attributes to show
 throttle stats
Date: Wed, 3 Feb 2016 14:33:57 +0530
Message-ID: <20160203090357.GA31828@vireshk>
References: <1454442102-1229-1-git-send-email-shilpa.bhat@linux.vnet.ibm.com>
 <1454442102-1229-7-git-send-email-shilpa.bhat@linux.vnet.ibm.com>
 <20160203082700.GZ31828@vireshk>
 <56B1BD71.2050403@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <56B1BD71.2050403@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Shilpasri G Bhat <shilpa.bhat@linux.vnet.ibm.com>
Cc: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org, rjw@rjwysocki.net, linux-pm@vger.kernel.org, pc@us.ibm.com, anton@samba.org, ego@linux.vnet.ibm.com, shreyas@linux.vnet.ibm.com, bsingharora@gmail.com, mpe@ellerman.id.au, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On 03-02-16, 14:12, Shilpasri G Bhat wrote:
> I need the chip-id in the <attr>_show(). With just sysfs_create_group() I will
> get the cpufreq_global_kobject in the <attr>_show() and I will not be able to
> figure out the chip-id.

The more I look at it, the more I am convinced that keeping this
'chip' directory in /sys/devices/system/cpu/cpuX/cpufreq/ makes sense.

So, here is the deal:
- A 'chip' on your platforms can contain multiple group of CPUs, which
  are represented by policies in cpufreq core. i.e. A chip can have
  multiple policies.
- All CPUs present on the same chip are subject to same throttling
  outcomes.
- Right now you are putting the 'chip' directory in cpu/cpufreq/
  directory. Because that directory isn't specific to a policy, but
  entire cpufreq subsystem, you can't get a policy->cpu in the code
  for the kobject in question. And so you are *forced* to create a
  kobject, so that you can do container_of() and get chip->id.
- And then you also need to unnecessarily add another field in the
  chip directory 'chip_mask', that is nothing but an bitwise OR
  operation on policy->related_cpus, so that userspace can know which
  policies/CPUs are managed by the 'chip'.

What I can suggest is:
- Move this directory inside cpuX/cpufreq/ directory, in a similar way
  as to how we create 'stats' directory today.
- You can then get policy->cpu, to get chip->id out of it.
- The only disadvantage here is that the same chip directory will be
  replicated in multiple policies, but that makes it more readable.

Thoughts ?

-- 
viresh
