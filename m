Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.218.54
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794987857;
	b=g4MCEDoUlxzGAXAty1yq4UGFTd5EAgM/0IRRQ4/YVMrRtaM7zrqNw8CqbueqHzG4kLMs
	 yy2xD6bNBSdqnIRGg9ACI/zmQO5rbs9hX9O0rhpYLzka6OgERjEk8fkPbrAwnB4EcKjui
	 OIfxrWmiIfocJJoOx2VOrUX3DbILvPqnfAI573NHF5fr89BxmU8p1pJRJZVf34I1K6p6p
	 Ej3XHJ9y5OmgC/KqxQ8WpfvSa7dVEwzUcNFsh+er8Qp2NFgHdir60EDgscjyjvQK9qYW6
	 fsqm58SRzffMYGeJl0hWInWRJkdz5Z45/zIVXZfb8Si3nPCUChYeX5DAWsi71j8hF7g==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794987857;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=n4AlrOV2bTkxElEMddERWhd2tmhmmQ/VeiiLUiTK5Jw=;
	b=LIh0UXBUzcRLB6N1v2HlNxY1Lu7/heuaA8MYqW0dO3gwyT3Sq7lTN5xySaTI6oqzofBs
	 PEYi3A35E4bQVy+4j2K+lKbVDvPhlcD3jZy0iwa3ATQKTQXCshZuj7Ao/3fIUPRHQHooN
	 Whxe/cX15iRojrGJsciHrOJrQZrk4gmsbmsh86MBU2hEKp2a3kakLvxcctbFLoQwIeYPx
	 Dt9SDvO5kKmMKaw1bak56QcpTV+dmpl/V2TblHegaUbSJwvP2RbZVdLce3uIhHeMVY5hP
	 MChw8f1rP44ja42DGRo9B/X3Gljgr2OvUrMRySXf39kt3O0FSkhYKzawpzuRaXF1s7A==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=a90oyekV;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.218.54
