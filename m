Received: from mail-wr2-f2.google.com (mail-wr2-f2.google.com [74.125.225.66])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CF2742A16F
	for <linux-api@vger.kernel.org>; Wed,  5 Aug 2026 16:50:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.225.66
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785948636; cv=none; b=ZeatiZ6EZNfW1W0i7tkKh2f4A56WmnWBtYBHzgr/odDzRn0yM4Ro0fqi8C5CVP//q1rJUkMPD3a86Qluk03WKapJ6ClkjwB8W6/sTEh3uukzfyewl+MvApUi9Pa3yWsWmkjV3iWy02Fed1ComslrMkAG6tBk3RcBwqyzLtiVhpo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785948636; c=relaxed/simple;
	bh=BszZ6KBeKZ6Qg3CtgvJEAnRrVNmYR4/7gcB+znjO7EI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RZpXd/NU1Rq5sAAcjhfdCQ3G9LDjl1ukEbZdw2+/fEQ1X8PRVjdWwaZAThNIMLp03AYdT/VHT25v8XQS2d50YnJsv3MLH7Hvk/zhEmWcchv+pN87mre7FJcMLdO3NEq2JEr7B+fYZqV4nLusnsuvlvGKaAC6OzWb3Z+2oA+v/qY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=ZHVUv/NU; arc=none smtp.client-ip=74.125.225.66
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="ZHVUv/NU"
Received: by mail-wr2-f2.google.com with SMTP id ffacd0b85a97d-47f7f93b3d4so222233f8f.1
        for <linux-api@vger.kernel.org>; Wed, 05 Aug 2026 09:50:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1785948632; x=1786553432; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=d+VuNurPstAmXmltuo2GrH5As/aKoCfWEX/g2T2jGFE=;
        b=ZHVUv/NUYJ33hELhK5Hk0kFOaOTBBPuQSkD29UmYqwP/PK8SDly698gOYsvBZlbWDU
         fYisgUfxVg4bXXYMHKHtVpSHTYwtAXEV/TZ7WPAmiH1CpCGhVDfCxx+eDGpdW65MhH0s
         z9tjGEQwkOtnIW1f0GyVIJwDn8xfdeGu6gIvnw/QZuvw6KX5Q/ZEGWm2qecMri4yomyd
         hENIKhRIT0tQMFohErC2B8eqqDy62QIUrtytuy5sjCME+gShmummldnvQsGYX6JnRhSY
         KrRFZLdlTyP8bCOi3SFMszApBpE8oZxLH4l+ZLC16t/eXVznNlrQ7VwKQg7i++7lWDaI
         T0zw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785948632; x=1786553432;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=d+VuNurPstAmXmltuo2GrH5As/aKoCfWEX/g2T2jGFE=;
        b=ayWqVA+nCjrRN6g+sfobydv0ekmFLTunjoT8MXTLARYCmdp2aMuNH4EsWmz88k1sfR
         PJUrd1Qk+gyN6PlByAGG8lRMj3Ou4XShdFFbsLxu1H61W8zIwrsAOw7x/JREiLsp47OY
         FNb4X1GXr8u8uZ9/8CEw3fcpx0zUjbsKGsif7QPBHw4xnxpYd7tSsAiU0bTZ/SRhaYu/
         iqLPVm5vANyJ99w9VWYcDZoQpIU/TNjSYXY/KABpQsZykZhdCXUHd6XbtU5v1fPNJlzH
         wcMhtPoGuVfxT6X6foabIp4lCJ6VlJc8DDt24cTOmM/S69SRBpyURRSWkJ2M/3qRF6KX
         VbJA==
X-Forwarded-Encrypted: i=1; AHgh+RpX78DAgthF2qF7C0hyv1mWmP0UkvOZi/4azvGAQ23gMnSbjvPD3e5G8tTdes+GjtKmzdMV/HiqqNY=@vger.kernel.org
X-Gm-Message-State: AOJu0YwazhwPu1S2yMnZVecN70V7CQPb663FfEFbizO9fQfo334zDGjj
	1Z0rJEnO6ChroIx+zrvuR3YL/sDSQtm4zh9Q0TI7KqLi0b/+vFgX/m5unmBI9mYJBUU=
