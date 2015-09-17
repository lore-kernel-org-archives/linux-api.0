From: Hiraku Toyooka <hiraku.toyooka.gu-FCd8Q96Dh0JBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [PATCH 1/2] selftests/pstore: add pstore test script for pre-reboot
Date: Thu, 17 Sep 2015 14:54:29 +0900
Message-ID: <55FA5595.4050207@hitachi.com>
References: <20150908110615.9783.69477.stgit@arietta>	<20150908110617.9783.4635.stgit@arietta> <CAGXu5jKLaoAjE5uYkbQW-o6TcjwDL-PS3=HndjD1LpTnN-rnAg@mail.gmail.com> <55F782E8.80508@hitachi.com> <753241EEF6DFAB4CAF20F32F515C4E358B33C3@GSjpTK1DCembx02.service.hitachi.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <753241EEF6DFAB4CAF20F32F515C4E358B33C3-RKwZE6o2dOX6mtb5pcma++hNMziWB107FCd8Q96Dh0LR7s880joybQ@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: =?UTF-8?B?6Zi/5Y+j6Kqg5Y+4IC8gQUdVQ0hJ77yMU0VJSkk=?= <seiji.aguchi.tr-FCd8Q96Dh0JBDgjK7y7TUQ@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
Cc: LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Tony Luck <tony.luck-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Anton Vorontsov <anton-9xeibp6oKSgdnm+yROfE0A@public.gmane.org>, Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>, Mark Salyzyn <salyzyn-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org>, Colin Cross <ccross-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Hello,

 > It may be good if you can log  "/sys/module/pstore/parameters/backen=
d/"
 > or /proc/cmdline in failure case.
 >
 > It makes debug easy.

OK, I'll have the script log the information in v2.

Best regards,
Hiraku Toyooka

