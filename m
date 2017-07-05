From: Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [Ksummit-discuss] [MAINTAINERS SUMMIT] & [TECH TOPIC] Improve
 regression tracking
Date: Wed, 5 Jul 2017 09:58:06 -0700
Message-ID: <CAPcyv4ips5B1DjEPjpO2JDdt+g-5hEZzvV1b1SbVJZxVpweHpQ@mail.gmail.com>
References: <576cea07-770a-4864-c3f5-0832ff211e94@leemhuis.info>
 <20170703123025.7479702e@gandalf.local.home> <ad94dc65-cc9c-f4f1-27c1-5a48603c7f59@leemhuis.info>
 <20170705084528.67499f8c@gandalf.local.home> <4080ecc7-1aa8-2940-f230-1b79d656cdb4@redhat.com>
 <20170705092757.63dc2328@gandalf.local.home> <20170705140607.GA30187@kroah.com>
 <a462fb3b-a6d4-e969-b301-b404981de224@roeck-us.net> <20170705112707.54d7f345@gandalf.local.home>
 <c782a15a-4e73-7373-ca66-5b55e9406059@roeck-us.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <c782a15a-4e73-7373-ca66-5b55e9406059-0h96xk9xTtrk1uMJSBkQmQ@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Guenter Roeck <linux-0h96xk9xTtrk1uMJSBkQmQ@public.gmane.org>
Cc: Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, ksummit <ksummit-discuss-cunTk1MwBs98uUxBSJOaYoYkZiVZrdSR2LY78lusg7I@public.gmane.org>, Carlos O'Donell <carlos-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>, Thorsten Leemhuis <linux-rCxcAJFjeRkk+I/owrrOrA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Wed, Jul 5, 2017 at 9:48 AM, Guenter Roeck <linux-0h96xk9xTtrk1uMJSBkQmQ@public.gmane.org> wrote:
> On 07/05/2017 08:27 AM, Steven Rostedt wrote:
>>
>> On Wed, 5 Jul 2017 08:16:33 -0700
>> Guenter Roeck <linux-0h96xk9xTtrk1uMJSBkQmQ@public.gmane.org> wrote:
>
> [ ... ]
>>>
>>>
>>> If we start shaming people for not providing unit tests, all we'll
>>> accomplish is
>>> that people will stop providing bug fixes.
>>
>>
>> I need to be clearer on this. What I meant was, if there's a bug
>> where someone has a test that easily reproduces the bug, then if
>> there's not a test added to selftests for said bug, then we should
>> shame those into doing so.
>>
>
> I don't think that public shaming of kernel developers is going to work
> any better than public shaming of children or teenagers.
>
> Maybe a friendlier approach would be more useful ?
>
> If a test to reproduce a problem exists, it might be more beneficial to
> suggest
> to the patch submitter that it would be great if that test would be
> submitted
> as unit test instead of shaming that person for not doing so. Acknowledging
> and
> praising kselftest submissions might help more than shaming for
> non-submissions.
>
>> A bug that is found by inspection or hard to reproduce test cases are
>> not applicable, as they don't have tests that can show a regression.
>>
>
> My concern would be that once the shaming starts, it won't stop.

Agreed, this shouldn't be a new burden for maintainers, this should be
a contribution path for new kernel developers. Go beyond our standard
"fix a bug" advice, which is a great advice, and also recommend
"backstop a regression with a unit test".
