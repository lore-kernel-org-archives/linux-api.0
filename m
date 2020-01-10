From: Andy Lutomirski <luto@amacapital.net>
Subject: Re: [PATCH v3 0/8] Rework random blocking
Date: Thu, 9 Jan 2020 14:30:48 -1000
Message-ID: <99CB981B-752C-449B-98BE-A4DF80D25A26@amacapital.net>
References: <20200109220230.GA39185@roeckx.be>
Mime-Version: 1.0 (1.0)
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-ext4-owner@vger.kernel.org>
In-Reply-To: <20200109220230.GA39185@roeckx.be>
Sender: linux-ext4-owner@vger.kernel.org
To: Kurt Roeckx <kurt@roeckx.be>
Cc: "Theodore Y. Ts'o" <tytso@mit.edu>, Stephan Mueller <smueller@chronox.de>, Andy Lutomirski <luto@kernel.org>, LKML <linux-kernel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, Kees Cook <keescook@chromium.org>, "Jason A. Donenfeld" <Jason@zx2c4.com>, "Ahmed S. Darwish" <darwish.07@gmail.com>, Lennart Poettering <mzxreary@0pointer.de>, "Eric W. Biederman" <ebiederm@xmission.com>, "Alexander E. Patrakov" <patrakov@gmail.com>, Michael Kerrisk <mtk.manpages@gmail.com>, Willy Tarreau <w@1wt.eu>, Matthew Garrett <mjg59@srcf.ucam.org>, Ext4 Developers List <linux-ext4@vger.kernel.org>, linux-man <linux-man@vger.kernel.org>
List-Id: linux-api@vger.kernel.org



> On Jan 9, 2020, at 12:02 PM, Kurt Roeckx <kurt@roeckx.be> wrote:
>=20

>=20
> If the kernel provides a good RNG, the only reason I can see why
> you would like to have direct access to a hwrng is to verify that
> it's working correctly. That might mean that you put it in some
> special mode where it returns raw unprocessed values. If the device
> is in such a mode, it's output will not provide the same entropy
> per bit, and so I would expect the kernel to stop using it directly.

I disagree.

If I buy a ChaosKey or a fancy EAL4FIPSOMG key, I presumably have it for a r=
eason and I want to actually use the thing for real. Maybe it=E2=80=99s for s=
ome certification reason and maybe it=E2=80=99s just because it=E2=80=99s re=
ally cool.

As for =E2=80=9Cdirect=E2=80=9D access,  I think AMD provides an interface t=
o read raw output from the on-die entropy source. Exposing this to user spac=
e is potentially quite useful for anyone who wants to try to characterize it=
.  I don=E2=80=99t really think people should use a raw sample interface as a=
 source of production random numbers, though.
