Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795031672;
	b=hMNGbPb60fVXE0OERe4R5FHEtrtPxDSSD0t8YSkaT5+62MSDvKGRL7lRcNRdStL9/W5c
	 WKvjq0zQT2WqGi9gIc4Wx+FvOLKyy228SjYK2Cb5IS4EiKrRqq7VUtrzvfsbvQ92EEVtG
	 k2eBC+9fwLKkvvb6jBAbVLJJrEUL4varDNzQazZ+RqUTLHJtkPLE0hbR9uD2ZS+qEBZHa
	 0YWVafrrpeh0yu+GGLNRaoYD9wiSmB9W+NyfenJycSupjzqW8H16LsvGvjzt2hDT2tSfD
	 612uNEpe6xbqQxsX0DF14Ew9PSzUUu7ORI5G0hbzzleda3+nuPmK/lgFVZNOQjyUoew==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795031672;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=dOMAgC0XvS4nP90YCQcBU0h+fNv/5Kz+lJp/v4CzlRY=;
	b=fKdO95ICercP4AkvPOQUL6U3pxdrGy9RTczD1uWNP8o1u92yPMPYdhrsCDJNYLBpQujs
	 ynRDYujeM1fYPWC4z9k33uNqidZpvAgsVvEbwVmR9HAV9oU+MPwBUSgnP1aLfrXok4qN0
	 a8fFsVfM4P0yISN/5Zw2A8MzXsfYpcHKgbSyBIKe98l/YafDv2JtMrOt9y9dBRhK8jYs8
	 3ZZUJhhTyqYiq70dC0H8f38fDWnMvObF6gyTAfdizX/zHISlXqVM/Neuo8cAlYQUi7RIs
	 K1nsIIaSe530F7wVFAp1btO2LgU5PzUZgewn3ON+1m/YjoIli9DNPYMiX4dY9MihLEg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=eHGDS24t;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id 3A9CE606A32A;
	Wed, 18 Nov 2026 19:54:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=eHGDS24t
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 409C51F000C4;
	Wed, 18 Nov 2026 19:54:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795031671;
	bh=dOMAgC0XvS4nP90YCQcBU0h+fNv/5Kz+lJp/v4CzlRY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=eHGDS24tKkdUdQSDE+m8Q9U7FzbKLF5B1bDQj4MZxp+NpFTpVSXqOqxZkSbRrYUCu
	 xtJKC8BPP86kLhKQWSGTmh00sX0NKvq9TjDCRYonSH8rUaaTLB11cllHumX66RUYyH
	 ScOEhGBFrGL7aznIPo29PaJXS63D224351P4tQaIaa4C2w33oRPpGvjOVaJF1GWXp0
	 yn3LJKcQWVn44OuzVcIAi7Xe0ILvDdblzEOdRn+tnrG+OFiaNe8nBeMUP2hyUdRH6G
	 ezABsk4drujjXkdYoPEJuXtySKLyTCVIg2d2O1x+lXwN8EOL9gzFhw3UcfphSBmKst
	 FR/hJTy4y6ubA==
Date: Wed, 18 Nov 2026 21:54:28 +0200
From: Jarkko Sakkinen <jarkko@kernel.org>
To: David Howells <dhowells@redhat.com>
Cc: linux-api@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org,
	linux-security-module@vger.kernel.org,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Andrew Morton <akpm@linux-foundation.org>,
	Andy Lutomirski <luto@amacapital.net>,
	Anna-Maria Behnsen <anna-maria@linutronix.de>,
	Ben Segall <bsegall@google.com>,
	Christian Brauner <brauner@kernel.org>,
	David Hildenbrand <david@kernel.org>,
	Davidlohr Bueso <dave@stgolabs.net>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Frederic Weisbecker <frederic@kernel.org>,
	Ingo Molnar <mingo@redhat.com>, Jan Kara <jack@suse.cz>,
	John Johansen <john.johansen@canonical.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Juri Lelli <juri.lelli@redhat.com>, Kees Cook <kees@kernel.org>,
	K Prateek Nayak <kprateek.nayak@amd.com>,
	"Liam R. Howlett" <liam@infradead.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Manfred Spraul <manfred@colorfullife.com>,
	Mel Gorman <mgorman@suse.de>, Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>, Neal Gompa <neal@gompa.dev>,
	Paul Moore <paul@paul-moore.com>,
	Pavel Tikhomirov <ptikhomirov@virtuozzo.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	Serge Hallyn <sergeh@kernel.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Valentin Schneider <vschneid@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Vincenzo Frascino <vincenzo.frascino@arm.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Zygmunt Krynicki <zygmunt.krynicki@canonical.com>
