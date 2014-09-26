From: Pawel Moll <pawel.moll@arm.com>
Subject: Re: [PATCH v2 1/2] perf: Add sampling of the raw monotonic clock
Date: Fri, 26 Sep 2014 16:05:59 +0100
Message-ID: <1411743959.3852.45.camel@hornet>
References: <1411491787-25938-1-git-send-email-pawel.moll@arm.com>
	 <1411491787-25938-2-git-send-email-pawel.moll@arm.com>
	 <87sijhk21x.fsf@sejong.aot.lge.com> <1411642198.4768.30.camel@hornet>
	 <8738bekith.fsf@sejong.aot.lge.com>  <1411729103.3852.19.camel@hornet>
	 <1411742306.1669.6.camel@leonhard>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1411742306.1669.6.camel@leonhard>
Sender: linux-kernel-owner@vger.kernel.org
To: Namhyung Kim <namhyung@kernel.org>
Cc: Richard Cochran <richardcochran@gmail.com>, Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Paul Mackerras <paulus@samba.org>, Arnaldo Carvalho de Melo <acme@kernel.org>, John Stultz <john.stultz@linaro.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Fri, 2014-09-26 at 15:38 +0100, Namhyung Kim wrote:
> > Then I have loads of normal normal samples, timestamped with sched clock
> > only, and every now and then one with both timestamps which then I can
> > use for time correlation. The whole point is that the frequency of such
> > "synchronisation" event can be much (much!) lower than of the normal
> > samples, but it still allows pretty good approximation (I was getting
> > accuracy of ~1 microsecond and better with sched_switch trace event
> > marked with additional raw monotonic timestamp).
> 
> Okay.  But in that case wouldn't it be enough to use just a single
> timestamp for each event - sched_clock for cpu-cycles and monotonic raw
> for sched_switch?

To do the correlation you need both timestamps to be "taken"
simultaneously:

        perf event     user event
       -----O--------------+-------------O------> t_mono
            :              |             :
            :              V             :
       -----O----------------------------O------> t_perf

Of course it's not possible get both values literally at the same time,
but placing them in a atomic context a couple of instructions from each
other still gives pretty good results. The larger this distance is, the
lower the accuracy will be. I must admit I haven't done such
experiments, but let me remind that I in my test I was getting results
in the range of 1000ns, with a single cycle of a 2GHz taking 0.5ns, so
moving the t_mono/t_perf value sampling further aside will reduce it
significantly...

Pawel

Pawel
