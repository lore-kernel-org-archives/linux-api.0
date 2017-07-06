From: Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
Subject: Re: [Ksummit-discuss] [MAINTAINERS SUMMIT] & [TECH TOPIC] Improve
 regression tracking
Date: Thu, 6 Jul 2017 16:40:45 -0600
Message-ID: <803733a4-491b-3303-5e22-a057d4eadd3d@osg.samsung.com>
References: <576cea07-770a-4864-c3f5-0832ff211e94@leemhuis.info>
 <20170703123025.7479702e@gandalf.local.home>
 <ad94dc65-cc9c-f4f1-27c1-5a48603c7f59@leemhuis.info>
 <20170705084528.67499f8c@gandalf.local.home>
 <4080ecc7-1aa8-2940-f230-1b79d656cdb4@redhat.com>
 <20170705092757.63dc2328@gandalf.local.home>
 <20170705140607.GA30187@kroah.com>
 <a462fb3b-a6d4-e969-b301-b404981de224@roeck-us.net>
 <20170705153259.GA7265@kroah.com>
 <a2fada39-76d4-e136-f2db-d8306d929902@osg.samsung.com>
 <20170706183249.60b2aef9@gandalf.local.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170706183249.60b2aef9-f9ZlEuEWxVcJvu8Pb33WZ0EMvNT87kid@public.gmane.org>
Content-Language: en-US
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>
Cc: Greg KH <greg-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org>, Guenter Roeck <linux-0h96xk9xTtrk1uMJSBkQmQ@public.gmane.org>, Carlos O'Donell <carlos-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Thorsten Leemhuis <linux-rCxcAJFjeRkk+I/owrrOrA@public.gmane.org>, ksummit-discuss-cunTk1MwBs98uUxBSJOaYoYkZiVZrdSR2LY78lusg7I@public.gmane.org, Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On 07/06/2017 04:32 PM, Steven Rostedt wrote:
> On Thu, 6 Jul 2017 16:24:01 -0600
> Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org> wrote:
> 
> 
>> Over the past couple of years, kselftests have seen improvements to run
>> on ARM in kernel ci rings. TAP13 will definitely make it easier to find
>> run to run differences. There is the effort to use ksefltests to test
>> stable releases (4.4 LTS for example), which will help make the tests
>> fail/skip gracefully when a feature isn't enabled/supported.
>>
>> The work so far is two fold:
>>
>> - enable them to run in test rings.
>> - making them easy to use
>>
>> As per test development, we are constantly adding tests and I see new tests
>> getting added for sub-systems that aren't hardware dependent. You will see
>> lots of activity in mm, timers, seccomp, net, sys-calls to name a few.
>>
>> I am going to be looking for TAP13 format compliance for new tests starting
>> 4.13.
>>
>> I am not sure how popular they are among developers and sub-system maintainers
>> though. Maybe this is one area we can try to improve usage.

As a clarification, what I meant by "how popular they are among developers and
sub-system maintainers" is that how often developers and sub-system maintainers
run kselftests and are there any obstacles for running them.

It would be good to get feedback on usage by us as in developers.

> 
> Maybe this should be included in the MAINTAINERS SUMMIT as well. To
> consolidate the format of all the kselftests and have something that
> everyone (or most) developers agree on.


thanks,
-- Shuah
