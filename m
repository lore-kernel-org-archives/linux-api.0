From: Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
Subject: Re: [PATCH v25 03/12] LRNG - /proc interface
Date: Sun, 17 Nov 2019 13:16:19 +0100
Message-ID: <3043322.Kq9igzfA0K@positron.chronox.de>
References: <2476454.l8LQlgn7Hv@positron.chronox.de> <4EB89769-7A2C-4A03-A832-9A0539DD3336@amacapital.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <4EB89769-7A2C-4A03-A832-9A0539DD3336@amacapital.net>
Sender: linux-kernel-owner@vger.kernel.org
To: Andy Lutomirski <luto@amacapital.net>
Cc: Arnd Bergmann <arnd@arndb.de>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-crypto@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, linux-api@vger.kernel.org, "Eric W. Biederman" <ebiederm@xmission.com>, "Alexander E. Patrakov" <patrakov@gmail.com>, "Ahmed S. Darwish" <darwish.07@gmail.com>, "Theodore Y. Ts'o" <tytso@mit.edu>, Willy Tarreau <w@1wt.eu>, Matthew Garrett <mjg59@srcf.ucam.org>, Vito Caputo <vcaputo@pengaru.com>, Andreas Dilger <adilger.kernel@dilger.ca>, Jan Kara <jack@suse.cz>, Ray Strode <rstrode@redhat.com>, William Jon McCann <mccann@jhu.edu>, zhangjs <zachary@baishancloud.com>, Andy Lutomirski <luto@kernel.org>, Florian Weimer <fweimer@redhat.com>, Lennart Poettering <mzxreary@0pointer.de>, Nicolai Stange <nstange@sus>
List-Id: linux-api@vger.kernel.org

Am Samstag, 16. November 2019, 17:39:40 CET schrieb Andy Lutomirski:

Hi Andy,

> > On Nov 16, 2019, at 1:40 AM, Stephan M=C3=BCller <smueller@chronox.de> =
wrote:
> >=20
> > =EF=BB=BFThe LRNG /proc interface provides the same files as the legacy
> > /dev/random. These files behave identically. Yet, all files are
> > documented at [1].
>=20
> Why?

I am not sure here: are you referring to the documentation? Or the one=20
additional file?

If it is the documentation, do you want me to add it to the patch descripti=
on?=20
I initially did not add it as these files were present and seemingly known=
=20
what they provide. But I would add that documentation to the patch descript=
ion=20
if this is desired.

If it is the additional file, should I move it to another place like a sysf=
s=20
interface?

Thank you.

Ciao
Stephan
