From: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
Subject: Re: [PATCH 1/7] selftests: add header file for test exit code defines
Date: Tue, 16 Sep 2014 10:40:22 -0700
Message-ID: <CALCETrUw21Bgd9N4wakP08OiFshxzPS6wBE6=Fd2K=k33RDgXA@mail.gmail.com>
References: <1410820442-8774-1-git-send-email-shuahkh@osg.samsung.com>
 <1410820442-8774-2-git-send-email-shuahkh@osg.samsung.com>
 <1410883441.4630.9.camel@linux-t7sj.site> <54187400.10506@osg.samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <54187400.10506-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
Cc: Davidlohr Bueso <dave-h16yJtLeMjHk1uMJSBkQmQ@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Greg KH <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, colin.king-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org, "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, Serge Hallyn <serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>, thierry-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org, felipensp-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Tue, Sep 16, 2014 at 10:31 AM, Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org> wrote:
> On 09/16/2014 10:04 AM, Davidlohr Bueso wrote:
>> On Mon, 2014-09-15 at 16:33 -0600, Shuah Khan wrote:
>>> Add a new header file that defines exit codes for individual
>>> tests to use to communicate test results. These defines are
>>> intended to provide a common and uniform way for selftests
>>> to report results. pass/fail/xfail/xpass/skip/unsupported
>>> are defined.
>>>
>>> Signed-off-by: Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
>>> ---
>>>  tools/testing/selftests/kselftest.h | 20 ++++++++++++++++++++
>>>  1 file changed, 20 insertions(+)
>>>  create mode 100644 tools/testing/selftests/kselftest.h
>>>
>>> diff --git a/tools/testing/selftests/kselftest.h b/tools/testing/selftests/kselftest.h
>>> new file mode 100644
>>> index 0000000..1b1c9cb
>>> --- /dev/null
>>> +++ b/tools/testing/selftests/kselftest.h
>>> @@ -0,0 +1,20 @@
>>> +/*
>>> + * kselftest.h - kselftest framework return codes to include from
>>> + *           selftests.
>>> + *
>>> + * Copyright (c) 2014 Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
>>> + * Copyright (c) 2014 Samsung Electronics Co., Ltd.
>>> + *
>>> + * This file is released under the GPLv2.
>>> + */
>>> +#ifndef __KSELFTEST_H
>>> +#define __KSELFTEST_H
>>> +
>>> +#define     EXIT_PASS               0
>>> +#define     EXIT_FAIL               1
>>> +#define     EXIT_XFAIL              2
>>> +#define     EXIT_XPASS              3
>>> +#define     EXIT_SKIP               4
>>> +#define     EXIT_UNSUPPORTED        EXIT_SKIP
>>
>> Looks to me like a potential name clashes here.
>>
>> What's the difference between XFAIL/XPASS and regular FAIL/PASS (I don't
>> see the former used in patchset either, only PASS/FAIL)? What's the
>> purpose of EXIT_SKIP? I think overall these should be commented.
>
> Yeah Comments would have been nice. :) I will add them.
>
>>
>> Also, in the bigger picture, I'm guessing you have a reason for not
>> recycling errno and inventing your own exit codes... How do you plan on
>> using these? In addition I'm seeing things like:
>>
>> -       exit(EXIT_FAILURE);
>> +       exit(EXIT_FAIL);
>>
>> which isn't a very good idea in general.
>
> EXIT_FAILURE happens to have the same value as EXIT_FAIL. That said,
> I do understand what you are saying. EXIT_FAILURE and EXIT_SUCCESS
> are defined in stdlib.h - I would have liked to simply use them,
> however that won't meet the needs. More on this below.
>
> At the moment there is no clear way to tell why a test failed. Some
> tests exit with -1, some exit 1, and some with errno. One of the
> requests/requirements that was discussed at the kernel summit kselftest
> session was to enhance tests to report why an individual test failed.
> Returning and/or exiting with -1, 1 and errno doesn't tell the user
> anything other than that the test failed. Even without this request, it
> will helps us developers if we have a uniform reporting in place for
> all tests to use.
>
> We have two kinds of users for these tests.
>
> 1. Developers that simply want to regression test their individual areas
>    These are the users that don't care about the categories of failures.
> 2. Users that want to run them from their user-space test suites. These
>    users care to know why a test failed, not just that it failed.
>
> errno is useful in pin-pointing the failure for a developer, however it
> is not very useful for somebody that is running sanity checks. We need
> both, hence I changed some of the tests in this series to print errno.
> Several tests print errno in their error legs and there a few places
> that don't.
>
> In either case, it would be good to report if a test failed because
> a modules it needs isn't configured or it just failed.
>
> There is also a need to report the following cases in addition a simple
> pass/fail:
>
> pass - test passed
> fail - it failed
> xfail - a test that expected to fail failed as expected (this is really
> a pass case)
> xpass - a test that is expected to fail passed.
> xskip or xunsupported - test couldn't run because of unmet dependencies.
>
> These types of decisions on why test failed, can only be made in the
> individual tests.
>
> I picked the POSIX conforming test codes that are used by various user
> space test suites. POSIX right, I can't go wrong :)
>
> I also want to avoid adding some test framework in kernel tree, hence
> I simply defined these in a header file. Another goal is to not make it
> hard for developers write these tests and think too much about the
> reporting. We need some way to report these and hence the need for a
> common defines so tests can simply use them.

I think we will want a framework in the tree, but it can be very
minimal.  But I also think that using exit(2) for this is wrong.  Why
not:

enum ktest_result {
  KTEST_PASS,
  ...,
};

void ktest_exit(enum ktest_result result);

With the possibility of further extensions for more than one test (and
associated result) per execution of the test binary.

--Andy

>
> I am trying to balance the needs of the two types of users and also
> do minimal changes to existing test with a light weight framework.
> Hope this helps explain this patch series better.
>
> I am open to suggestions as always.
>
> thanks,
> -- Shuah
>
>
> --
> Shuah Khan
> Sr. Linux Kernel Developer
> Samsung Research America (Silicon Valley)
> shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org | (970) 217-8978
> --
> To unsubscribe from this list: send the line "unsubscribe linux-api" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Andy Lutomirski
AMA Capital Management, LLC
