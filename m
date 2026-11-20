Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.53
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795185854;
	b=tVQKon+1S4bpqik3VuKKOvdkg3Ro1u9QqcsJCoJxrdhrJwF09A2SIB66DVWxcH5dFH0Q
	 haCZ3Bl1N/vfBCSX+4/Aqj/k8Y1eqW7xWAumKp9RWnnk63vI7R/CqrXXoXNYOXdp3k7vK
	 WWDiTCHkcR2yyn17V2ex2maaRBhiHVvTQNTSfb7MVv2Vk/NUeKdsmC/JaYdxQ6fj36DDd
	 V1w/nfRg1ne+U6g2QpUtyRXlJGP/R/u0nQCOEv4ovto90NtylrpQlCwH9osaVA9GpTYgC
	 gRaOX/jGUbKhddxGUcF0EjZMuOD2hdi68Jv2j/5S4cxuGfZlVtQsLMWaHQGDc+nfFuw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795185854;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Mime-Version:Content-Type:Date:Message-Id:Cc:Subject:From:To:X-Mailer:
	 References:In-Reply-To;
	bh=aeb62NrfYX2nWbFpQ3h7rH0au2pU37+u990yshAdsq8=;
	b=2VBY9h/Z7uUNWh4kDwWCffPkXdFJpEs6VUOqudq6guofDrGqip0LdCrU5Y+mfVeEsK5Q
	 ff5u/KhiCPVZn3LJzKS9vJX2A2yFio2UpqMAPhsEcXJyWjJ9/ORrqaPYr464s0LtsUxOf
	 hF5Qdylad2C7bFajA1rTqSYP8oQI5O/+nvMdTyMyObVVKMb/sYSd/TKbxXbM8clsfS//g
	 SJzG87u3n67+k2JdLIPRTNtUwbs3E/6AsBULxUaKyL5dN5PBtBB1xuVBS/+zbRpGXqZLF
	 lXMmNJjb+G+hcZA+LrgcU2jWJY1GNnwHmbL/0XA7HncS4B84wQyjROatUcKFjM015vw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=UCx2E0Sw;
	arc=none smtp.remote-ip=209.85.221.53
Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com [209.85.221.53])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF84A606A330
	for <linux-api@vger.kernel.org>; Fri, 20 Nov 2026 14:44:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org CF84A606A330
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=UCx2E0Sw
Received: by mail-wr1-f53.google.com with SMTP id ffacd0b85a97d-492fcbfaa88so604842f8f.3
        for <linux-api@vger.kernel.org>; Fri, 20 Nov 2026 06:44:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795185852; x=1795790652; darn=vger.kernel.org;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-type:mime-version:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=aeb62NrfYX2nWbFpQ3h7rH0au2pU37+u990yshAdsq8=;
        b=UCx2E0SwKcK/oqyYNLOz686VusYmii+3mMDSe2hm1s34x/9j7y81gtRcvRwLvYBz3L
         8OWonxeJ7ONGBIAdCYN28kX+LRG6+zE1qzjaKqtJdHF3MJBPWqGI5u3OnZMZ4nUYhE9m
         PEaUWEoqsvQP3IAgHgg36VjHmqvLstmO20zMnptGeWfnBQnfV8Xwbcf2i+5+HPE/je1g
         UffyYR0okyEW/XxdVXBfUQ2+CTA3+deWuJyIBQP4+m3bQJNmt6Az6/sbA917Q6G5mzbK
         Rj5vUQAl8Up+44D/OFiKqlCYJFj+9wTD4uBgXkGE6VmgSc/N2pGJihXdIl+6jSPw+Tjd
         ggNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795185852; x=1795790652;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-type:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=aeb62NrfYX2nWbFpQ3h7rH0au2pU37+u990yshAdsq8=;
        b=Rt1J7Jl21ZI2qhOBbti3hRWYkoFEhg+a+6s05dXLbJ4ydv+bNOoBKoZrRskk4GZsIS
         WFemp5mT5D5CiSskXIOPNLs0uI4+VQZy0rLZ4orA2LxyVl/pG94Rr8Tco0N3aIfSPF+b
         d6qWuFUetNU93T23zmJtOiS8njhZtj2HNKziAP5eJTrWW+TjguLr7JPrqQf8YaVDMJ4Q
         THopn7nAJDeZjwLzUZQu58Gq8qZB2+UTXuwNEC2tXEAdwldLjYNBpJ4RMZGGF5t40wkI
         nzukZ2MApGhqwWqa857yEbt7jnY1U80RcSkCWJvU9Z4s5Y3QhRaVdNUVFrqjVu09pa8a
         tBEw==
X-Forwarded-Encrypted: i=1; AL+hErHaoApWXfGkpYW1cnwX+vhEKnSRjDnWtMrhKtQP/rp9EIrAhkqiN7SMMVx2EndC8tLEwwEFxTq82x0=@vger.kernel.org
X-Gm-Message-State: APuU4Z/guL+NU4B5r8r7g1vCn3/lcmDYkuNuFL8rvU7FtlHOEAmlBZBL
	UT/Ln/zJqYPBZeV/awYdupdhXitjFNIBIWqBvBbDIerEOuXHbHouTb5H
