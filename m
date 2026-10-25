Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792946843;
	b=M8/KRQnoQaMmT6DGVF/BH1F2SV8XzPR6s+72iWTOBsslPXcAEdFXIqlhKkbjTSVDUFhZ
	 uWr0J5FoEyywBcSUXqPAX6uWsj8klH54bJY3Luzz9KC1ao7/IOQB0KY5yxhUCg+btCIBo
	 jPGpoZdqX+HYDxPSlfjefmyAUjzKQTp5xOYyfMyD2EKwN3L2t2BGUfBEBrPqkcN5dxasn
	 qedz1tNPqd9Q9/IXpBCBreyEjmy7EFZoBhQ2fPVEXVvBE8YMaz88gkGB9aQ1gNhSvysEU
	 IXnwcDBnbbbQIUk7Pk5qZqdeqBEpELgFpBqfgS3hL/GhM9QGUmVHmSAapiJXtauadlA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792946843;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 MIME-Version:Content-Transfer-Encoding;
	bh=VKSqiYoNV2dByJKpxVMj7QeloSi8EsWCiTvTbPWvl+0=;
	b=0H91vtbDxBzB8szVQ5y8NAFN0FWoVS/5JnWwZm3lG6CIBtp+WcXQjwRplTn2Nh8gcKbF
	 q+u9rZpLzGeiqugJ8jb4VnBT71ElUj7RtfbCS+XENitX0U69LQEkQc9sPL466jadmes/N
	 SeiocFz5S60hTiHCejEbv3j/x5RYxtZ51atU7NjdZps37shaKDGToYWEQ8gOr0gCln/Ee
	 2o7UUeQYmFoB3QiAhg0iVzXvfSj4Cpa/U/f++xosovB7x47PXyEnQX8hcZv1rgwSDoFQu
	 QUbeWHPflfgSrCYJnImJtZ/63QmKmjiJI3bKPEOYu2Ic1syrvkwjNeX2bJ8QOBz135A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=f5b5Tin9;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1FFF606A31A;
	Sun, 25 Oct 2026 16:47:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=f5b5Tin9
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F4E51F01825;
	Sun, 25 Oct 2026 16:47:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792946842;
	bh=VKSqiYoNV2dByJKpxVMj7QeloSi8EsWCiTvTbPWvl+0=;
	h=From:To:Cc:Subject:Date;
	b=f5b5Tin9u2Wpyny2CDyLlZaIlurlFe2XXMxLakNe+IPOrn4Y+19ADTdhEUpoU+LrM
	 bIfLv+Yob6sndJJJx+MRVaZS1hhH4m3bed/pU161JpQVPldd38sAOPxnNu4MrS1JES
	 xWRxAqIlNavZlXlmUBaPVq7FDd+A+q/nAW1js5khsevfP0zmUUX1YbP93Z+6PJfhOe
	 nsIFcrjNt9TkGcd+bwQ54H61xakInzU2jsst8wYritKNi0RE8kmz7xYvYYOIC52zlg
	 4HS3FX914Z+C5z89uDVOih834gZUeEtX/1I2J7nuPxxk1md7gW9gBlVmZRpd2i/IfL
	 8cLSosHxbjNVw==
From: Sasha Levin <sashal@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Sasha Levin <sashal@kernel.org>,
	linux-kernel@vger.kernel.org,
	linux-api@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kbuild@vger.kernel.org,
	linux-doc@vger.kernel.org,
	Christian Brauner <brauner@kernel.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Nathan Chancellor <nathan@kernel.org>,
	Nicolas Schier <nsc@kernel.org>,
	Thomas Gleixner <tglx@kernel.org>,
	Mark Brown <broonie@kernel.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [GIT PULL] Kernel API specification framework for v7.4
Date: Sun, 25 Oct 2026 12:47:19 -0400
Message-ID: <20261025164719.1831477-1-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
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

Hi Linus,

Please consider pulling the kernel API specification framework. It has
been discussed on the lists for over a year: five RFC rounds starting in
June 2025, then v1 through v5 this year, the last on October 8:

  https://lore.kernel.org/all/20261008084956.2911790-1-sashal@kernel.org/

The branch has been in linux-next since next-20261009. I held off on
sending this until the first week of the merge window was over, to let
things calm down.

There are two conflicts with what you already merged. linux-next resolved
both the same way:

 - Makefile: kbuild added '*.header-check' to the clean rule at the same
   spot where this adds '*.apispec.h'. Keep both lines.

 - fs/open.c: vfs added filp_close_sync() just above sys_close(), which is
   where this adds the sys_close() kerneldoc. Keep filp_close_sync(), then
   the new kerneldoc, then the existing "Careful here!" comment and
   SYSCALL_DEFINE1(close).

