Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.50
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795618902;
	b=Gjq3oQrMnY/hmprbTiWl7Ybozm5KIgbAhFZ64l4kS2GvxWZqhsA+DV8zsINGl9slgFqG
	 QVHfyaTnmdC5SJWuJNXMWUEPsomU6MfEjluIjh3KqVX2JxbepSnUr9L9rRoYrSY5tTMR9
	 U2xDvGr/0lhevxEi/nddWi8CNXlVPBzmmkwESTZDTZvYZD3gc6gEbL3AQ90UDRTy/yD05
	 LoSHAqzvkLj9rD/r5fPgQqYM6JrCI2DsCUR1j+DtjcNIdRaJbS3eaoZ6JHD/+b++oReWu
	 WtMRHbaKfRYFMqErOnDocuVTngR94F98PrRdTxxdmv3COQFTb66ldF3PfaPPxOlscsg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795618902;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Mime-Version:Content-Type:Date:Message-Id:Cc:Subject:From:To:X-Mailer:
	 References:In-Reply-To;
	bh=B5/TBBQPuILJ99V5x8tyq+8dEb1sqbcLQBtADawkVtQ=;
	b=a8BimsGVJtBZEyUM3943GtDo7VYXP42wjNV5uSTxezQ/EvQHRPW60u9598gEhby+axDA
	 q2mGwX7MAGjc9Yohh3C/j6hfwKxaS0IoB2gf1DNF+8GAGXYpiqp+ejYfxmOc7rKIrLFZd
	 IVFQu7CLSKIiAXxHZNb7CkpZTxSDo0qe6l2j/WwDaIUCgF30RQyKyf+BzYD1YmNPNhYIL
	 Nd2qdbRvLRChVqewDNRtxLLb3XA7p97N82TtVR2qcyWIuvpHjEM/oN2jiKUOuyfVGntqo
	 h+GtlBKTiFtpuTcNx4Gqmh4jV9986RXrGQcM6zvdfQtV/Vr73amen7Y0tm5uJglChKw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=kvorXzgE;
	arc=none smtp.remote-ip=209.85.128.50
Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC55E606A327
	for <linux-api@vger.kernel.org>; Wed, 25 Nov 2026 15:01:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org DC55E606A327
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=kvorXzgE
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-4a3517554f7so53851295e9.2
        for <linux-api@vger.kernel.org>; Wed, 25 Nov 2026 07:01:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795618900; x=1796223700; darn=vger.kernel.org;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-type:mime-version:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=B5/TBBQPuILJ99V5x8tyq+8dEb1sqbcLQBtADawkVtQ=;
        b=kvorXzgEaytoSYih50VsTBoBAgWWh/E3y6fLS/hmw6vSaHzqG3JI3/DWHBM4Xbmc2Y
         z8Nka6aDYtqKSi4ilekxKwOrN9DeRbD9LbpAlNHAuUvJbdLFJE3kyli4v39y3yHZzTYE
         bB4i9qWd9jBjrjEasloW5pv+M4YUoByjMiCes84nRxBBFJ/3W4dVfL2gSUWV5xKQwRL2
         c3ynA4Wzl/aSCI00LmBvKsFN264rd3WTAcwmuBpL7ExQ+ptHgOFHASTTkNGc3waKr+AN
         gDEUhEvWBXRAfdrg0Ec2qv0O0DCLsJ0Lis779bX3ejhfKD92/TrMvpKx2A4Rl+SFumsy
         q/2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795618900; x=1796223700;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-type:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=B5/TBBQPuILJ99V5x8tyq+8dEb1sqbcLQBtADawkVtQ=;
        b=Zijd7XGIvLmaI17iXXhsTCY+4qcq+hf9fds9yU+DSfQEt+x2+lpvmLXo61vCToo8s2
         CZXVYKEPWq5k8Kwe2iDsDUqOvWJzot3j7sJFjWl1B8AkkzTaTvxtVIdD11Ko0CBO1etl
         8gJzKcUMuYfiMNj437YNBtxT5Vy5TEbs75jmC8HlbSq2Dm1BMaoH099nPgc+WS2aJpFH
         7e5lqjIR53fC1V1C68K0nc+gMqLjUya5jKniLM0mG5homYXMeVz9UfN0JQ3lqEY1rsFu
         nZOdVp9/2ba7jrHgUtrQ8joTEJabbgUBNmVulEN4TSyLN4VI+EoKvG9G+DaE054gprpg
         aWAw==
