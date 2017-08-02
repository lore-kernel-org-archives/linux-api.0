From: Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
Subject: Re: [Ksummit-discuss] [MAINTAINERS SUMMIT] & [TECH TOPIC] Improve
 regression tracking
Date: Wed, 2 Aug 2017 11:46:40 -0600
Message-ID: <61093c3f-6ad0-c033-a524-f2624f8d55ba@osg.samsung.com>
References: <576cea07-770a-4864-c3f5-0832ff211e94@leemhuis.info>
 <20170703123025.7479702e@gandalf.local.home>
 <ad94dc65-cc9c-f4f1-27c1-5a48603c7f59@leemhuis.info>
 <20170705084528.67499f8c@gandalf.local.home>
 <4080ecc7-1aa8-2940-f230-1b79d656cdb4@redhat.com>
 <20170705092757.63dc2328@gandalf.local.home>
 <20170705140607.GA30187@kroah.com>
 <a462fb3b-a6d4-e969-b301-b404981de224@roeck-us.net>
 <20170705112707.54d7f345@gandalf.local.home>
 <c782a15a-4e73-7373-ca66-5b55e9406059@roeck-us.net>
 <20170705130200.7c653f61@gandalf.local.home> <87zibkzgve.fsf@xmission.com>
 <fb399eba-91eb-21a5-e3f5-c3f919061c12@osg.samsung.com>
 <87lgn1nac8.fsf@xmission.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <87lgn1nac8.fsf-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>
Content-Language: en-US
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>
Cc: Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Guenter Roeck <linux-0h96xk9xTtrk1uMJSBkQmQ@public.gmane.org>, ksummit-discuss-cunTk1MwBs98uUxBSJOaYoYkZiVZrdSR2LY78lusg7I@public.gmane.org, Carlos O'Donell <carlos-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Thorsten Leemhuis <linux-rCxcAJFjeRkk+I/owrrOrA@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Shuah Khan <shuah-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>Shuah Khan <shuah-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On 08/02/2017 11:33 AM, Eric W. Biederman wrote:
> Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org> writes:
> 
>> On 07/31/2017 10:54 AM, Eric W. Biederman wrote:
>>> Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org> writes:
>>>
>>>> On Wed, 5 Jul 2017 09:48:31 -0700
>>>> Guenter Roeck <linux-0h96xk9xTtrk1uMJSBkQmQ@public.gmane.org> wrote:
>>>>
>>>>> On 07/05/2017 08:27 AM, Steven Rostedt wrote:
>>>>>> On Wed, 5 Jul 2017 08:16:33 -0700
>>>>>> Guenter Roeck <linux-0h96xk9xTtrk1uMJSBkQmQ@public.gmane.org> wrote:  
>>>>> [ ... ]
>>>>>>>
>>>>>>> If we start shaming people for not providing unit tests, all we'll accomplish is
>>>>>>> that people will stop providing bug fixes.  
>>>>>>
>>>>>> I need to be clearer on this. What I meant was, if there's a bug
>>>>>> where someone has a test that easily reproduces the bug, then if
>>>>>> there's not a test added to selftests for said bug, then we should
>>>>>> shame those into doing so.
>>>>>>   
>>>>>
>>>>> I don't think that public shaming of kernel developers is going to work
>>>>> any better than public shaming of children or teenagers.
>>>>>
>>>>> Maybe a friendlier approach would be more useful ?
>>>>
>>>> I'm a friendly shamer ;-)
>>>>
>>>>>
>>>>> If a test to reproduce a problem exists, it might be more beneficial to suggest
>>>>> to the patch submitter that it would be great if that test would be submitted
>>>>> as unit test instead of shaming that person for not doing so. Acknowledging and
>>>>> praising kselftest submissions might help more than shaming for non-submissions.
>>>>>
>>>>>> A bug that is found by inspection or hard to reproduce test cases are
>>>>>> not applicable, as they don't have tests that can show a regression.
>>>>>>   
>>>>>
>>>>> My concern would be that once the shaming starts, it won't stop.
>>>>
>>>> I think this is a communication issue. My word for "shaming" was to
>>>> call out a developer for not submitting a test. It wasn't about making
>>>> fun of them, or anything like that. I was only making a point
>>>> about how to teach people that they need to be more aware of the
>>>> testing infrastructure. Not about actually demeaning people.
>>>>
>>>> Lets take a hypothetical sample. Say someone posted a bug report with
>>>> an associated reproducer for it. The developer then runs the reproducer
>>>> sees the bug, makes a fix and sends it to Linus and stable. Now the
>>>> developer forgets this and continues on their merry way. Along comes
>>>> someone like myself and sees a reproducing test case for a bug, but
>>>> sees no test added to kselftests. I would send an email along the lines
>>>> of "Hi, I noticed that there was a reproducer for this bug you fixed.
>>>> How come there was no test added to the kselftests to make sure it
>>>> doesn't appear again?" There, I "shamed" them ;-)
>>>
>>> I just want to point out that kselftests are hard to build and run.
>>>
>>> As I was looking at another issue I found a bug in one of the tests.  It
>>> had defined a constant wrong.  I have a patch.  It took me a week of
>>> poking at the kselftest code and trying one thing or another (between
>>> working on other things) before I could figure out which combination of
>>> things would let the test build and run.
>>>
>>> Until kselftests get easier to run I don't think they are something we
>>> want to push to hard.
>>>
>>
>> I would say it is easy to run ksefltests - "make kseflttest" from the
>> main Makefile does this for you. You can also run individual tests:
> 
> On 4.13-rc1  That doesn't work.
> 
> $ make O=$PWD-build -j8 kselftests
> make[1]: Entering directory 'linux-build'
> make[1]: *** No rule to make target 'kselftests'.  Stop.
> make[1]: Leaving directory 'linux-build'
> Makefile:145: recipe for target 'sub-make' failed
> make: *** [sub-make] Error 2

It is "make kselftest"

> 
> And why I have to use some esoteric command and not just the
> traditional "make path/to/test/output" to run an individual
> test is beyond me.
> 

make kselftest from top level Makefile is a way to run all the tests.
As I mentioned in my previous email 

"You can also run individual tests:

"make -C tools/testing/selftests/sync" for example to run sync tests.

or you can also run:

make -C tools/testing/selftests/ run_tests

thanks,
-- Shuah
