From: Andy Lutomirski <luto@amacapital.net>
Subject: Re: d_off field in struct dirent and 32-on-64 emulation
Date: Thu, 27 Dec 2018 10:38:10 -0700
Message-ID: <C65D3222-723F-4C0B-AF02-38488C302E84@amacapital.net>
References: <87bm56vqg4.fsf@mid.deneb.enyo.de>
Mime-Version: 1.0 (1.0)
Content-Type: text/plain;
	charset=utf-8
Content-Transfer-Encoding: quoted-printable
Return-path: <qemu-devel-bounces+gceq-qemu-devel2=m.gmane.org@nongnu.org>
In-Reply-To: <87bm56vqg4.fsf@mid.deneb.enyo.de>
List-Unsubscribe: <https://lists.nongnu.org/mailman/options/qemu-devel>,
	<mailto:qemu-devel-request@nongnu.org?subject=unsubscribe>
List-Archive: <http://lists.nongnu.org/archive/html/qemu-devel/>
List-Post: <mailto:qemu-devel@nongnu.org>
List-Help: <mailto:qemu-devel-request@nongnu.org?subject=help>
List-Subscribe: <https://lists.nongnu.org/mailman/listinfo/qemu-devel>,
	<mailto:qemu-devel-request@nongnu.org?subject=subscribe>
Errors-To: qemu-devel-bounces+gceq-qemu-devel2=m.gmane.org@nongnu.org
Sender: "Qemu-devel"
	<qemu-devel-bounces+gceq-qemu-devel2=m.gmane.org@nongnu.org>
To: Florian Weimer <fw@deneb.enyo.de>
Cc: lucho@ionkov.net, libc-alpha@sourceware.org, arnd@arndb.de, ericvh@gmail.com, linux-api@vger.kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org, qemu-devel@nongnu.org, rminnich@sandia.gov, linux-fsdevel@vger.kernel.org, v9fs-developer@lists.sourceforge.net, linux-ext4@vger.kernel.org
List-Id: linux-api@vger.kernel.org



> On Dec 27, 2018, at 10:18 AM, Florian Weimer <fw@deneb.enyo.de> wrote:
>=20
> We have a bit of an interesting problem with respect to the d_off
> field in struct dirent.
>=20
> When running a 64-bit kernel on certain file systems, notably ext4,
> this field uses the full 63 bits even for small directories (strace -v
> output, wrapped here for readability):
>=20
> getdents(3, [
>  {d_ino=3D1494304, d_off=3D3901177228673045825, d_reclen=3D40, d_name=3D"a=
uthorized_keys", d_type=3DDT_REG},
>  {d_ino=3D1494277, d_off=3D7491915799041650922, d_reclen=3D24, d_name=3D".=
", d_type=3DDT_DIR},
>  {d_ino=3D1314655, d_off=3D9223372036854775807, d_reclen=3D24, d_name=3D".=
.", d_type=3DDT_DIR}
> ], 32768) =3D 88
>=20
> When running in 32-bit compat mode, this value is somehow truncated to
> 31 bits, for both the getdents and the getdents64 (!) system call (at
> least on i386).

I imagine you=E2=80=99re encountering this bug:

https://lkml.org/lkml/2018/10/18/859

Presumably the right fix involves modifying the relevant VFS file operations=
 to indicate the relevant ABI to the implementations.

I would guess that 9p is triggering the =E2=80=9Cnot really in the syscall y=
ou think you=E2=80=99re in=E2=80=9D issue.
