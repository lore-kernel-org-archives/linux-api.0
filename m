From: Viresh Kumar <viresh.kumar-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v8 6/6] cpufreq: powernv: Add sysfs attributes to show
 throttle stats
Date: Thu, 4 Feb 2016 07:21:03 +0530
Message-ID: <20160204015103.GM3469@vireshk>
References: <1454442102-1229-1-git-send-email-shilpa.bhat@linux.vnet.ibm.com>
 <1454442102-1229-7-git-send-email-shilpa.bhat@linux.vnet.ibm.com>
 <20160203082700.GZ31828@vireshk>
 <56B1BD71.2050403@linux.vnet.ibm.com>
 <20160203090357.GA31828@vireshk>
 <20160203120258.GA32294@in.ibm.com>
 <20160203140600.GG3469@vireshk>
 <56B229C9.4010909@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <56B229C9.4010909-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Shilpasri G Bhat <shilpa.bhat-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Cc: rjw-LthD3rsA81gm4RdzfppkhA@public.gmane.org, Gautham R Shenoy <ego-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, linuxppc-dev-mnsaURCQ41sdnm+yROfE0A@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-pm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, pc-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org, anton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org, shreyas-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org, bsingharora-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, mpe-Gsx/Oe8HsFggBc27wqDAHg@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On 03-02-16, 21:54, Shilpasri G Bhat wrote:
> 
> > 
> > And now that you have mentioned that to me, why shouldn't this stats
> > directory be moved to debugfs ? :)
> > 
> > We are never going to perform a store here, isn't it ? And is just for
> > information, nothing more.
> > 
> 
> I would very much like to keep the throttle stats either in cpuX/cpufreq or
> global cpufreq directory as these are populated by the platform cpufreq driver.
> 
> Today we don't have a requirement to a perform a store operation on these files
> but we can have it in the future.

No issues.

-- 
viresh
