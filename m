From: Hiraku Toyooka <hiraku.toyooka.gu-FCd8Q96Dh0JBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [PATCH 1/2] selftests/pstore: add pstore test script for pre-reboot
Date: Tue, 15 Sep 2015 11:31:04 +0900
Message-ID: <55F782E8.80508@hitachi.com>
References: <20150908110615.9783.69477.stgit@arietta>	<20150908110617.9783.4635.stgit@arietta> <CAGXu5jKLaoAjE5uYkbQW-o6TcjwDL-PS3=HndjD1LpTnN-rnAg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAGXu5jKLaoAjE5uYkbQW-o6TcjwDL-PS3=HndjD1LpTnN-rnAg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
Cc: LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Tony Luck <tony.luck-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Anton Vorontsov <anton-9xeibp6oKSgdnm+yROfE0A@public.gmane.org>, Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>, Mark Salyzyn <salyzyn-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org>, Colin Cross <ccross-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org>, seiji.aguchi.tr-FCd8Q96Dh0JBDgjK7y7TUQ@public.gmane.org
List-Id: linux-api@vger.kernel.org

Hello, Kees,

Thank you for your advise.

 >> +be_msg=`dmesg | grep "pstore: Registered [a-zA-Z0-9]\+ as 
persistent store backend$"`
...
 > This seems unstable if the system hasn't booted recently or if stuff
 > is spamming dmesg. What about examining /sys/module/pstore instead?

OK, I'll update in that way.

Best regards,
Hiraku Toyooka

