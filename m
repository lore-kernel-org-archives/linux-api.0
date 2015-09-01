From: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
Subject: Re: [PATCH 2/3] selftests: add membarrier syscall test
Date: Tue, 1 Sep 2015 11:32:27 -0700
Message-ID: <CALCETrWpSErLUES1Wgs5+Ov8F0c-ohUwkSHFMRMZPhx-E4o2cQ@mail.gmail.com>
References: <1436561912-24365-1-git-send-email-mathieu.desnoyers@efficios.com>
 <1436561912-24365-3-git-send-email-mathieu.desnoyers@efficios.com>
 <1441004040.5735.7.camel@ellerman.id.au> <1071313434.33305.1441127478843.JavaMail.zimbra@efficios.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1071313434.33305.1441127478843.JavaMail.zimbra-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
Cc: Michael Ellerman <mpe-Gsx/Oe8HsFggBc27wqDAHg@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-api <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Pranith Kumar <bobby.prani-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Tue, Sep 1, 2015 at 10:11 AM, Mathieu Desnoyers
<mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org> wrote:
> ----- On Aug 31, 2015, at 2:54 AM, Michael Ellerman mpe-Gsx/Oe8HsFggBc27wqDAHg@public.gmane.org wrote:
>
>> On Fri, 2015-07-10 at 16:58 -0400, Mathieu Desnoyers wrote:
>>> From: Pranith Kumar <bobby.prani-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>>>
>>> This patch adds a self test for the membarrier system call.
>>>
>>> CC: Michael Ellerman <mpe-Gsx/Oe8HsFggBc27wqDAHg@public.gmane.org>
>>
>> Sorry I only just saw this due to some over zealous filtering on my end.
>>
>>
>>> diff --git a/tools/testing/selftests/membarrier/Makefile
>>> b/tools/testing/selftests/membarrier/Makefile
>>> new file mode 100644
>>> index 0000000..877a503
>>> --- /dev/null
>>> +++ b/tools/testing/selftests/membarrier/Makefile
>>> @@ -0,0 +1,11 @@
>>> +CFLAGS += -g -I../../../../usr/include/
>>> +
>>> +all:
>>> +    $(CC) $(CFLAGS) membarrier_test.c -o membarrier_test
>>>
>>> +TEST_PROGS := membarrier_test
>>
>> You don't need to specify the rule, the implict one will do exactly the same,
>> so you can just do:
>>
>> TEST_PROGS := membarrier_test
>>
>> all: $(TEST_PROGS)
>>
>>> diff --git a/tools/testing/selftests/membarrier/membarrier_test.c
>>> b/tools/testing/selftests/membarrier/membarrier_test.c
>>> new file mode 100644
>>> index 0000000..3c9f217
>>> --- /dev/null
>>> +++ b/tools/testing/selftests/membarrier/membarrier_test.c
>>> @@ -0,0 +1,71 @@
>>> +#define _GNU_SOURCE
>>> +#define __EXPORTED_HEADERS__
>>
>> Why are you exporting that?
>>
>> I suspect to try and get around the "Attempt to use kernel headers from user
>> space" warning.
>>
>> But you're correctly building against the installed headers, not the kernel
>> headers, so you don't need to do that.
>
> Just to make sure I understand: should we expect that
> everyone will issue "make headers_install" on their system
> before doing a make kselftest ?
>
> I see that a few selftests (e.g. memfd) are adding the
> source tree include paths to the compiler include paths,
> which I guess is to ensure that the kselftest will
> work even if the system headers are not up to date.

It would be really nice if there were a clean way for selftests to
include the kernel headers.  Perhaps make should build the exportable
headers somewhere as a dependency of kselftests.

--Andy
