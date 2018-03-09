From: Andy Lutomirski <luto@amacapital.net>
Subject: Re: [PATCH net-next] modules: allow modprobe load regular elf binaries
Date: Fri, 9 Mar 2018 10:48:51 -0800
Message-ID: <E459E6CC-F51B-4F2A-9D26-FFB7166E0A47@amacapital.net>
References: <20180306013457.1955486-1-ast@kernel.org> <CAGXu5j+Q=S5sw9N5avyByxi2ekM6povT5Tajjhdb6D9g9ggKxQ@mail.gmail.com> <CALCETrX=Vfk1T-XegwnjtUqeEsyUFXH1744d0yGkufQvDA5xkQ@mail.gmail.com> <CA+55aFwJPDub+tdShCgeTz3UejeskVE7_x+eQLq75mCjYPyP8w@mail.gmail.com> <CAGXu5j+B4wgT3ovynAxa1zwCeROfN5zK45tL1FUnFh0sg8M5AA@mail.gmail.com> <CA+55aFwRGDPvaCUgMtqnQHb2PZ77JSMQMQVf1znSN+PiV7NR-Q@mail.gmail.com> <C94A45E9-54A0-446D-86D6-82D06E2A35CD@amacapital.net> <87478c51-59a7-f6ac-1fb2-f3ca2dcf658b@fb.com> <CA+55aFwfcXzD+pzjN=vTcvscpK97pSztUZ2JK7pABs+rMtM7BQ@mail.gmail.com>
Mime-Version: 1.0 (1.0)
Content-Type: text/plain;
        charset=utf-8
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CA+55aFwfcXzD+pzjN=vTcvscpK97pSztUZ2JK7pABs+rMtM7BQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Alexei Starovoitov <ast@fb.com>, Kees Cook <keescook@chromium.org>, Alexei Starovoitov <ast@kernel.org>, Djalal Harouni <tixxdz@gmail.com>, Al Viro <viro@zeniv.linux.org.uk>, "David S. Miller" <davem@davemloft.net>, Daniel Borkmann <daniel@iogearbox.net>, Greg KH <gregkh@linuxfoundation.org>, "Luis R. Rodriguez" <mcgrof@kernel.org>, Network Development <netdev@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, kernel-team <kernel-team@fb.com>, Linux API <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org



> On Mar 9, 2018, at 10:17 AM, Linus Torvalds <torvalds@linux-foundation.org=
> wrote:
>=20

>=20
> Hmm. I wish we had an "execute blob" model, but we really don't, and
> it would be hard/impossible to do without pinning the pages in memory.
>=20

Why so hard?  We can already execute a struct file for execveat, and Alexei a=
lready has this working for umh. Surely we can make an immutable (as in even=
 root can=E2=80=99t write it) kernel-internal tmpfs file, execveat it, then u=
nlink it. And /proc/PID/exe should be openable and readable.  The blob itsel=
f would be __initdata so it gets discarded after it lands in tmpfs.=20=
