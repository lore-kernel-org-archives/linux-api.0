From: Jann Horn <jann-XZ1E9jl8jIdeoWH0uzbU5w@public.gmane.org>
Subject: Re: [PATCH 1/3] proc: Stop reporting eip and esp in /proc/PID/stat
Date: Fri, 30 Sep 2016 20:56:42 +0200
Message-ID: <20160930185642.GH14666@pc.thejh.net>
References: <cover.1475257877.git.luto@kernel.org>
 <a5fed4c3f4e33ed25d4bb03567e329bc5a712bcc.1475257877.git.luto@kernel.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="IbVRjBtIbJdbeK1C"
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <a5fed4c3f4e33ed25d4bb03567e329bc5a712bcc.1475257877.git.luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Brian Gerst <brgerst-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Tycho Andersen <tycho.andersen-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, Tetsuo Handa <penguin-kernel-1yMVhJb1mP/7nzcFbJAaVXf5DAMn2ifp@public.gmane.org>
List-Id: linux-api@vger.kernel.org


--IbVRjBtIbJdbeK1C
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Sep 30, 2016 at 10:58:56AM -0700, Andy Lutomirski wrote:
> Reporting these fields on a non-current task is dangerous.  If the
> task is in any state other than normal kernel code, they may contain
> garbage or even kernel addresses on some architectures.

Stupid question: Doesn't something similar apply to wchan?
Am I missing something?

It looks to me as if the get_wchan() implementation of X86 has the same
issue, with the difference that it's not obviously usable as an infoleak
because only known symbol names are printed, not numeric values.

get_wchan() basically does the following:

 - make sure the remote thread is sleeping (but don't take any locks to
   ensure it stays that way)
 - read the remote thread's saved kernel stack pointer
 - checks that the saved kernel stack pointer points to the main part of
   the remote stack
 - read a frame pointer through the saved kernel stack pointer; the read
   value could be anything if a race occured
 - check that the frame pointer points into the main part of the remote
   stack
 - read a saved instruction pointer through the frame pointer; the read
   value could be anything if a race occured
 - ensure that the "saved instruction pointer" doesn't point to the
   sections .sched.text and .spinlock.text
 - return the "saved instruction pointer"

So as far as I can tell, it *might* be possible for userspace to leak
information about the kernel text by alternatingly storing a proper
saved instruction pointer and a user-supplied value in a place from
which the kernel tries to read a saved instruction pointer.
By supplying values that are suspected to point to kernel text and
looking at the reported wchan values, an attacker could learn information
that allows him to e.g. defeat kASLR and even slowly locate functions in
custom kernels.

I vaguely remember seeing some similar code that defends against issues
like this by reading some counter beforehand and afterwards and checking
that it stays the same, but I'm not sure where that was. I think I saw it
while looking at the series for vmalloc()ed stacks.

--IbVRjBtIbJdbeK1C
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJX7rVqAAoJED4KNFJOeCOoOusP/2kz8tDp6jdGYdHwkS5xawZ9
KnSeAkk/RCAOYkH9h9LSiBfQyxdK+UG3CxZ6fd2FD5mDzWyFgMxyw7D4jBrJOCn2
e+4nb8Jz89eOmHyhuaOhfGflaVGM6SmHKg/Z4g6xbaMnYbG3L+thSgsjx7WPNX4j
ztSlfPG4ljJHLym4oKvm4yzvbypV7/qXmcGH8hAGuAx4l5UvB9VleL4tDhhftwHU
uUYnDqxV7mWsckRHJK8V4DSDQdUqd+lPD0GF+PQh/Y9vpPgbD0+FuiyotL+Oq7o6
zNup3A6gs5ZTMbjD2XOwNxG0a2/ZRwQeqQ9wIpAAbRaMNsZfRVsXZHJheroaVp6A
bvOXVvZyB915CnJ97/k312SlpAUrVci6KNpOxD5hLPyqB/vElKuwBHyz8GmuK7U3
au27ys31vCN9CWcM5utbAzKOi0YGINsRMKXK86V5aPBAYxMIjCGlQZtBF72kTuhu
bYzid8+KlHY95xifpdHrT+BGRvNr+tJHVdKdGaGAHj3KIbHYGo0Nshr18aOzYodO
ME3MCGosujtsQ0OU4iQ04w1SvarpiYTJnINSWKrI28xJI8LY1dANILSWbsiM+qcS
cE4DL+g2parVYMQNtxD6uFvUSdThI9kAWXa97H+PGRusIRkaL107gFUF1sqfus8g
vvbknLGRPnVL+gBoOABk
=qDFT
-----END PGP SIGNATURE-----

--IbVRjBtIbJdbeK1C--
