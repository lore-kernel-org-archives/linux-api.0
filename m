Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08AC946AF0A;
	Thu,  8 Oct 2026 08:50:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791449417; cv=none; b=B3/88Cyug9TGNYL4LJJimz+1jcCyX/S3Aj2jwru2or8EsDIKRvE5MY42COUv2aCbFhi8a5kIeju9nAldjXJxuvuCayNKsSgXBUelKBYWRcqa2tdgS9KyLJGtq6O80OFjvEw3tRRlAM88ZVhhFBeY6gnQpB+gP9SqR7fOLhyiwpI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791449417; c=relaxed/simple;
	bh=Y81cjMEOGGoKTTzPC6sX5h2TI6CFz1ACqqBTB/kZF9o=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=X8wDuwFC5TYHsTNXyiT5CkLkh/9Tjwfx+HrwixI71Fnn3/g10ro4ep6xwpawdEROCapWq1pLGdDuhJyaheiu4IQP16m5WCeU0bNjhOOMlg5dwjhb3M9eMPzLeGzh50bRvJGSAQLKJkosFniccaVySQVTQ5os11pHYVu+vFklC+4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mGPOeGbs; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mGPOeGbs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 578F21F000FF;
	Thu,  8 Oct 2026 08:50:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791449413;
	bh=a4DZfgRtRM1DfMkYwTNcvGcIRfoRHzGzJb+Heok6HXU=;
	h=From:To:Cc:Subject:Date;
	b=mGPOeGbsJ/bnNsddkZbUm/ydGEL0szfbmw6AdL97ACeU3sTLPEkyRS7f3RiWIqxvm
	 /MxFgsw0TaQ35kQFj+940bytBDQpSoxbyOKTat4qiT0/eQBbr4eHWHa9vkddp2bWeX
	 HQhtzEcVnOvcy7fqzsjZyMjeFzxMPH8RQtOjecjVVyVqJB7YeufNKpxacbDQMxJXZ9
	 7CcyLzCmtPk74kfmB7aEUL3I24Wi6SHz7vaq87HV9D8ke74ODRQep0fK6dW22Dhl6P
	 aT2UpAVpul/lC/zwYDnTvRpNAgU5XDuRpt+iLlAD9lOJplrDuOcuarRKjq7y14iEhU
	 ccw+iySavEnrw==
From: Sasha Levin <sashal@kernel.org>
To: linux-api@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: Sasha Levin <sashal@kernel.org>,
	linux-doc@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-kbuild@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	workflows@vger.kernel.org,
	tools@kernel.org,
	x86@kernel.org,
	Thomas Gleixner <tglx@kernel.org>,
	"Paul E . McKenney" <paulmck@kernel.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Dmitry Vyukov <dvyukov@google.com>,
	Randy Dunlap <rdunlap@infradead.org>,
	Cyril Hrubis <chrubis@suse.cz>,
	Kees Cook <kees@kernel.org>,
	Jake Edge <jake@lwn.net>,
	David Laight <david.laight.linux@gmail.com>,
	Gabriele Paoloni <gpaoloni@redhat.com>,
	Mauro Carvalho Chehab <mchehab@kernel.org>,
	Christian Brauner <brauner@kernel.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Andrew Morton <akpm@linux-foundation.org>,
	Masahiro Yamada <masahiroy@kernel.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Nathan Chancellor <nathan@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: [PATCH v5 00/11] Kernel API Specification Framework
Date: Thu,  8 Oct 2026 04:49:40 -0400
Message-ID: <20261008084956.2911790-1-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This series adds machinery for documenting kernel APIs in a machine-readable
form. The kernel promises not to break user space, but the contract of each
interface is written down only as prose in man pages and comments, which tools
cannot check.

Specifications can document parameter types, valid ranges, constraints, and
alignment requirements. They capture return value semantics including success
conditions and error codes with their meaning. Execution context requirements,
capabilities, locking constraints, signal handling behavior, and side effects
can all be formally specified.

These specifications live alongside the code they document and are both
human-readable and machine-parseable. They can be validated at runtime when
CONFIG_KAPI_RUNTIME_CHECKS is enabled, exported via debugfs for userspace
tools, and extracted from either vmlinux or source code.

The intent is for static analyzers, test generators and documentation tools
to consume these specifications. This series adds the framework, the
extraction tool, and specifications for five syscalls.

The implementation includes a core framework with ELF section storage,
kerneldoc integration for inline specification, a debugfs interface for runtime
querying, ftrace tracepoints that report each spec'd syscall's parameters and
return value, and a Rust-based extraction tool (tools/kapi) supporting JSON,
RST, and plain text output formats. Example specifications are provided for the
four fundamental file syscalls (sys_open, sys_close, sys_read, sys_write) and
for sys_madvise. The series also includes a KUnit test suite with 33 tests and
a runtime verification selftest with 31 TAP tests.

The series is also available in the "spec" branch of:

  https://git.kernel.org/pub/scm/linux/kernel/git/sashal/kapi.git

Changes since v4:

