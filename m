Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71D3017A30A;
	Mon, 29 Jun 2026 21:02:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782766939; cv=none; b=qPxtoG5qmZzwqI3VoZiEiG2xoz1dDxFluwp0EjRQglm6WThS2iKSWic7wnYkEkgzFCFJEN7V3zc7+xtUltZiguYEiknx+RFMf8mwasGfzG02fRGNFLCasF8EHkpSH9W114v2gzeyzh+VB2yPnVSlelcgHkv882r72NlpIbIcPiM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782766939; c=relaxed/simple;
	bh=5SS4tnsa4eUhnVbPLRY6K/9gXqlp6rmoe0u7RabBj60=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TkmLeh2kBB02tyU+7F+FQplKUai6h4Gs92FGz/feMQyB5YhXhpTFKvCIjnoIdLuoQ4mgm7goj7qT7K6SN/Pg9+MPesutsAfSv6rtQxSXQO9eJzYAerMQIxc0fPXBYF1a9QjKfTbLLHKr/eCkgt9z1Hi/9TqHje+W6M5qsAWkEPc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hb6e5lSg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hb6e5lSg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84B8B1F000E9;
	Mon, 29 Jun 2026 21:02:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782766938;
	bh=6W+jXHIwiP8nkHo2RHnpI8C4eDiEaXDtp69grtYWwTs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=hb6e5lSgj2Gqz8i1+ElNL1AyRJ4TMHQfbHjtEKiTyScwsAtKfukexH4NaQQH1IUjk
	 8yWpNdVQ9rOALSBxl/fGKCnaN3UgbqPapkBXCmqk6cDZZFmgI512Dw7gwqYoC3YrqD
	 QkQCa8BJeSAW2JQSoFV14uNmizuxKadXKrow35A4f2+AO2U/C1gTyKroMc/rEtIjFC
	 bfzfh8rgqZBiGSWd/h0j/NZAVQYXl0G/y4v0vo/JdxlewzwMbVob3n3RZbdsI1dZtC
	 atYAsfvtQACr1rle9CP3If54vjeL0MmDwTJNgd3+/UWbcZD2IZ4+jcEQWjGX48IcD8
	 TrvMlEVw3lnzQ==
Date: Mon, 29 Jun 2026 23:02:13 +0200
From: Alejandro Colomar <alx@kernel.org>
To: Dorjoy Chowdhury <dorjoychy111@gmail.com>
Cc: Florian Weimer <fweimer@redhat.com>, linux-man@vger.kernel.org, 
	brauner@kernel.org, jlayton@kernel.org, libc-alpha@sourceware.org, 
	linux-api@vger.kernel.org
Subject: Re: [PATCH v2 1/2] man/man3/errno.3: Document EFTYPE error code
Message-ID: <akLcqAykbOXmDJrg@devuan>
References: <20260426111707.36541-1-dorjoychy111@gmail.com>
 <20260426111707.36541-2-dorjoychy111@gmail.com>
 <ae4K_5f1g3zgSNkC@devuan>
 <lhu5x5c4rpl.fsf@oldenburg.str.redhat.com>
 <ae9gDtEo6OxHTYBt@devuan>
 <lhuv7dcy1j9.fsf@oldenburg.str.redhat.com>
 <ae9lMz0SRR-sn1Uz@devuan>
 <CAFfO_h7V4gX6NbQvPtTF=XeH44j4O1oxWcArE+fzKM9FTmDKRg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="pjhiwfohnkdb7ogf"
Content-Disposition: inline
In-Reply-To: <CAFfO_h7V4gX6NbQvPtTF=XeH44j4O1oxWcArE+fzKM9FTmDKRg@mail.gmail.com>


--pjhiwfohnkdb7ogf
Content-Type: text/plain; protected-headers=v1; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
From: Alejandro Colomar <alx@kernel.org>
To: Dorjoy Chowdhury <dorjoychy111@gmail.com>
Cc: Florian Weimer <fweimer@redhat.com>, linux-man@vger.kernel.org, 
	brauner@kernel.org, jlayton@kernel.org, libc-alpha@sourceware.org, 
	linux-api@vger.kernel.org
Subject: Re: [PATCH v2 1/2] man/man3/errno.3: Document EFTYPE error code
Message-ID: <akLcqAykbOXmDJrg@devuan>
References: <20260426111707.36541-1-dorjoychy111@gmail.com>
 <20260426111707.36541-2-dorjoychy111@gmail.com>
 <ae4K_5f1g3zgSNkC@devuan>
 <lhu5x5c4rpl.fsf@oldenburg.str.redhat.com>
 <ae9gDtEo6OxHTYBt@devuan>
 <lhuv7dcy1j9.fsf@oldenburg.str.redhat.com>
 <ae9lMz0SRR-sn1Uz@devuan>
 <CAFfO_h7V4gX6NbQvPtTF=XeH44j4O1oxWcArE+fzKM9FTmDKRg@mail.gmail.com>
MIME-Version: 1.0
In-Reply-To: <CAFfO_h7V4gX6NbQvPtTF=XeH44j4O1oxWcArE+fzKM9FTmDKRg@mail.gmail.com>

Hi Dorjoy,

On 2026-06-29T22:15:45+0600, Dorjoy Chowdhury wrote:
> Hi,
>=20
> The OPENAT2_REGULAR and EFTYPE changes are in the 7.2-rc1 now I
> believe. I am not sure if it's the right time to merge the man-page
> changes now.

Yes, it is.

> I also don't know the whole flow so I'm asking.

If it's in an -rc, and you believe there won't be significant changes
before release, we can merge the documentation already.  If there's any
last-minute change before the actual 7.2 release, just send some patch
fixing the documentation.

