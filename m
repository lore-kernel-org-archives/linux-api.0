From: Andy Lutomirski <luto@kernel.org>
Subject: Re: [PATCH 0/7] Rework random blocking
Date: Mon, 9 Sep 2019 15:57:46 -0700
Message-ID: <CALCETrXfDSjgNieM3Q9bVH-7gAePXT=SXWxvzOsyb8xp_2ymQA@mail.gmail.com>
References: <cover.1567126741.git.luto@kernel.org> <20190909094230.GB27626@amd>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190909094230.GB27626@amd>
Sender: linux-kernel-owner@vger.kernel.org
To: Pavel Machek <pavel@ucw.cz>
Cc: Andy Lutomirski <luto@kernel.org>, Theodore Tso <tytso@google.com>, LKML <linux-kernel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, Kees Cook <keescook@chromium.org>, "Jason A. Donenfeld" <Jason@zx2c4.com>
List-Id: linux-api@vger.kernel.org

On Mon, Sep 9, 2019 at 2:42 AM Pavel Machek <pavel@ucw.cz> wrote:
>
> On Thu 2019-08-29 18:11:35, Andy Lutomirski wrote:
> > This makes two major semantic changes to Linux's random APIs:
> >
> > It adds getentropy(..., GRND_INSECURE).  This causes getentropy to
> > always return *something*.  There is no guarantee whatsoever that
> > the result will be cryptographically random or even unique, but the
> > kernel will give the best quality random output it can.  The name is
> > a big hint: the resulting output is INSECURE.
> >
> > The purpose of this is to allow programs that genuinely want
> > best-effort entropy to get it without resorting to /dev/urandom.
> > Plenty of programs do this because they need to do *something*
> > during boot and they can't afford to wait.  Calling it "INSECURE" is
> > probably the best we can do to discourage using this API for things
> > that need security.
> >
> > This series also removes the blocking pool and makes /dev/random
> > work just like getentropy(..., 0) and makes GRND_RANDOM a no-op.  I
> > believe that Linux's blocking pool has outlived its usefulness.
> > Linux's CRNG generates output that is good enough to use even for
> > key generation.  The blocking pool is not stronger in any material
> > way, and keeping it around requires a lot of infrastructure of
> > dubious value.
>
> Could you give some more justification? If crng is good enough for
> you, you can use /dev/urandom...

Take a look at the diffstat.  The random code is extremely security
sensitive, and it's made considerably more complicated by the need to
support the blocking semantics for /dev/random.  My primary argument
is that there is no real reason for the kernel to continue to support
it.

>
>
> are
>
> > This series should not break any existing programs.  /dev/urandom is
> > unchanged.  /dev/random will still block just after booting, but it
> > will block less than it used to.  getentropy() with existing flags
> > will return output that is, for practical purposes, just as strong
> > as before.
>
> So what is the exact semantic of /dev/random after your change?

Reads return immediately if the CRNG is initialized, i.e reads return
immediately if and only if getentropy(..., 0) would succeed.
Otherwise reads block.

--Andy
