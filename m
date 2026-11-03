Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.41
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793707905;
	b=bQW65LIgCghFM4xIqJKtY5ppB5hRIqMQH4YReX01lpD0dqUDAt19BRmoQBPrVpbmzsgM
	 MScwdRiocPo11bBnBF4UIuHgZvgQ9Bstoxxr9WEDdFGVXi6GKaPt3KIoiblh9OvphT15l
	 LQ9LDUjyM51+h7sj/rbXr9nogdcMujnEUGX350PilRUg8DyzFPqMHJlyzJevufqMRiLZw
	 Tw65aXXGJfuxJYSr6hYSrPtOmIQ/A4j8FGf2KW6aRqasU0iTLciTmkgxjs/wTifDCssZ5
	 q+N1mzfPGl4ypzzuwNikxDV0xZpKkqgL51pC5eLkqymcr9LB2YKF2xluF5447Tykt9Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793707905;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Mime-Version:Content-Type:Date:Message-Id:From:To:Cc:Subject:X-Mailer:
	 References:In-Reply-To;
	bh=xaoHhtO7aV+Q2IZPOZAqbumhvcxyDzSipkyK2kiugFo=;
	b=p5ivv4S+2/knib1GVyWOAfceI/otunMEF94lyb6WFOCwE/ZvqDuIz2Fa+YIHKzTAabRQ
	 146WhAHDVCs/rCP1ef0A7F2UlD2fdRkpI38Ts8VKF55Y4zMpTBBWPNIKaL9RmKCxTp1gT
	 wYwkuiKMCaZfMh7M00lzsgBh9gJrG2urN/p68J2jTNMb475MiRtoIq9Crg35HrDaLA88u
	 hfoIpiMZSPZViMQL11K/cInW1+upA8JcV1wWjFprctZNJeEYIYhPoRf7cPFCh/xtQyJKK
	 Vg1DmNJDt47iQPRQCA5KcnqXbrLYhVNIww3iIgd5UixKi9fpG31sATywUiB/pcqi1Mg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=k9MuALIV;
	arc=none smtp.remote-ip=209.85.221.41
Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com [209.85.221.41])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DCE2606A32D
	for <linux-api@vger.kernel.org>; Tue,  3 Nov 2026 12:11:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6DCE2606A32D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=k9MuALIV
Received: by mail-wr1-f41.google.com with SMTP id ffacd0b85a97d-48df4e9d2d4so2211156f8f.3
        for <linux-api@vger.kernel.org>; Tue, 03 Nov 2026 04:11:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793707903; x=1794312703; darn=vger.kernel.org;
        h=in-reply-to:references:subject:cc:to:from:message-id:date
         :content-type:mime-version:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=xaoHhtO7aV+Q2IZPOZAqbumhvcxyDzSipkyK2kiugFo=;
        b=k9MuALIV9+qIoD4+CMM0ZHKiUSGtMqwttDDmvBJvoAgoHdTYPkNfjz8rHL34F3k9RE
         8+Hoc368of4iQ560wv3YPjMY4Yalw8q4kZopEwU+lSNKYmyJrdwEt3DW+iVWnJKe7mmZ
         ME4XTifjWsgp4AC4wBJg+bEuXO/vkkfjRgV++IOocjxLQehV7jL0KL6ZDsDU0ShG4DpW
         C4T0embwiZpDsnJlZ9tGkHMATW0LPxnF0r4T+zodmf8SuG6yIxR707Nj8EWh8poSyMI9
         CFT3bG9Jx88naRp4nylVJc8mMgy95weLICN/iZRvFJCigE9qwt7QqtFrFQiU2yWtlOxz
         gFgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793707903; x=1794312703;
        h=in-reply-to:references:subject:cc:to:from:message-id:date
         :content-type:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=xaoHhtO7aV+Q2IZPOZAqbumhvcxyDzSipkyK2kiugFo=;
        b=vHvtXyI71Mf69es8KldyiAzsFNymmXT7QhQr7xNcmusJsvte1VTNDjsgiY4rMdcjAH
         QCtb0K+lVfp8hAwevdPwGtRd9BZ2AaC8SCn7qmAZw9mooVGhxRGHT/Y0I5PRGg4lFfLk
         dhnIWwpgkyEKNYqM2aQHfovWoRfcBYa8APeNmhq/V7ZtBzf/yzj4SAD5B+Rdl+Lq8HY/
         FGhzaiNwPhYFGMF15/PWul7BjsP67ubhjiuU+6SWkw/SjYPcUiLwqaVTn7an5ZFQNP6q
         NYMZivIFwxE0pJ+d9RaeKwlGxm23sxJb8jX0G2rSPc+eNDu4fmhKrHqbUzkc9y+hF/8D
         kPsg==
