From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH net-next] modules: allow modprobe load regular elf binaries
Date: Thu, 8 Mar 2018 19:06:29 -0800
Message-ID: <CA+55aFwRGDPvaCUgMtqnQHb2PZ77JSMQMQVf1znSN+PiV7NR-Q@mail.gmail.com>
References: <20180306013457.1955486-1-ast@kernel.org> <CAGXu5j+Q=S5sw9N5avyByxi2ekM6povT5Tajjhdb6D9g9ggKxQ@mail.gmail.com>
 <CALCETrX=Vfk1T-XegwnjtUqeEsyUFXH1744d0yGkufQvDA5xkQ@mail.gmail.com>
 <CA+55aFwJPDub+tdShCgeTz3UejeskVE7_x+eQLq75mCjYPyP8w@mail.gmail.com> <CAGXu5j+B4wgT3ovynAxa1zwCeROfN5zK45tL1FUnFh0sg8M5AA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAGXu5j+B4wgT3ovynAxa1zwCeROfN5zK45tL1FUnFh0sg8M5AA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Kees Cook <keescook@chromium.org>
Cc: Andy Lutomirski <luto@amacapital.net>, Alexei Starovoitov <ast@kernel.org>, Djalal Harouni <tixxdz@gmail.com>, Al Viro <viro@zeniv.linux.org.uk>, "David S. Miller" <davem@davemloft.net>, Daniel Borkmann <daniel@iogearbox.net>, Greg KH <gregkh@linuxfoundation.org>, "Luis R. Rodriguez" <mcgrof@kernel.org>, Network Development <netdev@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, kernel-team <kernel-team@fb.com>, Linux API <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Thu, Mar 8, 2018 at 5:44 PM, Kees Cook <keescook@chromium.org> wrote:
>
> My concerns are mostly about crossing namespaces. If a container
> triggers an autoload, the result runs in the init_ns.

Heh. I saw that as an advantage. It's basically the same semantics as
a normal module load does - in that the "kernel namespace" is init_ns.

My own personal worry is actually different - we do check the
signature of the file we're loading, but we're then passing it off to
execve() not as the image we loaded, but as the file pointer.

So the execve() will end up not using the actual buffer we checked the
signature on, but instead just re-reading the file.

Now, that has two issues:

 (a) it means that 'init_module' doesn't work, only 'finit_module'.

    Not a big deal, but I do think that we should fail the 'info->file
== NULL' case explicitly (instead of failing when it does an execve()
of /dev/null, which is what I think it does now - but that's just from
the reading the patch, not from testing it).

 (b) somebody could maybe try to time it and modify the file
after-the-fact of the signature check, and then we execute something
else.

Honestly, that "read twice" thing may be what scuttles this.
Initially, I thought it was a non-issue, because anybody who controls
the module subdirectory enough to rewrite files would be in a position
to just execute the file itself directly instead.

But it turns out that isn't needed. Some bad actor could just do
"finit_module()" with a file that they just *copied* from the module
directory.

Yes, yes, they still need CAP_SYS_MODULE to even get that far, but it
does worry me.

So this does seem to turn "CAP_SYS_MODULE" into meaning "can run any
executable as root in the init namespace". They don't have to have the
module signing key that I thought would protect us, because they can
do that "rewrite after signature check".

So that does seem like a bad problem with the approach.

So I don't like Andy's "let's make it a kernel module and then that
kernel module can execve() a blob". THAT seems like just stupid
indirection.

But I do like Andy's "execve a blob" part, because it is the *blob*
that has had its signature verified, not the file!

             Linus
