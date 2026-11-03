Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.48
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793703902;
	b=YKAF9wX+r9KmZRSWyyGdm6h98jxxR0B8RJWPo8aylxOFpxU45DApt3WIDW5QrXR1ETgi
	 Pa4cNzNQuMRee9GXIzrgKiPNKoMT4KP4eSuyOaodN3+IBrQk1vxnpCCxNe57pwMfIN2i5
	 kTS0WF5Y5705eHloDDHaagjyedH4W5Fydcw8glWPkxKWMukXj1YN/ylN/SFSaaPQM+GPw
	 pVzu84Xh+Bxitjp56Kn1vzqYtKzygTk7IHUkrv5T+zKObwf6vEGGael2MExbeSHEvwL/u
	 qFgfeL7xCupov7JfFg7EYvpDPAN6Ea9dQdP9f4F+J46GqS8b20KchBnoOGXTw/5RmzQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793703902;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Mime-Version:Content-Type:Date:Message-Id:Cc:Subject:From:To:X-Mailer:
	 References:In-Reply-To;
	bh=j8M5IEnBOpeecrQD25vhkq0yjlX8vBG07N0hNcgzpTM=;
	b=kYkGE3I7ooe342dTuy/An4VkrFbEUQDVqny7iSI+fSQNZAjnnHugw938WHm+aJkmYJmY
	 FeLAKgdvHSbBaThd9ShzMcGQfZ/0Mk27LG1YSid7kF9v8jkjmbbN5Rlc/wKeAb/gzuUsH
	 MYRWpkeN5OxHR6704QaSWR8aww29OGepLuXT1rHAql2l4ZE2FVaKQKYVsbBkBECjHtbPW
	 7pYpkxeFrB1C18c/0tAXV/RvADRyIW6Twb1R8Zng1fiOuOcyyKfyOrxF4SUpjPITrYycM
	 c+GekajhM3pgKSzbA6YoJ9iB3psMFMKoxW5DXTYe7NXGk4k7ncTpywI5IpA9AIfmSWg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b="pLTH/8hb";
	arc=none smtp.remote-ip=209.85.221.48
Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com [209.85.221.48])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32FBE606C564
	for <linux-api@vger.kernel.org>; Tue,  3 Nov 2026 11:05:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 32FBE606C564
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=pLTH/8hb
Received: by mail-wr1-f48.google.com with SMTP id ffacd0b85a97d-48df8fe8513so3481018f8f.0
        for <linux-api@vger.kernel.org>; Tue, 03 Nov 2026 03:05:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793703900; x=1794308700; darn=vger.kernel.org;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-type:mime-version:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=j8M5IEnBOpeecrQD25vhkq0yjlX8vBG07N0hNcgzpTM=;
        b=pLTH/8hbTkbl4EdMBlGJnXHzNd8FISetg4mmO+f1qFagn/eZeFa6K0p6ezDs6zga2R
         lKvSSKB4mmTKqhH4lWfqJnqAlft2r08hMjKtETO22VM9tkTmOyn/bL9VJKXIszxB5zt+
         ZbmvEhUre+AlnqnTCBv2sN6tRf7SrMCNOHhodC8ZaNFZ5cxlare1dcSefr9XOhQD/6xR
         sNb34ANkt9oeNhhVLhvxlZIRE3Y6xVX9WBvwNcxrvJhwtuk42cIc2qHmapYrzPCmtn5V
         G9SJgG4QPe0eRn093Z5Q1Ri8SgKvPioteue+2w1I08bpfrWTicuflIn3CTHCQd9JDW56
         JTOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793703900; x=1794308700;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-type:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=j8M5IEnBOpeecrQD25vhkq0yjlX8vBG07N0hNcgzpTM=;
        b=04ACALd6Fh6GD0Hug5kpkMZCORIIPlN72T6adFy5sGMKkjNdD7wc5PtCQ1yfTXw+dq
         YI5UXDX/TmI/W2i+99qyGoF+BzgkoPi6Gkgn63bShsMwfvMKK+54Jx2IfLs7povdz6Pl
         tQMzM6RPRPy90g7RztLMs/jP97UhE7Y85aQZI58M7ZFBUTc2D34xDT1p8NS5ECFa6ksV
         uJOXki1tNqWLBm+YyTQdLkbmuxbaxRxpH5/4qLyUyjyjM8YTrbNNFQEjcitpPIPvko9m
         08j6q2JItrshCznBab/UlF4YKiuCMMU9KrpTPJARKWk2EAsWvHeUwXxMmyvP/fxcgDzS
         bpkw==
