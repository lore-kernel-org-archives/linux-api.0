Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50CC942125B;
	Mon, 14 Sep 2026 09:45:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789379106; cv=none; b=TSn9AB6roA6MDkPCviWW7Vz+lE81gI3NbzAQOyNgPTFgRNYn6tqW0BLaxIb68a23OWwY8SM8lDiarZ7AahdfTv04nAuXUPqm6IMIGUJjFtVzkRo5CGbGYh/vdH/gGfLORYZqLX6X1SKftAOx5NcNivvYIeur+nDdm4Uwao2CE+A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789379106; c=relaxed/simple;
	bh=qXyHuKK3R5cjQK1SPKnWGHcfT93Q6JVw2yrqxyMEPGw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=iXQm86M10WI5Q5oVwa+OwsdFi2HxsyMKdp3T1bGOHK/Dwd/8CkM+QLW4M8JiAbHfalPxDayX2rGkqLeBhN5Yo7Qlh1C4sWoVBWd2v8hDBvwNDgSeA54IxShQP0cDlEw9xUQDOcgqtoxu+y+R6YVGbuXSU0vRzN87kQLl36gpdGM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SlN/sD26; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SlN/sD26"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 391D01F00893;
	Mon, 14 Sep 2026 09:45:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789379104;
	bh=ngSbJjKZmajWZTS6gSs4CKvpaDkVLOB19LuRZtMNMrQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=SlN/sD26wc9lsvk5Y15BHvRM2dJfvPZVbYadPVRL6geBIRpzmCaPA56x2aSZYIuzy
	 N/zowTEe9oBOokL9Obp5/WlInST2mQDgG1cqcYFSc2Mk4OGHNAm2VrlC7i4qzqW6sj
	 BRbvbKvYHTvOiuEVqTQCchah2Be8e8qYxeTqC0WdNUtjHKvNcWzBl0Bb1buiNxOQzr
	 mpYuHUILhmoA3VsaS1viGN5N6WAUx8+SBw8F1M72E/NBVquxMjleY6ldU4o2xOOiVK
	 tronnIR/tLxfJgxJzQPYm49wVnjBeOeMZg0Gg5UQQA7Ix5MngB8r3O75FL1ViyNM8Y
	 pKCknLzARhNXg==
Date: Mon, 14 Sep 2026 11:44:59 +0200
From: Alejandro Colomar <alx@kernel.org>
To: Mikko Rantalainen <mikko.rantalainen@peda.net>
Cc: Rich Felker <dalias@libc.org>, linux-fsdevel@vger.kernel.org, 
	linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, brauner@kernel.org, 
	viro@zeniv.linux.org.uk, jack@suse.cz
Subject: Re: [RFC PATCH 0/1] close(): stop exposing non-retryable EINTR
Message-ID: <aqfBPvttl_LFphLZ@devuan>
References: <20260913193815.2862366-1-mikko.rantalainen@peda.net>
 <20260913205358.GX25906@brightrain.aerifal.cx>
 <0e27e9dc-3520-436e-aa69-af9e938ab1bf@peda.net>
Precedence: bulk
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="kxigvwypmsk7rkfd"
Content-Disposition: inline
In-Reply-To: <0e27e9dc-3520-436e-aa69-af9e938ab1bf@peda.net>


--kxigvwypmsk7rkfd
Content-Type: text/plain; protected-headers=v1; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
From: Alejandro Colomar <alx@kernel.org>
To: Mikko Rantalainen <mikko.rantalainen@peda.net>
Cc: Rich Felker <dalias@libc.org>, linux-fsdevel@vger.kernel.org, 
	linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, brauner@kernel.org, 
	viro@zeniv.linux.org.uk, jack@suse.cz
Subject: Re: [RFC PATCH 0/1] close(): stop exposing non-retryable EINTR
Message-ID: <aqfBPvttl_LFphLZ@devuan>
References: <20260913193815.2862366-1-mikko.rantalainen@peda.net>
 <20260913205358.GX25906@brightrain.aerifal.cx>
 <0e27e9dc-3520-436e-aa69-af9e938ab1bf@peda.net>
MIME-Version: 1.0
In-Reply-To: <0e27e9dc-3520-436e-aa69-af9e938ab1bf@peda.net>

Hi Mikko,

