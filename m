From: Shuah Khan <shuahkh@osg.samsung.com>
Subject: Re: [PATCH v2 6/6] selftests: enable O and KBUILD_OUTPUT
Date: Tue, 21 Mar 2017 07:54:23 -0600
Message-ID: <5daf0b79-a000-2adb-0b1e-f528d66ff6df@osg.samsung.com>
References: <20161129115552.8148-1-bamvor.zhangjian@huawei.com>
 <20161129115552.8148-7-bamvor.zhangjian@huawei.com>
 <CALCETrUCbGC5tmzKzYn0qE5w8omk6ZRDj4p9qz5-Ho92+W5McA@mail.gmail.com>
 <87fui7owls.fsf@concordia.ellerman.id.au>
 <CAFy1USRoKJ7G9ewLGBa1yy9V5UA+g=jo7O+eU1wV_rjKDYtJWg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAFy1USRoKJ7G9ewLGBa1yy9V5UA+g=jo7O+eU1wV_rjKDYtJWg@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Bamvor Zhang Jian <bamvor.zhangjian@linaro.org>, Michael Ellerman <mpe@ellerman.id.au>
Cc: Andy Lutomirski <luto@amacapital.net>, "Zhangjian (Bamvor)" <bamvor.zhangjian@huawei.com>, Linux API <linux-api@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Kevin Hilman <khilman@kernel.org>, Mark Brown <broonie@kernel.org>, Shuah Khan <shuahkh@osg.samsung.com>
List-Id: linux-api@vger.kernel.org

On 03/21/2017 03:00 AM, Bamvor Zhang Jian wrote:
> Hi,
> 
> On 21 March 2017 at 16:35, Michael Ellerman <mpe@ellerman.id.au> wrote:
>> Andy Lutomirski <luto@amacapital.net> writes:
>>
>>> On Tue, Nov 29, 2016 at 3:55 AM,  <bamvor.zhangjian@huawei.com> wrote:
>>>> From: Bamvor Jian Zhang <bamvor.zhangjian@linaro.org>
>>>>
>>>> Enable O and KBUILD_OUTPUT for kselftest. User could compile kselftest
>>>> to another directory by passing O or KBUILD_OUTPUT. And O is high
>>>> priority than KBUILD_OUTPUT.
>>>
>>> Sorry for noticing this late, but this patch
>>> (a8ba798bc8ec663cf02e80b0dd770324de9bafd9) is really annoying for
>>> people who *don't* use these fancy options:
>>
>> Yeah sorry, it wasn't quite ready to go in.

Bamovar,

Please give me heads up and ask me to not commit the patch,
if you think it isn't ready.

>>
>>> $ make -C tools/testing/selftests/x86 ldt_gdt_32
>>> make: Entering directory '/home/luto/apps/linux/tools/testing/selftests/x86'
>>> Makefile:44: warning: overriding recipe for target 'clean'
>>> ../lib.mk:55: warning: ignoring old recipe for target 'clean'
>>> make: *** No rule to make target 'ldt_gdt_32'.  Stop.
>>> make: Leaving directory '/home/luto/apps/linux/tools/testing/selftests/x86'
>>>
>>> Is there any way that you can make this work again?
>>
>> There obviously is *a* way, but I'm not sure there's a simple and
>> obviously correct way that is an easy fix for 4.11.
>>
>> I see at least 18 Makefile's in tools/testing/selftests that use
>> $(OUTPUT)/, which would all need to be updated at least to use $(OUTPUT)
>> (no trailing slash), and then some other changes to not propagate OUTPUT
>> when the user didn't specify it. But hopefully someone will prove me
>> wrong.
> I also look at this issue. Originally, I use OUTPUT without slash in my
> patch. People argue that it is not very clear. So, I add slash in curent
> version.
>>
>> As a (poor) alternative you can do:
>>
>>  $ cd tools/testing/selftests/x86; make $PWD/ldt_gdt_32
>>
>> or just:
>>
>>  $ make -C tools/testing/selftests/x86
>>
>> cheers
> Do we really need "make -C tools/testing/selftests/x86 ldt_gdt_32"?
> It is useful but it will skip the top level Makefile of selftests.

Being able to build individual tests is an important use-case. Please
see kselftest.txt under Documentation directory for all the use-cases
and new patches shouldn't break these use-cases.

Breaking these use-cases is a regression and we have to fix it.

thanks,
-- Shuah

> 
> Regards
> 
> Bamvor
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-api" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
