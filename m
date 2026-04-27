Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F67A3128BE;
	Mon, 27 Apr 2026 13:33:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777296800; cv=none; b=mpvX5kktfgtH1RyEPPRgSU6NeO/4L0qCtlf/Lx8CuI5DkMUeeSFNSpXzLGRYV42CXX9GmcCa7SVfJlzNhy+fNEaFRXiXV0VBUPYvb+e6edSHaxQkxo+VrCb3/9VcQI4mfex5DKw7rk2KPnrXOJcR+v/3i2H+RDJ4KymGJQbgo2E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777296800; c=relaxed/simple;
	bh=EatXnfSeNpf8F10Q2zH1PP/CJsJ/acTrqGU0iRSe30U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=M4s20BQJ2IaQZCZi8vnuPM+voCU/q7yjGCh5UW7XNlZGJHtXT5xx81UV8QULiKxiZfQmnr9dOOGbGY2jeraXiOGmlvaC6ezuQdSQrdANIkHBhgZiKKTHJME2cZC5nWWJR2ZdhHpwLxfeXDUwcIWkvSmWAvhVPWtH6XO3jHSJgxY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Zz0iQxaC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Zz0iQxaC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A701C19425;
	Mon, 27 Apr 2026 13:33:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777296800;
	bh=EatXnfSeNpf8F10Q2zH1PP/CJsJ/acTrqGU0iRSe30U=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Zz0iQxaChR0ZDa8HQvkaznVCl98SB+ZFLhIGGDtqyVm9wpvL3SWBvgxtXKot+JZ41
	 C5ImhNSW3dat8+D3b4aGC2XvE43sqn0ejkcIRWvytAV1kKi48OsHF6NU/i5vdZOq9V
	 oj/mJ6t+T3nOYRnIA73rc457162xYe1uw4JnZjHD1lozVyK7XFVYin3BU04WljSVnd
	 QVwR9fVsBXuNbm5pq8avjznJhIxIzOCIf80TQ19sdDu1yeLZy1E0+mV6eHIQcBNoIc
	 gKfaxUXuCQ0TEXo3ATMdWBt+lzn5JwgwuXXQiYpNtA6NWd0nZ29/9pJjiOllGrHFO3
	 qtXsjv6ztVl/w==
Date: Mon, 27 Apr 2026 15:33:16 +0200
From: Alejandro Colomar <alx@kernel.org>
To: Florian Weimer <fweimer@redhat.com>
Cc: Dorjoy Chowdhury <dorjoychy111@gmail.com>, linux-man@vger.kernel.org, 
	brauner@kernel.org, jlayton@kernel.org, libc-alpha@sourceware.org, 
	linux-api@vger.kernel.org
Subject: Re: [PATCH v2 1/2] man/man3/errno.3: Document EFTYPE error code
Message-ID: <ae9lMz0SRR-sn1Uz@devuan>
References: <20260426111707.36541-1-dorjoychy111@gmail.com>
 <20260426111707.36541-2-dorjoychy111@gmail.com>
 <ae4K_5f1g3zgSNkC@devuan>
 <lhu5x5c4rpl.fsf@oldenburg.str.redhat.com>
 <ae9gDtEo6OxHTYBt@devuan>
 <lhuv7dcy1j9.fsf@oldenburg.str.redhat.com>
Precedence: bulk
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="nq47nb2abmlhtukb"
Content-Disposition: inline
In-Reply-To: <lhuv7dcy1j9.fsf@oldenburg.str.redhat.com>


--nq47nb2abmlhtukb
Content-Type: text/plain; protected-headers=v1; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
From: Alejandro Colomar <alx@kernel.org>
To: Florian Weimer <fweimer@redhat.com>
Cc: Dorjoy Chowdhury <dorjoychy111@gmail.com>, linux-man@vger.kernel.org, 
	brauner@kernel.org, jlayton@kernel.org, libc-alpha@sourceware.org, 
	linux-api@vger.kernel.org
Subject: Re: [PATCH v2 1/2] man/man3/errno.3: Document EFTYPE error code
Message-ID: <ae9lMz0SRR-sn1Uz@devuan>
References: <20260426111707.36541-1-dorjoychy111@gmail.com>
 <20260426111707.36541-2-dorjoychy111@gmail.com>
 <ae4K_5f1g3zgSNkC@devuan>
 <lhu5x5c4rpl.fsf@oldenburg.str.redhat.com>
 <ae9gDtEo6OxHTYBt@devuan>
 <lhuv7dcy1j9.fsf@oldenburg.str.redhat.com>