The following changes since commit a90ee4305c4a5df72c11b31dacfdc76e00fcf78a:

  Linux 7.3-rc6 (2026-10-04 13:45:25 -0700)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/sashal/kapi.git tags/kapi-7.4

for you to fetch changes up to ef777ef05ebcc5ea5393b4bd5af6fc3ad1b3aec9:

  kernel/api: add syscall enter/exit tracepoints (2026-10-07 18:26:44 -0400)

----------------------------------------------------------------
Kernel API specification framework for v7.4

The contract of a kernel interface (which arguments are valid, which errors
come back and why, what context it can be called from, what it locks and
what it changes) only exists as prose in man pages and comments, which
tools cannot check. This adds a way to write that contract down in a form
that tools can consume, next to the code it describes.

A spec is structured kerneldoc covering parameter types and constraints,
return values and error codes, execution context, locking, signals,
capabilities and side effects. At build time kernel-doc turns it into C
data in a dedicated section of vmlinux. From there a spec can be:

 - checked against syscall arguments and return values at runtime by
   CONFIG_KAPI_RUNTIME_CHECKS, a DEBUG_KERNEL option for x86 and arches
   without syscall wrappers; a call that violates its spec fails with
   -EINVAL before the handler runs
 - read as JSON from debugfs
 - extracted from vmlinux, debugfs or the source with tools/kapi, which
   emits JSON, RST or plain text
 - followed with the kapi_syscall_enter/exit tracepoints

The first specs cover open, close, read, write and madvise, with a KUnit
suite and a selftest in tools/testing/selftests/kapi.

Everything is behind CONFIG_KAPI_SPEC, which defaults to off. With it off
the syscall definition macros expand as before, kernel-doc output is
unchanged, and the only change to fs/ and mm/ is the kerneldoc text.

----------------------------------------------------------------
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

 .gitignore                                       |    1 +
 Documentation/dev-tools/index.rst                |    1 +
 Documentation/dev-tools/kernel-api-spec.rst      |  648 +++++
 MAINTAINERS                                      |   13 +
 Makefile                                         |    1 +
 arch/x86/include/asm/syscall_wrapper.h           |    3 +-
 fs/open.c                                        |  557 ++++
 fs/read_write.c                                  |  710 +++++
 include/asm-generic/vmlinux.lds.h                |   14 +
 include/linux/kapi_syscall.h                     |   35 +
 include/linux/kernel_api_spec.h                  | 1226 ++++++++
 include/linux/syscalls.h                         |   42 +-
 include/trace/events/kapi.h                      |   74 +
 init/Kconfig                                     |    2 +
 kernel/Makefile                                  |    1 +
 kernel/api/Kconfig                               |   74 +
 kernel/api/Makefile                              |   13 +
 kernel/api/internal.h                            |   25 +
 kernel/api/kapi_debugfs.c                        |  553 ++++
 kernel/api/kapi_kunit.c                          |  720 +++++
 kernel/api/kernel_api_spec.c                     | 1470 ++++++++++
 mm/madvise.c                                     |  549 ++++
 scripts/Makefile.build                           |   26 +
 tools/docs/kernel-doc                            |   12 +-
 tools/kapi/.gitignore                            |    3 +
 tools/kapi/Cargo.lock                            |  679 +++++
 tools/kapi/Cargo.toml                            |   20 +
 tools/kapi/Makefile                              |   33 +
 tools/kapi/README.md                             |   33 +
 tools/kapi/src/extractor/debugfs.rs              | 1704 +++++++++++
 tools/kapi/src/extractor/kerneldoc_parser.rs     | 3335 ++++++++++++++++++++++
 tools/kapi/src/extractor/mod.rs                  |  442 +++
 tools/kapi/src/extractor/source_parser.rs        |  531 ++++
 tools/kapi/src/extractor/vmlinux/binary_utils.rs |  461 +++
 tools/kapi/src/extractor/vmlinux/mod.rs          | 1160 ++++++++
 tools/kapi/src/formatter/json.rs                 |  659 +++++
 tools/kapi/src/formatter/mod.rs                  |  220 ++
 tools/kapi/src/formatter/plain.rs                |  679 +++++
 tools/kapi/src/formatter/rst.rs                  |  802 ++++++
 tools/kapi/src/main.rs                           |  123 +
 tools/lib/python/kdoc/kdoc_apispec.py            | 1391 +++++++++
 tools/lib/python/kdoc/kdoc_files.py              |   12 +-
 tools/lib/python/kdoc/kdoc_parser.py             |  101 +-
 tools/testing/selftests/Makefile                 |    1 +
 tools/testing/selftests/kapi/.gitignore          |    2 +
 tools/testing/selftests/kapi/Makefile            |    7 +
 tools/testing/selftests/kapi/kapi_test_util.h    |   31 +
 tools/testing/selftests/kapi/test_kapi.c         | 1163 ++++++++
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
Thanks,
Sasha
