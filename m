From: Michael Ellerman <mpe-Gsx/Oe8HsFggBc27wqDAHg@public.gmane.org>
Subject: Re: [PATCH 2/2] selftests/timers: change to use shared logic to run
 and install tests
Date: Thu, 19 Mar 2015 11:21:49 +1100
Message-ID: <1426724509.14101.3.camel@ellerman.id.au>
References: <cover.1426286799.git.shuahkh@osg.samsung.com>
	 <e34c7abc6dff5922a45376b7a3085545db66eb6d.1426286799.git.shuahkh@osg.samsung.com>
	 <CALAqxLXApErmHgCzgoo9xkBCZaP59yu=f9WEmmYwTH29ZrDadQ@mail.gmail.com>
	 <1426474128.20210.2.camel@ellerman.id.au>
	 <55099FD8.1080502@osg.samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <55099FD8.1080502-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
Cc: John Stultz <john.stultz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, lkml <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Wed, 2015-03-18 at 09:55 -0600, Shuah Khan wrote:
> On 03/15/2015 08:48 PM, Michael Ellerman wrote:
> > On Fri, 2015-03-13 at 20:14 -0700, John Stultz wrote:
> >> My only thoughts:
> >> 1) Would it be better if threadtest can be made to have better
> >> defaults for kselftest so you don't need that extra logic?
> > 
> > That would help. But with the patch I just sent I think it's no bother, it's
> > only a little extra logic and it's only in the timers Makefile.
> 
> Let's go with a threadtest patch with better defaults. It will emit
> scripts logic as well. Awesome. I just saw John's new patch in my
> Inbox. Thanks.

Fine by me.

> >> 2) While I get that TEST_FILES is likely going to be used to copy the
> >> destructive tests over, It feels a little like its being bundled in
> >> with something like data files that tests might need, which seems sort
> >> of hackish. Would TEST_PROGS_EXTENDED or something be more clear and
> >> make more sense?
> > 
> > That doesn't really bother me. You're right that TEST_FILES is originally
> > intended for data files etc. but I don't think it's a big hack to use it for
> > other tests that shouldn't be run by default. Still if it bothers you I'm happy
> > to add a separate variable for it, they are cheap :)
> 
> Could you please make the change from TEST_FILES to TEST_PROGS_EXTENDED
> which is definitely better than overloading TEST_FILES?

I don't see the point, but I don't care that much.

> I think this would probably only change Add Install target patch. You
> can send me patch v5 with that change and I will override the next with
> your new one. Thanks for doing this.

You shouldn't rebase your next branch, people may have already merged it (like
me). You should apply it as an additional patch on top.

Patch sent.

cheers
