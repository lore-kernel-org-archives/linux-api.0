Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.46
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795186533;
	b=AyQ/hSLiOZQIBljTvzv+x50RfLdXBnfAKwWn0hYBKGVh8a3zdgT9ww+9VvEaZC5AY3ik
	 RW822gdAFMDaKy8ATyB4QpbZnE6ScfbCDDLvuxlsk3q0sitPYhm0vmB/xxvuB3tIXOiS+
	 lnSWJoTDjli7Jlj2tD7EpgQHNc9JSPTbYlQMArWXr3DgVBvQF8eBHHyFF8yefkWHfpf+n
	 4U6HU5LeUZCn/Lx2N81/Ta1MZddjpsuScJFMCho/eg7aTpSV8txqAWuO148q6qYyfj7L5
	 rRyUa0Qn2oUixsHPA23EKBlCYZ9xppUjV7zCIXqHqpzyPYZbJy8ArFSjUJhaTpc6GNA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795186533;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=zpoWzG1+g8sYeNmdw7RPLfc/0HSn9Ajkmbs7oAG/5Qs=;
	b=vPk6EBKaU1Zt3/e/C+jEbmw953sNWkP4s6SvgKIyJjdnaAaloXGTG+jLhtg+9SV8Jauh
	 IeVyBWfX/xfrRYtKyezviG6xgTJZ18K/8DZwdCG0VKHQZQBPb/Zdk77vTMIwsg7qCtmP/
	 Qc/WzJn5aa7fh23l4a+rheh3uOE9xJGwbX721jQvkLZyVUHNauIBYMDIPz8OK6QwYFjXK
	 boygXZXwpqKFGYFSSRIkrTiJIk+5+FIrMAeBdLR000nUqooh9kwKuHHh3eu4F7Fovf8r6
	 CR2UeojYbm10aRYUqEHrYW38Wi7AU6KCDaC09A6UMtqeD6M6JcUiT70aE5VGBXmNr2g==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=0liT1xoc;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.46
Received: from mail-ed1-f46.google.com (mail-ed1-f46.google.com [209.85.208.46])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95793606A33B
	for <linux-api@vger.kernel.org>; Fri, 20 Nov 2026 14:55:33 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 95793606A33B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=0liT1xoc
Received: by mail-ed1-f46.google.com with SMTP id 4fb4d7f45d1cf-6b87a92c17eso1450833a12.3
        for <linux-api@vger.kernel.org>; Fri, 20 Nov 2026 06:55:33 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795186532; cv=none;
        d=google.com; s=arc-20260327;
        b=sQrmZF1+YnmbYh/0mdCgONPiLEV0hvZa3sVQ5MCZHj1qDhxxetKIBs0+77dJAdeaGt
         6WppDzRHadO1G0adD8rvAfEg52sssBexX5qAItW0/nTg+Tmk530Xzewpd2NnYMGoQqZs
         /KLmplnZEGhIPgL3W5UJzkXc8bgeU3Qbz0fmw3cArnNVJk6fUovcegfNCBrWDBB93LNj
         LrUD3QfSCfIyldyKlqq75TRxtUtHwwHj4/Izfm0ATmGnuf53NshvNxYnKKhbvJd/Pdkb
         B1JhbpAPfL4Mn9jk23HLUIuf7dZ7S/UB2sNr28JdGx37hxF+ILH9u7dqNXMinKCrtdra
         9ttg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=zpoWzG1+g8sYeNmdw7RPLfc/0HSn9Ajkmbs7oAG/5Qs=;
        fh=KibjCeoBNkdEZo45PQkOzWQHO+dH3ObvQQ++MMgod8M=;
        b=QZ/Zmnq5RxweCeWKPczeBgnqYdM+m6jAWVigtZLYdi/SR3PmxLLsIrS1b2HRakhLlm
         XiXQuRHT7CJx/F2K2pC7XcE/+LHPxTBQohZPWDRyHpqLIlL5PEGYIw0H+YWd1f37Msmj
         agHzueRNd07LwmSEaXvF5KXsEctiYIOPLH3TSjZP2aR5X7SF4a7JOjx5CXnKyEFXS1gm
         k47cDJOQhI7CuqOBhLr/r2qfAUmkGIgnYz05Ch+pwlNrJB278uZO4IWwM8gvF/YzlRhG
         goWiftJU1EWLecdQTobFGIeW0x5CTjXaFlrhidY++V+x3UTe5EPxi4ChgJdDTI8hHNId
         nw0Q==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795186531; x=1795791331; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=zpoWzG1+g8sYeNmdw7RPLfc/0HSn9Ajkmbs7oAG/5Qs=;
        b=0liT1xocYY04eRAxMyqyT2RQyS2Apuso3FTjJTR5lpw4eouwRyxilXw/O5YJII3zt+
         VD0II0g/cMhmGgQLJuyvPgrS+v/q+lSTIiREXmKBDWHZWddNmP1BCwbpdAECCnL8uK2P
         w/XN7av4Bx94DaTolcfmIv8HDVX8wb/UFewp75CZTmAWMBZCqohdq8p8gWmtYn9G223f
         l3U2uQtULEusH/eC2yIzvuS/6itcAYgwJMB4B4wfo+0nhA/r5V+5q8dl6kGd+z9/xf3a
         3u8dy7zO+Sbsd6MHTa1mBCMZn/a/G396WDTvvP1tMl4KFrrXzIQCVlcVB223r4i9EW1V
         oEmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795186532; x=1795791332;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=zpoWzG1+g8sYeNmdw7RPLfc/0HSn9Ajkmbs7oAG/5Qs=;
        b=jxguuPWMeMaZ6xZzUIxkuACJNrP06JJELYTcocIBOsMVtt50PpwxQ7mybMdoG6rj0N
         anniXBbbge8GYv66CgyTCkxh8qyAC1lUCjsF824XrTXEPiMeTcPU/gzhHlIICdNI4adR
         q40SUHopV4V5pIr/jfvfgUkE+dbNqifWI6n8/jEeX47BHy5q4z70c+bAfgBExUzH4XZz
         eHbW3Ej+y5tyrsPrFs+NikTEACbpNq+HcDNOU5sRMMTtnqOz+B7tK83IZJz8o2T/W1uD
         mOcESSGMCnzB35jQ5nH3kzwqer/bOVGSqpgWZH5OnR+UqoqILhqqjQi+ryYRKN+8IrgI
         lQUA==
