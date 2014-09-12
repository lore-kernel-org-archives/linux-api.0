From: Christopher Covington <cov-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
Subject: Re: [RFC 2/2] perf: Marker software event and ioctl
Date: Fri, 12 Sep 2014 10:00:09 -0400
Message-ID: <5412FC69.8080709@codeaurora.org>
References: <1410522513-1045-1-git-send-email-pawel.moll@arm.com>  <1410522513-1045-3-git-send-email-pawel.moll@arm.com>  <5412EA7A.9020807@codeaurora.org> <1410526672.16936.52.camel@hornet>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1410526672.16936.52.camel@hornet>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Pawel Moll <pawel.moll-5wv7dgnIgG8@public.gmane.org>
Cc: Richard Cochran <richardcochran-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Paul Mackerras <paulus-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, Arnaldo Carvalho de Melo <acme-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, John Stultz <john.stultz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On 09/12/2014 08:57 AM, Pawel Moll wrote:
> On Fri, 2014-09-12 at 13:43 +0100, Christopher Covington wrote:
>> Just to ask the dumb questions in case the answers I've come up with are
>> wrong: What is PAGE_SIZE on an arm64 kernel? 
> 
> It's either 4 or 64k, depending on CONFIG_ARM64_64K_PAGES.
> 
>> How does userspace know?
>>
> #include <unistd.h>
> #include <stdio.h>
> 
> int main(void)
> {
> 	printf("%ld\n", sysconf(_SC_PAGESIZE));
> 	return 0;
> }

Oh excellent, that actually works. Based on a misreading of the glibc code I
thought it was hard-coded to 64K.

Thanks,
Christopher

-- 
Employee of Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by the Linux Foundation.
