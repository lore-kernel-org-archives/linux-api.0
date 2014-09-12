From: Arnaldo Carvalho de Melo <acme-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [RFC 2/2] perf: Marker software event and ioctl
Date: Fri, 12 Sep 2014 17:44:44 -0300
Message-ID: <20140912204444.GA11199@kernel.org>
References: <1410522513-1045-1-git-send-email-pawel.moll@arm.com>
 <1410522513-1045-3-git-send-email-pawel.moll@arm.com>
 <54132F63.1010401@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <54132F63.1010401-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David Ahern <dsahern-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Pawel Moll <pawel.moll-5wv7dgnIgG8@public.gmane.org>, Richard Cochran <richardcochran-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Paul Mackerras <paulus-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, John Stultz <john.stultz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

Em Fri, Sep 12, 2014 at 10:37:39AM -0700, David Ahern escreveu:
> On 9/12/14, 4:48 AM, Pawel Moll wrote:
> >This patch adds a PERF_COUNT_SW_MARKER event type, which
> >can be requested by user and a PERF_EVENT_IOC_MARKER
> >ioctl command which will inject an event of said type into
> >the perf buffer. The ioctl can take a zero-terminated
> >string argument, similar to tracing_marker in ftrace,
> >which will be kept in the "raw" field of the sample.
> >
> >The main use case for this is synchronisation of
> >performance data generated in user space with the perf
> >stream coming from the kernel. For example, the marker
> >can be inserted by a JIT engine after it generated
> >portion of the code, but before the code is executed
> >for the first time, allowing the post-processor to
> >pick the correct debugging information. Other example
> >is a system profiling tool taking data from other
> >sources than just perf, which generates a marker
> >at the beginning at at the end of the session
> >(also possibly periodically during the session) to
> >synchronise kernel timestamps with clock values
> >obtained in userspace (gtod or raw_monotonic).
> 
> Seems really similar to what I proposed in the past:
> 
> https://lkml.org/lkml/2011/2/27/159
> 
> Which was rejected.

I took a look at that thread, but just barely, emphasis on that.

Injecting something from userspace, a la ftrace, seems to be something,
as tglx mentioned, "buried" in that patchset.

- Arnaldo
