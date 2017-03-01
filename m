From: Shuah Khan <shuahkh@osg.samsung.com>
Subject: Re: [PATCH 1/5] selftests: Fix selftests build to just build, not run
 tests
Date: Wed, 1 Mar 2017 12:00:03 -0700
Message-ID: <93f8e25b-8ea6-9dc0-66c4-acb6644724de@osg.samsung.com>
References: <1486630590-9410-1-git-send-email-mpe@ellerman.id.au>
 <87shnhmsl1.fsf@concordia.ellerman.id.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Return-path: <linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org>
In-Reply-To: <87shnhmsl1.fsf@concordia.ellerman.id.au>
List-Unsubscribe: <https://lists.ozlabs.org/options/linuxppc-dev>,
 <mailto:linuxppc-dev-request@lists.ozlabs.org?subject=unsubscribe>
List-Archive: <http://lists.ozlabs.org/pipermail/linuxppc-dev/>
List-Post: <mailto:linuxppc-dev@lists.ozlabs.org>
List-Help: <mailto:linuxppc-dev-request@lists.ozlabs.org?subject=help>
List-Subscribe: <https://lists.ozlabs.org/listinfo/linuxppc-dev>,
 <mailto:linuxppc-dev-request@lists.ozlabs.org?subject=subscribe>
Errors-To: linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org
Sender: "Linuxppc-dev"
 <linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org>
To: Michael Ellerman <mpe@ellerman.id.au>, bamvor.zhangjian@huawei.com
Cc: linux-api@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, linuxppc-dev@ozlabs.org, linux-kselftest@vger.kernel.org, hpa@zytor.com, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>
List-Id: linux-api@vger.kernel.org

On 02/13/2017 07:09 PM, Michael Ellerman wrote:
> Michael Ellerman <mpe@ellerman.id.au> writes:
> 
>> In commit 88baa78d1f31 ("selftests: remove duplicated all and clean
>> target"), the "all" target was removed from individual Makefiles and
>> added to lib.mk.
>>
>> However the "all" target was added to lib.mk *after* the existing
>> "runtests" target. This means "runtests" becomes the first (default)
>> target for most of our Makefiles.
> ...
>>
>> Fix it by moving the "all" target to the start of lib.mk, making it the
>> default target.
>>
>> Fixes: 88baa78d1f31 ("selftests: remove duplicated all and clean target")
>> Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
> 
> Hi Shuah,
> 
> Can you please merge this series into linux-next?
> 
> The selftests are badly broken otherwise.
> 
> cheers
> 

Hi Bamovar,

Your original series badly broke the selftest build. I can no longer
build individual tests. For example:

cd breakpoints/
shuah@shuah-XPS-13-9350:/lkml/linux_4.11/tools/testing/selftests/breakpoints$ make
gcc     breakpoint_test.c  -o /breakpoint_test
/usr/bin/ld: cannot open output file /breakpoint_test: Permission denied
collect2: error: ld returned 1 exit status
../lib.mk:54: recipe for target '/breakpoint_test' failed
make: *** [/breakpoint_test] Error 1

commit a8ba798bc8ec663cf02e80b0dd770324de9bafd9
Author: bamvor.zhangjian@huawei.com <bamvor.zhangjian@huawei.com>
Date:   Tue Nov 29 19:55:52 2016 +0800

    selftests: enable O and KBUILD_OUTPUT

I believe the above patch is one of the suspects. Michael fixed
some of the problems in this patch and others he sent.

At the moment individual tests will not build.
tools/testing/selftests/x86$ make
Makefile:44: warning: overriding recipe for target 'clean'
../lib.mk:51: warning: ignoring old recipe for target 'clean'
gcc -m64 -o /single_step_syscall_64 -O2 -g -std=gnu99 -pthread -Wall  single_step_syscall.c -lrt -ldl
/usr/bin/ld: cannot open output file /single_step_syscall_64: Permission denied
collect2: error: ld returned 1 exit status
Makefile:50: recipe for target '/single_step_syscall_64' failed
make: *** [/single_step_syscall_64] Error 1


My guess is OUTPUT doesn't resolve in individual builds from the test directory.
We have to get this fixed for 4.11-rc1

Simply Reverting a8ba798bc8ec663cf02e80b0dd770324de9bafd9 doesn't work.
Michael's patches depend on this. So anyway, please let me know if you
can fix this quickly. I am going to be trying a few things today as well.

thanks,
-- Shuah
