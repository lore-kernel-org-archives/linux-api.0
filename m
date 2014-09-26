From: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 2/2] perf: Userspace software event and ioctl
Date: Fri, 26 Sep 2014 13:31:34 +0200
Message-ID: <20140926113134.GA14072@gmail.com>
References: <1411050873-9310-1-git-send-email-pawel.moll@arm.com>
 <1411050873-9310-3-git-send-email-pawel.moll@arm.com>
 <1411491764.3922.46.camel@hornet>
 <20140924074942.GB3797@gmail.com>
 <1411665649.4768.84.camel@hornet>
 <20140925183342.GB6854@gmail.com>
 <1411728487.3852.9.camel@hornet>
 <20140926112312.GB9870@gmail.com>
 <1411730797.3852.23.camel@hornet>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1411730797.3852.23.camel@hornet>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Pawel Moll <pawel.moll-5wv7dgnIgG8@public.gmane.org>
Cc: Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Arnaldo Carvalho de Melo <acme-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Richard Cochran <richardcochran-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Paul Mackerras <paulus-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, John Stultz <john.stultz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org


* Pawel Moll <pawel.moll-5wv7dgnIgG8@public.gmane.org> wrote:

> On Fri, 2014-09-26 at 12:23 +0100, Ingo Molnar wrote:
> > > As in: allows *all* tasks to inject the data? Are you sure we 
> > > don't want more fine-grained control, in particular per task?
> > 
> > Yeah. If the profiler allows it, then any task that is being 
> > traced can inject data.
> 
> The "that is being traced" fragment was the key here. I missed 
> the fact that perf trace already takes a list of pids, so we're 
> not talking about all tasks in the system. That should work.

Yeah, when we generate a user trace event, we should look at the 
currently active perf context's (percpu ones plus task ones), and 
inject into those only.

This way we limit event generation to those buffers that are 
actively interested in this task.

Thanks,

	Ingo
