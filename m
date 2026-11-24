Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795557792;
	b=Ar3aD63ituFM0fWvhyctE+FWs2xUWdWs7wueXX+cFlbWTTtrp5WczX7kl7bkZa94p9s5
	 ED8iVgzo2J5FQWQaBx753btlVB9yd0kMK5IDw82VXt+F0KahQl0yYGrVERT8XlTPBCuCh
	 W0F/2OEQr/iIlBx3At55pvWSHqMRms652YVqnJbsoH+Zzbf01sfeN7PhK31RXIiNWF5ku
	 FP01/ThFia9ZSvxMm5jvgjJ0uUhvdPHFmLhFmDne0rAu3jFeHGYpGyNM73FN3ENuDoSST
	 3lDfeqqp9aytcQoyrL394k9qa18coHWumxS6hDfzklJ4hlCNdgy69b6R4yOqWmwyjEA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795557792;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=I2AawXArirG4KpU+UUm14KyoGf+mvvaD2kOOOKXiUqk=;
	b=gEXu1BNvOZDGIVGYo75T1EgTAVa9305x8uSrpNvp1uyOe3HBIXHtZn/Vlcypt9zU/qjE
	 NMBYMQFx7z9kPlubWyKQrxwugHRagXwEoEM1Vf61rvjp3mtXnzKrsHzRfVSyUuk4diCg+
	 5jNXWSQOeZEML3h+K1b9M7AczYWw93LG6pF13hBrDrGU3cOCx18EnRIQNxulo3T+qN4mx
	 V2Ze4Gzh8ZiwUiU1GEDuwzxWnv4Q4rHHs56tfMT4qM1+MrJTRXInb+EkkcNocjuwhgY7F
	 ExMoWbS0yJ78t288hNf8Naiu+CElWK2N//+N6MczjuxpZao0FFFDIs31UDfDLKHV0rg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=NbKsLJkS;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id B4CD5606A31E;
	Tue, 24 Nov 2026 22:03:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=NbKsLJkS
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 8014E1F000D1;
	Tue, 24 Nov 2026 22:03:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795557792;
	bh=I2AawXArirG4KpU+UUm14KyoGf+mvvaD2kOOOKXiUqk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=NbKsLJkSWiUjr+/kVbIn98nMLxV6i/5Qs+f0i6FIBEkPFrMNK+9ezbwjqipPrP5zK
	 7eAw3dXiBNy4ZCOFyhojpJwh1jpUYecGHms5Zo1p6+7FVM2/GwCMgdTgh3RmMD+vIO
	 pyh99waasjRHrRa9GOR7D/GkolPRaKQT9VZkuENydlDNeA7VOYCsN2RcVit+SQcytc
	 2si4PwnoA2X/2DIweANilI/FOBDlbaQ6QNvuyIlKfG+POWgMjn3A/frdS5yqDffPTD
	 /SxikRsNwAWKM+I6R7Lcrd/pbP//S0PKae3f17ipQjyB6SZ2DoSw0ZmQmsLOovJec+
	 LPYdsWIa+BTmw==
Date: Wed, 25 Nov 2026 00:03:08 +0200
From: Jarkko Sakkinen <jarkko@kernel.org>
To: linux-fsdevel@vger.kernel.org
Cc: bpf@vger.kernel.org, containers@lists.linux.dev,
	linux-api@vger.kernel.org, linux-arch@vger.kernel.org,
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org,
	linux-security-module@vger.kernel.org,
	Aleksa Sarai <aleksa@amutable.com>,
	Alexander Mikhalitsyn <alex@amutable.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Andy Lutomirski <luto@amacapital.net>,
	Arnd Bergmann <arnd@arndb.de>,
	Christian Brauner <brauner@kernel.org>,
	David Howells <dhowells@redhat.com>,
	Eric Biggers <ebiggers@kernel.org>,
	Giuseppe Scrivano <giuseppe@scrivano.org>,
	Hugh Dickins <hughd@google.com>, Jan Kara <jack@suse.cz>,
	Jeff Layton <jlayton@kernel.org>, Jonathan Corbet <corbet@lwn.net>,
	Josef Bacik <josef@toxicpanda.com>, Kees Cook <kees@kernel.org>,
	KP Singh <kpsingh@kernel.org>,
	Lennart Poettering <lennart@poettering.net>,
	Neal Gompa <neal@gompa.dev>, Oleg Nesterov <oleg@redhat.com>,
	Paul Moore <paul@paul-moore.com>,
	Pavel Tikhomirov <ptikhomirov@virtuozzo.com>,
	Serge Hallyn <sergeh@kernel.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Zygmunt Krynicki <zygmunt.krynicki@canonical.com>
