Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.46
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795443035;
	b=sdRoVHnUAV0thnSiMgWMVtCysO3EtlFJsR2jqRtiuzOPkkvXVpnyLVS6REMgvzMnqgXj
	 mhxXP6tgttznhBDud5BRqlOFRxPVm2sdP/3eFNnuoh+cxAqKuEPwrwhjSM1JWbdLS4qWF
	 oWVQycHAxvHBZCfe3aAjl/B9Ns2h2TJq4tfmFspIQV54SxiO1+b/g/dG7HmLIArA288LO
	 fjbX93eyEbptSJ50EQiJ4CLJeaTdqCs7n3ACp/juSq2cw/2wNORtQun1N7znzffjtyFlz
	 7y7Cr/K6j0kKKO/mzENcEhHqKm05l7EYTAzdLJ2Aqqdzr4LYVNiXaosB+F5zTDKMCzA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795443035;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Mime-Version:Content-Type:Date:Message-Id:To:Cc:Subject:From:X-Mailer:
	 References:In-Reply-To;
	bh=CuMgRbNwzbHcnBEprb4vp2b0/t/8wHp/89cdVf+1khg=;
	b=PtlRdo+SkCGHvGv3F3+DF26rzjBIV01cGUo2CfzDl5KznNietrkT+3Uvduk6Kd/GTpbz
	 Ko4hkpOWkfpJlZzqRPL5/ZTF2dAy7s3noUrJQx1I0WnRtW+89bsGcnKCbc205ZntO0v0u
	 jNOaRTs1MtHvdB3A5vmG0ZQYhvDtQP1uAGbTUcuGrD2xKKwYru/OObVi3llFGMCw/htJt
	 5jrdXQt7R2IlfQsz76pdJfL4sWZC9aEbGjDmAOlZ2stDsmccBX6EVPvwkEqQ0ybuyIvak
	 f4YW187ILFnq3zF6SvufBKqP/4+t3p5Vnuva62TeThIP1Nk6FfMnTWWJUFNarVlTbsg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=pO+zyumf;
	arc=none smtp.remote-ip=209.85.128.46
Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B1E7606A321
	for <linux-api@vger.kernel.org>; Mon, 23 Nov 2026 14:10:34 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 0B1E7606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=pO+zyumf
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-4bb666304fdso38539395e9.0
        for <linux-api@vger.kernel.org>; Mon, 23 Nov 2026 06:10:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795443033; x=1796047833; darn=vger.kernel.org;
        h=in-reply-to:references:from:subject:cc:to:message-id:date
         :content-type:mime-version:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=CuMgRbNwzbHcnBEprb4vp2b0/t/8wHp/89cdVf+1khg=;
        b=pO+zyumfN2hTCRi3iq5NLc4z3g1haVYIkxKoEw23KhrnoeCnmxoW4xCWvhExvnIJt/
         4gbKTdRC2pDBC5Hp1QDu+A0sp15J8QbF1uz26Txh9nn6GACU+5b0eGJf77ZBrYD4ljq+
         VVV3TAosIjsC5zJn8eKmTnnWhVsW6mimroaCxKkcPnOjrIMaRqjQxmZWMMEEHiUMLpCa
         5p6UsfMRL3fW14IdkB9Z+Y3d2oWg/54ukp4uCq+iKOIANK3taEUvY5lWq/haJ8zprVcU
         w6wYX1Nw8spA/Ix8oPfGxJSdQ1mRWnJ2ch5ULR24WELgRzxBIqSkStDAjP/XrMzlFrUI
         DGnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795443033; x=1796047833;
        h=in-reply-to:references:from:subject:cc:to:message-id:date
         :content-type:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=CuMgRbNwzbHcnBEprb4vp2b0/t/8wHp/89cdVf+1khg=;
        b=bYLshNeMddPdS2GgwzykzcqXyH4zJQI8HMtzvdYwEXZ1V0V1eFuaVguqC92Dz/qIvS
         7oKN42ZEeklg1zUpQALSddtN8TZ2Q7e1gGrUuQ6+0aiOuXwDosWRwrCxNMFXyOTbTiGH
         DnEkY7KQN4qqS2sHcOTWMg2GToVq8NXc6VesCMJ1CAhWrtXxmfXJIxkfpDcyAst+eUdq
         Jspcf3YE7WK0bgooP7cU15c6Ekq/MPrinrVBjln+ZhEjZTzDPILMyEd262iMlgHRQD/C
         Rz9bUkvOw0MtS5EkSHDTmryc2to/bQ6BsXuFeksmLVzFGhS4+dYKeQK1yUjWRrBoHRIV
         ZxUA==
