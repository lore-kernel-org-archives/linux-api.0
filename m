Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.49
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795191432;
	b=OWYslg0dw39eYNZ3fCxo4tRDWjuKVpBS/2k9KWRsaLL4u4gIO8xNS+lTUYEFSMFEIZmI
	 ApsLGcjYXQXSskawp2H6X/aWOvipXPGa0T960SrpeNRH948CuLgglqQ+dNWupAFtj094D
	 R3zGwP4IA07KeKDJslPVvXsuMRaYPly29+gy9vEPCRF+w9Q92W8g004McaAu6pM7Mq4Sj
	 vcRDHLUfAAPGeKGfoc2eJ5VcK8BRPnriOg9ycr2IIET7vg/wcmOlEFzSFCKoNs6HVSqeK
	 3HgKE7dT2/r1buk2Q2MSv7k2yiAQjUYylTgTSrcTntq5km88vjYZ6hEv038qG7KbxtA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795191432;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=6pDEC7mZctjuQyIVdZ8lILmTsCvmwBFO6EStJerdj9U=;
	b=UVH/hVubEHgGzPvwBlXT3bUm8IKOQX8RnzS6kWxXJdzlAETK5J0xCXQA/qpwNWiPgI6S
	 Jl12Wfa8DZIzeNOxPIJLupa0WjQGDEXTGyMEv+0P0B0t3SQ+Vq64i0AyRbBfsS6y6GpU3
	 nJ5/uJ79HUbRDV4Bk60QOT3iQ3bX0wLQjXzV2TWJRxcwwtpNLeolCya0ABVzWx79jeAhC
	 qX2VzhNF8TEQvs7E3fmHwpcw+ZjQboasaZET1/t3kL5T4gERr/ht8E9P14onk2RotHjxv
	 AfrefoVjXMqCwWDhYEXr9RDrnpb8RBCAjNwJ8/3nAdNN2Ku9ZreP+xRrUKzKWoxS3/g==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b="h/fZwFYo";
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.49
Received: from mail-ed1-f49.google.com (mail-ed1-f49.google.com [209.85.208.49])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2883B606A32C
	for <linux-api@vger.kernel.org>; Fri, 20 Nov 2026 16:17:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2883B606A32C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=h/fZwFYo
Received: by mail-ed1-f49.google.com with SMTP id 4fb4d7f45d1cf-6b87a92c17eso1603431a12.3
        for <linux-api@vger.kernel.org>; Fri, 20 Nov 2026 08:17:11 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795191430; cv=none;
        d=google.com; s=arc-20260327;
        b=griR71bvs5fn3iME0zZflBtgRunFSEOgxmhv10RYT7a1oQCTf08uA+mLHTG80qP+g9
         yvXJu3ucReivvASmwZJvu3MgS61NN0P5MqgLvrP9WGu/0KcCOUXVAAe2k5GGDhACBIT0
         ljzduNc4O0NVGtUMsoBlEPVcAjsQIs1mxGPbKedcBD7MZmHbvAI+mlb1V4ltRgIzhKWJ
         QfOYbrNuJL+Jqez97mk2fcumjnF67x9eL+lF+LL5nUwP2rBMAAT7SOJ5ha4hBGhOeG3F
         xTD7+n8PNjNDS9l1K1izMffAwYxlbbx/2YHV0u8dPG06G15G0f5IxT+DPgrgMDHnZ4xK
         qCZQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=6pDEC7mZctjuQyIVdZ8lILmTsCvmwBFO6EStJerdj9U=;
        fh=askQaxr9t2WoS7ONgBrmNzsSxZMS/gBjRVQ0Xn86OnM=;
        b=aLJS8HnqabpyKxrB7eO/p3fpwWuKXT6+HjvfvEvZyNc3Th+jX6mDKG+F9TFX2s4woW
         qTEiTClR8Wh4s25qbTkNybmkLkSV8yLcLblIWGKFw32NNYcksr52vuJ7rpOXT7nGy+yf
         f/ES+RznIroi6HRfPzywu/0EE6IVBxtnBC2VE5M2gzupHUXlRG+TFft0xvClm12HvmBs
         VlD+rjq/zBazsqJWDncnApNOrwb7mM7036iJo60U0t8hXdozVqLufIVVf0MV4ndcKYfl
         x7BxjhCDTlFPP1tqqMranDwlWrh09vyJ1vcx1vJe8VNXmqt+ud21M9Je4B2gE3PO/+YZ
         GHUQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795191430; x=1795796230; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=6pDEC7mZctjuQyIVdZ8lILmTsCvmwBFO6EStJerdj9U=;
        b=h/fZwFYoiZ5YPRIJdDNPd6R2WQqQoX+h7cTcLwOfnPyAa1DPa1hxluLRyoO6Xm4sY9
         ovgYMuN1VmVG2b0g/LvfpIVhbQQX2N6IaALoOXq1GETPLvZs61MuhJ0UhI/bX7lZx9kE
         jrz+F1knWHvPKhUY4x5+Zcq6R49IPXPGuHiJXtvd9qU+hHWP0DeqyDjhSzKwzl2IvYdL
         y8KcOZpqPD5+clxjMHGD0gIx54eNMFAhPY1AXnyv17zAzyJbePexJvC3yP8mla0hT9fU
         J1CtyrcpOL584I1Qt0hbElWxdBJJ+Dsh5m8jAkiw92q7dDtejYpy9TmKaIr813bbhk4r
         grXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795191430; x=1795796230;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=6pDEC7mZctjuQyIVdZ8lILmTsCvmwBFO6EStJerdj9U=;
        b=bGUVvXIwTYvumeb5T9lf86y0KezynVoPhQJKAl82erG56Pku+X4NEMQ3s4Y/DyHdg/
         q4IIcWu+Zt0DCzOXRhGcfcJz2dy+y9D0igI//yDIXTHA5WvpRdq7r5xO7L/6xx/p4gO+
         ROgkg4r+F3rMjc4osn6sbPGPtQOVbwUpuX4yd5ORja0St4UOfoa+g169rwrFA0NQAX4J
         5O8ehubIkGP9iUwWMVpV8lKQRqpslzmCf0iJuCerIaHmHG0x/CsB16yrvdQOVuYYm6J4
         bia8ViXfIq+Ju/B0fDE6j0FnySoun+SBP5dH/TaiMMRLmeat8HlLYfqq6NI1vGpXoiBk
         vlaQ==
