Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795204101;
	b=cPbds3atDy36L0ihSk77TamNnAK7sZruUzMlvLyzjwQRTkvVsboF6h2Rxdiku6kwyURW
	 u776zLkNhrMgU9yzaK5Aj+7FG98gohzWqOXvkLSmvXpNBxVvflvQfRUS1lBjblHE9w+vv
	 yz02FEGwkaoUjiZGdtSU0QzWaBr3f3Ii6VQ4xFVMSQ0dO5tmzqgxpa0LFvosYGWxvA4ra
	 BT13zEvLD1D280LKPSDYpJoQBNheWYL+1ApS3cUPj9kA9n1hmTZbH3s8UrJwLnbIduIpQ
	 /AIhOXUfqt9fH985XN/kb9V7RDyQCbooU17iXSsPSBMqhDObWrOUnXtIVQYE3xXqTOQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795204101;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=lTIRHGIsznY2qaLBTMza940DKwA5VFJTusfkUBot3QA=;
	b=r+2asBSYjrXu9RkA9udh2Xr6+iwv6am49zfywpqTJpprVrbqiYSe29CQOhIxckXmu3fl
	 jqKZ+Ax2M5DGSiX1Yd0UZGR9D6imQ7+zrcTejECyWhZtZsDPwyaMmNTHKN8yTSaso5q6o
	 cadthGEqQ2lIIEDHvsIKR5bRtz+pLGcgEs9KMGPmBH/aaNVSYptIlJmkzyBAuzfoQZAEz
	 rphgZurUuzwqxpcu4ugaxh3qRvg1ymCqnSGE6GPswe1jz4y3lM9JkFhCtywmnquqAVV4k
	 z8Jxu/zC9xBCp9afT82nKjOGX62Ty1JD4W9yQB4yyRGSIgozd3d0CG+yhvvthsUE1Fw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=fUVKXjex;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id F1726606A6C2;
	Fri, 20 Nov 2026 19:48:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=fUVKXjex
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id D4EDF1F000C0;
	Fri, 20 Nov 2026 19:48:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795204100;
	bh=lTIRHGIsznY2qaLBTMza940DKwA5VFJTusfkUBot3QA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=fUVKXjexFonf9dU21Lpuqw4t1nv+4UCxPyhPh5yCUtIn94H3d9bY2PNxArC0Q4jkX
	 nmtuQ94+Tn5/f2+lp1+YNnHB3Mfnn5FYUuqbGIhpy/i+/A24CETpvGWGd1XAYUpOYa
	 HyiEy2RFLLB9Nhw9Wu07kuRioZSkqlVcKB/2eq33xfhAeWx5Xujw6DMrb72KNAC2VP
	 Jn5ZnV1eqZk/yHDbS6RfCVRMwRKzmclAyZ8xBuXTLaqMRqsbUspOte45Oz0Xc2bdit
	 DjXejcN+agdIszGp3Ap/a699y1M7wLzB1+t2PihFMm+OK0viDa1wCzAslzFLP6Tkdq
	 hcVtD1jJychYw==
Date: Fri, 20 Nov 2026 21:48:16 +0200
From: Jarkko Sakkinen <jarkko@kernel.org>
To: Alexander Mikhalitsyn <alex@amutable.com>,
	Andy Lutomirski <luto@amacapital.net>
Cc: Josef Bacik <josef@toxicpanda.com>,
	Christian Brauner <brauner@kernel.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	David Howells <dhowells@redhat.com>, Jan Kara <jack@suse.cz>,
	Serge Hallyn <sergeh@kernel.org>, Kees Cook <kees@kernel.org>,
	Paul Moore <paul@paul-moore.com>, linux-fsdevel@vger.kernel.org,
	linux-api@vger.kernel.org, linux-security-module@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v2 00/13] Namespace for namespace roots
