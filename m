From: Andy Lutomirski <luto@amacapital.net>
Subject: Re: [PATCH v2] signal: add procfd_signal() syscall
Date: Thu, 29 Nov 2018 08:54:18 -0800
Message-ID: <36323361-90BD-41AF-AB5B-EE0D7BA02C21@amacapital.net>
References: <20181120105124.14733-1-christian@brauner.io> <87in0g5aqo.fsf@oldenburg.str.redhat.com>
Mime-Version: 1.0 (1.0)
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <87in0g5aqo.fsf@oldenburg.str.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Florian Weimer <fweimer@redhat.com>
Cc: Christian Brauner <christian@brauner.io>, ebiederm@xmission.com, linux-kernel@vger.kernel.org, serge@hallyn.com, jannh@google.com, luto@kernel.org, akpm@linux-foundation.org, oleg@redhat.com, cyphar@cyphar.com, viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org, dancol@google.com, timmurray@google.com, linux-man@vger.kernel.org, Kees Cook <keescook@chromium.org>
List-Id: linux-api@vger.kernel.org



> On Nov 29, 2018, at 4:28 AM, Florian Weimer <fweimer@redhat.com> wrote:
>=20
> Disclaimer: I'm looking at this patch because Christian requested it.
> I'm not a kernel developer.
>=20
> * Christian Brauner:
>=20
>> diff --git a/arch/x86/entry/syscalls/syscall_32.tbl b/arch/x86/entry/sysc=
alls/syscall_32.tbl
>> index 3cf7b533b3d1..3f27ffd8ae87 100644
>> --- a/arch/x86/entry/syscalls/syscall_32.tbl
>> +++ b/arch/x86/entry/syscalls/syscall_32.tbl
>> @@ -398,3 +398,4 @@
>> 384    i386    arch_prctl        sys_arch_prctl            __ia32_compat_=
sys_arch_prctl
>> 385    i386    io_pgetevents        sys_io_pgetevents        __ia32_compa=
t_sys_io_pgetevents
>> 386    i386    rseq            sys_rseq            __ia32_sys_rseq
>> +387    i386    procfd_signal        sys_procfd_signal        __ia32_comp=
at_sys_procfd_signal
>> diff --git a/arch/x86/entry/syscalls/syscall_64.tbl b/arch/x86/entry/sysc=
alls/syscall_64.tbl
>> index f0b1709a5ffb..8a30cde82450 100644
>> --- a/arch/x86/entry/syscalls/syscall_64.tbl
>> +++ b/arch/x86/entry/syscalls/syscall_64.tbl
>> @@ -343,6 +343,7 @@
>> 332    common    statx            __x64_sys_statx
>> 333    common    io_pgetevents        __x64_sys_io_pgetevents
>> 334    common    rseq            __x64_sys_rseq
>> +335    64    procfd_signal        __x64_sys_procfd_signal
>>=20
>> #
>> # x32-specific system call numbers start at 512 to avoid cache impact
>> @@ -386,3 +387,4 @@
>> 545    x32    execveat        __x32_compat_sys_execveat/ptregs
>> 546    x32    preadv2            __x32_compat_sys_preadv64v2
>> 547    x32    pwritev2        __x32_compat_sys_pwritev64v2
>> +548    x32    procfd_signal        __x32_compat_sys_procfd_signal
>=20
> Is there a reason why these numbers have to be different?
>=20
> (See the recent discussion with Andy Lutomirski.)

Hah, I missed this part of the patch.  Let=E2=80=99s not add new x32 syscall=
 numbers.

Also, can we perhaps rework this a bit to get rid of the compat entry point?=
  The easier way would be to check in_compat_syscall(). The nicer way IMO wo=
uld be to use the 64-bit structure for 32-bit as well.
