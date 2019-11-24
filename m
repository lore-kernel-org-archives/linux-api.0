From: Sandy Harris <sandyinchina@gmail.com>
Subject: Re: [PATCH v24 01/12] Linux Random Number Generator
Date: Sun, 24 Nov 2019 12:51:19 +0800
Message-ID: <CACXcFmkBQAZd4bSfQvqeCsoTjMr0-uSjKciD6y9EkMN3c9ppJw@mail.gmail.com>
References: <6157374.ptSnyUpaCn@positron.chronox.de> <2369119.jSEA3qhmGI@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <2369119.jSEA3qhmGI@positron.chronox.de>
Sender: linux-kernel-owner@vger.kernel.org
To: =?UTF-8?Q?Stephan_M=C3=BCller?= <smueller@chronox.de>
Cc: Arnd Bergmann <arnd@arndb.de>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Linux Crypto Mailing List <linux-crypto@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, linux-api@vger.kernel.org, "Eric W. Biederman" <ebiederm@xmission.com>, "Alexander E. Patrakov" <patrakov@gmail.com>, "Ahmed S. Darwish" <darwish.07@gmail.com>, "Theodore Y. Ts'o" <tytso@mit.edu>, Willy Tarreau <w@1wt.eu>, Matthew Garrett <mjg59@srcf.ucam.org>, Vito Caputo <vcaputo@pengaru.com>, Andreas Dilger <adilger.kernel@dilger.ca>, Jan Kara <jack@suse.cz>, Ray Strode <rstrode@redhat.com>, William Jon McCann <mccann@jhu.edu>, zhangjs <zachary@baishancloud.com>, Andy Lutomirski <luto@kernel.org>, Florian Weimer <fweimer@redhat.com>, Lennart Poettering <mzxreary@0pointer.de>
List-Id: linux-api@vger.kernel.org

Stephan M=C3=BCller <smueller@chronox.de> wrote:

> In an effort to provide a flexible implementation for a random number
> generator that also ...

As usual, some of your proposals make considerable sense to me &
others do not, at least on first reading. I may have more comments
after reflecting some.

Meanwhile, a couple of things jump out at me:

>  (a) When an interrupt occurs, the high-resolution time stamp is mixed
> into the LFSR. ...
>
>  (b) HID event data like the key stroke or the mouse coordinates are
> mixed into the LFSR. ...
>
>  (c) Device drivers may provide data that is mixed into the LFSR. ...

Why into the LFSR instead of into the entropy pool?

> The LRNG allows the TRNG and secondary DRNG mechanism to be changed
> at runtime.

Why? This strikes me as pointless complication.

> * high performance of interrupt handling code: The LRNG impact on the
> interrupt handling has been reduced to a minimum. On one example
> system, the LRNG interrupt handling code executes within an average
> of 65 cycles whereas the existing /dev/random on the same device
> takes about 97 cycles when measuring the execution time of
> add_interrupt_randomness().

Assuming you do this without sacrificing the input mixing, this
would be worth submitting as a separate patch. Saving cycles
on every interrupt definitely looks worth doing.

> * lockless LFSR to collect raw entropy

This too.
