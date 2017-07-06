From: Daniel Vetter <daniel.vetter-/w4YWyX8dFk@public.gmane.org>
Subject: Re: [Ksummit-discuss] [MAINTAINERS SUMMIT] & [TECH TOPIC] Improve
 regression tracking
Date: Thu, 6 Jul 2017 23:28:28 +0200
Message-ID: <CAKMK7uGQz8soDJ-+eLnDArx382jiMAWeFwrJK_LxJkWYJ6DKmQ@mail.gmail.com>
References: <20170705084528.67499f8c@gandalf.local.home> <4080ecc7-1aa8-2940-f230-1b79d656cdb4@redhat.com>
 <20170705092757.63dc2328@gandalf.local.home> <20170705140607.GA30187@kroah.com>
 <a462fb3b-a6d4-e969-b301-b404981de224@roeck-us.net> <20170705112707.54d7f345@gandalf.local.home>
 <c782a15a-4e73-7373-ca66-5b55e9406059@roeck-us.net> <20170705130200.7c653f61@gandalf.local.home>
 <20170706092836.ifcnc2qqwufndhdl@sirena.org.uk> <CAKMK7uFH+Kz8Mdph=J_FCZ4LC3tzoOmwNJPpSO+snTz6p0Xz+w@mail.gmail.com>
 <20170706145346.6w2uzcf7xacbr3or@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170706145346.6w2uzcf7xacbr3or-AKGzg7BKzIDYtjvyW6yDsg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org>
Cc: Mark Brown <broonie-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, "ksummit-discuss-cunTk1MwBs98uUxBSJOaYoYkZiVZrdSR2LY78lusg7I@public.gmane.org" <ksummit-discuss-cunTk1MwBs98uUxBSJOaYoYkZiVZrdSR2LY78lusg7I@public.gmane.org>, Carlos O'Donell <carlos-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "open list:ABI/API" <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Thorsten Leemhuis <linux-rCxcAJFjeRkk+I/owrrOrA@public.gmane.org>, Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Thu, Jul 6, 2017 at 4:53 PM, Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org> wrote:
> On Thu, Jul 06, 2017 at 11:41:39AM +0200, Daniel Vetter wrote:
>> +1. That pretty much means large-scale CI. The i915 test suite has
>> suffered quite a bit over the past years because the CI infrastructure
>> didn't keep up. Result is that running full CI kills pretty much every
>> platform there is eventually, and it's really hard to get back to a
>> state where the testsuite can be used to catch regressions again.
>
> I assume the i915 test suite requires real hardware and can't be run
> on VM's; is that correct?

Yes, that's another problem. If all bigger teams/subsystems would do
what we'd do, but extended to all mailing lists, your patch series
would get replies from a few hundred CI farms. Not sure that would
scale ... And there's no way ever that one single entity will have
hardware for everything.

And if you only CI the mailing list for your own subsystem then every
time a merge window happens your CI will be out of service (4.13 seems
extremely bad, atm nothing survives an extended run on linux-next for
us).
-Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
