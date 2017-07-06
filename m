From: Daniel Vetter <daniel.vetter-/w4YWyX8dFk@public.gmane.org>
Subject: Re: [Ksummit-discuss] [MAINTAINERS SUMMIT] & [TECH TOPIC] Improve
 regression tracking
Date: Thu, 6 Jul 2017 11:41:39 +0200
Message-ID: <CAKMK7uFH+Kz8Mdph=J_FCZ4LC3tzoOmwNJPpSO+snTz6p0Xz+w@mail.gmail.com>
References: <20170703123025.7479702e@gandalf.local.home> <ad94dc65-cc9c-f4f1-27c1-5a48603c7f59@leemhuis.info>
 <20170705084528.67499f8c@gandalf.local.home> <4080ecc7-1aa8-2940-f230-1b79d656cdb4@redhat.com>
 <20170705092757.63dc2328@gandalf.local.home> <20170705140607.GA30187@kroah.com>
 <a462fb3b-a6d4-e969-b301-b404981de224@roeck-us.net> <20170705112707.54d7f345@gandalf.local.home>
 <c782a15a-4e73-7373-ca66-5b55e9406059@roeck-us.net> <20170705130200.7c653f61@gandalf.local.home>
 <20170706092836.ifcnc2qqwufndhdl@sirena.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170706092836.ifcnc2qqwufndhdl-GFdadSzt00ze9xe1eoZjHA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mark Brown <broonie-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, "ksummit-discuss-cunTk1MwBs98uUxBSJOaYoYkZiVZrdSR2LY78lusg7I@public.gmane.org" <ksummit-discuss-cunTk1MwBs98uUxBSJOaYoYkZiVZrdSR2LY78lusg7I@public.gmane.org>, Carlos O'Donell <carlos-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "open list:ABI/API" <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Thorsten Leemhuis <linux-rCxcAJFjeRkk+I/owrrOrA@public.gmane.org>, Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Thu, Jul 6, 2017 at 11:28 AM, Mark Brown <broonie-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
> On Wed, Jul 05, 2017 at 01:02:00PM -0400, Steven Rostedt wrote:
>> Guenter Roeck <linux-0h96xk9xTtrk1uMJSBkQmQ@public.gmane.org> wrote:
>
>> > If a test to reproduce a problem exists, it might be more beneficial to suggest
>> > to the patch submitter that it would be great if that test would be submitted
>> > as unit test instead of shaming that person for not doing so. Acknowledging and
>> > praising kselftest submissions might help more than shaming for non-submissions.
>
>> > My concern would be that once the shaming starts, it won't stop.
>
>> I think this is a communication issue. My word for "shaming" was to
>> call out a developer for not submitting a test. It wasn't about making
>> fun of them, or anything like that. I was only making a point
>> about how to teach people that they need to be more aware of the
>> testing infrastructure. Not about actually demeaning people.
>
> I think before anything like that is viable we need to show a concerted
> and visible interest in actually running the tests we already have and
> paying attention to the results - if people can see that they're just
> checking a checkbox that will often result in low quality tests which
> can do more harm than good.

+1. That pretty much means large-scale CI. The i915 test suite has
suffered quite a bit over the past years because the CI infrastructure
didn't keep up. Result is that running full CI kills pretty much every
platform there is eventually, and it's really hard to get back to a
state where the testsuite can be used to catch regressions again.
-Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
