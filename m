Received: from mail-yw1-f181.google.com (mail-yw1-f181.google.com [209.85.128.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96A7C4C6F05
	for <linux-api@vger.kernel.org>; Tue,  4 Aug 2026 20:25:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785875138; cv=none; b=BgvHiQE4jGsvmNaKlrBzXpejyQHJHQfd8Imi5YBfTN5dQ/44tEIf4IMm9WlypnHYO3oZC6RMlAAbEwa35s5k19fZvd8IZj6vK7fnl7vAVFQSI3qcR+Mj7Nz3q6E5oeKzLzweJLj2/sUMs1z0tfMuyNkV1wbM57dF3Y194cGHcC0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785875138; c=relaxed/simple;
	bh=kTBXNB2tLJinmV+meWCRY/M/YjJPpZZg3idzCVatug8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=iTYBdy6LtvK7VR2tUAc7D7xQwmnbzqHhhvGRLJqNuBYthDzw3wj1ccHKS8KBhoYOdtc4Il4/qU8SoIalkMkDhEqvhPMtv3QmtMjODcdqRKDcy4XJUx4gCsfx4QdVzdUufteP85CBdijL9DnOD0yeHtRZVkZVbbVDHKDuXXv3wpI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ea8vt7xN; arc=none smtp.client-ip=209.85.128.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ea8vt7xN"
Received: by mail-yw1-f181.google.com with SMTP id 00721157ae682-81ed000b507so3270117b3.0
        for <linux-api@vger.kernel.org>; Tue, 04 Aug 2026 13:25:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785875127; x=1786479927; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=NKkjXnnqGQF2M+u6ias5bB7wHPmpsm3RwoGuV3wwepg=;
        b=ea8vt7xN8uO7pphq5f2uQ7z8YfDucEy8Bnwu5T3CJOI59VlETfagwcsYKboeXC0Awr
         6ms+YL2vQZlxlawt+u1xgGefkxR5EtzqXyo1bt2dJQtLNf8gR38uZDQy7E8XpO43ZG/j
         fJZoxurVIc6RTXqoqlH226Ki+kZ2FgLYyAnWtl19lYTLeNxKLCsLfwbFI+DZgRTWj6Hg
         QsHJxUhzH1Yj1F3UvZhpsunhS29vrh1Enk66QET0qIaMN3yqhDaY0SZ5BUrgTqT8XVup
         b6qNKyqDqDSj5+3PWGBjqWuM7Fyp5xRUYTZ6NjF442dF5JgOiteKfMJQdDVI8a24PL9z
         FMlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785875127; x=1786479927;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=NKkjXnnqGQF2M+u6ias5bB7wHPmpsm3RwoGuV3wwepg=;
        b=Ca52ETSfBHJ5SfESJ+UJRHVSH8+AvvihJmTot0mHIkJu+GKYDF9Sag4EG0GeEDAjoY
         tT+3UZpba0J/3itEHoe5gD6ciMvjDqdJWUyrK1SNcOjWujxmGrWGSTsFamoW0YmRXOey
         0z5/ufMo7Ugc7VFiCfSv8/gzPGcy0dWeX23KF+7QzDp1LphbKk3whZ/VmnULEjtjH8jy
         xT63lnoaGW0nOHiTsqN0fhdnBDIR72MaEUQQNGkD7ZH/moQp6nuygKJUWD27E4qWPv+P
         RPreGd+L0rkBzABA9YBhDMmgN65R7E1xkqPQ8Hyc1i6M4Wa50FbWGqrmSEtKnGrwNRuS
         ayiA==
X-Forwarded-Encrypted: i=1; AHgh+RqkvLoPm6aZYGBMV7YfOPkPd3YUyrIxN7eq148jT/KoIwTy/bgXPsrDoLxsrJUQndLKRZHedfPmfA8=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy6kiwdr+EAfSAzgPGPbQFhkcnUGmfDamSaDToF9tJBFGnKzKKw
	3QSGNuRGpiGTSvVAJeZNS2SS/G3HhvyahEY1/IJpUVbxE3ggAa3VnFaW
X-Gm-Gg: AR+sD10bQiwpR5L7/6UJjvo0B69vLHOBNmqCGjPnRqHQ6O8AmaGCySMiDEV9A9wEG9S
	m5UYUjY7ne7npeqKMP9st9zraAmonqD/5rFhqwhxk4zcRX33HWyVAxeRpCULZYAy6KLvcJeVMk7
	5qVrJBWHc692hyFXdAFGpwHqTLFuI8sDg1QIiuH0VIp6jFhCI3uMGxFEPrmapJBOFk14Z5YKxk/
	WmmAf5ezJ1B1wstaZAy5xPBUw+HCzZG1nJKYEmQyt+831eudZX5aMf2DmDQIuKZk0fdEgMZbars
	TTJc7P1y7qsTVqu27uL1D1O0iDJDj7capvvPMhB1i10HBWtb2AwhWnUIXZWPFr1R03SCLpRsQwU
	8u2UxXknuAogD5mnc5fZHb3vf4MNOIEHGjTje70YFJo6uAEYKjwDllEavUoFMF9dP1/aUG0n9io
	ON1YQmh66MKkDwgjj0gvJML3ve1CSZNV1k6JuwHNWUgXz1jK1qFjgzB/N0VlY0NtxH4iMqk8IfF
	xYvCjsbjmkBKy+i0xx/ID0=
X-Received: by 2002:a05:690c:6904:b0:80c:b92c:77a9 with SMTP id 00721157ae682-82022293d52mr7702217b3.6.1785875126957;
        Tue, 04 Aug 2026 13:25:26 -0700 (PDT)
Received: from zenbox ([2600:1700:18fb:6011:572c:6770:834b:60f2])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-820134ccc5csm11632827b3.43.2026.08.04.13.25.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Aug 2026 13:25:26 -0700 (PDT)
Date: Tue, 4 Aug 2026 16:25:25 -0400
From: Justin Suess <utilityemal77@gmail.com>
To: Li Chen <me@linux.beauty>
Cc: Christian Brauner <brauner@kernel.org>, Kees Cook <kees@kernel.org>, 
	Gabriel Krisman Bertazi <krisman@kernel.org>, Josh Triplett <josh@joshtriplett.org>, 
	Mateusz Guzik <mjguzik@gmail.com>, Andy Lutomirski <luto@kernel.org>, 
	John Ericson <mail@johnericson.me>, Jonathan Corbet <corbet@lwn.net>, Shuah Khan <shuah@kernel.org>, 
	Arnd Bergmann <arnd@arndb.de>, Oleg Nesterov <oleg@redhat.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Paul Moore <paul@paul-moore.com>, Eric Paris <eparis@redhat.com>, 
	=?utf-8?Q?Micka=C3=ABl_Sala=C3=BCn?= <mic@digikod.net>, =?utf-8?Q?G=C3=BCnther?= Noack <gnoack@google.com>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, linux-api@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-doc@vger.kernel.org, audit@vger.kernel.org, linux-security-module@vger.kernel.org, 
	linux-arch@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [RFC PATCH 00/24] pidfd: add a minimal process spawn builder
Message-ID: <anJE8SfBLtkh6QSa@zenbox>
References: <cover.1784204592.git.me@linux.beauty>
Precedence: bulk
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1784204592.git.me@linux.beauty>

On Thu, Jul 16, 2026 at 10:31:26PM +0800, Li Chen wrote:
> Hi,
> 
> This RFC follows feedback on my earlier spawn_template RFC [1]. That
> proposal made caching the primary interface; this one starts with general
> process construction. Christian suggested a pidfd/pidfs exec builder
> modeled after fsconfig(), with enough semantics for userspace to implement
> posix_spawn() [2], and Kees agreed [3].
> 
> This RFC is based on linux-next next-20260710 and depends on two pidfs
> fixes that I sent separately:
> 
>   * pidfs: preserve thread pidfds reopened by file handle
>     https://lore.kernel.org/all/20260716052726.1032092-1-me@linux.beauty/
>   * pidfs: handle FS_IOC32_GETVERSION in compat ioctl
>     https://lore.kernel.org/all/20260716052822.1034228-1-me@linux.beauty/
> 
> The initial implementation is source-based. The executable path can be
> provided with the final run request:
> 
>     struct pidfd_spawn_run_args run = {
>         .path = (unsigned long)"/usr/bin/rg",
This should probably be an FD for the path.

This way it prevents race conditions over multiple configuration steps.
>         .argv = (unsigned long)argv,
>         .envp = (unsigned long)envp,
>     };
> 
>     fd = pidfd_open(0, PIDFD_EMPTY);
>     pidfd_spawn_run(fd, &run, sizeof(run));
> 
> Alternatively, the path can be staged before the final run step:
> 
>     struct pidfd_spawn_run_args run = {
>         .argv = (unsigned long)argv,
>         .envp = (unsigned long)envp,
>     };
> 
>     fd = pidfd_open(0, PIDFD_EMPTY);
>     pidfd_config(fd, PIDFD_CONFIG_SET_STRING,
>                  PIDFD_CONFIG_KEY_PATH, "/usr/bin/rg", 0);
Same here. Should probably be an FD to the binary instead.

>     pidfd_spawn_run(fd, &run, sizeof(run));
I'm worried this pidfd_spawn_run just adds another varient to the existing
myriad of exec* syscalls we already have. Would it be better to just have this
work through execveat(fd, "", argv, envp, AT_EMPTY_PATH) instead?

(i.e have execveat take a pidfd directly).

Then you can get rid of pidfd_spawn_run which looks almost structurally
identical to execveat (with the argv and envp collapsed).

Justin
> 
> pidfd_open(0, PIDFD_EMPTY) creates a taskless future pidfd with a stable
> pidfs inode, but no task, PID, or process-count charge. pidfd_spawn_run()
> creates the task and PID; after publication the same fd is the child pidfd,
> and a numeric pidfd resolves to the same inode. Live-task operations return
> -ESRCH before publication. A terminal pre-task failure wakes poll/epoll
> with POLLERR | POLLHUP.
> 
> Source-based mode follows posix_spawn-style defaults. At run time it
> samples the caller's cwd, root, umask, fd table, signal dispositions and
> blocked mask, and namespaces.
> Non-FD_CLOEXEC descriptors remain unless an action changes them; file and
> filesystem state are private child copies before actions. Configuration and
> run stay bound to the creating mm_struct, exact credential object, and
> child PID namespace, so SCM_RIGHTS does not delegate launch authority.
> 
> The first authorized run claims the builder before copying its payload, so
> later failures are terminal. Pre-task failure leaves the fd taskless;
> setup or exec failure leaves it as the child pidfd and exits the child with
> status 127. PIDFD_GET_INFO with PIDFD_INFO_EXIT distinguishes them.
> Success returns the positive child PID in the caller's PID namespace.
> 
> The RFC supports ordered DUP2, CLOSE_RANGE, and FCHDIR actions in
> extensible UAPI records. This exercises child-private fd and cwd setup, but
> is not the complete posix_spawn() action or attribute surface.
> 
> Between task publication and successful exec, the child is explicitly
> embryonic and may not have a valid userspace register frame. Ptrace and
> pidfd_getfd() are denied, procfs treats the PID as absent to other tasks,
> and coredump information reports PIDFD_COREDUMP_SKIP. The child can use its
> own proc entries during executable lookup. Setup runs as initial child task
> work, and successful exec releases this state before exec events are
> published.
> 
> Seccomp sees pidfd_spawn_run(), not separate file-action or exec syscalls,
> and cannot inspect the path or action records behind the run pointer. An
> exec-only denylist that allows unknown syscalls therefore does not block
> this initial exec; policy must filter the builder syscall as a unit. Should
> later expansion provide an immutable restriction profile or action mask
> that seccomp can reason about, or is the coarse syscall boundary
> preferable?
> 
> LSM exec checks and inherited seccomp state remain active. Child setup uses
> a dedicated AUDIT_PIDFD_SPAWN transaction, not a synthetic AUDIT_SYSCALL.
> Should it be selected through the source pidfd_spawn_run() exit rule? An
> existing rule naming only execve() or execveat() does not select it.
> For source/child correlation, could an auxiliary record carry
> the source PID plus the stable pidfs inode? An already traced source is
> rejected before the claim; ptrace auto-attach is not implemented.
> 
> The implementation still uses CLONE_VM | CLONE_VFORK plus exec internally.
> Mateusz suggested that an initial implementation might start with vfork to
> get the API off the ground [4]. That is what this RFC does. It does not yet
> construct a pristine target process without first inheriting source state.
> 
> Missing posix_spawn() pieces include open and close file actions, resetids,
> signal masks/defaults, process groups, sessions, scheduler attributes,
> affinity, cgroup placement, PATH lookup/posix_spawnp(), and exec by fd. The
> RFC also does not include pristine/no-source creation or the executable
> metadata/template cache from my earlier work.
> 
> John Ericson described a real, partially initialized process that remains
> unscheduled while callers install its state, and linked an exploratory
> FreeBSD proc_new()/proc_setfd()/proc_start() refactoring [5]. This RFC
> implements the source-based mode first; a lower-authority pristine/no-source
> mode would be explicit follow-up work.
> 
> Direct process construction is not unprecedented. XNU's posix_spawn path
> does not inherit the parent's address space [6], and Windows
> CreateProcess() accepts explicit startup state [7]. Josh's io_uring_spawn
> LPC slides list "set up process from scratch" as future work and provide
> useful performance context [8]; I am not using those numbers as a claim for
> this RFC.
> 
> If the direction is acceptable, I plan to continue toward:
> 
>   * the complete file-action and attribute set needed by posix_spawn();
>   * pristine target-process construction and an explicit no-source mode;
>   * PATH/posix_spawnp support, if it belongs on the kernel side; and
>   * an optional executable/template layer for workloads such as agent tool
>     calling and compiler drivers.
> 
> The exposed UAPI surface is intentionally limited so the state model and
> kernel/userspace boundary can be reviewed first. If maintainers would
> prefer more posix_spawn semantics or backend work in this RFC, please say
> so and I will adjust the split.
> 
> Codex GPT-5.5 and GPT-5.6-sol provided substantial assistance across design
> conceptualization, implementation, patch splitting, code review, development
> of self-test cases, and test planning and execution.
> 
> Thanks to Christian, Kees, Mateusz, Gabriel, Josh, Andy, John, and others
> for the review and direction.
> 
> [1]: https://patchew.org/linux/20260528095235.2491226-1-me%40linux.beauty/
> [2]: https://lore.kernel.org/all/20260528-madig-fachrichtung-fehlinformation-61117ba640da@brauner/
> [3]: https://lore.kernel.org/all/202606011254.5FCBD65@keescook/
> [4]: https://lore.kernel.org/all/vealb52tv5suireenkke4lul2l3wbnaul2rp3ea545ly5wa5ty@yk3aksvp7skt/
> [5]: https://lore.kernel.org/all/ce71d6df-6851-4e4b-9603-1d55d8d522b8@app.fastmail.com/
> [6]: https://github.com/apple-oss-distributions/xnu/blob/f6217f891ac0bb64f3d375211650a4c1ff8ca1ea/bsd/kern/kern_exec.c#L4039
> [7]: https://learn.microsoft.com/en-us/windows/win32/procthread/creating-processes
> [8]: https://lpc.events/event/16/contributions/1213/attachments/1012/1945/io-uring-spawn.pdf
> 
> 
> Li Chen (24):
>   pidfd: add spawn builder uapi
>   libfs: allow custom validation of stashed inode data
>   pidfs: add taskless future pidfd inodes
>   pidfd: create taskless spawn builders
>   pidfd: add spawn builder path configuration
>   exec: expose execveat internals to process builders
>   fork: expose vfork completion helper
>   pidfs: attach pids to future pidfd files
>   fork: let process builders supply preallocated pids
>   pidfs: publish future pidfd files
>   pidfd: add spawn builder state tracking
>   fork: let kernel callers create embryonic tasks
>   fork: let new tasks start with task work
>   pidfd: create and execute spawn builder tasks
>   fork: keep embryonic tasks hidden until exec completes
>   audit: add pidfd spawn child contexts
>   pidfd: audit child spawn execution
>   pidfd: make spawn builder execution signal-safe
>   file: expose spawn file-action helpers
>   pidfd: add initial spawn file actions
>   pidfd: consume spawn builders on the first run attempt
>   pidfd: expose spawn builder system calls
>   selftests/pidfd: cover pidfd spawn builders
>   Documentation: describe pidfd spawn builders
> 
>  Documentation/userspace-api/index.rst         |    1 +
>  Documentation/userspace-api/pidfd_spawn.rst   |  247 ++++
>  MAINTAINERS                                   |    6 +
>  arch/alpha/kernel/syscalls/syscall.tbl        |    2 +
>  arch/arm/tools/syscall.tbl                    |    2 +
>  arch/arm64/tools/syscall_32.tbl               |    2 +
>  arch/m68k/kernel/syscalls/syscall.tbl         |    2 +
>  arch/microblaze/kernel/syscalls/syscall.tbl   |    2 +
>  arch/mips/kernel/syscalls/syscall_n32.tbl     |    2 +
>  arch/mips/kernel/syscalls/syscall_n64.tbl     |    2 +
>  arch/mips/kernel/syscalls/syscall_o32.tbl     |    2 +
>  arch/parisc/kernel/syscalls/syscall.tbl       |    2 +
>  arch/powerpc/kernel/syscalls/syscall.tbl      |    2 +
>  arch/s390/kernel/syscalls/syscall.tbl         |    2 +
>  arch/sh/kernel/syscalls/syscall.tbl           |    2 +
>  arch/sparc/kernel/syscalls/syscall.tbl        |    2 +
>  arch/x86/entry/syscalls/syscall_32.tbl        |    2 +
>  arch/x86/entry/syscalls/syscall_64.tbl        |    2 +
>  arch/xtensa/kernel/syscalls/syscall.tbl       |    2 +
>  fs/Makefile                                   |    2 +-
>  fs/coredump.c                                 |    4 +-
>  fs/exec.c                                     |   30 +-
>  fs/exec_internal.h                            |   40 +
>  fs/file.c                                     |   11 +-
>  fs/internal.h                                 |    3 +
>  fs/libfs.c                                    |    5 +-
>  fs/open.c                                     |    7 +-
>  fs/pidfd_spawn.c                              | 1095 +++++++++++++++
>  fs/pidfs.c                                    |  478 ++++++-
>  fs/proc/base.c                                |   11 +-
>  fs/proc/internal.h                            |   18 +-
>  include/linux/audit.h                         |   31 +
>  include/linux/pid.h                           |   13 +
>  include/linux/pidfd_spawn.h                   |    9 +
>  include/linux/pidfs.h                         |   28 +
>  include/linux/sched.h                         |   21 +
>  include/linux/sched/task.h                    |    6 +
>  include/linux/syscalls.h                      |    7 +
>  include/uapi/asm-generic/unistd.h             |    8 +-
>  include/uapi/linux/audit.h                    |    1 +
>  include/uapi/linux/pidfd.h                    |    1 +
>  include/uapi/linux/pidfd_spawn.h              |   49 +
>  kernel/audit.h                                |    1 +
>  kernel/auditsc.c                              |  105 +-
>  kernel/fork.c                                 |   26 +-
>  kernel/nsproxy.c                              |   11 +-
>  kernel/pid.c                                  |   41 +-
>  kernel/ptrace.c                               |    4 +
>  kernel/signal.c                               |    2 +-
>  scripts/syscall.tbl                           |    2 +
>  tools/include/uapi/asm-generic/unistd.h       |    8 +-
>  tools/include/uapi/linux/pidfd_spawn.h        |   49 +
>  .../arch/alpha/entry/syscalls/syscall.tbl     |    2 +
>  .../perf/arch/arm/entry/syscalls/syscall.tbl  |    2 +
>  .../arch/arm64/entry/syscalls/syscall_32.tbl  |   11 +
>  .../arch/mips/entry/syscalls/syscall_n64.tbl  |    2 +
>  .../arch/parisc/entry/syscalls/syscall.tbl    |    2 +
>  .../arch/powerpc/entry/syscalls/syscall.tbl   |    2 +
>  .../perf/arch/s390/entry/syscalls/syscall.tbl |    2 +
>  tools/perf/arch/sh/entry/syscalls/syscall.tbl |    2 +
>  .../arch/sparc/entry/syscalls/syscall.tbl     |    2 +
>  .../arch/x86/entry/syscalls/syscall_32.tbl    |    2 +
>  .../arch/x86/entry/syscalls/syscall_64.tbl    |    2 +
>  .../arch/xtensa/entry/syscalls/syscall.tbl    |    2 +
>  tools/scripts/syscall.tbl                     |    2 +
>  tools/testing/selftests/landlock/audit.h      |    6 +-
>  tools/testing/selftests/pidfd/.gitignore      |    9 +
>  tools/testing/selftests/pidfd/Makefile        |   25 +-
>  tools/testing/selftests/pidfd/config          |    6 +
>  .../pidfd/pidfd_spawn_accounting_test.c       |  428 ++++++
>  .../pidfd/pidfd_spawn_actions_test.c          |  474 +++++++
>  .../selftests/pidfd/pidfd_spawn_audit_test.c  |  521 +++++++
>  .../selftests/pidfd/pidfd_spawn_common.c      |  512 +++++++
>  .../selftests/pidfd/pidfd_spawn_common.h      |   59 +
>  .../selftests/pidfd/pidfd_spawn_compat.c      |  221 +++
>  .../selftests/pidfd/pidfd_spawn_exec_test.c   |  301 ++++
>  .../selftests/pidfd/pidfd_spawn_policy_test.c |  294 ++++
>  .../selftests/pidfd/pidfd_spawn_race_test.c   |  923 ++++++++++++
>  .../pidfd/pidfd_spawn_security_test.c         | 1242 +++++++++++++++++
>  .../selftests/pidfd/pidfd_spawn_test.c        |  550 ++++++++
>  80 files changed, 7938 insertions(+), 81 deletions(-)
>  create mode 100644 Documentation/userspace-api/pidfd_spawn.rst
>  create mode 100644 fs/exec_internal.h
>  create mode 100644 fs/pidfd_spawn.c
>  create mode 100644 include/linux/pidfd_spawn.h
>  create mode 100644 include/uapi/linux/pidfd_spawn.h
>  create mode 100644 tools/include/uapi/linux/pidfd_spawn.h
>  create mode 100644 tools/testing/selftests/pidfd/pidfd_spawn_accounting_test.c
>  create mode 100644 tools/testing/selftests/pidfd/pidfd_spawn_actions_test.c
>  create mode 100644 tools/testing/selftests/pidfd/pidfd_spawn_audit_test.c
>  create mode 100644 tools/testing/selftests/pidfd/pidfd_spawn_common.c
>  create mode 100644 tools/testing/selftests/pidfd/pidfd_spawn_common.h
>  create mode 100644 tools/testing/selftests/pidfd/pidfd_spawn_compat.c
>  create mode 100644 tools/testing/selftests/pidfd/pidfd_spawn_exec_test.c
>  create mode 100644 tools/testing/selftests/pidfd/pidfd_spawn_policy_test.c
>  create mode 100644 tools/testing/selftests/pidfd/pidfd_spawn_race_test.c
>  create mode 100644 tools/testing/selftests/pidfd/pidfd_spawn_security_test.c
>  create mode 100644 tools/testing/selftests/pidfd/pidfd_spawn_test.c
> 
> -- 
> 2.52.0
> 
