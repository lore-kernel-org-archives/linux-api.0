From: Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
Subject: Re: [PATCH] selftests: Fix build failures when invoked from kselftest
 target
Date: Wed, 18 Mar 2015 10:46:39 -0600
Message-ID: <5509ABEF.1030203@osg.samsung.com>
References: <1426297504-14432-1-git-send-email-shuahkh@osg.samsung.com> <1426466329.21900.2.camel@ellerman.id.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1426466329.21900.2.camel-Gsx/Oe8HsFggBc27wqDAHg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Michael Ellerman <mpe-Gsx/Oe8HsFggBc27wqDAHg@public.gmane.org>
Cc: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On 03/15/2015 06:38 PM, Michael Ellerman wrote:
> On Fri, 2015-03-13 at 19:45 -0600, Shuah Khan wrote:
>> Several tests that rely on implicit build rules fail to build,
>> when invoked from the main Makefile kselftest target. These
>> failures are due to --no-builtin-rules and --no-builtin-variables
>> options set in the inherited MAKEFLAGS.
>>
>> --no-builtin-rules eliminates the use of built-in implicit rules
>> and --no-builtin-variables is for not defining built-in variables.
>> These two options override the use of implicit rules resulting in
>> build failures. In addition, inherited LDFLAGS result in build
>> failures and there is no need to define LDFLAGS.  Clear LDFLAGS
>> and MAKEFLAG when make is invoked from the main Makefile kselftest
>> target. Fixing this at selftests Makefile avoids changing the main
>> Makefile and keeps this change self contained at selftests level.
>>
>> Signed-off-by: Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
>> ---
>>  tools/testing/selftests/Makefile | 9 +++++++++
>>  1 file changed, 9 insertions(+)
>>
>> diff --git a/tools/testing/selftests/Makefile b/tools/testing/selftests/Makefile
>> index 4e51122..8e09db7 100644
>> --- a/tools/testing/selftests/Makefile
>> +++ b/tools/testing/selftests/Makefile
>> @@ -22,6 +22,15 @@ TARGETS += vm
>>  TARGETS_HOTPLUG = cpu-hotplug
>>  TARGETS_HOTPLUG += memory-hotplug
>>  
>> +# Clear LDFLAGS and MAKEFLAGS if called from main
>> +# Makefile to avoid test build failures when test
>> +# Makefile doesn't have explicit build rules.
>> +ifeq (1,$(MAKELEVEL))
>> +undefine LDFLAGS
>> +override define MAKEFLAGS =
>> +endef
>> +endif
> 
> You shouldn't need to use define/endef here, that is just for multi-line
> variables.
> 
> This should be equivalent:
> 
>   ifeq (1,$(MAKELEVEL))
>   undefine LDFLAGS
>   override MAKEFLAGS =
>   endif
> 

ok. Will send a patch v2 with that change.

-- Shuah

-- 
Shuah Khan
Sr. Linux Kernel Developer
Open Source Innovation Group
Samsung Research America (Silicon Valley)
shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org | (970) 217-8978
