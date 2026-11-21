Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795279993;
	b=egbB2owNjeEXHCKlulW1o17K7kKqu7SRGKlHXPHbERMX8ajUXLnkc9IXoZ6Zu+oIQ40S
	 pzriH3QYYhpiScmpt80pHft063KVUQi3QtgCM5aEU5tG0LwwR0yAnKhUkQm4zAsTliolK
	 qPCezic7F+ulKCzwQnicnMVRQeWSJQKQO9wSpT35EKJw47emSHDZG4gOEMu2EHXFlFIzR
	 5H+1lBIYh3muBcT8QCDmnQk9Sgy1OsMcKtS5I8ls4kPtQ5j6ErsJ7LvptHc1+P6Yz5PUo
	 cYf02WLNUJwoLfo4aBdcXU7zfryP4SE80ZSAtwtZfilpg7qso2gwBCkqgtGoSxATI8A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795279993;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=aFcqldHucwK+C2tqtdJb8Bb0ObxZeQLB5nFF9Sfrquw=;
	b=jpBRSFo19x5OMYRQHgb3x6FFY6FjsnCwHTzmID3rKlCDptwsvqfTCP/ChgrIf1ArkXIq
	 4YJstgN/7sR5l/DjcMBK40I6derfknxAsZjjg4eems6a44d9zNR58QDqxJmgwUrDDQrCh
	 QvE+71b2AG7JwFLwbsla81JRcLD3/gdOzYR3WlqSYdanNlopJ9F9gUsZ8cY5lT9T6tKY2
	 Bj38W+QowvXp5QtF1CGz8pTZGeBVW9glhIr85RfJiUsqGCjH+zb77kRg4v1VErAGyVWty
	 Ilae3vJWmMVI271BvrQBGf/HmEN8UVdFNaCgB7hBGUjwixBz3rKTq36Jl2rS+noKgaw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=m9IdaaCN;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id BB22F606A320;
	Sat, 21 Nov 2026 16:53:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=m9IdaaCN
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 12B361F000C4;
	Sat, 21 Nov 2026 16:53:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795279993;
	bh=aFcqldHucwK+C2tqtdJb8Bb0ObxZeQLB5nFF9Sfrquw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=m9IdaaCNfA/FKNo4j7nuRQr5xyo32XlA8RCYY2dKnBSYFcmuaF2aLNbzQL3Ws+kkP
	 klhDzy0jBMsf66EQCZTW4gvxE19LB1osV4RlDnKF0MtWGjnVgGKkbAm/SosgJcmPqY
	 fTBxLUMMHvfQmcYekBn8TGnpxZ8VTXormf7BCj2a8bBcyCxS/JgvzniPu5woc86O8t
	 4uzUAMnWb4MgbFSHmjSrfmIMp1ed2y9RtTUseHWqPprQwuolv1dB1JRZavj76iHM/R
	 2eS3qc0igRitfQeU9RQaJMi8ey0OnsXlnRwEUPVd4/a42cHQjCDH0xR7EHxsKoWS0p
	 7xGTJTV5mWKRQ==
Date: Sat, 21 Nov 2026 18:53:10 +0200
From: Jarkko Sakkinen <jarkko@kernel.org>
To: linux-fsdevel@vger.kernel.org
Cc: linux-api@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org, linux-security-module@vger.kernel.org,
	Alexander Mikhalitsyn <alex@amutable.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Andy Lutomirski <luto@amacapital.net>,
	Christian Brauner <brauner@kernel.org>,
	David Howells <dhowells@redhat.com>, Jan Kara <jack@suse.cz>,
	Jonathan Corbet <corbet@lwn.net>,
	Josef Bacik <josef@toxicpanda.com>, Kees Cook <kees@kernel.org>,
	Neal Gompa <neal@gompa.dev>, Paul Moore <paul@paul-moore.com>,
	Serge Hallyn <sergeh@kernel.org>,
	Zygmunt Krynicki <zygmunt.krynicki@canonical.com>
Subject: Re: [RFC PATCH v5 02/25] userns: Add userns_set_idmap() system call
Message-ID: <awHMdgo7DbzfLXcj@kernel.org>
References: <20261121000844.1863324-1-jarkko@kernel.org>
 <20261121000844.1863324-3-jarkko@kernel.org>
 <awHCTNAo9uMakhAH@kernel.org>
 <awHLt1IpLcqxUnDW@kernel.org>
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
In-Reply-To: <awHLt1IpLcqxUnDW@kernel.org>

On Sat, Nov 21, 2026 at 06:50:03PM +0200, Jarkko Sakkinen wrote:
> On Sat, Nov 21, 2026 at 06:09:53PM +0200, Jarkko Sakkinen wrote:
> > On Sat, Nov 21, 2026 at 02:08:21AM +0200, Jarkko Sakkinen wrote:
> > > Configuring UID, GID, and project ID mappings currently requires writing
> > > formatted text to /proc/<pid>/{uid_map,gid_map,projid_map,setgroups},
> > > which depends on a live task in /proc and enforces write(2) file-opener
> > > CAP_SETUID/CAP_SETGID checks that prevent passing an unprivileged userns
> > > file descriptor over SCM_RIGHTS to a dedicated CAP_SETUID/CAP_SETGID
> > > mapping helper.
> > > 
> > > Add userns_set_idmap() to atomically configure setgroups policy and UID,
> > > GID, and project ID extents directly on a CLONE_NEWUSER nsfs file
> > > descriptor. Require CAP_SYS_ADMIN over the target user namespace in
> > > either the caller's or the file opener's credentials, and check parent
> > > ID-range capabilities strictly against the caller's credentials.
> > > 
> > > Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
> > 
> > I'll remove the flags. I forgot to remove them from final version.
> 
> userns_set_idmap() still has flags-parameter but it is gated:
> 
> 	if (flags & ~USERNS_SETGROUPS_ALLOWED)
> 		return -EINVAL;
> 
> And used as a bitmask:
> 
> 	ns->flags = ns->flags & flags;

