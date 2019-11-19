From: Andy Lutomirski <luto@kernel.org>
Subject: Re: [PATCH v25 10/12] LRNG - add TRNG support
Date: Tue, 19 Nov 2019 02:07:40 -0800
Message-ID: <CALCETrUKDO1LSMnHNcPiAFQh2ri6saRiRBi9b5e699cm1_Mgsw@mail.gmail.com>
References: <5390778.VeFRgus4bQ@positron.chronox.de> <DDB907EA-3FCC-40C7-B55B-A84BC77FD7A1@amacapital.net>
 <3159012.PsEOTp9LqO@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <3159012.PsEOTp9LqO@positron.chronox.de>
Sender: linux-kernel-owner@vger.kernel.org
To: =?UTF-8?Q?Stephan_M=C3=BCller?= <smueller@chronox.de>
Cc: Arnd Bergmann <arnd@arndb.de>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Linux Crypto Mailing List <linux-crypto@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, "Eric W. Biederman" <ebiederm@xmission.com>, "Alexander E. Patrakov" <patrakov@gmail.com>, "Ahmed S. Darwish" <darwish.07@gmail.com>, "Theodore Y. Ts'o" <tytso@mit.edu>, Willy Tarreau <w@1wt.eu>, Matthew Garrett <mjg59@srcf.ucam.org>, Vito Caputo <vcaputo@pengaru.com>, Andreas Dilger <adilger.kernel@dilger.ca>, Jan Kara <jack@suse.cz>, Ray Strode <rstrode@redhat.com>, William Jon McCann <mccann@jhu.edu>, zhangjs <zachary@baishancloud.com>, Andy Lutomirski <luto@kernel.org>, Florian Weimer <fweimer@redhat.com>, Lennart Poettering <mzxreary@0>
List-Id: linux-api@vger.kernel.org

On Sun, Nov 17, 2019 at 3:11 AM Stephan M=C3=BCller <smueller@chronox.de> w=
rote:
>
> Am Samstag, 16. November 2019, 17:09:09 CET schrieb Andy Lutomirski:
>
> Hi Andy,
>
> > > On Nov 16, 2019, at 1:40 AM, Stephan M=C3=BCller <smueller@chronox.de=
> wrote:
> > >
> > > =EF=BB=BFThe True Random Number Generator (TRNG) provides a random nu=
mber
> > > generator with prediction resistance (SP800-90A terminology) or an NT=
G.1
> > > (AIS 31 terminology).
> >
> > ...
> >
> > > The secondary DRNGs seed from the TRNG if it is present. In addition,
> > > the /dev/random device accesses the TRNG.
> > >
> > > If the TRNG is disabled, the secondary DRNGs seed from the entropy po=
ol
> > > and /dev/random behaves like getrandom(2).
> >
> > As mentioned before, I don=E2=80=99t like this API.  An application tha=
t, for some
> > reason, needs a TRNG, should have an API by which it either gets a TRNG=
 or
> > an error. Similarly, an application that wants cryptographically secure
> > random numbers efficiently should have an API that does that.  With you=
r
> > design, /dev/random tries to cater to both use cases, but one of the us=
e
> > cases fails depending on kernel config.
> >
> > I think /dev/random should wait for enough entropy to initialize the sy=
stem
> > but should not block after that. A TRNG should have an entirely new API
> > that is better than /dev/random.
>
> I apologize for the misunderstanding. I assumed we would introduce such /=
dev/
> true_random at a later stage.
>
> If you agree, I can certainly add /dev/true_random right now that links w=
ith
> the TRNG and make /dev/random behave as discussed, i.e. behave exactly li=
ke
> getrandom(..., 0);

Given that your series is already a decently large ABI change, I think
it would be polite to users to make all the anticipated changes all at
once to reduce the amount of churn everyone needs to deal with.

>
> As this would introduce a new device file now, is there a special process=
 that
> I need to follow or do I need to copy? Which major/minor number should I =
use?
>
> Looking into static const struct memdev devlist[] I see
>
>          [8] =3D { "random", 0666, &random_fops, 0 },
>          [9] =3D { "urandom", 0666, &urandom_fops, 0 },
>
> Shall a true_random be added here with [10]?

I am not at all an expert on chardevs, but this sounds generally
reasonable.  gregkh is probably the real authority here.
