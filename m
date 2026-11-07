Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.42
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794070131;
	b=kq2NOGpGXZKR2oJJjm9yXbHWDenDgYfXHQ2rqQY+vaO463Vb3VsykH+8bd/Ye4e9grg8
	 4kYsrmshMqEh1Aiv/dwREyc1S3gQgz8Qr3qcLVR6rCcvkgDiLdmBIEBOiAN7lJCO9xUqQ
	 14LxjBXBoOYT0dlYXE9FXyLtO1FZUUODjTuFUWKt29MaGpfznlzbLth2oxQFIPOSpUVNK
	 gpirA8vRzPQkRoU9wzzXDSgAbEquPfO6dBZ5xA+G1nxQHmodBJmj9eZ0zZJ80Jbij+YvG
	 ZQcZWrvvBP66x7pYlmu80RnY1JNfKUD7siTg9yp5Mro6giMSuAjBnsTWRFjV1iFp6jw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794070131;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=LZ1hEM+d+iNpX1Pv6g3S4J8ubodEppWnVLdYamIPsBI=;
	b=DXSHsIQadlXMw9+yLr99mI0N0hnlcqnt2pU2c+CsKrtx4f4CbBN90+9a+l42aTTV+eBR
	 jrijw8Os5wQhKkH65nJ/5sCSsT1YoPN5+UhjKPa7SjKZNhfmDkCdVGNYiB5/isSHVQkc0
	 I3mXHTt8JZs8owvddDlK9H6XdryinRhkIXtm59BVeXnC73Osud4llYTFygAYqg/Bttbx1
	 tOaSJPmdMqfXDFpOVurw07hGOzVwO3HbxK6Cw70fHZaBL28Qrct9frfer5XnbX1KLShqU
	 f6TS4FSgPYxAigy2Buz8Jh8Va96vol0Dv/Tckrc9ofdVWw/4SK6nbk+V3bKSAnfgjJQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=FbJQ3Zqr;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.42
Received: from mail-ed1-f42.google.com (mail-ed1-f42.google.com [209.85.208.42])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05F8C606A32C
	for <linux-api@vger.kernel.org>; Sat,  7 Nov 2026 16:48:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 05F8C606A32C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=FbJQ3Zqr
