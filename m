From: Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
Subject: Re: [PATCH 1/5] selftests: Add futex functional tests
Date: Mon, 11 May 2015 16:21:08 -0600
Message-ID: <55512B54.50304@osg.samsung.com>
References: <cover.1431121818.git.dvhart@linux.intel.com> <57d921b1c30e8258ca4b2f55637424527317e92f.1431121818.git.dvhart@linux.intel.com> <5550EF8D.8080403@osg.samsung.com> <D1763F31.CC237%dvhart@linux.intel.com> <5550FB2C.1000403@osg.samsung.com> <D17653E0.CC29F%dvhart@linux.intel.com> <5551164E.5080409@osg.samsung.com> <D17670E1.CC354%dvhart@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <D17670E1.CC354%dvhart-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Darren Hart <dvhart-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Ingo Molnar <mingo-X9Un+BFzKDI@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Davidlohr Bueso <dave-h16yJtLeMjHk1uMJSBkQmQ@public.gmane.org>, KOSAKI Motohiro <kosaki.motohiro-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On 05/11/2015 03:50 PM, Darren Hart wrote:
> On 5/11/15, 1:51 PM, "Shuah Khan" <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org> wrote:
>=20
>> On 05/11/2015 01:47 PM, Darren Hart wrote:
>>> On 5/11/15, 11:55 AM, "Shuah Khan" <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org> wrote:
>>>
>>>> On 05/11/2015 12:22 PM, Darren Hart wrote:
>>>>> On 5/11/15, 11:06 AM, "Shuah Khan" <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org> wrot=
e:
>>>>>
>>>>>> On 05/08/2015 04:09 PM, Darren Hart wrote:
>>>>>>> The futextest testsuite [1] provides functional, stress, and
>>>>>>> performance tests for the various futex op codes. Those tests w=
ill
>>>>>>> be
>>>>>>> of
>>>>>>> more use to futex developers if they are included with the kern=
el
>>>>>>> source.
>>>>>>>
>>>>>>> Copy the core infrastructure and the functional tests into
>>>>>>> selftests,
>>>>>>> but adapt them for inclusion in the kernel:
>>>>>>>
>>>>>>> - Update the Makefile to include the run_tests target, remove
>>>>>>> reference
>>>>>>>   to the performance and stress tests from the contributed sour=
ces.
>>>>>>> - Replace my dead IBM email address with my current Intel email
>>>>>>> address.
>>>>>>> - Remove the warrantee and write-to paragraphs from the license
>>>>>>> blurbs.
>>>>>>> - Remove the NAME section as the filename is easily determined.=
 ;-)
>>>>>>> - Make the whitespace usage consistent in a couple of places.
>>>>>>> - Cleanup various CodingStyle violations.
>>>>>>>
>>>>>>> A future effort will explore moving the performance and stress =
tests
>>>>>>> into the kernel.
>>>>>>>
>>>>>>> 1. http://git.kernel.org/cgit/linux/kernel/git/dvhart/futextest=
=2Egit
>>>>>>>
>>>>>>> Cc: Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
>>>>>>> Cc: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>>>>>>> Cc: Ingo Molnar <mingo-X9Un+BFzKDI@public.gmane.org>
>>>>>>> Cc: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
>>>>>>> Cc: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
>>>>>>> Cc: Davidlohr Bueso <dave-h16yJtLeMjHk1uMJSBkQmQ@public.gmane.org>
>>>>>>> Cc: KOSAKI Motohiro <kosaki.motohiro-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
>>>>>>> Signed-off-by: Darren Hart <dvhart-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
>>>>>>> ---
>>>>>>
>>>>>> Daren,
>>>>>>
>>>>>> I am seeing
>>>>>>
>>>>>> fatal: cannot convert from y to UTF-8
>>>>>>
>>>>>> when I try to apply the patch. Did you use git send-email?
>>>>>
>>>>> Hi Shuah,
>>>>>
>>>>> I've seen that from one of my contributors earlier this month as
>>>>> well. I
>>>>> dropped the Content... Header and it applied without problems.
>>>>>
>>>>> I created the patch using git format-patch and then sent them usi=
ng
>>>>> git
>>>>> send-email - via a script I've been using for years now...
>>>>>
>>>>> Checking the files locally:
>>>>> $ file *
>>>>> 0000-cover-letter.patch:                                         =
ASCII
>>>>> text
>>>>> 0001-selftests-Add-futex-functional-tests.patch:
>>>>> unified
>>>>> diff output, UTF-8 Unicode text
>>>>> 0002-selftest-futex-Update-Makefile-to-use-lib.mk.patch:
>>>>> unified
>>>>> diff output, ASCII text
>>>>> 0003-selftest-futex-Increment-ksft-pass-and-fail-counters.patch:
>>>>> unified
>>>>> diff output, ASCII text
>>>>> 0004-selftest-Add-futex-tests-to-the-top-level-Makefile.patch:
>>>>> unified
>>>>> diff output, ASCII text
>>>>> 0005-kselftest-Add-exit-code-defines.patch:
>>>>> unified
>>>>> diff output, ASCII text
>>>>>
>>>>>
>>>>> This shows that only the first in UTF-8 and the rest are ASCII. I
>>>>> presume
>>>>> this is due to the Copyright notices in the original files:
>>>>>
>>>>> Copyright =A9 International Business Machines  Corp., 2006-2008
>>>>>
>>>>> Which use =A9 instead of (C). I just checked and there are 545 in=
stances
>>>>> of
>>>>> =A9 in the kernel itself, so this should not present a problem.
>>>>>
>>>>> I apologize for the glitch in applying. If you use the pull reque=
st I
>>>>> included that will avoid the mail transport issues, and I will be=
 sure
