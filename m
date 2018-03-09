From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH net-next] modules: allow modprobe load regular elf binaries
Date: Thu, 8 Mar 2018 19:17:39 -0800
Message-ID: <CA+55aFy9OoeWpHnLGCiLWxPz8tyzPaK4HS-4OfH6KEhNmsQzDQ@mail.gmail.com>
References: <20180306013457.1955486-1-ast@kernel.org> <CAGXu5j+Q=S5sw9N5avyByxi2ekM6povT5Tajjhdb6D9g9ggKxQ@mail.gmail.com>
 <CALCETrX=Vfk1T-XegwnjtUqeEsyUFXH1744d0yGkufQvDA5xkQ@mail.gmail.com>
 <CA+55aFwJPDub+tdShCgeTz3UejeskVE7_x+eQLq75mCjYPyP8w@mail.gmail.com>
 <CAGXu5j+B4wgT3ovynAxa1zwCeROfN5zK45tL1FUnFh0sg8M5AA@mail.gmail.com> <CA+55aFwRGDPvaCUgMtqnQHb2PZ77JSMQMQVf1znSN+PiV7NR-Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CA+55aFwRGDPvaCUgMtqnQHb2PZ77JSMQMQVf1znSN+PiV7NR-Q@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Kees Cook <keescook@chromium.org>
Cc: Andy Lutomirski <luto@amacapital.net>, Alexei Starovoitov <ast@kernel.org>, Djalal Harouni <tixxdz@gmail.com>, Al Viro <viro@zeniv.linux.org.uk>, "David S. Miller" <davem@davemloft.net>, Daniel Borkmann <daniel@iogearbox.net>, Greg KH <gregkh@linuxfoundation.org>, "Luis R. Rodriguez" <mcgrof@kernel.org>, Network Development <netdev@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, kernel-team <kernel-team@fb.com>, Linux API <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Thu, Mar 8, 2018 at 7:06 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> So I don't like Andy's "let's make it a kernel module and then that
> kernel module can execve() a blob". THAT seems like just stupid
> indirection.
>
> But I do like Andy's "execve a blob" part, because it is the *blob*
> that has had its signature verified, not the file!

To be honest., Andy's approach has the advantage that all the
synchronization we do for modules still works.

In particular, we have module loading logic where we synchronize
loading of modules with the same name, so that two things that do
request_module() concurrently will not lead to two modules being
loaded.

See that whole "module_mutex" thing, and the logic in (for example)
"add_unformed_module()".

Andrei's patch short-circuits the module loading before that, so if
you have two concurrent request_module() calls, you'll end up with no
serialization, and two executables.

So maybe Andy is right. He often is, after all.

             Linus
