From: Andy Lutomirski <luto@amacapital.net>
Subject: Re: [PATCH net-next] modules: allow modprobe load regular elf binaries
Date: Thu, 8 Mar 2018 19:54:20 -0800
Message-ID: <C94A45E9-54A0-446D-86D6-82D06E2A35CD@amacapital.net>
References: <20180306013457.1955486-1-ast@kernel.org> <CAGXu5j+Q=S5sw9N5avyByxi2ekM6povT5Tajjhdb6D9g9ggKxQ@mail.gmail.com> <CALCETrX=Vfk1T-XegwnjtUqeEsyUFXH1744d0yGkufQvDA5xkQ@mail.gmail.com> <CA+55aFwJPDub+tdShCgeTz3UejeskVE7_x+eQLq75mCjYPyP8w@mail.gmail.com> <CAGXu5j+B4wgT3ovynAxa1zwCeROfN5zK45tL1FUnFh0sg8M5AA@mail.gmail.com> <CA+55aFwRGDPvaCUgMtqnQHb2PZ77JSMQMQVf1znSN+PiV7NR-Q@mail.gmail.com>
Mime-Version: 1.0 (1.0)
Content-Type: text/plain;
        charset=utf-8
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CA+55aFwRGDPvaCUgMtqnQHb2PZ77JSMQMQVf1znSN+PiV7NR-Q@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Kees Cook <keescook@chromium.org>, Alexei Starovoitov <ast@kernel.org>, Djalal Harouni <tixxdz@gmail.com>, Al Viro <viro@zeniv.linux.org.uk>, "David S. Miller" <davem@davemloft.net>, Daniel Borkmann <daniel@iogearbox.net>, Greg KH <gregkh@linuxfoundation.org>, "Luis R. Rodriguez" <mcgrof@kernel.org>, Network Development <netdev@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, kernel-team <kernel-team@fb.com>, Linux API <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org




> On Mar 8, 2018, at 7:06 PM, Linus Torvalds <torvalds@linux-foundation.org>=
 wrote:
>=20
>=20
> Honestly, that "read twice" thing may be what scuttles this.
> Initially, I thought it was a non-issue, because anybody who controls
> the module subdirectory enough to rewrite files would be in a position
> to just execute the file itself directly instead.
>=20

On further consideration, I think there=E2=80=99s another showstopper. This p=
atch is a potentially severe ABI break. Right now, loading a module *copies*=
 it into memory and does not hold a reference to the underlying fs. With the=
 patch applied, all kinds of use cases can break in gnarly ways. Initramfs i=
s maybe okay, but initrd may be screwed. If you load an ET_EXEC module from i=
nitrd, then umount it, then clear the ramdisk, something will go horribly wr=
ong. Exactly what goes wrong depends on whether userspace notices that umoun=
t() failed. Similarly, if you load one of these modules over a network and t=
hen lose your connection, you have a problem.=20


The =E2=80=9Cread twice=E2=80=9D thing is also bad for another reason: conta=
iners. Suppose I have a setup where a container can load a signed module blo=
b. With the read twice code, the container can race and run an entirely diff=
erent blob outside the container.=20=