- Rebase onto v7.3-rc6: the sys_open spec accepts O_EMPTYPATH, the madvise
  spec follows the zap_vma_range() rename, and tools/kapi declares Rust 1.85
  to match the kernel minimum.

- CONFIG_KAPI_RUNTIME_CHECKS builds on 32-bit and on architectures without
  a syscall wrapper, and depends on X86 || !ARCH_HAS_SYSCALL_WRAPPER since
  other architectures never reach the hook. __SYSCALL_DEFINEx gains small
  hooks instead of a duplicated copy, with the prototypes in
  <linux/kapi_syscall.h>.

- Correct the syscall specs against the implementation (O_CREAT|O_DIRECTORY,
  O_PATH flag masking, EOVERFLOW and RLIMIT_FSIZE handling, SUID/SGID
  clearing, close() error sources, lock descriptions, madvise locking).

- kdoc_apispec.py: keep paragraph and line structure in long-desc, notes and
  examples, stop truncating fields at colons or 512 characters, and emit
  state-transition conditions and exact success values.

- debugfs exports the complete spec as JSON without a fixed-size buffer.
  tools/kapi gives the same result from --vmlinux and --debugfs, and from
  --source wherever no preprocessor evaluation is needed.

- kernel-doc recognises the KAPI sections only in -apispec mode, so its
  other output is unchanged. Kbuild generates headers only for sources
  with a contexts: line plus another KAPI section, regenerates them when
  the generator changes, and no longer reads stdin when a directory has
  no such sources.

- Fix KAPI_CAP_ALTERNATIVE and add KAPI_SIGNAL_MASK_COUNT.

Changes since v3:

- Fix the build with CONFIG_KAPI_SPEC=y: scripts/Makefile.build now derives the
  list of instrumented sources from $(real-obj-y)/$(real-obj-m) instead of a
  recursive find, and the detection regex matches "contexts:" (the token the
  syscalls actually use). The previous "context-flags:"-only match found no
  files, so no *.apispec.h was generated and the guarded includes failed to
  compile.

- Force-include the generated *.apispec.h via a per-object -include cflag in
  scripts/Makefile.build rather than a manual "#include" at the end of each
  instrumented source; the include blocks are dropped from fs/open.c and
  fs/read_write.c.

- kernel/Makefile: drop the redundant "obj- += api/"; the
  obj-$(CONFIG_KAPI_SPEC) gate already covers 'make clean'.

- kernel/api/Makefile: build kernel_api_spec.o with obj-y now that the subdir
  gate lives in kernel/Makefile.

- kernel/api/Kconfig: drop the tautological "default n" from KAPI_SPEC,
  KAPI_RUNTIME_CHECKS and KAPI_SPEC_DEBUGFS.

- Add an API specification for sys_madvise.

- Add ftrace tracepoints on the runtime-check path: kapi_syscall_enter (spec
  name and named parameter values) and kapi_syscall_exit (return value and
  spec match).

Changes since v2:

- Replace statically sized arrays in the spec structs with const char *
  pointers to reduce memory footprint and remove string truncation.

- Simplify the kerneldoc DSL to short tokens (e.g. `type: uint, input`,
  `contexts: process, softirq`, `constraint-type: range(0, KMAX)`,
  `side-effect: alloc_memory`) in place of raw KAPI_* enum names.

- tools/kapi: commit Cargo.lock for reproducible offline builds, add a
  Makefile and README, expand the kerneldoc parser to cover the full
  DSL, and refactor the vmlinux extractor for the const-pointer layout.

- tools/lib/python/kdoc/kdoc_apispec.py expanded to match the DSL so
  scripts/kernel-doc --apispec emits the structure the extractor consumes.

References:

  v4: https://lore.kernel.org/all/20260529233311.1901670-1-sashal@kernel.org/
  v3: https://lore.kernel.org/all/20260424165130.2306833-1-sashal@kernel.org/
  v2: https://lore.kernel.org/all/20260322121026.869758-1-sashal@kernel.org/
  v1: https://lore.kernel.org/all/20260313150928.2637368-1-sashal@kernel.org/
  RFC v5: https://lore.kernel.org/lkml/20251218204239.4159453-1-sashal@kernel.org/
  RFC v4: https://lore.kernel.org/lkml/20250825181434.3340805-1-sashal@kernel.org/
  RFC v3: https://lore.kernel.org/lkml/20250711114248.2288591-1-sashal@kernel.org/
  RFC v2: https://lore.kernel.org/lkml/20250624180742.5795-1-sashal@kernel.org/
  RFC v1: https://lore.kernel.org/lkml/20250614134858.790460-1-sashal@kernel.org/