Received: from mail-ej1-f54.google.com (mail-ej1-f54.google.com [209.85.218.54])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C27F3606A32C
	for <linux-api@vger.kernel.org>; Wed, 18 Nov 2026 07:44:15 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C27F3606A32C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=a90oyekV
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-c506a231b88so78059566b.3
        for <linux-api@vger.kernel.org>; Tue, 17 Nov 2026 23:44:15 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1794987854; cv=none;
        d=google.com; s=arc-20260327;
        b=XUqKzxDo36D5xYkTEFnkoEdBjf/VpWREKgNt239fnFjd0YwAOjDmwClSPd6KxWN1hq
         wcVayVJ5znEBL/oryg8SqK0U2B/YzX0Rc443p0RXimoQGIVKzPI4J+I7dtii+zcJDqHj
         vLcXHncyym7n6KS/HrQxmaVOr5knxM8EuTdmR5J/j50b/I0eqKXOqXHpn+iuOa1ELSdr
         xF4apjWth3J5/8GXJxV0Cjxa62APXDsHtqc5Vg0AM1Wv86dmuwEHaP6x79h/ttcMTzZM
         KmT5zzOfiONYBmb8XaIoiZ2hV2C6s5W5IqbDRM1+gmVL9mR21Wv93zIs8M8fOPvhSL1q
         GBhQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=n4AlrOV2bTkxElEMddERWhd2tmhmmQ/VeiiLUiTK5Jw=;
        fh=6HtiMSqcyRD+kEcGh10sDvsTuofJBxMsdzCafhxU5CM=;
        b=PiKFnulzEwtN/dpnDyTvjvflX9Kn1RCjPQrsHIhWzbaBnOlIxk/sE3v8tAaSkFqNoT
         EWVZEEQk6hpTX2Ermv6GDVm8YmT2GQj8MCoppa/XopmXj/w+iI2o+3iauLv87GqwEMXy
         C5HQkept/J7vteegvUUj3f8pzeDH5j2WaWaW+BO7mHTSYND0QC72+8loXTfMHyPmCFdN
         nt5A78HKkdIXp7CVFUHxViBYxxgXZ/hb3JXWxH9xUO6VKe6IE6w1hv6DzVcWLVztY19z
         Wj/j72WkdQBVncovMA8FGKw+4ncWSgkHsUPFs6xqL3Wl50PnHmTSRh6/r6/AjVEytaIH
         hUrA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794987854; x=1795592654; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=n4AlrOV2bTkxElEMddERWhd2tmhmmQ/VeiiLUiTK5Jw=;
        b=a90oyekVEtWSbiQRFscTKUuOugQqsd/uPA+FKR2IB/q1W1t8taa8KZshmfMtrhj1sD
         LqlTnKmsQhen50SBtfcKu6ft+wmIP8g2pM86rjRDF5dOKhx6HkBJjAXW7T1Tl+HJbYGM
         9Z/N8X+v0TSuGqaim2wrUn/cNQfHBvaUNsmrozwAN8tX044VAK/I37vtJhmtoyIAOWLA
         XYHsu5zGuiaBInhEXWSkPT9Ljesxk0waBX2hq58DlHTNOBoHWFxCJ3W007gohZobfiCi
         lUKynaBj5mnjW9OxWobgOEENOt4UOL2ebqhsSIkfnMawpK0ePLqbjCd09xHI9SQgG63a
         TzFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794987854; x=1795592654;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=n4AlrOV2bTkxElEMddERWhd2tmhmmQ/VeiiLUiTK5Jw=;
        b=2Mt/1VNzFAm5QjjX8k8Gr+I3ffpNpfdMDTgtA9RsFIccaNszu1rY6f0KdqcrXt3MUf
         sg/gSrd1irVBfyJOk77HNGmU10H6TxYQ9pugTF4+Tk+kzs+nL/u57BBU+uNhFJDnWSVL
         1OoiPacW+d2r8gVWUDz1wYsKLTTuXf8RcLcblE6R9V0M5ZDK64wCgjsUihMe1QlqKu+f
         VdhRmSDVSeRUqifgdd7lU4JrFjJ1fWYAlN91Y2JA6/fleeoKdmU/E7MvVPcDaQB0MXHu
         xXCsSKy3s3mZnlR3h8C8EOWVV9m2qk+j5Vq2Fi+mMjfBj0PeqaIJ2zPM3PAmTe3TBOcm
         TprQ==
X-Forwarded-Encrypted: i=1; AL+hErHWVEfW1fVI38khmjdKZ4QL+S3zEhbnIjk3mSTszsP6mBaNozgt+izBxbqsUsgY9zwWmX6qbkyseIM=@vger.kernel.org
X-Gm-Message-State: APuU4Z8ibnUSAuupdkNEh8F6BEI6q0oLQwXhCIzeFu8gBN/fB4rTdRJ/
	sIS2OSeo1+iop+YkQlWMzis6b11H4Er0Pw7yL/K3ZOv4W3KCRf79YtiNg/PvTluiOBAr6yGvDIs
	eNE02hXLHP1yR8v2FUaUVb7NP0rT+onY=
X-Gm-Gg: AYBFou2oJlgb3h5YDbWfNFsJUgclIgHJ5lhC4w0lyicshrsYzUGWEHuyY6BsJBOTHtj
	lIKO1p6sr4q03/UKmFgQePwCDCH6eOvi8RL/pV7qYS7C82/5jqeJVogXl3aDBIqXPeVFpJe4zGn
	9qs3EmMtOv1KUziIr3U10CWcMYn35Ys9Hq/4rbqqPwKICrLL3yrtYEvbJjDA6YeMv+tjf5SBH8m
	OspDVApApE3CU9oSoJDJJW4b7xxZV6fynh3Oa50g7js0XtsZ6tXFAP4GVJdizEv5mjL76dZjxnS
	yfr9RtCkARXIgu/c5/X/DlpEQ/bvfNttYAlT/1i52qHvkh8tFWb5v4aEbkjRGwBViJkrYsYfyIj
	3NBulioEQUMPjlhp9hdUahCFp9i9DpV8hnmOBSANK4ZdQ3TrUk8hfU/RN4gXgwdWlWnvWqA==
