Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.41
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795444270;
	b=HXrqElYJAZwitzgcZWSDo5YeAXFldjMR5YaBlJSvt+MZrmUtJQZzOphZDFvlE8KyFUbz
	 SAY7qdwQ6t3WPo2t9EhIk0JfrK1b0TXGHpD2i9kCH9xsxXQz7EgtMQjrS5jSW/EtUYndJ
	 iYHUccTs/YHRohmromKgZhRnjZPd+8XTx7D/iRe628hf+5KQiQq6UyvLd8WlvnFb3bFWE
	 pXaPfiRBtmXdMR24sRegccrhCSeTvdsYVrWKWmH3NJMd9I9CHx5yB/gKIooPQGRtYP6uj
	 I7iXfRtaPcsNkFFaNd2HRYBHrRkLx6UgbsGxQxSVGAZivgPdzLEJrQkC+JzcWpLI9dA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795444270;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Mime-Version:Content-Type:Date:Message-Id:Cc:Subject:From:To:X-Mailer:
	 References:In-Reply-To;
	bh=Q4jTJ4I7+4H3U2t4gGtedRgvTT6Hqn+CljxWSv/Jr1w=;
	b=pHAWQHKBddymhwfrSgTFkltSxcrTIgsEtVaNerVMatRPezH1WC4x1jbcD/X9JQy8i623
	 0zsBYM1RqzDM3481Ye28ABoECFTLDtSPpCNLAXD1WaIZ7viUwf61qvbeY4IOJz8ckeyGU
	 l1cq06T7ypBEZXqCXtwmiOjLxIkymxjFNHvV6wo2TsLu72w4GT0Prxv/nx8m2JcKg6X20
	 AwjntYnKzZaRLAw09GP8JsNJm5scvrZ0bzyd0tUQ9JWyb7ylE0RqDqlKhSaDhM6nrv92t
	 cgdAryVT0Elr8fJ39M3qEWfR1zDCQBETZvfqU+iJsjpNM/J30n84AfvR7yoekUI62SQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=VETaX+Oc;
	arc=none smtp.remote-ip=209.85.221.41
Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com [209.85.221.41])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9458606A32A
	for <linux-api@vger.kernel.org>; Mon, 23 Nov 2026 14:31:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B9458606A32A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=VETaX+Oc
Received: by mail-wr1-f41.google.com with SMTP id ffacd0b85a97d-4ac08f4a0b2so2417045f8f.3
        for <linux-api@vger.kernel.org>; Mon, 23 Nov 2026 06:31:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795444268; x=1796049068; darn=vger.kernel.org;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-type:mime-version:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=Q4jTJ4I7+4H3U2t4gGtedRgvTT6Hqn+CljxWSv/Jr1w=;
        b=VETaX+OczrckAdA40CS7vxCZvBrG7y727OkscWpuPH8NoqiwvNXiRk+iJHMiEnyahS
         RBfZSEAqPImQAgWzcD9CuB7TFbHgO7sTwpuUTArl1ERE2IPVFTM73x6AvLE8XuR2BQtI
         NfM/EDLchi7RpmRnIOG/fzpQ1VgdnuEYs56uKDFZJTocpt3Rphhzad1vr6ivfPvQfs7q
         zDPLeOj/0veY/zCOvit2isQTXe6V7TaBZ+m/Npv6BE32nGK/+xrI7JVkEb55IXUlhXV2
         5UmV9Fzv40OpemFZElWoQEjVt/wI5iQduzGzqM2a2l/IFqmMlSFsl3sDpjo6ExZub6aC
         DrRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795444268; x=1796049068;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-type:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=Q4jTJ4I7+4H3U2t4gGtedRgvTT6Hqn+CljxWSv/Jr1w=;
        b=A9AfzuDpRs8tua0DlMOiQNhy8iNqbFfWLhsbeAqMp8u83USrMZi1xafv1NehuGZtBG
         tw8pR0kds+L/ZQP7AQZlyunOo+1AuY8CqutROsdpju0pYMrPjN2CpZPWmFMhVFCMRmq4
         CVUSlwy7JOZ4xclU+4x6htyqfMCfqiTZ4rL6h16oGKuW1s1CE+DGJ9SQjzvniucpgH16
         9jtI3ppg4hX/KEYOnkFpg/SV59NOj5B8590fNHTIX1pjhetevyUCuKdbgMOjys/4eAQL
         0SXzF32jlTJz4HvdscSATK9b3KqvZbkzXShBNDoeqhv6MK5iV5qlpmluvDJW6D24Cimu
         HIcw==
