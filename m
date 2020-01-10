From: Stephan Mueller <smueller-T9tCv8IpfcWELgA04lAiVw@public.gmane.org>
Subject: Re: [PATCH v3 0/8] Rework random blocking
Date: Fri, 10 Jan 2020 08:53:54 +0100
Message-ID: <7629501.YrHEAiJyVJ@tauon.chronox.de>
References: <20191226140423.GB3158@mit.edu> <20200109224011.GD41242@mit.edu> <20200109230237.GA2992@roeckx.be>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-man-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20200109230237.GA2992-burXGKnpAKGzQB+pC5nmwQ@public.gmane.org>
Sender: linux-man-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Kurt Roeckx <kurt-burXGKnpAKGzQB+pC5nmwQ@public.gmane.org>
Cc: "Theodore Y. Ts'o" <tytso-3s7WtUTddSA@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, "Jason A. Donenfeld" <Jason-OnJsPKxuuEcAvxtiuMwx3w@public.gmane.org>, "Ahmed S. Darwish" <darwish.07-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Lennart Poettering <mzxreary-uLTowLwuiw4b1SvskN2V4Q@public.gmane.org>, "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, "Alexander E. Patrakov" <patrakov-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Willy Tarreau <w@1wt.eu>, Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>, Ext4 Developers List <linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-man <linux-man-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Am Freitag, 10. Januar 2020, 00:02:37 CET schrieb Kurt Roeckx:

Hi Kurt,

> On Thu, Jan 09, 2020 at 05:40:11PM -0500, Theodore Y. Ts'o wrote:
> > On Thu, Jan 09, 2020 at 11:02:30PM +0100, Kurt Roeckx wrote:
> > > One thing the NIST DRBGs have is prediction resistance, which is
> > > done by reseeding. If you chain DRBGs, you tell your parent DRBG
> > > that you want prediction resistance, so your parent will also
> > > reseed. There currently is no way to tell the kernel to reseed.
> > 
> > It would be simple enough to add a new flag, perhaps GRND_RESEED, to
> > getrandom() which requests that the kernel reseed first.  This would
> > require sufficient amounts of entropy in the input pool to do the
> > reseed; if there is not enough, the getrandom() call would block until
> > there was enough.  If GRND_NONBLOCK is supplied, then getrandom()
> > would return EAGAIN if there wasn't sufficient entropy.
> > 
> > Is this what you want?
> 
> I think some people might want to see it, but I think you
> shouldn't add it.

Just for your information: I played with that already as seen in [1] which 
does not require any kernel change.

The only issue that is currently there are the two races noted in [1]. These 
races seem to be only addressable when the reseeding and the gathering of 
random numbers are atomic. I was toying with the idea that the RNDRESEEDCRNG 
allows the user to specify an output buffer which would be filled in an atomic 
operation when the reseed is invoked. That buffer should only be at most in 
size of the security strength of the DRNG.

[1] https://github.com/smuellerDD/lrng/blob/master/test/syscall_test.c#L101
> 
> > > I don't think we want that. As far as I know, the only reason for
> > > using /dev/random is that /dev/urandom returns data before it
> > > has sufficient entropy.
> > 
> > Is there any objections to just using getrandom(2)?
> 
> It provides the interface we want, so no. But there are still
> people who don't have it for various reasons. OpenSSL actually
> does the system call itself if libc doesn't provider a wrapper for
> it.
> 
> 
> Kurt



Ciao
Stephan
