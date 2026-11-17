Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794913858;
	b=uIALsYU/cpVE5ApG7mX0E4VaEA5MolocAQWMHLWD6EXFMbh8xADEbu49Ci140mRVbx7c
	 fjKxBb/K1VSKyxWQ3W4/EC4UkZ1zWSYlE72p3Y5T4tfCLtQBrZlP3ff6HwGQIBowWSFj5
	 ///Plv1dBe+D/0TjzH07o30PStW2Ku7iYb25fcGBpLB9O5q2bhPgw1VwiV1674aIP9TOe
	 OWP0rh6uYRnxGavhufOm8PFgr9rkVU5WdUDH0avmAs+bkZnXbZqU66bpqpiba6ct+hLFN
	 7SYcanOZuexMROJkXIuwuKtQ3Efp0K5gdUM6loeyeJ+w74ObeP3rYTh5QKCOl7+Om0g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794913858;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=dvoI2Z2WNg5T4pHtVZggNJofexwqVtIKLoTu7i4tUi0=;
	b=G2b/9z5viFU/OrLsQRUFG6gSlkJg/kLJW7+ZzWzv9T3bisQeRdCIv96dHln3jo4wvgGg
	 Vk9iHy4kAzqh1ag+OE3yuiy1QFKc7JuxleSAPWYQfaIIghz9e0KfXkb9oC4TYgOfjyP+E
	 Kl9/fyuQSR/+uI/v50IpWw0spni9r+PMGg8NnNZFKdG/mtdYlze8wklBg9a/V3t0YP6dW
	 xmWXUv36XqcGXxGox6MBpKz76QrmgS6RP+RzQ+Aq8WbHR+KS65CVa2bpK6pTJ1XsrNVc4
	 gSdIfkRoZ54PuGGSnTe0JGnY3wxjf0/LQwlT8r7d7CL21SijYbjuL6xwO24Lh8u18zw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Jzh263Ql;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id 16C1E606A31C;
	Tue, 17 Nov 2026 11:10:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Jzh263Ql
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id E7C381F000C5;
	Tue, 17 Nov 2026 11:10:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794913857;
	bh=dvoI2Z2WNg5T4pHtVZggNJofexwqVtIKLoTu7i4tUi0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Jzh263Ql3sBter/ir2vEmp5ydzrO1Ocnawrz5yyuG8H2PDbQVGRjsJXHQWpO0WGc1
	 0Md5oRqYRswExKLjJJOhnfgc9Ra9y4DdR/o+KFMDN0Dc9pwJZRZFgLkYyiPjCWvYkq
	 HWtKlatBkGAq5Lcfkr+wGDncmORVwP8qu2nxVmXzyf7USdQI+q7v9wSvOEn59jsXTP
	 TkzX70xBQ6eNPKsGdV5CZuoOp28EROPCKU1y+ni3GR6GTAk5lP4pTWXA+pVVeuckB+
	 ujIkONmElPUvhm86ckJvNb/akAMGbPgn/MU/kqFLEE6MJv3eGg8kmt5ISV5nOJSVBr
	 d/ByM9U/IzS4Q==
Date: Tue, 17 Nov 2026 13:10:54 +0200
From: Jarkko Sakkinen <jarkko@kernel.org>
To: linux-fsdevel@vger.kernel.org
Cc: linux-api@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org, linux-security-module@vger.kernel.org,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Andrew Morton <akpm@linux-foundation.org>,
	Ben Segall <bsegall@google.com>,
	Christian Brauner <brauner@kernel.org>,
	David Hildenbrand <david@kernel.org>,
	David Howells <dhowells@redhat.com>,
	Davidlohr Bueso <dave@stgolabs.net>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Ingo Molnar <mingo@redhat.com>, Jan Kara <jack@suse.cz>,
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
	Valentin Schneider <vschneid@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	John Johansen <john.johansen@canonical.com>
Subject: Re: [RFC PATCH 00/13] Namespace for namespace roots
Message-ID: <avw2PlAWYbPtZzhE@kernel.org>
References: <20261117050841.3289652-1-jarkko@kernel.org>
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
In-Reply-To: <20261117050841.3289652-1-jarkko@kernel.org>

Possibly also:

	Cc: John Johansen <john.johansen@canonical.com>

The cc list was generated via:

	./scripts/get_maintainer.pl --nogit --nogit-fallback --norolestats 00[0-9][1-9]*.patch |  awk '{print "Cc: " $0}' | sort

Br, Jarkko

