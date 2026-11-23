Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.53
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795447127;
	b=hE3Zdyxn7Nq5BDhKjTNeqW6Wo54QLYpQ0JQnNGEnlVR/XuODztFM3t5eCIE4S+skvpTR
	 /VBBJGzBkf3PH/aTHbYvtPkxNCwkzsOBaA2egRRkHDuT1qrJBNZtKqTITLEl02jj/qw/y
	 CM+lk4JjGayFS/AO29kooXmu2k/oqFUmSzZ7b1fLYFzHjusKrDPvaXYx76kKpSjOAemsS
	 /J55o0rzZIKs61lRVbRkVhxj0WlYjIY55gLFo98hFxDaq7KOpXVGi82Ey4TKkhFHqbvGv
	 LpkfDiEmEYmyA/fZjcz/AoUVkXDs5JwFjg5B6T83Tn+KUEcBV238BeOlbZuX6luZE1w==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795447127;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=FQauslTrJye8WtEKr4/uMYFLXtDrCWIYYsnNnENx50w=;
	b=pho0YjzO2hccMXloBY/ZZXAJjBCAc2Y+r6mxFtu+UkrCyYrEbvwb+ArIUNbTnTmFeSQp
	 zgXaN6mfmx4a8MPGg899qFKrVvIrb/2/ef31ikkdmJtBMoW9ahTuw1u8z2+nvt17Gdjtq
	 r4bCxJSww0mdnS+iThhK53Xfo/T9AHUOtH06hxB7uyQZnFAXRJtg6vYd0ZTCXUCuLBe/B
	 U3QqQANhPiVkZzhbzT5OscSBZI2Qwc5+Zr9e/xyr1x876W1ZysnCRraWgaLD1CaPFTakY
	 dnc4b8v0qX72Ma7UzQxIZV/4Cdq3tB3AGHZGolvxq0W3xzERCXd+0fskdmvVS65hv9Q==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=tnOVRIK8;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.53
Received: from mail-ed1-f53.google.com (mail-ed1-f53.google.com [209.85.208.53])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0640606A32C
	for <linux-api@vger.kernel.org>; Mon, 23 Nov 2026 15:18:46 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C0640606A32C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=tnOVRIK8
Received: by mail-ed1-f53.google.com with SMTP id 4fb4d7f45d1cf-6b8786bb305so4175357a12.0
        for <linux-api@vger.kernel.org>; Mon, 23 Nov 2026 07:18:46 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795447125; cv=none;
        d=google.com; s=arc-20260327;
        b=jvvf8jkH5n/BtwkHUwrSBvkDtPPH6SbeV+h7QCJkIzuuIQw6R4EKDt0bEs9uDB/l/o
         i6Fleo3CU1/H6oKrCmFiwkPFIMpUJPtTbtWOsuN04HCmthUXk91CEzUfXW9IpXUI4F6o
         to/ogKOybvzE7P5516gqbK9ahtC5ImL7Cu/cD7EkpsxEVhOoD81y1JN04yuPawXB9dtB
         zvQ53FivdC0he1yvWBo6H97BMRTdd9z2aK/aT7dMsPQwf6fH2ut2XB8b/fEp86ZNjKmX
         2mXHxhXV3NteQa6cmWApCzzV5vQYuk1XtWs/7XpQbRroEpzorrsbDsx0GabscrNePI5H
         GK/g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=FQauslTrJye8WtEKr4/uMYFLXtDrCWIYYsnNnENx50w=;
        fh=9DLCxYm/c2wwWUXXjgHV4gvSq2ABtCsGEwHL7OXdQuI=;
        b=bSzj++Y4L3k0YHFNuIYxjBw+N1krE5b0RTXUDgQPN7v5WXDAQ1YizjhOcmFBpHaTlL
         aigDsyDImzCRlSw8djGO3KF1AklPfpD5myalZT5SaDmUNGolJdCYxeajX/liQPLDopQe
         K3mMvPW+Sbm+/S8GTL09bFk6KbhFVjon6UdROXa54Rsw83S42TdshUUlRhxD6HMt48me
         AN91kCN5irxHb3zucU+ns9dzqv7f3NgNKtTRj9fuzBVEBwAbJk7Y5t6hy5alheQeqe52
         KvRqhXyL2tWsKRIIvkC2s2xA4hvmRserZ3ifU9LGAkdcEHUbt28MjWVIg5ZpkkLugTdG
         NEDQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795447125; x=1796051925; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=FQauslTrJye8WtEKr4/uMYFLXtDrCWIYYsnNnENx50w=;
        b=tnOVRIK872Am/h1zBxtrm624YwtnAaM1ODFpUf4BIJQhjvNzDIVKPp0Tc0+kuNgK+T
         P6zbEiDvzhGQMmXVnvEgssD5Os9Kxz71/UfuvuNfnMWhsGjmbEY+8raprIJ9X6wrs9+P
         t+n4QGoPL0En++2BIFCjCTfGW7tcR93V3ClOyWg2gSS8rvl/rQevnj+NbA2pmKoegUTq
         wAOmepamNX26KktT8XanGPaaDNNp/wDvhl8maLDsDH89HC5UHE/TdVVYvF0O7DiHJyEN
         CZVx9d478DNjHDgR4foo1kre37sD3glA5umfoInRNznQIrbXZtcPjA2+5t6yJceHDFpe
         Nzlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795447125; x=1796051925;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=FQauslTrJye8WtEKr4/uMYFLXtDrCWIYYsnNnENx50w=;
        b=ijR76jxw9XfygJ8fpANyKgwnqiAeoj1fh1DNwUUwkArl8KDuBcPqg6Vv+YioOPXsIg
         Rcs5+iGco7zxeNIKjt9tyHrgKLHG+mSq9UWRl57yvE9QcGSxAjRefb3lwzU6gyuXTabb
         kK0fUYBfxRY4/Quqn5j6TBdzzosIctpDEcRdS2G/SobWIvD6UE2wsAPuIkpkdC7rqISv
         I5ihO5AAEnc43aSLXSnGQtI4xlUQMl/SxSmsBOZT/X4lp7nCV2Mey/P8dM4q6H6Ryee+
         OMJYDL/FHjKK878e/yIb+qyqS7hABA0i8NeyPDQ7NBrKt00YRhJkopa4K50m6VNp6fMF
         gS7g==
