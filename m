Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795036976;
	b=oGBveMXfn70MndCAI/lHJuZCKHt1ZmUAXf9nlcWWjPnG7F/wNdK0a4w38icKZ40tGN4H
	 jIAWSUeTFKfCH53x9pfSCUthaFrAytY3MGmNTkrdJeOHwX7QmCCAqMEB79fmooZDOGy+s
	 bmZZzxeTEy8/uR1C9xbylhig5gDGvDroLjImackE36Twd/uaKxUxY5uoZvvrBeWStyzYh
	 Vr28NghNyDo72EV8tVOHGoV8MTrUlGDm/eYBhqOtlGPoRLdSUNEJvPlMbl8qVaJ/Ywcqa
	 eyFG2aeHVnwGFh6Lgi+wfYmCJvz8cUmFMy78yh54fP0Yid+OJfryjIpX0g6E9XDLKcw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795036976;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=vqtZas3t5wXmBF7qeLP24ETZ+NnHhg0AAw7WUrgO5/M=;
	b=leWOvHPL7P3/S0xaO7i4oBhePMp6+uRPAKM47EHD1CeAyIMyfvqJ5UKBdNCg6j8Uh1wg
	 KVHH2+UjoQoXKMsVkrXPmzrd1EqktsCNU/6aE6ep24xb+E4LRvG8y/lq4edxsVyBh9M3u
	 z+iowanOGQKq7I+hGQ6m/skkV8XICqhq5H8lq9TfJWhW/ck4NmD14kwefGIjxm+gsiKek
	 jjFY7j1RpgQJcTONEodFb4kR+PhbV0FNJt4SfmAgj6w+IPI5dr2kSlHJ5p+827mlsN6vH
	 NEP8MSTGQ5OIBljS15i/+UD83Ow4dHwEbPZGG3CxHCUErAH4x6KX78ZOCU5F+aA1/Xw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Ml+aVGKv;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id 5DE5B606A31C;
	Wed, 18 Nov 2026 21:22:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Ml+aVGKv
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 733A41F000C4;
	Wed, 18 Nov 2026 21:22:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795036976;
	bh=vqtZas3t5wXmBF7qeLP24ETZ+NnHhg0AAw7WUrgO5/M=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Ml+aVGKvvIC5pcrzx9ZzwGHLtrNZnut1ESXjSEU2HVNx6KxFl13Zr+qffUFbbPCwW
	 V83mH7Py3EnQBPKdeQ6gpt7TyHQQlg5bEPLKqrq2wu1xjOrLWufishv37LqIoW8BFs
	 YQp1QvRsDrJQWGENlrzay8K370ntnq0LSRLNiftl+fd7XrzLs8QDVSKZwPJ3ElX+vi
	 OjP/miHHrlWI0I0NTP6aPNfvZ2Uz7sgVwWjL+HOqy7hVzjmWfdLN31G6Jok2wePmbd
	 RziLHmPCbpggAo4Y/HUC9dK4Gjc1b5IRHx6l3+MHzVFmMxy1ndqJ3CxDspiyEHOVVd
	 1GWZ+a/AyLQMA==
Date: Wed, 18 Nov 2026 23:22:52 +0200
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
Message-ID: <av4XLJcO0y8CbGT-@kernel.org>
References: <20261118193539.240065-1-jarkko@kernel.org>
 <av4CdM-eW73oO4wB@kernel.org>
 <av4NonrcCxzMoDyz@kernel.org>
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
In-Reply-To: <av4NonrcCxzMoDyz@kernel.org>