Received: by mail-ed1-f42.google.com with SMTP id 4fb4d7f45d1cf-6b58cb69927so926421a12.0
        for <linux-api@vger.kernel.org>; Sat, 07 Nov 2026 08:48:50 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1794070129; cv=none;
        d=google.com; s=arc-20260327;
        b=JRyrFvPIsipcyljFc6dVAEthJHRFqLKVdoaKT7GUCPyKxZbo+glFZFHHtEB9EFRma1
         Tim14gQDy8YwRLyECD9/jD+/UOOX44/mfaIbcLwfH1fYi1TKUHCqD4yyFRr95sRV0o5z
         fLlWeXfj9jUYWDw29NiioJgDeip4H3aHK0qHfhFAFtex1VmTQhkCuU4U7n3gSEeZpYGW
         WxB78zTE7ROFaGNgjxDh+OCNA6+G40DuUyPhQpakml5bKDCpSzihoWVgVmrP1DgT4ihM
         mFRkOUZlw1FOwIdhS+27qulQaQfxtTjvYr7D4cyCynjzmoCVYNSTkAREmpRk+OXlhV1C
         YNfA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=LZ1hEM+d+iNpX1Pv6g3S4J8ubodEppWnVLdYamIPsBI=;
        fh=qtfI4LFuZQOPyVH8Wi1fG/qQ4jRpwj4KVAX1142fRmM=;
        b=RhHkKK4rJXxQzO9aIonpeAtlsvp2TarEBk0IKwK2XEzBBOmFXQxOFfrAGIAHBOy05F
         RNw1hFNrBQKET/nt7AuKDkOFhl7gnfSWiN7StdpcOKMby8EZhECPUegiVAimE8xg0JsB
         TuOAgSOXjBN8rROdh8Ic/A7lt0xCVD1R0d7ynrNfd6R/7FQQUNN5eIi+i10G3FbiZ5kc
         ehyn8jMHGw5gACviii06CrPiqr6J52x2t1EcszHd/kcFgFnDMd0g5cuhs8/aQX4vKNUw
         60JaV7VcW9IdKl52qAdn0SB719Zj1/Vz154FI0ftBJ7Fj3l132V2553+lv0OhKoPYpaw
         6gEg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794070129; x=1794674929; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=LZ1hEM+d+iNpX1Pv6g3S4J8ubodEppWnVLdYamIPsBI=;
        b=FbJQ3Zqrdpn7NIhiDmg+EUuO6n3ozLBXaaXnvJNjmuY5AlqvMAyJo597rNOoVGHd+P
         Wy0+BFjRiKW+LdqY/E8CeYV42t7cwAmJ5AugbcA9IrMB2CM/bZ4DBvia0Xv7MsG4AgZi
         C30lhUT4bvKQ2SikSiGakC0P7/tq5w5ZAiw7cjWTlhOJPAGHcWeKY11DNjLSqhaj3LCJ
         EfYP2qa9hYSvPmYbNMnzYlsCnW2tfO8v2zrKk1TZnVnWfaWVJoi9yePqPucWkME33sCP
         PU+42FoiSdOSik4gy1NrZDeNWmmJHSVsadZh/wdcs6shRWcOD02h1nfTlAf92y48Nmox
         Q9NA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794070129; x=1794674929;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=LZ1hEM+d+iNpX1Pv6g3S4J8ubodEppWnVLdYamIPsBI=;
        b=Cj4ynrYo54yzLWbjTg3lBvbO1d8rqLxBHcsD9ySzLB2QwXF8G2dMaryYeQgP3ZjdQX
         tLlg3R5JQR/+X9LT13fYGPFO17jI+hRFywDo5CogjJ4XYHKDar5zx/HbVcqSzuEMOchY
         hqNrJ/2s+LPcz69PW3TlaEk+pCRhPIEoi5WPK+fp1IkY34u/hZxul56b/nEDyVR/80bI
         6LfCu8umnhLILYWLtXtS8MKZS0/2XMpqnZAFHCX6q6ftRbC1WZqDagqiZA1OrMOrBgSn
         CbKo4SMrZBXLdNfLmRQrAQOJye8sig5nU2s5e38HbdKcLV6oVV1XMn2tQ5CXbMhb+QGc
         FHtQ==
X-Forwarded-Encrypted: i=1; AL+hErG3gwG34ts6Ikn8ca/Sgi5Nd0VKXTLyJVQjELpJtk1B6TCugsnXFF+V+ESd917/bwKx718MN/+nJTY=@vger.kernel.org
X-Gm-Message-State: APuU4Z9zNJnb8mMJ9K96SjXTOlNbcBzAhwklFWfsms+ywNe7rG6bS96f
	Vx+0cJHpiS7y/8qJd/qSnrGHE8yGPDGCYILoi5P4i1NP+Nr5Vpi5Ccl7I26OyGRBCdWrUBWWcFq
	Jrs2384i+lpyqJpEmX9r+6xLDAdLeRDo=
X-Gm-Gg: AYBFou1iNY4JYgWgW5LuVaLmrtR1AAhjRiuOgeR66GxRyEHmKzDqHGBxnEJ+A3XQfm2
	1qNS/FN4ZF4A9r/MXGWE1ggGb5nDXej7rDUb0M9Q+pxzAo5kVYtix0nK3vQ+/1Nju5T/IJgFgjl
	sBzHdw8Fb/NXul7YfwQOufqhHyHUArUHOXMCprdl9Y86YV2Ja7Ao25YBlfONxr17Hs5E99liOZS
	NSDDDtgrg0vyxLm7hh2hyo+Ju2Rz4YPqsxfhMembll4+I+kfaMW4NcYgqE7BSxleg9aH4oS18hd
	QTDHllKXu+cbjfwyslPLUjcxQJGhkjlg+9V+SYfTH72T7ld9kh1XvQokwL3knlvEsWpWrM/Xeet
	OR1YdcQq/klXD8r5/D8RGIbjzmps/YFkDq95LlUGk5I9qDDQC/LAzskQLFLNNDpHeQCQSlg==
