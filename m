Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.44
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795019816;
	b=n4xk4ahE0Ho+ElJWSKVd/Lah8WeXXRvWn9j8Fy9Aoit0z/bxByGa0InZ8dDwsWE02lvm
	 s+HepW/uN33QegFm4zs0pG5lRBVOx+HtPyB7DxLqb5Fw5XR00sIRUhcZykz54R9q1s3Dw
	 2RGbfC3T6jenVGr+JnJVqV7BZTDOk/pi76/Wv4F2FEboZNk0MjCY329XhHd8lh6UBviwP
	 6yMJnuEDmwyXU11kUMZc2OArUIZpoLJqoHHLKWZzf97x4EJqsoJ/DLXnOUQuWchaeEm/7
	 UVUiIh4sGD0ZjYqYlXZYL5XPtPteX9OTbYOoe9slqTsiHVh72CNn413Z1uQWn59UQsQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795019816;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=ThJWWn15R7JIY3hayjLwOhu3LzqQd50Rds3OyAm+UpI=;
	b=nFXdBRF8CMky1n4W8cRS7PbfciHYogej0JFLwkcWW6WZYgNOVDanthqQq4iwU6cQCQvI
	 tqqq7PE5s8ia6golBYp7yeO93rI8aZUMWGLtLzB28YU0kzgmclHMrbM6E6vqIzuI2ywiH
	 4MV5R6KLbB5Sl8SLAbhkLQFxp7z6fJMnKG7qjAbkWMc0J6wLiObBcK/qPfmbXFo+bwAmN
	 E9fqWCsD8Gsyx7P450oitHzPvImvJOg0nf487kxQSkZAjPDv7kFA4kxJVHSTlfgbJyghO
	 O3V7ka0YqxV741J4G1COH46IDzKAUBp/ZzvKlP1pg1VOdDiWH1FBHWS60fmHPw7bHHA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=Q928FUfp;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.44
Received: from mail-ed1-f44.google.com (mail-ed1-f44.google.com [209.85.208.44])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B279606A333
	for <linux-api@vger.kernel.org>; Wed, 18 Nov 2026 16:36:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3B279606A333
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=Q928FUfp
Received: by mail-ed1-f44.google.com with SMTP id 4fb4d7f45d1cf-6b8a2518f7cso1093021a12.2
        for <linux-api@vger.kernel.org>; Wed, 18 Nov 2026 08:36:55 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795019814; cv=none;
        d=google.com; s=arc-20260327;
        b=JwZ8Dg5wWjEpLE64hsKZvtONJ+dqyinPqSDcv95M8K/0UyYFdqx1fz+j/G7Hm9Hpeh
         4T13bsMA4aAjaKJRX4Rn7bMzEgWe83pxp0km5LPufhsFl7Yx/fYVrd8KNtEO9rA103Wg
         bMMUGs6/a6EVvov4xqiFq2bO64QQERAQtIE30B43tgsCJ6q0Wg4tbJMkntPrXeGYAHxS
         Ni3gXRUI3L5ZF2DzpNMNoSEgS+1Icivubuyonm+9QDPC55kGm5xeFZqJTm/gUVW6XLmE
         QaR3DUJuFEPQr8JTdGAo8Y3JXmeGBA49mAdFV/UJA7u5qOxqn6i/PY63S5gYG6+dIz3H
         YcKg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=ThJWWn15R7JIY3hayjLwOhu3LzqQd50Rds3OyAm+UpI=;
        fh=sjk1v8ppoi9xPONe3KBS+YGlbybCndJABzctCndSOrY=;
        b=ZvVtT5NLvrR8KeUii5rkIvu2YSsMv+WAmYzbFdf+5AZAaDHHBxfva9n/yI2PepvNc/
         QVgz5sXYCH9okKZYPwr6r8dW685HYWXnr6++2+b8+H3u0qqP6ko55RArYWhyOofu8pqm
         IQsv47G9pobXEdqUi2m2Hg7y8oN6F+WtfqlS2ELKxGcUSp2k+HxWcKaLn2stapD3JaUA
         33xL2R/lsDC9igBAkh/O/dOzOYytK0JdsbnlDywHaST07lH1n0xpj4f1FCFKciIzd9Oc
         Pfvv1OBifqif5b6/vyOkyJ//GTwPHOKCbFu140tTxNtJ+aOjRGXo9TmZzbjqAB609taW
         ZdsQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795019814; x=1795624614; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=ThJWWn15R7JIY3hayjLwOhu3LzqQd50Rds3OyAm+UpI=;
        b=Q928FUfp2LnQkjGEnKMIMu+nIXWPV8Mw0HjVjFDQa7MZUVLuYPLFwnsc7iiHqC360u
         Kp8IRabh9aATlCbBIrXYC8LB4ujsA2WowQnPl0onFZOSJ5rVYhQ50HD2q0pTUJXyKimM
         OUL77cTMfVDMrYjz/NQW0TKyEQpYRFMt7Ju+HVxVGfRQjrSAY87Mpzq+C/2x9bC6NTow
         OtYFWyMzdvLEcoERGP5aXpJZMZOJljjkWPd07rML7zS6cDn/RnBxJCXaYM/7fpaXHvui
         3d3div9gMzI9ed77/rJrBt7B9+fw7rgFDQ4NESvylFpmE6QFtWC5GnB6Lj4Ro4sGb6Nt
         AJ7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795019814; x=1795624614;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ThJWWn15R7JIY3hayjLwOhu3LzqQd50Rds3OyAm+UpI=;
        b=flRAUtAyN8dW15ZpCnvlmG81ZaEhWKb9gpVfwRjM1Ewxe32Fl9Iv4RstGBp4Sz4qoY
         QmpkMem2Jxtbg+UEcNmyDKyLGIwaVgYF94biWZhcmoHZOoKOVgwPyExxD3VJ/OYRNgaq
         GL2az09qskTY5q/gYLgPnafyq7fcaobI4cUowg9ZZzzBEzbC+V6vmUp3FtgkmaDy+5M6
         igGypSareD+RETBiRnwQwQLt03drxSc+dBFRoIoiTnuktIg7vV8VqUcoNdHFQGLV+pBd
         tjcZkzg3bvvIDTA5AyFRTbeOZ4ZYJ2nGNcBNvnDmvU+EH9EzVSYCksDqOLpzkuyqay0r
         +dZw==
