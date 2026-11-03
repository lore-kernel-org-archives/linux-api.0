Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793710100;
	b=yB0yFoHT67wACBsURb24f4PiuKNpwJ2IddStBh3VFYwXVXUkBhB8X9kl8yZ34ciDY9Q+
	 eceNfFpAAUSUGY8TZJrQDgboUpxRvZVDAcPjio+K8/gsh/OARqfbQqfPUXzWCoKsdf5tq
	 ilJnzlVxiKLTnzV6e137F3dxLk8+kbFsLREQ5eNLX5rx6HokZPi0yeWZuSzkEY1XWHTm7
	 tjhbng9my73RxTBQfuPYEn1YZMPYy96/OUeJfdO9umfKqF7DWva1zeFoEEUiVvW1PBI1j
	 h8r/WUfTjaEVLyEFF4X/wDU8wDSlrzBQdJ5s/A3HIcuoGsNsM+nNckrGyUVIeFfJRvA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793710100;
	h=Received:DKIM-Signature:Received:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:
	 Content-Transfer-Encoding:In-Reply-To:User-Agent;
	bh=qPEAkYGZ72UK8gD0+5bT2DhWFrkZ77BNq3LmKXuYI4I=;
	b=2baRH9L5dyXUNqoJ+FeVynALwps/vw2G/zkzBEPEdpZ933ik5uvn9YKjzR6mEGnFoa1r
	 zZddri0GMUuSZyceOxTcagt17RBCgfaWqFd7t5QxCajC1mMb/2hA9t9XLoJHFB0VfK+9f
	 R2CT9AGNtOr1efoAUMgfYdNfAAWlL7nVn02cVUnUIzRxncUk1YsBqHa4HyVnR2/1TYINC
	 FgWEsEL1IbfoKgsbMbGKqbPmqmf939e7f2uw6bPUHlm1hxyz0HK68a6y6DW3xnOZkvRZd
	 dY/ntmkqKl1bzLfSdMmiqWmbg6eWGp+Ef9PZNhWVPFQQwydHgEhyYqI+CxiyIRq6DlQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ZmkpekEP;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81802606A327;
	Tue,  3 Nov 2026 12:48:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ZmkpekEP
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 044681F000C1;
	Tue,  3 Nov 2026 12:48:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793710099;
	bh=qPEAkYGZ72UK8gD0+5bT2DhWFrkZ77BNq3LmKXuYI4I=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=ZmkpekEPnv4wIeZdD9Stx/zDqVnNcNE7hDXMRyqYsPofcZv8iw6es5MmGZIOtK9w8
	 +r36f5LsZeeZRVZLHcz1zLg7Cv8WhLBN/5738r/jgQZ1f1REDNjAVE10HzdxdZzaeW
	 apDMTJIcNdCxp5cVvzhltanbrygIA+0bzDWcNqcZOC702pYor7x4TF+V3awFuLUICP
	 nyLtfwIKexZ6Nh4s7imdNrCFA1hlGNm1Xiuo6Zxk8qcdiTelH/WHFTvTKkMWPZZR1u
	 tGmMKyfx6hkUuIfEefCoqLPWItG1GBlihGyBM08DwKGLBuwhTIAp0BC+Ak+nTtzZTj
	 ODQwljsra6kJw==
Received: by pali.im (Postfix)
	id 2B4D5809; Tue,  3 Nov 2026 13:48:16 +0100 (CET)