X-Forwarded-Encrypted: i=1; AKwUvBzncy2lsbGIgr+mpjl3QcKP4KOer6o8pbifBc3PNkwY6cepmkO39KjbRfFQmipcBKuBd7M+CO8Gtrs=@vger.kernel.org
X-Gm-Message-State: APuU4Z9jWy5RZbrfZwxvRGRb2rv4TmhYCcXBGe9a7eYr/dtLJsW05n+M
	eTT4ZlxoIVRCt9buFNsBFclRoLLD7NnjFvXqF+pUS6GXoB6wa+yvQX0E
X-Gm-Gg: AYBFou3b7JaavfH1vUne22XvE3wSL+1VaLlM625KbhNLambRB2fYiZJI4HhBUz7cLXj
	L4vgKIPS98sMXequNqlk1SOMrgf8aIVAK3ca6EK0DvKd3RjAMKNNR3zh538bbaGMP66HfYqK+OX
	CKqC+uizSUSyQW+855kl7zUKgSXH/Cqp3tZqvB/XpjuzLvZajo4womnvs37Mg9KUY2pg9YvM1qv
	4R0trN8rsNq8Yg0UX8+f2F+ucIt5ufAyH9pJxloeBvY4QrJ53fOohK6Fb/wnJtKwn1A2N0bdunF
	zQzIiF2SMIpP60fgcBOGGHhU5BeqtRoTguI2P6mzPF5MczffOoB8VAgsVLRSX/XRrd4dSzhzpvX
	TxA0lvq59zJa6sKThbQqfc4EC1Gbq8V0+5P9YI+61kDevwupPX/vb6NkpPFKokpo88ZypyI5IgK
	QKOC3v1OdhXueiu2e6J37CvLRlaPzSBz2LZ6APBHMnyd2HqM06VEWeFQl790TbIG4MvzlB2GlBP
	5Iw5onupmI9JvA28EkegYRMIDw0dYcgKnw0hWARtNf+Jr/SCkhI0SYsNCNGwX1Vx94C6gUzATX4
	7/yVuOIfQIn8h9izO4HmwRcQyQMs9TYCduNm6qJZqC65MBZ0Pwd6sCE=
X-Received: by 2002:a5d:64e3:0:b0:48d:f876:f370 with SMTP id ffacd0b85a97d-48e6e309763mr26884305f8f.48.1793707902446;
        Tue, 03 Nov 2026 04:11:42 -0800 (PST)
Received: from localhost (78-212-141-14.subs.proxad.net. [78.212.141.14])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48e71b9b54dsm24330834f8f.47.2026.11.03.04.11.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 03 Nov 2026 04:11:40 -0800 (PST)
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
 boundary=4021ef4d146425c1319d29eb562c73840b95500eb95f16ec5197c0df3fe8;
 micalg=pgp-sha512; protocol="application/pgp-signature"
