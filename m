Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793633929;
	b=3IEv5/59GwfcTgAfrYhqfNkBu7beRnl4SS3eA8JRBfAOJNS8Hib8gXvTD3fwuo5EdCY5
	 CNKykuzQhsctC3+mHpbO4gkTTOkCTnQMBZJdHg/qNblqxSsXflcJLIlzYg03gSPTEm+UK
	 XnEKhWfU5/cTOxUqciCLq5XlEymiq4yLzQJPNY38vKs+QTay6yPbPl1zOP6ivzWxoCrzc
	 6ZGTQsXGS6rKWfKeU73kJ8VCnvQdAmMsZrbJTK6Ke5cYX29cxpEBC0k8R+8NOwych15jY
	 2EMu4ff/fSH3XR7ZWrng23OLltu45o+Wt1x+mOxclH9gzgUEnibDIOLkzcoVB7BLkTw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793633929;
	h=Received:DKIM-Signature:Received:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:
	 Content-Transfer-Encoding:In-Reply-To:User-Agent;
	bh=VJqjaO5K9E/B76JPrTD775/RWHSZm7cCk23GyJS2CyE=;
	b=SyCgX0KNuPQDmEv3PLtEeyttaZ1AISU/7IVp02upYHxMy/c9lrNb7SOZcDPmH73AXN1/
	 UpQ2IyDGlQShvVHyVNohQ3EvgNoHdLOnnIMzIkORwGbsGlHFDT59piyJAWeaA7q08LH9/
	 /L9cQQvbT8WYcuuCdvrZMNKahMWhdsddeyVENcFvFlYP76EB+cUPuVxHErHpMc8t4Ee6+
	 pXqO5SJGXWDRjQlX/pF/gafHsPQd0ay6VQrUs861vXRpU0C6EIWg66gzaw/mZ7SV71Tti
	 DE7YQ9VHkJU/dw7klQMUaNSQWQXGJx4Shf66DBuU/6XynCf8CO7CxG4I5GgodeK+YUw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=BmkYZwb7;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E556606B1C8;
	Mon,  2 Nov 2026 15:38:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=BmkYZwb7
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BFF41F00A17;
	Mon,  2 Nov 2026 15:38:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793633928;
	bh=VJqjaO5K9E/B76JPrTD775/RWHSZm7cCk23GyJS2CyE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=BmkYZwb7Hs5zwPysZ5Kbl9fP9AMmO7IR2bykQ5NA7X3z6kB06OVeJj5nemJnHncK9
	 ZPjbEB8hAlAkehkrzV7bHpiWjMzp8GBRWMtNSZVKxUvfhHwy/NXma4fb7tQIAlbwCq
	 KLAc65lW9AYc2FnhJl7eFFm6Ez0/0/gfiQmjMba9umO8Erv9V426ETgi7Ou/5/IoWu
	 oVcPMRJCNjLzy8fjFkuQiXZStL8cXxzNrdwawemQkMte9/6qoy3URP7oZyc5Z+90gP
	 ANSFbWhluWAKjuPtvrcVp+jSpjnzpAO5XYzO2r1Wx7GWuuLuzwbbb6gGOMG/PaRDpV
	 cnQCu2MUVw8jw==
Received: by pali.im (Postfix)
	id A2841A13; Mon,  2 Nov 2026 16:38:45 +0100 (CET)
Date: Mon, 2 Nov 2026 16:38:45 +0100
From: Pali =?utf-8?B?Um9ow6Fy?= <pali@kernel.org>
To: Amir Goldstein <amir73il@gmail.com>
Cc: koraynilay <koray.fra@gmail.com>, David Sterba <dsterba@suse.com>,
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
Message-ID: <20261102153845.d67wlorqcbe3c2w7@pali>
References: <20261101015551.786044-1-koray.fra@gmail.com>
 <20261101015551.786044-4-koray.fra@gmail.com>
 <20261102142452.d6jkitgdeuquy23i@pali>
 <CAOQ4uxhQ3uhq6s+4deEJAQV5iy8QZoucojR58_dUNYrnjt_yvA@mail.gmail.com>
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
In-Reply-To: <CAOQ4uxhQ3uhq6s+4deEJAQV5iy8QZoucojR58_dUNYrnjt_yvA@mail.gmail.com>
User-Agent: NeoMutt/20180716

