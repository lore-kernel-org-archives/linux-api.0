Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5274F2D739C;
	Sun, 13 Sep 2026 21:27:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789334870; cv=none; b=VJqV0r4vUxRfYmiS/Jiti8hGe18C7vzNlG8Mv970qBia3fZKxup+slvlq9aOC8exncpAnXwaUptPhUHxYBNN6qOjyUmeDo1EekSRm29UB/oXa2KemvfJODYo+FfCDvyX6j1uOIT+YfFwmoJzze64i8kU4YNlTHYx+a3M/Lou7o4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789334870; c=relaxed/simple;
	bh=2eLtFdwPKYWVNM0KNzYGZkOpik29kQi1mV3QJjpI6/s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LFwgW6IO8pqn7qfbPxhYoBd+FZz39ddPmWeBcvEkTwMZ0ut2gyj3zv8vj+G0fRQ7bpDfGGDYXDE2jkDuhdzcoevOZRK9qFsmw/37l7gVxRj+IOS5zXf/ThAsi4iMa8OFGXlgsPiUiB08U2LsdAbARmU1yi2JTAyCaRgmF1IKhoE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RH2qe/Z3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RH2qe/Z3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 431751F000FF;
	Sun, 13 Sep 2026 21:27:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789334868;
	bh=Wq5CvnEl1ewY213ZDBAozwO3EEBpYPHHPC4ml3gchzw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=RH2qe/Z3TudtVZ1E/xt5TO6qLeb9kUWsmWaBDOw/Ql8Wb3pUKA6FsX68HD/FZQb0u
	 /kV6c0bbDVNfOmhMJ+IcwVoezG8z3umgwmTe2opMrTCWyDlY/CkWPY/8wex995s/GH
	 jNk9OS2rHKY6n0IOUUUx0AF2c62WCrNT2fEOEopr9CwElLkfeUYJM1rObsnj8afWdl
	 Mi95UgzREFbnZM7uRMG5GgIEBCs9dgoa2vggdBYbhrqq/PV+pIJVlz9/RcFZb24F6p
	 e73Giz44OVq7dpYJVJHLBQGGx2NgWV5YqoJaV6fZCwuW9TGsLk39Q1BKivswTMxxj3
	 mFxRm57x+jKhw==
Date: Sun, 13 Sep 2026 23:27:44 +0200
From: Alejandro Colomar <alx@kernel.org>
To: Rich Felker <dalias@libc.org>
Cc: Mikko Rantalainen <mikko.rantalainen@peda.net>, 
	linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, 
	brauner@kernel.org, viro@zeniv.linux.org.uk, jack@suse.cz
Subject: Re: [RFC PATCH 0/1] close(): stop exposing non-retryable EINTR
Message-ID: <aqcVK5OGbvIRNUNP@devuan>
References: <20260913193815.2862366-1-mikko.rantalainen@peda.net>
 <20260913205358.GX25906@brightrain.aerifal.cx>
Precedence: bulk
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="57k27f4uxik2pcox"
Content-Disposition: inline
In-Reply-To: <20260913205358.GX25906@brightrain.aerifal.cx>


--57k27f4uxik2pcox
Content-Type: text/plain; protected-headers=v1; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
From: Alejandro Colomar <alx@kernel.org>
To: Rich Felker <dalias@libc.org>
Cc: Mikko Rantalainen <mikko.rantalainen@peda.net>, 
	linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, 
	brauner@kernel.org, viro@zeniv.linux.org.uk, jack@suse.cz
Subject: Re: [RFC PATCH 0/1] close(): stop exposing non-retryable EINTR
Message-ID: <aqcVK5OGbvIRNUNP@devuan>
References: <20260913193815.2862366-1-mikko.rantalainen@peda.net>
 <20260913205358.GX25906@brightrain.aerifal.cx>
MIME-Version: 1.0
In-Reply-To: <20260913205358.GX25906@brightrain.aerifal.cx>