X-Forwarded-Encrypted: i=1; AL+hErGZbgwJnwFTx4Med3yRJ4NnheRBgLqXhYOafnVdSv1dVaFmlkV/QcpjDE9U8E2giAyixCziK3O8YJo=@vger.kernel.org
X-Gm-Message-State: APuU4Z9eXpWrqavrRIPDb64wmvmL/9BRgH07cYpAxcPmdQFtui6JCO0T
	rUkQ6NfCaQ7467M/qUqXPS7O+iCCCDZS6w5E5g1BnQsimMxNceZ5NJUnmkh6aF9eWw2kdED7T2Q
	doOBlSCDbBlPFWcO8tDbfbvdTAqMeSVk=
X-Gm-Gg: AYBFou103LITX+iimD/VQxN7+7h2n7zzMnTAKoFzaKOFS5laDkC32RouACF4ISF+p+x
	z2j3Sm/MTd1gYJEpBQaIGHb5OpX3IYlx963xGWj5dsNs3i9AHxhWLUScaguGqkN7/339tMg4D/1
	SwZVmRjAUcpwNEOvux5/i87PImqMSACmjl1m1T8WxbzsApF4ARYp6LAetWYtDq8ueRc/KH5gnaw
	AAXTyPXNZ7sbsU+G8isZFxLJNbGEAt8VPHZ/WuUbA1PoQqpwX7OoaCYAWVBzfWjP9HwmX/dhiLt
	lB04gMcCs6R3o3yAoirdF42nyLZGTnv9xxVsWT4c3xDprmJAQqqqSUzF7V5qNGiwsXEox43j3Dq
	veMsD/8Gr2uOqZglWkcXEeC9/lXzHw29gLHRCIc26zkS+3lkrZTWbB66Tbti3pVwdukpPQQ==
X-Received: by 2002:a05:6402:c711:20b0:6b7:b12e:1638 with SMTP id
 4fb4d7f45d1cf-6b887effc26mr1999145a12.37.1795019814317; Wed, 18 Nov 2026
 08:36:54 -0800 (PST)
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Post: <mailto:linux-api@vger.kernel.org>
List-Help: <mailto:linux-api+help@vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-api+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261115180343.576773-1-koray.fra@gmail.com> <20261115180343.576773-8-koray.fra@gmail.com>
 <f297d9ea-ebd7-47f4-ab7b-de5c45980000@app.fastmail.com> <CAOQ4uxhpMARO_ZMJDeoa044BwufLVnS0o4Fv0abBF=tjaZmtWQ@mail.gmail.com>
 <cd49ce48-58d7-4341-b4fc-34e63daf3c52@app.fastmail.com>