Date: Tue, 03 Nov 2026 13:11:30 +0100
Message-Id: <DMLKDOZWVDTU.GLUJUDOZES2V@gmail.com>
From: "koraynilay" <koray.fra@gmail.com>
To: =?utf-8?q?Pali_Roh=C3=A1r?= <pali@kernel.org>, "koraynilay"
 <koray.fra@gmail.com>
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
X-Mailer: aerc 0.22.0-0-gc2f86b7abde3
References: <20261101015551.786044-1-koray.fra@gmail.com>
 <20261101015551.786044-4-koray.fra@gmail.com>
 <20261102142452.d6jkitgdeuquy23i@pali>
 <CAOQ4uxhQ3uhq6s+4deEJAQV5iy8QZoucojR58_dUNYrnjt_yvA@mail.gmail.com>
 <20261102153845.d67wlorqcbe3c2w7@pali>
 <DD1A08F1-8F47-4612-A807-AEA39461AF9B@dilger.ca>
 <CAOQ4uxh8EDX5HzFFKWv10-mHYVcSC1zXN+BS2qCm5cTMq=GOCA@mail.gmail.com>
 <20261103094906.n55n5dhrpct5ykmw@pali>
 <DMLIYIKP2CN8.3VGUCOLTMZC5J@gmail.com>
 <20261103113835.7kndzvvegrkwjlsd@pali>
In-Reply-To: <20261103113835.7kndzvvegrkwjlsd@pali>

--4021ef4d146425c1319d29eb562c73840b95500eb95f16ec5197c0df3fe8
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8

