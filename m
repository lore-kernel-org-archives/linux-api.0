From: Shuah Khan <shuahkh@osg.samsung.com>
Subject: Re: [PATCH] selftests: add seccomp suite
Date: Wed, 17 Jun 2015 17:25:59 -0600
Message-ID: <55820207.1070101@osg.samsung.com>
References: <20150616175414.GA24958@www.outflux.net> <1434526286.28933.2.camel@ellerman.id.au> <CAGXu5jK3xuCqJoE9W+b_5yH+TffDDaL5tDFyZhKRx_K-Qqqk2g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAGXu5jK3xuCqJoE9W+b_5yH+TffDDaL5tDFyZhKRx_K-Qqqk2g@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Kees Cook <keescook@chromium.org>, Michael Ellerman <mpe@ellerman.id.au>
Cc: LKML <linux-kernel@vger.kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, Andy Lutomirski <luto@amacapital.net>, Will Drewry <wad@chromium.org>, Andrew Morton <akpm@linux-foundation.org>, Greg KH <gregkh@linuxfoundation.org>, Mauro Carvalho Chehab <mchehab@osg.samsung.com>, "David S. Miller" <davem@davemloft.net>, Arnd Bergmann <arnd@arndb.de>, Joe Perches <joe@perches.com>, Jingoo Han <jingoohan1@gmail.com>, Linux API <linux-api@vger.kernel.org>, Shuah Khan <shuahkh@osg.samsung.com>
List-Id: linux-api@vger.kernel.org

On 06/17/2015 12:12 PM, Kees Cook wrote:
> On Wed, Jun 17, 2015 at 12:31 AM, Michael Ellerman <mpe@ellerman.id.au> wrote:
>> On Tue, 2015-06-16 at 10:54 -0700, Kees Cook wrote:
>>> This imports the existing seccomp test suite into the kernel's selftests
>>> tree. It contains extensive testing of seccomp features and corner cases.
>>> There remain additional tests to move into the kernel tree, but they have
>>> not yet been ported to all the architectures seccomp supports:
>>> https://github.com/redpig/seccomp/tree/master/tests
>>>
>>> Signed-off-by: Kees Cook <keescook@chromium.org>
>>> ---
>>>  MAINTAINERS                                    |    1 +
>>>  tools/testing/selftests/Makefile               |    1 +
>>>  tools/testing/selftests/seccomp/.gitignore     |    1 +
>>>  tools/testing/selftests/seccomp/Makefile       |   10 +
>>>  tools/testing/selftests/seccomp/seccomp_bpf.c  | 2109 ++++++++++++++++++++++++
>>>  tools/testing/selftests/seccomp/test_harness.h |  537 ++++++
>>
>>
>> Thanks very much for adding this, it would have been very helpful recently when
>> I was trying to get seccomp filter working on powerpc :)
>>
>> I get one failure in TRACE_syscall.syscall_dropped:
>>
>>   seccomp_bpf.c:1394:TRACE_syscall.syscall_dropped:Expected 1 (1) == syscall(207) (18446744073709551615)
>>
>>
>> So it looks like we're returning -1 instead of 1.
>>
>> That's probably a bug in our handling of the return value, or maybe an
>> inconsistency across the arches. I'll try and find time to dig into it.
> 
> Ah-ha! Excellent. Did you add an implementation for change_syscall()
> in seccomp_bpf.c? I don't have a powerpc method in there. I would have
> expected both TRACE_syscall.syscall_redirected and .syscall_dropped to
> fail without that.
> 
> If you did, maybe something isn't right with regs.SYSCALL_RET ? That's
> where the return value being tested on a skipped syscall is stored.
> 
> Thanks for testing!
> 

Thanks for the test. Fantastic to see so many positive responses
to this addition. Thanks Michael for testing it. It is now queued
for 4.2 in linux-kselftest next

thanks,
-- Shuah


-- 
Shuah Khan
Sr. Linux Kernel Developer
Open Source Innovation Group
Samsung Research America (Silicon Valley)
shuahkh@osg.samsung.com | (970) 217-8978