Subject: Re: [RFC PATCH v7 00/26] userland: Userland containers
Message-ID: <awYJnFNt9kkBqj59@kernel.org>
References: <20261122193539.3334213-1-jarkko@kernel.org>
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
In-Reply-To: <20261122193539.3334213-1-jarkko@kernel.org>

On Sun, Nov 22, 2026 at 09:35:13PM +0200, Jarkko Sakkinen wrote:
> OVERVIEW
> ========
> 
> A userland is an anonymous-inode control object with separate build and
> live phases that binds together:
> 
> 1. A full set of detached namespaces owned by a fresh user namespace,
>    with optional build-phase opt-in sharing (USERLAND_SHARE_NSFD).
> 2. A dedicated PID namespace for spawning processes into, signaling
>    members, and polling or waiting on PID 1 exit.
> 3. An initially empty mount namespace (CLONE_EMPTY_MNTNS) populated
>    directly in its target user namespace before going live, without
>    inheriting host mounts or cloning staged trees, while still allowing
>    new mounts to be attached at runtime.
> 
> Work on this feature started in 2025 after reviewing David Howells'
> container object patch set [1], whose underlying mechanics made sense to
> me as a continuation of earlier container object efforts [2]. The
> lifecycle follows a staircase initialization model similar to the Intel
> SGX driver, without an embryonic task state or a parallel namespace
> syscall API, pairing a compact policy-agnostic implementation with an
> allow-list security model (with LSM hooks) and runtime mount hotplug.
> 
> While the patch set is manually written, the original motivation came
> from isolating LLM agents. Running untrusted agent workloads made it
> clear that OCI runtimes need to minimize their live configuration
> surface.
> 
> Assembling mounts, credentials, and namespaces inside helper processes
> with a half-configured container is what I see as the main challenge,
> and the existential debate around namespaces and container objects is an
> unfocused discussion topic.
> 
> [1] https://lore.kernel.org/all/155059610368.17079.2220554006494174417.stgit@warthog.procyon.org.uk/
> [2] https://lwn.net/Articles/1102593/
> 
> IMPLEMENTATION
> ==============
> 
> Standalone fd-based namespace configuration (patches 01-07) decouples
> user and mount namespace setup from live helper tasks. userns_set_idmap()
> atomically configures USERNS_SETGROUPS_ALLOWED policy and UID, GID, and
> project ID mappings on a CLONE_NEWUSER nsfs fd, checking current_cred()
> so an unprivileged creator can delegate the fd via SCM_RIGHTS to a
> privileged mapping daemon. move_mount(..., MOVE_MOUNT_T_MNTNS) operates
> on any non-anonymous mount namespace fd: on an empty mount namespace it
> installs "/" onto the nullfs root once, attaches relative submounts both
> before entry and into live mount namespaces, and supports
> MOVE_MOUNT_CLONE for recursive bind mounts without OPEN_TREE_CLONE.
> 
> userland_open() allocates a userland instance backed by a pollable
> anonymous-inode fd, creating a fresh owning user namespace and a full
> set of detached namespaces: empty mount (CLONE_EMPTY_MNTNS), PID, UTS,
> IPC, network, cgroup, and time. ioctl(ufd, USERLAND_GET_NSFD, nstype)
> returns nsfs file descriptors for member namespaces, and
> ioctl(ufd, USERLAND_SHARE_NSFD, ns_fd) replaces a member cgroup, IPC,
> UTS, network, or time namespace while the userland is in USERLAND_INIT.
> 
> Superblocks are configured directly in the target user namespace via
> fsopen(), FSCONFIG_SET_USERLAND, and fsmount() for filesystems opting
> into FS_USERLAND_MOUNT (tmpfs, ramfs, devpts, proc, mqueue) or
> FS_USERNS_DELEGATABLE, allowing unprivileged callers to assemble mounts
> without holding CAP_SYS_ADMIN in their own user namespace or entering
> the target user namespace first.
> 
> Once "/" is installed, processes are spawned into the userland via
> clone3() with CLONE_INTO_USERLAND and struct clone_args.userland,
> without modifying the calling process's own live state first. Pairing
> CLONE_INTO_USERLAND with CLONE_VFORK and opening the target binary via
> openat2(..., RESOLVE_IN_ROOT) on the retained "/" mount fd allows
> spawning with execveat() directly into the target root.
> 
> The first entrant becomes PID 1; once it exits and
> zap_pid_ns_processes() reaps all members, poll() reports EPOLLHUP and
> waitid(P_USERLAND, ufd, infop, options, NULL) returns init's exit
> status without consuming it. pidfd_send_signal(ufd, sig, NULL, 0) walks
> pid_ns->idr under tasklist_lock to signal member thread groups, and
> dedicated LSM hooks mediate userland allocation, teardown, namespace
> sharing, process entry, and signal delivery.
> 
> SYSCALLS
> ========
> 
> Two new system calls are proposed:
> 
> 1. userland_open(): open an opaque staircase-initialized container
>    object (modeled on Intel SGX enclave initialization with separate
>    build and live states) with no embryonic state, opting selected
>    shared namespaces in via an allow-list instead of unshare semantics.
> 2. userns_set_idmap(): configure all UID, GID, and project ID map
>    extents for a container user namespace in a single atomic system
>    call.
> 
> Extensions to existing system calls:
> 
> 1. move_mount() (MOVE_MOUNT_T_MNTNS, MOVE_MOUNT_CLONE): install "/" and
>    relative submounts into a mount namespace fd before entry or at
>    runtime, and recursively bind-clone mount trees without
>    OPEN_TREE_CLONE.
> 2. clone3() (CLONE_INTO_USERLAND, struct clone_args.userland): spawn
>    PID 1 and subsequent processes directly into a userland without
>    modifying the calling process's own live state first.
> 3. fsopen() / fsconfig() / fsmount() (FSCONFIG_SET_USERLAND): bind a
>    filesystem context to a userland's namespaces and create mounts
>    without entering its user namespace.
> 4. waitid() (P_USERLAND): wait on a userland fd for PID 1 exit and read
>    its exit status without consuming it.
> 5. pidfd_send_signal(): broadcast signals to member thread groups via a
>    userland fd.
> 6. ioctl() (USERLAND_GET_NSFD, USERLAND_SHARE_NSFD): open member nsfs
>    file descriptors and opt selected namespaces into existing nsfs fds
>    during USERLAND_INIT.
> 
> HOTPLUG
> =======
> 
> 1. Host calls userland_open().
> 2. Host sets uid/gid maps with userns_set_idmap().
> 3. Host populates "/" with MOVE_MOUNT_T_MNTNS, optionally combined with
>    MOVE_MOUNT_CLONE for bind mounts.
> 4. Host spawns PID 1 with clone3(CLONE_INTO_USERLAND) (optionally
>    passing an AF_UNIX socketpair fd for communication).
> 5. PID 1 watches /proc/self/ns/mnt via fanotify(FAN_REPORT_MNT |
>    FAN_MARK_MNTNS, FAN_MNT_ATTACH) or polls /proc/self/mountinfo.
> 6. On hotplug, host mounts the filesystem via fsopen() /
>    fsconfig(FSCONFIG_SET_USERLAND) / fsmount() (plus optional
>    MOUNT_ATTR_IDMAP).
> 7. Host creates the mountpoint with openat2(RESOLVE_IN_ROOT) + mkdirat()
>    and attaches the mount with MOVE_MOUNT_T_MNTNS.
> 8. PID 1 receives FAN_MNT_ATTACH and queries the new mount via
>    statmount().

The initial ad-hoc testing of hotplug using a bare metal x86-64 machine
and systemd-nspawn has been successful. The kselftest seems provide
pretty good guarantees for the basic stability; using the syscalls has
caused no issues so far.

I took some time to go through my experimental SystemD patch files and
sliced them so that they ought to be easy to bisect and refactor. They
should be also quite easy to read, understand and evaluate. Finally, I
removed the shitty patch files from my test harness repository.

Resulting outcomes of all of this are:

1. Rebased RFC v7 patches with refined LSM support and fixes to the
   known issues as of today:
   https://git.kernel.org/pub/scm/linux/kernel/git/jarkko/linux-tpmdd.git/log/?h=userland
2. SystemD patches:
   https://github.com/jarkkojs/systemd/commits/userland/

No new issues were found during testing, other than fixing the issues
reported to this thread. This is all feels fairly nice, clean and
stable.

Br, Jarkko 
