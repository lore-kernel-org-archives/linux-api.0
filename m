From: Pawel Moll <pawel.moll-5wv7dgnIgG8@public.gmane.org>
Subject: Re: [PATCH v3 0/3] perf: User/kernel time correlation and event
 generation
Date: Tue, 04 Nov 2014 15:07:12 +0000
Message-ID: <1415113632.24819.4.camel@arm.com>
References: <1415060918-19954-1-git-send-email-pawel.moll@arm.com>
	 <CALCETrXGoevmD_avz5sQfbbD624vpLW5=-8ovzTPT_5wzNFnVA@mail.gmail.com>
	 <CALAqxLXfy5P0kg-W7hL+Jf1iYv758+-2cTdZwsY8kAns1nvEmg@mail.gmail.com>
	 <CALCETrUAkXKyXzZy4xaYcW2f65Lh=APrU4cFU1zm-qmc6EwB8g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CALCETrUAkXKyXzZy4xaYcW2f65Lh=APrU4cFU1zm-qmc6EwB8g-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
Cc: John Stultz <john.stultz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Richard Cochran <richardcochran-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Paul Mackerras <paulus-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, Arnaldo Carvalho de Melo <acme-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Masami Hiramatsu <masami.hiramatsu.pt-FCd8Q96Dh0JBDgjK7y7TUQ@public.gmane.org>, Christopher Covington <cov-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, Namhyung Kim <namhyung-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, David Ahern <dsahern-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Tomeu Vizoso <tomeu-XCtybt49RKsYaV1qd6yewg@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Tue, 2014-11-04 at 01:25 +0000, Andy Lutomirski wrote:
> >> If you're going to add double-stamped packets, can you also add a
> >> syscall to read multiple clocks at once, atomically?  Or can you
> >> otherwise add a non-perf mechanism to get at this data?
> >
> > I've got some thoughts on what a possible interface that wouldn't b=
e
> > awful could look like, but I'm still hesitant because I don't reall=
y
> > know if exposing this sort of data is actually a good idea long ter=
m.
>=20
> My only real thought here is that, if perf is going to try to do this=
,
> then presumably it should be reasonably integrated w/ the core timing
> code.  I.e. if perf does this, then presumably the core code should
> know about it and there should be a core interface to it.

I think I understand where you're coming from. Arnd's idea for the API
seems reasonable, although I can't promise implementing a proposal
(don't make me stop you from doing it :-).

As to the perf-specific correlation, I'm assuming limited accuracy.
Others already mentioned that in the absence of hardware support, the
time values are never really "atomic". The best what can be done is to
access them as near to each other in the code as possible and make sure
it happens in a non-preemptible section. In my tests I've achieved, on
average, sub-microsecond accuracy, which was good enough from my
perspective, but it's far from ideal 42ns resolution for my (just an
example) time source clocked at 24MHz.

Pawe=C5=82