X-Forwarded-Encrypted: i=1; AL+hErFi1i4UEfc7F6R/9i93DWC16LlH1QqJAi5Y3WDyNloxDxvtRh4qIvj2DNensJCg1Q1kiqzX97iYVuw=@vger.kernel.org
X-Gm-Message-State: APuU4Z9lN8QnqHT9sg9qYzjcgQbUP6mBEB3pEcSD0ILRknBqE7BWrMYN
	nAcKolr3UriXtYObHwpnMW60SPjpMGR1Gxae1FQ+rWPgAiZvLb1wvOkS
X-Gm-Gg: AZFdTZe/oGmIzniRpoo6C+hiJHWbjqbIEvtCeXpoQIPdVlxdDe71vg7esB8YRypWXdv
	yg924fAbBQTSg4DbfoDxfBWYxX4RVFxtQiz/j8xD0Vm8bx9Er06N/CBhYegm7EjaRsibgmQHIKw
	tZpdfgGlRyZp/5jDZRG12xV3r+FRDIsecfLeu3DFshyTQ6A4vZDB0UA8URy7vxzFSZMrGCW+Wbi
	mgqvZNdTMprKWN7DalGWhAKUFojOkfT8BNbqZMattmglq5zbUX6AQ3C/wRYOSCHiK66PbpPAhpo
	MsVmgevt2gyehvMlAPHWHD6P+hO9FkxJFqGHR+mu2L5hIEkDzaYyJzkfaL7VxBfYWld6GhpdoaW
	mHUV82bGUKQPN/HVMtseV6YV1m9pIwP8PIUSJl4QP1AGZ87y7y0IcqJT1LKz6AU+mBmbnUK1OS8
	EPbgpvSfotFphSlXUS3CGKaTU7Qv7TjH+FZIgnKVjBlbMpDdlhldwJUMTiJfefJpmG0nH61gG3X
	Y6eHdIU4F4phYNcKRP1x+vxnphYe7FEJVU97MMMr4R5WPtkuIJ2skA/AxXCIkRfa9/+8NmVip4b
	nqsYK3wx9Fx+N5JouSNFVfTH4g==
X-Received: by 2002:a05:6000:4616:b0:491:8286:5f0e with SMTP id ffacd0b85a97d-4abb514609amr20025380f8f.55.1795444267943;
        Mon, 23 Nov 2026 06:31:07 -0800 (PST)
Received: from localhost ([2001:b07:5d26:7a6a:365a:60ff:fe0d:cfc6])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4ab6b205443sm23631206f8f.39.2026.11.23.06.31.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 23 Nov 2026 06:31:07 -0800 (PST)
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
 boundary=dc84db75a66914bb784f1de9596eb2f7bc5819cd207268d8e5d18dd76353;
 micalg=pgp-sha512; protocol="application/pgp-signature"
Date: Mon, 23 Nov 2026 15:31:05 +0100
Message-Id: <DN2NVGUNO0GA.89JAB2PVI0LA@gmail.com>
Cc: "Namjae Jeon" <linkinjeon@kernel.org>, "Hyunchul Lee"
 <hyc.lee@gmail.com>, "Alexander Viro" <viro@zeniv.linux.org.uk>, "Christian
 Brauner" <brauner@kernel.org>, "Chuck Lever" <cel@kernel.org>, "Jeff
 Layton" <jlayton@kernel.org>, "Jan Kara" <jack@suse.cz>, "Darrick J . Wong"
 <djwong@kernel.org>, "Andrey Albershteyn" <aalbersh@kernel.org>,
 =?utf-8?q?Pali_Roh=C3=A1r?= <pali@kernel.org>, "Lauri Gates"
 <lauri.gates@gmail.com>, "Christoph Hellwig" <hch@infradead.org>, "Dave
 Chinner" <dgc@kernel.org>, <linux-btrfs@vger.kernel.org>,
 <linux-xfs@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
 <linux-fsdevel@vger.kernel.org>, <ntfs@lists.linux.dev>,
 <linux-nfs@vger.kernel.org>, <linux-api@vger.kernel.org>
Subject: Re: [PATCH 3/3] ntfs: switch to the new xflags fileattr API
From: "koraynilay" <koray.fra@gmail.com>
To: "Amir Goldstein" <amir73il@gmail.com>, "koraynilay"
 <koray.fra@gmail.com>
X-Mailer: aerc 0.22.0-0-gc2f86b7abde3
References: <20261122000856.536902-1-koray.fra@gmail.com>
 <20261122000856.536902-4-koray.fra@gmail.com>
 <CAOQ4uxgc6pP+_xvJMbqj6wOdGzS75Vn6x6i_vUfCJDD46DAA_Q@mail.gmail.com>
 <DN2N0BY83OY2.1OV3ZAZFSWCDG@gmail.com>
 <CAOQ4uxg9O-R_SUPAZ75ESGB99-4Z4EEUKGMkCF2f-sXkGPq1GA@mail.gmail.com>
