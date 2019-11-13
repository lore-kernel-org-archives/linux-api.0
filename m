From: Andy Lutomirski <luto@kernel.org>
Subject: Re: [PATCH v24 00/12] /dev/random - a new approach with full
 SP800-90B compliance
Date: Tue, 12 Nov 2019 20:48:30 -0800
Message-ID: <CALCETrVHdauN2ptZLSYAUDm=S3OGkxq=iH4qGxCuH0XCMKjGkQ@mail.gmail.com>
References: <6157374.ptSnyUpaCn@positron.chronox.de> <CALCETrVBzuOsDfaz5y3V4v+6xmeWufOYsOGnpZrRju6Pfsi6gg@mail.gmail.com>
 <3208655.cZiRAY37Id@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <3208655.cZiRAY37Id@positron.chronox.de>
Sender: linux-kernel-owner@vger.kernel.org
To: =?UTF-8?Q?Stephan_M=C3=BCller?= <smueller@chronox.de>
Cc: Andy Lutomirski <luto@kernel.org>, Arnd Bergmann <arnd@arndb.de>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Linux Crypto Mailing List <linux-crypto@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, "Eric W. Biederman" <ebiederm@xmission.com>, "Alexander E. Patrakov" <patrakov@gmail.com>, "Ahmed S. Darwish" <darwish.07@gmail.com>, "Theodore Y. Ts'o" <tytso@mit.edu>, Willy Tarreau <w@1wt.eu>, Matthew Garrett <mjg59@srcf.ucam.org>, Vito Caputo <vcaputo@pengaru.com>, Andreas Dilger <adilger.kernel@dilger.ca>, Jan Kara <jack@suse.cz>, Ray Strode <rstrode@redhat.com>, William Jon McCann <mccann@jhu.edu>, zhangjs <zachary@baishancloud.com>, Florian Weimer <fweimer@redhat.com>, Lennart Poettering <mzxreary@0pointer.>
List-Id: linux-api@vger.kernel.org

On Tue, Nov 12, 2019 at 8:25 PM Stephan M=C3=BCller <smueller@chronox.de> w=
rote:
>
> Am Dienstag, 12. November 2019, 16:33:59 CET schrieb Andy Lutomirski:
>
> Hi Andy,
>
> > On Mon, Nov 11, 2019 at 11:13 AM Stephan M=C3=BCller <smueller@chronox.=
de> wrote:
> > > The following patch set provides a different approach to /dev/random =
which
> > > is called Linux Random Number Generator (LRNG) to collect entropy wit=
hin
> > > the Linux kernel. The main improvements compared to the existing
> > > /dev/random is to provide sufficient entropy during boot time as well=
 as
> > > in virtual environments and when using SSDs. A secondary design goal =
is
> > > to limit the impact of the entropy collection on massive parallel sys=
tems
> > > and also allow the use accelerated cryptographic primitives. Also, al=
l
> > > steps of the entropic data processing are testable.
> >
> > This is very nice!
> >
> > > The LRNG patch set allows a user to select use of the existing /dev/r=
andom
> > > or the LRNG during compile time. As the LRNG provides API and ABI
> > > compatible interfaces to the existing /dev/random implementation, the
> > > user can freely chose the RNG implementation without affecting kernel=
 or
> > > user space operations.
> > >
> > > This patch set provides early boot-time entropy which implies that no
> > > additional flags to the getrandom(2) system call discussed recently o=
n
> > > the LKML is considered to be necessary.
> >
> > I'm uneasy about this.  I fully believe that, *on x86*, this works.
> > But on embedded systems with in-order CPUs, a single clock, and very
> > lightweight boot processes, most or all of boot might be too
> > deterministic for this to work.
> >
> > I have a somewhat competing patch set here:
> >
> > https://git.kernel.org/pub/scm/linux/kernel/git/luto/linux.git/log/?h=
=3Drandom
> > /kill-it
> >
> > (Ignore the "horrible test hack" and the debugfs part.)
> >
> > The basic summary is that I change /dev/random so that it becomes
> > functionally identical to getrandom(..., 0) -- in other words, it
> > blocks until the CRNG is initialized but is then identical to
> > /dev/urandom.  And I add getrandom(...., GRND_INSECURE) that is
> > functionally identical to the existing /dev/urandom: it always returns
> > *something* immediately, but it may or may not actually be
> > cryptographically random or even random at all depending on system
> > details.
> >
> > In other words, my series simplifies the ABI that we support.  Right
> > now, we have three ways to ask for random numbers with different
> > semantics and we need to have to RNGs in the kernel at all time.  With
> > my changes, we have only two ways to ask for random numbers, and the
> > /dev/random pool is entirely gone.
> >
> > Would you be amenable to merging this into your series (i.e. either
> > merging the code or just the ideas)?  This would let you get rid of
> > things like the compile-time selection of the blocking TRNG, since the
> > blocking TRNG would be entirely gone.
>
> I pulled your code and found the following based on my explanation that I
> would suggest to keep the TRNG at least as an option.
>
> - 7d54ef8512b06baf396f12584f7f48a9558ecd0f does not seem applicable:

