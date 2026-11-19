Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795128212;
	b=ofmc6HM/YX02JZzEqAethZq54ybu3VLv0wPcFyBhT4Bgh0bE/TzDyOPWEuwVrrkGQvjt
	 qmOJpwQ+rJovcSDawKn9wh+PehRDFQRa1o6gHAb6R+WkiLA8iIgxIcLTkYaaAqs4L0Lvb
	 yhsKqWtpHZ8mJPY9DSpggPww8VrPJhCKixlrblTwf5t7xo2bqnqQYsmaz/JeJE3ryFA8Z
	 jawgXI27gHXF6V1TH5zMxv8G8zejnmeY0l8fjh86jOeqrYdQ3etGHhJbVH8ziR82bqk9+
	 9DxYijBHjVF+PX6v4+8Q00fhAQHDUQxwIq7YEhL/VA7pHTPa5KjC4O5as8myWxAw+ng==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795128212;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ZNyRLMfKGk2VGtAqB2z2tqb9Lbalo8bd1K9pdQC4VVk=;
	b=fewJKLQNtoxV4nJHJlhYcjkYBLQAYbrkL6rOCmvS0a3oqeyOnlqqPzT0nEsE34oi7g77
	 f1g79nxcPyCpBlToi97zGLlchG7XXOOtgEcTUhOW26GWJEm3WAPV4Iy9swuh2uwcG64lr
	 ogI/cGAuOl/xnLX2twEcUkvkoKpfwQYURPLL0XheX5s4KNAYNogqgsr8GM0t/1Mp1G7WT
	 rbJbRbSpen2y7wR63q0GbObIpMC0YY3nIAK45UKnLkvDb2Wf9GHTzosn//+HtRLzcdOzk
	 mxSRaTL37tFptXC5afgAPF3VvOwyQkucbpUG2YMelxKxQhpcQ/eFk+UtZq9GF+SbqFg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=P3H24aJ0;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id 38116606A320;
	Thu, 19 Nov 2026 22:43:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=P3H24aJ0
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 61CC01F000C0;
	Thu, 19 Nov 2026 22:43:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795128212;
	bh=ZNyRLMfKGk2VGtAqB2z2tqb9Lbalo8bd1K9pdQC4VVk=;
	h=From:To:Cc:Subject:Date;
	b=P3H24aJ05ftjCxEWSMFYlBYV1XTWMdVsfXZQFZ3YrSWBVd5H9bKoldecv9sSK8HUW
	 zma+fPqxkX/aa8JLotsUMjF0hHjyH7CZsXsbi24WkApJyq9xHwPe6986tQHIQB99EZ
	 PdwIqBqHIJ1xjPKWEyRrFYiMTTHfzqi7A1tOuE7Los2xNqxe5ISYM1+j7aKaynuB/z
	 Fsv1Y+fWT1WzsZHIAkDnvVvbDV+e8Dq6jfXR8QPPSMKFPlkTYc6QBkUNlnXBL/2MFz
	 8xYPGBIMn5NfJMT9vpIQC6xRvxDi/6a80g3MIPCvN6dnxEumwqO/aOPsEn/nqse8pv
	 rQgxc/5VBoh4Q==
