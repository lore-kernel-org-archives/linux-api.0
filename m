From: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Subject: Re: [PATCH net-next] modules: allow modprobe load regular elf
 binaries
Date: Thu, 8 Mar 2018 17:20:48 -0800
Message-ID: <20180309012046.6kcivmzzkap3a4xc@ast-mbp>
References: <20180306013457.1955486-1-ast@kernel.org>
 <CAGXu5j+Q=S5sw9N5avyByxi2ekM6povT5Tajjhdb6D9g9ggKxQ@mail.gmail.com>
 <CALCETrX=Vfk1T-XegwnjtUqeEsyUFXH1744d0yGkufQvDA5xkQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CALCETrX=Vfk1T-XegwnjtUqeEsyUFXH1744d0yGkufQvDA5xkQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Andy Lutomirski <luto@amacapital.net>
Cc: Kees Cook <keescook@chromium.org>, Alexei Starovoitov <ast@kernel.org>, Djalal Harouni <tixxdz@gmail.com>, Al Viro <viro@zeniv.linux.org.uk>, "David S. Miller" <davem@davemloft.net>, Daniel Borkmann <daniel@iogearbox.net>, Linus Torvalds <torvalds@linux-foundation.org>, Greg KH <gregkh@linuxfoundation.org>, "Luis R. Rodriguez" <mcgrof@kernel.org>, Network Development <netdev@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, kernel-team@fb.com, Linux API <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Fri, Mar 09, 2018 at 12:59:36AM +0000, Andy Lutomirski wrote:
> 
> Alexei, can you give an example use case?  I'm sure it's upthread
> somewhere, but I'm having trouble finding it.

at the time of iptable's setsockopt() the kernel will do
err = request_module("bpfilter");
once.
The rough POC code:
https://git.kernel.org/pub/scm/linux/kernel/git/ast/bpf.git/tree/net/ipv4/bpfilter/sockopt.c?h=ipt_bpf#n25

> Also, I just tested this concept a bit.  Depmod invoked explicitly on
> an ET_EXEC with a.ko extension gets mad, but depmod -a on a kernel
> that has a "module" like that seems to work fine.  Go figure.

right. that's with the current patch.
In v2 I require .modinfo section to make sure license is specified,
but depmod still not very happy:
$ depmod /lib/modules/`uname -r`/kernel/net/bpfilter/bpfilter.ko
depmod: ERROR: Bad version passed /lib/modules/4.16.0-rc4-00799-g1716f0aa3039-dirty/kernel/net/bpfilter/bpfilter.ko
I'm not sure it's worth to silence it, since
as you noticed 'depmod -a' works.
