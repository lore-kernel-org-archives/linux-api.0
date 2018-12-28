From: Andy Lutomirski <luto@kernel.org>
Subject: Re: d_off field in struct dirent and 32-on-64 emulation
Date: Fri, 28 Dec 2018 07:26:00 -0800
Message-ID: <CALCETrUBfVK1yUtuVn-pGzgrq8GQ7_E0sjPBXPaSiPU+Q-C_aA@mail.gmail.com>
References: <87bm56vqg4.fsf@mid.deneb.enyo.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <87bm56vqg4.fsf@mid.deneb.enyo.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Florian Weimer <fw@deneb.enyo.de>
Cc: Linux FS Devel <linux-fsdevel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, linux-ext4@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, V9FS Developers <v9fs-developer@lists.sourceforge.net>, libc-alpha <libc-alpha@sourceware.org>, "qemu-devel@nongnu.org Developers" <qemu-devel@nongnu.org>, Eric Van Hensbergen <ericvh@gmail.com>, Ron Minnich <rminnich@sandia.gov>, Latchesar Ionkov <lucho@ionkov.net>, "H. Peter Anvin" <hpa@zytor.com>, Arnd Bergmann <arnd@arndb.de>
List-Id: linux-api@vger.kernel.org

[sending again, slightly edited, due to email client issues]

On Thu, Dec 27, 2018 at 9:25 AM Florian Weimer <fw@deneb.enyo.de> wrote:
>
> We have a bit of an interesting problem with respect to the d_off
> field in struct dirent.
>
> When running a 64-bit kernel on certain file systems, notably ext4,
> this field uses the full 63 bits even for small directories (strace -v
> output, wrapped here for readability):
>
> getdents(3, [
>   {d_ino=3D1494304, d_off=3D3901177228673045825, d_reclen=3D40, d_name=3D=
"authorized_keys", d_type=3DDT_REG},
>   {d_ino=3D1494277, d_off=3D7491915799041650922, d_reclen=3D24, d_name=3D=
".", d_type=3DDT_DIR},
>   {d_ino=3D1314655, d_off=3D9223372036854775807, d_reclen=3D24, d_name=3D=
"..", d_type=3DDT_DIR}
> ], 32768) =3D 88
>
> When running in 32-bit compat mode, this value is somehow truncated to
> 31 bits, for both the getdents and the getdents64 (!) system call (at
> least on i386).
>

...

>
> However, both qemu-user and the 9p file system can run in such a way
> that the kernel is entered from a 64-bit process, but the actual usage
> is from a 32-bit process:


I imagine that at least some of the problems you're seeing are due to this =
bug:

https://lkml.org/lkml/2018/10/18/859

Presumably the right fix involves modifying the relevant VFS file
operations to indicate the relevant ABI to the implementations.  I
would guess that 9p is triggering the =E2=80=9Cnot really in the syscall yo=
u
think you=E2=80=99re in=E2=80=9D issue.
