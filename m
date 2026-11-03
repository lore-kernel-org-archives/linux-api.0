Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.41
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793727661;
	b=BHmRCh2XMaKQBT8YgcXi8RIPtxi9Ss5InZ5ZzKE3EqXF3eR8O0q338rLn/vYHBzX2MBS
	 SciLK7F9rwGzU0DL4csPtGIUn6ztVfNt1tNAiBGAwj/Ndsm3EMIX64ZLioalTI3wvBjQ0
	 M0MDdGCT+uW+1fm7h1T/gIpKrClNb9lyNWrF74r0UhAUV0RNFPxBoWCN28Btkhvh6HziP
	 qlfjmuLARH1iA8NvS91hXCJjmH3EwlSD2Z7PIh4Ra4X1LJ4niG0jJFnopJCLShI3pHxCt
	 eIwt5tlhl6EeCoXFYE6XK++AiQW/ZVZ5RTgupM2iMbw66MMZDUACQxf3s/pMK8Im3fw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793727661;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Mime-Version:Content-Type:Date:Message-Id:Cc:Subject:From:To:X-Mailer:
	 References:In-Reply-To;
	bh=HalRvx8YdrlduYgz3MgmPlo+8RqyE0QcDNI34iRIm4o=;
	b=qMSLHidEcLYtJ7p7r4IKrLN/HdK/A/AT/tiDINham0shNZCF6CLZmKN9W/Q5L4tmewGV
	 qUEWYlvY23F4eBOgwfQEAARthtlxff2SgEW4HkAIpFSQLiyVtZWXjFI3Gi1+6n0ttBVIY
	 RmaqQfya+Ukm87CYJBbvrKXI4vrX8gXasuTI8vAx9wNFr9QcArTbfN799gOcSc1xC/or5
	 zghp9YTuGROhq9ZRaMxX22+7Hb0twrGx007aaQF3kIj4GPhZmtFdcSraCnBeZ+bdp3RrT
	 KWCApuFVazCvN+LPmfYQ84P+u+PJe+IcvVo44B8wcCPXCs9libV6N5sCeqcEn4mQwkw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=woy6HRwX;
	arc=none smtp.remote-ip=209.85.221.41
Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com [209.85.221.41])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BBCE606A328
	for <linux-api@vger.kernel.org>; Tue,  3 Nov 2026 17:41:00 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9BBCE606A328
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=woy6HRwX
Received: by mail-wr1-f41.google.com with SMTP id ffacd0b85a97d-48e46e449e8so2736112f8f.3
        for <linux-api@vger.kernel.org>; Tue, 03 Nov 2026 09:41:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793727659; x=1794332459; darn=vger.kernel.org;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-type:mime-version:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=HalRvx8YdrlduYgz3MgmPlo+8RqyE0QcDNI34iRIm4o=;
        b=woy6HRwXOILk2YRmozyjEQzBKUGc5Nf/4COoj8UwkKe57OQMjizixt8h2Onklui4dG
         1Vufu55PSfdgtAhx2T8CMoQdY2JbX2Yr+A889SNXnKPMg0IOSnbY43V89ZAp2SQ1y+Yu
         0Lo3Kk+5PdkN5aZJN1TTu4I4z8smhZ13Lx9UpmfwkRPgfRa8koFkNHg+PdMw/vi+Tl3n
         D9FewKOa4jG+Kql6zm4Seklqcl2NN/YZJh3Uuhm6z7ZwkWAyx/Ol+wuLb119e6+TzonZ
         eEy7mlgzD3yUcTDh48FObCbYQtkn2Cu5USSf+CpvJ+iUuZYjd8M9s4jy3c+fhMi+JSd/
         qyIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793727659; x=1794332459;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-type:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=HalRvx8YdrlduYgz3MgmPlo+8RqyE0QcDNI34iRIm4o=;
        b=vCcIUZHXYXCOBw0PvLZtrl9vCis/jgESxZNXgjYwhDGlBXGado+aQ6mRlwwOf5bg6k
         uE6mPOXQf7SYJTKpdt4j6x+G+AUqIxHzWlWwXhyZudHLx871oJ1OCCyiQ416kMUK+poa
         x54HipqrRO6Svr9RrzDJh+4PEbxKN2UWiVMciEQeb8pfGKNnUooFn7YLqE7ZEucCnaM/
         rpln6+TTY1zE6PXCS7Dq0GfbKunaHJtJupO4+Py4hK1+rzN2R5mfaZVfYKVopEDMIMgc
         H3LP707OqeV1GwKVUCVdTMfFAhouykIgoZr7PFkerQr8Cxabqohf0s/YImQ0IVxq36Gn
         1LAg==
