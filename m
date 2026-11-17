Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794892129;
	b=kaNyeHMfszvrF//jCsgsS/1FvKZCNpARCzI3FolJExRpukd/HQxxBRntPsx2b/tUOIYh
	 Tt2O2GxMnpTIj8bpt5Fa7L1txzm3+VlxiVpokDmJ46V+M3ZqQZEoFk1LgCSGp7U1M/9Dc
	 X9ugBnJeOt8ApQ1JNYtpUjnJaUo8+V5IiAaePytzE9lNlpHQvkEibxahQtL7vpdBDpaGZ
	 HYFKc3I53z4eT082j+zrdibjRTlCSA18CUdc4xpvQhxGsjJN6VUiH5MBRRZSO30P23Bzz
	 wqe5NknltXvzijK4FfIEj5IMyD470klo4/N8CDTPYbKGWXXuqiJWKVWFU/BbeA6Ne9w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794892129;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 MIME-Version:Content-Transfer-Encoding;
	bh=EHOaglGu01L1Blez6rThdkeRSDoeQsisrNfdJmtnDfw=;
	b=hGF3SyrGlrM8quqJKIJYq+GgoyJzoXQcfIXj4RgvV8+McljV65pIbv6C6BhjDWbF6WOa
	 afOvUWoY/lTlj/jtq9/BDRz+7eHWtMCwnUEWiuIXNKsOwJd+Ui5cyQmegnZJO/89CEybR
	 NKn/YzBr/AVqFA2z7l+atuxD7UM1bhBGdc+C/Rp9WLSUddscE6hoH2pkjfBv12FOdg0cc
	 Du3io3xvqZk1JCIXyCyfyAH+MhLb6EDDOF7ACXiucboG1zmoX+ocJgA4CuI85TynFTmfH
	 F9MQF0Nn3CuQ2LsUED5U4lG0hoK5nxh6CiSBha5bw8u2TOS8G48ZqClkWedgAFqUFdw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=LEczq6rN;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id BBD4B606A31C;
	Tue, 17 Nov 2026 05:08:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=LEczq6rN
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 9A8CC1F000C5;
	Tue, 17 Nov 2026 05:08:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794892129;
	bh=EHOaglGu01L1Blez6rThdkeRSDoeQsisrNfdJmtnDfw=;
	h=From:To:Cc:Subject:Date;
	b=LEczq6rNDD7/cZElMucuSr8e9ue2aG8F06dN2crHVgmE7ZPKTXCa7tv+Xg5QuIC1J
	 xycva1j6I8rXKchoZy3SblemaCtNsHXPwWgLGsMfvy2S7ruepM7D9KUXZb3ny81NGO
	 8MWnS8r6SViQfto5mHPABF2iC4OAlQrjDCB5zp419SJcpQ7hahNnNMbEUgldJL4Sh+
	 jTOhvPMAcTPyM9Y06iGqVZ+rZ6hRsJ64zi9p+dcXKE+v0MQHVcM8BEmJQRU3B908Jr
	 q+vVswDXYKILSq1zDUtt96nII0FBEln74u0FpB4+9SWdxzNO3xNNvb+h0dlWA7d60E
	 7EjJRf+RRy4Uw==
From: Jarkko Sakkinen <jarkko@kernel.org>
To: linux-fsdevel@vger.kernel.org
Cc: Jarkko Sakkinen <jarkko@kernel.org>,
	linux-api@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org,
	linux-security-module@vger.kernel.org,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Andrew Morton <akpm@linux-foundation.org>,
	Ben Segall <bsegall@google.com>,
	Christian Brauner <brauner@kernel.org>,
	David Hildenbrand <david@kernel.org>,
	David Howells <dhowells@redhat.com>,
	Davidlohr Bueso <dave@stgolabs.net>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Ingo Molnar <mingo@redhat.com>,
	Jan Kara <jack@suse.cz>,
	Jonathan Corbet <corbet@lwn.net>,
	Juri Lelli <juri.lelli@redhat.com>,
	Kees Cook <kees@kernel.org>,
	K Prateek Nayak <kprateek.nayak@amd.com>,
	"Liam R. Howlett" <liam@infradead.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Manfred Spraul <manfred@colorfullife.com>,
	Mel Gorman <mgorman@suse.de>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Neal Gompa <neal@gompa.dev>,
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
	Vlastimil Babka <vbabka@kernel.org>
