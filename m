Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.46
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795154626;
	b=WrzoU0d/WZGkyt/SrCjNORng/hqaTTmwsnMdTkKgDfbsgD4qZ3erV+t1MH4sZAHRbUkx
	 TVG+ss7vfH/YW4rrF/B7gO65ehJ9iKAkx/eJJZBy2iljj1/SMX3ONUiXFFO0dECAC8A5X
	 AQVSw8IRIGchOwzx0LdC81A6iNAyioTwITS0oq3dEPWYp5dfmZK1QAlyMxxqVev+JLkW1
	 EDOog8xvM5FFIBr0ni+ysTZpeMzKg9Zn9B0VKwF+7r1NmGvVmqUDdHBfA3gU5DiFxLR5M
	 yL7mabPBe5j1uZXiIjt0D0FZdh6wti2xPhGPyjdpbLl6hSMkelYaZT5j930h4IYx9NA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795154626;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=pGOGVjzDtRAIxks4mvGvAXFdrHYvYvSfhVh3EqISUwM=;
	b=LHZhaVbpsYRtZS332psJDQTzr7UHVjWfRosekLdGnfd/I5DNo7RtEjzyCwjYS5uM5npo
	 SL2PcDsUwwX+BEaJw3EbNJQVNhjNybmhoKNEG6LuzPxX3d18Ub9TMTxqGC5IGO0BNt3PT
	 JnSWzChnRFyt89Fnfj9wJC9Q5imgx0lLAG+MAU0Ssm8xij41BCSYqxm7jGTc8jzb1rq4B
	 J/9ZA2o8mKFdC6FukAZJIrxNYiv2BVjyWN23SJ7hXO/+jk+BLvXFlnl9WQXO+0n+Q58SG
	 WqGFwDrdq1hgS+W5M8UjX96reqXvIe6etc9jCpa1LTlY9HBHn4lu/+NoYSAkJhmif0Q==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=twd3LSyP;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.46
Received: from mail-ed1-f46.google.com (mail-ed1-f46.google.com [209.85.208.46])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91E9F60A260D
	for <linux-api@vger.kernel.org>; Fri, 20 Nov 2026 06:03:45 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 91E9F60A260D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=twd3LSyP
Received: by mail-ed1-f46.google.com with SMTP id 4fb4d7f45d1cf-6b87a92c17eso773881a12.3
        for <linux-api@vger.kernel.org>; Thu, 19 Nov 2026 22:03:45 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795154624; cv=none;
        d=google.com; s=arc-20260327;
        b=mmqQ4EBy8SVI3y7JQZBJ8/qD61y9Fb9Izc6ZZVwawk52smcZojiRLwlneuVtUopEPC
         9UDNq6UoRWjm5KQYGTfHhlURGJ0InGFUeuRUPVmJ/xdifUTh0MFhy7NwtoNm5u6YUiHJ
         etrZI9wL+eqfca+RimzpxFU44IGh7iuH6IZQov2sW47kniGrcxG5h1je3JQdYC1C00SZ
         FxVYyeIumvDyBYLhYAL0/eT+SbIB7RdnXCH3CESGa9+wRnTKdugTyNNfcNo4VzxVygci
         MQY07bDvKHm3sSdOlTixAnsp62LwCLn8AZmVk9TVZJCU2HQNYTODUNdd2Vgpa2epTXH5
         F5Xw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=pGOGVjzDtRAIxks4mvGvAXFdrHYvYvSfhVh3EqISUwM=;
        fh=gR1OzVJxb9rBrtosQ+hyIKWgB9Wcucwjr3TP9JbjVCs=;
        b=EYnaLj/mO9gQYSbdeIAl/YkOAKQM67AmtT6Dndr8+O0qUBWdyxrKBaY0XXjLACGYGx
         mzE0wdbMslDB3OxL0Ew6uwYBT8fB7nYURUA7IJjRaEw4lYvawtR51A7h33h+WGBov0CR
         UccikGkq6jAnHbQVDqvTRC20oXbRjB0I1K8CYYkdq/OWQ6z3wc/WfrLlp1TG2Jz+OVSM
         U+5rsD0KbuLtXLniWx99XF5VrRnbT0ZZPyJaReYe2l3Qx29WLoJNea090WAhfHDI+osk
         u2d/PJUvlpGsQ+6R38f3QamcMfaGVqNl6JOb1CKUobi3MwYDlktwphrwGYZ0GrJYhgqu
         a76A==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795154624; x=1795759424; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=pGOGVjzDtRAIxks4mvGvAXFdrHYvYvSfhVh3EqISUwM=;
        b=twd3LSyPhh/xqGTUhGQCUkwTgPz0ozSKLDTUdzWfuC88iwf9vuQaz4Cbapmx3zwlEj
         zlPpp5xjkBRG0SDqC55ar8nBqU+85ZN/BbmT34kWJ4vxhbdyZbdyEQy2606KHlPpAcFA
         JFJXbHJDQWbyltdYp5JJ76dGIZsXzMVaFFB2lWR6MIffBbfdMhvs931PsHwOVCxf6WxW
         wy21QWjJiN1/vrK+nMRXh+VMOYDU0hoTkIxn3m45nhUC91hezeDKP97nETUPcHv6eNo8
         2LkA2JYHzh73ui1UQni7id0o3aSMFPuYuUQVmp+IzjGqkrZikwiCYxOEdafgsA18VMyB
         JQzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795154624; x=1795759424;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=pGOGVjzDtRAIxks4mvGvAXFdrHYvYvSfhVh3EqISUwM=;
        b=wEkIRneHNuOrt/29+qurfDR3+ee3HISJfh7eH7L8cRyNd8YxOrUT0Caru7AxZBVuuC
         MIiolVcPFdImKoxX7Gi7LTuCC4wB07+o55ocQoFD4mITHq5TRu+FrSWmIxeQy8CBKkCX
         18E9q4h0FT8nqGR/VwCOXd2FReuT4+g8DgExiapahZFGSZL/7oaOdEb9wJXy25cekJaV
         GGr3itmMjPDpn5Jo86e3ZJ4YpMmK+/M62baaDy1dleVVeSiH+IHN3/N32M7kiw5LHONQ
         Jz9HSRf2VJwQIXoGbcV8E0UuikwwP3lquEIRZJUQf6KSOvA6gQ/Y4nM3lGUYkArTYBT5
         IDHQ==
