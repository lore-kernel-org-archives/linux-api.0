Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795214160;
	b=1pQTFcnBS6DJgJTPeXTZKS4tG250USNvLj8kRgfL5ddq2RAk4A2kY1cQRNjvMdB2pLje
	 VFGNxMJorsafIPt7AeqnG9JtXNvipHwLVVuYWCe4SUJRtgd1ByeHT3l0M0G+Z4UWbQjcj
	 3dnF2wozrTF6z37NqWasqFuw0bCWk4E9ChoqgYd5grocwFRERV1KdJmYkYqApmifr5TNR
	 gfdWDsvmbqmma/Al8AvS9an0SgzsvXagFGZgXOzdh2gyMuvE9WeNzys1Cu3ZSGim98vdY
	 rw6tNIaBz01WtBNiDHpF3uK5hC1O/StcHs/NWALfDzSKIETCcD2nNS/orb2rndUws0Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795214160;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=EctYPtK+zePOr0ZGKAPFnN9hSFADO/L0n1ivoVa8AVo=;
	b=gw4WdYMdnrecSgV1gGD/sJUCUkILbWSnpMYzl+3yFctkfiwW9yJ6NQfeabjT0vtkEzTY
	 0KZIulR+/ANythb3tY25zGni0lcGo3zXsQmOmUcK+dptBabk+ueXF9rluOVlVje45OX0p
	 WR0H029OuJhEvd9SS97pBuoIAW0eNsTE/t+klh1NTBiRHZdrLbvPJCTdKEpCa/U6iqmpt
	 8N1yoqFa7rYJBpdBtyyW+ExX/v1rlD4ZdJWJ9zEwbCGYcrF9ukr7+75EAU6ZrwSk0ZlMG
	 hJI1mf7psFnM4tx763NDg+m0dxoPE8iy4MxSeq/LVlJSyAhoAf9LpYrgPnogGGKuqhw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Sr3+Fm5K;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id C9C7C606A333;
	Fri, 20 Nov 2026 22:36:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Sr3+Fm5K
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id BD2251F000C0;
	Fri, 20 Nov 2026 22:35:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795214160;
	bh=EctYPtK+zePOr0ZGKAPFnN9hSFADO/L0n1ivoVa8AVo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Sr3+Fm5KrgTOlZgEZv2r37r2oyCuUKyIoF2nEGIseWapNBmQ74kHMwjZPD6hsMDbP
	 uiFmisGHKLVrQbzFDy7vunmuhnZIUGNGB078k30ibxgQlQLo6/g67eZBJ27cHyfH5v
	 RZd4FozpKlCVeUjbtZcDrkNS/bG8HPodjFGD8BAQ2JMmXEVPtNLA61AyM+8qSxHhyi
	 VEJjb8xVVCXtedy3dff2QMWtkLFD9JoAA9w20LqImQsyGWI8AWjpEZkJxQt4x1ILch
	 9hlJzgu1EmYC4Hayxv8dtLSYQPsHLA6hqYQjLsUQb9Db9kvhzjufFlAsIbaz4KJl0V
	 t89B21QF4FL8Q==
Date: Sat, 21 Nov 2026 00:35:56 +0200
From: Jarkko Sakkinen <jarkko@kernel.org>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Alexander Mikhalitsyn <alex@amutable.com>,
	Josef Bacik <josef@toxicpanda.com>,
	Christian Brauner <brauner@kernel.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	David Howells <dhowells@redhat.com>, Jan Kara <jack@suse.cz>,
	Serge Hallyn <sergeh@kernel.org>, Kees Cook <kees@kernel.org>,
	Paul Moore <paul@paul-moore.com>, linux-fsdevel@vger.kernel.org,
	linux-api@vger.kernel.org, linux-security-module@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v2 00/13] Namespace for namespace roots
Message-ID: <awDLTJcDJnN0kgMS@kernel.org>
References: <9463a969d35a7d5ec5a56aeb67644b94.josef@toxicpanda.com>
 <CALCETrXt-Do28BHDpbrA98kEy-tQuorxD8c2XsW24Tt8Vspdtg@mail.gmail.com>
 <CALCETrUbe8rBoxrC+Q66AMsrJ8Fow7xt5KJKRAmobtXBvHWdqg@mail.gmail.com>
 <c301fff20a4920fcd3baa31dda2e31ad99c93436.camel@amutable.com>
 <awBHZO2VwWyJzvBN@kernel.org>
 <1f12636403bb7af3759cd933b2612d8a5d7317a2.camel@amutable.com>
 <awBRyKgOQlaEqpWX@kernel.org>
 <awCg5VYXKJvex9vy@kernel.org>
 <awCkANwNDox_99SR@kernel.org>
 <CALCETrUnQjrWmSzL-FOqFF+_enxVsEM0On7orydXLCO-L2f23w@mail.gmail.com>
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Post: <mailto:linux-api@vger.kernel.org>
List-Help: <mailto:linux-api+help@vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-api+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALCETrUnQjrWmSzL-FOqFF+_enxVsEM0On7orydXLCO-L2f23w@mail.gmail.com>

On Fri, Nov 20, 2026 at 11:53:30AM -0800, Andy Lutomirski wrote:
> >     nsfs: Support NS_USERNS_SET_IDMAP ioctl
> >
> >     Configuring UID, GID, and project ID mappings or disabling setgroups(2)
> >     for a user namespace currently requires writing to /proc/<pid>/uid_map,
> >     gid_map, projid_map, and setgroups, forcing container managers to spawn a
> >     live process before populating a filesystem owned by that user namespace.
> >
> >     Add the extensible NS_USERNS_SET_IDMAP ioctl on CLONE_NEWUSER nsfs file
> >     descriptors to atomically configure setgroups policy and UID, GID, and
> >     project ID mappings before any process enters the namespace. Enforce the
> >     same single-write and capability invariants against both current_cred()
> >     and filp->f_cred under userns_state_mutex.
> >
> >     Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
> >
> 
> I'm highly in favor of this.  But maybe not as an ioctl.
> 
> If you have an nsfd for a userns and that nsfd is the "control" fd
> (however anyone decides this is formulated), why does f_cred matter?
> It should be possible to create a userns without privilege and
> SCM_RIGHTS the fd to a privileged uidmapd.  (I fixed the rather
> screwed up workflow for this in newuidmap/newgidmap a few weeks ago --
> this is remarkably easy to screw up.  It'll make it to a distro near
> you some day.  It's supposed to *work* even without CAP_SYS_ADMIN in
> the picture, and it did not.)

Sealing was part of my testing mostly to show that the flow itself
is robust for doing "whatever". I'm happier not to include it to the
patch set itself tbh.

+1 for syscall instead of ioctl routing.

I can also likely drop ROOTNS_WAIT and get that also through
pre-existing syscall path. Checking up a few things before
locking in but I think that this can be done.

I think this all is enough material for a single iteration, or I want
to see what world looks like after doing this. 

v4 did not produce anything from Sashiko so far, and I still fixed
couple of races too while doing this, so also on that side it makes
sense to iterate.

I skimmed your EPRIV email and get I get it yes but within the patch
set's scope I feel that it would go off the edge. So on that side, I'd
look compatibility of the features rather than bundle them into the
same patch set.

> 
> --Andy

Br, Jarkko