Subject: [RFC PATCH 00/13] Namespace for namespace roots
Date: Tue, 17 Nov 2026 07:08:28 +0200
Message-ID: <20261117050841.3289652-1-jarkko@kernel.org>
X-Mailer: git-send-email 2.47.3
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Post: <mailto:linux-api@vger.kernel.org>
List-Help: <mailto:linux-api+help@vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-api+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

OVERVIEW
========

The problem that root namespaces try to resolve is starting a container
from a root mount tree that is pre-populated before any process is allowed
to run, without inheriting any host mount-tree ancestors.

Work on this feature started originally in 2025 from David Howells'
container object patch set [1], but I turned container objects into a
namespace of namespace roots and built a new implementation around this
premise.

In early 2026, the patch set was left to gather dust in my kernel tree
[2]. Then, the other day I saw [3] as was shocked by its over the top
complexity and thus, here we are.

Not doubling the number of container frameworks inside Linux kernel is at
least a benefit over container object based solutions. Parallel plumbing is
an inherent flaw of container objects, and it directly affects on
development and maintenance cost of container runtimes.

Also, thanks to better scoped implementation surface, verifying rootns
correctness is factors easier than with container objects, and even my
early kselftest is meaningful. We know what and where we are testing,
which is always great.

Finally, it is more compatible with pre-existing container tooling
whereas container objects would have much higher cost.

[1] https://lore.kernel.org/all/155059610368.17079.2220554006494174417.stgit@warthog.procyon.org.uk/
[2] https://git.kernel.org/pub/scm/linux/kernel/git/jarkko/linux-tpmdd.git/log/?h=rootns
[3] https://lore.kernel.org/linux-fsdevel/20261105-b4-cells-v3-0-bc9095937a84@toxicpanda.com/

IMPLEMENTATION
==============

rootns_create() allocates a rootns object backed by a pollable anonymous
inode fd, pinning dedicated empty mount (CLONE_EMPTY_MNTNS) and PID
namespaces along with any optional namespaces selected in flags.

Before entry, a manager prepares the mount tree through the control fd:
FSCONFIG_SET_ROOTNS binds a newly opened fs_context to the target rootns,
and move_mount(..., MOVE_MOUNT_T_ROOTNS_ROOT) installs "/" onto the nullfs
root once and attaches relative submounts beneath it.

rootns_enter() forks a child directly into the rootns credentials,
nsproxy, and root path without mutating the caller in place. The first
entrant becomes PID 1; once it exits and zap_pid_ns_processes() reaps all
members, poll() reports EPOLLHUP and rootns_wait() returns init's status
and rusage. rootns_kill() walks pid_ns->idr under RCU to signal member
thread groups.

Namespaces allocated by member tasks inherit the owning rootns ID in
__ns_common_init() so intra-rootns clone(), unshare(), open_tree(), and
setns() work while foreign setns() calls fail with -EPERM.

Cc: linux-api@vger.kernel.org
Cc: linux-doc@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: linux-kselftest@vger.kernel.org
Cc: linux-mm@kvack.org
Cc: linux-security-module@vger.kernel.org
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Ben Segall <bsegall@google.com>
Cc: Christian Brauner <brauner@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: David Howells <dhowells@redhat.com>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Cc: Dietmar Eggemann <dietmar.eggemann@arm.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Jarkko Sakkinen <jarkko@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Juri Lelli <juri.lelli@redhat.com>
Cc: Kees Cook <kees@kernel.org>
Cc: K Prateek Nayak <kprateek.nayak@amd.com>
Cc: "Liam R. Howlett" <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Manfred Spraul <manfred@colorfullife.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Neal Gompa <neal@gompa.dev>
Cc: Paul Moore <paul@paul-moore.com>
Cc: Pavel Tikhomirov <ptikhomirov@virtuozzo.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Serge Hallyn <sergeh@kernel.org>
Cc: Shuah Khan <skhan@linuxfoundation.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Valentin Schneider <vschneid@redhat.com>
Cc: Vincent Guittot <vincent.guittot@linaro.org>
Cc: Vlastimil Babka <vbabka@kernel.org>

