Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0878047045C;
	Thu,  8 Oct 2026 08:50:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791449430; cv=none; b=GENvwvGofwDL0okENYFI+3jP8S77ki0tGB/AXsiXhwCUKL+2ecm/c5G+OqxRYJ8uyNPbSZ0sqmWJUt8jGBeiosP0a4WbOhrWQ9i8oSS0jKdbZ2vVGzv56VsoM7q3ZAl5xb9ZKxA/nfLiPc5OciorHDf3gMZn5DTWu8z2OocSnCQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791449430; c=relaxed/simple;
	bh=6tcou1E1OXIz02wbeg8cDqxMKWSdpx64rncGVfe+8qk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=SCUrpYvLUxSYUZMHVkbBwg4u9ui1wmSWK05H3vgAVgbl2I8jpHjNSXMwPuUl0jGNKa9QnPDYJkldatFaHVaUvDHQ6iSEK4y1unlyR4aLufwXHr8P0nsbKMcAKJUK9lcT+1/jIOVRh7W3Gtw1XrCxbIsU65eIjUa5BtGxLTWTUkc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RfNuowvt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RfNuowvt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 079EB1F00898;
	Thu,  8 Oct 2026 08:50:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791449420;
	bh=jDsepahtKEYSXFacljULtZgvRWDR63jL4As/g4r24Z0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RfNuowvtAG3S82kHgSKWTrlMaDG/yFaQHOHKVBzz7ug4WCEJvTJ5bE8nJ1T+lA98o
	 hqWvNgirLOLp6ULLxqxWoYkwb3dfM/WneoDLj6vDi2tahuIXFUFHfxFNAO11DrMJ6V
	 zX6NRpmWecvpbqREdjqdq2uC6+wYp0/lg5fBkVVjBpgTSH4fgGFxNwFcJdrg91mFiT
	 ZO8p6iIYrFIyQEUF8YJPEDXva5j9DqF/ctCIx6jjhsaC23XLnTdK+5TozCqzWCDPFe
	 xWThtq0PGFeFSuEPthqsr/QenYSztdxFWfqEcCG6NHW/HzsrR6dc9JW+5eXLkeFyUo
	 NhbEX+b4QYz8g==
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
Subject: [PATCH v5 01/11] kernel/api: introduce kernel API specification framework
Date: Thu,  8 Oct 2026 04:49:41 -0400
Message-ID: <20261008084956.2911790-2-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261008084956.2911790-1-sashal@kernel.org>
References: <20261008084956.2911790-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Add a framework for formally documenting kernel APIs with inline
specifications. This framework provides:

- Structured API documentation with parameter specifications, return
  values, error conditions, and execution context requirements
- Runtime validation capabilities for debugging
  (CONFIG_KAPI_RUNTIME_CHECKS)
- Support for both internal kernel APIs and system calls

The framework stores specifications in a dedicated ELF section and
provides infrastructure for:
- Runtime querying of API documentation
- Integration with existing SYSCALL_DEFINE macros

A KUnit suite (CONFIG_KAPI_KUNIT_TEST) covers registration, lookup,
parameter and return value validation, and JSON export.

No specifications are added here; subsequent patches add them for
individual syscalls. With CONFIG_KAPI_SPEC=n the SYSCALL_DEFINEx()
expansion is unchanged. CONFIG_KAPI_RUNTIME_CHECKS is a debug option:
a syscall whose arguments violate its specification returns -EINVAL
without running.

Assisted-by: LLM
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/dev-tools/index.rst           |    1 +
 Documentation/dev-tools/kernel-api-spec.rst |  615 ++++++++
 MAINTAINERS                                 |   11 +
 arch/x86/include/asm/syscall_wrapper.h      |    3 +-
 include/asm-generic/vmlinux.lds.h           |   14 +
 include/linux/kapi_syscall.h                |   35 +
 include/linux/kernel_api_spec.h             | 1226 ++++++++++++++++
 include/linux/syscalls.h                    |   42 +-
 init/Kconfig                                |    2 +
 kernel/Makefile                             |    1 +
 kernel/api/Kconfig                          |   54 +
 kernel/api/Makefile                         |   10 +
 kernel/api/internal.h                       |   25 +
 kernel/api/kapi_kunit.c                     |  720 ++++++++++
 kernel/api/kernel_api_spec.c                | 1415 +++++++++++++++++++
 15 files changed, 4172 insertions(+), 2 deletions(-)
 create mode 100644 Documentation/dev-tools/kernel-api-spec.rst
 create mode 100644 include/linux/kapi_syscall.h
 create mode 100644 include/linux/kernel_api_spec.h
 create mode 100644 kernel/api/Kconfig
 create mode 100644 kernel/api/Makefile
 create mode 100644 kernel/api/internal.h
 create mode 100644 kernel/api/kapi_kunit.c
 create mode 100644 kernel/api/kernel_api_spec.c

diff --git a/Documentation/dev-tools/index.rst b/Documentation/dev-tools/index.rst
index 59cbb77b33ff4..8d3768645d96c 100644
--- a/Documentation/dev-tools/index.rst
+++ b/Documentation/dev-tools/index.rst
@@ -36,6 +36,7 @@ Documentation/process/debugging/index.rst
    kunit/index
    ktap
    checkuapi
+   kernel-api-spec
    gpio-sloppy-logic-analyzer
    autofdo
    propeller
diff --git a/Documentation/dev-tools/kernel-api-spec.rst b/Documentation/dev-tools/kernel-api-spec.rst
new file mode 100644
index 0000000000000..4fb412b2720d3
--- /dev/null
+++ b/Documentation/dev-tools/kernel-api-spec.rst
@@ -0,0 +1,615 @@
+.. SPDX-License-Identifier: GPL-2.0
+
+======================================
+Kernel API Specification Framework
+======================================
+
+:Author: Sasha Levin <sashal@kernel.org>
+
+.. contents:: Table of Contents
+   :depth: 3
+   :local:
+
+Introduction
+============
+
+The Kernel API Specification Framework (KAPI) describes kernel APIs in a
+machine-readable form. The descriptions are written as kerneldoc annotations
+next to the implementation and compiled into the kernel. They can be used to
+check system call arguments at runtime and can be read back through debugfs or
+the ``kapi`` tool.
+
+Purpose and Goals
+-----------------
+
+The framework aims to:
+
+1. **Improve API Documentation**: Provide structured, inline documentation that
+   lives alongside the code and is maintained as part of the development process.
+
+2. **Enable Runtime Validation**: Optionally validate API usage at runtime to catch
+   common programming errors during development and testing.
+
+3. **Support Tooling**: Export API specifications in machine-readable formats for
+   use by static analyzers, documentation generators, and development tools.
+
+4. **Formalize Contracts**: Explicitly document API contracts including parameter
+   constraints, execution contexts, locking requirements, and side effects.
+
+Architecture Overview
+=====================
+
+Components
+----------
+
+The framework consists of several key components:
+
+1. **Core Framework** (``kernel/api/kernel_api_spec.c``)
+
+   - API specification registration and storage
+   - Runtime validation engine
+   - Specification lookup and querying
+
+2. **DebugFS Interface** (``kernel/api/kapi_debugfs.c``)
+
+   - Runtime introspection via ``/sys/kernel/debug/kapi/``
+   - Per-API detailed specification output
+   - List of all registered API specifications
+
+3. **kapi Tool** (``tools/kapi/``)
+
+   - Userspace utility for extracting specifications
+   - Multiple input sources (source, binary, debugfs)
+   - Multiple output formats (plain, JSON, RST)
+   - Testing and validation utilities
+
+Data Model
+----------
+
+The framework uses a hierarchical data model::
+
+    kernel_api_spec
+    ├── Basic Information
+    │   ├── name (API function name)
+    │   ├── version (specification version)
+    │   └── description (human-readable description)
+    │
+    ├── Parameters (up to 16)
+    │   └── kapi_param_spec
+    │       ├── name
+    │       ├── type (int, pointer, fd, path, etc.)
+    │       ├── flags (in, out, inout, optional, etc.)
+    │       ├── constraints (range, mask, enum values)
+    │       └── description
+    │
+    ├── Return Value
+    │   └── kapi_return_spec
+    │       ├── type
+    │       ├── success conditions
+    │       └── validation rules
+    │
+    ├── Error Conditions (up to 32)
+    │   └── kapi_error_spec
+    │       ├── error code
+    │       ├── name
+    │       ├── condition
+    │       └── description
+    │
+    ├── Execution Context
+    │   ├── allowed contexts (process, interrupt, etc.)
+    │   ├── locking requirements
+    │   └── preemption/interrupt state
+    │
+    └── Side Effects
+        ├── memory allocation
+        ├── state changes
+        └── signal handling
+
+Usage Guide
+===========
+
+Basic API Specification
+-----------------------
+
+API specifications are written as KAPI-annotated kerneldoc comments directly in
+the source file, immediately preceding the function implementation. With
+``CONFIG_KAPI_SPEC`` enabled, Kbuild runs ``kernel-doc -apispec`` on each
+built-in C file that has a ``contexts:`` (or ``context-flags:``) line plus at
+least one of ``api-type:``, ``param:``, ``error:``, ``capability:``,
+``signal:``, ``lock:``, ``state-trans:``, ``constraint:``, ``side-effect:`` or
+``long-desc:``, and compiles the generated header into that file. The ``kapi``
+tool reads the same annotations, or the specifications in a built kernel, for
+use outside the kernel build.
+
+The following is an excerpt of the ``sys_read`` specification in
+``fs/read_write.c``, trimmed for length:
+
+.. code-block:: c
+
+    /**
+     * sys_read - Read data from a file descriptor
+     * @fd: File descriptor to read from
+     * @buf: User-space buffer to read data into
+     * @count: Maximum number of bytes to read
+     *
+     * long-desc: Attempts to read up to count bytes from file descriptor fd into
+     *   the buffer starting at buf. ...
+     *
+     * contexts: process, sleepable
+     *
+     * param: fd
+     *   type: fd, input
+     *   constraint-type: range(0, INT_MAX)
+     *
+     * param: buf
+     *   type: user_ptr, output
+     *   constraint-type: buffer(2)
+     *
+     * param: count
+     *   type: uint, input
+     *
+     * return:
+     *   type: int
+     *   check-type: range
+     *   success: >= 0
+     *   desc: On success, returns the number of bytes read (non-negative). ...
+     *
+     * error: EBADF, Bad file descriptor
+     *   desc: fd is not a valid file descriptor, or fd was not opened for
+     *     reading. ...
+     */
+    SYSCALL_DEFINE3(read, unsigned int, fd, char __user *, buf, size_t, count)
+
+DSL reference:
+
+* ``contexts:`` — comma-separated list of call contexts.  Accepted tokens:
+  ``process``, ``softirq``, ``hardirq``, ``nmi``, ``atomic``, ``sleepable``,
+  ``preempt_disabled``, ``irq_disabled``.  ``context-flags:`` with
+  ``|``-joined ``KAPI_CTX_*`` constants is equivalent.
+* ``type:`` — parameter type plus direction/qualifier flags on a single
+  line.  Type aliases (case-insensitive): ``int``, ``uint``, ``ptr``,
+  ``fd``, ``path``, ``user_ptr`` (or ``uptr``), ``struct``, ``union``,
+  ``enum``, ``func_ptr``, ``array``, ``custom``.  Flag aliases:
+  ``input``, ``output``, ``inout``, ``user``, ``optional``, ``const``,
+  ``volatile``, ``dma``, ``aligned``.
+* ``constraint-type:`` — a ``KAPI_CONSTRAINT_*`` enum token or a
+  function-call expression.  ``range(lo, hi)``, ``mask(expr)``,
+  ``enum(v1, v2, …)``, ``buffer(size_param_idx)``, ``alignment(N)``,
+  ``user_string``, ``user_path``, ``user_ptr``, ``power_of_two``,
+  ``page_aligned``, ``nonzero``.  ``user_string`` takes its length limits
+  from ``range:``.  The function-call
+  form populates the matching aux fields
+  (``range:`` / ``valid-mask:`` / ``size-param:``).
+* ``lock: … type:`` accepts ``mutex``, ``spinlock``, ``rwlock``,
+  ``seqlock``, ``rcu``, ``semaphore``, ``custom`` or ``KAPI_LOCK_*``.
+* ``signal: … direction:`` accepts ``receive``, ``send``, ``handle``,
+  ``block``, ``ignore`` (bitmask, joinable with ``|`` or ``,``).
+* ``signal: … action:`` accepts ``default``, ``terminate``, ``coredump``,
+  ``stop``, ``continue``, ``custom``, ``return``, ``restart``,
+  ``queue``, ``discard``, ``transform``.
+* ``signal: … timing:`` accepts ``before``, ``during``, ``after``.
+* ``capability: … type:`` accepts ``bypass_check``, ``increase_limit``,
+  ``override_restriction``, ``grant_permission``, ``modify_behavior``,
+  ``access_resource``, ``perform_operation``.
+* ``side-effect:`` accepts the snake_case effect names
+  (``alloc_memory``, ``free_memory``, ``modify_state``, ``signal_send``,
+  ``file_position``, ``lock_acquire``, ``lock_release``,
+  ``resource_create``, ``resource_destroy``, ``schedule``, ``hardware``,
+  ``network``, ``filesystem``, ``process_state``, ``irreversible``)
+  joined with ``|`` — for example ``side-effect: resource_create | alloc_memory``.
+* ``return: … type:`` reuses the ``type:`` aliases above.
+* ``return: … check-type:`` accepts ``exact``, ``range``,
+  ``fd``, ``no_return``.  ``success:``
+  gives the success value for ``exact`` (an integer, optionally
+  written ``= N``) and the lower bound for ``range`` (``>= N``); the
+  other check types do not use it.  The ``type:`` of a return block
+  is also kept as written (for example ``int``) in the
+  human-readable ``type_name`` of ``struct kapi_return_spec``.
+* ``error:`` takes a ``NAME, one-line summary`` header followed
+  by optional indented ``desc:`` / ``condition:`` subfields.
+* ``lock:`` and ``signal:`` take an indented ``desc:`` subfield
+  for the long-form description; ``signal:`` also accepts
+  ``number:`` (the signal constant, for example ``SIGPIPE``),
+  ``errno:``, ``priority:``, ``restartable:``, ``interruptible:``,
+  and ``queue:`` subfields.
+* ``state-trans:`` takes ``from:``, ``to:``, ``object:``,
+  optional ``condition:``, and ``desc:`` subfields.  The condition is
+  stored in its own field, apart from the description.
+* ``long-desc:`` is a free-form multi-line prose block that
+  populates ``long_description`` in the spec.  ``notes:`` is a
+  free-form block of the same kind.  In both, a blank line starts a
+  new paragraph, a line starting with ``- `` stays on its own line so
+  bullet lists survive, and any other wrapped line is joined to the
+  previous one with a space.  ``examples:`` keeps one example per
+  line, preserving the relative indentation of nested code.  The
+  line breaks are stored as ``\n`` in the generated strings, which
+  have no length limit.
+* A subfield line inside a block starts with one of the subfield
+  names of that block followed by ``:``.  Every other line, even one
+  with a colon in the middle of a sentence, continues the previous
+  subfield.
+* ``param-count:`` is optional; the parser counts ``param:`` blocks and
+  warns when an explicit count disagrees.
+
+System Call Specification
+-------------------------
+
+System calls are documented inline in the implementation file (e.g., ``fs/open.c``)
+using KAPI-annotated kerneldoc comments. When ``CONFIG_KAPI_RUNTIME_CHECKS`` is
+enabled, the ``SYSCALL_DEFINEx`` macros automatically look up the specification
+and validate parameters before and after the syscall executes.
+
+Runtime Validation
+==================
+
+Enabling Validation
+-------------------
+
+Runtime validation is controlled by kernel configuration:
+
+1. Enable ``CONFIG_KAPI_SPEC`` to build the framework
+2. Enable ``CONFIG_KAPI_RUNTIME_CHECKS`` for runtime validation
+
+Validation Behavior
+-------------------
+
+When ``CONFIG_KAPI_RUNTIME_CHECKS`` is enabled, every system call that has a
+specification is validated in its ``SYSCALL_DEFINEx()`` wrapper: the arguments
+are checked against the parameter constraints before the handler runs, and the
+return value is checked against the return specification afterwards. Violations
+are reported via ``pr_warn_ratelimited`` to avoid flooding the kernel log. On
+the return side only a successful ``fd`` return that is not a valid file
+descriptor is reported. Any other value that does not satisfy the success check
+is treated as an error and accepted, and error codes that the specification
+does not list are only logged at debug level.
+The execution context recorded in a specification is not checked at runtime.
+The option is available on x86 and on architectures that use the generic
+``__SYSCALL_DEFINEx()``.
+
+Custom Validators
+-----------------
+
+``KAPI_CONSTRAINT_CUSTOM`` calls the ``validate`` function of the parameter
+specification. Kerneldoc annotations cannot set it, so it is only available to a
+``struct kapi_param_spec`` that is filled in by hand:
+
+.. code-block:: c
+
+    static bool validate_buffer_size(s64 value)
+    {
+        size_t size = (size_t)value;
+
+        return size > 0 && size <= MAX_BUFFER_SIZE;
+    }
+
+    /* In the parameter definition: */
+    .constraint_type = KAPI_CONSTRAINT_CUSTOM,
+    .validate = validate_buffer_size,
+
+Performance Considerations
+==========================
+
+Memory Overhead
+---------------
+
+Each compiled spec is 26400 bytes (``readelf -sW vmlinux | grep
+__kapi_spec_``), dominated by the fixed-bound arrays
+``struct_specs[8]`` (11584 bytes), ``signal_masks[32]`` (4864),
+``signals[32]`` (3328) and ``params[16]`` (1920). With
+the five syscall specs in this series, ``.kapi_specs`` and the backing
+``.rodata`` objects occupy ~132 KB. Building with ``CONFIG_KAPI_SPEC=n``
+emits no code or data from the framework.
+
+Runtime Overhead
+----------------
+
+When ``CONFIG_KAPI_RUNTIME_CHECKS`` is enabled, each validated
+call pays for a parameter walk plus the per-constraint check
+(range/mask/enum/align/user-ptr/user-path/user-string).
+The cost depends on the parameter count and the constraints involved;
+profile before enabling on workloads where syscall latency matters.
+``CONFIG_KAPI_RUNTIME_CHECKS=n`` compiles the validators away
+entirely.
+
+The kapi Tool
+=============
+
+Overview
+--------
+
+The ``kapi`` tool is a userspace utility that extracts and displays kernel API
+specifications from multiple sources. It provides a unified interface to access
+API documentation whether from compiled kernels, source code, or runtime systems.
+
+Installation
+------------
+
+Build the tool from the kernel source tree::
+
+    $ cd tools/kapi
+    $ cargo build --release
+
+    # Optional: Install system-wide
+    $ cargo install --path .
+
+The tool requires Rust and Cargo to build. The binary will be available at
+``tools/kapi/target/release/kapi``.
+
+Command-Line Usage
+------------------
+
+Basic syntax::
+
+    kapi [OPTIONS] [API_NAME]
+
+Options:
+
+- ``--vmlinux <PATH>``: Extract from compiled kernel binary
+- ``--source <PATH>``: Extract from kernel source code
+- ``--debugfs <PATH>``: Extract from debugfs (default: /sys/kernel/debug)
+- ``-f, --format <FORMAT>``: Output format (plain, json, rst)
+- ``-h, --help``: Display help information
+- ``-V, --version``: Display version information
+
+Input Modes
+-----------
+
+**1. Source Code Mode**
+
+Extract specifications directly from kernel source::
+
+    # Scan entire kernel source tree
+    $ kapi --source /path/to/linux
+
+    # Extract from specific file
+    $ kapi --source fs/open.c
+
+    # Get details for specific API
+    $ kapi --source /path/to/linux sys_close
+
+**2. Vmlinux Mode**
+
+Extract from compiled kernel with debug symbols::
+
+    # List all APIs in vmlinux
+    $ kapi --vmlinux ./vmlinux
+
+    # Get specific syscall details
+    $ kapi --vmlinux ./vmlinux sys_read
+
+**3. Debugfs Mode**
+
+Extract from running kernel via debugfs::
+
+    # Use default debugfs path
+    $ kapi
+
+    # Use custom debugfs mount
+    $ kapi --debugfs /mnt/debugfs
+
+    # Get specific API from running kernel
+    $ kapi sys_write
+
+Output Formats
+--------------
+
+The samples below are shortened; ``...`` marks omitted output.
+
+**Plain Text Format** (default)::
+
+    $ kapi --source . sys_read
+
+    Detailed information for sys_read:
+    ==================================
+    Description: Read data from a file descriptor
+
+    Detailed Description:
+      Attempts to read up to count bytes from file descriptor fd into the buffer starting at buf. ...
+
+    Execution Context:
+      - KAPI_CTX_PROCESS
+      - KAPI_CTX_SLEEPABLE
+
+    Parameters (3):
+      [0] fd (unsigned int fd)
+          File descriptor to read from
+          Flags: IN
+          ...
+
+**JSON Format**::
+
+    $ kapi --source . --format json sys_read
+    {
+      "api_details": {
+        "name": "sys_read",
+        "description": "Read data from a file descriptor",
+        "long_description": "Attempts to read up to count bytes from file descriptor fd into the buffer starting at buf. ...",
+        "context_flags": [
+          "KAPI_CTX_PROCESS",
+          "KAPI_CTX_SLEEPABLE"
+        ],
+        ...
+      }
+    }
+
+**ReStructuredText Format**::
+
+    $ kapi --source . --format rst sys_read
+
+    sys_read
+    ========
+
+    **Read data from a file descriptor**
+
+    Attempts to read up to count bytes from file descriptor fd into the buffer starting at buf. ...
+
+Usage Examples
+--------------
+
+**Generate complete API documentation**::
+
+    # Export all kernel APIs to JSON
+    $ kapi --source /path/to/linux --format json > kernel-apis.json
+
+    # Generate RST documentation for all syscalls
+    $ kapi --vmlinux ./vmlinux --format rst > syscalls.rst
+
+    # List APIs from specific subsystem
+    $ kapi --source fs/
+
+**Integration with other tools**::
+
+    # List the names of all APIs
+    $ kapi --format json | jq -r '.apis[].name'
+
+    # Generate markdown documentation
+    $ kapi --format rst sys_madvise | pandoc -f rst -t markdown
+
+**Debugging and analysis**::
+
+    # Check if specific API exists
+    $ kapi --source . my_custom_api || echo "API not found"
+
+Implementation Details
+----------------------
+
+The tool extracts API specifications from three sources:
+
+1. **Source Code**: Parses KAPI-annotated kerneldoc comments in C files, using
+   the same selection rule as Kbuild; regular expressions only locate the
+   ``SYSCALL_DEFINEx()`` or function that follows each comment
+2. **Vmlinux**: Reads the ``.kapi_specs`` ELF section from compiled kernels
+3. **Debugfs**: Reads from ``/sys/kernel/debug/kapi/`` filesystem interface
+
+The tool supports all KAPI specification types:
+
+- System calls (kerneldoc annotations)
+- Kernel functions (kerneldoc annotations with KAPI tags)
+
+IDE Integration
+---------------
+
+Modern IDEs can use the specification data for:
+
+- Parameter hints
+- Type checking
+- Context validation
+- Error code documentation
+
+Best Practices
+==============
+
+Writing Specifications
+----------------------
+
+1. **Be Comprehensive**: Document all parameters, errors, and side effects
+2. **Keep Updated**: Update specs when API behavior changes
+3. **Use Examples**: Include usage examples in descriptions
+4. **Validate Constraints**: Define realistic constraints for parameters
+5. **Document Context**: Clearly specify allowed execution contexts
+
+Maintenance
+-----------
+
+1. **Version Specifications**: Increment version when API changes
+2. **Deprecation**: Mark deprecated APIs and suggest replacements
+3. **Cross-reference**: Link related APIs in descriptions
+4. **Test Specifications**: Verify specs match implementation
+
+Common Patterns
+---------------
+
+**Optional Parameters**:
+
+.. code-block:: c
+
+    /**
+     * @optional_arg: Optional argument (may be NULL)
+     *
+     * param: optional_arg
+     *   type: KAPI_TYPE_PTR
+     *   flags: KAPI_PARAM_IN | KAPI_PARAM_OPTIONAL
+     */
+
+**Buffer with Size Parameter**:
+
+.. code-block:: c
+
+    /**
+     * @buf: User-space buffer
+     *
+     * param: buf
+     *   type: KAPI_TYPE_USER_PTR
+     *   flags: KAPI_PARAM_OUT | KAPI_PARAM_USER
+     *   constraint-type: KAPI_CONSTRAINT_BUFFER
+     *   size-param: 2
+     */
+
+**Callback Functions**:
+
+.. code-block:: c
+
+    /**
+     * @callback: Callback function
+     *
+     * param: callback
+     *   type: KAPI_TYPE_FUNC_PTR
+     *   flags: KAPI_PARAM_IN
+     */
+
+Troubleshooting
+===============
+
+Common Issues
+-------------
+
+**Specification Not Found**
+
+A syscall that is missing from ``/sys/kernel/debug/kapi/list`` has no
+specification. Ensure the KAPI-annotated kerneldoc comment is in the same
+translation unit as the function implementation, is named ``sys_<name>`` for
+``SYSCALL_DEFINEx(<name>, ...)``, and has a ``contexts:`` line plus one more
+KAPI section as described above.
+
+**Validation Failures**::
+
+    kapi: Parameter fd: invalid file descriptor -1
+
+    Solution: Check parameter constraints or adjust specification if
+    the constraint is incorrect.
+
+Debug Options
+-------------
+
+Violations are logged with ``pr_warn_ratelimited()``. Error codes that a
+specification does not list are logged with ``pr_debug()``; with
+``CONFIG_DYNAMIC_DEBUG`` they can be enabled with::
+
+    echo 'file kernel_api_spec.c +p' > /sys/kernel/debug/dynamic_debug/control
+
+Contributing
+============
+
+Submitting Specifications
+-------------------------
+
+1. Add specifications to the same file as the API implementation
+2. Follow existing patterns and naming conventions
+3. Test with CONFIG_KAPI_RUNTIME_CHECKS enabled
+4. Run scripts/checkpatch.pl on your changes
+
+Review Criteria
+---------------
+
+Specifications will be reviewed for:
+
+1. **Completeness**: All parameters and errors documented
+2. **Accuracy**: Specification matches implementation
+3. **Clarity**: Descriptions are clear and helpful
+4. **Consistency**: Follows framework conventions
+5. **Performance**: No unnecessary runtime overhead
+
+Contact
+-------
+
+- Maintainer: Sasha Levin <sashal@kernel.org>
diff --git a/MAINTAINERS b/MAINTAINERS
index 65e8a4b5c90b1..cd15c6a776ae3 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -14118,6 +14118,17 @@ W:	https://linuxtv.org
 T:	git git://linuxtv.org/media.git
 F:	drivers/media/radio/radio-keene*
 
