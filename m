Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.41
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793726517;
	b=AFO7sdQZMrLVzTsw+9PWzQjFMK1MoFHnAGAWeIg9qlwl7e4gHdkTR0xbM68wgo5caENi
	 zUUsV+BoycYAJqMWlxeD60pcMGb0k7DyK5Owdj11NOKqMHSQmTaKQoEKoNHGuws48VXgi
	 K8rGRxVie6XiGM2sz45Pf6sMm/bd0MJX2uR4QYrKnUotM3kjIteoYm5+UH0S4EmrEeU9/
	 4ykvLjZIGaJ9ebS5EYd9sq5kLbuZ4JOBU0fFRTdRHtFY+beuaMRZp6drhBXx7Oclyr0e3
	 x3MpwRra09+pjalqmepmQQ4rgmAww2NoQ4G0M1EQOat1cBMJRHTa6jh/5AEcIoF3dig==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793726517;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Mime-Version:Content-Type:Date:Message-Id:Cc:Subject:From:To:X-Mailer:
	 References:In-Reply-To;
	bh=AD4L42H0HNVoYlglqMFr39a2BJYBFr7pQM1pceNP/MA=;
	b=l6tUENQDWV78CyUuu8++ufv86CZgDfAMO4Gaezm5py+VxnmDlqh/0epllW+IcaXttVyP
	 IG8ku7YieOByMME+SMPINuJY05oYV6ezvf3UIT0VABsoLRRxXQ/fT7Qx3li13ibS3Ky/E
	 uX+h60xAIclz0C0l/buZqxH74lq7RmueT9GJxQDBCslu4qo5eZVC+4EHsNtJJ+DY6yZ4F
	 ycO4hmWfxm5aD4q6j+v/D0XsH5tSkDw7RCjjQ5qr4MrzwcTxrEg51acfkROvGM+KRdgwY
	 +eH8GKzd63bmtYVsU30gRRKom8EP1q8MVUAveFJtfUAPJILLkZy0q4o7i+h+IjzhZMA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b="PPSaT/cx";
	arc=none smtp.remote-ip=209.85.128.41
Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82933606A324
	for <linux-api@vger.kernel.org>; Tue,  3 Nov 2026 17:21:57 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 82933606A324
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=PPSaT/cx
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-4a4dc547987so22639715e9.0
        for <linux-api@vger.kernel.org>; Tue, 03 Nov 2026 09:21:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793726516; x=1794331316; darn=vger.kernel.org;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-type:mime-version:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=AD4L42H0HNVoYlglqMFr39a2BJYBFr7pQM1pceNP/MA=;
        b=PPSaT/cxmZ6hURUQKCutb+9MNl3fhi5qn8d5wFV015ZFNP0p7wP/UMc9QWwSCjKlPZ
         zL/DD7gvjUVS1WwDG0vy7qUtdL4e9ZBG8lQnrDRgkfIUIZlbzvv/trLSefcWiQBKSr6u
         RWiOf73SY7QM6RfyYuZu6k4tR5WiWRRKh/RIeV0cY5iHRsNLK+hTXF4APDRoBkCtO0ct
         XYVAwfYwEMmz7BR45aY/9jxlYMj2cVxDIW7S6WMomC8Q4pSudP/vALucJz1DmpNouKJK
         rA6xG/hBuUMhhOF7kKRJNPw+Wh4MOGJIc9m2NaRK8UCv+/ZvMWsAaIltcn9U+q8NCPVX
         b5Xw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793726516; x=1794331316;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-type:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=AD4L42H0HNVoYlglqMFr39a2BJYBFr7pQM1pceNP/MA=;
        b=GPwSM65LRKZ3cUH5laxAAXGlWZzyGy1O1Qo26ecsN2mKHMMndPf8k6+cx8IUGMRWIq
         yIFuChGsuCI6E5B0ndj61g7Mibfs4PcpoOYPK3sDxEbafjpSzyyxnYELT/jCD+GhT16t
         uLOYvnBtS0FXHVERZdjuW6ZMvPZ+05aj6MCTYUJ3PqSlOm03wDKD5G/M3StH7qaLKeyl
         22vbqlS+b+9xjk/SQnxFvNW3BR2EhVqRHV2J19NNGahBuc17z5aF72wIKSk1yHCGeszT
         WxYUToJOrHxKxRkCw9jLgDeEV12O6/hl/DGiCkXWDPwh1pw9hQGPJi040Qj4KgPbJ8/I
         U2bg==