X-Gm-Gg: AR+sD11LeK4ppEIBPo6wZ7B3guEkGQQykLS4KXV/IMc85lYjP+EBq9Q5dR1r+n5Ezh2
	fXzZghNhb3opnTf7ZgLIn7zDKjYo+c6bgbhcEOdKKD/pml04a+Ou1VrnqnAnPeqOc+sI/2meXj6
	G4MwR/41INXXhtxYFCzHaeU0aXistRG5CUN9Pk0faBqFKRQb0nqY2DGTA9tejcUtKOuahLAaDu4
	NZa4bzwfNyMjfsw4Z2kJ3Jv8OOd17PkSHxA0DR6+kNbl5Laeioj64PDtCVZ8CTofV63wk2UOf1p
	55i+dN922x++KEnG1cmdcFXZvxIn5HlFwC9CT4XkWI5wA4ej6K15qQlRMeEHHEOOo+iKsVd6Gcp
	XaVhbXNkbdCTsYcatHO0/oXZZUy3ACjZSVQTCjCjeRVIdcrHJhotmJP0qFCH5I7eKlWcV7KcCrq
	KoPdtsQlEfNSQhk/O0wS6uZWS3wEUwrRjtO8suyYhsSRa7cPGT7ae/tFZ7NaR4Wf1Z
X-Received: by 2002:a05:6000:d4f:b0:47f:9d0e:f8f with SMTP id ffacd0b85a97d-47fec627a65mr12452020f8f.26.1785948632621;
        Wed, 05 Aug 2026 09:50:32 -0700 (PDT)
Received: from localhost.localdomain ([2001:af0:8000:1409:193:86:92:181])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47febf7e5bdsm9821153f8f.0.2026.08.05.09.50.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Aug 2026 09:50:31 -0700 (PDT)
Date: Wed, 5 Aug 2026 18:50:30 +0200
From: Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny@suse.com>
To: cgroups@vger.kernel.org, containers@lists.linux.dev, 
	criu@lists.linux.dev
Cc: Kamalesh Babulal <kamalesh.babulal@gmail.com>, bpf@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org, linux-integrity@vger.kernel.org, 
	lxc-devel@lists.linuxcontainers.org, fuse-devel@lists.linux.dev, 
	=?utf-8?B?U3TDqXBoYW5l?= Graber <stgraber@stgraber.org>, Mike Rapoport <mike.rapoport@gmail.com>, 
	Christian Brauner <christian@brauner.io>, Adrian Reber <adrian@lisas.de>, 
	Kamalesh Babulal <kamalesh.babulal@oracle.com>
Subject: Re: [ANNOUNCE/CFP] Linux Plumbers 2026 Containers and
 Checkpoint/Restore Microconference
Message-ID: <anNn1INJrRef2ViZ@localhost.localdomain>
References: <7959ba0b-c39d-4cb3-8269-482d1d593257@gmail.com>
Precedence: bulk
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="7ozpukrxhw32oga7"
Content-Disposition: inline
In-Reply-To: <7959ba0b-c39d-4cb3-8269-482d1d593257@gmail.com>


--7ozpukrxhw32oga7
Content-Type: text/plain; protected-headers=v1; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Subject: Re: [ANNOUNCE/CFP] Linux Plumbers 2026 Containers and
 Checkpoint/Restore Microconference
MIME-Version: 1.0

Hello.

On Thu, Jun 25, 2026 at 09:25:58AM +0530, Kamalesh Babulal <kamalesh.babula=
l@gmail.com> wrote:
> We are pleased to announce the Call for Proposals for the Containers and
> Checkpoint/Restore Microconference[0] at Linux Plumbers Conference 2026,
> taking place in Prague, Czechia, from October 5 to 7, 2026.
=2E..
> Please submit proposals through the LPC 2026 abstracts page by August 7:
>=20
>         https://lpc.events/event/20/abstracts/

Just a quick reminder that the CfP for the MC [1] topics is just around
the corner. There is a chance to bring up topics of _your_ liking.

Regards,
Michal


[1] https://lpc.events/event/20/sessions/267/

--7ozpukrxhw32oga7
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iJEEABYKADkWIQRCE24Fn/AcRjnLivR+PQLnlNv4CAUCanNp0RsUgAAAAAAEAA5t
YW51MiwyLjUrMS4xMiwyLDIACgkQfj0C55Tb+Ajh6gEA+JVKvBO47pbrAwGAdZKn
odfo4fAHSl0NLd8LTjOZA9ABAPg+Z9QFz4yhF4juz/IqW3AL7DcP/4GylW4G2PcG
K90I
=KTnA
-----END PGP SIGNATURE-----

--7ozpukrxhw32oga7--