> Date: 2026-09-14 09:36:58+0300
> From: Mikko Rantalainen <mikko.rantalainen@peda.net>
>
> Rich Felker (2026-09-13 23:53 Europe/Helsinki):
> > On Sun, Sep 13, 2026 at 10:38:14PM +0300, Mikko Rantalainen wrote:
> >> In addition, POSIX.1-2024 requires that if close() reports EINTR, the
> >> descriptor must remain open. It also explicitly permits an interrupted
> >> close() to return success after closing the descriptor.
> >>
> >> This patch is about implementing the second option to be compatible wi=
th
> >> both POSIX.1-2024 and real-world applications.
> > ...
> >=20
> > I don't think there is serious concern about userspace regressions
> > making this change. It would not be changing the meaning of any
> > existing result code or adding a new error condition applications need
> > to be aware of (like the EINPROGRESS mess).
> >=20
> > But I'm also not sure how helpful the change would be. It's already
> > possible to patch this up in userspace, and as you noted, we already
> > do that in musl and so does Bionic. So the main practical effect of
> > this change would be just forcing the right behavior on glibc systems
> > even when glibc doesn't want to fix it. Maybe that's a good idea? I'm
> > not sure. I think it would be best to have everyone on the same page
> > that this should be fixed, with both glibc fixing it so it's right on
> > old-kernel/new-glibc, and the kernel fixing it so it's right on
> > new-kernel/old-glibc. That would also avoid hard feelings from a
> > unilateral action perceived as dictatorial.
>=20
> I think there are two important questions:
>=20
>=20
> (1) What is the caller truly expected to do for EINTR? They cannot
> retry which would be the typical response to EINTR.
>=20
> (2) If caller cannot retry because file was already closed, can caller
> have any valuable information from EINTR return instead of success?
> I think it's pretty safe assumption that success from close() would
> be handled correctly by the caller.

There's one thing a caller might do:

Let's say I have a program doing a backup, and close(2) reports EINTR.
I might decide that I don't trust any of what happened, and start the
backup again from scratch.

Of course, I should have sync(2)ed before calling close(2).  So this
should be a non-issue in the first place.

This is the one thing that makes me think it might be better to keep
close(2) broken: it would be a reminder that people should flush
everything before calling close(2) if they care about their files.


Have a lovely day!
Alex

>=20
>=20
> I'm currently thinking that the answer to (1) is "???" and answer to
> (2) is best you can do is to log "Some unknown action interrupted
> some unknown background process while closing file XYZ, pretending
> everything went well." because anything else would assume some
> specific implementation of close() on Linux.
>=20
> As I see it, the fact that avoiding EINTR return value when the file
> is already closed fixing POSIX.1-2024 compatibility and glibc is just
> a bonus for a change that makes sense otherwise, too.
>=20
> --=20
> Mikko
>=20

--=20
<https://www.alejandro-colomar.es>

--kxigvwypmsk7rkfd
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEES7Jt9u9GbmlWADAi64mZXMKQwqkFAmqnwhsACgkQ64mZXMKQ
wqmu0A/7BB1x2E+gDgQANzIbq9Fsdu1chTIW0tZDe+4kqQJh8/5wQ8pnfWsg2yFl
hM5r1dW7Gf9qjYp4ztYR1jIfY4C8dC4yJIXPUD67FCjJX0w4J5oyfLTBwtlPyULM
l+CqD0okAXs5iQjV5IkXAMz/Pdqr3NWfkdu3M/mH9hWZgTETmlU5I6JJJXtlZqPb
l9Af0QFEAvVcZnBNJKwxcGimXNc+3CNUWXpt2ChK5fMCIxy/NLNOj1c3mvBNZ1vo
S+gn8XsFoSctJgColAbC7oxUqMKDXaNOOqbV/wEOnKhi9j4Ivay3TqymoErn2jMM
5l8MWV1gmYgloPGQOY6UeFjcBketKCY4Om6G0n64vVEN/9Fz5IzkiWBomGRM/3LB
C7IQ5C23A6B2dfXkGs4Ho0vglVLhjUgHtKVWHGFQ6Zz8vLLwvQyRE+pU9bpyR8ZC
T05xUSDt6g5kFeXEXMP1DJ9NPeBrOag4i5vubrsYz//yl8136c2wsY8zKqYnT8MS
fjUdtIs+a95yPW45DqGJaf+Y7IStzhkk6tFVM8mLcptr3Cldfw2BswWQVw/JbvPp
LVar4dt2sBxCEK8yT5eQt1oS4K95THZpwFHrBfQEcFR3Hcucv7clASfhCjrKmjSa
TwUpFfbafHbXxYN1vIau+Q6Edzs7u3J/mM2kuDbl5YvjcQlqyPs=
=XNqf
-----END PGP SIGNATURE-----

--kxigvwypmsk7rkfd--