Not surprising.  It's just a cleanup to the existing code, and I doubt
you inherited the oddity I'm fixing.

> - 6a26a3146e5fb90878dca9fde8caa1ca4233156a: My handler for /dev/urandom a=
nd
> getrandom(..., 0) are using one callback which issues a warning in both u=
se
> cases (see lrng_sdrng_read). So I think this patch may not be applicable =
as
> the LRNG code implements warning about being unseeded.

Probably true.

What is the actual semantics of /dev/urandom with your series applied?
 Is there any situation in which it will block?

>
> - 3e8e159da49b44ae0bb08e68fa2be760722fa033: I am happy to take that code =
which
> would almost directly apply. The last hunk however would be:
>
> if (!(flags & GRND_INSECURE) && unlikely(!lrng_state_operational())) {
>
> =3D=3D> Shall I apply it to my code base? If yes, how shall the changes t=
o
> random.h be handled?
>

This might be a question for Ted.  Once the merge window opens, I'll
resubmit it.

>
> - 920e97e7fc508e6f0da9c7dec94c8073fd63ab4d: I would pass on this patch du=
e to
> the following: it unconditionally starts removing the access to the TRNG =
(the
> LRNG's logical equivalent to the blocking_pool). As patch 10/12 of the LR=
NG
> patch series provides the TRNG that is a compile time option, your patch =
would
> logically and functionally be equivalent when deselecting
> CONFIG_LRNG_TRNG_SUPPORT in the LRNG without any further changes to the L=
RNG
> code.

Given your previous email about the TRNG, I'm wondering what the API
for the TRNG should be.  I am willing to grant that there are users
who need a TRNG for various reasons, and that not all of them can use
hwrng.  (And the current hwrng API is pretty bad.)  But I'm not
convinced that /dev/random or getrandom(..., GRND_RANDOM) is a
reasonable way to access it.  A blocking_pool-style TRNG is a very
limited resource, and I think it could make sense to require some sort
of actual permission to use it.  GRND_RANDOM has no access control at
all, and everyone expects /dev/random to be world-readable.  The most
widespread user of /dev/random that I know of is gnupg, and gnupg
really should not be using it.

Would it make sense to have a /dev/true_random that is 0400 by default
for users who actually need it?  Then /dev/random and GRND_RANDOM
could work as they do with my patch, and maybe it does the right thing
for everyone.

>
> - 693b9ffdf0fdc93456b5ad293ac05edf240a531b: This patch is applicable to t=
he
> LRNG. In case CONFIG_LRNG_TRNG_SUPPORT is not set, the TRNG is not presen=
t.
> Yet, the /dev/random and getrandom(GRND_RANDOM) would behave blocked unti=
l
> fully initialized. I have now added the general blocking until the LRNG i=
s
> fully initialized to the common /dev/random and getrandom(GRND_RANDOM)
> interface function of lrng_trng_read_common. With that, the LRNG would be
> fully equivalent to this patch if CONFIG_LRNG_TRNG_SUPPORT is not set.

Sounds reasonable.

> By making the TRNG compile-time selectable, I was hoping to serve all use=
rs: I
> wanted to cover the conclusions of the discussion to remove the blocking_=
pool.
> On the other hand, however, I want to support requirements that need the
> blocking behavior.

I find it odd that /dev/random would be either a TRNG or not a TRNG
depending on kernel configuration.  For the small fraction of users
that actually want a TRNG, wouldn't it be better to have an interface
that fails outright if the TRNG is not enabled?

--Andy
