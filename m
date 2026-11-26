Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.52
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795685018;
	b=pyTYa64KCG8IZadRSIHemhZu13suuIdGT1IqueAi88X9Wvt/770tAlAKMVJY4xdyEFI+
	 OtsYmlrDo5ZODjpSSTcgHd2o28oLkAg7q3PVdmhF4iXSSOnrvUdnAITik64b+nIMFzwIY
	 aeMJ9kv2NHeGplUpthg0BESMscAGn/RjeX15WoOx8alVWSsP7tdKAm9zpbRNDuqv3uCZa
	 SKK59V9nR9qy58TGHSsnCIkN1OtRJp4q7xU1NvP/if2Qpvw8z28mMX5cnEVjzbCSUDwz0
	 JzXCL9s43+5VT9wt+m7mGfO1PFi7M2HPZYnfSB2ko0WlgBGaoe4q2zSAqITBVJomqIA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795685018;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=xckR6blDjDVAhqTSlG7y2c/dJk+7MAk3ZiUn44VZKcw=;
	b=CVCjjQt3UFgpFHS8so8GhPfJ0gZbputSYSXH10VGtOYhWYRR454l2g1gGffqYYGEqSIB
	 9rtIA7Alwjqvy4n+cdzioYOysEF4MpVPCBORSdmQhiFo79vtgy5soOTslMkrbsB57JAH0
	 uRntjnUO26hwHj7m6JWe+Tm0wiBa+4/U26HkiLYJ6i2PtkK1xPpUl0NWN5nKTCug/MLlO
	 G1rACET4AB8MhO7o+UCHbkO8DEI6vlb0GJDttUH5llCSDqhsknDfVnWze/tVFhkGKlKSp
	 uxuc2Iw0//06sqor2nmNjE9nVzJndhWLpZwiUKIchZJP/ZaP8yj8bVlE18ETGi0b09A==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=htZC86Pa;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.52
Received: from mail-ed1-f52.google.com (mail-ed1-f52.google.com [209.85.208.52])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4846B606A32A
	for <linux-api@vger.kernel.org>; Thu, 26 Nov 2026 09:23:38 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4846B606A32A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=htZC86Pa
Received: by mail-ed1-f52.google.com with SMTP id 4fb4d7f45d1cf-6b4bd3d98bfso8555352a12.1
        for <linux-api@vger.kernel.org>; Thu, 26 Nov 2026 01:23:38 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795685017; cv=none;
        d=google.com; s=arc-20260327;
        b=chKk7gXXSVN0b0rxWzamPi93ARKHGQkmFjCQBwjl8SeKb31ROQfH+jF6isKY+LUEMb
         2cs714/f2nlQLFZEPNd1Ti2drazetBNbTHKfnwt8yGhAKoS5fvOtrDdmY8NowpxuA1wf
         0Vy8TuFb3mvaVc/7n78hSJn2r/viRukZlj2FzdsyKIOVNI7YadIJLKUPgIotTrVbKpXY
         nM1eNvnhTp/bC2DXvSktFpNj0ePVYo8bjwRSoLr2hJWKTEIZhTysFAvAwYPPQHJPDRy5
         38sD++bllm4uFcvOj8mZrcGNzMULa4FUeU4G5e0MycBk8QNrw4f7Tl/RZt/njTKOWpCY
         Mh9A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=xckR6blDjDVAhqTSlG7y2c/dJk+7MAk3ZiUn44VZKcw=;
        fh=bLBooEO1/gg3Ptecr3nIPsb+ebpVjdgxDVxOBh8EizU=;
        b=C4927UsEMfGKBa3sMkB8U47ncr11B5Vs65lrh1C+Xwr+WaokrwA9sQxd1Yp2Y9Wo7V
         qiqUhThmuayswy0ibCUNoRSPZZcdPJj7DkBoj0sCjb4eEUDixjxhzf2EUy2UPjytOwOq
         rdT8b9MBDQQ774CxgsGzrTlP5CMXIIbcngZNwd9Rj3xs84WGhE8pVKXszpAJovwQXY91
         WS/0sFU+7FeDdfh/wS8iJps1X2HUu+4nYg7grhxsHbC29+ap3y2yUUDvvrUHPMPAZggB
         P3KI3g3MuqnxGWt7seJhEdTXbpTuPuxnppMm2WIp8kLllJrM2onruh+k04HwRFK+qsLz
         qMFg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795685016; x=1796289816; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=xckR6blDjDVAhqTSlG7y2c/dJk+7MAk3ZiUn44VZKcw=;
        b=htZC86PaPTG34kYWAisdWcgHJD1UzaMIQvA1regyq5nViPY53KsD3NsllAndQX1evi
         Ni4eoDAvoFkwSVjRH2aLo8DK1It6q5/8NfVeByru4dF9S6/VEXj+TZJ5U8mChY30w0Uv
         jcCx/2OSR9wIj7x8YmXDsxOsBKo6p3Q3ujwy/4TdmbIF5u+YX04R1Bv1QF0hLopIVtio
         PngI5fpJQ1uCiosc+uFsN8S0QqiNZJdqLTNdOL6uay7GyqwBy7ErG/e7G5Nk2oTVO/wr
         64NWwOk7mZ5vgAa+kdjPvHzrMIdBU6PYX15ePP1qntAbHhcwn6ZQtcGoRW3QJj2GibeU
         nxqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795685016; x=1796289816;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=xckR6blDjDVAhqTSlG7y2c/dJk+7MAk3ZiUn44VZKcw=;
        b=szaHs9nAtN+2IzhSaviz8pPiaNWR2JsAGEeK84E7YwoRTXQq/kJAMzy90JcksvnCgh
         xxaMfdC6QiJFNvNdj26WAFAl2oed1nNMiL1k9hecFSjEKMmco9UWgGJikZ5wUyCV1Xpa
         Rgu5Cwu39H6/te0t22ZiZWky8HemCx0y6mz6rsmHLMFclsO1Q4WQBWrg5FlFg+SQY29n
         LmwR7Db3cetmvM3vdg6PqyC+m1qIJ7AdCAdy+NipMLJS3FXJ+0GvTwmcgYAT3PYNejnP
         I5GplAwgoT4V21Alams3A41ibj2STnPkW/ONun9o+BWP4KeuXIHH5qJONbG4wS6AGKND
         mXKw==