On Tue Nov 3, 2026 at 12:38 PM CET, Pali Roh=C3=A1r wrote:
> On Tuesday 03 November 2026 12:04:39 koraynilay wrote:
>> Hi and sorry for the late reply,
>>=20
>> On Tue Nov 3, 2026 at 10:49 AM CET, Pali Roh=C3=A1r wrote:
>> > On Tuesday 03 November 2026 09:23:32 Amir Goldstein wrote:
>> >> On Tue, Nov 3, 2026 at 2:19=E2=80=AFAM Andreas Dilger <adilger@dilger=
.ca> wrote:
>> >> >
>> >> > On Nov 2, 2026, at 09:38, Pali Roh=C3=A1r <pali@kernel.org> wrote:
>> >> > >
>> >> > > On Monday 02 November 2026 16:09:41 Amir Goldstein wrote:
>> >> > >> On Mon, Nov 2, 2026 at 3:24=E2=80=AFPM Pali Roh=C3=A1r <pali@ker=
nel.org> wrote:
>> >> > >>>
>> >> > >>> On Sunday 01 November 2026 02:55:49 koraynilay wrote:
>> >> > >>>> @@ -154,6 +158,11 @@ int ntfs_fileattr_set(const struct mnt_id=
map *idmap, struct dentry *dentry,
>> >> > >>>>      if (flags & FS_APPEND_FL)
>> >> > >>>>              new_fl |=3D S_APPEND;
>> >> > >>>>
>> >> > >>>> +     if (fa->fsx_xflags & FS_XFLAG_PTIME) {
>> >> > >>>> +             ni->i_crtime.tv_sec =3D fa->fsx_ptime.tv_sec;
>> >> > >>>> +             ni->i_crtime.tv_nsec =3D fa->fsx_ptime.tv_nsec;
>> >> > >>>> +     }
>> >> > >>>> +
>> >> > >>>>      inode_set_flags(inode, new_fl, S_IMMUTABLE | S_APPEND);
>> >> > >>>>
>> >> > >>>>      /* Save nodump flag to return in ntfs_getattr. */
>> >> > >>>> @@ -275,8 +284,9 @@ int ntfs_getattr(const struct mnt_idmap *i=
dmap, const struct path *path,
>> >> > >>>>      if (unlikely(is_bad_ni(ni)))
>> >> > >>>>              return -EINVAL;
>> >> > >>>>
>> >> > >>>> -     stat->result_mask |=3D STATX_BTIME;
>> >> > >>>> +     stat->result_mask |=3D (STATX_BTIME | STATX_PTIME);
>> >> > >>>>      stat->btime =3D ni->i_crtime;
>> >> > >>>> +     stat->ptime =3D ni->i_crtime;
>> >> > >>>
>> >> > >>> For me this patch looks dangerous. Somehow I would expect that =
the
>> >> > >>> "btime" will never change for existing inode.
>> >> > >>>
>> >> > >>> But because the ptime is mapped to i_crtime and ptime is settab=
le from
>> >> > >>> userspace, with this patch it is directly possible to change bt=
ime.
>> >> > >>>
>> >> > >>>
>> >> > >>>
>> >> > >>> I was thinking more about it... Is not this just misunderstandi=
ng of how
>> >> > >>> the security model around the times is working on different sys=
tems?
>> >> > >>> Because on NTFS there is stored just one field which says when =
the file
>> >> > >>> was created. There are not two fields like "time set by user an=
d time
>> >> > >>> set by system".
>> >> > >>>
>> >> > >>> Windows security model allows anybody with WRITE_ATTRIBUTES acc=
ess to
>> >> > >>> change that create time. Linux security model does not allow to=
 change it.
>> >> > >>>
>> >> > >>> NTFS in this view is just a filesystem like any other (ext4, bt=
rfs, ...).
>> >> > >>> In my opinion if the ext4 or btrfs filesystem is correctly impl=
emented
>> >> > >>> on Windows systems, then Windows security model should handle i=
t in the
>> >> > >>> same way like for NTFS or exFAT. So if something grants WRITE_A=
TTRIBUTES
>> >> > >>> access, then Windows should allow to change also btime on ext4 =
or btrfs.
>> >> > >>>
>> >> > >>>
>> >> > >>>
>> >> > >>> On the other hand, I understand the use case to have two creati=
on times.
>> >> > >>> One time which would never be changed and could be used for any=
 kind of
>> >> > >>> atomic / synchronization by userspace application logic (this b=
time).
>> >> > >>> And another time for human which can be changed at any time to =
any value
>> >> > >>> which user wants (this ptime).
>> >> > >>>
>> >> > >>> In any case, I would suggest that filesystem driver would not r=
eport to
>> >> > >>> userspace unsupported values and would not try to invent other =
values
>> >> > >>> and lying about them.
>> >> > >>
>> >> > >> But all those fs with mutable creation time already report it wi=
th STATX_BTIME
>> >> > >> so what can we do about this?
>> >> > >
>> >> > > Well, what I wanted above to point out is that the "mutability" o=
f
>> >> > > creation time is not feature of filesystem, but in my opinion rat=
her
>> >> > > property of the security model on the running operating system.
>> >> > >
>> >> > > Maybe better question is: how ext4 btimes differs from the ntfs b=
time?
>> >> > > In my opinion there is no much difference, both of them has meani=
ng
>> >> > > "time when was the file created".
>> >> > >
>> >> > >> If userspace requests both STATX_BTIME|STATX_PTIME in mask arg,
>> >> > >> those fs could technically return only STATX_PTIME and it should=
 not regress
>> >> > >> existing programs.
>> >> > >>
>> >> > >> But this is still a bit surprising behavior is it not?
>> >> > >>
>> >> > >> Thanks,
>> >> > >> Amir.
>> >> > >
>> >> > > I'm not sure what to do with it.
>> >> > >
>> >> > > If we allow to change btime of ntfs then for consistency we shoul=
d also
>> >> > > allow to change btime of ext4.
>> >> > >
>> >> > > Maybe another idea... define new capability which would allow to =
change
>> >> > > btime (on any filesystem)? This would at least make the consisten=
cy.
>> >>=20
>> >> Pali, I think this is a very bad idea.
>> >
>> > Ok, if the point is that ext4 btime must stay immutable then it is a b=
ad idea.
>> >
>> >> This has nothing to do with capabilities.
>> >> The Windows and MacOS filesystems have allowed setting their
>> >> "creation time" forever
>> >
>> > FreeBSD for some fs allow it too (see below).
>> >
>> >> and for all the other Linux filesystems that had
>> >> "birth time" it was immutable, so let's not mix filesystem features
>> >> with capabilities.
>> >
>> > I think that it is important to first define behavior and invariants o=
f
>> > these "btime" and "ptime" kernel properties.
>> >
>> > If we want to be consistent then there are two possible options:
>> >
>> > 1. If we choose that the STATX_BTIME is immutable then no kernel fs
>> >    driver should allow to change.
>> >
>> > 2. If we choose that the "NTFS create time" is reported via STATX_BTIM=
E
>> >    then STATX_BTIME is not immutable at all.
>> >
>> > These two options cannot be chosen together because option 1 would
>> > implie that the modifiable "NTFS create time" cannot be reported over
>> > STATX_BTIME.
>> >
>> > We are have currently STATX_BTIME immutable and "NTFS create time"
>> > reported via STATX_BTIME.
>> >
>> > If we want to stay _consistent_ across fs drivers then adding API for
>> > changing "NTFS create time" would break one of those two things.
>> >
>> > In my opinion we should stay consistent across filesystem drivers and
>> > provide unified behavior of APIs independently of used filesystem.
>> > Otherwise userspace applications would have to write fs specific code
>> > for doing their use cases (and we can stay with fs-specific xattrs, no
>> > need to create unified APIs).
>> >
>> > Does it make sense? Or it is still a bad idea to think about it in thi=
s way?
>>=20
>> Personally I think in this discussion we should separate linux
>> filesystems vs non-linux filesystems, as linux filesystems are "ours"
>> and are the ones we can change as we want, while non-linux filesystems
>> are not made by "us" and cannot be easily changed (like NFS I would say)
>> or cannot changed at all (e.g. NTFS (well, unless we make ntfs
>> incompatible with windows lol)).
>>=20
>> But I understand why it would be better to keep a unified API across all
>> filesystems, even "non-official" ones, so I can think of 2 options
>> (well, with ntfs/exfat in mind, as I don't know much about NFS/smb):
>
> SMB for timestamps has exactly same meaning and storage format as NTFS.
> So it should be pretty straightforward what to do with it.
> NFS3 does not have btime at all. And NFS4 has FATTR4_TIME_CREATE attr
> which I described in previous email (there is no more info). So based on
> the decision of 1 or 2, that NFS4 attr would either map to btime or ptime=
.

Ah ok, thanks.

>>=20
>> 1) keep btime aliased to ptime, which means that (to userspace) btime
>>    would be mutable for ntfs/exfat/vfat/etc
>>=20
>> 2) move ntfs/exfat/vfat/etc's cr_time from btime to ptime, effectively
>>    "removing" btime from those FSs and "keeping" only ptime; in this cas=
e
>>    stat would show "-" for Birth:, but would show the correct timestamp =
for
>>    Origin:/Create:/Provenance:/...
>>=20
>> I prefer 1) because it probably breaks less scripts, but 2) would be
>> more correct semantically.
>
> My personal opinion is 2) because the btime stay immutable also in
> userspace and is also more correct semantically.
>
> Another argument why 2) should be less breaking change: Userspace
> applications have to already expect that the btime is not filled at all
> (e.g. when filesystem does not support it or when application is running
> on older kernel version without such support).

