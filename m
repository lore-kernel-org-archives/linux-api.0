Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793727127;
	b=OwHJze3eFTHtU+tZcPWlOZpTrHZ1qLVt1wsIPSpei7VXv78TLNIU4HoGBQ2UBiLwgEJ5
	 FAgvXoKMXFF17anK801qDJTvHareD1fuqNAHNDXlEALwSLoEvRrdEtBymzzYU7h8E87du
	 pYGXZyg6JWLhYwAteeV2vdQJDwelmeyNvCF/oyFzRVuxnwtNitR4Ci+cFkv69OT2v3iI6
	 rM+ZKNDBisIEKM7AW3obPi0SZvzAJqk7Fi0udE49MIabSIXVNkQMh+7EsQG6RYb+ew0sO
	 4Gdh3EXeBk8oDebNQdtgBepeaB1z6PFJg+0i6aEnTXQsllTHUsoePeiWhOZrZKQGQOw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793727127;
	h=Received:DKIM-Signature:Received:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:
	 Content-Transfer-Encoding:In-Reply-To:User-Agent;
	bh=sAR3tacHx0il6lbaS7qXOE5kN4T/yWj/+9dPEXaBm6s=;
	b=1Rmnz711P8SKif3v7I1KLGJk+rtADd9sKe2YoDhMk9rUEaqxH98N4/PCbvTBOUCJQT7R
	 FzE2CNYLTO44K4sFccgYbZIs9CeCzLtB4yaNszSIaK+2oq7Jw+znzg4EOTZB9is8Alt7p
	 0muVFcN6fa9pfNNWGNZW4GqInYTCEoMJ6A6SnKEo7n/oSRifrnYMIb/9PILdFv2ToqbVi
	 dmplybpRbMcIhlRjXVVpOXbUmWZHul0Sb6W0YoYzsxokebBCH5aatNnZTv6czrswZ/mx1
	 Vv8F2tRd4JPUfklTeC2UgqisNtvoLCa8NN3DBngkWPolUbCpFMNjhAERog0wxQClUxw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=AeMVfRI1;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D2C4606A31B;
	Tue,  3 Nov 2026 17:32:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=AeMVfRI1
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84A771F00919;
	Tue,  3 Nov 2026 17:32:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793727126;
	bh=sAR3tacHx0il6lbaS7qXOE5kN4T/yWj/+9dPEXaBm6s=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=AeMVfRI1knSdwz2Yl3uQs2OZCqPV8f6MGwMyA+DX5+VfQs3+6n/PNysIeFqQijF6F
	 WLIkLOF0eweFJZSSiJThMsehJVtuglopUf2GjJXVpDpgUmxKnUAROxBsBh/b7uBOjF
	 rekgySOxgKUVDVQhvf4/enficrKzBiMi7qssNuhCxGInozNpojKWG1gBnGGsiABZ8/
	 UsUWcH1r8GwTFMU1i6fInUwI53uFE+H07F1hweKlbR7PN4djAUZYFS96i2saClU+yi
	 moXUhqZfPdkobcjm+TaSHL1aZCSYBcaGlFTk44FFL0aqzjQ3VLOW22Z5dZbWw7NT40
	 h3/EmOF3ntj2Q==
Received: by pali.im (Postfix)
	id BD40C809; Tue,  3 Nov 2026 18:32:03 +0100 (CET)
Date: Tue, 3 Nov 2026 18:32:03 +0100
From: Pali =?utf-8?B?Um9ow6Fy?= <pali@kernel.org>
To: koraynilay <koray.fra@gmail.com>
Cc: Amir Goldstein <amir73il@gmail.com>, Andreas Dilger <adilger@dilger.ca>,
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
Message-ID: <20261103173203.c4lldr63tocfstok@pali>
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
In-Reply-To: <DMLQY7IRCAX1.1B2J5G5VNEVAS@gmail.com>
User-Agent: NeoMutt/20180716

