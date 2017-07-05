From: Daniel Vetter <daniel.vetter-/w4YWyX8dFk@public.gmane.org>
Subject: Re: [Ksummit-discuss] [MAINTAINERS SUMMIT] & [TECH TOPIC] Improve
 regression tracking
Date: Wed, 5 Jul 2017 20:24:26 +0200
Message-ID: <CAKMK7uEGrNH-VGh=cX5y77F-=b+VZfnBzGPh3a1MQYNuohO2pg@mail.gmail.com>
References: <576cea07-770a-4864-c3f5-0832ff211e94@leemhuis.info>
 <20170703123025.7479702e@gandalf.local.home> <ad94dc65-cc9c-f4f1-27c1-5a48603c7f59@leemhuis.info>
 <20170705084528.67499f8c@gandalf.local.home> <4080ecc7-1aa8-2940-f230-1b79d656cdb4@redhat.com>
 <20170705092757.63dc2328@gandalf.local.home> <20170705140607.GA30187@kroah.com>
 <20170705143341.oees22k2snhtmkxo@sirena.org.uk> <20170705103658.226099c6@gandalf.local.home>
 <1499266228.3668.10.camel@HansenPartnership.com> <20170705105651.5da9c969@gandalf.local.home>
 <1499267389.3668.16.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1499267389.3668.16.camel-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: James Bottomley <James.Bottomley-JuX6DAaQMKPCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>
Cc: Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Carlos O'Donell <carlos-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "open list:ABI/API" <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>, "ksummit-discuss-cunTk1MwBs98uUxBSJOaYoYkZiVZrdSR2LY78lusg7I@public.gmane.org" <ksummit-discuss-cunTk1MwBs98uUxBSJOaYoYkZiVZrdSR2LY78lusg7I@public.gmane.org>, Thorsten Leemhuis <linux-rCxcAJFjeRkk+I/owrrOrA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Wed, Jul 5, 2017 at 5:09 PM, James Bottomley
<James.Bottomley-JuX6DAaQMKPCXq6kfMZ53/egYHeGw8Jk@public.gmane.org> wrote:
>> > > All tests should be run with lockdep enabled ;-)  Which a
>> > > surprising few developers appear to do :-p
>> >
>> > Lockdep checks the locking hierarchies and makes assumptions about
>> > them which it then validates ... it doesn't tell you if the data
>> > you think
>>
>> We should probably look at adding infrastructure that helps in that.
>> RCU already has a lot of there to help know if data is being
>> protected by RCU or not.
>>
>> Hmm, maybe we could add a __rcu like type that we can associate
>> protected data with, where a config can associate access to a
>> variable with a lock being held?
>
> That's about 10x more complex than the releases/acquires/must_hold
> annotation, which we have fairly dismal coverage on.

Yeah, I've never found those useful at all. What we're trying to do in
drm code is liberally sprinkle lockdep_assert_held into accessor and
helper functions (there's lots of nontrivial stuff where you need a
little bit of computation around a pure access, so doesn't result in
ugly code). That catches a lot of these, but of course not all.

The problem with static annotations is that often the lock you need to
hold isn't statically known, and annotating the entire callchain is a
no-go as James points out. But maybe we could use such annotations
plus a gcc plugin to auto-insert the right lockdep_assert_held every
time you read/write into a given field?

That's not going to cover locking rules where the locking rules change
during the lifetime of an object, but I think even without that it
would cover a _lot_ of cases. And if your static annotation would be
allowed to chase pointers (well, just any C expression that takes the
struct pointer as parameter would be sweet) you could even annotate
fields where the protecting lock is in some parent struct.

Another thing I'm really looking forward to (but it's somehow not
moving fast) is the cross-release stuff. Too many times I've screamed
at kernel backtraces stuck in wait_event, and lockdep could have
directly told me what's wrong long before a stress test successfully
hit that race.

There's definitely a lot of room to prove more stuff in locking using tools.
-Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