X-Received: by 2002:a05:6402:1ec8:b0:6b4:dcab:bf9f with SMTP id
 4fb4d7f45d1cf-6b6fae71be9mr1620380a12.16.1794070129335; Sat, 07 Nov 2026
 08:48:49 -0800 (PST)
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Post: <mailto:linux-api@vger.kernel.org>
List-Help: <mailto:linux-api+help@vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-api+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261101015551.786044-1-koray.fra@gmail.com> <20261101015551.786044-2-koray.fra@gmail.com>
 <CAOQ4uxiuJ=eZu28FZAUz3rpqPKqCimPxJucOnYYuBowvD09_Cw@mail.gmail.com> <DMP3UBB0QVOT.20HIXK7ZL6K6U@gmail.com>
In-Reply-To: <DMP3UBB0QVOT.20HIXK7ZL6K6U@gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Sat, 7 Nov 2026 17:48:38 +0100
X-Gm-Features: AclHuK89rvp6wjLvX07JFLvpP57bRUqY-Yxm_O2zzvQ-fpYQDX7x1__0QP5KjTE
Message-ID: <CAOQ4uxgSVc8n1LbL_dcU-DpNN5BB-ap_vGdXEu7+d0Td7PK5Tw@mail.gmail.com>
Subject: Re: [RFC PATCH v3 1/5] vfs: add provenance time (ptime)
To: koraynilay <koray.fra@gmail.com>
Cc: David Sterba <dsterba@suse.com>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Christian Brauner <brauner@kernel.org>, Namjae Jeon <linkinjeon@kernel.org>, 
	Sungjong Seo <sj1557.seo@samsung.com>, 
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>, Chris Mason <mason@kernel.org>, 
	Jan Kara <jack@suse.cz>, Yuezhang Mo <yuezhang.mo@sony.com>, Chuck Lever <cel@kernel.org>, 
	"Darrick J . Wong" <djwong@kernel.org>, Sean Smith <defendthedisabled@gmail.com>, 
	Andrey Albershteyn <aalbersh@kernel.org>, Pedro Falcato <pfalcato@suse.de>, =?UTF-8?Q?Pali_Roh=C3=A1r?= <pali@kernel.org>, 
	linux-btrfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, exfat@lists.linux.dev, ntfs3@lists.linux.dev, 
	linux-api@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Nov 7, 2026 at 5:04=E2=80=AFPM koraynilay <koray.fra@gmail.com> wro=
te:
>
> On Mon Nov 2, 2026 at 3:00 PM CET, Amir Goldstein wrote:
> > On Sun, Nov 1, 2026 at 2:57=E2=80=AFAM koraynilay <koray.fra@gmail.com>=
 wrote:
> >>
> >> Add provenance time (ptime), indicating the time when a file or
> >> directory was created. This is user-settable via file_setattr() and
> >> retrievable via statx(2) (using STATX_PTIME) or file_getattr().
> >>
> >> The semantics of when to preserve this new timestamp are the same as
> >> mtime, the idea being that there is a correspondence like this:
> >>
> >> ctime <-> btime
> >> mtime <-> ptime
> >>
> >> so every operation (copying, moving, ...) that currently preserves mti=
me
> >> should also preserve ptime.
> >>
> >> Furthermore, in order to avoid the legacy FS_IOC_FSSETXATTR accepting
> >> FS_XFLAG_PTIME, add an FS_FILE_ATTR_XFLAGS_MASK mask to support new
> >> xflags, and use it in fileattr_to_file_attr()/file_attr_to_fileattr() =
to
> >> allow ptime to be used with the file_setattr()/file_getattr() syscalls=
.
> >>
> >> [ This is a re-implementation of the initial patch[1] by Sean Smith
> >>   <defendthedisabled@gmail.com>, following the advice[2] from Darrick =
J.
> >>   Wong <djwong@kernel.org> of using file_setattr() instead of updating
> >>   utimensat() ]
> >>
> >> [1]: https://lore.kernel.org/20260405195007.1306-2-DefendTheDisabled@g=
mail.com
> >> [2]: https://lore.kernel.org/20260407014129.GC6192@frogsfrogsfrogs
> >>
> >> Assisted-by: Gemini:3.8-flash-high antigravity-cli-1.4.7
> >> Signed-off-by: koraynilay <koray.fra@gmail.com>
> >> ---
> >>  fs/file_attr.c            | 33 +++++++++++++++++++++++++++++++--
> >>  fs/stat.c                 |  2 ++
> >>  include/linux/fileattr.h  |  5 +++++
> >>  include/linux/stat.h      |  1 +
> >>  include/uapi/linux/fs.h   |  8 +++++++-
> >>  include/uapi/linux/stat.h |  7 ++++++-
> >>  6 files changed, 52 insertions(+), 4 deletions(-)
> >>
> >> diff --git a/fs/file_attr.c b/fs/file_attr.c
> >> index 833e03810b24..c0645cb22bf3 100644
> >> --- a/fs/file_attr.c
> >> +++ b/fs/file_attr.c
> >> @@ -102,7 +102,7 @@ EXPORT_SYMBOL(vfs_fileattr_get);
> >>  static void fileattr_to_file_attr(const struct file_kattr *fa,
> >>                                   struct file_attr *fattr)
> >>  {
> >> -       __u32 mask =3D FS_XFLAGS_MASK;
> >> +       __u32 mask =3D FS_FILE_ATTR_XFLAGS_MASK;
> >>
> >>         memset(fattr, 0, sizeof(struct file_attr));
> >>         fattr->fa_xflags =3D fa->fsx_xflags & mask;
> >> @@ -110,6 +110,8 @@ static void fileattr_to_file_attr(const struct fil=
e_kattr *fa,
> >>         fattr->fa_nextents =3D fa->fsx_nextents;
> >>         fattr->fa_projid =3D fa->fsx_projid;
> >>         fattr->fa_cowextsize =3D fa->fsx_cowextsize;
> >> +       fattr->fa_ptime_sec =3D fa->fsx_ptime.tv_sec;
> >> +       fattr->fa_ptime_nsec =3D fa->fsx_ptime.tv_nsec;
> >>  }
> >>
> >>  /**
> >> @@ -141,15 +143,20 @@ EXPORT_SYMBOL(copy_fsxattr_to_user);
> >>  static int file_attr_to_fileattr(const struct file_attr *fattr,
> >>                                  struct file_kattr *fa)
> >>  {
> >> -       __u64 mask =3D FS_XFLAGS_MASK;
> >> +       __u64 mask =3D FS_FILE_ATTR_XFLAGS_MASK;
> >
> > That is not the correct way to extend this API.
> > This fixed mask was added as a placeholder for
> > "We intend to add support for more xflags to selective filesystems":
> > https://lore.kernel.org/linux-fsdevel/20250329143312.1350603-2-amir73il=
@gmail.com/
> >
> > Please see this POC patch for filesystems to publish their supported
> > xflags mask:
> > https://lore.kernel.org/linux-fsdevel/20250329143312.1350603-3-amir73il=
@gmail.com/
>
> Quick quesiton, should _mask also be used for user-space -> VFS to advert=
ise
> what it wants to change?
> This would be useful for on/off flags, but for ptime both fa->xflags and
> fa->xflags_mask would have the same meaning of "I want to change ptime,
> look at fa->ptime".
> Should we make _mask the only way to advertise what the user wants to
> change, ignore xflags | PTIME in user-space -> VFS and use it only in FS
> -> VFS -> user-space to say "this fs supports PTIME for this file"
> (which will be always once support is added to an FS, so it would just
> be "this FS supports PTIME")?
>

Sorry I was not able to parse your question.

I think the mask should mean "this FS supports PTIME"
regardless if the user asked to get/set it or not.

Thanks,
Amir.