Message-ID: <awCkANwNDox_99SR@kernel.org>
References: <av3bkDnwmjunTleX@kernel.org>
 <CALCETrXPLeUgxyhjP4XuWS46FKB0TUHF5PcMkdMf+qeEXbyXRA@mail.gmail.com>
 <9463a969d35a7d5ec5a56aeb67644b94.josef@toxicpanda.com>
 <CALCETrXt-Do28BHDpbrA98kEy-tQuorxD8c2XsW24Tt8Vspdtg@mail.gmail.com>
 <CALCETrUbe8rBoxrC+Q66AMsrJ8Fow7xt5KJKRAmobtXBvHWdqg@mail.gmail.com>
 <c301fff20a4920fcd3baa31dda2e31ad99c93436.camel@amutable.com>
 <awBHZO2VwWyJzvBN@kernel.org>
 <1f12636403bb7af3759cd933b2612d8a5d7317a2.camel@amutable.com>
 <awBRyKgOQlaEqpWX@kernel.org>
 <awCg5VYXKJvex9vy@kernel.org>
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
In-Reply-To: <awCg5VYXKJvex9vy@kernel.org>

On Fri, Nov 20, 2026 at 09:35:06PM +0200, Jarkko Sakkinen wrote:
> On Fri, Nov 20, 2026 at 03:57:32PM +0200, Jarkko Sakkinen wrote:
> > On Fri, Nov 20, 2026 at 02:24:57PM +0100, Alexander Mikhalitsyn wrote:
> > > Yeah, detached mounts API solves a security issue here, but it does not
> > > fully enable the use-case Andy describes (if I understood it
> > > correctly). My interpretation here is that to fully cover it we need
> > > some well-isolated communication channel between container and
> > > container manager (vsock for containers? :-D). And some well-defined
> > > agreement of how PID 1 inside the container can get an information
> > > about a hotplugg-ed stuff. [ But it could be that I completely
> > > misunderstood and Andy meant something much more simple here. ]
> 
> The sequence for hotplug (Andy's use case) breaks down like this and is
> doable:
> 
> 1. Host creates rootns(ROOTNS_SEAL_MNTNS).
> 2. Host sets uid/gid maps with NS_USERNS_SET_IDMAP.
> 3. Host populates "/" with MOVE_MOUNT_T_MNTNS, optionally combined with
>    MOVE_MOUNT_CLONE for bind mounts.
> 4. Host spawns PID 1 with clone3(CLONE_INTO_ROOTNS) (optionally passing
>    an AF_UNIX socketpair fd for communication).
> 5. PID 1 watches /proc/self/ns/mnt via fanotify(FAN_REPORT_MNT |
>    FAN_MARK_MNTNS, FAN_MNT_ATTACH) or polls /proc/self/mountinfo.
> 6. On hotplug, host mounts the filesystem via fsopen()/fsmount() (plus
>    optional MOUNT_ATTR_IDMAP).
> 7. Host creates the mountpoint with openat2(RESOLVE_IN_ROOT) + mkdirat()
>    and attaches the mount with MOVE_MOUNT_T_MNTNS.
> 8. PID 1 receives FAN_MNT_ATTACH and queries the new mount via
>    statmount().
> 
> ROOTNS_SEAL_MNTS, NS_USERNS_SET_IDMAP and MOVE_MOUNT_CLONE new features
> that are yet to be submitted but they were not tedious to ramp up.
> 
> I'll include them to v5 of the patch set. Thanks for underlining this
> part because that led to having those.
> 
> Architecture scales to this even if my choices to address these details
> would need some adjustment.
> 
> The clear two-phase (build/live) progress with rootns sort of just gives
> room to address stuff like this, and I have hard time to believe that it
> would get much better than this.

A completely new feature is NS_USERNS_SET_IDMAP:

    nsfs: Support NS_USERNS_SET_IDMAP ioctl

    Configuring UID, GID, and project ID mappings or disabling setgroups(2)
    for a user namespace currently requires writing to /proc/<pid>/uid_map,
    gid_map, projid_map, and setgroups, forcing container managers to spawn a
    live process before populating a filesystem owned by that user namespace.

    Add the extensible NS_USERNS_SET_IDMAP ioctl on CLONE_NEWUSER nsfs file
    descriptors to atomically configure setgroups policy and UID, GID, and
    project ID mappings before any process enters the namespace. Enforce the
    same single-write and capability invariants against both current_cred()
    and filp->f_cred under userns_state_mutex.

    Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>

This can be obviously used race-free, and this is thanks to two-phase
initialization pattern I have in place.

Br, Jarkko