Kees Cook wrote:
> On Tue, Sep 8, 2015 at 4:06 AM, Hiraku Toyooka
> <hiraku.toyooka.gu-FCd8Q96Dh0JBDgjK7y7TUQ@public.gmane.org> wrote:
>> The pstore_tests script includes test cases which check pstore's
>> behavior before crash (and reboot).
>>
>> The test cases are currently following.
>>
>> - Check pstore backend is registered
>> - Check pstore console is registered
>> - Check /dev/pmsg0 exists
>> - Write string to /dev/pmsg0
>>
>> Example usage is following.
>>
>> make: Entering directory '/home/root/selftests/pstore'
>> === Pstore unit tests (pstore_tests)===
>> Checking pstore backend is registered ... ok
>> Checking pstore console is registered ... ok
>> Checking /dev/pmsg0 exists ... ok
>> Writing TEST_STRING to /dev/pmsg0 ... ok
>> selftests: pstore_tests [PASS]
>> === Pstore unit tests (pstore_post_reboot_tests)===
>> Checking pstore backend is registered ... ok
>> pstore_crash_test has not been executed yet. we skip further tests.
>> selftests: pstore_post_reboot_tests [PASS]
>> make: Leaving directory '/home/root/selftests/pstore'
>>
>> We can also see test logs later.
>>
>> Signed-off-by: Hiraku Toyooka <hiraku.toyooka.gu-FCd8Q96Dh0JBDgjK7y7TUQ@public.gmane.org>
>> Cc: Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
>> Cc: Tony Luck <tony.luck-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
>> Cc: Anton Vorontsov <anton-9xeibp6oKSgdnm+yROfE0A@public.gmane.org>
>> Cc: Colin Cross <ccross-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org>
>> Cc: Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
>> Cc: Mark Salyzyn <salyzyn-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org>
>> Cc: Seiji Aguchi <seiji.aguchi-7rDLJAbr9SE@public.gmane.org>
>> Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> Cc: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> ---
>>   tools/testing/selftests/Makefile            |    1 +
>>   tools/testing/selftests/pstore/Makefile     |   12 +++++++
>>   tools/testing/selftests/pstore/common_tests |   45 +++++++++++++++++++++++++++
>>   tools/testing/selftests/pstore/pstore_tests |   42 +++++++++++++++++++++++++
>>   4 files changed, 100 insertions(+)
>>   create mode 100644 tools/testing/selftests/pstore/Makefile
>>   create mode 100755 tools/testing/selftests/pstore/common_tests
>>   create mode 100755 tools/testing/selftests/pstore/pstore_tests
>>
>> diff --git a/tools/testing/selftests/Makefile b/tools/testing/selftests/Makefile
>> index 24ae9e8..b58c72e 100644
>> --- a/tools/testing/selftests/Makefile
>> +++ b/tools/testing/selftests/Makefile
>> @@ -12,6 +12,7 @@ TARGETS += mount
>>   TARGETS += mqueue
>>   TARGETS += net
>>   TARGETS += powerpc
>> +TARGETS += pstore
>>   TARGETS += ptrace
>>   TARGETS += seccomp
>>   TARGETS += size
>> diff --git a/tools/testing/selftests/pstore/Makefile b/tools/testing/selftests/pstore/Makefile
>> new file mode 100644
>> index 0000000..40b887d
>> --- /dev/null
>> +++ b/tools/testing/selftests/pstore/Makefile
>> @@ -0,0 +1,12 @@
>> +# Makefile for pstore selftests.
>> +# Expects pstore backend is registered.
>> +
>> +all:
>> +
>> +TEST_PROGS := pstore_tests
>> +TEST_FILES := common_tests
>> +
>> +include ../lib.mk
>> +
>> +clean:
>> +       rm -rf logs/*
>> diff --git a/tools/testing/selftests/pstore/common_tests b/tools/testing/selftests/pstore/common_tests
>> new file mode 100755
>> index 0000000..98611c5
>> --- /dev/null
>> +++ b/tools/testing/selftests/pstore/common_tests
>> @@ -0,0 +1,45 @@
>> +#!/bin/sh
>> +
>> +# common_tests - Shell script commonly used by pstore test scripts
>> +#
>> +# Copyright (C) Hitachi Ltd., 2015
>> +#  Written by Hiraku Toyooka <hiraku.toyooka.gu-FCd8Q96Dh0JBDgjK7y7TUQ@public.gmane.org>
>> +#
>> +# Released under the terms of the GPL v2.
>> +
>> +# Utilities
>> +errexit() { # message
>> +  echo "Error: $1" 1>&2
>> +  exit 1
>> +}
>> +
>> +absdir() { # file_path
>> +  (cd `dirname $1`; pwd)
>> +}
>> +
>> +# Parameters
>> +TOP_DIR=`absdir $0`
>> +LOG_DIR=$TOP_DIR/logs/`date +%Y%m%d-%H%M%S`/
>> +TEST_STRING="Testing pstore"
>> +
>> +# Preparing logs
>> +LOG_FILE=$LOG_DIR/`basename $0`.log
>> +mkdir -p $LOG_DIR || errexit "Failed to make a log directory: $LOG_DIR"
>> +date > $LOG_FILE
>> +prlog() { # messages
>> +  /bin/echo "$@" | tee -a $LOG_FILE
>> +}
>> +prlog "=== Pstore unit tests (`basename $0`)==="
>> +
>> +# Starting tests
>> +rc=0
>> +
>> +prlog -n "Checking pstore backend is registered ... "
>> +be_msg=`dmesg | grep "pstore: Registered [a-zA-Z0-9]\+ as persistent store backend$"`
>> +if [ $? -eq 0 ]; then
>> +    backend=`echo ${be_msg} | sed -e 's/^.*Registered\ \([a-zA-z0-9-]\+\)\ as.*$/\1/g'`
>> +    prlog "ok"
>> +else
>> +    prlog "FAIL"
>> +    exit 1
>> +fi
>
> This seems unstable if the system hasn't booted recently or if stuff
> is spamming dmesg. What about examining /sys/module/pstore instead?
>
>> diff --git a/tools/testing/selftests/pstore/pstore_tests b/tools/testing/selftests/pstore/pstore_tests
>> new file mode 100755
>> index 0000000..cbf613c
>> --- /dev/null
>> +++ b/tools/testing/selftests/pstore/pstore_tests
>> @@ -0,0 +1,42 @@
>> +#!/bin/sh
>> +
>> +# pstore_tests - Check pstore's behavior before crash/reboot
>> +#
>> +# Copyright (C) Hitachi Ltd., 2015
>> +#  Written by Hiraku Toyooka <hiraku.toyooka.gu-FCd8Q96Dh0JBDgjK7y7TUQ@public.gmane.org>
>> +#
>> +# Released under the terms of the GPL v2.
>> +
>> +. ./common_tests
>> +
>> +prlog -n "Checking pstore console is registered ... "
>> +dmesg | grep -q "console \[pstore"
>> +if [ $? -eq 0 ]; then
>> +    prlog "ok"
>> +else
>> +    prlog "FAIL"
>> +fi
>> +
>> +prlog -n "Checking /dev/pmsg0 exists ... "
>> +if [ -e "/dev/pmsg0" ]; then
>> +    prlog "ok"
>> +else
>> +    prlog "FAIL"
>> +    rc=1
>> +fi
>> +
>> +prlog -n "Writing TEST_STRING to /dev/pmsg0 ... "
>> +if [ -e "/dev/pmsg0" ]; then
>> +    echo "${TEST_STRING}" > /dev/pmsg0
>> +    if [ $? -eq 0 ]; then
>> +       prlog "ok"
>> +    else
>> +       prlog "FAIL"
>> +       rc=1
>> +    fi
>> +else
>> +    prlog "FAIL"
>> +    rc=1
>> +fi
>> +
>> +exit $rc
>>
>
> -Kees
>

-- 
Hiraku Toyooka
Systems Productivity Research Dept. / Linux Technology Center
Center for Technology Innovation - Systems Engineering, Hitachi Ltd.