From: Jarkko Sakkinen <jarkko@kernel.org>
To: linux-fsdevel@vger.kernel.org
Cc: Jarkko Sakkinen <jarkko@kernel.org>,
	linux-api@vger.kernel.org,
	linux-arch@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org,
	linux-security-module@vger.kernel.org,
	Albert Ou <aou@eecs.berkeley.edu>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Alexandre Ghiti <alex@ghiti.fr>,
	Andreas Larsson <andreas@gaisler.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Andy Lutomirski <luto@amacapital.net>,
	Andy Lutomirski <luto@kernel.org>,
	Anna-Maria Behnsen <anna-maria@linutronix.de>,
	Arnd Bergmann <arnd@arndb.de>,
	Ben Segall <bsegall@google.com>,
	Borislav Petkov <bp@alien8.de>,
	Casey Schaufler <casey@schaufler-ca.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Christian Brauner <brauner@kernel.org>,
	"Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
	Chris Zankel <chris@zankel.net>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	David Hildenbrand <david@kernel.org>,
	David Howells <dhowells@redhat.com>,
	Davidlohr Bueso <dave@stgolabs.net>,
	"David S. Miller" <davem@davemloft.net>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Frederic Weisbecker <frederic@kernel.org>,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	"Hallgrimur H. Gunnarsson" <halg@google.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Helge Deller <deller@gmx.de>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Ingo Molnar <mingo@redhat.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	Jan Kara <jack@suse.cz>,
	John Johansen <john.johansen@canonical.com>,
	John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>,
	Jonathan Corbet <corbet@lwn.net>,
	Josef Bacik <josef@toxicpanda.com>,
	Juri Lelli <juri.lelli@redhat.com>,
	Kees Cook <kees@kernel.org>,
	K Prateek Nayak <kprateek.nayak@amd.com>,
	"Liam R. Howlett" <liam@infradead.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Magnus Lindholm <linmag7@gmail.com>,
	Manfred Spraul <manfred@colorfullife.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Matt Turner <mattst88@gmail.com>,
	Max Filippov <jcmvbkbc@gmail.com>,
	Mel Gorman <mgorman@suse.de>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Michal Hocko <mhocko@suse.com>,
	Michal Simek <monstr@monstr.eu>,
	Mike Rapoport <rppt@kernel.org>,
	Neal Gompa <neal@gompa.dev>,
	Nicholas Piggin <npiggin@gmail.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Paul Moore <paul@paul-moore.com>,
	Paul Walmsley <pjw@kernel.org>,
	Pavel Tikhomirov <ptikhomirov@virtuozzo.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	Richard Henderson <richard.henderson@linaro.org>,
	Rich Felker <dalias@libc.org>,
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
	Russell King <linux@armlinux.org.uk>,
	Serge Hallyn <sergeh@kernel.org>,
	Shrikanth Hegde <sshegde@linux.ibm.com>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Sven Schnelle <svens@linux.ibm.com>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Thomas Gleixner <tglx@kernel.org>,
	Valentin Schneider <vschneid@redhat.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Vincenzo Frascino <vincenzo.frascino@arm.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Will Deacon <will@kernel.org>,
	Yoshinori Sato <ysato@users.sourceforge.jp>,
	Zygmunt Krynicki <zygmunt.krynicki@canonical.com>
Subject: [RFC PATCH v4 00/14] Namespace for namespace roots
Date: Fri, 20 Nov 2026 00:42:58 +0200
Message-ID: <20261119224312.1037966-1-jarkko@kernel.org>
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

1. A full set of detached namespaces owned by a fresh user namespace.
2. A dedicated PID namespace for spawning processes into, signaling
   members, and polling or waiting on PID 1 exit.
3. An initially empty mount namespace (CLONE_EMPTY_MNTNS) populated
   directly in its target user namespace before going live, without
   inheriting host mounts or cloning staged trees, while still allowing
   new mounts to be attached at runtime.

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

rootns() allocates a rootns instance backed by a pollable anonymous
inode fd, creating a fresh owning user namespace and a full set of
detached namespaces: empty mount (CLONE_EMPTY_MNTNS), PID, UTS, IPC,
network, cgroup, and time. ioctl(rootnsfd, ROOTNS_GET_NSFD, nstype)
returns nsfs file descriptors for individual member namespaces when
standalone namespace operations are needed.

Superblocks are configured directly in the target user namespace via
fsopen(), FSCONFIG_SET_ROOTNS, and fsmount(), allowing unprivileged
callers to assemble FS_USERNS_MOUNT filesystems without holding
CAP_SYS_ADMIN in their own user namespace or entering the target user
namespace first. move_mount(..., MOVE_MOUNT_T_MNTNS) operates on any
non-anonymous mount namespace fd: on an empty mount namespace it installs
"/" onto the nullfs root once, and it attaches relative submounts both
before entry and into live mount namespaces.