X-Forwarded-Encrypted: i=1; AL+hErFzzoKf8VD4vqi8eTGlH3QefBzsc2jBsYrZO9VRR3WAxDXyetN+kO+SjOxyNDXr3vQQNL/W7j4rie8=@vger.kernel.org
X-Gm-Message-State: APuU4Z+UdtivMIxMUht1zrgwfT2s2MoeiDD3zU6hg19dLiSDK/qNW846
	0mywHxPb1+ATZvOxv3ZwIeAAAL7bXCle4EuU8YH7uBTLbq+1cQGCaPRd
X-Gm-Gg: AZFdTZemghnz9brAxvCqwPx2bdPOaD/8ERlev7anrfZBDU4M/wGlJ00tDbIhJBBlJ2D
	4zvJXYBZaA2sFSPi+e66CA1ipV6ryQBESwx5esJSClyNp2or2I1Sefb4vfNHgN3NM6rM2oaJ8Xn
	Kq0arPMto4eDwvJpmnNAXok94sMQuYI95IH6ArQMy+0c93esnMfPSiwMx9W2qiQHgHiWM092Je6
	Uo84Pd1Vap68WjXs/O4ibM5CMDwkr9BbR7xqzaVzX6JeTdsuI6RAbtYy87dofsWPYgRn6N6w/4K
	nt3D3cpIh9edPzbn4c64vsLn6P+XSSiqwdVvP+1lvUsjhfSth2G9LrpkplYpQvUl1M38yJV2Eep
	3ZFGvIonvzCB54Bo4veTKvaxVnkWjs3UzoWDmWHB+1Rpg8yN+Q0KNhWMd9r16nUuUaDk3Vou5Vo
	vi43WNYt+9cr9Syqj3hvkzs+Ddlh45/ytHW2LZD3U1dFgAO3Ha+vFM5bG7NNRSqcHZJ/q0zAa94
	vgewsKT0An6Bwbb0yshLa4znctaVWbecoVPGytWgpCpI9a2A2A/zpMvbfyZGq2bIfRXfoAnzyiR
	12/nD1YnKnfSUnJo6PXlXpQLK/8=
X-Received: by 2002:a05:600c:828e:b0:4a2:526b:d40f with SMTP id 5b1f17b1804b1-4bb88785898mr250028695e9.0.1795443033146;
        Mon, 23 Nov 2026 06:10:33 -0800 (PST)
Received: from localhost ([2001:b07:5d26:7a6a:365a:60ff:fe0d:cfc6])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb906817ccsm170559065e9.5.2026.11.23.06.10.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 23 Nov 2026 06:10:32 -0800 (PST)
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
 boundary=b1a345f2b4a5254b3632da7c1e235601a7730bbbbe126372d6b8eae348d4;
 micalg=pgp-sha512; protocol="application/pgp-signature"
Date: Mon, 23 Nov 2026 15:10:28 +0100
Message-Id: <DN2NFOEO4XGN.1PEF1SWOF7YCQ@gmail.com>
To: "Amir Goldstein" <amir73il@gmail.com>, "koraynilay"
 <koray.fra@gmail.com>
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
Subject: Re: [PATCH 0/3] Add f*_xflags_{rw,ro}_mask flags to the fileattr
 API
From: "koraynilay" <koray.fra@gmail.com>
X-Mailer: aerc 0.22.0-0-gc2f86b7abde3
References: <20261122000856.536902-1-koray.fra@gmail.com>
 <CAOQ4uxgf2KE=Ag13EPAu5=KnrFwt7zRH=im-qmLc8+i10Tjd+Q@mail.gmail.com>
In-Reply-To: <CAOQ4uxgf2KE=Ag13EPAu5=KnrFwt7zRH=im-qmLc8+i10Tjd+Q@mail.gmail.com>

--b1a345f2b4a5254b3632da7c1e235601a7730bbbbe126372d6b8eae348d4
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8

