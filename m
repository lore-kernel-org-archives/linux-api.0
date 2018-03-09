From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH net-next] modules: allow modprobe load regular elf binaries
Date: Fri, 9 Mar 2018 10:53:45 -0800
Message-ID: <CA+55aFx7w1s7=5HzeczPkkksaU4oVsWQf+_c=aHS0O7i_9g+Kg@mail.gmail.com>
References: <20180306013457.1955486-1-ast@kernel.org> <CAGXu5j+Q=S5sw9N5avyByxi2ekM6povT5Tajjhdb6D9g9ggKxQ@mail.gmail.com>
 <CALCETrX=Vfk1T-XegwnjtUqeEsyUFXH1744d0yGkufQvDA5xkQ@mail.gmail.com>
 <CA+55aFwJPDub+tdShCgeTz3UejeskVE7_x+eQLq75mCjYPyP8w@mail.gmail.com>
 <CAGXu5j+B4wgT3ovynAxa1zwCeROfN5zK45tL1FUnFh0sg8M5AA@mail.gmail.com>
 <CA+55aFwRGDPvaCUgMtqnQHb2PZ77JSMQMQVf1znSN+PiV7NR-Q@mail.gmail.com>
 <C94A45E9-54A0-446D-86D6-82D06E2A35CD@amacapital.net> <87478c51-59a7-f6ac-1fb2-f3ca2dcf658b@fb.com>
 <CA+55aFwfcXzD+pzjN=vTcvscpK97pSztUZ2JK7pABs+rMtM7BQ@mail.gmail.com> <E459E6CC-F51B-4F2A-9D26-FFB7166E0A47@amacapital.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <E459E6CC-F51B-4F2A-9D26-FFB7166E0A47@amacapital.net>
Sender: linux-kernel-owner@vger.kernel.org
To: Andy Lutomirski <luto@amacapital.net>
Cc: Alexei Starovoitov <ast@fb.com>, Kees Cook <keescook@chromium.org>, Alexei Starovoitov <ast@kernel.org>, Djalal Harouni <tixxdz@gmail.com>, Al Viro <viro@zeniv.linux.org.uk>, "David S. Miller" <davem@davemloft.net>, Daniel Borkmann <daniel@iogearbox.net>, Greg KH <gregkh@linuxfoundation.org>, "Luis R. Rodriguez" <mcgrof@kernel.org>, Network Development <netdev@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, kernel-team <kernel-team@fb.com>, Linux API <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Fri, Mar 9, 2018 at 10:48 AM, Andy Lutomirski <luto@amacapital.net> wrot=
e:
>> On Mar 9, 2018, at 10:17 AM, Linus Torvalds <torvalds@linux-foundation.o=
rg> wrote:
>>
>> Hmm. I wish we had an "execute blob" model, but we really don't, and
>> it would be hard/impossible to do without pinning the pages in memory.
>>
>
> Why so hard?  We can already execute a struct file for execveat, and Alex=
ei already has this working for umh.
> Surely we can make an immutable (as in even root can=E2=80=99t write it) =
kernel-internal tmpfs file, execveat it, then unlink it.

And what do you think that does? It pins the memory for the whole
time. As a *copy* of the original file.

Anyway, see my other suggestion that makes this all irrelevant. Just
wait synchronously (until the exit), and just use deny_write_access().

The "synchronous wait" means that you don't have the semantic change
(and really., it's *required* anyway for the whole mutual exclusion
against another thread racing to load the same module), and the
deny_write_access() means that we don't neeed to make another copy.

                Linus