Once "/" is installed, processes are spawned into the rootns via clone3()
with CLONE_INTO_ROOTNS and struct clone_args.rootns, without mutating the
caller in place. Pairing CLONE_INTO_ROOTNS with CLONE_VFORK and opening
the target binary via openat2(..., RESOLVE_IN_ROOT) on the retained "/"
mount fd allows spawning with execveat() directly into the target root.

The first entrant becomes PID 1; once it exits and
zap_pid_ns_processes() reaps all members, poll() reports EPOLLHUP and
ioctl(rootnsfd, ROOTNS_WAIT, &args) returns init's exit status.
ioctl(rootnsfd, ROOTNS_KILL, sig) walks pid_ns->idr under tasklist_lock
to signal member thread groups, and dedicated LSM hooks mediate rootns
allocation, teardown, process entry, and signal delivery.

CHANGES
=======

v4:
- A single syscall API (and shenanigans e.g., in fsconfig).
- I use a similar API model as I used in SGX driver, as like enclaves,
  containers are "closures". Instead of /dev/sgx_enclave like device
  file, anon inode is used.
- Consolidate rootns_create(), rootns_wait(), and rootns_kill() into a
  single rootns() system call plus ROOTNS_WAIT and ROOTNS_KILL ioctls,
  dropping rusage from ROOTNS_WAIT.
- LSM: lbs_rootns security blob management and security_rootns_alloc(),
  security_rootns_free(), security_rootns_clone(), and
  security_rootns_kill() LSM hooks wired into bpf_lsm.
- Disallow CLONE_VM with CLONE_INTO_ROOTNS across time namespaces, require
  CAP_SYS_CHROOT, preserve caller umask, reset dumpability on user
  namespace transitions, and fix ROOTNS_WAIT, FSCONFIG_SET_ROOTNS,
  fsmount(), and MOVE_MOUNT_T_MNTNS locking and permission checks
  (Sashiko).
- Rewrite selftests/rootns in Python. I used similar structure as I've
  used in selftests/tpm2. This "along the lines" mimics Cells style
  container manager. Rootns is a quite typical no policy solution and
  Cells is a managed solution, and they are at the far ends, which can
  also be witnessed from the patch set sizes.

  The question really is where we want to draw the borderline. I'm
  neither favoring nor supporting any possible solution because I don't
  know. I'm just saying where they live as a software stack.
- Update documentation and architecture syscall tables for rootns().

v3:
- The patch set size increased predominantly because the coverage of
  kselftest had to widened to cover the introduced changes.
- Replace MOVE_MOUNT_T_ROOTNS_ROOT with MOVE_MOUNT_T_MNTNS targeting
  mnt_ns nsfs fds, and add ioctl(ROOTNS_GET_NSFD) to open member
  namespace fds (Andy Lutomirski).
- Allow unprivileged fsopen(), FSCONFIG_SET_ROOTNS, and fsmount() to
  configure and mount FS_USERNS_MOUNT filesystems directly in the target
  user namespace without entering it first (Andy Lutomirski).
- Fix locking, refcounting, credential/dumpability/timens setup,
  pivot_root() lookup, and cross-userns mount checks across copy_rootns(),
  CLONE_INTO_ROOTNS, rootns_kill(), FSCONFIG_SET_ROOTNS, and move_mount()
  (Sashiko).
- Mark PowerPC rootns syscalls nospu (Sashiko).
- Update documentation and kselftests.

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

v3: https://lore.kernel.org/linux-fsdevel/20261118193539.240065-1-jarkko@kernel.org/
v2: https://lore.kernel.org/linux-fsdevel/20261117231352.3816603-1-jarkko@kernel.org/
v1: https://lore.kernel.org/linux-fsdevel/20261117050841.3289652-1-jarkko@kernel.org/