On Tue, Nov 17, 2026 at 07:08:28AM +0200, Jarkko Sakkinen wrote:
> OVERVIEW
> ========
> 
> The problem that root namespaces try to resolve is starting a container
> from a root mount tree that is pre-populated before any process is allowed
> to run, without inheriting any host mount-tree ancestors.
> 
> Work on this feature started originally in 2025 from David Howells'
> container object patch set [1], but I turned container objects into a
> namespace of namespace roots and built a new implementation around this
> premise.
> 
> In early 2026, the patch set was left to gather dust in my kernel tree
> [2]. Then, the other day I saw [3] as was shocked by its over the top
> complexity and thus, here we are.
> 
> Not doubling the number of container frameworks inside Linux kernel is at
> least a benefit over container object based solutions. Parallel plumbing is
> an inherent flaw of container objects, and it directly affects on
> development and maintenance cost of container runtimes.
> 
> Also, thanks to better scoped implementation surface, verifying rootns
> correctness is factors easier than with container objects, and even my
> early kselftest is meaningful. We know what and where we are testing,
> which is always great.
> 
> Finally, it is more compatible with pre-existing container tooling
> whereas container objects would have much higher cost.
> 
> [1] https://lore.kernel.org/all/155059610368.17079.2220554006494174417.stgit@warthog.procyon.org.uk/
> [2] https://git.kernel.org/pub/scm/linux/kernel/git/jarkko/linux-tpmdd.git/log/?h=rootns
> [3] https://lore.kernel.org/linux-fsdevel/20261105-b4-cells-v3-0-bc9095937a84@toxicpanda.com/
> 
> IMPLEMENTATION
> ==============
> 
> rootns_create() allocates a rootns object backed by a pollable anonymous
> inode fd, pinning dedicated empty mount (CLONE_EMPTY_MNTNS) and PID
> namespaces along with any optional namespaces selected in flags.
> 
> Before entry, a manager prepares the mount tree through the control fd:
> FSCONFIG_SET_ROOTNS binds a newly opened fs_context to the target rootns,
> and move_mount(..., MOVE_MOUNT_T_ROOTNS_ROOT) installs "/" onto the nullfs
> root once and attaches relative submounts beneath it.
> 
> rootns_enter() forks a child directly into the rootns credentials,
> nsproxy, and root path without mutating the caller in place. The first
> entrant becomes PID 1; once it exits and zap_pid_ns_processes() reaps all
> members, poll() reports EPOLLHUP and rootns_wait() returns init's status
> and rusage. rootns_kill() walks pid_ns->idr under RCU to signal member
> thread groups.
> 
> Namespaces allocated by member tasks inherit the owning rootns ID in
> __ns_common_init() so intra-rootns clone(), unshare(), open_tree(), and
> setns() work while foreign setns() calls fail with -EPERM.
> 
> Cc: linux-api@vger.kernel.org
> Cc: linux-doc@vger.kernel.org
> Cc: linux-fsdevel@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> Cc: linux-kselftest@vger.kernel.org
> Cc: linux-mm@kvack.org
> Cc: linux-security-module@vger.kernel.org
> Cc: Alexander Viro <viro@zeniv.linux.org.uk>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Ben Segall <bsegall@google.com>
> Cc: Christian Brauner <brauner@kernel.org>
> Cc: David Hildenbrand <david@kernel.org>
> Cc: David Howells <dhowells@redhat.com>
> Cc: Davidlohr Bueso <dave@stgolabs.net>
> Cc: Dietmar Eggemann <dietmar.eggemann@arm.com>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: Jan Kara <jack@suse.cz>
> Cc: Jarkko Sakkinen <jarkko@kernel.org>
> Cc: Jonathan Corbet <corbet@lwn.net>
> Cc: Juri Lelli <juri.lelli@redhat.com>
> Cc: Kees Cook <kees@kernel.org>
> Cc: K Prateek Nayak <kprateek.nayak@amd.com>
> Cc: "Liam R. Howlett" <liam@infradead.org>
> Cc: Lorenzo Stoakes <ljs@kernel.org>
> Cc: Manfred Spraul <manfred@colorfullife.com>
> Cc: Mel Gorman <mgorman@suse.de>
> Cc: Michal Hocko <mhocko@suse.com>
> Cc: Mike Rapoport <rppt@kernel.org>
> Cc: Neal Gompa <neal@gompa.dev>
> Cc: Paul Moore <paul@paul-moore.com>
> Cc: Pavel Tikhomirov <ptikhomirov@virtuozzo.com>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Randy Dunlap <rdunlap@infradead.org>
> Cc: Serge Hallyn <sergeh@kernel.org>
> Cc: Shuah Khan <skhan@linuxfoundation.org>
> Cc: Steven Rostedt <rostedt@goodmis.org>
> Cc: Suren Baghdasaryan <surenb@google.com>
> Cc: Valentin Schneider <vschneid@redhat.com>
> Cc: Vincent Guittot <vincent.guittot@linaro.org>
> Cc: Vlastimil Babka <vbabka@kernel.org>
> 
> Jarkko Sakkinen (13):
>   nsproxy: Pass nsproxy to create_new_namespaces()
>   rootns: Add core infrastructure for root namespaces
>   rootns: Track init lifecycle via copy_process() and pid_namespace
>   rootns: Add rootns_create() system call
>   rootns: Add rootns_wait() system call
>   rootns: Add rootns_kill() system call
>   rootns: Add rootns_enter() system call
>   fs: Support FSCONFIG_SET_ROOTNS in fsconfig()
>   fs: Support installing rootns mount trees via move_mount()
>   arch: Wire up rootns system calls
>   docs: Document root namespace uAPI
>   selftests/rootns: Add root namespace test suite
>   MAINTAINERS: Add entry for ROOT NAMESPACE
> 
>  Documentation/userspace-api/index.rst       |    1 +
>  Documentation/userspace-api/rootns.rst      |   35 +
>  MAINTAINERS                                 |   11 +
>  arch/alpha/kernel/syscalls/syscall.tbl      |    4 +
>  arch/arm/tools/syscall.tbl                  |    4 +
>  arch/arm64/tools/syscall_32.tbl             |    4 +
>  arch/m68k/kernel/syscalls/syscall.tbl       |    4 +
>  arch/microblaze/kernel/syscalls/syscall.tbl |    4 +
>  arch/mips/kernel/syscalls/syscall_n32.tbl   |    4 +
>  arch/mips/kernel/syscalls/syscall_n64.tbl   |    4 +
>  arch/mips/kernel/syscalls/syscall_o32.tbl   |    4 +
>  arch/parisc/kernel/syscalls/syscall.tbl     |    4 +
>  arch/powerpc/kernel/syscalls/syscall.tbl    |    4 +
>  arch/s390/kernel/syscalls/syscall.tbl       |    4 +
>  arch/sh/kernel/syscalls/syscall.tbl         |    4 +
>  arch/sparc/kernel/syscalls/syscall.tbl      |    4 +
>  arch/x86/entry/syscalls/syscall_32.tbl      |    4 +
>  arch/x86/entry/syscalls/syscall_64.tbl      |    4 +
>  arch/xtensa/kernel/syscalls/syscall.tbl     |    4 +
>  fs/fsopen.c                                 |   74 +-
>  fs/namespace.c                              |  176 ++-
>  fs/proc/root.c                              |   13 +
>  include/linux/compat.h                      |    4 +
>  include/linux/cred.h                        |    4 +-
>  include/linux/fs_context.h                  |    3 +
>  include/linux/ns/ns_common_types.h          |    4 +
>  include/linux/nsproxy.h                     |   27 +-
>  include/linux/pid_namespace.h               |    4 +
>  include/linux/rootns.h                      |   87 ++
>  include/linux/sched/task.h                  |    4 +
>  include/linux/syscalls.h                    |    5 +
>  include/uapi/asm-generic/unistd.h           |   12 +-
>  include/uapi/linux/mount.h                  |    4 +-
>  include/uapi/linux/rootns.h                 |   38 +
>  init/Kconfig                                |    9 +
>  ipc/mqueue.c                                |   12 +
>  kernel/Makefile                             |    2 +
>  kernel/cred.c                               |   70 +-
>  kernel/fork.c                               |   29 +-
>  kernel/nscommon.c                           |    8 +
>  kernel/nsproxy.c                            |   49 +-
>  kernel/pid_namespace.c                      |    2 +
>  kernel/rootns.c                             |  599 +++++++++
>  kernel/sys_ni.c                             |    7 +
>  scripts/syscall.tbl                         |    4 +
>  tools/testing/selftests/Makefile            |    1 +
>  tools/testing/selftests/rootns/.gitignore   |    2 +
>  tools/testing/selftests/rootns/Makefile     |    5 +
>  tools/testing/selftests/rootns/config       |    9 +
>  tools/testing/selftests/rootns/smoke.c      | 1254 +++++++++++++++++++
>  50 files changed, 2559 insertions(+), 73 deletions(-)
>  create mode 100644 Documentation/userspace-api/rootns.rst
>  create mode 100644 include/linux/rootns.h
>  create mode 100644 include/uapi/linux/rootns.h
>  create mode 100644 kernel/rootns.c
>  create mode 100644 tools/testing/selftests/rootns/.gitignore
>  create mode 100644 tools/testing/selftests/rootns/Makefile
>  create mode 100644 tools/testing/selftests/rootns/config
>  create mode 100644 tools/testing/selftests/rootns/smoke.c
> 
> --
> 2.47.3
> 