Date: Tue, 3 Nov 2026 13:48:16 +0100
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
Message-ID: <20261103124816.m27zk5c75lzee272@pali>
References: <20261101015551.786044-4-koray.fra@gmail.com>
 <20261102142452.d6jkitgdeuquy23i@pali>
 <CAOQ4uxhQ3uhq6s+4deEJAQV5iy8QZoucojR58_dUNYrnjt_yvA@mail.gmail.com>
 <20261102153845.d67wlorqcbe3c2w7@pali>
 <DD1A08F1-8F47-4612-A807-AEA39461AF9B@dilger.ca>
 <CAOQ4uxh8EDX5HzFFKWv10-mHYVcSC1zXN+BS2qCm5cTMq=GOCA@mail.gmail.com>
 <20261103094906.n55n5dhrpct5ykmw@pali>
 <DMLIYIKP2CN8.3VGUCOLTMZC5J@gmail.com>
 <20261103113835.7kndzvvegrkwjlsd@pali>
 <DMLKDOZWVDTU.GLUJUDOZES2V@gmail.com>
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
In-Reply-To: <DMLKDOZWVDTU.GLUJUDOZES2V@gmail.com>
User-Agent: NeoMutt/20180716

On Tuesday 03 November 2026 13:11:30 koraynilay wrote:
> On Tue Nov 3, 2026 at 12:38 PM CET, Pali Rohár wrote:
> > On Tuesday 03 November 2026 12:04:39 koraynilay wrote:
> >> Hi and sorry for the late reply,
> >> 
> >> On Tue Nov 3, 2026 at 10:49 AM CET, Pali Rohár wrote:
> >> > On Tuesday 03 November 2026 09:23:32 Amir Goldstein wrote:
> >> >> On Tue, Nov 3, 2026 at 2:19 AM Andreas Dilger <adilger@dilger.ca> wrote:
> >> >> >
> >> >> > On Nov 2, 2026, at 09:38, Pali Rohár <pali@kernel.org> wrote:
> >> >> > >
> >> >> > > On Monday 02 November 2026 16:09:41 Amir Goldstein wrote:
> >> >> > >> On Mon, Nov 2, 2026 at 3:24 PM Pali Rohár <pali@kernel.org> wrote:
> >> >> > >>>
> >> >> > >>> On Sunday 01 November 2026 02:55:49 koraynilay wrote:
> >> >> > >>>> @@ -154,6 +158,11 @@ int ntfs_fileattr_set(const struct mnt_idmap *idmap, struct dentry *dentry,
> >> >> > >>>>      if (flags & FS_APPEND_FL)
> >> >> > >>>>              new_fl |= S_APPEND;
> >> >> > >>>>
> >> >> > >>>> +     if (fa->fsx_xflags & FS_XFLAG_PTIME) {
> >> >> > >>>> +             ni->i_crtime.tv_sec = fa->fsx_ptime.tv_sec;
> >> >> > >>>> +             ni->i_crtime.tv_nsec = fa->fsx_ptime.tv_nsec;
> >> >> > >>>> +     }
> >> >> > >>>> +
> >> >> > >>>>      inode_set_flags(inode, new_fl, S_IMMUTABLE | S_APPEND);
> >> >> > >>>>
> >> >> > >>>>      /* Save nodump flag to return in ntfs_getattr. */
> >> >> > >>>> @@ -275,8 +284,9 @@ int ntfs_getattr(const struct mnt_idmap *idmap, const struct path *path,
> >> >> > >>>>      if (unlikely(is_bad_ni(ni)))
> >> >> > >>>>              return -EINVAL;
> >> >> > >>>>
> >> >> > >>>> -     stat->result_mask |= STATX_BTIME;
> >> >> > >>>> +     stat->result_mask |= (STATX_BTIME | STATX_PTIME);
> >> >> > >>>>      stat->btime = ni->i_crtime;
> >> >> > >>>> +     stat->ptime = ni->i_crtime;
> >> >> > >>>
> >> >> > >>> For me this patch looks dangerous. Somehow I would expect that the
> >> >> > >>> "btime" will never change for existing inode.
> >> >> > >>>
> >> >> > >>> But because the ptime is mapped to i_crtime and ptime is settable from
> >> >> > >>> userspace, with this patch it is directly possible to change btime.
> >> >> > >>>
> >> >> > >>>
> >> >> > >>>
> >> >> > >>> I was thinking more about it... Is not this just misunderstanding of how
> >> >> > >>> the security model around the times is working on different systems?
> >> >> > >>> Because on NTFS there is stored just one field which says when the file
> >> >> > >>> was created. There are not two fields like "time set by user and time
> >> >> > >>> set by system".
> >> >> > >>>
> >> >> > >>> Windows security model allows anybody with WRITE_ATTRIBUTES access to
> >> >> > >>> change that create time. Linux security model does not allow to change it.
> >> >> > >>>
> >> >> > >>> NTFS in this view is just a filesystem like any other (ext4, btrfs, ...).
> >> >> > >>> In my opinion if the ext4 or btrfs filesystem is correctly implemented
> >> >> > >>> on Windows systems, then Windows security model should handle it in the
> >> >> > >>> same way like for NTFS or exFAT. So if something grants WRITE_ATTRIBUTES
> >> >> > >>> access, then Windows should allow to change also btime on ext4 or btrfs.
> >> >> > >>>
> >> >> > >>>
> >> >> > >>>
> >> >> > >>> On the other hand, I understand the use case to have two creation times.
> >> >> > >>> One time which would never be changed and could be used for any kind of
> >> >> > >>> atomic / synchronization by userspace application logic (this btime).
> >> >> > >>> And another time for human which can be changed at any time to any value
> >> >> > >>> which user wants (this ptime).
> >> >> > >>>
> >> >> > >>> In any case, I would suggest that filesystem driver would not report to
> >> >> > >>> userspace unsupported values and would not try to invent other values
> >> >> > >>> and lying about them.
> >> >> > >>
> >> >> > >> But all those fs with mutable creation time already report it with STATX_BTIME
> >> >> > >> so what can we do about this?
> >> >> > >
> >> >> > > Well, what I wanted above to point out is that the "mutability" of
> >> >> > > creation time is not feature of filesystem, but in my opinion rather
> >> >> > > property of the security model on the running operating system.
> >> >> > >
> >> >> > > Maybe better question is: how ext4 btimes differs from the ntfs btime?
> >> >> > > In my opinion there is no much difference, both of them has meaning
> >> >> > > "time when was the file created".
> >> >> > >
> >> >> > >> If userspace requests both STATX_BTIME|STATX_PTIME in mask arg,
> >> >> > >> those fs could technically return only STATX_PTIME and it should not regress
> >> >> > >> existing programs.
> >> >> > >>
> >> >> > >> But this is still a bit surprising behavior is it not?
> >> >> > >>
> >> >> > >> Thanks,
> >> >> > >> Amir.
> >> >> > >
> >> >> > > I'm not sure what to do with it.
> >> >> > >
> >> >> > > If we allow to change btime of ntfs then for consistency we should also
> >> >> > > allow to change btime of ext4.
> >> >> > >
> >> >> > > Maybe another idea... define new capability which would allow to change
> >> >> > > btime (on any filesystem)? This would at least make the consistency.
> >> >> 
> >> >> Pali, I think this is a very bad idea.
> >> >
> >> > Ok, if the point is that ext4 btime must stay immutable then it is a bad idea.
> >> >
> >> >> This has nothing to do with capabilities.
> >> >> The Windows and MacOS filesystems have allowed setting their
> >> >> "creation time" forever
> >> >
> >> > FreeBSD for some fs allow it too (see below).
> >> >
> >> >> and for all the other Linux filesystems that had
> >> >> "birth time" it was immutable, so let's not mix filesystem features
> >> >> with capabilities.
> >> >
> >> > I think that it is important to first define behavior and invariants of
> >> > these "btime" and "ptime" kernel properties.
> >> >
> >> > If we want to be consistent then there are two possible options:
> >> >
> >> > 1. If we choose that the STATX_BTIME is immutable then no kernel fs
> >> >    driver should allow to change.
> >> >
> >> > 2. If we choose that the "NTFS create time" is reported via STATX_BTIME
> >> >    then STATX_BTIME is not immutable at all.
> >> >
> >> > These two options cannot be chosen together because option 1 would
> >> > implie that the modifiable "NTFS create time" cannot be reported over
> >> > STATX_BTIME.
> >> >
> >> > We are have currently STATX_BTIME immutable and "NTFS create time"
> >> > reported via STATX_BTIME.
> >> >
> >> > If we want to stay _consistent_ across fs drivers then adding API for
> >> > changing "NTFS create time" would break one of those two things.
> >> >
> >> > In my opinion we should stay consistent across filesystem drivers and
> >> > provide unified behavior of APIs independently of used filesystem.
> >> > Otherwise userspace applications would have to write fs specific code
> >> > for doing their use cases (and we can stay with fs-specific xattrs, no
> >> > need to create unified APIs).
> >> >
> >> > Does it make sense? Or it is still a bad idea to think about it in this way?
> >> 
> >> Personally I think in this discussion we should separate linux
> >> filesystems vs non-linux filesystems, as linux filesystems are "ours"
> >> and are the ones we can change as we want, while non-linux filesystems
> >> are not made by "us" and cannot be easily changed (like NFS I would say)
> >> or cannot changed at all (e.g. NTFS (well, unless we make ntfs
> >> incompatible with windows lol)).
> >> 
> >> But I understand why it would be better to keep a unified API across all
> >> filesystems, even "non-official" ones, so I can think of 2 options
> >> (well, with ntfs/exfat in mind, as I don't know much about NFS/smb):
> >
> > SMB for timestamps has exactly same meaning and storage format as NTFS.
> > So it should be pretty straightforward what to do with it.
> > NFS3 does not have btime at all. And NFS4 has FATTR4_TIME_CREATE attr
> > which I described in previous email (there is no more info). So based on
> > the decision of 1 or 2, that NFS4 attr would either map to btime or ptime.
> 
> Ah ok, thanks.
> 
> >> 
> >> 1) keep btime aliased to ptime, which means that (to userspace) btime
> >>    would be mutable for ntfs/exfat/vfat/etc
> >> 
> >> 2) move ntfs/exfat/vfat/etc's cr_time from btime to ptime, effectively
> >>    "removing" btime from those FSs and "keeping" only ptime; in this case
> >>    stat would show "-" for Birth:, but would show the correct timestamp for
> >>    Origin:/Create:/Provenance:/...
> >> 
> >> I prefer 1) because it probably breaks less scripts, but 2) would be
> >> more correct semantically.
> >
> > My personal opinion is 2) because the btime stay immutable also in
> > userspace and is also more correct semantically.
> >
> > Another argument why 2) should be less breaking change: Userspace
> > applications have to already expect that the btime is not filled at all
> > (e.g. when filesystem does not support it or when application is running
> > on older kernel version without such support).
> 
> Right, I didn't think of that.
> 
> > My opinion is that if the _new_ API provides two different timestamps
> > based on the filesystem then we should report it as is, so userspace can
> > decide how to want to process them. For example full 1:1 clone backup
> > application would want to preserve both btime and ptime and correctly
> > indicate if one of them is not available (e.g. because underlying fs
> > support only one of those times, like NTFS). And such full 1:1 clone
> > backup application do not want to "invent" some unavailable values.
> > Option 1) would not allow to do that for such applications.
> 
> Ok yes I agree, I'll update the ntfs/exfat patches to switch btime for
> ptime then.