SYSCALL_DEFINE4(userns_set_idmap, int, fd,
                const struct userns_idmap __user *, map,
                size_t, size, unsigned int, flags)
{
        struct uid_gid_map new_uid = {}, new_gid = {}, new_projid = {};
        struct userns_idmap req = {};
        struct ns_common *ns_common;
        struct user_namespace *ns;
        unsigned long old_flags;
        struct file *filp;
        int ret;

        BUILD_BUG_ON(sizeof(struct userns_idmap) != USERNS_IDMAP_SIZE_VER0);

        if (flags & ~USERNS_SETGROUPS_ALLOWED)
                return -EINVAL;

        CLASS(fd, f)(fd);
        if (fd_empty(f))
                return -EBADF;

        filp = fd_file(f);
        if (!proc_ns_file(filp))
                return -EINVAL;

        ns_common = get_proc_ns(file_inode(filp));
        if (ns_common->ns_type != CLONE_NEWUSER)
                return -EINVAL;
        ns = to_user_ns(ns_common);

        if (!map || size < USERNS_IDMAP_SIZE_VER0)
                return -EINVAL;
        ret = copy_struct_from_user(&req, sizeof(req), map, size);
        if (ret)
                return ret;
        if (req.reserved)
                return -EINVAL;
        if (!req.nr_uid_extents != !req.uid_extents ||
            !req.nr_gid_extents != !req.gid_extents ||
            !req.nr_projid_extents != !req.projid_extents)
                return -EINVAL;
        if (!req.nr_uid_extents && !req.nr_gid_extents &&
            !req.nr_projid_extents)
                return -EINVAL;
        if ((flags & USERNS_SETGROUPS_ALLOWED) && !req.nr_gid_extents)
                return -EINVAL;

        if (!ns->parent)
                return -EPERM;
        if (current_user_ns() != ns && current_user_ns() != ns->parent)
                return -EPERM;

        if (req.nr_uid_extents || req.nr_gid_extents) {
                bool file_ok = (filp->f_cred->user_ns == ns ||
                                filp->f_cred->user_ns == ns->parent) &&
                               file_ns_capable(filp, ns, CAP_SYS_ADMIN);

                if (!ns_capable(ns, CAP_SYS_ADMIN) && !file_ok)
                        return -EPERM;
        }

        if (req.nr_uid_extents) {
                ret = parse_user_idmap_extents(req.uid_extents,
                                               req.nr_uid_extents, &new_uid);
                if (ret < 0)
                        goto out_free;
        }
        if (req.nr_gid_extents) {
                ret = parse_user_idmap_extents(req.gid_extents,
                                               req.nr_gid_extents, &new_gid);
                if (ret < 0)
                        goto out_free;
        }
        if (req.nr_projid_extents) {
                ret = parse_user_idmap_extents(req.projid_extents,
                                               req.nr_projid_extents,
                                               &new_projid);
                if (ret < 0)
                        goto out_free;
        }

        mutex_lock(&userns_state_mutex);
        old_flags = ns->flags;
        ret = -EPERM;

        if (req.nr_uid_extents && ns->uid_map.nr_extents != 0)
                goto out_unlock;
        if (req.nr_gid_extents && ns->gid_map.nr_extents != 0)
                goto out_unlock;
        if (req.nr_projid_extents && ns->projid_map.nr_extents != 0)
                goto out_unlock;

        if (req.nr_gid_extents) {
                if ((flags & USERNS_SETGROUPS_ALLOWED) &&
                    !(ns->flags & USERNS_SETGROUPS_ALLOWED))
                        goto out_unlock;
                if (!(flags & USERNS_SETGROUPS_ALLOWED))
                        ns->flags &= ~USERNS_SETGROUPS_ALLOWED;
        }

        if (req.nr_uid_extents) {
                ret = prepare_caller_idmap(ns, CAP_SETUID, &new_uid,
                                           &ns->parent->uid_map);
                if (ret < 0)
                        goto out_restore;
        }
        if (req.nr_gid_extents) {
                ret = prepare_caller_idmap(ns, CAP_SETGID, &new_gid,
                                           &ns->parent->gid_map);
                if (ret < 0)
                        goto out_restore;
        }
        if (req.nr_projid_extents) {
                ret = prepare_caller_idmap(ns, -1, &new_projid,
                                           &ns->parent->projid_map);
                if (ret < 0)
                        goto out_restore;
        }

        if (req.nr_uid_extents)
                commit_new_idmap(&ns->uid_map, &new_uid);
        if (req.nr_gid_extents)
                commit_new_idmap(&ns->gid_map, &new_gid);
        if (req.nr_projid_extents)
                commit_new_idmap(&ns->projid_map, &new_projid);

        mutex_unlock(&userns_state_mutex);
        return 0;

out_restore:
        ns->flags = old_flags;
out_unlock:
        mutex_unlock(&userns_state_mutex);
out_free:
        free_new_idmap(&new_uid);
        free_new_idmap(&new_gid);
        free_new_idmap(&new_projid);
        return ret;
}

Br, Jarkko

