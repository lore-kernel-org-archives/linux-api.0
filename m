From: Pawel Moll <pawel.moll@arm.com>
Subject: Re: [PATCH v2 1/2] perf: Add sampling of the raw monotonic clock
Date: Mon, 29 Sep 2014 15:47:36 +0100
Message-ID: <1412002056.3817.10.camel@hornet>
References: <1411491787-25938-1-git-send-email-pawel.moll@arm.com>
	 <1411491787-25938-2-git-send-email-pawel.moll@arm.com>
	 <87sijhk21x.fsf@sejong.aot.lge.com> <1411642198.4768.30.camel@hornet>
	 <8738bekith.fsf@sejong.aot.lge.com>  <1411729103.3852.19.camel@hornet>
	 <1411742306.1669.6.camel@leonhard> <1411743959.3852.45.camel@hornet>
	 <5425BD94.4030006@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <5425BD94.4030006@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: David Ahern <dsahern@gmail.com>
Cc: Namhyung Kim <namhyung@kernel.org>, Richard Cochran <richardcochran@gmail.com>, Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Paul Mackerras <paulus@samba.org>, Arnaldo Carvalho de Melo <acme@kernel.org>, John Stultz <john.stultz@linaro.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Fri, 2014-09-26 at 20:25 +0100, David Ahern wrote:
> On 9/26/14, 9:05 AM, Pawel Moll wrote:
> > To do the correlation you need both timestamps to be "taken"
> > simultaneously:
> >
> >          perf event     user event
> >         -----O--------------+-------------O------> t_mono
> >              :              |             :
> >              :              V             :
> >         -----O----------------------------O------> t_perf
> >
> > Of course it's not possible get both values literally at the same time,
> > but placing them in a atomic context a couple of instructions from each
> > other still gives pretty good results. The larger this distance is, the
> 
> An early patchset on this topic added the realtime clock as an event and 
> an ioctl was used to push a sample into the event stream. 

Yeah, I remember. If I remember correctly correctly the pushback was on
a custom event type, right?

Generally speaking I don't mind any solution that we'll get us to the
place both you and I want to be (just being able to time stamp some
performance data in userspace, how difficult can this be! ;-) but I like
the flexibility of an extra sample - one can pick and mix events and
samples at one's leisure.

> In that case 
> you have wall clock and perf-clock samples taken in the same kernel 
> context and about as close together as you can get.

Yep, that's what I was saying - we can't quite get two timestamps at the
*same*, but getting them within a single atomic block of instructions
gives reasonable accuracy.

Thanks!

Pawel
