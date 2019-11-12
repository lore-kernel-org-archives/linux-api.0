From: Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
Subject: Re: [PATCH v24 00/12] /dev/random - a new approach with full SP800-90B compliance
Date: Tue, 12 Nov 2019 23:43:42 +0100
Message-ID: <5603724.uI2RiKDNrm@positron.chronox.de>
References: <6157374.ptSnyUpaCn@positron.chronox.de> <875zjpfcu9.fsf@mid.deneb.enyo.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <875zjpfcu9.fsf@mid.deneb.enyo.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Florian Weimer <fw@deneb.enyo.de>
Cc: Arnd Bergmann <arnd@arndb.de>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-crypto@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, linux-api@vger.kernel.org, "Eric W. Biederman" <ebiederm@xmission.com>, "Alexander E. Patrakov" <patrakov@gmail.com>, "Ahmed S. Darwish" <darwish.07@gmail.com>, "Theodore Y. Ts'o" <tytso@mit.edu>, Willy Tarreau <w@1wt.eu>, Matthew Garrett <mjg59@srcf.ucam.org>, Vito Caputo <vcaputo@pengaru.com>, Andreas Dilger <adilger.kernel@dilger.ca>, Jan Kara <jack@suse.cz>, Ray Strode <rstrode@redhat.com>, William Jon McCann <mccann@jhu.edu>, zhangjs <zachary@baishancloud.com>, Andy Lutomirski <luto@kernel.org>, Florian Weimer <fweimer@redhat.com>, Lennart Poettering <mzxreary@0pointer.de>, Nicolai Stange <nstange@sus>
List-Id: linux-api@vger.kernel.org

Am Dienstag, 12. November 2019, 14:23:10 CET schrieb Florian Weimer:

Hi Florian,

> * Stephan M=FCller:
> > * support deactivation of TRNG (i.e. blocking behavior of /dev/random)
> >=20
> >   at compile time. If deactivated, /dev/random behaves like
> >   getrandom(2).
>=20
> I don't quite understand this comment.  Doesn't getrandom with the
> GRND_RANDOM always behave like /dev/random?  Presumably, without the
> TRNG tap, the GRND_RANDOM flag for getrandom is ignored, and reading
> from /dev/random behaves like reading from /dev/urandom.

Absolutely. Apologies for the imprecision here. I will correct that.

The idea is that the constant blocking behavior of /dev/random and GRND_RAN=
DOM=20
is replaced with the blocking behavior of getrandom(2) without the GRND_RAN=
DOM=20
flag (i.e. the interface waits until the LRNG thinks it is completely seede=
d=20
before it provides ulimited data).
>=20
> Anyway, reading the accompanying PDF, this looks rather impressive:
> the userspace bootstrapping problem is gone (the issue where waiting
> for more entropy prevents the collection of more entropy), *and* we
> can still make the standards people happy.
>=20
> (Replying from my other account due to mail issues, sorry.)


Ciao
Stephan
