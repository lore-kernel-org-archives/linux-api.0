From: Andy Lutomirski <luto@amacapital.net>
Subject: Re: [PATCH net-next] modules: allow modprobe load regular elf binaries
Date: Thu, 8 Mar 2018 19:10:54 -0800
Message-ID: <3BC1EAA3-D926-4758-901D-A860718B846A@amacapital.net>
References: <CALCETrX=Vfk1T-XegwnjtUqeEsyUFXH1744d0yGkufQvDA5xkQ@mail.gmail.com> <20180309012046.6kcivmzzkap3a4xc@ast-mbp> <CALCETrV8nPo=_rsSzy3Dt+y09mNgRi2+aYRk0Pj45j6BLRXgAA@mail.gmail.com> <20180308.213153.2003279953084099668.davem@davemloft.net>
Mime-Version: 1.0 (1.0)
Content-Type: text/plain;
        charset=utf-8
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180308.213153.2003279953084099668.davem@davemloft.net>
Sender: linux-kernel-owner@vger.kernel.org
To: David Miller <davem@davemloft.net>
Cc: luto@kernel.org, alexei.starovoitov@gmail.com, keescook@chromium.org, ast@kernel.org, tixxdz@gmail.com, viro@zeniv.linux.org.uk, daniel@iogearbox.net, torvalds@linux-foundation.org, gregkh@linuxfoundation.org, mcgrof@kernel.org, netdev@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org




> On Mar 8, 2018, at 6:31 PM, David Miller <davem@davemloft.net> wrote:
>=20
> From: Andy Lutomirski <luto@kernel.org>
> Date: Fri, 9 Mar 2018 02:12:24 +0000
>=20
>> First, compile your user code and emit a staitc binary.  Use objdump
>> fiddling or a trivial .S file to make that static binary into a
>> variable.  Then write a tiny shim module like this:
>>=20
>> extern unsigned char __begin_user_code[], __end_user_code[];
>>=20
>> int __init init_shim_module(void)
>> {
>>  return call_umh_blob(__begin_user_code, __end_user_code - __begin_user_c=
ode);
>> }
>>=20
>> By itself, this is clearly a worse solution than yours, but it has two
>> benefits, one small and two big.  The small benefit is that it is
>> completely invisible to userspace: the .ko file is a bona fide module.
>=20
> Anything you try to do which makes these binaries "special" is a huge
> negative.

I don=E2=80=99t know what you mean.  Alexei=E2=80=99s approach introduces a w=
hole new kind of special module.  Mine doesn=E2=80=99t.=20

>=20
>> The big benefits are:
>=20
> I don't see those things as benefits at all, and Alexei's scheme can
> easily be made to work in your benefit #1 case too.
>=20

How?  I think you=E2=80=99ll find that a non-modular implementation of a bun=
dled ELF binary looks a *lot* like my call_umh_blob().

> It's a user binary.  It's shipped with the kernel and it's signed.
>=20
> If we can't trust that, we can't trust much else.

I=E2=80=99m not making any arguments about security at all. I=E2=80=99m talk=
ing about functionality.=20

If we apply Alexei=E2=80=99s patch as is, then I think we=E2=80=99ll have a s=
ituation where ET_EXEC modules are only useful if they can do their jobs wit=
hout any filesystem access at all.  This is fine for networking, where netli=
nk sockets are used, but I think it=E2=80=99s not so great for other use cas=
es. If we ever try to stick a usb driver into userspace, we=E2=80=99re going=
 to want to instantiate the user task once per device, passed as stdin or si=
milar, and Alexei=E2=80=99s code will make that very awkward.
