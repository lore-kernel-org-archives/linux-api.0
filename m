From: Christian Brauner <christian@brauner.io>
Subject: Re: [PATCH v2] signal: add procfd_signal() syscall
Date: Sat, 01 Dec 2018 12:52:24 +1300
Message-ID: <746B7C49-CC7B-4040-A7EF-82491796D360@brauner.io>
References: <20181120105124.14733-1-christian@brauner.io> <87in0g5aqo.fsf@oldenburg.str.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <87in0g5aqo.fsf@oldenburg.str.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Florian Weimer <fweimer@redhat.com>
Cc: ebiederm@xmission.com, linux-kernel@vger.kernel.org, serge@hallyn.com, jannh@google.com, luto@kernel.org, akpm@linux-foundation.org, oleg@redhat.com, cyphar@cyphar.com, viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org, dancol@google.com, timmurray@google.com, linux-man@vger.kernel.org, Kees Cook <keescook@chromium.org>
List-Id: linux-api@vger.kernel.org

On November 30, 2018 1:28:15 AM GMT+13:00, Florian Weimer <fweimer@redhat=
=2Ecom> wrote:
>Disclaimer: I'm looking at this patch because Christian requested it=2E
>I'm not a kernel developer=2E

Given all your expertise this really doesn't matter=2E :)
You're the one having to deal with this
in glibc after all=2E
Thanks for doing this and sorry for the late reply=2E
I missed that mail=2E

>
>* Christian Brauner:
>
>> diff --git a/arch/x86/entry/syscalls/syscall_32=2Etbl
>b/arch/x86/entry/syscalls/syscall_32=2Etbl
>> index 3cf7b533b3d1=2E=2E3f27ffd8ae87 100644
>> --- a/arch/x86/entry/syscalls/syscall_32=2Etbl
>> +++ b/arch/x86/entry/syscalls/syscall_32=2Etbl
>> @@ -398,3 +398,4 @@
>>  384	i386	arch_prctl		sys_arch_prctl			__ia32_compat_sys_arch_prctl
>>=20
>385	i386	io_pgetevents		sys_io_pgetevents		__ia32_compat_sys_io_pgetevent=
s
>>  386	i386	rseq			sys_rseq			__ia32_sys_rseq
>>
>+387	i386	procfd_signal		sys_procfd_signal		__ia32_compat_sys_procfd_sign=
al
>> diff --git a/arch/x86/entry/syscalls/syscall_64=2Etbl
>b/arch/x86/entry/syscalls/syscall_64=2Etbl
>> index f0b1709a5ffb=2E=2E8a30cde82450 100644
>> --- a/arch/x86/entry/syscalls/syscall_64=2Etbl
>> +++ b/arch/x86/entry/syscalls/syscall_64=2Etbl
>> @@ -343,6 +343,7 @@
>>  332	common	statx			__x64_sys_statx
>>  333	common	io_pgetevents		__x64_sys_io_pgetevents
>>  334	common	rseq			__x64_sys_rseq
>> +335	64	procfd_signal		__x64_sys_procfd_signal
>> =20
>>  #
>>  # x32-specific system call numbers start at 512 to avoid cache
>impact
>> @@ -386,3 +387,4 @@
>>  545	x32	execveat		__x32_compat_sys_execveat/ptregs
>>  546	x32	preadv2			__x32_compat_sys_preadv64v2
>>  547	x32	pwritev2		__x32_compat_sys_pwritev64v2
>> +548	x32	procfd_signal		__x32_compat_sys_procfd_signal
>
>Is there a reason why these numbers have to be different?
>
>(See the recent discussion with Andy Lutomirski=2E)
>
>> +static int do_procfd_signal(int fd, int sig, kernel_siginfo_t
>*kinfo, int flags,
>> +			    bool had_siginfo)
>> +{
>> +	int ret;
>> +	struct fd f;
>> +	struct pid *pid;
>> +
>> +	/* Enforce flags be set to 0 until we add an extension=2E */
>> +	if (flags)
>> +		return -EINVAL;
>> +
>> +	f =3D fdget_raw(fd);
>> +	if (!f=2Efile)
>> +		return -EBADF;
>> +
>> +	/* Is this a process file descriptor? */
>> +	ret =3D -EINVAL;
>> +	if (!proc_is_tgid_procfd(f=2Efile))
>> +		goto err;
>[=E2=80=A6]
>> +	ret =3D kill_pid_info(sig, kinfo, pid);
>
>I would like to see some comment here what happens to zombie processes=2E

You'd get ESRCH=2E
I'm not sure if that has always been the case=2E
Eric recently did some excellent refactoring of the signal code=2E
Iirc, part of that involved not delivering signals to zombies=2E
That's at least how I remember it=2E
I don't have access to source code though atm=2E

>
>> +/**
>> + *  sys_procfd_signal - send a signal to a process through a process
>file
>> + *                      descriptor
>> + *  @fd: the file descriptor of the process
>> + *  @sig: signal to be sent
>> + *  @info: the signal info
>> + *  @flags: future flags to be passed
>> + */
>> +SYSCALL_DEFINE4(procfd_signal, int, fd, int, sig, siginfo_t __user
>*, info,
>> +		int, flags)
>
>Sorry, I'm quite unhappy with the name=2E  =E2=80=9Csignal=E2=80=9D is fo=
r signal handler
>management=2E  procfd_sendsignal, procfd_sigqueueinfo or something like
>that would be fine=2E  Even procfd_kill would be better IMHO=2E

Ok=2E I only have strong opinions to procfd_kill()=2E
Mainly because the new syscall takes
the job of multiple other syscalls
so kill gives the wrong impression=2E
I'll come up with a better name in the next iteration=2E

>
>Looking at the rt_tgsigqueueinfo interface, is there a way to implement
>the =E2=80=9Ctg=E2=80=9D part with the current procfd_signal interface?  =
Would you use
>openat to retrieve the Tgid: line from "status"?

Yes, the tg part can be implemented=2E
As I pointed out in another mail my
I is to make this work by using file
descriptors for /proc/<pid>/task/<tid>=2E
I don't want this in the initial patchset though=2E
I prefer to slowly add those features
once we have gotten the basic functionality
in=2E


>
>Thanks,
>Florian
