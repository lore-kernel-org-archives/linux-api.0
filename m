From: Pawel Moll <pawel.moll-5wv7dgnIgG8@public.gmane.org>
Subject: Re: [PATCH 2/2] perf: Userspace software event and ioctl
Date: Fri, 26 Sep 2014 11:48:07 +0100
Message-ID: <1411728487.3852.9.camel@hornet>
References: <1411050873-9310-1-git-send-email-pawel.moll@arm.com>
	 <1411050873-9310-3-git-send-email-pawel.moll@arm.com>
	 <1411491764.3922.46.camel@hornet> <20140924074942.GB3797@gmail.com>
	 <1411665649.4768.84.camel@hornet> <20140925183342.GB6854@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20140925183342.GB6854-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Arnaldo Carvalho de Melo <acme-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Richard Cochran <richardcochran-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Paul Mackerras <paulus-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, John Stultz <john.stultz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Thu, 2014-09-25 at 19:33 +0100, Ingo Molnar wrote:
> > How would we select tasks that can write to a given buffer? Maybe an
> > ioctl() on a perf fd? Something like this?
> > 
> > 	ioctl(perf_fd, PERF_EVENT_IOC_ENABLE_UEVENT, pid);
> > 	ioctl(perf_fd, PERF_EVENT_IOC_DISABLE_UEVENT, pid);
> 
> No, I think there's a simpler way: this should be a regular 
> perf_attr flag, which defaults to '0' (tasks cannot do this), but 
> which can be set to 1 if the profiler explicitly allows such 
> event injection.

As in: allows *all* tasks to inject the data? Are you sure we don't want
more fine-grained control, in particular per task?

If we have two buffers, both created with the "injecting allowed" flag,
do we inject a given uevent into both of them?

> I.e. whether user-events are allowed is controlled by the 
> profiling/tracing context, via the regular perf syscall. It would 
> propagate into the perf context, so it would be easy to check at 
> event generation time.

It would definitely be the profiling/tracing tools that would decide if
the injection is allowed, no question about that. I just feel that it
should be able to select the tasks that can do that, not just flip a big
switch saying "everyone is welcome". Other question is: should a
non-root context be able to receive events from root processes? Wouldn't
it be a security hole (for example, it could be used as a kind of covert
channel)? Maybe we should do what ptrace does? As in: if a task can
ptrace another task, it can also receive uevents from it.

Pawel