X-Forwarded-Encrypted: i=1; AL+hErGIybU1U2LTfM8mtbX2f3FQbkcmLMdUUwBNCCkot8V/wTiouFc3wiF4AfxyXaSSDDNeQB0dKevUmeI=@vger.kernel.org
X-Gm-Message-State: APuU4Z/5ehOeQ7n1sYhrAWPV6Dy/avAKAPV2RCS1Do+mAav/bmU2jkVf
	PImdC9yn8EtwnANZz5/y9hH/BB+Ptb2IGvUPe6u+KCmo43X9jB/B3NYzGHr/6OvITQxLl4vpp8+
	2jFCFXLBPJKLAcWneeXwb+OEhZA6oG6w=
X-Gm-Gg: AZFdTZfaEpyay82Dzk+i4l3Zt+S3nmFl93NIW5jK8G1tlpUeFpxzjji/6cjk0NSIwST
	bHcx1ODnEVDA3MQs0DsNEja3DoTz79QRzfz8/+Agfmk5t/BRL86jswP/aZDruegBcuYTY0s49yE
	E/EbdTymS0Om0lGshl0MbaJ95Z2rTlWGUx1gX2GNEnelNHb0PtbTwxGdQRMDWPu+2YMccwq4vTm
	W9pklEzXLJUIerMJr181Yd8Kh+R3dWVD9TgTJ+G790JmaUTZKCUM8JYG89EU+74nS/d/g/Vd51w
	lUUhH0oRA0+dF+/xMNuRyUq/ehbt+fwzwmcnRt4rI9EfuxFaVoSlNQtXOpkwruffZqw3hNBAuhB
	hXoI0MD/qLVpFP0oZot+CT+BLvO3AaFQKEfq9KQohCzIAlzSZPEp3uBfOnzDuzuNhx7HtjLhmlB
	fEEXg5n5fsvwbFQNo=
X-Received: by 2002:a05:6402:e06:b0:6b5:4f5c:cb2 with SMTP id
 4fb4d7f45d1cf-6ba37ec320fmr1108851a12.34.1795154623771; Thu, 19 Nov 2026
 22:03:43 -0800 (PST)
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Post: <mailto:linux-api@vger.kernel.org>
List-Help: <mailto:linux-api+help@vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-api+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261115180343.576773-1-koray.fra@gmail.com> <20261115180343.576773-10-koray.fra@gmail.com>
 <CAOQ4uxhjxp5sxYphWoB=8sgX3XHOv9zLVYf+8ZjYbS_gQDxO3w@mail.gmail.com>
 <DMZIQG4U1NTH.2IN0S2YIWEYTG@gmail.com> <20261119220936.mssmaixcorn2gzli@pali> <DMZJGB07CO56.IZ20OCGGH6C@gmail.com>