+KERNEL API SPECIFICATION FRAMEWORK (KAPI)
+M:	Sasha Levin <sashal@kernel.org>
+L:	linux-api@vger.kernel.org
+S:	Maintained
+F:	Documentation/dev-tools/kernel-api-spec.rst
+F:	include/linux/kapi_syscall.h
+F:	include/linux/kernel_api_spec.h
+F:	kernel/api/
+F:	tools/kapi/
+F:	tools/lib/python/kdoc/kdoc_apispec.py
+
 KERNEL AUTOMOUNTER
 M:	Ian Kent <raven@themaw.net>
 L:	autofs@vger.kernel.org
diff --git a/arch/x86/include/asm/syscall_wrapper.h b/arch/x86/include/asm/syscall_wrapper.h
index 7e88705e907f4..54b70c2cac8ac 100644
--- a/arch/x86/include/asm/syscall_wrapper.h
+++ b/arch/x86/include/asm/syscall_wrapper.h
@@ -223,11 +223,12 @@ extern long __ia32_sys_ni_syscall(const struct pt_regs *regs);
 #define __SYSCALL_DEFINEx(x, name, ...)					\
 	static long __se_sys##name(__MAP(x,__SC_LONG,__VA_ARGS__));	\
 	static inline long __do_sys##name(__MAP(x,__SC_DECL,__VA_ARGS__));\