X-Forwarded-Encrypted: i=1; AL+hErGmwaleulXEgrGwI4LeRQhsrZ9MtICuWHYF6soRL+QhusMP5pc5RKtIkac/bSqTnw/KLdaRFl0M9EM=@vger.kernel.org
X-Gm-Message-State: APuU4Z8yNjbO0yh6qG/jMieN9LOcZ2GpWBf/g7KcgAMlDupL9u7Fy10d
	XdV9OpB6f8vyPBKuvhon+Cuj2eVHnNJC3CIbWPBKIZdA6LH80c/0NTJY
X-Gm-Gg: AZFdTZefxSL4OfaVOQ/RP0Mot+RRVPzfrM+EwE9F/I1Xaziryv4cGxOvotHZ0Ejfof/
	ZZmg8xGpfmWMy9dz4++FkS6I5eTmXc/O82X0PfjhBcsI6BRxr3MNUKDA7AuFSS3tS7G5CGTRfFI
	Ix6Nip+E/GSk9DdJ7suhYcf+5BcsIrYcHbtDx4AVpn408rtciqxMZxL4r8JW1z//ugIezrQVkIc
	rZwA2Y+2XlUDMEEGLFrYA9k/rD018POC4ZVg3WI49pSkauk6YqEVaZMORwGohs0Ax8OV5uQ8THy
	pI/qzp2qF+8xmTOtwM7UHOUM44GEaRTKc/GhJuJLPBXLkBEQs0oyV0WIO+GI5ORvXPgP6DoSxZm
	VWEuJBxJMaaVLQ7oKOIDXrqYHA9xkQDIiYO5l5PQHlETBFC7ZYnQRQFVB60LZUegZwbfRsXbVkc
	9ScIjy6qTiuwVWDYpuHpafMYc41/qEbnWID61/ij04o5chhk7HNr0sU7U8vlNw44jm1KiqHsSYO
	gHh63Mhg7rPSwwVHAwrk2BZqFSNIt+p4y2/wGxWVeAn75Po7+GSLCreAhdhwC7FfQ2EqL07ViJs
	w9IO97IvwTfKFxuRlpa7ABHazQD4aWY3CX0x++fffZx6885c7ldlk3I0jfPqrPi8n1LsCGTTpY9
	kxWAY3dGIFnj1
X-Received: by 2002:a05:600c:3b94:b0:4bb:6f41:39be with SMTP id 5b1f17b1804b1-4bb8880ca3cmr461004845e9.15.1795618899873;
        Wed, 25 Nov 2026 07:01:39 -0800 (PST)
Received: from localhost (mob-176-246-240-189.net.vodafone.it. [176.246.240.189])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb8960068fsm199919685e9.4.2026.11.25.07.01.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 25 Nov 2026 07:01:37 -0800 (PST)
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Post: <mailto:linux-api@vger.kernel.org>
List-Help: <mailto:linux-api+help@vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-api+owner@vger.kernel.org>
Precedence: list
Mime-Version: 1.0
Content-Type: multipart/signed;
 boundary=63a562d6577b3515b9b86b9d4d44e07b4a48b768beedbf2d083915e409e8;
 micalg=pgp-sha512; protocol="application/pgp-signature"
Date: Wed, 25 Nov 2026 16:01:31 +0100
Message-Id: <DN4DRUYPHYMP.20U4DYV5VBN7P@gmail.com>
Cc: "Namjae Jeon" <linkinjeon@kernel.org>, "Hyunchul Lee"
 <hyc.lee@gmail.com>, "Alexander Viro" <viro@zeniv.linux.org.uk>, "Christian
 Brauner" <brauner@kernel.org>, "Chuck Lever" <cel@kernel.org>, "Jeff
 Layton" <jlayton@kernel.org>, "Jan Kara" <jack@suse.cz>, "Darrick J . Wong"
 <djwong@kernel.org>, "Andrey Albershteyn" <aalbersh@kernel.org>,
 =?utf-8?q?Pali_Roh=C3=A1r?= <pali@kernel.org>, "Lauri Gates"
 <lauri.gates@gmail.com>, "Christoph Hellwig" <hch@infradead.org>, "Dave
 Chinner" <dgc@kernel.org>, <linux-btrfs@vger.kernel.org>,
 <linux-xfs@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
 <linux-fsdevel@vger.kernel.org>, <ntfs@lists.linux.dev>,
 <linux-nfs@vger.kernel.org>, <linux-api@vger.kernel.org>
Subject: Re: [PATCH 2/3] vfs: add xflags mask to fileattr API
From: "koraynilay" <koray.fra@gmail.com>
To: "Amir Goldstein" <amir73il@gmail.com>, "koraynilay"
 <koray.fra@gmail.com>
