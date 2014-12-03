From: Tim Bird <tim.bird-/MT0OVThwyLZJqsBc5GL+g@public.gmane.org>
Subject: Re: [PATCH v5] selftest: size: Add size test for Linux kernel
Date: Wed, 3 Dec 2014 10:25:49 -0800
Message-ID: <547F55AD.1040303@sonymobile.com>
References: <547E854E.5060101@sonymobile.com>	<1417578191.16722.11.camel@concordia>	<547F3A57.7000106@sonymobile.com> <CAMuHMdVk9QLDRYDs3q7=51=qTMNRY+MQVhkqGE25XqYOkLbCxg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAMuHMdVk9QLDRYDs3q7=51=qTMNRY+MQVhkqGE25XqYOkLbCxg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Geert Uytterhoeven <geert-Td1EMuHUCqxL1ZNQvxDV9g@public.gmane.org>
Cc: Michael Ellerman <mpe-Gsx/Oe8HsFggBc27wqDAHg@public.gmane.org>, Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>, "linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-embedded-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-embedded-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Thomas Petazzoni <thomas.petazzoni-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org>
List-Id: linux-api@vger.kernel.org



On 12/03/2014 10:00 AM, Geert Uytterhoeven wrote:
> On Wed, Dec 3, 2014 at 5:29 PM, Tim Bird <tim.bird-/MT0OVThwyLZJqsBc5GL+g@public.gmane.org> wrote:
>>>> diff --git a/tools/testing/selftests/size/Makefile b/tools/testing/selftests/size/Makefile
>>>> new file mode 100644
>>>> index 0000000..47f8e9c
>>>> --- /dev/null
>>>> +++ b/tools/testing/selftests/size/Makefile
>>>> @@ -0,0 +1,15 @@
>>>> +#ifndef CC
>>>> +    CC = $(CROSS_COMPILE)gcc
>>>> +#endif
>>>
>>> I think the following is preferable:
>>>
>>>   CC := $(CROSS_COMPILE)$(CC)
>>>
>>>
>>> It allows optionally setting a custom CC, as well as optionally CROSS_COMPILE.
>>
>> I'm not sure I follow this.
>>
>> If CC is unset, you get only the CROSS_COMPILE prefix.
>> If CC is set to e.g. 'gcc', then you get a nicely formatted toolchain string.
>> But if CC already has the prefix applied, then this will result in
>>   having it duplicated, which surely won't work correctly.
>>
>> In the long run, I would hope that a higher level Makefile or environment setting
>> will be setting the toolchain string appropriately (as well as handling build flags)
>> which is why I wanted to use an ifndef (which Thomas correctly pointed out is just
>> wrong).
>>
>> Actually, after getting this tiny program accepted, my next task was working on a
>> proper fix for handling cross compilation in a more generic (not case-by-case) way.
>>
>> CROSS_COMPILE prefix usage looks a bit uncoordinated in the tools directory, but most
>> tests seem to be favoring $(CROSS_COMPILE)gcc.
>>
>>  $ cd tools ; mgrep CROSS
> 
> [...]
> 
>> I agree it's desirable not to hardcode gcc, but we seem to be doing it all over
>> the place already.
> 
> Seems like it's time to start integrating the tests with the regular Kbuild
> system, which handles cross-compilation fine...

Where possible, yes.  It would be nice to leverage CROSS_COMPILE and CFLAGS, or
a portion thereof, from the Kbuild system (as well a KBUILD_OUTPUT and friends).
It's on my to-do list, after getting my little C program accepted...
 -- Tim
