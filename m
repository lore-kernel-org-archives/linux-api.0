From: Shuah Khan <shuahkh@osg.samsung.com>
Subject: Re: [PATCH 1/5] selftests: Add futex functional tests
Date: Mon, 11 May 2015 12:55:40 -0600
Message-ID: <5550FB2C.1000403@osg.samsung.com>
References: <cover.1431121818.git.dvhart@linux.intel.com> <57d921b1c30e8258ca4b2f55637424527317e92f.1431121818.git.dvhart@linux.intel.com> <5550EF8D.8080403@osg.samsung.com> <D1763F31.CC237%dvhart@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <D1763F31.CC237%dvhart@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Darren Hart <dvhart@linux.intel.com>, linux-api@vger.kernel.org, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>, Thomas Gleixner <tglx@linutronix.de>, Davidlohr Bueso <dave@stgolabs.net>, KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>, Shuah Khan <shuahkh@osg.samsung.com>
List-Id: linux-api@vger.kernel.org

On 05/11/2015 12:22 PM, Darren Hart wrote:
> On 5/11/15, 11:06 AM, "Shuah Khan" <shuahkh@osg.samsung.com> wrote:
>=20
>> On 05/08/2015 04:09 PM, Darren Hart wrote:
>>> The futextest testsuite [1] provides functional, stress, and
>>> performance tests for the various futex op codes. Those tests will =
be of
>>> more use to futex developers if they are included with the kernel
>>> source.
>>>
>>> Copy the core infrastructure and the functional tests into selftest=
s,
>>> but adapt them for inclusion in the kernel:
>>>
>>> - Update the Makefile to include the run_tests target, remove refer=
ence
>>>   to the performance and stress tests from the contributed sources.
>>> - Replace my dead IBM email address with my current Intel email add=
ress.
>>> - Remove the warrantee and write-to paragraphs from the license blu=
rbs.
>>> - Remove the NAME section as the filename is easily determined. ;-)
>>> - Make the whitespace usage consistent in a couple of places.
>>> - Cleanup various CodingStyle violations.
>>>
>>> A future effort will explore moving the performance and stress test=
s
>>> into the kernel.
>>>
>>> 1. http://git.kernel.org/cgit/linux/kernel/git/dvhart/futextest.git
>>>
>>> Cc: Shuah Khan <shuahkh@osg.samsung.com>
>>> Cc: linux-api@vger.kernel.org
>>> Cc: Ingo Molnar <mingo@elte.hu>
>>> Cc: Peter Zijlstra <peterz@infradead.org>
>>> Cc: Thomas Gleixner <tglx@linutronix.de>
>>> Cc: Davidlohr Bueso <dave@stgolabs.net>
>>> Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
>>> Signed-off-by: Darren Hart <dvhart@linux.intel.com>
>>> ---
>>
>> Daren,
>>
>> I am seeing
>>
>> fatal: cannot convert from y to UTF-8
>>
>> when I try to apply the patch. Did you use git send-email?
>=20
> Hi Shuah,
>=20
> I've seen that from one of my contributors earlier this month as well=
=2E I
> dropped the Content... Header and it applied without problems.
>=20
> I created the patch using git format-patch and then sent them using g=
it
> send-email - via a script I've been using for years now...
>=20
> Checking the files locally:
> $ file *
> 0000-cover-letter.patch:                                         ASCI=
I text
> 0001-selftests-Add-futex-functional-tests.patch:                 unif=
ied
> diff output, UTF-8 Unicode text
> 0002-selftest-futex-Update-Makefile-to-use-lib.mk.patch:         unif=
ied
> diff output, ASCII text
> 0003-selftest-futex-Increment-ksft-pass-and-fail-counters.patch: unif=
ied
> diff output, ASCII text
> 0004-selftest-Add-futex-tests-to-the-top-level-Makefile.patch:   unif=
ied
> diff output, ASCII text
> 0005-kselftest-Add-exit-code-defines.patch:                      unif=
ied
> diff output, ASCII text
>=20
>=20
> This shows that only the first in UTF-8 and the rest are ASCII. I pre=
sume
> this is due to the Copyright notices in the original files:
>=20
> Copyright =A9 International Business Machines  Corp., 2006-2008
>=20
> Which use =A9 instead of (C). I just checked and there are 545 instan=
ces of
> =A9 in the kernel itself, so this should not present a problem.
>=20
> I apologize for the glitch in applying. If you use the pull request I
> included that will avoid the mail transport issues, and I will be sur=
e to
> fix my scripts to avoid the issue in the future.
>=20
> If you want to use the patches directly, please have a look at 1 of 5=
 and
> just remove the "Content..." header, and I think you'll find "git am"=
 will
> apply it without complaint.
>=20

Hi Daren,

Removing the Content header got me past the utf error. However, git am
complains:

git am --signoff
=2E./4.2_patches/futex_tests/PATCH_1_5selftestsAddfutexfunctionaltests.=
mbox
Applying: selftests: Add futex functional tests
/mnt/data/lkml/linux-kselftest/.git/rebase-apply/patch:1457: new blank
line at EOF.
+
warning: 1 line adds whitespace errors.

Could you look into these. Rest of the patches applied fine.

thanks,
-- Shuah

--=20
Shuah Khan
Sr. Linux Kernel Developer
Open Source Innovation Group
Samsung Research America (Silicon Valley)
shuahkh@osg.samsung.com | (970) 217-8978