Well, what I wrote is my personal opinion, not the decision from this list.

> >> And both break at least 1 existing script anyway (as per https://xkcd.com/1172/).
> >
> > Yes. And that is because we want a new feature which allows changing
> > something which was immutable. So we need to handle it somehow.
> >
> >> >> >
> >> >> > I think the ext4 and xfs maintainers have repeatedly said that btime/crtime
> >> >> > attribute should not be modified by users.  There was a long discussion on
> >> >> > this from Ted as well, and the reality is that "creation" time is not worth
> >> >> > the bits that it is written on,
> >> >> 
> >> >> This is an opinion of individual people, who did not lay out technical
> >> >> arguments.
> >> >> I have concrete technical arguments in favor of first class creation time for
> >> >> ext4/xfs from my experience with production systems that need it and use xattr
> >> >> to store it (by smbd), but I am not going to list them here because
> >> >> this is not a
> >> >> thread about implementing mutable creation time for ext4/xfs.
> >> 
> >> For my (backups, preservation) use case, making btime mutable would also
> >> be fine, but I can see the value of having a "ctime" for creation, hence
> >> this RFC.
> >> 
> >> >> 
> >> >> > since it is not preserved by any tools, has
> >> >> 
> >> >> Facts check:
> >> >> 
> >> >> # NEWS for rsync 3.2.3 (6 Aug 2020)
> >> >> 
> >> >> ## Changes in this version:
> >> >> ...
> >> >>  - Added [`--crtimes`](rsync.1#opt) (`-N`) option for preserving the file's
> >> >>    create time (I believe that this is macOS only at the moment).
> >> >> 
> >> >> Incidentally, I have an implementation for --crtimes for cifs [1], but this
> >> >> is not extendable to support all the filsystems which support settable crtime.
> >> >
> >> > Another two facts check:
> >> >
> >> > FreeBSD has also API for changing "birth (creation) times".
> >> > It is documented in utimes(2) manpage:
> >> > https://man.freebsd.org/cgi/man.cgi?query=utimes&sektion=2
> >> >
> >> > So I guess that there has to be some tool which is using this API and
> >> > therefore these "birth (creation) times" are preserved.
> >> >
> >> >
> >> > NFS4 has time_create attribute (FATTR4_TIME_CREATE=50) which is
> >> > per-fs-object read-write attribute and defined (in RFC8881 5.8.2.40.) as:
> >> >   The time of creation of the object. This attribute does not have any
> >> >   relation to the traditional UNIX file attribute "ctime" or "change time".
> >> > Since NFSv4.1 it can be even specified during creating a new file/dir
> >> > which seems to be for backup-restore. And permissions (RFC8881 6.2.1.3.1.):
> >> >   ACE4_WRITE_ATTRIBUTES
> >> >   Operation(s) affected: SETATTR of time_access_set, time_backup,
> >> >     time_create, time_modify_set, mimetype, hidden, system
> >> >   Discussion: Permission to change the times associated with a file or
> >> >     directory to an arbitrary value. Also permission to change the
> >> >     mimetype, hidden, and system attributes. A user having ACE4_WRITE_DATA
> >> >     or ACE4_WRITE_ATTRIBUTES will be allowed to set the times associated
> >> >     with a file to the current server time.
> >> >
> >> > I'm not sure if there is some backup/restore tool which do it over NFS4
> >> > but the NFS4 description seems to be very clear that the network protocol
> >> > itself is already prepared for these use cases. And permissions mostly
> >> > matches the SMB / NTFS / Windows security model.
> >> >
> >> >> > a "vague" meaning (is it when the *file* was created, when the *content* was
> >> >> > created, do edits update it, is it preserved across filesystems, archives,
> >> >> > etc.) and adding it into the filesystem is misplaced effort.
> >> >> 
> >> >> Sorry now you are talking nonsense. Meaning has nothing to do with it.
> >> >> This is a property of filesystems (plural) which have documented APIs
> >> >> and documented network protocols - it is what it is.
> >> >> 
> >> >> If you are looking for a meaning, it is the first publication date, whether
> >> >> it means something to you is irrelevant - what's relevant is that customers
> >> >> use it and want to preserve it in backups, whatever its meaning is.
> >> >
> >> > I agree here. I also heard lot of times that users (customers) want to
> >> > preserve create time in backups and be able to restore it. And that
> >> > Windows is already able to do it, Linux not yet.
> >> 
> >> Hi I'm one of those users, I still can't believe no-one has implemented
> >> something like this yet since POSIX came out way back when (*cry*).
> >> 
> >> > Maybe what is a "vague" here is where that "create time" is stored and
> >> > from which (API) source is GUI (or CLI) application showing it to user.
> >> >
> >> >> >
> >> >> > Storing it as an xattr has some reasonable chance of being preserved across
> >> >> > tar/cp/filesystems, and doesn't introduce a herculean effort of changing
> >> >> > all of the system calls and on-disk formats for every filesystem.
> >> >> >
> >> >
> >> > I think the part "being preserved across tar/cp/filesystems" is
> >> > relevant. If a completely new API is introduced into Linux then it means
> >> > that every existing backup tool would not be able to preserve this
> >> > property and also would not be able to restore it.
> >> >
> >> > I'm not sure if we can do anything with this issue, but it is important
> >> > to know about this limitation.
> >> 
> >> My thinking for this RFC would be to then submit relevant patches also
> >> to at least the main tools I use like tar, cp, rsync and vim, which will
> >> hopefully make it gain momentum and be supported also in other less
> >> well-known tools (I would also love for it to be supported by HTTP like
> >> mtime is, but that will likely be a lot more difficult to get accepted
> >> and implemented).
> >
> > If having two btime and ptime fields would be the direction then we can
> > propose an extension for NFS4 protocol with a new attribute (as NFS4 has
> > currently only one). There are already some NFS4 extensions which comes
> > from Linux or was inspired, e.g. umask or xattr support.
> 
> Yes that would be nice, so when making the patch for nfs (in v4 or v5),
> should I treat FATTR4_TIME_CREATE as ptime and maybe try to add the
> needed code for a new btime?

That is good question and I do not have any definite answer how should
Linux handle it.

The reason is very simple. If you look at the FATTR4_TIME_CREATE in
specification (basically I have copied everything about it in previous
emails) it is short and does not say which one it should be.

I was implementing commercial NFS+SMB server with a hard requirement on
compliance with both protocols at the same time and also interop between
them. So from this my perspective by reading NFS4 spec with knowledge of
how SMB server should behave and how are designed Windows/SMB attributes
and permissions into NFS4, if I was asked to which of "ptime" or "btime"
I should map the FATTR4_TIME_CREATE then I would say it is "ptime".
Reasons: all those time attributes are R/W (like in SMB/Windows),
all of them require WRITE_ATTRIBUTES acl permission (like in SMB/Windows)
and we somehow agreed that Windows "create time" matches the "ptime",
and also because the request from from SMB to change create time would
not result in changing the linux "immutable btime". Basically in that
NFS4 spec I see a connection between FATTR4_TIME_CREATE and SMB create time.

But please this my analysis not from the Linux perspective, but rather
from the FS server perspective with respect to the NFS4 and SMB protocols.
I'm just giving inputs here.

> Thanks,
> koraynilay
> 
> >> > About the part "introduce a herculean effort of changing all of the
> >> > system calls and on-disk formats for every filesystem.". In my opinion
> >> > it is better to do that cleanup (maybe even in all stat-related
> >> > syscalls) if it makes things easier and prevents another technical
> >> > issues.
> >> >
> >> >> 
> >> >> As I said I can provide data for why the xattr approach taken by smbd is
> >> >> limited and inferior, but this is not the place to get into it (there are hints
> >> >> in the rsync commit message below).
> >> >> 
> >> >> Thanks,
> >> >> Amir.
> >> >> 
> >> >> [1] https://github.com/amir73il/rsync/commits/cifs-crtimes/
> >> >
> >> > I would say that xattr does not solve this issue too.
> >> 
> >> I would also like to note again that xattrs aren't available to symlinks
> >> (or other special files), which would break at least my backup/preservation
> >> use case.
> >> 
> >> Best,
> >> koraynilay
