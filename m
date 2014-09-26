From: Pawel Moll <pawel.moll-5wv7dgnIgG8@public.gmane.org>
Subject: Re: [PATCH 2/2] perf: Userspace software event and ioctl
Date: Fri, 26 Sep 2014 12:26:37 +0100
Message-ID: <1411730797.3852.23.camel@hornet>
References: <1411050873-9310-1-git-send-email-pawel.moll@arm.com>
	 <1411050873-9310-3-git-send-email-pawel.moll@arm.com>
	 <1411491764.3922.46.camel@hornet> <20140924074942.GB3797@gmail.com>
	 <1411665649.4768.84.camel@hornet> <20140925183342.GB6854@gmail.com>
	 <1411728487.3852.9.camel@hornet> <20140926112312.GB9870@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20140926112312.GB9870-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Arnaldo Carvalho de Melo <acme-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Richard Cochran <richardcochran-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Paul Mackerras <paulus-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, John Stultz <john.stultz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Fri, 2014-09-26 at 12:23 +0100, Ingo Molnar wrote:
> > As in: allows *all* tasks to inject the data? Are you sure we=20
> > don't want more fine-grained control, in particular per task?
>=20
> Yeah. If the profiler allows it, then any task that is being=20
> traced can inject data.

The "that is being traced" fragment was the key here. I missed the fact
that perf trace already takes a list of pids, so we're not talking abou=
t
all tasks in the system. That should work.

Pawe=C5=82
