From: Darren Hart <dvhart@linux.intel.com>
Subject: Re: [PATCH 1/5] selftests: Add futex functional tests
Date: Mon, 11 May 2015 11:22:13 -0700
Message-ID: <D1763F31.CC237%dvhart@linux.intel.com>
References: <cover.1431121818.git.dvhart@linux.intel.com>
 <57d921b1c30e8258ca4b2f55637424527317e92f.1431121818.git.dvhart@linux.intel.com>
 <5550EF8D.8080403@osg.samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <5550EF8D.8080403@osg.samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Shuah Khan <shuahkh@osg.samsung.com>, linux-api@vger.kernel.org, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>, Thomas Gleixner <tglx@linutronix.de>, Davidlohr Bueso <dave@stgolabs.net>, KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
List-Id: linux-api@vger.kernel.org

On 5/11/15, 11:06 AM, "Shuah Khan" <shuahkh@osg.samsung.com> wrote:

>On 05/08/2015 04:09 PM, Darren Hart wrote:
>> The futextest testsuite [1] provides functional, stress, and
>> performance tests for the various futex op codes. Those tests will b=
e of
>> more use to futex developers if they are included with the kernel
>> source.
>>=20
>> Copy the core infrastructure and the functional tests into selftests=
,
>> but adapt them for inclusion in the kernel:
>>=20
>> - Update the Makefile to include the run_tests target, remove refere=
nce
>>   to the performance and stress tests from the contributed sources.
>> - Replace my dead IBM email address with my current Intel email addr=
ess.
>> - Remove the warrantee and write-to paragraphs from the license blur=
bs.
>> - Remove the NAME section as the filename is easily determined. ;-)
>> - Make the whitespace usage consistent in a couple of places.
>> - Cleanup various CodingStyle violations.
>>=20
>> A future effort will explore moving the performance and stress tests
>> into the kernel.
>>=20
>> 1. http://git.kernel.org/cgit/linux/kernel/git/dvhart/futextest.git
>>=20
>> Cc: Shuah Khan <shuahkh@osg.samsung.com>
>> Cc: linux-api@vger.kernel.org
>> Cc: Ingo Molnar <mingo@elte.hu>
>> Cc: Peter Zijlstra <peterz@infradead.org>
>> Cc: Thomas Gleixner <tglx@linutronix.de>
>> Cc: Davidlohr Bueso <dave@stgolabs.net>
>> Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
>> Signed-off-by: Darren Hart <dvhart@linux.intel.com>
>> ---
>
>Daren,
>
>I am seeing
>
>fatal: cannot convert from y to UTF-8
>
>when I try to apply the patch. Did you use git send-email?

Hi Shuah,

I've seen that from one of my contributors earlier this month as well. =
I
dropped the Content... Header and it applied without problems.

I created the patch using git format-patch and then sent them using git
send-email - via a script I've been using for years now...

Checking the files locally:
$ file *
0000-cover-letter.patch:                                         ASCII =
text
0001-selftests-Add-futex-functional-tests.patch:                 unifie=
d
diff output, UTF-8 Unicode text
0002-selftest-futex-Update-Makefile-to-use-lib.mk.patch:         unifie=
d
diff output, ASCII text
0003-selftest-futex-Increment-ksft-pass-and-fail-counters.patch: unifie=
d
diff output, ASCII text
0004-selftest-Add-futex-tests-to-the-top-level-Makefile.patch:   unifie=
d
diff output, ASCII text
0005-kselftest-Add-exit-code-defines.patch:                      unifie=
d
diff output, ASCII text


This shows that only the first in UTF-8 and the rest are ASCII. I presu=
me
this is due to the Copyright notices in the original files:

Copyright =A9 International Business Machines  Corp., 2006-2008

Which use =A9 instead of (C). I just checked and there are 545 instance=
s of
=A9 in the kernel itself, so this should not present a problem.

I apologize for the glitch in applying. If you use the pull request I
included that will avoid the mail transport issues, and I will be sure =
to
fix my scripts to avoid the issue in the future.

If you want to use the patches directly, please have a look at 1 of 5 a=
nd
just remove the "Content..." header, and I think you'll find "git am" w=
ill
apply it without complaint.

Thanks,

--=20
Darren Hart
Intel Open Source Technology Center
