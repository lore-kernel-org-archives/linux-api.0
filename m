Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.46
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793632194;
	b=F5k1aP9LrkY5M6Xs7+XsswWLAJzQGrzIiobfR0gqHajhLj7FuO36WRJdoAVBc0JdrRvZ
	 jzRKRp5h87nTxDoce7sY8aouToZ3lI8tWWjIx47qvTmjRUpzaDaRDdaeUZxe65M/H+yJ2
	 sWHE3nD9jLIoeU1F6nZIrMiAwhki5WZz30qKS2n02j844kSbEITIUB1srIgGKNue2eUxo
	 pl1aw2sHy5I+NGlFGt3YRtEh6cn5CCmnlrE0yuix/vyU9gfuXK+PGsDOFi3RRtxu8OzOb
	 e0OkborGRRUYF4+2iw1YGCtKRaIeyGr3vLGjQNpSlE601IJNAvbHiCowUXviQEgw3CA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793632194;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=V5oGEHqJ8v+T24gYPQlWKHiFIfSM1fugDdyxpETnIGg=;
	b=LGaW7yWhs+22t3UYi4vZAKiMpV9PpP6OrZjSgc5dzgui3fg/qWwbP5OXug7toOgKsjea
	 jxqJSBkHAxvN0hFx4a+BkLx/3PxYppg2/YCFsnnchUQm9FL0de+szksZPE+rXAOvEHLap
	 wdvtU0Gsh2Z7grddehL/YVelm9bpR1utub6D8my+jHb2hSJb7ghODna96cgdoQkIwSpE9
	 gFUe0elr5twoPxyAA+kRlF15MsmGUECloKEnnDc4vCqpBCkWQCPVzPVr/d4nieSWVeadi
	 aq1ZPd5FLTm4C3l4EtLJiK4cy/CWKwGQ1KFGZrAdba+maUMm/+bAqLsHImUG0cwY2iA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=mIOy3AeV;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.46
Received: from mail-ed1-f46.google.com (mail-ed1-f46.google.com [209.85.208.46])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 867D7606B909
	for <linux-api@vger.kernel.org>; Mon,  2 Nov 2026 15:09:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 867D7606B909
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=mIOy3AeV
Received: by mail-ed1-f46.google.com with SMTP id 4fb4d7f45d1cf-6b1afcd2d23so4383183a12.1
        for <linux-api@vger.kernel.org>; Mon, 02 Nov 2026 07:09:54 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1793632193; cv=none;
        d=google.com; s=arc-20260327;
        b=gCP7jNrBxpLTiynlbyc0A7zMm201ySwAGsgKplS1GNNGtxicENzwbkWR7jShibKI9r
         FlOhpuPqnwrz2e4mlmNk4wgb9NWimaoD/k8R0k3M0ZHii3PEoesviw2jdAVm/M96rGqa
         Xvj6k09iPaYZkxLfXxj7oS432oJaifaS5j3rI577fqS7hcGH5jfETWXibU2Jdf1oTJLT
         KkeM0NFJT0UYR5uSR+Ge5/PPQbxzL6MuJsvCtcuA1OPN8LqApOor1jk4l4ayuooa0O5g
         iv0jvGYsCh6UC0kbp1d1WD1lZBYWCaQDlzqhKRGal/1ADVqDSqnrze2DkaEGS/1SsX1p
         w5Rw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=V5oGEHqJ8v+T24gYPQlWKHiFIfSM1fugDdyxpETnIGg=;
        fh=HJSGyMtO4y9nWPPesy1cU8gBaGG2prTIFtTnJmiKEcY=;
        b=p5k1fc+N21RBClB4yXKFIOPR3xGIoLLsSMbfi5Bv9QZAjVT7W5OZJNux0uoioZ/zb5
         gDEglOHMFqcuTyGcp8h2pKTU0HNWACcleWrkZoR/wjDc52iy7HLcYYvGlG45CT3MPksV
         MpvGFbSLwbLQ01v5B/R1BATx0aSwDdelxSTtaphfOFkmiUH2sdmQRqqPT6qPKXpINaif
         NGS28nBTeOpncKPxeegmzmm5Ct9LMghS3DCVJSJf0JdDo5X8bXiFMR6q+jnBYyYFtj5t
         ctwMTIXybeUz6qLjk7YR1CHggcMZxgT1QyEZSaXQZ3tC2HUYqmwuwmOenCqob4iiNcs1
         F0Pw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793632193; x=1794236993; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=V5oGEHqJ8v+T24gYPQlWKHiFIfSM1fugDdyxpETnIGg=;
        b=mIOy3AeVsuWhyP+l6zA16Ucz20Y+QphUxMILOJk08HJCRUJzanCmGGCzgIzPsgBy9o
         LyJ8inTq2q9yWhRw7me/r58dVxm6liirJLCxwEY6460lx0DXcEkaqlFP8OV8YCx0kFoM
         HoE+n6yR9RitH33XexK6Z6cy5cl3M3o2JG9Z1WE6aUBM6ZsP/VxlHG534TLHDnsUaare
         jMFzjt20DhnmU8TYEiyotX5hCQYZdGjSym2gUXW1p7xsUyYH1XtX0iiA0HpEhiNC0u/o
         zVGFyTi7a55y36X4lQNFQ7NoXmL3GN3UjbePDGNGL779i91M7RqsaBxPOULjaqJU/Hek
         kMvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793632193; x=1794236993;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=V5oGEHqJ8v+T24gYPQlWKHiFIfSM1fugDdyxpETnIGg=;
        b=Qietwywq7SJRe3mxunt7H8i52nmq2BLq4PPLN/DpdGqAGqxTKK2ciFcE+GI/cGSlsG
         hicMhTZKgPI+91pxsTnDL+evvwNZTKL8UMme0SBbO9fwfXnWfgQ8z5xAN9Oz4a9SUvxa
         kTWWWTbSUonjoSvI/ntewelNEGgrF75eTDwYvp5a1IjWBH1qhH/m4ptXHUvnMymFUlby
         Un83JsQqz2BmkZ64bn0FR379m+rL8aPdxraPow8n4r53FAf8elsR6YWZu+sQGCVaWtjI
         /X2F/mXY+TQc9WF2s2H4Tzl9Yz4CjTJGaZ/7chaVZH/1gbD/XAss7VujQP5BEMASDo/A
         M82Q==
