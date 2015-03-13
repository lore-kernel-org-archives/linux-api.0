From: Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
Subject: Re: [PATCH v4 3/9] selftests: Introduce minimal shared logic for
 running tests
Date: Fri, 13 Mar 2015 14:28:34 -0600
Message-ID: <55034872.7050503@osg.samsung.com>
References: <1426046765-19289-1-git-send-email-mpe@ellerman.id.au> <1426046765-19289-3-git-send-email-mpe@ellerman.id.au> <55031C14.1030203@osg.samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <55031C14.1030203-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Michael Ellerman <mpe-Gsx/Oe8HsFggBc27wqDAHg@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, davej-rdkfGonbjUTCLXcRTR1eJlpr/1R2p/CL@public.gmane.org, mmarek-AlSwsSmVLrQ@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On 03/13/2015 11:19 AM, Shuah Khan wrote:
> On 03/10/2015 10:05 PM, Michael Ellerman wrote:
>> This adds a Make include file which most selftests can then include to
>> get the run_tests logic.
>>
>> On its own this has the advantage of some reduction in repetition, and
>> also means the pass/fail message is defined in fewer places.
>>
>> However the key advantage is it will allow us to implement install very
>> simply in a subsequent patch.
>>
>> The default implementation just executes each program in $(TEST_PROGS).
>>
>> We use a variable to hold the default implementation of $(RUN_TESTS)
>> because that gives us a clean way to override it if necessary, ie. using
>> override. The mount, memory-hotplug and mqueue tests use that to provide
>> a different implementation.
>>
>> Tests are not run via /bin/bash, so if they are scripts they must be
>> executable, we add a+x to several.
>>
>> Signed-off-by: Michael Ellerman <mpe-Gsx/Oe8HsFggBc27wqDAHg@public.gmane.org>
> 
> This patch will be applied to next and queued for 4.1.
> 

This patch is now in linux-kselftest next. Could you please review
to make sure, it looks right. I had to drop the shared logic from
timers Makefile because, it changed considerably with the additional
tests and it wasn't easy to resolve the conflict and keep both changes.
So at the moment, timers doesn't use the shared logic.

If lib.mk could provide a way to run additional programs that require
arguments in addition to RUN_TESTS. In the case of timers, there is one
test that requires arguments. In some cases, e.g: memory hotplug,
override works well since it is just one executable. In this case,
there is a mix.

Something that can be addressed in a separate patch. For now, I made
the decision to apply with shared logic patch minus the changes to
use lib.mk

thanks,
-- Shuah


-- 
Shuah Khan
Sr. Linux Kernel Developer
Open Source Innovation Group
Samsung Research America (Silicon Valley)
shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org | (970) 217-8978