Jarkko Sakkinen (13):
  nsproxy: Pass nsproxy to create_new_namespaces()
  rootns: Add core infrastructure for root namespaces
  rootns: Track init lifecycle via copy_process() and pid_namespace
  rootns: Add rootns_create() system call
  rootns: Add rootns_wait() system call
  rootns: Add rootns_kill() system call
  rootns: Add rootns_enter() system call
  fs: Support FSCONFIG_SET_ROOTNS in fsconfig()
  fs: Support installing rootns mount trees via move_mount()
  arch: Wire up rootns system calls
  docs: Document root namespace uAPI
  selftests/rootns: Add root namespace test suite
  MAINTAINERS: Add entry for ROOT NAMESPACE

 Documentation/userspace-api/index.rst       |    1 +
 Documentation/userspace-api/rootns.rst      |   35 +
 MAINTAINERS                                 |   11 +
 arch/alpha/kernel/syscalls/syscall.tbl      |    4 +
 arch/arm/tools/syscall.tbl                  |    4 +
 arch/arm64/tools/syscall_32.tbl             |    4 +
 arch/m68k/kernel/syscalls/syscall.tbl       |    4 +
 arch/microblaze/kernel/syscalls/syscall.tbl |    4 +
 arch/mips/kernel/syscalls/syscall_n32.tbl   |    4 +
 arch/mips/kernel/syscalls/syscall_n64.tbl   |    4 +
 arch/mips/kernel/syscalls/syscall_o32.tbl   |    4 +
 arch/parisc/kernel/syscalls/syscall.tbl     |    4 +
 arch/powerpc/kernel/syscalls/syscall.tbl    |    4 +
 arch/s390/kernel/syscalls/syscall.tbl       |    4 +
 arch/sh/kernel/syscalls/syscall.tbl         |    4 +
 arch/sparc/kernel/syscalls/syscall.tbl      |    4 +
 arch/x86/entry/syscalls/syscall_32.tbl      |    4 +
 arch/x86/entry/syscalls/syscall_64.tbl      |    4 +
 arch/xtensa/kernel/syscalls/syscall.tbl     |    4 +
 fs/fsopen.c                                 |   74 +-
 fs/namespace.c                              |  176 ++-
 fs/proc/root.c                              |   13 +
 include/linux/compat.h                      |    4 +
 include/linux/cred.h                        |    4 +-
 include/linux/fs_context.h                  |    3 +
 include/linux/ns/ns_common_types.h          |    4 +
 include/linux/nsproxy.h                     |   27 +-
 include/linux/pid_namespace.h               |    4 +
 include/linux/rootns.h                      |   87 ++
 include/linux/sched/task.h                  |    4 +
 include/linux/syscalls.h                    |    5 +
 include/uapi/asm-generic/unistd.h           |   12 +-
 include/uapi/linux/mount.h                  |    4 +-
 include/uapi/linux/rootns.h                 |   38 +
 init/Kconfig                                |    9 +
 ipc/mqueue.c                                |   12 +
 kernel/Makefile                             |    2 +
 kernel/cred.c                               |   70 +-
 kernel/fork.c                               |   29 +-
 kernel/nscommon.c                           |    8 +
 kernel/nsproxy.c                            |   49 +-
 kernel/pid_namespace.c                      |    2 +
 kernel/rootns.c                             |  599 +++++++++
 kernel/sys_ni.c                             |    7 +
 scripts/syscall.tbl                         |    4 +
 tools/testing/selftests/Makefile            |    1 +
 tools/testing/selftests/rootns/.gitignore   |    2 +
 tools/testing/selftests/rootns/Makefile     |    5 +
 tools/testing/selftests/rootns/config       |    9 +
 tools/testing/selftests/rootns/smoke.c      | 1254 +++++++++++++++++++
 50 files changed, 2559 insertions(+), 73 deletions(-)
 create mode 100644 Documentation/userspace-api/rootns.rst
 create mode 100644 include/linux/rootns.h
 create mode 100644 include/uapi/linux/rootns.h
 create mode 100644 kernel/rootns.c
 create mode 100644 tools/testing/selftests/rootns/.gitignore
 create mode 100644 tools/testing/selftests/rootns/Makefile
 create mode 100644 tools/testing/selftests/rootns/config
 create mode 100644 tools/testing/selftests/rootns/smoke.c

--
2.47.3