X-Forwarded-Encrypted: i=1; AL+hErE6wxfrNM2blMBlMgdV8WnLkkzTnHf0WncufRJPEsH/6eHNqnTgmEuSp2chx4DzuE1Eef8nOhLspuo=@vger.kernel.org
X-Gm-Message-State: APuU4Z/4Z4BCwnKEZjHWHRyh3c8nLkZjHgpGhn0Ufk/muig8RkaKnziC
	OGsGisLUBJAV4zybcqz9gloa9w6xDEeDH4Dx7n2xe0MkqSj9CO3xkiaPbHBdvpV6gZitOszG1fn
	VK3btfo84mfNZhjsaUXs9M7Hif6cGPWk=
X-Gm-Gg: AZFdTZev1HBro4l3SFEx3Jo6fBJTePmKs2M2g20vwrrwl5DQ3fPGJNseUfzSm2HLzkx
	v0qt+IxFduyYleTaetz2MMjzY+9WyngUsJy1C7eDfClsfxrtvQ8x7WM0wLHd/Hd9rAdVnuGBPI7
	DbDUv3S1q3zCZMV6tdtQ1Zcp3nS87teIxPoibRfqvHRXxvQQkvoL2nXwa8OUP8AjdHKdcIhWn8G
	Aq5kG9hnM5vzsccsd0js2L8e54KUHsbGlH9ADnDmEP+/DAktZxEOaL2x0yxLcoxqstwogxMTk0C
	pyt1v4qrJ2yI01OTu6GG5nUWx0ufI/gEb+bmPZnSjE7XfrpaYz/KAJ3J3lflviWQvZUWT88ewWv
	yM5JJzZxWvVIj/dva8drtnlrbRv53Ude1Tyv2iEuPpxredWNhUX+8mVqwvMr353We3Tdf/Q==
X-Received: by 2002:a05:6402:3223:b0:6b8:5f08:931b with SMTP id
 4fb4d7f45d1cf-6ba37ea44b2mr2736007a12.26.1795191430236; Fri, 20 Nov 2026
 08:17:10 -0800 (PST)
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
 <DN02S2XNGRZD.1KNOZJ0GGDJNG@gmail.com> <CAOQ4uxh+d-wNC0aWLEexPFz7zj=TZjLyu61kaEmwBx9_hKn2gg@mail.gmail.com>
 <DN0526U5C1RT.3AQRIHXPB86NS@gmail.com>
