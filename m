Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793719519;
	b=y66rnlRyYUekwDm4jB8YCYeVg+NSnMDEMVIEm+5v6hirls0yInEHTGujnapkjUtuFxaH
	 tQeN/3iFf5Iq1d2s2sbJY99NXaHozB9lSPGexJi5IB+Wg8bTO19eWnOTvBv9wCYws1QOm
	 8/9WbOB61UFf/a1Btd/ZH8x5qdzkT0YwxmKUB/ESuXg25NqYlflalaFrllzLoBJZjT3pJ
	 ATH/JhbToOI7/Xyky4jd8wP3Yn4XEUj04HtVaLXNecb2OaKsjGmwIDC0nWwbxkHOjCJuW
	 7qMy87VYMc0cEpJWQ+CJX9d2rR4mtZCH/MzS+Fd/vo1VxedyKcSKfv08JCiFDW0zavw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793719519;
	h=Received:DKIM-Signature:Received:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:
	 Content-Transfer-Encoding:In-Reply-To:User-Agent;
	bh=Yyg5vPBLNFzUwlKjKhASX8BZA7SN2GhRxs4jgDfztWw=;
	b=sOcv156Tm7HE4FqWvxgqeB/HbF7qP1EfLIdpZA40twQMiwBm6XiN/lTAK8mz3E3+BZHc
	 pGOF9V0xMS/byWC3EwaM11UKatRpGnSavNM6XS/N+7BVLRvD30mjAP4N7Nosynb4TIau5
	 R6Uri5gTQWI3zamI+fn1N2hZFMXqRM62PcupnZ+dCVIm8QHcw3m6xsGseHzQqbLUrmvY3
	 iI+5gFvaAanzkDoLN405yWuQrLMU7McItuZLuuNPwAg6LYJrkLSc74Pv5Kc29O91hh7oT
	 poHCsaZ17gDU76rrOV4JRlrPkyaUZQvxnLi+gpew87ffyImbhuWHN2sZ4nhWaFHraLA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=XLnsqgV3;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91992606A32D;
	Tue,  3 Nov 2026 15:25:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=XLnsqgV3
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF2B81F000C1;
	Tue,  3 Nov 2026 15:25:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793719519;
	bh=Yyg5vPBLNFzUwlKjKhASX8BZA7SN2GhRxs4jgDfztWw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=XLnsqgV3nOgeeNJPXiz+rmWygv3G979aoefBQ00Uwzkl5wn3DHjdilBwlTN/amKq0
	 +GQRolYF7Zhc0viRq8z7Z7lii57lcDM07ZRDv1xzIQHb8iSJKTbdOFuBL+qsURXvDk
	 aesSsHmJCSwA06Rtv/1nKpjEODmuC2uuEWwfRkWN8qe233+xWDj01Y4TF9Ht/PXJr/
	 iAr5PgKDafU/q6IWsjIBfIyh4bJOb0Eank1tZU/WrMgToLRF2IZKKZWGqg7lWWwqZs
	 ZfSac9FongxQj1bn6kR26dMBFKrwh98nx7+usMrwg4bc5nEjKqSLKst7MTp6cFhQek
	 c8NS7mtN92KQQ==
Received: by pali.im (Postfix)
	id 18408809; Tue,  3 Nov 2026 16:25:16 +0100 (CET)
Date: Tue, 3 Nov 2026 16:25:15 +0100
From: Pali =?utf-8?B?Um9ow6Fy?= <pali@kernel.org>
To: Amir Goldstein <amir73il@gmail.com>
Cc: Andreas Dilger <adilger@dilger.ca>, koraynilay <koray.fra@gmail.com>,
	David Sterba <dsterba@suse.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sungjong Seo <sj1557.seo@samsung.com>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Chris Mason <mason@kernel.org>, Jan Kara <jack@suse.cz>,
	Yuezhang Mo <yuezhang.mo@sony.com>, Chuck Lever <cel@kernel.org>,
	"Darrick J . Wong" <djwong@kernel.org>,
	Sean Smith <defendthedisabled@gmail.com>,
	Andrey Albershteyn <aalbersh@kernel.org>,
	Pedro Falcato <pfalcato@suse.de>, linux-btrfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	exfat@lists.linux.dev, ntfs3@lists.linux.dev,
	linux-api@vger.kernel.org
