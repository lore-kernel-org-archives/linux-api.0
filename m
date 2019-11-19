From: Andy Lutomirski <luto@kernel.org>
Subject: Re: [PATCH v25 03/12] LRNG - /proc interface
Date: Tue, 19 Nov 2019 09:40:43 -0800
Message-ID: <CALCETrV9W9_rkdCZ4ZvV0bQWiE0ms8cvAyZqeNy4=kHnFj9BRA@mail.gmail.com>
References: <2476454.l8LQlgn7Hv@positron.chronox.de> <3043322.Kq9igzfA0K@positron.chronox.de>
 <CALCETrVXGuShozaf5RpgmQnwtTpAbmaTVny+E0q8OE4OLuWwAQ@mail.gmail.com> <5323691.yyFvDVlHDV@tauon.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <5323691.yyFvDVlHDV@tauon.chronox.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Stephan Mueller <smueller@chronox.de>
Cc: Andy Lutomirski <luto@kernel.org>, Arnd Bergmann <arnd@arndb.de>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Linux Crypto Mailing List <linux-crypto@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, "Eric W. Biederman" <ebiederm@xmission.com>, "Alexander E. Patrakov" <patrakov@gmail.com>, "Ahmed S. Darwish" <darwish.07@gmail.com>, "Theodore Y. Ts'o" <tytso@mit.edu>, Willy Tarreau <w@1wt.eu>, Matthew Garrett <mjg59@srcf.ucam.org>, Vito Caputo <vcaputo@pengaru.com>, Andreas Dilger <adilger.kernel@dilger.ca>, Jan Kara <jack@suse.cz>, Ray Strode <rstrode@redhat.com>, William Jon McCann <mccann@jhu.edu>, zhangjs <zachary@baishancloud.com>, Florian Weimer <fweimer@redhat.com>, Lennart Poettering <mzxreary@0pointer.>
List-Id: linux-api@vger.kernel.org

On Tue, Nov 19, 2019 at 2:57 AM Stephan Mueller <smueller@chronox.de> wrote=
:
>
> Am Dienstag, 19. November 2019, 11:06:02 CET schrieb Andy Lutomirski:
>
> Hi Andy,
>
> > On Sun, Nov 17, 2019 at 4:16 AM Stephan M=C3=BCller <smueller@chronox.d=
e> wrote:
> > > Am Samstag, 16. November 2019, 17:39:40 CET schrieb Andy Lutomirski:
> > >
> > > Hi Andy,
> > >
> > > > > On Nov 16, 2019, at 1:40 AM, Stephan M=C3=BCller <smueller@chrono=
x.de>
> > > > > wrote:
> > > > >
> > > > > =EF=BB=BFThe LRNG /proc interface provides the same files as the =
legacy
> > > > > /dev/random. These files behave identically. Yet, all files are
> > > > > documented at [1].
> > > >
> > > > Why?
> > >
> > > I am not sure here: are you referring to the documentation? Or the on=
e
> > > additional file?
> > >
> > > If it is the documentation, do you want me to add it to the patch
> > > description? I initially did not add it as these files were present a=
nd
> > > seemingly known what they provide. But I would add that documentation=
 to
> > > the patch description if this is desired.
> >
> > Sorry, I should have been a lot more explicit.  Why do you want to add
> > a new interface to read the RNG?  What's wrong with the old one?
>
> There is nothing wrong at all. I actually want to be 100% API and ABI
> compliant with the existing random.c. Thus, the list of the sysctls are
> identical to the existing random.c with the same behavior (hence I skippe=
d the
> documentation of these files).

Whoops, I misunderstood your commit message.  You said "The LRNG /proc
interface provides the same files as the legacy
/dev/random.".  I assumed that meant that you had a file in /proc that
worked like /dev/random.

So never mind.
