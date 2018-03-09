From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH net-next] modules: allow modprobe load regular elf binaries
Date: Fri, 9 Mar 2018 10:17:42 -0800
Message-ID: <CA+55aFwfcXzD+pzjN=vTcvscpK97pSztUZ2JK7pABs+rMtM7BQ@mail.gmail.com>
References: <20180306013457.1955486-1-ast@kernel.org> <CAGXu5j+Q=S5sw9N5avyByxi2ekM6povT5Tajjhdb6D9g9ggKxQ@mail.gmail.com>
 <CALCETrX=Vfk1T-XegwnjtUqeEsyUFXH1744d0yGkufQvDA5xkQ@mail.gmail.com>
 <CA+55aFwJPDub+tdShCgeTz3UejeskVE7_x+eQLq75mCjYPyP8w@mail.gmail.com>
 <CAGXu5j+B4wgT3ovynAxa1zwCeROfN5zK45tL1FUnFh0sg8M5AA@mail.gmail.com>
 <CA+55aFwRGDPvaCUgMtqnQHb2PZ77JSMQMQVf1znSN+PiV7NR-Q@mail.gmail.com>
 <C94A45E9-54A0-446D-86D6-82D06E2A35CD@amacapital.net> <87478c51-59a7-f6ac-1fb2-f3ca2dcf658b@fb.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <87478c51-59a7-f6ac-1fb2-f3ca2dcf658b@fb.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Alexei Starovoitov <ast@fb.com>
Cc: Andy Lutomirski <luto@amacapital.net>, Kees Cook <keescook@chromium.org>, Alexei Starovoitov <ast@kernel.org>, Djalal Harouni <tixxdz@gmail.com>, Al Viro <viro@zeniv.linux.org.uk>, "David S. Miller" <davem@davemloft.net>, Daniel Borkmann <daniel@iogearbox.net>, Greg KH <gregkh@linuxfoundation.org>, "Luis R. Rodriguez" <mcgrof@kernel.org>, Network Development <netdev@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, kernel-team <kernel-team@fb.com>, Linux API <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Thu, Mar 8, 2018 at 9:08 PM, Alexei Starovoitov <ast@fb.com> wrote:
>
> there is not abi breakage and file cannot disappear from running task.
> One cannot umount fs while file is still being used.

I think that "cannot umount" part _is_ the ABI breakage that Andy is
talking about.

> Not only "read twice", but "read many".
> If .text sections of elf that are not yet in memory can be modified
> by malicious user, later they will be brought in with different code.
> I think the easiest fix to tighten this "umh modules" to CAP_SYS_ADMIN.

I don't think it actually fixes anything.  It might just break things.
For all we know, people run modprobe with CAP_SYS_MODULE only, since
that is obviously the only capability it needs.

Hmm. I wish we had an "execute blob" model, but we really don't, and
it would be hard/impossible to do without pinning the pages in memory.

My gut feel is that the right direction to explore is:

 - consider the module loaded for the whole duration of the execve. So
the execution is a *blocking* operation (and we get the correct
exclusion semantics)

 - use deny_write_access() to make sure that we don't have active
writers and cannot get them during the execve.

The above mean that something that executes to load a new ebpf rule
will work very well.  But a "start and forget" will not work (although
you can obviously do so with a internal fork/exec).

Hmm?

                       Linus