X-Forwarded-Encrypted: i=1; AKwUvBwRteRGQpaLdVevmBnopV6OTDOyrQ+Fr7EKLCm2KyI9/q6K8xxj9YRClpKXQmObO+CifFTV6JtN0+o=@vger.kernel.org
X-Gm-Message-State: APuU4Z+mFkLuwylFkHvOoht78teO0ofqSm8xpiqX+Rlkh6OhBGHnKxxF
	KwHsGlcWwOycyyFYqMlycfKvzbUzfjTSGYn74MSLoKdLLAZp0XPIXOsk
X-Gm-Gg: AYBFou2chWwc4VYbM+7snN9ecWcppnHCA4kDJhNH/aGiEJn7XP2U1x8ev8hp3DIjZCW
	kz3X+2YnWU29pJkwnElM3+mQjN+fu7wZT4dGCDdlPX+HG0qnF0jJfVc5TOCZZkmCBze2tE4uh06
	JbEXHF4WOkHRGG/mi8uiNgNcAGG7sLL7Fwr28Hj8Svk7BswYXqyGeAOUfanQGAJsXydSJ102bjZ
	qrM0aL7FoiW0FTynHW2V99A1UoX3MvsMGQtPIHC1PfU1MVJFp0Q/mNyJwj9n0Rk3RAlhPzz3Vp8
	lmu4gpUWW0U/0NNZhvdR1238Gg45kWIjF6xbVjeyy8y2lA9Wz41NgE3lNT57drY+kELqea2R9AR
	MUpLsV5QzPqc9PanaVbZGZxdV0mplR1vPMOFyFQH2imc2JsxA9c1MZcoz+SsLLc9Vmkfx/zUUCs
	0jpLX3kDt4l1HkuoYsnf0qELwVMqHmGrfk/h2jEvU67lVRkFsoTabjlHawq7uBBdhdtM5/nGWmP
	WrxhQoi7pma9n9szTQSJn2IOJhY+bPELHyC+JlKy89Z3QfxVGjNqhuQaV7KcN0HdZl0f5vC4ovA
	cllQxgdVZLbnKRbNFbvKuJgI
X-Received: by 2002:a05:6000:454f:b0:48f:bcbf:26f5 with SMTP id ffacd0b85a97d-48fbcbf2c73mr1923220f8f.52.1793727658865;
        Tue, 03 Nov 2026 09:40:58 -0800 (PST)
Received: from localhost ([151.60.201.12])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48e71b80306sm28135094f8f.33.2026.11.03.09.40.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 03 Nov 2026 09:40:58 -0800 (PST)
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
 boundary=c5a5fde869710a3a79bb3641c634c1197ac09790723846e273976b318448;
 micalg=pgp-sha512; protocol="application/pgp-signature"
Date: Tue, 03 Nov 2026 18:40:43 +0100
Message-Id: <DMLRDRF0IJ5H.2FLKGIYY948MB@gmail.com>
Cc: "Amir Goldstein" <amir73il@gmail.com>, "Andreas Dilger"
 <adilger@dilger.ca>, "David Sterba" <dsterba@suse.com>, "Alexander Viro"
 <viro@zeniv.linux.org.uk>, "Christian Brauner" <brauner@kernel.org>,
 "Namjae Jeon" <linkinjeon@kernel.org>, "Sungjong Seo"
 <sj1557.seo@samsung.com>, "Konstantin Komarov"
 <almaz.alexandrovich@paragon-software.com>, "Chris Mason"
 <mason@kernel.org>, "Jan Kara" <jack@suse.cz>, "Yuezhang Mo"
 <yuezhang.mo@sony.com>, "Chuck Lever" <cel@kernel.org>, "Darrick J . Wong"
 <djwong@kernel.org>, "Sean Smith" <defendthedisabled@gmail.com>, "Andrey
 Albershteyn" <aalbersh@kernel.org>, "Pedro Falcato" <pfalcato@suse.de>,
 <linux-btrfs@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>,
 <linux-kernel@vger.kernel.org>, <exfat@lists.linux.dev>,
 <ntfs3@lists.linux.dev>, <linux-api@vger.kernel.org>