On Wed, Nov 18, 2026 at 10:42:15PM +0200, Jarkko Sakkinen wrote:
> On Wed, Nov 18, 2026 at 09:54:32PM +0200, Jarkko Sakkinen wrote:
> > On Wed, Nov 18, 2026 at 09:35:26PM +0200, Jarkko Sakkinen wrote:
> > > OVERVIEW
> > > ========
> > > 
> > > A root namespace (rootns) is a kernel object backed by a file descriptor
> > > that binds together:
> > > 
> > > 1. A full set of detached namespaces owned by a fresh user namespace.
> > > 2. A dedicated PID namespace for spawning processes into, signaling
> > >    members, and polling or waiting on PID 1 exit.
> > > 3. An initially empty mount namespace (CLONE_EMPTY_MNTNS) populated
> > >    directly in its target user namespace before going live, without
> > >    inheriting host mounts or cloning staged trees, while still allowing
> > >    new mounts to be attached at runtime.
> > > 
> > > Work on this feature started in 2025 from David Howells' container object
> > > patch set [1], which I turned into a namespace for namespace roots and
> > > rebuilt around that premise.
> > > 
> > > While the patch set is manually written, the original motivation came
> > > from isolating LLM agents. Running untrusted agent workloads made it
> > > clear that OCI runtimes need to minimize their live configuration
> > > surface.
> > > 
> > > Assembling mounts, credentials, and namespaces inside helper processes
> > > with a half-configured container is what I see as the main challenge,
> > > and the existential debate around namespaces and container objects is an
> > > unfocused discussion topic.
> > > 
> > > [1] https://lore.kernel.org/all/155059610368.17079.2220554006494174417.stgit@warthog.procyon.org.uk/
> > > 
> > > IMPLEMENTATION
> > > ==============
> > > 
> > > rootns_create() allocates a rootns instance backed by a pollable
> > > anonymous inode fd, creating a fresh owning user namespace and a full set
> > > of detached namespaces: empty mount (CLONE_EMPTY_MNTNS), PID, UTS, IPC,
> > > network, cgroup, and time. ioctl(rootnsfd, ROOTNS_GET_NSFD, nstype)
> > > returns nsfs file descriptors for individual member namespaces when
> > > standalone namespace operations are needed.
> > > 
> > > Superblocks are configured directly in the target user namespace via
> > > fsopen(), FSCONFIG_SET_ROOTNS, and fsmount(), allowing unprivileged
> > > callers to assemble FS_USERNS_MOUNT filesystems without holding
> > > CAP_SYS_ADMIN in their own user namespace or entering the target user
> > > namespace first. move_mount(..., MOVE_MOUNT_T_MNTNS) operates on any
> > > non-anonymous mount namespace fd: on an empty mount namespace it installs
> > > "/" onto the nullfs root once, and it attaches relative submounts both
> > > before entry and into live mount namespaces.
> > > 
> > > Once "/" is installed, processes are spawned into the rootns via clone3()
> > > with CLONE_INTO_ROOTNS and struct clone_args.rootns, without mutating the
> > > caller in place. Pairing CLONE_INTO_ROOTNS with CLONE_VM | CLONE_VFORK
> > > and opening the target binary via openat2(..., RESOLVE_IN_ROOT) on the
> > > retained "/" mount fd allows spawning with execveat() without copying
> > > page tables.
> > > 
> > > The first entrant becomes PID 1; once it exits and
> > > zap_pid_ns_processes() reaps all members, poll() reports EPOLLHUP and
> > > rootns_wait() returns init's exit status and rusage. rootns_kill() walks
> > > pid_ns->idr under tasklist_lock to signal member thread groups.
> > > 
> > > CHANGES
> > > =======
> > > 
> > > v3:
> > > - The patch set size increased predominantly because the coverage of
> > >   kselftest had to widened to cover the introduced changes.
> > > - Replace MOVE_MOUNT_T_ROOTNS_ROOT with MOVE_MOUNT_T_MNTNS targeting
> > >   mnt_ns nsfs fds, and add ioctl(ROOTNS_GET_NSFD) to open member
> > >   namespace fds (Andy Lutomirski).
> > > - Allow unprivileged fsopen(), FSCONFIG_SET_ROOTNS, and fsmount() to
> > >   configure and mount FS_USERNS_MOUNT filesystems directly in the target
> > >   user namespace without entering it first (Andy Lutomirski).
> > > - Fix locking, refcounting, credential/dumpability/timens setup,
> > >   pivot_root() lookup, and cross-userns mount checks across copy_rootns(),
> > >   CLONE_INTO_ROOTNS, rootns_kill(), FSCONFIG_SET_ROOTNS, and move_mount()
> > >   (Sashiko).
> > > - Mark PowerPC rootns syscalls nospu (Sashiko).
> > > - Update documentation and kselftests.
> > 
> > I.e. before PID 1 and /proc/<pid>/ns/* existss, nsfd for namespace other
> > than root nsfd can be acquired as follows:
> > 
> > 	int mnts_fd = ioctl(root_fd, ROOTNS_GET_NSFD, CLONE_NEWNS);
> 
> 
> Unprivileged caller becomes the owner of rootns->user_ns. Each mount
> syscall then just checks CAP_SYS_ADMIN against rootns->user_ns.
> 
> The user space wiring goes along the lines of:
> 
>         int root_fd = rootns_create(ROOTNS_KILL_ON_CLOSE | ROOTNS_CLOSE_ON_EXEC);
>         int mntns_fd = ioctl(root_fd, ROOTNS_GET_NSFD, CLONE_NEWNS);
> 
>         int tmpfs_fd = fsopen("tmpfs", 0);
>         fsconfig(tmpfs_fd, FSCONFIG_SET_ROOTNS, NULL, NULL, root_fd);
>         fsconfig(tmpfs_fd, FSCONFIG_CMD_CREATE, NULL, NULL, 0);
>         int rootfs_fd = fsmount(tmpfs_fd, 0, 0);
> 
>         move_mount(rootfs_fd, "", mntns_fd, "/", MOVE_MOUNT_F_EMPTY_PATH | MOVE_MOUNT_T_MNTNS);
> 
>         struct clone_args args = {
>                 .flags  = CLONE_INTO_ROOTNS,
>                 .rootns = root_fd,
>         };
>         pid_t pid = clone3(&args, sizeof(args));
> 
> Note that example is uncompiled :-)
> 
> This example makes me feel that perhaps RootNS is not the best possible
> name for this but this rather should be e.g., NullNS?

Before judging this, keep in mind that I've not just suddenly invented
this. I first encountered the topic when David posted his patches, and
felt that they were a bit unfairly judged.

Somewhere at 2025 David rebased his branch when I asked, and slow-cooked
the result that we're seeing during a period of 1.5 years. It has not
been a priority topic at work so this has been more like a spare time
sudoku.

So if you count the David's original patch set version, this has
history spanning since 2017.

Br, Jarkko
