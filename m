From: Darren Hart <dvhart-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [PATCH 1/5] selftests: Add futex functional tests
Date: Mon, 11 May 2015 12:47:33 -0700
Message-ID: <D17653E0.CC29F%dvhart@linux.intel.com>
References: <cover.1431121818.git.dvhart@linux.intel.com>
 <57d921b1c30e8258ca4b2f55637424527317e92f.1431121818.git.dvhart@linux.intel.com>
 <5550EF8D.8080403@osg.samsung.com>
 <D1763F31.CC237%dvhart@linux.intel.com>
 <5550FB2C.1000403@osg.samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5550FB2C.1000403-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Ingo Molnar <mingo-X9Un+BFzKDI@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Davidlohr Bueso <dave-h16yJtLeMjHk1uMJSBkQmQ@public.gmane.org>, KOSAKI Motohiro <kosaki.motohiro-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On 5/11/15, 11:55 AM, "Shuah Khan" <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org> wrote:

>On 05/11/2015 12:22 PM, Darren Hart wrote:
>> On 5/11/15, 11:06 AM, "Shuah Khan" <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org> wrote:
>>=20
>>> On 05/08/2015 04:09 PM, Darren Hart wrote:
>>>> The futextest testsuite [1] provides functional, stress, and
>>>> performance tests for the various futex op codes. Those tests will=
 be
>>>>of
>>>> more use to futex developers if they are included with the kernel
>>>> source.
>>>>
>>>> Copy the core infrastructure and the functional tests into selftes=
ts,
>>>> but adapt them for inclusion in the kernel:
>>>>
>>>> - Update the Makefile to include the run_tests target, remove
>>>>reference
>>>>   to the performance and stress tests from the contributed sources=
=2E
>>>> - Replace my dead IBM email address with my current Intel email
>>>>address.
>>>> - Remove the warrantee and write-to paragraphs from the license
>>>>blurbs.
>>>> - Remove the NAME section as the filename is easily determined. ;-=
)
>>>> - Make the whitespace usage consistent in a couple of places.
>>>> - Cleanup various CodingStyle violations.
>>>>
>>>> A future effort will explore moving the performance and stress tes=
ts
>>>> into the kernel.
>>>>
>>>> 1. http://git.kernel.org/cgit/linux/kernel/git/dvhart/futextest.gi=
t
>>>>
>>>> Cc: Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
>>>> Cc: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>>>> Cc: Ingo Molnar <mingo-X9Un+BFzKDI@public.gmane.org>
>>>> Cc: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
>>>> Cc: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
>>>> Cc: Davidlohr Bueso <dave-h16yJtLeMjHk1uMJSBkQmQ@public.gmane.org>
>>>> Cc: KOSAKI Motohiro <kosaki.motohiro-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
>>>> Signed-off-by: Darren Hart <dvhart-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
>>>> ---
>>>
>>> Daren,
>>>
>>> I am seeing
>>>
>>> fatal: cannot convert from y to UTF-8
>>>
>>> when I try to apply the patch. Did you use git send-email?
>>=20
>> Hi Shuah,
>>=20
>> I've seen that from one of my contributors earlier this month as wel=
l. I
>> dropped the Content... Header and it applied without problems.
>>=20
>> I created the patch using git format-patch and then sent them using =
git
>> send-email - via a script I've been using for years now...
>>=20
>> Checking the files locally:
>> $ file *
>> 0000-cover-letter.patch:                                         ASC=
II
>>text
>> 0001-selftests-Add-futex-functional-tests.patch:                 uni=
fied
>> diff output, UTF-8 Unicode text
>> 0002-selftest-futex-Update-Makefile-to-use-lib.mk.patch:         uni=
fied
>> diff output, ASCII text
>> 0003-selftest-futex-Increment-ksft-pass-and-fail-counters.patch: uni=
fied
>> diff output, ASCII text
>> 0004-selftest-Add-futex-tests-to-the-top-level-Makefile.patch:   uni=
fied
>> diff output, ASCII text
>> 0005-kselftest-Add-exit-code-defines.patch:                      uni=
fied
>> diff output, ASCII text
>>=20
>>=20
>> This shows that only the first in UTF-8 and the rest are ASCII. I
>>presume
>> this is due to the Copyright notices in the original files:
>>=20
>> Copyright =A9 International Business Machines  Corp., 2006-2008
>>=20
>> Which use =A9 instead of (C). I just checked and there are 545 insta=
nces
>>of
>> =A9 in the kernel itself, so this should not present a problem.
>>=20
>> I apologize for the glitch in applying. If you use the pull request =
I
>> included that will avoid the mail transport issues, and I will be su=
re
>>to
>> fix my scripts to avoid the issue in the future.
>>=20
>> If you want to use the patches directly, please have a look at 1 of =
5
>>and
>> just remove the "Content..." header, and I think you'll find "git am=
"
>>will
>> apply it without complaint.
>>=20
>
>Hi Daren,
>
>Removing the Content header got me past the utf error. However, git am
>complains:
>
>git am --signoff
>../4.2_patches/futex_tests/PATCH_1_5selftestsAddfutexfunctionaltests.m=
box
>Applying: selftests: Add futex functional tests
>/mnt/data/lkml/linux-kselftest/.git/rebase-apply/patch:1457: new blank
>line at EOF.
>+
>warning: 1 line adds whitespace errors.
>
>Could you look into these. Rest of the patches applied fine.

Hi Shuah,

This was due to a newline at the end of:
tools/testing/selftests/futex/functional/run.sh

Which unfortunately checkpatch.pl doesn't catch. My fault for not apply=
ing
the series from the generated patches first. Sorry for the hassle.

I have corrected this in the first patch and pushed v3 of the series to=
:

git://git.infradead.org/users/dvhart/linux.git futextest-v3


$ git diff infradead/futextest-v2 infradead/futextest-v3
diff --git a/tools/testing/selftests/futex/functional/run.sh
b/tools/testing/selftests/futex/functional/run.sh
index 46827a8..e87dbe2 100755
--- a/tools/testing/selftests/futex/functional/run.sh
+++ b/tools/testing/selftests/futex/functional/run.sh
@@ -77,4 +77,3 @@ echo
 echo
 ./futex_wait_uninitialized_heap $COLOR
 ./futex_wait_private_mapped_file $COLOR
-


Is this sufficient or do would you prefer a new pull request?

Thanks,

--=20
Darren Hart
Intel Open Source Technology Center
