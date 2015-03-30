From: Darren Hart <dvhart-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [PATCH 2/5] selftest/futex: Update Makefile to use lib.mk
Date: Mon, 30 Mar 2015 09:31:14 -0700
Message-ID: <D13EC750.C43E1%dvhart@linux.intel.com>
References: <597c9eabcac5da9456d6cfd6de9117591d73385e.1427493640.git.dvhart@linux.intel.com>
 <95d599bc531666252f8e3f4e467d5f94af2a7ad2.1427493640.git.dvhart@linux.intel.com>
 <1427672978.4218.3.camel@ellerman.id.au>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1427672978.4218.3.camel-Gsx/Oe8HsFggBc27wqDAHg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Michael Ellerman <mpe-Gsx/Oe8HsFggBc27wqDAHg@public.gmane.org>
Cc: Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ingo Molnar <mingo-X9Un+BFzKDI@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Davidlohr Bueso <dave-h16yJtLeMjHk1uMJSBkQmQ@public.gmane.org>, KOSAKI Motohiro <kosaki.motohiro-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On 3/29/15, 4:49 PM, "Michael Ellerman" <mpe-Gsx/Oe8HsFggBc27wqDAHg@public.gmane.org> wrote:

>On Fri, 2015-03-27 at 15:17 -0700, Darren Hart wrote:
>> Adapt the futextest Makefiles to use lib.mk macros for RUN_TESTS and
>> EMIT_TESTS. For now, we reuse the run.sh mechanism provided by
>> futextest. This doesn't provide the standard selftests: [PASS|FAIL]
>> format, but the tests provide very similar output already.
>> 
>> This results in the run_kselftest.sh script for futexes including a
>> single line: ./run.sh
>> 
>> Cc: Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
>> Cc: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> Cc: Ingo Molnar <mingo-X9Un+BFzKDI@public.gmane.org>
>> Cc: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
>> Cc: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
>> Cc: Davidlohr Bueso <dave-h16yJtLeMjHk1uMJSBkQmQ@public.gmane.org>
>> Cc: KOSAKI Motohiro <kosaki.motohiro-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
>> Signed-off-by: Darren Hart <dvhart-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
>> ---
>>  tools/testing/selftests/futex/Makefile            | 21
>>+++++++++++++++++++++
>>  tools/testing/selftests/futex/functional/Makefile |  4 ++++
>>  2 files changed, 25 insertions(+)
>> 
>> diff --git a/tools/testing/selftests/futex/Makefile
>>b/tools/testing/selftests/futex/Makefile
>> index 8629187..6a17529 100644
>> --- a/tools/testing/selftests/futex/Makefile
>> +++ b/tools/testing/selftests/futex/Makefile
>> @@ -1,8 +1,29 @@
>>  SUBDIRS := functional
>>  
>> +TEST_PROGS := run.sh
>> +
>>  .PHONY: all clean
>
>lib.mk defines all & clean as PHONY for you.

OK, I can remove this (it was just part of the originals). Shall I resent
the whole series or just a follow-on patch?

>
>>  all:
>>  	for DIR in $(SUBDIRS); do $(MAKE) -C $$DIR $@ ; done
>>  
>> +include ../lib.mk
>> +
>> +override define RUN_TESTS
>> +	./run.sh
>> +endef
>
>Do you need to do this override? The standard logic should work AFAICS,
>or do
>you not want the echo logic?

The standard logic wants to run each individual test and uses the echo
logic. My tests have their own pass/fail reporting mechanism. As I run
many options on the same tests and have pretty-printing logic, I prefer to
keep that in a run script rather than in a makefile.

I don't care for the echo logic as a mechanism, I think the reporting
should be part of the test. It also doesn't scale past pass/fail - like
xpass and xfail, for example.

>
>> +override define INSTALL_RULE
>> +	mkdir -p $(INSTALL_PATH)
>> +	install -t $(INSTALL_PATH) $(TEST_PROGS) $(TEST_PROGS_EXTENDED)
>>$(TEST_FILES)
>> +
>> +	@for SUBDIR in $(SUBDIRS); do \
>> +		$(MAKE) -C $$SUBDIR INSTALL_PATH=$(INSTALL_PATH)/$$SUBDIR install; \
>> +	done;
>> +endef
>> +
>> +override define EMIT_TESTS
>> +	echo "./run.sh"
>> +endef
>
>Ditto.
>
>cheers
>
>
>
>
>


-- 
Darren Hart
Intel Open Source Technology Center