X-Forwarded-Encrypted: i=1; AKwUvByTF1r7IDcRk38Flf02ndOqVkPbMflowHoQKNeoQoCwshPK9dkUg+1uy2U2I4kpGd+SejtPBh8cbbE=@vger.kernel.org
X-Gm-Message-State: APuU4Z8eJI88HTcUzRnkEFxUjzUExBW+jJnBbYaTVs/EJ8lwOJ7/AYWN
	qlZxIO/TwD7Sf1kYwgwvLDoyvE2tuYjZPgVBSWpAr/cP6esWSByjNrnyO+7x/9IOIKoBEvmk07X
	2eVgGXt0ayQuFtedC+GGpb04xYVxeYIQ=
X-Gm-Gg: AYBFou15WsBI0xlgSvwrPV0NVMBLbxfP64u3cEVsnA2cpXgzdlCnkSeuplKlOrSTjWp
	67zTEAiczolRYRfrwR6xaKufdJfIQ0Ti8EVkZPu0WUrauzfiHiMQzBC7ezcaTq0FcEv8nBLHcSZ
	myMx/+hURZsjtSltE4Ei/UusNBc4YGodZGSn9o4ZErT3RVAw0P7G6SExwDPyiKFMXu4pupucgOX
	wIe6t5J9zfUdypjw891R76Dmu1D3qWKZtDHnUQwX5lPzn/62qfgLRfC7TMdz+uTD8tWKB6lPULf
	oysCcDFMktUmC9huE9yNJll+A9ZCkP2tlPT2ZtiXGH6OiDlhHqE9zhl0j6ISR2W0RveqoYB4CQG
	8Hl1RsWPMSfeRHomv1YT/1lrYV6+TNac4fJi0kx20bjoBbdCFkEdijdClApSMXmVKw8sUpQ==
X-Received: by 2002:a17:906:4fd5:b0:c46:7fa4:922c with SMTP id
 a640c23a62f3a-c4ca7b20e1fmr868205166b.24.1793632192478; Mon, 02 Nov 2026
 07:09:52 -0800 (PST)
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Post: <mailto:linux-api@vger.kernel.org>
List-Help: <mailto:linux-api+help@vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-api+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261101015551.786044-1-koray.fra@gmail.com> <20261101015551.786044-4-koray.fra@gmail.com>
 <20261102142452.d6jkitgdeuquy23i@pali>