In-Reply-To: <DN0526U5C1RT.3AQRIHXPB86NS@gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Fri, 20 Nov 2026 17:16:57 +0100
X-Gm-Features: Aa3M54o4zCHXyRapvg8jSZ5VVJaxHz4N0ZrJOn4Hcu1m2DItc14K7Jop9PLrcPo
Message-ID: <CAOQ4uxjCN-ekd18R-soD8tkGFnXjK0S1VdSNhq9b3Ev6y8K9jQ@mail.gmail.com>
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

On Fri, Nov 20, 2026 at 4:21=E2=80=AFPM koraynilay <koray.fra@gmail.com> wr=
ote:
>
> On Fri Nov 20, 2026 at 3:55 PM CET, Amir Goldstein wrote:
> > On Fri, Nov 20, 2026 at 2:34=E2=80=AFPM koraynilay <koray.fra@gmail.com=
> wrote:
> >>
> >> On Fri Nov 20, 2026 at 7:45 AM CET, Amir Goldstein wrote:
> >> > On Thu, Nov 19, 2026 at 11:10=E2=80=AFPM koraynilay <koray.fra@gmail=
.com> wrote:
> >
> >> >> >                    fa->fsx_xflags |=3D FS_XFLAG_CASENONPRESERVING=
;
> >> >> > +                 fa->fsx_xflags_mask |=3D FS_XFLAG_CASENONPRESER=
VING;
> >> >> > +                 fa->fsx_xflags_ro_mask |=3D FS_XFLAG_CASENONPRE=
SERVING;
> >> >> Uhm, why both in _mask and _ro_mask? If it's a RDONLY flag shouldn'=
t
> >> >> it *only* be in _ro_mask? (same for CASEFOLD)
> >> >>
> >> >
> >> > Good question. Maybe
> >> > I guess if you want to follow some percent
> >> > FS_FL_USER_MODIFIABLE is a subset of FS_FL_USER_VISIBLE
> >> > but I think that exporting ro_mask and _mask is going to be easier a=
nd
> >> > cleaner than rw_mask but not sure.
> >>
> >> Hmm I asked that also because you said in the xfs shared extent thread=
:
> >>
> >> > The advantage being that it makes the interface symmetric.
> >> > User can alway setattr() with the buffer they got from getattr()
> >> > and instead of randomly ignoring flags in set, the fsx_ro_mask
> >> > along with fsx_mask defines the behavior exactly.
> >>
> >> But by putting the ro flags in _mask too, a user would have to clean
> >> them out or vfs will reject the call with -EINVAL/something else, sinc=
e
> >> in that case the vfs would see the user say "I want to change this [ro=
]
> >> flag".
> >>
> >
> > That's just a matter of interpretation.
> >
> > You could say that if flag FS_XFLAG_CASENONPRESERVING
> > is in ro_mask then its value may not be modified and fs needs to
> > fail the set
>
> Yes, that's what I was thinking.
>
> > if the user given value is not a match to the current
> > kernel's value.
>
> Since this is a new API, I think it's fine to -EINVAL if it's in _mask
> anyway, even if the value is the same, no?
>

The question is only about when a flag is set in _ro_mask
and say that it is not in _rw_mask
what do you do with the value of this flag in _xflags?

You can simply ignore it, mask it out as  copy_fsxattr_to_user()
is doing today and this is probably the right choice.

But you could also take a more conservative approach
like ntfs_fileattr_set() in fs/ntfs/file.c:

        /* chattr passes the unchanged read-only flags back to us too. */
        if (NInoCompressed(ni) || NInoWofCompressed(ni))
                readonly |=3D FS_COMPR_FL;
        if (NInoEncrypted(ni))
                readonly |=3D FS_ENCRYPT_FL;
        if ((fa->flags ^ readonly) & (FS_COMPR_FL | FS_ENCRYPT_FL))
                return -EOPNOTSUPP;

This is stronger, because userspace can express:
set flag X while making sure the flag Y is not set

in this case xflags =3D X, xflags_rw_mask =3D X, xflags_ro_mask =3D Y

It does not have to mean that Y is a readonly attribute
the filesystem itself could set it in rw_mask, but when user
puts it in ro_mask its a verification_mask rather than an ignore_mask

In both interpretations (verify/ignore) the sequence:

    ret =3D get_fileattr(&fa)
    ret =3D set_fileattr(&fa)

should work fine most of the time, but if some rdonly flag
can flip between the two calls (e.g. FS_XFLAG_PREALLOC)
then the set call would fail and this is not the expectation
wrt the existing FS_XFLAG_RDONLY_MASK flags.

Thanks,
Amir.
