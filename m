From: Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
Subject: Re: [PATCH v25 10/12] LRNG - add TRNG support
Date: Wed, 20 Nov 2019 20:51:11 +0100
Message-ID: <1695782.oZ5Vf4nH9s@positron.chronox.de>
References: <5390778.VeFRgus4bQ@positron.chronox.de> <19681012.svDddlc5pN@positron.chronox.de> <20191120132918.GA2892197@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20191120132918.GA2892197@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Andy Lutomirski <luto@kernel.org>, Arnd Bergmann <arnd@arndb.de>, Linux Crypto Mailing List <linux-crypto@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, "Eric W. Biederman" <ebiederm@xmission.com>, "Alexander E. Patrakov" <patrakov@gmail.com>, "Ahmed S. Darwish" <darwish.07@gmail.com>, "Theodore Y. Ts'o" <tytso@mit.edu>, Willy Tarreau <w@1wt.eu>, Matthew Garrett <mjg59@srcf.ucam.org>, Vito Caputo <vcaputo@pengaru.com>, Andreas Dilger <adilger.kernel@dilger.ca>, Jan Kara <jack@suse.cz>, Ray Strode <rstrode@redhat.com>, William Jon McCann <mccann@jhu.edu>, zhangjs <zachary@baishancloud.com>, Florian Weimer <fweimer@redhat.com>, Lennart Poettering <mzxreary@0pointer.de>, Nicolai Stange <nstange@suse.de>P
List-Id: linux-api@vger.kernel.org

Am Mittwoch, 20. November 2019, 14:29:18 CET schrieb Greg Kroah-Hartman:

Hi Greg,

> On Wed, Nov 20, 2019 at 09:58:35AM +0100, Stephan M=FCller wrote:
> > Am Dienstag, 19. November 2019, 13:41:50 CET schrieb Greg Kroah-Hartman:
> >=20
> > Hi Greg,
> >=20
> > > On Tue, Nov 19, 2019 at 02:07:40AM -0800, Andy Lutomirski wrote:
> > > > > As this would introduce a new device file now, is there a special
> > > > > process that I need to follow or do I need to copy? Which
> > > > > major/minor
> > > > > number should I use?
> > > > >=20
> > > > > Looking into static const struct memdev devlist[] I see
> > > > >=20
> > > > >          [8] =3D { "random", 0666, &random_fops, 0 },
> > > > >          [9] =3D { "urandom", 0666, &urandom_fops, 0 },
> > > > >=20
> > > > > Shall a true_random be added here with [10]?
> > > >=20
> > > > I am not at all an expert on chardevs, but this sounds generally
> > > > reasonable.  gregkh is probably the real authority here.
> > >=20
> > > [10] is the aio char device node, so you better not try to overlap it=
 or
> > > bad things will happen :(
> >=20
> > Thanks for your insights.
> >=20
> > Which device minor number could we use?
>=20
> Get your own dynamic one by using a misc device if you _REALLY_ want to
> add yet-another-char-node-for-random-data.
>=20
> But I would have thought that we all realize that this is not the way to
> do things.  Let's not have "random", "urandom", and "true_random" be
> something we want to totally confuse userspace with, that way is insane.
>=20
> Please just make the existing userspace api "just work", don't add to
> the mess.

Thank you, I think we should follow that advise.

With that and considering Alexander's rightful remark we have a challenge. =
So,=20
changing the syscall may not be the right way unless we find a way to restr=
ict=20
the permissions somehow (capability? LSM? None of that seems to be a good=20
fit).

What about providing a /sys file? I.e. adding a file that:

a) has permissions 440 per default and maybe the ownership of root:root

b) allow user space to perform a chown/chgrp

c) only supports reading of data from user space

But then, how could we provide a common interface for the existing random.c=
=20
and the LRNG?

Or should we use a proc file for that? If yes, I guess it should not be a=20
sysctl, but a "regular" proc file that should allow a chown(2) operation. O=
n=20
the other hand, is proc the right place to provide a user space interface f=
or=20
exporting data to user?

Thanks a lot.

Ciao
Stephan