Subject: Re: [RFC PATCH v3 3/5] ntfs3: make crtime user-settable using ptime
Message-ID: <20261103152515.svzvdugqxrwpz5ju@pali>
References: <20261101015551.786044-1-koray.fra@gmail.com>
 <20261101015551.786044-4-koray.fra@gmail.com>
 <20261102142452.d6jkitgdeuquy23i@pali>
 <CAOQ4uxhQ3uhq6s+4deEJAQV5iy8QZoucojR58_dUNYrnjt_yvA@mail.gmail.com>
 <20261102153845.d67wlorqcbe3c2w7@pali>
 <DD1A08F1-8F47-4612-A807-AEA39461AF9B@dilger.ca>
 <CAOQ4uxh8EDX5HzFFKWv10-mHYVcSC1zXN+BS2qCm5cTMq=GOCA@mail.gmail.com>
 <20261103094906.n55n5dhrpct5ykmw@pali>
 <CAOQ4uxizEdR-MauSMOTfVcdxnuSMkrEuPth3nm3MsZuhcN5vjA@mail.gmail.com>
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Post: <mailto:linux-api@vger.kernel.org>
List-Help: <mailto:linux-api+help@vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-api+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAOQ4uxizEdR-MauSMOTfVcdxnuSMkrEuPth3nm3MsZuhcN5vjA@mail.gmail.com>
User-Agent: NeoMutt/20180716