=E9=98=BF=E5=8F=A3=E8=AA=A0=E5=8F=B8 / AGUCHI=EF=BC=8CSEIJI wrote:
> Hi,
>
>>>> +prlog -n "Checking pstore backend is registered ... "
>>>> +be_msg=3D`dmesg | grep "pstore: Registered [a-zA-Z0-9]\+ as persi=
stent store backend$"`
>>>> +if [ $? -eq 0 ]; then
>>>> +    backend=3D`echo ${be_msg} | sed -e 's/^.*Registered\ \([a-zA-=
z0-9-]\+\)\ as.*$/\1/g'`
>>>> +    prlog "ok"
>>>> +else
>>>> +    prlog "FAIL"
>>>> +    exit 1
>
> It may be good if you can log  "/sys/module/pstore/parameters/backend=
/"
> or /proc/cmdline in failure case.
>
> It makes debug easy.
>
> Seiji
>
>>>> +fi
>
>
>> -----Original Message-----
>> From: =E8=B1=8A=E5=B2=A1=E6=8B=93 / Toyooka=EF=BC=8CHiraku
>> Sent: Tuesday, September 15, 2015 11:31 AM
>> To: Kees Cook
>> Cc: LKML; Tony Luck; Linux API; Anton Vorontsov; Shuah Khan; Mark Sa=
lyzyn; Colin Cross; =E9=98=BF=E5=8F=A3=E8=AA=A0=E5=8F=B8 / AGUCHI=EF=BC=
=8CSEIJI
>> Subject: Re: [PATCH 1/2] selftests/pstore: add pstore test script fo=
r pre-reboot
>>
>> Hello, Kees,
>>
>> Thank you for your advise.
>>
>>   >> +be_msg=3D`dmesg | grep "pstore: Registered [a-zA-Z0-9]\+ as
>> persistent store backend$"`
>> ...
>>   > This seems unstable if the system hasn't booted recently or if s=
tuff
>>   > is spamming dmesg. What about examining /sys/module/pstore inste=
ad?
>>
>> OK, I'll update in that way.
>>
>> Best regards,
>> Hiraku Toyooka
>>
>> Kees Cook wrote:
>>> On Tue, Sep 8, 2015 at 4:06 AM, Hiraku Toyooka
>>> <hiraku.toyooka.gu-FCd8Q96Dh0JBDgjK7y7TUQ@public.gmane.org> wrote:
>>>> The pstore_tests script includes test cases which check pstore's
>>>> behavior before crash (and reboot).
>>>>
>>>> The test cases are currently following.
>>>>
>>>> - Check pstore backend is registered
>>>> - Check pstore console is registered
>>>> - Check /dev/pmsg0 exists
>>>> - Write string to /dev/pmsg0
>>>>
>>>> Example usage is following.
>>>>
>>>> make: Entering directory '/home/root/selftests/pstore'
>>>> =3D=3D=3D Pstore unit tests (pstore_tests)=3D=3D=3D
>>>> Checking pstore backend is registered ... ok
>>>> Checking pstore console is registered ... ok
>>>> Checking /dev/pmsg0 exists ... ok
>>>> Writing TEST_STRING to /dev/pmsg0 ... ok
>>>> selftests: pstore_tests [PASS]
>>>> =3D=3D=3D Pstore unit tests (pstore_post_reboot_tests)=3D=3D=3D
>>>> Checking pstore backend is registered ... ok
>>>> pstore_crash_test has not been executed yet. we skip further tests=
=2E
>>>> selftests: pstore_post_reboot_tests [PASS]
>>>> make: Leaving directory '/home/root/selftests/pstore'
>>>>
>>>> We can also see test logs later.
>>>>
>>>> Signed-off-by: Hiraku Toyooka <hiraku.toyooka.gu-FCd8Q96Dh0JBDgjK7y7TUQ@public.gmane.org>
>>>> Cc: Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
>>>> Cc: Tony Luck <tony.luck-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
>>>> Cc: Anton Vorontsov <anton-9xeibp6oKSgdnm+yROfE0A@public.gmane.org>
>>>> Cc: Colin Cross <ccross-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org>
>>>> Cc: Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
>>>> Cc: Mark Salyzyn <salyzyn-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org>
>>>> Cc: Seiji Aguchi <seiji.aguchi-7rDLJAbr9SE@public.gmane.org>
>>>> Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>>>> Cc: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>>>> ---
>>>>    tools/testing/selftests/Makefile            |    1 +
>>>>    tools/testing/selftests/pstore/Makefile     |   12 +++++++
>>>>    tools/testing/selftests/pstore/common_tests |   45 ++++++++++++=
+++++++++++++++
>>>>    tools/testing/selftests/pstore/pstore_tests |   42 ++++++++++++=
+++++++++++++
>>>>    4 files changed, 100 insertions(+)
>>>>    create mode 100644 tools/testing/selftests/pstore/Makefile
>>>>    create mode 100755 tools/testing/selftests/pstore/common_tests
>>>>    create mode 100755 tools/testing/selftests/pstore/pstore_tests
>>>>
>>>> diff --git a/tools/testing/selftests/Makefile b/tools/testing/self=
tests/Makefile
>>>> index 24ae9e8..b58c72e 100644
>>>> --- a/tools/testing/selftests/Makefile
>>>> +++ b/tools/testing/selftests/Makefile
>>>> @@ -12,6 +12,7 @@ TARGETS +=3D mount
>>>>    TARGETS +=3D mqueue
>>>>    TARGETS +=3D net
>>>>    TARGETS +=3D powerpc
>>>> +TARGETS +=3D pstore
>>>>    TARGETS +=3D ptrace
>>>>    TARGETS +=3D seccomp
>>>>    TARGETS +=3D size
>>>> diff --git a/tools/testing/selftests/pstore/Makefile b/tools/testi=
ng/selftests/pstore/Makefile
>>>> new file mode 100644
>>>> index 0000000..40b887d
>>>> --- /dev/null
>>>> +++ b/tools/testing/selftests/pstore/Makefile
>>>> @@ -0,0 +1,12 @@
>>>> +# Makefile for pstore selftests.
>>>> +# Expects pstore backend is registered.
>>>> +
>>>> +all:
>>>> +
>>>> +TEST_PROGS :=3D pstore_tests
>>>> +TEST_FILES :=3D common_tests
>>>> +
>>>> +include ../lib.mk
>>>> +
>>>> +clean:
>>>> +       rm -rf logs/*
>>>> diff --git a/tools/testing/selftests/pstore/common_tests b/tools/t=
esting/selftests/pstore/common_tests
>>>> new file mode 100755
>>>> index 0000000..98611c5
>>>> --- /dev/null
>>>> +++ b/tools/testing/selftests/pstore/common_tests
>>>> @@ -0,0 +1,45 @@
>>>> +#!/bin/sh
>>>> +
>>>> +# common_tests - Shell script commonly used by pstore test script=
s
>>>> +#
>>>> +# Copyright (C) Hitachi Ltd., 2015
>>>> +#  Written by Hiraku Toyooka <hiraku.toyooka.gu-FCd8Q96Dh0JBDgjK7y7TUQ@public.gmane.org>
>>>> +#
>>>> +# Released under the terms of the GPL v2.
>>>> +
>>>> +# Utilities
>>>> +errexit() { # message
>>>> +  echo "Error: $1" 1>&2
>>>> +  exit 1
>>>> +}
>>>> +
>>>> +absdir() { # file_path
>>>> +  (cd `dirname $1`; pwd)
>>>> +}
>>>> +
>>>> +# Parameters
>>>> +TOP_DIR=3D`absdir $0`
>>>> +LOG_DIR=3D$TOP_DIR/logs/`date +%Y%m%d-%H%M%S`/
>>>> +TEST_STRING=3D"Testing pstore"
>>>> +
>>>> +# Preparing logs
>>>> +LOG_FILE=3D$LOG_DIR/`basename $0`.log
>>>> +mkdir -p $LOG_DIR || errexit "Failed to make a log directory: $LO=
G_DIR"
>>>> +date > $LOG_FILE
>>>> +prlog() { # messages
>>>> +  /bin/echo "$@" | tee -a $LOG_FILE
>>>> +}
>>>> +prlog "=3D=3D=3D Pstore unit tests (`basename $0`)=3D=3D=3D"
>>>> +
>>>> +# Starting tests
>>>> +rc=3D0
>>>> +
>>>> +prlog -n "Checking pstore backend is registered ... "
>>>> +be_msg=3D`dmesg | grep "pstore: Registered [a-zA-Z0-9]\+ as persi=
stent store backend$"`
>>>> +if [ $? -eq 0 ]; then
>>>> +    backend=3D`echo ${be_msg} | sed -e 's/^.*Registered\ \([a-zA-=
z0-9-]\+\)\ as.*$/\1/g'`
>>>> +    prlog "ok"
>>>> +else
>>>> +    prlog "FAIL"
>>>> +    exit 1
>>>> +fi
>>>
>>> This seems unstable if the system hasn't booted recently or if stuf=
f
>>> is spamming dmesg. What about examining /sys/module/pstore instead?
>>>
>>>> diff --git a/tools/testing/selftests/pstore/pstore_tests b/tools/t=
esting/selftests/pstore/pstore_tests
>>>> new file mode 100755
>>>> index 0000000..cbf613c
>>>> --- /dev/null
>>>> +++ b/tools/testing/selftests/pstore/pstore_tests
>>>> @@ -0,0 +1,42 @@
>>>> +#!/bin/sh
>>>> +
>>>> +# pstore_tests - Check pstore's behavior before crash/reboot
>>>> +#
>>>> +# Copyright (C) Hitachi Ltd., 2015
>>>> +#  Written by Hiraku Toyooka <hiraku.toyooka.gu-FCd8Q96Dh0JBDgjK7y7TUQ@public.gmane.org>
>>>> +#
>>>> +# Released under the terms of the GPL v2.
>>>> +
>>>> +. ./common_tests
>>>> +
>>>> +prlog -n "Checking pstore console is registered ... "
>>>> +dmesg | grep -q "console \[pstore"
>>>> +if [ $? -eq 0 ]; then
>>>> +    prlog "ok"
>>>> +else
>>>> +    prlog "FAIL"
>>>> +fi
>>>> +
>>>> +prlog -n "Checking /dev/pmsg0 exists ... "
>>>> +if [ -e "/dev/pmsg0" ]; then
>>>> +    prlog "ok"
>>>> +else
>>>> +    prlog "FAIL"
>>>> +    rc=3D1
>>>> +fi
>>>> +
>>>> +prlog -n "Writing TEST_STRING to /dev/pmsg0 ... "
>>>> +if [ -e "/dev/pmsg0" ]; then
>>>> +    echo "${TEST_STRING}" > /dev/pmsg0
>>>> +    if [ $? -eq 0 ]; then
>>>> +       prlog "ok"
>>>> +    else
>>>> +       prlog "FAIL"
>>>> +       rc=3D1
>>>> +    fi
>>>> +else
>>>> +    prlog "FAIL"
>>>> +    rc=3D1
>>>> +fi
>>>> +
>>>> +exit $rc
>>>>
>>>
>>> -Kees
>>>
>>
>> --
>> Hiraku Toyooka
>> Systems Productivity Research Dept. / Linux Technology Center
>> Center for Technology Innovation - Systems Engineering, Hitachi Ltd.

--=20
Hiraku Toyooka
Systems Productivity Research Dept. / Linux Technology Center
Center for Technology Innovation - Systems Engineering, Hitachi Ltd.
