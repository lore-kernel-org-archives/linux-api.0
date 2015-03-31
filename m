From: David Drysdale <drysdale@google.com>
Subject: Re: [PATCH v2 3/7] Introduce a new clone4 syscall with more flag bits
 and extensible arguments
Date: Tue, 31 Mar 2015 15:41:35 +0100
Message-ID: <CAHse=S_nZFeC3BMp74SOO_aNvTSqkRbkq28LpT-GaNBpD_kP+A@mail.gmail.com>
References: <cover.1426376419.git.josh@joshtriplett.org> <367b888ef58831b6812c3cf80ca973c65edc67f5.1426376419.git.josh@joshtriplett.org>
 <CAHse=S_0G028D2f1vO=1EBO-TM1ZyJZT3-VE4O3a9dS-VcdKzg@mail.gmail.com> <20150323150500.GB31561@cloud>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20150323150500.GB31561@cloud>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Josh Triplett <josh@joshtriplett.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Andrew Morton <akpm@linux-foundation.org>, Andy Lutomirski <luto@kernel.org>, Ingo Molnar <mingo@redhat.com>, Kees Cook <keescook@chromium.org>, Oleg Nesterov <oleg@redhat.com>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, "H. Peter Anvin" <hpa@zytor.com>, Rik van Riel <riel@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, Michael Kerrisk <mtk.manpages@gmail.com>, Thiago Macieira <thiago.macieira@intel.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, Linux FS Devel <linux-fsdevel@vger.kernel.org>, X86 ML <x86@kernel.org>
List-Id: linux-api@vger.kernel.org

On Mon, Mar 23, 2015 at 3:05 PM,  <josh@joshtriplett.org> wrote:
> On Mon, Mar 23, 2015 at 02:11:45PM +0000, David Drysdale wrote:
>> On Sun, Mar 15, 2015 at 7:59 AM, Josh Triplett <josh@joshtriplett.org> wrote:
>> > diff --git a/arch/x86/ia32/ia32entry.S b/arch/x86/ia32/ia32entry.S
>> > index 0286735..ba28306 100644
>> > --- a/arch/x86/ia32/ia32entry.S
>> > +++ b/arch/x86/ia32/ia32entry.S
>> > @@ -483,6 +483,7 @@ GLOBAL(\label)
>> >         PTREGSCALL stub32_execveat, compat_sys_execveat
>> >         PTREGSCALL stub32_fork, sys_fork
>> >         PTREGSCALL stub32_vfork, sys_vfork
>> > +       PTREGSCALL stub32_clone4, compat_sys_clone4
>> >
>> >         ALIGN
>> >  GLOBAL(stub32_clone)
>> > diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
>> > index 1d74d16..ead143f 100644
>> > --- a/arch/x86/kernel/entry_64.S
>> > +++ b/arch/x86/kernel/entry_64.S
>> > @@ -520,6 +520,7 @@ END(\label)
>> >         FORK_LIKE  clone
>> >         FORK_LIKE  fork
>> >         FORK_LIKE  vfork
>> > +       FORK_LIKE  clone4
>> >         FIXED_FRAME stub_iopl, sys_iopl
>> >
>> >  ENTRY(stub_execve)
>> > diff --git a/arch/x86/syscalls/syscall_32.tbl b/arch/x86/syscalls/syscall_32.tbl
>> > index b3560ec..56fcc90 100644
>> > --- a/arch/x86/syscalls/syscall_32.tbl
>> > +++ b/arch/x86/syscalls/syscall_32.tbl
>> > @@ -365,3 +365,4 @@
>> >  356    i386    memfd_create            sys_memfd_create
>> >  357    i386    bpf                     sys_bpf
>> >  358    i386    execveat                sys_execveat                    stub32_execveat
>> > +359    i386    clone4                  sys_clone4                      stub32_clone4
>> > diff --git a/arch/x86/syscalls/syscall_64.tbl b/arch/x86/syscalls/syscall_64.tbl
>> > index 8d656fb..af15b0f 100644
>> > --- a/arch/x86/syscalls/syscall_64.tbl
>> > +++ b/arch/x86/syscalls/syscall_64.tbl
>> > @@ -329,6 +329,7 @@
>> >  320    common  kexec_file_load         sys_kexec_file_load
>> >  321    common  bpf                     sys_bpf
>> >  322    64      execveat                stub_execveat
>> > +323    64      clone4                  stub_clone4
>> >
>> >  #
>> >  # x32-specific system call numbers start at 512 to avoid cache impact
>> > @@ -368,3 +369,4 @@
>> >  543    x32     io_setup                compat_sys_io_setup
>> >  544    x32     io_submit               compat_sys_io_submit
>> >  545    x32     execveat                stub_x32_execveat
>> > +546    x32     clone4                  stub32_clone4
>>
>> Doesn't this need an x32 specific wrapper (to ensure the full
>> set of registers are saved)?
>
> I'm not an x32 expert; I don't know how x32 interacts with pt_regs and
> compat syscalls.  Could an x32 expert weigh in, please?
>
> - Josh Triplett

(In the absence of an x32 expert chiming in...)

As I understand it:
 - stub32_clone4 expects 32-bit calling conventions and calls compat_sys_clone4
 - stub_clone4 expects 64-bit calling conventions and calls sys_clone4
 - stub_x32_clone4 would expect 64-bit calling conventions but call
   compat_sys_clone4.

Also, I have a suspicion that different field types in the [compat_]clone4_args
structure may cause problems -- I *think* its (final) layout will be 4+4+4+4+4+4
on 32-bit, 8+8+8+8+8+4 on 64-bit, but 4+4+8+8+4+4 on x32.

Have you tried running a test with a userspace program compiled with -mx32?