Subject: Re: [RFC PATCH v3 3/5] ntfs3: make crtime user-settable using ptime
From: "koraynilay" <koray.fra@gmail.com>
To: =?utf-8?q?Pali_Roh=C3=A1r?= <pali@kernel.org>, "koraynilay"
 <koray.fra@gmail.com>
X-Mailer: aerc 0.22.0-0-gc2f86b7abde3
References: <20261101015551.786044-1-koray.fra@gmail.com>
 <20261101015551.786044-4-koray.fra@gmail.com>
 <20261102142452.d6jkitgdeuquy23i@pali>
 <CAOQ4uxhQ3uhq6s+4deEJAQV5iy8QZoucojR58_dUNYrnjt_yvA@mail.gmail.com>
 <20261102153845.d67wlorqcbe3c2w7@pali>
 <DD1A08F1-8F47-4612-A807-AEA39461AF9B@dilger.ca>
 <CAOQ4uxh8EDX5HzFFKWv10-mHYVcSC1zXN+BS2qCm5cTMq=GOCA@mail.gmail.com>
 <20261103094906.n55n5dhrpct5ykmw@pali>
 <CAOQ4uxizEdR-MauSMOTfVcdxnuSMkrEuPth3nm3MsZuhcN5vjA@mail.gmail.com>
 <DMLQY7IRCAX1.1B2J5G5VNEVAS@gmail.com>
 <20261103173203.c4lldr63tocfstok@pali>
In-Reply-To: <20261103173203.c4lldr63tocfstok@pali>

--c5a5fde869710a3a79bb3641c634c1197ac09790723846e273976b318448
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8