X-Forwarded-Encrypted: i=1; AKwUvBxAMzeXv1YJEpM5M8dF+36unOufdL+MeWu9CfJR5E0oS5w9Np6ZVBMIZIl8OwBRMG5/gd3nWmyq3hw=@vger.kernel.org
X-Gm-Message-State: APuU4Z9EZNJCzSZv0xTSKBxmEPuoPCg0qsjyO3WsTGqomdbsn/cW8lyH
	VP2wnEVginjcvax39acRBL+tF29l3utMvhhaF5Ea3PB3f/XLuVvKWJuu
X-Gm-Gg: AYBFou1K9qYoC6OWrTUoexxDVQz23Q97NzS9pV7DlG2IEjuFjL3pqI3Wq8pivDrO6K/
	Ens1tTb2wewl4T6v73uIOysTw85y+Pq/evCChgKckqBESOzuzUUIO4HW5/tNG9meHHaIEbeLTEj
	DtHm9KoKRp5icm16WLmSmGvWLwG1GFO8/aWSlpiIKxQuGo3UjOz8SD+Hm0n6NAkR5uLDQf+Dbmm
	uF14vlq6QknitrxsMT7WtbO7G55jc5kS5iD5kM9PcsoKsjMAo9+Fzo06T4RQFCFOf85UjllDD1W
	Zo+FUheJMRpm8Vkp12VDZFnrDDMpDWDQSYB4VKnJZtMfPQSVcdnkZKp8tskhAbsti71Husc+BpE
	XbX7746NTWjjFrtxvG3ZXinOePXIzIYWumiQ9o8T88HXWVZ4xciDf6VA1ThlbOBegvfqmLLtCD9
	j+mrOJbhiqQsvvYHT53DGUxTz9Eg/Bw2RKjtmBTbb5PZz7o9HUMm09pApoV6p4OpqfqQT4Uqxp7
	aHDZaU8ZG33kqIGsPQDYM8RnnWQzEINZgFWJy9laKHdbdo/RUJIprg4V+1WXnHr52ZCjO6T4XWi
	mzhu3J5xIDpcrvzcvlH0Sa3U2NVmX8hUfZcLugX4tGMVx+8sVEBAxM5RHpcNECW1O8SdlA==
X-Received: by 2002:a05:6000:2611:b0:48e:4e00:b72f with SMTP id ffacd0b85a97d-48e6e50c8ecmr27004328f8f.32.1793703900049;
        Tue, 03 Nov 2026 03:05:00 -0800 (PST)
Received: from localhost ([130.192.98.149])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48e71a4d3e9sm27288449f8f.6.2026.11.03.03.04.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 03 Nov 2026 03:04:59 -0800 (PST)
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
 boundary=0aa7e00f32b8c400c0464b8cc772bcee1c017d171ea542856405779d22a4;
 micalg=pgp-sha512; protocol="application/pgp-signature"
Date: Tue, 03 Nov 2026 12:04:39 +0100
Message-Id: <DMLIYIKP2CN8.3VGUCOLTMZC5J@gmail.com>
Cc: "Andreas Dilger" <adilger@dilger.ca>, "koraynilay"
 <koray.fra@gmail.com>, "David Sterba" <dsterba@suse.com>, "Alexander Viro"
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
To: =?utf-8?q?Pali_Roh=C3=A1r?= <pali@kernel.org>, "Amir Goldstein"
 <amir73il@gmail.com>
