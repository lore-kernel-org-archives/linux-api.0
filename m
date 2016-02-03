From: Shilpasri G Bhat <shilpa.bhat@linux.vnet.ibm.com>
Subject: Re: [PATCH v8 6/6] cpufreq: powernv: Add sysfs attributes to show
 throttle stats
Date: Wed, 03 Feb 2016 21:54:41 +0530
Message-ID: <56B229C9.4010909@linux.vnet.ibm.com>
References: <1454442102-1229-1-git-send-email-shilpa.bhat@linux.vnet.ibm.com> <1454442102-1229-7-git-send-email-shilpa.bhat@linux.vnet.ibm.com> <20160203082700.GZ31828@vireshk> <56B1BD71.2050403@linux.vnet.ibm.com> <20160203090357.GA31828@vireshk> <20160203120258.GA32294@in.ibm.com> <20160203140600.GG3469@vireshk>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20160203140600.GG3469@vireshk>
Sender: linux-kernel-owner@vger.kernel.org
To: Viresh Kumar <viresh.kumar@linaro.org>, rjw@rjwysocki.net, Gautham R Shenoy <ego@linux.vnet.ibm.com>
Cc: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org, pc@us.ibm.com, anton@samba.org, shreyas@linux.vnet.ibm.com, bsingharora@gmail.com, mpe@ellerman.id.au, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org


> 
> And now that you have mentioned that to me, why shouldn't this stats
> directory be moved to debugfs ? :)
> 
> We are never going to perform a store here, isn't it ? And is just for
> information, nothing more.
> 

I would very much like to keep the throttle stats either in cpuX/cpufreq or
global cpufreq directory as these are populated by the platform cpufreq driver.

Today we don't have a requirement to a perform a store operation on these files
but we can have it in the future.

Thanks and Regards,
Shilpa