X-Forwarded-Encrypted: i=1; AKwUvBzVs5nq92Msh+fjwt/iWMmpaLDswU2ZVVHCa9cwcaZvR82Uz8zouNBViWUBpr4uTnQyopSawtzj2b0=@vger.kernel.org
X-Gm-Message-State: APuU4Z+jsSErHzNVn6UE7ZoMgdegqghSfGX48LZK3GW6qEIJVPEcZ3HV
	4WF+MMLiw8QwtNFdyiED6FIzRRW1dQQm9pck3acCxp66hrR02GeHsSbG
X-Gm-Gg: AYBFou0oZ/vy4JnGGE8g+Y5YDwqACVY053zlknMepyExC7d0tM5YAH/kzl2+5iXgQY2
	NH1jgF/jox7B1JmMqH0YDyqIaSjbvVadk8EZyRjUbs1zcjRZd8TOdkUsqtCnRQMZBx7bpI9953s
	JfqfUKQiz3feDL4D3le5tbDLO91ajZDv4N8t7Ax9MbP7r+6WjB8jweo6gqfoKaHUSWbviiOEdV0
	1cnBI6ELHQZVB0+2Na0ZK2g+50VEPHVEeS/NUyHp2jPAu5h3ttVlIIxLHLXQsGLuDTKniYF7qrH
	VUgrL9oJq0SJedaCiqzJP5qNOgOQfM4k0/vG9GptvS7K+ncGjr70d+y41Au7svuMfm/EWky8y5c
	Ev5+WyvO15IUxv9E1obvNECvR5mbC+Ep3RKFQtlK9yx5NIzbMdAGc51SNWYIBp7ocDbSlD91knG
	J0f4jwANozLpDv/h1rIbrpQQQfvKy/nPlY/o7VAn1kPK+E675drqT367z5PpdijMZ+QOuhdk6Me
	5dRGS7ccUF0nKcLqc5wcaZP8hH/vkusB+SSt6IHEjCLqS76pl7mqwc6W91/Kq5dWyrrSGujP8yh
	uxM+9vDcHZ5nothfYVki3pLF
X-Received: by 2002:a05:600c:3b0e:b0:4a7:7d22:c50c with SMTP id 5b1f17b1804b1-4ac150b2243mr345177055e9.2.1793726515970;
        Tue, 03 Nov 2026 09:21:55 -0800 (PST)
Received: from localhost ([151.60.201.12])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4ac0a66caefsm287061365e9.5.2026.11.03.09.21.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 03 Nov 2026 09:21:55 -0800 (PST)
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
 boundary=1ae0fec9eeabe43856471b243f1ece3413edf7686407593b3575066613d8;
 micalg=pgp-sha512; protocol="application/pgp-signature"
Date: Tue, 03 Nov 2026 18:21:53 +0100
Message-Id: <DMLQZCDREHI8.1PLK04U05AP4S@gmail.com>
Cc: "David Sterba" <dsterba@suse.com>, "Alexander Viro"
 <viro@zeniv.linux.org.uk>, "Christian Brauner" <brauner@kernel.org>,
 "Namjae Jeon" <linkinjeon@kernel.org>, "Sungjong Seo"
 <sj1557.seo@samsung.com>, "Konstantin Komarov"
 <almaz.alexandrovich@paragon-software.com>, "Chris Mason"
 <mason@kernel.org>, "Jan Kara" <jack@suse.cz>, "Yuezhang Mo"
 <yuezhang.mo@sony.com>, "Chuck Lever" <cel@kernel.org>, "Darrick J . Wong"
 <djwong@kernel.org>, "Sean Smith" <defendthedisabled@gmail.com>, "Andrey
 Albershteyn" <aalbersh@kernel.org>, "Pedro Falcato" <pfalcato@suse.de>,
 =?utf-8?q?Pali_Roh=C3=A1r?= <pali@kernel.org>,
 <linux-btrfs@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>,
 <linux-kernel@vger.kernel.org>, <exfat@lists.linux.dev>,
 <ntfs3@lists.linux.dev>, <linux-api@vger.kernel.org>
Subject: Re: [RFC PATCH v3 0/5] add provenance time (ptime)
From: "koraynilay" <koray.fra@gmail.com>
To: "Amir Goldstein" <amir73il@gmail.com>, "koraynilay"
 <koray.fra@gmail.com>
X-Mailer: aerc 0.22.0-0-gc2f86b7abde3
References: <20261101015551.786044-1-koray.fra@gmail.com>
 <CAOQ4uxjkG=1j1z==Mv4wzkF042rXstodokKnBfMFBf2e-Eztmw@mail.gmail.com>
 <DMLJE2Z57AD9.1W22LSE7V9HH2@gmail.com>
 <CAOQ4uxiMLDgMXuij99-43UfCqfZN2a=CTet560o_RzU2m_Y4SA@mail.gmail.com>
