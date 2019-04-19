From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: Re: [PATCH for 5.1 3/3] rseq/selftests: Adapt number of threads to
 the number of detected cpus
Date: Fri, 19 Apr 2019 09:42:26 -0400 (EDT)
Message-ID: <614774674.134.1555681346941.JavaMail.zimbra@efficios.com>
References: <20190305194755.2602-1-mathieu.desnoyers@efficios.com> <20190305194755.2602-4-mathieu.desnoyers@efficios.com> <20190419103847.GA111210@gmail.com> <1444419838.71.1555677682502.JavaMail.zimbra@efficios.com> <1266612341.87.1555678507226.JavaMail.zimbra@efficios.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1266612341.87.1555678507226.JavaMail.zimbra@efficios.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Ingo Molnar <mingo@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, linux-kernel <linux-kernel@vger.kernel.org>, linux-api <linux-api@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>, "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>, Boqun Feng <boqun.feng@gmail.com>, Andy Lutomirski <luto@amacapital.net>, Dave Watson <davejwatson@fb.com>, Paul Turner <pjt@google.com>, Andrew Morton <akpm@linux-foundation.org>, Russell King <linux@arm.linux.org.uk>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, Andi Kleen <andi@firstfloor.org>, Chris Lameter <cl@linux.com>, Ben Maurer <bmaurer@fb.com>, rostedt <rostedt@goodmis.org>, Josh Triplett <josh@joshtriplett.org>, Linus Torvalds <torvalds@linux-foundation.org>, Catalin Marinas <catalin.marinas@arm.com>, Will
List-Id: linux-api@vger.kernel.org

----- On Apr 19, 2019, at 8:55 AM, Mathieu Desnoyers mathieu.desnoyers@efficios.com wrote:

