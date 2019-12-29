From: Andy Lutomirski <luto@amacapital.net>
Subject: Re: [PATCH v3 0/8] Rework random blocking
Date: Sun, 29 Dec 2019 23:08:50 +0800
Message-ID: <AA6F6C68-CC2E-45ED-974D-1667769AF679@amacapital.net>
References: <20191229144904.GB7177@mit.edu>
Mime-Version: 1.0 (1.0)
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20191229144904.GB7177@mit.edu>
Sender: linux-kernel-owner@vger.kernel.org
To: "Theodore Y. Ts'o" <tytso@mit.edu>
Cc: Andy Lutomirski <luto@kernel.org>, Stephan Mueller <smueller@chronox.de>, LKML <linux-kernel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, Kees Cook <keescook@chromium.org>, "Jason A. Donenfeld" <Jason@zx2c4.com>, "Ahmed S. Darwish" <darwish.07@gmail.com>, Lennart Poettering <mzxreary@0pointer.de>, "Eric W. Biederman" <ebiederm@xmission.com>, "Alexander E. Patrakov" <patrakov@gmail.com>, Michael Kerrisk <mtk.manpages@gmail.com>, Willy Tarreau <w@1wt.eu>, Matthew Garrett <mjg59@srcf.ucam.org>, Ext4 Developers List <linux-ext4@vger.kernel.org>, linux-man <linux-man@vger.kernel.org>
List-Id: linux-api@vger.kernel.org



> On Dec 29, 2019, at 10:49 PM, Theodore Y. Ts'o <tytso@mit.edu> wrote:
>=20
> =EF=BB=BFOn Fri, Dec 27, 2019 at 06:06:56PM -0800, Andy Lutomirski wrote:
>>=20
>> I'm thinking of having a real class device and chardev for each hwrng
>> device.  Authentication is entirely in userspace: whatever user code
>> is involved can look at the sysfs hierarchy and decide to what extent
>> it trusts a given source.  This could be done based on bus topology or
>> based on anything else.
>=20
> Yes, that's what I was thinking.  Another project on my "when I can
> get a round tuit" list is to change how drivers/char/random.c taps
> into the hwrng devices, mixing in a bit from each of these devies in a
> round-robin fashion, instead of just feeding from a single hwrng.
>=20
>> The kernel could also separately expose various noise sources, and the
>> user code can do whatever it wants with them.  But these should be
>> explicitly unconditioned, un-entropy-extracted sources -- user code
>> can run its favorite algorithm to extract something it believes to be
>> useful.  The only conceptually tricky bit is keeping user code like
>> this from interfering with the in-kernel RNG.
>=20
> The other problem is the unconditioned values of the noise sources may
> leak unacceptable amounts of information about system operation.  The
> most obvious example of this would be keyboard and mouse sources,
> where today we mix in not only the timing information, but the actual
> input values (e.g., the keyboard scancodes) into the entropy pool.
> Exposing this to userspace, even if it is via a privileged system
> call, would be... unwise.
>=20
>         =20

Hmm. We could give only the timing.

We could also say that the official interface for this is to use tracepoints=
 and punt everything into userspace.=