X-Forwarded-Encrypted: i=1; AL+hErEQP6I+OBR/+YA0Br5L84/cbvJaXyoqWyII+TFH6Xe0onsLO1nIyW6re5fRJdymAdIJvfO99O2+8m4=@vger.kernel.org
X-Gm-Message-State: APuU4Z8ZT3RS8CsVyJMe4KnhoLspeoGBo1DRFvl3S5Hm7R9x/4FvI/BX
	oUH+HPz5cW3QzVzmGqwYcx8DHaNOpHEYJGYZJifJ7PlWU3pJClOfGczNOo0EUceoark7MYUagmz
	+rVl7QorJZnKdHwCPKcgJ20n+oLFuFjM=
X-Gm-Gg: AZFdTZee3vLa0WUBapD1yHs+ZPQ3i7lmmRZUXqzZTnxJSI8ua0FnpxxqL9FZEyCAEPP
	qxS1PJRDn42xkyNzLc1vuWnbewpU9pr4ZRe7seOo0e8Ik/5nMKhhzDerNzmhVCIuA5mgup5AkG1
	CetKK02J4GqUQMhJyjJnCMftwZ/noy/zqKDas2zUd4bDQpKGIvi8ZwmtfHaZSGBt9o2AoD7a9a6
	iK94eurJvOqhlqqAcb0yUhlHI3mCrRPsOdmZrndPKMgm3BtfVZOQRQT1NRF7s6GW2BByrMmIuC4
	eIrGhVv6gI12E1JYxBRzqjL/6HpnAMkslRzk7VO34IbPdQoR5aBWt7olhKJiiu1qTYzWuH9p0H/
	zCWzQ0CyPNTavT97yAJrnsCNlQ/7+ZsNYeTiWsV6QL8CgUQ3XPGAnmH0GaNYT/uQChO/9Eg==
X-Received: by 2002:a05:6402:3223:b0:6b8:5f08:931b with SMTP id
 4fb4d7f45d1cf-6ba37ea44b2mr2503989a12.26.1795186531571; Fri, 20 Nov 2026
 06:55:31 -0800 (PST)
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Post: <mailto:linux-api@vger.kernel.org>
List-Help: <mailto:linux-api+help@vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-api+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261115180343.576773-1-koray.fra@gmail.com> <20261115180343.576773-9-koray.fra@gmail.com>
 <CAOQ4uxgoNsOH82FyrCxc+qSoid_CFmbmpL0qgWFw-e8E689fFA@mail.gmail.com>
 <DMZJ4PL1JVA4.2YEB7EPYJR5Q7@gmail.com> <CAOQ4uxi6h9BBP7pf4sR+gc2+4XtkEgbxXZha45iZzdB_wGFVgQ@mail.gmail.com>
 <DN02S2XNGRZD.1KNOZJ0GGDJNG@gmail.com>