In-Reply-To: <20261102142452.d6jkitgdeuquy23i@pali>
From: Amir Goldstein <amir73il@gmail.com>
Date: Mon, 2 Nov 2026 16:09:41 +0100
X-Gm-Features: AclHuK8kuq8eQ7yCdpsnJrZqU_PhMlxnY90gMXEz8lBNnkHZ5ogvsTJfHTXbOfo
Message-ID: <CAOQ4uxhQ3uhq6s+4deEJAQV5iy8QZoucojR58_dUNYrnjt_yvA@mail.gmail.com>
Subject: Re: [RFC PATCH v3 3/5] ntfs3: make crtime user-settable using ptime
To: =?UTF-8?Q?Pali_Roh=C3=A1r?= <pali@kernel.org>
Cc: koraynilay <koray.fra@gmail.com>, David Sterba <dsterba@suse.com>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, 
	Namjae Jeon <linkinjeon@kernel.org>, Sungjong Seo <sj1557.seo@samsung.com>, 
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>, Chris Mason <mason@kernel.org>, 
	Jan Kara <jack@suse.cz>, Yuezhang Mo <yuezhang.mo@sony.com>, Chuck Lever <cel@kernel.org>, 
	"Darrick J . Wong" <djwong@kernel.org>, Sean Smith <defendthedisabled@gmail.com>, 
	Andrey Albershteyn <aalbersh@kernel.org>, Pedro Falcato <pfalcato@suse.de>, linux-btrfs@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
	exfat@lists.linux.dev, ntfs3@lists.linux.dev, linux-api@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 2, 2026 at 3:24=E2=80=AFPM Pali Roh=C3=A1r <pali@kernel.org> wr=
ote:
>
> On Sunday 01 November 2026 02:55:49 koraynilay wrote:
> > @@ -154,6 +158,11 @@ int ntfs_fileattr_set(const struct mnt_idmap *idma=
p, struct dentry *dentry,
> >       if (flags & FS_APPEND_FL)
> >               new_fl |=3D S_APPEND;
> >
> > +     if (fa->fsx_xflags & FS_XFLAG_PTIME) {
> > +             ni->i_crtime.tv_sec =3D fa->fsx_ptime.tv_sec;
> > +             ni->i_crtime.tv_nsec =3D fa->fsx_ptime.tv_nsec;
> > +     }
> > +
> >       inode_set_flags(inode, new_fl, S_IMMUTABLE | S_APPEND);
> >
> >       /* Save nodump flag to return in ntfs_getattr. */
> > @@ -275,8 +284,9 @@ int ntfs_getattr(const struct mnt_idmap *idmap, con=
st struct path *path,
> >       if (unlikely(is_bad_ni(ni)))
> >               return -EINVAL;
> >
> > -     stat->result_mask |=3D STATX_BTIME;
> > +     stat->result_mask |=3D (STATX_BTIME | STATX_PTIME);
> >       stat->btime =3D ni->i_crtime;
> > +     stat->ptime =3D ni->i_crtime;
>
> For me this patch looks dangerous. Somehow I would expect that the
> "btime" will never change for existing inode.
>
> But because the ptime is mapped to i_crtime and ptime is settable from
> userspace, with this patch it is directly possible to change btime.
>
>
>
> I was thinking more about it... Is not this just misunderstanding of how
> the security model around the times is working on different systems?
> Because on NTFS there is stored just one field which says when the file
> was created. There are not two fields like "time set by user and time
> set by system".
>
> Windows security model allows anybody with WRITE_ATTRIBUTES access to
> change that create time. Linux security model does not allow to change it=
.
>
> NTFS in this view is just a filesystem like any other (ext4, btrfs, ...).
> In my opinion if the ext4 or btrfs filesystem is correctly implemented
> on Windows systems, then Windows security model should handle it in the
> same way like for NTFS or exFAT. So if something grants WRITE_ATTRIBUTES
> access, then Windows should allow to change also btime on ext4 or btrfs.
>
>
>
> On the other hand, I understand the use case to have two creation times.
> One time which would never be changed and could be used for any kind of
> atomic / synchronization by userspace application logic (this btime).
> And another time for human which can be changed at any time to any value
> which user wants (this ptime).
>
> In any case, I would suggest that filesystem driver would not report to
> userspace unsupported values and would not try to invent other values
> and lying about them.

But all those fs with mutable creation time already report it with STATX_BT=
IME
so what can we do about this?

If userspace requests both STATX_BTIME|STATX_PTIME in mask arg,
those fs could technically return only STATX_PTIME and it should not regres=
s
existing programs.

But this is still a bit surprising behavior is it not?

Thanks,
Amir.