On Tuesday 03 November 2026 18:20:24 koraynilay wrote:
> On Tue Nov 3, 2026 at 4:10 PM CET, Amir Goldstein wrote:
> > On Tue, Nov 3, 2026 at 10:49 AM Pali Rohár <pali@kernel.org> wrote:
> >>
> >> On Tuesday 03 November 2026 09:23:32 Amir Goldstein wrote:
> >> > On Tue, Nov 3, 2026 at 2:19 AM Andreas Dilger <adilger@dilger.ca> wrote:
> >> > >
> >> > > On Nov 2, 2026, at 09:38, Pali Rohár <pali@kernel.org> wrote:
> >> > > >
> >> > > > On Monday 02 November 2026 16:09:41 Amir Goldstein wrote:
> >> > > >> On Mon, Nov 2, 2026 at 3:24 PM Pali Rohár <pali@kernel.org> wrote:
> >> > > >>>
> >> > > >>> On Sunday 01 November 2026 02:55:49 koraynilay wrote:
> >> > > >>>> @@ -154,6 +158,11 @@ int ntfs_fileattr_set(const struct mnt_idmap *idmap, struct dentry *dentry,
> >> > > >>>>      if (flags & FS_APPEND_FL)
> >> > > >>>>              new_fl |= S_APPEND;
> >> > > >>>>
> >> > > >>>> +     if (fa->fsx_xflags & FS_XFLAG_PTIME) {
> >> > > >>>> +             ni->i_crtime.tv_sec = fa->fsx_ptime.tv_sec;
> >> > > >>>> +             ni->i_crtime.tv_nsec = fa->fsx_ptime.tv_nsec;
> >> > > >>>> +     }
> >> > > >>>> +
> >> > > >>>>      inode_set_flags(inode, new_fl, S_IMMUTABLE | S_APPEND);
> >> > > >>>>
> >> > > >>>>      /* Save nodump flag to return in ntfs_getattr. */
> >> > > >>>> @@ -275,8 +284,9 @@ int ntfs_getattr(const struct mnt_idmap *idmap, const struct path *path,
> >> > > >>>>      if (unlikely(is_bad_ni(ni)))
> >> > > >>>>              return -EINVAL;
> >> > > >>>>
> >> > > >>>> -     stat->result_mask |= STATX_BTIME;
> >> > > >>>> +     stat->result_mask |= (STATX_BTIME | STATX_PTIME);
> >> > > >>>>      stat->btime = ni->i_crtime;
> >> > > >>>> +     stat->ptime = ni->i_crtime;
> >> > > >>>
> >> > > >>> For me this patch looks dangerous. Somehow I would expect that the
> >> > > >>> "btime" will never change for existing inode.
> >> > > >>>
> >> > > >>> But because the ptime is mapped to i_crtime and ptime is settable from
> >> > > >>> userspace, with this patch it is directly possible to change btime.
> >> > > >>>
> >> > > >>>
> >> > > >>>
> >> > > >>> I was thinking more about it... Is not this just misunderstanding of how
> >> > > >>> the security model around the times is working on different systems?
> >> > > >>> Because on NTFS there is stored just one field which says when the file
> >> > > >>> was created. There are not two fields like "time set by user and time
> >> > > >>> set by system".
> >> > > >>>
> >> > > >>> Windows security model allows anybody with WRITE_ATTRIBUTES access to
> >> > > >>> change that create time. Linux security model does not allow to change it.
> >> > > >>>
> >> > > >>> NTFS in this view is just a filesystem like any other (ext4, btrfs, ...).
> >> > > >>> In my opinion if the ext4 or btrfs filesystem is correctly implemented
> >> > > >>> on Windows systems, then Windows security model should handle it in the
> >> > > >>> same way like for NTFS or exFAT. So if something grants WRITE_ATTRIBUTES
> >> > > >>> access, then Windows should allow to change also btime on ext4 or btrfs.
> >> > > >>>
> >> > > >>>
> >> > > >>>
> >> > > >>> On the other hand, I understand the use case to have two creation times.
> >> > > >>> One time which would never be changed and could be used for any kind of
> >> > > >>> atomic / synchronization by userspace application logic (this btime).
> >> > > >>> And another time for human which can be changed at any time to any value
> >> > > >>> which user wants (this ptime).
> >> > > >>>
> >> > > >>> In any case, I would suggest that filesystem driver would not report to
> >> > > >>> userspace unsupported values and would not try to invent other values
> >> > > >>> and lying about them.
> >> > > >>
> >> > > >> But all those fs with mutable creation time already report it with STATX_BTIME
> >> > > >> so what can we do about this?
> >> > > >
> >> > > > Well, what I wanted above to point out is that the "mutability" of
> >> > > > creation time is not feature of filesystem, but in my opinion rather
> >> > > > property of the security model on the running operating system.
> >> > > >
> >> > > > Maybe better question is: how ext4 btimes differs from the ntfs btime?
> >> > > > In my opinion there is no much difference, both of them has meaning
> >> > > > "time when was the file created".
> >> > > >
> >> > > >> If userspace requests both STATX_BTIME|STATX_PTIME in mask arg,
> >> > > >> those fs could technically return only STATX_PTIME and it should not regress
> >> > > >> existing programs.
> >> > > >>
> >> > > >> But this is still a bit surprising behavior is it not?
> >> > > >>
> >> > > >> Thanks,
> >> > > >> Amir.
> >> > > >
> >> > > > I'm not sure what to do with it.
> >> > > >
> >> > > > If we allow to change btime of ntfs then for consistency we should also
> >> > > > allow to change btime of ext4.
> >> > > >
> >> > > > Maybe another idea... define new capability which would allow to change
> >> > > > btime (on any filesystem)? This would at least make the consistency.
> >> >
> >> > Pali, I think this is a very bad idea.
> >>
> >> Ok, if the point is that ext4 btime must stay immutable then it is a bad idea.
> >>
> >> > This has nothing to do with capabilities.
> >> > The Windows and MacOS filesystems have allowed setting their
> >> > "creation time" forever
> >>
> >> FreeBSD for some fs allow it too (see below).
> >>
> >> > and for all the other Linux filesystems that had
> >> > "birth time" it was immutable, so let's not mix filesystem features
> >> > with capabilities.
> >>
> >> I think that it is important to first define behavior and invariants of
> >> these "btime" and "ptime" kernel properties.
> >>
> >> If we want to be consistent then there are two possible options:
> >>
> >> 1. If we choose that the STATX_BTIME is immutable then no kernel fs
> >>    driver should allow to change.
> >>
> >> 2. If we choose that the "NTFS create time" is reported via STATX_BTIME
> >>    then STATX_BTIME is not immutable at all.
> >>
> >> These two options cannot be chosen together because option 1 would
> >> implie that the modifiable "NTFS create time" cannot be reported over
> >> STATX_BTIME.
> >>
> >> We are have currently STATX_BTIME immutable and "NTFS create time"
> >> reported via STATX_BTIME.
> >>
> >> If we want to stay _consistent_ across fs drivers then adding API for
> >> changing "NTFS create time" would break one of those two things.
> >>
> >> In my opinion we should stay consistent across filesystem drivers and
> >> provide unified behavior of APIs independently of used filesystem.
> >> Otherwise userspace applications would have to write fs specific code
> >> for doing their use cases (and we can stay with fs-specific xattrs, no
> >> need to create unified APIs).
> >>
> >> Does it make sense? Or it is still a bad idea to think about it in this way?
> >>
> >
> > My "bad idea" comment was only referring to capability.
> >
> > w.r.t the STATX_BTIME ambiguity there is another option we may want to
> > consider: Don't publish STATX_PTIME via statx() at all.
> >
> > One of the reasons that developers have pointed to fileattr as the right API
> > to host the creation time as well as the DOS attributes is that it has a history
> > of carrying filesystem specific attributes.
> >
> > Not every attribute available in lsattr is also available in statx().
> > If projid is not available in statx() then the settable creation time
> > doesn't need to be in statx() either.
> >
> > The file_[sg]etattr() syscalls provides a symmetric API to set/get it.
> 
> btime currently is also a fliesystem specific implementation tho, and
> there was already a transition from stat to statx when btime was added,
> so I think ptime should be included in statx, especially since it should
> be treated as one of the standard timestamps from now on (or at least,
> that's what I hope to achieve eventually).
> The only difference to the currently standard timestamps would be that
> a/mtime are managed by utimensat, ctime/btime by the filesystems
> themselves (as they're more "internal" and less "user-facing") and ptime
> would be managed by file_[gs]etattr() (since changing utimensat wouldn't
> make sense as said in the april thread).

Not related to these changes, but I think it would make sense to adjust
also utimensat man page documentation and mention there what kind of
syscall/function will be used for changing ptime. From my experience,
such cross reference can help developers. Also the fact is that FreeBSD
changes birth time via utimes syscall could mean that developers could
look for similar Linux functionality in linux utime* manpages.

> Thanks,
> koraynilay
> 
> > The same could be true to HIDDEN/ARCHIVE/SYSTEM flags if those
> > are added to fileattr.
> >
> > Do we need to stop publishing NTFS creation time in STATX_BTIME?
> > I think it's too late for that and nobody is going to gain anything
> > from doing that.
> >
> > Thanks,
> > Amir.
> 
> 
