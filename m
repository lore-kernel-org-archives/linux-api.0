From: David Miller <davem@davemloft.net>
Subject: Re: [PATCHv9 4/5] sparc: Hook up execveat system call.
Date: Fri, 21 Nov 2014 15:08:36 -0500 (EST)
Message-ID: <20141121.150836.687566774013830023.davem@davemloft.net>
References: <1416418072-18639-5-git-send-email-drysdale@google.com>
	<20141120104223.2cea8043@canb.auug.org.au>
	<CAHse=S--yNmP5sTr2kg_7kb2V8Lh2FioTSH_o23MstVrdt4Wmw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAHse=S--yNmP5sTr2kg_7kb2V8Lh2FioTSH_o23MstVrdt4Wmw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: drysdale@google.com
Cc: sfr@canb.auug.org.au, ebiederm@xmission.com, luto@amacapital.net, viro@zeniv.linux.org.uk, meredydd@senatehouse.org, linux-kernel@vger.kernel.org, akpm@linux-foundation.org, tglx@linutronix.de, oleg@redhat.com, mtk.manpages@gmail.com, mingo@redhat.com, hpa@zytor.com, keescook@chromium.org, arnd@arndb.de, dalias@aerifal.cx, hch@infradead.org, x86@kernel.org, linux-arch@vger.kernel.org, linux-api@vger.kernel.org, sparclinux@vger.kernel.org
List-Id: linux-api@vger.kernel.org

From: David Drysdale <drysdale@google.com>
Date: Thu, 20 Nov 2014 11:28:22 +0000

> On Wed, Nov 19, 2014 at 11:42 PM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
>> Hi David,
>>
>> On Wed, 19 Nov 2014 17:27:51 +0000 David Drysdale <drysdale@google.com> wrote:
>>>
>>> diff --git a/arch/sparc/kernel/systbls_64.S b/arch/sparc/kernel/systbls_64.S
>>> index 580cde9370c9..15069cb35dac 100644
>>> --- a/arch/sparc/kernel/systbls_64.S
>>> +++ b/arch/sparc/kernel/systbls_64.S
>>> @@ -88,6 +88,7 @@ sys_call_table32:
>>>       .word sys_syncfs, compat_sys_sendmmsg, sys_setns, compat_sys_process_vm_readv, compat_sys_process_vm_writev
>>>  /*340*/      .word sys_kern_features, sys_kcmp, sys_finit_module, sys_sched_setattr, sys_sched_getattr
>>>       .word sys32_renameat2, sys_seccomp, sys_getrandom, sys_memfd_create, sys_bpf
>>> +/*350*/      .word sys_execveat
>>
>> Shouldn't this be compat_sys_execveat?
> 
> Yeah, that would make sense -- thanks for spotting.
> 
> Looking at this more closely, I also wonder if we need a pair of wrappers
> analogous to sys(32|64)_execve -- they include a (pipeline-executed)
> flushw instruction after the jmpl to [compat_]sys_execve, which I guess
> might be needed.  So I could add something like the following to
> arch/sparc/kernel/syscalls.S:
> 
>   sys64_execveat:
>       set sys_execveat, %g1
>       jmpl %g1, %g0
>       flushw
>   #ifdef CONFIG_COMPAT
>   sys32_execveat:
>       set compat_sys_execveat, %g1
>       jmpl %g1, %g0
>       flushw
>   #endif
> 
> However, I don't speak SPARC and can't run the code -- any thoughts
> out there from someone who does & can?
> 
> Or maybe I should stop trying to be helpful with speculative patches, and
> just leave wiring up the sparc stuff to the experts...

You need wrappers for execve() like system calls yes, in order to flush all
of the user register windows to the stack before the kill the address space.

I think your code snippet above is fine, except that you should indent
the flushw by one space more because it is in the delay slot of a
control transfer instruction.

Thanks.
