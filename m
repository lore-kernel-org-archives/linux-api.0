Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.218.43
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795445772;
	b=iQps+c/jg2qUWHYItJnZyVdrLYmic37xguu72fI2+ZSjz/q2buzsgf/QWRbEy/SSTmx1
	 Ak1MJLc18tNtLI2hY/itBroHptAz919TXhGEn9CEHbGkzyorfaTrPBw3Vw+7n/Ypu159Z
	 az7B8nw+lqul7GQapjQ6tkRZi5xUMc+prGoxLztXN0WpcMF4BNGJDdDJxyURglZ4YUEjw
	 x8FW6PCQMB2r5wlv5FxL8IgmIdYr69mvXtTgdoDIMrOUpy9vwT7yDsmrHT1xtIvEEnRau
	 21xLwXkwnbZQZolDMd2vRDiTwA0kJV29iGRs1Lmv7ifqCdezSZRrY14MP/iPb78mc2g==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795445772;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=iLBZumrqdFfo+uoEqy5DjzVlLpVK7yMeWhuKRObIsyk=;
	b=fJ71VtOVTJIUHuhIpLiM+2Q15mE+RDxypRa3hZjc/s63bwgKUEx983myD46kG8aEmY18
	 XvaO1S7+kMS5WR3wXPolTcYekxTW0beZG+j/NFF8AJoZpbgwVgmfq05s70PP1/K5xyTQp
	 Kas1c3b5Mdxbj4DDm7AmI2iFiJPrA9kEuqve5LphEKbje7WeGKruPtkCECS9pVjNXVy3E
	 lhg7cnLenpoj1XRwxLUWJxlk5cZNyPLScY2vt9uhUvZe33nXb5cuVwgav9XRNov5ls05d
	 zjNe2lY0pL7xvSv7hSQRDrN9M9Q1ErF/rFotK4wwON/b7XnNZvORQvmxoptZ4jx+dag==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=wqeG4UVx;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.218.43
