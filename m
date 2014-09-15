From: Pawel Moll <pawel.moll-5wv7dgnIgG8@public.gmane.org>
Subject: Re: [RFC 2/2] perf: Marker software event and ioctl
Date: Mon, 15 Sep 2014 18:18:37 +0100
Message-ID: <1410801517.3817.13.camel@hornet>
References: <1410522513-1045-1-git-send-email-pawel.moll@arm.com>
	 <1410522513-1045-3-git-send-email-pawel.moll@arm.com>
	 <54132F63.1010401@gmail.com> <20140912204444.GA11199@kernel.org>
	 <5415B790.5010607@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5415B790.5010607-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David Ahern <dsahern-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Arnaldo Carvalho de Melo <acme-f8uhVLnGfZaxAyOMLChx1axOck334EZe@public.gmane.org>, Richard Cochran <richardcochran-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Paul Mackerras <paulus-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, John Stultz <john.stultz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Sun, 2014-09-14 at 16:43 +0100, David Ahern wrote:
> >> Seems really similar to what I proposed in the past:

Yeah, it wasn't really hard to come with similar conclusions :-)

> >> https://lkml.org/lkml/2011/2/27/159
> >>
> >> Which was rejected.
> >
> > I took a look at that thread, but just barely, emphasis on that.
> >
> > Injecting something from userspace, a la ftrace, seems to be something,
> > as tglx mentioned, "buried" in that patchset.
> 
> Thomas object to an ioctl buried deep in a patch -- newbie mistake.
> 
> Peter objected to the ioctl https://lkml.org/lkml/2011/3/1/229
> 
> It was not userspace injecting random data into the stream but rather 
> forcing the sample to be generated and added to the stream.

I would like to hear from Peter and others. If not here, I'll get them
to talk next month on Linux Plumbers :-)

Pawel