Subject: Re: [RFC PATCH v3 00/13] Namespace for namespace roots
Message-ID: <av4CdM-eW73oO4wB@kernel.org>
References: <20261118193539.240065-1-jarkko@kernel.org>
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
In-Reply-To: <20261118193539.240065-1-jarkko@kernel.org>

On Wed, Nov 18, 2026 at 09:35:26PM +0200, Jarkko Sakkinen wrote:
> OVERVIEW
> ========
> 
> A root namespace (rootns) is a kernel object backed by a file descriptor
> that binds together:
> 
> 1. A full set of detached namespaces owned by a fresh user namespace.
> 2. A dedicated PID namespace for spawning processes into, signaling
>    members, and polling or waiting on PID 1 exit.
> 3. An initially empty mount namespace (CLONE_EMPTY_MNTNS) populated
>    directly in its target user namespace before going live, without
>    inheriting host mounts or cloning staged trees, while still allowing
>    new mounts to be attached at runtime.
> 
> Work on this feature started in 2025 from David Howells' container object
> patch set [1], which I turned into a namespace for namespace roots and
> rebuilt around that premise.
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
> 
> IMPLEMENTATION
> ==============
> 
> rootns_create() allocates a rootns instance backed by a pollable
> anonymous inode fd, creating a fresh owning user namespace and a full set
> of detached namespaces: empty mount (CLONE_EMPTY_MNTNS), PID, UTS, IPC,
> network, cgroup, and time. ioctl(rootnsfd, ROOTNS_GET_NSFD, nstype)
> returns nsfs file descriptors for individual member namespaces when
> standalone namespace operations are needed.
> 
> Superblocks are configured directly in the target user namespace via
> fsopen(), FSCONFIG_SET_ROOTNS, and fsmount(), allowing unprivileged
> callers to assemble FS_USERNS_MOUNT filesystems without holding
> CAP_SYS_ADMIN in their own user namespace or entering the target user
> namespace first. move_mount(..., MOVE_MOUNT_T_MNTNS) operates on any
> non-anonymous mount namespace fd: on an empty mount namespace it installs
> "/" onto the nullfs root once, and it attaches relative submounts both
> before entry and into live mount namespaces.
> 
> Once "/" is installed, processes are spawned into the rootns via clone3()
> with CLONE_INTO_ROOTNS and struct clone_args.rootns, without mutating the
> caller in place. Pairing CLONE_INTO_ROOTNS with CLONE_VM | CLONE_VFORK
> and opening the target binary via openat2(..., RESOLVE_IN_ROOT) on the
> retained "/" mount fd allows spawning with execveat() without copying
> page tables.
> 
> The first entrant becomes PID 1; once it exits and
> zap_pid_ns_processes() reaps all members, poll() reports EPOLLHUP and
> rootns_wait() returns init's exit status and rusage. rootns_kill() walks
> pid_ns->idr under tasklist_lock to signal member thread groups.
> 
> CHANGES
> =======
> 
> v3:
> - The patch set size increased predominantly because the coverage of
>   kselftest had to widened to cover the introduced changes.
> - Replace MOVE_MOUNT_T_ROOTNS_ROOT with MOVE_MOUNT_T_MNTNS targeting
>   mnt_ns nsfs fds, and add ioctl(ROOTNS_GET_NSFD) to open member
>   namespace fds (Andy Lutomirski).
> - Allow unprivileged fsopen(), FSCONFIG_SET_ROOTNS, and fsmount() to
>   configure and mount FS_USERNS_MOUNT filesystems directly in the target
>   user namespace without entering it first (Andy Lutomirski).
> - Fix locking, refcounting, credential/dumpability/timens setup,
>   pivot_root() lookup, and cross-userns mount checks across copy_rootns(),
>   CLONE_INTO_ROOTNS, rootns_kill(), FSCONFIG_SET_ROOTNS, and move_mount()
>   (Sashiko).
> - Mark PowerPC rootns syscalls nospu (Sashiko).
> - Update documentation and kselftests.

I.e. before PID 1 and /proc/<pid>/ns/* existss, nsfd for namespace other
than root nsfd can be acquired as follows:

	int mnts_fd = ioctl(root_fd, ROOTNS_GET_NSFD, CLONE_NEWNS);

Br, Jarkko
