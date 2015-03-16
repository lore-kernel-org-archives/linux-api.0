From: Michael Ellerman <mpe-Gsx/Oe8HsFggBc27wqDAHg@public.gmane.org>
Subject: Re: [PATCH 2/2] selftests/timers: change to use shared logic to run
 and install tests
Date: Mon, 16 Mar 2015 13:48:48 +1100
Message-ID: <1426474128.20210.2.camel@ellerman.id.au>
References: <cover.1426286799.git.shuahkh@osg.samsung.com>
	 <e34c7abc6dff5922a45376b7a3085545db66eb6d.1426286799.git.shuahkh@osg.samsung.com>
	 <CALAqxLXApErmHgCzgoo9xkBCZaP59yu=f9WEmmYwTH29ZrDadQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CALAqxLXApErmHgCzgoo9xkBCZaP59yu=f9WEmmYwTH29ZrDadQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: John Stultz <john.stultz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, lkml <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Fri, 2015-03-13 at 20:14 -0700, John Stultz wrote:
> On Fri, Mar 13, 2015 at 3:57 PM, Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org> wrote:
> > Change the timers Makefile to make use of shared run and install
> > logic in lib.mk. Destructive tests are installed. Regular tests
> > are emited to run_kselftest script to match the run_tests behavior.
> >
> > Signed-off-by: Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
> > ---
> >  tools/testing/selftests/timers/Makefile | 20 +++++++++++---------
> >  1 file changed, 11 insertions(+), 9 deletions(-)
> >
> > diff --git a/tools/testing/selftests/timers/Makefile b/tools/testing/selftests/timers/Makefile
> > index 9da3498..61e7284 100644
> > --- a/tools/testing/selftests/timers/Makefile
> > +++ b/tools/testing/selftests/timers/Makefile
> > @@ -7,19 +7,21 @@ bins = posix_timers nanosleep inconsistency-check nsleep-lat raw_skew \
> >         alarmtimer-suspend change_skew skew_consistency clocksource-switch \
> >         leap-a-day leapcrash set-tai set-2038
> >
> > +TEST_PROGS = posix_timers nanosleep nsleep-lat set-timer-lat mqueue-lat \
> > +               inconsistency-check raw_skew
> > +TEST_FILES = threadtest alarmtimer-suspend valid-adjtimex change_skew \
> > +               skew_consistency clocksource-switch leap-a-day leapcrash \
> > +               set-tai set-2038
> > +
> > +RUN_TESTS_WITH_ARGS := ./threadtest -t 30 -n 8 || echo "selftests: threadtest [FAIL]"
> > +
> > +EMIT_TESTS_WITH_ARGS := echo "$(RUN_TESTS_WITH_ARGS)"
> > +
> 
> So my make-foo isn't very strong, but no objections from me.
> 
> My only thoughts:
> 1) Would it be better if threadtest can be made to have better
> defaults for kselftest so you don't need that extra logic?

That would help. But with the patch I just sent I think it's no bother, it's
only a little extra logic and it's only in the timers Makefile.

> 2) While I get that TEST_FILES is likely going to be used to copy the
> destructive tests over, It feels a little like its being bundled in
> with something like data files that tests might need, which seems sort
> of hackish. Would TEST_PROGS_EXTENDED or something be more clear and
> make more sense?

That doesn't really bother me. You're right that TEST_FILES is originally
intended for data files etc. but I don't think it's a big hack to use it for
other tests that shouldn't be run by default. Still if it bothers you I'm happy
to add a separate variable for it, they are cheap :)

cheers
