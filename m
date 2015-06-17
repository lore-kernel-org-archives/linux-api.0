From: Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
Subject: Re: [PATCH] selftests: add seccomp suite
Date: Wed, 17 Jun 2015 11:12:56 -0700
Message-ID: <CAGXu5jK3xuCqJoE9W+b_5yH+TffDDaL5tDFyZhKRx_K-Qqqk2g@mail.gmail.com>
References: <20150616175414.GA24958@www.outflux.net>
	<1434526286.28933.2.camel@ellerman.id.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1434526286.28933.2.camel-Gsx/Oe8HsFggBc27wqDAHg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Michael Ellerman <mpe-Gsx/Oe8HsFggBc27wqDAHg@public.gmane.org>
Cc: LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Daniel Borkmann <daniel-FeC+5ew28dpmcu3hnIyYJQ@public.gmane.org>, Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Will Drewry <wad-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Greg KH <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Mauro Carvalho Chehab <mchehab-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>, "David S. Miller" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Joe Perches <joe-6d6DIl74uiNBDgjK7y7TUQ@public.gmane.org>, Jingoo Han <jingoohan1-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Wed, Jun 17, 2015 at 12:31 AM, Michael Ellerman <mpe-Gsx/Oe8HsFggBc27wqDAHg@public.gmane.org> wrote:
> On Tue, 2015-06-16 at 10:54 -0700, Kees Cook wrote:
>> This imports the existing seccomp test suite into the kernel's selftests
>> tree. It contains extensive testing of seccomp features and corner cases.
>> There remain additional tests to move into the kernel tree, but they have
>> not yet been ported to all the architectures seccomp supports:
>> https://github.com/redpig/seccomp/tree/master/tests
>>
>> Signed-off-by: Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
>> ---
>>  MAINTAINERS                                    |    1 +
>>  tools/testing/selftests/Makefile               |    1 +
>>  tools/testing/selftests/seccomp/.gitignore     |    1 +
>>  tools/testing/selftests/seccomp/Makefile       |   10 +
>>  tools/testing/selftests/seccomp/seccomp_bpf.c  | 2109 ++++++++++++++++++++++++
>>  tools/testing/selftests/seccomp/test_harness.h |  537 ++++++
>
>
> Thanks very much for adding this, it would have been very helpful recently when
> I was trying to get seccomp filter working on powerpc :)
>
> I get one failure in TRACE_syscall.syscall_dropped:
>
>   seccomp_bpf.c:1394:TRACE_syscall.syscall_dropped:Expected 1 (1) == syscall(207) (18446744073709551615)
>
>
> So it looks like we're returning -1 instead of 1.
>
> That's probably a bug in our handling of the return value, or maybe an
> inconsistency across the arches. I'll try and find time to dig into it.

Ah-ha! Excellent. Did you add an implementation for change_syscall()
in seccomp_bpf.c? I don't have a powerpc method in there. I would have
expected both TRACE_syscall.syscall_redirected and .syscall_dropped to
fail without that.

If you did, maybe something isn't right with regs.SYSCALL_RET ? That's
where the return value being tested on a skipped syscall is stored.

Thanks for testing!

-Kees

-- 
Kees Cook
Chrome OS Security
