From: Namhyung Kim <namhyung@kernel.org>
Subject: Re: [PATCH v2 1/2] perf: Add sampling of the raw monotonic clock
Date: Fri, 26 Sep 2014 23:38:26 +0900
Message-ID: <1411742306.1669.6.camel@leonhard>
References: <1411491787-25938-1-git-send-email-pawel.moll@arm.com>
	 <1411491787-25938-2-git-send-email-pawel.moll@arm.com>
	 <87sijhk21x.fsf@sejong.aot.lge.com> <1411642198.4768.30.camel@hornet>
	 <8738bekith.fsf@sejong.aot.lge.com>  <1411729103.3852.19.camel@hornet>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1411729103.3852.19.camel@hornet>
Sender: linux-kernel-owner@vger.kernel.org
To: Pawel Moll <pawel.moll@arm.com>
Cc: Richard Cochran <richardcochran@gmail.com>, Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Paul Mackerras <paulus@samba.org>, Arnaldo Carvalho de Melo <acme@kernel.org>, John Stultz <john.stultz@linaro.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

2014-09-26 (=EA=B8=88), 11:58 +0100, Pawel Moll:
> On Fri, 2014-09-26 at 07:16 +0100, Namhyung Kim wrote:
> > > It would be doable, I guess, but what
> > > if someone *wants* to have sched clock as the timestamps source (=
because
> > > it's cheap) but still be able to correlate them with userspace? I=
n this
> > > case two separate timestamps are required to do the approximation=
=2E
> >=20
> > But by collecting two timestamps, you'll loose the win of the first
> > timestamp, no?
>=20
> But I can ask for both timestamps only being collected on "low
> bandwidth" events, in particular context switches and/or periodic (eg=
=2E
> 10ms hrtimer) software events.
>=20
> Then I have loads of normal normal samples, timestamped with sched cl=
ock
> only, and every now and then one with both timestamps which then I ca=
n
> use for time correlation. The whole point is that the frequency of su=
ch
> "synchronisation" event can be much (much!) lower than of the normal
> samples, but it still allows pretty good approximation (I was getting
> accuracy of ~1 microsecond and better with sched_switch trace event
> marked with additional raw monotonic timestamp).

Okay.  But in that case wouldn't it be enough to use just a single
timestamp for each event - sched_clock for cpu-cycles and monotonic raw
for sched_switch?


>=20
> Pawel
>=20
> PS. Have you sent a couple of the messages via some kind of gmane's
> proxy? All the mail addresses got rather messed up...
>=20

Yes, I use gnus to communicate with lkml, but it seems it messed up mai=
l
addresses if it contains some list (like linux-api ?).  Sorry about
that.

Thanks,
Namhyung
