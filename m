Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794957250;
	b=qX6msZnlFXVaykS8LeC/2onM33AA9fTSvihB7B4/hED16qBclTuZUV61osF5yWJ7NxWg
	 y9YyLrwU5M67WHtB3ZeUrxK/PDqiN02eRLNXChWy63emVtmLgExoXx5hoNPYwWf5u7vEw
	 EarofQ6FvvlpIALaAXN4WcD/LuD40zxGgJ234w4ka8944wpOiwQM/weuEBxyV8fSvi++T
	 Rr87oY3i0IIxIt5nupOWpLcK6n87quRNjJxKgRJZZDpnnpcAPlor9N+tu3ZdysiKZj4Nm
	 lY3UpADj1LuMwJavx0aYPqe4bbweHRcO/7MqjDtoCWMy81sP+CnhK2THfU2x7vDD8KQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794957250;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 MIME-Version:Content-Transfer-Encoding;
	bh=yp6+Hwad/NBoam++rgWwhCOLZpBfJyHe1i278jtj9/A=;
	b=DJKXaSQgPkenXcjOF3/NvB0L9OKWXlUVRjKYs2cZVoXxnpZGEs+iP1xwSWwJq3Cuuz5l
	 NDHt7x+U4q4Fypzm7HPhQkvXWhjx30gyLIDJ0IVrMu9H8G4ej880AjIER2wmn7HXv8yl2
	 8HzmCJNzGBnqB7d4TWAFkfu2ZmJTUCoXyDTyVUHhXvercPpCMmy5kMqzaZmzbAeGsOpDM
	 WUSQDhPBC8s78Q/Bvr7LL32pVKkbGS0WVAPRa/Hr/VOlhrD9k6n67lunMxQLorrXSqPIm
	 /HWWu/p+ZaQz+UKQIjUh+lnBY2LOh5G2kVtnHRn/8CdaUBOqfSLjTegoqsxspVBQaSw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=gxf3CeZg;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id D7B39606A31C;
	Tue, 17 Nov 2026 23:14:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=gxf3CeZg
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 00C0C1F000C4;
	Tue, 17 Nov 2026 23:14:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794957250;
	bh=yp6+Hwad/NBoam++rgWwhCOLZpBfJyHe1i278jtj9/A=;
	h=From:To:Cc:Subject:Date;
	b=gxf3CeZgQiYInmwTCsJEpC9Q9rV3XfEnkpMfqYKKQLHrsz2tF88DlZadPUvGDmLHY
	 JhDrjDv6JsOFbRcfejD3ARsnyggY8gv6rSAqj9Q/EE5lOo0/KtkapgPsJVCDvxTDjZ
	 Anec1m6erHqQ5vTQWyAgScKHqeo8H0BnCCaOL8NwC2wWLw+8F11lo4zoqyA0J3IaRc
	 eUB4bdzBxQwPCE0m7ywlRNS0Xaej4i0kGTBNg2IdenE0LzY51zebpn9mmrsrWLuBWF
	 paBGkkIYjNP9b5XMebOD4pW6qK1i/Q/FyCDqA7vser6WO1NxHFV+ecP7etOYBgybdw
	 4E2nhRf97F6Eg==
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
	Andy Lutomirski <luto@amacapital.net>,
	Ben Segall <bsegall@google.com>,
	Christian Brauner <brauner@kernel.org>,
	David Hildenbrand <david@kernel.org>,
	David Howells <dhowells@redhat.com>,
	Davidlohr Bueso <dave@stgolabs.net>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Ingo Molnar <mingo@redhat.com>,
	Jan Kara <jack@suse.cz>,
	Jonathan Corbet <corbet@lwn.net>,
	John Johansen <john.johansen@canonical.com>,
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
	Vlastimil Babka <vbabka@kernel.org>,
	Zygmunt Krynicki <zygmunt.krynicki@canonical.com>
Subject: [RFC PATCH v2 00/13] Namespace for namespace roots
Date: Wed, 18 Nov 2026 01:13:39 +0200
Message-ID: <20261117231352.3816603-1-jarkko@kernel.org>
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

A root namespace (rootns) is a kernel object backed by a file descriptor
that binds together:

1. A full or partial set of detached namespaces.
2. A dedicated PID namespace for spawning processes into, signaling
   members, and polling or waiting on PID 1 exit.
3. An initially empty mount namespace (CLONE_EMPTY_MNTNS) that must be
   populated before going live, without inheriting host mount-tree
   ancestors.

Work on this feature started in 2025 from David Howells' container object
patch set [1], which I turned into a namespace for namespace roots and
rebuilt around that premise.

While the patch set is manually written, the original motivation came
from isolating LLM agents. Running untrusted agent workloads made it
clear that OCI runtimes need to minimize their live configuration
surface.

Assembling mounts, credentials, and namespaces inside helper processes
with a half-configured container is what I see as the main challenge,
and the existential debate around namespaces and container objects is an
unfocused discussion topic.

[1] https://lore.kernel.org/all/155059610368.17079.2220554006494174417.stgit@warthog.procyon.org.uk/

IMPLEMENTATION
==============

rootns_create() allocates a rootns instance backed by a pollable
anonymous inode fd, pinning dedicated empty mount (CLONE_EMPTY_MNTNS) and
PID namespaces along with any optional namespaces selected in flags.

Before entry, userspace populates the mount tree through the control fd:
FSCONFIG_SET_ROOTNS binds a newly opened fs_context to the target rootns,
and move_mount(..., MOVE_MOUNT_T_ROOTNS_ROOT) installs "/" onto the
nullfs root once (transitioning the rootns to ROOTNS_READY) and attaches
relative submounts beneath it.

