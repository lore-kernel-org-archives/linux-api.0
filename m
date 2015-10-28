From: Stephan Mueller <smueller-T9tCv8IpfcWELgA04lAiVw@public.gmane.org>
Subject: Re: [PATCH v2 0/5] crypto: add algif_akcipher user space API
Date: Wed, 28 Oct 2015 02:18:35 +0100
Message-ID: <2035809.AHCPW286O9@myon.chronox.de>
References: <1831785.BBs8Hj3CxY@myon.chronox.de> <1885267.SGBklDhT9E@myon.chronox.de> <1445992622.3405.148.camel@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1445992622.3405.148.camel-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David Woodhouse <dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Marcel Holtmann <marcel-kz+m5ild9QBg9hUCZPvPmw@public.gmane.org>, Herbert Xu <herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org>, linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Am Mittwoch, 28. Oktober 2015, 09:37:02 schrieb David Woodhouse:

Hi David,

> On Wed, 2015-10-28 at 00:47 +0100, Stephan Mueller wrote:
> > Ohh, I see. So, you are saying that there should not be a setpub/pr=
ivkey
> > for the akcipher AF_ALG interface?!
> >=20
> > If somebody wants to use akcipher, he shall set the key via the key=
ring
> > and
> > akcipher shall obtain it from the keyring?
> >=20
> > However, for the actual data shoveling, AF_ALG should still be used=
?
>=20
> That might seem ideal, but Herbert doesn't want that =E2=80=94 he wan=
ts
> akcipher to work *only* with its own internal keys, not with keys fro=
m
> the kernel's key subsystem.
>=20
> David has patches (not upstream yet; used for testing) which expose a
> verify operation for kernel keys through sys_keyctl(). Adding the oth=
er
> three operations would be feasible.
>=20
> Perhaps if we *really* want this to appear through AF_ALG, the key
> subsystem could register its own RSA (and other) implementation(s) wi=
th
> the crypto subsystem. Then we could find some way that we can pass th=
e
> key_serial_t through alg_setkey() instead of the actual key data
> without it (or Herbert) noticing that's what we're doing. But... ick.
> And I don't think we can select algorithms based on the actual key
> rather than the type. We should do it properly, if at all. And define
> the API as taking key IDs instead of having it be a nasty special-cas=
e
> hack for a specific (but really, very generic) algorithm provider.

=46irst of all, I personally would not insist on an AF_ALG for pure akc=
ipher=20
externalization. Integrating it with the key subsystem looks like a fin=
e idea.

But that would imply that we tie the crypto API quite hard with the key=
=20
retention system which I guess may not be warranted.

Note, I was playing with the idea of using the key retention system for=
 the=20
kernel crypto API myself (hence also my patch to add key wrapping suppo=
rt=20
which has its roots there).

But having a tie between both, the kernel crypto API and the key system=
, that=20
cannot be cut any more is something I am not sure about. Both should an=
d would=20
work in isolation of each other as both serve different needs.

But I agree that when having both and the user wants proper key managem=
ent,=20
the key system should be used. But isn't that already a policy decision=
 of the=20
user/administrator? IIRC, the kernel should not hard-wire policies that=
 may or=20
may not be wanted by user space. Hence, the decision about connecting b=
oth=20
systems should rest in user space. And the kernel should support a join=
t=20
operation of both.


--=20
Ciao
Stephan
