From: "Theodore Y. Ts'o" <tytso@mit.edu>
Subject: Re: [PATCH v3 0/8] Rework random blocking
Date: Thu, 26 Dec 2019 09:04:23 -0500
Message-ID: <20191226140423.GB3158@mit.edu>
References: <9872655.prSdhymlXK@positron.chronox.de>
 <888017FA-06A1-42EF-9FC0-46629138DA9E@amacapital.net>
 <4820831.xlnk3tY4r2@tauon.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4820831.xlnk3tY4r2@tauon.chronox.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Stephan Mueller <smueller@chronox.de>
Cc: Andy Lutomirski <luto@amacapital.net>, Andy Lutomirski <luto@kernel.org>, LKML <linux-kernel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, Kees Cook <keescook@chromium.org>, "Jason A. Donenfeld" <Jason@zx2c4.com>, "Ahmed S. Darwish" <darwish.07@gmail.com>, Lennart Poettering <mzxreary@0pointer.de>, "Eric W. Biederman" <ebiederm@xmission.com>, "Alexander E. Patrakov" <patrakov@gmail.com>, Michael Kerrisk <mtk.manpages@gmail.com>, Willy Tarreau <w@1wt.eu>, Matthew Garrett <mjg59@srcf.ucam.org>, Ext4 Developers List <linux-ext4@vger.kernel.org>, linux-man <linux-man@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Thu, Dec 26, 2019 at 01:03:34PM +0100, Stephan Mueller wrote:
> Agreed. I was just trying to outline that the removal of the blocking_pool is 
> a good thing. Even when we decide that random.c should receive a TRNG, we do 
> not need to re-add a blocking pool, but can easily use the existing ChaCha20 
> DRNG (most likely with its own instance).

Well, it depends on what you mean by "TRNG" --- the ChaCha20 DRNG only
has a state of 256 bits.  So if you want to only depend on "true
entropy" you can't extract more than 256 bits without violating that
assumption, at least if you're using a very strict definition of TRNG.

By getting rid of the blocking pool, and making /dev/random work like
getrandom with flags set to 0, we're effectively abandoning any kind
of assertion that /dev/random is some kind of TRNG.  This is not
insane; this is what the *BSD's have always done.

But once we do this, and /dev/random takes on the semantics of "block
until the CRNG has been initialized, and then it won't block after
that", if we change it so that it now has some different semantics,
such as "one you extract a 256-bit key, the read from /dev/random will
block until we can refill it, which might take seconds, minutes or
hours", will be considered a regression, and we can't do that.

Of course, we can hope that people will be using getrandom() and there
will be very few new users of the /dev/random pathname.  But nothing
is ever guaranteed..

						- Ted
