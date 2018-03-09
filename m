From: David Miller <davem@davemloft.net>
Subject: Re: [PATCH net-next] modules: allow modprobe load regular elf
 binaries
Date: Thu, 08 Mar 2018 21:31:53 -0500 (EST)
Message-ID: <20180308.213153.2003279953084099668.davem@davemloft.net>
References: <CALCETrX=Vfk1T-XegwnjtUqeEsyUFXH1744d0yGkufQvDA5xkQ@mail.gmail.com>
        <20180309012046.6kcivmzzkap3a4xc@ast-mbp>
        <CALCETrV8nPo=_rsSzy3Dt+y09mNgRi2+aYRk0Pj45j6BLRXgAA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CALCETrV8nPo=_rsSzy3Dt+y09mNgRi2+aYRk0Pj45j6BLRXgAA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: luto@kernel.org
Cc: alexei.starovoitov@gmail.com, keescook@chromium.org, ast@kernel.org, tixxdz@gmail.com, viro@zeniv.linux.org.uk, daniel@iogearbox.net, torvalds@linux-foundation.org, gregkh@linuxfoundation.org, mcgrof@kernel.org, netdev@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

From: Andy Lutomirski <luto@kernel.org>
Date: Fri, 9 Mar 2018 02:12:24 +0000

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

Anything you try to do which makes these binaries "special" is a huge
negative.

> The big benefits are:

I don't see those things as benefits at all, and Alexei's scheme can
easily be made to work in your benefit #1 case too.

It's a user binary.  It's shipped with the kernel and it's signed.

If we can't trust that, we can't trust much else.

And this whole container argument..  It's a mirage.

Kernel modules are 1000 times worse, since they can access any
container and any namespace they want.
