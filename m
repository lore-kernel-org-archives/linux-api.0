From: David Drysdale <drysdale-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCHv9 4/5] sparc: Hook up execveat system call.
Date: Thu, 20 Nov 2014 11:28:22 +0000
Message-ID: <CAHse=S--yNmP5sTr2kg_7kb2V8Lh2FioTSH_o23MstVrdt4Wmw@mail.gmail.com>
References: <1416418072-18639-1-git-send-email-drysdale@google.com>
 <1416418072-18639-5-git-send-email-drysdale@google.com> <20141120104223.2cea8043@canb.auug.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20141120104223.2cea8043-3FnU+UHB4dNDw9hX6IcOSA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Stephen Rothwell <sfr-3FnU+UHB4dNDw9hX6IcOSA@public.gmane.org>, David Miller <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>
Cc: "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Meredydd Luff <meredydd-zPN50pYk8eUaUu29zAJCuw@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Rich Felker <dalias-/miJ2pyFWUyWIDz0JBNUog@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, X86 ML <x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-arch <linux-arch-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, sparclinux-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Wed, Nov 19, 2014 at 11:42 PM, Stephen Rothwell <sfr-3FnU+UHB4dNDw9hX6IcOSA@public.gmane.org> wrote:
> Hi David,
>
> On Wed, 19 Nov 2014 17:27:51 +0000 David Drysdale <drysdale-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> wrote:
>>
>> diff --git a/arch/sparc/kernel/systbls_64.S b/arch/sparc/kernel/systbls_64.S
>> index 580cde9370c9..15069cb35dac 100644
>> --- a/arch/sparc/kernel/systbls_64.S
>> +++ b/arch/sparc/kernel/systbls_64.S
>> @@ -88,6 +88,7 @@ sys_call_table32:
>>       .word sys_syncfs, compat_sys_sendmmsg, sys_setns, compat_sys_process_vm_readv, compat_sys_process_vm_writev
>>  /*340*/      .word sys_kern_features, sys_kcmp, sys_finit_module, sys_sched_setattr, sys_sched_getattr
>>       .word sys32_renameat2, sys_seccomp, sys_getrandom, sys_memfd_create, sys_bpf
>> +/*350*/      .word sys_execveat
>
> Shouldn't this be compat_sys_execveat?

Yeah, that would make sense -- thanks for spotting.

Looking at this more closely, I also wonder if we need a pair of wrappers
analogous to sys(32|64)_execve -- they include a (pipeline-executed)
flushw instruction after the jmpl to [compat_]sys_execve, which I guess
might be needed.  So I could add something like the following to
arch/sparc/kernel/syscalls.S:

  sys64_execveat:
      set sys_execveat, %g1
      jmpl %g1, %g0
      flushw
  #ifdef CONFIG_COMPAT
  sys32_execveat:
      set compat_sys_execveat, %g1
      jmpl %g1, %g0
      flushw
  #endif

However, I don't speak SPARC and can't run the code -- any thoughts
out there from someone who does & can?

Or maybe I should stop trying to be helpful with speculative patches, and
just leave wiring up the sparc stuff to the experts...

>>
>>  #endif /* CONFIG_COMPAT */
>
> --
> Cheers,
> Stephen Rothwell                    sfr-3FnU+UHB4dNDw9hX6IcOSA@public.gmane.org