In-Reply-To: <DN02S2XNGRZD.1KNOZJ0GGDJNG@gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Fri, 20 Nov 2026 15:55:19 +0100
X-Gm-Features: Aa3M54om4CtJTUNd2Te8u7pI-ZPclkwXdtuzgdSJLpiBpdV9ZiFnAJvfZll4Px8
Message-ID: <CAOQ4uxh+d-wNC0aWLEexPFz7zj=TZjLyu61kaEmwBx9_hKn2gg@mail.gmail.com>
Subject: Re: [RFC PATCH v4 08/10] nfs: add provenance time (ptime) via FATTR4_TIME_CREATE
To: koraynilay <koray.fra@gmail.com>
Cc: David Sterba <dsterba@suse.com>, Namjae Jeon <linkinjeon@kernel.org>, 
	Sungjong Seo <sj1557.seo@samsung.com>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Christian Brauner <brauner@kernel.org>, Trond Myklebust <trondmy@kernel.org>, 
	Anna Schumaker <anna@kernel.org>, Chuck Lever <cel@kernel.org>, Jeff Layton <jlayton@kernel.org>, 
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>, 
	Paulo Alcantara <pc@manguebit.org>, Chris Mason <mason@kernel.org>, Yuezhang Mo <yuezhang.mo@sony.com>, 
	Jan Kara <jack@suse.cz>, NeilBrown <neil@brown.name>, Olga Kornievskaia <okorniev@redhat.com>, 
	Dai Ngo <Dai.Ngo@oracle.com>, Tom Talpey <tom@talpey.com>, 
	Ronnie Sahlberg <ronniesahlberg@gmail.com>, Shyam Prasad N <sprasad@microsoft.com>, 
	Bharath SM <bharathsm@microsoft.com>, Sergey Senozhatsky <senozhatsky@chromium.org>, 
	ChenXiaoSong <chenxiaosong@chenxiaosong.com>, "Darrick J . Wong" <djwong@kernel.org>, 
	Sean Smith <defendthedisabled@gmail.com>, Andrey Albershteyn <aalbersh@kernel.org>, 
	Pedro Falcato <pfalcato@suse.de>, =?UTF-8?Q?Pali_Roh=C3=A1r?= <pali@kernel.org>, 
	linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, exfat@lists.linux.dev, ntfs3@lists.linux.dev, 
	linux-cifs@vger.kernel.org, linux-nfs@vger.kernel.org, 
	linux-api@vger.kernel.org, Theodore Tso <tytso@mit.edu>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Nov 20, 2026 at 2:34=E2=80=AFPM koraynilay <koray.fra@gmail.com> wr=
ote:
>
> On Fri Nov 20, 2026 at 7:45 AM CET, Amir Goldstein wrote:
> > On Thu, Nov 19, 2026 at 11:10=E2=80=AFPM koraynilay <koray.fra@gmail.co=
m> wrote:

> >> >                    fa->fsx_xflags |=3D FS_XFLAG_CASENONPRESERVING;
> >> > +                 fa->fsx_xflags_mask |=3D FS_XFLAG_CASENONPRESERVIN=
G;
> >> > +                 fa->fsx_xflags_ro_mask |=3D FS_XFLAG_CASENONPRESER=
VING;
> >> Uhm, why both in _mask and _ro_mask? If it's a RDONLY flag shouldn't
> >> it *only* be in _ro_mask? (same for CASEFOLD)
> >>
> >
> > Good question. Maybe
> > I guess if you want to follow some percent
> > FS_FL_USER_MODIFIABLE is a subset of FS_FL_USER_VISIBLE
> > but I think that exporting ro_mask and _mask is going to be easier and
> > cleaner than rw_mask but not sure.
>
> Hmm I asked that also because you said in the xfs shared extent thread:
>
> > The advantage being that it makes the interface symmetric.
> > User can alway setattr() with the buffer they got from getattr()
> > and instead of randomly ignoring flags in set, the fsx_ro_mask
> > along with fsx_mask defines the behavior exactly.
>
> But by putting the ro flags in _mask too, a user would have to clean
> them out or vfs will reject the call with -EINVAL/something else, since
> in that case the vfs would see the user say "I want to change this [ro]
> flag".
>

That's just a matter of interpretation.

You could say that if flag FS_XFLAG_CASENONPRESERVING
is in ro_mask then its value may not be modified and fs needs to
fail the set if the user given value is not a match to the current
kernel's value.

Could be used for an "atomic flag set" operation, but I think
this is taking this too far.

I am fine with xflags_ro_mask and xflags_rw_mask I guess this
is the less ambiguous option.

Thanks,
Amir.