X-Gm-Gg: AZFdTZcJ50bG5cYyCZUNebmwnbeAGmcpoRz4sM5PGw4DfTFuJ7ix/UKr1ITfEEyHs/m
	izWKHQ9bYZfolmpqayoCA7cWmhD72qVC2M/9XxOF2Z9mNB6OZycEg2hFE1BT3TAVGTL3ffEevvS
	fZl8hTzjpeacDCFBnXaEQmCCIny/4tCcDFu83k0AzGMCM9dy76Si1H0RgUWpKwuGwJw5ttEjTJn
	GURXZr7ftS0Ue4msbrnq8pLY7b7dQQVmlW7Bem1IX7niReGPriswBmoe9NpEyHwAQ2uTIJyYjmM
	9L7sMg51+GhUTbwn3NoYiiV7+PH/Q+6oxM6dK0NsnKxrRJpwQq95VUOrKxoRAx+VVhhvwzYeTJs
	90p/o2gJwu6yZM61+xfKEgc4wmNxq4rzUX9B/oKRtNM0aA9wagxhmREc946cZ5tNmc0m1bjTa2g
	/9ulVTumGnttitnzBWtKttWxwQ8tJFa1Hxx4SA7cXTiK9emKDJB9/nC18trKUdoIURIHZnVlVEg
	OUekR6H/u20sQGaMfFNIgT+WCFVnGuINEgZ2xTBwWJ1WQYDA0mEbRBiB08d6QKMaXUoWmoBurjg
	DW7D9ehQvFoutzD31k7QlLbsC3uSwJYap4edamJfR4urrGl3
X-Received: by 2002:adf:e014:0:20b0:491:8462:20cc with SMTP id ffacd0b85a97d-4abb400c0cbmr5198457f8f.37.1795185852061;
        Fri, 20 Nov 2026 06:44:12 -0800 (PST)
Received: from localhost ([130.192.98.149])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4ab69bf62f7sm6426849f8f.13.2026.11.20.06.44.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 20 Nov 2026 06:44:11 -0800 (PST)
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Post: <mailto:linux-api@vger.kernel.org>
List-Help: <mailto:linux-api+help@vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-api+owner@vger.kernel.org>
Precedence: list
Mime-Version: 1.0
Content-Type: multipart/signed;
 boundary=8a2bc4e8bd35bb6d32db85e9ae6f5058abdd79d3019902d3de598560ffbd;
 micalg=pgp-sha512; protocol="application/pgp-signature"
Date: Fri, 20 Nov 2026 15:44:07 +0100
Message-Id: <DN049T7Y67NZ.10CIWW8DE6PP5@gmail.com>
Cc: "Lauri Gates" <lauri.gates@gmail.com>, "Dave Chinner" <dgc@kernel.org>,
 "Christian Brauner" <brauner@kernel.org>, "Christoph Hellwig"
 <hch@infradead.org>, <linux-xfs@vger.kernel.org>, "Carlos Maiolino"
 <cem@kernel.org>, "Christian Brauner" <christian@brauner.io>, "Darrick J.
 Wong" <djwong@kernel.org>, <linux-api@vger.kernel.org>,
 <linux-fsdevel@vger.kernel.org>, <linux-btrfs@vger.kernel.org>,
 <ocfs2-devel@lists.linux.dev>, <linux-nfs@vger.kernel.org>,
 <linux-cifs@vger.kernel.org>, "Theodore Tso" <tytso@mit.edu>
Subject: Re: Concurrent FIEMAP on reflinked files serialises on the AGF
 buffer lock
From: "koraynilay" <koray.fra@gmail.com>
To: "Amir Goldstein" <amir73il@gmail.com>, "koraynilay"
 <koray.fra@gmail.com>
X-Mailer: aerc 0.22.0-0-gc2f86b7abde3
References: <av4Hn9u80fs8iHZ6@dread>
 <20261119095943.85048-1-lauri.gates@gmail.com>
 <DMZ4VQ7SZ07T.29WMPQ0BQZGSS@gmail.com>
 <CAOQ4uximow25oc=3XEN1ATgQvonQaTXtDPmQufxo75tJ=e355A@mail.gmail.com>
 <DMZJDGMJ1RVF.32ES391JKNFGP@gmail.com>
 <CAOQ4uxjVQ9cjV=_jBjQtNg9zCuWUEJT9KNYMKV+1jwBkHen5OA@mail.gmail.com>
 <DN03LWNSDYP5.11FTQ5KCWU2X7@gmail.com>
 <CAOQ4uxg0oq7VjhSQ0h8dBucdPfON2Q6tJQQqUy05sCaE10QRoQ@mail.gmail.com>
In-Reply-To: <CAOQ4uxg0oq7VjhSQ0h8dBucdPfON2Q6tJQQqUy05sCaE10QRoQ@mail.gmail.com>

--8a2bc4e8bd35bb6d32db85e9ae6f5058abdd79d3019902d3de598560ffbd
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8

On Fri Nov 20, 2026 at 3:35 PM CET, Amir Goldstein wrote:
> On Fri, Nov 20, 2026 at 3:12=E2=80=AFPM koraynilay <koray.fra@gmail.com> =
wrote:
>> > With non-zero xflags_mask, internal contact masks
>> > can be used for -EINVAL not for silent ignoring.
>>
>> What do you mean by "internal contact masks"?
>>
>
> I mean that users do file_setattr() with a bunch of flags
> some of them are just ignored randomly without any any way
> for user to know about it, because this logic is some internal kernel con=
stant,
> which cannot and should not be documented in the API.

Ah ok.

Thanks,
koraynilay

> Thanks,
> Amir.



--8a2bc4e8bd35bb6d32db85e9ae6f5058abdd79d3019902d3de598560ffbd
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQRJ2XvJtXGwULYEerQ0bnTtJTDoOAUCawBctwAKCRA0bnTtJTDo
OG67AP99DCLnFsLMHCsRAeUitR3pAiNRglGbALKnTbw7U718dAD/Rbb718IIJvnz
/T8g9StMlY2VrgWntvlMz+RabJ8OUgY=
=dJIP
-----END PGP SIGNATURE-----

--8a2bc4e8bd35bb6d32db85e9ae6f5058abdd79d3019902d3de598560ffbd--
