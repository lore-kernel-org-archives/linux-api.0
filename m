From: Christopher Covington <cov-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
Subject: Re: [PATCH 0/2] perf: User/kernel time correlation and event generation
Date: Thu, 18 Sep 2014 11:02:35 -0400
Message-ID: <541AF40B.7070604@codeaurora.org>
References: <1411050873-9310-1-git-send-email-pawel.moll@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1411050873-9310-1-git-send-email-pawel.moll-5wv7dgnIgG8@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Pawel Moll <pawel.moll-5wv7dgnIgG8@public.gmane.org>
Cc: Richard Cochran <richardcochran-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Paul Mackerras <paulus-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, Arnaldo Carvalho de Melo <acme-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, John Stultz <john.stultz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Hi Pawel,

On 09/18/2014 10:34 AM, Pawel Moll wrote:
> Greetings,
> 
> This is a second spin of the short series posted last week:
> 
> http://www.spinics.net/lists/kernel/msg1824419.html
> 
> The first patch adds an additional timestamp field in the perf
> sample data, which can be requested for any perf event along
> with normal PERF_SAMPLE_TIME. Events with both values appearing
> periodically in the perf data allow user code to translate
> raw monotonic time (obtained via POSIX clock API) to sched_clock
> domain. Although any perf event can be used, the natural choice
> would be a sched_switch trace event (for processes with root
> permissions) or a hrtimer-based PERF_COUNT_SW_CPU_CLOCK.
> 
> It didn't attract any comments previously, so is just re-posted
> without any changes.
> 
> The second patch, functionally orthogonal but complementing
> the first one, builds on the ftrace "trace_maker" idea. It adds
> a ioctl that can be used to inject a userspace-generated data
> into the perf buffer. It provides base for printf-like
> functionality in perf world. If used with the previous patch,
> it can be also used to provide synchronisation points for sched
> vs. raw monotonic time stamps correlation.
> 
> First version of the patch was taking a zero-terminated string
> as an argument. Now it is taking a custom structure with "type"
> and "size" integer fields followed by data. Type value "0"
> is defined as a zero-terminated string (although size, including
> the NULL character, must still be provided), but meaning of data
> for other types is of no interest for the kernel. The intention
> is to host a list of "well known" types (with reference parsers
> for them) in the user perf tool code.

Would it be possible for you to also update the corresponding man pages?

https://www.kernel.org/doc/man-pages/

Thanks,
Christopher

-- 
Employee of Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by the Linux Foundation.
