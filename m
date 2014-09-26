From: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v2 2/2] perf: Userspace event
Date: Fri, 26 Sep 2014 13:24:24 +0200
Message-ID: <20140926112424.GC9870@gmail.com>
References: <1411491787-25938-1-git-send-email-pawel.moll@arm.com>
 <1411491787-25938-3-git-send-email-pawel.moll@arm.com>
 <87oau5k0u9.fsf@sejong.aot.lge.com>
 <20140924072017.GC990@gmail.com>
 <87y4t6j40p.fsf@sejong.aot.lge.com>
 <1411729190.3852.21.camel@hornet>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1411729190.3852.21.camel@hornet>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Pawel Moll <pawel.moll-5wv7dgnIgG8@public.gmane.org>
Cc: Namhyung Kim <namhyung-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Richard Cochran <richardcochran-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Paul Mackerras <paulus-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, Arnaldo Carvalho de Melo <acme-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, John Stultz <john.stultz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org


* Pawel Moll <pawel.moll-5wv7dgnIgG8@public.gmane.org> wrote:

> On Fri, 2014-09-26 at 07:21 +0100, Namhyung Kim wrote:
>
> > It looks like what trace-marker in ftrace does..  We might 
> > connect output of the trace marker into a perf event somehow.
> 
> I can probably trace_marker's write handler do the same as the 
> new prctl() would do. [...]

Please keep this new facility separate, so that !ftrace kernels 
that have perf events enabled still have this facility, etc.

Thanks,

	Ingo