> ----- On Apr 19, 2019, at 8:41 AM, Mathieu Desnoyers
> mathieu.desnoyers@efficios.com wrote:
> 
>> ----- On Apr 19, 2019, at 6:38 AM, Ingo Molnar mingo@kernel.org wrote:
>> 
>>> * Mathieu Desnoyers <mathieu.desnoyers@efficios.com> wrote:
>>> 
>>>> On smaller systems, running a test with 200 threads can take a long
>>>> time on machines with smaller number of CPUs.
>>>> 
>>>> Detect the number of online cpus at test runtime, and multiply that
>>>> by 6 to have 6 rseq threads per cpu preempting each other.
>>>> 
>>>> Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
>>>> Cc: Shuah Khan <shuah@kernel.org>
>>>> Cc: Thomas Gleixner <tglx@linutronix.de>
>>>> Cc: Joel Fernandes <joelaf@google.com>
>>>> Cc: Peter Zijlstra <peterz@infradead.org>
>>>> Cc: Catalin Marinas <catalin.marinas@arm.com>
>>>> Cc: Dave Watson <davejwatson@fb.com>
>>>> Cc: Will Deacon <will.deacon@arm.com>
>>>> Cc: Andi Kleen <andi@firstfloor.org>
>>>> Cc: linux-kselftest@vger.kernel.org
>>>> Cc: "H . Peter Anvin" <hpa@zytor.com>
>>>> Cc: Chris Lameter <cl@linux.com>
>>>> Cc: Russell King <linux@arm.linux.org.uk>
>>>> Cc: Michael Kerrisk <mtk.manpages@gmail.com>
>>>> Cc: "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>
>>>> Cc: Paul Turner <pjt@google.com>
>>>> Cc: Boqun Feng <boqun.feng@gmail.com>
>>>> Cc: Josh Triplett <josh@joshtriplett.org>
>>>> Cc: Steven Rostedt <rostedt@goodmis.org>
>>>> Cc: Ben Maurer <bmaurer@fb.com>
>>>> Cc: Andy Lutomirski <luto@amacapital.net>
>>>> Cc: Andrew Morton <akpm@linux-foundation.org>
>>>> Cc: Linus Torvalds <torvalds@linux-foundation.org>
>>>> ---
>>>>  tools/testing/selftests/rseq/run_param_test.sh | 7 +++++--
>>>>  1 file changed, 5 insertions(+), 2 deletions(-)
>>>> 
>>>> diff --git a/tools/testing/selftests/rseq/run_param_test.sh
>>>> b/tools/testing/selftests/rseq/run_param_test.sh
>>>> index 3acd6d75ff9f..e426304fd4a0 100755
>>>> --- a/tools/testing/selftests/rseq/run_param_test.sh
>>>> +++ b/tools/testing/selftests/rseq/run_param_test.sh
>>>> @@ -1,6 +1,8 @@
>>>>  #!/bin/bash
>>>>  # SPDX-License-Identifier: GPL-2.0+ or MIT
>>>>  
>>>> +NR_CPUS=`grep '^processor' /proc/cpuinfo | wc -l`
>>>> +
>>>>  EXTRA_ARGS=${@}
>>>>  
>>>>  OLDIFS="$IFS"
>>>> @@ -28,15 +30,16 @@ IFS="$OLDIFS"
>>>>  
>>>>  REPS=1000
>>>>  SLOW_REPS=100
>>>> +NR_THREADS=$((6*${NR_CPUS}))
>>>>  
>>>>  function do_tests()
>>>>  {
>>>>  	local i=0
>>>>  	while [ "$i" -lt "${#TEST_LIST[@]}" ]; do
>>>>  		echo "Running test ${TEST_NAME[$i]}"
>>>> -		./param_test ${TEST_LIST[$i]} -r ${REPS} ${@} ${EXTRA_ARGS} || exit 1
>>>> +		./param_test ${TEST_LIST[$i]} -r ${REPS} -t ${NR_THREADS} ${@} ${EXTRA_ARGS}
>>>> || exit 1
>>>>  		echo "Running compare-twice test ${TEST_NAME[$i]}"
>>>> -		./param_test_compare_twice ${TEST_LIST[$i]} -r ${REPS} ${@} ${EXTRA_ARGS} ||
>>>> exit 1
>>>> +		./param_test_compare_twice ${TEST_LIST[$i]} -r ${REPS} -t ${NR_THREADS} ${@}
>>>> ${EXTRA_ARGS} || exit 1
>>>>  		let "i++"
>>>>  	done
>>>>  }
>>> 
>>> BTW., when trying to build the rseq self-tests I get this build failure:
>>> 
>>>  dagon:~/tip/tools/testing/selftests/rseq> make
>>>  gcc -O2 -Wall -g -I./ -I../../../../usr/include/ -L./ -Wl,-rpath=./ -shared
>>>  -fPIC rseq.c -lpthread -o
>>>  /home/mingo/tip/tools/testing/selftests/rseq/librseq.so
>>>  gcc -O2 -Wall -g -I./ -I../../../../usr/include/ -L./ -Wl,-rpath=./ basic_test.c
>>>  -lpthread -lrseq -o /home/mingo/tip/tools/testing/selftests/rseq/basic_test
>>>  gcc -O2 -Wall -g -I./ -I../../../../usr/include/ -L./ -Wl,-rpath=./
>>>  basic_percpu_ops_test.c -lpthread -lrseq -o
>>>  /home/mingo/tip/tools/testing/selftests/rseq/basic_percpu_ops_test
>>>  /usr/bin/ld: /tmp/ccuHTWnZ.o: in function `rseq_cmpeqv_storev':
>>>  /home/mingo/tip/tools/testing/selftests/rseq/./rseq-x86.h:84: undefined
>>>  reference to `.L8'
>>>  /usr/bin/ld: /home/mingo/tip/tools/testing/selftests/rseq/./rseq-x86.h:84:
>>>  undefined reference to `.L49'
>>>  /usr/bin/ld: /tmp/ccuHTWnZ.o: in function `rseq_cmpnev_storeoffp_load':
>>>  /home/mingo/tip/tools/testing/selftests/rseq/./rseq-x86.h:141: undefined
>>>  reference to `.L57'
>>>  /usr/bin/ld: /tmp/ccuHTWnZ.o:(__rseq_failure+0x8): undefined reference to `.L8'
>>>  /usr/bin/ld: /tmp/ccuHTWnZ.o:(__rseq_failure+0x14): undefined reference to
>>>  `.L49'
>>>  /usr/bin/ld: /tmp/ccuHTWnZ.o:(__rseq_failure+0x20): undefined reference to
>>>  `.L55'
>>>  collect2: error: ld returned 1 exit status
>>>  make: *** [Makefile:22:
>>>  /home/mingo/tip/tools/testing/selftests/rseq/basic_percpu_ops_test] Error 1
>>> 
>>> Is this a known problem, or do I miss something from my build environment
>>> perhaps? Vanilla 64-bit Ubuntu 18.10 (Cosmic).
>> 
>> It works fine with gcc-7 (gcc version 7.3.0 (Ubuntu 7.3.0-16ubuntu3))
>> but indeed I get the same failure with gcc-8 (gcc version 8.0.1 20180414
>> (experimental) [trunk revision 259383] (Ubuntu 8-20180414-1ubuntu2)).
>> 
>> Thanks for reporting! I will investigate.
> 
> It looks like gcc-8 optimize away the target of asm goto labels when
> there are more than one of them on x86-64. I'll try to come up with
> a simpler reproducer.

It appears to be related to gcc-8 mishandling combination of
asm goto and thread-local storage input operands on x86-64.
Here is a simple reproducer:

__thread int var;
  
static int fct(void)
{
        asm goto (      "jmp %l[testlabel]\n\t"
                        : : [var] "m" (var) : : testlabel);
        return 0;
testlabel:
        return 1;
}

int main()
{
        return fct();
}

building with gcc-7 -O2 is fine. Building with gcc-8 -O0 is
fine too. Building with gcc-8 -O1 and -O2 fails with:

/tmp/ccuXTFfs.o: In function `main':
test-asm-goto.c:(.text.startup+0x1): undefined reference to `.L2'
collect2: error: ld returned 1 exit status

With gcc-7 -O2, the assembly of main has the .L2 label:

main:
.LFB1:
        .cfi_startproc
#APP
# 5 "test-asm-goto.c" 1
        jmp .L2

# 0 "" 2
#NO_APP
.L4:
.L3:
        xorl    %eax, %eax
        ret
.L2:
        movl    $1, %eax
        ret
        .cfi_endproc

However, with gcc-8 -O2, it's missing:

main:
.LFB1:
        .cfi_startproc
.L3:
#APP
# 5 "test-asm-goto.c" 1
        jmp .L2

# 0 "" 2
#NO_APP
        xorl    %eax, %eax
        ret
        .cfi_endproc

It looks like we have a compiler issue. :-/

Thanks,

Mathieu

-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
