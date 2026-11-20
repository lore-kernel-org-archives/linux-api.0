Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795180392;
	b=NWzYySK/sIFwz/oyhLia1wfpl/r9X9as6SEED9c3T3uETrDe16e+TiLz9Dyy/pWYllIn
	 yoYL8eiJw2CF+uc4u5e0ZZR427+cZXyeKPopw3npY5E1SgctUu8DFmhbKm3LU0fUdoNYT
	 3ZpHOeW/tN6wNRoe2htP46z9aUUuuKUICfnLsaat7k+ynif9X5jIECl+dI+Thi8gRpkrl
	 lc7hut3ZlUfJupFz0PXsl63eq6MYAm02VwKH+VDwYBMIy8D9kkRs2/U3no9BmS/Mb4cpE
	 VecuHjd3IPyLvP4W5NDW8li3OmFAPCC+o8YYq7fL6zzb70gijz7wune+xY5nWKtpXGw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795180392;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:
	 Content-Transfer-Encoding:In-Reply-To;
	bh=9Y4YGdjx5Co4VGeq/qLfNYXpjTltdduCTVMVmpN67n8=;
	b=l2vqke8y3OF/YTAS/l4QWTyMHeSbfRdh97jUNfmyK0tpFPfeF3fiw/n6Y5xXBb2Ie5uO
	 d5oJ8Mp46aHMlYjFK9OMtNp4IM5wYxgKTcLdWj2F152B0BYFD4BCmDO11i1vnbmdbJShP
	 elPB/C4O/AIeNNVfPXrT4qDW/sv5nuotkyl5HsKgF/ecPBZXQV3m6NDDlcvU/i06GsWCp
	 ZPJRCi6wuwdz7qJSEEWkCnpq0cNBpbc3aXYB4GrXqdZZgO50RCigMW8F+pFj2pXJtVtG3
	 14l7FNZ4+R1MrPVlf6O35iUhMlOEX9kqeGb9Xr+m/LKxi30X/idp7v1JkySoEzd13VA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=L6bm2CA6;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id 4F9F6606A32C;
	Fri, 20 Nov 2026 13:13:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=L6bm2CA6
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 864701F000D0;
	Fri, 20 Nov 2026 13:13:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795180392;
	bh=9Y4YGdjx5Co4VGeq/qLfNYXpjTltdduCTVMVmpN67n8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=L6bm2CA6ArbThfm1WmrkXzmsjJ9pMyguKKs0xUr4K+f38fDFzfbpfRicjfICsSdJ4
	 EvCaIoZNDDkDzdu1VOSNkdU1F0RSN51ctC/kKe5RfxH15HixGgB9YHgyITfdm6fmQ/
	 KukuzEL7OfU540j63rweyPPBP05/OOpczqhijr3NboHNmidk5YDJ49HfnBY185Md5w
	 N2+fWgKAZGe0cthL0YBrnH7VsL2dFuZ7tr5+cBA9Dmvi89tnlasDr5v2w/ITKALjHD
	 YgBMPO/Zz54/vicmRTKCrNjRXAUPjwlDfMiA2QDKQNW6VyWV4/fCpfMyeFKHXxQ92P
	 MuT54PeKYrtiQ==
Date: Fri, 20 Nov 2026 15:13:08 +0200
From: Jarkko Sakkinen <jarkko@kernel.org>
To: Alexander Mikhalitsyn <alex@amutable.com>
Cc: Andy Lutomirski <luto@amacapital.net>,
	Josef Bacik <josef@toxicpanda.com>,
	Christian Brauner <brauner@kernel.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	David Howells <dhowells@redhat.com>, Jan Kara <jack@suse.cz>,
	Serge Hallyn <sergeh@kernel.org>, Kees Cook <kees@kernel.org>,
	Paul Moore <paul@paul-moore.com>, linux-fsdevel@vger.kernel.org,
	linux-api@vger.kernel.org, linux-security-module@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v2 00/13] Namespace for namespace roots
Message-ID: <awBHZO2VwWyJzvBN@kernel.org>
References: <20261117231352.3816603-1-jarkko@kernel.org>
 <CALCETrVUkbpoFjwSAejyA4b_9qEauAP_36i=O8Op1ifp8aUkqA@mail.gmail.com>
 <av3akYFOYaeQZauZ@kernel.org>
 <av3bkDnwmjunTleX@kernel.org>
 <CALCETrXPLeUgxyhjP4XuWS46FKB0TUHF5PcMkdMf+qeEXbyXRA@mail.gmail.com>
 <9463a969d35a7d5ec5a56aeb67644b94.josef@toxicpanda.com>
 <CALCETrXt-Do28BHDpbrA98kEy-tQuorxD8c2XsW24Tt8Vspdtg@mail.gmail.com>
 <CALCETrUbe8rBoxrC+Q66AMsrJ8Fow7xt5KJKRAmobtXBvHWdqg@mail.gmail.com>
 <c301fff20a4920fcd3baa31dda2e31ad99c93436.camel@amutable.com>
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
In-Reply-To: <c301fff20a4920fcd3baa31dda2e31ad99c93436.camel@amutable.com>

