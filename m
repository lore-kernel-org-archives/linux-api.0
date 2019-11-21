From: Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
Subject: Re: [PATCH v25 10/12] LRNG - add TRNG support
Date: Thu, 21 Nov 2019 14:06:03 +0100
Message-ID: <5032854.qLNvD48x4y@positron.chronox.de>
References: <5390778.VeFRgus4bQ@positron.chronox.de> <1695782.oZ5Vf4nH9s@positron.chronox.de> <20191120203232.GB3109949@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20191120203232.GB3109949@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Andy Lutomirski <luto@kernel.org>, Arnd Bergmann <arnd@arndb.de>, Linux Crypto Mailing List <linux-crypto@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, "Eric W. Biederman" <ebiederm@xmission.com>, "Alexander E. Patrakov" <patrakov@gmail.com>, "Ahmed S. Darwish" <darwish.07@gmail.com>, "Theodore Y. Ts'o" <tytso@mit.edu>, Willy Tarreau <w@1wt.eu>, Matthew Garrett <mjg59@srcf.ucam.org>, Vito Caputo <vcaputo@pengaru.com>, Andreas Dilger <adilger.kernel@dilger.ca>, Jan Kara <jack@suse.cz>, Ray Strode <rstrode@redhat.com>, William Jon McCann <mccann@jhu.edu>, zhangjs <zachary@baishancloud.com>, Florian Weimer <fweimer@redhat.com>, Lennart Poettering <mzxreary@0pointer.de>, Nicolai Stange <nstange@suse.de>P
List-Id: linux-api@vger.kernel.org

Am Mittwoch, 20. November 2019, 21:32:32 CET schrieb Greg Kroah-Hartman:

Hi Greg,

> No, do not abuse sysfs or procfs for something like this.  Use a real
> syscall please if you really need it.

You are right.

Ok, let us get back to the drawing board. What are our requirements? We need 
to have an interface for the TRNG that should ensure other users of entropy 
are not starved by unprivileged users.

What about the following: we use the getrandom(2) system call and add 
GRND_TRUERANDOM as already indicated. However, there is one more caveat we 
would add:

- if the caller of GRND_TRUERANDOM is !CAP_SYS_ADMIN the entropy pool can only 
be depleted to the point where at least one or two full seeding operations 
worth of entropy is left.

- if the caller of GRND_TRUERANDOM is CAP_SYS_ADMIN, the entropy can be 
depleted completely

At runtime, the LRNG would then behave like the following:

- calling getrandom(..., 0), /dev/random or /dev/urandom would deplete the 
entropy pool during reseeding operations but leaving an emergency level of 512 
bits of entropy in the pool. If equal or less are in the pool, reseeding would 
be skipped.

- calling getrandom(..., GRND_TRUERANDOM) with CAP_SYS_ADMIN allows the 
entropy pool to be fully depleted.

- calling getrandom(..., GRND_TRUERANDOM) without CAP_SYS_ADMIN allows the 
entropy pool to be depleted down to 1024 bits of entropy. If the pool has 
equal or less, the caller is blocked. This allows the DRNG feeding /dev/
random, /dev/urandom or getrandom(..., 0) with 512 bits of entropy (i.e. two 
reseed operations are possible). Only if the entropy pool has more than 1024 
bits of entropy, the getrandom call would unblock and provide data.

With that approach, I think we can honor the request from Greg to not add any 
new interface and yet honor the note from Alexander to not allow unprivileged 
user space to deplete the entropy pool to the extent that other users of 
entropy are too much affected.

If GRND_TRUERANDOM is not implemented, EOPNOTSUPP is returned.

Thank you.

Ciao
Stephan
