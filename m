From: "Theodore Y. Ts'o" <tytso@mit.edu>
Subject: Re: [PATCH 0/7] Rework random blocking
Date: Thu, 29 Aug 2019 21:49:06 -0400
Message-ID: <20190830014906.GD10779@mit.edu>
References: <cover.1567126741.git.luto@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <cover.1567126741.git.luto@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Andy Lutomirski <luto@kernel.org>
Cc: Theodore Tso <tytso@google.com>, LKML <linux-kernel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, Kees Cook <keescook@chromium.org>, "Jason A. Donenfeld" <Jason@zx2c4.com>
List-Id: linux-api@vger.kernel.org

On Thu, Aug 29, 2019 at 06:11:35PM -0700, Andy Lutomirski wrote:
> This series also removes the blocking pool and makes /dev/random
> work just like getentropy(..., 0) and makes GRND_RANDOM a no-op.  I
> believe that Linux's blocking pool has outlived its usefulness.
> Linux's CRNG generates output that is good enough to use even for
> key generation.  The blocking pool is not stronger in any material
> way, and keeping it around requires a lot of infrastructure of
> dubious value.

It's too late for the 5.4 cycle for a change of this magnitude, and
I'd just as soon let this wait until *after* the LTS kernel gets cut.
The reason for this is because at the moment, there are some PCI
compliance labs who believe that the "true randomness" of /dev/random
is necessary for PCI compliance and so they mandate the use of
/dev/random over /dev/urandom's "cryptographic randomness" for that
reason.  A lot of things which are thought to be needed for PCI
compliance that are about as useful as eye of newt and toe of frog,
but nothing says that PCI compliance (and enterprise customer
requirements :-) have to make sense.

It may be that what we might need to really support people (or stupid
compliance labs) who have a fetish for "true randomness" to get a
better interface for hardware random number generators than
/dev/hwrng.  Specifically, one which allows for a more sane way of
selecting which hardware random number generator to use if there are
multiple available, and also one where we mix in some CRNG as a
whitening step just case the hardware number generator is busted in
some way.  (And to fix the issue that at the moment, if someone evil
fakes up a USB device with the USB manufacturer and minor device
number for a ChosKey device that generates a insecure sequence, it
will still get blindly trusted by the kernel without any kind of
authentication of said hardware device.)

That probably means we need to come up with a new interface than
/dev/hwrng, or have some way of configuring /dev/random to use a
hardware RNG device for those people who really care about "true
randomness".  The current /dev/hwrng interface and how it is
configured via sysfs is pretty baroque IMO.

	      	  	     	       	  	 - Ted