On Tuesday 03 November 2026 16:10:24 Amir Goldstein wrote:
> On Tue, Nov 3, 2026 at 10:49 AM Pali Rohár <pali@kernel.org> wrote:
> >
> > On Tuesday 03 November 2026 09:23:32 Amir Goldstein wrote:
> > > On Tue, Nov 3, 2026 at 2:19 AM Andreas Dilger <adilger@dilger.ca> wrote:
> > > >
> > > > On Nov 2, 2026, at 09:38, Pali Rohár <pali@kernel.org> wrote:
> > > > >
> > > > > On Monday 02 November 2026 16:09:41 Amir Goldstein wrote:
> > > > >> On Mon, Nov 2, 2026 at 3:24 PM Pali Rohár <pali@kernel.org> wrote:
> > > > >>>
> > > > >>> On Sunday 01 November 2026 02:55:49 koraynilay wrote:
> > > > >>>> @@ -154,6 +158,11 @@ int ntfs_fileattr_set(const struct mnt_idmap *idmap, struct dentry *dentry,
> > > > >>>>      if (flags & FS_APPEND_FL)
> > > > >>>>              new_fl |= S_APPEND;
> > > > >>>>
> > > > >>>> +     if (fa->fsx_xflags & FS_XFLAG_PTIME) {
> > > > >>>> +             ni->i_crtime.tv_sec = fa->fsx_ptime.tv_sec;
> > > > >>>> +             ni->i_crtime.tv_nsec = fa->fsx_ptime.tv_nsec;
> > > > >>>> +     }
> > > > >>>> +
> > > > >>>>      inode_set_flags(inode, new_fl, S_IMMUTABLE | S_APPEND);
> > > > >>>>
> > > > >>>>      /* Save nodump flag to return in ntfs_getattr. */
> > > > >>>> @@ -275,8 +284,9 @@ int ntfs_getattr(const struct mnt_idmap *idmap, const struct path *path,
> > > > >>>>      if (unlikely(is_bad_ni(ni)))
> > > > >>>>              return -EINVAL;
> > > > >>>>
> > > > >>>> -     stat->result_mask |= STATX_BTIME;
> > > > >>>> +     stat->result_mask |= (STATX_BTIME | STATX_PTIME);
> > > > >>>>      stat->btime = ni->i_crtime;
> > > > >>>> +     stat->ptime = ni->i_crtime;
> > > > >>>
> > > > >>> For me this patch looks dangerous. Somehow I would expect that the
> > > > >>> "btime" will never change for existing inode.
> > > > >>>
> > > > >>> But because the ptime is mapped to i_crtime and ptime is settable from
> > > > >>> userspace, with this patch it is directly possible to change btime.
> > > > >>>
> > > > >>>
> > > > >>>
> > > > >>> I was thinking more about it... Is not this just misunderstanding of how
> > > > >>> the security model around the times is working on different systems?
> > > > >>> Because on NTFS there is stored just one field which says when the file
> > > > >>> was created. There are not two fields like "time set by user and time
> > > > >>> set by system".
> > > > >>>
> > > > >>> Windows security model allows anybody with WRITE_ATTRIBUTES access to
> > > > >>> change that create time. Linux security model does not allow to change it.
> > > > >>>
> > > > >>> NTFS in this view is just a filesystem like any other (ext4, btrfs, ...).
> > > > >>> In my opinion if the ext4 or btrfs filesystem is correctly implemented
> > > > >>> on Windows systems, then Windows security model should handle it in the
> > > > >>> same way like for NTFS or exFAT. So if something grants WRITE_ATTRIBUTES
> > > > >>> access, then Windows should allow to change also btime on ext4 or btrfs.
> > > > >>>
> > > > >>>
> > > > >>>
> > > > >>> On the other hand, I understand the use case to have two creation times.
> > > > >>> One time which would never be changed and could be used for any kind of
> > > > >>> atomic / synchronization by userspace application logic (this btime).
> > > > >>> And another time for human which can be changed at any time to any value
> > > > >>> which user wants (this ptime).
> > > > >>>
> > > > >>> In any case, I would suggest that filesystem driver would not report to
> > > > >>> userspace unsupported values and would not try to invent other values
> > > > >>> and lying about them.
> > > > >>
> > > > >> But all those fs with mutable creation time already report it with STATX_BTIME
> > > > >> so what can we do about this?
> > > > >
> > > > > Well, what I wanted above to point out is that the "mutability" of
> > > > > creation time is not feature of filesystem, but in my opinion rather
> > > > > property of the security model on the running operating system.
> > > > >
> > > > > Maybe better question is: how ext4 btimes differs from the ntfs btime?
> > > > > In my opinion there is no much difference, both of them has meaning
> > > > > "time when was the file created".
> > > > >
> > > > >> If userspace requests both STATX_BTIME|STATX_PTIME in mask arg,
> > > > >> those fs could technically return only STATX_PTIME and it should not regress
> > > > >> existing programs.
> > > > >>
> > > > >> But this is still a bit surprising behavior is it not?
> > > > >>
> > > > >> Thanks,
> > > > >> Amir.
> > > > >
> > > > > I'm not sure what to do with it.
> > > > >
> > > > > If we allow to change btime of ntfs then for consistency we should also
> > > > > allow to change btime of ext4.
> > > > >
> > > > > Maybe another idea... define new capability which would allow to change
> > > > > btime (on any filesystem)? This would at least make the consistency.
> > >
> > > Pali, I think this is a very bad idea.
> >
> > Ok, if the point is that ext4 btime must stay immutable then it is a bad idea.
> >
> > > This has nothing to do with capabilities.
> > > The Windows and MacOS filesystems have allowed setting their
> > > "creation time" forever
> >
> > FreeBSD for some fs allow it too (see below).
> >
> > > and for all the other Linux filesystems that had
> > > "birth time" it was immutable, so let's not mix filesystem features
> > > with capabilities.
> >
> > I think that it is important to first define behavior and invariants of
> > these "btime" and "ptime" kernel properties.
> >
> > If we want to be consistent then there are two possible options:
> >
> > 1. If we choose that the STATX_BTIME is immutable then no kernel fs
> >    driver should allow to change.
> >
> > 2. If we choose that the "NTFS create time" is reported via STATX_BTIME
> >    then STATX_BTIME is not immutable at all.
> >
> > These two options cannot be chosen together because option 1 would
> > implie that the modifiable "NTFS create time" cannot be reported over
> > STATX_BTIME.
> >
> > We are have currently STATX_BTIME immutable and "NTFS create time"
> > reported via STATX_BTIME.
> >
> > If we want to stay _consistent_ across fs drivers then adding API for
> > changing "NTFS create time" would break one of those two things.
> >
> > In my opinion we should stay consistent across filesystem drivers and
> > provide unified behavior of APIs independently of used filesystem.
> > Otherwise userspace applications would have to write fs specific code
> > for doing their use cases (and we can stay with fs-specific xattrs, no
> > need to create unified APIs).
> >
> > Does it make sense? Or it is still a bad idea to think about it in this way?
> >
> 
> My "bad idea" comment was only referring to capability.
> 
> w.r.t the STATX_BTIME ambiguity there is another option we may want to
> consider: Don't publish STATX_PTIME via statx() at all.
> 
> One of the reasons that developers have pointed to fileattr as the right API
> to host the creation time as well as the DOS attributes is that it has a history
> of carrying filesystem specific attributes.
> 
> Not every attribute available in lsattr is also available in statx().
> If projid is not available in statx() then the settable creation time
> doesn't need to be in statx() either.
> 
> The file_[sg]etattr() syscalls provides a symmetric API to set/get it.
> 
> The same could be true to HIDDEN/ARCHIVE/SYSTEM flags if those
> are added to fileattr.
> 
> Do we need to stop publishing NTFS creation time in STATX_BTIME?
> I think it's too late for that and nobody is going to gain anything
> from doing that.
> 
> Thanks,
> Amir.

Kernel NTFS driver changed more times, so I would not say that it is too
late to stop publishing NTFS creation time in STATX_BTIME, and start
publishing it in STATX_PTIME.


Anyway, I have another idea (if stopping publishing of NTFS is not possible):
Let fs drivers to fill ptime and btime members only when fs itself
supports particular field (ext4 would fill only btime, nfts would fill
only ptime; btrfs with patch would fill both). For userspace STATX_BTIME
request, VFS will copy ptime to btime if the btime is not provided.
For userspace STATX_PTIME request or STATX_BTIME|STATX_PTIME request,
the VFS will not do this copy. Or We can introduce new flag
STATX_NO_FAKE_BTIME (just random name for now) and this would cause that
the ptime would not be copied to btime (so it would not be needed to
misuse STATX_BTIME|STATX_PTIME). The logic would be unified in VFS
layer, not in the fs drivers.