On Mon Nov 23, 2026 at 2:35 PM CET, Amir Goldstein wrote:
> On Sun, Nov 22, 2026 at 1:09=E2=80=AFAM koraynilay <koray.fra@gmail.com> =
wrote:
>>
>> This is a follow up patch series stemmed from [1] and [2], splitting the
>> _mask change for the fileattr API into its own separate patch.
>>
>> The first patch is a preparatory patch so that the code in the patch
>> after can be formatted better.
>>
>> The second patch is the actual implementation, which introduces:
>> - fa_xflags_{rw,ro}_mask fields to struct file_attr
>> - fsx_xflags_{rw,ro}_mask fields and has_masks selector to struct file_k=
attr
>>
>> These masks have the following semantics:
>> - rw_mask:
>>   * for filesystems: advertise which xflags they support changing
>>   * for userspace: specify which xflags it wants to modify
>> - ro_mask:
>>   * for filesystems: advertise which xflags they support only reading
>>   * for userspace: ignored
>
> Nice!
> I think this API description is very clear and coherent

Nice.

>
>>
>> (ro_mask for userspace was also proposed as a "verification mask"[3] but
>> I left out that semantic to keep this patch series more contained, and
>> can be added later if needed.)
>
> Not so easily added later.
> We cannot change the meaning from ignore to verify without any opt-in
> later, but we could use the combination of
> rw_mask |=3D X
> ro_mask |=3D X
>
> to "verify" (set it as long as it is already set)

Isn't this just "preserving"?

> all we need to do now is make sure that the API returns -EINVAL
> for rw_mask & ro_mask on set.

Yes, the current (v2) code does

if (fa->has_masks && (rw_user_mask & ~old_ma->fsx_xflags_rw_mask))
	return -EOPNOTSUPP;

at the start of set_prepare(), I think that is enough, since we assume
the filesystems return the masks such that rw_mask & ro_mask =3D=3D 0.

>>
>> This allows userspace to not have to do a RMW cycle when using the
>> file_[gs]etattr() syscalls, avoiding possible race conditions and
>> simplifying their usage.
>>
>> Patch 2/3 also introduces the missing FS_XFLAG_PROJID flag so that
>> programs like chattr can leverage the new mask API.
>> FS_XFLAG_PROJID is kept out of the legacy FS_XFLAG_MASK and so it's
>> defined as part of a new FS_FILE_ATTR_XFLAGS_MASK group of xflags that
>> will be used moving forward for any new xflag (like the one proposed in =
[2]).
>>
>> Patch 3/3 converts fs/ntfs to this new API, to show how it can benefit
>> filesystem drivers too.
>>
>> The series has been tested across NTFS, ext4 (with project quotas), XFS
>> (project quotas and extent size hints), and Btrfs.
>>
>
> Judging from the number of bugs reported by Sashiko and by my agent
> on the COMMON flags change,
> I think this needs test coverage for the old APIs, especially with old bi=
naries
> chattt/xfs_io that do the get/set cycle and re-built binaries with new he=
aders
> both tested against old and new kernel.
> Sorry, but the UAPI issues are fragile...

Yeah, I thought about adding some tests to xfstests yesteday after I
made my agent test the sashiko issues in my test vm, but I don't want to
make it generate them and submit them with minimal oversight.

It could still be worth to make it generate them to just test locally,
then clean them up and submit them after the vfs design/code is
finalized.

> This is one of the changes that would have been very hard to audit withou=
t
> the LLM agents. Hopefully with the agents it is doable, but need to guide
> them how to review/test for regressions.

Yeah, the amount of edge cases it catches in my code is very high, I
manually wrote the main vfs code in this patch series, but I took at
least the same amount of time to fix *some* (considering the amount
sashiko still reported anyway) of the bugs the robot pointed out.

Thanks,
koraynilay

> Thanks,
> Amir.

--b1a345f2b4a5254b3632da7c1e235601a7730bbbbe126372d6b8eae348d4
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQSgVimKafU5DQMcjcDmj22qf5IGXAUCawRJVAAKCRDmj22qf5IG
XPMqAQDKSRELLXXkJM1eWJs/2jAv9K7PNaXrJgEdc9WUuhVlqwEA+UC/ffcMo2z2
JMu/9eWe5JddaVS+uSeZePo0JhjpBAg=
=ToHp
-----END PGP SIGNATURE-----

--b1a345f2b4a5254b3632da7c1e235601a7730bbbbe126372d6b8eae348d4--