In-Reply-To: <CAOQ4uxiMLDgMXuij99-43UfCqfZN2a=CTet560o_RzU2m_Y4SA@mail.gmail.com>

--1ae0fec9eeabe43856471b243f1ece3413edf7686407593b3575066613d8
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8

On Tue Nov 3, 2026 at 4:12 PM CET, Amir Goldstein wrote:
> On Tue, Nov 3, 2026 at 12:25=E2=80=AFPM koraynilay <koray.fra@gmail.com> =
wrote:
>>
>> On Mon Nov 2, 2026 at 3:54 PM CET, Amir Goldstein wrote:
>> > On Sun, Nov 1, 2026 at 2:57=E2=80=AFAM koraynilay <koray.fra@gmail.com=
> wrote:
>> >>
>> >> This is an initial implementation of a new timestamp to indicate the
>> >> time when a file/directory was initially created.
>> >>
>> >> This patch series takes inspiration from the one by Sean Smith
>> >> <defendthedisabled@gmail.com> [1], but using
>> >> file_setattr()/file_getattr() as suggested by Darrick J. Wong
>> >> <djwong@kernel.org> in [2].
>> >>
>> >> The semantics of this new timestamp should be at least these:
>> >> - it should be the same as btime on a newly created file
>> >> - it's user-settable, so it can be preserved for backups, filesystem
>> >>   conversions, archives and any similar operation
>> >> - it should be preserved every time mtime gets preserved
>> >>
>> >> and the correspondence with the other timestamps is as follows:
>> >>
>> >> ctime <-> btime
>> >> mtime <-> ptime
>> >>
>> >> Examples:
>> >> 1) a .zsh_history file created in 2019, then after a few years the us=
er
>> >>    decides to switch to another filesystem, copying the .zsh_history =
to
>> >>    the new home, in that case btime would have the timestamp of the c=
opy
>> >>    and ptime would have the 2019 timestamp (just like mtime would hav=
e
>> >>    been preserved)
>> >> 2) a symlink created in 2020 from the home directory to a /path going
>> >>    through the same process as the .zsh_history, in this case it woul=
d
>> >>    also make sense to sync the ptime to the 2020 timestamp instead of
>> >>    keeping only the btime (so the inode creation time).
>> >>
>> >> The proof-of-concept code (for testing) for stat(1) and cp(1) is
>> >> available at https://github.com/koraynilay/coreutils (master branch)
>> >> (Note: these coreutils code changes are a prototype and won't be
>> >> submitted upstream as-is, but they work as expected in simple stat an=
d
>> >> cp -a/--preserve=3Dptime tests)
>> >>
>> >> Lastly, the name "provenance" and "ptime" are not final, I personally
>> >> don't have a strong opinion on any name, but while testing with stat(=
1)
>> >> I noticed that "Provenance" is definitely too long for the normal
>> >> output, so another option which would fit well is "Origin time",
>> >> abbreviated as "ntime" (OrigiN time) and not as "otime", as that woul=
d
>> >> conflict with btrfs' internal naming and create confusion.
>> >
>> > FWIW, I agree that given the existing uses of btime and crtime in the
>> > kernel and various XXXprogs, using 'ptime' for kernel code is probably
>> > the lesser evil.
>>
>> What do you think about the origiN time (ntime) (Origin: in stat)?
>> It would also coincidentally be alphabetically (ntime <-> mtime, n -> m)
>> the same as btime <-> ctime (b -> c) ahah.
>>
>
> Honestly I don't know.
> My new idea is don't publish it in statx() at all.

Well I was more talking about the actual variable names in all patches
ahah.

Thanks,
koraynilay

> Thanks,
> Amir.



--1ae0fec9eeabe43856471b243f1ece3413edf7686407593b3575066613d8
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQRJ2XvJtXGwULYEerQ0bnTtJTDoOAUCauoYMQAKCRA0bnTtJTDo
OI2UAQDfLMxbWJxZCtj5g/a2TQHWFv3yLHmv7IEjclN8pYY5IgD/VFtdYZ3g+FW5
oxEEhXF7xBfTTV5O+6Ag8QIL/lM51wc=
=XiPH
-----END PGP SIGNATURE-----

--1ae0fec9eeabe43856471b243f1ece3413edf7686407593b3575066613d8--