Right, I didn't think of that.

> My opinion is that if the _new_ API provides two different timestamps
> based on the filesystem then we should report it as is, so userspace can
> decide how to want to process them. For example full 1:1 clone backup
> application would want to preserve both btime and ptime and correctly
> indicate if one of them is not available (e.g. because underlying fs
> support only one of those times, like NTFS). And such full 1:1 clone
> backup application do not want to "invent" some unavailable values.
> Option 1) would not allow to do that for such applications.

Ok yes I agree, I'll update the ntfs/exfat patches to switch btime for
ptime then.

>> And both break at least 1 existing script anyway (as per https://xkcd.co=
m/1172/).
>
> Yes. And that is because we want a new feature which allows changing
> something which was immutable. So we need to handle it somehow.
>
>> >> >
>> >> > I think the ext4 and xfs maintainers have repeatedly said that btim=
e/crtime
>> >> > attribute should not be modified by users.  There was a long discus=
sion on
>> >> > this from Ted as well, and the reality is that "creation" time is n=
ot worth
>> >> > the bits that it is written on,
>> >>=20
>> >> This is an opinion of individual people, who did not lay out technica=
l
>> >> arguments.
>> >> I have concrete technical arguments in favor of first class creation =
time for
>> >> ext4/xfs from my experience with production systems that need it and =
use xattr
>> >> to store it (by smbd), but I am not going to list them here because
>> >> this is not a
>> >> thread about implementing mutable creation time for ext4/xfs.
>>=20
>> For my (backups, preservation) use case, making btime mutable would also
>> be fine, but I can see the value of having a "ctime" for creation, hence
>> this RFC.
>>=20
>> >>=20
>> >> > since it is not preserved by any tools, has
>> >>=20
>> >> Facts check:
>> >>=20
>> >> # NEWS for rsync 3.2.3 (6 Aug 2020)
>> >>=20
>> >> ## Changes in this version:
>> >> ...
>> >>  - Added [`--crtimes`](rsync.1#opt) (`-N`) option for preserving the =
file's
>> >>    create time (I believe that this is macOS only at the moment).
>> >>=20
>> >> Incidentally, I have an implementation for --crtimes for cifs [1], bu=
t this
>> >> is not extendable to support all the filsystems which support settabl=
e crtime.
>> >
>> > Another two facts check:
>> >
>> > FreeBSD has also API for changing "birth (creation) times".
>> > It is documented in utimes(2) manpage:
>> > https://man.freebsd.org/cgi/man.cgi?query=3Dutimes&sektion=3D2
>> >
>> > So I guess that there has to be some tool which is using this API and
>> > therefore these "birth (creation) times" are preserved.
>> >
>> >
>> > NFS4 has time_create attribute (FATTR4_TIME_CREATE=3D50) which is
>> > per-fs-object read-write attribute and defined (in RFC8881 5.8.2.40.) =
as:
>> >   The time of creation of the object. This attribute does not have any
>> >   relation to the traditional UNIX file attribute "ctime" or "change t=
ime".
>> > Since NFSv4.1 it can be even specified during creating a new file/dir
>> > which seems to be for backup-restore. And permissions (RFC8881 6.2.1.3=
.1.):
>> >   ACE4_WRITE_ATTRIBUTES
>> >   Operation(s) affected: SETATTR of time_access_set, time_backup,
>> >     time_create, time_modify_set, mimetype, hidden, system
>> >   Discussion: Permission to change the times associated with a file or
>> >     directory to an arbitrary value. Also permission to change the
>> >     mimetype, hidden, and system attributes. A user having ACE4_WRITE_=
DATA
>> >     or ACE4_WRITE_ATTRIBUTES will be allowed to set the times associat=
ed
>> >     with a file to the current server time.
>> >
>> > I'm not sure if there is some backup/restore tool which do it over NFS=
4
>> > but the NFS4 description seems to be very clear that the network proto=
col
>> > itself is already prepared for these use cases. And permissions mostly
>> > matches the SMB / NTFS / Windows security model.
>> >
>> >> > a "vague" meaning (is it when the *file* was created, when the *con=
tent* was
>> >> > created, do edits update it, is it preserved across filesystems, ar=
chives,
>> >> > etc.) and adding it into the filesystem is misplaced effort.
>> >>=20
>> >> Sorry now you are talking nonsense. Meaning has nothing to do with it=
.
>> >> This is a property of filesystems (plural) which have documented APIs
>> >> and documented network protocols - it is what it is.
>> >>=20
>> >> If you are looking for a meaning, it is the first publication date, w=
hether
>> >> it means something to you is irrelevant - what's relevant is that cus=
tomers
>> >> use it and want to preserve it in backups, whatever its meaning is.
>> >
>> > I agree here. I also heard lot of times that users (customers) want to
>> > preserve create time in backups and be able to restore it. And that
>> > Windows is already able to do it, Linux not yet.
>>=20
>> Hi I'm one of those users, I still can't believe no-one has implemented
>> something like this yet since POSIX came out way back when (*cry*).
>>=20
>> > Maybe what is a "vague" here is where that "create time" is stored and
>> > from which (API) source is GUI (or CLI) application showing it to user=
.
>> >
>> >> >
>> >> > Storing it as an xattr has some reasonable chance of being preserve=
d across
>> >> > tar/cp/filesystems, and doesn't introduce a herculean effort of cha=
nging
>> >> > all of the system calls and on-disk formats for every filesystem.
>> >> >
>> >
>> > I think the part "being preserved across tar/cp/filesystems" is
>> > relevant. If a completely new API is introduced into Linux then it mea=
ns
>> > that every existing backup tool would not be able to preserve this
>> > property and also would not be able to restore it.
>> >
>> > I'm not sure if we can do anything with this issue, but it is importan=
t
>> > to know about this limitation.
>>=20
>> My thinking for this RFC would be to then submit relevant patches also
>> to at least the main tools I use like tar, cp, rsync and vim, which will
>> hopefully make it gain momentum and be supported also in other less
>> well-known tools (I would also love for it to be supported by HTTP like
>> mtime is, but that will likely be a lot more difficult to get accepted
>> and implemented).
>
> If having two btime and ptime fields would be the direction then we can
> propose an extension for NFS4 protocol with a new attribute (as NFS4 has
> currently only one). There are already some NFS4 extensions which comes
> from Linux or was inspired, e.g. umask or xattr support.

Yes that would be nice, so when making the patch for nfs (in v4 or v5),
should I treat FATTR4_TIME_CREATE as ptime and maybe try to add the
needed code for a new btime?

Thanks,
koraynilay

>> > About the part "introduce a herculean effort of changing all of the
>> > system calls and on-disk formats for every filesystem.". In my opinion
>> > it is better to do that cleanup (maybe even in all stat-related
>> > syscalls) if it makes things easier and prevents another technical
>> > issues.
>> >
>> >>=20
>> >> As I said I can provide data for why the xattr approach taken by smbd=
 is
>> >> limited and inferior, but this is not the place to get into it (there=
 are hints
>> >> in the rsync commit message below).
>> >>=20
>> >> Thanks,
>> >> Amir.
>> >>=20
>> >> [1] https://github.com/amir73il/rsync/commits/cifs-crtimes/
>> >
>> > I would say that xattr does not solve this issue too.
>>=20
>> I would also like to note again that xattrs aren't available to symlinks
>> (or other special files), which would break at least my backup/preservat=
ion
>> use case.
>>=20
>> Best,
>> koraynilay

--4021ef4d146425c1319d29eb562c73840b95500eb95f16ec5197c0df3fe8
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHQEABYKAB0WIQRJ2XvJtXGwULYEerQ0bnTtJTDoOAUCaunPcgAKCRA0bnTtJTDo
OI6mAPjMnLq/EQ+r++5IMXXLUDypRX7qUy1wK/iyFhNiWG2/AQCyMgTOsWOkdFgi
u/tBpysg8yTHGlDE1l6EeIg4m3LLBw==
=Q7qx
-----END PGP SIGNATURE-----

--4021ef4d146425c1319d29eb562c73840b95500eb95f16ec5197c0df3fe8--
