From: Kurt Roeckx <kurt-burXGKnpAKGzQB+pC5nmwQ@public.gmane.org>
Subject: Re: [PATCH v3 0/8] Rework random blocking
Date: Thu, 9 Jan 2020 23:02:30 +0100
Message-ID: <20200109220230.GA39185@roeckx.be>
References: <20191226140423.GB3158@mit.edu>
 <4048434.Q8HajmOrkZ@tauon.chronox.de>
 <20191227130436.GC70060@mit.edu>
 <15817620.rmTN4T87Wr@tauon.chronox.de>
 <20191227220857.GD70060@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-man-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20191227220857.GD70060-3s7WtUTddSA@public.gmane.org>
Sender: linux-man-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Theodore Y. Ts'o" <tytso-3s7WtUTddSA@public.gmane.org>
Cc: Stephan Mueller <smueller-T9tCv8IpfcWELgA04lAiVw@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, "Jason A. Donenfeld" <Jason-OnJsPKxuuEcAvxtiuMwx3w@public.gmane.org>, "Ahmed S. Darwish" <darwish.07-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Lennart Poettering <mzxreary-uLTowLwuiw4b1SvskN2V4Q@public.gmane.org>, "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, "Alexander E. Patrakov" <patrakov-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Willy Tarreau <w@1wt.eu>, Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>, Ext4 Developers List <linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-man <linux-man-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Fri, Dec 27, 2019 at 05:08:57PM -0500, Theodore Y. Ts'o wrote:
> On Fri, Dec 27, 2019 at 10:22:23PM +0100, Stephan Mueller wrote:
> > > So let's take a step back and ask the question: "Exactly what _value_
> > > do you want to provide by creating some kind of true random
> > > interface?"  What does this enable?  What applications does this
> > > really help?
> > 
> > There are simply cryptographers who have use cases for such random numbers. 
> > The core use case is to seed other DRNGs and avoiding the chaining of free-
> > running DRNGs.
> 
> For this very specialized use case, what I think the kernel should
> provide is maximal transparency; that is, given the DRBG direct access
> to the TPM's random number generator, or direct access to the
> ChaosKey, and the userspace DRBG should be able to get a list of the
> various hardware RNG's, and select one, with the characterization
> being done userspace, not in the kernel.

One thing the NIST DRBGs have is prediction resistance, which is
done by reseeding. If you chain DRBGs, you tell your parent DRBG
that you want prediction resistance, so your parent will also
reseed. There currently is no way to tell the kernel to reseed.

This reseed option might be something that some people would like
to see. If such an option is added, I expect that the kernel might
block until it has gotten enough new entropy from it's entropy
sources. But I don't actually see a need to add such an option.

If the kernel provides a good RNG, the only reason I can see why
you would like to have direct access to a hwrng is to verify that
it's working correctly. That might mean that you put it in some
special mode where it returns raw unprocessed values. If the device
is in such a mode, it's output will not provide the same entropy
per bit, and so I would expect the kernel to stop using it directly.

I guess there might be people who would like to use it directly,
but I think we should instead encourage them kernel RNG.

> You can talk about providing tools that try to make these estimations
> --- but these sorts of things would have to be done on each user's
> hardware, and for most distro users, it's just not practical.

I would check my own hardware if such an option was available. I
think it can be useful to see if the current estimates in the
kernel are conservative enough or not. But it would require that
you can know what the entropy source is, like the keyboard or
harddisk.

> So if it's just for cryptographers, then let it all be done in
> userspace, and let's not make it easy for GPG, OpenSSL, etc., to all
> say, "We want TrueRandom(tm); we won't settle for less".

I don't think we want that. As far as I know, the only reason for
using /dev/random is that /dev/urandom returns data before it
has sufficient entropy.


Kurt