Received: from mail-ej1-f43.google.com (mail-ej1-f43.google.com [209.85.218.43])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B4B2606A334
	for <linux-api@vger.kernel.org>; Mon, 23 Nov 2026 14:56:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5B4B2606A334
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=wqeG4UVx
Received: by mail-ej1-f43.google.com with SMTP id a640c23a62f3a-c511c0e2826so390810166b.0
        for <linux-api@vger.kernel.org>; Mon, 23 Nov 2026 06:56:12 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795445771; cv=none;
        d=google.com; s=arc-20260327;
        b=C56laIQejkeePS8nDrNwJOn/poEetyD/eQj0+D6bxKX6/UW7fZDdEm1NsraDyrZ2bQ
         45euOuTRD1DbB5JyU0gunRVV7lTgJEoloEwUzF5TVN7+UVqg3zHGE3mb9FDXOQufuOHe
         ftRrW+Er1ZTZApUWNwL3w8MOk8C6mxY2HWmjo3INzSLlPEgjwNh4waAxBktjmjciMz7n
         tL0GDYte5hgdHRrez416pQ4dQZfm0PKZR4UOdVx8T8InzleVgp9uPPYZ3omvUMxRZHte
         68Mk+ZeO9ZDc6P+gpRzbyZGb2n/yIWPW/dyGK0PEId0VuYpUfRjDS8N0w894UOSgTzKq
         q7LQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=iLBZumrqdFfo+uoEqy5DjzVlLpVK7yMeWhuKRObIsyk=;
        fh=TS/WftAX4fk/dQDF7/WjoyxOQa/bo3bixjQVJRrkSTA=;
        b=cY6iH1oJfZiaPVCL17EGxJ0L1O7mRyq9MZw+erJpSBQHVPtbPPG9ZoVUrpK/8h/E1h
         xYhluLAHSZFOLONtCy0SwpeLekK9eQ6G5FUeyNNdcYUVA6w2bPQ3XmO5VaBQLW9+fXtk
         500yib9FrMFNB3re+zIrqNOnA9Uk2O05Xx53QAc8XjDfmhoz6DyVgTzeUACxK181npNj
         XH4T8n4R5WjbMS3QT1BZv/rdQfKIQe0OfI3ZvbcKTukbe+MMwRYaDusR/iKtpGM4HOUX
         NNn/Uir5fWEpgWD7+FdQiIccnb0tTx2w9HOcG/85R8VevHkFyL1QJ6B6u1BwsIt++hJS
         dx1w==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795445771; x=1796050571; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=iLBZumrqdFfo+uoEqy5DjzVlLpVK7yMeWhuKRObIsyk=;
        b=wqeG4UVxEsqawGNw4hgj4cfTFQ6arGqHSUO6imUiUMeXa8Rm1J1TOte1yUPje6cwe+
         TH7GIH833ISdvF+478dTG3g3rLc8GhsHBKY9tqDuuQG6ExZLNhc6wL4HurcYB7XYzYdM
         k1c8ZPl+i2LZWoD5sDSXAeuyZzpwDmF+lV5KF+mNx7I24cADkXDh2iddswNPgtjRQiod
         98Rf1TYJCpfC9KwAJ5lRFDyGvcIpE/pXspm8dgf3k6SDEHnakNvYQAXllHZS4/z97Zhl
         7Cy4Ubz5DFhoeGRxQ9Dvdf2g25hW/qM8ZE/LRkxbNQ4Q7lkYgGaDdPliMsLLJbdE54BG
         tBDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795445771; x=1796050571;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=iLBZumrqdFfo+uoEqy5DjzVlLpVK7yMeWhuKRObIsyk=;
        b=u/Kgao8KU+b9xTZQw67gfoCw8ZMi4pSh02tLOf1mLMtQN3ygqFsx5oGsLuawsnnduK
         EcBcRBWk976AVUEvInn0L/2aEXi1fKrvAbd5LK6fstxtYr40fa++gskghedIeLW63HfW
         feFeDMUHEqEeq0fLMoetce7qN5NHToVKMMjnoPU32nzp2P/1Zx3WHbaQejip2m/hoFb4
         4f3zumklA6pSEp3gvyBG0YHSHx3JdK8rutmTrnhUrrmuepMFTne8I6ybJHNZZRv7i2aR
         M18g9YpMOaGkXXgG8FShsN9J4O/s4gRQ+h7tiTu+p+/kmq3xlqxINGb1K1exYKJjxtKx
         n4ug==
X-Forwarded-Encrypted: i=1; AL+hErFXVko/rl4yjYsseWVIVQddpmZyqYUl71wLpMy/vW0bZYXVvwBWSA+LXRFaS/9PpsfOSV/bvNooyak=@vger.kernel.org
X-Gm-Message-State: APuU4Z8pW5TrRsxDbkOzqlNwXBD7v1zxksi9NbSG9I4LY0+07jqChJkK
	Wm7h8g1vX2fg5BxNNRGMObW/4EIA1KfdBFnkRzXEq2RfSSJTluOyWxcoDZPNeG1uZ1Eigzz6y4m
	mh4+GPBwHAkxekkR3mF85kMSh0NEnqWA=
X-Gm-Gg: AZFdTZfGsx+ySDSu0AsReI+Pbukisp61K4zOlMpnSogTTmYAmCaXRGJ4GV1b6K+eP8s
	YckhCtEopUKX7Bupqp4l8ktvAESkGTLnoPRRcpaKCI39BpQEQFMQnocH25zqW7oPfvoIY7aBaPA
	q5dRnsYzC8K4An7rxqKXumuiEf6rT2RBCn96Ec3FHOGhgcgo5n8bwxjFTAIKN+nFjj6EccyHPRQ
	axQCy1gw/86WTdlb3Ify3f3hnApeJPstN9GMdcq4eHwOvMRx0HnR6mv626zStwutHAHjaxET3P3
	iBk15CwBoAOdMnf1VBUTsyIxeGaSxSfX4JrRzW34H1aBCWcwBkF5lc+BFXT5DucFiNbYRU1qpL4
	g26nIiBdv3vNdst88JmAIzpnG76JCaymt9VNJcnd/cebW41vCw5eaLLq0hKgLvYA+nZSS5w==