X-Mailer: aerc 0.22.0-0-gc2f86b7abde3
References: <20261122000856.536902-1-koray.fra@gmail.com>
 <20261122000856.536902-3-koray.fra@gmail.com>
 <CAOQ4uxhegn1z=41_MHL1Zu2hXuPtzNhC=x4gd371oaeJE4-weQ@mail.gmail.com>
 <DN2N6A68PBO1.2QT8ZOARF4I6L@gmail.com>
 <CAOQ4uxhDQqEQ3T9NveBFpUmSU032BxrNV5D+_zHj8u9LOQY+qg@mail.gmail.com>
In-Reply-To: <CAOQ4uxhDQqEQ3T9NveBFpUmSU032BxrNV5D+_zHj8u9LOQY+qg@mail.gmail.com>

--63a562d6577b3515b9b86b9d4d44e07b4a48b768beedbf2d083915e409e8
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8

On Mon Nov 23, 2026 at 4:29 PM CET, Amir Goldstein wrote:
> On Mon, Nov 23, 2026 at 2:58=E2=80=AFPM koraynilay <koray.fra@gmail.com> =
wrote:
>>
>> On Mon Nov 23, 2026 at 2:24 PM CET, Amir Goldstein wrote:
>> > On Sun, Nov 22, 2026 at 1:09=E2=80=AFAM koraynilay <koray.fra@gmail.co=
m> wrote:
>> >>
>> >> Add fa_xflags_rw_mask and fa_xflags_ro_mask to struct file_attr and
>> >> equivalent masks to struct file_kattr.
>> >>
>> >> Also add has_masks selector to struct file_kattr so we can know when =
a
>> >> user of this API (userspace or filesystem) supports them.
>> >>
>> >> This lets filesystems advertise their support for specific xflags, li=
ke
>> >> statx.stx_attributes_mask does, and userspace can specify only which
>> >> xflags it wants to change without needing a RMW cycle:
>> >> - on GET: each filesystem that wants to support this new API fills th=
e
>> >>   masks according to its supported and read-only xflags, then:
>> >>   * for boolean xflags: it fills fsx_xflags with the current on-disk =
value
>> >>   * for value xflags: it sets the xflag bit to 1 in fsx_xflags and th=
e
>> >>     xflag value in the struct field;
>> >> - on SET: userspace fills the rw_mask with the bits of the xflags it
>> >>   wants to change, then:
>> >>   * for boolean xflags: it provides the xflag value as a bit in fa_xf=
lags
>> >>   * for value xflags: it sets the xflag bit to 1 in fa_xflags and the=
n
>> >>     provides the value in the struct field; if the xflag bit is set t=
o 0
>> >>     instead, this informs the kernel to unset/clear that value.
>> >>
>> >> Since fa_xflags_rw_mask means "I want to change the xflags specified =
in
>> >> here", if userspace specifies fa_xflags_rw_mask =3D 0, only check for
>> >> permissions and fileattr support without checking any xflags.
>> >>
>> >> Behaviour of older programs that already use file_[gs]etattr() is
>> >> preserved by checking against FILE_ATTR_SIZE_VER*.
>> >>
>> >> Also add the missing FS_XFLAG_PROJID xflag, to allow userspace to set
>> >> the projid using file_[gs]etattr() by leveraging the new masks.
>> >>
>> >> Finally, in order to prevent the legacy FS_IOC_FSSETXATTR from accept=
ing
>> >> FS_XFLAG_PROJID, add a FS_FILE_ATTR_XFLAGS_MASK to support new xflags
>> >> and use it to validate/clamp both the _xflags fields and the masks.
>> >>
>> >> Assisted-by: Gemini:3.8-flash-high antigravity-cli-1.5.11
>> >> Signed-off-by: koraynilay <koray.fra@gmail.com>
>> >> ---
> ...
>> >>         err =3D fileattr_set_prepare(inode, &old_ma, fa);
>> >> @@ -424,6 +504,14 @@ SYSCALL_DEFINE5(file_getattr, int, dfd, const ch=
ar __user *, filename,
>> >>                 return error;
>> >>
>> >>         fileattr_to_file_attr(&fa, &fattr);
>> >> +       /*
>> >> +        * Remove xflags added in or after VER1 so userspace programs=
 compiled
>> >> +        * against VER0 don't try to write xflags they don't know abo=
ut (since
>> >> +        * they do RMW).
>> >> +        */
>> >> +       if (usize < FILE_ATTR_SIZE_VER1)
>> >> +               fattr.fa_xflags &=3D FS_XFLAGS_MASK;
>> >> +
>> >
>> > This looks odd.
>> > old struct size with new flags should be -EINVAL not silently drop the=
m
>>
>> Right, and the GET path should strip any new flags, so old programs
>> doing RMW will never see them, correct?
>>
>
> Yes, I think so.
>
>> >
>> >>         error =3D copy_struct_to_user(ufattr, usize, &fattr,
>> >>                                     sizeof(struct file_attr), NULL);
>> >>
>> >> @@ -460,10 +548,6 @@ SYSCALL_DEFINE5(file_setattr, int, dfd, const ch=
ar __user *, filename,
>> >>         if (error)
>> >>                 return error;
>> >>
>> >> -       error =3D file_attr_to_fileattr(&fattr, &fa);
>> >> -       if (error)
>> >> -               return error;
>> >> -
>> >>         CLASS(filename_maybe_null, name)(filename, at_flags);
>> >>         if (!name && dfd >=3D 0) {
>> >>                 CLASS(fd, f)(dfd);
>> >> @@ -479,6 +563,30 @@ SYSCALL_DEFINE5(file_setattr, int, dfd, const ch=
ar __user *, filename,
>> >>                         return error;
>> >>         }
>> >>
>> >> +       /*
>> >> +        * Userspace said "I don't want to change any flag", so be it=
 I guess.
>> >> +        * Still check for fileattr support and permissions, also in =
case this
>> >> +        * is just a probe.
>> >> +        */
>> >> +       if (usize >=3D FILE_ATTR_SIZE_VER1 && fattr.fa_xflags_rw_mask=
 =3D=3D 0) {
>> >> +               struct inode *inode =3D d_inode(filepath.dentry);
>> >
>> >
>> > No No this is not what this userspace said!
>> >
>> > This user space is the same old chattr programs recompiled with a new
>> > fs.h header file
>> > installed.
>>
>> Oh, right, I did not think about this case, I hope it doesn't break too
>> much of the new code I changed already for v2 :(
>>
>> > When userspace does not set anything is masks it means "old API"
>>
>> And so a modern program using masks that passes rw_mask as 0 should be
>> also interpreted as "old API", even if it kinda goes against the
>> definition of rw_mask right?
>
> Yes, but it is not a problem to describe this backward compat exception:
> When (rw_mask | ro_mask) =3D=3D 0, it means "no mask" "set everything"
> but then vfs will not accept new xflags that were not supported in v0
> syscall.

Uhm, since we have no way to know on the GET path if the caller is mask
aware or not, on mask aware filesystems and legacy programs recompiled
against VER1, file_getattr() will return rw_mask !=3D 0, when the program
does RMW, so calling file_setattr() with the old struct which has
rw_mask !=3D 0, vfs will think that the caller is mask aware.

This causes problems when that legacy program changes the projid, since
vfs will see rw_mask =3D PROJID but fsx_xflags will not have PROJID, vfs
will clear it even tho the program wanted to set it to some value.

Unless I'm missing something, there is no way for us to know if a caller
of file_getattr() is a new mask aware program or just a recompiled legacy
program.

My robot proposed 2 fixes: either don't introduce FS_XFLAG_PROJID
(which, eh, not the best imo) or add a new flag to be used in at_flags,
like AT_FILEATTR_MASKS, which would resolve all our legacy vs non-legacy
problems, but it would be in *at*_flags, so doesn't really make sense
semantically (but it would work well since file_getattr already rejects
unknown at_flags, so it wouldn't cause problems for old programs).

Thanks,
koraynilay

>> And other than VER there is no way to know if it's a SETFLAGS compiled
>> against modern fs.h or fileattr VER1 explicitly setting rw_mask to 0,
>> right?
>>
>
> SETFLAGS with explicit 0 rw_mask is not useful and does not make
> sense, so there is no reason to support this in any other meaning than
> legacy programs.
>
> Thanks,
> Amir.



--63a562d6577b3515b9b86b9d4d44e07b4a48b768beedbf2d083915e409e8
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQRJ2XvJtXGwULYEerQ0bnTtJTDoOAUCawb4SwAKCRA0bnTtJTDo
OK0uAP9ueb1Rn7jI3JdReZ1mTTKoolNf16q49mc0W8NxgzwV0gEAor4cmldmQIAj
JpbZxXhVkMCA3/AL1lxksQ6xU5wQowQ=
=UQBy
-----END PGP SIGNATURE-----

--63a562d6577b3515b9b86b9d4d44e07b4a48b768beedbf2d083915e409e8--
