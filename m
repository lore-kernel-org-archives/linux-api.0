Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.44
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795024254;
	b=0VK/9eg5ceizWLx81Hu+hfe2aTlpo/YPDmcVHKs1etIghJ5Z8sVLrEXYItFmcoVfAcrY
	 x6EKeUKG6kKgYP2nYfFoCd+TRjH6uHT2uiJ9B1iK7UeHV42TStiEaLSIv5VEhB2lHY+xP
	 0OFxITJyb7omgMui5f0LhslcaHoTh6naSDxVowg4vZMMoHXsZm/gVTD3OYXw6GdqMWPUT
	 MX7LtnLTqUpJJ/osCg13u1Eyx/uJXtGOB1quR5Gz/NWJBsCaIArX9yjyYZOFwqiwg9HdI
	 9JjD1x07nDBkvpKLZZ/9HCdYcGNOLpFmo9aIL3yAKEP18iydd1OerIMaA9U7aUFA+Cw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795024254;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=BliQBsLi8Tf+bGa80m+pxZeHcLThIeJfSszhbNvQWjc=;
	b=mpDSxw8ks6y921NkzUQWRS33x0SZgpOwD7fYdA4OSB/bW5n9kQgoRH06w+RHxQpZfL/4
	 6URHTZP5tCLeWDUlr4kW6fAZhAWqo94QsyRmJg1UIu/aJscTAplUzciJHtglf/DfpCY5h
	 h5nhx0Cky8EmMKen5iuTqfaqQ4tansq5ePvJMRUKcCHhE4oBi7H5t2qcZl49SM28Wszy/
	 c9imawzyc4S+OYfVuolw6hwXnzJRf1u0K6U+a8/yGzpBRt9gn2bZT8yxJgOZH9mueoWUR
	 PMM/JRSj5cmqsm7S3CnbfO5q6fUTLZSLAkkFAbLtXfyikZKOnX5Fg2PD3/lLWswOc4Q==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=t0urFzns;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.44
Received: from mail-ed1-f44.google.com (mail-ed1-f44.google.com [209.85.208.44])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9C0860A2608
	for <linux-api@vger.kernel.org>; Wed, 18 Nov 2026 17:50:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D9C0860A2608
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=t0urFzns
Received: by mail-ed1-f44.google.com with SMTP id 4fb4d7f45d1cf-6b4bd3d98bfso1767020a12.1
        for <linux-api@vger.kernel.org>; Wed, 18 Nov 2026 09:50:53 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795024252; cv=none;
        d=google.com; s=arc-20260327;
        b=ehZioFTti/UyHT18o2amxwjH07Ll16ngmlQ5ek97M1nRhGV8ocgUv8bBVNZkGbZplr
         DduZC2ksWnZ7WwCf1x3tQcuNPWmwGMDqkqRKxsu8CPlO+i6GYFtEWIILKpdoF6chxe2Z
         oJaOpYhmDyZYcF1R5z9Zfv2AZ7/SXmeweIFLtQsBNadykLJ5e7g5+ZCDH+kfx9FLLmNF
         16Xg7WkezIm0GjH5/P9gxE25ui4VYH89Oxx92epa8v3FK03To4tIFATQ991Z1SUaF41y
         xbA6AScYapWRPJDCKs7yI2D3Oc4k3tn8c2aqfmA6aUIjCY9S6wgxogTW8AfzlY92jZEd
         8ybA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=BliQBsLi8Tf+bGa80m+pxZeHcLThIeJfSszhbNvQWjc=;
        fh=GDU7THjiFVYwutmLfh/Enex4+jHRDigaqucrq5gYOBA=;
        b=UwyH1LQjhuXrbh3HRVA7YOgCPgCqVK5dS7ahHJ3Ab10Nvv/JwLkiPO/GBrdztEBu38
         5VOYiqLDYE+EcBgKVrlKiWTJVc2gswhRBsTeXSBzV/+xUEpBt9dCUKfx/szDedJb6vWK
         3e5u993dOyuBScuTz2hg7f5uTeq/ehgGHt/aSCFIdB7QA07wXixIv7pd4tqMwFIeja53
         vwY3lyBX1cqoMpmyrUzvQeUzpg2sWeCmeb4cWkhKoQ+S0PvB47iyS7V/61OrOqw3STLp
         MYAYu7LjO5AIyBv1UIdLOnnNDi1XnTd5CASR48OZRaGh0FuK+wUtX+2wMEZ12WlJW7QM
         HsiA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795024252; x=1795629052; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=BliQBsLi8Tf+bGa80m+pxZeHcLThIeJfSszhbNvQWjc=;
        b=t0urFznsvrKRqixemRUZFc9mgXym3XN1YMBmj0waBLyV3CsdgnHy8xmpMpLBOjvFSO
         4OyVbjrHe3QbmjmaFHziwXJZHZ3OpkdyrRZKOYWCdCJexvqSmUuVu4fnaP7X0VKW/H2Q
         uU2+obaBKEAHGKd8XWt2iDtAO+W46sMhQn7B0F4IN3mylmD+1QrZ9esi0QvoH9kZT9bX
         EBKM7Z1u6o+AxA5zR70zZUIovWhwqLZJa6oEexWqxHL96XtNRn01UmHNOonMpcB3gc6f
         RbyVXVt9WSJBogGVLF5lTsidaWxQ5lTI8ZoKmu6C/MRJ9rExNu7Xb6AIdnGzmI6derxu
         Duww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795024252; x=1795629052;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=BliQBsLi8Tf+bGa80m+pxZeHcLThIeJfSszhbNvQWjc=;
        b=XGBSM1BSu20AK5QfxKu8j6tp2DqOmAfPkZF4WDUL+T7eXYYxQ/0L6DYmD6TfWi8XO6
         yapYcKiWAOhzLOgAZ9OAK0n53SvbgfqaTqB2pUC21WFUdEyGDpuwFcZubWH+ol/HeNW5
         wDNmSj7Rnkpg4Qufu/66tpRquIsxtRYrUvNvqsG11pSHenjii1B7SUvMIt1j4iGIhNlg
         p2vRaoW5qlZmULoMLaKYVPHzs4vZtz3FenxG8rhyGkfP0o+i3LDlLeWMrGi2BBpyOIoG
         lK07cziBINJqN10owCUd/iO9sZGvM9YPkxYSaijyIHClddiLqgKkgFNPMejOVjJL3gXt
         e+WQ==