On Tue Nov 3, 2026 at 6:32 PM CET, Pali Roh=C3=A1r wrote:
> On Tuesday 03 November 2026 18:20:24 koraynilay wrote:
>> On Tue Nov 3, 2026 at 4:10 PM CET, Amir Goldstein wrote:
>> > On Tue, Nov 3, 2026 at 10:49=E2=80=AFAM Pali Roh=C3=A1r <pali@kernel.o=
rg> wrote:
>> >>
>> >> On Tuesday 03 November 2026 09:23:32 Amir Goldstein wrote:
>> >> > On Tue, Nov 3, 2026 at 2:19=E2=80=AFAM Andreas Dilger <adilger@dilg=
er.ca> wrote:
>> >> > >
>> >> > > On Nov 2, 2026, at 09:38, Pali Roh=C3=A1r <pali@kernel.org> wrote=
:
>> >> > > >
>> >> > > > On Monday 02 November 2026 16:09:41 Amir Goldstein wrote:
>> >> > > >> On Mon, Nov 2, 2026 at 3:24=E2=80=AFPM Pali Roh=C3=A1r <pali@k=
ernel.org> wrote:
>> >> > > >>>
>> >> > > >>> On Sunday 01 November 2026 02:55:49 koraynilay wrote:
>> >> > > >>>> @@ -154,6 +158,11 @@ int ntfs_fileattr_set(const struct mnt_=
idmap *idmap, struct dentry *dentry,
>> >> > > >>>>      if (flags & FS_APPEND_FL)
>> >> > > >>>>              new_fl |=3D S_APPEND;
>> >> > > >>>>
>> >> > > >>>> +     if (fa->fsx_xflags & FS_XFLAG_PTIME) {
>> >> > > >>>> +             ni->i_crtime.tv_sec =3D fa->fsx_ptime.tv_sec;
>> >> > > >>>> +             ni->i_crtime.tv_nsec =3D fa->fsx_ptime.tv_nsec=
;
>> >> > > >>>> +     }
>> >> > > >>>> +
>> >> > > >>>>      inode_set_flags(inode, new_fl, S_IMMUTABLE | S_APPEND);
>> >> > > >>>>
>> >> > > >>>>      /* Save nodump flag to return in ntfs_getattr. */
>> >> > > >>>> @@ -275,8 +284,9 @@ int ntfs_getattr(const struct mnt_idmap =
*idmap, const struct path *path,
>> >> > > >>>>      if (unlikely(is_bad_ni(ni)))
>> >> > > >>>>              return -EINVAL;
>> >> > > >>>>
>> >> > > >>>> -     stat->result_mask |=3D STATX_BTIME;
>> >> > > >>>> +     stat->result_mask |=3D (STATX_BTIME | STATX_PTIME);
>> >> > > >>>>      stat->btime =3D ni->i_crtime;
>> >> > > >>>> +     stat->ptime =3D ni->i_crtime;
>> >> > > >>>
>> >> > > >>> For me this patch looks dangerous. Somehow I would expect tha=
t the
>> >> > > >>> "btime" will never change for existing inode.
>> >> > > >>>
>> >> > > >>> But because the ptime is mapped to i_crtime and ptime is sett=
able from
>> >> > > >>> userspace, with this patch it is directly possible to change =
btime.
>> >> > > >>>
>> >> > > >>>
>> >> > > >>>
>> >> > > >>> I was thinking more about it... Is not this just misunderstan=
ding of how
>> >> > > >>> the security model around the times is working on different s=
ystems?
>> >> > > >>> Because on NTFS there is stored just one field which says whe=
n the file
>> >> > > >>> was created. There are not two fields like "time set by user =
and time
>> >> > > >>> set by system".
>> >> > > >>>
>> >> > > >>> Windows security model allows anybody with WRITE_ATTRIBUTES a=
ccess to
>> >> > > >>> change that create time. Linux security model does not allow =
to change it.
>> >> > > >>>
>> >> > > >>> NTFS in this view is just a filesystem like any other (ext4, =
btrfs, ...).
>> >> > > >>> In my opinion if the ext4 or btrfs filesystem is correctly im=
plemented
>> >> > > >>> on Windows systems, then Windows security model should handle=
 it in the
>> >> > > >>> same way like for NTFS or exFAT. So if something grants WRITE=
_ATTRIBUTES
>> >> > > >>> access, then Windows should allow to change also btime on ext=
4 or btrfs.
>> >> > > >>>
>> >> > > >>>
>> >> > > >>>
>> >> > > >>> On the other hand, I understand the use case to have two crea=
tion times.
>> >> > > >>> One time which would never be changed and could be used for a=
ny kind of
>> >> > > >>> atomic / synchronization by userspace application logic (this=
 btime).
>> >> > > >>> And another time for human which can be changed at any time t=
o any value
>> >> > > >>> which user wants (this ptime).
>> >> > > >>>
>> >> > > >>> In any case, I would suggest that filesystem driver would not=
 report to
>> >> > > >>> userspace unsupported values and would not try to invent othe=
r values
>> >> > > >>> and lying about them.
>> >> > > >>
>> >> > > >> But all those fs with mutable creation time already report it =
with STATX_BTIME
>> >> > > >> so what can we do about this?
>> >> > > >
>> >> > > > Well, what I wanted above to point out is that the "mutability"=
 of
>> >> > > > creation time is not feature of filesystem, but in my opinion r=
ather
>> >> > > > property of the security model on the running operating system.
>> >> > > >
>> >> > > > Maybe better question is: how ext4 btimes differs from the ntfs=
 btime?
>> >> > > > In my opinion there is no much difference, both of them has mea=
ning
>> >> > > > "time when was the file created".
>> >> > > >
>> >> > > >> If userspace requests both STATX_BTIME|STATX_PTIME in mask arg=
,
>> >> > > >> those fs could technically return only STATX_PTIME and it shou=
ld not regress
>> >> > > >> existing programs.
>> >> > > >>
>> >> > > >> But this is still a bit surprising behavior is it not?
>> >> > > >>
>> >> > > >> Thanks,
>> >> > > >> Amir.
>> >> > > >
>> >> > > > I'm not sure what to do with it.
>> >> > > >
>> >> > > > If we allow to change btime of ntfs then for consistency we sho=
uld also
>> >> > > > allow to change btime of ext4.
>> >> > > >
>> >> > > > Maybe another idea... define new capability which would allow t=
o change
>> >> > > > btime (on any filesystem)? This would at least make the consist=
ency.
>> >> >
>> >> > Pali, I think this is a very bad idea.
>> >>
>> >> Ok, if the point is that ext4 btime must stay immutable then it is a =
bad idea.
>> >>
>> >> > This has nothing to do with capabilities.
>> >> > The Windows and MacOS filesystems have allowed setting their
>> >> > "creation time" forever
>> >>
>> >> FreeBSD for some fs allow it too (see below).
>> >>
>> >> > and for all the other Linux filesystems that had
>> >> > "birth time" it was immutable, so let's not mix filesystem features
>> >> > with capabilities.
>> >>
>> >> I think that it is important to first define behavior and invariants =
of
>> >> these "btime" and "ptime" kernel properties.
>> >>
>> >> If we want to be consistent then there are two possible options:
>> >>
>> >> 1. If we choose that the STATX_BTIME is immutable then no kernel fs
>> >>    driver should allow to change.
>> >>
>> >> 2. If we choose that the "NTFS create time" is reported via STATX_BTI=
ME
>> >>    then STATX_BTIME is not immutable at all.
>> >>
>> >> These two options cannot be chosen together because option 1 would
>> >> implie that the modifiable "NTFS create time" cannot be reported over
>> >> STATX_BTIME.
>> >>
>> >> We are have currently STATX_BTIME immutable and "NTFS create time"
>> >> reported via STATX_BTIME.
>> >>
>> >> If we want to stay _consistent_ across fs drivers then adding API for
>> >> changing "NTFS create time" would break one of those two things.
>> >>
>> >> In my opinion we should stay consistent across filesystem drivers and
>> >> provide unified behavior of APIs independently of used filesystem.
>> >> Otherwise userspace applications would have to write fs specific code
>> >> for doing their use cases (and we can stay with fs-specific xattrs, n=
o
>> >> need to create unified APIs).
>> >>
>> >> Does it make sense? Or it is still a bad idea to think about it in th=
is way?
>> >>
>> >
>> > My "bad idea" comment was only referring to capability.
>> >
>> > w.r.t the STATX_BTIME ambiguity there is another option we may want to
>> > consider: Don't publish STATX_PTIME via statx() at all.
>> >
>> > One of the reasons that developers have pointed to fileattr as the rig=
ht API
>> > to host the creation time as well as the DOS attributes is that it has=
 a history
>> > of carrying filesystem specific attributes.
>> >
>> > Not every attribute available in lsattr is also available in statx().
>> > If projid is not available in statx() then the settable creation time
>> > doesn't need to be in statx() either.
>> >
>> > The file_[sg]etattr() syscalls provides a symmetric API to set/get it.
>>=20
>> btime currently is also a fliesystem specific implementation tho, and
>> there was already a transition from stat to statx when btime was added,
>> so I think ptime should be included in statx, especially since it should
>> be treated as one of the standard timestamps from now on (or at least,
>> that's what I hope to achieve eventually).
>> The only difference to the currently standard timestamps would be that
>> a/mtime are managed by utimensat, ctime/btime by the filesystems
>> themselves (as they're more "internal" and less "user-facing") and ptime
>> would be managed by file_[gs]etattr() (since changing utimensat wouldn't
>> make sense as said in the april thread).
>
> Not related to these changes, but I think it would make sense to adjust
> also utimensat man page documentation and mention there what kind of
> syscall/function will be used for changing ptime. From my experience,
> such cross reference can help developers. Also the fact is that FreeBSD
> changes birth time via utimes syscall could mean that developers could
> look for similar Linux functionality in linux utime* manpages.

Right, I'll add some quick draft/mention in the manpage for next series,
just to remember to include this in the final patch (and to get feedback
on this point too).

Thanks,
koraynilay

>>=20
>> > The same could be true to HIDDEN/ARCHIVE/SYSTEM flags if those
>> > are added to fileattr.
>> >
>> > Do we need to stop publishing NTFS creation time in STATX_BTIME?
>> > I think it's too late for that and nobody is going to gain anything
>> > from doing that.
>> >
>> > Thanks,
>> > Amir.
>>=20
>>=20



--c5a5fde869710a3a79bb3641c634c1197ac09790723846e273976b318448
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQRJ2XvJtXGwULYEerQ0bnTtJTDoOAUCauocmwAKCRA0bnTtJTDo
OAdQAQCYIdU5uaWCGPbgdHiAaI43OTEUpmNMNI06KVgbMWpOXgEAgvqYaGh+5xGv
tTUbArF1CokI7Zqs1nLK83tHMHPSWwI=
=fO3V
-----END PGP SIGNATURE-----

--c5a5fde869710a3a79bb3641c634c1197ac09790723846e273976b318448--
