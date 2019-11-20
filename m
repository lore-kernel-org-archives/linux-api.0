From: Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
Subject: Re: [PATCH v25 10/12] LRNG - add TRNG support
Date: Wed, 20 Nov 2019 09:58:35 +0100
Message-ID: <19681012.svDddlc5pN@positron.chronox.de>
References: <5390778.VeFRgus4bQ@positron.chronox.de> <CALCETrUKDO1LSMnHNcPiAFQh2ri6saRiRBi9b5e699cm1_Mgsw@mail.gmail.com> <20191119124150.GB1975017@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20191119124150.GB1975017@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Andy Lutomirski <luto@kernel.org>, Arnd Bergmann <arnd@arndb.de>, Linux Crypto Mailing List <linux-crypto@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, "Eric W. Biederman" <ebiederm@xmission.com>, "Alexander E. Patrakov" <patrakov@gmail.com>, "Ahmed S. Darwish" <darwish.07@gmail.com>, "Theodore Y. Ts'o" <tytso@mit.edu>, Willy Tarreau <w@1wt.eu>, Matthew Garrett <mjg59@srcf.ucam.org>, Vito Caputo <vcaputo@pengaru.com>, Andreas Dilger <adilger.kernel@dilger.ca>, Jan Kara <jack@suse.cz>, Ray Strode <rstrode@redhat.com>, William Jon McCann <mccann@jhu.edu>, zhangjs <zachary@baishancloud.com>, Florian Weimer <fweimer@redhat.com>, Lennart Poettering <mzxreary@0pointer.de>, Nicolai Stange <nstange@suse.de>P
List-Id: linux-api@vger.kernel.org

Am Dienstag, 19. November 2019, 13:41:50 CET schrieb Greg Kroah-Hartman:

Hi Greg,

> On Tue, Nov 19, 2019 at 02:07:40AM -0800, Andy Lutomirski wrote:
> > > As this would introduce a new device file now, is there a special
> > > process that I need to follow or do I need to copy? Which major/minor
> > > number should I use?
> > > 
> > > Looking into static const struct memdev devlist[] I see
> > > 
> > >          [8] = { "random", 0666, &random_fops, 0 },
> > >          [9] = { "urandom", 0666, &urandom_fops, 0 },
> > > 
> > > Shall a true_random be added here with [10]?
> > 
> > I am not at all an expert on chardevs, but this sounds generally
> > reasonable.  gregkh is probably the real authority here.
> 
> [10] is the aio char device node, so you better not try to overlap it or
> bad things will happen :(

Thanks for your insights.

Which device minor number could we use?

Or another idea and apologies if I restart this conversation as there was 
already a discussion around it: what about extending the getrandom(2) call 
instead of adding a device file?

What about adding yet another flag to getrandom: GRND_TRUERANDOM and process 
it as follows:

        if (flags & ~(GRND_NONBLOCK|GRND_RANDOM|GRND_INSECURE|
GRND_TRUERANDOM))
                return -EINVAL;

        //From Andy's tree
        /*
         * Requesting insecure and blocking randomness at the same time makes
         * no sense.
         */
        if ((flags & (GRND_INSECURE|GRND_RANDOM)) == (GRND_INSECURE|
GRND_RANDOM))
                return -EINVAL;

	  /* We only allow GRND_TRUERANDOM by itself or with NONBLOCK */
	  if (! ((flags & GRND_TRUERANDOM) &&
               ((flags == GRND_TRUERANDOM) ||
                (flags == GRND_TRUERANDOM | GRND_NONBLOCK))))
		return -EINVAL;

	if (flags & GRND_TRUERANDOM) {
		... do the TRNG processing ...
		... may return -ENOPNOTSUPP if no TRNG available ...
	}

Thanks a lot.


Ciao
Stephan