X-Forwarded-Encrypted: i=1; AL+hErEkZzXZzo5X/9GAVzg8cTr1PhDkDj0Xx/Y0VeYZxcw1mhKzuxJqrkx5uDCMhBBxtf0O0BxlDBTjXVQ=@vger.kernel.org
X-Gm-Message-State: APuU4Z8LfxwjMkjbVwbE3nlmfPnxXGAkk+RkZuazHLp//n3iToi4jnKH
	ExRqkxNO+wmrTb7YuVl47gOCsqUKZ6fdXvlQn11kPSjDoeSd4qIdJ7K6dANuuVuqk2XZOAnU625
	0bKbvgdKImWMntFMIku90jtMigH7YOSg=
X-Gm-Gg: AZFdTZdh8FxGk0wYoAqpm4bacJhHi5s4LIUSfqfncdHNKQbydrUCtw7UPDjqzAoDkto
	jRG0HprQh9YtUx72giwZFmOleG46KsqHdjvjuaq/o3oFmzoD5CR3augKLVGBBUAt+kE63AtjTxr
	4FvzXpJWuYaXAF9H6jw4RJ+dQ4Lr6uZrz6idLTGdou/ZrI+ayAAJErnoEZgSQ+HwzWYaosHsX4n
	W/Vdmcdb3mRNauCtklQ694s9trIIn1AUQcOkNf1htHf2jY4ExCANV7cTsmjl9qXJUu3twxFdQcV
	xkfPvg+hMmAN7v7BN9YgaSmU4D1GtRBpHQ6eNyGo7HBqIwCaS8umNPi+WaMo3GYy82Yg1VQfPHx
	gVtxfd7CYkTCizEyjaDmBdL5EIEjh6CgH+rrlW4iXhenFoYXeYWzNwkV8FJeN3PhnQq4D3x8=
X-Received: by 2002:a05:6402:23d0:b0:6b1:b97b:744 with SMTP id
 4fb4d7f45d1cf-6ba37ec18e4mr7070716a12.32.1795447124603; Mon, 23 Nov 2026
 07:18:44 -0800 (PST)
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
 <DN2NVGUNO0GA.89JAB2PVI0LA@gmail.com> <CAOQ4uxjuAN0FdxGr_-OccO5qnUuLF5oxOq7L_545tG3+36EKFw@mail.gmail.com>
