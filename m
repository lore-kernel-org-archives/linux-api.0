From: Tim Bird <tim.bird-/MT0OVThwyLZJqsBc5GL+g@public.gmane.org>
Subject: Re: [PATCH v5] selftest: size: Add size test for Linux kernel
Date: Thu, 4 Dec 2014 08:39:33 -0800
Message-ID: <54808E45.3010806@sonymobile.com>
References: <547E854E.5060101@sonymobile.com>	 <1417578191.16722.11.camel@concordia> <547F3A57.7000106@sonymobile.com> <1417651707.9123.1.camel@concordia>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1417651707.9123.1.camel@concordia>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Michael Ellerman <mpe-Gsx/Oe8HsFggBc27wqDAHg@public.gmane.org>
Cc: Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>, "linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-embedded-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-embedded-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Geert Uytterhoeven <geert-Td1EMuHUCqxL1ZNQvxDV9g@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On 12/03/2014 04:08 PM, Michael Ellerman wrote:
> On Wed, 2014-12-03 at 08:29 -0800, Tim Bird wrote:
>>
>> On 12/02/2014 07:43 PM, Michael Ellerman wrote:
>>> On Tue, 2014-12-02 at 19:36 -0800, Tim Bird wrote:
>>>> This test shows the amount of memory used by the system.
>>>> Note that this is dependent on the user-space that is loaded
>>>> when this program runs.  Optimally, this program would be
>>>> run as the init program itself.
>>>
>>> Sorry to only chime in at v5.
>>>
>>>> diff --git a/tools/testing/selftests/size/Makefile b/tools/testing/selftests/size/Makefile
>>>> new file mode 100644
>>>> index 0000000..47f8e9c
>>>> --- /dev/null
>>>> +++ b/tools/testing/selftests/size/Makefile
>>>> @@ -0,0 +1,15 @@
>>>> +#ifndef CC
>>>> +	CC = $(CROSS_COMPILE)gcc
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
> 
> CC is never unset. The default value is 'cc'.

Yeah - I found that out by experimentation yesterday.  So my whole
idea for configuring it based on an unset CC was misguided.

> 
>> If CC is set to e.g. 'gcc', then you get a nicely formatted toolchain string.
> 
> Right.
> 
>> But if CC already has the prefix applied, then this will result in
>>   having it duplicated, which surely won't work correctly.
> 
> That's just PEBKAC. Don't specify CROSS_COMPILE and also a fully specified CC.
> Try it with the kernel Makefile and see how well it works.
> 
>> CROSS_COMPILE prefix usage looks a bit uncoordinated in the tools directory, but most
>> tests seem to be favoring $(CROSS_COMPILE)gcc.
> 
> That doesn't make it right :)

Agreed. I'd like to separate this issue from the rest of the patch.
Shuah has accepted the patch as it currently is, but I'd like
to start working on the best way to support cross compilation
throughout the kselftest suite.

Ideally we can have CC set properly in a higher-level Makefile,
and not reference CROSS_COMPILE at all in the sub-directory Makefiles.
This may involve copying how CROSS_COMPILE and CFLAGS work in
the rest of the kernel tree, or making some kselftest-specific
modifications.

 -- Tim
