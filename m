From: Andy Lutomirski <luto@kernel.org>
Subject: Re: [PATCH net-next] modules: allow modprobe load regular elf binaries
Date: Fri, 9 Mar 2018 02:12:24 +0000
Message-ID: <CALCETrV8nPo=_rsSzy3Dt+y09mNgRi2+aYRk0Pj45j6BLRXgAA@mail.gmail.com>
References: <20180306013457.1955486-1-ast@kernel.org> <CAGXu5j+Q=S5sw9N5avyByxi2ekM6povT5Tajjhdb6D9g9ggKxQ@mail.gmail.com>
 <CALCETrX=Vfk1T-XegwnjtUqeEsyUFXH1744d0yGkufQvDA5xkQ@mail.gmail.com> <20180309012046.6kcivmzzkap3a4xc@ast-mbp>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180309012046.6kcivmzzkap3a4xc@ast-mbp>
Sender: linux-kernel-owner@vger.kernel.org
To: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc: Kees Cook <keescook@chromium.org>, Alexei Starovoitov <ast@kernel.org>, Djalal Harouni <tixxdz@gmail.com>, Al Viro <viro@zeniv.linux.org.uk>, "David S. Miller" <davem@davemloft.net>, Daniel Borkmann <daniel@iogearbox.net>, Linus Torvalds <torvalds@linux-foundation.org>, Greg KH <gregkh@linuxfoundation.org>, "Luis R. Rodriguez" <mcgrof@kernel.org>, Network Development <netdev@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, kernel-team@fb.com, Linux API <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Fri, Mar 9, 2018 at 1:20 AM, Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
> On Fri, Mar 09, 2018 at 12:59:36AM +0000, Andy Lutomirski wrote:
>>
>> Alexei, can you give an example use case?  I'm sure it's upthread
>> somewhere, but I'm having trouble finding it.
>
> at the time of iptable's setsockopt() the kernel will do
> err = request_module("bpfilter");
> once.
> The rough POC code:
> https://git.kernel.org/pub/scm/linux/kernel/git/ast/bpf.git/tree/net/ipv4/bpfilter/sockopt.c?h=ipt_bpf#n25

Here's what I gather from reading that code: you have a new kernel
feature (consisting of actual kernel code) that wants to defer some of
its implementation to user mode.  I like this idea a lot.  But I have
a suggestion for a slightly different way of accomplishing the same
thing.  Rather than extending init_module() to accept ELF input,
except the call_umh code to be able to call blobs.  You'd use it it
very roughly like this:

First, compile your user code and emit a staitc binary.  Use objdump
fiddling or a trivial .S file to make that static binary into a
variable.  Then write a tiny shim module like this:

extern unsigned char __begin_user_code[], __end_user_code[];

int __init init_shim_module(void)
{
  return call_umh_blob(__begin_user_code, __end_user_code - __begin_user_code);
}

By itself, this is clearly a worse solution than yours, but it has two
benefits, one small and two big.  The small benefit is that it is
completely invisible to userspace: the .ko file is a bona fide module.
The big benefits are:

1. It works even in a non-modular kernel!  (Okay, it probably only
works if you can arrange for the built-in module to be initialized
late enough, but that's straightforward.)

2. It allows future extensions to change the way the glue works.  For
example, maybe you want the module to integrate properly with lsmod,
etc.  Rather than adding a mechanism for general privileged programs
to register themselves with lsmod (ick!), you could do it entirely in
the kernel where lsmod would know that a particular umh task is
special.  More usefully, you could extend call_umh_blob() to pass in
some pre-initialized struct files, which would give a clean way to
*synchronously* create a communication channel to user code for
whatever service the user code provides.  And it would be more
straightforward to make the umh blob do what it needs to do without
relying on any particular filesystems being mounted.

I think we don't want to end up in a situation where we ship a program
with a .ko extension that opens something in /dev, for example.

call_umh_blob() would create an anon_inode or similar object backed by
the blob and exec it.