X-Forwarded-Encrypted: i=1; AL+hErHjB3B1gzzzzMkk+mS2+tEYKKQhoyXiGOt6390wVjx/C+WcsY1+zZI779qULJTQXwq7D5zZpAIXMQ0=@vger.kernel.org
X-Gm-Message-State: APuU4Z/EhDAmidBcdpSHDdAHs6yPOYmTex9xgKe6spj3qxPuzr2rQbG2
	HdS+brmh8/mNAvqb/NTPETdZIUmi2qtsQzi8eYiMQcO55fvVozKIF7VLm7igg+SJ36jE1XTyZuJ
	wORib0N98D1R81RjxJPoO/KeoFAG2dc0=
X-Gm-Gg: AYBFou17Mmh80iCUfR6Taen4622T04OLEaG7FIAOxbFL5Uoy569U+bmzxUqmU4KvdGA
	gomW6JsAms3td0X0xnRDd6zqDYqQeWo1Aq2opgOlZRvRtzMtW5qtZQKF+CrJXKCjDwEaGg/kC9d
	SlcOuL8Qkje+2JY0UInirKUYTL5KPyYhVkAztqn3A0liJlzcDFlPNbSmxIo0KhCN0n39Fhj+bQ9
	/sqVz7U6lx7T4iqkJIa7nhu3Udli0KIjFc7tj9bB/mRSaK/RUh6YA0fb8xHv22Lhrfeu21F4vfg
	VN24BZOQ+L/dapCrXWN1BxNbHUmztEDwlfZXwQbl/aw9gKTWgM/k2i89p2vsXz8ZmAKYIaPGLjF
	wqIR66CxILF//VsCmwah5nT5dw0Fj4PysF1QAYfVfCofRuT8kwYiSD1eHRRV6l+lEC4bb7imkKz
	mR9Bn+Myzn7lOT2sw=
X-Received: by 2002:a05:6402:5411:b0:6b7:df0c:18d0 with SMTP id
 4fb4d7f45d1cf-6b8a2e6d881mr1966295a12.11.1795024252167; Wed, 18 Nov 2026
 09:50:52 -0800 (PST)
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Post: <mailto:linux-api@vger.kernel.org>
List-Help: <mailto:linux-api+help@vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-api+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261115180343.576773-1-koray.fra@gmail.com> <20261118142613.be3r3s6kobkkxnz4@pali>
 <DMYFBDIV4Y08.35ZKR5G86U1H7@gmail.com> <20261118151605.lqtn5fz423kuswk5@pali>
 <DMYHPLWKPSH3.MUM1IIZZIWNR@gmail.com> <CAOQ4uxiwpdC-fKkqS5kiZ515q9MenC0jX4USV1idN7h2njx45Q@mail.gmail.com>
 <7126bdd0ff59e9ea9bc58702af2ecb38096330e8.camel@kernel.org>