Cc: linux-api@vger.kernel.org
Cc: linux-arch@vger.kernel.org
Cc: linux-doc@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: linux-kselftest@vger.kernel.org
Cc: linux-mm@kvack.org
Cc: linux-security-module@vger.kernel.org
Cc: Albert Ou <aou@eecs.berkeley.edu>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Alexandre Ghiti <alex@ghiti.fr>
Cc: Andreas Larsson <andreas@gaisler.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Andy Lutomirski <luto@amacapital.net>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Anna-Maria Behnsen <anna-maria@linutronix.de>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Ben Segall <bsegall@google.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Casey Schaufler <casey@schaufler-ca.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>
Cc: Christian Brauner <brauner@kernel.org>
Cc: "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>
Cc: Chris Zankel <chris@zankel.net>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: David Howells <dhowells@redhat.com>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Dietmar Eggemann <dietmar.eggemann@arm.com>
Cc: Frederic Weisbecker <frederic@kernel.org>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Hallgrimur H. Gunnarsson <halg@google.com>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Helge Deller <deller@gmx.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Jarkko Sakkinen <jarkko@kernel.org>
Cc: John Johansen <john.johansen@canonical.com>
Cc: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Josef Bacik <josef@toxicpanda.com>
Cc: Juri Lelli <juri.lelli@redhat.com>
Cc: Kees Cook <kees@kernel.org>
Cc: K Prateek Nayak <kprateek.nayak@amd.com>
Cc: "Liam R. Howlett" <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Magnus Lindholm <linmag7@gmail.com>
Cc: Manfred Spraul <manfred@colorfullife.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Matt Turner <mattst88@gmail.com>
Cc: Max Filippov <jcmvbkbc@gmail.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Michal Simek <monstr@monstr.eu>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Neal Gompa <neal@gompa.dev>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Cc: Paul Moore <paul@paul-moore.com>
Cc: Paul Walmsley <pjw@kernel.org>
Cc: Pavel Tikhomirov <ptikhomirov@virtuozzo.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Richard Henderson <richard.henderson@linaro.org>
Cc: Rich Felker <dalias@libc.org>
Cc: "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>
Cc: Russell King <linux@armlinux.org.uk>
Cc: Serge Hallyn <sergeh@kernel.org>
Cc: Shrikanth Hegde <sshegde@linux.ibm.com>
Cc: Shuah Khan <skhan@linuxfoundation.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Sven Schnelle <svens@linux.ibm.com>
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc: Thomas Gleixner <tglx@kernel.org>
Cc: Valentin Schneider <vschneid@redhat.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Vincent Guittot <vincent.guittot@linaro.org>
Cc: Vincenzo Frascino <vincenzo.frascino@arm.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Will Deacon <will@kernel.org>
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
Cc: Zygmunt Krynicki <zygmunt.krynicki@canonical.com>