Processes are spawned into a ready rootns via clone3() with
CLONE_INTO_ROOTNS and struct clone_args.rootns, without mutating the
caller in place. Pairing CLONE_INTO_ROOTNS with CLONE_VM | CLONE_VFORK
and opening the target binary via openat2(..., RESOLVE_IN_ROOT) on the
retained "/" mount fd allows spawning with execveat() without copying
page tables.

The first entrant becomes PID 1; once it exits and
zap_pid_ns_processes() reaps all members, poll() reports EPOLLHUP and
rootns_wait() returns init's exit status and rusage. rootns_kill() walks
pid_ns->idr under RCU to signal member thread groups.

CHANGES
=======

v2:
- Drop rootns provenance tracking (rootns_id and rootns_may_setns()) and
  rely on user_namespace ownership for setns() isolation (Andy
  Lutomirski).
- Replace the rootns_enter() system call with clone3(CLONE_INTO_ROOTNS)
  and struct clone_args.rootns (CLONE_ARGS_SIZE_VER3), allowing
  CLONE_VM | CLONE_VFORK and compatible per-child clone3() flags (Andy
  Lutomirski).
- Drop the spurious task_no_new_privs() check in may_enter_rootns_creds()
  (Andy Lutomirski).
- Update documentation, Kconfig, syscall tables, and kselftests for
  CLONE_INTO_ROOTNS.

VERSIONS
========

v1: https://lore.kernel.org/linux-fsdevel/20261117050841.3289652-1-jarkko@kernel.org/

Cc: linux-api@vger.kernel.org
Cc: linux-doc@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: linux-kselftest@vger.kernel.org
Cc: linux-mm@kvack.org
Cc: linux-security-module@vger.kernel.org
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Andy Lutomirski <luto@amacapital.net>
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
Cc: John Johansen <john.johansen@canonical.com>
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
Cc: Zygmunt Krynicki <zygmunt.krynicki@canonical.com>

Jarkko Sakkinen (13):
  nsproxy: Pass nsproxy to create_new_namespaces()
  rootns: Add core infrastructure for root namespaces
  rootns: Track init lifecycle via copy_process() and pid_namespace
  rootns: Add rootns_create() system call
  rootns: Add rootns_wait() system call
  rootns: Add rootns_kill() system call
  fork: Support CLONE_INTO_ROOTNS in clone3()
  fs: Support FSCONFIG_SET_ROOTNS in fsconfig()
  fs: Support installing rootns mount trees via move_mount()
  arch: Wire up rootns system calls
  docs: Document root namespace uAPI
  selftests/rootns: Add root namespace test suite
  MAINTAINERS: Add entry for ROOT NAMESPACE

 Documentation/userspace-api/index.rst       |    1 +
 Documentation/userspace-api/rootns.rst      |   40 +
 MAINTAINERS                                 |   11 +
 arch/alpha/kernel/syscalls/syscall.tbl      |    3 +
 arch/arm/tools/syscall.tbl                  |    3 +
 arch/arm64/tools/syscall_32.tbl             |    3 +
 arch/m68k/kernel/syscalls/syscall.tbl       |    3 +
 arch/microblaze/kernel/syscalls/syscall.tbl |    3 +
 arch/mips/kernel/syscalls/syscall_n32.tbl   |    3 +
 arch/mips/kernel/syscalls/syscall_n64.tbl   |    3 +
 arch/mips/kernel/syscalls/syscall_o32.tbl   |    3 +
 arch/parisc/kernel/syscalls/syscall.tbl     |    3 +
 arch/powerpc/kernel/syscalls/syscall.tbl    |    3 +
 arch/s390/kernel/syscalls/syscall.tbl       |    3 +
 arch/sh/kernel/syscalls/syscall.tbl         |    3 +
 arch/sparc/kernel/syscalls/syscall.tbl      |    3 +
 arch/x86/entry/syscalls/syscall_32.tbl      |    3 +
 arch/x86/entry/syscalls/syscall_64.tbl      |    3 +
 arch/xtensa/kernel/syscalls/syscall.tbl     |    3 +
 fs/fsopen.c                                 |   76 +-
 fs/namespace.c                              |  178 ++-
 fs/proc/root.c                              |   13 +
 include/linux/compat.h                      |    4 +
 include/linux/cred.h                        |    4 +-
 include/linux/fs_context.h                  |    3 +
 include/linux/nsproxy.h                     |    9 +-
 include/linux/pid_namespace.h               |    4 +
 include/linux/rootns.h                      |   92 ++
 include/linux/sched/task.h                  |    8 +
 include/linux/syscalls.h                    |    4 +
 include/uapi/asm-generic/unistd.h           |   10 +-
 include/uapi/linux/mount.h                  |    4 +-
 include/uapi/linux/rootns.h                 |   38 +
 include/uapi/linux/sched.h                  |    5 +
 init/Kconfig                                |    9 +
 ipc/mqueue.c                                |   12 +
 kernel/Makefile                             |    2 +
 kernel/cred.c                               |   70 +-
 kernel/fork.c                               |   67 +-
 kernel/nsproxy.c                            |   41 +-
 kernel/pid_namespace.c                      |    2 +
 kernel/rootns.c                             |  593 ++++++++
 kernel/sys_ni.c                             |    6 +
 scripts/syscall.tbl                         |    3 +
 tools/testing/selftests/Makefile            |    1 +
 tools/testing/selftests/rootns/.gitignore   |    2 +
 tools/testing/selftests/rootns/Makefile     |    5 +
 tools/testing/selftests/rootns/config       |    9 +
 tools/testing/selftests/rootns/smoke.c      | 1381 +++++++++++++++++++
 49 files changed, 2680 insertions(+), 75 deletions(-)
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

