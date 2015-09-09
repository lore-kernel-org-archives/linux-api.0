From: Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
Subject: Re: [PATCH] selftests/seccomp: build on aarch64, document ABI
Date: Wed, 9 Sep 2015 13:52:39 -0700
Message-ID: <CAGXu5jJw8hAVPKvut51D1jojsCEGEweWNu2TyWrgUfQ9hqsw3Q@mail.gmail.com>
References: <20150909193025.GA29244@www.outflux.net>
	<19228212.s6UOoYJca9@wuerfel>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <19228212.s6UOoYJca9@wuerfel>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
Cc: "linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, Will Drewry <wad-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Bamvor Zhang Jian <bamvor.zhangjian-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Wed, Sep 9, 2015 at 1:08 PM, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org> wrote:
> On Wednesday 09 September 2015 12:30:27 Kees Cook wrote:
>> The syscall ABI is inconsistent on aarch64 compat, so at least we should
>> document it in the seccomp_bpf tests.
>>
>> Signed-off-by: Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
>
> Can you explain in what way the ABI is inconsistent here?
>
>> ---
>> Can someone with access to native aarch64 double-check this for me? I
>> think we need to change these tests to pass if it's expected, but the
>> compat behavior seems bad. It means compat code will break under an
>> aarch64 kernel, when dealing with syscalls, like through seccomp.
>> ---
>>  tools/testing/selftests/seccomp/seccomp_bpf.c | 15 +++++++++++++--
>>  1 file changed, 13 insertions(+), 2 deletions(-)
>>
>> diff --git a/tools/testing/selftests/seccomp/seccomp_bpf.c b/tools/testing/selftests/seccomp/seccomp_bpf.c
>> index 770f47adf295..866ff42e000d 100644
>> --- a/tools/testing/selftests/seccomp/seccomp_bpf.c
>> +++ b/tools/testing/selftests/seccomp/seccomp_bpf.c
>> @@ -33,6 +33,10 @@
>>  #include <unistd.h>
>>  #include <sys/syscall.h>
>>
>> +#if defined(__aarch64__) && !defined(__NR_poll)
>> +# define __NR_poll 0x49
>> +#endif
>
> I don't understand this: 0x49 is __NR_ppoll on arm64 and all architectures
> that use asm-generic/unistd.h, not __NR_poll, which is no longer used there.

Ah-ha, okay, that explains part of my struggle. :)

> If this is intentional, it at least needs a comment to explain the
> situation, and be extended to all other architectures that do not have
> a poll() system call.
>
> The arm32 version of sys_poll should be available as 168 in both native
> and compat mode.

Does ppoll still get interrupted like poll to require a restart_syscall call?

Regardless, the primary problem is this (emphasis added):

>> +        * - native ARM does _not_ expose true syscall.
>> +        * - compat ARM on ARM64 _does_ expose true syscall.

When you ptrace or seccomp an arm32 binary under and arm32 kernel,
restart_syscall is invisible. When you ptrace or seccomp an arm32
binary under and arm64 kernel, suddenly it's visible. This means, for
example, seccomp filters will break under an arm64 kernel.

(And apologies if I'm not remembering pieces of this correctly, I
don't have access to arm64 hardware at the moment, which is why I'm
reaching out for some help on this... I'm trying to close out this old
thread: https://lkml.org/lkml/2015/1/20/778 )

-Kees

-- 
Kees Cook
Chrome OS Security
