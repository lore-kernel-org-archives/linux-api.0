From: "Alexander E. Patrakov" <patrakov@gmail.com>
Subject: Re: [PATCH v24 11/12] LRNG - add SP800-90B compliant health tests
Date: Wed, 13 Nov 2019 11:02:40 +0500
Message-ID: <CAN_LGv3LUjJ=8ZZxaJ=c7uDPb=ayvCNPE-UshxgBUK-Jf7qNmQ@mail.gmail.com>
References: <6157374.ptSnyUpaCn@positron.chronox.de> <3385183.Cb3iLDTLdO@positron.chronox.de>
 <556c89ae-4272-970d-1644-cb77dc3c7946@gmail.com> <9152597.fJySsU3eCD@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <9152597.fJySsU3eCD@positron.chronox.de>
Sender: linux-kernel-owner@vger.kernel.org
To: =?UTF-8?Q?Stephan_M=C3=BCller?= <smueller@chronox.de>
Cc: Arnd Bergmann <arnd@arndb.de>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-crypto@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, "Eric W. Biederman" <ebiederm@xmission.com>, "Ahmed S. Darwish" <darwish.07@gmail.com>, "Theodore Y. Ts'o" <tytso@mit.edu>, Willy Tarreau <w@1wt.eu>, Matthew Garrett <mjg59@srcf.ucam.org>, Vito Caputo <vcaputo@pengaru.com>, Andreas Dilger <adilger.kernel@dilger.ca>, Jan Kara <jack@suse.cz>, Ray Strode <rstrode@redhat.com>, William Jon McCann <mccann@jhu.edu>, zhangjs <zachary@baishancloud.com>, Andy Lutomirski <luto@kernel.org>, Florian Weimer <fweimer@redhat.com>, Lennart Poettering <mzxreary@0pointer.de>, Nicolai Stange <nstange@suse.de>, "Peter, Matthias" <matthias>
List-Id: linux-api@vger.kernel.org

=D1=81=D1=80, 13 =D0=BD=D0=BE=D1=8F=D0=B1. 2019 =D0=B3. =D0=B2 05:38, Steph=
an M=C3=BCller <smueller@chronox.de>:
>
> Am Dienstag, 12. November 2019, 20:58:32 CET schrieb Alexander E. Patrako=
v:
>
> Hi Alexander,
>
> > > +config LRNG_HEALTH_TESTS
> > > +   bool "Enable noise source online health tests"
> > > +   help
> > > +     The online health tests validate the noise source at
> > > +     runtime for fatal errors. These tests include SP800-90B
> > > +     compliant tests which are invoked if the system is booted
> > > +     with fips=3D1. In case of fatal errors during active
> > > +     SP800-90B tests, the issue is logged and the noise
> > > +     data is discarded. These tests are required for full
> > > +     compliance with SP800-90B.
> >
> > How have you tested that these tests work at runtime? Maybe add some
> > code under a new CONFIG item that depends on CONFIG_BROKEN that
> > deliberately botches the RNG and triggers failures?
>
>
> I am unable to find sensible information about CONFIG_BROKEN in the recen=
t
> kernel tree.
>
> Do you happen to have a pointer on how that option is to be used?

This option is not used on its own. You create a new option,
CONFIG_TEST_LRNG_FAILURE_MODE or something like that, and put your
code under the ifdef guarded by that option. And then, to prevent
ordinary users and allyesconfig from selecting it, in Kconfig you say:
"depends on BROKEN". This way, the option becomes unselectable in
menuconfig but still works as intended when added manually to .config
(obviously, with the BROKEN dependency removed locally).

Definition: https://github.com/torvalds/linux/blob/9c7db5004280767566e91a33=
445bf93aa479ef02/init/Kconfig#L68
Example usage: https://github.com/torvalds/linux/blob/c87237110f2553b4200a8=
b3401a01198edfcf0d9/drivers/gpu/drm/i915/Kconfig.debug#L166

--
Alexander E. Patrakov