X-Received: by 2002:a17:906:99c5:b0:c2a:ad55:b3fa with SMTP id
 a640c23a62f3a-c510debbf56mr128472166b.7.1794987854109; Tue, 17 Nov 2026
 23:44:14 -0800 (PST)
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
 <f297d9ea-ebd7-47f4-ab7b-de5c45980000@app.fastmail.com>
In-Reply-To: <f297d9ea-ebd7-47f4-ab7b-de5c45980000@app.fastmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Wed, 18 Nov 2026 08:44:02 +0100
X-Gm-Features: AclHuK95FDUZyIgGYH5oXAgwPF3l-5HxSmk1nBdJ9DPBoS5wbYWUIu9nYKyQ4rA
Message-ID: <CAOQ4uxhpMARO_ZMJDeoa044BwufLVnS0o4Fv0abBF=tjaZmtWQ@mail.gmail.com>
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

On Tue, Nov 17, 2026 at 11:02=E2=80=AFPM Chuck Lever <cel@kernel.org> wrote=
:
>
>
>
> On Sun, Nov 15, 2026, at 1:03 PM, koraynilay wrote:
> > Implement provenance time (ptime) in NFSD, as introduced in a
> > previous commit ("vfs: add provenance time (ptime)").
> >
> > Map ptime to FATTR4_TIME_CREATE, allowing clients to set it across
> > CREATE, OPEN and SETATTR compounds.
> >
> > If the underlying filesystem supports it, use __vfs_fileattr_set_locked=
()
> > to set it, returning -EOPNOTSUPP in case it's not supported (i.e. when
> > __vfs_fileattr_set_locked() returns -ENOIOCTLCMD).
> >
> > When querying FATTR4_TIME_CREATE, request both STATX_PTIME and
> > STATX_BTIME, preferring ptime over btime if available, and advertise
> > FATTR4_TIME_CREATE support if either ptime or btime is available.
> >
> > Assisted-by: Gemini:3.8-flash-high antigravity-cli-1.5.7
> > Signed-off-by: koraynilay <koray.fra@gmail.com>
>
> > @@ -3646,7 +3649,14 @@ static __be32
> > nfsd4_encode_fattr4_time_access(struct xdr_stream *xdr,
> >  static __be32 nfsd4_encode_fattr4_time_create(struct xdr_stream *xdr,
> >                                             const struct nfsd4_fattr_ar=
gs *args)
> >  {
> > -     return nfsd4_encode_nfstime4(xdr, &args->stat.btime);
> > +     const struct timespec64 *ts;
> > +
> > +     if (args->stat.result_mask & STATX_PTIME)
> > +             ts =3D &args->stat.ptime;
> > +     else
> > +             ts =3D &args->stat.btime;
> > +
> > +     return nfsd4_encode_nfstime4(xdr, ts);
> >  }
>
> I have trouble with this approach.
>
> We've already established that, for the Linux in-kernel NFS server
> implementation, FATTR4_TIME_CREATE reports a file's birth time and
> does not permit NFS clients to modify that.
>
> After this patch is applied, the server reports the ptime instead
> of the btime on some filesystems but not others.

In other words, for some server filesystems FATTR4_TIME_CREATE is
settable and for others it is not.

Isn't the NFSv4 protocol equipt to deal with this complexity?

>
> Essentially this changes the semantics of existing files that have
> a btime set -- technically that's a regression.

I fail to see in what situation this is a regression. Please explain.

The only oddity I can see is that a kernel downgrade could result
in an NFS client's view of FATTR4_TIME_CREATE going backward
in time to birth time, but I don't think this qualifies as a regression.

Thanks,
Amir.
