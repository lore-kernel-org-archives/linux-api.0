From: Darren Hart <dvhart@linux.intel.com>
Subject: Re: [PATCH 5/5] kselftest: Add exit code defines
Date: Fri, 27 Mar 2015 16:09:23 -0700
Message-ID: <5515E323.1070800@linux.intel.com>
References: <597c9eabcac5da9456d6cfd6de9117591d73385e.1427493640.git.dvhart@linux.intel.com>	 <43a448183a340b61d91c711da4a75898e3ffd8f2.1427493640.git.dvhart@linux.intel.com> <1427497178.3986.1.camel@ellerman.id.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1427497178.3986.1.camel@ellerman.id.au>
Sender: linux-kernel-owner@vger.kernel.org
To: Michael Ellerman <mpe@ellerman.id.au>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Shuah Khan <shuahkh@osg.samsung.com>, linux-api@vger.kernel.org, Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>, Thomas Gleixner <tglx@linutronix.de>, Davidlohr Bueso <dave@stgolabs.net>, KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
List-Id: linux-api@vger.kernel.org



On 3/27/15 3:59 PM, Michael Ellerman wrote:
> On Fri, 2015-03-27 at 15:17 -0700, Darren Hart wrote:
>> Define the exit codes with KSFT_PASS and similar so tests can use these
>> directly if they choose. Also enable harnesses and other tooling to use
>> the defines instead of hardcoding the return codes.
>  
> +1
> 
>> diff --git a/tools/testing/selftests/kselftest.h b/tools/testing/selftests/kselftest.h
>> index 572c888..ef1c80d 100644
>> --- a/tools/testing/selftests/kselftest.h
>> +++ b/tools/testing/selftests/kselftest.h
>> @@ -13,6 +13,13 @@
>>  #include <stdlib.h>
>>  #include <unistd.h>
>>  
>> +/* define kselftest exit codes */
>> +#define KSFT_PASS  0
>> +#define KSFT_FAIL  1
>> +#define KSFT_XFAIL 2
>> +#define KSFT_XPASS 3
>> +#define KSFT_SKIP  4
>> +
>>  /* counters */
>>  struct ksft_count {
>>  	unsigned int ksft_pass;
>> @@ -40,23 +47,23 @@ static inline void ksft_print_cnts(void)
>>  
>>  static inline int ksft_exit_pass(void)
>>  {
>> -	exit(0);
>> +	exit(KSFT_PASS);
>>  }
> 
> Am I the only person who's bothered by the fact that these don't actually
> return int?

That bothered me to, but I couldn't be bothered to go read the manuals
apparently to come up with a compelling argument :-)

I also think the ksft_exit* routines should go ahead and increment the
counters (at least optionally) so we don't have to call two functions.

-- 
Darren Hart
Intel Open Source Technology Center