X-Forwarded-Encrypted: i=1; AL+hErH67m5dDBelPXbuxhbcbSnonqYjggCdmhZX/jW5LV3WmdrNdnwKYCE8YE7wA1AcgrwA0XcLJ9O7Heg=@vger.kernel.org
X-Gm-Message-State: APuU4Z8GRyCtso+NR4GNZeffJ0O+kQnFbOmhcClW0r5n4NsO6ilARsmx
	RoCJ6L6/YMKT+PE21+nkILR+f+jVTvELFKDcdHx+Vj+N3K8dAL4uVrxpeXWe0s9/QPN4JOQWSd/
	vCPnZZzrjC7j+W7uBCeXOWgPHVWQTUzQ=
X-Gm-Gg: AZFdTZcbb6xdGO4HBDrDIWgHfsoq6YdElo4epniruhURL3GJqBTOGiGc22H5g8kDCFe
	OvQE/T/gq92MF2OImV8mSCK2j0BdUtplKRXZhqa/AZ6m8cmjV6n7l/UGevJSSO10zTTpR8omt9j
	plzmM5DAshu57DKfVbMmb5FGdpv+RXIhdMAcPmK3mQxOORL0958TfjU8Bi4N6ueknMocztzVgaz
	3et/t1ZXGFUPsZXKrOIT6xXacRbAutqu0kTpoxtXbqyoYNawLBrKG1Ji+vMzKuyrGax9Y3mMj1S
	XyYZwo1GoGnp3vHeHQf6rG27l9Gd/VtkrBeETQM1Sl+RUhsKnC4Eg4Ma0tZ8VjUHRIXDTuoItvZ
	dUOL0GpIYtVGo0OCMLroueujjvn/+Xb3GYfFn2m7hOzJWM82GpVF/PPVnWIDfg/W1CpbWGA==
X-Received: by 2002:a05:6402:1501:b0:6b7:182c:5d4e with SMTP id
 4fb4d7f45d1cf-6ba37c7c3a6mr11134218a12.5.1795685016112; Thu, 26 Nov 2026
 01:23:36 -0800 (PST)
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Post: <mailto:linux-api@vger.kernel.org>
List-Help: <mailto:linux-api+help@vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-api+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261122000856.536902-1-koray.fra@gmail.com> <20261122000856.536902-3-koray.fra@gmail.com>
 <CAOQ4uxhegn1z=41_MHL1Zu2hXuPtzNhC=x4gd371oaeJE4-weQ@mail.gmail.com>
 <DN2N6A68PBO1.2QT8ZOARF4I6L@gmail.com> <CAOQ4uxhDQqEQ3T9NveBFpUmSU032BxrNV5D+_zHj8u9LOQY+qg@mail.gmail.com>
 <DN4DRUYPHYMP.20U4DYV5VBN7P@gmail.com> <CAOQ4uxg0g+XkPb3-kQS5ez1-rp7Q=BkYDHW0CGOFhpbcf70yMg@mail.gmail.com>
 <DN4KLSM2OO0K.2C8Q5CPFBVNL6@gmail.com> <CAOQ4uxhpJygZH-arLFSUYEEfqFG96Sr3_6CWakfSkdWxEsOxMg@mail.gmail.com>
 <DN50PH7HHSWZ.3H4T25JFPQECY@gmail.com>
