From: Stephan Mueller <smueller@chronox.de>
Subject: Re: [PATCH v25 03/12] LRNG - /proc interface
Date: Tue, 19 Nov 2019 11:55:23 +0100
Message-ID: <5323691.yyFvDVlHDV@tauon.chronox.de>
References: <2476454.l8LQlgn7Hv@positron.chronox.de> <3043322.Kq9igzfA0K@positron.chronox.de> <CALCETrVXGuShozaf5RpgmQnwtTpAbmaTVny+E0q8OE4OLuWwAQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CALCETrVXGuShozaf5RpgmQnwtTpAbmaTVny+E0q8OE4OLuWwAQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Andy Lutomirski <luto@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Linux Crypto Mailing List <linux-crypto@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, "Eric W. Biederman" <ebiederm@xmission.com>, "Alexander E. Patrakov" <patrakov@gmail.com>, "Ahmed S. Darwish" <darwish.07@gmail.com>, "Theodore Y. Ts'o" <tytso@mit.edu>, Willy Tarreau <w@1wt.eu>, Matthew Garrett <mjg59@srcf.ucam.org>, Vito Caputo <vcaputo@pengaru.com>, Andreas Dilger <adilger.kernel@dilger.ca>, Jan Kara <jack@suse.cz>, Ray Strode <rstrode@redhat.com>, William Jon McCann <mccann@jhu.edu>, zhangjs <zachary@baishancloud.com>, Florian Weimer <fweimer@redhat.com>, Lennart Poettering <mzxreary@0pointer.de>, Nicolai Stange <nstang>
List-Id: linux-api@vger.kernel.org

Am Dienstag, 19. November 2019, 11:06:02 CET schrieb Andy Lutomirski:

Hi Andy,

> On Sun, Nov 17, 2019 at 4:16 AM Stephan M=C3=BCller <smueller@chronox.de>=
 wrote:
> > Am Samstag, 16. November 2019, 17:39:40 CET schrieb Andy Lutomirski:
> >=20
> > Hi Andy,
> >=20
> > > > On Nov 16, 2019, at 1:40 AM, Stephan M=C3=BCller <smueller@chronox.=
de>
> > > > wrote:
> > > >=20
> > > > =EF=BB=BFThe LRNG /proc interface provides the same files as the le=
gacy
> > > > /dev/random. These files behave identically. Yet, all files are
> > > > documented at [1].
> > >=20
> > > Why?
> >=20
> > I am not sure here: are you referring to the documentation? Or the one
> > additional file?
> >=20
> > If it is the documentation, do you want me to add it to the patch
> > description? I initially did not add it as these files were present and
> > seemingly known what they provide. But I would add that documentation to
> > the patch description if this is desired.
>=20
> Sorry, I should have been a lot more explicit.  Why do you want to add
> a new interface to read the RNG?  What's wrong with the old one?

There is nothing wrong at all. I actually want to be 100% API and ABI=20
compliant with the existing random.c. Thus, the list of the sysctls are=20
identical to the existing random.c with the same behavior (hence I skipped =
the=20
documentation of these files).

Yet, the wiring up of the interfaces to internal data structures and handle=
rs=20
is different than for the existing random.c.

Also, the reason why I created a separate lrng_proc.c (and lrng_interface.c=
)=20
is to allow a possible merger of this similar code with the existing random=
=2Ec.=20
The only question that needs to be solved is to find a common way to invoke=
=20
the random.c internal logic and the LRNG internal logic with these interfac=
es.
>=20
> I think your patch description should explain the purpose of the patch.

Ok, I can surely add a description for each file to the patch description.

Ciao
Stephan