>>>>> to
>>>>> fix my scripts to avoid the issue in the future.
>>>>>
>>>>> If you want to use the patches directly, please have a look at 1 =
of 5
>>>>> and
>>>>> just remove the "Content..." header, and I think you'll find "git=
 am"
>>>>> will
>>>>> apply it without complaint.
>>>>>
>>>>
>>>> Hi Daren,
>>>>
>>>> Removing the Content header got me past the utf error. However, gi=
t am
>>>> complains:
>>>>
>>>> git am --signoff
>>>>
>>>> ../4.2_patches/futex_tests/PATCH_1_5selftestsAddfutexfunctionaltes=
ts.mbo
>>>> x
>>>> Applying: selftests: Add futex functional tests
>>>> /mnt/data/lkml/linux-kselftest/.git/rebase-apply/patch:1457: new b=
lank
>>>> line at EOF.
>>>> +
>>>> warning: 1 line adds whitespace errors.
>>>>
>>>> Could you look into these. Rest of the patches applied fine.
>>>
>>> Hi Shuah,
>>>
>>> This was due to a newline at the end of:
>>> tools/testing/selftests/futex/functional/run.sh
>>>
>>> Which unfortunately checkpatch.pl doesn't catch. My fault for not
>>> applying
>>> the series from the generated patches first. Sorry for the hassle.
>>>
>>> I have corrected this in the first patch and pushed v3 of the serie=
s to:
>>>
>>> git://git.infradead.org/users/dvhart/linux.git futextest-v3
>>>
>>>
>>> $ git diff infradead/futextest-v2 infradead/futextest-v3
>>> diff --git a/tools/testing/selftests/futex/functional/run.sh
>>> b/tools/testing/selftests/futex/functional/run.sh
>>> index 46827a8..e87dbe2 100755
>>> --- a/tools/testing/selftests/futex/functional/run.sh
>>> +++ b/tools/testing/selftests/futex/functional/run.sh
>>> @@ -77,4 +77,3 @@ echo
>>>  echo
>>>  ./futex_wait_uninitialized_heap $COLOR
>>>  ./futex_wait_private_mapped_file $COLOR
>>> -
>>>
>>>
>>
>> No need for a new pull request. Have you seen these errors before:
>>
>> make[2]: Entering directory
>> '/mnt/data/lkml/linux-kselftest/tools/testing/selftests/futex'
>> for DIR in functional; do make -C $DIR all ; done
>> make[3]: Entering directory
>> '/mnt/data/lkml/linux-kselftest/tools/testing/selftests/futex/functi=
onal'
>> gcc  -g -O2 -Wall -D_GNU_SOURCE -I../include -I../../   -lpthread -l=
rt
>> futex_requeue_pi.c ../include/futextest.h   -o futex_requeue_pi
>> /tmp/cc2UgUVs.o: In function `create_rt_thread':
>> /mnt/data/lkml/linux-kselftest/tools/testing/selftests/futex/functio=
nal/fu
>> tex_requeue_pi.c:102:
>> undefined reference to `pthread_create'
>> /tmp/cc2UgUVs.o: In function `unit_test':
>> /mnt/data/lkml/linux-kselftest/tools/testing/selftests/futex/functio=
nal/fu
>> tex_requeue_pi.c:342:
>> undefined reference to `pthread_join'
>> /mnt/data/lkml/linux-kselftest/tools/testing/selftests/futex/functio=
nal/fu
>> tex_requeue_pi.c:347:
>> undefined reference to `pthread_join'
>> /mnt/data/lkml/linux-kselftest/tools/testing/selftests/futex/functio=
nal/fu
>> tex_requeue_pi.c:346:
>> undefined reference to `pthread_join'
>> collect2: error: ld returned 1 exit status
>> <builtin>: recipe for target 'futex_requeue_pi' failed
>> make[3]: *** [futex_requeue_pi] Error 1
>> make[3]: Leaving directory
>> '/mnt/data/lkml/linux-kselftest/tools/testing/selftests/futex/functi=
onal'
>> Makefile:7: recipe for target 'all' failed
>>
>> I am running make kselftest target when I saw the above build failur=
es.
>> kselftest run doesn't fail which is good, however futex tests won't
>> run with this failure.
>=20
> I have not seen these errors whilst developing with futextest for the
> kernel. That looks like you may be missing the pthread development he=
aders
> from your build machine.
>=20
> Those are provided by libc6-dev on my Debian systems.
>=20

I do have lib6-dev installed. timers uses pthread compiles fine.
So does mqueue. I am not sure what is going on with futex tests
though. I am guessing it has to do with library link order.

The following fixed it for me:

-LDFLAGS :=3D $(LDFLAGS) -lpthread -lrt
+LDFLAGS :=3D $(LDFLAGS) -pthread -lrt

Could you please make this change and resend the patch series.
I prefer patch series over pull request.

thanks,
-- Shuah



thanks,
-- Shuah
--=20
Shuah Khan
Sr. Linux Kernel Developer
Open Source Innovation Group
Samsung Research America (Silicon Valley)
shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org | (970) 217-8978