X-Received: by 2002:a05:6402:5516:b0:6b6:ef7f:600d with SMTP id
 4fb4d7f45d1cf-6ba37e74244mr7852050a12.21.1795445770471; Mon, 23 Nov 2026
 06:56:10 -0800 (PST)
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Post: <mailto:linux-api@vger.kernel.org>
List-Help: <mailto:linux-api+help@vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-api+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261122000856.536902-1-koray.fra@gmail.com> <20261122000856.536902-4-koray.fra@gmail.com>
 <CAOQ4uxgc6pP+_xvJMbqj6wOdGzS75Vn6x6i_vUfCJDD46DAA_Q@mail.gmail.com>
 <DN2N0BY83OY2.1OV3ZAZFSWCDG@gmail.com> <CAOQ4uxg9O-R_SUPAZ75ESGB99-4Z4EEUKGMkCF2f-sXkGPq1GA@mail.gmail.com>
 <DN2NVGUNO0GA.89JAB2PVI0LA@gmail.com>
In-Reply-To: <DN2NVGUNO0GA.89JAB2PVI0LA@gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Mon, 23 Nov 2026 15:55:57 +0100
X-Gm-Features: Aa3M54p3kKL3ZKUzvEHZq54IOonM6T5WCFB3q5vIRbaCh5i5swbxajRtrCtjW5o
Message-ID: <CAOQ4uxjuAN0FdxGr_-OccO5qnUuLF5oxOq7L_545tG3+36EKFw@mail.gmail.com>
Subject: Re: [PATCH 3/3] ntfs: switch to the new xflags fileattr API
To: koraynilay <koray.fra@gmail.com>
Cc: Namjae Jeon <linkinjeon@kernel.org>, Hyunchul Lee <hyc.lee@gmail.com>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, 
	Chuck Lever <cel@kernel.org>, Jeff Layton <jlayton@kernel.org>, Jan Kara <jack@suse.cz>, 
	"Darrick J . Wong" <djwong@kernel.org>, Andrey Albershteyn <aalbersh@kernel.org>, =?UTF-8?Q?Pali_Roh=C3=A1r?= <pali@kernel.org>, 
	Lauri Gates <lauri.gates@gmail.com>, Christoph Hellwig <hch@infradead.org>, Dave Chinner <dgc@kernel.org>, 
	linux-btrfs@vger.kernel.org, linux-xfs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	ntfs@lists.linux.dev, linux-nfs@vger.kernel.org, linux-api@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 23, 2026 at 3:31=E2=80=AFPM koraynilay <koray.fra@gmail.com> wr=