On Fri, Nov 20, 2026 at 01:32:57PM +0100, Alexander Mikhalitsyn wrote:
> On Thu, 2026-11-19 at 15:27 -0800, Andy Lutomirski wrote:
> > On Thu, Nov 19, 2026 at 2:50 PM Andy Lutomirski <luto@amacapital.net>
> > wrote:
> > > 
> > > On Thu, Nov 19, 2026 at 9:30 AM Josef Bacik <josef@toxicpanda.com>
> > > wrote:
> > > > 
> > > > On Wed, Nov 18, 2026 at 9:46 AM Andy Lutomirski
> > > > <luto@amacapital.net> wrote:
> > > > > cells: The dance where I create an anonymous mountns, mount
> > > > > stuff into
> > > > > it, and then attach it to the cell is cute.  But I think the
> > > > > userns
> > > > > interaction is wrong: you are making me assemble all the mounts
> > > > > in
> > > > > *my* userns and then clone the entire tree into a fresh, non-
> > > > > anonymous
> > > > > mountns bound to the current userns.  And that clone operation
> > > > > is not
> > > > > free and serves no actual practical purpose.
> > > > 
> > > > The copy buys us nothing, agreed.  That's just what the mount API
> > > > gives
> > > > me to work with today, it's not something cells wants.  If I
> > > > could make
> > > > an empty mount namespace and fill it by fd I'd use that, the
> > > > "root" slot
> > > > takes a mount namespace fd already.  Extending the API for that
> > > > makes
> > > > sense to me on its own.
> > > > 
> > > > The mount namespace staying with the builder's userns is on
> > > > purpose
> > > > though, that's what keeps the cell from mounting anything no
> > > > matter what
> > > > capabilities it was given.  The builder sets the tree up and
> > > > hands it
> > > > over, so the cell only ever has what it was given, and the mount
> > > > code
> > > > isn't something it can attack from the inside.
> > > 
> > > I don't get it.
> > > 
> > > Using the builder's user namespace means that the contained
> > > processes
> > > can't be ns_capable on mntns->userns.  But this solves very few
> > > problems unless you also deny the contained processes the ability
> > > to
> > > unshare userns and make a new mountns, and if you can do that,
> > > surely
> > > you can also deny the ability to modify the mount namespace.
> > > 
> > > As just one example, a mount namespace could have a little flag to
> > > say
> > > that it's *in* one userns but its owner is a different userns.
> > > 
> > > > 
> > > > > cells: I find it *incredibly annoying* that one generally
> > > > > cannot put
> > > > > new mounts into an existing container using most existing
> > > > > container
> > > > > managers.  I hit this on a surprisingly regular basis.  You
> > > > > seem to be
> > > > > baking this into the whole cells design.  Why?
> > > > 
> > > > By design.  Allowing changes to a running container is what
> > > > causes the
> > > > problems.  If you need another mount, tear it down and build it
> > > > again.
> > > 
> > > What problems?
> 
> Dear friends,
> 
> Dear Andy,
> 
> > 
> > I'll add:
> > 
> > On a non-container Linux system, you can hot-add a removable drive.
> > On a Linux-hosted VM, you can hot-add all kinds of devices, with or
> > without the help of the hypervisor.  (The hypervisor can hot-add a
> > device, and the guest can mount network devices or newly added USB
> > devices on a port that was already assigned, etc.)
> > 
> > For some reason, on Docker and its sort-of-clones, approximately the
> > best you can do is rbind in a directory and then mount things into
> > that directory from outside.  This is sad.
> 
> +1
> 
> I guess the root reason here is what you've mentioned - for VMs we have
> a clear separation of the host-side (hypervisor can hot-plug a device
> to be visible on a PCI bus, for example) and some agent on the guest
> side can react on this change and do something depending on how VM's
> owner has configured it.
> 
> For containers, we usually don't have an agent (at least in LXC, OpenVZ
> and Docker too). So it is a container manager's work to figure out how
> to hotplug a new filesystem for example and where to place the mount.
> And this was always a reason for some crazy security issues, when some
> privileged process on the host was entering a container's namespaces
> (partially) and then suddenly become trace-able or bring some host FDs
> (and these FDs could be a way to escape via (struct file*)->f_cred
> permission delegation model).
> 
> Another reason is that in VM you hotplug a device, while in container
> you can only hotplug a mounted filesystem. And for devices we don't
> care under which major/minor they land and so on - again, because we
> have systemd for example and it can figure this out. For filesystem we
> need to know where to place in in a mount namespace tree from the
> beginning (we still don't allow mounting a block-device based
> filesystems inside user namespaces).
> 
> I really like your point and that would be great if we can solve this
> somehow in a new design.

This is for v4 (latest).

MOVE_MOUNT_T_MNTNS takes any nsfs CLONE_NEWNS fd, and populates
CLONE_EMPTY_MNTNS directly and attaches live submounts without setns()
and FSCONFIG_SET_ROOTNS mounts FS_USERNS_MOUNT filesystems unprivileged
without entering userns.

The gaps would be open_tree(OPEN_TREE_CLONE) gating (it's now against
host), uid_map/gid_map prepopulation and a flag to deny mount table
changes inside rootns() container while keeping external hot-mounts
enabled.

Those are totally addressable issues.

Br, Jarkko
 