Jarkko Sakkinen (14):
  nsproxy: Pass nsproxy to create_new_namespaces()
  rootns: Add core infrastructure for root namespaces
  rootns: Track init lifecycle via copy_process() and pid_namespace
  rootns: Add rootns() system call
  rootns: Add ROOTNS_WAIT ioctl
  rootns: Add ROOTNS_KILL ioctl
  fork: Support CLONE_INTO_ROOTNS in clone3()
  fs: Support FSCONFIG_SET_ROOTNS in fsconfig()
  fs: Support MOVE_MOUNT_T_MNTNS in move_mount()
  security: Add rootns LSM hooks
  arch: Wire up rootns() system call
  docs: Document root namespace uAPI
  selftests/rootns: Add root namespace test suite
  MAINTAINERS: Add entry for ROOT NAMESPACE

 Documentation/userspace-api/index.rst         |    1 +
 .../userspace-api/ioctl/ioctl-number.rst      |    1 +
 Documentation/userspace-api/rootns.rst        |   56 +
 MAINTAINERS                                   |   11 +
 arch/alpha/kernel/syscalls/syscall.tbl        |    1 +
 arch/arm/tools/syscall.tbl                    |    1 +
 arch/arm64/tools/syscall_32.tbl               |    1 +
 arch/m68k/kernel/syscalls/syscall.tbl         |    1 +
 arch/microblaze/kernel/syscalls/syscall.tbl   |    1 +
 arch/mips/kernel/syscalls/syscall_n32.tbl     |    1 +
 arch/mips/kernel/syscalls/syscall_n64.tbl     |    1 +
 arch/mips/kernel/syscalls/syscall_o32.tbl     |    1 +
 arch/parisc/kernel/syscalls/syscall.tbl       |    1 +
 arch/powerpc/kernel/syscalls/syscall.tbl      |    1 +
 arch/s390/kernel/syscalls/syscall.tbl         |    1 +
 arch/sh/kernel/syscalls/syscall.tbl           |    1 +
 arch/sparc/kernel/syscalls/syscall.tbl        |    1 +
 arch/x86/entry/syscalls/syscall_32.tbl        |    1 +
 arch/x86/entry/syscalls/syscall_64.tbl        |    1 +
 arch/xtensa/kernel/syscalls/syscall.tbl       |    1 +
 fs/devpts/inode.c                             |    2 +
 fs/filesystems.c                              |   15 +
 fs/fs_context.c                               |   21 +-
 fs/fsopen.c                                   |  139 +-
 fs/internal.h                                 |    6 +
 fs/namespace.c                                |  272 +++-
 fs/nsfs.c                                     |   64 +
 fs/proc/root.c                                |   18 +
 include/linux/cred.h                          |    4 +-
 include/linux/fs_context.h                    |    6 +
 include/linux/lsm_hook_defs.h                 |    7 +
 include/linux/lsm_hooks.h                     |    3 +
 include/linux/mnt_namespace.h                 |    2 +
 include/linux/nsfs.h                          |    2 +
 include/linux/nsproxy.h                       |    9 +-
 include/linux/pid_namespace.h                 |    4 +
 include/linux/rootns.h                        |   92 ++
 include/linux/sched/task.h                    |    8 +
 include/linux/security.h                      |   30 +
 include/linux/syscalls.h                      |    1 +
 include/linux/time_namespace.h                |   13 +
 include/linux/user_namespace.h                |    7 +
 include/uapi/asm-generic/unistd.h             |    6 +-
 include/uapi/linux/mount.h                    |    4 +-
 include/uapi/linux/rootns.h                   |   83 ++
 include/uapi/linux/sched.h                    |    5 +
 init/Kconfig                                  |    9 +
 ipc/mqueue.c                                  |   13 +
 kernel/Makefile                               |    2 +
 kernel/bpf/bpf_lsm.c                          |   10 +
 kernel/cred.c                                 |   32 +-
 kernel/fork.c                                 |   95 +-
 kernel/nsproxy.c                              |   41 +-
 kernel/pid_namespace.c                        |    2 +
 kernel/rootns.c                               |  581 +++++++++
 kernel/sys_ni.c                               |    3 +
 kernel/user_namespace.c                       |   12 +-
 scripts/syscall.tbl                           |    1 +
 security/lsm_init.c                           |    6 +
 security/security.c                           |   86 ++
 tools/testing/selftests/Makefile              |    1 +
 tools/testing/selftests/rootns/Makefile       |    5 +
 tools/testing/selftests/rootns/config         |   10 +
 .../testing/selftests/rootns/rootns_cells.py  | 1076 +++++++++++++++
 tools/testing/selftests/rootns/rootns_test.py | 1161 +++++++++++++++++
 tools/testing/selftests/rootns/test_smoke.sh  |   11 +
 66 files changed, 3977 insertions(+), 88 deletions(-)
 create mode 100644 Documentation/userspace-api/rootns.rst
 create mode 100644 include/linux/rootns.h
 create mode 100644 include/uapi/linux/rootns.h
 create mode 100644 kernel/rootns.c
 create mode 100644 tools/testing/selftests/rootns/Makefile
 create mode 100644 tools/testing/selftests/rootns/config
 create mode 100755 tools/testing/selftests/rootns/rootns_cells.py
 create mode 100755 tools/testing/selftests/rootns/rootns_test.py
 create mode 100755 tools/testing/selftests/rootns/test_smoke.sh

--
2.47.3