In-Reply-To: <DN50PH7HHSWZ.3H4T25JFPQECY@gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Thu, 26 Nov 2026 10:23:23 +0100
X-Gm-Features: Aa3M54qgNadyHP5LQf6BsvKupVU6AY9XgOmNRBH-yAFSYibTS_3xHgBMtDNHcI0
Message-ID: <CAOQ4uxgJTSspRJqRFaSJxKUShVULaJpMv8UhBFR-DV2kUe1sXw@mail.gmail.com>
Subject: Re: [PATCH 2/3] vfs: add xflags mask to fileattr API
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

On Thu, Nov 26, 2026 at 9:59=E2=80=AFAM koraynilay <koray.fra@gmail.com> wr=
ote:
>
...
> >> > Attributes that have X_value like fsx_projid have few types:
> >> > 1. 0 means disabled (all existing values incl. projid)
> >> > 2. 0 is a valid value but cannot be unset (btime)
> >> > 3. 0 is a valid value and NULL/unset is also a valid value
> >> >
> >> > Only for type 3 does can the interpretation of
> >> > (!XFLAG_X && !fsx_X) be considered as an "unset"
> >> > and anyway, this will require support in individual fs.
> >>
> >> IMO !(xflags & XFLAG) && (rw_mask & XFLAG) should clear/unset the valu=
e
> >> in all cases, ignoring what's in fsx_X.
> >>
> >> And all existing values would be of type 1 for VER0, but of type 1 + 3
> >> for VER1.
> >>
> >
> > I agree that this will be more consistent.
> >
> > With explicit opt-in to FILEATTR_MASKS API
> > vfs can determine that
> > (!XFLAG_X && !!fsx_X) is alway -EINVAL
> >
> > When fsx_X =3D=3D 0, the value of XFLAG_X does not really matter
> > so filesystems can decide themselves if they want to act on
> > an "unset" flag or not.
>
> Hmm, I think fsx_xflags should have priority over the value in this
> _masks API.
>
> In my mind, to clear PROJID a userspace program would only need to do:
>
>   struct file_attr fa =3D {
>         .fsx_xflags =3D 0,
>         .fsx_xflags_rw_mask =3D FS_XFLAG_PROJID
>   };
>   file_setattr(&fa, AT_FILE_ATTR_MASKS);

If the program (e.g. chattr -p) internationally sets rw_mask =3D FS_XFLAG_P=
ROJID
what do we gain from not requiring the program to also set fsx_projid =3D 0=
?
I just don't see any wins for anyone from this design choice.

Maybe I am missing something.

>
> and have projid cleared (same for EXTSIZE/EXTSZINHERIT/COWEXTESIZE),
> while to set/change it:
>
>   struct file_attr fa =3D {
>         .fsx_xflags =3D FS_XFLAG_PROJID,
>         .fsx_xflags_rw_mask =3D FS_XFLAG_PROJID,
>         .fsx_projid =3D 67,
>   };
>   file_setattr(&fa, AT_FILE_ATTR_MASKS);
>
> and this:
>
>   struct file_attr fa =3D {
>         .fsx_xflags =3D FS_XFLAG_PROJID,
>         .fsx_xflags_rw_mask =3D FS_XFLAG_PROJID,
>         .fsx_projid =3D 0,
>   };
>   file_setattr(&fa, AT_FILE_ATTR_MASKS);
>
> would have the same result as the first snippet, but not the same
> meaning, since this would mean "set projid to 0" while the first snippet
> means "clear/unset projid" (but in this case, for projid and all the
> other already existing fsx_* it would have the same result).
>

As I wrote it could matter per attribute and per filesystem
whether set to 0 or unset is different.

The man page language should be flexible enough about this point.

It only needs to document the invalid combinations.

When proposing an UAPI change I often included a man-page draft
as a proof that the UAPI can make sense to human readers.

Thanks,
Amir.
