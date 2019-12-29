From: "Theodore Y. Ts'o" <tytso@mit.edu>
Subject: Re: [PATCH v3 0/8] Rework random blocking
Date: Sun, 29 Dec 2019 09:49:04 -0500
Message-ID: <20191229144904.GB7177@mit.edu>
References: <20191226140423.GB3158@mit.edu>
 <4048434.Q8HajmOrkZ@tauon.chronox.de>
 <20191227130436.GC70060@mit.edu>
 <15817620.rmTN4T87Wr@tauon.chronox.de>
 <20191227220857.GD70060@mit.edu>
 <CALCETrUyVx_qb2yYH8D_z1T2bVu5RAEr71G0MTzEksBKKM1QsA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CALCETrUyVx_qb2yYH8D_z1T2bVu5RAEr71G0MTzEksBKKM1QsA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Andy Lutomirski <luto@kernel.org>
Cc: Stephan Mueller <smueller@chronox.de>, LKML <linux-kernel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, Kees Cook <keescook@chromium.org>, "Jason A. Donenfeld" <Jason@zx2c4.com>, "Ahmed S. Darwish" <darwish.07@gmail.com>, Lennart Poettering <mzxreary@0pointer.de>, "Eric W. Biederman" <ebiederm@xmission.com>, "Alexander E. Patrakov" <patrakov@gmail.com>, Michael Kerrisk <mtk.manpages@gmail.com>, Willy Tarreau <w@1wt.eu>, Matthew Garrett <mjg59@srcf.ucam.org>, Ext4 Developers List <linux-ext4@vger.kernel.org>, linux-man <linux-man@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Fri, Dec 27, 2019 at 06:06:56PM -0800, Andy Lutomirski wrote:
> 
> I'm thinking of having a real class device and chardev for each hwrng
> device.  Authentication is entirely in userspace: whatever user code
> is involved can look at the sysfs hierarchy and decide to what extent
> it trusts a given source.  This could be done based on bus topology or
> based on anything else.

Yes, that's what I was thinking.  Another project on my "when I can
get a round tuit" list is to change how drivers/char/random.c taps
into the hwrng devices, mixing in a bit from each of these devies in a
round-robin fashion, instead of just feeding from a single hwrng.

> The kernel could also separately expose various noise sources, and the
> user code can do whatever it wants with them.  But these should be
> explicitly unconditioned, un-entropy-extracted sources -- user code
> can run its favorite algorithm to extract something it believes to be
> useful.  The only conceptually tricky bit is keeping user code like
> this from interfering with the in-kernel RNG.

The other problem is the unconditioned values of the noise sources may
leak unacceptable amounts of information about system operation.  The
most obvious example of this would be keyboard and mouse sources,
where today we mix in not only the timing information, but the actual
input values (e.g., the keyboard scancodes) into the entropy pool.
Exposing this to userspace, even if it is via a privileged system
call, would be... unwise.

						- Ted
