From: Christian Brauner <christian@brauner.io>
Subject: Re: [PATCH v2] signal: add procfd_signal() syscall
Date: Fri, 30 Nov 2018 08:16:52 +1300
Message-ID: <993B98AC-51DF-4131-AF7F-7DA2A7F485F1@brauner.io>
References: <20181120105124.14733-1-christian@brauner.io> <87in0g5aqo.fsf@oldenburg.str.redhat.com> <36323361-90BD-41AF-AB5B-EE0D7BA02C21@amacapital.net>
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <36323361-90BD-41AF-AB5B-EE0D7BA02C21@amacapital.net>
Sender: linux-kernel-owner@vger.kernel.org
To: Andy Lutomirski <luto@amacapital.net>, Florian Weimer <fweimer@redhat.com>
Cc: ebiederm@xmission.com, linux-kernel@vger.kernel.org, serge@hallyn.com, jannh@google.com, luto@kernel.org, akpm@linux-foundation.org, oleg@redhat.com, cyphar@cyphar.com, viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org, dancol@google.com, timmurray@google.com, linux-man@vger.kernel.org, Kees Cook <keescook@chromium.org>
List-Id: linux-api@vger.kernel.org

On November 30, 2018 5:54:18 AM GMT+13:00, Andy Lutomirski <luto@amacapital=
=2Enet> wrote:
>
>
>> On Nov 29, 2018, at 4:28 AM, Florian Weimer <fweimer@redhat=2Ecom>
>wrote:
>>=20
>> Disclaimer: I'm looking at this patch because Christian requested it=2E
>> I'm not a kernel developer=2E
>>=20
>> * Christian Brauner:
>>=20
>>> diff --git a/arch/x86/entry/syscalls/syscall_32=2Etbl
>b/arch/x86/entry/syscalls/syscall_32=2Etbl
>>> index 3cf7b533b3d1=2E=2E3f27ffd8ae87 100644
>>> --- a/arch/x86/entry/syscalls/syscall_32=2Etbl
>>> +++ b/arch/x86/entry/syscalls/syscall_32=2Etbl
>>> @@ -398,3 +398,4 @@
>>> 384    i386    arch_prctl        sys_arch_prctl          =20
>__ia32_compat_sys_arch_prctl
>>> 385    i386    io_pgetevents        sys_io_pgetevents      =20
>__ia32_compat_sys_io_pgetevents
>>> 386    i386    rseq            sys_rseq            __ia32_sys_rseq
>>> +387    i386    procfd_signal        sys_procfd_signal      =20
>__ia32_compat_sys_procfd_signal
>>> diff --git a/arch/x86/entry/syscalls/syscall_64=2Etbl
>b/arch/x86/entry/syscalls/syscall_64=2Etbl
>>> index f0b1709a5ffb=2E=2E8a30cde82450 100644
>>> --- a/arch/x86/entry/syscalls/syscall_64=2Etbl
>>> +++ b/arch/x86/entry/syscalls/syscall_64=2Etbl
>>> @@ -343,6 +343,7 @@
>>> 332    common    statx            __x64_sys_statx
>>> 333    common    io_pgetevents        __x64_sys_io_pgetevents
>>> 334    common    rseq            __x64_sys_rseq
>>> +335    64    procfd_signal        __x64_sys_procfd_signal
>>>=20
>>> #
>>> # x32-specific system call numbers start at 512 to avoid cache
>impact
>>> @@ -386,3 +387,4 @@
>>> 545    x32    execveat        __x32_compat_sys_execveat/ptregs
>>> 546    x32    preadv2            __x32_compat_sys_preadv64v2
>>> 547    x32    pwritev2        __x32_compat_sys_pwritev64v2
>>> +548    x32    procfd_signal        __x32_compat_sys_procfd_signal
>>=20
>> Is there a reason why these numbers have to be different?
>>=20
>> (See the recent discussion with Andy Lutomirski=2E)
>
>Hah, I missed this part of the patch=2E  Let=E2=80=99s not add new x32 sy=
scall
>numbers=2E
>
>Also, can we perhaps rework this a bit to get rid of the compat entry
>point?  The easier way would be to check in_compat_syscall()=2E The nicer
>way IMO would be to use the 64-bit structure for 32-bit as well=2E

Do you have a syscall which set precedence/did this before I could look at=
?
Just if you happen to remember one=2E
Fwiw, I followed the other signal syscalls=2E
They all introduce compat syscalls=2E