MIME-Version: 1.0
In-Reply-To: <lhuv7dcy1j9.fsf@oldenburg.str.redhat.com>

Hi Florian,

On 2026-04-27T15:29:30+0200, Florian Weimer wrote:
> * Alejandro Colomar:
>=20
> > Hi Florian,
> >
> > On 2026-04-27T12:34:30+0200, Florian Weimer wrote:
> >> * Alejandro Colomar:
> >>=20
> >> > [CC +=3D libc-alpha]
> >> >
> >> > Hi Dorjoy,
> >> >
> >> > On 2026-04-26T17:14:25+0600, Dorjoy Chowdhury wrote:
> >> >> Signed-off-by: Dorjoy Chowdhury <dorjoychy111@gmail.com>
> >> >
> >> > Thanks!
> >> >
> >> > 	Reviewed-by: Alejandro Colomar <alx@kernel.org>
> >> >
> >> > I will wait until glibc adds this error code to their <errno.h> befo=
re
> >> > applying the patch.  This means either you should write and send a p=
atch
> >> > to glibc (if so, please CC me), or you should ask them to add it
> >> > themselves (if you're not comfortable writing glibc code).
> >>=20
> >> I'm not sure where this is coming from.
> >
> > Here's a link to the thread:
> > <https://lore.kernel.org/linux-man/20260426111707.36541-1-dorjoychy111@=
gmail.com/T/>
> >
> >> POSIX says EFTYPE was rejected
> >> in favor of ENOTTY.
> >
> > Could you please share a link to that?
> >
> > Anyway, I guess ENOTTY would be inappropriate in this case.  Although
> > maybe a better error code could be devised; I don't know.  This is why
> > I wanted glibc involved in this discussion before this arrives to a
> > Linux release.  Thanks for the quick feedback!
>=20
> It's in the Rationale for System Interfaces:
>=20
> =E2=80=9C
> [EFTYPE]
>     This error code was proposed in earlier proposals as "Inappropriate
>     operation for file type", meaning that the operation requested is
>     not appropriate for the file specified in the function call. This
>     code was proposed, although the same idea was covered by [ENOTTY],
>     because the connotations of the name would be misleading. It was
>     pointed out that the fcntl() function uses the error code [EINVAL]
>     for this notion, and hence all instances of [EFTYPE] were changed to
>     this code.
> =E2=80=9D
>=20
> I replied on linux-fsdevel, too.

Thanks!

>=20
> (It would be nice to submit patches introducing new error codes to
> linux-api with a subject mentioning the error code.)

Thanks!  I'll remember this advice for when receiving patches that add
error codes.

>=20
> Thanks,
> Florian

Cheers,
Alex

--=20
<https://www.alejandro-colomar.es>

--nq47nb2abmlhtukb
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEES7Jt9u9GbmlWADAi64mZXMKQwqkFAmnvZZsACgkQ64mZXMKQ
wqndBg/9EyC4MEfnePrW42V+4l/1WcRCwcEdXdGM9wh01n91yUWquDUTfaIwFU/s
e5bj8HvJ97yDgnLWCw7JV99+xPcqTcS96QqhLiTRjmW5/FOGsTUACQrpTWVpJ87l
p4LLMmorrODrNHU5dDIDGZ3uuVaHOOjb8m1dZ4wMvE9yBamyiqn8Yp4WWWav4yML
Ca9cuOPHosjSB8x9SrQuvzlFmjGlDpdYsrU1bNzVLdKN9D1rZH2etU/Q3NUIu/NO
zqPRGv7uwqenA2TKmL2GxVMjffdpgSKRCLVt/oDLmVl7+h6KS4wvkFNRzOhE+mfU
QMgF8WH0eEvVPZ0OWmMAAjTtxPSSUalU2mBofTBbJDhUjlNF4qVBTTxd5VNcsjPq
IrwD9e2m4JRby+FAvu4nqkPT0iPIzfuewoDvr4WDeyO4omQcVb4iRVtGzrED7/JQ
ORcwKbp/pkVW84aoY/evtY1AOKXfaiRlijGU0JqY/g6NAHbb/OWrc9D9XaOifW90
Qtwxoscxj6U5fFAZl2Hxb3CmUik92+YvC6rAzzLsTLsZIy80TlxETb34EIrgR3td
beLV9WyEiHchtYC+W8m1DnoFhePbSDMb2XfDmChxxpzY+ae4SAjkO6yav0nE8lvy
TswZ9/T61Eb7Azccqxpewu9nSXoMn/00ZjIDbjdtmKZSwbzI/TY=
=4KlR
-----END PGP SIGNATURE-----

--nq47nb2abmlhtukb--
