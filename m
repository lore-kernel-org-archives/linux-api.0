From: Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
Subject: Re: [PATCH v24 00/12] /dev/random - a new approach with full SP800-90B compliance
Date: Wed, 13 Nov 2019 13:16:36 +0100
Message-ID: <4999435.M7Dy0bkext@positron.chronox.de>
References: <6157374.ptSnyUpaCn@positron.chronox.de> <3208655.cZiRAY37Id@positron.chronox.de> <CALCETrVHdauN2ptZLSYAUDm=S3OGkxq=iH4qGxCuH0XCMKjGkQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CALCETrVHdauN2ptZLSYAUDm=S3OGkxq=iH4qGxCuH0XCMKjGkQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Andy Lutomirski <luto@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Linux Crypto Mailing List <linux-crypto@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, "Eric W. Biederman" <ebiederm@xmission.com>, "Alexander E. Patrakov" <patrakov@gmail.com>, "Ahmed S. Darwish" <darwish.07@gmail.com>, "Theodore Y. Ts'o" <tytso@mit.edu>, Willy Tarreau <w@1wt.eu>, Matthew Garrett <mjg59@srcf.ucam.org>, Vito Caputo <vcaputo@pengaru.com>, Andreas Dilger <adilger.kernel@dilger.ca>, Jan Kara <jack@suse.cz>, Ray Strode <rstrode@redhat.com>, William Jon McCann <mccann@jhu.edu>, zhangjs <zachary@baishancloud.com>, Florian Weimer <fweimer@redhat.com>, Lennart Poettering <mzxreary@0pointer.de>, Nicolai Stange <nstang>
List-Id: linux-api@vger.kernel.org

Am Mittwoch, 13. November 2019, 05:48:30 CET schrieb Andy Lutomirski:

Hi Andy,

> 
> > - 6a26a3146e5fb90878dca9fde8caa1ca4233156a: My handler for /dev/urandom
> > and
> > getrandom(..., 0) are using one callback which issues a warning in both
> > use
> > cases (see lrng_sdrng_read). So I think this patch may not be applicable
> > as
> > the LRNG code implements warning about being unseeded.
> 
> Probably true.
> 
> What is the actual semantics of /dev/urandom with your series applied?
>  Is there any situation in which it will block?

The LRNG tries to provide a 100% identical user interface to the existing /
dev/random:

- /dev/urandom never blocks

- getrandom(..., 0) blocks until the LRNG has received 256 bits of entropy 
(i.e. the LRNG is fully seeded)

Yet, both may issue a warning if CONFIG_WARN_ALL_UNSEEDED_RANDOM is set.
> 
> > - 3e8e159da49b44ae0bb08e68fa2be760722fa033: I am happy to take that code
> > which would almost directly apply. The last hunk however would be:
> > 
> > if (!(flags & GRND_INSECURE) && unlikely(!lrng_state_operational())) {
> > 
> > ==> Shall I apply it to my code base? If yes, how shall the changes to
> > random.h be handled?
> 
> This might be a question for Ted.  Once the merge window opens, I'll
> resubmit it.

Ok, I will keep it out of the LRNG for now, but once your patch is merged, I 
would integrate it.
> 
> > - 920e97e7fc508e6f0da9c7dec94c8073fd63ab4d: I would pass on this patch due
> > to the following: it unconditionally starts removing the access to the
> > TRNG (the LRNG's logical equivalent to the blocking_pool). As patch 10/12
> > of the LRNG patch series provides the TRNG that is a compile time option,
> > your patch would logically and functionally be equivalent when
> > deselecting
> > CONFIG_LRNG_TRNG_SUPPORT in the LRNG without any further changes to the
> > LRNG code.
> 
> Given your previous email about the TRNG, I'm wondering what the API
> for the TRNG should be.  I am willing to grant that there are users
> who need a TRNG for various reasons, and that not all of them can use
> hwrng.  (And the current hwrng API is pretty bad.)  But I'm not
> convinced that /dev/random or getrandom(..., GRND_RANDOM) is a
> reasonable way to access it.  A blocking_pool-style TRNG is a very
> limited resource, and I think it could make sense to require some sort
> of actual permission to use it.  GRND_RANDOM has no access control at
> all, and everyone expects /dev/random to be world-readable.  The most
> widespread user of /dev/random that I know of is gnupg, and gnupg
> really should not be using it.
> 
> Would it make sense to have a /dev/true_random that is 0400 by default
> for users who actually need it?  Then /dev/random and GRND_RANDOM
> could work as they do with my patch, and maybe it does the right thing
> for everyone.

That is surely a reasonable way to do it. But I am not sure 0400 should be 
applied, but rather 0440. This should allow introducing a group in user space 
that processes who need the TRNG are not required to have root privilege, but 
rather need to be a member of some otherwise unprivileged group.
> 
> > - 693b9ffdf0fdc93456b5ad293ac05edf240a531b: This patch is applicable to
> > the
> > LRNG. In case CONFIG_LRNG_TRNG_SUPPORT is not set, the TRNG is not
> > present.
> > Yet, the /dev/random and getrandom(GRND_RANDOM) would behave blocked until
> > fully initialized. I have now added the general blocking until the LRNG is
> > fully initialized to the common /dev/random and getrandom(GRND_RANDOM)
> > interface function of lrng_trng_read_common. With that, the LRNG would be
> > fully equivalent to this patch if CONFIG_LRNG_TRNG_SUPPORT is not set.
> 
> Sounds reasonable.
> 
> > By making the TRNG compile-time selectable, I was hoping to serve all
> > users: I wanted to cover the conclusions of the discussion to remove the
> > blocking_pool. On the other hand, however, I want to support requirements
> > that need the blocking behavior.
> 
> I find it odd that /dev/random would be either a TRNG or not a TRNG
> depending on kernel configuration.  For the small fraction of users
> that actually want a TRNG, wouldn't it be better to have an interface
> that fails outright if the TRNG is not enabled?

Sure, I would have no concerns here.

> 
> --Andy


Ciao
Stephan
