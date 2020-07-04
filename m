Return-Path: <SRS0=s2md=AP=vger.kernel.org=linux-api-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D005FC433E0
	for <linux-api@archiver.kernel.org>; Sat,  4 Jul 2020 11:48:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B1E1F20890
	for <linux-api@archiver.kernel.org>; Sat,  4 Jul 2020 11:48:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726738AbgGDLsY (ORCPT <rfc822;linux-api@archiver.kernel.org>);
        Sat, 4 Jul 2020 07:48:24 -0400
Received: from jabberwock.ucw.cz ([46.255.230.98]:42000 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726621AbgGDLsY (ORCPT
        <rfc822;linux-api@vger.kernel.org>); Sat, 4 Jul 2020 07:48:24 -0400
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 805441C0BD2; Sat,  4 Jul 2020 13:48:21 +0200 (CEST)
Date:   Sat, 4 Jul 2020 13:48:20 +0200
From:   Pavel Machek <pavel@ucw.cz>
To:     Jann Horn <jannh@google.com>
Cc:     "Catangiu, Adrian Costin" <acatan@amazon.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "rjw@rjwysocki.net" <rjw@rjwysocki.net>,
        "len.brown@intel.com" <len.brown@intel.com>,
        "mhocko@kernel.org" <mhocko@kernel.org>,
        "fweimer@redhat.com" <fweimer@redhat.com>,
        "keescook@chromium.org" <keescook@chromium.org>,
        "luto@amacapital.net" <luto@amacapital.net>,
        "wad@chromium.org" <wad@chromium.org>,
        "mingo@kernel.org" <mingo@kernel.org>,
        "bonzini@gnu.org" <bonzini@gnu.org>,
        "Graf (AWS), Alexander" <graf@amazon.de>,
        "MacCarthaigh, Colm" <colmmacc@amazon.com>,
        "Singh, Balbir" <sblbir@amazon.com>,
        "Sandu, Andrei" <sandreim@amazon.com>,
        "Brooker, Marc" <mbrooker@amazon.com>,
        "Weiss, Radu" <raduweis@amazon.com>,
        "Manwaring, Derek" <derekmn@amazon.com>
Subject: Re: [RFC]: mm,power: introduce MADV_WIPEONSUSPEND
Message-ID: <20200704114820.GA16083@amd>
References: <B7793B7A-3660-4769-9B9A-FFCF250728BB@amazon.com>
 <20200703224411.GC25072@amd>
 <CAG48ez0oWQd42a-H-Dzw1Wq7HgB5PpFRGCZeYxP8ohxaoZHmvQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="h31gzZEtNLTqOjlF"
Content-Disposition: inline
In-Reply-To: <CAG48ez0oWQd42a-H-Dzw1Wq7HgB5PpFRGCZeYxP8ohxaoZHmvQ@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-api-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-api.vger.kernel.org>
X-Mailing-List: linux-api@vger.kernel.org


--h31gzZEtNLTqOjlF
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> > > Cryptographic libraries carry pseudo random number generators to
> > > quickly provide randomness when needed. If such a random pool gets
> > > cloned, secrets may get revealed, as the same random number may get
> > > used multiple times. For fork, this was fixed using the WIPEONFORK
> > > madvise flag [1].
> >
> > > Unfortunately, the same problem surfaces when a virtual machine gets
> > > cloned. The existing flag does not help there. This patch introduces a
> > > new flag to automatically clear memory contents on VM suspend/resume,
> > > which will allow random number generators to reseed when virtual
> > > machines get cloned.
> >
> > Umm. If this is real problem, should kernel provide such rng in the
> > vsdo page using vsyscalls? Kernel can have special interface to its
> > vsyscalls, but we may not want to offer this functionality to rest of
> > userland...
>=20
> And then the kernel would just need to maintain a sequence
> number in the vDSO data page that gets bumped on suspen

Yes, something like that would work. Plus, we'd be free to change the
mechanism in future.

Best regards,
								Pavel
--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--h31gzZEtNLTqOjlF
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAl8AbIQACgkQMOfwapXb+vKmPACeIrmKuoNf1JXiUYxPw51Y90fr
M6oAnjRxd9sUbS8IWUhsIH7VWkQJzbQT
=mrV7
-----END PGP SIGNATURE-----

--h31gzZEtNLTqOjlF--