In-Reply-To: <DMZJGB07CO56.IZ20OCGGH6C@gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Fri, 20 Nov 2026 07:03:31 +0100
X-Gm-Features: Aa3M54rvTAbJYlhFUqobPAqFrpuIqbxGTrlnaPynQQoE0nz09X_6dT10Gv8Q47Y
Message-ID: <CAOQ4uxhqgsh9ahJsX7C4YyZH2n_r8VwOe9X9jZwsKALCoYvyag@mail.gmail.com>
Subject: Re: [RFC PATCH v4 09/10] ksmbd: add provenance time (ptime) and map
 it to CreationTime
To: koraynilay <koray.fra@gmail.com>
Cc: =?UTF-8?Q?Pali_Roh=C3=A1r?= <pali@kernel.org>, 
	David Sterba <dsterba@suse.com>, Namjae Jeon <linkinjeon@kernel.org>, 
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
	Pedro Falcato <pfalcato@suse.de>, linux-btrfs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	exfat@lists.linux.dev, ntfs3@lists.linux.dev, linux-cifs@vger.kernel.org, 
	linux-nfs@vger.kernel.org, linux-api@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Nov 19, 2026 at 11:25=E2=80=AFPM koraynilay <koray.fra@gmail.com> w=
rote:
>
> On Thu Nov 19, 2026 at 11:09 PM CET, Pali Roh=C3=A1r wrote:
> > On Thursday 19 November 2026 22:51:26 koraynilay wrote:
> >> On Thu Nov 19, 2026 at 6:34 PM CET, Amir Goldstein wrote:
> >> > On Sun, Nov 15, 2026 at 7:04=E2=80=AFPM koraynilay <koray.fra@gmail.=
com> wrote:
> >> >>
> >> >> Implement provenance time (ptime) in ksmbd, as introduced in a
> >> >> previous commit ("vfs: add provenance time (ptime)").
> >> >>
> >> >> Map it to SMB's CreationTime, making it settable by SMB clients. Wh=
en
> >> >> reporting CreationTime to clients, prioritize ptime over da.create_=
time
> >> >> memorized in the user.DOSATTRIB xattr.
> >> >
> >> > That doesn't sound like the right thing to do.
> >> >
> >> > If the server stored a CreationTime that client had set, you cannot
> >> > override this.
> >>
> >> Ah, yes, but how would we handle older files which get a custom
> >> CreationTime both before (in the xattr) and after (in ptime) a kernel
> >> upgrade?
> >
> > Just to note that this problem is already there. ksmbd can export for
> > example ntfs filesystem on removable disk. And this removable disk can
> > be connected to Windows machine which will always only touch
> > CreationTime and ignores xattr DOSATTRIB.
> >
> >> > When the client sets CreationTime, the server can decide if it can a=
nd wants
> >> > (may be a policy decision) to store CreationTime in PTIME and not st=
ore
> >> > it in user.DOSATTRIB.
> >>
> >> To fix the above problem we should probably keep storing it in both
> >> ptime and the xattr though.
> >
> > IMHO for a long term solution it is better to not have duplicated
> > information in xattr. Because duplicated information are going to be
> > out-of-sync. Windows NTFS driver will not update xattr DOSATTRIB.
>
> Yeah, to avoid out-of-sync issues is why I made ksmbd prefer ptime over
> the xattr's CreationTime.
>
> >
> > For me it looks like that this needs some policy / configuration
> > decision done by user. We do not know if the user will replug that disk
> > also to Windows NTFS driver (and then those xattr DOSATTRIB could cause
> > out-of-sync issues) or will only use it from Linux or Samba and then
> > xattr DOSATTRIB is probably fine.
>
> I'm not sure if this is the best solution, it doesn't feel too right
> to me, but maybe there isn't a better one.
>

If you ask me, this is not your problem and I agree with Pali that
this is a policy decision.

I would not include this patch at all in the series if I were you.
Maybe as a demo user, but you could just as well include a demo
user application.

The nfsd user is a simpler demo, so as long as the nfsd maintainers
are on the same page wrt the mutable btime plan, you could include
it in your series.

The problem you raise with DOSATTRIB xattr is similar to the problems
that Chuck raised for ptime vs. btime as the source of FATTR4_TIME_CREATE

Thanks,
Amir.
