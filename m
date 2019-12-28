From: Andy Lutomirski <luto@kernel.org>
Subject: Re: [PATCH v3 0/8] Rework random blocking
Date: Fri, 27 Dec 2019 18:06:56 -0800
Message-ID: <CALCETrUyVx_qb2yYH8D_z1T2bVu5RAEr71G0MTzEksBKKM1QsA@mail.gmail.com>
References: <20191226140423.GB3158@mit.edu> <4048434.Q8HajmOrkZ@tauon.chronox.de>
 <20191227130436.GC70060@mit.edu> <15817620.rmTN4T87Wr@tauon.chronox.de> <20191227220857.GD70060@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20191227220857.GD70060@mit.edu>
Sender: linux-kernel-owner@vger.kernel.org
To: "Theodore Y. Ts'o" <tytso@mit.edu>
Cc: Stephan Mueller <smueller@chronox.de>, Andy Lutomirski <luto@kernel.org>, LKML <linux-kernel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, Kees Cook <keescook@chromium.org>, "Jason A. Donenfeld" <Jason@zx2c4.com>, "Ahmed S. Darwish" <darwish.07@gmail.com>, Lennart Poettering <mzxreary@0pointer.de>, "Eric W. Biederman" <ebiederm@xmission.com>, "Alexander E. Patrakov" <patrakov@gmail.com>, Michael Kerrisk <mtk.manpages@gmail.com>, Willy Tarreau <w@1wt.eu>, Matthew Garrett <mjg59@srcf.ucam.org>, Ext4 Developers List <linux-ext4@vger.kernel.org>, linux-man <linux-man@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Fri, Dec 27, 2019 at 2:09 PM Theodore Y. Ts'o <tytso@mit.edu> wrote:

> So if it's just for cryptographers, then let it all be done in
> userspace, and let's not make it easy for GPG, OpenSSL, etc., to all
> say, "We want TrueRandom(tm); we won't settle for less".  We can talk
> about how do we provide the interfaces so that those cryptographers
> can get the information they need so they can get access to the raw
> noise sources, separated out and named, and with possibly some way
> that the noise source can authenticate itself to the Cryptographer's
> userspace library/application.
>
> But all of this should probably not be in drivers/char/random.c, and
> we probably need to figure out a better kernel to userspace interface
> than what we have with /dev/hwrng.

I'm thinking of having a real class device and chardev for each hwrng
device.  Authentication is entirely in userspace: whatever user code
is involved can look at the sysfs hierarchy and decide to what extent
it trusts a given source.  This could be done based on bus topology or
based on anything else.

The kernel could also separately expose various noise sources, and the
user code can do whatever it wants with them.  But these should be
explicitly unconditioned, un-entropy-extracted sources -- user code
can run its favorite algorithm to extract something it believes to be
useful.  The only conceptually tricky bit is keeping user code like
this from interfering with the in-kernel RNG.

--Andy