In-Reply-To: <CAOQ4uxg9O-R_SUPAZ75ESGB99-4Z4EEUKGMkCF2f-sXkGPq1GA@mail.gmail.com>

--dc84db75a66914bb784f1de9596eb2f7bc5819cd207268d8e5d18dd76353
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8

On Mon Nov 23, 2026 at 3:14 PM CET, Amir Goldstein wrote:
> On Mon, Nov 23, 2026 at 2:50=E2=80=AFPM koraynilay <koray.fra@gmail.com> =
wrote:
>>
>> On Mon Nov 23, 2026 at 2:00 PM CET, Amir Goldstein wrote:
>> > On Sun, Nov 22, 2026 at 1:09=E2=80=AFAM koraynilay <koray.fra@gmail.co=
m> wrote:
>> >>
[...]
>> > Rule:
>> >
>> > You cannot add a flag to common without carefully auditing all
>> > filesystems that support the legacy flag.
>>
>> Yeah, sashiko pointed out a problem in f2fs, and I could reproduce it in
>> testing, where adding COMPR to COMMON makes f2fs crash, it also needs
>> NOCOMP in COMMON.
>>
>
> I don't think this is correct, or at least not enough.
> My agent said that this breaks or changes things on  f2fs/ext4/ubifs
> I didn't bother to check if all of them are true - I doubt it
> bottom line - need careful audit and good testing.

Yes, definitely.

>
>> > FS_XFLAG_ENCRYPT can go into common but must also
>> > go to FS_XFLAG_RDONLY_MASK because it's read-only for
>> > all existing fs.
>> >
>> > COMPR is rw for some fs and ro for others.
>> > As with CASEFOLD, you cannot make it COMMON before
>> > converting all casefold fs to new API so that each can say
>> > whether it wants RO or RW.
>>
>> How's CASEFOLD currently handled? in the v2 I'm drafting, I added
>> fileattr_mask_to_legacy() and fileattr_legacy_to_mask(), which convert
>> between the old format (filtering by FS_XFLAGS_MASK) and the new mask
>> format.
>>
>
> Good question.
> Need to check this.

Can you do that? If not, I'll check tonight, no problem.

>> > I think there may be a way to deal with this easily since
>> > ntfs doesn't need to set either but not sure.
>>
>> We could export the 2 other helpers I added for v2 (xflags_to_flags and
>> flags_to_xflags) and make NTFS use them?
>> Though adding the fileattr_ prefix will make the current (v2) vfs code
>> maybe too verbose.
>>
>
> Honestly, I can't say for sure - you can try
>
> I think you may need a different set of helpers fileattr_prep_ used by th=
e
> filesystsems that are converted to xflags_mask, which may be different fr=
om
> the set of helpers used by the user facing ioctls but I'm not sure.
>

I guess I'll think about it when I move NTFS's impl to the updated vfs
code.

> The thing is - this is all hard to wrap our heads around
Yes.
> You and I have parts of the design in our heads w.r.t backward
> compat with legacy API, both UAPI and vfs internal api.
>
> I think you should put it in writing to see that you and I have
> not left anything out because this v1 surely does get it wrong
> in several places both wrt legacy UAPI breakage and internal
> API correctness.

I agree, now the version in my head is not finalized yet, so I'll do
that in the v2 patch/cover letter.

TLDR is "use the legacy to/from mask converters whenever needed, so:
- user legacy -> fs legacy: keep as the old code did
- user legacy -> fs mask: fileattr_legacy_to_mask()
- user mask -> fs legacy: fileattr_mask_to_legacy()
- user mask -> fs mask: pass it through

(before finalizing the GET path I want to finish the SET path).

Thanks,
koraynilay

> Thanks,
> Amir.

--dc84db75a66914bb784f1de9596eb2f7bc5819cd207268d8e5d18dd76353
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQSgVimKafU5DQMcjcDmj22qf5IGXAUCawROKQAKCRDmj22qf5IG
XIluAQCkRERpwhiWlAG1vnH4LLTLbZOFc6HLeE1vttoO1MkJnAEAs/LzOmQQYKAR
R7lCcHjWSuolpqeVgvCGo0f1qKCRTw0=
=50n4
-----END PGP SIGNATURE-----

--dc84db75a66914bb784f1de9596eb2f7bc5819cd207268d8e5d18dd76353--