ote:
>
> On Mon Nov 23, 2026 at 3:14 PM CET, Amir Goldstein wrote:
> > On Mon, Nov 23, 2026 at 2:50=E2=80=AFPM koraynilay <koray.fra@gmail.com=
> wrote:
> >>
> >> On Mon Nov 23, 2026 at 2:00 PM CET, Amir Goldstein wrote:
> >> > On Sun, Nov 22, 2026 at 1:09=E2=80=AFAM koraynilay <koray.fra@gmail.=
com> wrote:
> >> >>
> [...]
> >> > Rule:
> >> >
> >> > You cannot add a flag to common without carefully auditing all
> >> > filesystems that support the legacy flag.
> >>
> >> Yeah, sashiko pointed out a problem in f2fs, and I could reproduce it =
in
> >> testing, where adding COMPR to COMMON makes f2fs crash, it also needs
> >> NOCOMP in COMMON.
> >>
> >
> > I don't think this is correct, or at least not enough.
> > My agent said that this breaks or changes things on  f2fs/ext4/ubifs
> > I didn't bother to check if all of them are true - I doubt it
> > bottom line - need careful audit and good testing.
>
> Yes, definitely.
>
> >
> >> > FS_XFLAG_ENCRYPT can go into common but must also
> >> > go to FS_XFLAG_RDONLY_MASK because it's read-only for
> >> > all existing fs.
> >> >
> >> > COMPR is rw for some fs and ro for others.
> >> > As with CASEFOLD, you cannot make it COMMON before
> >> > converting all casefold fs to new API so that each can say
> >> > whether it wants RO or RW.
> >>
> >> How's CASEFOLD currently handled? in the v2 I'm drafting, I added
> >> fileattr_mask_to_legacy() and fileattr_legacy_to_mask(), which convert
> >> between the old format (filtering by FS_XFLAGS_MASK) and the new mask
> >> format.
> >>
> >
> > Good question.
> > Need to check this.
>
> Can you do that? If not, I'll check tonight, no problem.
>

CASEFOLD is set in FS_XFLAG_RDONLY_MASK and NOT set
in COMMON

Therefore, doing set with the old xflags API for the common flags always
preserves the old CASEFOLD.

This is kind of ugly and works but its hard to see the design there
so hopefully all the new helpers and masks will sort this and make it
more explicit.

IOW, ENCRYPT can use the VERITY RDONLY and COMMON
precedent because it is read-only across all fs (via this API).

COMPR (for the purpose of ntfs patch) can follow the precedent
of CASEFOLD of RDONLY and ~COMMON, which somehow works.

Note that for fs that were converted to the xflags_mask API,
COMMON should be irrelevant.

COMMON is only used in SET to do GET and preserve the ~COMMON
bits of the "other" API flavor.

With the xflags_mask API, unless we adopt the "verify" feature
there needs to be no internal GET with user SET and then COMMON
is not used at all relevant at all for those fs (e.g. ntfs) only the
_fill_ converters are important.

> >> > I think there may be a way to deal with this easily since
> >> > ntfs doesn't need to set either but not sure.
> >>
> >> We could export the 2 other helpers I added for v2 (xflags_to_flags an=
d
> >> flags_to_xflags) and make NTFS use them?
> >> Though adding the fileattr_ prefix will make the current (v2) vfs code
> >> maybe too verbose.
> >>
> >
> > Honestly, I can't say for sure - you can try
> >
> > I think you may need a different set of helpers fileattr_prep_ used by =
the
> > filesystsems that are converted to xflags_mask, which may be different =
from
> > the set of helpers used by the user facing ioctls but I'm not sure.
> >
>
> I guess I'll think about it when I move NTFS's impl to the updated vfs
> code.
>
> > The thing is - this is all hard to wrap our heads around
> Yes.
> > You and I have parts of the design in our heads w.r.t backward
> > compat with legacy API, both UAPI and vfs internal api.
> >
> > I think you should put it in writing to see that you and I have
> > not left anything out because this v1 surely does get it wrong
> > in several places both wrt legacy UAPI breakage and internal
> > API correctness.
>
> I agree, now the version in my head is not finalized yet, so I'll do
> that in the v2 patch/cover letter.
>
> TLDR is "use the legacy to/from mask converters whenever needed, so:
> - user legacy -> fs legacy: keep as the old code did
> - user legacy -> fs mask: fileattr_legacy_to_mask()
> - user mask -> fs legacy: fileattr_mask_to_legacy()
> - user mask -> fs mask: pass it through
>
> (before finalizing the GET path I want to finish the SET path).
>

Maybe for me if I don't see the full picture, full get-set cycle
it's hard for me to judge.

Thanks,
Amir.