> Date: 2026-09-13 16:53:58-0400
> From: Rich Felker <dalias@libc.org>
>
> On Sun, Sep 13, 2026 at 10:38:14PM +0300, Mikko Rantalainen wrote:
> > This is an RFC because it deliberately changes a long-established raw
> > syscall ABI. Jan Kara raised userspace-regression concerns when this was
> > discussed in 2025:
> >=20
> >     https://lore.kernel.org/linux-fsdevel/ddqmhjc2rpzk2jjvunbt3l3eukcn4=
xzkocqzdg3j4msihdhzko@fizekvxndg2d/
> >=20
> > while musl and Android bionic already normalize this result to success
> > in libc.
> >=20
> > The Linux implementation of close() will always close the file descript=
or
> > given as argument, except for the invalid file descriptor which will
> > return -EBADF.
> >=20
> > However, currently Linux kernel will return EINTR in some cases for
> > close(). There is no good way for caller to recover from this case using
> > the original fd. Whatever action was actually interrupted cannot be
> > resumed or retried through this fd, because the fd has already been
> > consumed. Even worse, EINTR conventionally invites retrying an operatio=
n,
> > but retrying close() is unsafe: the same file descriptor number may
> > already refer to another file opened by another thread by the time
> > close() returns EINTR.
> >=20
> > In addition, POSIX.1-2024 requires that if close() reports EINTR, the
> > descriptor must remain open. It also explicitly permits an interrupted
> > close() to return success after closing the descriptor.
> >=20
> > This patch is about implementing the second option to be compatible with
> > both POSIX.1-2024 and real-world applications.
> >=20
> > Since close() on Linux first relinquishes the file descriptor and only
> > then performs ->flush() work, interruption of that later work cannot be
> > recovered through the original fd. No matter how important that
> > close-time work was, ownership of the fd has already been irrevocably
> > relinquished.
> >=20
> > For regular files, applications requiring durability already need an
> > explicit synchronization operation such as fsync() or fdatasync() before
> > relinquishing the fd. This proposal does not suppress meaningful
> > delayed-I/O errors such as EIO, ENOSPC, or EDQUOT; it only changes
> > interruption results whose conventional recovery action (retrying the
> > operation) is unsafe for close().
> >=20
> > Historical discussions about this subject:
> >=20
> > - https://inbox.sourceware.org/libc-alpha/efaffc5a404cf104f225c26dbc96e=
0001cede8f9.1747399542.git.alx@kernel.org/T/
> >=20
> > - https://sourceware.org/pipermail/libc-alpha/2025-May/166675.html
> >=20
> > - https://lkml.rescloud.iu.edu/hypermail/linux/kernel/2205.3/06731.html
> >=20
> > - https://lwn.net/Articles/576478/
> >=20
> > - https://yarchive.net/comp/linux/must_check.html
> >=20
> > - https://sourceware.org/pipermail/libc-alpha/2025-May/166907.html
> >=20
> > - https://sourceware.org/pipermail/libc-alpha/2025-May/166722.html
> >=20
> >=20
> > POSIX.1-2024 also allows EINPROGRESS after the descriptor has been clos=
ed.
> > I considered using that result, but it appears less useful than success
> > for Linux. It would preserve diagnostic information about interrupted
> > close-time work, but there is no operation the caller can perform on the
> > original fd to resume or complete that work. It would therefore turn an
> > irrevocably completed ownership transfer into an apparent failure witho=
ut
> > providing a recovery path. Returning success avoids that ambiguity and
> > still leaves genuinely useful delayed-I/O errors such as EIO, ENOSPC, a=
nd
> > EDQUOT untouched.
> >=20
> > This also matches the direction taken by musl, which initially used
> > EINPROGRESS for this case and later changed to success because existing
> > applications were prone to interpret EINPROGRESS as a failure and could
> > incorrectly infer that the fd was still open.
> >=20
> > Automatically replacing EINTR with success does change the *observable*
> > raw syscall ABI for applications that distinguish EINTR from successful
> > close(). For applications that already treat the descriptor as consumed,
> > this changes control flow to the normal successful-close path. I would =
be
> > particularly interested in concrete examples where distinguishing EINTR
> > provides useful recovery semantics, given that the original fd has
> > already been consumed and cannot be used to resume the interrupted
> > close-time work.
> >=20
> > Mikko Rantalainen (1):
> >   fs: don't return EINTR from close()
> >=20
> >  fs/open.c | 11 ++++++++---
> >  1 file changed, 8 insertions(+), 3 deletions(-)
> >=20
> > --=20
> > 2.43.0
>=20
> Hi! I'm one of the first people who pressed this issue while tracking
> down the POSIX model for how side effects are supposed to work with
> respect to EINTR and how that relates to thread cancellation, and how
> glibc was getting all this stuff wrong, back around 2011-2012.
>=20
> I don't think there is serious concern about userspace regressions
> making this change. It would not be changing the meaning of any
> existing result code or adding a new error condition applications need
> to be aware of (like the EINPROGRESS mess).
>=20
> But I'm also not sure how helpful the change would be. It's already
> possible to patch this up in userspace, and as you noted, we already
> do that in musl and so does Bionic. So the main practical effect of
> this change would be just forcing the right behavior on glibc systems
> even when glibc doesn't want to fix it. Maybe that's a good idea? I'm
> not sure. I think it would be best to have everyone on the same page
> that this should be fixed, with both glibc fixing it so it's right on
> old-kernel/new-glibc, and the kernel fixing it so it's right on
> new-kernel/old-glibc. That would also avoid hard feelings from a
> unilateral action perceived as dictatorial.

Acked-by: Alejandro Colomar <alx@kernel.org>

>=20
> Rich

--=20
<https://www.alejandro-colomar.es>

--57k27f4uxik2pcox
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEES7Jt9u9GbmlWADAi64mZXMKQwqkFAmqnFUoACgkQ64mZXMKQ
wqkBRw//df2SrR2tZspLc5dKF85tQo+uta1DKIEZUJ9Mgz+gTOMcNqEshLMs13nJ
zf7egelrg28x+tuk8Sofu6dW13MnPBEgQuoYCMulIWKKf8Ah0+Whrh3BeTlVLMJC
Gg4beJxWW67CNgF46kjDUWTEyXCmqQtCizu7OKCF+nOsD1/mNw6Jse3LSTxob7bR
wE40OGnXj+pZvMjWjjWCbrhEUnroTltxS6DVhr+jePfJN4om7doNYfKJD/+eE2cL
A7mqHlkkKK2V37miCYXQN021I122ark6Go1dZEuwQFCLSp2+iT9ZrQxrescCqvBO
ErQWxU97Ndt7T9y5ndLLhUdP7KeLINHbqDMgp6hswL2RTmFh7W7C35FhBmBGHlc4
XIzcxdRkldMWvs/tAF0PrneKSOpC8XPTIDx3srXrRhA0iLR/RHNFcE9HI2178KSs
o3U8nI/f7ZREzyFRvCN9BBVcQph704NMcTmEFxoLeTwdC8BW7q1r2ekdQ7xNUmQU
hnF9o3PjdZ/1HbLXvsWN/0sDeycMXf6zjEkOuF1sHkkroqArbidT97HYioFlZqh8
kiy7ar1oiaGwtWuaXddgYvWvgxVssgIoycKCAtcbXgbL2QIcq028FnTNXBPAK1uK
K/+o2ThvMWBMCD/k5p9rf/WimEdfCG2mB7DvrwfixFzzFHhXnY8=
=OUOx
-----END PGP SIGNATURE-----

--57k27f4uxik2pcox--