+	__KAPI_SYSCALL_DEFINEx(x, name, __VA_ARGS__)			\
 	__X64_SYS_STUBx(x, name, __VA_ARGS__)				\
 	__IA32_SYS_STUBx(x, name, __VA_ARGS__)				\
 	static long __se_sys##name(__MAP(x,__SC_LONG,__VA_ARGS__))	\
 	{								\
-		long ret = __do_sys##name(__MAP(x,__SC_CAST,__VA_ARGS__));\
+		long ret = __KAPI_DO_SYS(name)(__MAP(x,__SC_CAST,__VA_ARGS__));\
 		__MAP(x,__SC_TEST,__VA_ARGS__);				\
 		__PROTECT(x, ret,__MAP(x,__SC_ARGS,__VA_ARGS__));	\
 		return ret;						\
diff --git a/include/asm-generic/vmlinux.lds.h b/include/asm-generic/vmlinux.lds.h
index b2988aa12f664..b754fa182a6a3 100644
--- a/include/asm-generic/vmlinux.lds.h
+++ b/include/asm-generic/vmlinux.lds.h
@@ -296,6 +296,19 @@
 #define TRACE_SYSCALLS()
 #endif
 
+#ifdef CONFIG_KAPI_SPEC
+/*
+ * .kapi_specs is an array of pointers (see DEFINE_KERNEL_API_SPEC()). Align
+ * __start_kapi_specs to at least pointer alignment so that no padding
+ * separates it from the first entry.
+ */
+#define KAPI_SPECS()							\
+	. = ALIGN(8);							\
+	BOUNDED_SECTION_BY(.kapi_specs, _kapi_specs)
+#else
+#define KAPI_SPECS()
+#endif
+
 #ifdef CONFIG_BPF_EVENTS
 #define BPF_RAW_TP() STRUCT_ALIGN();				\
 	BOUNDED_SECTION_BY(__bpf_raw_tp_map, __bpf_raw_tp)
@@ -485,6 +498,7 @@
 		. = ALIGN(8);						\
 		BOUNDED_SECTION_BY(__tracepoints_ptrs, ___tracepoints_ptrs) \
 		*(__tracepoints_strings)/* Tracepoints: strings */	\
+		KAPI_SPECS()						\
 	}								\
 									\
 	.rodata1          : AT(ADDR(.rodata1) - LOAD_OFFSET) {		\
diff --git a/include/linux/kapi_syscall.h b/include/linux/kapi_syscall.h
new file mode 100644
index 0000000000000..bc9387e0e052c
--- /dev/null
+++ b/include/linux/kapi_syscall.h
@@ -0,0 +1,35 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Copyright (C) 2026 Sasha Levin <sashal@kernel.org>
+ *
+ * Spec lookup and syscall validation entry points of the kernel API
+ * specification framework, kept apart from <linux/kernel_api_spec.h> so that
+ * <linux/syscalls.h> can declare them cheaply.
+ */
+
+#ifndef _LINUX_KAPI_SYSCALL_H
+#define _LINUX_KAPI_SYSCALL_H
+
+#include <linux/types.h>
+
+struct kernel_api_spec;
+
+const struct kernel_api_spec *kapi_get_spec(const char *name);
+
+#ifdef CONFIG_KAPI_RUNTIME_CHECKS
+int kapi_validate_syscall_params(const struct kernel_api_spec *spec,
+				 const s64 *params, int param_count);
+int kapi_validate_syscall_return(const struct kernel_api_spec *spec, s64 retval);
+#else
+static inline int kapi_validate_syscall_params(const struct kernel_api_spec *spec,
+					       const s64 *params, int param_count)
+{
+	return 0;
+}
+static inline int kapi_validate_syscall_return(const struct kernel_api_spec *spec, s64 retval)
+{
+	return 0;
+}
+#endif
+
+#endif /* _LINUX_KAPI_SYSCALL_H */
diff --git a/include/linux/kernel_api_spec.h b/include/linux/kernel_api_spec.h
new file mode 100644
index 0000000000000..f72ef5cd73b38
--- /dev/null
+++ b/include/linux/kernel_api_spec.h
@@ -0,0 +1,1226 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Copyright (C) 2026 Sasha Levin <sashal@kernel.org>
+ *
+ * kernel_api_spec.h - Kernel API Specification Framework
+ *
+ * Structures and macros for specifying kernel APIs in a human and
+ * machine-readable form: parameters, return values, error conditions,
+ * and constraints.
+ */
+
+#ifndef _LINUX_KERNEL_API_SPEC_H
+#define _LINUX_KERNEL_API_SPEC_H
+
+#include <linux/array_size.h>
+#include <linux/bits.h>
+#include <linux/compiler.h>
+#include <linux/errno.h>
+#include <linux/kapi_syscall.h>
+#include <linux/kernel.h>
+#include <linux/stringify.h>
+#include <linux/types.h>
+
+struct sigaction;
+
+#define KAPI_MAX_PARAMS		16
+#define KAPI_MAX_ERRORS		32
+#define KAPI_MAX_CONSTRAINTS	32
+#define KAPI_MAX_LOCKS		16
+#define KAPI_MAX_SIGNALS	32
+#define KAPI_MAX_NAME_LEN	128
+#define KAPI_MAX_DESC_LEN	512
+#define KAPI_MAX_CAPABILITIES	8
+
+/* Magic numbers for section validation (ASCII mnemonics) */
+#define KAPI_MAGIC_PARAMS	0x4B415031	/* 'KAP1' */
+#define KAPI_MAGIC_RETURN	0x4B415232	/* 'KAR2' */
+#define KAPI_MAGIC_ERRORS	0x4B414533	/* 'KAE3' */
+#define KAPI_MAGIC_LOCKS	0x4B414C34	/* 'KAL4' */
+#define KAPI_MAGIC_CONSTRAINTS	0x4B414335	/* 'KAC5' */
+#define KAPI_MAGIC_INFO		0x4B414936	/* 'KAI6' */
+#define KAPI_MAGIC_SIGNALS	0x4B415337	/* 'KAS7' */
+#define KAPI_MAGIC_SIGMASK	0x4B414D38	/* 'KAM8' */
+#define KAPI_MAGIC_STRUCTS	0x4B415439	/* 'KAT9' */
+#define KAPI_MAGIC_EFFECTS	0x4B414641	/* 'KAFA' */
+#define KAPI_MAGIC_TRANS	0x4B415442	/* 'KATB' */
+#define KAPI_MAGIC_CAPS		0x4B414343	/* 'KACC' */
+
+/**
+ * enum kapi_param_type - Parameter type classification
+ * @KAPI_TYPE_VOID: void type
+ * @KAPI_TYPE_INT: Integer types (int, long, etc.)
+ * @KAPI_TYPE_UINT: Unsigned integer types
+ * @KAPI_TYPE_PTR: Pointer types
+ * @KAPI_TYPE_STRUCT: Structure types
+ * @KAPI_TYPE_UNION: Union types
+ * @KAPI_TYPE_ENUM: Enumeration types
+ * @KAPI_TYPE_FUNC_PTR: Function pointer types
+ * @KAPI_TYPE_ARRAY: Array types
+ * @KAPI_TYPE_FD: File descriptor - range-checked only
+ * @KAPI_TYPE_USER_PTR: User space pointer - validated for access and size
+ * @KAPI_TYPE_PATH: Pathname - validated for access and path limits
+ * @KAPI_TYPE_CUSTOM: Custom/complex types
+ */
+enum kapi_param_type {
+	KAPI_TYPE_VOID = 0,
+	KAPI_TYPE_INT,
+	KAPI_TYPE_UINT,
+	KAPI_TYPE_PTR,
+	KAPI_TYPE_STRUCT,
+	KAPI_TYPE_UNION,
+	KAPI_TYPE_ENUM,
+	KAPI_TYPE_FUNC_PTR,
+	KAPI_TYPE_ARRAY,
+	KAPI_TYPE_FD,		/* File descriptor - range-checked only */
+	KAPI_TYPE_USER_PTR,	/* User space pointer - validated for access and size */
+	KAPI_TYPE_PATH,		/* Pathname - validated for access and path limits */
+	KAPI_TYPE_CUSTOM,
+};
+
+/**
+ * enum kapi_param_flags - Parameter attribute flags
+ * @KAPI_PARAM_IN: Input parameter
+ * @KAPI_PARAM_OUT: Output parameter
+ * @KAPI_PARAM_INOUT: Input/output parameter
+ * @KAPI_PARAM_OPTIONAL: Optional parameter (can be NULL)
+ * @KAPI_PARAM_CONST: Const qualified parameter
+ * @KAPI_PARAM_VOLATILE: Volatile qualified parameter
+ * @KAPI_PARAM_USER: User space pointer
+ * @KAPI_PARAM_DMA: DMA-capable memory required
+ * @KAPI_PARAM_ALIGNED: Alignment requirements
+ */
+enum kapi_param_flags {
+	KAPI_PARAM_IN		= (1 << 0),
+	KAPI_PARAM_OUT		= (1 << 1),
+	KAPI_PARAM_INOUT	= (KAPI_PARAM_IN | KAPI_PARAM_OUT),
+	KAPI_PARAM_OPTIONAL	= (1 << 3),
+	KAPI_PARAM_CONST	= (1 << 4),
+	KAPI_PARAM_VOLATILE	= (1 << 5),
+	KAPI_PARAM_USER		= (1 << 6),
+	KAPI_PARAM_DMA		= (1 << 7),
+	KAPI_PARAM_ALIGNED	= (1 << 8),
+};
+
+/**
+ * enum kapi_context_flags - Function execution context flags
+ * @KAPI_CTX_PROCESS: Can be called from process context
+ * @KAPI_CTX_SOFTIRQ: Can be called from softirq context
+ * @KAPI_CTX_HARDIRQ: Can be called from hardirq context
+ * @KAPI_CTX_NMI: Can be called from NMI context
+ * @KAPI_CTX_ATOMIC: Must be called in atomic context
+ * @KAPI_CTX_SLEEPABLE: May sleep
+ * @KAPI_CTX_PREEMPT_DISABLED: Requires preemption disabled
+ * @KAPI_CTX_IRQ_DISABLED: Requires interrupts disabled
+ */
+enum kapi_context_flags {
+	KAPI_CTX_PROCESS	= (1 << 0),
+	KAPI_CTX_SOFTIRQ	= (1 << 1),
+	KAPI_CTX_HARDIRQ	= (1 << 2),
+	KAPI_CTX_NMI		= (1 << 3),
+	KAPI_CTX_ATOMIC		= (1 << 4),
+	KAPI_CTX_SLEEPABLE	= (1 << 5),
+	KAPI_CTX_PREEMPT_DISABLED = (1 << 6),
+	KAPI_CTX_IRQ_DISABLED	= (1 << 7),
+};
+
+/**
+ * enum kapi_lock_type - Lock types used/required by the function
+ * @KAPI_LOCK_NONE: No locking requirements
+ * @KAPI_LOCK_MUTEX: Mutex lock
+ * @KAPI_LOCK_SPINLOCK: Spinlock
+ * @KAPI_LOCK_RWLOCK: Read-write lock
+ * @KAPI_LOCK_SEQLOCK: Sequence lock
+ * @KAPI_LOCK_RCU: RCU lock
+ * @KAPI_LOCK_SEMAPHORE: Semaphore
+ * @KAPI_LOCK_CUSTOM: Custom locking mechanism
+ */
+enum kapi_lock_type {
+	KAPI_LOCK_NONE = 0,
+	KAPI_LOCK_MUTEX,
+	KAPI_LOCK_SPINLOCK,
+	KAPI_LOCK_RWLOCK,
+	KAPI_LOCK_SEQLOCK,
+	KAPI_LOCK_RCU,
+	KAPI_LOCK_SEMAPHORE,
+	KAPI_LOCK_CUSTOM,
+};
+
+/**
+ * enum kapi_constraint_type - Types of parameter constraints
+ * @KAPI_CONSTRAINT_NONE: No constraint
+ * @KAPI_CONSTRAINT_RANGE: Numeric range constraint
+ * @KAPI_CONSTRAINT_MASK: Bitmask constraint
+ * @KAPI_CONSTRAINT_ENUM: Enumerated values constraint
+ * @KAPI_CONSTRAINT_ALIGNMENT: Alignment constraint (must be aligned to specified boundary)
+ * @KAPI_CONSTRAINT_POWER_OF_TWO: Value must be a power of two
+ * @KAPI_CONSTRAINT_PAGE_ALIGNED: Value must be page-aligned
+ * @KAPI_CONSTRAINT_NONZERO: Value must be non-zero
+ * @KAPI_CONSTRAINT_USER_STRING: Userspace null-terminated string with length range
+ * @KAPI_CONSTRAINT_USER_PATH: Userspace pathname string (validated for accessibility and PATH_MAX)
+ * @KAPI_CONSTRAINT_USER_PTR: Userspace pointer (validated for accessibility and size)
+ * @KAPI_CONSTRAINT_BUFFER: Userspace buffer pointer (validated by copy_to/from_user)
+ * @KAPI_CONSTRAINT_CUSTOM: Custom validation function
+ */
+enum kapi_constraint_type {
+	KAPI_CONSTRAINT_NONE = 0,
+	KAPI_CONSTRAINT_RANGE,
+	KAPI_CONSTRAINT_MASK,
+	KAPI_CONSTRAINT_ENUM,
+	KAPI_CONSTRAINT_ALIGNMENT,
+	KAPI_CONSTRAINT_POWER_OF_TWO,
+	KAPI_CONSTRAINT_PAGE_ALIGNED,
+	KAPI_CONSTRAINT_NONZERO,
+	KAPI_CONSTRAINT_USER_STRING,
+	KAPI_CONSTRAINT_USER_PATH,
+	KAPI_CONSTRAINT_USER_PTR,
+	KAPI_CONSTRAINT_BUFFER,
+	KAPI_CONSTRAINT_CUSTOM,
+};
+
+/**
+ * struct kapi_param_spec - Parameter specification
+ * @name: Parameter name
+ * @type_name: Type name as string
+ * @type: Parameter type classification
+ * @flags: Parameter attribute flags
+ * @size: Size in bytes (for arrays/buffers)
+ * @alignment: Required alignment
+ * @min_value: Minimum valid value (for numeric types)
+ * @max_value: Maximum valid value (for numeric types)
+ * @valid_mask: Valid bits mask (for flag parameters)
+ * @enum_values: Array of valid enumerated values
+ * @enum_count: Number of valid enumerated values
+ * @constraint_type: Type of constraint applied
+ * @validate: Custom validation function
+ * @description: Human-readable description
+ * @constraints: Additional constraints description
+ * @size_param_idx: 1-based index of the parameter that determines size,
+ *                  or 0 if this parameter has a fixed size
+ * @size_multiplier: Multiplier for size calculation (e.g., sizeof(struct))
+ */
+struct kapi_param_spec {
+	const char *name;
+	const char *type_name;
+	enum kapi_param_type type;
+	u32 flags;
+	size_t size;
+	size_t alignment;
+	s64 min_value;
+	s64 max_value;
+	u64 valid_mask;
+	const s64 *enum_values;
+	u32 enum_count;
+	enum kapi_constraint_type constraint_type;
+	bool (*validate)(s64 value);
+	const char *description;
+	const char *constraints;
+	int size_param_idx;	/* 1-based param index for dynamic size; 0 if N/A */
+	size_t size_multiplier;	/* Size per unit (e.g., sizeof(struct epoll_event)) */
+};
+
+/**
+ * struct kapi_error_spec - Error condition specification
+ * @error_code: Error code value
+ * @name: Error code name (e.g., "EINVAL")
+ * @condition: Condition that triggers this error
+ * @description: Detailed error description
+ */
+struct kapi_error_spec {
+	int error_code;
+	const char *name;
+	const char *condition;
+	const char *description;
+};
+
+/**
+ * enum kapi_return_check_type - Return value check types
+ * @KAPI_RETURN_EXACT: Success is an exact value
+ * @KAPI_RETURN_RANGE: Success is within a range
+ * @KAPI_RETURN_ERROR_CHECK: Success is when NOT in error list
+ * @KAPI_RETURN_FD: Return value is a file descriptor (>= 0 is success)
+ * @KAPI_RETURN_CUSTOM: Custom validation function
+ * @KAPI_RETURN_NO_RETURN: Function does not return (e.g., exec on success)
+ */
+enum kapi_return_check_type {
+	KAPI_RETURN_EXACT,
+	KAPI_RETURN_RANGE,
+	KAPI_RETURN_ERROR_CHECK,
+	KAPI_RETURN_FD,
+	KAPI_RETURN_CUSTOM,
+	KAPI_RETURN_NO_RETURN,
+};
+
+/**
+ * struct kapi_return_spec - Return value specification
+ * @type_name: Return type name
+ * @type: Return type classification
+ * @check_type: Type of success check to perform
+ * @success_value: Exact value indicating success (for EXACT)
+ * @success_min: Minimum success value (for RANGE)
+ * @success_max: Maximum success value (for RANGE)
+ * @error_values: Array of error values (for ERROR_CHECK)
+ * @error_count: Number of error values
+ * @is_success: Custom function to check success
+ * @description: Return value description
+ */
+struct kapi_return_spec {
+	const char *type_name;
+	enum kapi_param_type type;
+	enum kapi_return_check_type check_type;
+	s64 success_value;
+	s64 success_min;
+	s64 success_max;
+	const s64 *error_values;
+	u32 error_count;
+	bool (*is_success)(s64 retval);
+	const char *description;
+};
+
+/**
+ * enum kapi_lock_scope - Lock acquisition/release scope
+ * @KAPI_LOCK_INTERNAL: Lock is acquired and released within the function (common case)
+ * @KAPI_LOCK_ACQUIRES: Function acquires lock but does not release it
+ * @KAPI_LOCK_RELEASES: Function releases lock (must be held on entry)
+ * @KAPI_LOCK_CALLER_HELD: Lock must be held by caller throughout the call
+ */
+enum kapi_lock_scope {
+	KAPI_LOCK_INTERNAL = 0,
+	KAPI_LOCK_ACQUIRES,
+	KAPI_LOCK_RELEASES,
+	KAPI_LOCK_CALLER_HELD,
+};
+
+/**
+ * struct kapi_lock_spec - Lock requirement specification
+ * @lock_name: Name of the lock
+ * @lock_type: Type of lock
+ * @scope: Lock scope (internal, acquires, releases, or caller-held)
+ * @description: Additional lock requirements
+ */
+struct kapi_lock_spec {
+	const char *lock_name;
+	enum kapi_lock_type lock_type;
+	enum kapi_lock_scope scope;
+	const char *description;
+};
+
+/**
+ * struct kapi_constraint_spec - Additional constraint specification
+ * @name: Constraint name
+ * @description: Constraint description
+ * @expression: Formal expression (if applicable)
+ */
+struct kapi_constraint_spec {
+	const char *name;
+	const char *description;
+	const char *expression;
+};
+
+/**
+ * enum kapi_signal_direction - Signal flow direction
+ * @KAPI_SIGNAL_RECEIVE: Function may receive this signal
+ * @KAPI_SIGNAL_SEND: Function may send this signal
+ * @KAPI_SIGNAL_HANDLE: Function handles this signal specially
+ * @KAPI_SIGNAL_BLOCK: Function blocks this signal
+ * @KAPI_SIGNAL_IGNORE: Function ignores this signal
+ */
+enum kapi_signal_direction {
+	KAPI_SIGNAL_RECEIVE	= (1 << 0),
+	KAPI_SIGNAL_SEND	= (1 << 1),
+	KAPI_SIGNAL_HANDLE	= (1 << 2),
+	KAPI_SIGNAL_BLOCK	= (1 << 3),
+	KAPI_SIGNAL_IGNORE	= (1 << 4),
+};
+
+/**
+ * enum kapi_signal_action - What the function does with the signal
+ * @KAPI_SIGNAL_ACTION_DEFAULT: Default signal action applies
+ * @KAPI_SIGNAL_ACTION_TERMINATE: Causes termination
+ * @KAPI_SIGNAL_ACTION_COREDUMP: Causes termination with core dump
+ * @KAPI_SIGNAL_ACTION_STOP: Stops the process
+ * @KAPI_SIGNAL_ACTION_CONTINUE: Continues a stopped process
+ * @KAPI_SIGNAL_ACTION_CUSTOM: Custom handling described in notes
+ * @KAPI_SIGNAL_ACTION_RETURN: Returns from syscall with EINTR
+ * @KAPI_SIGNAL_ACTION_RESTART: Restarts the syscall
+ * @KAPI_SIGNAL_ACTION_QUEUE: Queues the signal for later delivery
+ * @KAPI_SIGNAL_ACTION_DISCARD: Discards the signal
+ * @KAPI_SIGNAL_ACTION_TRANSFORM: Transforms to another signal
+ */
+enum kapi_signal_action {
+	KAPI_SIGNAL_ACTION_DEFAULT = 0,
+	KAPI_SIGNAL_ACTION_TERMINATE,
+	KAPI_SIGNAL_ACTION_COREDUMP,
+	KAPI_SIGNAL_ACTION_STOP,
+	KAPI_SIGNAL_ACTION_CONTINUE,
+	KAPI_SIGNAL_ACTION_CUSTOM,
+	KAPI_SIGNAL_ACTION_RETURN,
+	KAPI_SIGNAL_ACTION_RESTART,
+	KAPI_SIGNAL_ACTION_QUEUE,
+	KAPI_SIGNAL_ACTION_DISCARD,
+	KAPI_SIGNAL_ACTION_TRANSFORM,
+};
+
+/**
+ * struct kapi_signal_spec - Signal specification
+ * @signal_num: Signal number (e.g., SIGKILL, SIGTERM)
+ * @signal_name: Signal name as string
+ * @direction: Direction flags (OR of kapi_signal_direction)
+ * @action: What happens when signal is received
+ * @target: Description of target process/thread for sent signals
+ * @condition: Condition under which signal is sent/received/handled
+ * @description: Detailed description of signal handling
+ * @restartable: Whether syscall is restartable after this signal
+ * @sa_flags_required: Required signal action flags (SA_*)
+ * @sa_flags_forbidden: Forbidden signal action flags
+ * @error_on_signal: Error code returned when signal occurs (-EINTR, etc)
+ * @transform_to: Signal number to transform to (if action is TRANSFORM)
+ * @timing: When signal can occur ("entry", "during", "exit", "anytime")
+ * @priority: Signal handling priority (lower processed first)
+ * @interruptible: Whether this operation is interruptible by this signal
+ * @queue_behavior: How signal is queued ("realtime", "standard", "coalesce")
+ * @state_required: Required process state for signal to be delivered
+ * @state_forbidden: Forbidden process state for signal delivery
+ */
+struct kapi_signal_spec {
+	int signal_num;
+	const char *signal_name;
+	u32 direction;
+	enum kapi_signal_action action;
+	const char *target;
+	const char *condition;
+	const char *description;
+	bool restartable;
+	u32 sa_flags_required;
+	u32 sa_flags_forbidden;
+	int error_on_signal;
+	int transform_to;
+	const char *timing;
+	u8 priority;
+	bool interruptible;
+	const char *queue_behavior;
+	u32 state_required;
+	u32 state_forbidden;
+};
+
+/**
+ * struct kapi_signal_mask_spec - Signal mask specification
+ * @mask_name: Name of the signal mask
+ * @signals: Array of signal numbers in the mask
+ * @signal_count: Number of signals in the mask
+ * @description: Description of what this mask represents
+ */
+struct kapi_signal_mask_spec {
+	const char *mask_name;
+	int signals[KAPI_MAX_SIGNALS];
+	u32 signal_count;
+	const char *description;
+};
+
+/**
+ * struct kapi_struct_field - Structure field specification
+ * @name: Field name
+ * @type: Field type classification
+ * @type_name: Type name as string
+ * @offset: Offset within structure
+ * @size: Size of field in bytes
+ * @flags: Field attribute flags
+ * @constraint_type: Type of constraint applied
+ * @min_value: Minimum valid value (for numeric types)
+ * @max_value: Maximum valid value (for numeric types)
+ * @valid_mask: Valid bits mask (for flag fields)
+ * @enum_values: Comma-separated list of valid enum values (for enum types)
+ * @description: Field description
+ */
+struct kapi_struct_field {
+	const char *name;
+	enum kapi_param_type type;
+	const char *type_name;
+	size_t offset;
+	size_t size;
+	u32 flags;
+	enum kapi_constraint_type constraint_type;
+	s64 min_value;
+	s64 max_value;
+	u64 valid_mask;
+	const char *enum_values;	/* Comma-separated list of valid enum values */
+	const char *description;
+};
+
+/**
+ * struct kapi_struct_spec - Structure type specification
+ * @name: Structure name
+ * @size: Total size of structure
+ * @alignment: Required alignment
+ * @field_count: Number of fields
+ * @fields: Field specifications
+ * @description: Structure description
+ */
+struct kapi_struct_spec {
+	const char *name;
+	size_t size;
+	size_t alignment;
+	u32 field_count;
+	struct kapi_struct_field fields[KAPI_MAX_PARAMS];
+	const char *description;
+};
+
+/**
+ * enum kapi_capability_action - What the capability allows
+ * @KAPI_CAP_BYPASS_CHECK: Bypasses a check entirely
+ * @KAPI_CAP_INCREASE_LIMIT: Increases or removes a limit
+ * @KAPI_CAP_OVERRIDE_RESTRICTION: Overrides a restriction
+ * @KAPI_CAP_GRANT_PERMISSION: Grants permission that would otherwise be denied
+ * @KAPI_CAP_MODIFY_BEHAVIOR: Changes the behavior of the operation
+ * @KAPI_CAP_ACCESS_RESOURCE: Allows access to restricted resources
+ * @KAPI_CAP_PERFORM_OPERATION: Allows performing a privileged operation
+ */
+enum kapi_capability_action {
+	KAPI_CAP_BYPASS_CHECK = 0,
+	KAPI_CAP_INCREASE_LIMIT,
+	KAPI_CAP_OVERRIDE_RESTRICTION,
+	KAPI_CAP_GRANT_PERMISSION,
+	KAPI_CAP_MODIFY_BEHAVIOR,
+	KAPI_CAP_ACCESS_RESOURCE,
+	KAPI_CAP_PERFORM_OPERATION,
+};
+
+/**
+ * struct kapi_capability_spec - Capability requirement specification
+ * @capability: The capability constant (e.g., CAP_IPC_LOCK)
+ * @cap_name: Capability name as string
+ * @action: What the capability allows (kapi_capability_action)
+ * @allows: Description of what the capability allows
+ * @without_cap: What happens without the capability
+ * @check_condition: Condition when capability is checked
+ * @priority: Check priority (lower checked first)
+ * @alternative: Alternative capabilities that can be used
+ * @alternative_count: Number of alternative capabilities
+ */
+struct kapi_capability_spec {
+	int capability;
+	const char *cap_name;
+	enum kapi_capability_action action;
+	const char *allows;
+	const char *without_cap;
+	const char *check_condition;
+	u8 priority;
+	int alternative[KAPI_MAX_CAPABILITIES];
+	u32 alternative_count;
+};
+
+/**
+ * enum kapi_side_effect_type - Types of side effects
+ * @KAPI_EFFECT_NONE: No side effects
+ * @KAPI_EFFECT_ALLOC_MEMORY: Allocates memory
+ * @KAPI_EFFECT_FREE_MEMORY: Frees memory
+ * @KAPI_EFFECT_MODIFY_STATE: Modifies global/shared state
+ * @KAPI_EFFECT_SIGNAL_SEND: Sends signals
+ * @KAPI_EFFECT_FILE_POSITION: Modifies file position
+ * @KAPI_EFFECT_LOCK_ACQUIRE: Acquires locks
+ * @KAPI_EFFECT_LOCK_RELEASE: Releases locks
+ * @KAPI_EFFECT_RESOURCE_CREATE: Creates system resources (FDs, PIDs, etc)
+ * @KAPI_EFFECT_RESOURCE_DESTROY: Destroys system resources
+ * @KAPI_EFFECT_SCHEDULE: May cause scheduling/context switch
+ * @KAPI_EFFECT_HARDWARE: Interacts with hardware
+ * @KAPI_EFFECT_NETWORK: Network I/O operation
+ * @KAPI_EFFECT_FILESYSTEM: Filesystem modification
+ * @KAPI_EFFECT_PROCESS_STATE: Modifies process state
+ * @KAPI_EFFECT_IRREVERSIBLE: Effect cannot be undone
+ */
+enum kapi_side_effect_type {
+	KAPI_EFFECT_NONE = 0,
+	KAPI_EFFECT_ALLOC_MEMORY = (1 << 0),
+	KAPI_EFFECT_FREE_MEMORY = (1 << 1),
+	KAPI_EFFECT_MODIFY_STATE = (1 << 2),
+	KAPI_EFFECT_SIGNAL_SEND = (1 << 3),
+	KAPI_EFFECT_FILE_POSITION = (1 << 4),
+	KAPI_EFFECT_LOCK_ACQUIRE = (1 << 5),
+	KAPI_EFFECT_LOCK_RELEASE = (1 << 6),
+	KAPI_EFFECT_RESOURCE_CREATE = (1 << 7),
+	KAPI_EFFECT_RESOURCE_DESTROY = (1 << 8),
+	KAPI_EFFECT_SCHEDULE = (1 << 9),
+	KAPI_EFFECT_HARDWARE = (1 << 10),
+	KAPI_EFFECT_NETWORK = (1 << 11),
+	KAPI_EFFECT_FILESYSTEM = (1 << 12),
+	KAPI_EFFECT_PROCESS_STATE = (1 << 13),
+	KAPI_EFFECT_IRREVERSIBLE = (1 << 14),
+};
+
+/**
+ * struct kapi_side_effect - Side effect specification
+ * @type: Bitmask of effect types
+ * @target: What is affected (e.g., "process memory", "file descriptor table")
+ * @condition: Condition under which effect occurs
+ * @description: Detailed description of the effect
+ * @reversible: Whether the effect can be undone
+ */
+struct kapi_side_effect {
+	u32 type;
+	const char *target;
+	const char *condition;
+	const char *description;
+	bool reversible;
+};
+
+/**
+ * struct kapi_state_transition - State transition specification
+ * @from_state: Starting state description
+ * @to_state: Ending state description
+ * @condition: Condition for transition
+ * @object: Object whose state changes
+ * @description: Detailed description
+ */
+struct kapi_state_transition {
+	const char *from_state;
+	const char *to_state;
+	const char *condition;
+	const char *object;
+	const char *description;
+};
+
+#define KAPI_MAX_STRUCT_SPECS	8
+#define KAPI_MAX_SIDE_EFFECTS	32
+#define KAPI_MAX_STATE_TRANS	8
+
+/**
+ * struct kernel_api_spec - Complete kernel API specification
+ * @name: Function name
+ * @version: API version
+ * @description: Brief description
+ * @long_description: Detailed description
+ * @context_flags: Execution context flags
+ * @param_count: Number of parameters
+ * @params: Parameter specifications
+ * @return_spec: Return value specification
+ * @error_count: Number of possible errors
+ * @errors: Error specifications
+ * @lock_count: Number of lock specifications
+ * @locks: Lock requirement specifications
+ * @constraint_count: Number of additional constraints
+ * @constraints: Additional constraint specifications
+ * @examples: Usage examples
+ * @notes: Additional notes
+ * @signal_count: Number of signal specifications
+ * @signals: Signal handling specifications
+ * @signal_mask_count: Number of signal mask specifications
+ * @signal_masks: Signal mask specifications
+ * @struct_spec_count: Number of structure specifications
+ * @struct_specs: Structure type specifications
+ * @side_effect_count: Number of side effect specifications
+ * @side_effects: Side effect specifications
+ * @state_trans_count: Number of state transition specifications
+ * @state_transitions: State transition specifications
+ * @capability_count: Number of required capabilities
+ * @capabilities: Required capability specifications
+ * @param_magic: Magic value marking the start of the params array
+ * @return_magic: Magic value marking the return spec
+ * @error_magic: Magic value marking the start of the errors array
+ * @lock_magic: Magic value marking the start of the locks array
+ * @constraint_magic: Magic value marking the constraints array
+ * @info_magic: Magic value marking the info block (examples, notes)
+ * @signal_magic: Magic value marking the start of the signals array
+ * @sigmask_magic: Magic value marking the signal masks array
+ * @struct_magic: Magic value marking the struct specs array
+ * @effect_magic: Magic value marking the side effects array
+ * @trans_magic: Magic value marking the state transitions array
+ * @cap_magic: Magic value marking the capabilities array
+ */
+struct kernel_api_spec {
+	const char *name;
+	u32 version;
+	const char *description;
+	const char *long_description;
+	u32 context_flags;
+
+	/* Parameters */
+	u32 param_magic;  /* 0x4B415031 = 'KAP1' */
+	u32 param_count;
+	struct kapi_param_spec params[KAPI_MAX_PARAMS];
+
+	/* Return value */
+	u32 return_magic; /* 0x4B415232 = 'KAR2' */
+	struct kapi_return_spec return_spec;
+
+	/* Errors */
+	u32 error_magic;  /* 0x4B414533 = 'KAE3' */
+	u32 error_count;
+	struct kapi_error_spec errors[KAPI_MAX_ERRORS];
+
+	/* Locking */
+	u32 lock_magic;   /* 0x4B414C34 = 'KAL4' */
+	u32 lock_count;
+	struct kapi_lock_spec locks[KAPI_MAX_LOCKS];
+
+	/* Constraints */
+	u32 constraint_magic; /* 0x4B414335 = 'KAC5' */
+	u32 constraint_count;
+	struct kapi_constraint_spec constraints[KAPI_MAX_CONSTRAINTS];
+
+	/* Additional information */
+	u32 info_magic;   /* 0x4B414936 = 'KAI6' */
+	const char *examples;
+	const char *notes;
+
+	/* Signal specifications */
+	u32 signal_magic; /* 0x4B415337 = 'KAS7' */
+	u32 signal_count;
+	struct kapi_signal_spec signals[KAPI_MAX_SIGNALS];
+
+	/* Signal mask specifications */
+	u32 sigmask_magic; /* 0x4B414D38 = 'KAM8' */
+	u32 signal_mask_count;
+	struct kapi_signal_mask_spec signal_masks[KAPI_MAX_SIGNALS];
+
+	/* Structure specifications */
+	u32 struct_magic; /* 0x4B415439 = 'KAT9' */
+	u32 struct_spec_count;
+	struct kapi_struct_spec struct_specs[KAPI_MAX_STRUCT_SPECS];
+
+	/* Side effects */
+	u32 effect_magic; /* 0x4B414641 = 'KAFA' */
+	u32 side_effect_count;
+	struct kapi_side_effect side_effects[KAPI_MAX_SIDE_EFFECTS];
+
+	/* State transitions */
+	u32 trans_magic;  /* 0x4B415442 = 'KATB' */
+	u32 state_trans_count;
+	struct kapi_state_transition state_transitions[KAPI_MAX_STATE_TRANS];
+
+	/* Capability specifications */
+	u32 cap_magic;    /* 0x4B414343 = 'KACC' */
+	u32 capability_count;
+	struct kapi_capability_spec capabilities[KAPI_MAX_CAPABILITIES];
+};
+
+/* Macros for defining API specifications */
+
+/**
+ * DEFINE_KERNEL_API_SPEC - Define a kernel API specification
+ * @func_name: Function name to specify
+ *
+ * The ``.kapi_specs`` section holds an array of pointers to
+ * fully-defined ``kernel_api_spec`` instances, tightly packed so
+ * iteration ``for (pp = __start_kapi_specs; pp < __stop_kapi_specs;
+ * pp++)`` advances by one pointer each step regardless of the real
+ * spec struct size.
+ */
+#define DEFINE_KERNEL_API_SPEC(func_name)					\
+	extern const struct kernel_api_spec __kapi_spec_##func_name;		\
+	static const struct kernel_api_spec * const				\
+	__kapi_spec_ptr_##func_name __used __section(".kapi_specs") =		\
+		&__kapi_spec_##func_name;					\
+	const struct kernel_api_spec __kapi_spec_##func_name = {		\
+		.name = __stringify(func_name),					\
+		.version = 1,
+
+/**
+ * KAPI_DESCRIPTION - Set API description
+ * @desc: Description string
+ */
+#define KAPI_DESCRIPTION(desc) \
+	.description = desc,
+
+/**
+ * KAPI_LONG_DESC - Set detailed API description
+ * @desc: Detailed description string
+ */
+#define KAPI_LONG_DESC(desc) \
+	.long_description = desc,
+
+/**
+ * KAPI_CONTEXT - Set execution context flags
+ * @flags: Context flags (OR'ed KAPI_CTX_* values)
+ */
+#define KAPI_CONTEXT(flags) \
+	.context_flags = flags,
+
+/**
+ * KAPI_PARAM - Define a parameter specification
+ * @idx: Parameter index (0-based)
+ * @pname: Parameter name
+ * @ptype: Type name string
+ * @pdesc: Parameter description
+ */
+#define KAPI_PARAM(idx, pname, ptype, pdesc) \
+	.params[idx] = {			\
+		.name = pname,			\
+		.type_name = ptype,		\
+		.description = pdesc,
+
+#define KAPI_PARAM_TYPE(ptype) \
+		.type = ptype,
+
+#define KAPI_PARAM_FLAGS(pflags) \
+		.flags = pflags,
+
+#define KAPI_PARAM_SIZE(psize) \
+		.size = psize,
+
+#define KAPI_PARAM_RANGE(pmin, pmax) \
+		.min_value = pmin,	\
+		.max_value = pmax,
+
+#define KAPI_PARAM_CONSTRAINT_TYPE(ctype) \
+		.constraint_type = ctype,
+
+#define KAPI_PARAM_CONSTRAINT(desc) \
+		.constraints = desc,
+
+#define KAPI_PARAM_VALID_MASK(mask) \
+		.valid_mask = mask,
+
+/**
+ * KAPI_PARAM_ENUM_VALUES - Set the valid values of an enumerated parameter
+ * @...: Variadic list of valid values
+ */
+#define KAPI_PARAM_ENUM_VALUES(...) \
+		.enum_values = (const s64[]){ __VA_ARGS__ }, \
+		.enum_count = sizeof((const s64[]){ __VA_ARGS__ }) / sizeof(s64),
+
+#define KAPI_PARAM_ALIGNMENT(align) \
+		.alignment = align,
+
+/*
+ * Store the 1-based parameter index so the zero-initialised default
+ * (no dynamic sizing) remains distinguishable from "uses param 0".
+ */
+#define KAPI_PARAM_SIZE_PARAM(idx) \
+		.size_param_idx = (idx) + 1,
+
+/**
+ * KAPI_PARAM_COUNT - Set the number of parameters
+ * @n: Number of parameters
+ */
+#define KAPI_PARAM_COUNT(n) \
+	.param_magic = KAPI_MAGIC_PARAMS, \
+	.param_count = n,
+
+/**
+ * KAPI_RETURN - Define return value specification
+ * @rtype: Return type name
+ * @rdesc: Return value description
+ */
+#define KAPI_RETURN(rtype, rdesc) \
+	.return_magic = KAPI_MAGIC_RETURN, \
+	.return_spec = {		\
+		.type_name = rtype,	\
+		.description = rdesc,
+
+#define KAPI_RETURN_SUCCESS(val, ...) \
+		.success_value = val,
+
+#define KAPI_RETURN_TYPE(rtype) \
+		.type = rtype,
+
+#define KAPI_RETURN_CHECK_TYPE(ctype) \
+		.check_type = ctype,
+
+#define KAPI_RETURN_ERROR_VALUES(values) \
+		.error_values = values,
+
+#define KAPI_RETURN_ERROR_COUNT(count) \
+		.error_count = count,
+
+#define KAPI_RETURN_SUCCESS_RANGE(min, max) \
+		.success_min = min, \
+		.success_max = max,
+
+/**
+ * KAPI_ERROR - Define an error condition
+ * @idx: Error index
+ * @ecode: Error code value
+ * @ename: Error name
+ * @econd: Error condition
+ * @edesc: Error description
+ */
+#define KAPI_ERROR(idx, ecode, ename, econd, edesc) \
+	.errors[idx] = {			\
+		.error_code = ecode,		\
+		.name = ename,			\
+		.condition = econd,		\
+		.description = edesc,		\
+	},
+
+/**
+ * KAPI_ERROR_COUNT - Set the number of errors
+ * @n: Number of errors
+ */
+#define KAPI_ERROR_COUNT(n) \
+	.error_magic = KAPI_MAGIC_ERRORS, \
+	.error_count = n,
+
+/**
+ * KAPI_LOCK - Define a lock requirement
+ * @idx: Lock index
+ * @lname: Lock name
+ * @ltype: Lock type
+ */
+#define KAPI_LOCK(idx, lname, ltype) \
+	.locks[idx] = {			\
+		.lock_name = lname,	\
+		.lock_type = ltype,
+
+#define KAPI_LOCK_ACQUIRED \
+		.scope = KAPI_LOCK_ACQUIRES,
+
+#define KAPI_LOCK_RELEASED \
+		.scope = KAPI_LOCK_RELEASES,
+
+#define KAPI_LOCK_HELD_ENTRY \
+		.scope = KAPI_LOCK_CALLER_HELD,
+
+#define KAPI_LOCK_HELD_EXIT \
+		.scope = KAPI_LOCK_CALLER_HELD,
+
+#define KAPI_LOCK_DESC(ldesc) \
+		.description = ldesc,
+
+/**
+ * KAPI_CONSTRAINT - Define an additional constraint
+ * @idx: Constraint index
+ * @cname: Constraint name
+ * @cdesc: Constraint description
+ */
+#define KAPI_CONSTRAINT(idx, cname, cdesc) \
+	.constraints[idx] = {		\
+		.name = cname,		\
+		.description = cdesc,
+
+#define KAPI_CONSTRAINT_EXPR(expr) \
+		.expression = expr,
+
+/**
+ * KAPI_EXAMPLES - Set API usage examples
+ * @ex: Examples string
+ */
+#define KAPI_EXAMPLES(ex) \
+	.info_magic = KAPI_MAGIC_INFO, \
+	.examples = ex,
+
+/**
+ * KAPI_NOTES - Set API notes
+ * @n: Notes string
+ */
+#define KAPI_NOTES(n) \
+	.notes = n,
+
+
+/**
+ * KAPI_SIGNAL - Define a signal specification
+ * @idx: Signal index
+ * @signum: Signal number (e.g., SIGKILL)
+ * @signame: Signal name string
+ * @dir: Direction flags
+ * @act: Action taken
+ */
+#define KAPI_SIGNAL(idx, signum, signame, dir, act) \
+	.signals[idx] = {			\
+		.signal_num = signum,		\
+		.signal_name = signame,		\
+		.direction = dir,		\
+		.action = act,
+
+#define KAPI_SIGNAL_TARGET(tgt) \
+		.target = tgt,
+
+#define KAPI_SIGNAL_CONDITION(cond) \
+		.condition = cond,
+
+#define KAPI_SIGNAL_DESC(desc) \
+		.description = desc,
+
+#define KAPI_SIGNAL_RESTARTABLE \
+		.restartable = true,
+
+#define KAPI_SIGNAL_SA_FLAGS_REQ(flags) \
+		.sa_flags_required = flags,
+
+#define KAPI_SIGNAL_SA_FLAGS_FORBID(flags) \
+		.sa_flags_forbidden = flags,
+
+#define KAPI_SIGNAL_ERROR(err) \
+		.error_on_signal = err,
+
+#define KAPI_SIGNAL_TRANSFORM(sig) \
+		.transform_to = sig,
+
+#define KAPI_SIGNAL_TIMING(when) \
+		.timing = when,
+
+#define KAPI_SIGNAL_PRIORITY(prio) \
+		.priority = prio,
+
+#define KAPI_SIGNAL_INTERRUPTIBLE \
+		.interruptible = true,
+
+#define KAPI_SIGNAL_QUEUE(behavior) \
+		.queue_behavior = behavior,
+
+#define KAPI_SIGNAL_STATE_REQ(state) \
+		.state_required = state,
+
+#define KAPI_SIGNAL_STATE_FORBID(state) \
+		.state_forbidden = state,
+
+#define KAPI_SIGNAL_COUNT(n) \
+	.signal_magic = KAPI_MAGIC_SIGNALS, \
+	.signal_count = n,
+
+/**
+ * KAPI_SIGNAL_MASK - Define a signal mask specification
+ * @idx: Mask index
+ * @name: Mask name
+ * @desc: Mask description
+ */
+#define KAPI_SIGNAL_MASK(idx, name, desc) \
+	.signal_masks[idx] = {		\
+		.mask_name = name,	\
+		.description = desc,
+
+/*
+ * KAPI_SIGNAL_MASK_SIGNALS - Specify signals in a signal mask
+ * @...: Variadic list of signal numbers
+ *
+ * Usage:
+ *   KAPI_SIGNAL_MASK(0, "blocked", "Signals blocked during operation")
+ *   KAPI_SIGNAL_MASK_SIGNALS(SIGINT, SIGTERM, SIGQUIT)
+ *   },
+ */
+#define KAPI_SIGNAL_MASK_SIGNALS(...) \
+		.signals = { __VA_ARGS__ }, \
+		.signal_count = sizeof((int[]){ __VA_ARGS__ }) / sizeof(int),
+
+/**
+ * KAPI_SIGNAL_MASK_COUNT - Set the number of signal mask specifications
+ * @n: Number of signal masks
+ */
+#define KAPI_SIGNAL_MASK_COUNT(n) \
+	.sigmask_magic = KAPI_MAGIC_SIGMASK, \
+	.signal_mask_count = n,
+
+/**
+ * KAPI_STRUCT_SPEC - Define a structure specification
+ * @idx: Structure spec index
+ * @sname: Structure name
+ * @sdesc: Structure description
+ */
+#define KAPI_STRUCT_SPEC(idx, sname, sdesc) \
+	.struct_specs[idx] = {		\
+		.name = #sname,		\
+		.description = sdesc,
+
+#define KAPI_STRUCT_SIZE(ssize, salign) \
+		.size = ssize,		\
+		.alignment = salign,
+
+#define KAPI_STRUCT_FIELD_COUNT(n) \
+		.field_count = n,
+
+/**
+ * KAPI_STRUCT_FIELD - Define a structure field
+ * @fidx: Field index
+ * @fname: Field name
+ * @ftype: Field type (KAPI_TYPE_*)
+ * @ftype_name: Type name as string
+ * @fdesc: Field description
+ */
+#define KAPI_STRUCT_FIELD(fidx, fname, ftype, ftype_name, fdesc) \
+		.fields[fidx] = {	\
+			.name = fname,	\
+			.type = ftype,	\
+			.type_name = ftype_name, \
+			.description = fdesc,
+
+#define KAPI_FIELD_OFFSET(foffset) \
+			.offset = foffset,
+
+#define KAPI_FIELD_SIZE(fsize) \
+			.size = fsize,
+
+#define KAPI_FIELD_FLAGS(fflags) \
+			.flags = fflags,
+
+#define KAPI_FIELD_CONSTRAINT_RANGE(min, max) \
+			.constraint_type = KAPI_CONSTRAINT_RANGE, \
+			.min_value = min, \
+			.max_value = max,
+
+#define KAPI_FIELD_CONSTRAINT_MASK(mask) \
+			.constraint_type = KAPI_CONSTRAINT_MASK, \
+			.valid_mask = mask,
+
+#define KAPI_FIELD_CONSTRAINT_ENUM(values) \
+			.constraint_type = KAPI_CONSTRAINT_ENUM, \
+			.enum_values = values,
+
+/* Counter for structure specifications */
+#define KAPI_STRUCT_SPEC_COUNT(n) \
+	.struct_magic = KAPI_MAGIC_STRUCTS, \
+	.struct_spec_count = n,
+
+/* Additional lock-related macros */
+#define KAPI_LOCK_COUNT(n) \
+	.lock_magic = KAPI_MAGIC_LOCKS, \
+	.lock_count = n,
+
+/**
+ * KAPI_SIDE_EFFECT - Define a side effect
+ * @idx: Side effect index
+ * @etype: Effect type bitmask (OR'ed KAPI_EFFECT_* values)
+ * @etarget: What is affected
+ * @edesc: Effect description
+ */
+#define KAPI_SIDE_EFFECT(idx, etype, etarget, edesc) \
+	.side_effects[idx] = {		\
+		.type = etype,		\
+		.target = etarget,	\
+		.description = edesc,
+
+#define KAPI_EFFECT_CONDITION(cond) \
+		.condition = cond,
+
+#define KAPI_EFFECT_REVERSIBLE \
+		.reversible = true,
+
+/**
+ * KAPI_STATE_TRANS - Define a state transition
+ * @idx: State transition index
+ * @obj: Object whose state changes
+ * @from: From state
+ * @to: To state
+ * @desc: Transition description
+ */
+#define KAPI_STATE_TRANS(idx, obj, from, to, desc) \
+	.state_transitions[idx] = {	\
+		.object = obj,		\
+		.from_state = from,	\
+		.to_state = to,		\
+		.description = desc,
+
+#define KAPI_STATE_TRANS_COND(cond) \
+		.condition = cond,
+
+/* Counters for side effects and state transitions */
+#define KAPI_SIDE_EFFECT_COUNT(n) \
+	.effect_magic = KAPI_MAGIC_EFFECTS, \
+	.side_effect_count = n,
+
+#define KAPI_STATE_TRANS_COUNT(n) \
+	.trans_magic = KAPI_MAGIC_TRANS, \
+	.state_trans_count = n,
+
+/* Helper macros for common side effect patterns */
+#define KAPI_EFFECTS_MEMORY	(KAPI_EFFECT_ALLOC_MEMORY | KAPI_EFFECT_FREE_MEMORY)
+#define KAPI_EFFECTS_LOCKING	(KAPI_EFFECT_LOCK_ACQUIRE | KAPI_EFFECT_LOCK_RELEASE)
+#define KAPI_EFFECTS_RESOURCES	(KAPI_EFFECT_RESOURCE_CREATE | KAPI_EFFECT_RESOURCE_DESTROY)
+#define KAPI_EFFECTS_IO		(KAPI_EFFECT_NETWORK | KAPI_EFFECT_FILESYSTEM)
+
+/* Common signal timing constants */
+#define KAPI_SIGNAL_TIME_ENTRY		"entry"
+#define KAPI_SIGNAL_TIME_DURING		"during"
+#define KAPI_SIGNAL_TIME_EXIT		"exit"
+#define KAPI_SIGNAL_TIME_ANYTIME	"anytime"
+#define KAPI_SIGNAL_TIME_BLOCKING	"while_blocked"
+#define KAPI_SIGNAL_TIME_SLEEPING	"while_sleeping"
+#define KAPI_SIGNAL_TIME_BEFORE		"before"
+#define KAPI_SIGNAL_TIME_AFTER		"after"
+
+/* Common signal queue behaviors */
+#define KAPI_SIGNAL_QUEUE_STANDARD	"standard"
+#define KAPI_SIGNAL_QUEUE_REALTIME	"realtime"
+#define KAPI_SIGNAL_QUEUE_COALESCE	"coalesce"
+#define KAPI_SIGNAL_QUEUE_REPLACE	"replace"
+#define KAPI_SIGNAL_QUEUE_DISCARD	"discard"
+
+/* Process state flags for signal delivery */
+#define KAPI_SIGNAL_STATE_RUNNING	BIT(0)
+#define KAPI_SIGNAL_STATE_SLEEPING	BIT(1)
+#define KAPI_SIGNAL_STATE_STOPPED	BIT(2)
+#define KAPI_SIGNAL_STATE_TRACED	BIT(3)
+#define KAPI_SIGNAL_STATE_ZOMBIE	BIT(4)
+#define KAPI_SIGNAL_STATE_DEAD		BIT(5)
+
+/* Capability specification macros */
+
+/**
+ * KAPI_CAPABILITY - Define a capability requirement
+ * @idx: Capability index
+ * @cap: Capability constant (e.g., CAP_IPC_LOCK)
+ * @name: Capability name string
+ * @act: Action type (kapi_capability_action)
+ */
+#define KAPI_CAPABILITY(idx, cap, name, act) \
+	.capabilities[idx] = {		\
+		.capability = cap,	\
+		.cap_name = name,	\
+		.action = act,
+
+#define KAPI_CAP_ALLOWS(desc) \
+		.allows = desc,
+
+#define KAPI_CAP_WITHOUT(desc) \
+		.without_cap = desc,
+
+#define KAPI_CAP_CONDITION(cond) \
+		.check_condition = cond,
+
+#define KAPI_CAP_PRIORITY(prio) \
+		.priority = prio,
+
+/*
+ * KAPI_CAP_ALTERNATIVE - Capabilities that can be used instead
+ * @...: Variadic list of capability numbers
+ */
+#define KAPI_CAP_ALTERNATIVE(...) \
+		.alternative = { __VA_ARGS__ }, \
+		.alternative_count = sizeof((int[]){ __VA_ARGS__ }) / sizeof(int),
+
+/* Counter for capability specifications */
+#define KAPI_CAPABILITY_COUNT(n) \
+	.cap_magic = KAPI_MAGIC_CAPS, \
+	.capability_count = n,
+
+/* Validation and runtime checking */
+
+#ifdef CONFIG_KAPI_RUNTIME_CHECKS
+bool kapi_validate_param(const struct kapi_param_spec *param_spec, s64 value);
+bool kapi_validate_param_with_context(const struct kapi_param_spec *param_spec,
+				       s64 value, const s64 *all_params, int param_count);
+bool kapi_check_return_success(const struct kapi_return_spec *return_spec, s64 retval);
+bool kapi_validate_return_value(const struct kernel_api_spec *spec, s64 retval);
+void kapi_check_context(const struct kernel_api_spec *spec);
+#else
+static inline bool kapi_validate_param(const struct kapi_param_spec *param_spec, s64 value)
+{
+	return true;
+}
+static inline bool
+kapi_validate_param_with_context(const struct kapi_param_spec *param_spec,
+				 s64 value, const s64 *all_params, int param_count)
+{
+	return true;
+}
+static inline bool kapi_check_return_success(const struct kapi_return_spec *return_spec, s64 retval)
+{
+	return true;
+}
+static inline bool kapi_validate_return_value(const struct kernel_api_spec *spec, s64 retval)
+{
+	return true;
+}
+static inline void kapi_check_context(const struct kernel_api_spec *spec) {}
+#endif
+
+/* Export/query functions */
+int kapi_export_json(const struct kernel_api_spec *spec, char *buf, size_t size);
+
+/* Registration for dynamic APIs */
+int kapi_register_spec(const struct kernel_api_spec *spec);
+void kapi_unregister_spec(const char *name);
+
+#define KAPI_CONSTRAINT_COUNT(n) \
+	.constraint_magic = KAPI_MAGIC_CONSTRAINTS, \
+	.constraint_count = n,
+
+#endif /* _LINUX_KERNEL_API_SPEC_H */
diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
index 8413b624ad478..b062bac9ea1ed 100644
--- a/include/linux/syscalls.h
+++ b/include/linux/syscalls.h
@@ -94,6 +94,10 @@ struct file_attr;
 #include <linux/personality.h>
 #include <trace/syscall.h>
 
+#ifdef CONFIG_KAPI_RUNTIME_CHECKS
+#include <linux/kapi_syscall.h>
+#endif
+
 #ifdef CONFIG_ARCH_HAS_SYSCALL_WRAPPER
 /*
  * It may be useful for an architecture to override the definitions of the
@@ -237,6 +241,41 @@ static inline int is_syscall_trace_event(struct trace_event_call *tp_event)
 
 #define __PROTECT(...) asmlinkage_protect(__VA_ARGS__)
 
+#ifdef CONFIG_KAPI_RUNTIME_CHECKS
+/*
+ * Convert integers as (s64)(a) does, and pointers through unsigned long so
+ * they are not sign-extended on 32-bit. (unsigned long)(t)0 is an integer
+ * constant expression only if t is an integer type.
+ */
+#define __SC_CAST_TO_S64(t, a)						\
+	((__force s64)__builtin_choose_expr(				\
+		__is_constexpr((__force unsigned long)(t)0),		\
+		(a), (__force unsigned long)(a)))
+
+#define __KAPI_DO_SYS(name)	__do_kapi_sys##name
+#define __KAPI_SYSCALL_DEFINEx(x, name, ...)				\
+	static inline long __do_kapi_sys##name(__MAP(x, __SC_DECL, __VA_ARGS__)) \
+	{								\
+		const struct kernel_api_spec *__spec = kapi_get_spec("sys" #name); \
+		long ret;						\
+									\
+		if (__spec) {						\
+			s64 __params[x] = { __MAP(x, __SC_CAST_TO_S64, __VA_ARGS__) }; \
+			int __ret = kapi_validate_syscall_params(__spec, __params, x); \
+									\
+			if (__ret)					\
+				return __ret;				\
+		}							\
+		ret = __do_sys##name(__MAP(x, __SC_ARGS, __VA_ARGS__));	\
+		if (__spec)						\
+			kapi_validate_syscall_return(__spec, (s64)ret);	\
+		return ret;						\
+	}
+#else
+#define __KAPI_DO_SYS(name)	__do_sys##name
+#define __KAPI_SYSCALL_DEFINEx(x, name, ...)
+#endif
+
 /*
  * The asmlinkage stub is aliased to a function named __se_sys_*() which
  * sign-extends 32-bit ints to longs whenever needed. The actual work is
@@ -255,10 +294,11 @@ static inline int is_syscall_trace_event(struct trace_event_call *tp_event)
 		__attribute__((alias(__stringify(__se_sys##name))));	\
 	ALLOW_ERROR_INJECTION(sys##name, ERRNO);			\
 	static inline long __do_sys##name(__MAP(x,__SC_DECL,__VA_ARGS__));\
+	__KAPI_SYSCALL_DEFINEx(x, name, __VA_ARGS__)			\
 	asmlinkage long __se_sys##name(__MAP(x,__SC_LONG,__VA_ARGS__));	\
 	asmlinkage long __se_sys##name(__MAP(x,__SC_LONG,__VA_ARGS__))	\
 	{								\
-		long ret = __do_sys##name(__MAP(x,__SC_CAST,__VA_ARGS__));\
+		long ret = __KAPI_DO_SYS(name)(__MAP(x,__SC_CAST,__VA_ARGS__));\
 		__MAP(x,__SC_TEST,__VA_ARGS__);				\
 		__PROTECT(x, ret,__MAP(x,__SC_ARGS,__VA_ARGS__));	\
 		return ret;						\
diff --git a/init/Kconfig b/init/Kconfig
index ad592fdf29af4..66c23c4147498 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -2306,6 +2306,8 @@ source "kernel/Kconfig.kexec"
 
 source "kernel/liveupdate/Kconfig"
 
+source "kernel/api/Kconfig"
+
 endmenu		# General setup
 
 source "arch/Kconfig"
diff --git a/kernel/Makefile b/kernel/Makefile
index 1e1a31673577d..7fd43127d5eee 100644
--- a/kernel/Makefile
+++ b/kernel/Makefile
@@ -59,6 +59,7 @@ obj-y += dma/
 obj-y += entry/
 obj-y += unwind/
 obj-$(CONFIG_MODULES) += module/
+obj-$(CONFIG_KAPI_SPEC) += api/
 
 obj-$(CONFIG_KCMP) += kcmp.o
 obj-$(CONFIG_FREEZER) += freezer.o
diff --git a/kernel/api/Kconfig b/kernel/api/Kconfig
new file mode 100644
index 0000000000000..1cd55b252f0d5
--- /dev/null
+++ b/kernel/api/Kconfig
@@ -0,0 +1,54 @@
+# SPDX-License-Identifier: GPL-2.0-only
+#
+# Kernel API Specification Framework Configuration
+#
+
+config KAPI_SPEC
+	bool "Kernel API Specification Framework"
+	help
+	  This option enables the kernel API specification framework,
+	  which provides formal documentation of kernel APIs in both
+	  human and machine-readable formats.
+
+	  The framework allows developers to document APIs inline with
+	  their implementation, including parameter specifications,
+	  return values, error conditions, locking requirements, and
+	  execution context constraints.
+
+	  When enabled, API specifications can be queried at runtime
+	  and exported in JSON format through debugfs.
+
+	  If unsure, say N.
+
+config KAPI_RUNTIME_CHECKS
+	bool "Runtime API specification checks"
+	depends on KAPI_SPEC
+	depends on DEBUG_KERNEL
+	# The hook is only in the generic and the x86 __SYSCALL_DEFINEx()
+	depends on X86 || !ARCH_HAS_SYSCALL_WRAPPER
+	help
+	  Validate the arguments and the return value of system calls that
+	  have an API specification, in their SYSCALL_DEFINEx() wrapper.
+	  Violations are reported with pr_warn_ratelimited(). This adds
+	  overhead to every system call.
+
+	  DEBUG-ONLY: Enabling this changes the errno seen by userspace for
+	  syscalls that violate their parameter specification. On violation
+	  the validator short-circuits the syscall and returns -EINVAL
+	  before the real handler runs, masking whatever errno the handler
+	  would otherwise have produced. Do not enable on production
+	  kernels.
+
+	  If unsure, say N.
+
+config KAPI_KUNIT_TEST
+	tristate "KUnit tests for KAPI framework" if !KUNIT_ALL_TESTS
+	depends on KAPI_SPEC
+	depends on KUNIT
+	default KUNIT_ALL_TESTS
+	help
+	  KUnit tests for the Kernel API Specification Framework.
+	  Tests registration, lookup, validation constraints, and
+	  JSON export functionality.
+
+	  If unsure, say N.
diff --git a/kernel/api/Makefile b/kernel/api/Makefile
new file mode 100644
index 0000000000000..6e14ca243980c
--- /dev/null
+++ b/kernel/api/Makefile
@@ -0,0 +1,10 @@
+# SPDX-License-Identifier: GPL-2.0
+#
+# Makefile for the Kernel API Specification Framework
+#
+
+# Core API specification framework
+obj-y				+= kernel_api_spec.o
+
+# KUnit tests
+obj-$(CONFIG_KAPI_KUNIT_TEST) += kapi_kunit.o
diff --git a/kernel/api/internal.h b/kernel/api/internal.h
new file mode 100644
index 0000000000000..b6112bcc2e8d0
--- /dev/null
+++ b/kernel/api/internal.h
@@ -0,0 +1,25 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Copyright (C) 2026 Sasha Levin <sashal@kernel.org>
+ *
+ * Internal declarations shared by the KAPI core and its debugfs
+ * interface. Not part of the public kernel API.
+ */
+
+#ifndef _KERNEL_API_INTERNAL_H
+#define _KERNEL_API_INTERNAL_H
+
+#include <linux/kernel_api_spec.h>
+
+/*
+ * Section boundaries for the `.kapi_specs` array. Defined by the
+ * linker script in include/asm-generic/vmlinux.lds.h.
+ */
+extern const struct kernel_api_spec * const __start_kapi_specs[];
+extern const struct kernel_api_spec * const __stop_kapi_specs[];
+
+const char *kapi_param_type_to_string(enum kapi_param_type type);
+const char *kapi_lock_type_to_string(enum kapi_lock_type type);
+const char *kapi_lock_scope_to_string(enum kapi_lock_scope scope);
+
+#endif /* _KERNEL_API_INTERNAL_H */
diff --git a/kernel/api/kapi_kunit.c b/kernel/api/kapi_kunit.c
new file mode 100644
index 0000000000000..4f6f874c33b86
--- /dev/null
+++ b/kernel/api/kapi_kunit.c
@@ -0,0 +1,720 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (C) 2026 Sasha Levin <sashal@kernel.org>
+ *
+ * KUnit tests for the Kernel API Specification Framework
+ *
+ * Tests registration, lookup, validation, and JSON export functionality.
+ */
+
+#include <kunit/test.h>
+#include <linux/kernel_api_spec.h>
+#include <linux/string.h>
+#include <linux/slab.h>
+#include <linux/capability.h>
+#include <linux/mm.h>
+#include <linux/signal.h>
+#include <linux/uaccess.h>
+
+static void init_test_spec(struct kernel_api_spec *spec, const char *name)
+{
+	memset(spec, 0, sizeof(*spec));
+	spec->name = name;
+	spec->version = 1;
+	spec->description = "Test API";
+}
+
+/* kapi_register_spec with valid spec returns 0 */
+static void test_register_valid(struct kunit *test)
+{
+	struct kernel_api_spec *spec;
+	int ret;
+
+	spec = kzalloc_obj(*spec, GFP_KERNEL);
+	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, spec);
+
+	init_test_spec(spec, "test_register_valid");
+
+	ret = kapi_register_spec(spec);
+	KUNIT_EXPECT_EQ(test, ret, 0);
+
+	kapi_unregister_spec("test_register_valid");
+	kfree(spec);
+}
+
+/* kapi_get_spec returns registered spec */
+static void test_lookup_registered(struct kunit *test)
+{
+	struct kernel_api_spec *spec;
+	const struct kernel_api_spec *found;
+	int ret;
+
+	spec = kzalloc_obj(*spec, GFP_KERNEL);
+	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, spec);
+
+	init_test_spec(spec, "test_lookup_func");
+
+	ret = kapi_register_spec(spec);
+	KUNIT_ASSERT_EQ(test, ret, 0);
+
+	found = kapi_get_spec("test_lookup_func");
+	KUNIT_EXPECT_PTR_EQ(test, found, (const struct kernel_api_spec *)spec);
+
+	kapi_unregister_spec("test_lookup_func");
+	kfree(spec);
+}
+
+/* Double registration returns -EEXIST */
+static void test_double_register(struct kunit *test)
+{
+	struct kernel_api_spec *spec;
+	int ret;
+
+	spec = kzalloc_obj(*spec, GFP_KERNEL);
+	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, spec);
+
+	init_test_spec(spec, "test_double_reg");
+
+	ret = kapi_register_spec(spec);
+	KUNIT_ASSERT_EQ(test, ret, 0);
+
+	ret = kapi_register_spec(spec);
+	KUNIT_EXPECT_EQ(test, ret, -EEXIST);
+
+	kapi_unregister_spec("test_double_reg");
+	kfree(spec);
+}
+
+/* Unregister makes spec unfindable */
+static void test_unregister(struct kunit *test)
+{
+	struct kernel_api_spec *spec;
+	const struct kernel_api_spec *found;
+	int ret;
+
+	spec = kzalloc_obj(*spec, GFP_KERNEL);
+	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, spec);
+
+	init_test_spec(spec, "test_unreg_func");
+
+	ret = kapi_register_spec(spec);
+	KUNIT_ASSERT_EQ(test, ret, 0);
+
+	kapi_unregister_spec("test_unreg_func");
+
+	found = kapi_get_spec("test_unreg_func");
+	KUNIT_EXPECT_NULL(test, found);
+
+	kfree(spec);
+}
+
+/* kapi_get_spec(NULL) returns NULL */
+static void test_get_spec_null(struct kunit *test)
+{
+	const struct kernel_api_spec *found;
+
+	found = kapi_get_spec(NULL);
+	KUNIT_EXPECT_NULL(test, found);
+}
+
+/* kapi_register_spec(NULL) returns -EINVAL */
+static void test_register_null(struct kunit *test)
+{
+	int ret;
+
+	ret = kapi_register_spec(NULL);
+	KUNIT_EXPECT_EQ(test, ret, -EINVAL);
+}
+
+/* Spec with a NULL name is rejected */
+static void test_register_null_name(struct kunit *test)
+{
+	struct kernel_api_spec *spec;
+	int ret;
+
+	spec = kzalloc_obj(*spec, GFP_KERNEL);
+	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, spec);
+
+	/* spec->name == NULL after zero-init; registration rejects it. */
+	ret = kapi_register_spec(spec);
+	KUNIT_EXPECT_EQ(test, ret, -EINVAL);
+
+	kfree(spec);
+}
+
+#ifdef CONFIG_KAPI_RUNTIME_CHECKS
+
+/* RANGE constraint - value in range is valid */
+static void test_constraint_range_valid(struct kunit *test)
+{
+	struct kapi_param_spec param = {};
+
+	param.name = "test_param";
+	param.constraint_type = KAPI_CONSTRAINT_RANGE;
+	param.min_value = 0;
+	param.max_value = 100;
+
+	KUNIT_EXPECT_TRUE(test, kapi_validate_param(&param, 0));
+	KUNIT_EXPECT_TRUE(test, kapi_validate_param(&param, 50));
+	KUNIT_EXPECT_TRUE(test, kapi_validate_param(&param, 100));
+
+	param.min_value = -10;
+	param.max_value = -1;
+	KUNIT_EXPECT_TRUE(test, kapi_validate_param(&param, -10));
+	KUNIT_EXPECT_TRUE(test, kapi_validate_param(&param, -1));
+
+	/* An unsigned maximum such as U64_MAX reads as -1 */
+	param.min_value = 0;
+	param.max_value = (s64)U64_MAX;
+	KUNIT_EXPECT_TRUE(test, kapi_validate_param(&param, S64_MAX));
+}
+
+/* RANGE constraint - value out of range is invalid */
+static void test_constraint_range_invalid(struct kunit *test)
+{
+	struct kapi_param_spec param = {};
+
+	param.name = "test_param";
+	param.constraint_type = KAPI_CONSTRAINT_RANGE;
+	param.min_value = 0;
+	param.max_value = 100;
+
+	KUNIT_EXPECT_FALSE(test, kapi_validate_param(&param, -1));
+	KUNIT_EXPECT_FALSE(test, kapi_validate_param(&param, 101));
+
+	param.min_value = -10;
+	param.max_value = -1;
+	KUNIT_EXPECT_FALSE(test, kapi_validate_param(&param, -11));
+	KUNIT_EXPECT_FALSE(test, kapi_validate_param(&param, 0));
+	KUNIT_EXPECT_FALSE(test, kapi_validate_param(&param, 5));
+}
+
+/* MASK constraint - valid bits pass */
+static void test_constraint_mask_valid(struct kunit *test)
+{
+	struct kapi_param_spec param = {};
+
+	param.name = "test_flags";
+	param.constraint_type = KAPI_CONSTRAINT_MASK;
+	param.valid_mask = 0xFF;
+
+	KUNIT_EXPECT_TRUE(test, kapi_validate_param(&param, 0x00));
+	KUNIT_EXPECT_TRUE(test, kapi_validate_param(&param, 0x0F));
+	KUNIT_EXPECT_TRUE(test, kapi_validate_param(&param, 0xFF));
+}
+
+/* MASK constraint - extra bits fail */
+static void test_constraint_mask_invalid(struct kunit *test)
+{
+	struct kapi_param_spec param = {};
+
+	param.name = "test_flags";
+	param.constraint_type = KAPI_CONSTRAINT_MASK;
+	param.valid_mask = 0xFF;
+
+	KUNIT_EXPECT_FALSE(test, kapi_validate_param(&param, 0x100));
+	KUNIT_EXPECT_FALSE(test, kapi_validate_param(&param, 0x1FF));
+}
+
+/* POWER_OF_TWO constraint */
+static void test_constraint_power_of_two(struct kunit *test)
+{
+	struct kapi_param_spec param = {};
+
+	param.name = "test_pot";
+	param.constraint_type = KAPI_CONSTRAINT_POWER_OF_TWO;
+
+	KUNIT_EXPECT_TRUE(test, kapi_validate_param(&param, 1));
+	KUNIT_EXPECT_TRUE(test, kapi_validate_param(&param, 2));
+	KUNIT_EXPECT_TRUE(test, kapi_validate_param(&param, 4));
+	KUNIT_EXPECT_TRUE(test, kapi_validate_param(&param, 8));
+	KUNIT_EXPECT_FALSE(test, kapi_validate_param(&param, 0));
+	KUNIT_EXPECT_FALSE(test, kapi_validate_param(&param, 3));
+	KUNIT_EXPECT_FALSE(test, kapi_validate_param(&param, 5));
+}
+
+/* PAGE_ALIGNED constraint */
+static void test_constraint_page_aligned(struct kunit *test)
+{
+	struct kapi_param_spec param = {};
+
+	param.name = "test_page";
+	param.constraint_type = KAPI_CONSTRAINT_PAGE_ALIGNED;
+
+	KUNIT_EXPECT_TRUE(test, kapi_validate_param(&param, 0));
+	KUNIT_EXPECT_TRUE(test, kapi_validate_param(&param, PAGE_SIZE));
+	KUNIT_EXPECT_TRUE(test, kapi_validate_param(&param, 2 * PAGE_SIZE));
+	KUNIT_EXPECT_FALSE(test, kapi_validate_param(&param, 1));
+	KUNIT_EXPECT_FALSE(test, kapi_validate_param(&param, PAGE_SIZE - 1));
+}
+
+/* NONZERO constraint */
+static void test_constraint_nonzero(struct kunit *test)
+{
+	struct kapi_param_spec param = {};
+
+	param.name = "test_nz";
+	param.constraint_type = KAPI_CONSTRAINT_NONZERO;
+
+	KUNIT_EXPECT_FALSE(test, kapi_validate_param(&param, 0));
+	KUNIT_EXPECT_TRUE(test, kapi_validate_param(&param, 1));
+	KUNIT_EXPECT_TRUE(test, kapi_validate_param(&param, -1));
+}
+
+/* Return value validation - success */
+static void test_return_validation(struct kunit *test)
+{
+	struct kernel_api_spec *spec;
+
+	spec = kunit_kzalloc(test, sizeof(*spec), GFP_KERNEL);
+	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, spec);
+
+	spec->name = "test_ret";
+	spec->return_magic = KAPI_MAGIC_RETURN;
+	spec->return_spec.check_type = KAPI_RETURN_EXACT;
+	spec->return_spec.success_value = 0;
+
+	KUNIT_EXPECT_TRUE(test, kapi_validate_return_value(spec, 0));
+}
+
+/* Return value validation - known error */
+static void test_return_known_error(struct kunit *test)
+{
+	struct kernel_api_spec *spec;
+
+	spec = kunit_kzalloc(test, sizeof(*spec), GFP_KERNEL);
+	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, spec);
+
+	spec->name = "test_ret_err";
+	spec->return_magic = KAPI_MAGIC_RETURN;
+	spec->return_spec.check_type = KAPI_RETURN_FD;
+	spec->error_count = 1;
+	spec->errors[0].error_code = -ENOENT;
+	spec->errors[0].name = "ENOENT";
+
+	/* -ENOENT is in the error list, so it's valid */
+	KUNIT_EXPECT_TRUE(test, kapi_validate_return_value(spec, -ENOENT));
+}
+
+/* Return value validation - unknown error */
+static void test_return_unknown_error(struct kunit *test)
+{
+	struct kernel_api_spec *spec;
+
+	spec = kunit_kzalloc(test, sizeof(*spec), GFP_KERNEL);
+	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, spec);
+
+	spec->name = "test_ret_unk";
+	spec->return_magic = KAPI_MAGIC_RETURN;
+	spec->return_spec.check_type = KAPI_RETURN_FD;
+	spec->error_count = 1;
+	spec->errors[0].error_code = -ENOENT;
+	spec->errors[0].name = "ENOENT";
+
+	/* -EPERM is not in the error list, but unlisted errors are accepted
+	 * since filesystem/device-specific errors may not be exhaustively listed
+	 */
+	KUNIT_EXPECT_TRUE(test, kapi_validate_return_value(spec, -EPERM));
+}
+
+/* ALIGNMENT constraint */
+static void test_constraint_alignment(struct kunit *test)
+{
+	struct kapi_param_spec param = {};
+
+	param.name = "test_align";
+	param.constraint_type = KAPI_CONSTRAINT_ALIGNMENT;
+	param.alignment = 8;
+
+	KUNIT_EXPECT_TRUE(test, kapi_validate_param(&param, 0));
+	KUNIT_EXPECT_TRUE(test, kapi_validate_param(&param, 8));
+	KUNIT_EXPECT_TRUE(test, kapi_validate_param(&param, 16));
+	KUNIT_EXPECT_FALSE(test, kapi_validate_param(&param, 1));
+	KUNIT_EXPECT_FALSE(test, kapi_validate_param(&param, 7));
+}
+
+/* FD validation rejects values > INT_MAX */
+static void test_fd_int_overflow(struct kunit *test)
+{
+	struct kapi_param_spec param = {};
+
+	param.name = "test_fd";
+	param.type = KAPI_TYPE_FD;
+	param.constraint_type = KAPI_CONSTRAINT_NONE;
+
+	/* Value that overflows int: 0x100000003 -> truncates to 3 */
+	KUNIT_EXPECT_FALSE(test, kapi_validate_param(&param, 0x100000003LL));
+}
+
+/* ENUM constraint */
+static const s64 test_enum_vals[] = { 1, 5, 10 };
+
+static void test_constraint_enum(struct kunit *test)
+{
+	struct kapi_param_spec param = {};
+
+	param.name = "test_enum";
+	param.constraint_type = KAPI_CONSTRAINT_ENUM;
+	param.enum_values = test_enum_vals;
+	param.enum_count = ARRAY_SIZE(test_enum_vals);
+
+	KUNIT_EXPECT_TRUE(test, kapi_validate_param(&param, 1));
+	KUNIT_EXPECT_TRUE(test, kapi_validate_param(&param, 5));
+	KUNIT_EXPECT_TRUE(test, kapi_validate_param(&param, 10));
+	KUNIT_EXPECT_FALSE(test, kapi_validate_param(&param, 0));
+	KUNIT_EXPECT_FALSE(test, kapi_validate_param(&param, 3));
+	KUNIT_EXPECT_FALSE(test, kapi_validate_param(&param, 11));
+}
+
+/* BUFFER constraint always accepts (size checked at runtime) */
+static void test_constraint_buffer(struct kunit *test)
+{
+	struct kapi_param_spec param = {};
+
+	param.name = "test_buf";
+	param.constraint_type = KAPI_CONSTRAINT_BUFFER;
+
+	/* Buffer constraint doesn't validate the value itself */
+	KUNIT_EXPECT_TRUE(test, kapi_validate_param(&param, 0));
+	KUNIT_EXPECT_TRUE(test, kapi_validate_param(&param, 4096));
+}
+
+/* RETURN_RANGE check type */
+static void test_return_range(struct kunit *test)
+{
+	struct kernel_api_spec *spec;
+
+	spec = kunit_kzalloc(test, sizeof(*spec), GFP_KERNEL);
+	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, spec);
+
+	spec->name = "test_ret_range";
+	spec->return_magic = KAPI_MAGIC_RETURN;
+	spec->return_spec.check_type = KAPI_RETURN_RANGE;
+	spec->return_spec.success_min = 0;
+	spec->return_spec.success_max = 100;
+
+	KUNIT_EXPECT_TRUE(test, kapi_validate_return_value(spec, 0));
+	KUNIT_EXPECT_TRUE(test, kapi_validate_return_value(spec, 50));
+	KUNIT_EXPECT_TRUE(test, kapi_validate_return_value(spec, 100));
+}
+
+static void init_dyn_buf_param(struct kapi_param_spec *param)
+{
+	param->name = "buf";
+	param->type = KAPI_TYPE_USER_PTR;
+	param->constraint_type = KAPI_CONSTRAINT_BUFFER;
+	param->size_param_idx = 2;
+}
+
+static bool validate_dyn_buf(const struct kapi_param_spec *param,
+			     const void __user *ptr, s64 count)
+{
+	s64 params[] = { (s64)(unsigned long)ptr, count };
+
+	return kapi_validate_param_with_context(param, params[0], params,
+						ARRAY_SIZE(params));
+}
+
+/* Dynamic buffer: any pointer is accepted when the size is 0 */
+static void test_dyn_buf_zero_count(struct kunit *test)
+{
+	struct kapi_param_spec param = {};
+	const void __user *kernel_addr = (void __user *)-(unsigned long)PAGE_SIZE;
+
+	init_dyn_buf_param(&param);
+
+	KUNIT_EXPECT_TRUE(test, validate_dyn_buf(&param, NULL, 0));
+	KUNIT_EXPECT_TRUE(test, validate_dyn_buf(&param, (void __user *)PAGE_SIZE, 0));
+	KUNIT_EXPECT_TRUE(test, validate_dyn_buf(&param, kernel_addr, 0));
+}
+
+/* Dynamic buffer: NULL is rejected when the size is non-zero */
+static void test_dyn_buf_null_nonzero_count(struct kunit *test)
+{
+	struct kapi_param_spec param = {};
+
+	init_dyn_buf_param(&param);
+
+	KUNIT_EXPECT_FALSE(test, validate_dyn_buf(&param, NULL, 1));
+	KUNIT_EXPECT_FALSE(test, validate_dyn_buf(&param, NULL, PAGE_SIZE));
+}
+
+/*
+ * Some architectures (separate user address space, !MMU) accept any address
+ * in access_ok(), so the rejection cases below only apply where it bounds
+ * user ranges.
+ */
+static bool kapi_rejects_kernel_addr(const void __user *addr)
+{
+	return !access_ok(addr, 1);
+}
+
+static bool kapi_bounds_user_range(const void __user *base)
+{
+	return access_ok(base, PAGE_SIZE) && !access_ok(base, 3 * PAGE_SIZE);
+}
+
+/* Dynamic buffer: addresses outside user space are rejected when the size is non-zero */
+static void test_dyn_buf_kernel_addr(struct kunit *test)
+{
+	struct kapi_param_spec param = {};
+	const void __user *kernel_addr = (void __user *)-(unsigned long)PAGE_SIZE;
+	const void __user *top = (void __user *)ULONG_MAX;
+
+	init_dyn_buf_param(&param);
+
+	if (!kapi_rejects_kernel_addr(kernel_addr) || !kapi_rejects_kernel_addr(top))
+		kunit_skip(test, "access_ok() accepts kernel addresses on this architecture");
+
+	KUNIT_EXPECT_FALSE(test, validate_dyn_buf(&param, kernel_addr, 1));
+	KUNIT_EXPECT_FALSE(test, validate_dyn_buf(&param, top, 1));
+}
+
+/* Dynamic buffer: an unset size_multiplier means byte units */
+static void test_dyn_buf_default_multiplier(struct kunit *test)
+{
+	struct kapi_param_spec param = {};
+	const void __user *near_top = (void __user *)(TASK_SIZE_MAX - 2 * PAGE_SIZE);
+
+	init_dyn_buf_param(&param);
+
+	KUNIT_EXPECT_TRUE(test, validate_dyn_buf(&param, (void __user *)PAGE_SIZE, 16));
+	KUNIT_EXPECT_TRUE(test, validate_dyn_buf(&param, near_top, 0));
+
+	if (!kapi_bounds_user_range(near_top))
+		kunit_skip(test, "access_ok() does not bound user ranges on this architecture");
+
+	KUNIT_EXPECT_TRUE(test, validate_dyn_buf(&param, near_top, PAGE_SIZE));
+	KUNIT_EXPECT_FALSE(test, validate_dyn_buf(&param, near_top, 3 * PAGE_SIZE));
+}
+
+/* Dynamic buffer: explicit multiplier scales the size, negative and overflowing counts fail */
+static void test_dyn_buf_multiplier_and_bad_count(struct kunit *test)
+{
+	struct kapi_param_spec param = {};
+	const void __user *near_top = (void __user *)(TASK_SIZE_MAX - 2 * PAGE_SIZE);
+
+	init_dyn_buf_param(&param);
+	param.size_multiplier = 8;
+
+	KUNIT_EXPECT_FALSE(test, validate_dyn_buf(&param, (void __user *)PAGE_SIZE,
+						  (s64)(SIZE_MAX / 8 + 1)));
+	KUNIT_EXPECT_FALSE(test, validate_dyn_buf(&param, (void __user *)PAGE_SIZE, -1));
+
+	if (!kapi_bounds_user_range(near_top))
+		kunit_skip(test, "access_ok() does not bound user ranges on this architecture");
+
+	KUNIT_EXPECT_TRUE(test, validate_dyn_buf(&param, near_top, PAGE_SIZE / 8));
+	KUNIT_EXPECT_FALSE(test, validate_dyn_buf(&param, near_top, PAGE_SIZE));
+}
+
+#endif /* CONFIG_KAPI_RUNTIME_CHECKS */
+
+static const struct kernel_api_spec kapi_test_macro_spec = {
+	.name = "test_macro_spec",
+	KAPI_SIGNAL_MASK_COUNT(1)
+	KAPI_SIGNAL_MASK(0, "blocked", "Signals blocked while waiting")
+		KAPI_SIGNAL_MASK_SIGNALS(SIGINT, SIGTERM, SIGQUIT)
+	},
+	KAPI_CAPABILITY_COUNT(1)
+	KAPI_CAPABILITY(0, CAP_SYS_ADMIN, "CAP_SYS_ADMIN", KAPI_CAP_BYPASS_CHECK)
+		KAPI_CAP_ALTERNATIVE(CAP_SYS_RESOURCE, CAP_NET_ADMIN)
+	},
+};
+
+/* Signal mask and capability alternative macros fill in their counts */
+static void test_signal_mask_and_cap_alternative(struct kunit *test)
+{
+	const struct kernel_api_spec *spec = &kapi_test_macro_spec;
+	char *buf;
+
+	KUNIT_EXPECT_EQ(test, spec->signal_mask_count, 1U);
+	KUNIT_EXPECT_EQ(test, spec->signal_masks[0].signal_count, 3U);
+	KUNIT_EXPECT_EQ(test, spec->signal_masks[0].signals[2], SIGQUIT);
+	KUNIT_EXPECT_EQ(test, spec->capabilities[0].alternative_count, 2U);
+	KUNIT_EXPECT_EQ(test, spec->capabilities[0].alternative[1], CAP_NET_ADMIN);
+
+	buf = kunit_kzalloc(test, 8192, GFP_KERNEL);
+	KUNIT_ASSERT_NOT_NULL(test, buf);
+	KUNIT_ASSERT_GT(test, kapi_export_json(spec, buf, 8192), 0);
+	KUNIT_EXPECT_NOT_NULL(test, strstr(buf, "\"blocked\""));
+	KUNIT_EXPECT_NOT_NULL(test, strstr(buf, "\"alternatives\""));
+}
+
+/* Unregister non-existent spec is a no-op */
+static void test_unregister_nonexistent(struct kunit *test)
+{
+	/* Should not crash or error */
+	kapi_unregister_spec("nonexistent_spec_xyz");
+}
+
+/* Multiple specs can be registered and looked up */
+static void test_multiple_specs(struct kunit *test)
+{
+	struct kernel_api_spec *spec1, *spec2;
+	const struct kernel_api_spec *found;
+
+	spec1 = kzalloc_obj(*spec1, GFP_KERNEL);
+	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, spec1);
+	spec2 = kzalloc_obj(*spec2, GFP_KERNEL);
+	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, spec2);
+
+	init_test_spec(spec1, "multi_spec_1");
+	init_test_spec(spec2, "multi_spec_2");
+
+	KUNIT_ASSERT_EQ(test, kapi_register_spec(spec1), 0);
+	KUNIT_ASSERT_EQ(test, kapi_register_spec(spec2), 0);
+
+	found = kapi_get_spec("multi_spec_1");
+	KUNIT_EXPECT_PTR_EQ(test, found, (const struct kernel_api_spec *)spec1);
+
+	found = kapi_get_spec("multi_spec_2");
+	KUNIT_EXPECT_PTR_EQ(test, found, (const struct kernel_api_spec *)spec2);
+
+	kapi_unregister_spec("multi_spec_1");
+	kapi_unregister_spec("multi_spec_2");
+	kfree(spec1);
+	kfree(spec2);
+}
+
+/* JSON export produces valid output */
+static void test_json_export(struct kunit *test)
+{
+	static const s64 enum_vals[] = { 3, -1 };
+	static const s64 err_vals[] = { -EINVAL, -EFAULT };
+	struct kernel_api_spec *spec;
+	char *buf;
+	int ret;
+
+	spec = kzalloc_obj(*spec, GFP_KERNEL);
+	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, spec);
+
+	buf = kzalloc(4096, GFP_KERNEL);
+	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, buf);
+
+	init_test_spec(spec, "test_json");
+	spec->param_count = 1;
+	spec->params[0].name = "arg0";
+	spec->params[0].type_name = "int";
+	spec->params[0].constraint_type = KAPI_CONSTRAINT_ENUM;
+	spec->params[0].enum_values = enum_vals;
+	spec->params[0].enum_count = ARRAY_SIZE(enum_vals);
+	spec->params[0].valid_mask = 0xff;
+	spec->params[0].size_param_idx = 2;
+	spec->return_spec.check_type = KAPI_RETURN_ERROR_CHECK;
+	spec->return_spec.error_values = err_vals;
+	spec->return_spec.error_count = ARRAY_SIZE(err_vals);
+
+	ret = kapi_export_json(spec, buf, 4096);
+	KUNIT_EXPECT_GT(test, ret, 0);
+
+	/* Verify it starts with '{' and ends with '}' */
+	KUNIT_EXPECT_EQ(test, buf[0], '{');
+	KUNIT_ASSERT_GT(test, ret, 1);
+	/* Find last non-whitespace char */
+	while (ret > 0 && (buf[ret - 1] == '\n' || buf[ret - 1] == ' '))
+		ret--;
+	KUNIT_EXPECT_EQ(test, buf[ret - 1], '}');
+
+	/* Verify key fields are present */
+	KUNIT_EXPECT_NOT_NULL(test, strstr(buf, "\"name\""));
+	KUNIT_EXPECT_NOT_NULL(test, strstr(buf, "\"test_json\""));
+	KUNIT_EXPECT_NOT_NULL(test, strstr(buf, "\"parameters\""));
+
+	KUNIT_EXPECT_NOT_NULL(test, strstr(buf, "\"constraint_type\": \"enum\""));
+	KUNIT_EXPECT_NOT_NULL(test, strstr(buf, "\"enum_values\": [3, -1]"));
+	KUNIT_EXPECT_NOT_NULL(test, strstr(buf, "\"valid_mask\": \"0xff\""));
+	KUNIT_EXPECT_NOT_NULL(test, strstr(buf, "\"size_param_idx\": 1"));
+	KUNIT_EXPECT_NOT_NULL(test, strstr(buf, "\"error_values\": [-22, -14]"));
+	KUNIT_EXPECT_NOT_NULL(test, strstr(buf, "\"state_transitions\""));
+	KUNIT_EXPECT_NOT_NULL(test, strstr(buf, "\"struct_specs\""));
+
+	kfree(buf);
+	kfree(spec);
+}
+
+/* JSON export with NULL args returns -EINVAL */
+static void test_json_export_null(struct kunit *test)
+{
+	struct kernel_api_spec *spec;
+	char buf[64];
+	int ret;
+
+	ret = kapi_export_json(NULL, buf, sizeof(buf));
+	KUNIT_EXPECT_EQ(test, ret, -EINVAL);
+
+	spec = kunit_kzalloc(test, sizeof(*spec), GFP_KERNEL);
+	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, spec);
+	init_test_spec(spec, "test");
+
+	ret = kapi_export_json(spec, NULL, 64);
+	KUNIT_EXPECT_EQ(test, ret, -EINVAL);
+
+	ret = kapi_export_json(spec, buf, 0);
+	KUNIT_EXPECT_EQ(test, ret, -EINVAL);
+}
+
+/* JSON export into a buffer that is too small reports -E2BIG */
+static void test_json_export_small_buffer(struct kunit *test)
+{
+	struct kernel_api_spec *spec;
+	char buf[64];
+	int ret;
+
+	spec = kunit_kzalloc(test, sizeof(*spec), GFP_KERNEL);
+	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, spec);
+	init_test_spec(spec, "test_small");
+
+	ret = kapi_export_json(spec, buf, sizeof(buf));
+
+	KUNIT_EXPECT_EQ(test, ret, -E2BIG);
+}
+
+static struct kunit_case kapi_test_cases[] = {
+	KUNIT_CASE(test_register_valid),
+	KUNIT_CASE(test_lookup_registered),
+	KUNIT_CASE(test_double_register),
+	KUNIT_CASE(test_unregister),
+	KUNIT_CASE(test_get_spec_null),
+	KUNIT_CASE(test_register_null),
+	KUNIT_CASE(test_register_null_name),
+#ifdef CONFIG_KAPI_RUNTIME_CHECKS
+	KUNIT_CASE(test_constraint_range_valid),
+	KUNIT_CASE(test_constraint_range_invalid),
+	KUNIT_CASE(test_constraint_mask_valid),
+	KUNIT_CASE(test_constraint_mask_invalid),
+	KUNIT_CASE(test_constraint_power_of_two),
+	KUNIT_CASE(test_constraint_page_aligned),
+	KUNIT_CASE(test_constraint_nonzero),
+	KUNIT_CASE(test_return_validation),
+	KUNIT_CASE(test_return_known_error),
+	KUNIT_CASE(test_return_unknown_error),
+	KUNIT_CASE(test_constraint_alignment),
+	KUNIT_CASE(test_fd_int_overflow),
+	KUNIT_CASE(test_constraint_enum),
+	KUNIT_CASE(test_constraint_buffer),
+	KUNIT_CASE(test_return_range),
+	KUNIT_CASE(test_dyn_buf_zero_count),
+	KUNIT_CASE(test_dyn_buf_null_nonzero_count),
+	KUNIT_CASE(test_dyn_buf_kernel_addr),
+	KUNIT_CASE(test_dyn_buf_default_multiplier),
+	KUNIT_CASE(test_dyn_buf_multiplier_and_bad_count),
+#endif
+	KUNIT_CASE(test_signal_mask_and_cap_alternative),
+	KUNIT_CASE(test_unregister_nonexistent),
+	KUNIT_CASE(test_multiple_specs),
+	KUNIT_CASE(test_json_export),
+	KUNIT_CASE(test_json_export_null),
+	KUNIT_CASE(test_json_export_small_buffer),
+	{}
+};
+
+static struct kunit_suite kapi_test_suite = {
+	.name = "kapi",
+	.test_cases = kapi_test_cases,
+};
+
+kunit_test_suite(kapi_test_suite);
+
+MODULE_DESCRIPTION("KUnit tests for Kernel API Specification Framework");
+MODULE_LICENSE("GPL");
diff --git a/kernel/api/kernel_api_spec.c b/kernel/api/kernel_api_spec.c
new file mode 100644
index 0000000000000..c3b220104c04b
--- /dev/null
+++ b/kernel/api/kernel_api_spec.c
@@ -0,0 +1,1415 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (C) 2026 Sasha Levin <sashal@kernel.org>
+ *
+ * kernel_api_spec.c - Kernel API Specification Framework Implementation
+ *
+ * Provides runtime support for kernel API specifications including validation,
+ * export to various formats, and querying capabilities.
+ */
+
+#define pr_fmt(fmt) "kapi: " fmt
+
+#include <linux/kernel.h>
+#include <linux/kernel_api_spec.h>
+#include <linux/string.h>
+#include <linux/slab.h>
+#include <linux/list.h>
+#include <linux/mutex.h>
+#include <linux/export.h>
+#include <linux/preempt.h>
+#include <linux/hardirq.h>
+#include <linux/file.h>
+#include <linux/fdtable.h>
+#include <linux/uaccess.h>
+#include <linux/limits.h>
+#include <linux/fcntl.h>
+#include <linux/mm.h>
+#include <linux/ratelimit.h>
+
+#include "internal.h"
+
+/* Dynamic API registration */
+static LIST_HEAD(dynamic_api_specs);
+static DEFINE_MUTEX(api_spec_mutex);
+
+struct dynamic_api_spec {
+	struct list_head list;
+	const struct kernel_api_spec *spec;
+};
+
+/*
+ * __kapi_find_spec_locked - Internal lookup, caller must hold api_spec_mutex
+ */
+static const struct kernel_api_spec *__kapi_find_spec_locked(const char *name)
+{
+	const struct kernel_api_spec * const *pp;
+	struct dynamic_api_spec *dyn_spec;
+
+	for (pp = __start_kapi_specs; pp < __stop_kapi_specs; pp++) {
+		const struct kernel_api_spec *spec = *pp;
+
+		if (spec && spec->name && strcmp(spec->name, name) == 0)
+			return spec;
+	}
+
+	list_for_each_entry(dyn_spec, &dynamic_api_specs, list) {
+		if (dyn_spec->spec->name &&
+		    strcmp(dyn_spec->spec->name, name) == 0)
+			return dyn_spec->spec;
+	}
+
+	return NULL;
+}
+
+/**
+ * kapi_get_spec - Get API specification by name
+ * @name: Function name to look up
+ *
+ * Return: Pointer to the API specification, or NULL if not found. The
+ * pointer stays valid for specifications in the ``.kapi_specs`` ELF section
+ * (built-in, statically defined). A dynamically registered spec stays valid
+ * only until kapi_unregister_spec() is called for it, so the caller must
+ * serialize against unregistration.
+ *
+ * Context: May sleep. Do not call under spinlock or in IRQ context.
+ */
+const struct kernel_api_spec *kapi_get_spec(const char *name)
+{
+	const struct kernel_api_spec *spec;
+
+	if (!name)
+		return NULL;
+
+	mutex_lock(&api_spec_mutex);
+	spec = __kapi_find_spec_locked(name);
+	mutex_unlock(&api_spec_mutex);
+
+	return spec;
+}
+EXPORT_SYMBOL_GPL(kapi_get_spec);
+
+/**
+ * kapi_register_spec - Register a dynamic API specification
+ * @spec: API specification to register
+ *
+ * Return: 0 on success, negative error code on failure
+ */
+int kapi_register_spec(const struct kernel_api_spec *spec)
+{
+	struct dynamic_api_spec *dyn_spec;
+	int ret = 0;
+
+	if (!spec || !spec->name || !spec->name[0])
+		return -EINVAL;
+
+	dyn_spec = kzalloc_obj(*dyn_spec, GFP_KERNEL);
+	if (!dyn_spec)
+		return -ENOMEM;
+
+	dyn_spec->spec = spec;
+
+	mutex_lock(&api_spec_mutex);
+
+	/* Check if already exists while holding lock to prevent races */
+	if (__kapi_find_spec_locked(spec->name)) {
+		ret = -EEXIST;
+		kfree(dyn_spec);
+	} else {
+		list_add_tail(&dyn_spec->list, &dynamic_api_specs);
+	}
+
+	mutex_unlock(&api_spec_mutex);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(kapi_register_spec);
+
+/**
+ * kapi_unregister_spec - Unregister a dynamic API specification
+ * @name: Name of API to unregister
+ */
+void kapi_unregister_spec(const char *name)
+{
+	struct dynamic_api_spec *dyn_spec, *tmp;
+
+	if (!name)
+		return;
+
+	mutex_lock(&api_spec_mutex);
+	list_for_each_entry_safe(dyn_spec, tmp, &dynamic_api_specs, list) {
+		if (dyn_spec->spec->name &&
+		    strcmp(dyn_spec->spec->name, name) == 0) {
+			list_del(&dyn_spec->list);
+			kfree(dyn_spec);
+			break;
+		}
+	}
+	mutex_unlock(&api_spec_mutex);
+}
+EXPORT_SYMBOL_GPL(kapi_unregister_spec);
+
+/**
+ * kapi_param_type_to_string - Convert parameter type to string
+ * @type: Parameter type
+ *
+ * Return: String representation of type
+ */
+const char *kapi_param_type_to_string(enum kapi_param_type type)
+{
+	static const char * const type_names[] = {
+		[KAPI_TYPE_VOID] = "void",
+		[KAPI_TYPE_INT] = "int",
+		[KAPI_TYPE_UINT] = "uint",
+		[KAPI_TYPE_PTR] = "pointer",
+		[KAPI_TYPE_STRUCT] = "struct",
+		[KAPI_TYPE_UNION] = "union",
+		[KAPI_TYPE_ENUM] = "enum",
+		[KAPI_TYPE_FUNC_PTR] = "function_pointer",
+		[KAPI_TYPE_ARRAY] = "array",
+		[KAPI_TYPE_FD] = "file_descriptor",
+		[KAPI_TYPE_USER_PTR] = "user_pointer",
+		[KAPI_TYPE_PATH] = "pathname",
+		[KAPI_TYPE_CUSTOM] = "custom",
+	};
+
+	if (type >= ARRAY_SIZE(type_names))
+		return "unknown";
+
+	return type_names[type];
+}
+
+/**
+ * kapi_lock_type_to_string - Convert lock type to string
+ * @type: Lock type
+ *
+ * Return: String representation of lock type
+ */
+const char *kapi_lock_type_to_string(enum kapi_lock_type type)
+{
+	static const char * const lock_names[] = {
+		[KAPI_LOCK_NONE] = "none",
+		[KAPI_LOCK_MUTEX] = "mutex",
+		[KAPI_LOCK_SPINLOCK] = "spinlock",
+		[KAPI_LOCK_RWLOCK] = "rwlock",
+		[KAPI_LOCK_SEQLOCK] = "seqlock",
+		[KAPI_LOCK_RCU] = "rcu",
+		[KAPI_LOCK_SEMAPHORE] = "semaphore",
+		[KAPI_LOCK_CUSTOM] = "custom",
+	};
+
+	if (type >= ARRAY_SIZE(lock_names))
+		return "unknown";
+
+	return lock_names[type];
+}
+
+/**
+ * kapi_lock_scope_to_string - Convert lock scope to string
+ * @scope: Lock scope
+ *
+ * Return: String representation of lock scope
+ */
+const char *kapi_lock_scope_to_string(enum kapi_lock_scope scope)
+{
+	static const char * const scope_names[] = {
+		[KAPI_LOCK_INTERNAL] = "internal",
+		[KAPI_LOCK_ACQUIRES] = "acquires",
+		[KAPI_LOCK_RELEASES] = "releases",
+		[KAPI_LOCK_CALLER_HELD] = "caller_held",
+	};
+
+	if (scope >= ARRAY_SIZE(scope_names))
+		return "unknown";
+
+	return scope_names[scope];
+}
+
+/**
+ * return_check_type_to_string - Convert return check type to string
+ * @type: Return check type
+ *
+ * Return: String representation of return check type
+ */
+static const char *return_check_type_to_string(enum kapi_return_check_type type)
+{
+	static const char * const check_names[] = {
+		[KAPI_RETURN_EXACT] = "exact",
+		[KAPI_RETURN_RANGE] = "range",
+		[KAPI_RETURN_ERROR_CHECK] = "error_check",
+		[KAPI_RETURN_FD] = "file_descriptor",
+		[KAPI_RETURN_CUSTOM] = "custom",
+		[KAPI_RETURN_NO_RETURN] = "no_return",
+	};
+
+	if (type >= ARRAY_SIZE(check_names))
+		return "unknown";
+
+	return check_names[type];
+}
+
+/**
+ * capability_action_to_string - Convert capability action to string
+ * @action: Capability action
+ *
+ * Return: String representation of capability action
+ */
+static const char *capability_action_to_string(enum kapi_capability_action action)
+{
+	static const char * const action_names[] = {
+		[KAPI_CAP_BYPASS_CHECK] = "bypass_check",
+		[KAPI_CAP_INCREASE_LIMIT] = "increase_limit",
+		[KAPI_CAP_OVERRIDE_RESTRICTION] = "override_restriction",
+		[KAPI_CAP_GRANT_PERMISSION] = "grant_permission",
+		[KAPI_CAP_MODIFY_BEHAVIOR] = "modify_behavior",
+		[KAPI_CAP_ACCESS_RESOURCE] = "access_resource",
+		[KAPI_CAP_PERFORM_OPERATION] = "perform_operation",
+	};
+
+	if (action >= ARRAY_SIZE(action_names))
+		return "unknown";
+
+	return action_names[action];
+}
+
+/**
+ * constraint_type_to_string - Convert constraint type to string
+ * @type: Constraint type
+ *
+ * Return: String representation of constraint type
+ */
+static const char *constraint_type_to_string(enum kapi_constraint_type type)
+{
+	static const char * const constraint_names[] = {
+		[KAPI_CONSTRAINT_NONE] = "none",
+		[KAPI_CONSTRAINT_RANGE] = "range",
+		[KAPI_CONSTRAINT_MASK] = "mask",
+		[KAPI_CONSTRAINT_ENUM] = "enum",
+		[KAPI_CONSTRAINT_ALIGNMENT] = "alignment",
+		[KAPI_CONSTRAINT_POWER_OF_TWO] = "power_of_two",
+		[KAPI_CONSTRAINT_PAGE_ALIGNED] = "page_aligned",
+		[KAPI_CONSTRAINT_NONZERO] = "nonzero",
+		[KAPI_CONSTRAINT_USER_STRING] = "user_string",
+		[KAPI_CONSTRAINT_USER_PATH] = "user_path",
+		[KAPI_CONSTRAINT_USER_PTR] = "user_ptr",
+		[KAPI_CONSTRAINT_BUFFER] = "buffer",
+		[KAPI_CONSTRAINT_CUSTOM] = "custom",
+	};
+
+	if (type >= ARRAY_SIZE(constraint_names))
+		return "unknown";
+
+	return constraint_names[type];
+}
+
+/*
+ * kapi_json_escape - Write a JSON-escaped string into a buffer
+ * @buf: Output buffer
+ * @size: Remaining space in buffer
+ * @str: Input string to escape
+ *
+ * Escapes backslash, double-quote, and control characters for JSON output.
+ * Return: Number of bytes written (via scnprintf semantics)
+ */
+static int kapi_json_escape(char *buf, size_t size, const char *str)
+{
+	int ret = 0;
+	const char *p;
+
+	if (!str || size == 0)
+		return 0;
+
+	for (p = str; *p && ret < size - 1; p++) {
+		switch (*p) {
+		case '\\':
+			ret += scnprintf(buf + ret, size - ret, "\\\\");
+			break;
+		case '"':
+			ret += scnprintf(buf + ret, size - ret, "\\\"");
+			break;
+		case '\n':
+			ret += scnprintf(buf + ret, size - ret, "\\n");
+			break;
+		case '\r':
+			ret += scnprintf(buf + ret, size - ret, "\\r");
+			break;
+		case '\t':
+			ret += scnprintf(buf + ret, size - ret, "\\t");
+			break;
+		default:
+			if ((unsigned char)*p < 0x20) {
+				ret += scnprintf(buf + ret, size - ret,
+						 "\\u%04x", (unsigned char)*p);
+			} else {
+				ret += scnprintf(buf + ret, size - ret,
+						 "%c", *p);
+			}
+			break;
+		}
+	}
+
+	if (ret < size)
+		buf[ret] = '\0';
+
+	return ret;
+}
+
+static int kapi_json_str(char *buf, size_t size, const char *str)
+{
+	int ret = 0;
+
+	ret += scnprintf(buf, size, "\"");
+	ret += kapi_json_escape(buf + ret, size - ret, str);
+	ret += scnprintf(buf + ret, size - ret, "\"");
+	return ret;
+}
+
+static int kapi_json_s64_list(char *buf, size_t size, const s64 *vals, u32 count)
+{
+	int ret = scnprintf(buf, size, "[");
+	u32 i;
+
+	for (i = 0; vals && i < count; i++)
+		ret += scnprintf(buf + ret, size - ret, "%s%lld",
+				 i ? ", " : "", vals[i]);
+
+	ret += scnprintf(buf + ret, size - ret, "]");
+	return ret;
+}
+
+static int kapi_json_struct_spec(char *buf, size_t size,
+				 const struct kapi_struct_spec *st)
+{
+	int ret;
+	u32 i;
+
+	ret = scnprintf(buf, size, "    {\n      \"name\": ");
+	ret += kapi_json_str(buf + ret, size - ret, st->name);
+	ret += scnprintf(buf + ret, size - ret,
+		",\n      \"size\": %zu,\n      \"alignment\": %zu,\n      \"description\": ",
+		st->size, st->alignment);
+	ret += kapi_json_str(buf + ret, size - ret, st->description);
+	ret += scnprintf(buf + ret, size - ret, ",\n      \"fields\": [\n");
+
+	for (i = 0; i < st->field_count && i < KAPI_MAX_PARAMS; i++) {
+		const struct kapi_struct_field *field = &st->fields[i];
+
+		ret += scnprintf(buf + ret, size - ret,
+			"        {\n          \"name\": ");
+		ret += kapi_json_str(buf + ret, size - ret, field->name);
+		ret += scnprintf(buf + ret, size - ret, ",\n          \"type\": ");
+		ret += kapi_json_str(buf + ret, size - ret, field->type_name);
+		ret += scnprintf(buf + ret, size - ret,
+			",\n"
+			"          \"type_class\": \"%s\",\n"
+			"          \"offset\": %zu,\n"
+			"          \"size\": %zu,\n"
+			"          \"flags\": \"0x%x\",\n"
+			"          \"constraint_type\": \"%s\",\n"
+			"          \"min_value\": %lld,\n"
+			"          \"max_value\": %lld,\n"
+			"          \"valid_mask\": \"0x%llx\",\n"
+			"          \"enum_values\": ",
+			kapi_param_type_to_string(field->type),
+			field->offset, field->size, field->flags,
+			constraint_type_to_string(field->constraint_type),
+			field->min_value, field->max_value, field->valid_mask);
+		ret += kapi_json_str(buf + ret, size - ret, field->enum_values);
+		ret += scnprintf(buf + ret, size - ret,
+			",\n          \"description\": ");
+		ret += kapi_json_str(buf + ret, size - ret, field->description);
+		ret += scnprintf(buf + ret, size - ret,
+			"\n        }%s\n",
+			(i < st->field_count - 1) ? "," : "");
+	}
+
+	ret += scnprintf(buf + ret, size - ret, "      ]\n    }");
+	return ret;
+}
+
+/**
+ * kapi_export_json - Export API specification to JSON format
+ * @spec: API specification to export
+ * @buf: Buffer to write JSON to
+ * @size: Size of buffer
+ *
+ * Return: Number of bytes written, -EINVAL on bad arguments, or -E2BIG
+ * if the output did not fit in @buf (the contents are then incomplete)
+ */
+int kapi_export_json(const struct kernel_api_spec *spec, char *buf, size_t size)
+{
+	int ret = 0;
+	int i, j;
+
+	if (!spec || !buf || size == 0)
+		return -EINVAL;
+
+	ret = scnprintf(buf, size, "{\n  \"name\": ");
+	ret += kapi_json_str(buf + ret, size - ret, spec->name);
+	ret += scnprintf(buf + ret, size - ret,
+			 ",\n  \"version\": %u,\n  \"description\": ",
+			 spec->version);
+	ret += kapi_json_str(buf + ret, size - ret, spec->description);
+	ret += scnprintf(buf + ret, size - ret, ",\n  \"long_description\": ");
+	ret += kapi_json_str(buf + ret, size - ret, spec->long_description);
+	ret += scnprintf(buf + ret, size - ret,
+			 ",\n  \"context_flags\": \"0x%x\",\n",
+			 spec->context_flags);
+
+	/* Parameters */
+	ret += scnprintf(buf + ret, size - ret, "  \"parameters\": [\n");
+
+	for (i = 0; i < spec->param_count && i < KAPI_MAX_PARAMS; i++) {
+		const struct kapi_param_spec *param = &spec->params[i];
+
+		ret += scnprintf(buf + ret, size - ret, "    {\n      \"name\": ");
+		ret += kapi_json_str(buf + ret, size - ret, param->name);
+		ret += scnprintf(buf + ret, size - ret, ",\n      \"type\": ");
+		ret += kapi_json_str(buf + ret, size - ret, param->type_name);
+		ret += scnprintf(buf + ret, size - ret,
+			",\n      \"type_class\": \"%s\",\n      \"flags\": \"0x%x\",\n      \"description\": ",
+			kapi_param_type_to_string(param->type),
+			param->flags);
+		ret += kapi_json_str(buf + ret, size - ret, param->description);
+		ret += scnprintf(buf + ret, size - ret,
+			",\n      \"constraint_type\": \"%s\",\n      \"constraint_desc\": ",
+			constraint_type_to_string(param->constraint_type));
+		ret += kapi_json_str(buf + ret, size - ret, param->constraints);
+		ret += scnprintf(buf + ret, size - ret,
+			",\n"
+			"      \"min_value\": %lld,\n"
+			"      \"max_value\": %lld,\n"
+			"      \"valid_mask\": \"0x%llx\",\n"
+			"      \"enum_values\": ",
+			param->min_value, param->max_value, param->valid_mask);
+		ret += kapi_json_s64_list(buf + ret, size - ret,
+					  param->enum_values, param->enum_count);
+		ret += scnprintf(buf + ret, size - ret,
+			",\n      \"size\": %zu,\n      \"alignment\": %zu,\n      \"size_param_idx\": ",
+			param->size, param->alignment);
+		if (param->size_param_idx > 0)
+			ret += scnprintf(buf + ret, size - ret, "%d",
+					 param->size_param_idx - 1);
+		else
+			ret += scnprintf(buf + ret, size - ret, "null");
+		ret += scnprintf(buf + ret, size - ret,
+			",\n      \"size_multiplier\": %zu\n    }%s\n",
+			param->size_multiplier,
+			(i < spec->param_count - 1) ? "," : "");
+	}
+
+	ret += scnprintf(buf + ret, size - ret, "  ],\n");
+
+	/* Return value */
+	ret += scnprintf(buf + ret, size - ret, "  \"return\": {\n    \"type\": ");
+	ret += kapi_json_str(buf + ret, size - ret, spec->return_spec.type_name);
+	ret += scnprintf(buf + ret, size - ret,
+		",\n"
+		"    \"type_class\": \"%s\",\n"
+		"    \"check_type\": \"%s\",\n"
+		"    \"success_value\": %lld,\n"
+		"    \"success_min\": %lld,\n"
+		"    \"success_max\": %lld,\n"
+		"    \"error_values\": ",
+		kapi_param_type_to_string(spec->return_spec.type),
+		return_check_type_to_string(spec->return_spec.check_type),
+		spec->return_spec.success_value,
+		spec->return_spec.success_min,
+		spec->return_spec.success_max);
+	ret += kapi_json_s64_list(buf + ret, size - ret,
+				  spec->return_spec.error_values,
+				  spec->return_spec.error_count);
+
+	ret += scnprintf(buf + ret, size - ret, ",\n    \"description\": ");
+	ret += kapi_json_str(buf + ret, size - ret, spec->return_spec.description);
+	ret += scnprintf(buf + ret, size - ret, "\n  },\n");
+
+	/* Errors */
+	ret += scnprintf(buf + ret, size - ret, "  \"errors\": [\n");
+
+	for (i = 0; i < spec->error_count && i < KAPI_MAX_ERRORS; i++) {
+		const struct kapi_error_spec *error = &spec->errors[i];
+
+		ret += scnprintf(buf + ret, size - ret,
+			"    {\n      \"code\": %d,\n      \"name\": ",
+			error->error_code);
+		ret += kapi_json_str(buf + ret, size - ret, error->name);
+		ret += scnprintf(buf + ret, size - ret, ",\n      \"condition\": ");
+		ret += kapi_json_str(buf + ret, size - ret, error->condition);
+		ret += scnprintf(buf + ret, size - ret, ",\n      \"description\": ");
+		ret += kapi_json_str(buf + ret, size - ret, error->description);
+		ret += scnprintf(buf + ret, size - ret,
+			"\n    }%s\n",
+			(i < spec->error_count - 1) ? "," : "");
+	}
+
+	ret += scnprintf(buf + ret, size - ret, "  ],\n");
+
+	/* Locks */
+	ret += scnprintf(buf + ret, size - ret, "  \"locks\": [\n");
+
+	for (i = 0; i < spec->lock_count && i < KAPI_MAX_LOCKS; i++) {
+		const struct kapi_lock_spec *lock = &spec->locks[i];
+
+		ret += scnprintf(buf + ret, size - ret, "    {\n      \"name\": ");
+		ret += kapi_json_str(buf + ret, size - ret, lock->lock_name);
+		ret += scnprintf(buf + ret, size - ret,
+			",\n      \"type\": \"%s\",\n      \"scope\": \"%s\",\n      \"description\": ",
+			kapi_lock_type_to_string(lock->lock_type),
+			kapi_lock_scope_to_string(lock->scope));
+		ret += kapi_json_str(buf + ret, size - ret, lock->description);
+		ret += scnprintf(buf + ret, size - ret,
+			"\n    }%s\n",
+			(i < spec->lock_count - 1) ? "," : "");
+	}
+
+	ret += scnprintf(buf + ret, size - ret, "  ],\n");
+
+	/* Capabilities */
+	ret += scnprintf(buf + ret, size - ret, "  \"capabilities\": [\n");
+
+	for (i = 0; i < spec->capability_count && i < KAPI_MAX_CAPABILITIES; i++) {
+		const struct kapi_capability_spec *cap = &spec->capabilities[i];
+
+		ret += scnprintf(buf + ret, size - ret,
+			"    {\n      \"capability\": %d,\n      \"name\": ",
+			cap->capability);
+		ret += kapi_json_str(buf + ret, size - ret, cap->cap_name);
+		ret += scnprintf(buf + ret, size - ret,
+			",\n      \"action\": \"%s\",\n      \"allows\": ",
+			capability_action_to_string(cap->action));
+		ret += kapi_json_str(buf + ret, size - ret, cap->allows);
+		ret += scnprintf(buf + ret, size - ret, ",\n      \"without_cap\": ");
+		ret += kapi_json_str(buf + ret, size - ret, cap->without_cap);
+		ret += scnprintf(buf + ret, size - ret, ",\n      \"check_condition\": ");
+		ret += kapi_json_str(buf + ret, size - ret, cap->check_condition);
+		ret += scnprintf(buf + ret, size - ret, ",\n      \"priority\": %u", cap->priority);
+
+		if (cap->alternative_count > 0) {
+			ret += scnprintf(buf + ret, size - ret,
+				",\n      \"alternatives\": [");
+			for (j = 0; j < cap->alternative_count && j < KAPI_MAX_CAPABILITIES; j++) {
+				ret += scnprintf(buf + ret, size - ret,
+					"%s%d", j ? ", " : "",
+					cap->alternative[j]);
+			}
+			ret += scnprintf(buf + ret, size - ret, "]");
+		}
+
+		ret += scnprintf(buf + ret, size - ret,
+			"\n    }%s\n",
+			(i < spec->capability_count - 1) ? "," : "");
+	}
+
+	ret += scnprintf(buf + ret, size - ret, "  ],\n");
+
+	/* Constraints */
+	ret += scnprintf(buf + ret, size - ret, "  \"constraints\": [\n");
+	for (i = 0; i < spec->constraint_count && i < KAPI_MAX_CONSTRAINTS; i++) {
+		const struct kapi_constraint_spec *con = &spec->constraints[i];
+
+		ret += scnprintf(buf + ret, size - ret, "    {\n      \"name\": ");
+		ret += kapi_json_str(buf + ret, size - ret, con->name);
+		ret += scnprintf(buf + ret, size - ret, ",\n      \"description\": ");
+		ret += kapi_json_str(buf + ret, size - ret, con->description);
+		ret += scnprintf(buf + ret, size - ret, ",\n      \"expression\": ");
+		ret += kapi_json_str(buf + ret, size - ret, con->expression);
+		ret += scnprintf(buf + ret, size - ret,
+			"\n    }%s\n",
+			(i < spec->constraint_count - 1) ? "," : "");
+	}
+	ret += scnprintf(buf + ret, size - ret, "  ],\n");
+
+	/* Signals */
+	ret += scnprintf(buf + ret, size - ret, "  \"signals\": [\n");
+	for (i = 0; i < spec->signal_count && i < KAPI_MAX_SIGNALS; i++) {
+		const struct kapi_signal_spec *sig = &spec->signals[i];
+
+		ret += scnprintf(buf + ret, size - ret,
+			"    {\n      \"signal_num\": %d,\n      \"signal_name\": ",
+			sig->signal_num);
+		ret += kapi_json_str(buf + ret, size - ret, sig->signal_name);
+		ret += scnprintf(buf + ret, size - ret,
+			",\n      \"direction\": \"0x%x\",\n      \"action\": %u,\n      \"target\": ",
+			sig->direction, sig->action);
+		ret += kapi_json_str(buf + ret, size - ret, sig->target);
+		ret += scnprintf(buf + ret, size - ret, ",\n      \"condition\": ");
+		ret += kapi_json_str(buf + ret, size - ret, sig->condition);
+		ret += scnprintf(buf + ret, size - ret, ",\n      \"description\": ");
+		ret += kapi_json_str(buf + ret, size - ret, sig->description);
+		ret += scnprintf(buf + ret, size - ret,
+			",\n"
+			"      \"restartable\": %s,\n"
+			"      \"sa_flags_required\": \"0x%x\",\n"
+			"      \"sa_flags_forbidden\": \"0x%x\",\n"
+			"      \"error_on_signal\": %d,\n"
+			"      \"transform_to\": %d,\n"
+			"      \"timing\": ",
+			sig->restartable ? "true" : "false",
+			sig->sa_flags_required,
+			sig->sa_flags_forbidden,
+			sig->error_on_signal,
+			sig->transform_to);
+		ret += kapi_json_str(buf + ret, size - ret, sig->timing);
+		ret += scnprintf(buf + ret, size - ret,
+			",\n      \"priority\": %u,\n      \"interruptible\": %s,\n      \"queue_behavior\": ",
+			sig->priority,
+			sig->interruptible ? "true" : "false");
+		ret += kapi_json_str(buf + ret, size - ret, sig->queue_behavior);
+		ret += scnprintf(buf + ret, size - ret,
+			",\n      \"state_required\": \"0x%x\",\n      \"state_forbidden\": \"0x%x\"\n    }%s\n",
+			sig->state_required,
+			sig->state_forbidden,
+			(i < spec->signal_count - 1) ? "," : "");
+	}
+	ret += scnprintf(buf + ret, size - ret, "  ],\n");
+
+	/* Side effects */
+	ret += scnprintf(buf + ret, size - ret, "  \"side_effects\": [\n");
+	for (i = 0; i < spec->side_effect_count && i < KAPI_MAX_SIDE_EFFECTS; i++) {
+		const struct kapi_side_effect *eff = &spec->side_effects[i];
+
+		ret += scnprintf(buf + ret, size - ret,
+			"    {\n      \"type\": \"0x%x\",\n      \"target\": ",
+			eff->type);
+		ret += kapi_json_str(buf + ret, size - ret, eff->target);
+		ret += scnprintf(buf + ret, size - ret, ",\n      \"condition\": ");
+		ret += kapi_json_str(buf + ret, size - ret, eff->condition);
+		ret += scnprintf(buf + ret, size - ret, ",\n      \"description\": ");
+		ret += kapi_json_str(buf + ret, size - ret, eff->description);
+		ret += scnprintf(buf + ret, size - ret,
+			",\n      \"reversible\": %s\n    }%s\n",
+			eff->reversible ? "true" : "false",
+			(i < spec->side_effect_count - 1) ? "," : "");
+	}
+	ret += scnprintf(buf + ret, size - ret, "  ],\n");
+
+	/* State transitions */
+	ret += scnprintf(buf + ret, size - ret, "  \"state_transitions\": [\n");
+	for (i = 0; i < spec->state_trans_count && i < KAPI_MAX_STATE_TRANS; i++) {
+		const struct kapi_state_transition *trans = &spec->state_transitions[i];
+
+		ret += scnprintf(buf + ret, size - ret, "    {\n      \"object\": ");
+		ret += kapi_json_str(buf + ret, size - ret, trans->object);
+		ret += scnprintf(buf + ret, size - ret, ",\n      \"from_state\": ");
+		ret += kapi_json_str(buf + ret, size - ret, trans->from_state);
+		ret += scnprintf(buf + ret, size - ret, ",\n      \"to_state\": ");
+		ret += kapi_json_str(buf + ret, size - ret, trans->to_state);
+		ret += scnprintf(buf + ret, size - ret, ",\n      \"condition\": ");
+		ret += kapi_json_str(buf + ret, size - ret, trans->condition);
+		ret += scnprintf(buf + ret, size - ret, ",\n      \"description\": ");
+		ret += kapi_json_str(buf + ret, size - ret, trans->description);
+		ret += scnprintf(buf + ret, size - ret,
+			"\n    }%s\n",
+			(i < spec->state_trans_count - 1) ? "," : "");
+	}
+	ret += scnprintf(buf + ret, size - ret, "  ],\n");
+
+	/* Signal masks */
+	ret += scnprintf(buf + ret, size - ret, "  \"signal_masks\": [\n");
+	for (i = 0; i < spec->signal_mask_count && i < KAPI_MAX_SIGNALS; i++) {
+		const struct kapi_signal_mask_spec *mask = &spec->signal_masks[i];
+
+		ret += scnprintf(buf + ret, size - ret, "    {\n      \"name\": ");
+		ret += kapi_json_str(buf + ret, size - ret, mask->mask_name);
+		ret += scnprintf(buf + ret, size - ret, ",\n      \"description\": ");
+		ret += kapi_json_str(buf + ret, size - ret, mask->description);
+		ret += scnprintf(buf + ret, size - ret, ",\n      \"signals\": [");
+		for (j = 0; j < mask->signal_count && j < KAPI_MAX_SIGNALS; j++)
+			ret += scnprintf(buf + ret, size - ret, "%s%d",
+					 j ? ", " : "", mask->signals[j]);
+		ret += scnprintf(buf + ret, size - ret,
+			"]\n    }%s\n",
+			(i < spec->signal_mask_count - 1) ? "," : "");
+	}
+	ret += scnprintf(buf + ret, size - ret, "  ],\n");
+
+	/* Structure specifications */
+	ret += scnprintf(buf + ret, size - ret, "  \"struct_specs\": [\n");
+	for (i = 0; i < spec->struct_spec_count && i < KAPI_MAX_STRUCT_SPECS; i++) {
+		ret += kapi_json_struct_spec(buf + ret, size - ret,
+					     &spec->struct_specs[i]);
+		ret += scnprintf(buf + ret, size - ret, "%s\n",
+				 (i < spec->struct_spec_count - 1) ? "," : "");
+	}
+	ret += scnprintf(buf + ret, size - ret, "  ],\n");
+
+	/* Additional info */
+	ret += scnprintf(buf + ret, size - ret, "  \"examples\": ");
+	ret += kapi_json_str(buf + ret, size - ret, spec->examples);
+	ret += scnprintf(buf + ret, size - ret, ",\n  \"notes\": ");
+	ret += kapi_json_str(buf + ret, size - ret, spec->notes);
+	ret += scnprintf(buf + ret, size - ret, "\n}\n");
+
+	/* scnprintf() never writes past size - 1, so a full buffer means truncation */
+	if (ret >= size - 1)
+		return -E2BIG;
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(kapi_export_json);
+
+#ifdef CONFIG_KAPI_RUNTIME_CHECKS
+
+/**
+ * kapi_validate_fd - Validate that a file descriptor value is in valid range
+ * @fd: File descriptor to validate
+ *
+ * Only the numeric range is checked: AT_FDCWD or a non-negative value.
+ * Openness is left to the syscall, since the fd can be closed between check
+ * and use. Other negative values are rejected here, so a syscall such as
+ * close() fails with EINVAL for them rather than EBADF.
+ *
+ * Return: true if fd is in valid range, false otherwise
+ */
+static bool kapi_validate_fd(int fd)
+{
+	return fd == AT_FDCWD || fd >= 0;
+}
+
+/**
+ * kapi_validate_user_ptr - Validate that a user pointer is accessible
+ * @ptr: User pointer to validate
+ * @size: Size in bytes to validate
+ *
+ * Return: true if user memory is accessible, false otherwise
+ */
+static bool kapi_validate_user_ptr(const void __user *ptr, size_t size)
+{
+	/* NULL pointers are not valid; caller handles optional case */
+	if (!ptr)
+		return false;
+
+	return access_ok(ptr, size);
+}
+
+/**
+ * kapi_validate_user_ptr_with_params - Validate user pointer with dynamic size
+ * @param_spec: Parameter specification
+ * @ptr: User pointer to validate
+ * @all_params: Array of all parameter values
+ * @param_count: Number of parameters
+ *
+ * Return: true if user memory is accessible, false otherwise
+ */
+static bool kapi_validate_user_ptr_with_params(const struct kapi_param_spec *param_spec,
+						const void __user *ptr,
+						const s64 *all_params,
+						int param_count)
+{
+	size_t actual_size;
+
+	/* NULL is allowed for optional parameters */
+	if (!ptr && (param_spec->flags & KAPI_PARAM_OPTIONAL))
+		return true;
+
+	/*
+	 * size_param_idx is stored 1-based (0 means "no dynamic sizing").
+	 * Convert to a real index before looking into all_params.
+	 */
+	if (param_spec->size_param_idx > 0 &&
+	    param_spec->size_param_idx - 1 < param_count) {
+		s64 count = all_params[param_spec->size_param_idx - 1];
+		size_t unit = param_spec->size_multiplier ?: 1;
+
+		if (count < 0) {
+			pr_warn_ratelimited("Parameter %s: size determinant is negative (%lld)\n",
+				param_spec->name, count);
+			return false;
+		}
+
+		/* A zero-length access never dereferences the pointer */
+		if (count == 0)
+			return true;
+
+		if (count > SIZE_MAX / unit) {
+			pr_warn_ratelimited("Parameter %s: size calculation overflow\n",
+				param_spec->name);
+			return false;
+		}
+
+		actual_size = (size_t)count * unit;
+	} else {
+		actual_size = param_spec->size;
+	}
+
+	return kapi_validate_user_ptr(ptr, actual_size);
+}
+
+/**
+ * kapi_validate_path - Validate that a pathname is accessible and within limits
+ * @path: User pointer to pathname
+ * @param_spec: Parameter specification
+ *
+ * Return: true if path is valid, false otherwise
+ */
+static bool kapi_validate_path(const char __user *path,
+				const struct kapi_param_spec *param_spec)
+{
+	size_t len;
+
+	/* NULL is allowed for optional parameters */
+	if (!path && (param_spec->flags & KAPI_PARAM_OPTIONAL))
+		return true;
+
+	if (!path) {
+		pr_warn_ratelimited("Parameter %s: NULL path not allowed\n", param_spec->name);
+		return false;
+	}
+
+	if (!access_ok(path, 1)) {
+		pr_warn_ratelimited("Parameter %s: path pointer %p not accessible\n",
+			param_spec->name, path);
+		return false;
+	}
+
+	/*
+	 * Use strnlen_user to check the path length and accessibility.
+	 * Note: strnlen_user() is subject to TOCTOU -- the measured length
+	 * may change if another thread modifies the user memory. This is
+	 * acceptable since the kernel re-copies and re-validates the path
+	 * later in the syscall path. This check is best-effort.
+	 */
+	len = strnlen_user(path, PATH_MAX + 1);
+	if (len == 0) {
+		pr_warn_ratelimited("Parameter %s: invalid path pointer %p\n",
+			param_spec->name, path);
+		return false;
+	}
+
+	if (len > PATH_MAX) {
+		pr_warn_ratelimited("Parameter %s: path too long (exceeds PATH_MAX)\n",
+			param_spec->name);
+		return false;
+	}
+
+	return true;
+}
+
+/**
+ * kapi_validate_user_string - Validate a userspace null-terminated string
+ * @str: User pointer to string
+ * @param_spec: Parameter specification containing length constraints
+ *
+ * Validates that the userspace string pointer is accessible and that the
+ * string length (excluding null terminator) is within the range specified
+ * by min_value and max_value in the parameter specification.
+ *
+ * Return: true if string is valid, false otherwise
+ */
+static bool kapi_validate_user_string(const char __user *str,
+				       const struct kapi_param_spec *param_spec)
+{
+	size_t len;
+	size_t max_check_len;
+
+	/* NULL is allowed for optional parameters */
+	if (!str && (param_spec->flags & KAPI_PARAM_OPTIONAL))
+		return true;
+
+	if (!str) {
+		pr_warn_ratelimited("Parameter %s: NULL string not allowed\n", param_spec->name);
+		return false;
+	}
+
+	if (!access_ok(str, 1)) {
+		pr_warn_ratelimited("Parameter %s: string pointer %p not accessible\n",
+			param_spec->name, str);
+		return false;
+	}
+
+	/*
+	 * Use strnlen_user to check the string length and validate accessibility.
+	 * Check up to max_value + 1 to detect strings that are too long.
+	 * If max_value is 0 or unset, use PATH_MAX as a reasonable default.
+	 *
+	 * Note: strnlen_user() is subject to TOCTOU -- see comment in
+	 * kapi_validate_path() above. This check is best-effort.
+	 */
+	max_check_len = param_spec->max_value > 0 ?
+			(size_t)param_spec->max_value + 1 : PATH_MAX + 1;
+	len = strnlen_user(str, max_check_len);
+
+	if (len == 0) {
+		pr_warn_ratelimited("Parameter %s: invalid string pointer %p\n",
+			param_spec->name, str);
+		return false;
+	}
+
+	/*
+	 * strnlen_user returns the length including the null terminator.
+	 * Convert to string length (excluding terminator) for range check.
+	 */
+	len--;
+
+	if (param_spec->min_value > 0 && len < (size_t)param_spec->min_value) {
+		pr_warn_ratelimited("Parameter %s: string too short (%zu < %lld)\n",
+			param_spec->name, len, param_spec->min_value);
+		return false;
+	}
+
+	if (param_spec->max_value > 0 && len > (size_t)param_spec->max_value) {
+		pr_warn_ratelimited("Parameter %s: string too long (%zu > %lld)\n",
+			param_spec->name, len, param_spec->max_value);
+		return false;
+	}
+
+	return true;
+}
+
+/**
+ * kapi_validate_user_ptr_constraint - Validate a userspace pointer with size
+ * @ptr: User pointer to validate
+ * @param_spec: Parameter specification containing size
+ *
+ * Validates that the userspace pointer is accessible and that the memory
+ * region of the specified size can be accessed. The size is taken from
+ * the param_spec->size field.
+ *
+ * Return: true if pointer is valid, false otherwise
+ */
+static bool kapi_validate_user_ptr_constraint(const void __user *ptr,
+					       const struct kapi_param_spec *param_spec)
+{
+	/* NULL is allowed for optional parameters */
+	if (!ptr && (param_spec->flags & KAPI_PARAM_OPTIONAL))
+		return true;
+
+	if (!ptr) {
+		pr_warn_ratelimited("Parameter %s: NULL pointer not allowed\n", param_spec->name);
+		return false;
+	}
+
+	if (param_spec->size == 0) {
+		pr_warn_ratelimited("Parameter %s: size not specified for user pointer validation\n",
+			param_spec->name);
+		return false;
+	}
+
+	if (!access_ok(ptr, param_spec->size)) {
+		pr_warn_ratelimited("Parameter %s: user pointer %p not accessible for %zu bytes\n",
+			param_spec->name, ptr, param_spec->size);
+		return false;
+	}
+
+	return true;
+}
+
+/*
+ * check_user_ptr is false once the pointer was validated against its dynamic
+ * size; the fixed-size check would reject NULL even when that size is 0.
+ */
+static bool kapi_validate_param_checks(const struct kapi_param_spec *param_spec,
+				       s64 value, bool check_user_ptr)
+{
+	int i;
+
+	/* Special handling for file descriptor type */
+	if (param_spec->type == KAPI_TYPE_FD &&
+	    !(param_spec->flags & KAPI_PARAM_OPTIONAL)) {
+		if (value < INT_MIN || value > INT_MAX) {
+			pr_warn_ratelimited("Parameter %s: file descriptor %lld out of int range\n",
+				param_spec->name, value);
+			return false;
+		}
+		if (!kapi_validate_fd((int)value)) {
+			pr_warn_ratelimited("Parameter %s: invalid file descriptor %lld\n",
+				param_spec->name, value);
+			return false;
+		}
+	}
+
+	/* Special handling for user pointer type */
+	if (check_user_ptr && param_spec->type == KAPI_TYPE_USER_PTR) {
+		const void __user *ptr = (const void __user *)(unsigned long)value;
+
+		/* NULL is allowed for optional parameters */
+		if (!ptr && (param_spec->flags & KAPI_PARAM_OPTIONAL))
+			return true;
+
+		if (!kapi_validate_user_ptr(ptr, param_spec->size)) {
+			pr_warn_ratelimited("Parameter %s: invalid user pointer %p (size: %zu)\n",
+				param_spec->name, ptr, param_spec->size);
+			return false;
+		}
+	}
+
+	/* Special handling for path type */
+	if (param_spec->type == KAPI_TYPE_PATH) {
+		const char __user *path = (const char __user *)(unsigned long)value;
+
+		if (!kapi_validate_path(path, param_spec))
+			return false;
+	}
+
+	switch (param_spec->constraint_type) {
+	case KAPI_CONSTRAINT_NONE:
+	case KAPI_CONSTRAINT_BUFFER:
+		return true;
+
+	case KAPI_CONSTRAINT_RANGE:
+		/*
+		 * If max_value is below min_value, it was likely set from an
+		 * unsigned constant (e.g. SIZE_MAX) that overflowed s64.  Treat
+		 * as no upper bound; only check the minimum.
+		 */
+		if (param_spec->max_value >= param_spec->min_value) {
+			if (value < param_spec->min_value ||
+			    value > param_spec->max_value) {
+				pr_warn_ratelimited("Parameter %s value %lld out of range [%lld, %lld]\n",
+					param_spec->name, value,
+					param_spec->min_value,
+					param_spec->max_value);
+				return false;
+			}
+		} else {
+			if (value < param_spec->min_value) {
+				pr_warn_ratelimited("Parameter %s value %lld below minimum %lld\n",
+					param_spec->name, value,
+					param_spec->min_value);
+				return false;
+			}
+		}
+		return true;
+
+	case KAPI_CONSTRAINT_MASK:
+		if (value & ~param_spec->valid_mask) {
+			pr_warn_ratelimited("Parameter %s value 0x%llx contains invalid bits (valid mask: 0x%llx)\n",
+				param_spec->name, value, param_spec->valid_mask);
+			return false;
+		}
+		return true;
+
+	case KAPI_CONSTRAINT_ENUM:
+		if (!param_spec->enum_values || param_spec->enum_count == 0)
+			return true;
+
+		for (i = 0; i < param_spec->enum_count; i++) {
+			if (value == param_spec->enum_values[i])
+				return true;
+		}
+		pr_warn_ratelimited("Parameter %s value %lld not in valid enumeration\n",
+			param_spec->name, value);
+		return false;
+
+	case KAPI_CONSTRAINT_ALIGNMENT:
+		if (param_spec->alignment == 0) {
+			pr_warn_ratelimited("Parameter %s: alignment constraint specified but alignment is 0\n",
+				param_spec->name);
+			return false;
+		}
+		if (param_spec->alignment & (param_spec->alignment - 1)) {
+			pr_warn_ratelimited("Parameter %s: alignment %zu is not a power of two\n",
+				param_spec->name, param_spec->alignment);
+			return false;
+		}
+		if (value & (param_spec->alignment - 1)) {
+			pr_warn_ratelimited("Parameter %s value 0x%llx not aligned to %zu boundary\n",
+				param_spec->name, value, param_spec->alignment);
+			return false;
+		}
+		return true;
+
+	case KAPI_CONSTRAINT_POWER_OF_TWO:
+		if (value == 0 || (value & (value - 1))) {
+			pr_warn_ratelimited("Parameter %s value %lld is not a power of two\n",
+				param_spec->name, value);
+			return false;
+		}
+		return true;
+
+	case KAPI_CONSTRAINT_PAGE_ALIGNED:
+		if (value & (PAGE_SIZE - 1)) {
+			pr_warn_ratelimited("Parameter %s value 0x%llx not page-aligned (PAGE_SIZE=%ld)\n",
+				param_spec->name, value, PAGE_SIZE);
+			return false;
+		}
+		return true;
+
+	case KAPI_CONSTRAINT_NONZERO:
+		if (value == 0) {
+			pr_warn_ratelimited("Parameter %s must be non-zero\n", param_spec->name);
+			return false;
+		}
+		return true;
+
+	case KAPI_CONSTRAINT_USER_STRING:
+		return kapi_validate_user_string((const char __user *)(unsigned long)value,
+						 param_spec);
+
+	case KAPI_CONSTRAINT_USER_PATH:
+		return kapi_validate_path((const char __user *)(unsigned long)value, param_spec);
+
+	case KAPI_CONSTRAINT_USER_PTR:
+		return kapi_validate_user_ptr_constraint((const void __user *)(unsigned long)value,
+							 param_spec);
+
+	case KAPI_CONSTRAINT_CUSTOM:
+		if (param_spec->validate)
+			return param_spec->validate(value);
+		return true;
+
+	default:
+		return true;
+	}
+}
+
+/**
+ * kapi_validate_param - Validate a parameter against its specification
+ * @param_spec: Parameter specification
+ * @value: Parameter value to validate
+ *
+ * Return: true if valid, false otherwise
+ */
+bool kapi_validate_param(const struct kapi_param_spec *param_spec, s64 value)
+{
+	return kapi_validate_param_checks(param_spec, value, true);
+}
+EXPORT_SYMBOL_GPL(kapi_validate_param);
+
+/**
+ * kapi_validate_param_with_context - Validate parameter with access to all params
+ * @param_spec: Parameter specification
+ * @value: Parameter value to validate
+ * @all_params: Array of all parameter values
+ * @param_count: Number of parameters
+ *
+ * Return: true if valid, false otherwise
+ */
+bool kapi_validate_param_with_context(const struct kapi_param_spec *param_spec,
+				       s64 value, const s64 *all_params, int param_count)
+{
+	/* Special handling for user pointer type with dynamic sizing */
+	if (param_spec->type == KAPI_TYPE_USER_PTR) {
+		const void __user *ptr = (const void __user *)(unsigned long)value;
+
+		/* NULL is allowed for optional parameters */
+		if (!ptr && (param_spec->flags & KAPI_PARAM_OPTIONAL))
+			return true;
+
+		if (!kapi_validate_user_ptr_with_params(param_spec, ptr, all_params, param_count)) {
+			pr_warn_ratelimited("Parameter %s: invalid user pointer %p\n",
+				param_spec->name, ptr);
+			return false;
+		}
+		return kapi_validate_param_checks(param_spec, value, false);
+	}
+
+	/* For other types, fall back to regular validation */
+	return kapi_validate_param(param_spec, value);
+}
+EXPORT_SYMBOL_GPL(kapi_validate_param_with_context);
+
+/**
+ * kapi_validate_syscall_params - Validate all syscall parameters together
+ * @spec: API specification
+ * @params: Array of parameter values
+ * @param_count: Number of parameters
+ *
+ * Return: -EINVAL if any parameter is invalid, 0 if all valid
+ */
+int kapi_validate_syscall_params(const struct kernel_api_spec *spec,
+				 const s64 *params, int param_count)
+{
+	int i;
+
+	if (!spec || !params)
+		return 0;
+
+	/* Validate that we have the expected number of parameters */
+	if (param_count != spec->param_count) {
+		pr_warn_ratelimited("API %s: parameter count mismatch (expected %u, got %d)\n",
+			spec->name, spec->param_count, param_count);
+		return -EINVAL;
+	}
+
+	/* Validate each parameter with context */
+	for (i = 0; i < spec->param_count && i < KAPI_MAX_PARAMS; i++) {
+		const struct kapi_param_spec *param_spec = &spec->params[i];
+
+		if (!kapi_validate_param_with_context(param_spec, params[i], params, param_count)) {
+			if (strncmp(spec->name, "sys_", 4) == 0) {
+				/* For syscalls, we can return EINVAL to userspace */
+				return -EINVAL;
+			}
+		}
+	}
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(kapi_validate_syscall_params);
+
+/**
+ * kapi_check_return_success - Check if return value indicates success
+ * @return_spec: Return specification
+ * @retval: Return value to check
+ *
+ * Return: true if the return value indicates success according to the spec.
+ */
+bool kapi_check_return_success(const struct kapi_return_spec *return_spec, s64 retval)
+{
+	u32 i;
+
+	if (!return_spec)
+		return true;
+
+	switch (return_spec->check_type) {
+	case KAPI_RETURN_EXACT:
+		return retval == return_spec->success_value;
+
+	case KAPI_RETURN_RANGE:
+		return retval >= return_spec->success_min &&
+		       retval <= return_spec->success_max;
+
+	case KAPI_RETURN_ERROR_CHECK:
+		/* Success if NOT in error list */
+		if (return_spec->error_values) {
+			for (i = 0; i < return_spec->error_count; i++) {
+				if (retval == return_spec->error_values[i])
+					return false;
+			}
+		}
+		return true;
+
+	case KAPI_RETURN_FD:
+		/* File descriptors: >= 0 is success, < 0 is error */
+		return retval >= 0;
+
+	case KAPI_RETURN_CUSTOM:
+		if (return_spec->is_success)
+			return return_spec->is_success(retval);
+		fallthrough;
+
+	default:
+		return true;
+	}
+}
+EXPORT_SYMBOL_GPL(kapi_check_return_success);
+
+/**
+ * kapi_validate_return_value - Validate that return value matches spec
+ * @spec: API specification
+ * @retval: Return value to validate
+ *
+ * Return: false if the spec is a KAPI_RETURN_FD check and a successful @retval
+ * is not a valid file descriptor, true otherwise.
+ *
+ * kapi_check_return_success() runs first. A value that does not satisfy it is
+ * treated as an error and is accepted. An error code that is not listed in the
+ * spec is only logged with pr_debug().
+ */
+bool kapi_validate_return_value(const struct kernel_api_spec *spec, s64 retval)
+{
+	int i;
+	bool is_success;
+
+	if (!spec)
+		return true; /* No spec means we can't validate */
+
+	/* First check if this is a success return */
+	is_success = kapi_check_return_success(&spec->return_spec, retval);
+
+	if (is_success) {
+		/* Special validation for file descriptor returns */
+		if (spec->return_spec.check_type == KAPI_RETURN_FD) {
+			if (retval > INT_MAX || !kapi_validate_fd((int)retval)) {
+				pr_warn_ratelimited("API %s returned invalid file descriptor %lld\n",
+					spec->name, retval);
+				return false;
+			}
+		}
+		return true;
+	}
+
+	if (spec->error_count == 0) {
+		pr_debug("API %s returned unspecified error %lld\n",
+			 spec->name, retval);
+		return true;
+	}
+
+	for (i = 0; i < spec->error_count && i < KAPI_MAX_ERRORS; i++) {
+		if (retval == spec->errors[i].error_code)
+			return true;
+	}
+
+	/*
+	 * Error not in spec - log at debug level since filesystem-specific and
+	 * device-specific error codes may not be exhaustively listed.
+	 */
+	pr_debug("API %s returned error code %lld not listed in spec\n",
+		 spec->name, retval);
+
+	return true;
+}
+EXPORT_SYMBOL_GPL(kapi_validate_return_value);
+
+/**
+ * kapi_validate_syscall_return - Validate syscall return value
+ * @spec: API specification
+ * @retval: Return value
+ *
+ * Return: always 0. A return value that does not match the spec is only
+ * logged and the syscall result is left unchanged.
+ */
+int kapi_validate_syscall_return(const struct kernel_api_spec *spec, s64 retval)
+{
+	if (!spec)
+		return 0;
+
+	/* Skip return validation if return spec was not defined */
+	if (spec->return_magic != KAPI_MAGIC_RETURN)
+		return 0;
+
+	if (!kapi_validate_return_value(spec, retval)) {
+		/* Log the violation but don't change the return value */
+		pr_warn_ratelimited("KAPI: Syscall %s returned unspecified value %lld\n",
+				    spec->name, retval);
+	}
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(kapi_validate_syscall_return);
+
+/**
+ * kapi_check_context - Check if current context matches API requirements
+ * @spec: API specification to check against
+ */
+void kapi_check_context(const struct kernel_api_spec *spec)
+{
+	bool valid = false;
+	u32 ctx;
+
+	if (!spec)
+		return;
+
+	ctx = spec->context_flags;
+
+	if (!ctx)
+		return;
+
+	/* Check if we're in an allowed context */
+	if ((ctx & KAPI_CTX_PROCESS) && !in_interrupt())
+		valid = true;
+
+	if ((ctx & KAPI_CTX_SOFTIRQ) && in_softirq())
+		valid = true;
+
+	if ((ctx & KAPI_CTX_HARDIRQ) && in_hardirq())
+		valid = true;
+
+	if ((ctx & KAPI_CTX_NMI) && in_nmi())
+		valid = true;
+
+	if (!valid)
+		WARN_ONCE(1, "API %s called from invalid context\n", spec->name);
+
+	/* Check specific requirements */
+	if ((ctx & KAPI_CTX_ATOMIC) && preemptible())
+		WARN_ONCE(1, "API %s requires atomic context\n", spec->name);
+
+	if ((ctx & KAPI_CTX_SLEEPABLE) && !preemptible())
+		WARN_ONCE(1, "API %s requires sleepable context\n", spec->name);
+}
+EXPORT_SYMBOL_GPL(kapi_check_context);
+
+#endif /* CONFIG_KAPI_RUNTIME_CHECKS */
-- 
2.53.0