Please keep all the CCs when sending the patches, and send in reply to
the first message in this thread, so that it's easier to correlate them.
Please also include CC tags in the trailer of the commit message.

> Do both
> of these need to be added to glibc manually or do these get pulled in
> from the uapi headers of linux into glibc automatically?

I don't know about this; someone from glibc will have to comment.


Have a lovely night!
Alex

>=20
> Regards,
> Dorjoy
>=20
> On Mon, Apr 27, 2026 at 7:33=E2=80=AFPM Alejandro Colomar <alx@kernel.org=
> wrote:
> >
> > Hi Florian,
> >
> > On 2026-04-27T15:29:30+0200, Florian Weimer wrote:
> > > * Alejandro Colomar:
> > >
> > > > Hi Florian,
> > > >
> > > > On 2026-04-27T12:34:30+0200, Florian Weimer wrote:
> > > >> * Alejandro Colomar:
> > > >>
> > > >> > [CC +=3D libc-alpha]
> > > >> >
> > > >> > Hi Dorjoy,
> > > >> >
> > > >> > On 2026-04-26T17:14:25+0600, Dorjoy Chowdhury wrote:
> > > >> >> Signed-off-by: Dorjoy Chowdhury <dorjoychy111@gmail.com>
> > > >> >
> > > >> > Thanks!
> > > >> >
> > > >> >  Reviewed-by: Alejandro Colomar <alx@kernel.org>
> > > >> >
> > > >> > I will wait until glibc adds this error code to their <errno.h> =
before
> > > >> > applying the patch.  This means either you should write and send=
 a patch
> > > >> > to glibc (if so, please CC me), or you should ask them to add it
> > > >> > themselves (if you're not comfortable writing glibc code).
> > > >>
> > > >> I'm not sure where this is coming from.
> > > >
> > > > Here's a link to the thread:
> > > > <https://lore.kernel.org/linux-man/20260426111707.36541-1-dorjoychy=
111@gmail.com/T/>
> > > >
> > > >> POSIX says EFTYPE was rejected
> > > >> in favor of ENOTTY.
> > > >
> > > > Could you please share a link to that?
> > > >
> > > > Anyway, I guess ENOTTY would be inappropriate in this case.  Althou=
gh
> > > > maybe a better error code could be devised; I don't know.  This is =
why
> > > > I wanted glibc involved in this discussion before this arrives to a
> > > > Linux release.  Thanks for the quick feedback!
> > >
> > > It's in the Rationale for System Interfaces:
> > >
> > > =E2=80=9C
> > > [EFTYPE]
> > >     This error code was proposed in earlier proposals as "Inappropria=
te
> > >     operation for file type", meaning that the operation requested is
> > >     not appropriate for the file specified in the function call. This
> > >     code was proposed, although the same idea was covered by [ENOTTY],
> > >     because the connotations of the name would be misleading. It was
> > >     pointed out that the fcntl() function uses the error code [EINVAL]
> > >     for this notion, and hence all instances of [EFTYPE] were changed=
 to
> > >     this code.
> > > =E2=80=9D
> > >
> > > I replied on linux-fsdevel, too.
> >
> > Thanks!
> >
> > >
> > > (It would be nice to submit patches introducing new error codes to
> > > linux-api with a subject mentioning the error code.)
> >
> > Thanks!  I'll remember this advice for when receiving patches that add
> > error codes.
> >
> > >
> > > Thanks,
> > > Florian
> >
> > Cheers,
> > Alex
> >
> > --
> > <https://www.alejandro-colomar.es>
>=20

--=20
<https://www.alejandro-colomar.es>

--pjhiwfohnkdb7ogf
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEES7Jt9u9GbmlWADAi64mZXMKQwqkFAmpC3VUACgkQ64mZXMKQ
wqnWfRAAuoniZIX9zqORr7vzlcwVIBl4e/8eJXU7WXV3JKgO5Bh58ZJWwKa+gdvj
5+5IJnr2jJk1vmi8P1WrOFGJCOBWExk2KOCk1M/iF2FA0X2Hqm51Bu7ImgGAcl0K
ilwDPDXpazIk7hcwXaJiDOAgFwpTPJfRSS/e+LcnOoSr9CU7eKbhRoSHeD2KujJf
2fFvWPGJEmgWmkUKraT58PADMhZJdKOyysrKm5fYDWwJqECzu0qFOOeBuZTyD5e8
WucAOht1lZ0RMTupcKUWvNg7LkAIq+WMKuLvJrh5FW4uHXPl9pI9iuZ5zJWzawSX
CoxXEWH6lN+5r8auX44kPRa8VsJDaif1zd0KQcEqF+PE/yHq3ye990IAOBdtSWQX
/RpWqB7+V1vVEjByRBlRGoTm3rAkDdUx9QDIVtzMblxd2ykBnr4a3UnfFGwqfHbn
DFOzWsStsZ9RAcAoRq8WW3Pua+fQvwA3xlJXGWD+9Vtbfva6C2hYfySD+ssiu/Bh
E65A3gU3M61JT3UGKIgRTr6mgRN5mRUj8zToJxp3q1GFiVafh43H6n4T5ZWeUWrZ
q/0qVWoDSqkiij0tLY6RgmdyplraiPycDp9u9phxXdDKJ/moesREYTLRveihUpuq
J8v8oHliL4J+9TJVToQselv5TQqfK432hIxAMsKUfSvMCTRja7o=
=1ehd
-----END PGP SIGNATURE-----

--pjhiwfohnkdb7ogf--