In-Reply-To: <CAOQ4uxjuAN0FdxGr_-OccO5qnUuLF5oxOq7L_545tG3+36EKFw@mail.gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Mon, 23 Nov 2026 16:18:32 +0100
X-Gm-Features: Aa3M54oObGzmT9EyX7FArFQpCHBYwqipULgBnYau0_-PZcRo8HGalO_VEERbt3I
Message-ID: <CAOQ4uxgyKcB8GjE5_S9fgMv9oC_dKKaypDWEf-eXEkFeo5e89g@mail.gmail.com>
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

On Mon, Nov 23, 2026 at 3:55=E2=80=AFPM Amir Goldstein <amir73il@gmail.com>=
 wrote:
>
> On Mon, Nov 23, 2026 at 3:31=E2=80=AFPM koraynilay <koray.fra@gmail.com> =
wrote:
> >
> > On Mon Nov 23, 2026 at 3:14 PM CET, Amir Goldstein wrote:
> > > On Mon, Nov 23, 2026 at 2:50=E2=80=AFPM koraynilay <koray.fra@gmail.c=
om> wrote:
> > >>
> > >> On Mon Nov 23, 2026 at 2:00 PM CET, Amir Goldstein wrote:
> > >> > On Sun, Nov 22, 2026 at 1:09=E2=80=AFAM koraynilay <koray.fra@gmai=
l.com> wrote:
> > >> >>
> > [...]
> > >> > Rule:
> > >> >
> > >> > You cannot add a flag to common without carefully auditing all
> > >> > filesystems that support the legacy flag.
> > >>
> > >> Yeah, sashiko pointed out a problem in f2fs, and I could reproduce i=
t in
> > >> testing, where adding COMPR to COMMON makes f2fs crash, it also need=
s
> > >> NOCOMP in COMMON.
> > >>
> > >
> > > I don't think this is correct, or at least not enough.
> > > My agent said that this breaks or changes things on  f2fs/ext4/ubifs
> > > I didn't bother to check if all of them are true - I doubt it
> > > bottom line - need careful audit and good testing.
> >
> > Yes, definitely.
> >
> > >
> > >> > FS_XFLAG_ENCRYPT can go into common but must also
> > >> > go to FS_XFLAG_RDONLY_MASK because it's read-only for
> > >> > all existing fs.
> > >> >
> > >> > COMPR is rw for some fs and ro for others.
> > >> > As with CASEFOLD, you cannot make it COMMON before
> > >> > converting all casefold fs to new API so that each can say
> > >> > whether it wants RO or RW.
> > >>
> > >> How's CASEFOLD currently handled? in the v2 I'm drafting, I added
> > >> fileattr_mask_to_legacy() and fileattr_legacy_to_mask(), which conve=
rt
> > >> between the old format (filtering by FS_XFLAGS_MASK) and the new mas=
k
> > >> format.
> > >>
> > >
> > > Good question.
> > > Need to check this.
> >
> > Can you do that? If not, I'll check tonight, no problem.
> >
>
> CASEFOLD is set in FS_XFLAG_RDONLY_MASK and NOT set
> in COMMON
>
> Therefore, doing set with the old xflags API for the common flags always
> preserves the old CASEFOLD.
>
> This is kind of ugly and works but its hard to see the design there
> so hopefully all the new helpers and masks will sort this and make it
> more explicit.
>
> IOW, ENCRYPT can use the VERITY RDONLY and COMMON
> precedent because it is read-only across all fs (via this API).
>
> COMPR (for the purpose of ntfs patch) can follow the precedent
> of CASEFOLD of RDONLY and ~COMMON, which somehow works.
>
> Note that for fs that were converted to the xflags_mask API,
> COMMON should be irrelevant.
>
> COMMON is only used in SET to do GET and preserve the ~COMMON
> bits of the "other" API flavor.
>
> With the xflags_mask API, unless we adopt the "verify" feature
> there needs to be no internal GET with user SET and then COMMON
> is not used at all relevant at all for those fs (e.g. ntfs) only the
> _fill_ converters are important.
>

The statement above came out too strong

The internal GET is still needed for the permission checks (immutable, etc)=
,
and for converted fs COMMON still matters for the legacy ioctls, but it is
not used when the new xflags_masks API is used.

I would love it if we could get rid of the internal GET, by moving the
IMMUTABLE|APPEND checks to the fs fileattr_prep_ helpers.
But this can wait, you should not be distracted by this now.


Thanks,
Amir.