X-Mailer: aerc 0.22.0-0-gc2f86b7abde3
References: <20261101015551.786044-1-koray.fra@gmail.com>
 <20261101015551.786044-4-koray.fra@gmail.com>
 <20261102142452.d6jkitgdeuquy23i@pali>
 <CAOQ4uxhQ3uhq6s+4deEJAQV5iy8QZoucojR58_dUNYrnjt_yvA@mail.gmail.com>
 <20261102153845.d67wlorqcbe3c2w7@pali>
 <DD1A08F1-8F47-4612-A807-AEA39461AF9B@dilger.ca>
 <CAOQ4uxh8EDX5HzFFKWv10-mHYVcSC1zXN+BS2qCm5cTMq=GOCA@mail.gmail.com>
 <20261103094906.n55n5dhrpct5ykmw@pali>
In-Reply-To: <20261103094906.n55n5dhrpct5ykmw@pali>

--0aa7e00f32b8c400c0464b8cc772bcee1c017d171ea542856405779d22a4
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8

Hi and sorry for the late reply,

On Tue Nov 3, 2026 at 10:49 AM CET, Pali Roh=C3=A1r wrote:
> On Tuesday 03 November 2026 09:23:32 Amir Goldstein wrote:
>> On Tue, Nov 3, 2026 at 2:19=E2=80=AFAM Andreas Dilger <adilger@dilger.ca=
> wrote:
>> >
>> > On Nov 2, 2026, at 09:38, Pali Roh=C3=A1r <pali@kernel.org> wrote:
>> > >
>> > > On Monday 02 November 2026 16:09:41 Amir Goldstein wrote:
>> > >> On Mon, Nov 2, 2026 at 3:24=E2=80=AFPM Pali Roh=C3=A1r <pali@kernel=
.org> wrote:
>> > >>>
>> > >>> On Sunday 01 November 2026 02:55:49 koraynilay wrote:
>> > >>>> @@ -154,6 +158,11 @@ int ntfs_fileattr_set(const struct mnt_idmap=
 *idmap, struct dentry *dentry,
>> > >>>>      if (flags & FS_APPEND_FL)
>> > >>>>              new_fl |=3D S_APPEND;
>> > >>>>
>> > >>>> +     if (fa->fsx_xflags & FS_XFLAG_PTIME) {
>> > >>>> +             ni->i_crtime.tv_sec =3D fa->fsx_ptime.tv_sec;
>> > >>>> +             ni->i_crtime.tv_nsec =3D fa->fsx_ptime.tv_nsec;
>> > >>>> +     }
>> > >>>> +
>> > >>>>      inode_set_flags(inode, new_fl, S_IMMUTABLE | S_APPEND);
>> > >>>>
>> > >>>>      /* Save nodump flag to return in ntfs_getattr. */
>> > >>>> @@ -275,8 +284,9 @@ int ntfs_getattr(const struct mnt_idmap *idma=
p, const struct path *path,
>> > >>>>      if (unlikely(is_bad_ni(ni)))
>> > >>>>              return -EINVAL;
>> > >>>>
>> > >>>> -     stat->result_mask |=3D STATX_BTIME;
>> > >>>> +     stat->result_mask |=3D (STATX_BTIME | STATX_PTIME);
>> > >>>>      stat->btime =3D ni->i_crtime;
>> > >>>> +     stat->ptime =3D ni->i_crtime;
>> > >>>
>> > >>> For me this patch looks dangerous. Somehow I would expect that the
>> > >>> "btime" will never change for existing inode.
>> > >>>
>> > >>> But because the ptime is mapped to i_crtime and ptime is settable =
from
>> > >>> userspace, with this patch it is directly possible to change btime=
.
>> > >>>
>> > >>>
>> > >>>
>> > >>> I was thinking more about it... Is not this just misunderstanding =
of how
>> > >>> the security model around the times is working on different system=
s?
>> > >>> Because on NTFS there is stored just one field which says when the=
 file
>> > >>> was created. There are not two fields like "time set by user and t=
ime
>> > >>> set by system".
>> > >>>
>> > >>> Windows security model allows anybody with WRITE_ATTRIBUTES access=
 to
>> > >>> change that create time. Linux security model does not allow to ch=
ange it.
>> > >>>
>> > >>> NTFS in this view is just a filesystem like any other (ext4, btrfs=
, ...).
>> > >>> In my opinion if the ext4 or btrfs filesystem is correctly impleme=
nted
>> > >>> on Windows systems, then Windows security model should handle it i=
n the
>> > >>> same way like for NTFS or exFAT. So if something grants WRITE_ATTR=
IBUTES
>> > >>> access, then Windows should allow to change also btime on ext4 or =
btrfs.
>> > >>>
>> > >>>
>> > >>>
>> > >>> On the other hand, I understand the use case to have two creation =
times.
>> > >>> One time which would never be changed and could be used for any ki=
nd of
>> > >>> atomic / synchronization by userspace application logic (this btim=
e).
>> > >>> And another time for human which can be changed at any time to any=
 value
>> > >>> which user wants (this ptime).
>> > >>>
>> > >>> In any case, I would suggest that filesystem driver would not repo=
rt to
>> > >>> userspace unsupported values and would not try to invent other val=
ues
>> > >>> and lying about them.
>> > >>
>> > >> But all those fs with mutable creation time already report it with =
STATX_BTIME
>> > >> so what can we do about this?
>> > >
>> > > Well, what I wanted above to point out is that the "mutability" of
>> > > creation time is not feature of filesystem, but in my opinion rather
>> > > property of the security model on the running operating system.
>> > >
>> > > Maybe better question is: how ext4 btimes differs from the ntfs btim=
e?
>> > > In my opinion there is no much difference, both of them has meaning
>> > > "time when was the file created".
>> > >
>> > >> If userspace requests both STATX_BTIME|STATX_PTIME in mask arg,
>> > >> those fs could technically return only STATX_PTIME and it should no=
t regress
>> > >> existing programs.
>> > >>
>> > >> But this is still a bit surprising behavior is it not?
>> > >>
>> > >> Thanks,
>> > >> Amir.
>> > >
>> > > I'm not sure what to do with it.
>> > >
>> > > If we allow to change btime of ntfs then for consistency we should a=
lso
>> > > allow to change btime of ext4.
>> > >
>> > > Maybe another idea... define new capability which would allow to cha=
nge
>> > > btime (on any filesystem)? This would at least make the consistency.
>>=20
>> Pali, I think this is a very bad idea.
>
> Ok, if the point is that ext4 btime must stay immutable then it is a bad =
idea.
>
>> This has nothing to do with capabilities.
>> The Windows and MacOS filesystems have allowed setting their
>> "creation time" forever
>
> FreeBSD for some fs allow it too (see below).
>
>> and for all the other Linux filesystems that had
>> "birth time" it was immutable, so let's not mix filesystem features
>> with capabilities.
>
> I think that it is important to first define behavior and invariants of
> these "btime" and "ptime" kernel properties.
>
> If we want to be consistent then there are two possible options:
>
> 1. If we choose that the STATX_BTIME is immutable then no kernel fs
>    driver should allow to change.
>
> 2. If we choose that the "NTFS create time" is reported via STATX_BTIME
>    then STATX_BTIME is not immutable at all.
>
> These two options cannot be chosen together because option 1 would
> implie that the modifiable "NTFS create time" cannot be reported over
> STATX_BTIME.
>
> We are have currently STATX_BTIME immutable and "NTFS create time"
> reported via STATX_BTIME.
>
> If we want to stay _consistent_ across fs drivers then adding API for
> changing "NTFS create time" would break one of those two things.
>
> In my opinion we should stay consistent across filesystem drivers and
> provide unified behavior of APIs independently of used filesystem.
> Otherwise userspace applications would have to write fs specific code
> for doing their use cases (and we can stay with fs-specific xattrs, no
> need to create unified APIs).
>
> Does it make sense? Or it is still a bad idea to think about it in this w=
ay?

Personally I think in this discussion we should separate linux
filesystems vs non-linux filesystems, as linux filesystems are "ours"
and are the ones we can change as we want, while non-linux filesystems
are not made by "us" and cannot be easily changed (like NFS I would say)
or cannot changed at all (e.g. NTFS (well, unless we make ntfs
incompatible with windows lol)).

But I understand why it would be better to keep a unified API across all
filesystems, even "non-official" ones, so I can think of 2 options
(well, with ntfs/exfat in mind, as I don't know much about NFS/smb):

1) keep btime aliased to ptime, which means that (to userspace) btime
   would be mutable for ntfs/exfat/vfat/etc

2) move ntfs/exfat/vfat/etc's cr_time from btime to ptime, effectively
   "removing" btime from those FSs and "keeping" only ptime; in this case
   stat would show "-" for Birth:, but would show the correct timestamp for
   Origin:/Create:/Provenance:/...

I prefer 1) because it probably breaks less scripts, but 2) would be
more correct semantically.

