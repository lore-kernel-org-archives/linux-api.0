From: Kees Cook <keescook@chromium.org>
Subject: Re: [PATCH net-next] modules: allow modprobe load regular elf binaries
Date: Thu, 8 Mar 2018 17:44:11 -0800
Message-ID: <CAGXu5j+B4wgT3ovynAxa1zwCeROfN5zK45tL1FUnFh0sg8M5AA@mail.gmail.com>
References: <20180306013457.1955486-1-ast@kernel.org> <CAGXu5j+Q=S5sw9N5avyByxi2ekM6povT5Tajjhdb6D9g9ggKxQ@mail.gmail.com>
 <CALCETrX=Vfk1T-XegwnjtUqeEsyUFXH1744d0yGkufQvDA5xkQ@mail.gmail.com> <CA+55aFwJPDub+tdShCgeTz3UejeskVE7_x+eQLq75mCjYPyP8w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CA+55aFwJPDub+tdShCgeTz3UejeskVE7_x+eQLq75mCjYPyP8w@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andy Lutomirski <luto@amacapital.net>, Alexei Starovoitov <ast@kernel.org>, Djalal Harouni <tixxdz@gmail.com>, Al Viro <viro@zeniv.linux.org.uk>, "David S. Miller" <davem@davemloft.net>, Daniel Borkmann <daniel@iogearbox.net>, Greg KH <gregkh@linuxfoundation.org>, "Luis R. Rodriguez" <mcgrof@kernel.org>, Network Development <netdev@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, kernel-team <kernel-team@fb.com>, Linux API <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Thu, Mar 8, 2018 at 5:38 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Thu, Mar 8, 2018 at 4:59 PM, Andy Lutomirski <luto@amacapital.net> wrote:
>>
>> Also, I don't see how this is any more exploitable than any other
>> init_module().
>
> Absolutely. If Kees doesn't trust the files to be loaded, an
> executable - even if it's running with root privileges and in the
> initns - is still fundamentally weaker than a kernel module.
>
> So I don't understand the security argument AT ALL. It's nonsensical.
> The executable loading does all the same security checks that the
> module loading does, including the signing check.
>
> And the whole point is that we can now do things with building and
> loading a ebpf rule instead of having a full module.

My concerns are mostly about crossing namespaces. If a container
triggers an autoload, the result runs in the init_ns. So, really,
there's nothing new from my perspective, except that it's in userspace
instead of in the kernel.

Perhaps it's an orthogonal concern.

-Kees

-- 
Kees Cook
Pixel Security