Sasha Levin (11):
  kernel/api: introduce kernel API specification framework
  kernel/api: enable kerneldoc-based API specifications
  kernel/api: add debugfs interface for kernel API specifications
  tools/kapi: add kernel API specification extraction tool
  kernel/api: add API specification for sys_open
  kernel/api: add API specification for sys_close
  kernel/api: add API specification for sys_read
  kernel/api: add API specification for sys_write
  kernel/api: add runtime verification selftest
  kernel/api: add API specification for sys_madvise
  kernel/api: add syscall enter/exit tracepoints

 .gitignore                                    |    1 +
 Documentation/dev-tools/index.rst             |    1 +
 Documentation/dev-tools/kernel-api-spec.rst   |  648 ++++
 MAINTAINERS                                   |   13 +
 Makefile                                      |    1 +
 arch/x86/include/asm/syscall_wrapper.h        |    3 +-
 fs/open.c                                     |  557 +++
 fs/read_write.c                               |  710 ++++
 include/asm-generic/vmlinux.lds.h             |   14 +
 include/linux/kapi_syscall.h                  |   35 +
 include/linux/kernel_api_spec.h               | 1226 ++++++
 include/linux/syscalls.h                      |   42 +-
 include/trace/events/kapi.h                   |   74 +
 init/Kconfig                                  |    2 +
 kernel/Makefile                               |    1 +
 kernel/api/Kconfig                            |   74 +
 kernel/api/Makefile                           |   13 +
 kernel/api/internal.h                         |   25 +
 kernel/api/kapi_debugfs.c                     |  553 +++
 kernel/api/kapi_kunit.c                       |  720 ++++
 kernel/api/kernel_api_spec.c                  | 1470 ++++++++
 mm/madvise.c                                  |  549 +++
 scripts/Makefile.build                        |   26 +
 tools/docs/kernel-doc                         |   12 +-
 tools/kapi/.gitignore                         |    3 +
 tools/kapi/Cargo.lock                         |  679 ++++
 tools/kapi/Cargo.toml                         |   20 +
 tools/kapi/Makefile                           |   33 +
 tools/kapi/README.md                          |   33 +
 tools/kapi/src/extractor/debugfs.rs           | 1704 +++++++++
 tools/kapi/src/extractor/kerneldoc_parser.rs  | 3335 +++++++++++++++++
 tools/kapi/src/extractor/mod.rs               |  442 +++
 tools/kapi/src/extractor/source_parser.rs     |  531 +++
 .../src/extractor/vmlinux/binary_utils.rs     |  461 +++
 tools/kapi/src/extractor/vmlinux/mod.rs       | 1160 ++++++
 tools/kapi/src/formatter/json.rs              |  659 ++++
 tools/kapi/src/formatter/mod.rs               |  220 ++
 tools/kapi/src/formatter/plain.rs             |  679 ++++
 tools/kapi/src/formatter/rst.rs               |  802 ++++
 tools/kapi/src/main.rs                        |  123 +
 tools/lib/python/kdoc/kdoc_apispec.py         | 1391 +++++++
 tools/lib/python/kdoc/kdoc_files.py           |   12 +-
 tools/lib/python/kdoc/kdoc_parser.py          |  101 +-
 tools/testing/selftests/Makefile              |    1 +
 tools/testing/selftests/kapi/.gitignore       |    2 +
 tools/testing/selftests/kapi/Makefile         |    7 +
 tools/testing/selftests/kapi/kapi_test_util.h |   31 +
 tools/testing/selftests/kapi/test_kapi.c      | 1163 ++++++
 48 files changed, 20350 insertions(+), 12 deletions(-)
 create mode 100644 Documentation/dev-tools/kernel-api-spec.rst
 create mode 100644 include/linux/kapi_syscall.h
 create mode 100644 include/linux/kernel_api_spec.h
 create mode 100644 include/trace/events/kapi.h
 create mode 100644 kernel/api/Kconfig
 create mode 100644 kernel/api/Makefile
 create mode 100644 kernel/api/internal.h
 create mode 100644 kernel/api/kapi_debugfs.c
 create mode 100644 kernel/api/kapi_kunit.c
 create mode 100644 kernel/api/kernel_api_spec.c
 create mode 100644 tools/kapi/.gitignore
 create mode 100644 tools/kapi/Cargo.lock
 create mode 100644 tools/kapi/Cargo.toml
 create mode 100644 tools/kapi/Makefile
 create mode 100644 tools/kapi/README.md
 create mode 100644 tools/kapi/src/extractor/debugfs.rs
 create mode 100644 tools/kapi/src/extractor/kerneldoc_parser.rs
 create mode 100644 tools/kapi/src/extractor/mod.rs
 create mode 100644 tools/kapi/src/extractor/source_parser.rs
 create mode 100644 tools/kapi/src/extractor/vmlinux/binary_utils.rs
 create mode 100644 tools/kapi/src/extractor/vmlinux/mod.rs
 create mode 100644 tools/kapi/src/formatter/json.rs
 create mode 100644 tools/kapi/src/formatter/mod.rs
 create mode 100644 tools/kapi/src/formatter/plain.rs
 create mode 100644 tools/kapi/src/formatter/rst.rs
 create mode 100644 tools/kapi/src/main.rs
 create mode 100644 tools/lib/python/kdoc/kdoc_apispec.py
 create mode 100644 tools/testing/selftests/kapi/.gitignore
 create mode 100644 tools/testing/selftests/kapi/Makefile
 create mode 100644 tools/testing/selftests/kapi/kapi_test_util.h
 create mode 100644 tools/testing/selftests/kapi/test_kapi.c

-- 
2.53.0

