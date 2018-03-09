From: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Subject: Re: [PATCH net-next] modules: allow modprobe load regular elf
 binaries
Date: Thu, 8 Mar 2018 19:27:32 -0800
Message-ID: <20180309032730.qaqsv3hc6t4wghxc@ast-mbp>
References: <20180306013457.1955486-1-ast@kernel.org>
 <CAGXu5j+Q=S5sw9N5avyByxi2ekM6povT5Tajjhdb6D9g9ggKxQ@mail.gmail.com>
 <CALCETrX=Vfk1T-XegwnjtUqeEsyUFXH1744d0yGkufQvDA5xkQ@mail.gmail.com>
 <20180309012046.6kcivmzzkap3a4xc@ast-mbp>
 <CALCETrV8nPo=_rsSzy3Dt+y09mNgRi2+aYRk0Pj45j6BLRXgAA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CALCETrV8nPo=_rsSzy3Dt+y09mNgRi2+aYRk0Pj45j6BLRXgAA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Andy Lutomirski <luto@kernel.org>
Cc: Kees Cook <keescook@chromium.org>, Alexei Starovoitov <ast@kernel.org>, Djalal Harouni <tixxdz@gmail.com>, Al Viro <viro@zeniv.linux.org.uk>, "David S. Miller" <davem@davemloft.net>, Daniel Borkmann <daniel@iogearbox.net>, Linus Torvalds <torvalds@linux-foundation.org>, Greg KH <gregkh@linuxfoundation.org>, "Luis R. Rodriguez" <mcgrof@kernel.org>, Network Development <netdev@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, kernel-team@fb.com, Linux API <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Fri, Mar 09, 2018 at 02:12:24AM +0000, Andy Lutomirski wrote:
> On Fri, Mar 9, 2018 at 1:20 AM, Alexei Starovoitov
> <alexei.starovoitov@gmail.com> wrote:
> > On Fri, Mar 09, 2018 at 12:59:36AM +0000, Andy Lutomirski wrote:
> >>
> >> Alexei, can you give an example use case?  I'm sure it's upthread
> >> somewhere, but I'm having trouble finding it.
> >
> > at the time of iptable's setsockopt() the kernel will do
> > err = request_module("bpfilter");
> > once.
> > The rough POC code:
> > https://git.kernel.org/pub/scm/linux/kernel/git/ast/bpf.git/tree/net/ipv4/bpfilter/sockopt.c?h=ipt_bpf#n25
> 
> Here's what I gather from reading that code: you have a new kernel
> feature (consisting of actual kernel code) that wants to defer some of
> its implementation to user mode.  I like this idea a lot.  But I have
> a suggestion for a slightly different way of accomplishing the same
> thing.  Rather than extending init_module() to accept ELF input,
> except the call_umh code to be able to call blobs.  You'd use it it
> very roughly like this:
> 
> First, compile your user code and emit a staitc binary.  Use objdump
> fiddling or a trivial .S file to make that static binary into a
> variable.  Then write a tiny shim module like this:
> 
> extern unsigned char __begin_user_code[], __end_user_code[];
> 
> int __init init_shim_module(void)
> {
>   return call_umh_blob(__begin_user_code, __end_user_code - __begin_user_code);
> }
> 
> By itself, this is clearly a worse solution than yours, but it has two
> benefits, one small and two big.  The small benefit is that it is
> completely invisible to userspace: the .ko file is a bona fide module.

Unfortunately it's not quite the case.
The normal .ko that does call_umh_blob is indeed seen in lsmod,
but the umh process is a separate task.
It could have been oomed or killed by admin and
this normal .ko wouldn't notice it, so health check of umh process
by the kernel is needed regardless.
Right now bpfilter has trivial fuse-like protocol. This part
is still to be designed cleanly.

No doubt that visibility and debuggability into this umh processes
is must have, but lsmod/rmmod interface doesn't quite fit.
As you said letting this priv tasks register themselves in lsmod
is certainly no-go.
I think if they will be in lsmod, kernel has to register them
and establish health check with umh at the same time.
I think worrying about restarting is not necessary.
This is still kernel code with the same high standards and
review process. If they crash it's really a kernel bug.
It only doesn't take the system down.

> I think we don't want to end up in a situation where we ship a program
> with a .ko extension that opens something in /dev, for example.

this part I don't get. What's wrong with open of /dev ?
I don't see a use case for it, but technically why not?

> call_umh_blob() would create an anon_inode or similar object backed by
> the blob and exec it.

Interesting. I haven't considered such approach.

For full context it all started from the idea of 'unprivileged kernel modules'
or 'hardened kernel modules'. Something that kernel can easily
interact with, but much safer than traditional kernel module.

I've tried a bunch of crappy ideas first:
1. have a piece of kernel .text vm_mmap-ed into user process that
doing iptables setsockopt and on return to user space force handle_signal
to execute that code. Sort of like forced ld_preload where parasite
code is provided by the kernel but runs in user space
2. have a special set of kernel page tables in read-only mode while
iptable->bpf conversion is happening
3. have load_module() fork a user task and load real kernel .ko into it

trying to hack #3 realized that I'm mainly copy-pasting a lot of
load_elf_binary() code without elf_interpreter bits,
so figured it's much easier and simpler to blend sys_finit_module
with load_elf_binary via tweaking do_execveat_common and keeping
that .ko as normal elf which is implemented in this patch.
Debugging of that fake .ko is so much better.
If it's done via call_umh_blob() the process that starts
will indeed be a user mode process, but you won't be able to
attach gdb to it. Whereas in this patch it's normal elf and
standard debugging techniques apply. A developer can
do gdb breakpoints, debug info, etc.
That is huge advantage of keeping it as normal elf.