In-Reply-To: <cd49ce48-58d7-4341-b4fc-34e63daf3c52@app.fastmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Wed, 18 Nov 2026 17:36:41 +0100
X-Gm-Features: AclHuK_Wot5qcfi8_9CAebWCtd31KyKZ5gW_T2w6JAANm_7TsCfaaSyfxQBsTLM
Message-ID: <CAOQ4uxjme9sJ5LGNDnP6rEKZLTJzX_ZdcMohgu2iLULK96GPOA@mail.gmail.com>
Subject: Re: [RFC PATCH v4 07/10] nfsd: add provenance time (ptime) via FATTR4_TIME_CREATE
To: Chuck Lever <cel@kernel.org>
Cc: koraynilay <koray.fra@gmail.com>, David Sterba <dsterba@suse.com>, 
	Namjae Jeon <linkinjeon@kernel.org>, Sungjong Seo <sj1557.seo@samsung.com>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, 
	Trond Myklebust <trondmy@kernel.org>, Anna Schumaker <anna@kernel.org>, Jeff Layton <jlayton@kernel.org>, 
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>, 
	Paulo Alcantara <pc@manguebit.org>, Chris Mason <mason@kernel.org>, Yuezhang Mo <yuezhang.mo@sony.com>, 
	Jan Kara <jack@suse.cz>, NeilBrown <neil@brown.name>, Olga Kornievskaia <okorniev@redhat.com>, 
	Dai Ngo <Dai.Ngo@oracle.com>, Tom Talpey <tom@talpey.com>, 
	Ronnie Sahlberg <ronniesahlberg@gmail.com>, Shyam Prasad N <sprasad@microsoft.com>, 
	Bharath SM <bharathsm@microsoft.com>, Sergey Senozhatsky <senozhatsky@chromium.org>, 
	ChenXiaoSong <chenxiaosong@chenxiaosong.com>, "Darrick J. Wong" <djwong@kernel.org>, 
	Sean Smith <defendthedisabled@gmail.com>, Andrey Albershteyn <aalbersh@kernel.org>, 
	Pedro Falcato <pfalcato@suse.de>, =?UTF-8?Q?Pali_Roh=C3=A1r?= <pali@kernel.org>, 
	linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, exfat@lists.linux.dev, ntfs3@lists.linux.dev, 
	linux-cifs@vger.kernel.org, linux-nfs@vger.kernel.org, 
	linux-api@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Nov 18, 2026 at 5:09=E2=80=AFPM Chuck Lever <cel@kernel.org> wrote:
>
>
>
> On Wed, Nov 18, 2026, at 2:44 AM, Amir Goldstein wrote:
> > On Tue, Nov 17, 2026 at 11:02=E2=80=AFPM Chuck Lever <cel@kernel.org> w=
rote:
> >>
> >>
> >>
> >> On Sun, Nov 15, 2026, at 1:03 PM, koraynilay wrote:
> >> > Implement provenance time (ptime) in NFSD, as introduced in a
> >> > previous commit ("vfs: add provenance time (ptime)").
> >> >
> >> > Map ptime to FATTR4_TIME_CREATE, allowing clients to set it across
> >> > CREATE, OPEN and SETATTR compounds.
> >> >
> >> > If the underlying filesystem supports it, use __vfs_fileattr_set_loc=
ked()
> >> > to set it, returning -EOPNOTSUPP in case it's not supported (i.e. wh=
en
> >> > __vfs_fileattr_set_locked() returns -ENOIOCTLCMD).
> >> >
> >> > When querying FATTR4_TIME_CREATE, request both STATX_PTIME and
> >> > STATX_BTIME, preferring ptime over btime if available, and advertise
> >> > FATTR4_TIME_CREATE support if either ptime or btime is available.
> >> >
> >> > Assisted-by: Gemini:3.8-flash-high antigravity-cli-1.5.7
> >> > Signed-off-by: koraynilay <koray.fra@gmail.com>
> >>
> >> > @@ -3646,7 +3649,14 @@ static __be32
> >> > nfsd4_encode_fattr4_time_access(struct xdr_stream *xdr,
> >> >  static __be32 nfsd4_encode_fattr4_time_create(struct xdr_stream *xd=
r,
> >> >                                             const struct nfsd4_fattr=
_args *args)
> >> >  {
> >> > -     return nfsd4_encode_nfstime4(xdr, &args->stat.btime);
> >> > +     const struct timespec64 *ts;
> >> > +
> >> > +     if (args->stat.result_mask & STATX_PTIME)
> >> > +             ts =3D &args->stat.ptime;
> >> > +     else
> >> > +             ts =3D &args->stat.btime;
> >> > +
> >> > +     return nfsd4_encode_nfstime4(xdr, ts);
> >> >  }
> >>
> >> I have trouble with this approach.
> >>
> >> We've already established that, for the Linux in-kernel NFS server
> >> implementation, FATTR4_TIME_CREATE reports a file's birth time and
> >> does not permit NFS clients to modify that.
> >>
> >> After this patch is applied, the server reports the ptime instead
> >> of the btime on some filesystems but not others.
> >
> > In other words, for some server filesystems FATTR4_TIME_CREATE is
> > settable and for others it is not.
> >
> > Isn't the NFSv4 protocol equipt to deal with this complexity?
>
> Not a question of whether NFSv4 _can_ do it. It's whether it _should_
> and whether opaquely choosing a settable vs. an immutable timestamp
> on the server is the right design.
>
>
> >> Essentially this changes the semantics of existing files that have
> >> a btime set -- technically that's a regression.
> >
> > I fail to see in what situation this is a regression. Please explain.
>
> Any consumer that depends on btime being read-only is now screwed.
>

Who is the consumer in this context?
An NFS client?

Can't an NFS client be connected to another NFS server
implementation which does allow this?

I can't wrap my head around the problem.

Thanks,
Amir.