On Monday 02 November 2026 16:09:41 Amir Goldstein wrote:
> On Mon, Nov 2, 2026 at 3:24 PM Pali Rohár <pali@kernel.org> wrote:
> >
> > On Sunday 01 November 2026 02:55:49 koraynilay wrote:
> > > @@ -154,6 +158,11 @@ int ntfs_fileattr_set(const struct mnt_idmap *idmap, struct dentry *dentry,
> > >       if (flags & FS_APPEND_FL)
> > >               new_fl |= S_APPEND;
> > >
> > > +     if (fa->fsx_xflags & FS_XFLAG_PTIME) {
> > > +             ni->i_crtime.tv_sec = fa->fsx_ptime.tv_sec;
> > > +             ni->i_crtime.tv_nsec = fa->fsx_ptime.tv_nsec;
> > > +     }
> > > +
> > >       inode_set_flags(inode, new_fl, S_IMMUTABLE | S_APPEND);
> > >
> > >       /* Save nodump flag to return in ntfs_getattr. */
> > > @@ -275,8 +284,9 @@ int ntfs_getattr(const struct mnt_idmap *idmap, const struct path *path,
> > >       if (unlikely(is_bad_ni(ni)))
> > >               return -EINVAL;
> > >
> > > -     stat->result_mask |= STATX_BTIME;
> > > +     stat->result_mask |= (STATX_BTIME | STATX_PTIME);
> > >       stat->btime = ni->i_crtime;
> > > +     stat->ptime = ni->i_crtime;
> >
> > For me this patch looks dangerous. Somehow I would expect that the
> > "btime" will never change for existing inode.
> >
> > But because the ptime is mapped to i_crtime and ptime is settable from
> > userspace, with this patch it is directly possible to change btime.
> >
> >
> >
> > I was thinking more about it... Is not this just misunderstanding of how
> > the security model around the times is working on different systems?
> > Because on NTFS there is stored just one field which says when the file
> > was created. There are not two fields like "time set by user and time
> > set by system".
> >
> > Windows security model allows anybody with WRITE_ATTRIBUTES access to
> > change that create time. Linux security model does not allow to change it.
> >
> > NTFS in this view is just a filesystem like any other (ext4, btrfs, ...).
> > In my opinion if the ext4 or btrfs filesystem is correctly implemented
> > on Windows systems, then Windows security model should handle it in the
> > same way like for NTFS or exFAT. So if something grants WRITE_ATTRIBUTES
> > access, then Windows should allow to change also btime on ext4 or btrfs.
> >
> >
> >
> > On the other hand, I understand the use case to have two creation times.
> > One time which would never be changed and could be used for any kind of
> > atomic / synchronization by userspace application logic (this btime).
> > And another time for human which can be changed at any time to any value
> > which user wants (this ptime).
> >
> > In any case, I would suggest that filesystem driver would not report to
> > userspace unsupported values and would not try to invent other values
> > and lying about them.
> 
> But all those fs with mutable creation time already report it with STATX_BTIME
> so what can we do about this?

Well, what I wanted above to point out is that the "mutability" of
creation time is not feature of filesystem, but in my opinion rather
property of the security model on the running operating system.

Maybe better question is: how ext4 btimes differs from the ntfs btime?
In my opinion there is no much difference, both of them has meaning
"time when was the file created".

> If userspace requests both STATX_BTIME|STATX_PTIME in mask arg,
> those fs could technically return only STATX_PTIME and it should not regress
> existing programs.
> 
> But this is still a bit surprising behavior is it not?
> 
> Thanks,
> Amir.

I'm not sure what to do with it.

If we allow to change btime of ntfs then for consistency we should also
allow to change btime of ext4.

Maybe another idea... define new capability which would allow to change
btime (on any filesystem)? This would at least make the consistency.
