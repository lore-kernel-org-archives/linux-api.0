Received: from mail.novencio.pl (mail.novencio.pl [162.19.155.164])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF59A3126D1
	for <linux-api@vger.kernel.org>; Wed, 19 Nov 2025 08:56:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=162.19.155.164
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763542612; cv=none; b=ZnTbP9IlcLrwSIzTvXw4VYVPaNuVssS7h7TuCqDS7wr+I1z6zOLxLHvAui4nsE4Ixfp5h5yxhCzi2jd1mguzLIObjbqpBzKPHK+xTsrqc4dLG/9lYLzE0KAwuNaxxxq1qGtwyMoTCdzAMh6Ac43LTfqGLF1Tw/ZBirEY6xO7ao8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763542612; c=relaxed/simple;
	bh=fIh67CnJs35z4uTVN1yEzBZIG1sWJSjOc8Phu/rB5ug=;
	h=Message-ID:Date:From:To:Subject:MIME-Version:Content-Type; b=ds2Eet6QkBAKfeSDGTZBwAMhFtHJ5lztAE82j8auKcU7aOE5wFVZG09Hg2Q2JhjV48FnBVwvK9SP0IUMnnDHn3mODsqvO3SHai3w+w6DfT0as7oF0B8EtavPofY+zVUwU7XOBJBtwLyL7wOn6Qd48BYvm1w657MBylYH+n/Xpgs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=novencio.pl; spf=pass smtp.mailfrom=novencio.pl; dkim=pass (2048-bit key) header.d=novencio.pl header.i=@novencio.pl header.b=dYAXe4Bk; arc=none smtp.client-ip=162.19.155.164
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=novencio.pl
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=novencio.pl
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=novencio.pl header.i=@novencio.pl header.b="dYAXe4Bk"
Received: by mail.novencio.pl (Postfix, from userid 1002)
	id 0CFBF24D2F; Wed, 19 Nov 2025 08:56:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=novencio.pl; s=mail;
	t=1763542609; bh=fIh67CnJs35z4uTVN1yEzBZIG1sWJSjOc8Phu/rB5ug=;
	h=Date:From:To:Subject:From;
	b=dYAXe4BkegvVeFBBy90ykNVqmYNnDYyvoflYU3uSBKiHxamnIbU4G+AmaYExZme9y
	 Oq8yAyqEtdU0r+cdlNwjj7tgRPEprr1EP7rVTVFUFxpdsTlRUqSHtykFx56AmzlEyW
	 gA1AAmMpn7ccHJit8RDvPz9tgjDpa+mXjORQm3OYduUpgkFZ1sTz8EAKtUqCTO/cmI
	 Ki0VFItC2DE8wZdaoqZ4xmeAflOq3T4lWoTFiU0Z5J0IuUYnY5vOXAlh18ypxY3uYS
	 GXNK0R1gv/4kS3/9hBw52bu0OR3H9SvrUb1MFc1h5kAAZTEQrL02/04/eSy+gHm2Mi
	 ktabytUllwz2g==
Received: by mail.novencio.pl for <linux-api@vger.kernel.org>; Wed, 19 Nov 2025 08:55:55 GMT
Message-ID: <20251119074742-0.1.5y.z3pn.0.0qcc0llb2o@novencio.pl>
Date: Wed, 19 Nov 2025 08:55:55 GMT
From: "Marek Poradecki" <marek.poradecki@novencio.pl>
To: <linux-api@vger.kernel.org>
Subject: =?UTF-8?Q?Wiadomo=C5=9B=C4=87_z_ksi=C4=99gowo=C5=9Bci?=
X-Mailer: mail.novencio.pl
Precedence: bulk
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Dzie=C5=84 dobry,

pomagamy przedsi=C4=99biorcom wprowadzi=C4=87 model wymiany walut, kt=C3=B3=
ry minimalizuje wahania koszt=C3=B3w przy rozliczeniach mi=C4=99dzynarodo=
wych.

Kiedyv mo=C5=BCemy um=C3=B3wi=C4=87 si=C4=99 na 15-minutow=C4=85 rozmow=C4=
=99, aby zaprezentowa=C4=87, jak taki model m=C3=B3g=C5=82by dzia=C5=82a=C4=
=87 w Pa=C5=84stwa firmie - z gwarancj=C4=85 indywidualnych kurs=C3=B3w i=
 pe=C5=82nym uproszczeniem p=C5=82atno=C5=9Bci? Prosz=C4=99 o propozycj=C4=
=99 dogodnego terminu.


Pozdrawiam
Marek Poradecki
