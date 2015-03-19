From: Shuah Khan <shuahkh@osg.samsung.com>
Subject: Re: [PATCH] selftests: Fix kcmp build to not require headers install
Date: Wed, 18 Mar 2015 18:18:51 -0600
Message-ID: <550A15EB.1060900@osg.samsung.com>
References: <1426297504-14432-1-git-send-email-shuahkh@osg.samsung.com> <1426297504-14432-2-git-send-email-shuahkh@osg.samsung.com> <1426503639.4716.7.camel@ellerman.id.au> <55099415.5060400@osg.samsung.com> <1426723357.14101.1.camel@ellerman.id.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1426723357.14101.1.camel@ellerman.id.au>
Sender: linux-kernel-owner@vger.kernel.org
To: Michael Ellerman <mpe@ellerman.id.au>
Cc: gorcunov@openvz.org, tranmanphong@gmail.com, akpm@linux-foundation.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, Shuah Khan <shuahkh@osg.samsung.com>
List-Id: linux-api@vger.kernel.org

On 03/18/2015 06:02 PM, Michael Ellerman wrote:
> On Wed, 2015-03-18 at 09:04 -0600, Shuah Khan wrote:
>> On 03/16/2015 05:00 AM, Michael Ellerman wrote:
>>> On Fri, 2015-03-13 at 19:45 -0600, Shuah Khan wrote:
>>>> Change CFLAGS to look in uapi to allow kcmp to be built without
>>>> requiring headers install. This will make it easier to run tests
>>>> without going through the headers install step.
>>>>
>>>> Signed-off-by: Shuah Khan <shuahkh@osg.samsung.com>
>>>> ---
>>>>  tools/testing/selftests/kcmp/Makefile | 2 +-
>>>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>>>
>>>> diff --git a/tools/testing/selftests/kcmp/Makefile b/tools/testing/selftests/kcmp/Makefile
>>>> index ff0eefd..d405ad4 100644
>>>> --- a/tools/testing/selftests/kcmp/Makefile
>>>> +++ b/tools/testing/selftests/kcmp/Makefile
>>>> @@ -1,5 +1,5 @@
>>>>  CC := $(CROSS_COMPILE)$(CC)
>>>> -CFLAGS += -I../../../../usr/include/
>>>> +CFLAGS += -I../../../../include/uapi -I../../../../usr/include/
>>>
>>> Hi Shuah,
>>>
>>> Sorry but this is wrong. The contents of include/uapi are not the same as the
>>> exported kernel headers.
>>>
>>> Mixing the unprocessed kernel headers with user headers leads to all sorts of
>>> mess, eg:
>>>
>>> $ cc -I../../../../include/uapi -I../../../../usr/include/ kcmp_test.c   -o kcmp_test
>>
>> Do you see this error when you run the compile using kcmp Makefile
>> or using make ksefltest target?
> 
> $ cd tools/testing/selftests
> $ make TARGETS=kcmp
> for TARGET in kcmp; do \
> 	make -C $TARGET; \
> done;
> make[1]: Entering directory '/home/michael/work/topics/powerpc-maint/src/misc-test/tools/testing/selftests/kcmp'
> ppc64-cc -I../../../../include/uapi -I../../../../usr/include/    kcmp_test.c   -o kcmp_test
> In file included from /usr/powerpc-linux-gnu/include/asm/ptrace.h:27:0,
>                  from /usr/powerpc-linux-gnu/include/asm/sigcontext.h:11,
>                  from /usr/powerpc-linux-gnu/include/bits/sigcontext.h:27,
>                  from /usr/powerpc-linux-gnu/include/signal.h:332,
>                  from kcmp_test.c:5:
> ../../../../include/uapi/linux/types.h:9:2: warning: #warning "Attempt to use kernel headers from user space, see http://kernelnewbies.org/KernelHeaders" [-Wcpp]
>  #warning "Attempt to use kernel headers from user space, see http://kernelnewbies.org/KernelHeaders"
>   ^
> 

Hmm..  I don't see this when I run it on x86

make TARGETS=kcmp
for TARGET in kcmp; do \
	make -C $TARGET; \
done;
make[1]: Entering directory
'/lkml/linux-kselftest/tools/testing/selftests/kcmp'
cc -I../../../../include/uapi -I../../../../usr/include/    kcmp_test.c
  -o kcmp_test
make[1]: Leaving directory
'/lkml/linux-kselftest/tools/testing/selftests/kcmp'

oh well. I don't want to make the change, since it introduces warnings
on powerpc.

-- Shuah


-- 
Shuah Khan
Sr. Linux Kernel Developer
Open Source Innovation Group
Samsung Research America (Silicon Valley)
shuahkh@osg.samsung.com | (970) 217-8978