And both break at least 1 existing script anyway (as per https://xkcd.com/1=
172/).

>> >
>> > I think the ext4 and xfs maintainers have repeatedly said that btime/c=
rtime
>> > attribute should not be modified by users.  There was a long discussio=
n on
>> > this from Ted as well, and the reality is that "creation" time is not =
worth
>> > the bits that it is written on,
>>=20
>> This is an opinion of individual people, who did not lay out technical
>> arguments.
>> I have concrete technical arguments in favor of first class creation tim=
e for
>> ext4/xfs from my experience with production systems that need it and use=
 xattr
>> to store it (by smbd), but I am not going to list them here because
>> this is not a
>> thread about implementing mutable creation time for ext4/xfs.

For my (backups, preservation) use case, making btime mutable would also
be fine, but I can see the value of having a "ctime" for creation, hence
this RFC.

>>=20
>> > since it is not preserved by any tools, has
>>=20
>> Facts check:
>>=20
>> # NEWS for rsync 3.2.3 (6 Aug 2020)
>>=20
>> ## Changes in this version:
>> ...
>>  - Added [`--crtimes`](rsync.1#opt) (`-N`) option for preserving the fil=
e's
>>    create time (I believe that this is macOS only at the moment).
>>=20
>> Incidentally, I have an implementation for --crtimes for cifs [1], but t=
his
>> is not extendable to support all the filsystems which support settable c=
rtime.
>
> Another two facts check:
>
> FreeBSD has also API for changing "birth (creation) times".
> It is documented in utimes(2) manpage:
> https://man.freebsd.org/cgi/man.cgi?query=3Dutimes&sektion=3D2
>
> So I guess that there has to be some tool which is using this API and
> therefore these "birth (creation) times" are preserved.
>
>
> NFS4 has time_create attribute (FATTR4_TIME_CREATE=3D50) which is
> per-fs-object read-write attribute and defined (in RFC8881 5.8.2.40.) as:
>   The time of creation of the object. This attribute does not have any
>   relation to the traditional UNIX file attribute "ctime" or "change time=
".
> Since NFSv4.1 it can be even specified during creating a new file/dir
> which seems to be for backup-restore. And permissions (RFC8881 6.2.1.3.1.=
):
>   ACE4_WRITE_ATTRIBUTES
>   Operation(s) affected: SETATTR of time_access_set, time_backup,
>     time_create, time_modify_set, mimetype, hidden, system
>   Discussion: Permission to change the times associated with a file or
>     directory to an arbitrary value. Also permission to change the
>     mimetype, hidden, and system attributes. A user having ACE4_WRITE_DAT=
A
>     or ACE4_WRITE_ATTRIBUTES will be allowed to set the times associated
>     with a file to the current server time.
>
> I'm not sure if there is some backup/restore tool which do it over NFS4
> but the NFS4 description seems to be very clear that the network protocol
> itself is already prepared for these use cases. And permissions mostly
> matches the SMB / NTFS / Windows security model.
>
>> > a "vague" meaning (is it when the *file* was created, when the *conten=
t* was
>> > created, do edits update it, is it preserved across filesystems, archi=
ves,
>> > etc.) and adding it into the filesystem is misplaced effort.
>>=20
>> Sorry now you are talking nonsense. Meaning has nothing to do with it.
>> This is a property of filesystems (plural) which have documented APIs
>> and documented network protocols - it is what it is.
>>=20
>> If you are looking for a meaning, it is the first publication date, whet=
her
>> it means something to you is irrelevant - what's relevant is that custom=
ers
>> use it and want to preserve it in backups, whatever its meaning is.
>
> I agree here. I also heard lot of times that users (customers) want to
> preserve create time in backups and be able to restore it. And that
> Windows is already able to do it, Linux not yet.

Hi I'm one of those users, I still can't believe no-one has implemented
something like this yet since POSIX came out way back when (*cry*).

> Maybe what is a "vague" here is where that "create time" is stored and
> from which (API) source is GUI (or CLI) application showing it to user.
>
>> >
>> > Storing it as an xattr has some reasonable chance of being preserved a=
cross
>> > tar/cp/filesystems, and doesn't introduce a herculean effort of changi=
ng
>> > all of the system calls and on-disk formats for every filesystem.
>> >
>
> I think the part "being preserved across tar/cp/filesystems" is
> relevant. If a completely new API is introduced into Linux then it means
> that every existing backup tool would not be able to preserve this
> property and also would not be able to restore it.
>
> I'm not sure if we can do anything with this issue, but it is important
> to know about this limitation.

My thinking for this RFC would be to then submit relevant patches also
to at least the main tools I use like tar, cp, rsync and vim, which will
hopefully make it gain momentum and be supported also in other less
well-known tools (I would also love for it to be supported by HTTP like
mtime is, but that will likely be a lot more difficult to get accepted
and implemented).

> About the part "introduce a herculean effort of changing all of the
> system calls and on-disk formats for every filesystem.". In my opinion
> it is better to do that cleanup (maybe even in all stat-related
> syscalls) if it makes things easier and prevents another technical
> issues.
>
>>=20
>> As I said I can provide data for why the xattr approach taken by smbd is
>> limited and inferior, but this is not the place to get into it (there ar=
e hints
>> in the rsync commit message below).
>>=20
>> Thanks,
>> Amir.
>>=20
>> [1] https://github.com/amir73il/rsync/commits/cifs-crtimes/
>
> I would say that xattr does not solve this issue too.

I would also like to note again that xattrs aren't available to symlinks
(or other special files), which would break at least my backup/preservation
use case.

Best,
koraynilay

--0aa7e00f32b8c400c0464b8cc772bcee1c017d171ea542856405779d22a4
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQRJ2XvJtXGwULYEerQ0bnTtJTDoOAUCaum/xwAKCRA0bnTtJTDo
OOhEAQDL4i35GyfAYbelFIfhGWNHlhNy/ouA1+wcWW1eaH8iOgEAvU3bJMRD9QCs
OIDX7ELNpTDJ+skUeK6fcUppgnVangA=
=jUS/
-----END PGP SIGNATURE-----

--0aa7e00f32b8c400c0464b8cc772bcee1c017d171ea542856405779d22a4--