In-Reply-To: <7126bdd0ff59e9ea9bc58702af2ecb38096330e8.camel@kernel.org>
From: Amir Goldstein <amir73il@gmail.com>
Date: Wed, 18 Nov 2026 18:50:40 +0100
X-Gm-Features: AclHuK8-cETfcc5mQcfuFgReFzNL3uUqtJJFv8XHOum7KdV27M9jJ90gtN64MvU
Message-ID: <CAOQ4uxidYWNVmoPgxKrxesXTxpMB-JqUZx9p6xXZWD5m+hJ+JA@mail.gmail.com>
Subject: Re: [RFC PATCH v4 00/10] add provenance time (ptime)
To: Jeff Layton <jlayton@kernel.org>
Cc: koraynilay <koray.fra@gmail.com>, =?UTF-8?Q?Pali_Roh=C3=A1r?= <pali@kernel.org>, 
	David Sterba <dsterba@suse.com>, Namjae Jeon <linkinjeon@kernel.org>, 
	Sungjong Seo <sj1557.seo@samsung.com>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Christian Brauner <brauner@kernel.org>, Trond Myklebust <trondmy@kernel.org>, 
	Anna Schumaker <anna@kernel.org>, Chuck Lever <cel@kernel.org>, 
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>, 
	Paulo Alcantara <pc@manguebit.org>, Chris Mason <mason@kernel.org>, Yuezhang Mo <yuezhang.mo@sony.com>, 
	Jan Kara <jack@suse.cz>, NeilBrown <neil@brown.name>, Olga Kornievskaia <okorniev@redhat.com>, 
	Dai Ngo <Dai.Ngo@oracle.com>, Tom Talpey <tom@talpey.com>, 
	Ronnie Sahlberg <ronniesahlberg@gmail.com>, Shyam Prasad N <sprasad@microsoft.com>, 
	Bharath SM <bharathsm@microsoft.com>, Sergey Senozhatsky <senozhatsky@chromium.org>, 
	ChenXiaoSong <chenxiaosong@chenxiaosong.com>, "Darrick J . Wong" <djwong@kernel.org>, 
	Sean Smith <defendthedisabled@gmail.com>, Andrey Albershteyn <aalbersh@kernel.org>, 
	Pedro Falcato <pfalcato@suse.de>, linux-btrfs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	exfat@lists.linux.dev, ntfs3@lists.linux.dev, linux-cifs@vger.kernel.org, 
	linux-nfs@vger.kernel.org, linux-api@vger.kernel.org, 
	Theodore Tso <tytso@mit.edu>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Nov 18, 2026 at 6:36=E2=80=AFPM Jeff Layton <jlayton@kernel.org> wr=
ote:
>
> On Wed, 2026-11-18 at 18:28 +0100, Amir Goldstein wrote:
...
> > Guys,
> >
> > Let's take a step back.
> >
> > If this discussion is proving anything is that the btime/ptime
> > duality is a big headache and it's going to be a source of confusion to=
 users
> > even if we come up with some smart pants consistent semantics.
> >
> > As Jeff writes, I think we should consider making btime mutable
> > be a per-fs choice and not an API limitation.
> >
> > A filesystem can even decide to store both the forensics btime
> > alongside the user settable crtime.
> >
> > There are some precedents in xfs with settable UUID which is
> > a different field then the origin UUID from mkfs.
> >
> > Fs that have immutable btime have a few choices:
> > 1. Keep it immutable
> > 2. Start making it muttbale (like the Win fs)
> > 3. Start making the user visible btime (STATX_BTIME) mutable
> >     but keep the forensics btime on-disk for, well, forensics
> >
> > If btime becomes settable via options 2 or 3, this could require
> > admin opt-in (e.g. tune2fs -O crtime).
> >
> > With option 3 the crtime feature would be ROCOMPAT
> > With option 2, it could probably be COMPAT. Maybe.
> >
> > If we accept this story and the major fs maintainers are
> > in agreement with this plan, then I think the missing piece
> > is making the "settable mask" visible to users via the new API.
> >
> > IOW, we need to somehow export FS_XFLAG_RDONLY_MASK
> > to userspace instead of only exporting the supported mask.
> > And then with the addition of xflags_mask, we could also
> > -EINVAL on users trying to set readonly flags/values.
> >
> > Perhaps a single xflags_settable_mask is enough.
> >
> > For file_setattr(), xflags_mask is anyway a set-those mask.
> > For file_getattr(), does it matter if we get an answer
> > Filesystem does not support casefold on this file
> > OR
> > Filesystem does not have casefold on this file and
> > you cannot set casefold on this file
> >
> > It's kind of the same, isn't it?
> >
> > What do you say?
> >
> > Shall we drop PTIME in favor of "is BTIME settable?" API?
> > Leaving STATX_BTIME exactly as is.
> >
> >
>
> +1
>
> I think this is the better approach.
>
> Looking over some of the earlier discussions around this since 2010
> (!?!): I think some of the XFS devs objected to making it settable for
> forensic reasons. So, on XFS you might need to rev the on-disk format
> if you want to do it there to preserve the "historical" btime, and
> maybe some xfs userland work to make it accessible for forensics.

XFS_IOC_FSBULKSTAT will likely continue to publish the original bs_btime.
if a mutable field is added it could be published as bs_crtime.

For forensics this should be enough.

>
> For the record, the statx manpage documents the btime field very
> sparsely:
>
>        stx_btime
>               The file's creation timestamp.
>
> There is no documented guarantee that this will be immutable, AFAICT.

Yes, and it really isn't immutable for cifs already.
It's just that we don't have a standard API to change it.

Thanks,
Amir.
