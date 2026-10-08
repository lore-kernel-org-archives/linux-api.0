Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 763EF46C843;
	Thu,  8 Oct 2026 08:50:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791449469; cv=none; b=VXSLHkrSbIcjCbEjUn0fqSpHRX1PRre2tF0UVb8Bkc+MY7JYBQMMBFB9pOP/fs0xOgy5zxOmDhyojkIX5nomERSzPHluq0hCPYRafTzF43tpr1O8VsXyNSodOk4EpdyI6G9GH8nXwclrHhNKKfDgLC+CxZWnui9r5+hOiE96Tvw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791449469; c=relaxed/simple;
	bh=ZX9S4gJHS+A5rDZTB2T7QeFso6qPQkfOgOSHk57Xk0A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=EbzYdlNIrTl+T+qj+7p5+P6xmgihCArHx67olQOP7TNTskvkpVeyJh7CXcBvTaZu1pIr8WJwKod1crmZjMw1TRj4hzIACuliZifA5AZBhrC3KtIKilWMkT/r9fj6tHySCV/f9X+U2+jpA4In1CsMb6AC8Y32ZOEFDN7IyKbZoOA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=D24vgNXQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="D24vgNXQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 686BC1F000FF;
	Thu,  8 Oct 2026 08:50:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791449442;
	bh=KUSB5DBE2skQF43PT5MrznyX1fA+tq77putovDNpO7M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=D24vgNXQSCgFzNlPeX9Xh2VS8LTroLkCzM0N1Etw4D8xbCoJatYSu8Uz4J00hM/KD
	 uSCecKF959ut+StvY35+xKWYG/y9x49yWqiPYxJwSR9XnD5VBb1FT2GOxTwk3sHt1Z
	 RmeQiwy5T6AYiynyskCr1ee/YwffjAMzJ7dSsTJ91EdHdRM9hhnUzB258aCJj8NlMp
	 AOjO+HWv68yL9oFBmwWPennzMOeq172eb4S1DjO+mMy8CVGubeKdEHOui85CnbnQLx
	 kCEiwLKsZpRMM2Dxv0FjLOscAtnrEiZlg07lDhqss7YIrqsvXIu9PKDMy0Mr+C3FVv
	 qwkchMHz0yC4g==
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
Subject: [PATCH v5 04/11] tools/kapi: add kernel API specification extraction tool
Date: Thu,  8 Oct 2026 04:49:44 -0400
Message-ID: <20261008084956.2911790-5-sashal@kernel.org>
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

The kapi tool extracts and renders kernel API specifications from
three input sources and emits them in one of three output formats:

  Input modes:
    --source PATH    parse kerneldoc blocks from a C source file or
                     directory
    --vmlinux PATH   decode the `.kapi_specs` ELF section from a
                     compiled kernel binary
    --debugfs PATH   read the spec dumps exposed under
                     /sys/kernel/debug/kapi/ on a running kernel

  Output formats: plain, json, rst

The tool is written in Rust and builds with cargo from the crates
pinned in Cargo.lock; the resulting binary has no runtime
dependencies. It ships alongside the kernel to give documentation
tools, static analyzers, and IDE integrations a single entry point for
querying the spec data produced by the framework.

Assisted-by: LLM
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/dev-tools/kernel-api-spec.rst   |   74 +-
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
 17 files changed, 10886 insertions(+), 72 deletions(-)
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

diff --git a/Documentation/dev-tools/kernel-api-spec.rst b/Documentation/dev-tools/kernel-api-spec.rst
index fa8aabb92a503..95b72060f8ef8 100644
--- a/Documentation/dev-tools/kernel-api-spec.rst
+++ b/Documentation/dev-tools/kernel-api-spec.rst
@@ -31,7 +31,8 @@ The framework aims to:
    common programming errors during development and testing.
 
 3. **Support Tooling**: Export API specifications in machine-readable formats for
-   use by static analyzers, documentation generators, and development tools.
+   use by static analyzers, documentation generators, and development tools. See
+   `The kapi Tool`_.
 
 4. **Formalize Contracts**: Explicitly document API contracts including parameter
    constraints, execution contexts, locking requirements, and side effects.
@@ -573,77 +574,6 @@ The tool supports all KAPI specification types:
 - System calls (kerneldoc annotations)
 - Kernel functions (kerneldoc annotations with KAPI tags)
 
-IDE Integration
----------------
-
-Modern IDEs can use the specification data for:
-
-- Parameter hints
-- Type checking
-- Context validation
-- Error code documentation
-
-Best Practices
-==============
-
-Writing Specifications
-----------------------
-
-1. **Be Comprehensive**: Document all parameters, errors, and side effects
-2. **Keep Updated**: Update specs when API behavior changes
-3. **Use Examples**: Include usage examples in descriptions
-4. **Validate Constraints**: Define realistic constraints for parameters
-5. **Document Context**: Clearly specify allowed execution contexts
-
-Maintenance
------------
-
-1. **Version Specifications**: Increment version when API changes
-2. **Deprecation**: Mark deprecated APIs and suggest replacements
-3. **Cross-reference**: Link related APIs in descriptions
-4. **Test Specifications**: Verify specs match implementation
-
-Common Patterns
----------------
-
-**Optional Parameters**:
-
-.. code-block:: c
-
-    /**
-     * @optional_arg: Optional argument (may be NULL)
-     *
-     * param: optional_arg
-     *   type: KAPI_TYPE_PTR
-     *   flags: KAPI_PARAM_IN | KAPI_PARAM_OPTIONAL
-     */
-
-**Buffer with Size Parameter**:
-
-.. code-block:: c
-
-    /**
-     * @buf: User-space buffer
-     *
-     * param: buf
-     *   type: KAPI_TYPE_USER_PTR
-     *   flags: KAPI_PARAM_OUT | KAPI_PARAM_USER
-     *   constraint-type: KAPI_CONSTRAINT_BUFFER
-     *   size-param: 2
-     */
-
-**Callback Functions**:
-
-.. code-block:: c
-
-    /**
-     * @callback: Callback function
-     *
-     * param: callback
-     *   type: KAPI_TYPE_FUNC_PTR
-     *   flags: KAPI_PARAM_IN
-     */
-
 Troubleshooting
 ===============
 
diff --git a/tools/kapi/.gitignore b/tools/kapi/.gitignore
new file mode 100644
index 0000000000000..fa95032ed6c2a
--- /dev/null
+++ b/tools/kapi/.gitignore
@@ -0,0 +1,3 @@
+# Rust build artifacts
+/target/
+**/*.rs.bk
diff --git a/tools/kapi/Cargo.lock b/tools/kapi/Cargo.lock
new file mode 100644
index 0000000000000..23d4ef8b910d2
--- /dev/null
+++ b/tools/kapi/Cargo.lock
@@ -0,0 +1,679 @@
+# This file is automatically @generated by Cargo.
+# It is not intended for manual editing.
+version = 4
+
+[[package]]
+name = "aho-corasick"
+version = "1.1.4"
+source = "registry+https://github.com/rust-lang/crates.io-index"
+checksum = "ddd31a130427c27518df266943a5308ed92d4b226cc639f5a8f1002816174301"
+dependencies = [
+ "memchr",
+]
+
+[[package]]
+name = "anstream"
+version = "1.0.0"
+source = "registry+https://github.com/rust-lang/crates.io-index"
+checksum = "824a212faf96e9acacdbd09febd34438f8f711fb84e09a8916013cd7815ca28d"
+dependencies = [
+ "anstyle",
+ "anstyle-parse",
+ "anstyle-query",
+ "anstyle-wincon",
+ "colorchoice",
+ "is_terminal_polyfill",
+ "utf8parse",
+]
+
+[[package]]
+name = "anstyle"
+version = "1.0.14"
+source = "registry+https://github.com/rust-lang/crates.io-index"
+checksum = "940b3a0ca603d1eade50a4846a2afffd5ef57a9feac2c0e2ec2e14f9ead76000"
+
+[[package]]
+name = "anstyle-parse"
+version = "1.0.0"
+source = "registry+https://github.com/rust-lang/crates.io-index"
+checksum = "52ce7f38b242319f7cabaa6813055467063ecdc9d355bbb4ce0c68908cd8130e"
+dependencies = [
+ "utf8parse",
+]
+
+[[package]]
+name = "anstyle-query"
+version = "1.1.5"
+source = "registry+https://github.com/rust-lang/crates.io-index"
+checksum = "40c48f72fd53cd289104fc64099abca73db4166ad86ea0b4341abe65af83dadc"
+dependencies = [
+ "windows-sys",
+]
+
+[[package]]
+name = "anstyle-wincon"
+version = "3.0.11"
+source = "registry+https://github.com/rust-lang/crates.io-index"
+checksum = "291e6a250ff86cd4a820112fb8898808a366d8f9f58ce16d1f538353ad55747d"
+dependencies = [
+ "anstyle",
+ "once_cell_polyfill",
+ "windows-sys",
+]
+
+[[package]]
+name = "anyhow"
+version = "1.0.102"
+source = "registry+https://github.com/rust-lang/crates.io-index"
+checksum = "7f202df86484c868dbad7eaa557ef785d5c66295e41b460ef922eca0723b842c"
+
+[[package]]
+name = "bitflags"
+version = "2.11.1"
+source = "registry+https://github.com/rust-lang/crates.io-index"
+checksum = "c4512299f36f043ab09a583e57bceb5a5aab7a73db1805848e8fef3c9e8c78b3"
+
+[[package]]
+name = "cfg-if"
+version = "1.0.4"
+source = "registry+https://github.com/rust-lang/crates.io-index"
+checksum = "9330f8b2ff13f34540b44e946ef35111825727b38d33286ef986142615121801"
+
+[[package]]
+name = "clap"
+version = "4.6.1"
+source = "registry+https://github.com/rust-lang/crates.io-index"
+checksum = "1ddb117e43bbf7dacf0a4190fef4d345b9bad68dfc649cb349e7d17d28428e51"
+dependencies = [
+ "clap_builder",
+ "clap_derive",
+]
+
+[[package]]
+name = "clap_builder"
+version = "4.6.0"
+source = "registry+https://github.com/rust-lang/crates.io-index"
+checksum = "714a53001bf66416adb0e2ef5ac857140e7dc3a0c48fb28b2f10762fc4b5069f"
+dependencies = [
+ "anstream",
+ "anstyle",
+ "clap_lex",
+ "strsim",
+]
+
+[[package]]
+name = "clap_derive"
+version = "4.6.1"
+source = "registry+https://github.com/rust-lang/crates.io-index"
+checksum = "f2ce8604710f6733aa641a2b3731eaa1e8b3d9973d5e3565da11800813f997a9"
+dependencies = [
+ "heck",
+ "proc-macro2",
+ "quote",
+ "syn",
+]
+
+[[package]]
+name = "clap_lex"
+version = "1.1.0"
+source = "registry+https://github.com/rust-lang/crates.io-index"
+checksum = "c8d4a3bb8b1e0c1050499d1815f5ab16d04f0959b233085fb31653fbfc9d98f9"
+
+[[package]]
+name = "colorchoice"
+version = "1.0.5"
+source = "registry+https://github.com/rust-lang/crates.io-index"
+checksum = "1d07550c9036bf2ae0c684c4297d503f838287c83c53686d05370d0e139ae570"
+
+[[package]]
+name = "equivalent"
+version = "1.0.2"
+source = "registry+https://github.com/rust-lang/crates.io-index"
+checksum = "877a4ace8713b0bcf2a4e7eec82529c029f1d0619886d18145fea96c3ffe5c0f"
+
+[[package]]
+name = "errno"
+version = "0.3.14"
+source = "registry+https://github.com/rust-lang/crates.io-index"
+checksum = "39cab71617ae0d63f51a36d69f866391735b51691dbda63cf6f96d042b63efeb"
+dependencies = [
+ "libc",
+ "windows-sys",
+]
+
+[[package]]
+name = "fastrand"
+version = "2.4.1"
+source = "registry+https://github.com/rust-lang/crates.io-index"
+checksum = "9f1f227452a390804cdb637b74a86990f2a7d7ba4b7d5693aac9b4dd6defd8d6"
+
+[[package]]
+name = "foldhash"
+version = "0.1.5"
+source = "registry+https://github.com/rust-lang/crates.io-index"
+checksum = "d9c4f5dac5e15c24eb999c26181a6ca40b39fe946cbe4c263c7209467bc83af2"
+
+[[package]]
+name = "getrandom"
+version = "0.4.2"
+source = "registry+https://github.com/rust-lang/crates.io-index"
+checksum = "0de51e6874e94e7bf76d726fc5d13ba782deca734ff60d5bb2fb2607c7406555"
+dependencies = [
+ "cfg-if",
+ "libc",
+ "r-efi",
+ "wasip2",
+ "wasip3",
+]
+
+[[package]]
+name = "goblin"
+version = "0.10.5"
+source = "registry+https://github.com/rust-lang/crates.io-index"
+checksum = "983a6aafb3b12d4c41ea78d39e189af4298ce747353945ff5105b54a056e5cd9"
+dependencies = [
+ "log",
+ "plain",
+ "scroll",
+]
+
+[[package]]
+name = "hashbrown"
+version = "0.15.5"
+source = "registry+https://github.com/rust-lang/crates.io-index"
+checksum = "9229cfe53dfd69f0609a49f65461bd93001ea1ef889cd5529dd176593f5338a1"
+dependencies = [
+ "foldhash",
+]
+
+[[package]]
+name = "hashbrown"
+version = "0.17.0"
+source = "registry+https://github.com/rust-lang/crates.io-index"
+checksum = "4f467dd6dccf739c208452f8014c75c18bb8301b050ad1cfb27153803edb0f51"
+
+[[package]]
+name = "heck"
+version = "0.5.0"
+source = "registry+https://github.com/rust-lang/crates.io-index"
+checksum = "2304e00983f87ffb38b55b444b5e3b60a884b5d30c0fca7d82fe33449bbe55ea"
+
+[[package]]
+name = "id-arena"
+version = "2.3.0"
+source = "registry+https://github.com/rust-lang/crates.io-index"
+checksum = "3d3067d79b975e8844ca9eb072e16b31c3c1c36928edf9c6789548c524d0d954"
+
+[[package]]
+name = "indexmap"
+version = "2.14.0"
+source = "registry+https://github.com/rust-lang/crates.io-index"
+checksum = "d466e9454f08e4a911e14806c24e16fba1b4c121d1ea474396f396069cf949d9"
+dependencies = [
+ "equivalent",
+ "hashbrown 0.17.0",
+ "serde",
+ "serde_core",
+]
+
+[[package]]
+name = "is_terminal_polyfill"
+version = "1.70.2"
+source = "registry+https://github.com/rust-lang/crates.io-index"
+checksum = "a6cb138bb79a146c1bd460005623e142ef0181e3d0219cb493e02f7d08a35695"
+
+[[package]]
+name = "itoa"
+version = "1.0.18"
+source = "registry+https://github.com/rust-lang/crates.io-index"
+checksum = "8f42a60cbdf9a97f5d2305f08a87dc4e09308d1276d28c869c684d7777685682"
+
+[[package]]
+name = "kapi"
+version = "0.1.0"
+dependencies = [
+ "anyhow",
+ "clap",
+ "goblin",
+ "regex",
+ "serde",
+ "serde_json",
+ "tempfile",
+ "walkdir",
+]
+
+[[package]]
+name = "leb128fmt"
+version = "0.1.0"
+source = "registry+https://github.com/rust-lang/crates.io-index"
+checksum = "09edd9e8b54e49e587e4f6295a7d29c3ea94d469cb40ab8ca70b288248a81db2"
+
+[[package]]
+name = "libc"
+version = "0.2.185"
+source = "registry+https://github.com/rust-lang/crates.io-index"
+checksum = "52ff2c0fe9bc6cb6b14a0592c2ff4fa9ceb83eea9db979b0487cd054946a2b8f"
+
+[[package]]
+name = "linux-raw-sys"
+version = "0.12.1"
+source = "registry+https://github.com/rust-lang/crates.io-index"
+checksum = "32a66949e030da00e8c7d4434b251670a91556f4144941d37452769c25d58a53"
+
+[[package]]
+name = "log"
+version = "0.4.29"
+source = "registry+https://github.com/rust-lang/crates.io-index"
+checksum = "5e5032e24019045c762d3c0f28f5b6b8bbf38563a65908389bf7978758920897"
+
+[[package]]
+name = "memchr"
+version = "2.8.0"
+source = "registry+https://github.com/rust-lang/crates.io-index"
+checksum = "f8ca58f447f06ed17d5fc4043ce1b10dd205e060fb3ce5b979b8ed8e59ff3f79"
+
+[[package]]
+name = "once_cell"
+version = "1.21.4"
+source = "registry+https://github.com/rust-lang/crates.io-index"
+checksum = "9f7c3e4beb33f85d45ae3e3a1792185706c8e16d043238c593331cc7cd313b50"
+
+[[package]]
+name = "once_cell_polyfill"
+version = "1.70.2"
+source = "registry+https://github.com/rust-lang/crates.io-index"
+checksum = "384b8ab6d37215f3c5301a95a4accb5d64aa607f1fcb26a11b5303878451b4fe"
+
+[[package]]
+name = "plain"
+version = "0.2.3"
+source = "registry+https://github.com/rust-lang/crates.io-index"
+checksum = "b4596b6d070b27117e987119b4dac604f3c58cfb0b191112e24771b2faeac1a6"
+
+[[package]]
+name = "prettyplease"
+version = "0.2.37"
+source = "registry+https://github.com/rust-lang/crates.io-index"
+checksum = "479ca8adacdd7ce8f1fb39ce9ecccbfe93a3f1344b3d0d97f20bc0196208f62b"
+dependencies = [
+ "proc-macro2",
+ "syn",
+]
+
+[[package]]
+name = "proc-macro2"
+version = "1.0.106"
+source = "registry+https://github.com/rust-lang/crates.io-index"
+checksum = "8fd00f0bb2e90d81d1044c2b32617f68fcb9fa3bb7640c23e9c748e53fb30934"
+dependencies = [
+ "unicode-ident",
+]
+
+[[package]]
+name = "quote"
+version = "1.0.45"
+source = "registry+https://github.com/rust-lang/crates.io-index"
+checksum = "41f2619966050689382d2b44f664f4bc593e129785a36d6ee376ddf37259b924"
+dependencies = [
+ "proc-macro2",
+]
+
+[[package]]
+name = "r-efi"
+version = "6.0.0"
+source = "registry+https://github.com/rust-lang/crates.io-index"
+checksum = "f8dcc9c7d52a811697d2151c701e0d08956f92b0e24136cf4cf27b57a6a0d9bf"
+
+[[package]]
+name = "regex"
+version = "1.12.3"
+source = "registry+https://github.com/rust-lang/crates.io-index"
+checksum = "e10754a14b9137dd7b1e3e5b0493cc9171fdd105e0ab477f51b72e7f3ac0e276"
+dependencies = [
+ "aho-corasick",
+ "memchr",
+ "regex-automata",
+ "regex-syntax",
+]
+
+[[package]]
+name = "regex-automata"
+version = "0.4.14"
+source = "registry+https://github.com/rust-lang/crates.io-index"
+checksum = "6e1dd4122fc1595e8162618945476892eefca7b88c52820e74af6262213cae8f"
+dependencies = [
+ "aho-corasick",
+ "memchr",
+ "regex-syntax",
+]
+
+[[package]]
+name = "regex-syntax"
+version = "0.8.10"
+source = "registry+https://github.com/rust-lang/crates.io-index"
+checksum = "dc897dd8d9e8bd1ed8cdad82b5966c3e0ecae09fb1907d58efaa013543185d0a"
+
+[[package]]
+name = "rustix"
+version = "1.1.4"
+source = "registry+https://github.com/rust-lang/crates.io-index"
+checksum = "b6fe4565b9518b83ef4f91bb47ce29620ca828bd32cb7e408f0062e9930ba190"
+dependencies = [
+ "bitflags",
+ "errno",
+ "libc",
+ "linux-raw-sys",
+ "windows-sys",
+]
+
+[[package]]
+name = "same-file"
+version = "1.0.6"
+source = "registry+https://github.com/rust-lang/crates.io-index"
+checksum = "93fc1dc3aaa9bfed95e02e6eadabb4baf7e3078b0bd1b4d7b6b0b68378900502"
+dependencies = [
+ "winapi-util",
+]
+
+[[package]]
+name = "scroll"
+version = "0.13.0"
+source = "registry+https://github.com/rust-lang/crates.io-index"
+checksum = "c1257cd4248b4132760d6524d6dda4e053bc648c9070b960929bf50cfb1e7add"
+dependencies = [
+ "scroll_derive",
+]
+
+[[package]]
+name = "scroll_derive"
+version = "0.13.1"
+source = "registry+https://github.com/rust-lang/crates.io-index"
+checksum = "ed76efe62313ab6610570951494bdaa81568026e0318eaa55f167de70eeea67d"
+dependencies = [
+ "proc-macro2",
+ "quote",
+ "syn",
+]
+
+[[package]]
+name = "semver"
+version = "1.0.28"
+source = "registry+https://github.com/rust-lang/crates.io-index"
+checksum = "8a7852d02fc848982e0c167ef163aaff9cd91dc640ba85e263cb1ce46fae51cd"
+
+[[package]]
+name = "serde"
+version = "1.0.228"
+source = "registry+https://github.com/rust-lang/crates.io-index"
+checksum = "9a8e94ea7f378bd32cbbd37198a4a91436180c5bb472411e48b5ec2e2124ae9e"
+dependencies = [
+ "serde_core",
+ "serde_derive",
+]
+
+[[package]]
+name = "serde_core"
+version = "1.0.228"
+source = "registry+https://github.com/rust-lang/crates.io-index"
+checksum = "41d385c7d4ca58e59fc732af25c3983b67ac852c1a25000afe1175de458b67ad"
+dependencies = [
+ "serde_derive",
+]
+
+[[package]]
+name = "serde_derive"
+version = "1.0.228"
+source = "registry+https://github.com/rust-lang/crates.io-index"
+checksum = "d540f220d3187173da220f885ab66608367b6574e925011a9353e4badda91d79"
+dependencies = [
+ "proc-macro2",
+ "quote",
+ "syn",
+]
+
+[[package]]
+name = "serde_json"
+version = "1.0.149"
+source = "registry+https://github.com/rust-lang/crates.io-index"
+checksum = "83fc039473c5595ace860d8c4fafa220ff474b3fc6bfdb4293327f1a37e94d86"
+dependencies = [
+ "itoa",
+ "memchr",
+ "serde",
+ "serde_core",
+ "zmij",
+]
+
+[[package]]
+name = "strsim"
+version = "0.11.1"
+source = "registry+https://github.com/rust-lang/crates.io-index"
+checksum = "7da8b5736845d9f2fcb837ea5d9e2628564b3b043a70948a3f0b778838c5fb4f"
+
+[[package]]
+name = "syn"
+version = "2.0.117"
+source = "registry+https://github.com/rust-lang/crates.io-index"
+checksum = "e665b8803e7b1d2a727f4023456bbbbe74da67099c585258af0ad9c5013b9b99"
+dependencies = [
+ "proc-macro2",
+ "quote",
+ "unicode-ident",
+]
+
+[[package]]
+name = "tempfile"
+version = "3.27.0"
+source = "registry+https://github.com/rust-lang/crates.io-index"
+checksum = "32497e9a4c7b38532efcdebeef879707aa9f794296a4f0244f6f69e9bc8574bd"
+dependencies = [
+ "fastrand",
+ "getrandom",
+ "once_cell",
+ "rustix",
+ "windows-sys",
+]
+
+[[package]]
+name = "unicode-ident"
+version = "1.0.24"
+source = "registry+https://github.com/rust-lang/crates.io-index"
+checksum = "e6e4313cd5fcd3dad5cafa179702e2b244f760991f45397d14d4ebf38247da75"
+
+[[package]]
+name = "unicode-xid"
+version = "0.2.6"
+source = "registry+https://github.com/rust-lang/crates.io-index"
+checksum = "ebc1c04c71510c7f702b52b7c350734c9ff1295c464a03335b00bb84fc54f853"
+
+[[package]]
+name = "utf8parse"
+version = "0.2.2"
+source = "registry+https://github.com/rust-lang/crates.io-index"
+checksum = "06abde3611657adf66d383f00b093d7faecc7fa57071cce2578660c9f1010821"
+
+[[package]]
+name = "walkdir"
+version = "2.5.0"
+source = "registry+https://github.com/rust-lang/crates.io-index"
+checksum = "29790946404f91d9c5d06f9874efddea1dc06c5efe94541a7d6863108e3a5e4b"
+dependencies = [
+ "same-file",
+ "winapi-util",
+]
+
+[[package]]
+name = "wasip2"
+version = "1.0.3+wasi-0.2.9"
+source = "registry+https://github.com/rust-lang/crates.io-index"
+checksum = "20064672db26d7cdc89c7798c48a0fdfac8213434a1186e5ef29fd560ae223d6"
+dependencies = [
+ "wit-bindgen 0.57.1",
+]
+
+[[package]]
+name = "wasip3"
+version = "0.4.0+wasi-0.3.0-rc-2026-01-06"
+source = "registry+https://github.com/rust-lang/crates.io-index"
+checksum = "5428f8bf88ea5ddc08faddef2ac4a67e390b88186c703ce6dbd955e1c145aca5"
+dependencies = [
+ "wit-bindgen 0.51.0",
+]
+
+[[package]]
+name = "wasm-encoder"
+version = "0.244.0"
+source = "registry+https://github.com/rust-lang/crates.io-index"
+checksum = "990065f2fe63003fe337b932cfb5e3b80e0b4d0f5ff650e6985b1048f62c8319"
+dependencies = [
+ "leb128fmt",
+ "wasmparser",
+]
+
+[[package]]
+name = "wasm-metadata"
+version = "0.244.0"
+source = "registry+https://github.com/rust-lang/crates.io-index"
+checksum = "bb0e353e6a2fbdc176932bbaab493762eb1255a7900fe0fea1a2f96c296cc909"
+dependencies = [
+ "anyhow",
+ "indexmap",
+ "wasm-encoder",
+ "wasmparser",
+]
+
+[[package]]
+name = "wasmparser"
+version = "0.244.0"
+source = "registry+https://github.com/rust-lang/crates.io-index"
+checksum = "47b807c72e1bac69382b3a6fb3dbe8ea4c0ed87ff5629b8685ae6b9a611028fe"
+dependencies = [
+ "bitflags",
+ "hashbrown 0.15.5",
+ "indexmap",
+ "semver",
+]
+
+[[package]]
+name = "winapi-util"
+version = "0.1.11"
+source = "registry+https://github.com/rust-lang/crates.io-index"
+checksum = "c2a7b1c03c876122aa43f3020e6c3c3ee5c05081c9a00739faf7503aeba10d22"
+dependencies = [
+ "windows-sys",
+]
+
+[[package]]
+name = "windows-link"
+version = "0.2.1"
+source = "registry+https://github.com/rust-lang/crates.io-index"
+checksum = "f0805222e57f7521d6a62e36fa9163bc891acd422f971defe97d64e70d0a4fe5"
+
+[[package]]
+name = "windows-sys"
+version = "0.61.2"
+source = "registry+https://github.com/rust-lang/crates.io-index"
+checksum = "ae137229bcbd6cdf0f7b80a31df61766145077ddf49416a728b02cb3921ff3fc"
+dependencies = [
+ "windows-link",
+]
+
+[[package]]
+name = "wit-bindgen"
+version = "0.51.0"
+source = "registry+https://github.com/rust-lang/crates.io-index"
+checksum = "d7249219f66ced02969388cf2bb044a09756a083d0fab1e566056b04d9fbcaa5"
+dependencies = [
+ "wit-bindgen-rust-macro",
+]
+
+[[package]]
+name = "wit-bindgen"
+version = "0.57.1"
+source = "registry+https://github.com/rust-lang/crates.io-index"
+checksum = "1ebf944e87a7c253233ad6766e082e3cd714b5d03812acc24c318f549614536e"
+
+[[package]]
+name = "wit-bindgen-core"
+version = "0.51.0"
+source = "registry+https://github.com/rust-lang/crates.io-index"
+checksum = "ea61de684c3ea68cb082b7a88508a8b27fcc8b797d738bfc99a82facf1d752dc"
+dependencies = [
+ "anyhow",
+ "heck",
+ "wit-parser",
+]
+
+[[package]]
+name = "wit-bindgen-rust"
+version = "0.51.0"
+source = "registry+https://github.com/rust-lang/crates.io-index"
+checksum = "b7c566e0f4b284dd6561c786d9cb0142da491f46a9fbed79ea69cdad5db17f21"
+dependencies = [
+ "anyhow",
+ "heck",
+ "indexmap",
+ "prettyplease",
+ "syn",
+ "wasm-metadata",
+ "wit-bindgen-core",
+ "wit-component",
+]
+
+[[package]]
+name = "wit-bindgen-rust-macro"
+version = "0.51.0"
+source = "registry+https://github.com/rust-lang/crates.io-index"
+checksum = "0c0f9bfd77e6a48eccf51359e3ae77140a7f50b1e2ebfe62422d8afdaffab17a"
+dependencies = [
+ "anyhow",
+ "prettyplease",
+ "proc-macro2",
+ "quote",
+ "syn",
+ "wit-bindgen-core",
+ "wit-bindgen-rust",
+]
+
+[[package]]
+name = "wit-component"
+version = "0.244.0"
+source = "registry+https://github.com/rust-lang/crates.io-index"
+checksum = "9d66ea20e9553b30172b5e831994e35fbde2d165325bec84fc43dbf6f4eb9cb2"
+dependencies = [
+ "anyhow",
+ "bitflags",
+ "indexmap",
+ "log",
+ "serde",
+ "serde_derive",
+ "serde_json",
+ "wasm-encoder",
+ "wasm-metadata",
+ "wasmparser",
+ "wit-parser",
+]
+
+[[package]]
+name = "wit-parser"
+version = "0.244.0"
+source = "registry+https://github.com/rust-lang/crates.io-index"
+checksum = "ecc8ac4bc1dc3381b7f59c34f00b67e18f910c2c0f50015669dde7def656a736"
+dependencies = [
+ "anyhow",
+ "id-arena",
+ "indexmap",
+ "log",
+ "semver",
+ "serde",
+ "serde_derive",
+ "serde_json",
+ "unicode-xid",
+ "wasmparser",
+]
+
+[[package]]
+name = "zmij"
+version = "1.0.21"
+source = "registry+https://github.com/rust-lang/crates.io-index"
+checksum = "b8848ee67ecc8aedbaf3e4122217aff892639231befc6a1b58d29fff4c2cabaa"
diff --git a/tools/kapi/Cargo.toml b/tools/kapi/Cargo.toml
new file mode 100644
index 0000000000000..159e65d324468
--- /dev/null
+++ b/tools/kapi/Cargo.toml
@@ -0,0 +1,20 @@
+[package]
+name = "kapi"
+version = "0.1.0"
+edition = "2021"
+rust-version = "1.85"
+authors = ["Sasha Levin <sashal@kernel.org>"]
+description = "Tool for extracting and displaying kernel API specifications"
+license = "GPL-2.0"
+
+[dependencies]
+goblin = "0.10"
+clap = { version = "4.4", features = ["derive"] }
+anyhow = "1.0"
+serde = { version = "1.0", features = ["derive"] }
+serde_json = "1.0"
+regex = "1.10"
+walkdir = "2.4"
+
+[dev-dependencies]
+tempfile = "3.8"
diff --git a/tools/kapi/Makefile b/tools/kapi/Makefile
new file mode 100644
index 0000000000000..d4234538e4eee
--- /dev/null
+++ b/tools/kapi/Makefile
@@ -0,0 +1,33 @@
+# SPDX-License-Identifier: GPL-2.0
+# Makefile wrapper for the kapi tool (Rust userspace binary).
+#
+# See Documentation/dev-tools/kernel-api-spec.rst for details.
+
+PREFIX ?= /usr/local
+
+.PHONY: all build release debug clean install test fmt clippy
+
+all: release
+
+release:
+	cargo build --release
+
+build: release
+
+debug:
+	cargo build
+
+test:
+	cargo test
+
+fmt:
+	cargo fmt --all -- --check
+
+clippy:
+	cargo clippy --all-targets --all-features -- -D warnings
+
+clean:
+	cargo clean
+
+install: release
+	install -D -m 0755 target/release/kapi $(DESTDIR)$(PREFIX)/bin/kapi
diff --git a/tools/kapi/README.md b/tools/kapi/README.md
new file mode 100644
index 0000000000000..3839f3ff2964a
--- /dev/null
+++ b/tools/kapi/README.md
@@ -0,0 +1,33 @@
+# kapi — Kernel API Specification Extractor
+
+Userspace utility that extracts and displays kernel API specifications from
+three sources:
+
+- `--source PATH` — parse kerneldoc blocks in a C source file or tree
+- `--vmlinux PATH` — decode the `.kapi_specs` ELF section of a compiled vmlinux
+- `--debugfs PATH` — read the live specs from `/sys/kernel/debug/kapi/` on a
+  running kernel (this is also the mode used when no input option is given, in
+  which case PATH is `/sys/kernel/debug`)
+
+Output formats: `plain` (default), `json`, `rst`.
+
+See `Documentation/dev-tools/kernel-api-spec.rst` for the full user guide,
+including the kerneldoc DSL reference and the surrounding framework design.
+
+## Build
+
+```
+make -C tools/kapi
+```
+
+(wraps `cargo build --release`; the binary is produced at
+`tools/kapi/target/release/kapi`).
+
+## Usage
+
+```
+tools/kapi/target/release/kapi --help
+tools/kapi/target/release/kapi --source fs/open.c sys_open
+tools/kapi/target/release/kapi --vmlinux vmlinux -f json
+tools/kapi/target/release/kapi --debugfs /sys/kernel/debug
+```
diff --git a/tools/kapi/src/extractor/debugfs.rs b/tools/kapi/src/extractor/debugfs.rs
new file mode 100644
index 0000000000000..0a7e41e1c40ca
--- /dev/null
+++ b/tools/kapi/src/extractor/debugfs.rs
@@ -0,0 +1,1704 @@
+// SPDX-License-Identifier: GPL-2.0
+// Copyright (C) 2026 Sasha Levin <sashal@kernel.org>
+
+use crate::formatter::OutputFormatter;
+use anyhow::{bail, Context, Result};
+use serde::Deserialize;
+use std::fs;
+use std::io::Write;
+use std::path::PathBuf;
+
+use super::{
+    display_api_spec, ApiExtractor, ApiSpec, CapabilitySpec, ConstraintSpec, ErrorSpec, LockSpec,
+    ParamSpec, ReturnSpec, SignalMaskSpec, StateTransitionSpec, StructFieldSpec, StructSpec,
+};
+
+// Schema matching what kapi_export_json() in the kernel emits.  The kernel
+// serialises several enum-like fields as hex strings ("0x%x") or token
+// strings ("exact", "process"); we keep them as Option<String> here and
+// interpret them during conversion.
+#[derive(Deserialize)]
+struct KernelApiJson {
+    name: String,
+    #[serde(default)]
+    api_type: Option<String>,
+    #[serde(default)]
+    version: Option<u32>,
+    #[serde(default)]
+    description: Option<String>,
+    #[serde(default)]
+    long_description: Option<String>,
+    #[serde(default)]
+    context_flags: Option<String>,
+    #[serde(default)]
+    examples: Option<String>,
+    #[serde(default)]
+    notes: Option<String>,
+    #[serde(default)]
+    capabilities: Option<Vec<KernelCapabilityJson>>,
+    #[serde(default)]
+    parameters: Option<Vec<KernelParamJson>>,
+    #[serde(default)]
+    errors: Option<Vec<KernelErrorJson>>,
+    #[serde(default, rename = "return")]
+    return_spec: Option<KernelReturnJson>,
+    #[serde(default)]
+    locks: Option<Vec<KernelLockJson>>,
+    #[serde(default)]
+    constraints: Option<Vec<KernelConstraintJson>>,
+    #[serde(default)]
+    signals: Option<Vec<KernelSignalJson>>,
+    #[serde(default)]
+    side_effects: Option<Vec<KernelSideEffectJson>>,
+    #[serde(default)]
+    state_transitions: Option<Vec<KernelStateTransitionJson>>,
+    #[serde(default)]
+    signal_masks: Option<Vec<KernelSignalMaskJson>>,
+    #[serde(default)]
+    struct_specs: Option<Vec<KernelStructJson>>,
+}
+
+#[derive(Deserialize)]
+struct KernelStateTransitionJson {
+    #[serde(default)]
+    object: Option<String>,
+    #[serde(default)]
+    from_state: Option<String>,
+    #[serde(default)]
+    to_state: Option<String>,
+    #[serde(default)]
+    condition: Option<String>,
+    #[serde(default)]
+    description: Option<String>,
+}
+
+#[derive(Deserialize)]
+struct KernelSignalMaskJson {
+    #[serde(default)]
+    name: Option<String>,
+    #[serde(default)]
+    description: Option<String>,
+    #[serde(default)]
+    signals: Vec<i32>,
+}
+
+#[derive(Deserialize)]
+struct KernelStructFieldJson {
+    #[serde(default)]
+    name: Option<String>,
+    #[serde(rename = "type", default)]
+    type_name: Option<String>,
+    #[serde(default)]
+    type_class: Option<String>,
+    #[serde(default)]
+    offset: usize,
+    #[serde(default)]
+    size: usize,
+    #[serde(default)]
+    flags: Option<String>,
+    #[serde(default)]
+    constraint_type: Option<String>,
+    #[serde(default)]
+    min_value: i64,
+    #[serde(default)]
+    max_value: i64,
+    #[serde(default)]
+    valid_mask: Option<String>,
+    #[serde(default)]
+    description: Option<String>,
+}
+
+#[derive(Deserialize)]
+struct KernelStructJson {
+    #[serde(default)]
+    name: Option<String>,
+    #[serde(default)]
+    size: usize,
+    #[serde(default)]
+    alignment: usize,
+    #[serde(default)]
+    description: Option<String>,
+    #[serde(default)]
+    fields: Vec<KernelStructFieldJson>,
+}
+
+#[derive(Deserialize)]
+struct KernelConstraintJson {
+    name: String,
+    #[serde(default)]
+    description: Option<String>,
+    #[serde(default)]
+    expression: Option<String>,
+}
+
+#[derive(Deserialize)]
+struct KernelSignalJson {
+    #[serde(default)]
+    signal_num: i32,
+    #[serde(default)]
+    signal_name: Option<String>,
+    #[serde(default)]
+    direction: Option<String>,
+    #[serde(default)]
+    action: u32,
+    #[serde(default)]
+    target: Option<String>,
+    #[serde(default)]
+    condition: Option<String>,
+    #[serde(default)]
+    description: Option<String>,
+    #[serde(default)]
+    restartable: bool,
+    #[serde(default)]
+    sa_flags_required: Option<String>,
+    #[serde(default)]
+    sa_flags_forbidden: Option<String>,
+    #[serde(default)]
+    error_on_signal: i32,
+    #[serde(default)]
+    transform_to: i32,
+    #[serde(default)]
+    timing: Option<String>,
+    #[serde(default)]
+    priority: u32,
+    #[serde(default)]
+    interruptible: bool,
+    #[serde(default)]
+    queue_behavior: Option<String>,
+    #[serde(default)]
+    state_required: Option<String>,
+    #[serde(default)]
+    state_forbidden: Option<String>,
+}
+
+#[derive(Deserialize)]
+struct KernelSideEffectJson {
+    #[serde(rename = "type", default)]
+    type_hex: Option<String>,
+    #[serde(default)]
+    target: Option<String>,
+    #[serde(default)]
+    condition: Option<String>,
+    #[serde(default)]
+    description: Option<String>,
+    #[serde(default)]
+    reversible: bool,
+}
+
+#[derive(Deserialize)]
+struct KernelParamJson {
+    name: String,
+    #[serde(rename = "type", default)]
+    type_name: Option<String>,
+    #[serde(default)]
+    type_class: Option<String>,
+    #[serde(default)]
+    description: Option<String>,
+    #[serde(default)]
+    flags: Option<String>,
+    #[serde(default)]
+    constraint_type: Option<String>,
+    #[serde(default)]
+    constraint_desc: Option<String>,
+    #[serde(default)]
+    min_value: Option<i64>,
+    #[serde(default)]
+    max_value: Option<i64>,
+    #[serde(default)]
+    valid_mask: Option<String>,
+    #[serde(default)]
+    enum_values: Vec<i64>,
+    #[serde(default)]
+    size: Option<u64>,
+    #[serde(default)]
+    alignment: Option<u64>,
+    #[serde(default)]
+    size_param_idx: Option<u32>,
+}
+
+#[derive(Deserialize)]
+struct KernelErrorJson {
+    #[serde(rename = "code")]
+    error_code: i32,
+    #[serde(default)]
+    name: Option<String>,
+    #[serde(default)]
+    condition: Option<String>,
+    #[serde(default)]
+    description: Option<String>,
+}
+
+#[derive(Deserialize)]
+struct KernelReturnJson {
+    #[serde(rename = "type", default)]
+    type_name: Option<String>,
+    #[serde(default)]
+    type_class: Option<String>,
+    #[serde(default)]
+    check_type: Option<String>,
+    #[serde(default)]
+    description: Option<String>,
+    #[serde(default)]
+    success_value: Option<i64>,
+    #[serde(default)]
+    success_min: Option<i64>,
+    #[serde(default)]
+    success_max: Option<i64>,
+    #[serde(default)]
+    error_values: Vec<i64>,
+}
+
+#[derive(Deserialize)]
+struct KernelLockJson {
+    name: String,
+    #[serde(rename = "type", default)]
+    lock_type: Option<String>,
+    #[serde(default)]
+    scope: Option<String>,
+    #[serde(default)]
+    description: Option<String>,
+}
+
+#[derive(Deserialize)]
+struct KernelCapabilityJson {
+    capability: i32,
+    name: String,
+    action: String,
+    allows: String,
+    without_cap: String,
+    check_condition: Option<String>,
+    priority: Option<u8>,
+    alternatives: Option<Vec<i32>>,
+}
+
+/// Free-text fields of the text dump that may span several lines.
+#[derive(Clone, Copy)]
+enum TextField {
+    Description,
+    LongDescription,
+    Examples,
+    Notes,
+}
+
+impl TextField {
+    /// Recognise the header line of a text field, returning the field and
+    /// whatever follows the colon on the same line.
+    fn start(line: &str) -> Option<(Self, &str)> {
+        [
+            ("Description:", Self::Description),
+            ("Long description:", Self::LongDescription),
+            ("Examples:", Self::Examples),
+            ("Notes:", Self::Notes),
+        ]
+        .into_iter()
+        .find_map(|(header, field)| {
+            line.strip_prefix(header)
+                .map(|rest| (field, rest.trim_start()))
+        })
+    }
+
+    fn store(self, spec: &mut ApiSpec, lines: &[String]) {
+        let text = lines.join("\n");
+        let text = text.trim_matches('\n').trim_end().to_string();
+        let slot = match self {
+            Self::Description => &mut spec.description,
+            Self::LongDescription => &mut spec.long_description,
+            Self::Examples => &mut spec.examples,
+            Self::Notes => &mut spec.notes,
+        };
+        *slot = Some(text);
+    }
+}
+
+/// Extractor for kernel API specifications from debugfs
+pub struct DebugfsExtractor {
+    debugfs_path: PathBuf,
+}
+
+impl DebugfsExtractor {
+    /// Create a new debugfs extractor with the specified debugfs path
+    pub fn new(debugfs_path: Option<String>) -> Result<Self> {
+        let path = match debugfs_path {
+            Some(p) => PathBuf::from(p),
+            None => PathBuf::from("/sys/kernel/debug"),
+        };
+
+        // Check if the debugfs path exists
+        if !path.exists() {
+            bail!("Debugfs path does not exist: {}", path.display());
+        }
+
+        // Check if kapi directory exists
+        let kapi_path = path.join("kapi");
+        if !kapi_path.exists() {
+            bail!(
+                "Kernel API debugfs interface not found at: {}",
+                kapi_path.display()
+            );
+        }
+
+        Ok(Self { debugfs_path: path })
+    }
+
+    /// Parse the list file to get all available API names
+    fn parse_list_file(&self) -> Result<Vec<String>> {
+        let list_path = self.debugfs_path.join("kapi/list");
+        let content = fs::read_to_string(&list_path)
+            .with_context(|| format!("Failed to read {}", list_path.display()))?;
+
+        let mut apis = Vec::new();
+        let mut in_list = false;
+
+        for line in content.lines() {
+            if line.contains("===") {
+                in_list = true;
+                continue;
+            }
+
+            if in_list && line.starts_with("Total:") {
+                break;
+            }
+
+            if in_list && !line.trim().is_empty() {
+                // Extract API name from lines like "sys_read - Read from a file descriptor"
+                if let Some(name) = line.split(" - ").next() {
+                    apis.push(name.trim().to_string());
+                }
+            }
+        }
+
+        Ok(apis)
+    }
+
+    /// Convert context flags (emitted by the kernel as a hex string like
+    /// "0x21") into the token list consumed by the formatter.
+    fn parse_context_flags(flags: &str) -> Vec<String> {
+        let mut result = Vec::new();
+        let bits = flags
+            .strip_prefix("0x")
+            .or_else(|| flags.strip_prefix("0X"))
+            .unwrap_or(flags);
+        let Ok(flags) = u32::from_str_radix(bits, 16) else {
+            return result;
+        };
+
+        // These values should match KAPI_CTX_* flags from kernel
+        if flags & (1 << 0) != 0 {
+            result.push("KAPI_CTX_PROCESS".to_string());
+        }
+        if flags & (1 << 1) != 0 {
+            result.push("KAPI_CTX_SOFTIRQ".to_string());
+        }
+        if flags & (1 << 2) != 0 {
+            result.push("KAPI_CTX_HARDIRQ".to_string());
+        }
+        if flags & (1 << 3) != 0 {
+            result.push("KAPI_CTX_NMI".to_string());
+        }
+        if flags & (1 << 4) != 0 {
+            result.push("KAPI_CTX_ATOMIC".to_string());
+        }
+        if flags & (1 << 5) != 0 {
+            result.push("KAPI_CTX_SLEEPABLE".to_string());
+        }
+        if flags & (1 << 6) != 0 {
+            result.push("KAPI_CTX_PREEMPT_DISABLED".to_string());
+        }
+        if flags & (1 << 7) != 0 {
+            result.push("KAPI_CTX_IRQ_DISABLED".to_string());
+        }
+
+        result
+    }
+
+    /// Parse a hex-string like "0x123" into u64, returning 0 on failure.
+    fn parse_hex_u64(value: &str) -> u64 {
+        let bits = value
+            .strip_prefix("0x")
+            .or_else(|| value.strip_prefix("0X"))
+            .unwrap_or(value);
+        u64::from_str_radix(bits, 16).unwrap_or(0)
+    }
+
+    /// Parse a hex-string like "0x123" into u32, returning 0 on failure.
+    fn parse_hex_u32(value: &str) -> u32 {
+        u32::try_from(Self::parse_hex_u64(value)).unwrap_or(0)
+    }
+
+    /// Map the type-class token emitted by the kernel (param_type_to_string)
+    /// back to the numeric enum kapi_param_type.
+    fn parse_type_class(token: &str) -> u32 {
+        match token {
+            "void" => 0,
+            "int" => 1,
+            "uint" => 2,
+            "pointer" => 3,
+            "struct" => 4,
+            "union" => 5,
+            "enum" => 6,
+            "function_pointer" => 7,
+            "array" => 8,
+            "file_descriptor" => 9,
+            "user_pointer" => 10,
+            "pathname" => 11,
+            "custom" => 12,
+            _ => 0,
+        }
+    }
+
+    /// Map the constraint-type token emitted by the kernel
+    /// (constraint_type_to_string) back to the numeric enum
+    /// kapi_constraint_type.
+    fn parse_constraint_type(token: &str) -> u32 {
+        match token {
+            "none" => 0,
+            "range" => 1,
+            "mask" => 2,
+            "enum" => 3,
+            "alignment" => 4,
+            "power_of_two" => 5,
+            "page_aligned" => 6,
+            "nonzero" => 7,
+            "user_string" => 8,
+            "user_path" => 9,
+            "user_ptr" => 10,
+            "buffer" => 11,
+            "custom" => 12,
+            _ => 0,
+        }
+    }
+
+    /// Derive the API type from the symbol name, the same way the vmlinux
+    /// extractor does.
+    fn api_type_from_name(name: &str) -> &'static str {
+        if name.starts_with("sys_") {
+            "syscall"
+        } else if name.ends_with("_ioctl") {
+            "ioctl"
+        } else if name.contains("sysfs") {
+            "sysfs"
+        } else {
+            "function"
+        }
+    }
+
+    /// Map the check-type token emitted by the kernel
+    /// (return_check_type_to_string) back to the u32 enum the formatter wants.
+    fn parse_check_type(token: &str) -> u32 {
+        match token {
+            "exact" => 0,
+            "range" => 1,
+            "error_check" => 2,
+            "file_descriptor" => 3,
+            "custom" => 4,
+            "no_return" => 5,
+            _ => 0,
+        }
+    }
+
+    /// Map the lock-type token emitted by the kernel (lock_type_to_string).
+    fn parse_lock_type(token: &str) -> u32 {
+        match token {
+            "none" => 0,
+            "mutex" => 1,
+            "spinlock" => 2,
+            "rwlock" => 3,
+            "seqlock" => 4,
+            "rcu" => 5,
+            "semaphore" => 6,
+            "custom" => 7,
+            _ => 0,
+        }
+    }
+
+    /// Map the lock-scope token emitted by the kernel (lock_scope_to_string).
+    fn parse_lock_scope(token: &str) -> u32 {
+        match token {
+            "internal" => 0,
+            "acquires" => 1,
+            "releases" => 2,
+            "caller_held" => 3,
+            _ => 0,
+        }
+    }
+
+    /// Map the signal-timing token (e.g. "during") back to the u32 enum that
+    /// the source-side parser produces. Mirrors
+    /// KerneldocParser::parse_signal_timing in kerneldoc_parser.rs so the
+    /// debugfs path and the source path agree.
+    fn parse_signal_timing(token: &str) -> u32 {
+        match token.trim().to_ascii_lowercase().as_str() {
+            "before" => 0,
+            "during" => 1,
+            "after" => 2,
+            _ => 0,
+        }
+    }
+
+    /// Convert the capability action token emitted by the kernel
+    /// (capability_action_to_string) to the KAPI_CAP_* spelling used by the
+    /// other extractors.
+    fn parse_capability_action(action: &str) -> String {
+        match action {
+            "bypass_check" => "KAPI_CAP_BYPASS_CHECK".to_string(),
+            "increase_limit" => "KAPI_CAP_INCREASE_LIMIT".to_string(),
+            "override_restriction" => "KAPI_CAP_OVERRIDE_RESTRICTION".to_string(),
+            "grant_permission" => "KAPI_CAP_GRANT_PERMISSION".to_string(),
+            "modify_behavior" => "KAPI_CAP_MODIFY_BEHAVIOR".to_string(),
+            "access_resource" => "KAPI_CAP_ACCESS_RESOURCE".to_string(),
+            "perform_operation" => "KAPI_CAP_PERFORM_OPERATION".to_string(),
+            _ => action.to_string(),
+        }
+    }
+
+    /// Try to parse as JSON first
+    fn try_parse_json(&self, content: &str) -> Result<ApiSpec, serde_json::Error> {
+        let json_data: KernelApiJson = serde_json::from_str(content)?;
+        // The kernel-side kapi_json_str() emits NULL char * as the empty
+        // string "", so normalise empty -> None to match the ApiSpec
+        // convention used by --source / --vmlinux.
+        fn opt_str(s: Option<String>) -> Option<String> {
+            s.filter(|v| !v.is_empty())
+        }
+        let api_type = json_data
+            .api_type
+            .unwrap_or_else(|| Self::api_type_from_name(&json_data.name).to_string());
+
+        let mut spec = ApiSpec {
+            name: json_data.name,
+            api_type,
+            description: opt_str(json_data.description),
+            long_description: opt_str(json_data.long_description),
+            version: json_data.version.map(|v| v.to_string()),
+            context_flags: json_data
+                .context_flags
+                .as_deref()
+                .map_or_else(Vec::new, Self::parse_context_flags),
+            param_count: None,
+            error_count: None,
+            examples: opt_str(json_data.examples),
+            notes: opt_str(json_data.notes),
+            subsystem: None,   // Not in the JSON format
+            sysfs_path: None,  // Not in the JSON format
+            permissions: None, // Not in the JSON format
+            capabilities: vec![],
+            parameters: vec![],
+            return_spec: None,
+            errors: vec![],
+            signals: vec![],
+            signal_masks: vec![],
+            side_effects: vec![],
+            state_transitions: vec![],
+            constraints: vec![],
+            locks: vec![],
+            struct_specs: vec![],
+        };
+
+        // Convert capabilities
+        if let Some(caps) = json_data.capabilities {
+            for cap in caps {
+                spec.capabilities.push(CapabilitySpec {
+                    capability: cap.capability,
+                    name: cap.name,
+                    action: Self::parse_capability_action(&cap.action),
+                    allows: cap.allows,
+                    without_cap: cap.without_cap,
+                    check_condition: opt_str(cap.check_condition),
+                    priority: cap.priority,
+                    alternatives: cap.alternatives.unwrap_or_default(),
+                });
+            }
+        }
+
+        // Convert parameters.
+        if let Some(params) = json_data.parameters {
+            for (i, p) in params.into_iter().enumerate() {
+                let flags = p.flags.as_deref().map_or(0, Self::parse_hex_u32);
+                let mut param = ParamSpec {
+                    index: i as u32,
+                    name: p.name,
+                    type_name: p.type_name.unwrap_or_default(),
+                    description: p.description.unwrap_or_default(),
+                    flags,
+                    param_type: p.type_class.as_deref().map_or(0, Self::parse_type_class),
+                    constraint_type: p
+                        .constraint_type
+                        .as_deref()
+                        .map_or(0, Self::parse_constraint_type),
+                    constraint: opt_str(p.constraint_desc),
+                    min_value: p.min_value,
+                    max_value: p.max_value,
+                    valid_mask: p.valid_mask.as_deref().map(Self::parse_hex_u64),
+                    enum_values: p.enum_values.iter().map(i64::to_string).collect(),
+                    size: p.size.map(|v| v as u32),
+                    alignment: p.alignment.map(|v| v as u32),
+                    size_param_idx: p.size_param_idx,
+                };
+                param.keep_used_numbers();
+                spec.parameters.push(param);
+            }
+            if !spec.parameters.is_empty() {
+                spec.param_count = Some(spec.parameters.len() as u32);
+            }
+        }
+
+        // Convert errors
+        if let Some(errors) = json_data.errors {
+            for e in errors {
+                spec.errors.push(ErrorSpec {
+                    error_code: e.error_code,
+                    name: e.name.unwrap_or_default(),
+                    condition: e.condition.unwrap_or_default(),
+                    description: e.description.unwrap_or_default(),
+                });
+            }
+            if !spec.errors.is_empty() {
+                spec.error_count = Some(spec.errors.len() as u32);
+            }
+        }
+
+        // Convert return spec
+        if let Some(ret) = json_data.return_spec {
+            let check_type = ret.check_type.as_deref().map_or(0, Self::parse_check_type);
+            let return_type = ret.type_class.as_deref().map_or(0, Self::parse_type_class);
+            let type_name = ret.type_name.unwrap_or_default();
+            let success_value = ret.success_value.unwrap_or(0);
+            // A spec without a return block exports as an all-zero return
+            // spec; report it as absent like the vmlinux extractor does.
+            if !(type_name.is_empty() && return_type == 0 && check_type == 0 && success_value == 0)
+            {
+                let mut ret_spec = ReturnSpec {
+                    type_name,
+                    description: ret.description.unwrap_or_default(),
+                    return_type,
+                    check_type,
+                    success_value: ret.success_value,
+                    success_min: ret.success_min,
+                    success_max: ret.success_max,
+                    error_values: ret
+                        .error_values
+                        .into_iter()
+                        .filter_map(|v| i32::try_from(v).ok())
+                        .collect(),
+                };
+                ret_spec.keep_used_success_fields();
+                spec.return_spec = Some(ret_spec);
+            }
+        }
+
+        // Convert locks
+        if let Some(locks) = json_data.locks {
+            for l in locks {
+                let lock_type = l.lock_type.as_deref().map_or(0, Self::parse_lock_type);
+                let scope = l.scope.as_deref().map_or(0, Self::parse_lock_scope);
+                spec.locks.push(LockSpec {
+                    lock_name: l.name,
+                    lock_type,
+                    scope,
+                    description: l.description.unwrap_or_default(),
+                });
+            }
+        }
+
+        // Convert constraints.  Empty strings emitted from kapi_json_str()
+        // for NULL char * fields normalise back to None to match --source.
+        if let Some(constraints) = json_data.constraints {
+            for c in constraints {
+                spec.constraints.push(ConstraintSpec {
+                    name: c.name,
+                    description: c.description.unwrap_or_default(),
+                    expression: c.expression.filter(|v| !v.is_empty()),
+                });
+            }
+        }
+
+        // Convert signals.
+        if let Some(signals) = json_data.signals {
+            for s in signals {
+                let direction = s.direction.as_deref().map_or(0, Self::parse_hex_u32);
+                let sa_flags_required = s
+                    .sa_flags_required
+                    .as_deref()
+                    .map_or(0, Self::parse_hex_u32);
+                let sa_flags_forbidden = s
+                    .sa_flags_forbidden
+                    .as_deref()
+                    .map_or(0, Self::parse_hex_u32);
+                let state_required = s.state_required.as_deref().map_or(0, Self::parse_hex_u32);
+                let state_forbidden = s.state_forbidden.as_deref().map_or(0, Self::parse_hex_u32);
+                let timing = s.timing.as_deref().map_or(0, Self::parse_signal_timing);
+                spec.signals.push(super::SignalSpec {
+                    signal_num: s.signal_num,
+                    signal_name: s.signal_name.unwrap_or_default(),
+                    direction,
+                    action: s.action,
+                    target: opt_str(s.target),
+                    condition: opt_str(s.condition),
+                    description: opt_str(s.description),
+                    timing,
+                    priority: s.priority,
+                    restartable: s.restartable,
+                    interruptible: s.interruptible,
+                    queue: opt_str(s.queue_behavior),
+                    sa_flags: 0,
+                    sa_flags_required,
+                    sa_flags_forbidden,
+                    state_required,
+                    state_forbidden,
+                    error_on_signal: if s.error_on_signal != 0 {
+                        Some(s.error_on_signal)
+                    } else {
+                        None
+                    },
+                    transform_to: if s.transform_to != 0 {
+                        // Kernel JSON already carries the numeric value.
+                        Some(s.transform_to)
+                    } else {
+                        None
+                    },
+                });
+            }
+        }
+
+        // Convert side effects.
+        if let Some(effects) = json_data.side_effects {
+            for e in effects {
+                let effect_type = e.type_hex.as_deref().map_or(0, Self::parse_hex_u32);
+                spec.side_effects.push(super::SideEffectSpec {
+                    effect_type,
+                    target: e.target.unwrap_or_default(),
+                    condition: e.condition.filter(|v| !v.is_empty()),
+                    description: e.description.unwrap_or_default(),
+                    reversible: e.reversible,
+                });
+            }
+        }
+
+        if let Some(transitions) = json_data.state_transitions {
+            for t in transitions {
+                spec.state_transitions.push(StateTransitionSpec {
+                    object: t.object.unwrap_or_default(),
+                    from_state: t.from_state.unwrap_or_default(),
+                    to_state: t.to_state.unwrap_or_default(),
+                    condition: opt_str(t.condition),
+                    description: t.description.unwrap_or_default(),
+                });
+            }
+        }
+
+        if let Some(masks) = json_data.signal_masks {
+            for m in masks {
+                spec.signal_masks.push(SignalMaskSpec {
+                    name: m.name.unwrap_or_default(),
+                    description: m.description.unwrap_or_default(),
+                    signals: m.signals,
+                });
+            }
+        }
+
+        if let Some(structs) = json_data.struct_specs {
+            for st in structs {
+                let fields: Vec<StructFieldSpec> = st
+                    .fields
+                    .into_iter()
+                    .map(|f| StructFieldSpec {
+                        name: f.name.unwrap_or_default(),
+                        field_type: f.type_class.as_deref().map_or(0, Self::parse_type_class),
+                        type_name: f.type_name.unwrap_or_default(),
+                        offset: f.offset,
+                        size: f.size,
+                        flags: f.flags.as_deref().map_or(0, Self::parse_hex_u32),
+                        constraint_type: f
+                            .constraint_type
+                            .as_deref()
+                            .map_or(0, Self::parse_constraint_type),
+                        min_value: f.min_value,
+                        max_value: f.max_value,
+                        valid_mask: f.valid_mask.as_deref().map_or(0, Self::parse_hex_u64),
+                        description: f.description.unwrap_or_default(),
+                    })
+                    .collect();
+                spec.struct_specs.push(StructSpec {
+                    name: st.name.unwrap_or_default(),
+                    size: st.size,
+                    alignment: st.alignment,
+                    field_count: fields.len() as u32,
+                    fields,
+                    description: st.description.unwrap_or_default(),
+                });
+            }
+        }
+
+        Ok(spec)
+    }
+
+    /// Parse a single API specification file
+    fn parse_spec_file(&self, api_name: &str) -> Result<ApiSpec> {
+        // Prefer the JSON endpoint; fall back to the plain-text dump under
+        // kapi/specs/ if it is missing or does not parse.
+        let json_path = self
+            .debugfs_path
+            .join(format!("kapi/specs-json/{}", api_name));
+        match fs::read_to_string(&json_path) {
+            Ok(content) => match self.try_parse_json(&content) {
+                Ok(spec) => return Ok(spec),
+                Err(e) => eprintln!(
+                    "Warning: invalid JSON in {}: {}; using the text dump",
+                    json_path.display(),
+                    e
+                ),
+            },
+            Err(e) if e.kind() != std::io::ErrorKind::NotFound => eprintln!(
+                "Warning: cannot read {}: {}; using the text dump",
+                json_path.display(),
+                e
+            ),
+            Err(_) => {}
+        }
+
+        let spec_path = self.debugfs_path.join(format!("kapi/specs/{}", api_name));
+        let content = fs::read_to_string(&spec_path)
+            .with_context(|| format!("Failed to read {}", spec_path.display()))?;
+
+        // The specs/ file may hold JSON as well.
+        if let Ok(spec) = self.try_parse_json(&content) {
+            return Ok(spec);
+        }
+
+        // Fall back to plain text parsing
+        let mut spec = ApiSpec {
+            name: api_name.to_string(),
+            api_type: "unknown".to_string(),
+            description: None,
+            long_description: None,
+            version: None,
+            context_flags: Vec::new(),
+            param_count: None,
+            error_count: None,
+            examples: None,
+            notes: None,
+            subsystem: None,
+            sysfs_path: None,
+            permissions: None,
+            capabilities: vec![],
+            parameters: vec![],
+            return_spec: None,
+            errors: vec![],
+            signals: vec![],
+            signal_masks: vec![],
+            side_effects: vec![],
+            state_transitions: vec![],
+            constraints: vec![],
+            locks: vec![],
+            struct_specs: vec![],
+        };
+
+        // Parse the content
+        let mut text_field: Option<TextField> = None;
+        let mut text_lines: Vec<String> = Vec::new();
+        let mut parsing_capability = false;
+        let mut in_capabilities_section = false;
+        let mut current_capability: Option<CapabilitySpec> = None;
+
+        for line in content.lines() {
+            // The kernel indents every line of a multi-line value, so a value
+            // ends at the first non-blank line that is not indented.
+            if let Some(field) = text_field {
+                if line.is_empty() {
+                    text_lines.push(String::new());
+                    continue;
+                }
+                if let Some(rest) = line.strip_prefix("  ") {
+                    text_lines.push(rest.to_string());
+                    continue;
+                }
+                field.store(&mut spec, &text_lines);
+                text_field = None;
+            }
+
+            // Handle capability sections
+            if line.starts_with("Capabilities (") {
+                in_capabilities_section = true;
+                continue;
+            }
+            // Any other top-level section header ends the capabilities section
+            // so that "  pending_signals (0):" inside "Signal handling (1):"
+            // isn't mis-parsed as a capability entry.
+            if !line.starts_with(' ') && !line.is_empty() && line.ends_with(':') {
+                in_capabilities_section = false;
+            }
+            if in_capabilities_section
+                && line.starts_with("  ")
+                && line.contains(" (")
+                && line.ends_with("):")
+            {
+                // Start of a capability entry like "  CAP_IPC_LOCK (14):"
+                if let Some(cap) = current_capability.take() {
+                    spec.capabilities.push(cap);
+                }
+
+                let parts: Vec<&str> = line.trim().split(" (").collect();
+                if parts.len() == 2 {
+                    let cap_name = parts[0].to_string();
+                    let cap_id = parts[1].trim_end_matches("):").parse().unwrap_or(0);
+                    current_capability = Some(CapabilitySpec {
+                        capability: cap_id,
+                        name: cap_name,
+                        action: String::new(),
+                        allows: String::new(),
+                        without_cap: String::new(),
+                        check_condition: None,
+                        priority: None,
+                        alternatives: Vec::new(),
+                    });
+                    parsing_capability = true;
+                }
+                continue;
+            }
+            if parsing_capability && line.starts_with("    ") {
+                // Parse capability fields
+                if let Some(ref mut cap) = current_capability {
+                    if let Some(action) = line.strip_prefix("    Action: ") {
+                        cap.action = action.to_string();
+                    } else if let Some(allows) = line.strip_prefix("    Allows: ") {
+                        cap.allows = allows.to_string();
+                    } else if let Some(without) = line.strip_prefix("    Without: ") {
+                        cap.without_cap = without.to_string();
+                    } else if let Some(cond) = line.strip_prefix("    Condition: ") {
+                        cap.check_condition = Some(cond.to_string());
+                    } else if let Some(prio) = line.strip_prefix("    Priority: ") {
+                        cap.priority = prio.parse().ok();
+                    } else if let Some(alts) = line.strip_prefix("    Alternatives: ") {
+                        cap.alternatives =
+                            alts.split(", ").filter_map(|s| s.parse().ok()).collect();
+                    }
+                }
+                continue;
+            }
+            if parsing_capability && !line.starts_with("  ") {
+                // End of capabilities section
+                if let Some(cap) = current_capability.take() {
+                    spec.capabilities.push(cap);
+                }
+                parsing_capability = false;
+            }
+
+            // Handle section headers
+            if line.starts_with("Parameters (") {
+                if let Some(count_str) = line
+                    .strip_prefix("Parameters (")
+                    .and_then(|s| s.strip_suffix("):"))
+                {
+                    spec.param_count = count_str.parse().ok();
+                }
+                continue;
+            } else if line.starts_with("Errors (") {
+                if let Some(count_str) = line
+                    .strip_prefix("Errors (")
+                    .and_then(|s| s.strip_suffix("):"))
+                {
+                    spec.error_count = count_str.parse().ok();
+                }
+                continue;
+            }
+
+            // Parse regular fields
+            if let Some((field, first)) = TextField::start(line) {
+                text_field = Some(field);
+                text_lines.clear();
+                if !first.is_empty() {
+                    text_lines.push(first.to_string());
+                }
+            } else if let Some(version) = line.strip_prefix("Version: ") {
+                spec.version = Some(version.to_string());
+            } else if let Some(flags) = line.strip_prefix("Context flags: ") {
+                spec.context_flags = flags
+                    .split_whitespace()
+                    .map(|f| format!("KAPI_CTX_{f}"))
+                    .collect();
+            } else if let Some(subsys) = line.strip_prefix("Subsystem: ") {
+                spec.subsystem = Some(subsys.to_string());
+            } else if let Some(path) = line.strip_prefix("Sysfs Path: ") {
+                spec.sysfs_path = Some(path.to_string());
+            } else if let Some(perms) = line.strip_prefix("Permissions: ") {
+                spec.permissions = Some(perms.to_string());
+            }
+        }
+
+        if let Some(field) = text_field {
+            field.store(&mut spec, &text_lines);
+        }
+
+        // Handle any remaining capability
+        if let Some(cap) = current_capability.take() {
+            spec.capabilities.push(cap);
+        }
+
+        // Determine API type based on name
+        if api_name.starts_with("sys_") {
+            spec.api_type = "syscall".to_string();
+        } else if api_name.contains("_ioctl") || api_name.starts_with("ioctl_") {
+            spec.api_type = "ioctl".to_string();
+        } else if api_name.contains("sysfs")
+            || api_name.ends_with("_show")
+            || api_name.ends_with("_store")
+        {
+            spec.api_type = "sysfs".to_string();
+        } else {
+            spec.api_type = "function".to_string();
+        }
+
+        Ok(spec)
+    }
+}
+
+impl ApiExtractor for DebugfsExtractor {
+    fn extract_all(&self) -> Result<Vec<ApiSpec>> {
+        let api_names = self.parse_list_file()?;
+        let mut specs = Vec::new();
+
+        for name in api_names {
+            match self.parse_spec_file(&name) {
+                Ok(spec) => specs.push(spec),
+                Err(e) => {
+                    eprintln!("Warning: failed to parse API spec '{}': {}", name, e);
+                }
+            }
+        }
+
+        Ok(specs)
+    }
+
+    fn extract_by_name(&self, name: &str) -> Result<Option<ApiSpec>> {
+        let api_names = self.parse_list_file()?;
+
+        if api_names.contains(&name.to_string()) {
+            Ok(Some(self.parse_spec_file(name)?))
+        } else {
+            Ok(None)
+        }
+    }
+
+    fn display_api_details(
+        &self,
+        api_name: &str,
+        formatter: &mut dyn OutputFormatter,
+        writer: &mut dyn Write,
+    ) -> Result<()> {
+        if let Some(spec) = self.extract_by_name(api_name)? {
+            display_api_spec(&spec, formatter, writer)?;
+        } else {
+            writeln!(writer, "API '{api_name}' not found in debugfs")?;
+        }
+
+        Ok(())
+    }
+}
+
+#[cfg(test)]
+mod tests {
+    use super::*;
+
+    // Shortened sys_read dump as emitted by kapi_export_json().
+    const SYS_READ_JSON: &str = r#"{
+  "name": "sys_read",
+  "version": 1,
+  "description": "Read data from a file descriptor",
+  "long_description": "",
+  "context_flags": "0x21",
+  "parameters": [
+    {
+      "name": "fd",
+      "type": "unsigned int fd",
+      "type_class": "file_descriptor",
+      "flags": "0x1",
+      "description": "File descriptor to read from ",
+      "constraint_type": "range",
+      "constraint_desc": "Must be a valid, open file descriptor",
+      "min_value": 0,
+      "max_value": 2147483647,
+      "valid_mask": "0x0",
+      "enum_values": [],
+      "size": 0,
+      "alignment": 0,
+      "size_param_idx": null,
+      "size_multiplier": 0
+    },
+    {
+      "name": "buf",
+      "type": "char __user * buf",
+      "type_class": "user_pointer",
+      "flags": "0x42",
+      "description": "User-space buffer to read data into ",
+      "constraint_type": "buffer",
+      "constraint_desc": "Must point to a writable user-space region",
+      "min_value": 0,
+      "max_value": 0,
+      "valid_mask": "0x0",
+      "enum_values": [],
+      "size": 0,
+      "alignment": 0,
+      "size_param_idx": 2,
+      "size_multiplier": 0
+    },
+    {
+      "name": "count",
+      "type": "size_t count",
+      "type_class": "uint",
+      "flags": "0x1",
+      "description": "Maximum number of bytes to read ",
+      "constraint_type": "none",
+      "constraint_desc": "",
+      "min_value": 0,
+      "max_value": 0,
+      "valid_mask": "0x0",
+      "enum_values": [],
+      "size": 0,
+      "alignment": 0,
+      "size_param_idx": null,
+      "size_multiplier": 0
+    }
+  ],
+  "return": {
+    "type": "KAPI_TYPE_INT",
+    "type_class": "int",
+    "check_type": "range",
+    "success_value": 0,
+    "success_min": 0,
+    "success_max": 9223372036854775807,
+    "error_values": [],
+    "description": "Number of bytes read"
+  },
+  "errors": [
+    { "code": -9, "name": "EBADF", "condition": "Bad file descriptor",
+      "description": "fd is not valid" }
+  ],
+  "locks": [
+    { "name": "file->f_pos_lock", "type": "mutex", "scope": "internal",
+      "description": "Position lock" }
+  ],
+  "capabilities": [
+    {
+      "capability": 1,
+      "name": "CAP_DAC_OVERRIDE",
+      "action": "bypass_check",
+      "allows": "Bypass read permission checks",
+      "without_cap": "Standard DAC checks are enforced",
+      "check_condition": "",
+      "priority": 0
+    }
+  ],
+  "constraints": [
+    { "name": "MAX_RW_COUNT",
+      "description": "Count is clamped", "expression": "min(count, MAX_RW_COUNT)" }
+  ],
+  "signals": [
+    {
+      "signal_num": 0,
+      "signal_name": "Any signal",
+      "direction": "0x1",
+      "action": 6,
+      "target": "",
+      "condition": "When blocked waiting for data",
+      "description": "May be interrupted",
+      "restartable": true,
+      "sa_flags_required": "0x0",
+      "sa_flags_forbidden": "0x0",
+      "error_on_signal": -4,
+      "transform_to": 0,
+      "timing": "during",
+      "priority": 0,
+      "interruptible": false,
+      "queue_behavior": "",
+      "state_required": "0x0",
+      "state_forbidden": "0x0"
+    }
+  ],
+  "side_effects": [
+    { "type": "0x10", "target": "file->f_pos", "condition": "",
+      "description": "Offset advances", "reversible": false }
+  ],
+  "state_transitions": [],
+  "signal_masks": [],
+  "struct_specs": [],
+  "examples": "",
+  "notes": ""
+}
+"#;
+
+    // Synthetic dump exercising the fields sys_read leaves empty: enum
+    // values, error values, struct specs, signal masks, state transitions.
+    const FULL_JSON: &str = r#"{
+  "name": "tmp_full",
+  "version": 1,
+  "description": "Full \"feature\" test\tline\nbreak\u0001",
+  "long_description": "",
+  "context_flags": "0x91",
+  "parameters": [
+    {
+      "name": "mode",
+      "type": "int mode",
+      "type_class": "enum",
+      "flags": "0x1",
+      "description": "Enumerated parameter",
+      "constraint_type": "enum",
+      "constraint_desc": "",
+      "min_value": 0,
+      "max_value": 0,
+      "valid_mask": "0x0",
+      "enum_values": [1, 2, -3, 1000000000000],
+      "size": 4096,
+      "alignment": 64,
+      "size_param_idx": null,
+      "size_multiplier": 0
+    },
+    {
+      "name": "bits",
+      "type": "u64 bits",
+      "type_class": "uint",
+      "flags": "0x1",
+      "description": "Masked parameter",
+      "constraint_type": "mask",
+      "constraint_desc": "",
+      "min_value": 0,
+      "max_value": 0,
+      "valid_mask": "0xffffffffffffffff",
+      "enum_values": [],
+      "size": 0,
+      "alignment": 0,
+      "size_param_idx": null,
+      "size_multiplier": 0
+    }
+  ],
+  "return": {
+    "type": "long",
+    "type_class": "int",
+    "check_type": "error_check",
+    "success_value": 0,
+    "success_min": 0,
+    "success_max": 0,
+    "error_values": [-1, -22, -4095],
+    "description": "Error-checked return"
+  },
+  "errors": [],
+  "locks": [
+    { "name": "tmp_lock", "type": "seqlock", "scope": "acquires", "description": "a seqlock" }
+  ],
+  "capabilities": [
+    {
+      "capability": 21,
+      "name": "CAP_SYS_ADMIN",
+      "action": "perform_operation",
+      "allows": "do it",
+      "without_cap": "cannot",
+      "check_condition": "always checked",
+      "priority": 3,
+      "alternatives": [21, 17]
+    }
+  ],
+  "constraints": [],
+  "signals": [],
+  "side_effects": [],
+  "state_transitions": [
+    { "object": "obj", "from_state": "a", "to_state": "b", "condition": "when asked",
+      "description": "moves a to b" }
+  ],
+  "signal_masks": [
+    { "name": "blocked", "description": "Blocked while running", "signals": [2, 15, 3] }
+  ],
+  "struct_specs": [
+    {
+      "name": "tmp_struct",
+      "size": 16,
+      "alignment": 8,
+      "description": "Test structure",
+      "fields": [
+        {
+          "name": "flags",
+          "type": "u32",
+          "type_class": "uint",
+          "offset": 0,
+          "size": 4,
+          "flags": "0x1",
+          "constraint_type": "mask",
+          "min_value": 0,
+          "max_value": 0,
+          "valid_mask": "0xff",
+          "enum_values": "",
+          "description": "Flag bits"
+        },
+        {
+          "name": "kind",
+          "type": "enum k",
+          "type_class": "enum",
+          "offset": 8,
+          "size": 4,
+          "flags": "0x0",
+          "constraint_type": "range",
+          "min_value": -5,
+          "max_value": 5,
+          "valid_mask": "0x0",
+          "enum_values": "",
+          "description": "Kind"
+        }
+      ]
+    }
+  ],
+  "examples": "",
+  "notes": "note"
+}
+"#;
+
+    // Dump without the optional per-parameter constraint fields.
+    const MINIMAL_JSON: &str = r#"{
+  "name": "sys_read",
+  "version": 1,
+  "description": "Read data from a file descriptor",
+  "long_description": "Reads.",
+  "context_flags": "0x21",
+  "parameters": [
+    {
+      "name": "buf",
+      "type": "char __user * buf",
+      "type_class": "user_pointer",
+      "flags": "0x42",
+      "description": "User-space buffer to read data into "
+    }
+  ],
+  "return": {
+    "type": "KAPI_TYPE_INT",
+    "type_class": "int",
+    "check_type": "range",
+    "success_min": 0,
+    "success_max": 9223372036854775807,
+    "description": "Bytes read"
+  },
+  "errors": [],
+  "locks": [],
+  "capabilities": [
+    {
+      "capability": 1,
+      "name": "CAP_DAC_OVERRIDE",
+      "action": "bypass_check",
+      "allows": "a",
+      "without_cap": "b",
+      "check_condition": "c",
+      "priority": 0
+    }
+  ],
+  "constraints": [],
+  "signals": [],
+  "side_effects": [],
+  "examples": "",
+  "notes": ""
+}
+"#;
+
+    fn extractor() -> DebugfsExtractor {
+        DebugfsExtractor {
+            debugfs_path: PathBuf::new(),
+        }
+    }
+
+    #[test]
+    fn json_sys_read_carries_type_and_constraint_data() {
+        let spec = extractor().try_parse_json(SYS_READ_JSON).unwrap();
+
+        assert_eq!(spec.api_type, "syscall");
+        assert_eq!(spec.version.as_deref(), Some("1"));
+        assert_eq!(spec.long_description, None);
+        assert_eq!(
+            spec.context_flags,
+            ["KAPI_CTX_PROCESS", "KAPI_CTX_SLEEPABLE"]
+        );
+        assert_eq!(spec.param_count, Some(3));
+
+        let fd = &spec.parameters[0];
+        assert_eq!((fd.param_type, fd.constraint_type), (9, 1));
+        assert_eq!((fd.min_value, fd.max_value), (Some(0), Some(2147483647)));
+        assert_eq!(fd.valid_mask, None);
+        assert_eq!(fd.size_param_idx, None);
+        assert_eq!(
+            fd.constraint.as_deref(),
+            Some("Must be a valid, open file descriptor")
+        );
+
+        let buf = &spec.parameters[1];
+        assert_eq!((buf.param_type, buf.constraint_type), (10, 11));
+        assert_eq!(buf.flags, 0x42);
+        assert_eq!(buf.size_param_idx, Some(2));
+        assert_eq!(
+            (buf.min_value, buf.max_value, buf.valid_mask),
+            (None, None, None)
+        );
+        assert_eq!((buf.size, buf.alignment), (None, None));
+        assert_eq!(
+            spec.parameters[buf.size_param_idx.unwrap() as usize].name,
+            "count"
+        );
+
+        let count = &spec.parameters[2];
+        assert_eq!((count.param_type, count.constraint_type), (2, 0));
+        assert_eq!(count.constraint, None);
+        assert_eq!(count.description, "Maximum number of bytes to read ");
+
+        let ret = spec.return_spec.as_ref().unwrap();
+        assert_eq!((ret.return_type, ret.check_type), (1, 1));
+        assert_eq!(ret.success_value, None);
+        assert_eq!(ret.success_min, Some(0));
+        assert_eq!(ret.success_max, Some(i64::MAX));
+        assert!(ret.error_values.is_empty());
+
+        assert_eq!(spec.errors[0].error_code, -9);
+        assert_eq!((spec.locks[0].lock_type, spec.locks[0].scope), (1, 0));
+        assert_eq!(spec.capabilities[0].action, "KAPI_CAP_BYPASS_CHECK");
+        assert_eq!(spec.capabilities[0].check_condition, None);
+        assert_eq!(spec.signals[0].timing, 1);
+        assert_eq!(spec.signals[0].error_on_signal, Some(-4));
+        assert_eq!(spec.signals[0].target, None);
+        assert_eq!(spec.side_effects[0].effect_type, 0x10);
+        assert_eq!(spec.side_effects[0].condition, None);
+        assert_eq!(spec.constraints.len(), 1);
+    }
+
+    #[test]
+    fn json_full_carries_enum_error_struct_and_transition_data() {
+        let spec = extractor().try_parse_json(FULL_JSON).unwrap();
+
+        assert_eq!(
+            spec.description.as_deref(),
+            Some("Full \"feature\" test\tline\nbreak\u{1}")
+        );
+        assert_eq!(
+            spec.context_flags,
+            [
+                "KAPI_CTX_PROCESS",
+                "KAPI_CTX_ATOMIC",
+                "KAPI_CTX_IRQ_DISABLED"
+            ]
+        );
+
+        let mode = &spec.parameters[0];
+        assert_eq!((mode.param_type, mode.constraint_type), (6, 3));
+        assert_eq!(mode.enum_values, ["1", "2", "-3", "1000000000000"]);
+        assert_eq!((mode.size, mode.alignment), (Some(4096), Some(64)));
+        assert_eq!(
+            (mode.min_value, mode.max_value, mode.valid_mask),
+            (None, None, None)
+        );
+
+        let bits = &spec.parameters[1];
+        assert_eq!(bits.constraint_type, 2);
+        assert_eq!(bits.valid_mask, Some(u64::MAX));
+        assert_eq!((bits.min_value, bits.max_value), (None, None));
+        assert_eq!((bits.size, bits.alignment), (None, None));
+
+        let ret = spec.return_spec.as_ref().unwrap();
+        assert_eq!(ret.check_type, 2);
+        assert_eq!(ret.error_values, [-1, -22, -4095]);
+
+        assert_eq!(spec.capabilities[0].alternatives, [21, 17]);
+        assert_eq!(spec.capabilities[0].priority, Some(3));
+        assert_eq!((spec.locks[0].lock_type, spec.locks[0].scope), (4, 1));
+
+        let trans = &spec.state_transitions[0];
+        assert_eq!(
+            (trans.object.as_str(), trans.from_state.as_str()),
+            ("obj", "a")
+        );
+        assert_eq!(trans.to_state, "b");
+        assert_eq!(trans.condition.as_deref(), Some("when asked"));
+
+        assert_eq!(spec.signal_masks[0].name, "blocked");
+        assert_eq!(spec.signal_masks[0].signals, [2, 15, 3]);
+
+        let st = &spec.struct_specs[0];
+        assert_eq!(
+            (st.name.as_str(), st.size, st.alignment),
+            ("tmp_struct", 16, 8)
+        );
+        assert_eq!(st.field_count, 2);
+        assert_eq!(st.description, "Test structure");
+        assert_eq!(
+            (st.fields[0].field_type, st.fields[0].constraint_type),
+            (2, 2)
+        );
+        assert_eq!(st.fields[0].valid_mask, 0xff);
+        assert_eq!(st.fields[1].offset, 8);
+        assert_eq!((st.fields[1].min_value, st.fields[1].max_value), (-5, 5));
+    }
+
+    #[test]
+    fn json_without_constraint_fields_still_parses() {
+        let spec = extractor().try_parse_json(MINIMAL_JSON).unwrap();
+
+        let buf = &spec.parameters[0];
+        assert_eq!(buf.param_type, 10);
+        assert_eq!(buf.constraint_type, 0);
+        assert_eq!(buf.min_value, None);
+        assert_eq!(buf.valid_mask, None);
+        assert_eq!(buf.size_param_idx, None);
+        assert!(buf.enum_values.is_empty());
+
+        let ret = spec.return_spec.as_ref().unwrap();
+        assert_eq!((ret.return_type, ret.check_type), (1, 1));
+        assert_eq!(ret.success_value, None);
+        assert_eq!(ret.success_max, Some(i64::MAX));
+        assert_eq!(spec.capabilities[0].action, "KAPI_CAP_BYPASS_CHECK");
+        assert!(spec.state_transitions.is_empty());
+        assert!(spec.struct_specs.is_empty());
+    }
+
+    #[test]
+    fn enum_tokens_match_kernel_numbering() {
+        let classes = [
+            "void",
+            "int",
+            "uint",
+            "pointer",
+            "struct",
+            "union",
+            "enum",
+            "function_pointer",
+            "array",
+            "file_descriptor",
+            "user_pointer",
+            "pathname",
+            "custom",
+        ];
+        for (n, token) in classes.iter().enumerate() {
+            assert_eq!(
+                DebugfsExtractor::parse_type_class(token),
+                n as u32,
+                "{token}"
+            );
+        }
+
+        let constraints = [
+            "none",
+            "range",
+            "mask",
+            "enum",
+            "alignment",
+            "power_of_two",
+            "page_aligned",
+            "nonzero",
+            "user_string",
+            "user_path",
+            "user_ptr",
+            "buffer",
+            "custom",
+        ];
+        for (n, token) in constraints.iter().enumerate() {
+            assert_eq!(
+                DebugfsExtractor::parse_constraint_type(token),
+                n as u32,
+                "{token}"
+            );
+        }
+    }
+
+    #[test]
+    fn api_type_follows_symbol_name() {
+        assert_eq!(DebugfsExtractor::api_type_from_name("sys_read"), "syscall");
+        assert_eq!(DebugfsExtractor::api_type_from_name("foo_ioctl"), "ioctl");
+        assert_eq!(DebugfsExtractor::api_type_from_name("kmalloc"), "function");
+    }
+
+    #[test]
+    fn truncated_json_is_rejected() {
+        let cut = &SYS_READ_JSON[..SYS_READ_JSON.len() / 2];
+        assert!(extractor().try_parse_json(cut).is_err());
+    }
+
+    fn debugfs_with(json: &str, text: &str) -> tempfile::TempDir {
+        let dir = tempfile::tempdir().unwrap();
+        let kapi = dir.path().join("kapi");
+        fs::create_dir_all(kapi.join("specs")).unwrap();
+        fs::create_dir_all(kapi.join("specs-json")).unwrap();
+        fs::write(
+            kapi.join("list"),
+            "Available Kernel API Specifications\n\
+             ===================================\n\n\
+             sys_read - Read data from a file descriptor\n\n\
+             Total: 1 specifications\n",
+        )
+        .unwrap();
+        fs::write(kapi.join("specs-json/sys_read"), json).unwrap();
+        fs::write(kapi.join("specs/sys_read"), text).unwrap();
+        dir
+    }
+
+    #[test]
+    fn reads_json_endpoint_from_debugfs_tree() {
+        let dir = debugfs_with(SYS_READ_JSON, "Name: sys_read\n");
+        let ex = DebugfsExtractor::new(Some(dir.path().to_string_lossy().into_owned())).unwrap();
+        let spec = ex.extract_by_name("sys_read").unwrap().unwrap();
+
+        assert_eq!(spec.parameters[1].constraint_type, 11);
+        assert_eq!(spec.parameters[1].size_param_idx, Some(2));
+    }
+
+    #[test]
+    fn truncated_json_endpoint_falls_back_to_text_dump() {
+        let text = "Name: sys_read\n\
+                    Version: 1\n\
+                    Description: Read data from a file descriptor\n\
+                    Context flags: PROCESS SLEEPABLE \n";
+        let dir = debugfs_with(&SYS_READ_JSON[..SYS_READ_JSON.len() / 2], text);
+        let ex = DebugfsExtractor::new(Some(dir.path().to_string_lossy().into_owned())).unwrap();
+        let spec = ex.extract_by_name("sys_read").unwrap().unwrap();
+
+        assert!(spec.parameters.is_empty());
+        assert_eq!(
+            spec.context_flags,
+            ["KAPI_CTX_PROCESS", "KAPI_CTX_SLEEPABLE"]
+        );
+    }
+
+    #[test]
+    fn text_dump_multi_line_values_stay_in_their_field() {
+        let text = "Kernel API Specification\n\
+                    ========================\n\n\
+                    Name: sys_read\n\
+                    Version: 1\n\
+                    Description: Read data from a file descriptor\n\
+                    Long description:\n  \
+                    First paragraph.\n\n  \
+                    Notes: not a header\n  \
+                    Version: 9\n\
+                    Context flags: PROCESS SLEEPABLE \n\n\
+                    Parameters (1):\n  \
+                    [0] fd:\n    \
+                    description: File descriptor\n\n\
+                    Examples:\n  \
+                    read(fd, buf, n);\n  \
+                    close(fd);\n\n\
+                    Notes:\n  \
+                    one\n\n  \
+                    two\n\n";
+        let dir = debugfs_with("", text);
+        let ex = DebugfsExtractor::new(Some(dir.path().to_string_lossy().into_owned())).unwrap();
+        let spec = ex.extract_by_name("sys_read").unwrap().unwrap();
+
+        assert_eq!(spec.version.as_deref(), Some("1"));
+        assert_eq!(
+            spec.description.as_deref(),
+            Some("Read data from a file descriptor")
+        );
+        assert_eq!(
+            spec.long_description.as_deref(),
+            Some("First paragraph.\n\nNotes: not a header\nVersion: 9")
+        );
+        assert_eq!(
+            spec.context_flags,
+            ["KAPI_CTX_PROCESS", "KAPI_CTX_SLEEPABLE"]
+        );
+        assert_eq!(spec.param_count, Some(1));
+        assert_eq!(
+            spec.examples.as_deref(),
+            Some("read(fd, buf, n);\nclose(fd);")
+        );
+        assert_eq!(spec.notes.as_deref(), Some("one\n\ntwo"));
+    }
+}
diff --git a/tools/kapi/src/extractor/kerneldoc_parser.rs b/tools/kapi/src/extractor/kerneldoc_parser.rs
new file mode 100644
index 0000000000000..b8fae748470b0
--- /dev/null
+++ b/tools/kapi/src/extractor/kerneldoc_parser.rs
@@ -0,0 +1,3335 @@
+// SPDX-License-Identifier: GPL-2.0
+// Copyright (C) 2026 Sasha Levin <sashal@kernel.org>
+
+use super::{
+    ApiSpec, CapabilitySpec, ConstraintSpec, ErrorSpec, LockSpec, ParamSpec, ReturnSpec,
+    SideEffectSpec, SignalSpec, StateTransitionSpec,
+};
+use anyhow::Result;
+use std::collections::HashMap;
+
+/// Kerneldoc parser that extracts KAPI annotations
+pub struct KerneldocParser;
+
+/// What block are we currently inside?
+#[derive(Debug, Clone, PartialEq)]
+enum BlockContext {
+    None,
+    Param(String),   // param: <name>
+    Error(String),   // error: <name>
+    Signal,          // signal: <name>
+    Capability,      // capability: <name>
+    SideEffect,      // side-effect: <type>
+    StateTransition, // state-trans: ...
+    Constraint,      // constraint: <name>
+    Lock,            // lock: <name>
+    Return,          // return:
+}
+
+/// Evaluate an integer literal exactly as the compiler does on LP64 (int is
+/// 32 bits, long and long long are 64): decimal, 0x/0X hex, 0b/0B binary or
+/// leading-0 octal, an optional u/U/l/L suffix and an optional leading '-'.
+/// The literal's C type (C11 6.4.4.1) decides how '-' wraps, so `-1U` is
+/// 4294967295 and `-0x80000000` is 2147483648. The result is the 64-bit
+/// two's complement pattern the value has once stored into an s64/u64
+/// field. Returns `None` for anything that requires cpp-level constant
+/// resolution (e.g. symbolic masks like `O_RDONLY | O_WRONLY`). Callers must
+/// treat that case as "value unknown" and leave the downstream slot unset,
+/// not store it as 0, which would wrongly assert that zero bits are valid.
+fn eval_c_int_literal(s: &str) -> Option<u64> {
+    let t = s.trim();
+    let (neg, t) = match t.strip_prefix('-') {
+        Some(rest) => (true, rest.trim_start()),
+        None => (false, t),
+    };
+    let body = t.trim_end_matches(['u', 'U', 'l', 'L']);
+    let suffix = &t[body.len()..];
+    let unsigned = match suffix.matches(['u', 'U']).count() {
+        0 => false,
+        1 => true,
+        _ => return None,
+    };
+    let longs = suffix.matches(['l', 'L']).count();
+    if longs > 2 {
+        return None;
+    }
+
+    let (digits, radix) =
+        if let Some(h) = body.strip_prefix("0x").or_else(|| body.strip_prefix("0X")) {
+            (h, 16)
+        } else if let Some(b) = body.strip_prefix("0b").or_else(|| body.strip_prefix("0B")) {
+            (b, 2)
+        } else if body.len() > 1 && body.starts_with('0') {
+            (&body[1..], 8)
+        } else {
+            (body, 10)
+        };
+    if digits.is_empty() || !digits.chars().all(|c| c.is_digit(radix)) {
+        return None;
+    }
+    let v = u64::from_str_radix(digits, radix).ok()?;
+
+    // Decimal literals without 'u' only take signed types; GCC treats one
+    // too large for long long as unsigned.
+    let value = if longs == 0 && !unsigned && v <= i32::MAX as u64 {
+        let x = v as i32;
+        (if neg { x.wrapping_neg() } else { x }) as i64 as u64
+    } else if longs == 0 && (unsigned || radix != 10) && v <= u32::MAX as u64 {
+        let x = v as u32;
+        u64::from(if neg { x.wrapping_neg() } else { x })
+    } else if !unsigned && v <= i64::MAX as u64 {
+        let x = v as i64;
+        (if neg { x.wrapping_neg() } else { x }) as u64
+    } else if neg {
+        v.wrapping_neg()
+    } else {
+        v
+    };
+    Some(value)
+}
+
+fn parse_u64_literal(s: &str) -> Option<u64> {
+    eval_c_int_literal(s)
+}
+
+fn parse_i64_literal(s: &str) -> Option<i64> {
+    eval_c_int_literal(s).map(|v| v as i64)
+}
+
+/// Split a return `success:` value into (exact value, range minimum,
+/// range maximum). `>= N` is the range [N, i64::MAX]; `N`, `= N` and
+/// `== N` are an exact value, and any value that is not `>= N` leaves
+/// the default range [0, i64::MAX] a range check falls back to. Mirrors
+/// `_return_success_macro()` in kdoc_apispec.py.
+fn parse_return_success(text: &str) -> (Option<i64>, Option<i64>, Option<i64>) {
+    let t = text.trim();
+    if let Some(min) = t.strip_prefix(">=") {
+        return (
+            None,
+            Some(parse_i64_literal(min).unwrap_or(0)),
+            Some(i64::MAX),
+        );
+    }
+    let exact = t
+        .strip_prefix("==")
+        .or_else(|| t.strip_prefix('='))
+        .unwrap_or(t);
+    (parse_i64_literal(exact), Some(0), Some(i64::MAX))
+}
+
+/// Canonicalise a capability `type:` value to its KAPI_CAP_* spelling.
+fn canon_kapi_cap_action(s: &str) -> String {
+    let t = s.trim();
+    if t.starts_with("KAPI_CAP_") {
+        return t.to_string();
+    }
+    match t.to_ascii_lowercase().as_str() {
+        "bypass_check" => "KAPI_CAP_BYPASS_CHECK".to_string(),
+        "increase_limit" => "KAPI_CAP_INCREASE_LIMIT".to_string(),
+        "override_restriction" => "KAPI_CAP_OVERRIDE_RESTRICTION".to_string(),
+        "grant_permission" => "KAPI_CAP_GRANT_PERMISSION".to_string(),
+        "modify_behavior" => "KAPI_CAP_MODIFY_BEHAVIOR".to_string(),
+        "access_resource" => "KAPI_CAP_ACCESS_RESOURCE".to_string(),
+        "perform_operation" => "KAPI_CAP_PERFORM_OPERATION".to_string(),
+        _ => t.to_string(),
+    }
+}
+
+/// Types whose semantics imply `KAPI_PARAM_USER` on the param, so
+/// `type: user_ptr, input` doesn't need a separate `user` flag.
+fn type_implies_user_flag(tok: &str) -> bool {
+    matches!(tok.trim(), "KAPI_TYPE_USER_PTR" | "KAPI_TYPE_PATH")
+        || matches!(
+            tok.trim().to_ascii_lowercase().as_str(),
+            "user_ptr" | "uptr" | "path"
+        )
+}
+
+/// Subfield names each block type consumes. An indented line opens a
+/// new subfield only when it starts with one of these followed by ':';
+/// any other line continues the previous subfield. Must stay in sync
+/// with the `_*_SUBFIELDS` sets in tools/lib/python/kdoc/kdoc_apispec.py.
+fn block_subfield_keys(block: &BlockContext) -> &'static [&'static str] {
+    match block {
+        BlockContext::Param(_) => &[
+            "type",
+            "flags",
+            "size",
+            "constraint-type",
+            "constraint",
+            "cdesc",
+            "range",
+            "mask",
+            "valid-mask",
+            "valid-values",
+            "alignment",
+            "size-param",
+            "struct-type",
+            "arch-mask",
+            "desc",
+            "description",
+        ],
+        BlockContext::Error(_) => &["desc", "condition"],
+        BlockContext::Signal => &[
+            "direction",
+            "action",
+            "condition",
+            "desc",
+            "errno",
+            "timing",
+            "priority",
+            "restartable",
+            "interruptible",
+            "number",
+            "target",
+            "queue",
+            "queue_behavior",
+            "transform",
+            "transform_to",
+            "transform-to",
+            "sa_flags_required",
+            "sa-flags-required",
+            "sa_flags_forbidden",
+            "sa-flags-forbidden",
+            "state_required",
+            "state-required",
+            "state_forbidden",
+            "state-forbidden",
+        ],
+        BlockContext::Capability => &["type", "allows", "without", "condition", "priority", "desc"],
+        BlockContext::SideEffect => &["target", "desc", "condition", "reversible"],
+        BlockContext::StateTransition => &["object", "from", "to", "condition", "desc"],
+        BlockContext::Constraint => &["desc", "expr"],
+        BlockContext::Lock => &[
+            "type",
+            "scope",
+            "acquired",
+            "released",
+            "held-on-entry",
+            "held-on-exit",
+            "desc",
+        ],
+        BlockContext::Return => &[
+            "type",
+            "check-type",
+            "success",
+            "success-range",
+            "error-values",
+            "desc",
+        ],
+        BlockContext::None => &[],
+    }
+}
+
+/// True if `line` starts with one of `keys` followed by ':'.
+fn starts_subfield(line: &str, keys: &[&str]) -> bool {
+    line.split_once(':')
+        .is_some_and(|(key, _)| keys.contains(&key.trim()))
+}
+
+fn is_indented_line(line: &str) -> bool {
+    line.starts_with("  ") || line.starts_with('\t')
+}
+
+/// Fold free-form prose into paragraphs. Blank lines separate
+/// paragraphs ("\n\n"); wrapped lines inside a paragraph are joined
+/// with spaces, except that a line starting with "- " always begins a
+/// new line so bullet lists survive. Mirrors `_fold_paragraphs()` in
+/// kdoc_apispec.py.
+fn fold_paragraphs(lines: &[&str]) -> String {
+    let mut paragraphs: Vec<Vec<String>> = Vec::new();
+    let mut current: Vec<String> = Vec::new();
+    for line in lines {
+        let line = line.trim();
+        if line.is_empty() {
+            if !current.is_empty() {
+                paragraphs.push(std::mem::take(&mut current));
+            }
+        } else if line.starts_with("- ") || current.is_empty() {
+            current.push(line.to_string());
+        } else if let Some(last) = current.last_mut() {
+            last.push(' ');
+            last.push_str(line);
+        }
+    }
+    if !current.is_empty() {
+        paragraphs.push(current);
+    }
+    paragraphs
+        .iter()
+        .map(|p| p.join("\n"))
+        .collect::<Vec<_>>()
+        .join("\n\n")
+        .replace('\t', " ")
+}
+
+fn expand_tabs(line: &str) -> String {
+    let mut out = String::with_capacity(line.len());
+    let mut col = 0;
+    for c in line.chars() {
+        if c == '\t' {
+            let pad = 8 - col % 8;
+            out.extend(std::iter::repeat_n(' ', pad));
+            col += pad;
+        } else {
+            out.push(c);
+            col += 1;
+        }
+    }
+    out
+}
+
+/// Keep every line of a block on its own line. The indentation shared
+/// by the continuation lines is removed so relative indentation
+/// (nested code) is preserved; runs of blank lines collapse into one.
+/// Mirrors `_fold_lines()` in kdoc_apispec.py.
+fn fold_lines(lines: &[&str]) -> String {
+    let mut lines: Vec<String> = lines
+        .iter()
+        .map(|l| expand_tabs(l).trim_end().to_string())
+        .collect();
+    while lines.first().is_some_and(|l| l.is_empty()) {
+        lines.remove(0);
+    }
+    while lines.last().is_some_and(|l| l.is_empty()) {
+        lines.pop();
+    }
+
+    let indent = |l: &str| l.len() - l.trim_start().len();
+    let base = lines
+        .iter()
+        .skip(1)
+        .filter(|l| !l.is_empty())
+        .map(|l| indent(l))
+        .min()
+        .unwrap_or(0);
+
+    let mut out: Vec<&str> = Vec::new();
+    for line in &lines {
+        if line.is_empty() {
+            if out.last().is_some_and(|l| l.is_empty()) {
+                continue;
+            }
+            out.push("");
+        } else {
+            out.push(&line[base.min(indent(line))..]);
+        }
+    }
+    out.join("\n")
+}
+
+impl KerneldocParser {
+    pub fn new() -> Self {
+        KerneldocParser
+    }
+
+    pub fn parse_kerneldoc(
+        &self,
+        doc: &str,
+        name: &str,
+        api_type: &str,
+        signature: Option<&str>,
+    ) -> Result<ApiSpec> {
+        let mut spec = ApiSpec {
+            name: name.to_string(),
+            api_type: api_type.to_string(),
+            ..Default::default()
+        };
+
+        let lines: Vec<&str> = doc.lines().collect();
+
+        // Extract main description from function name line
+        if let Some(first_line) = lines.first() {
+            if let Some((_, desc)) = first_line.split_once(" - ") {
+                spec.description = Some(desc.trim().to_string());
+            }
+        }
+
+        // Extract type names from SYSCALL_DEFINE signature
+        let type_map = if let Some(sig) = signature {
+            self.extract_types_from_signature(sig)
+        } else {
+            HashMap::new()
+        };
+
+        // Keep track of parameters we've seen (from @param lines)
+        let mut param_map: HashMap<String, ParamSpec> = HashMap::new();
+
+        // Current block being parsed
+        let mut block = BlockContext::None;
+
+        // Temporary storage for current block items
+        let mut current_lock: Option<LockSpec> = None;
+        let mut current_signal: Option<SignalSpec> = None;
+        // Pending symbolic `transform-to:` token. Captured when the parser
+        // sees a non-numeric value, but only reported if the final
+        // `transform_to` after all lines in the signal block is still
+        // unresolved. A later numeric `transform-to:` clears this so we
+        // don't warn about a value that was subsequently overridden.
+        let mut pending_transform_warning: Option<String> = None;
+        let mut current_capability: Option<CapabilitySpec> = None;
+        let mut current_side_effect: Option<SideEffectSpec> = None;
+        let mut current_constraint: Option<ConstraintSpec> = None;
+        let mut current_error: Option<ErrorSpec> = None;
+        let mut current_return: Option<ReturnSpec> = None;
+        let mut current_state_trans: Option<StateTransitionSpec> = None;
+
+        let mut i = 0;
+
+        while i < lines.len() {
+            let line = lines[i];
+            let trimmed = line.trim();
+
+            // Skip empty lines
+            if trimmed.is_empty() {
+                i += 1;
+                continue;
+            }
+
+            // Check if this is an indented continuation line (part of current block)
+            let is_indented = is_indented_line(line);
+
+            // If indented and we're in a block, parse as block attribute.
+            // A subfield line absorbs the lines that follow it until the
+            // next known subfield key, so a value such as
+            // `constraint-type: mask(FOO | BAR |` ... `| BAZ)` or a
+            // wrapped `condition:` arrives as a single logical line.
+            if is_indented && block != BlockContext::None {
+                let keys = block_subfield_keys(&block);
+                let mut logical = trimmed.to_string();
+                if starts_subfield(trimmed, keys) {
+                    let mut j = i + 1;
+                    while j < lines.len() {
+                        let next = lines[j];
+                        let next_trim = next.trim();
+                        if next_trim.is_empty() {
+                            j += 1;
+                            continue;
+                        }
+                        if !is_indented_line(next) || starts_subfield(next_trim, keys) {
+                            break;
+                        }
+                        logical.push(' ');
+                        logical.push_str(next_trim);
+                        i = j;
+                        j += 1;
+                    }
+                }
+                self.parse_block_attribute(
+                    &logical,
+                    &block,
+                    &mut param_map,
+                    &mut current_error,
+                    &mut current_signal,
+                    &mut pending_transform_warning,
+                    &mut current_capability,
+                    &mut current_side_effect,
+                    &mut current_constraint,
+                    &mut current_lock,
+                    &mut current_return,
+                    &mut current_state_trans,
+                );
+                i += 1;
+                continue;
+            }
+
+            // Not indented or not in block: flush current block if any.
+            // If a symbolic `transform-to:` was captured and no later
+            // numeric line cleared it, surface the warning now; by
+            // construction `transform_to` is None in that case.
+            if matches!(block, BlockContext::Signal) {
+                if let Some(raw) = pending_transform_warning.take() {
+                    eprintln!(
+                        "kapi: warning: transform-to: {raw:?} is symbolic; \
+                         source-mode cannot resolve signal numbers portably. \
+                         Use --vmlinux or --debugfs to get the resolved value.",
+                    );
+                }
+            }
+            self.flush_block(
+                &mut block,
+                &mut spec,
+                &mut current_error,
+                &mut current_signal,
+                &mut current_capability,
+                &mut current_side_effect,
+                &mut current_constraint,
+                &mut current_lock,
+                &mut current_return,
+                &mut current_state_trans,
+            );
+
+            // Parse top-level annotations
+            if let Some(rest) = trimmed.strip_prefix("@") {
+                // @param: description (standard kerneldoc parameter)
+                if let Some((param_name, desc)) = rest.split_once(':') {
+                    let param_name = param_name.trim();
+                    let desc = desc.trim();
+                    if !param_name.contains('-') {
+                        let idx = param_map.len() as u32;
+                        let type_name = type_map.get(param_name).cloned().unwrap_or_default();
+                        param_map.insert(
+                            param_name.to_string(),
+                            ParamSpec {
+                                index: idx,
+                                name: param_name.to_string(),
+                                type_name,
+                                description: desc.to_string(),
+                                flags: 0,
+                                param_type: 0,
+                                constraint_type: 0,
+                                constraint: None,
+                                min_value: None,
+                                max_value: None,
+                                valid_mask: None,
+                                enum_values: vec![],
+                                size: None,
+                                alignment: None,
+                                size_param_idx: None,
+                            },
+                        );
+                    }
+                }
+            } else if let Some(rest) = trimmed.strip_prefix("long-desc:") {
+                let (section, next_i) = self.collect_section(&lines, i, rest);
+                let val = fold_paragraphs(&section);
+                spec.long_description = Some(val).filter(|v| !v.is_empty());
+                i = next_i;
+                continue;
+            } else if let Some(rest) = trimmed.strip_prefix("context-flags:") {
+                spec.context_flags = self.parse_context_flags(rest.trim());
+            } else if let Some(rest) = trimmed.strip_prefix("contexts:") {
+                // Short form: "contexts: process, sleepable"
+                spec.context_flags = self.parse_context_list(rest.trim());
+            } else if let Some(rest) = trimmed.strip_prefix("param-count:") {
+                spec.param_count = rest.trim().parse().ok();
+            }
+            // Block-start annotations
+            else if let Some(rest) = trimmed.strip_prefix("param:") {
+                let param_name = rest.trim().to_string();
+                block = BlockContext::Param(param_name.clone());
+                // Ensure param exists in map
+                if !param_map.contains_key(&param_name) {
+                    let idx = param_map.len() as u32;
+                    let type_name = type_map
+                        .get(param_name.as_str())
+                        .cloned()
+                        .unwrap_or_default();
+                    param_map.insert(
+                        param_name.clone(),
+                        ParamSpec {
+                            index: idx,
+                            name: param_name,
+                            type_name,
+                            description: String::new(),
+                            flags: 0,
+                            param_type: 0,
+                            constraint_type: 0,
+                            constraint: None,
+                            min_value: None,
+                            max_value: None,
+                            valid_mask: None,
+                            enum_values: vec![],
+                            size: None,
+                            alignment: None,
+                            size_param_idx: None,
+                        },
+                    );
+                }
+            } else if let Some(rest) = trimmed.strip_prefix("error:") {
+                // error: NAME, condition
+                let parts: Vec<&str> = rest.splitn(2, ',').map(|s| s.trim()).collect();
+                if !parts.is_empty() {
+                    let error_name = parts[0].to_string();
+                    let condition = if parts.len() >= 2 {
+                        parts[1].to_string()
+                    } else {
+                        String::new()
+                    };
+                    let error_code = self.error_name_to_code(&error_name);
+                    current_error = Some(ErrorSpec {
+                        error_code,
+                        name: error_name.clone(),
+                        condition,
+                        description: String::new(),
+                    });
+                    block = BlockContext::Error(error_name);
+                }
+            } else if let Some(rest) = trimmed.strip_prefix("signal:") {
+                let signal_name = rest.trim().to_string();
+                current_signal = Some(SignalSpec {
+                    signal_num: 0,
+                    signal_name,
+                    direction: 1,
+                    action: 0,
+                    target: None,
+                    condition: None,
+                    description: None,
+                    restartable: false,
+                    timing: 0,
+                    priority: 0,
+                    interruptible: false,
+                    queue: None,
+                    sa_flags: 0,
+                    sa_flags_required: 0,
+                    sa_flags_forbidden: 0,
+                    state_required: 0,
+                    state_forbidden: 0,
+                    error_on_signal: None,
+                    transform_to: None,
+                });
+                block = BlockContext::Signal;
+            } else if let Some(rest) = trimmed.strip_prefix("capability:") {
+                let parts: Vec<&str> = rest.split(',').map(|s| s.trim()).collect();
+                if !parts.is_empty() {
+                    let cap_name = parts[0].to_string();
+                    let cap_value = self.parse_capability_value(&cap_name);
+                    // If we have 3 parts, it's flat format: capability: CAP, action, name
+                    let (action, name) = if parts.len() >= 3 {
+                        (parts[1].to_string(), parts[2].to_string())
+                    } else {
+                        (String::new(), cap_name.clone())
+                    };
+                    current_capability = Some(CapabilitySpec {
+                        capability: cap_value,
+                        name,
+                        action,
+                        allows: String::new(),
+                        without_cap: String::new(),
+                        check_condition: None,
+                        priority: Some(0),
+                        alternatives: vec![],
+                    });
+                    block = BlockContext::Capability;
+                }
+            } else if let Some(rest) = trimmed.strip_prefix("side-effect:") {
+                // Could be flat format (comma-separated) or block start
+                let rest = rest.trim();
+                // Check if it's the flat format with commas
+                let comma_parts: Vec<&str> = rest.splitn(3, ',').map(|s| s.trim()).collect();
+                if comma_parts.len() >= 3 {
+                    // Flat format: side-effect: TYPE, target, desc
+                    let mut effect = SideEffectSpec {
+                        effect_type: self.parse_effect_type(comma_parts[0]),
+                        target: comma_parts[1].to_string(),
+                        condition: None,
+                        description: comma_parts[2].to_string(),
+                        reversible: false,
+                    };
+                    if comma_parts[2].contains("reversible=yes") {
+                        effect.reversible = true;
+                    }
+                    spec.side_effects.push(effect);
+                } else {
+                    // Block format: side-effect: TYPE
+                    current_side_effect = Some(SideEffectSpec {
+                        effect_type: self.parse_effect_type(rest),
+                        target: String::new(),
+                        condition: None,
+                        description: String::new(),
+                        reversible: false,
+                    });
+                    block = BlockContext::SideEffect;
+                }
+            } else if let Some(rest) = trimmed.strip_prefix("state-trans:") {
+                // Flat form: state-trans: OBJECT, FROM, TO, DESCRIPTION
+                // (the description may itself contain commas). Block
+                // form: a bare OBJECT followed by from:/to:/condition:/
+                // desc: subfields.
+                if rest.contains(',') {
+                    let mut parts = rest.splitn(4, ',').map(|s| s.trim());
+                    let mut next_part = || parts.next().unwrap_or_default().to_string();
+                    spec.state_transitions.push(StateTransitionSpec {
+                        object: next_part(),
+                        from_state: next_part(),
+                        to_state: next_part(),
+                        condition: None,
+                        description: next_part(),
+                    });
+                } else {
+                    current_state_trans = Some(StateTransitionSpec {
+                        object: rest.trim().to_string(),
+                        from_state: String::new(),
+                        to_state: String::new(),
+                        condition: None,
+                        description: String::new(),
+                    });
+                }
+                block = BlockContext::StateTransition;
+            } else if let Some(rest) = trimmed.strip_prefix("constraint:") {
+                let rest = rest.trim();
+                // Could be flat format: constraint: name, desc
+                // Or block format: constraint: name
+                let parts: Vec<&str> = rest.splitn(2, ',').map(|s| s.trim()).collect();
+                if parts.len() >= 2 {
+                    // Flat format
+                    current_constraint = Some(ConstraintSpec {
+                        name: parts[0].to_string(),
+                        description: parts[1].to_string(),
+                        expression: None,
+                    });
+                } else {
+                    // Block format
+                    current_constraint = Some(ConstraintSpec {
+                        name: rest.to_string(),
+                        description: String::new(),
+                        expression: None,
+                    });
+                }
+                block = BlockContext::Constraint;
+            } else if let Some(rest) = trimmed.strip_prefix("lock:") {
+                let rest = rest.trim();
+                // Could be flat: lock: name, type
+                // Or block: lock: name
+                let parts: Vec<&str> = rest.split(',').map(|s| s.trim()).collect();
+                if parts.len() >= 2 {
+                    current_lock = Some(LockSpec {
+                        lock_name: parts[0].to_string(),
+                        lock_type: self.parse_lock_type(parts[1]),
+                        scope: super::KAPI_LOCK_INTERNAL,
+                        description: String::new(),
+                    });
+                } else {
+                    current_lock = Some(LockSpec {
+                        lock_name: rest.to_string(),
+                        lock_type: 0,
+                        scope: super::KAPI_LOCK_INTERNAL,
+                        description: String::new(),
+                    });
+                }
+                block = BlockContext::Lock;
+            }
+            // Other top-level annotations
+            else if let Some(rest) = trimmed.strip_prefix("return:") {
+                let rest = rest.trim();
+                if rest.is_empty() {
+                    // Block format
+                    current_return = Some(ReturnSpec {
+                        type_name: String::new(),
+                        description: String::new(),
+                        return_type: 0,
+                        check_type: 0,
+                        success_value: None,
+                        success_min: None,
+                        success_max: None,
+                        error_values: vec![],
+                    });
+                    block = BlockContext::Return;
+                }
+            } else if let Some(rest) = trimmed.strip_prefix("examples:") {
+                let (section, next_i) = self.collect_section(&lines, i, rest);
+                let val = fold_lines(&section);
+                spec.examples = Some(val).filter(|v| !v.is_empty());
+                i = next_i;
+                continue;
+            } else if let Some(rest) = trimmed.strip_prefix("notes:") {
+                let (section, next_i) = self.collect_section(&lines, i, rest);
+                let val = fold_paragraphs(&section);
+                spec.notes = Some(val).filter(|v| !v.is_empty());
+                i = next_i;
+                continue;
+            }
+
+            i += 1;
+        }
+
+        // Flush any remaining block. Emit a pending symbolic
+        // `transform-to:` warning if the final state still has no
+        // resolved numeric value (see per-line loop for rationale).
+        if matches!(block, BlockContext::Signal) {
+            if let Some(raw) = pending_transform_warning.take() {
+                eprintln!(
+                    "kapi: warning: transform-to: {raw:?} is symbolic; \
+                     source-mode cannot resolve signal numbers portably. \
+                     Use --vmlinux or --debugfs to get the resolved value.",
+                );
+            }
+        }
+        self.flush_block(
+            &mut block,
+            &mut spec,
+            &mut current_error,
+            &mut current_signal,
+            &mut current_capability,
+            &mut current_side_effect,
+            &mut current_constraint,
+            &mut current_lock,
+            &mut current_return,
+            &mut current_state_trans,
+        );
+
+        // Convert param_map to vec preserving order
+        let mut params: Vec<ParamSpec> = param_map.into_values().collect();
+        params.sort_by_key(|p| p.index);
+
+        // If the spec carries an explicit param-count, warn when it
+        // disagrees with the number of param: blocks we actually saw.
+        if let Some(claimed) = spec.param_count {
+            if claimed as usize != params.len() {
+                eprintln!(
+                    "kapi: {}: param-count: {} disagrees with {} param: block(s)",
+                    name,
+                    claimed,
+                    params.len(),
+                );
+            }
+        }
+
+        for param in &mut params {
+            param.drop_unset_string_limits();
+        }
+        spec.parameters = params;
+
+        Ok(spec)
+    }
+
+    /// Parse an indented attribute line within a block
+    #[allow(clippy::too_many_arguments)]
+    fn parse_block_attribute(
+        &self,
+        trimmed: &str,
+        block: &BlockContext,
+        param_map: &mut HashMap<String, ParamSpec>,
+        current_error: &mut Option<ErrorSpec>,
+        current_signal: &mut Option<SignalSpec>,
+        pending_transform_warning: &mut Option<String>,
+        current_capability: &mut Option<CapabilitySpec>,
+        current_side_effect: &mut Option<SideEffectSpec>,
+        current_constraint: &mut Option<ConstraintSpec>,
+        current_lock: &mut Option<LockSpec>,
+        current_return: &mut Option<ReturnSpec>,
+        current_state_trans: &mut Option<StateTransitionSpec>,
+    ) {
+        match block {
+            BlockContext::Param(param_name) => {
+                if let Some(param) = param_map.get_mut(param_name) {
+                    if let Some(rest) = trimmed.strip_prefix("type:") {
+                        // Accept either:
+                        //   type: KAPI_TYPE_UINT              (long, single token)
+                        //   type: uint                        (short, single token)
+                        //   type: uint, input                 (short, type + flags)
+                        //   type: path, input                 (short, type + flags)
+                        // Single-token inputs leave flags alone; they are
+                        // set by a separate `flags:` line.
+                        //
+                        // User-space pointer types (user_ptr, path) imply
+                        // KAPI_PARAM_USER, so specs don't need to repeat
+                        // `user` after the type.
+                        let mut parts = rest.split(',').map(str::trim);
+                        let type_token = parts.next();
+                        if let Some(ty) = type_token {
+                            param.param_type = self.parse_param_type(ty);
+                        }
+                        for flag in parts {
+                            param.flags |= self.parse_param_flag_token(flag);
+                        }
+                        if type_token.map(type_implies_user_flag).unwrap_or(false) {
+                            param.flags |= 1 << 6; // KAPI_PARAM_USER
+                        }
+                    } else if let Some(rest) = trimmed.strip_prefix("flags:") {
+                        param.flags = self.parse_param_flags(rest.trim());
+                    } else if let Some(rest) = trimmed.strip_prefix("constraint-type:") {
+                        // Accepts `KAPI_CONSTRAINT_*` enum tokens or
+                        // function-call expressions like `range(0, 4096)`
+                        // / `mask(0xff)` / `buffer(2)` that also populate
+                        // the matching numeric fields on `param`.
+                        let text = rest.trim();
+                        if !self.apply_constraint_expr(param, text) {
+                            param.constraint_type = self.parse_constraint_type(text);
+                        }
+                    } else if let Some(rest) = trimmed.strip_prefix("valid-mask:") {
+                        // Symbolic mask values need cpp-level resolution;
+                        // leave that to the binary reader.
+                        let _ = rest;
+                    } else if let Some(rest) = trimmed
+                        .strip_prefix("cdesc:")
+                        .or_else(|| trimmed.strip_prefix("constraint:"))
+                    {
+                        // Free-text constraint description.
+                        param.constraint = Some(rest.trim().to_string());
+                    } else if let Some(rest) = trimmed.strip_prefix("range:") {
+                        let parts: Vec<&str> = rest.split(',').map(|s| s.trim()).collect();
+                        if parts.len() >= 2 {
+                            param.min_value = parts[0].parse().ok();
+                            param.max_value = parts[1].parse().ok();
+                            param.constraint_type = 1; // KAPI_CONSTRAINT_RANGE
+                        }
+                    } else if let Some(rest) = trimmed.strip_prefix("size-param:") {
+                        param.size_param_idx = rest.trim().parse().ok();
+                    } else if let Some(rest) = trimmed.strip_prefix("description:") {
+                        param.description = rest.trim().to_string();
+                    } else if let Some(rest) = trimmed.strip_prefix("desc:") {
+                        param.description = rest.trim().to_string();
+                    } else if !trimmed.contains(':') || trimmed.starts_with("  ") {
+                        // Continuation of the previous attribute's value.
+                        if let Some(c) = param.constraint.as_mut() {
+                            c.push(' ');
+                            c.push_str(trimmed);
+                        }
+                    }
+                }
+            }
+            BlockContext::Error(_) => {
+                if let Some(error) = current_error.as_mut() {
+                    if let Some(rest) = trimmed.strip_prefix("desc:") {
+                        let text = rest.trim().to_string();
+                        if error.description.is_empty() {
+                            error.description = text;
+                        } else {
+                            error.description.push(' ');
+                            error.description.push_str(&text);
+                        }
+                    } else if let Some(rest) = trimmed.strip_prefix("condition:") {
+                        error.condition = rest.trim().to_string();
+                    } else {
+                        // Continuation of description
+                        if !error.description.is_empty() {
+                            error.description.push(' ');
+                            error.description.push_str(trimmed);
+                        }
+                    }
+                }
+            }
+            BlockContext::Signal => {
+                if let Some(signal) = current_signal.as_mut() {
+                    if let Some(rest) = trimmed.strip_prefix("direction:") {
+                        signal.direction = self.parse_signal_direction(rest.trim());
+                    } else if let Some(rest) = trimmed.strip_prefix("action:") {
+                        signal.action = self.parse_signal_action(rest.trim());
+                    } else if let Some(rest) = trimmed.strip_prefix("condition:") {
+                        signal.condition = Some(rest.trim().to_string());
+                    } else if let Some(rest) = trimmed.strip_prefix("desc:") {
+                        let text = rest.trim().to_string();
+                        if signal.description.is_none() {
+                            signal.description = Some(text);
+                        } else if let Some(d) = signal.description.as_mut() {
+                            d.push(' ');
+                            d.push_str(&text);
+                        }
+                    } else if let Some(rest) = trimmed.strip_prefix("errno:") {
+                        // `error:` cannot be used here because kerneldoc
+                        // promotes it to a top-level section header.
+                        //
+                        // Accepted forms:
+                        //   errno: -4         -> numeric literal, stored as-is
+                        //   errno: -EINTR     -> kernel convention; resolve
+                        //                       the symbol and negate
+                        //   errno: EINTR      -> bare symbol; resolved value
+                        //                       is already negative
+                        let value = rest.trim();
+                        signal.error_on_signal = if let Ok(code) = value.parse::<i32>() {
+                            Some(code)
+                        } else if let Some(name) = value.strip_prefix('-') {
+                            // `error_name_to_code` already returns the negated
+                            // code (e.g. "EINTR" -> -4), so `-EINTR` resolves
+                            // to -4 too; the leading `-` on the symbolic form
+                            // is kernel-source convention, not a second negation.
+                            Some(self.error_name_to_code(name))
+                        } else {
+                            Some(self.error_name_to_code(value))
+                        };
+                    } else if let Some(rest) = trimmed.strip_prefix("timing:") {
+                        signal.timing = self.parse_signal_timing(rest.trim());
+                    } else if let Some(rest) = trimmed.strip_prefix("restartable:") {
+                        let val = rest.trim().to_lowercase();
+                        signal.restartable = matches!(val.as_str(), "yes" | "true" | "1");
+                    } else if let Some(rest) = trimmed.strip_prefix("interruptible:") {
+                        let val = rest.trim().to_lowercase();
+                        signal.interruptible = matches!(val.as_str(), "yes" | "true" | "1");
+                    } else if let Some(rest) = trimmed.strip_prefix("priority:") {
+                        signal.priority = rest.trim().parse().unwrap_or(0);
+                    } else if let Some(rest) = trimmed.strip_prefix("target:") {
+                        signal.target = Some(rest.trim().to_string());
+                    } else if let Some(rest) = trimmed
+                        .strip_prefix("queue:")
+                        .or_else(|| trimmed.strip_prefix("queue_behavior:"))
+                    {
+                        signal.queue = Some(rest.trim().to_string());
+                    } else if let Some(rest) = trimmed.strip_prefix("number:") {
+                        signal.signal_num = rest.trim().parse().unwrap_or(0);
+                    } else if let Some(rest) = trimmed
+                        .strip_prefix("transform-to:")
+                        .or_else(|| trimmed.strip_prefix("transform_to:"))
+                        .or_else(|| trimmed.strip_prefix("transform:"))
+                    {
+                        // transform-to: takes a signal constant (e.g.
+                        // SIGKILL) or a numeric literal. Only a numeric
+                        // literal fills `transform_to`; symbolic values
+                        // cannot be resolved portably in userspace
+                        // because signal numbers are arch-dependent and
+                        // we have no access to the target arch's
+                        // <asm/signal.h>. Report such cases to stderr so
+                        // they are not silently lost, and point the user
+                        // at --vmlinux / --debugfs, which consult the
+                        // compiled struct where the C preprocessor has
+                        // already baked in the correct value.
+                        //
+                        // Assign unconditionally so the last line in
+                        // the kerneldoc wins and an intended symbolic
+                        // override doesn't silently leave a stale
+                        // numeric value from an earlier line. The
+                        // warning is deferred until flush_block() so a
+                        // subsequent numeric line can cancel it; if the
+                        // last line was still symbolic we report it
+                        // then.
+                        let v = rest.trim();
+                        let parsed = v.parse::<i32>().ok();
+                        signal.transform_to = parsed;
+                        if parsed.is_some() {
+                            *pending_transform_warning = None;
+                        } else if !v.is_empty() {
+                            *pending_transform_warning = Some(v.to_string());
+                        }
+                    } else if let Some(rest) = trimmed
+                        .strip_prefix("sa-flags-required:")
+                        .or_else(|| trimmed.strip_prefix("sa_flags_required:"))
+                    {
+                        signal.sa_flags_required = self.parse_hex_or_bitmask(rest.trim());
+                    } else if let Some(rest) = trimmed
+                        .strip_prefix("sa-flags-forbidden:")
+                        .or_else(|| trimmed.strip_prefix("sa_flags_forbidden:"))
+                    {
+                        signal.sa_flags_forbidden = self.parse_hex_or_bitmask(rest.trim());
+                    } else if let Some(rest) = trimmed
+                        .strip_prefix("state-required:")
+                        .or_else(|| trimmed.strip_prefix("state_required:"))
+                    {
+                        signal.state_required = self.parse_signal_state_mask(rest.trim());
+                    } else if let Some(rest) = trimmed
+                        .strip_prefix("state-forbidden:")
+                        .or_else(|| trimmed.strip_prefix("state_forbidden:"))
+                    {
+                        signal.state_forbidden = self.parse_signal_state_mask(rest.trim());
+                    } else {
+                        // Continuation of description
+                        if let Some(d) = signal.description.as_mut() {
+                            d.push(' ');
+                            d.push_str(trimmed);
+                        }
+                    }
+                }
+            }
+            BlockContext::Capability => {
+                if let Some(cap) = current_capability.as_mut() {
+                    if let Some(rest) = trimmed.strip_prefix("type:") {
+                        cap.action = canon_kapi_cap_action(rest.trim());
+                    } else if let Some(rest) = trimmed.strip_prefix("allows:") {
+                        cap.allows = rest.trim().to_string();
+                    } else if let Some(rest) = trimmed.strip_prefix("without:") {
+                        cap.without_cap = rest.trim().to_string();
+                    } else if let Some(rest) = trimmed.strip_prefix("condition:") {
+                        cap.check_condition = Some(rest.trim().to_string());
+                    } else if let Some(rest) = trimmed.strip_prefix("priority:") {
+                        cap.priority = rest.trim().parse().ok();
+                    }
+                }
+            }
+            BlockContext::SideEffect => {
+                if let Some(effect) = current_side_effect.as_mut() {
+                    if let Some(rest) = trimmed.strip_prefix("target:") {
+                        effect.target = rest.trim().to_string();
+                    } else if let Some(rest) = trimmed.strip_prefix("condition:") {
+                        effect.condition = Some(rest.trim().to_string());
+                    } else if let Some(rest) = trimmed.strip_prefix("desc:") {
+                        let text = rest.trim().to_string();
+                        if effect.description.is_empty() {
+                            effect.description = text;
+                        } else {
+                            effect.description.push(' ');
+                            effect.description.push_str(&text);
+                        }
+                    } else if let Some(rest) = trimmed.strip_prefix("reversible:") {
+                        let val = rest.trim().to_lowercase();
+                        effect.reversible = matches!(val.as_str(), "yes" | "true" | "1");
+                    } else {
+                        // Continuation of description
+                        if !effect.description.is_empty() {
+                            effect.description.push(' ');
+                            effect.description.push_str(trimmed);
+                        }
+                    }
+                }
+            }
+            BlockContext::Constraint => {
+                if let Some(constraint) = current_constraint.as_mut() {
+                    if let Some(rest) = trimmed.strip_prefix("desc:") {
+                        let text = rest.trim().to_string();
+                        if constraint.description.is_empty() {
+                            constraint.description = text;
+                        } else {
+                            constraint.description.push(' ');
+                            constraint.description.push_str(&text);
+                        }
+                    } else if let Some(rest) = trimmed.strip_prefix("expr:") {
+                        constraint.expression = Some(rest.trim().to_string());
+                    } else {
+                        // Continuation of description
+                        if !constraint.description.is_empty() {
+                            constraint.description.push(' ');
+                            constraint.description.push_str(trimmed);
+                        }
+                    }
+                }
+            }
+            BlockContext::Lock => {
+                if let Some(lock) = current_lock.as_mut() {
+                    if let Some(rest) = trimmed.strip_prefix("type:") {
+                        lock.lock_type = self.parse_lock_type(rest.trim());
+                    } else if let Some(rest) = trimmed.strip_prefix("scope:") {
+                        lock.scope = match rest.trim() {
+                            "internal" => super::KAPI_LOCK_INTERNAL,
+                            "acquires" => super::KAPI_LOCK_ACQUIRES,
+                            "releases" => super::KAPI_LOCK_RELEASES,
+                            "caller_held" => super::KAPI_LOCK_CALLER_HELD,
+                            _ => super::KAPI_LOCK_INTERNAL,
+                        };
+                    } else if let Some(rest) = trimmed.strip_prefix("desc:") {
+                        let text = rest.trim().to_string();
+                        if lock.description.is_empty() {
+                            lock.description = text;
+                        } else {
+                            lock.description.push(' ');
+                            lock.description.push_str(&text);
+                        }
+                    } else if let Some(rest) = trimmed.strip_prefix("acquired:") {
+                        // Same rule as kdoc_apispec.py: a lock that is both
+                        // acquired and released stays KAPI_LOCK_INTERNAL.
+                        if matches!(rest.trim().to_lowercase().as_str(), "true" | "yes") {
+                            lock.scope = if lock.scope == super::KAPI_LOCK_RELEASES {
+                                super::KAPI_LOCK_INTERNAL
+                            } else {
+                                super::KAPI_LOCK_ACQUIRES
+                            };
+                        }
+                    } else if let Some(rest) = trimmed.strip_prefix("released:") {
+                        if matches!(rest.trim().to_lowercase().as_str(), "true" | "yes") {
+                            lock.scope = if lock.scope == super::KAPI_LOCK_ACQUIRES {
+                                super::KAPI_LOCK_INTERNAL
+                            } else {
+                                super::KAPI_LOCK_RELEASES
+                            };
+                        }
+                    } else {
+                        // Continuation of description
+                        if !lock.description.is_empty() {
+                            lock.description.push(' ');
+                            lock.description.push_str(trimmed);
+                        }
+                    }
+                }
+            }
+            BlockContext::Return => {
+                if let Some(ret) = current_return.as_mut() {
+                    if let Some(rest) = trimmed.strip_prefix("type:") {
+                        let raw = rest.trim();
+                        ret.type_name = raw.to_string();
+                        ret.return_type = self.parse_param_type(raw);
+                    } else if let Some(rest) = trimmed.strip_prefix("check-type:") {
+                        ret.check_type = self.parse_return_check_type(rest.trim());
+                    } else if let Some(rest) = trimmed.strip_prefix("success:") {
+                        (ret.success_value, ret.success_min, ret.success_max) =
+                            parse_return_success(rest.trim());
+                    } else if let Some(rest) = trimmed.strip_prefix("desc:") {
+                        let text = rest.trim().to_string();
+                        if ret.description.is_empty() {
+                            ret.description = text;
+                        } else {
+                            ret.description.push(' ');
+                            ret.description.push_str(&text);
+                        }
+                    } else {
+                        // Continuation of description
+                        if !ret.description.is_empty() {
+                            ret.description.push(' ');
+                            ret.description.push_str(trimmed);
+                        }
+                    }
+                }
+            }
+            BlockContext::StateTransition => {
+                if let Some(trans) = current_state_trans.as_mut() {
+                    if let Some(rest) = trimmed.strip_prefix("object:") {
+                        trans.object = rest.trim().to_string();
+                    } else if let Some(rest) = trimmed.strip_prefix("from:") {
+                        trans.from_state = rest.trim().to_string();
+                    } else if let Some(rest) = trimmed.strip_prefix("to:") {
+                        trans.to_state = rest.trim().to_string();
+                    } else if let Some(rest) = trimmed.strip_prefix("condition:") {
+                        trans.condition = Some(rest.trim().to_string());
+                    } else if let Some(rest) = trimmed.strip_prefix("desc:") {
+                        trans.description = rest.trim().to_string();
+                    }
+                }
+            }
+            BlockContext::None => {}
+        }
+    }
+
+    /// Flush the current block, pushing items into the spec
+    #[allow(clippy::too_many_arguments)]
+    fn flush_block(
+        &self,
+        block: &mut BlockContext,
+        spec: &mut ApiSpec,
+        current_error: &mut Option<ErrorSpec>,
+        current_signal: &mut Option<SignalSpec>,
+        current_capability: &mut Option<CapabilitySpec>,
+        current_side_effect: &mut Option<SideEffectSpec>,
+        current_constraint: &mut Option<ConstraintSpec>,
+        current_lock: &mut Option<LockSpec>,
+        current_return: &mut Option<ReturnSpec>,
+        current_state_trans: &mut Option<StateTransitionSpec>,
+    ) {
+        match block {
+            BlockContext::Error(_) => {
+                if let Some(error) = current_error.take() {
+                    spec.errors.push(error);
+                }
+            }
+            BlockContext::Signal => {
+                if let Some(signal) = current_signal.take() {
+                    spec.signals.push(signal);
+                }
+            }
+            BlockContext::Capability => {
+                if let Some(cap) = current_capability.take() {
+                    spec.capabilities.push(cap);
+                }
+            }
+            BlockContext::SideEffect => {
+                if let Some(effect) = current_side_effect.take() {
+                    spec.side_effects.push(effect);
+                }
+            }
+            BlockContext::Constraint => {
+                if let Some(constraint) = current_constraint.take() {
+                    spec.constraints.push(constraint);
+                }
+            }
+            BlockContext::Lock => {
+                if let Some(lock) = current_lock.take() {
+                    spec.locks.push(lock);
+                }
+            }
+            BlockContext::Return => {
+                if let Some(mut ret) = current_return.take() {
+                    ret.keep_used_success_fields();
+                    spec.return_spec = Some(ret);
+                }
+            }
+            BlockContext::StateTransition => {
+                if let Some(trans) = current_state_trans.take() {
+                    spec.state_transitions.push(trans);
+                }
+            }
+            _ => {}
+        }
+        *block = BlockContext::None;
+    }
+
+    /// Extract parameter type names from SYSCALL_DEFINE signature
+    fn extract_types_from_signature(&self, sig: &str) -> HashMap<String, String> {
+        let mut types = HashMap::new();
+
+        // Find content between outermost parens
+        let content = if let Some(start) = sig.find('(') {
+            let end = sig.rfind(')').unwrap_or(sig.len());
+            &sig[start + 1..end]
+        } else {
+            return types;
+        };
+
+        // Split by comma and process type/name pairs
+        // SYSCALL_DEFINE format: (syscall_name, type1, name1, type2, name2, ...)
+        let parts: Vec<&str> = content.split(',').map(|s| s.trim()).collect();
+
+        // Skip first part (syscall name), then process pairs
+        let mut i = 1;
+        while i + 1 < parts.len() {
+            let type_part = parts[i].trim();
+            let name_part = parts[i + 1].trim();
+
+            // Build the type_name string: "type name"
+            let type_name = format!("{} {}", type_part, name_part);
+            types.insert(name_part.to_string(), type_name);
+
+            i += 2;
+        }
+
+        types
+    }
+
+    /// Collect the raw lines of a free-form section: the text after the
+    /// key plus every following indented or blank line, up to the next
+    /// annotation line.
+    fn collect_section<'a>(
+        &self,
+        lines: &[&'a str],
+        start_idx: usize,
+        first_part: &'a str,
+    ) -> (Vec<&'a str>, usize) {
+        let mut section = vec![first_part];
+        let mut i = start_idx + 1;
+
+        while i < lines.len() {
+            let line = lines[i];
+            if self.is_annotation_line(line) {
+                break;
+            }
+            if !line.trim().is_empty() && !is_indented_line(line) {
+                break;
+            }
+            section.push(line);
+            i += 1;
+        }
+
+        (section, i)
+    }
+
+    fn is_annotation_line(&self, line: &str) -> bool {
+        let trimmed = line.trim_start();
+        if !trimmed.contains(':') {
+            return false;
+        }
+        let annotations = [
+            "param:",
+            "param-count:",
+            "error:",
+            "lock:",
+            "signal:",
+            "side-effect:",
+            "state-trans:",
+            "capability:",
+            "constraint:",
+            "return:",
+            "examples:",
+            "notes:",
+            "context-",
+            "long-desc:",
+            "api-type:",
+        ];
+
+        for ann in &annotations {
+            if trimmed.starts_with(ann) {
+                return true;
+            }
+        }
+        false
+    }
+
+    /// Parse a constraint expression and apply it to `param`.
+    /// Shapes:
+    ///   NAME                         (e.g. "user_path", "nonzero")
+    ///   NAME ( ARG (, ARG)* )        (e.g. "range(0, 4096)", "buffer(2)")
+    /// Returns true if the expression matched a known constraint kind,
+    /// populating `param`'s numeric fields. Returns false if the text
+    /// is free-form, leaving `param` untouched.
+    fn apply_constraint_expr(&self, param: &mut ParamSpec, text: &str) -> bool {
+        let t = text.trim();
+        if t.is_empty() {
+            return false;
+        }
+        // Split NAME ( ARGS ); no nesting, no escaping.
+        let (name, args): (&str, Option<&str>) = match (t.find('('), t.rfind(')')) {
+            (Some(lp), Some(rp)) if rp > lp => (t[..lp].trim(), Some(t[lp + 1..rp].trim())),
+            _ => (t, None),
+        };
+        // Bail out on anything that looks like free text (spaces inside the
+        // name part).
+        if name.contains(char::is_whitespace) || name.is_empty() {
+            return false;
+        }
+        let name_lc = name.to_ascii_lowercase();
+        let split_args = || -> Vec<String> {
+            args.map(|a| a.split(',').map(|s| s.trim().to_string()).collect())
+                .unwrap_or_default()
+        };
+        match name_lc.as_str() {
+            "range" => {
+                let a = split_args();
+                if a.len() != 2 {
+                    return false;
+                }
+                param.min_value = parse_i64_literal(&a[0]);
+                param.max_value = parse_i64_literal(&a[1]);
+                param.constraint_type = 1; // KAPI_CONSTRAINT_RANGE
+                true
+            }
+            "mask" => {
+                let a = split_args();
+                if a.len() != 1 {
+                    return false;
+                }
+                // Symbolic masks (e.g. "O_RDONLY | O_WRONLY | ...") can't
+                // be resolved at parse time; leave valid_mask as None so
+                // downstream consumers treat the mask as unknown, matching
+                // the long-form `valid-mask:` handler (which also leaves
+                // the slot untouched when the value isn't a literal).
+                param.valid_mask = parse_u64_literal(&a[0]);
+                param.constraint_type = 2; // KAPI_CONSTRAINT_MASK
+                true
+            }
+            "enum" => {
+                let a = split_args();
+                if a.is_empty() {
+                    return false;
+                }
+                // --vmlinux and --debugfs report each value in decimal, so
+                // numeric literals are normalised; symbolic names stay.
+                param.enum_values = a
+                    .into_iter()
+                    .map(|v| parse_i64_literal(&v).map_or(v, |n| n.to_string()))
+                    .collect();
+                param.constraint_type = 3; // KAPI_CONSTRAINT_ENUM
+                true
+            }
+            "alignment" | "align" => {
+                let a = split_args();
+                if a.len() != 1 {
+                    return false;
+                }
+                param.alignment = parse_u64_literal(&a[0]).and_then(|n| u32::try_from(n).ok());
+                param.constraint_type = 4; // KAPI_CONSTRAINT_ALIGNMENT
+                true
+            }
+            "power_of_two" => {
+                if args.is_some() {
+                    return false;
+                }
+                param.constraint_type = 5; // KAPI_CONSTRAINT_POWER_OF_TWO
+                true
+            }
+            "page_aligned" => {
+                if args.is_some() {
+                    return false;
+                }
+                param.constraint_type = 6; // KAPI_CONSTRAINT_PAGE_ALIGNED
+                true
+            }
+            "nonzero" => {
+                if args.is_some() {
+                    return false;
+                }
+                param.constraint_type = 7; // KAPI_CONSTRAINT_NONZERO
+                true
+            }
+            "user_string" => {
+                // Optional size argument: user_string(N)
+                if let Some(arg) = args {
+                    if let Some(n) = parse_u64_literal(arg).and_then(|n| u32::try_from(n).ok()) {
+                        param.size = Some(n);
+                    }
+                }
+                param.constraint_type = 8; // KAPI_CONSTRAINT_USER_STRING
+                true
+            }
+            "user_path" => {
+                if args.is_some() {
+                    return false;
+                }
+                param.constraint_type = 9; // KAPI_CONSTRAINT_USER_PATH
+                true
+            }
+            "user_ptr" => {
+                if args.is_some() {
+                    return false;
+                }
+                param.constraint_type = 10; // KAPI_CONSTRAINT_USER_PTR
+                true
+            }
+            "buffer" => {
+                // buffer(size_param_idx): capture the index into
+                // param.size_param_idx so it matches the long-form
+                // `size-param: N` handler below (and the C struct
+                // field populated by KAPI_PARAM_SIZE_PARAM()).
+                let a = split_args();
+                if a.len() != 1 {
+                    return false;
+                }
+                param.size_param_idx = a[0].parse().ok();
+                param.constraint_type = 11; // KAPI_CONSTRAINT_BUFFER
+                true
+            }
+            "custom" => {
+                // custom(fn_name): record function name as free-text constraint
+                // so downstream tooling can wire it up.
+                if let Some(arg) = args {
+                    param.constraint = Some(arg.trim().to_string());
+                }
+                param.constraint_type = 12; // KAPI_CONSTRAINT_CUSTOM
+                true
+            }
+            _ => false,
+        }
+    }
+
+    fn parse_context_flags(&self, flags: &str) -> Vec<String> {
+        flags
+            .split('|')
+            .map(|f| self.ctx_alias(f.trim()).to_string())
+            .filter(|f| !f.is_empty())
+            .collect()
+    }
+
+    /// Parse a comma-separated short-form context list
+    /// (e.g. "process, sleepable" -> ["KAPI_CTX_PROCESS", "KAPI_CTX_SLEEPABLE"]).
+    /// Tokens that already look like KAPI_CTX_* are passed through.
+    fn parse_context_list(&self, flags: &str) -> Vec<String> {
+        flags
+            .split(',')
+            .map(|f| self.ctx_alias(f.trim()).to_string())
+            .filter(|f| !f.is_empty())
+            .collect()
+    }
+
+    /// Canonicalise a single context token to its KAPI_CTX_* spelling.
+    /// Short aliases are case-insensitive. Unknown tokens pass through
+    /// verbatim so mixed/long-form input keeps working.
+    fn ctx_alias(&self, tok: &str) -> String {
+        let t = tok.trim();
+        if t.is_empty() {
+            return String::new();
+        }
+        match t.to_ascii_lowercase().as_str() {
+            "process" => "KAPI_CTX_PROCESS".to_string(),
+            "softirq" => "KAPI_CTX_SOFTIRQ".to_string(),
+            "hardirq" => "KAPI_CTX_HARDIRQ".to_string(),
+            "nmi" => "KAPI_CTX_NMI".to_string(),
+            "atomic" => "KAPI_CTX_ATOMIC".to_string(),
+            "sleepable" => "KAPI_CTX_SLEEPABLE".to_string(),
+            "preempt_disabled" => "KAPI_CTX_PREEMPT_DISABLED".to_string(),
+            "irq_disabled" => "KAPI_CTX_IRQ_DISABLED".to_string(),
+            _ => t.to_string(),
+        }
+    }
+
+    fn error_name_to_code(&self, name: &str) -> i32 {
+        match name {
+            "EPERM" => -1,
+            "ENOENT" => -2,
+            "ESRCH" => -3,
+            "EINTR" => -4,
+            "EIO" => -5,
+            "ENXIO" => -6,
+            "E2BIG" => -7,
+            "ENOEXEC" => -8,
+            "EBADF" => -9,
+            "ECHILD" => -10,
+            "EAGAIN" | "EWOULDBLOCK" => -11,
+            "ENOMEM" => -12,
+            "EACCES" => -13,
+            "EFAULT" => -14,
+            "ENOTBLK" => -15,
+            "EBUSY" => -16,
+            "EEXIST" => -17,
+            "EXDEV" => -18,
+            "ENODEV" => -19,
+            "ENOTDIR" => -20,
+            "EISDIR" => -21,
+            "EINVAL" => -22,
+            "ENFILE" => -23,
+            "EMFILE" => -24,
+            "ENOTTY" => -25,
+            "ETXTBSY" => -26,
+            "EFBIG" => -27,
+            "ENOSPC" => -28,
+            "ESPIPE" => -29,
+            "EROFS" => -30,
+            "EMLINK" => -31,
+            "EPIPE" => -32,
+            "EDOM" => -33,
+            "ERANGE" => -34,
+            "EDEADLK" => -35,
+            "ENAMETOOLONG" => -36,
+            "ENOLCK" => -37,
+            "ENOSYS" => -38,
+            "ENOTEMPTY" => -39,
+            "ELOOP" => -40,
+            "ENOMSG" => -42,
+            "ENODATA" => -61,
+            "ENOLINK" => -67,
+            "EPROTO" => -71,
+            "EOVERFLOW" => -75,
+            "ELIBBAD" => -80,
+            "EILSEQ" => -84,
+            "ENOTSOCK" => -88,
+            "EDESTADDRREQ" => -89,
+            "EMSGSIZE" => -90,
+            "EPROTOTYPE" => -91,
+            "ENOPROTOOPT" => -92,
+            "EPROTONOSUPPORT" => -93,
+            "EOPNOTSUPP" | "ENOTSUP" => -95,
+            "EADDRINUSE" => -98,
+            "EADDRNOTAVAIL" => -99,
+            "ENETDOWN" => -100,
+            "ENETUNREACH" => -101,
+            "ENETRESET" => -102,
+            "ECONNABORTED" => -103,
+            "ECONNRESET" => -104,
+            "ENOBUFS" => -105,
+            "EISCONN" => -106,
+            "ENOTCONN" => -107,
+            "ETIMEDOUT" => -110,
+            "ECONNREFUSED" => -111,
+            "EALREADY" => -114,
+            "EINPROGRESS" => -115,
+            "ESTALE" => -116,
+            "EDQUOT" => -122,
+            "ENOMEDIUM" => -123,
+            "ENOKEY" => -126,
+            "EHWPOISON" => -133,
+            "ERESTARTSYS" => -512,
+            _ => 0,
+        }
+    }
+
+    /// Map a KAPI_TYPE_* token (or its short-form alias) to the numeric
+    /// value declared in `enum kapi_param_type` in
+    /// `include/linux/kernel_api_spec.h`.
+    fn parse_param_type(&self, type_str: &str) -> u32 {
+        let s = type_str.trim();
+        match s {
+            "KAPI_TYPE_VOID" => 0,
+            "KAPI_TYPE_INT" => 1,
+            "KAPI_TYPE_UINT" => 2,
+            "KAPI_TYPE_PTR" => 3,
+            "KAPI_TYPE_STRUCT" => 4,
+            "KAPI_TYPE_UNION" => 5,
+            "KAPI_TYPE_ENUM" => 6,
+            "KAPI_TYPE_FUNC_PTR" => 7,
+            "KAPI_TYPE_ARRAY" => 8,
+            "KAPI_TYPE_FD" => 9,
+            "KAPI_TYPE_USER_PTR" => 10,
+            "KAPI_TYPE_PATH" => 11,
+            "KAPI_TYPE_CUSTOM" => 12,
+            _ => match s.to_ascii_lowercase().as_str() {
+                "void" => 0,
+                "int" => 1,
+                "uint" => 2,
+                "ptr" => 3,
+                "struct" => 4,
+                "union" => 5,
+                "enum" => 6,
+                "func_ptr" => 7,
+                "array" => 8,
+                "fd" => 9,
+                "user_ptr" | "uptr" => 10,
+                "path" => 11,
+                "custom" => 12,
+                _ => 0,
+            },
+        }
+    }
+
+    /// Map a KAPI_CONSTRAINT_* token to the numeric value declared in
+    /// `enum kapi_constraint_type` in `include/linux/kernel_api_spec.h`.
+    fn parse_constraint_type(&self, type_str: &str) -> u32 {
+        let s = type_str.trim();
+        match s {
+            "KAPI_CONSTRAINT_NONE" => 0,
+            "KAPI_CONSTRAINT_RANGE" => 1,
+            "KAPI_CONSTRAINT_MASK" => 2,
+            "KAPI_CONSTRAINT_ENUM" => 3,
+            "KAPI_CONSTRAINT_ALIGNMENT" => 4,
+            "KAPI_CONSTRAINT_POWER_OF_TWO" => 5,
+            "KAPI_CONSTRAINT_PAGE_ALIGNED" => 6,
+            "KAPI_CONSTRAINT_NONZERO" => 7,
+            "KAPI_CONSTRAINT_USER_STRING" => 8,
+            "KAPI_CONSTRAINT_USER_PATH" => 9,
+            "KAPI_CONSTRAINT_USER_PTR" => 10,
+            "KAPI_CONSTRAINT_BUFFER" => 11,
+            "KAPI_CONSTRAINT_CUSTOM" => 12,
+            _ => 0,
+        }
+    }
+
+    fn parse_param_flags(&self, flags: &str) -> u32 {
+        flags
+            .split('|')
+            .map(|f| self.parse_param_flag_token(f.trim()))
+            .fold(0, |acc, bit| acc | bit)
+    }
+
+    /// Parse one flag token (long or short form, case-insensitive for
+    /// short form). Returns 0 for unknown tokens.
+    fn parse_param_flag_token(&self, tok: &str) -> u32 {
+        let t = tok.trim();
+        // KAPI_PARAM_* names and upper-case short forms first.
+        match t {
+            "KAPI_PARAM_IN" | "IN" => return 1,
+            "KAPI_PARAM_OUT" | "OUT" => return 2,
+            "KAPI_PARAM_INOUT" | "INOUT" => return 3,
+            "KAPI_PARAM_OPTIONAL" | "OPTIONAL" => return 1 << 3,
+            "KAPI_PARAM_CONST" | "CONST" => return 1 << 4,
+            "KAPI_PARAM_VOLATILE" | "VOLATILE" => return 1 << 5,
+            "KAPI_PARAM_USER" | "USER" => return 1 << 6,
+            "KAPI_PARAM_DMA" | "DMA" => return 1 << 7,
+            "KAPI_PARAM_ALIGNED" | "ALIGNED" => return 1 << 8,
+            _ => {}
+        }
+        // English short aliases (case-insensitive).
+        match t.to_ascii_lowercase().as_str() {
+            "input" => 1,
+            "output" => 2,
+            "inout" => 3,
+            "optional" => 1 << 3,
+            "const" => 1 << 4,
+            "volatile" => 1 << 5,
+            "user" => 1 << 6,
+            "dma" => 1 << 7,
+            "aligned" => 1 << 8,
+            _ => 0,
+        }
+    }
+
+    /// Map a KAPI_LOCK_* token to the numeric value declared in
+    /// `enum kapi_lock_type` in `include/linux/kernel_api_spec.h`.
+    fn parse_lock_type(&self, type_str: &str) -> u32 {
+        let s = type_str.trim();
+        match s {
+            "KAPI_LOCK_NONE" => 0,
+            "KAPI_LOCK_MUTEX" => 1,
+            "KAPI_LOCK_SPINLOCK" => 2,
+            "KAPI_LOCK_RWLOCK" => 3,
+            "KAPI_LOCK_SEQLOCK" => 4,
+            "KAPI_LOCK_RCU" => 5,
+            "KAPI_LOCK_SEMAPHORE" => 6,
+            "KAPI_LOCK_CUSTOM" => 7,
+            _ => match s.to_ascii_lowercase().as_str() {
+                "none" => 0,
+                "mutex" => 1,
+                "spinlock" => 2,
+                "rwlock" => 3,
+                "seqlock" => 4,
+                "rcu" => 5,
+                "semaphore" => 6,
+                "custom" => 7,
+                _ => 0,
+            },
+        }
+    }
+
+    fn parse_signal_direction(&self, dir: &str) -> u32 {
+        let s = dir.trim();
+        match s {
+            "KAPI_SIGNAL_RECEIVE" => 1,
+            "KAPI_SIGNAL_SEND" => 2,
+            "KAPI_SIGNAL_HANDLE" => 4,
+            "KAPI_SIGNAL_BLOCK" => 8,
+            "KAPI_SIGNAL_IGNORE" => 16,
+            _ => match s.to_ascii_lowercase().as_str() {
+                "receive" => 1,
+                "send" => 2,
+                "handle" => 4,
+                "block" => 8,
+                "ignore" => 16,
+                _ => 0,
+            },
+        }
+    }
+
+    fn parse_signal_action(&self, action: &str) -> u32 {
+        let s = action.trim();
+        match s {
+            "KAPI_SIGNAL_ACTION_DEFAULT" => 0,
+            "KAPI_SIGNAL_ACTION_TERMINATE" => 1,
+            "KAPI_SIGNAL_ACTION_COREDUMP" => 2,
+            "KAPI_SIGNAL_ACTION_STOP" => 3,
+            "KAPI_SIGNAL_ACTION_CONTINUE" => 4,
+            "KAPI_SIGNAL_ACTION_CUSTOM" => 5,
+            "KAPI_SIGNAL_ACTION_RETURN" => 6,
+            "KAPI_SIGNAL_ACTION_RESTART" => 7,
+            "KAPI_SIGNAL_ACTION_QUEUE" => 8,
+            "KAPI_SIGNAL_ACTION_DISCARD" => 9,
+            "KAPI_SIGNAL_ACTION_TRANSFORM" => 10,
+            _ => match s.to_ascii_lowercase().as_str() {
+                "default" => 0,
+                "terminate" => 1,
+                "coredump" => 2,
+                "stop" => 3,
+                "continue" => 4,
+                "custom" => 5,
+                "return" => 6,
+                "restart" => 7,
+                "queue" => 8,
+                "discard" => 9,
+                "transform" => 10,
+                _ => 0,
+            },
+        }
+    }
+
+    fn parse_signal_timing(&self, timing: &str) -> u32 {
+        let s = timing.trim();
+        match s {
+            "KAPI_SIGNAL_TIME_BEFORE" => 0,
+            "KAPI_SIGNAL_TIME_DURING" => 1,
+            "KAPI_SIGNAL_TIME_AFTER" => 2,
+            _ => match s.to_ascii_lowercase().as_str() {
+                "before" => 0,
+                "during" => 1,
+                "after" => 2,
+                _ => 0,
+            },
+        }
+    }
+
+    /// Accept a hex literal ("0x4"), a decimal literal ("4"), or a '|'-separated
+    /// bitmask expression. Unknown tokens contribute 0.
+    fn parse_hex_or_bitmask(&self, value: &str) -> u32 {
+        let v = value.trim();
+        if let Some(hex) = v.strip_prefix("0x").or_else(|| v.strip_prefix("0X")) {
+            if let Ok(n) = u32::from_str_radix(hex, 16) {
+                return n;
+            }
+        }
+        if let Ok(n) = v.parse::<u32>() {
+            return n;
+        }
+        let mut acc = 0u32;
+        for part in v.split(['|', ',']) {
+            let t = part.trim();
+            if t.is_empty() {
+                continue;
+            }
+            if let Some(hex) = t.strip_prefix("0x").or_else(|| t.strip_prefix("0X")) {
+                if let Ok(n) = u32::from_str_radix(hex, 16) {
+                    acc |= n;
+                    continue;
+                }
+            }
+            if let Ok(n) = t.parse::<u32>() {
+                acc |= n;
+            }
+        }
+        acc
+    }
+
+    /// Parse a '|'-separated list of KAPI_SIGNAL_STATE_* tokens (or short
+    /// names like "RUNNING") and OR their bit values together. Matches the
+    /// BIT(N) definitions in kernel_api_spec.h.
+    fn parse_signal_state_mask(&self, value: &str) -> u32 {
+        let mut acc = 0u32;
+        for part in value.split(['|', ',']) {
+            let t = part.trim().trim_start_matches("KAPI_SIGNAL_STATE_");
+            let bit = match t.to_ascii_uppercase().as_str() {
+                "RUNNING" => 1 << 0,
+                "SLEEPING" => 1 << 1,
+                "STOPPED" => 1 << 2,
+                "TRACED" => 1 << 3,
+                "ZOMBIE" => 1 << 4,
+                "DEAD" => 1 << 5,
+                _ => 0,
+            };
+            acc |= bit;
+        }
+        acc
+    }
+
+    /// Bitmask of `KAPI_EFFECT_*` values joined by '|' or ','.
+    /// Values match `enum kapi_side_effect_type` in
+    /// `include/linux/kernel_api_spec.h`.
+    fn parse_effect_type(&self, type_str: &str) -> u32 {
+        let sep = if type_str.contains('|') || !type_str.contains(',') {
+            '|'
+        } else {
+            ','
+        };
+        let mut result = 0;
+        for flag in type_str.split(sep) {
+            let t = flag.trim();
+            let bit = match t {
+                "KAPI_EFFECT_NONE" => 0,
+                "KAPI_EFFECT_ALLOC_MEMORY" => 1 << 0,
+                "KAPI_EFFECT_FREE_MEMORY" => 1 << 1,
+                "KAPI_EFFECT_MODIFY_STATE" => 1 << 2,
+                "KAPI_EFFECT_SIGNAL_SEND" => 1 << 3,
+                "KAPI_EFFECT_FILE_POSITION" => 1 << 4,
+                "KAPI_EFFECT_LOCK_ACQUIRE" => 1 << 5,
+                "KAPI_EFFECT_LOCK_RELEASE" => 1 << 6,
+                "KAPI_EFFECT_RESOURCE_CREATE" => 1 << 7,
+                "KAPI_EFFECT_RESOURCE_DESTROY" => 1 << 8,
+                "KAPI_EFFECT_SCHEDULE" => 1 << 9,
+                "KAPI_EFFECT_HARDWARE" => 1 << 10,
+                "KAPI_EFFECT_NETWORK" => 1 << 11,
+                "KAPI_EFFECT_FILESYSTEM" => 1 << 12,
+                "KAPI_EFFECT_PROCESS_STATE" => 1 << 13,
+                "KAPI_EFFECT_IRREVERSIBLE" => 1 << 14,
+                _ => match t.to_ascii_lowercase().as_str() {
+                    "none" => 0,
+                    "alloc_memory" => 1 << 0,
+                    "free_memory" => 1 << 1,
+                    "modify_state" => 1 << 2,
+                    "signal_send" => 1 << 3,
+                    "file_position" => 1 << 4,
+                    "lock_acquire" => 1 << 5,
+                    "lock_release" => 1 << 6,
+                    "resource_create" => 1 << 7,
+                    "resource_destroy" => 1 << 8,
+                    "schedule" => 1 << 9,
+                    "hardware" => 1 << 10,
+                    "network" => 1 << 11,
+                    "filesystem" => 1 << 12,
+                    "process_state" => 1 << 13,
+                    "irreversible" => 1 << 14,
+                    _ => 0,
+                },
+            };
+            result |= bit;
+        }
+        result
+    }
+
+    fn parse_capability_value(&self, cap: &str) -> i32 {
+        match cap {
+            "CAP_CHOWN" => 0,
+            "CAP_DAC_OVERRIDE" => 1,
+            "CAP_DAC_READ_SEARCH" => 2,
+            "CAP_FOWNER" => 3,
+            "CAP_FSETID" => 4,
+            "CAP_KILL" => 5,
+            "CAP_SETGID" => 6,
+            "CAP_SETUID" => 7,
+            "CAP_SETPCAP" => 8,
+            "CAP_LINUX_IMMUTABLE" => 9,
+            "CAP_NET_BIND_SERVICE" => 10,
+            "CAP_NET_BROADCAST" => 11,
+            "CAP_NET_ADMIN" => 12,
+            "CAP_NET_RAW" => 13,
+            "CAP_IPC_LOCK" => 14,
+            "CAP_IPC_OWNER" => 15,
+            "CAP_SYS_MODULE" => 16,
+            "CAP_SYS_RAWIO" => 17,
+            "CAP_SYS_CHROOT" => 18,
+            "CAP_SYS_PTRACE" => 19,
+            "CAP_SYS_PACCT" => 20,
+            "CAP_SYS_ADMIN" => 21,
+            "CAP_SYS_BOOT" => 22,
+            "CAP_SYS_NICE" => 23,
+            "CAP_SYS_RESOURCE" => 24,
+            "CAP_SYS_TIME" => 25,
+            "CAP_SYS_TTY_CONFIG" => 26,
+            "CAP_MKNOD" => 27,
+            "CAP_LEASE" => 28,
+            "CAP_AUDIT_WRITE" => 29,
+            "CAP_AUDIT_CONTROL" => 30,
+            "CAP_SETFCAP" => 31,
+            "CAP_MAC_OVERRIDE" => 32,
+            "CAP_MAC_ADMIN" => 33,
+            "CAP_SYSLOG" => 34,
+            "CAP_WAKE_ALARM" => 35,
+            "CAP_BLOCK_SUSPEND" => 36,
+            "CAP_AUDIT_READ" => 37,
+            "CAP_PERFMON" => 38,
+            "CAP_BPF" => 39,
+            "CAP_CHECKPOINT_RESTORE" => 40,
+            _ => 0,
+        }
+    }
+
+    /// Map a KAPI_RETURN_* token to the numeric value declared in
+    /// `enum kapi_return_check_type` in `include/linux/kernel_api_spec.h`.
+    fn parse_return_check_type(&self, check: &str) -> u32 {
+        let s = check.trim();
+        match s {
+            "KAPI_RETURN_EXACT" => 0,
+            "KAPI_RETURN_RANGE" => 1,
+            "KAPI_RETURN_ERROR_CHECK" => 2,
+            "KAPI_RETURN_FD" => 3,
+            "KAPI_RETURN_CUSTOM" => 4,
+            "KAPI_RETURN_NO_RETURN" => 5,
+            _ => match s.to_ascii_lowercase().as_str() {
+                "exact" => 0,
+                "range" => 1,
+                "error_check" => 2,
+                "fd" => 3,
+                "custom" => 4,
+                "no_return" => 5,
+                _ => 0,
+            },
+        }
+    }
+}
+
+#[cfg(test)]
+mod tests {
+    use super::*;
+
+    fn parser() -> KerneldocParser {
+        KerneldocParser::new()
+    }
+
+    #[test]
+    fn parse_minimal_kerneldoc() {
+        let doc = "\
+sys_foo - Do something useful
+context-flags: KAPI_CTX_PROCESS
+param-count: 1
+@fd: The file descriptor
+error: EBADF, Bad file descriptor
+";
+        let spec = parser()
+            .parse_kerneldoc(doc, "sys_foo", "syscall", None)
+            .unwrap();
+
+        assert_eq!(spec.name, "sys_foo");
+        assert_eq!(spec.api_type, "syscall");
+        assert_eq!(spec.description.as_deref(), Some("Do something useful"));
+        assert_eq!(spec.param_count, Some(1));
+        assert_eq!(spec.parameters.len(), 1);
+        assert_eq!(spec.parameters[0].name, "fd");
+        assert_eq!(spec.parameters[0].description, "The file descriptor");
+        assert_eq!(spec.errors.len(), 1);
+        assert_eq!(spec.errors[0].name, "EBADF");
+        assert_eq!(spec.errors[0].error_code, -9);
+    }
+
+    #[test]
+    fn parse_multiple_param_types() {
+        let doc = "\
+sys_bar - Multiple params
+@fd: file descriptor arg
+@buf: user buffer
+@count: byte count
+@flags: option flags
+param: fd
+  type: KAPI_TYPE_FD
+param: buf
+  type: KAPI_TYPE_USER_PTR
+param: count
+  type: KAPI_TYPE_UINT
+param: flags
+  type: KAPI_TYPE_UINT
+";
+        let sig = "(bar, int, fd, char __user *, buf, size_t, count, unsigned long, flags)";
+        let spec = parser()
+            .parse_kerneldoc(doc, "sys_bar", "syscall", Some(sig))
+            .unwrap();
+
+        assert_eq!(spec.parameters.len(), 4);
+
+        let fd_param = spec.parameters.iter().find(|p| p.name == "fd").unwrap();
+        assert_eq!(fd_param.param_type, 9); // FD (kernel enum)
+
+        let buf_param = spec.parameters.iter().find(|p| p.name == "buf").unwrap();
+        assert_eq!(buf_param.param_type, 10); // USER_PTR (kernel enum)
+        assert_eq!(buf_param.type_name, "char __user * buf");
+
+        let count_param = spec.parameters.iter().find(|p| p.name == "count").unwrap();
+        assert_eq!(count_param.param_type, 2); // UINT
+
+        let flags_param = spec.parameters.iter().find(|p| p.name == "flags").unwrap();
+        assert_eq!(flags_param.param_type, 2); // UINT
+    }
+
+    #[test]
+    fn parse_error_codes_with_descriptions() {
+        let doc = "\
+sys_err - Error test
+error: EBADF
+  desc: Bad file descriptor
+  condition: fd < 0
+error: EFAULT
+  desc: Bad user pointer
+  condition: buf is NULL
+error: EINVAL
+  desc: Invalid argument
+";
+        let spec = parser()
+            .parse_kerneldoc(doc, "sys_err", "syscall", None)
+            .unwrap();
+
+        assert_eq!(spec.errors.len(), 3);
+
+        assert_eq!(spec.errors[0].name, "EBADF");
+        assert_eq!(spec.errors[0].error_code, -9);
+        assert_eq!(spec.errors[0].description, "Bad file descriptor");
+        assert_eq!(spec.errors[0].condition, "fd < 0");
+
+        assert_eq!(spec.errors[1].name, "EFAULT");
+        assert_eq!(spec.errors[1].error_code, -14);
+        assert_eq!(spec.errors[1].description, "Bad user pointer");
+
+        assert_eq!(spec.errors[2].name, "EINVAL");
+        assert_eq!(spec.errors[2].error_code, -22);
+        assert_eq!(spec.errors[2].description, "Invalid argument");
+    }
+
+    #[test]
+    fn parse_context_flags() {
+        let doc = "\
+sys_ctx - Context test
+context-flags: KAPI_CTX_PROCESS|KAPI_CTX_SLEEPABLE
+";
+        let spec = parser()
+            .parse_kerneldoc(doc, "sys_ctx", "syscall", None)
+            .unwrap();
+
+        assert_eq!(spec.context_flags.len(), 2);
+        assert_eq!(spec.context_flags[0], "KAPI_CTX_PROCESS");
+        assert_eq!(spec.context_flags[1], "KAPI_CTX_SLEEPABLE");
+    }
+
+    #[test]
+    fn parse_context_list_short() {
+        // "contexts: process, sleepable" -> KAPI_CTX_PROCESS | SLEEPABLE
+        let doc = "\
+sys_ctx - Context test
+contexts: process, sleepable
+";
+        let spec = parser()
+            .parse_kerneldoc(doc, "sys_ctx", "syscall", None)
+            .unwrap();
+
+        assert_eq!(
+            spec.context_flags,
+            vec![
+                "KAPI_CTX_PROCESS".to_string(),
+                "KAPI_CTX_SLEEPABLE".to_string(),
+            ]
+        );
+    }
+
+    #[test]
+    fn parse_context_list_mixed() {
+        // Short tokens intermixed with explicit KAPI_CTX_* still work.
+        let doc = "\
+sys_ctx - Context test
+contexts: process, KAPI_CTX_SLEEPABLE, softirq
+";
+        let spec = parser()
+            .parse_kerneldoc(doc, "sys_ctx", "syscall", None)
+            .unwrap();
+
+        assert_eq!(
+            spec.context_flags,
+            vec![
+                "KAPI_CTX_PROCESS".to_string(),
+                "KAPI_CTX_SLEEPABLE".to_string(),
+                "KAPI_CTX_SOFTIRQ".to_string(),
+            ]
+        );
+    }
+
+    #[test]
+    fn parse_context_flags_long_with_short_token() {
+        // Long-form "context-flags:" accepts "|"-joined short aliases.
+        let doc = "\
+sys_ctx - Context test
+context-flags: process | KAPI_CTX_SLEEPABLE
+";
+        let spec = parser()
+            .parse_kerneldoc(doc, "sys_ctx", "syscall", None)
+            .unwrap();
+
+        assert_eq!(
+            spec.context_flags,
+            vec![
+                "KAPI_CTX_PROCESS".to_string(),
+                "KAPI_CTX_SLEEPABLE".to_string(),
+            ]
+        );
+    }
+
+    #[test]
+    fn parse_param_type_short_combined() {
+        // "type: uint, input" combines the type and flag aliases.
+        let doc = "\
+sys_t - Short type test
+param: size
+  type: uint, input
+";
+        let spec = parser()
+            .parse_kerneldoc(doc, "sys_t", "syscall", None)
+            .unwrap();
+
+        assert_eq!(spec.parameters.len(), 1);
+        assert_eq!(spec.parameters[0].param_type, 2); // KAPI_TYPE_UINT
+        assert_eq!(spec.parameters[0].flags, 1); // KAPI_PARAM_IN
+    }
+
+    #[test]
+    fn parse_param_type_short_multi_flag() {
+        // "type: path, input, user" sets both the IN and USER flags.
+        let doc = "\
+sys_t - Short type test
+param: filename
+  type: path, input, user
+";
+        let spec = parser()
+            .parse_kerneldoc(doc, "sys_t", "syscall", None)
+            .unwrap();
+
+        assert_eq!(spec.parameters.len(), 1);
+        assert_eq!(spec.parameters[0].param_type, 11); // PATH (kernel enum)
+        assert_eq!(spec.parameters[0].flags, 1 | (1 << 6)); // IN | USER
+    }
+
+    #[test]
+    fn parse_constraint_type_range_expr() {
+        // Short form: "constraint-type: range(0, 4096)" replaces the
+        // two-line long form "constraint-type: KAPI_CONSTRAINT_RANGE"
+        // + "range: 0, 4096".
+        let doc = "\
+sys_c - Constraint test
+param: count
+  type: uint, input
+  constraint-type: range(0, 4096)
+";
+        let spec = parser()
+            .parse_kerneldoc(doc, "sys_c", "syscall", None)
+            .unwrap();
+
+        let p = &spec.parameters[0];
+        assert_eq!(p.constraint_type, 1); // KAPI_CONSTRAINT_RANGE
+        assert_eq!(p.min_value, Some(0));
+        assert_eq!(p.max_value, Some(4096));
+    }
+
+    #[test]
+    fn parse_constraint_type_mask_expr() {
+        let doc = "\
+sys_c - Constraint test
+param: flags
+  type: uint, input
+  constraint-type: mask(0xff)
+";
+        let spec = parser()
+            .parse_kerneldoc(doc, "sys_c", "syscall", None)
+            .unwrap();
+
+        let p = &spec.parameters[0];
+        assert_eq!(p.constraint_type, 2); // KAPI_CONSTRAINT_MASK
+        assert_eq!(p.valid_mask, Some(0xff));
+    }
+
+    #[test]
+    fn parse_constraint_type_enum_expr() {
+        let doc = "\
+sys_c - Constraint test
+param: mode
+  type: int, input
+  constraint-type: enum(0, 0x10, -3, MODE_FAST)
+";
+        let spec = parser()
+            .parse_kerneldoc(doc, "sys_c", "syscall", None)
+            .unwrap();
+
+        let p = &spec.parameters[0];
+        assert_eq!(p.constraint_type, 3); // KAPI_CONSTRAINT_ENUM
+        assert_eq!(p.enum_values, ["0", "16", "-3", "MODE_FAST"]);
+    }
+
+    #[test]
+    fn c_integer_literals() {
+        assert_eq!(parse_u64_literal("0"), Some(0));
+        assert_eq!(parse_u64_literal("010"), Some(8));
+        assert_eq!(parse_u64_literal("0755"), Some(0o755));
+        assert_eq!(parse_u64_literal("0x1F"), Some(31));
+        assert_eq!(parse_u64_literal("0b101"), Some(5));
+        assert_eq!(parse_u64_literal("4096UL"), Some(4096));
+        assert_eq!(parse_u64_literal("0xffULL"), Some(255));
+        assert_eq!(parse_u64_literal("08"), None);
+        assert_eq!(parse_u64_literal("0x"), None);
+        assert_eq!(parse_u64_literal("+5"), None);
+        assert_eq!(parse_u64_literal("PAGE_SIZE"), None);
+        assert_eq!(parse_i64_literal("-010"), Some(-8));
+        assert_eq!(parse_i64_literal("-1U"), Some(4294967295));
+        assert_eq!(parse_i64_literal("-0x80000000"), Some(2147483648));
+        assert_eq!(parse_i64_literal("-2147483648"), Some(-2147483648));
+        assert_eq!(parse_i64_literal("-1UL"), Some(-1));
+        assert_eq!(parse_i64_literal("0xFFFFFFFFFFFFFFFF"), Some(-1));
+        assert_eq!(parse_i64_literal("18446744073709551615"), Some(-1));
+        assert_eq!(parse_i64_literal("-0x8000000000000000"), Some(i64::MIN));
+        assert_eq!(parse_u64_literal("-1"), Some(u64::MAX));
+        assert_eq!(parse_u64_literal("1uu"), None);
+        assert_eq!(parse_u64_literal("1lll"), None);
+    }
+
+    #[test]
+    fn parse_constraint_c_literals() {
+        let doc = "\
+sys_c - Constraint test
+param: mode
+  type: int, input
+  constraint-type: enum(010, 0x10, -07, 0b11, 5U)
+param: perms
+  type: uint, input
+  constraint-type: mask(0755)
+param: len
+  type: uint, input
+  constraint-type: range(01, 0x1000UL)
+param: align
+  type: uint, input
+  constraint-type: alignment(0x10)
+";
+        let spec = parser()
+            .parse_kerneldoc(doc, "sys_c", "syscall", None)
+            .unwrap();
+
+        let p = &spec.parameters;
+        assert_eq!(p[0].enum_values, ["8", "16", "-7", "3", "5"]);
+        assert_eq!(p[1].valid_mask, Some(0o755));
+        assert_eq!((p[2].min_value, p[2].max_value), (Some(1), Some(4096)));
+        assert_eq!(p[3].alignment, Some(16));
+    }
+
+    #[test]
+    fn zero_user_string_limits_are_unset() {
+        let doc = "\
+sys_s - String test
+param: name
+  type: user_ptr, input
+  range: 0, 255
+  constraint-type: user_string
+";
+        let spec = parser()
+            .parse_kerneldoc(doc, "sys_s", "syscall", None)
+            .unwrap();
+
+        let p = &spec.parameters[0];
+        assert_eq!(p.constraint_type, 8);
+        assert_eq!((p.min_value, p.max_value), (None, Some(255)));
+    }
+
+    #[test]
+    fn user_ptr_type_implies_user_flag() {
+        let doc = "\
+sys_u - Implicit user flag test
+param: buf
+  type: user_ptr, output
+";
+        let spec = parser()
+            .parse_kerneldoc(doc, "sys_u", "syscall", None)
+            .unwrap();
+
+        let p = &spec.parameters[0];
+        assert_eq!(p.param_type, 10); // KAPI_TYPE_USER_PTR
+        assert_eq!(
+            p.flags,
+            (1 << 1) | (1 << 6), // OUT | USER
+            "user_ptr type must imply KAPI_PARAM_USER"
+        );
+    }
+
+    #[test]
+    fn fd_type_does_not_imply_user_flag() {
+        // Only user_ptr / path imply KAPI_PARAM_USER. fd, int, uint,
+        // and every other non-user-space type must leave flags alone.
+        let doc = "\
+sys_fd - fd has no implicit user flag
+param: fd
+  type: fd, input
+";
+        let spec = parser()
+            .parse_kerneldoc(doc, "sys_fd", "syscall", None)
+            .unwrap();
+
+        let p = &spec.parameters[0];
+        assert_eq!(p.param_type, 9);
+        assert_eq!(p.flags, 1, "fd must not auto-set KAPI_PARAM_USER");
+    }
+
+    #[test]
+    fn path_type_implies_user_flag() {
+        let doc = "\
+sys_p - Path implicit user flag
+param: filename
+  type: path, input
+";
+        let spec = parser()
+            .parse_kerneldoc(doc, "sys_p", "syscall", None)
+            .unwrap();
+
+        let p = &spec.parameters[0];
+        assert_eq!(p.param_type, 11);
+        assert_eq!(
+            p.flags,
+            1 | (1 << 6), // IN | USER
+            "path type must imply KAPI_PARAM_USER"
+        );
+    }
+
+    #[test]
+    fn short_form_enum_equivalence() {
+        // Short-form and long-form renderings of the same spec must
+        // produce identical ApiSpec output across every enum family:
+        // context flags, param type+flags, constraint type, lock type,
+        // signal direction/action/timing, capability action, side-effect
+        // bitmask, return check type.
+        let long = "\
+sys_x - Enum short form test
+context-flags: KAPI_CTX_PROCESS | KAPI_CTX_SLEEPABLE
+
+param: fd
+  type: KAPI_TYPE_FD
+  flags: KAPI_PARAM_IN
+
+lock: files->file_lock
+  type: KAPI_LOCK_SPINLOCK
+  scope: acquires
+  desc: table lock
+
+signal: pending_signals
+  direction: KAPI_SIGNAL_RECEIVE
+  action: KAPI_SIGNAL_ACTION_RETURN
+  timing: KAPI_SIGNAL_TIME_DURING
+  desc: sig
+
+capability: CAP_SYS_ADMIN
+  type: KAPI_CAP_BYPASS_CHECK
+
+return:
+  type: KAPI_TYPE_INT
+  check-type: KAPI_RETURN_FD
+  desc: fd or errno
+
+side-effect: KAPI_EFFECT_RESOURCE_CREATE | KAPI_EFFECT_ALLOC_MEMORY
+  target: t
+  desc: d
+";
+        let short = "\
+sys_x - Enum short form test
+contexts: process, sleepable
+
+param: fd
+  type: fd, input
+
+lock: files->file_lock
+  type: spinlock
+  scope: acquires
+  desc: table lock
+
+signal: pending_signals
+  direction: receive
+  action: return
+  timing: during
+  desc: sig
+
+capability: CAP_SYS_ADMIN
+  type: bypass_check
+
+return:
+  type: int
+  check-type: fd
+  desc: fd or errno
+
+side-effect: resource_create | alloc_memory
+  target: t
+  desc: d
+";
+        let mut sp_l = parser()
+            .parse_kerneldoc(long, "sys_x", "syscall", None)
+            .unwrap();
+        let mut sp_s = parser()
+            .parse_kerneldoc(short, "sys_x", "syscall", None)
+            .unwrap();
+        // The return type name is the human spelling, kept as written.
+        for sp in [&mut sp_l, &mut sp_s] {
+            sp.return_spec.as_mut().unwrap().type_name.clear();
+        }
+        assert_eq!(
+            format!("{:#?}", sp_l),
+            format!("{:#?}", sp_s),
+            "long-form and short-form of every enum family must normalise identically"
+        );
+    }
+
+    #[test]
+    fn parse_buffer_short_captures_size_param_idx() {
+        let doc = "\
+sys_b - Buffer test
+param: buf
+  type: user_ptr, output, user
+  constraint-type: buffer(2)
+";
+        let spec = parser()
+            .parse_kerneldoc(doc, "sys_b", "syscall", None)
+            .unwrap();
+
+        assert_eq!(spec.parameters[0].constraint_type, 11);
+        assert_eq!(spec.parameters[0].size_param_idx, Some(2));
+    }
+
+    #[test]
+    fn buffer_short_and_size_param_long_are_symmetric() {
+        let short = "\
+sys_b - Symmetric buffer test
+param: buf
+  type: user_ptr, output, user
+  constraint-type: buffer(2)
+";
+        let long = "\
+sys_b - Symmetric buffer test
+param: buf
+  type: KAPI_TYPE_USER_PTR
+  flags: KAPI_PARAM_OUT | KAPI_PARAM_USER
+  constraint-type: KAPI_CONSTRAINT_BUFFER
+  size-param: 2
+";
+        let sp_s = parser()
+            .parse_kerneldoc(short, "sys_b", "syscall", None)
+            .unwrap();
+        let sp_l = parser()
+            .parse_kerneldoc(long, "sys_b", "syscall", None)
+            .unwrap();
+        assert_eq!(format!("{:#?}", sp_s), format!("{:#?}", sp_l));
+    }
+
+    #[test]
+    fn parse_constraint_type_bare_user_path() {
+        let doc = "\
+sys_c - Constraint test
+param: filename
+  type: path, input, user
+  constraint-type: user_path
+";
+        let spec = parser()
+            .parse_kerneldoc(doc, "sys_c", "syscall", None)
+            .unwrap();
+
+        assert_eq!(spec.parameters[0].constraint_type, 9); // USER_PATH
+    }
+
+    #[test]
+    fn starts_subfield_requires_known_key() {
+        let keys = block_subfield_keys(&BlockContext::SideEffect);
+        assert!(super::starts_subfield("target: file table", keys));
+        assert!(super::starts_subfield("condition:", keys));
+        assert!(super::starts_subfield("reversible: yes", keys));
+        // A colon inside prose does not open a subfield.
+        assert!(!super::starts_subfield(
+            "this lock mid-operation: the handler",
+            keys
+        ));
+        assert!(!super::starts_subfield("Careful: it is dangerous", keys));
+        // A key that belongs to another block type does not count.
+        assert!(!super::starts_subfield("direction: receive", keys));
+        assert!(!super::starts_subfield("O_RDONLY | O_WRONLY |", keys));
+        assert!(!super::starts_subfield(")", keys));
+    }
+
+    #[test]
+    fn multiline_fold_stops_at_sibling_block_attribute() {
+        // The constraint-type's continuation must not greedily eat the
+        // next subfield of the same block.
+        let doc = "\
+sys_y - Fold stop test
+param: f
+  type: int, input
+  constraint-type: mask(FOO |
+                        BAR)
+  cdesc: something about f
+";
+        let spec = parser()
+            .parse_kerneldoc(doc, "sys_y", "syscall", None)
+            .unwrap();
+
+        assert_eq!(spec.parameters.len(), 1);
+        // If the fold over-consumed, `cdesc:` would have been swallowed
+        // into the mask expression and param.constraint_type would be 0.
+        assert_eq!(spec.parameters[0].constraint_type, 2);
+        assert_eq!(
+            spec.parameters[0].constraint.as_deref(),
+            Some("something about f")
+        );
+    }
+
+    #[test]
+    fn parse_constraint_type_mask_expr_multiline() {
+        // Real-world sys_open/flags case: a symbolic mask split across
+        // four continuation lines. The parser must fold the continuation
+        // lines before running the function-call match, otherwise the
+        // constraint type silently decays to 0.
+        let doc = "\
+sys_x - Multi-line mask test
+param: f
+  type: int, input
+  constraint-type: mask(O_RDONLY | O_WRONLY | O_RDWR | O_CREAT | O_EXCL | O_NOCTTY |
+                        O_TRUNC | O_APPEND | O_NONBLOCK | O_DSYNC | O_SYNC | FASYNC |
+                        O_DIRECT | O_LARGEFILE | O_DIRECTORY | O_NOFOLLOW | O_NOATIME |
+                        O_CLOEXEC | O_PATH | O_TMPFILE)
+";
+        let spec = parser()
+            .parse_kerneldoc(doc, "sys_x", "syscall", None)
+            .unwrap();
+
+        assert_eq!(spec.parameters.len(), 1);
+        let p = &spec.parameters[0];
+        assert_eq!(p.constraint_type, 2, "multi-line mask must set MASK type");
+        // Symbolic mask: must stay unresolved rather than becoming Some(0).
+        assert_eq!(
+            p.valid_mask, None,
+            "symbolic mask values must remain None, not Some(0)"
+        );
+    }
+
+    #[test]
+    fn parse_constraint_long_form() {
+        let doc = "\
+sys_c - Constraint test
+param: foo
+  type: uint, input
+  constraint-type: KAPI_CONSTRAINT_MASK
+  valid-mask: 0xff
+";
+        let spec = parser()
+            .parse_kerneldoc(doc, "sys_c", "syscall", None)
+            .unwrap();
+
+        let p = &spec.parameters[0];
+        assert_eq!(p.constraint_type, 2); // KAPI_CONSTRAINT_MASK
+    }
+
+    #[test]
+    fn parse_constraint_free_text() {
+        // `constraint:` carries free-text constraint description;
+        // function-call short form lives on `constraint-type:`.
+        let doc = "\
+sys_c - Constraint test
+param: foo
+  type: uint, input
+  constraint: must be a valid page descriptor
+";
+        let spec = parser()
+            .parse_kerneldoc(doc, "sys_c", "syscall", None)
+            .unwrap();
+
+        let p = &spec.parameters[0];
+        assert_eq!(p.constraint_type, 0);
+        assert_eq!(
+            p.constraint.as_deref(),
+            Some("must be a valid page descriptor")
+        );
+    }
+
+    #[test]
+    fn parse_description_alias_overrides_kerneldoc() {
+        // `description:` inside a `param:` block is an alias for `desc:`
+        // and overrides the @param description.
+        let doc = "\
+sys_d - Description alias test
+@size: kerneldoc short description
+param: size
+  type: uint, input
+  description: The new long form description.
+";
+        let spec = parser()
+            .parse_kerneldoc(doc, "sys_d", "syscall", None)
+            .unwrap();
+
+        assert_eq!(spec.parameters.len(), 1);
+        assert_eq!(
+            spec.parameters[0].description,
+            "The new long form description."
+        );
+    }
+
+    #[test]
+    fn canonical_equivalence_short_vs_long() {
+        // Two spellings of the same spec must produce identical ApiSpec
+        // JSON.
+        let long = "\
+sys_open - open a file
+context-flags: KAPI_CTX_PROCESS | KAPI_CTX_SLEEPABLE
+
+param: filename
+  type: KAPI_TYPE_PATH
+  flags: KAPI_PARAM_IN | KAPI_PARAM_USER
+  constraint-type: KAPI_CONSTRAINT_USER_PATH
+  desc: Pathname to open
+
+param: count
+  type: KAPI_TYPE_UINT
+  flags: KAPI_PARAM_IN
+  constraint-type: KAPI_CONSTRAINT_RANGE
+  range: 0, 4096
+  desc: Byte count
+";
+        let short = "\
+sys_open - open a file
+contexts: process, sleepable
+
+param: filename
+  type: path, input, user
+  constraint-type: user_path
+  description: Pathname to open
+
+param: count
+  type: uint, input
+  constraint-type: range(0, 4096)
+  description: Byte count
+";
+        let long_spec = parser()
+            .parse_kerneldoc(long, "sys_open", "syscall", None)
+            .unwrap();
+        let short_spec = parser()
+            .parse_kerneldoc(short, "sys_open", "syscall", None)
+            .unwrap();
+
+        // ApiSpec isn't Serialize as a whole, so compare the Debug
+        // rendering, which still proves every field canonicalises
+        // identically.
+        let d_long = format!("{:#?}", long_spec);
+        let d_short = format!("{:#?}", short_spec);
+        assert_eq!(
+            d_long, d_short,
+            "short-form and long-form specs must normalise identically"
+        );
+    }
+
+    #[test]
+    fn parse_capability_block() {
+        let doc = "\
+sys_cap - Capability test
+capability: CAP_SYS_ADMIN
+  type: required
+  allows: Full system administration
+  without: Operation not permitted
+  condition: always
+  priority: 5
+";
+        let spec = parser()
+            .parse_kerneldoc(doc, "sys_cap", "syscall", None)
+            .unwrap();
+
+        assert_eq!(spec.capabilities.len(), 1);
+        let cap = &spec.capabilities[0];
+        assert_eq!(cap.capability, 21); // CAP_SYS_ADMIN
+        assert_eq!(cap.action, "required");
+        assert_eq!(cap.allows, "Full system administration");
+        assert_eq!(cap.without_cap, "Operation not permitted");
+        assert_eq!(cap.check_condition.as_deref(), Some("always"));
+        assert_eq!(cap.priority, Some(5));
+    }
+
+    #[test]
+    fn parse_lock_block() {
+        let doc = "\
+sys_lock - Lock test
+lock: files_lock, KAPI_LOCK_MUTEX
+  scope: acquires
+  desc: Protects file table
+";
+        let spec = parser()
+            .parse_kerneldoc(doc, "sys_lock", "syscall", None)
+            .unwrap();
+
+        assert_eq!(spec.locks.len(), 1);
+        let lock = &spec.locks[0];
+        assert_eq!(lock.lock_name, "files_lock");
+        assert_eq!(lock.lock_type, 1); // MUTEX
+        assert_eq!(lock.scope, super::super::KAPI_LOCK_ACQUIRES);
+        assert_eq!(lock.description, "Protects file table");
+    }
+
+    #[test]
+    fn parse_lock_acquired_released_flags() {
+        let doc = "\
+sys_lock - Lock test
+lock: a_lock, KAPI_LOCK_MUTEX
+  acquired: true
+  released: true
+lock: b_lock, KAPI_LOCK_MUTEX
+  acquired: true
+lock: c_lock, KAPI_LOCK_MUTEX
+  released: yes
+lock: d_lock, KAPI_LOCK_MUTEX
+  acquired: conditional
+  released: false
+";
+        let spec = parser()
+            .parse_kerneldoc(doc, "sys_lock", "syscall", None)
+            .unwrap();
+
+        let scopes: Vec<u32> = spec.locks.iter().map(|l| l.scope).collect();
+        assert_eq!(
+            scopes,
+            vec![
+                super::super::KAPI_LOCK_INTERNAL,
+                super::super::KAPI_LOCK_ACQUIRES,
+                super::super::KAPI_LOCK_RELEASES,
+                super::super::KAPI_LOCK_INTERNAL,
+            ]
+        );
+    }
+
+    #[test]
+    fn parse_signal_block() {
+        let doc = "\
+sys_sig - Signal test
+signal: SIGKILL
+  direction: KAPI_SIGNAL_RECEIVE
+  action: KAPI_SIGNAL_ACTION_TERMINATE
+  timing: KAPI_SIGNAL_TIME_DURING
+  priority: 3
+  restartable: yes
+  interruptible: yes
+  desc: Process termination signal
+";
+        let spec = parser()
+            .parse_kerneldoc(doc, "sys_sig", "syscall", None)
+            .unwrap();
+
+        assert_eq!(spec.signals.len(), 1);
+        let sig = &spec.signals[0];
+        assert_eq!(sig.signal_name, "SIGKILL");
+        assert_eq!(sig.direction, 1); // RECEIVE
+        assert_eq!(sig.action, 1); // TERMINATE
+        assert_eq!(sig.timing, 1); // DURING
+        assert_eq!(sig.priority, 3);
+        assert!(sig.restartable);
+        assert!(sig.interruptible);
+        assert_eq!(
+            sig.description.as_deref(),
+            Some("Process termination signal")
+        );
+    }
+
+    #[test]
+    fn parse_signal_errno_shapes() {
+        // All three accepted spellings of the signal errno field must
+        // produce the same negative kernel return code.
+        for (form, label) in [
+            ("errno: -EINTR", "-EINTR symbolic"),
+            ("errno: EINTR", "bare symbolic"),
+            ("errno: -4", "numeric literal"),
+        ] {
+            let doc = format!(
+                "sys_s - Signal errno test\n\
+                 signal: SIGINT\n\
+                 \x20 direction: receive\n\
+                 \x20 action: return\n\
+                 \x20 {}\n",
+                form,
+            );
+            let spec = parser()
+                .parse_kerneldoc(&doc, "sys_s", "syscall", None)
+                .unwrap();
+            assert_eq!(spec.signals.len(), 1, "{label}");
+            assert_eq!(
+                spec.signals[0].error_on_signal,
+                Some(-4),
+                "errno form {label:?} must resolve to -EINTR (-4)",
+            );
+        }
+    }
+
+    #[test]
+    fn parse_side_effect_flat() {
+        let doc = "\
+sys_se - Side effect test
+side-effect: KAPI_EFFECT_MODIFY_STATE, file_table, Allocates a new file descriptor
+";
+        let spec = parser()
+            .parse_kerneldoc(doc, "sys_se", "syscall", None)
+            .unwrap();
+
+        assert_eq!(spec.side_effects.len(), 1);
+        let se = &spec.side_effects[0];
+        assert_eq!(se.effect_type, 1 << 2); // KAPI_EFFECT_MODIFY_STATE
+        assert_eq!(se.target, "file_table");
+        assert_eq!(se.description, "Allocates a new file descriptor");
+    }
+
+    #[test]
+    fn parse_side_effect_block() {
+        let doc = "\
+sys_se2 - Side effect block test
+side-effect: KAPI_EFFECT_ALLOC_MEMORY
+  target: kernel_heap
+  desc: Allocates kernel memory
+  reversible: yes
+  condition: size > 0
+";
+        let spec = parser()
+            .parse_kerneldoc(doc, "sys_se2", "syscall", None)
+            .unwrap();
+
+        assert_eq!(spec.side_effects.len(), 1);
+        let se = &spec.side_effects[0];
+        assert_eq!(se.effect_type, 1 << 0); // KAPI_EFFECT_ALLOC_MEMORY
+        assert_eq!(se.target, "kernel_heap");
+        assert_eq!(se.description, "Allocates kernel memory");
+        assert!(se.reversible);
+        assert_eq!(se.condition.as_deref(), Some("size > 0"));
+    }
+
+    #[test]
+    fn parse_empty_doc_no_error() {
+        let doc = "";
+        let spec = parser()
+            .parse_kerneldoc(doc, "sys_empty", "syscall", None)
+            .unwrap();
+
+        assert_eq!(spec.name, "sys_empty");
+        assert!(spec.description.is_none());
+        assert!(spec.parameters.is_empty());
+        assert!(spec.errors.is_empty());
+        assert!(spec.signals.is_empty());
+        assert!(spec.capabilities.is_empty());
+        assert!(spec.locks.is_empty());
+        assert!(spec.side_effects.is_empty());
+        assert!(spec.context_flags.is_empty());
+    }
+
+    #[test]
+    fn parse_missing_sections_no_error() {
+        // Only has a description, no KAPI annotations
+        let doc = "\
+sys_simple - Just a simple syscall
+";
+        let spec = parser()
+            .parse_kerneldoc(doc, "sys_simple", "syscall", None)
+            .unwrap();
+
+        assert_eq!(spec.description.as_deref(), Some("Just a simple syscall"));
+        assert!(spec.parameters.is_empty());
+        assert!(spec.errors.is_empty());
+        assert!(spec.context_flags.is_empty());
+    }
+
+    #[test]
+    fn parse_constraint_block() {
+        let doc = "\
+sys_cst - Constraint test
+constraint: valid_fd
+  desc: File descriptor must be valid and open
+  expr: fd >= 0 && fd < NR_OPEN
+";
+        let spec = parser()
+            .parse_kerneldoc(doc, "sys_cst", "syscall", None)
+            .unwrap();
+
+        assert_eq!(spec.constraints.len(), 1);
+        let cst = &spec.constraints[0];
+        assert_eq!(cst.name, "valid_fd");
+        assert_eq!(cst.description, "File descriptor must be valid and open");
+        assert_eq!(cst.expression.as_deref(), Some("fd >= 0 && fd < NR_OPEN"));
+    }
+
+    #[test]
+    fn parse_state_transition_flat() {
+        let doc = "\
+sys_st - State transition test
+state-trans: fd, open, closed, File descriptor is closed
+";
+        let spec = parser()
+            .parse_kerneldoc(doc, "sys_st", "syscall", None)
+            .unwrap();
+
+        assert_eq!(spec.state_transitions.len(), 1);
+        let st = &spec.state_transitions[0];
+        assert_eq!(st.object, "fd");
+        assert_eq!(st.from_state, "open");
+        assert_eq!(st.to_state, "closed");
+        assert_eq!(st.description, "File descriptor is closed");
+    }
+
+    #[test]
+    fn parse_param_block_with_range() {
+        let doc = "\
+sys_rng - Range test
+@count: byte count
+param: count
+  type: KAPI_TYPE_UINT
+  flags: IN
+  range: 0, 4096
+  constraint-type: KAPI_CONSTRAINT_RANGE
+";
+        let spec = parser()
+            .parse_kerneldoc(doc, "sys_rng", "syscall", None)
+            .unwrap();
+
+        assert_eq!(spec.parameters.len(), 1);
+        let p = &spec.parameters[0];
+        assert_eq!(p.name, "count");
+        assert_eq!(p.param_type, 2); // UINT
+        assert_eq!(p.flags, 1); // IN
+        assert_eq!(p.min_value, Some(0));
+        assert_eq!(p.max_value, Some(4096));
+        assert_eq!(p.constraint_type, 1); // RANGE
+    }
+
+    #[test]
+    fn parse_return_block() {
+        let doc = "\
+sys_ret - Return test
+return:
+  type: KAPI_TYPE_INT
+  check-type: KAPI_RETURN_FD
+  success: 0
+  desc: Returns file descriptor on success
+";
+        let spec = parser()
+            .parse_kerneldoc(doc, "sys_ret", "syscall", None)
+            .unwrap();
+
+        let ret = spec.return_spec.as_ref().unwrap();
+        assert_eq!(ret.type_name, "KAPI_TYPE_INT");
+        assert_eq!(ret.return_type, 1); // INT
+        assert_eq!(ret.check_type, 3); // FD
+        assert_eq!(ret.success_value, None); // FD checks carry no success value
+        assert_eq!(ret.description, "Returns file descriptor on success");
+    }
+
+    #[test]
+    fn colon_in_continuation_line_does_not_start_subfield() {
+        let doc = "\
+sys_col - Colon continuation test
+param: x
+  type: int
+  cdesc: Must be sane. Note: this is a continuation
+    with a colon: in the middle.
+
+lock: mylock
+  type: mutex
+  desc: Taken at entry; if the caller drops
+    this lock mid-operation: the handler waits
+    until released.
+
+side-effect: modify_state
+  target: stuff
+  condition: only when a
+    special case applies: for example
+    on Tuesdays
+  desc: Does things.
+    Careful: it is dangerous.
+  reversible: no
+
+signal: SIGINT
+  direction: receive
+  condition: while blocked, unless
+    flagged: see below
+  desc: Interrupts the wait.
+
+capability: CAP_SYS_ADMIN
+  type: bypass_check
+  allows: Things
+    that need: privilege
+  condition: Always
+
+constraint: limit
+  desc: A limit
+    of note: nothing.
+  expr: a &&
+    b
+";
+        let spec = parser()
+            .parse_kerneldoc(doc, "sys_col", "syscall", None)
+            .unwrap();
+
+        assert_eq!(
+            spec.parameters[0].constraint.as_deref(),
+            Some("Must be sane. Note: this is a continuation with a colon: in the middle.")
+        );
+        assert_eq!(
+            spec.locks[0].description,
+            "Taken at entry; if the caller drops this lock mid-operation: the handler waits until released."
+        );
+        let se = &spec.side_effects[0];
+        assert_eq!(
+            se.condition.as_deref(),
+            Some("only when a special case applies: for example on Tuesdays")
+        );
+        assert_eq!(se.description, "Does things. Careful: it is dangerous.");
+        assert!(!se.reversible);
+        let sig = &spec.signals[0];
+        assert_eq!(
+            sig.condition.as_deref(),
+            Some("while blocked, unless flagged: see below")
+        );
+        assert_eq!(sig.description.as_deref(), Some("Interrupts the wait."));
+        let cap = &spec.capabilities[0];
+        assert_eq!(cap.allows, "Things that need: privilege");
+        assert_eq!(cap.check_condition.as_deref(), Some("Always"));
+        let cst = &spec.constraints[0];
+        assert_eq!(cst.description, "A limit of note: nothing.");
+        assert_eq!(cst.expression.as_deref(), Some("a && b"));
+    }
+
+    #[test]
+    fn multiline_side_effect_condition_is_kept_whole() {
+        let doc = "\
+sys_mc - Multi-line condition test
+side-effect: modify_state
+  target: userfaultfd event queue
+  condition: MADV_DONTNEED, MADV_FREE
+    on a VMA whose userfaultfd context negotiated
+    UFFD_FEATURE_EVENT_REMOVE
+  desc: Generates a notification.
+    The monitor cannot veto it.
+  reversible: no
+";
+        let spec = parser()
+            .parse_kerneldoc(doc, "sys_mc", "syscall", None)
+            .unwrap();
+
+        let se = &spec.side_effects[0];
+        assert_eq!(
+            se.condition.as_deref(),
+            Some(
+                "MADV_DONTNEED, MADV_FREE on a VMA whose userfaultfd context \
+                 negotiated UFFD_FEATURE_EVENT_REMOVE"
+            )
+        );
+        assert_eq!(
+            se.description,
+            "Generates a notification. The monitor cannot veto it."
+        );
+    }
+
+    #[test]
+    fn blank_line_inside_block_continues_subfield() {
+        let doc = "\
+sys_bl - Blank line test
+lock: l
+  type: mutex
+  desc: First half
+
+    second half.
+";
+        let spec = parser()
+            .parse_kerneldoc(doc, "sys_bl", "syscall", None)
+            .unwrap();
+
+        assert_eq!(spec.locks[0].description, "First half second half.");
+    }
+
+    #[test]
+    fn param_cdesc_is_the_constraint_text() {
+        let doc = "\
+sys_cd - cdesc test
+param: fd
+  type: int, input
+  cdesc: Must be open.
+    Zero is allowed.
+";
+        let spec = parser()
+            .parse_kerneldoc(doc, "sys_cd", "syscall", None)
+            .unwrap();
+
+        assert_eq!(
+            spec.parameters[0].constraint.as_deref(),
+            Some("Must be open. Zero is allowed.")
+        );
+    }
+
+    #[test]
+    fn state_transition_block_keeps_condition_separate() {
+        let doc = "\
+sys_stb - State transition block test
+state-trans: file_descriptor
+  from: open
+  to: closed/free
+  condition: Valid fd passed to close
+  desc: The fd becomes unusable.
+    It may be reused.
+
+state-trans: refcount
+  from: n
+  to: n-1
+  desc: Decremented.
+";
+        let spec = parser()
+            .parse_kerneldoc(doc, "sys_stb", "syscall", None)
+            .unwrap();
+
+        assert_eq!(spec.state_transitions.len(), 2);
+        let st = &spec.state_transitions[0];
+        assert_eq!(st.object, "file_descriptor");
+        assert_eq!(st.from_state, "open");
+        assert_eq!(st.to_state, "closed/free");
+        assert_eq!(st.condition.as_deref(), Some("Valid fd passed to close"));
+        assert_eq!(st.description, "The fd becomes unusable. It may be reused.");
+        let st = &spec.state_transitions[1];
+        assert_eq!(st.object, "refcount");
+        assert_eq!(st.condition, None);
+        assert_eq!(st.description, "Decremented.");
+    }
+
+    #[test]
+    fn state_transition_flat_description_keeps_commas() {
+        let doc = "\
+sys_stc - Flat state transition test
+state-trans: fd, open, closed, File is closed, and the number is free
+";
+        let spec = parser()
+            .parse_kerneldoc(doc, "sys_stc", "syscall", None)
+            .unwrap();
+
+        let st = &spec.state_transitions[0];
+        assert_eq!(st.description, "File is closed, and the number is free");
+        assert_eq!(st.condition, None);
+    }
+
+    #[test]
+    fn return_type_name_is_kept_as_written() {
+        for (written, ty) in [("int", 1), ("long", 0), ("KAPI_TYPE_UINT", 2)] {
+            let doc = format!("sys_rt - Return type test\nreturn:\n  type: {written}\n");
+            let spec = parser()
+                .parse_kerneldoc(&doc, "sys_rt", "syscall", None)
+                .unwrap();
+            let ret = spec.return_spec.as_ref().unwrap();
+            assert_eq!(ret.type_name, written);
+            assert_eq!(ret.return_type, ty);
+        }
+    }
+
+    #[test]
+    fn return_success_follows_check_type() {
+        let cases = [
+            // (check-type, success, value, min, max)
+            ("exact", "0", Some(0), None, None),
+            ("exact", "= 0", Some(0), None, None),
+            ("exact", "== -1", Some(-1), None, None),
+            ("exact", "0x10", Some(16), None, None),
+            ("exact", ">= 0", None, None, None),
+            ("range", ">= 0", None, Some(0), Some(i64::MAX)),
+            ("range", ">= 1", None, Some(1), Some(i64::MAX)),
+            ("range", "0", None, Some(0), Some(i64::MAX)),
+            ("fd", ">= 0", None, None, None),
+            ("error_check", "0", None, None, None),
+        ];
+        for (check, success, value, min, max) in cases {
+            let doc = format!(
+                "sys_rs - Return success test\nreturn:\n  type: int\n  \
+                 success: {success}\n  check-type: {check}\n  desc: ok\n"
+            );
+            let spec = parser()
+                .parse_kerneldoc(&doc, "sys_rs", "syscall", None)
+                .unwrap();
+            let ret = spec.return_spec.as_ref().unwrap();
+            assert_eq!(ret.success_value, value, "{check} {success}");
+            assert_eq!(ret.success_min, min, "{check} {success}");
+            assert_eq!(ret.success_max, max, "{check} {success}");
+        }
+    }
+
+    #[test]
+    fn return_description_continuation_with_colon() {
+        let doc = "\
+sys_rd - Return description test
+return:
+  type: int
+  check-type: exact
+  success: 0
+  desc: Returns zero on success. Note: this is
+    a continuation line with a colon.
+";
+        let spec = parser()
+            .parse_kerneldoc(doc, "sys_rd", "syscall", None)
+            .unwrap();
+
+        let ret = spec.return_spec.as_ref().unwrap();
+        assert_eq!(
+            ret.description,
+            "Returns zero on success. Note: this is a continuation line with a colon."
+        );
+        assert_eq!(ret.success_value, Some(0));
+    }
+
+    #[test]
+    fn examples_keep_one_example_per_line() {
+        let doc = "\
+sys_ex - Examples test
+examples: fd = open(\"/etc/passwd\", O_RDONLY);  // Read existing file
+  fd = open(\"/tmp/new\", O_WRONLY | O_CREAT, 0644);  // Create
+  // Handle short writes:
+  while (total < len) {
+    n = write(fd, buf + total, len - total);
+    if (n < 0) break;
+  }
+
+  close(fd);
+
+notes: After the examples.
+";
+        let spec = parser()
+            .parse_kerneldoc(doc, "sys_ex", "syscall", None)
+            .unwrap();
+
+        assert_eq!(
+            spec.examples.as_deref(),
+            Some(
+                "fd = open(\"/etc/passwd\", O_RDONLY);  // Read existing file\n\
+                 fd = open(\"/tmp/new\", O_WRONLY | O_CREAT, 0644);  // Create\n\
+                 // Handle short writes:\n\
+                 while (total < len) {\n  \
+                 n = write(fd, buf + total, len - total);\n  \
+                 if (n < 0) break;\n\
+                 }\n\
+                 \n\
+                 close(fd);"
+            )
+        );
+        assert_eq!(spec.notes.as_deref(), Some("After the examples."));
+    }
+
+    #[test]
+    fn notes_and_long_desc_keep_paragraphs_and_bullets() {
+        let doc = "\
+sys_nt - Notes test
+long-desc: First paragraph wraps
+  over two lines.
+
+  Second paragraph introduces a list:
+  - item one wraps
+    onto a second line
+  - item two
+
+  Last paragraph.
+notes: The behavior varies:
+
+  - Regular files: reads
+    from the current position.
+
+  - Pipes: block.
+
+  Trailing: text.
+";
+        let spec = parser()
+            .parse_kerneldoc(doc, "sys_nt", "syscall", None)
+            .unwrap();
+
+        assert_eq!(
+            spec.long_description.as_deref(),
+            Some(
+                "First paragraph wraps over two lines.\n\n\
+                 Second paragraph introduces a list:\n\
+                 - item one wraps onto a second line\n\
+                 - item two\n\n\
+                 Last paragraph."
+            )
+        );
+        assert_eq!(
+            spec.notes.as_deref(),
+            Some(
+                "The behavior varies:\n\n\
+                 - Regular files: reads from the current position.\n\n\
+                 - Pipes: block.\n\n\
+                 Trailing: text."
+            )
+        );
+    }
+
+    #[test]
+    fn fold_lines_handles_leading_blank_and_tabs() {
+        assert_eq!(
+            super::fold_lines(&["", "  a();", "  b();", "    c();", ""]),
+            "a();\nb();\n  c();"
+        );
+        assert_eq!(super::fold_lines(&["x();", "\ty();"]), "x();\ny();");
+        assert_eq!(super::fold_lines(&[""]), "");
+        assert_eq!(super::fold_lines(&["a", "  b", "", "", "  c"]), "a\nb\n\nc");
+    }
+
+    #[test]
+    fn fold_paragraphs_joins_wrapped_lines_only() {
+        assert_eq!(
+            super::fold_paragraphs(&["one", "  two", "", "", "  three", "- four", "- five"]),
+            "one two\n\nthree\n- four\n- five"
+        );
+        assert_eq!(super::fold_paragraphs(&["", "  "]), "");
+    }
+}
diff --git a/tools/kapi/src/extractor/mod.rs b/tools/kapi/src/extractor/mod.rs
new file mode 100644
index 0000000000000..d7ada57924d7a
--- /dev/null
+++ b/tools/kapi/src/extractor/mod.rs
@@ -0,0 +1,442 @@
+// SPDX-License-Identifier: GPL-2.0
+// Copyright (C) 2026 Sasha Levin <sashal@kernel.org>
+
+use crate::formatter::OutputFormatter;
+use anyhow::Result;
+use std::io::Write;
+
+pub mod debugfs;
+pub mod kerneldoc_parser;
+pub mod source_parser;
+pub mod vmlinux;
+
+pub use debugfs::DebugfsExtractor;
+pub use source_parser::SourceExtractor;
+pub use vmlinux::VmlinuxExtractor;
+
+/// Capability specification
+#[derive(Debug, Clone, serde::Serialize)]
+pub struct CapabilitySpec {
+    pub capability: i32,
+    pub name: String,
+    pub action: String,
+    pub allows: String,
+    pub without_cap: String,
+    pub check_condition: Option<String>,
+    pub priority: Option<u8>,
+    pub alternatives: Vec<i32>,
+}
+
+/// Parameter specification
+#[derive(Debug, Clone, serde::Serialize)]
+pub struct ParamSpec {
+    pub index: u32,
+    pub name: String,
+    pub type_name: String,
+    pub description: String,
+    pub flags: u32,
+    pub param_type: u32,
+    pub constraint_type: u32,
+    pub constraint: Option<String>,
+    pub min_value: Option<i64>,
+    pub max_value: Option<i64>,
+    pub valid_mask: Option<u64>,
+    pub enum_values: Vec<String>,
+    pub size: Option<u32>,
+    pub alignment: Option<u32>,
+    /// Index of the parameter that carries this parameter's byte count
+    /// (for KAPI_CONSTRAINT_BUFFER). Populated by either
+    /// `size-param: N` (long form) or `constraint-type: buffer(N)`
+    /// (short form).
+    pub size_param_idx: Option<u32>,
+}
+
+/// Constraint type enum values matching kernel enum kapi_constraint_type
+pub const KAPI_CONSTRAINT_RANGE: u32 = 1;
+pub const KAPI_CONSTRAINT_MASK: u32 = 2;
+pub const KAPI_CONSTRAINT_USER_STRING: u32 = 8;
+
+impl ParamSpec {
+    /// Clear the numeric fields the constraint type does not use. The
+    /// compiled struct always carries them, so an unset value reads as 0.
+    pub fn keep_used_numbers(&mut self) {
+        match self.constraint_type {
+            KAPI_CONSTRAINT_RANGE => {}
+            KAPI_CONSTRAINT_USER_STRING => self.drop_unset_string_limits(),
+            _ => {
+                self.min_value = None;
+                self.max_value = None;
+            }
+        }
+        if self.constraint_type != KAPI_CONSTRAINT_MASK {
+            self.valid_mask = None;
+        }
+        self.size = self.size.filter(|&n| n != 0);
+        self.alignment = self.alignment.filter(|&n| n != 0);
+    }
+
+    /// The kernel treats a user_string length limit of 0 as no limit.
+    pub fn drop_unset_string_limits(&mut self) {
+        if self.constraint_type == KAPI_CONSTRAINT_USER_STRING {
+            self.min_value = self.min_value.filter(|&n| n > 0);
+            self.max_value = self.max_value.filter(|&n| n > 0);
+        }
+    }
+}
+
+/// Return value specification
+#[derive(Debug, Clone, serde::Serialize)]
+pub struct ReturnSpec {
+    pub type_name: String,
+    pub description: String,
+    pub return_type: u32,
+    pub check_type: u32,
+    pub success_value: Option<i64>,
+    pub success_min: Option<i64>,
+    pub success_max: Option<i64>,
+    pub error_values: Vec<i32>,
+}
+
+impl ReturnSpec {
+    /// Drop the success fields the check type does not use, the way the
+    /// generated KAPI_RETURN_SUCCESS()/KAPI_RETURN_SUCCESS_RANGE() macros
+    /// only set the one that applies.
+    pub fn keep_used_success_fields(&mut self) {
+        match self.check_type {
+            0 => {
+                self.success_min = None;
+                self.success_max = None;
+            }
+            1 => self.success_value = None,
+            _ => {
+                self.success_value = None;
+                self.success_min = None;
+                self.success_max = None;
+            }
+        }
+    }
+}
+
+/// Error specification
+#[derive(Debug, Clone, serde::Serialize)]
+pub struct ErrorSpec {
+    pub error_code: i32,
+    pub name: String,
+    pub condition: String,
+    pub description: String,
+}
+
+/// Signal specification
+#[derive(Debug, Clone, serde::Serialize)]
+pub struct SignalSpec {
+    pub signal_num: i32,
+    pub signal_name: String,
+    pub direction: u32,
+    pub action: u32,
+    pub target: Option<String>,
+    pub condition: Option<String>,
+    pub description: Option<String>,
+    pub timing: u32,
+    pub priority: u32,
+    pub restartable: bool,
+    pub interruptible: bool,
+    pub queue: Option<String>,
+    pub sa_flags: u32,
+    pub sa_flags_required: u32,
+    pub sa_flags_forbidden: u32,
+    pub state_required: u32,
+    pub state_forbidden: u32,
+    pub error_on_signal: Option<i32>,
+    /// Signal number to transform to (e.g. `SIGKILL` -> 9 on x86).
+    /// Always an integer or null in JSON -- the schema never widens to
+    /// a string. Extractors reading the compiled struct (`--vmlinux`,
+    /// `--debugfs`) populate this directly. The source-kerneldoc parser
+    /// populates it only when the `transform-to:` subfield is a numeric
+    /// literal; symbolic signal names are arch-dependent and cannot be
+    /// resolved portably in userspace, so they are reported via an
+    /// stderr warning and leave this field `None`. Consumers that need
+    /// the resolved number for a symbolic spec should use `--vmlinux`
+    /// or `--debugfs` against a kernel built for the target arch.
+    pub transform_to: Option<i32>,
+}
+
+/// Signal mask specification
+#[derive(Debug, Clone, serde::Serialize)]
+pub struct SignalMaskSpec {
+    pub name: String,
+    pub description: String,
+    pub signals: Vec<i32>,
+}
+
+/// Side effect specification
+#[derive(Debug, Clone, serde::Serialize)]
+pub struct SideEffectSpec {
+    pub effect_type: u32,
+    pub target: String,
+    pub condition: Option<String>,
+    pub description: String,
+    pub reversible: bool,
+}
+
+/// State transition specification
+#[derive(Debug, Clone, serde::Serialize)]
+pub struct StateTransitionSpec {
+    pub object: String,
+    pub from_state: String,
+    pub to_state: String,
+    pub condition: Option<String>,
+    pub description: String,
+}
+
+/// Constraint specification
+#[derive(Debug, Clone, serde::Serialize)]
+pub struct ConstraintSpec {
+    pub name: String,
+    pub description: String,
+    pub expression: Option<String>,
+}
+
+/// Lock scope enum values matching kernel enum kapi_lock_scope
+pub const KAPI_LOCK_INTERNAL: u32 = 0;
+pub const KAPI_LOCK_ACQUIRES: u32 = 1;
+pub const KAPI_LOCK_RELEASES: u32 = 2;
+pub const KAPI_LOCK_CALLER_HELD: u32 = 3;
+
+/// Lock specification
+#[derive(Debug, Clone, serde::Serialize)]
+pub struct LockSpec {
+    pub lock_name: String,
+    pub lock_type: u32,
+    pub scope: u32,
+    pub description: String,
+}
+
+/// Struct field specification
+#[derive(Debug, Clone, serde::Serialize)]
+pub struct StructFieldSpec {
+    pub name: String,
+    pub field_type: u32,
+    pub type_name: String,
+    pub offset: usize,
+    pub size: usize,
+    pub flags: u32,
+    pub constraint_type: u32,
+    pub min_value: i64,
+    pub max_value: i64,
+    pub valid_mask: u64,
+    pub description: String,
+}
+
+/// Struct specification
+#[derive(Debug, Clone, serde::Serialize)]
+pub struct StructSpec {
+    pub name: String,
+    pub size: usize,
+    pub alignment: usize,
+    pub field_count: u32,
+    pub fields: Vec<StructFieldSpec>,
+    pub description: String,
+}
+
+/// Common API specification information that all extractors should provide
+#[derive(Debug, Clone, Default)]
+pub struct ApiSpec {
+    pub name: String,
+    pub api_type: String,
+    pub description: Option<String>,
+    pub long_description: Option<String>,
+    pub version: Option<String>,
+    pub context_flags: Vec<String>,
+    pub param_count: Option<u32>,
+    pub error_count: Option<u32>,
+    pub examples: Option<String>,
+    pub notes: Option<String>,
+    // Sysfs-specific fields
+    pub subsystem: Option<String>,
+    pub sysfs_path: Option<String>,
+    pub permissions: Option<String>,
+    pub capabilities: Vec<CapabilitySpec>,
+    pub parameters: Vec<ParamSpec>,
+    pub return_spec: Option<ReturnSpec>,
+    pub errors: Vec<ErrorSpec>,
+    pub signals: Vec<SignalSpec>,
+    pub signal_masks: Vec<SignalMaskSpec>,
+    pub side_effects: Vec<SideEffectSpec>,
+    pub state_transitions: Vec<StateTransitionSpec>,
+    pub constraints: Vec<ConstraintSpec>,
+    pub locks: Vec<LockSpec>,
+    pub struct_specs: Vec<StructSpec>,
+}
+
+/// Trait for extracting API specifications from different sources
+pub trait ApiExtractor {
+    /// Extract all API specifications from the source
+    fn extract_all(&self) -> Result<Vec<ApiSpec>>;
+
+    /// Extract a specific API specification by name
+    fn extract_by_name(&self, name: &str) -> Result<Option<ApiSpec>>;
+
+    /// Display detailed information about a specific API
+    fn display_api_details(
+        &self,
+        api_name: &str,
+        formatter: &mut dyn OutputFormatter,
+        writer: &mut dyn Write,
+    ) -> Result<()>;
+}
+
+/// Helper function to display an ApiSpec using a formatter
+pub fn display_api_spec(
+    spec: &ApiSpec,
+    formatter: &mut dyn OutputFormatter,
+    writer: &mut dyn Write,
+) -> Result<()> {
+    formatter.begin_api_details(writer, &spec.name)?;
+
+    if let Some(desc) = &spec.description {
+        formatter.description(writer, desc)?;
+    }
+
+    if let Some(long_desc) = &spec.long_description {
+        formatter.long_description(writer, long_desc)?;
+    }
+
+    if !spec.context_flags.is_empty() {
+        formatter.begin_context_flags(writer)?;
+        for flag in &spec.context_flags {
+            formatter.context_flag(writer, flag)?;
+        }
+        formatter.end_context_flags(writer)?;
+    }
+
+    if !spec.parameters.is_empty() {
+        formatter.begin_parameters(writer, spec.parameters.len().try_into().unwrap_or(u32::MAX))?;
+        for param in &spec.parameters {
+            formatter.parameter(writer, param)?;
+        }
+        formatter.end_parameters(writer)?;
+    }
+
+    if let Some(ret) = &spec.return_spec {
+        formatter.return_spec(writer, ret)?;
+    }
+
+    if !spec.errors.is_empty() {
+        formatter.begin_errors(writer, spec.errors.len().try_into().unwrap_or(u32::MAX))?;
+        for error in &spec.errors {
+            formatter.error(writer, error)?;
+        }
+        formatter.end_errors(writer)?;
+    }
+
+    if let Some(notes) = &spec.notes {
+        formatter.notes(writer, notes)?;
+    }
+
+    if let Some(examples) = &spec.examples {
+        formatter.examples(writer, examples)?;
+    }
+
+    // Display sysfs-specific fields
+    if spec.api_type == "sysfs" {
+        if let Some(subsystem) = &spec.subsystem {
+            formatter.sysfs_subsystem(writer, subsystem)?;
+        }
+        if let Some(path) = &spec.sysfs_path {
+            formatter.sysfs_path(writer, path)?;
+        }
+        if let Some(perms) = &spec.permissions {
+            formatter.sysfs_permissions(writer, perms)?;
+        }
+    }
+
+    if !spec.capabilities.is_empty() {
+        formatter.begin_capabilities(writer)?;
+        for cap in &spec.capabilities {
+            formatter.capability(writer, cap)?;
+        }
+        formatter.end_capabilities(writer)?;
+    }
+
+    // Display signals
+    if !spec.signals.is_empty() {
+        formatter.begin_signals(writer, spec.signals.len().try_into().unwrap_or(u32::MAX))?;
+        for signal in &spec.signals {
+            formatter.signal(writer, signal)?;
+        }
+        formatter.end_signals(writer)?;
+    }
+
+    // Display signal masks
+    if !spec.signal_masks.is_empty() {
+        formatter.begin_signal_masks(
+            writer,
+            spec.signal_masks.len().try_into().unwrap_or(u32::MAX),
+        )?;
+        for mask in &spec.signal_masks {
+            formatter.signal_mask(writer, mask)?;
+        }
+        formatter.end_signal_masks(writer)?;
+    }
+
+    // Display side effects
+    if !spec.side_effects.is_empty() {
+        formatter.begin_side_effects(
+            writer,
+            spec.side_effects.len().try_into().unwrap_or(u32::MAX),
+        )?;
+        for effect in &spec.side_effects {
+            formatter.side_effect(writer, effect)?;
+        }
+        formatter.end_side_effects(writer)?;
+    }
+
+    // Display state transitions
+    if !spec.state_transitions.is_empty() {
+        formatter.begin_state_transitions(
+            writer,
+            spec.state_transitions.len().try_into().unwrap_or(u32::MAX),
+        )?;
+        for trans in &spec.state_transitions {
+            formatter.state_transition(writer, trans)?;
+        }
+        formatter.end_state_transitions(writer)?;
+    }
+
+    // Display constraints
+    if !spec.constraints.is_empty() {
+        formatter.begin_constraints(
+            writer,
+            spec.constraints.len().try_into().unwrap_or(u32::MAX),
+        )?;
+        for constraint in &spec.constraints {
+            formatter.constraint(writer, constraint)?;
+        }
+        formatter.end_constraints(writer)?;
+    }
+
+    // Display locks
+    if !spec.locks.is_empty() {
+        formatter.begin_locks(writer, spec.locks.len().try_into().unwrap_or(u32::MAX))?;
+        for lock in &spec.locks {
+            formatter.lock(writer, lock)?;
+        }
+        formatter.end_locks(writer)?;
+    }
+
+    // Display struct specs
+    if !spec.struct_specs.is_empty() {
+        formatter.begin_struct_specs(
+            writer,
+            spec.struct_specs.len().try_into().unwrap_or(u32::MAX),
+        )?;
+        for struct_spec in &spec.struct_specs {
+            formatter.struct_spec(writer, struct_spec)?;
+        }
+        formatter.end_struct_specs(writer)?;
+    }
+
+    formatter.end_api_details(writer)?;
+
+    Ok(())
+}
diff --git a/tools/kapi/src/extractor/source_parser.rs b/tools/kapi/src/extractor/source_parser.rs
new file mode 100644
index 0000000000000..cc50e15f16c83
--- /dev/null
+++ b/tools/kapi/src/extractor/source_parser.rs
@@ -0,0 +1,531 @@
+// SPDX-License-Identifier: GPL-2.0
+// Copyright (C) 2026 Sasha Levin <sashal@kernel.org>
+
+use super::kerneldoc_parser::KerneldocParser;
+use super::{display_api_spec, ApiExtractor, ApiSpec};
+use crate::formatter::OutputFormatter;
+use anyhow::{bail, Context, Result};
+use regex::Regex;
+use std::fs;
+use std::io::Write;
+use std::path::Path;
+use walkdir::WalkDir;
+
+/// Extractor for kernel source files with KAPI-annotated kerneldoc
+pub struct SourceExtractor {
+    path: String,
+    parser: KerneldocParser,
+    syscall_regex: Regex,
+    ioctl_regex: Regex,
+    function_regex: Regex,
+}
+
+impl SourceExtractor {
+    pub fn new(path: &str) -> Result<Self> {
+        if !Path::new(path).exists() {
+            bail!("Source path does not exist: {path}");
+        }
+
+        Ok(SourceExtractor {
+            path: path.to_string(),
+            parser: KerneldocParser::new(),
+            syscall_regex: Regex::new(r"SYSCALL_DEFINE\d+\((\w+)")?,
+            ioctl_regex: Regex::new(r"(?:static\s+)?long\s+(\w+_ioctl)\s*\(")?,
+            function_regex: Regex::new(concat!(
+                r"(?m)^(?:static\s+)?(?:inline\s+)?",
+                r"(?:(?:unsigned\s+)?",
+                r"(?:long|int|void|char|short",
+                r"|struct\s+\w+\s*\*?",
+                r"|[\w_]+_t)",
+                r"\s*\*?\s+)?",
+                r"(\w+)\s*\([^)]*\)",
+            ))?,
+        })
+    }
+
+    fn extract_from_file(&self, path: &Path) -> Result<Vec<ApiSpec>> {
+        let content = fs::read_to_string(path)
+            .with_context(|| format!("Failed to read file: {}", path.display()))?;
+
+        self.extract_from_content(&content)
+    }
+
+    /// Same rule as has-apispec in scripts/Makefile.build: a contexts: (or
+    /// context-flags:) line plus one more KAPI section.
+    fn has_context_line(doc: &str) -> bool {
+        const SECTIONS: &[&str] = &[
+            "api-type:",
+            "param:",
+            "error:",
+            "capability:",
+            "signal:",
+            "lock:",
+            "state-trans:",
+            "constraint:",
+            "side-effect:",
+            "long-desc:",
+        ];
+        let has_line = |keys: &[&str]| {
+            doc.lines()
+                .map(str::trim_start)
+                .any(|l| keys.iter().any(|k| l.starts_with(k)))
+        };
+
+        has_line(&["contexts:", "context-flags:"]) && has_line(SECTIONS)
+    }
+
+    fn extract_from_content(&self, content: &str) -> Result<Vec<ApiSpec>> {
+        let mut specs = Vec::new();
+        let mut in_kerneldoc = false;
+        let mut current_doc = String::new();
+        let lines: Vec<&str> = content.lines().collect();
+        let mut i = 0;
+
+        while i < lines.len() {
+            let line = lines[i];
+
+            // Start of kerneldoc comment
+            if line.trim_start().starts_with("/**") {
+                in_kerneldoc = true;
+                current_doc.clear();
+                i += 1;
+                continue;
+            }
+
+            // Inside kerneldoc comment
+            if in_kerneldoc {
+                if line.contains("*/") {
+                    in_kerneldoc = false;
+
+                    // Check if this kerneldoc has KAPI annotations
+                    if Self::has_context_line(&current_doc) {
+                        // Look ahead for the function declaration
+                        if let Some((name, api_type, signature)) =
+                            self.find_function_after(&lines, i + 1)
+                        {
+                            if let Ok(spec) = self.parser.parse_kerneldoc(
+                                &current_doc,
+                                &name,
+                                &api_type,
+                                Some(&signature),
+                            ) {
+                                specs.push(spec);
+                            }
+                        }
+                    }
+                } else {
+                    // Remove leading asterisk and preserve content
+                    let cleaned = if let Some(stripped) = line.trim_start().strip_prefix("*") {
+                        if let Some(no_space) = stripped.strip_prefix(' ') {
+                            no_space
+                        } else {
+                            stripped
+                        }
+                    } else {
+                        line.trim_start()
+                    };
+                    current_doc.push_str(cleaned);
+                    current_doc.push('\n');
+                }
+            }
+
+            i += 1;
+        }
+
+        Ok(specs)
+    }
+
+    fn find_function_after(
+        &self,
+        lines: &[&str],
+        start: usize,
+    ) -> Option<(String, String, String)> {
+        for i in start..lines.len().min(start + 10) {
+            let line = lines[i];
+
+            // Skip blank lines and a plain comment before the function
+            let trimmed = line.trim_start();
+            if trimmed.is_empty() || trimmed.starts_with("/*") || trimmed.starts_with('*') {
+                continue;
+            }
+
+            // Check for SYSCALL_DEFINE
+            if let Some(caps) = self.syscall_regex.captures(line) {
+                let name = format!("sys_{}", caps.get(1).unwrap().as_str());
+                let signature = self.extract_syscall_signature(lines, i);
+                return Some((name, "syscall".to_string(), signature));
+            }
+
+            // Check for ioctl function
+            if let Some(caps) = self.ioctl_regex.captures(line) {
+                let name = caps.get(1).unwrap().as_str().to_string();
+                return Some((name, "ioctl".to_string(), line.to_string()));
+            }
+
+            // Check for regular function
+            if let Some(caps) = self.function_regex.captures(line) {
+                let name = caps.get(1).unwrap().as_str().to_string();
+                return Some((name, "function".to_string(), line.to_string()));
+            }
+
+            // Stop if we hit something that's clearly not part of the function declaration
+            if !line.starts_with(' ') && !line.starts_with('\t') && !line.trim().is_empty() {
+                break;
+            }
+        }
+
+        None
+    }
+
+    fn extract_syscall_signature(&self, lines: &[&str], start: usize) -> String {
+        // Extract the full SYSCALL_DEFINE signature
+        let mut sig = String::new();
+        let mut in_paren = false;
+        let mut paren_count = 0;
+
+        for line in lines.iter().skip(start).take(20) {
+            let line = *line;
+
+            // Start of SYSCALL_DEFINE
+            if line.contains("SYSCALL_DEFINE") {
+                if let Some(pos) = line.find('(') {
+                    sig.push_str(&line[pos..]);
+                    in_paren = true;
+                    paren_count = line[pos..].chars().filter(|&c| c == '(').count()
+                        - line[pos..].chars().filter(|&c| c == ')').count();
+                }
+            } else if in_paren {
+                sig.push(' ');
+                sig.push_str(line.trim());
+                paren_count += line.chars().filter(|&c| c == '(').count();
+                paren_count =
+                    paren_count.saturating_sub(line.chars().filter(|&c| c == ')').count());
+
+                if paren_count == 0 {
+                    break;
+                }
+            }
+        }
+
+        sig
+    }
+}
+
+impl ApiExtractor for SourceExtractor {
+    fn extract_all(&self) -> Result<Vec<ApiSpec>> {
+        let path = Path::new(&self.path);
+        let mut all_specs = Vec::new();
+
+        if path.is_file() {
+            // Single file
+            all_specs.extend(self.extract_from_file(path)?);
+        } else if path.is_dir() {
+            // Directory - walk all .c files
+            for entry in WalkDir::new(path)
+                .into_iter()
+                .filter_map(|e| e.ok())
+                .filter(|e| {
+                    e.path()
+                        .extension()
+                        .is_some_and(|ext| ext == "c" || ext == "h")
+                })
+            {
+                match self.extract_from_file(entry.path()) {
+                    Ok(specs) => all_specs.extend(specs),
+                    Err(e) => {
+                        eprintln!("Warning: failed to parse {}: {}", entry.path().display(), e);
+                    }
+                }
+            }
+        }
+
+        Ok(all_specs)
+    }
+
+    fn extract_by_name(&self, name: &str) -> Result<Option<ApiSpec>> {
+        let all_specs = self.extract_all()?;
+        Ok(all_specs.into_iter().find(|s| s.name == name))
+    }
+
+    fn display_api_details(
+        &self,
+        api_name: &str,
+        formatter: &mut dyn OutputFormatter,
+        output: &mut dyn Write,
+    ) -> Result<()> {
+        if let Some(spec) = self.extract_by_name(api_name)? {
+            display_api_spec(&spec, formatter, output)?;
+        } else {
+            writeln!(output, "API '{}' not found", api_name)?;
+        }
+        Ok(())
+    }
+}
+
+#[cfg(test)]
+mod tests {
+    use super::*;
+
+    fn make_extractor() -> SourceExtractor {
+        SourceExtractor::new("/dev/null").unwrap()
+    }
+
+    #[test]
+    fn detect_contexts_spec() {
+        let content = r#"
+/**
+ * sys_foo - do foo
+ * @arg: the argument
+ *
+ * contexts: process, sleepable
+ *
+ * long-desc: Does foo.
+ */
+SYSCALL_DEFINE1(foo, int, arg)
+{
+    return 0;
+}
+
+/**
+ * bar - not a spec, even though the prose mentions context: here
+ * @x: value
+ */
+SYSCALL_DEFINE1(bar, int, x)
+{
+    return 0;
+}
+
+/**
+ * baz - not a spec either
+ * @x: value
+ *
+ * contexts: task, softirq, hardirq, nmi.
+ */
+SYSCALL_DEFINE1(baz, int, x)
+{
+    return 0;
+}
+"#;
+        let specs = make_extractor().extract_from_content(content).unwrap();
+        assert_eq!(specs.len(), 1);
+        assert_eq!(specs[0].name, "sys_foo");
+    }
+
+    #[test]
+    fn prose_mentioning_a_section_key_is_not_a_spec() {
+        let content = r#"
+/**
+ * __probe - check a device
+ * @drv: driver
+ *
+ * returns 0 on success, else error.
+ * side-effect: dev->driver is set to drv when drv claims dev.
+ */
+static int __probe(struct driver *drv, struct device *dev)
+{
+    return 0;
+}
+"#;
+        let specs = make_extractor().extract_from_content(content).unwrap();
+        assert!(specs.is_empty());
+    }
+
+    #[test]
+    fn nonexistent_path_is_rejected() {
+        let err = SourceExtractor::new("/nonexistent/kapi-test")
+            .err()
+            .unwrap();
+
+        assert!(err.to_string().contains("does not exist"), "{err}");
+    }
+
+    #[test]
+    fn has_context_line_needs_two_sections() {
+        let rule = SourceExtractor::has_context_line;
+
+        assert!(rule("contexts: process\nlong-desc: foo\n"));
+        assert!(rule("context-flags: KAPI_CTX_PROCESS\n  lock: foo\n"));
+        assert!(rule("contexts: process\nparam: fd\n"));
+        assert!(rule("contexts: process\nerror: EINVAL, bad fd\n"));
+        assert!(!rule("contexts: process\n"));
+        assert!(!rule("context: process\nlong-desc: foo\n"));
+        assert!(!rule("long-desc: foo\nside-effect: bar\n"));
+    }
+
+    #[test]
+    fn detect_syscall_define3() {
+        let content = r#"
+/**
+ * sys_open - open a file
+ * context-flags: KAPI_CTX_PROCESS
+ * param-count: 3
+ * @filename: pathname to open
+ * param: filename
+ * error: ENOENT, test
+ */
+SYSCALL_DEFINE3(open, const char __user *, filename, int, flags, umode_t, mode)
+{
+    return 0;
+}
+"#;
+        let ext = make_extractor();
+        let specs = ext.extract_from_content(content).unwrap();
+        assert_eq!(specs.len(), 1);
+        assert_eq!(specs[0].name, "sys_open");
+        assert_eq!(specs[0].api_type, "syscall");
+    }
+
+    #[test]
+    fn detect_syscall_define1() {
+        let content = r#"
+/**
+ * sys_close - close a file descriptor
+ * context-flags: KAPI_CTX_PROCESS
+ * @fd: file descriptor to close
+ * error: EBADF, test
+ */
+SYSCALL_DEFINE1(close, unsigned int, fd)
+{
+    return 0;
+}
+"#;
+        let ext = make_extractor();
+        let specs = ext.extract_from_content(content).unwrap();
+        assert_eq!(specs.len(), 1);
+        assert_eq!(specs[0].name, "sys_close");
+    }
+
+    #[test]
+    fn detect_syscall_define6() {
+        let content = r#"
+/**
+ * sys_mmap - map memory
+ * context-flags: KAPI_CTX_PROCESS
+ * error: ENOMEM, test
+ */
+SYSCALL_DEFINE6(mmap, unsigned long, addr, unsigned long, len, unsigned long, prot,
+    unsigned long, flags, unsigned long, fd, unsigned long, offset)
+{
+    return 0;
+}
+"#;
+        let ext = make_extractor();
+        let specs = ext.extract_from_content(content).unwrap();
+        assert_eq!(specs.len(), 1);
+        assert_eq!(specs[0].name, "sys_mmap");
+    }
+
+    #[test]
+    fn detect_ioctl_pattern() {
+        let content = r#"
+/**
+ * my_ioctl - handle ioctl
+ * context-flags: KAPI_CTX_PROCESS
+ * error: EINVAL, test
+ */
+static long my_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
+{
+    return 0;
+}
+"#;
+        let ext = make_extractor();
+        let specs = ext.extract_from_content(content).unwrap();
+        assert_eq!(specs.len(), 1);
+        assert_eq!(specs[0].name, "my_ioctl");
+        assert_eq!(specs[0].api_type, "ioctl");
+    }
+
+    #[test]
+    fn find_function_after_skips_blanks() {
+        // Test that find_function_after looks past blank lines
+        let lines = vec!["", "", "SYSCALL_DEFINE2(foo, int, bar, int, baz)", "{"];
+        let ext = make_extractor();
+        let result = ext.find_function_after(&lines, 0);
+        assert!(result.is_some());
+        let (name, api_type, _sig) = result.unwrap();
+        assert_eq!(name, "sys_foo");
+        assert_eq!(api_type, "syscall");
+    }
+
+    #[test]
+    fn find_function_after_skips_plain_comment() {
+        let lines = vec![
+            "/*",
+            " * Careful here!",
+            " */",
+            "SYSCALL_DEFINE1(close, unsigned int, fd)",
+            "{",
+        ];
+        let ext = make_extractor();
+        let (name, api_type, _sig) = ext.find_function_after(&lines, 0).unwrap();
+        assert_eq!(name, "sys_close");
+        assert_eq!(api_type, "syscall");
+    }
+
+    #[test]
+    fn find_function_after_returns_none_for_no_match() {
+        // No function declaration within lookahead range
+        let lines = vec!["#include <linux/fs.h>", "#define FOO 1", "/* comment */"];
+        let ext = make_extractor();
+        let result = ext.find_function_after(&lines, 0);
+        assert!(result.is_none());
+    }
+
+    #[test]
+    fn find_function_after_detects_regular_function() {
+        let lines = vec!["", "int do_something(struct task_struct *task)", "{"];
+        let ext = make_extractor();
+        let result = ext.find_function_after(&lines, 0);
+        assert!(result.is_some());
+        let (name, api_type, _) = result.unwrap();
+        assert_eq!(name, "do_something");
+        assert_eq!(api_type, "function");
+    }
+
+    #[test]
+    fn no_kapi_annotations_produces_empty() {
+        // kerneldoc without any KAPI annotations should not produce a spec
+        let content = r#"
+/**
+ * my_func - does stuff
+ * @arg: an argument
+ */
+void my_func(int arg)
+{
+}
+"#;
+        let ext = make_extractor();
+        let specs = ext.extract_from_content(content).unwrap();
+        assert!(specs.is_empty());
+    }
+
+    #[test]
+    fn multiple_syscalls_in_one_file() {
+        let content = r#"
+/**
+ * sys_read - read from fd
+ * context-flags: KAPI_CTX_PROCESS
+ * error: EBADF, test
+ */
+SYSCALL_DEFINE3(read, unsigned int, fd, char __user *, buf, size_t, count)
+{
+    return 0;
+}
+
+/**
+ * sys_write - write to fd
+ * context-flags: KAPI_CTX_PROCESS
+ * error: EBADF, test
+ */
+SYSCALL_DEFINE3(write, unsigned int, fd, const char __user *, buf, size_t, count)
+{
+    return 0;
+}
+"#;
+        let ext = make_extractor();
+        let specs = ext.extract_from_content(content).unwrap();
+        assert_eq!(specs.len(), 2);
+        assert_eq!(specs[0].name, "sys_read");
+        assert_eq!(specs[1].name, "sys_write");
+    }
+}
diff --git a/tools/kapi/src/extractor/vmlinux/binary_utils.rs b/tools/kapi/src/extractor/vmlinux/binary_utils.rs
new file mode 100644
index 0000000000000..046772ea690c1
--- /dev/null
+++ b/tools/kapi/src/extractor/vmlinux/binary_utils.rs
@@ -0,0 +1,461 @@
+// SPDX-License-Identifier: GPL-2.0
+// Copyright (C) 2026 Sasha Levin <sashal@kernel.org>
+
+// Array-bound constants matching `include/linux/kernel_api_spec.h`.
+// String fields are `const char *`; call `DataReader::ptr_size()` for
+// the per-target pointer width.
+pub mod sizes {
+    pub const MAX_PARAMS: usize = 16;
+    pub const MAX_ERRORS: usize = 32;
+    pub const MAX_CONSTRAINTS: usize = 32;
+    pub const MAX_LOCKS: usize = 16;
+    pub const MAX_CAPABILITIES: usize = 8;
+    pub const MAX_SIGNALS: usize = 32;
+    pub const MAX_STRUCT_SPECS: usize = 8;
+    pub const MAX_SIDE_EFFECTS: usize = 32;
+    pub const MAX_STATE_TRANS: usize = 8;
+
+    pub const NAME: usize = 0;
+    pub const DESC: usize = 0;
+}
+
+// Section markers of `struct kernel_api_spec`. The kernel only sets a
+// marker when the matching *_COUNT()/KAPI_EXAMPLES() macro is used, so
+// a zero marker is as valid as the expected one.
+pub mod magic {
+    pub const PARAMS: u32 = 0x4B415031; // 'KAP1'
+    pub const RETURN: u32 = 0x4B415232; // 'KAR2'
+    pub const ERRORS: u32 = 0x4B414533; // 'KAE3'
+    pub const LOCKS: u32 = 0x4B414C34; // 'KAL4'
+    pub const CONSTRAINTS: u32 = 0x4B414335; // 'KAC5'
+    pub const INFO: u32 = 0x4B414936; // 'KAI6'
+    pub const SIGNALS: u32 = 0x4B415337; // 'KAS7'
+    pub const SIGMASK: u32 = 0x4B414D38; // 'KAM8'
+    pub const STRUCTS: u32 = 0x4B415439; // 'KAT9'
+    pub const EFFECTS: u32 = 0x4B414641; // 'KAFA'
+    pub const TRANS: u32 = 0x4B415442; // 'KATB'
+    pub const CAPS: u32 = 0x4B414343; // 'KACC'
+}
+
+/// Resolve a virtual-address string pointer against the vmlinux ELF
+/// and return the NUL-terminated C string it points at.
+pub fn resolve_vaddr_string(elf: &goblin::elf::Elf, data: &[u8], vaddr: u64) -> Option<String> {
+    if vaddr == 0 {
+        return None;
+    }
+    for sh in &elf.section_headers {
+        let start = sh.sh_addr;
+        let end = start.checked_add(sh.sh_size)?;
+        if vaddr < start || vaddr >= end {
+            continue;
+        }
+        // File-backed sections only (skip SHT_NOBITS etc.)
+        if sh.sh_type == goblin::elf::section_header::SHT_NOBITS {
+            return None;
+        }
+        let rel = (vaddr - start) as usize;
+        let file_start = sh.sh_offset as usize + rel;
+        if file_start >= data.len() {
+            return None;
+        }
+        let tail = &data[file_start..];
+        let nul = tail.iter().position(|&b| b == 0)?;
+        return std::str::from_utf8(&tail[..nul]).ok().map(str::to_string);
+    }
+    None
+}
+
+/// Endianness of the target ELF binary
+#[derive(Clone, Copy, PartialEq)]
+pub enum Endian {
+    Little,
+    Big,
+}
+
+/// Resolves string pointers read from `.kapi_specs` back to their
+/// underlying C strings in the vmlinux rodata.
+pub struct StringResolver<'a> {
+    pub elf: &'a goblin::elf::Elf<'a>,
+    pub vmlinux: &'a [u8],
+}
+
+// Helper for reading data at specific offsets
+pub struct DataReader<'a> {
+    pub data: &'a [u8],
+    pub pos: usize,
+    pub endian: Endian,
+    /// true for 64-bit ELF, false for 32-bit
+    pub is_64bit: bool,
+    /// Used to follow `const char *` fields into rodata.
+    pub resolver: Option<StringResolver<'a>>,
+}
+
+impl<'a> DataReader<'a> {
+    pub fn new(data: &'a [u8], offset: usize, endian: Endian, is_64bit: bool) -> Self {
+        Self {
+            data,
+            pos: offset,
+            endian,
+            is_64bit,
+            resolver: None,
+        }
+    }
+
+    pub fn with_resolver(mut self, resolver: StringResolver<'a>) -> Self {
+        self.resolver = Some(resolver);
+        self
+    }
+
+    /// Pointer width of the target in bytes (4 or 8).
+    pub fn ptr_size(&self) -> usize {
+        if self.is_64bit {
+            8
+        } else {
+            4
+        }
+    }
+
+    /// Advance the read position to the next multiple of `align`.
+    /// Needed before every naturally-aligned field when the containing
+    /// struct is not `__packed`.
+    pub fn align_to(&mut self, align: usize) {
+        if align > 1 {
+            let rem = self.pos % align;
+            if rem != 0 {
+                self.pos = (self.pos + (align - rem)).min(self.data.len());
+            }
+        }
+    }
+
+    /// Read a target-sized pointer slot. Returns the virtual address
+    /// stored in the slot, or `None` if there isn't enough data. The
+    /// caller is expected to align the reader first if the containing
+    /// struct demands natural alignment.
+    pub fn read_ptr(&mut self) -> Option<u64> {
+        self.align_to(self.ptr_size());
+        if self.is_64bit {
+            self.read_u64()
+        } else {
+            self.read_u32().map(|v| v as u64)
+        }
+    }
+
+    pub fn read_bytes(&mut self, len: usize) -> Option<&'a [u8]> {
+        if self.pos + len <= self.data.len() {
+            let bytes = &self.data[self.pos..self.pos + len];
+            self.pos += len;
+            Some(bytes)
+        } else {
+            None
+        }
+    }
+
+    pub fn read_u32(&mut self) -> Option<u32> {
+        self.align_to(4);
+        let b: [u8; 4] = self.read_bytes(4)?.try_into().unwrap();
+        Some(match self.endian {
+            Endian::Little => u32::from_le_bytes(b),
+            Endian::Big => u32::from_be_bytes(b),
+        })
+    }
+
+    pub fn read_u8(&mut self) -> Option<u8> {
+        self.read_bytes(1).map(|b| b[0])
+    }
+
+    pub fn read_i32(&mut self) -> Option<i32> {
+        self.align_to(4);
+        let b: [u8; 4] = self.read_bytes(4)?.try_into().unwrap();
+        Some(match self.endian {
+            Endian::Little => i32::from_le_bytes(b),
+            Endian::Big => i32::from_be_bytes(b),
+        })
+    }
+
+    pub fn read_u64(&mut self) -> Option<u64> {
+        self.align_to(8);
+        let b: [u8; 8] = self.read_bytes(8)?.try_into().unwrap();
+        Some(match self.endian {
+            Endian::Little => u64::from_le_bytes(b),
+            Endian::Big => u64::from_be_bytes(b),
+        })
+    }
+
+    pub fn read_i64(&mut self) -> Option<i64> {
+        self.align_to(8);
+        let b: [u8; 8] = self.read_bytes(8)?.try_into().unwrap();
+        Some(match self.endian {
+            Endian::Little => i64::from_le_bytes(b),
+            Endian::Big => i64::from_be_bytes(b),
+        })
+    }
+
+    /// Read a target-sized unsigned value (4 bytes for 32-bit, 8 bytes for 64-bit).
+    pub fn read_usize(&mut self) -> Option<usize> {
+        self.align_to(self.ptr_size());
+        if self.is_64bit {
+            // No double-align: read_u64 would re-align, but we just
+            // did that with ptr_size() which is 8 on 64-bit.
+            let b: [u8; 8] = self.read_bytes(8)?.try_into().unwrap();
+            Some(match self.endian {
+                Endian::Little => u64::from_le_bytes(b) as usize,
+                Endian::Big => u64::from_be_bytes(b) as usize,
+            })
+        } else {
+            let b: [u8; 4] = self.read_bytes(4)?.try_into().unwrap();
+            Some(match self.endian {
+                Endian::Little => u32::from_le_bytes(b) as usize,
+                Endian::Big => u32::from_be_bytes(b) as usize,
+            })
+        }
+    }
+
+    // Helper methods for common patterns
+    pub fn read_bool(&mut self) -> Option<bool> {
+        self.read_u8().map(|v| v != 0)
+    }
+
+    /// Read a `const char *` slot using the target pointer width
+    /// (4 bytes on 32-bit, 8 bytes on 64-bit) and, if a resolver is
+    /// attached, follow the address into the vmlinux to recover the
+    /// C string. The `_max_len` argument is ignored.
+    pub fn read_optional_string(&mut self, _max_len: usize) -> Option<String> {
+        let vaddr = self.read_ptr()?;
+        let resolver = self.resolver.as_ref()?;
+        resolve_vaddr_string(resolver.elf, resolver.vmlinux, vaddr).filter(|s| !s.is_empty())
+    }
+
+    pub fn read_string_or_default(&mut self, max_len: usize) -> String {
+        self.read_optional_string(max_len).unwrap_or_default()
+    }
+
+    /// Follow a `const s64 *` slot (already read with `read_ptr`) to the
+    /// `count` values it points at. A NULL or unresolvable pointer yields
+    /// an empty list.
+    pub fn resolve_s64_array(&self, vaddr: u64, count: u32) -> Vec<i64> {
+        let Some(resolver) = self.resolver.as_ref() else {
+            return Vec::new();
+        };
+        if vaddr == 0 {
+            return Vec::new();
+        }
+        let Some(start) = super::vaddr_to_file_offset(resolver.elf, vaddr) else {
+            return Vec::new();
+        };
+        let raw = (count as usize)
+            .checked_mul(8)
+            .and_then(|len| start.checked_add(len))
+            .and_then(|end| resolver.vmlinux.get(start..end));
+        raw.map_or_else(Vec::new, |raw| {
+            raw.chunks_exact(8)
+                .map(|chunk| {
+                    let b: [u8; 8] = chunk.try_into().unwrap();
+                    match self.endian {
+                        Endian::Little => i64::from_le_bytes(b),
+                        Endian::Big => i64::from_be_bytes(b),
+                    }
+                })
+                .collect()
+        })
+    }
+}
+
+#[cfg(test)]
+mod tests {
+    use super::*;
+
+    // ---- DataReader little-endian tests ----
+
+    #[test]
+    fn read_u32_little_endian() {
+        let data = [0x78, 0x56, 0x34, 0x12];
+        let mut reader = DataReader::new(&data, 0, Endian::Little, true);
+        assert_eq!(reader.read_u32(), Some(0x12345678));
+    }
+
+    #[test]
+    fn read_u32_big_endian() {
+        let data = [0x12, 0x34, 0x56, 0x78];
+        let mut reader = DataReader::new(&data, 0, Endian::Big, true);
+        assert_eq!(reader.read_u32(), Some(0x12345678));
+    }
+
+    #[test]
+    fn read_u64_little_endian() {
+        let data = 0xDEADBEEFCAFEBABEu64.to_le_bytes();
+        let mut reader = DataReader::new(&data, 0, Endian::Little, true);
+        assert_eq!(reader.read_u64(), Some(0xDEADBEEFCAFEBABE));
+    }
+
+    #[test]
+    fn read_u64_big_endian() {
+        let data = 0xDEADBEEFCAFEBABEu64.to_be_bytes();
+        let mut reader = DataReader::new(&data, 0, Endian::Big, true);
+        assert_eq!(reader.read_u64(), Some(0xDEADBEEFCAFEBABE));
+    }
+
+    #[test]
+    fn read_i32_little_endian_negative() {
+        let val: i32 = -42;
+        let data = val.to_le_bytes();
+        let mut reader = DataReader::new(&data, 0, Endian::Little, true);
+        assert_eq!(reader.read_i32(), Some(-42));
+    }
+
+    #[test]
+    fn read_i32_big_endian_negative() {
+        let val: i32 = -1;
+        let data = val.to_be_bytes();
+        let mut reader = DataReader::new(&data, 0, Endian::Big, true);
+        assert_eq!(reader.read_i32(), Some(-1));
+    }
+
+    #[test]
+    fn read_i64_little_endian() {
+        let val: i64 = -9999999999;
+        let data = val.to_le_bytes();
+        let mut reader = DataReader::new(&data, 0, Endian::Little, true);
+        assert_eq!(reader.read_i64(), Some(-9999999999));
+    }
+
+    #[test]
+    fn read_i64_big_endian() {
+        let val: i64 = i64::MIN;
+        let data = val.to_be_bytes();
+        let mut reader = DataReader::new(&data, 0, Endian::Big, true);
+        assert_eq!(reader.read_i64(), Some(i64::MIN));
+    }
+
+    // ---- read_usize tests ----
+
+    #[test]
+    fn read_usize_64bit() {
+        let val: u64 = 0x00000000FFFFFFFF;
+        let data = val.to_le_bytes();
+        let mut reader = DataReader::new(&data, 0, Endian::Little, true);
+        assert_eq!(reader.read_usize(), Some(0xFFFFFFFF));
+    }
+
+    #[test]
+    fn read_usize_32bit() {
+        let val: u32 = 0xABCD1234;
+        let data = val.to_le_bytes();
+        let mut reader = DataReader::new(&data, 0, Endian::Little, false);
+        assert_eq!(reader.read_usize(), Some(0xABCD1234));
+    }
+
+    #[test]
+    fn read_usize_32bit_does_not_consume_8_bytes() {
+        // In 32-bit mode, read_usize should only consume 4 bytes
+        let mut data = [0u8; 8];
+        data[..4].copy_from_slice(&42u32.to_le_bytes());
+        data[4..8].copy_from_slice(&99u32.to_le_bytes());
+        let mut reader = DataReader::new(&data, 0, Endian::Little, false);
+        assert_eq!(reader.read_usize(), Some(42));
+        // After reading 4 bytes, pos should be at 4
+        assert_eq!(reader.pos, 4);
+        assert_eq!(reader.read_usize(), Some(99));
+    }
+
+    // ---- Bounds checking ----
+
+    #[test]
+    fn read_u32_past_end_returns_none() {
+        let data = [0x01, 0x02, 0x03]; // only 3 bytes, need 4
+        let mut reader = DataReader::new(&data, 0, Endian::Little, true);
+        assert_eq!(reader.read_u32(), None);
+    }
+
+    #[test]
+    fn read_u64_past_end_returns_none() {
+        let data = [0u8; 7]; // only 7 bytes, need 8
+        let mut reader = DataReader::new(&data, 0, Endian::Little, true);
+        assert_eq!(reader.read_u64(), None);
+    }
+
+    #[test]
+    fn read_bytes_past_end_returns_none() {
+        let data = [0u8; 4];
+        let mut reader = DataReader::new(&data, 0, Endian::Little, true);
+        assert_eq!(reader.read_bytes(5), None);
+    }
+
+    #[test]
+    fn read_at_offset() {
+        // read_u32 auto-aligns to a 4-byte boundary, so the starting
+        // offset must itself be 4-aligned for the value to be read
+        // from its declared position.
+        let data = [0xFF, 0xFF, 0xFF, 0xFF, 0x78, 0x56, 0x34, 0x12];
+        let mut reader = DataReader::new(&data, 4, Endian::Little, true);
+        assert_eq!(reader.read_u32(), Some(0x12345678));
+    }
+
+    #[test]
+    fn read_u32_auto_aligns() {
+        // Starting mid-word, read_u32 snaps to the next 4-byte boundary.
+        let data = [0xDE, 0xAD, 0xBE, 0xEF, 0x78, 0x56, 0x34, 0x12];
+        let mut reader = DataReader::new(&data, 1, Endian::Little, true);
+        assert_eq!(reader.read_u32(), Some(0x12345678));
+        assert_eq!(reader.pos, 8);
+    }
+
+    #[test]
+    fn read_ptr_32bit_uses_4_bytes() {
+        let data = [0x78, 0x56, 0x34, 0x12];
+        let mut reader = DataReader::new(&data, 0, Endian::Little, false);
+        assert_eq!(reader.read_ptr(), Some(0x12345678));
+        assert_eq!(reader.pos, 4);
+    }
+
+    #[test]
+    fn read_ptr_64bit_uses_8_bytes() {
+        let data = [0x78, 0x56, 0x34, 0x12, 0x00, 0x00, 0x00, 0x00];
+        let mut reader = DataReader::new(&data, 0, Endian::Little, true);
+        assert_eq!(reader.read_ptr(), Some(0x12345678));
+        assert_eq!(reader.pos, 8);
+    }
+
+    #[test]
+    fn read_bool_values() {
+        let data = [0, 1, 255];
+        let mut reader = DataReader::new(&data, 0, Endian::Little, true);
+        assert_eq!(reader.read_bool(), Some(false));
+        assert_eq!(reader.read_bool(), Some(true));
+        assert_eq!(reader.read_bool(), Some(true)); // any non-zero is true
+    }
+
+    #[test]
+    fn sequential_reads_advance_position() {
+        let mut data = [0u8; 12];
+        data[..4].copy_from_slice(&1u32.to_le_bytes());
+        data[4..8].copy_from_slice(&2u32.to_le_bytes());
+        data[8..12].copy_from_slice(&3u32.to_le_bytes());
+        let mut reader = DataReader::new(&data, 0, Endian::Little, true);
+        assert_eq!(reader.read_u32(), Some(1));
+        assert_eq!(reader.read_u32(), Some(2));
+        assert_eq!(reader.read_u32(), Some(3));
+        assert_eq!(reader.pos, 12);
+    }
+
+    #[test]
+    fn read_optional_string_empty_returns_none() {
+        // A string buffer that is just NUL
+        let data = [0u8; 10];
+        let mut reader = DataReader::new(&data, 0, Endian::Little, true);
+        assert_eq!(reader.read_optional_string(10), None);
+    }
+
+    #[test]
+    fn read_string_or_default_with_empty() {
+        let data = [0u8; 10];
+        let mut reader = DataReader::new(&data, 0, Endian::Little, true);
+        assert_eq!(reader.read_string_or_default(10), "");
+    }
+
+    #[test]
+    fn read_u8_value() {
+        let data = [0x42];
+        let mut reader = DataReader::new(&data, 0, Endian::Little, true);
+        assert_eq!(reader.read_u8(), Some(0x42));
+    }
+}
diff --git a/tools/kapi/src/extractor/vmlinux/mod.rs b/tools/kapi/src/extractor/vmlinux/mod.rs
new file mode 100644
index 0000000000000..5202f7d80c8d8
--- /dev/null
+++ b/tools/kapi/src/extractor/vmlinux/mod.rs
@@ -0,0 +1,1160 @@
+// SPDX-License-Identifier: GPL-2.0
+// Copyright (C) 2026 Sasha Levin <sashal@kernel.org>
+
+use super::{
+    ApiExtractor, ApiSpec, CapabilitySpec, ConstraintSpec, ErrorSpec, LockSpec, ParamSpec,
+    ReturnSpec, SideEffectSpec, SignalMaskSpec, SignalSpec, StateTransitionSpec, StructFieldSpec,
+    StructSpec,
+};
+use crate::formatter::OutputFormatter;
+use anyhow::{Context, Result};
+use goblin::elf::Elf;
+use std::fs;
+use std::io::Write;
+
+mod binary_utils;
+use binary_utils::{magic, sizes, DataReader, Endian};
+
+// Helper to convert empty strings to None
+fn opt_string(s: String) -> Option<String> {
+    if s.is_empty() {
+        None
+    } else {
+        Some(s)
+    }
+}
+
+pub struct VmlinuxExtractor {
+    vmlinux: Vec<u8>,
+    specs: Vec<KapiSpec>,
+    endian: Endian,
+    is_64bit: bool,
+}
+
+#[derive(Debug)]
+struct KapiSpec {
+    name: String,
+    api_type: String,
+    /// File offset in the vmlinux buffer where this spec's
+    /// `struct kernel_api_spec` begins.
+    file_offset: usize,
+}
+
+impl VmlinuxExtractor {
+    pub fn new(vmlinux_path: &str) -> Result<Self> {
+        let vmlinux = fs::read(vmlinux_path)
+            .with_context(|| format!("Failed to read vmlinux file: {vmlinux_path}"))?;
+
+        let elf = Elf::parse(&vmlinux).context("Failed to parse ELF file")?;
+        let endian = if elf.little_endian {
+            Endian::Little
+        } else {
+            Endian::Big
+        };
+        let is_64bit = elf.is_64;
+
+        // Locate the .kapi_specs section boundaries.
+        let mut start_addr = None;
+        let mut stop_addr = None;
+        for sym in &elf.syms {
+            if let Some(name) = elf.strtab.get_at(sym.st_name) {
+                match name {
+                    "__start_kapi_specs" => start_addr = Some(sym.st_value),
+                    "__stop_kapi_specs" => stop_addr = Some(sym.st_value),
+                    _ => {}
+                }
+            }
+        }
+        let start = start_addr.context("Could not find __start_kapi_specs symbol")?;
+        let stop = stop_addr.context("Could not find __stop_kapi_specs symbol")?;
+        if stop <= start {
+            anyhow::bail!("No kernel API specifications found in vmlinux");
+        }
+
+        // `.kapi_specs` is a tightly-packed array of `struct kernel_api_spec *`
+        // pointers; walk them to find each real spec's vaddr, then resolve to
+        // a file offset inside `vmlinux`. Pointer width tracks the target
+        // (4 bytes for 32-bit, 8 bytes for 64-bit).
+        let ptr_size = if is_64bit { 8usize } else { 4 };
+        let ptr_count = ((stop - start) as usize) / ptr_size;
+        let ptr_file_off =
+            vaddr_to_file_offset(&elf, start).context("Could not locate .kapi_specs in file")?;
+
+        let read_ptr = |raw: &[u8]| -> u64 {
+            match (endian, is_64bit) {
+                (Endian::Little, true) => u64::from_le_bytes(raw.try_into().unwrap()),
+                (Endian::Big, true) => u64::from_be_bytes(raw.try_into().unwrap()),
+                (Endian::Little, false) => u32::from_le_bytes(raw.try_into().unwrap()) as u64,
+                (Endian::Big, false) => u32::from_be_bytes(raw.try_into().unwrap()) as u64,
+            }
+        };
+
+        let mut specs = Vec::with_capacity(ptr_count);
+        for i in 0..ptr_count {
+            let p = ptr_file_off + i * ptr_size;
+            if p + ptr_size > vmlinux.len() {
+                break;
+            }
+            let spec_vaddr = read_ptr(&vmlinux[p..p + ptr_size]);
+            if spec_vaddr == 0 {
+                continue;
+            }
+            let Some(spec_file_off) = vaddr_to_file_offset(&elf, spec_vaddr) else {
+                continue;
+            };
+            // The first field of `struct kernel_api_spec` is `const char *name`.
+            if spec_file_off + ptr_size > vmlinux.len() {
+                continue;
+            }
+            let name_vaddr = read_ptr(&vmlinux[spec_file_off..spec_file_off + ptr_size]);
+            let name =
+                binary_utils::resolve_vaddr_string(&elf, &vmlinux, name_vaddr).unwrap_or_default();
+            if name.is_empty() {
+                continue;
+            }
+            let api_type = if name.starts_with("sys_") {
+                "syscall"
+            } else if name.ends_with("_ioctl") {
+                "ioctl"
+            } else {
+                "function"
+            }
+            .to_string();
+            specs.push(KapiSpec {
+                name,
+                api_type,
+                file_offset: spec_file_off,
+            });
+        }
+
+        Ok(VmlinuxExtractor {
+            vmlinux,
+            specs,
+            endian,
+            is_64bit,
+        })
+    }
+}
+
+/// Map a virtual address to a file offset inside the raw vmlinux bytes.
+fn vaddr_to_file_offset(elf: &Elf, vaddr: u64) -> Option<usize> {
+    for sh in &elf.section_headers {
+        let start = sh.sh_addr;
+        let end = start.checked_add(sh.sh_size)?;
+        if vaddr >= start && vaddr < end {
+            if sh.sh_type == goblin::elf::section_header::SHT_NOBITS {
+                return None;
+            }
+            return Some((sh.sh_offset + (vaddr - start)) as usize);
+        }
+    }
+    None
+}
+
+impl VmlinuxExtractor {
+    fn parse_at(&self, file_offset: usize) -> Result<ApiSpec> {
+        parse_binary_to_api_spec(&self.vmlinux, file_offset, self.endian, self.is_64bit)
+    }
+}
+
+impl ApiExtractor for VmlinuxExtractor {
+    fn extract_all(&self) -> Result<Vec<ApiSpec>> {
+        Ok(self
+            .specs
+            .iter()
+            .map(|spec| {
+                self.parse_at(spec.file_offset).unwrap_or_else(|e| {
+                    eprintln!("Warning: cannot parse the spec of {}: {e:#}", spec.name);
+                    ApiSpec {
+                        name: spec.name.clone(),
+                        api_type: spec.api_type.clone(),
+                        ..Default::default()
+                    }
+                })
+            })
+            .collect())
+    }
+
+    fn extract_by_name(&self, api_name: &str) -> Result<Option<ApiSpec>> {
+        if let Some(spec) = self.specs.iter().find(|s| s.name == api_name) {
+            Ok(Some(self.parse_at(spec.file_offset)?))
+        } else {
+            Ok(None)
+        }
+    }
+
+    fn display_api_details(
+        &self,
+        api_name: &str,
+        formatter: &mut dyn OutputFormatter,
+        writer: &mut dyn Write,
+    ) -> Result<()> {
+        if let Some(spec) = self.specs.iter().find(|s| s.name == api_name) {
+            let api_spec = self.parse_at(spec.file_offset)?;
+            super::display_api_spec(&api_spec, formatter, writer)?;
+        }
+        Ok(())
+    }
+}
+
+const TRUNCATED: &str = "kernel_api_spec runs past the end of the file";
+
+/// Consume a section marker. The kernel leaves it zero when the matching
+/// macro is not used, so only a different non-zero value means that the
+/// reader has lost sync with the struct layout.
+fn read_magic(reader: &mut DataReader, expected: u32) -> Result<()> {
+    let found = reader.read_u32().context(TRUNCATED)?;
+    if found != 0 && found != expected {
+        anyhow::bail!(
+            "unexpected section marker {found:#x} at offset {:#x}, expected {expected:#x}",
+            reader.pos - 4
+        );
+    }
+    Ok(())
+}
+
+/// Parse a `{ u32 magic; u32 count; T items[MAX]; }` section. Every one of
+/// the `max_items` slots is consumed, so the reader ends up behind the
+/// whole array; only the first `count` are returned.
+fn parse_array<T, F>(
+    reader: &mut DataReader,
+    expected_magic: u32,
+    max_items: usize,
+    parse_fn: F,
+) -> Result<Vec<T>>
+where
+    F: Fn(&mut DataReader, usize) -> Option<T>,
+{
+    read_magic(reader, expected_magic)?;
+    let count = reader.read_u32().context(TRUNCATED)? as usize;
+    let align = reader.ptr_size();
+    reader.align_to(align);
+
+    let mut items = Vec::new();
+    for i in 0..max_items {
+        let item = parse_fn(reader, i).context(TRUNCATED)?;
+        reader.align_to(align);
+        if i < count {
+            items.push(item);
+        }
+    }
+    Ok(items)
+}
+
+fn parse_binary_to_api_spec(
+    data: &[u8],
+    offset: usize,
+    endian: Endian,
+    is_64bit: bool,
+) -> Result<ApiSpec> {
+    let elf = Elf::parse(data).context("Failed to re-parse ELF for string resolution")?;
+    let resolver = binary_utils::StringResolver {
+        elf: &elf,
+        vmlinux: data,
+    };
+    let mut reader = DataReader::new(data, offset, endian, is_64bit).with_resolver(resolver);
+
+    // Read fields in exact order of struct kernel_api_spec.
+    // Every string field is a `const char *` pointer resolved via the
+    // StringResolver attached to the DataReader.
+    let name = reader
+        .read_optional_string(sizes::NAME)
+        .ok_or_else(|| anyhow::anyhow!("Failed to read API name"))?;
+
+    // Determine API type
+    let api_type = if name.starts_with("sys_") {
+        "syscall"
+    } else if name.ends_with("_ioctl") {
+        "ioctl"
+    } else if name.contains("sysfs") {
+        "sysfs"
+    } else {
+        "function"
+    }
+    .to_string();
+
+    let version = reader.read_u32().map(|v| v.to_string());
+
+    let description = reader
+        .read_optional_string(sizes::DESC)
+        .filter(|s| !s.is_empty());
+
+    let long_description = reader
+        .read_optional_string(sizes::DESC)
+        .filter(|s| !s.is_empty());
+
+    let context_flags = parse_context_flags(&mut reader);
+
+    let parameters = parse_array(&mut reader, magic::PARAMS, sizes::MAX_PARAMS, parse_param)?;
+
+    read_magic(&mut reader, magic::RETURN)?;
+    let return_spec = parse_return_spec(&mut reader);
+
+    let errors = parse_array(&mut reader, magic::ERRORS, sizes::MAX_ERRORS, |r, _| {
+        parse_error(r)
+    })?;
+
+    let locks = parse_array(&mut reader, magic::LOCKS, sizes::MAX_LOCKS, |r, _| {
+        parse_lock(r)
+    })?;
+
+    let constraints = parse_array(
+        &mut reader,
+        magic::CONSTRAINTS,
+        sizes::MAX_CONSTRAINTS,
+        |r, _| parse_constraint(r),
+    )?;
+
+    // Only KAPI_EXAMPLES() sets info_magic, so it says nothing about
+    // whether notes are present.
+    read_magic(&mut reader, magic::INFO)?;
+    let examples = reader
+        .read_optional_string(sizes::DESC)
+        .filter(|s| !s.is_empty());
+    let notes = reader
+        .read_optional_string(sizes::DESC)
+        .filter(|s| !s.is_empty());
+
+    let signals = parse_array(&mut reader, magic::SIGNALS, sizes::MAX_SIGNALS, |r, _| {
+        parse_signal(r)
+    })?;
+
+    let signal_masks = parse_array(&mut reader, magic::SIGMASK, sizes::MAX_SIGNALS, |r, _| {
+        parse_signal_mask(r)
+    })?;
+
+    let struct_specs = parse_array(
+        &mut reader,
+        magic::STRUCTS,
+        sizes::MAX_STRUCT_SPECS,
+        |r, _| parse_struct_spec(r),
+    )?;
+
+    let side_effects = parse_array(
+        &mut reader,
+        magic::EFFECTS,
+        sizes::MAX_SIDE_EFFECTS,
+        |r, _| parse_side_effect(r),
+    )?;
+
+    let state_transitions =
+        parse_array(&mut reader, magic::TRANS, sizes::MAX_STATE_TRANS, |r, _| {
+            parse_state_transition(r)
+        })?;
+
+    let capabilities = parse_array(&mut reader, magic::CAPS, sizes::MAX_CAPABILITIES, |r, _| {
+        parse_capability(r)
+    })?;
+
+    Ok(ApiSpec {
+        name,
+        api_type,
+        description,
+        long_description,
+        version,
+        context_flags,
+        param_count: if parameters.is_empty() {
+            None
+        } else {
+            Some(parameters.len() as u32)
+        },
+        error_count: if errors.is_empty() {
+            None
+        } else {
+            Some(errors.len() as u32)
+        },
+        examples,
+        notes,
+        subsystem: None,
+        sysfs_path: None,
+        permissions: None,
+        capabilities,
+        parameters,
+        return_spec,
+        errors,
+        signals,
+        signal_masks,
+        side_effects,
+        state_transitions,
+        constraints,
+        locks,
+        struct_specs,
+    })
+}
+
+// Helper parsing functions
+
+fn parse_context_flags(reader: &mut DataReader) -> Vec<String> {
+    const KAPI_CTX_PROCESS: u32 = 1 << 0;
+    const KAPI_CTX_SOFTIRQ: u32 = 1 << 1;
+    const KAPI_CTX_HARDIRQ: u32 = 1 << 2;
+    const KAPI_CTX_NMI: u32 = 1 << 3;
+    const KAPI_CTX_ATOMIC: u32 = 1 << 4;
+    const KAPI_CTX_SLEEPABLE: u32 = 1 << 5;
+    const KAPI_CTX_PREEMPT_DISABLED: u32 = 1 << 6;
+    const KAPI_CTX_IRQ_DISABLED: u32 = 1 << 7;
+
+    if let Some(flags) = reader.read_u32() {
+        let mut parts = Vec::new();
+
+        if flags & KAPI_CTX_PROCESS != 0 {
+            parts.push("KAPI_CTX_PROCESS");
+        }
+        if flags & KAPI_CTX_SOFTIRQ != 0 {
+            parts.push("KAPI_CTX_SOFTIRQ");
+        }
+        if flags & KAPI_CTX_HARDIRQ != 0 {
+            parts.push("KAPI_CTX_HARDIRQ");
+        }
+        if flags & KAPI_CTX_NMI != 0 {
+            parts.push("KAPI_CTX_NMI");
+        }
+        if flags & KAPI_CTX_ATOMIC != 0 {
+            parts.push("KAPI_CTX_ATOMIC");
+        }
+        if flags & KAPI_CTX_SLEEPABLE != 0 {
+            parts.push("KAPI_CTX_SLEEPABLE");
+        }
+        if flags & KAPI_CTX_PREEMPT_DISABLED != 0 {
+            parts.push("KAPI_CTX_PREEMPT_DISABLED");
+        }
+        if flags & KAPI_CTX_IRQ_DISABLED != 0 {
+            parts.push("KAPI_CTX_IRQ_DISABLED");
+        }
+
+        parts.into_iter().map(|s| s.to_string()).collect()
+    } else {
+        vec![]
+    }
+}
+
+fn parse_param(reader: &mut DataReader, index: usize) -> Option<ParamSpec> {
+    let name = reader.read_string_or_default(sizes::NAME);
+    let type_name = reader.read_string_or_default(sizes::NAME);
+    let param_type = reader.read_u32()?;
+    let flags = reader.read_u32()?;
+    let size = reader.read_usize()?;
+    let alignment = reader.read_usize()?;
+    let min_value = reader.read_i64()?;
+    let max_value = reader.read_i64()?;
+    let valid_mask = reader.read_u64()?;
+
+    let enum_values_ptr = reader.read_ptr()?;
+    let enum_count = reader.read_u32()?;
+    let constraint_type = reader.read_u32()?;
+    // Skip validate function pointer
+    reader.read_ptr()?;
+
+    let description = reader.read_string_or_default(sizes::DESC);
+    let constraint = reader.read_optional_string(sizes::DESC);
+    let size_param_idx_raw = reader.read_i32()?; // Must use ? to propagate errors
+    let _size_multiplier = reader.read_usize()?; // Must use ? to propagate errors
+
+    // In the C struct, size_param_idx is stored 1-based; 0 means
+    // "no size-carrying param". Surface the real (0-based) index as
+    // `Option<u32>`.
+    let size_param_idx = if size_param_idx_raw > 0 {
+        Some((size_param_idx_raw - 1) as u32)
+    } else {
+        None
+    };
+
+    let mut param = ParamSpec {
+        index: index as u32,
+        name,
+        type_name,
+        description,
+        flags,
+        param_type,
+        constraint_type,
+        constraint,
+        min_value: Some(min_value),
+        max_value: Some(max_value),
+        valid_mask: Some(valid_mask),
+        enum_values: reader
+            .resolve_s64_array(enum_values_ptr, enum_count)
+            .iter()
+            .map(i64::to_string)
+            .collect(),
+        size: Some(size as u32),
+        alignment: Some(alignment as u32),
+        size_param_idx,
+    };
+    param.keep_used_numbers();
+    Some(param)
+}
+
+fn parse_return_spec(reader: &mut DataReader) -> Option<ReturnSpec> {
+    // Read type_name, but treat empty as valid (will be empty string)
+    let type_name = reader.read_string_or_default(sizes::NAME);
+
+    // Read return_type and check_type
+    let return_type = reader.read_u32().unwrap_or(0);
+    let check_type = reader.read_u32().unwrap_or(0);
+    let success_value = reader.read_i64().unwrap_or(0);
+    let success_min = reader.read_i64().unwrap_or(0);
+    let success_max = reader.read_i64().unwrap_or(0);
+
+    let error_values_ptr = reader.read_ptr().unwrap_or(0);
+    let error_count = reader.read_u32().unwrap_or(0);
+    // Skip is_success function pointer
+    let _ = reader.read_ptr();
+
+    let description = reader.read_string_or_default(sizes::DESC);
+
+    // Return a spec even if type_name is empty, as long as we have some data
+    // The type_name might be a string like "KAPI_TYPE_INT" that gets stored literally
+    if type_name.is_empty() && return_type == 0 && check_type == 0 && success_value == 0 {
+        // No return spec at all
+        return None;
+    }
+
+    let mut ret = ReturnSpec {
+        type_name,
+        description,
+        return_type,
+        check_type,
+        success_value: Some(success_value),
+        success_min: Some(success_min),
+        success_max: Some(success_max),
+        error_values: reader
+            .resolve_s64_array(error_values_ptr, error_count)
+            .into_iter()
+            .filter_map(|v| i32::try_from(v).ok())
+            .collect(),
+    };
+    ret.keep_used_success_fields();
+    Some(ret)
+}
+
+fn parse_error(reader: &mut DataReader) -> Option<ErrorSpec> {
+    let error_code = reader.read_i32()?;
+    let name = reader.read_string_or_default(sizes::NAME);
+    let condition = reader.read_string_or_default(sizes::DESC);
+    let description = reader.read_string_or_default(sizes::DESC);
+
+    Some(ErrorSpec {
+        error_code,
+        name,
+        condition,
+        description,
+    })
+}
+
+fn parse_lock(reader: &mut DataReader) -> Option<LockSpec> {
+    let lock_name = reader.read_string_or_default(sizes::NAME);
+    let lock_type = reader.read_u32()?;
+    let scope = reader.read_u32()?;
+    let description = reader.read_string_or_default(sizes::DESC);
+
+    Some(LockSpec {
+        lock_name,
+        lock_type,
+        scope,
+        description,
+    })
+}
+
+fn parse_constraint(reader: &mut DataReader) -> Option<ConstraintSpec> {
+    let name = reader.read_string_or_default(sizes::NAME);
+    let description = reader.read_string_or_default(sizes::DESC);
+    let expression = reader.read_string_or_default(sizes::DESC);
+
+    Some(ConstraintSpec {
+        name,
+        description,
+        expression: opt_string(expression),
+    })
+}
+
+fn parse_signal(reader: &mut DataReader) -> Option<SignalSpec> {
+    // Matches `struct kapi_signal_spec`. All string fields are pointers.
+    let signal_num = reader.read_i32()?;
+    let signal_name = reader.read_optional_string(sizes::NAME).unwrap_or_default();
+    let direction = reader.read_u32()?;
+    let action = reader.read_u32()?;
+    let target = reader.read_optional_string(sizes::DESC);
+    let condition = reader.read_optional_string(sizes::DESC);
+    let description = reader.read_optional_string(sizes::DESC);
+    let restartable = reader.read_bool()?;
+    let sa_flags_required = reader.read_u32()?;
+    let sa_flags_forbidden = reader.read_u32()?;
+    let error_on_signal = reader.read_i32()?;
+    let transform_to = reader.read_i32()?;
+    // Read the symbolic timing token (const char *) and map it to the
+    // numeric timing code used by downstream consumers.
+    let timing_str = reader.read_optional_string(sizes::NAME).unwrap_or_default();
+    let timing = match timing_str.as_str() {
+        "KAPI_SIGNAL_TIME_BEFORE" | "before" => 0u32,
+        "KAPI_SIGNAL_TIME_DURING" | "during" => 1,
+        "KAPI_SIGNAL_TIME_AFTER" | "after" => 2,
+        _ => 0,
+    };
+    let priority = reader.read_u8()?;
+    let interruptible = reader.read_bool()?;
+    let queue_behavior = reader.read_optional_string(sizes::NAME);
+    let state_required = reader.read_u32()?;
+    let state_forbidden = reader.read_u32()?;
+
+    Some(SignalSpec {
+        signal_num,
+        signal_name,
+        direction,
+        action,
+        target,
+        condition,
+        description,
+        timing,
+        priority: priority as u32,
+        restartable,
+        interruptible,
+        queue: queue_behavior,
+        sa_flags: 0, // Not a field of struct kapi_signal_spec
+        sa_flags_required,
+        sa_flags_forbidden,
+        state_required,
+        state_forbidden,
+        // `error_on_signal` of 0 means "no errno returned"; surface
+        // that as None to match the source-parser convention.
+        error_on_signal: if error_on_signal != 0 {
+            Some(error_on_signal)
+        } else {
+            None
+        },
+        transform_to: if transform_to != 0 {
+            // The compiled struct holds the numeric value; the C
+            // preprocessor already resolved any signal symbol.
+            Some(transform_to)
+        } else {
+            None
+        },
+    })
+}
+
+fn parse_signal_mask(reader: &mut DataReader) -> Option<SignalMaskSpec> {
+    let name = reader.read_string_or_default(sizes::NAME);
+
+    let mut signals = Vec::with_capacity(sizes::MAX_SIGNALS);
+    for _ in 0..sizes::MAX_SIGNALS {
+        signals.push(reader.read_i32()?);
+    }
+    let signal_count = reader.read_u32()?;
+    signals.truncate(signal_count as usize);
+
+    let description = reader.read_string_or_default(sizes::DESC);
+
+    Some(SignalMaskSpec {
+        name,
+        description,
+        signals,
+    })
+}
+
+fn parse_struct_field(reader: &mut DataReader) -> Option<StructFieldSpec> {
+    let name = reader.read_string_or_default(sizes::NAME);
+    let field_type = reader.read_u32()?;
+    let type_name = reader.read_string_or_default(sizes::NAME);
+    let offset = reader.read_usize()?;
+    let size = reader.read_usize()?;
+    let flags = reader.read_u32()?;
+    let constraint_type = reader.read_u32()?;
+    let min_value = reader.read_i64()?;
+    let max_value = reader.read_i64()?;
+    let valid_mask = reader.read_u64()?;
+    // enum_values is a `const char *` that StructFieldSpec has no slot for
+    reader.read_ptr()?;
+    let description = reader.read_string_or_default(sizes::DESC);
+
+    Some(StructFieldSpec {
+        name,
+        field_type,
+        type_name,
+        offset,
+        size,
+        flags,
+        constraint_type,
+        min_value,
+        max_value,
+        valid_mask,
+        description,
+    })
+}
+
+fn parse_struct_spec(reader: &mut DataReader) -> Option<StructSpec> {
+    let name = reader.read_string_or_default(sizes::NAME);
+    let size = reader.read_usize()?;
+    let alignment = reader.read_usize()?;
+    let field_count = reader.read_u32()?;
+
+    let mut fields = Vec::new();
+    for i in 0..sizes::MAX_PARAMS {
+        let field = parse_struct_field(reader)?;
+        reader.align_to(reader.ptr_size());
+        if i < field_count as usize {
+            fields.push(field);
+        }
+    }
+
+    let description = reader.read_string_or_default(sizes::DESC);
+
+    Some(StructSpec {
+        name,
+        size,
+        alignment,
+        field_count: fields.len() as u32,
+        fields,
+        description,
+    })
+}
+
+fn parse_side_effect(reader: &mut DataReader) -> Option<SideEffectSpec> {
+    let effect_type = reader.read_u32()?;
+    let target = reader.read_string_or_default(sizes::NAME);
+    let condition = reader.read_string_or_default(sizes::DESC);
+    let description = reader.read_string_or_default(sizes::DESC);
+    let reversible = reader.read_bool()?;
+
+    Some(SideEffectSpec {
+        effect_type,
+        target,
+        condition: opt_string(condition),
+        description,
+        reversible,
+    })
+}
+
+fn parse_state_transition(reader: &mut DataReader) -> Option<StateTransitionSpec> {
+    let from_state = reader.read_string_or_default(sizes::NAME);
+    let to_state = reader.read_string_or_default(sizes::NAME);
+    let condition = reader.read_string_or_default(sizes::DESC);
+    let object = reader.read_string_or_default(sizes::NAME);
+    let description = reader.read_string_or_default(sizes::DESC);
+
+    Some(StateTransitionSpec {
+        object,
+        from_state,
+        to_state,
+        condition: opt_string(condition),
+        description,
+    })
+}
+
+fn parse_capability(reader: &mut DataReader) -> Option<CapabilitySpec> {
+    // Struct layout matches `struct kapi_capability_spec`:
+    //   int capability; const char *cap_name; enum action;
+    //   const char *allows; const char *without_cap;
+    //   const char *check_condition; u8 priority;
+    //   int alternative[KAPI_MAX_CAPABILITIES]; u32 alternative_count;
+    let capability = reader.read_i32()?;
+    let cap_name = reader.read_string_or_default(sizes::NAME);
+    let action = reader.read_u32()?;
+    let allows = reader.read_string_or_default(sizes::DESC);
+    let without_cap = reader.read_string_or_default(sizes::DESC);
+    let check_condition = reader.read_optional_string(sizes::DESC);
+    let priority = reader.read_u8()?;
+
+    let mut alternatives = Vec::with_capacity(sizes::MAX_CAPABILITIES);
+    for _ in 0..sizes::MAX_CAPABILITIES {
+        alternatives.push(reader.read_i32()?);
+    }
+    let alternative_count = reader.read_u32()?;
+    alternatives.truncate(alternative_count as usize);
+
+    Some(CapabilitySpec {
+        capability,
+        name: cap_name,
+        action: capability_action_to_string(action),
+        allows,
+        without_cap,
+        check_condition,
+        priority: Some(priority),
+        alternatives,
+    })
+}
+
+/// Map the `enum kapi_capability_action` numeric value to its symbolic
+/// spelling, matching `include/linux/kernel_api_spec.h`.
+fn capability_action_to_string(n: u32) -> String {
+    match n {
+        0 => "KAPI_CAP_BYPASS_CHECK",
+        1 => "KAPI_CAP_INCREASE_LIMIT",
+        2 => "KAPI_CAP_OVERRIDE_RESTRICTION",
+        3 => "KAPI_CAP_GRANT_PERMISSION",
+        4 => "KAPI_CAP_MODIFY_BEHAVIOR",
+        5 => "KAPI_CAP_ACCESS_RESOURCE",
+        6 => "KAPI_CAP_PERFORM_OPERATION",
+        _ => return n.to_string(),
+    }
+    .to_string()
+}
+
+#[cfg(test)]
+mod tests {
+    use super::*;
+
+    #[test]
+    fn state_transition_with_empty_strings_consumes_the_whole_struct() {
+        // five `const char *` slots: from_state, to_state, condition,
+        // object, description
+        let data = [0u8; 5 * 8];
+        let mut reader = DataReader::new(&data, 0, Endian::Little, true);
+
+        let trans = parse_state_transition(&mut reader).unwrap();
+
+        assert_eq!(reader.pos, data.len());
+        assert_eq!(trans.from_state, "");
+        assert_eq!(trans.condition, None);
+        assert_eq!(trans.description, "");
+    }
+
+    // Offsets inside `struct kernel_api_spec` and its element structs as
+    // laid out by gcc on x86-64, taken from offsetof()/sizeof().
+    const SPEC_SIZE: usize = 26400;
+    const PARAM_MAGIC: usize = 36;
+    const PARAMS: usize = 48;
+    const PARAM_SIZE: usize = 120;
+    const RETURN_MAGIC: usize = 1968;
+    const RETURN_SPEC: usize = 1976;
+    const ERROR_MAGIC: usize = 2048;
+    const ERRORS: usize = 2056;
+    const ERROR_SIZE: usize = 32;
+    const LOCK_MAGIC: usize = 3080;
+    const LOCKS: usize = 3088;
+    const LOCK_SIZE: usize = 24;
+    const CONSTRAINT_MAGIC: usize = 3472;
+    const CONSTRAINTS: usize = 3480;
+    const CONSTRAINT_SIZE: usize = 24;
+    const INFO_MAGIC: usize = 4248;
+    const NOTES: usize = 4264;
+    const SIGNAL_MAGIC: usize = 4272;
+    const SIGNALS: usize = 4280;
+    const SIGNAL_SIZE: usize = 104;
+    const SIGMASK_MAGIC: usize = 7608;
+    const SIGNAL_MASKS: usize = 7616;
+    const SIGNAL_MASK_SIZE: usize = 152;
+    const STRUCT_MAGIC: usize = 12480;
+    const STRUCT_SPECS: usize = 12488;
+    const STRUCT_SPEC_SIZE: usize = 1448;
+    const STRUCT_FIELD_SIZE: usize = 88;
+    const EFFECT_MAGIC: usize = 24072;
+    const SIDE_EFFECTS: usize = 24080;
+    const SIDE_EFFECT_SIZE: usize = 40;
+    const TRANS_MAGIC: usize = 25360;
+    const STATE_TRANSITIONS: usize = 25368;
+    const STATE_TRANSITION_SIZE: usize = 40;
+    const CAP_MAGIC: usize = 25688;
+    const CAPABILITIES: usize = 25696;
+    const CAPABILITY_SIZE: usize = 88;
+
+    const BASE: u64 = 0xffff_ffff_8100_0000;
+    const CONTENT_OFFSET: usize = 0x1000;
+
+    /// A `struct kernel_api_spec` image preceded by the strings and
+    /// `s64` arrays it points at, wrapped in a minimal ELF file.
+    struct Image {
+        spec: Vec<u8>,
+        tail: Vec<u8>,
+    }
+
+    impl Image {
+        fn new() -> Self {
+            Image {
+                spec: vec![0; SPEC_SIZE],
+                tail: Vec::new(),
+            }
+        }
+
+        fn u32(&mut self, at: usize, v: u32) {
+            self.spec[at..at + 4].copy_from_slice(&v.to_le_bytes());
+        }
+
+        fn u64(&mut self, at: usize, v: u64) {
+            self.spec[at..at + 8].copy_from_slice(&v.to_le_bytes());
+        }
+
+        fn tail_vaddr(&self) -> u64 {
+            BASE + self.tail.len() as u64
+        }
+
+        fn string(&mut self, at: usize, s: &str) {
+            let vaddr = self.tail_vaddr();
+            self.tail.extend_from_slice(s.as_bytes());
+            self.tail.push(0);
+            self.u64(at, vaddr);
+        }
+
+        fn s64s(&mut self, at: usize, vals: &[i64]) {
+            while self.tail.len() % 8 != 0 {
+                self.tail.push(0);
+            }
+            let vaddr = self.tail_vaddr();
+            for v in vals {
+                self.tail.extend_from_slice(&v.to_le_bytes());
+            }
+            self.u64(at, vaddr);
+        }
+
+        fn elf(&self) -> Vec<u8> {
+            let mut content = self.tail.clone();
+            content.extend_from_slice(&self.spec);
+
+            let mut img = vec![0u8; CONTENT_OFFSET];
+            img[..4].copy_from_slice(b"\x7fELF");
+            img[4] = 2; // ELFCLASS64
+            img[5] = 1; // ELFDATA2LSB
+            img[6] = 1; // EV_CURRENT
+            img[16..18].copy_from_slice(&2u16.to_le_bytes()); // ET_EXEC
+            img[18..20].copy_from_slice(&62u16.to_le_bytes()); // EM_X86_64
+            img[20..24].copy_from_slice(&1u32.to_le_bytes());
+            img[40..48].copy_from_slice(&64u64.to_le_bytes()); // e_shoff
+            img[52..54].copy_from_slice(&64u16.to_le_bytes()); // e_ehsize
+            img[58..60].copy_from_slice(&64u16.to_le_bytes()); // e_shentsize
+            img[60..62].copy_from_slice(&2u16.to_le_bytes()); // e_shnum
+            let sh = 64 + 64; // section 1 follows the null section header at 64
+            img[sh + 4..sh + 8].copy_from_slice(&1u32.to_le_bytes()); // SHT_PROGBITS
+            img[sh + 8..sh + 16].copy_from_slice(&2u64.to_le_bytes()); // SHF_ALLOC
+            img[sh + 16..sh + 24].copy_from_slice(&BASE.to_le_bytes());
+            img[sh + 24..sh + 32].copy_from_slice(&(CONTENT_OFFSET as u64).to_le_bytes());
+            img[sh + 32..sh + 40].copy_from_slice(&(content.len() as u64).to_le_bytes());
+            img[sh + 48..sh + 56].copy_from_slice(&8u64.to_le_bytes());
+            img.extend_from_slice(&content);
+            img
+        }
+
+        fn parse(&mut self) -> Result<ApiSpec> {
+            self.string(0, "kapi_fixture");
+            while self.tail.len() % 8 != 0 {
+                self.tail.push(0);
+            }
+            let img = self.elf();
+            parse_binary_to_api_spec(&img, CONTENT_OFFSET + self.tail.len(), Endian::Little, true)
+        }
+    }
+
+    #[test]
+    fn every_array_slot_is_consumed() {
+        let mut img = Image::new();
+        img.u32(PARAM_MAGIC, magic::PARAMS);
+        img.u32(PARAM_MAGIC + 4, 16);
+        img.u32(RETURN_MAGIC, magic::RETURN);
+        img.u32(ERROR_MAGIC, magic::ERRORS);
+        img.u32(ERROR_MAGIC + 4, 32);
+        img.u32(LOCK_MAGIC, magic::LOCKS);
+        img.u32(LOCK_MAGIC + 4, 16);
+        img.u32(CONSTRAINT_MAGIC, magic::CONSTRAINTS);
+        img.u32(CONSTRAINT_MAGIC + 4, 32);
+        img.u32(SIGNAL_MAGIC, magic::SIGNALS);
+        img.u32(SIGNAL_MAGIC + 4, 32);
+        img.u32(SIGMASK_MAGIC, magic::SIGMASK);
+        img.u32(SIGMASK_MAGIC + 4, 32);
+        img.u32(STRUCT_MAGIC, magic::STRUCTS);
+        img.u32(STRUCT_MAGIC + 4, 8);
+        img.u32(EFFECT_MAGIC, magic::EFFECTS);
+        img.u32(EFFECT_MAGIC + 4, 32);
+        img.u32(TRANS_MAGIC, magic::TRANS);
+        img.u32(TRANS_MAGIC + 4, 8);
+        img.u32(CAP_MAGIC, magic::CAPS);
+        img.u32(CAP_MAGIC + 4, 8);
+
+        img.string(PARAMS + 15 * PARAM_SIZE, "last_param");
+        img.u32(ERRORS + 31 * ERROR_SIZE, -7i32 as u32);
+        img.string(ERRORS + 31 * ERROR_SIZE + 8, "ELAST");
+        img.string(LOCKS + 15 * LOCK_SIZE, "last_lock");
+        img.string(CONSTRAINTS + 31 * CONSTRAINT_SIZE, "last_constraint");
+        img.u32(SIGNALS + 31 * SIGNAL_SIZE, 31);
+        img.u32(SIGNAL_MASKS + 31 * SIGNAL_MASK_SIZE + 8, 64);
+        img.u32(SIGNAL_MASKS + 31 * SIGNAL_MASK_SIZE + 136, 1);
+        img.string(SIGNAL_MASKS + 31 * SIGNAL_MASK_SIZE, "last mask");
+        img.string(SIGNAL_MASKS + 31 * SIGNAL_MASK_SIZE + 144, "mask desc");
+
+        let last_struct = STRUCT_SPECS + 7 * STRUCT_SPEC_SIZE;
+        img.string(last_struct, "last_struct");
+        img.u32(last_struct + 24, 16);
+        img.string(last_struct + 32 + 15 * STRUCT_FIELD_SIZE, "last_field");
+        img.string(last_struct + 32 + 15 * STRUCT_FIELD_SIZE + 80, "field desc");
+        img.string(last_struct + 1440, "struct desc");
+
+        img.string(SIDE_EFFECTS + 31 * SIDE_EFFECT_SIZE + 8, "last_effect");
+        img.string(
+            STATE_TRANSITIONS + 7 * STATE_TRANSITION_SIZE + 24,
+            "last_object",
+        );
+        let last_cap = CAPABILITIES + 7 * CAPABILITY_SIZE;
+        img.u32(last_cap, 40);
+        img.u32(last_cap + 52 + 7 * 4, 99);
+        img.u32(last_cap + 84, 8);
+
+        let spec = img.parse().unwrap();
+
+        assert_eq!(spec.parameters.len(), 16);
+        assert_eq!(spec.parameters[15].name, "last_param");
+        assert_eq!(spec.errors.len(), 32);
+        assert_eq!(spec.errors[31].error_code, -7);
+        assert_eq!(spec.errors[31].name, "ELAST");
+        assert_eq!(spec.locks[15].lock_name, "last_lock");
+        assert_eq!(spec.constraints[31].name, "last_constraint");
+        assert_eq!(spec.signals[31].signal_num, 31);
+        assert_eq!(spec.signal_masks.len(), 32);
+        assert_eq!(spec.signal_masks[31].name, "last mask");
+        assert_eq!(spec.signal_masks[31].signals, [64]);
+        assert_eq!(spec.signal_masks[31].description, "mask desc");
+
+        let st = &spec.struct_specs[7];
+        assert_eq!(st.name, "last_struct");
+        assert_eq!(st.description, "struct desc");
+        assert_eq!(st.field_count, 16);
+        assert_eq!(st.fields[15].name, "last_field");
+        assert_eq!(st.fields[15].description, "field desc");
+
+        assert_eq!(spec.side_effects[31].target, "last_effect");
+        assert_eq!(spec.state_transitions[7].object, "last_object");
+        let cap = &spec.capabilities[7];
+        assert_eq!(cap.capability, 40);
+        assert_eq!(cap.alternatives, [0, 0, 0, 0, 0, 0, 0, 99]);
+    }
+
+    #[test]
+    fn notes_and_signal_masks_are_read_without_their_markers() {
+        let mut img = Image::new();
+        img.u32(SIGMASK_MAGIC + 4, 2);
+        img.string(NOTES, "only notes");
+        img.string(SIGNAL_MASKS, "first");
+        img.u32(SIGNAL_MASKS + 8, 2);
+        img.u32(SIGNAL_MASKS + 12, 15);
+        img.u32(SIGNAL_MASKS + 136, 2);
+        img.string(SIGNAL_MASKS + 144, "first desc");
+        img.string(SIGNAL_MASKS + SIGNAL_MASK_SIZE, "second");
+
+        let spec = img.parse().unwrap();
+
+        assert_eq!(spec.examples, None);
+        assert_eq!(spec.notes.as_deref(), Some("only notes"));
+        assert_eq!(spec.signal_masks.len(), 2);
+        assert_eq!(spec.signal_masks[0].name, "first");
+        assert_eq!(spec.signal_masks[0].description, "first desc");
+        assert_eq!(spec.signal_masks[0].signals, [2, 15]);
+        assert_eq!(spec.signal_masks[1].name, "second");
+        assert!(spec.signal_masks[1].signals.is_empty());
+    }
+
+    #[test]
+    fn examples_are_read_next_to_notes() {
+        let mut img = Image::new();
+        img.u32(INFO_MAGIC, magic::INFO);
+        img.string(INFO_MAGIC + 8, "an example");
+        img.string(NOTES, "a note");
+
+        let spec = img.parse().unwrap();
+
+        assert_eq!(spec.examples.as_deref(), Some("an example"));
+        assert_eq!(spec.notes.as_deref(), Some("a note"));
+    }
+
+    #[test]
+    fn enum_and_error_values_are_followed_through_their_pointers() {
+        let mut img = Image::new();
+        img.u32(PARAM_MAGIC, magic::PARAMS);
+        img.u32(PARAM_MAGIC + 4, 2);
+        img.string(PARAMS, "mode");
+        img.s64s(PARAMS + 64, &[0, 1, -7, 1 << 40]);
+        img.u32(PARAMS + 72, 4);
+        img.string(PARAMS + PARAM_SIZE, "plain");
+        img.u32(RETURN_MAGIC, magic::RETURN);
+        img.string(RETURN_SPEC, "long");
+        img.u32(RETURN_SPEC + 12, 2);
+        img.s64s(RETURN_SPEC + 40, &[-22, -2, -(1 << 40)]);
+        img.u32(RETURN_SPEC + 48, 3);
+
+        let spec = img.parse().unwrap();
+
+        assert_eq!(
+            spec.parameters[0].enum_values,
+            ["0", "1", "-7", "1099511627776"]
+        );
+        assert!(spec.parameters[1].enum_values.is_empty());
+        let ret = spec.return_spec.unwrap();
+        assert_eq!(ret.check_type, 2);
+        assert_eq!(ret.error_values, [-22, -2]);
+    }
+
+    #[test]
+    fn numbers_the_constraint_does_not_use_are_unset() {
+        let mut img = Image::new();
+        img.u32(PARAM_MAGIC, magic::PARAMS);
+        img.u32(PARAM_MAGIC + 4, 4);
+        img.string(PARAMS, "plain");
+        let ranged = PARAMS + PARAM_SIZE;
+        img.string(ranged, "ranged");
+        img.u64(ranged + 24, 16);
+        img.u64(ranged + 40, -5i64 as u64);
+        img.u64(ranged + 48, 9);
+        img.u64(ranged + 56, 0xff);
+        img.u32(ranged + 76, 1);
+        let string = PARAMS + 2 * PARAM_SIZE;
+        img.string(string, "string");
+        img.u64(string + 40, 1);
+        img.u64(string + 48, 255);
+        img.u32(string + 76, 8);
+        let unlimited = PARAMS + 3 * PARAM_SIZE;
+        img.string(unlimited, "unlimited");
+        img.u32(unlimited + 76, 8);
+        img.u32(RETURN_MAGIC, magic::RETURN);
+        img.string(RETURN_SPEC, "long");
+        img.u32(RETURN_SPEC + 12, 1);
+        img.u64(RETURN_SPEC + 16, 7);
+        img.u64(RETURN_SPEC + 32, 100);
+
+        let spec = img.parse().unwrap();
+
+        let plain = &spec.parameters[0];
+        assert_eq!((plain.min_value, plain.max_value), (None, None));
+        assert_eq!(
+            (plain.valid_mask, plain.size, plain.alignment),
+            (None, None, None)
+        );
+        let ranged = &spec.parameters[1];
+        assert_eq!((ranged.min_value, ranged.max_value), (Some(-5), Some(9)));
+        assert_eq!((ranged.valid_mask, ranged.size), (None, Some(16)));
+        let string = &spec.parameters[2];
+        assert_eq!((string.min_value, string.max_value), (Some(1), Some(255)));
+        let unlimited = &spec.parameters[3];
+        assert_eq!((unlimited.min_value, unlimited.max_value), (None, None));
+        let ret = spec.return_spec.unwrap();
+        assert_eq!(ret.success_value, None);
+        assert_eq!((ret.success_min, ret.success_max), (Some(0), Some(100)));
+    }
+
+    #[test]
+    fn enum_values_behind_a_dangling_pointer_are_dropped() {
+        let mut img = Image::new();
+        img.u32(PARAM_MAGIC, magic::PARAMS);
+        img.u32(PARAM_MAGIC + 4, 1);
+        img.string(PARAMS, "mode");
+        img.u64(PARAMS + 64, 0x1000);
+        img.u32(PARAMS + 72, 4);
+
+        let spec = img.parse().unwrap();
+
+        assert!(spec.parameters[0].enum_values.is_empty());
+    }
+
+    #[test]
+    fn unexpected_section_marker_is_rejected() {
+        let mut img = Image::new();
+        img.u32(ERROR_MAGIC, 0xdead_beef);
+
+        let err = img.parse().unwrap_err();
+
+        assert!(err.to_string().contains("0xdeadbeef"), "{err}");
+    }
+
+    #[test]
+    fn truncated_spec_is_rejected() {
+        let mut img = Image::new();
+        img.spec.truncate(SIGNAL_MASKS);
+
+        let err = img.parse().unwrap_err();
+
+        assert!(err.to_string().contains("past the end"), "{err}");
+    }
+}
diff --git a/tools/kapi/src/formatter/json.rs b/tools/kapi/src/formatter/json.rs
new file mode 100644
index 0000000000000..5f2367ad12d40
--- /dev/null
+++ b/tools/kapi/src/formatter/json.rs
@@ -0,0 +1,659 @@
+// SPDX-License-Identifier: GPL-2.0
+// Copyright (C) 2026 Sasha Levin <sashal@kernel.org>
+
+use super::OutputFormatter;
+use crate::extractor::{
+    CapabilitySpec, ConstraintSpec, ErrorSpec, LockSpec, ParamSpec, ReturnSpec, SideEffectSpec,
+    SignalMaskSpec, SignalSpec, StateTransitionSpec, StructSpec,
+};
+use serde::Serialize;
+use std::io::Write;
+
+pub struct JsonFormatter {
+    data: JsonData,
+}
+
+#[derive(Serialize)]
+struct JsonData {
+    #[serde(skip_serializing_if = "Option::is_none")]
+    apis: Option<Vec<JsonApi>>,
+    #[serde(skip_serializing_if = "Option::is_none")]
+    api_details: Option<JsonApiDetails>,
+}
+
+#[derive(Serialize)]
+struct JsonApi {
+    name: String,
+    api_type: String,
+}
+
+#[derive(Serialize)]
+struct JsonApiDetails {
+    name: String,
+    #[serde(skip_serializing_if = "Option::is_none")]
+    description: Option<String>,
+    #[serde(skip_serializing_if = "Option::is_none")]
+    long_description: Option<String>,
+    #[serde(skip_serializing_if = "Vec::is_empty")]
+    context_flags: Vec<String>,
+    #[serde(skip_serializing_if = "Option::is_none")]
+    examples: Option<String>,
+    #[serde(skip_serializing_if = "Option::is_none")]
+    notes: Option<String>,
+    // Sysfs-specific fields
+    #[serde(skip_serializing_if = "Option::is_none")]
+    subsystem: Option<String>,
+    #[serde(skip_serializing_if = "Option::is_none")]
+    sysfs_path: Option<String>,
+    #[serde(skip_serializing_if = "Option::is_none")]
+    permissions: Option<String>,
+    #[serde(skip_serializing_if = "Vec::is_empty")]
+    capabilities: Vec<CapabilitySpec>,
+    #[serde(skip_serializing_if = "Vec::is_empty")]
+    state_transitions: Vec<StateTransitionSpec>,
+    #[serde(skip_serializing_if = "Vec::is_empty")]
+    side_effects: Vec<SideEffectSpec>,
+    #[serde(skip_serializing_if = "Vec::is_empty")]
+    parameters: Vec<ParamSpec>,
+    #[serde(skip_serializing_if = "Option::is_none")]
+    return_spec: Option<ReturnSpec>,
+    #[serde(skip_serializing_if = "Vec::is_empty")]
+    errors: Vec<ErrorSpec>,
+    #[serde(skip_serializing_if = "Vec::is_empty")]
+    locks: Vec<LockSpec>,
+    #[serde(skip_serializing_if = "Vec::is_empty")]
+    struct_specs: Vec<StructSpec>,
+    #[serde(skip_serializing_if = "Vec::is_empty")]
+    signals: Vec<SignalSpec>,
+    #[serde(skip_serializing_if = "Vec::is_empty")]
+    signal_masks: Vec<SignalMaskSpec>,
+    #[serde(skip_serializing_if = "Vec::is_empty")]
+    constraints: Vec<ConstraintSpec>,
+}
+
+impl JsonFormatter {
+    pub fn new() -> Self {
+        JsonFormatter {
+            data: JsonData {
+                apis: None,
+                api_details: None,
+            },
+        }
+    }
+}
+
+impl OutputFormatter for JsonFormatter {
+    fn begin_document(&mut self, _w: &mut dyn Write) -> std::io::Result<()> {
+        Ok(())
+    }
+
+    fn end_document(&mut self, w: &mut dyn Write) -> std::io::Result<()> {
+        let json = serde_json::to_string_pretty(&self.data)?;
+        writeln!(w, "{json}")?;
+        Ok(())
+    }
+
+    fn begin_api_list(&mut self, _w: &mut dyn Write, _title: &str) -> std::io::Result<()> {
+        if self.data.apis.is_none() {
+            self.data.apis = Some(Vec::new());
+        }
+        Ok(())
+    }
+
+    fn api_item(&mut self, _w: &mut dyn Write, name: &str, api_type: &str) -> std::io::Result<()> {
+        if let Some(apis) = &mut self.data.apis {
+            apis.push(JsonApi {
+                name: name.to_string(),
+                api_type: api_type.to_string(),
+            });
+        }
+        Ok(())
+    }
+
+    fn end_api_list(&mut self, _w: &mut dyn Write) -> std::io::Result<()> {
+        Ok(())
+    }
+
+    fn total_specs(&mut self, _w: &mut dyn Write, _count: usize) -> std::io::Result<()> {
+        Ok(())
+    }
+
+    fn begin_api_details(&mut self, _w: &mut dyn Write, name: &str) -> std::io::Result<()> {
+        self.data.api_details = Some(JsonApiDetails {
+            name: name.to_string(),
+            description: None,
+            long_description: None,
+            context_flags: Vec::new(),
+            examples: None,
+            notes: None,
+            subsystem: None,
+            sysfs_path: None,
+            permissions: None,
+            capabilities: Vec::new(),
+            state_transitions: Vec::new(),
+            side_effects: Vec::new(),
+            parameters: Vec::new(),
+            return_spec: None,
+            errors: Vec::new(),
+            locks: Vec::new(),
+            struct_specs: Vec::new(),
+            signals: Vec::new(),
+            signal_masks: Vec::new(),
+            constraints: Vec::new(),
+        });
+        Ok(())
+    }
+
+    fn end_api_details(&mut self, _w: &mut dyn Write) -> std::io::Result<()> {
+        Ok(())
+    }
+
+    fn description(&mut self, _w: &mut dyn Write, desc: &str) -> std::io::Result<()> {
+        if let Some(details) = &mut self.data.api_details {
+            details.description = Some(desc.to_string());
+        }
+        Ok(())
+    }
+
+    fn long_description(&mut self, _w: &mut dyn Write, desc: &str) -> std::io::Result<()> {
+        if let Some(details) = &mut self.data.api_details {
+            details.long_description = Some(desc.to_string());
+        }
+        Ok(())
+    }
+
+    fn begin_context_flags(&mut self, _w: &mut dyn Write) -> std::io::Result<()> {
+        Ok(())
+    }
+
+    fn context_flag(&mut self, _w: &mut dyn Write, flag: &str) -> std::io::Result<()> {
+        if let Some(details) = &mut self.data.api_details {
+            details.context_flags.push(flag.to_string());
+        }
+        Ok(())
+    }
+
+    fn end_context_flags(&mut self, _w: &mut dyn Write) -> std::io::Result<()> {
+        Ok(())
+    }
+
+    fn begin_parameters(&mut self, _w: &mut dyn Write, _count: u32) -> std::io::Result<()> {
+        Ok(())
+    }
+
+    fn end_parameters(&mut self, _w: &mut dyn Write) -> std::io::Result<()> {
+        Ok(())
+    }
+
+    fn begin_errors(&mut self, _w: &mut dyn Write, _count: u32) -> std::io::Result<()> {
+        Ok(())
+    }
+
+    fn end_errors(&mut self, _w: &mut dyn Write) -> std::io::Result<()> {
+        Ok(())
+    }
+
+    fn examples(&mut self, _w: &mut dyn Write, examples: &str) -> std::io::Result<()> {
+        if let Some(details) = &mut self.data.api_details {
+            details.examples = Some(examples.to_string());
+        }
+        Ok(())
+    }
+
+    fn notes(&mut self, _w: &mut dyn Write, notes: &str) -> std::io::Result<()> {
+        if let Some(details) = &mut self.data.api_details {
+            details.notes = Some(notes.to_string());
+        }
+        Ok(())
+    }
+
+    fn sysfs_subsystem(&mut self, _w: &mut dyn Write, subsystem: &str) -> std::io::Result<()> {
+        if let Some(details) = &mut self.data.api_details {
+            details.subsystem = Some(subsystem.to_string());
+        }
+        Ok(())
+    }
+
+    fn sysfs_path(&mut self, _w: &mut dyn Write, path: &str) -> std::io::Result<()> {
+        if let Some(details) = &mut self.data.api_details {
+            details.sysfs_path = Some(path.to_string());
+        }
+        Ok(())
+    }
+
+    fn sysfs_permissions(&mut self, _w: &mut dyn Write, perms: &str) -> std::io::Result<()> {
+        if let Some(details) = &mut self.data.api_details {
+            details.permissions = Some(perms.to_string());
+        }
+        Ok(())
+    }
+
+    fn begin_capabilities(&mut self, _w: &mut dyn Write) -> std::io::Result<()> {
+        Ok(())
+    }
+
+    fn capability(&mut self, _w: &mut dyn Write, cap: &CapabilitySpec) -> std::io::Result<()> {
+        if let Some(details) = &mut self.data.api_details {
+            details.capabilities.push(cap.clone());
+        }
+        Ok(())
+    }
+
+    fn end_capabilities(&mut self, _w: &mut dyn Write) -> std::io::Result<()> {
+        Ok(())
+    }
+
+    fn parameter(&mut self, _w: &mut dyn Write, param: &ParamSpec) -> std::io::Result<()> {
+        if let Some(details) = &mut self.data.api_details {
+            details.parameters.push(param.clone());
+        }
+        Ok(())
+    }
+
+    fn return_spec(&mut self, _w: &mut dyn Write, ret: &ReturnSpec) -> std::io::Result<()> {
+        if let Some(details) = &mut self.data.api_details {
+            details.return_spec = Some(ret.clone());
+        }
+        Ok(())
+    }
+
+    fn error(&mut self, _w: &mut dyn Write, error: &ErrorSpec) -> std::io::Result<()> {
+        if let Some(details) = &mut self.data.api_details {
+            details.errors.push(error.clone());
+        }
+        Ok(())
+    }
+
+    fn begin_signals(&mut self, _w: &mut dyn Write, _count: u32) -> std::io::Result<()> {
+        Ok(())
+    }
+
+    fn signal(&mut self, _w: &mut dyn Write, signal: &SignalSpec) -> std::io::Result<()> {
+        if let Some(api_details) = &mut self.data.api_details {
+            api_details.signals.push(signal.clone());
+        }
+        Ok(())
+    }
+
+    fn end_signals(&mut self, _w: &mut dyn Write) -> std::io::Result<()> {
+        Ok(())
+    }
+
+    fn begin_signal_masks(&mut self, _w: &mut dyn Write, _count: u32) -> std::io::Result<()> {
+        Ok(())
+    }
+
+    fn signal_mask(&mut self, _w: &mut dyn Write, mask: &SignalMaskSpec) -> std::io::Result<()> {
+        if let Some(api_details) = &mut self.data.api_details {
+            api_details.signal_masks.push(mask.clone());
+        }
+        Ok(())
+    }
+
+    fn end_signal_masks(&mut self, _w: &mut dyn Write) -> std::io::Result<()> {
+        Ok(())
+    }
+
+    fn begin_side_effects(&mut self, _w: &mut dyn Write, _count: u32) -> std::io::Result<()> {
+        Ok(())
+    }
+
+    fn side_effect(&mut self, _w: &mut dyn Write, effect: &SideEffectSpec) -> std::io::Result<()> {
+        if let Some(details) = &mut self.data.api_details {
+            details.side_effects.push(effect.clone());
+        }
+        Ok(())
+    }
+
+    fn end_side_effects(&mut self, _w: &mut dyn Write) -> std::io::Result<()> {
+        Ok(())
+    }
+
+    fn begin_state_transitions(&mut self, _w: &mut dyn Write, _count: u32) -> std::io::Result<()> {
+        Ok(())
+    }
+
+    fn state_transition(
+        &mut self,
+        _w: &mut dyn Write,
+        trans: &StateTransitionSpec,
+    ) -> std::io::Result<()> {
+        if let Some(details) = &mut self.data.api_details {
+            details.state_transitions.push(trans.clone());
+        }
+        Ok(())
+    }
+
+    fn end_state_transitions(&mut self, _w: &mut dyn Write) -> std::io::Result<()> {
+        Ok(())
+    }
+
+    fn begin_constraints(&mut self, _w: &mut dyn Write, _count: u32) -> std::io::Result<()> {
+        Ok(())
+    }
+
+    fn constraint(
+        &mut self,
+        _w: &mut dyn Write,
+        constraint: &ConstraintSpec,
+    ) -> std::io::Result<()> {
+        if let Some(api_details) = &mut self.data.api_details {
+            api_details.constraints.push(constraint.clone());
+        }
+        Ok(())
+    }
+
+    fn end_constraints(&mut self, _w: &mut dyn Write) -> std::io::Result<()> {
+        Ok(())
+    }
+
+    fn begin_locks(&mut self, _w: &mut dyn Write, _count: u32) -> std::io::Result<()> {
+        Ok(())
+    }
+
+    fn lock(&mut self, _w: &mut dyn Write, lock: &LockSpec) -> std::io::Result<()> {
+        if let Some(details) = &mut self.data.api_details {
+            details.locks.push(lock.clone());
+        }
+        Ok(())
+    }
+
+    fn end_locks(&mut self, _w: &mut dyn Write) -> std::io::Result<()> {
+        Ok(())
+    }
+
+    fn begin_struct_specs(&mut self, _w: &mut dyn Write, _count: u32) -> std::io::Result<()> {
+        Ok(())
+    }
+
+    fn struct_spec(&mut self, _w: &mut dyn Write, spec: &StructSpec) -> std::io::Result<()> {
+        if let Some(ref mut details) = self.data.api_details {
+            details.struct_specs.push(spec.clone());
+        }
+        Ok(())
+    }
+
+    fn end_struct_specs(&mut self, _w: &mut dyn Write) -> std::io::Result<()> {
+        Ok(())
+    }
+}
+
+#[cfg(test)]
+mod tests {
+    use super::*;
+    use crate::extractor::{ErrorSpec, ParamSpec, ReturnSpec};
+
+    fn render_json(f: &mut JsonFormatter) -> String {
+        let mut buf = Vec::new();
+        f.end_document(&mut buf).unwrap();
+        String::from_utf8(buf).unwrap()
+    }
+
+    #[test]
+    fn json_output_is_valid() {
+        let mut f = JsonFormatter::new();
+        let mut sink = Vec::new();
+
+        f.begin_document(&mut sink).unwrap();
+        f.begin_api_details(&mut sink, "sys_test").unwrap();
+        f.description(&mut sink, "A test syscall").unwrap();
+        f.end_api_details(&mut sink).unwrap();
+
+        let json = render_json(&mut f);
+
+        // Verify it parses as valid JSON
+        let parsed: serde_json::Value = serde_json::from_str(&json).unwrap();
+        assert_eq!(parsed["api_details"]["name"].as_str(), Some("sys_test"));
+        assert_eq!(
+            parsed["api_details"]["description"].as_str(),
+            Some("A test syscall")
+        );
+    }
+
+    #[test]
+    fn json_api_list() {
+        let mut f = JsonFormatter::new();
+        let mut sink = Vec::new();
+
+        f.begin_document(&mut sink).unwrap();
+        f.begin_api_list(&mut sink, "Syscalls").unwrap();
+        f.api_item(&mut sink, "sys_open", "syscall").unwrap();
+        f.api_item(&mut sink, "sys_read", "syscall").unwrap();
+        f.end_api_list(&mut sink).unwrap();
+
+        let json = render_json(&mut f);
+        let parsed: serde_json::Value = serde_json::from_str(&json).unwrap();
+
+        let apis = parsed["apis"].as_array().unwrap();
+        assert_eq!(apis.len(), 2);
+        assert_eq!(apis[0]["name"].as_str(), Some("sys_open"));
+        assert_eq!(apis[0]["api_type"].as_str(), Some("syscall"));
+        assert_eq!(apis[1]["name"].as_str(), Some("sys_read"));
+    }
+
+    #[test]
+    fn json_special_characters_in_description() {
+        let mut f = JsonFormatter::new();
+        let mut sink = Vec::new();
+
+        f.begin_document(&mut sink).unwrap();
+        f.begin_api_details(&mut sink, "sys_test").unwrap();
+        f.description(&mut sink, "Contains \"quotes\" and \\backslashes\\")
+            .unwrap();
+        f.end_api_details(&mut sink).unwrap();
+
+        let json = render_json(&mut f);
+
+        // Must be valid JSON despite special characters
+        let parsed: serde_json::Value = serde_json::from_str(&json).unwrap();
+        assert_eq!(
+            parsed["api_details"]["description"].as_str(),
+            Some("Contains \"quotes\" and \\backslashes\\")
+        );
+    }
+
+    #[test]
+    fn json_special_characters_in_name() {
+        let mut f = JsonFormatter::new();
+        let mut sink = Vec::new();
+
+        f.begin_document(&mut sink).unwrap();
+        f.begin_api_list(&mut sink, "APIs").unwrap();
+        // Names with underscores (common in kernel) and unusual strings
+        f.api_item(&mut sink, "sys_new\tline", "syscall").unwrap();
+        f.end_api_list(&mut sink).unwrap();
+
+        let json = render_json(&mut f);
+
+        // Must parse correctly; serde_json handles escaping for us
+        let parsed: serde_json::Value = serde_json::from_str(&json).unwrap();
+        assert_eq!(parsed["apis"][0]["name"].as_str(), Some("sys_new\tline"));
+    }
+
+    #[test]
+    fn json_parameters_serialized() {
+        let mut f = JsonFormatter::new();
+        let mut sink = Vec::new();
+
+        f.begin_document(&mut sink).unwrap();
+        f.begin_api_details(&mut sink, "sys_write").unwrap();
+        f.begin_parameters(&mut sink, 2).unwrap();
+        f.parameter(
+            &mut sink,
+            &ParamSpec {
+                index: 0,
+                name: "fd".to_string(),
+                type_name: "unsigned int".to_string(),
+                description: "file descriptor".to_string(),
+                flags: 1,
+                param_type: 2,
+                constraint_type: 0,
+                constraint: None,
+                min_value: Some(0),
+                max_value: Some(1024),
+                valid_mask: None,
+                enum_values: vec![],
+                size: None,
+                alignment: None,
+                size_param_idx: None,
+            },
+        )
+        .unwrap();
+        f.end_parameters(&mut sink).unwrap();
+        f.end_api_details(&mut sink).unwrap();
+
+        let json = render_json(&mut f);
+        let parsed: serde_json::Value = serde_json::from_str(&json).unwrap();
+
+        let params = parsed["api_details"]["parameters"].as_array().unwrap();
+        assert_eq!(params.len(), 1);
+        assert_eq!(params[0]["name"].as_str(), Some("fd"));
+        assert_eq!(params[0]["param_type"].as_u64(), Some(2));
+    }
+
+    #[test]
+    fn json_errors_serialized() {
+        let mut f = JsonFormatter::new();
+        let mut sink = Vec::new();
+
+        f.begin_document(&mut sink).unwrap();
+        f.begin_api_details(&mut sink, "sys_read").unwrap();
+        f.begin_errors(&mut sink, 1).unwrap();
+        f.error(
+            &mut sink,
+            &ErrorSpec {
+                error_code: -9,
+                name: "EBADF".to_string(),
+                condition: "fd is not valid".to_string(),
+                description: "Bad file descriptor".to_string(),
+            },
+        )
+        .unwrap();
+        f.end_errors(&mut sink).unwrap();
+        f.end_api_details(&mut sink).unwrap();
+
+        let json = render_json(&mut f);
+        let parsed: serde_json::Value = serde_json::from_str(&json).unwrap();
+
+        let errors = parsed["api_details"]["errors"].as_array().unwrap();
+        assert_eq!(errors.len(), 1);
+        assert_eq!(errors[0]["name"].as_str(), Some("EBADF"));
+        assert_eq!(errors[0]["error_code"].as_i64(), Some(-9));
+    }
+
+    #[test]
+    fn json_empty_details_omits_empty_fields() {
+        let mut f = JsonFormatter::new();
+        let mut sink = Vec::new();
+
+        f.begin_document(&mut sink).unwrap();
+        f.begin_api_details(&mut sink, "sys_empty").unwrap();
+        f.end_api_details(&mut sink).unwrap();
+
+        let json = render_json(&mut f);
+        let parsed: serde_json::Value = serde_json::from_str(&json).unwrap();
+
+        // description should not be present (skip_serializing_if = Option::is_none)
+        assert!(parsed["api_details"]["description"].is_null());
+        // parameters empty array should not be present (skip_serializing_if = Vec::is_empty)
+        assert!(parsed["api_details"]["parameters"].is_null());
+        // errors empty array should not be present
+        assert!(parsed["api_details"]["errors"].is_null());
+    }
+
+    #[test]
+    fn json_braces_balance() {
+        let mut f = JsonFormatter::new();
+        let mut sink = Vec::new();
+
+        f.begin_document(&mut sink).unwrap();
+        f.begin_api_details(&mut sink, "sys_balanced").unwrap();
+        f.description(&mut sink, "Test braces balance").unwrap();
+        f.end_api_details(&mut sink).unwrap();
+
+        let json = render_json(&mut f);
+
+        let open_braces = json.chars().filter(|&c| c == '{').count();
+        let close_braces = json.chars().filter(|&c| c == '}').count();
+        assert_eq!(open_braces, close_braces, "Braces are unbalanced");
+
+        let open_brackets = json.chars().filter(|&c| c == '[').count();
+        let close_brackets = json.chars().filter(|&c| c == ']').count();
+        assert_eq!(open_brackets, close_brackets, "Brackets are unbalanced");
+    }
+
+    #[test]
+    fn json_return_spec_serialized() {
+        let mut f = JsonFormatter::new();
+        let mut sink = Vec::new();
+
+        f.begin_document(&mut sink).unwrap();
+        f.begin_api_details(&mut sink, "sys_open").unwrap();
+        f.return_spec(
+            &mut sink,
+            &ReturnSpec {
+                type_name: "int".to_string(),
+                description: "file descriptor on success".to_string(),
+                return_type: 1,
+                check_type: 3,
+                success_value: Some(0),
+                success_min: None,
+                success_max: None,
+                error_values: vec![-1],
+            },
+        )
+        .unwrap();
+        f.end_api_details(&mut sink).unwrap();
+
+        let json = render_json(&mut f);
+        let parsed: serde_json::Value = serde_json::from_str(&json).unwrap();
+
+        let ret = &parsed["api_details"]["return_spec"];
+        assert_eq!(ret["type_name"].as_str(), Some("int"));
+        assert_eq!(ret["check_type"].as_u64(), Some(3));
+    }
+
+    #[test]
+    fn json_unicode_in_description() {
+        let mut f = JsonFormatter::new();
+        let mut sink = Vec::new();
+
+        f.begin_document(&mut sink).unwrap();
+        f.begin_api_details(&mut sink, "sys_uni").unwrap();
+        f.description(&mut sink, "Supports unicode: \u{00e9}\u{00e8}\u{00ea}")
+            .unwrap();
+        f.end_api_details(&mut sink).unwrap();
+
+        let json = render_json(&mut f);
+        let parsed: serde_json::Value = serde_json::from_str(&json).unwrap();
+        assert!(parsed["api_details"]["description"]
+            .as_str()
+            .unwrap()
+            .contains('\u{00e9}'));
+    }
+
+    #[test]
+    fn json_escapes_embedded_newlines() {
+        let mut f = JsonFormatter::new();
+        let mut sink = Vec::new();
+
+        f.begin_document(&mut sink).unwrap();
+        f.begin_api_details(&mut sink, "sys_test").unwrap();
+        f.long_description(&mut sink, "One.\n\n- a\n- b").unwrap();
+        f.examples(&mut sink, "a();\nb();").unwrap();
+        f.notes(&mut sink, "Note one.\n\nNote two.").unwrap();
+        f.end_api_details(&mut sink).unwrap();
+
+        let json = render_json(&mut f);
+        assert!(json.contains(r#""examples": "a();\nb();""#));
+        let parsed: serde_json::Value = serde_json::from_str(&json).unwrap();
+        assert_eq!(
+            parsed["api_details"]["long_description"].as_str(),
+            Some("One.\n\n- a\n- b")
+        );
+        assert_eq!(
+            parsed["api_details"]["notes"].as_str(),
+            Some("Note one.\n\nNote two.")
+        );
+    }
+}
diff --git a/tools/kapi/src/formatter/mod.rs b/tools/kapi/src/formatter/mod.rs
new file mode 100644
index 0000000000000..8d375cb310b0b
--- /dev/null
+++ b/tools/kapi/src/formatter/mod.rs
@@ -0,0 +1,220 @@
+// SPDX-License-Identifier: GPL-2.0
+// Copyright (C) 2026 Sasha Levin <sashal@kernel.org>
+
+use crate::extractor::{
+    CapabilitySpec, ConstraintSpec, ErrorSpec, LockSpec, ParamSpec, ReturnSpec, SideEffectSpec,
+    SignalMaskSpec, SignalSpec, StateTransitionSpec, StructSpec,
+};
+use std::io::Write;
+
+mod json;
+mod plain;
+mod rst;
+
+pub use json::JsonFormatter;
+pub use plain::PlainFormatter;
+pub use rst::RstFormatter;
+
+#[derive(Debug, Clone, Copy, PartialEq)]
+pub enum OutputFormat {
+    Plain,
+    Json,
+    Rst,
+}
+
+impl std::str::FromStr for OutputFormat {
+    type Err = String;
+
+    fn from_str(s: &str) -> Result<Self, Self::Err> {
+        match s.to_lowercase().as_str() {
+            "plain" => Ok(OutputFormat::Plain),
+            "json" => Ok(OutputFormat::Json),
+            "rst" => Ok(OutputFormat::Rst),
+            _ => Err(format!("Unknown output format: {}", s)),
+        }
+    }
+}
+
+/// Names of the KAPI_PARAM_* flags set in `flags`.
+fn param_flag_names(flags: u32) -> Vec<&'static str> {
+    const IN: u32 = 1 << 0;
+    const OUT: u32 = 1 << 1;
+    const OTHER: [(u32, &str); 6] = [
+        (1 << 3, "OPTIONAL"),
+        (1 << 4, "CONST"),
+        (1 << 5, "VOLATILE"),
+        (1 << 6, "USER"),
+        (1 << 7, "DMA"),
+        (1 << 8, "ALIGNED"),
+    ];
+
+    let mut names = Vec::new();
+    if flags & (IN | OUT) == IN | OUT {
+        names.push("INOUT");
+    } else if flags & IN != 0 {
+        names.push("IN");
+    } else if flags & OUT != 0 {
+        names.push("OUT");
+    }
+    names.extend(
+        OTHER
+            .iter()
+            .filter(|(bit, _)| flags & bit != 0)
+            .map(|(_, name)| *name),
+    );
+    names
+}
+
+/// Text for a parameter's bounds; either end may be unset.
+fn range_text(min: Option<i64>, max: Option<i64>) -> Option<String> {
+    match (min, max) {
+        (Some(min), Some(max)) => Some(format!("{min} to {max}")),
+        (Some(min), None) => Some(format!(">= {min}")),
+        (None, Some(max)) => Some(format!("<= {max}")),
+        (None, None) => None,
+    }
+}
+
+/// Write `text` line by line, indenting every non-blank line by `indent`.
+fn write_indented(w: &mut dyn Write, indent: &str, text: &str) -> std::io::Result<()> {
+    for line in text.lines() {
+        if line.is_empty() {
+            writeln!(w)?;
+        } else {
+            writeln!(w, "{indent}{line}")?;
+        }
+    }
+    Ok(())
+}
+
+/// Prepare text with embedded newlines for reStructuredText. Wrapped
+/// prose stays in its paragraph, but a bullet list needs a blank line
+/// before its first item and after its last one to be recognised.
+fn rst_text(text: &str) -> String {
+    let mut out: Vec<&str> = Vec::new();
+    let mut prev_bullet = false;
+    for line in text.lines() {
+        let bullet = line.starts_with("- ");
+        if !line.is_empty() && bullet != prev_bullet && out.last().is_some_and(|l| !l.is_empty()) {
+            out.push("");
+        }
+        out.push(line);
+        if !line.is_empty() {
+            prev_bullet = bullet;
+        }
+    }
+    out.join("\n")
+}
+
+pub trait OutputFormatter {
+    fn begin_document(&mut self, w: &mut dyn Write) -> std::io::Result<()>;
+    fn end_document(&mut self, w: &mut dyn Write) -> std::io::Result<()>;
+
+    fn begin_api_list(&mut self, w: &mut dyn Write, title: &str) -> std::io::Result<()>;
+    fn api_item(&mut self, w: &mut dyn Write, name: &str, api_type: &str) -> std::io::Result<()>;
+    fn end_api_list(&mut self, w: &mut dyn Write) -> std::io::Result<()>;
+
+    fn total_specs(&mut self, w: &mut dyn Write, count: usize) -> std::io::Result<()>;
+
+    fn begin_api_details(&mut self, w: &mut dyn Write, name: &str) -> std::io::Result<()>;
+    fn end_api_details(&mut self, w: &mut dyn Write) -> std::io::Result<()>;
+    fn description(&mut self, w: &mut dyn Write, desc: &str) -> std::io::Result<()>;
+    fn long_description(&mut self, w: &mut dyn Write, desc: &str) -> std::io::Result<()>;
+
+    fn begin_context_flags(&mut self, w: &mut dyn Write) -> std::io::Result<()>;
+    fn context_flag(&mut self, w: &mut dyn Write, flag: &str) -> std::io::Result<()>;
+    fn end_context_flags(&mut self, w: &mut dyn Write) -> std::io::Result<()>;
+
+    fn begin_parameters(&mut self, w: &mut dyn Write, count: u32) -> std::io::Result<()>;
+    fn parameter(&mut self, w: &mut dyn Write, param: &ParamSpec) -> std::io::Result<()>;
+    fn end_parameters(&mut self, w: &mut dyn Write) -> std::io::Result<()>;
+
+    fn return_spec(&mut self, w: &mut dyn Write, ret: &ReturnSpec) -> std::io::Result<()>;
+
+    fn begin_errors(&mut self, w: &mut dyn Write, count: u32) -> std::io::Result<()>;
+    fn error(&mut self, w: &mut dyn Write, error: &ErrorSpec) -> std::io::Result<()>;
+    fn end_errors(&mut self, w: &mut dyn Write) -> std::io::Result<()>;
+
+    fn examples(&mut self, w: &mut dyn Write, examples: &str) -> std::io::Result<()>;
+    fn notes(&mut self, w: &mut dyn Write, notes: &str) -> std::io::Result<()>;
+
+    // Sysfs-specific methods
+    fn sysfs_subsystem(&mut self, w: &mut dyn Write, subsystem: &str) -> std::io::Result<()>;
+    fn sysfs_path(&mut self, w: &mut dyn Write, path: &str) -> std::io::Result<()>;
+    fn sysfs_permissions(&mut self, w: &mut dyn Write, perms: &str) -> std::io::Result<()>;
+
+    fn begin_capabilities(&mut self, w: &mut dyn Write) -> std::io::Result<()>;
+    fn capability(&mut self, w: &mut dyn Write, cap: &CapabilitySpec) -> std::io::Result<()>;
+    fn end_capabilities(&mut self, w: &mut dyn Write) -> std::io::Result<()>;
+
+    // Signal-related methods
+    fn begin_signals(&mut self, w: &mut dyn Write, count: u32) -> std::io::Result<()>;
+    fn signal(&mut self, w: &mut dyn Write, signal: &SignalSpec) -> std::io::Result<()>;
+    fn end_signals(&mut self, w: &mut dyn Write) -> std::io::Result<()>;
+
+    fn begin_signal_masks(&mut self, w: &mut dyn Write, count: u32) -> std::io::Result<()>;
+    fn signal_mask(&mut self, w: &mut dyn Write, mask: &SignalMaskSpec) -> std::io::Result<()>;
+    fn end_signal_masks(&mut self, w: &mut dyn Write) -> std::io::Result<()>;
+
+    // Side effects and state transitions
+    fn begin_side_effects(&mut self, w: &mut dyn Write, count: u32) -> std::io::Result<()>;
+    fn side_effect(&mut self, w: &mut dyn Write, effect: &SideEffectSpec) -> std::io::Result<()>;
+    fn end_side_effects(&mut self, w: &mut dyn Write) -> std::io::Result<()>;
+
+    fn begin_state_transitions(&mut self, w: &mut dyn Write, count: u32) -> std::io::Result<()>;
+    fn state_transition(
+        &mut self,
+        w: &mut dyn Write,
+        trans: &StateTransitionSpec,
+    ) -> std::io::Result<()>;
+    fn end_state_transitions(&mut self, w: &mut dyn Write) -> std::io::Result<()>;
+
+    // Constraints and locks
+    fn begin_constraints(&mut self, w: &mut dyn Write, count: u32) -> std::io::Result<()>;
+    fn constraint(&mut self, w: &mut dyn Write, constraint: &ConstraintSpec)
+        -> std::io::Result<()>;
+    fn end_constraints(&mut self, w: &mut dyn Write) -> std::io::Result<()>;
+
+    fn begin_locks(&mut self, w: &mut dyn Write, count: u32) -> std::io::Result<()>;
+    fn lock(&mut self, w: &mut dyn Write, lock: &LockSpec) -> std::io::Result<()>;
+    fn end_locks(&mut self, w: &mut dyn Write) -> std::io::Result<()>;
+
+    fn begin_struct_specs(&mut self, w: &mut dyn Write, count: u32) -> std::io::Result<()>;
+    fn struct_spec(&mut self, w: &mut dyn Write, spec: &StructSpec) -> std::io::Result<()>;
+    fn end_struct_specs(&mut self, w: &mut dyn Write) -> std::io::Result<()>;
+}
+
+pub fn create_formatter(format: OutputFormat) -> Box<dyn OutputFormatter> {
+    match format {
+        OutputFormat::Plain => Box::new(PlainFormatter::new()),
+        OutputFormat::Json => Box::new(JsonFormatter::new()),
+        OutputFormat::Rst => Box::new(RstFormatter::new()),
+    }
+}
+
+#[cfg(test)]
+mod tests {
+    use super::*;
+
+    #[test]
+    fn param_flags_use_the_header_bit_values() {
+        assert!(param_flag_names(0).is_empty());
+        assert_eq!(param_flag_names(0x1), ["IN"]);
+        assert_eq!(param_flag_names(0x2), ["OUT"]);
+        assert_eq!(param_flag_names(0x3), ["INOUT"]);
+        assert_eq!(param_flag_names(0x42), ["OUT", "USER"]);
+        assert_eq!(param_flag_names(0x9), ["IN", "OPTIONAL"]);
+        assert_eq!(
+            param_flag_names(0x1f8),
+            ["OPTIONAL", "CONST", "VOLATILE", "USER", "DMA", "ALIGNED"]
+        );
+    }
+
+    #[test]
+    fn range_text_shows_one_sided_bounds() {
+        assert_eq!(range_text(Some(0), Some(9)).as_deref(), Some("0 to 9"));
+        assert_eq!(range_text(Some(1), None).as_deref(), Some(">= 1"));
+        assert_eq!(range_text(None, Some(255)).as_deref(), Some("<= 255"));
+        assert_eq!(range_text(None, None), None);
+    }
+}
diff --git a/tools/kapi/src/formatter/plain.rs b/tools/kapi/src/formatter/plain.rs
new file mode 100644
index 0000000000000..0aa03ab8573b6
--- /dev/null
+++ b/tools/kapi/src/formatter/plain.rs
@@ -0,0 +1,679 @@
+// SPDX-License-Identifier: GPL-2.0
+// Copyright (C) 2026 Sasha Levin <sashal@kernel.org>
+
+use super::OutputFormatter;
+use crate::extractor::{
+    CapabilitySpec, ConstraintSpec, ErrorSpec, LockSpec, ParamSpec, ReturnSpec, SideEffectSpec,
+    SignalMaskSpec, SignalSpec, StateTransitionSpec,
+};
+use std::io::Write;
+
+pub struct PlainFormatter;
+
+impl PlainFormatter {
+    pub fn new() -> Self {
+        PlainFormatter
+    }
+}
+
+impl OutputFormatter for PlainFormatter {
+    fn begin_document(&mut self, _w: &mut dyn Write) -> std::io::Result<()> {
+        Ok(())
+    }
+
+    fn end_document(&mut self, _w: &mut dyn Write) -> std::io::Result<()> {
+        Ok(())
+    }
+
+    fn begin_api_list(&mut self, w: &mut dyn Write, title: &str) -> std::io::Result<()> {
+        writeln!(w, "\n{title}:")?;
+        writeln!(w, "{}", "-".repeat(title.len() + 1))
+    }
+
+    fn api_item(&mut self, w: &mut dyn Write, name: &str, _api_type: &str) -> std::io::Result<()> {
+        writeln!(w, "  {name}")
+    }
+
+    fn end_api_list(&mut self, _w: &mut dyn Write) -> std::io::Result<()> {
+        Ok(())
+    }
+
+    fn total_specs(&mut self, w: &mut dyn Write, count: usize) -> std::io::Result<()> {
+        writeln!(w, "\nTotal specifications found: {count}")
+    }
+
+    fn begin_api_details(&mut self, w: &mut dyn Write, name: &str) -> std::io::Result<()> {
+        writeln!(w, "\nDetailed information for {name}:")?;
+        writeln!(w, "{}=", "=".repeat(25 + name.len()))
+    }
+
+    fn end_api_details(&mut self, _w: &mut dyn Write) -> std::io::Result<()> {
+        Ok(())
+    }
+
+    fn description(&mut self, w: &mut dyn Write, desc: &str) -> std::io::Result<()> {
+        writeln!(w, "Description: {desc}")
+    }
+
+    fn long_description(&mut self, w: &mut dyn Write, desc: &str) -> std::io::Result<()> {
+        writeln!(w, "\nDetailed Description:")?;
+        super::write_indented(w, "  ", desc)
+    }
+
+    fn begin_context_flags(&mut self, w: &mut dyn Write) -> std::io::Result<()> {
+        writeln!(w, "\nExecution Context:")
+    }
+
+    fn context_flag(&mut self, w: &mut dyn Write, flag: &str) -> std::io::Result<()> {
+        writeln!(w, "  - {flag}")
+    }
+
+    fn end_context_flags(&mut self, _w: &mut dyn Write) -> std::io::Result<()> {
+        Ok(())
+    }
+
+    fn begin_parameters(&mut self, w: &mut dyn Write, count: u32) -> std::io::Result<()> {
+        writeln!(w, "\nParameters ({count}):")
+    }
+
+    fn parameter(&mut self, w: &mut dyn Write, param: &ParamSpec) -> std::io::Result<()> {
+        writeln!(
+            w,
+            "  [{}] {} ({})",
+            param.index, param.name, param.type_name
+        )?;
+        if !param.description.is_empty() {
+            writeln!(w, "      {}", param.description)?;
+        }
+
+        // Display flags
+        let flags = super::param_flag_names(param.flags);
+        if !flags.is_empty() {
+            writeln!(w, "      Flags: {}", flags.join(" | "))?;
+        }
+
+        // Display constraints
+        if let Some(constraint) = &param.constraint {
+            writeln!(w, "      Constraint: {constraint}")?;
+        }
+        if let Some(range) = super::range_text(param.min_value, param.max_value) {
+            writeln!(w, "      Range: {range}")?;
+        }
+        if let Some(mask) = param.valid_mask {
+            writeln!(w, "      Valid mask: 0x{mask:x}")?;
+        }
+        Ok(())
+    }
+
+    fn end_parameters(&mut self, _w: &mut dyn Write) -> std::io::Result<()> {
+        Ok(())
+    }
+
+    fn return_spec(&mut self, w: &mut dyn Write, ret: &ReturnSpec) -> std::io::Result<()> {
+        writeln!(w, "\nReturn Value:")?;
+        writeln!(w, "  Type: {}", ret.type_name)?;
+        writeln!(w, "  {}", ret.description)?;
+        if let Some(val) = ret.success_value {
+            writeln!(w, "  Success value: {val}")?;
+        }
+        if let (Some(min), Some(max)) = (ret.success_min, ret.success_max) {
+            writeln!(w, "  Success range: {min} to {max}")?;
+        }
+        Ok(())
+    }
+
+    fn begin_errors(&mut self, w: &mut dyn Write, count: u32) -> std::io::Result<()> {
+        writeln!(w, "\nPossible Errors ({count}):")
+    }
+
+    fn error(&mut self, w: &mut dyn Write, error: &ErrorSpec) -> std::io::Result<()> {
+        writeln!(w, "  {} ({})", error.name, error.error_code)?;
+        if !error.condition.is_empty() {
+            writeln!(w, "      Condition: {}", error.condition)?;
+        }
+        if !error.description.is_empty() {
+            writeln!(w, "      {}", error.description)?;
+        }
+        Ok(())
+    }
+
+    fn end_errors(&mut self, _w: &mut dyn Write) -> std::io::Result<()> {
+        Ok(())
+    }
+
+    fn examples(&mut self, w: &mut dyn Write, examples: &str) -> std::io::Result<()> {
+        writeln!(w, "\nExamples:")?;
+        super::write_indented(w, "  ", examples)
+    }
+
+    fn notes(&mut self, w: &mut dyn Write, notes: &str) -> std::io::Result<()> {
+        writeln!(w, "\nNotes:")?;
+        super::write_indented(w, "  ", notes)
+    }
+
+    fn sysfs_subsystem(&mut self, w: &mut dyn Write, subsystem: &str) -> std::io::Result<()> {
+        writeln!(w, "Subsystem: {subsystem}")
+    }
+
+    fn sysfs_path(&mut self, w: &mut dyn Write, path: &str) -> std::io::Result<()> {
+        writeln!(w, "Sysfs Path: {path}")
+    }
+
+    fn sysfs_permissions(&mut self, w: &mut dyn Write, perms: &str) -> std::io::Result<()> {
+        writeln!(w, "Permissions: {perms}")
+    }
+
+    fn begin_capabilities(&mut self, w: &mut dyn Write) -> std::io::Result<()> {
+        writeln!(w, "\nRequired Capabilities:")
+    }
+
+    fn capability(&mut self, w: &mut dyn Write, cap: &CapabilitySpec) -> std::io::Result<()> {
+        writeln!(w, "  {} ({}) - {}", cap.name, cap.capability, cap.action)?;
+        if !cap.allows.is_empty() {
+            writeln!(w, "    Allows: {}", cap.allows)?;
+        }
+        if !cap.without_cap.is_empty() {
+            writeln!(w, "    Without capability: {}", cap.without_cap)?;
+        }
+        if let Some(cond) = &cap.check_condition {
+            writeln!(w, "    Condition: {cond}")?;
+        }
+        Ok(())
+    }
+
+    fn end_capabilities(&mut self, _w: &mut dyn Write) -> std::io::Result<()> {
+        Ok(())
+    }
+
+    // Signal-related methods
+    fn begin_signals(&mut self, w: &mut dyn Write, count: u32) -> std::io::Result<()> {
+        writeln!(w, "\nSignal Specifications ({count}):")
+    }
+
+    fn signal(&mut self, w: &mut dyn Write, signal: &SignalSpec) -> std::io::Result<()> {
+        write!(w, "  {} ({})", signal.signal_name, signal.signal_num)?;
+
+        // Display direction (bitmask matching C enum kapi_signal_direction)
+        let mut dirs = Vec::new();
+        if signal.direction & 1 != 0 {
+            dirs.push("RECEIVE");
+        }
+        if signal.direction & 2 != 0 {
+            dirs.push("SEND");
+        }
+        if signal.direction & 4 != 0 {
+            dirs.push("HANDLE");
+        }
+        if signal.direction & 8 != 0 {
+            dirs.push("BLOCK");
+        }
+        if signal.direction & 16 != 0 {
+            dirs.push("IGNORE");
+        }
+        let direction = if dirs.is_empty() {
+            "UNKNOWN".to_string()
+        } else {
+            dirs.join("|")
+        };
+        write!(w, " - {direction}")?;
+
+        // Display action (matching C enum kapi_signal_action)
+        let action = match signal.action {
+            0 => "DEFAULT",
+            1 => "TERMINATE",
+            2 => "COREDUMP",
+            3 => "STOP",
+            4 => "CONTINUE",
+            5 => "CUSTOM",
+            6 => "RETURN",
+            7 => "RESTART",
+            8 => "QUEUE",
+            9 => "DISCARD",
+            10 => "TRANSFORM",
+            _ => "UNKNOWN",
+        };
+        writeln!(w, " - {action}")?;
+
+        if let Some(target) = &signal.target {
+            writeln!(w, "      Target: {target}")?;
+        }
+        if let Some(condition) = &signal.condition {
+            writeln!(w, "      Condition: {condition}")?;
+        }
+        if let Some(desc) = &signal.description {
+            writeln!(w, "      {desc}")?;
+        }
+
+        // Display timing
+        let timing = match signal.timing {
+            0 => "BEFORE",
+            1 => "DURING",
+            2 => "AFTER",
+            3 => "EXIT",
+            _ => "UNKNOWN",
+        };
+        writeln!(w, "      Timing: {timing}")?;
+        writeln!(w, "      Priority: {}", signal.priority)?;
+
+        if signal.restartable {
+            writeln!(w, "      Restartable: yes")?;
+        }
+        if signal.interruptible {
+            writeln!(w, "      Interruptible: yes")?;
+        }
+        if let Some(queue) = &signal.queue {
+            writeln!(w, "      Queue: {queue}")?;
+        }
+        if signal.sa_flags_required != 0 {
+            writeln!(
+                w,
+                "      SA flags required: {:#x}",
+                signal.sa_flags_required
+            )?;
+        }
+        if signal.sa_flags_forbidden != 0 {
+            writeln!(
+                w,
+                "      SA flags forbidden: {:#x}",
+                signal.sa_flags_forbidden
+            )?;
+        }
+        if signal.state_required != 0 {
+            writeln!(w, "      State required: {:#x}", signal.state_required)?;
+        }
+        if signal.state_forbidden != 0 {
+            writeln!(w, "      State forbidden: {:#x}", signal.state_forbidden)?;
+        }
+        if let Some(error) = signal.error_on_signal {
+            writeln!(w, "      Error on signal: {error}")?;
+        }
+        if let Some(transform) = signal.transform_to {
+            writeln!(w, "      Transform to: {transform}")?;
+        }
+        Ok(())
+    }
+
+    fn end_signals(&mut self, _w: &mut dyn Write) -> std::io::Result<()> {
+        Ok(())
+    }
+
+    fn begin_signal_masks(&mut self, w: &mut dyn Write, count: u32) -> std::io::Result<()> {
+        writeln!(w, "\nSignal Masks ({count}):")
+    }
+
+    fn signal_mask(&mut self, w: &mut dyn Write, mask: &SignalMaskSpec) -> std::io::Result<()> {
+        writeln!(w, "  {}", mask.name)?;
+        if !mask.description.is_empty() {
+            writeln!(w, "      {}", mask.description)?;
+        }
+        if !mask.signals.is_empty() {
+            let signals: Vec<String> = mask.signals.iter().map(i32::to_string).collect();
+            writeln!(w, "      Signals: {}", signals.join(", "))?;
+        }
+        Ok(())
+    }
+
+    fn end_signal_masks(&mut self, _w: &mut dyn Write) -> std::io::Result<()> {
+        Ok(())
+    }
+
+    // Side effects and state transitions
+    fn begin_side_effects(&mut self, w: &mut dyn Write, count: u32) -> std::io::Result<()> {
+        writeln!(w, "\nSide Effects ({count}):")
+    }
+
+    fn side_effect(&mut self, w: &mut dyn Write, effect: &SideEffectSpec) -> std::io::Result<()> {
+        writeln!(w, "  {} - {}", effect.target, effect.description)?;
+        if let Some(condition) = &effect.condition {
+            writeln!(w, "      Condition: {condition}")?;
+        }
+        if effect.reversible {
+            writeln!(w, "      Reversible: yes")?;
+        }
+        Ok(())
+    }
+
+    fn end_side_effects(&mut self, _w: &mut dyn Write) -> std::io::Result<()> {
+        Ok(())
+    }
+
+    fn begin_state_transitions(&mut self, w: &mut dyn Write, count: u32) -> std::io::Result<()> {
+        writeln!(w, "\nState Transitions ({count}):")
+    }
+
+    fn state_transition(
+        &mut self,
+        w: &mut dyn Write,
+        trans: &StateTransitionSpec,
+    ) -> std::io::Result<()> {
+        writeln!(
+            w,
+            "  {} : {} -> {}",
+            trans.object, trans.from_state, trans.to_state
+        )?;
+        if let Some(condition) = &trans.condition {
+            writeln!(w, "      Condition: {condition}")?;
+        }
+        if !trans.description.is_empty() {
+            writeln!(w, "      {}", trans.description)?;
+        }
+        Ok(())
+    }
+
+    fn end_state_transitions(&mut self, _w: &mut dyn Write) -> std::io::Result<()> {
+        Ok(())
+    }
+
+    // Constraints and locks
+    fn begin_constraints(&mut self, w: &mut dyn Write, count: u32) -> std::io::Result<()> {
+        writeln!(w, "\nAdditional Constraints ({count}):")
+    }
+
+    fn constraint(
+        &mut self,
+        w: &mut dyn Write,
+        constraint: &ConstraintSpec,
+    ) -> std::io::Result<()> {
+        writeln!(w, "  {}", constraint.name)?;
+        if !constraint.description.is_empty() {
+            writeln!(w, "      {}", constraint.description)?;
+        }
+        if let Some(expr) = &constraint.expression {
+            writeln!(w, "      Expression: {expr}")?;
+        }
+        Ok(())
+    }
+
+    fn end_constraints(&mut self, _w: &mut dyn Write) -> std::io::Result<()> {
+        Ok(())
+    }
+
+    fn begin_locks(&mut self, w: &mut dyn Write, count: u32) -> std::io::Result<()> {
+        writeln!(w, "\nLocking Requirements ({count}):")
+    }
+
+    fn lock(&mut self, w: &mut dyn Write, lock: &LockSpec) -> std::io::Result<()> {
+        write!(w, "  {}", lock.lock_name)?;
+
+        // Display lock type
+        let lock_type = match lock.lock_type {
+            0 => "NONE",
+            1 => "MUTEX",
+            2 => "SPINLOCK",
+            3 => "RWLOCK",
+            4 => "SEQLOCK",
+            5 => "RCU",
+            6 => "SEMAPHORE",
+            7 => "CUSTOM",
+            _ => "UNKNOWN",
+        };
+        writeln!(w, " ({lock_type})")?;
+
+        let scope_str = match lock.scope {
+            0 => "acquired and released",
+            1 => "acquired (not released)",
+            2 => "released (held on entry)",
+            3 => "held by caller",
+            _ => "unknown",
+        };
+        writeln!(w, "      Scope: {scope_str}")?;
+
+        if !lock.description.is_empty() {
+            writeln!(w, "      {}", lock.description)?;
+        }
+        Ok(())
+    }
+
+    fn end_locks(&mut self, _w: &mut dyn Write) -> std::io::Result<()> {
+        Ok(())
+    }
+
+    fn begin_struct_specs(&mut self, w: &mut dyn Write, count: u32) -> std::io::Result<()> {
+        writeln!(w, "\nStructure Specifications ({count}):")
+    }
+
+    fn struct_spec(
+        &mut self,
+        w: &mut dyn Write,
+        spec: &crate::extractor::StructSpec,
+    ) -> std::io::Result<()> {
+        writeln!(
+            w,
+            "  {} (size={}, align={}):",
+            spec.name, spec.size, spec.alignment
+        )?;
+        if !spec.description.is_empty() {
+            writeln!(w, "      {}", spec.description)?;
+        }
+
+        if !spec.fields.is_empty() {
+            writeln!(w, "      Fields ({}):", spec.field_count)?;
+            for field in &spec.fields {
+                write!(w, "        - {} ({}):", field.name, field.type_name)?;
+                if !field.description.is_empty() {
+                    write!(w, " {}", field.description)?;
+                }
+                writeln!(w)?;
+
+                // Show constraints if present
+                if field.min_value != 0 || field.max_value != 0 {
+                    writeln!(
+                        w,
+                        "          Range: [{}, {}]",
+                        field.min_value, field.max_value
+                    )?;
+                }
+                if field.valid_mask != 0 {
+                    writeln!(w, "          Mask: {:#x}", field.valid_mask)?;
+                }
+            }
+        }
+        Ok(())
+    }
+
+    fn end_struct_specs(&mut self, _w: &mut dyn Write) -> std::io::Result<()> {
+        Ok(())
+    }
+}
+
+#[cfg(test)]
+mod tests {
+    use super::*;
+    use crate::extractor::{ErrorSpec, ParamSpec, ReturnSpec};
+
+    fn render_plain(f: &mut PlainFormatter, sink: &mut Vec<u8>) -> String {
+        f.end_document(sink).unwrap();
+        String::from_utf8(sink.clone()).unwrap()
+    }
+
+    #[test]
+    fn plain_api_list() {
+        let mut f = PlainFormatter::new();
+        let mut sink = Vec::new();
+
+        f.begin_document(&mut sink).unwrap();
+        f.begin_api_list(&mut sink, "System Calls").unwrap();
+        f.api_item(&mut sink, "sys_open", "syscall").unwrap();
+        f.api_item(&mut sink, "sys_read", "syscall").unwrap();
+        f.end_api_list(&mut sink).unwrap();
+        f.total_specs(&mut sink, 2).unwrap();
+
+        let out = render_plain(&mut f, &mut sink);
+        assert!(out.contains("sys_open"));
+        assert!(out.contains("sys_read"));
+        assert!(out.contains("Total specifications found: 2"));
+    }
+
+    #[test]
+    fn plain_api_details() {
+        let mut f = PlainFormatter::new();
+        let mut sink = Vec::new();
+
+        f.begin_document(&mut sink).unwrap();
+        f.begin_api_details(&mut sink, "sys_test").unwrap();
+        f.description(&mut sink, "A test syscall").unwrap();
+        f.long_description(&mut sink, "Detailed description here")
+            .unwrap();
+        f.end_api_details(&mut sink).unwrap();
+
+        let out = render_plain(&mut f, &mut sink);
+        assert!(out.contains("sys_test"));
+        assert!(out.contains("A test syscall"));
+        assert!(out.contains("Detailed description here"));
+    }
+
+    #[test]
+    fn plain_parameters() {
+        let mut f = PlainFormatter::new();
+        let mut sink = Vec::new();
+
+        f.begin_document(&mut sink).unwrap();
+        f.begin_api_details(&mut sink, "sys_write").unwrap();
+        f.begin_parameters(&mut sink, 1).unwrap();
+        f.parameter(
+            &mut sink,
+            &ParamSpec {
+                index: 0,
+                name: "fd".to_string(),
+                type_name: "unsigned int".to_string(),
+                description: "file descriptor".to_string(),
+                flags: 1,
+                param_type: 2,
+                constraint_type: 0,
+                constraint: None,
+                min_value: None,
+                max_value: None,
+                valid_mask: None,
+                enum_values: vec![],
+                size: None,
+                alignment: None,
+                size_param_idx: None,
+            },
+        )
+        .unwrap();
+        f.end_parameters(&mut sink).unwrap();
+        f.end_api_details(&mut sink).unwrap();
+
+        let out = render_plain(&mut f, &mut sink);
+        assert!(out.contains("fd"));
+        assert!(out.contains("unsigned int"));
+        assert!(out.contains("file descriptor"));
+    }
+
+    #[test]
+    fn plain_errors() {
+        let mut f = PlainFormatter::new();
+        let mut sink = Vec::new();
+
+        f.begin_document(&mut sink).unwrap();
+        f.begin_api_details(&mut sink, "sys_test").unwrap();
+        f.begin_errors(&mut sink, 1).unwrap();
+        f.error(
+            &mut sink,
+            &ErrorSpec {
+                error_code: -2,
+                name: "ENOENT".to_string(),
+                condition: "File not found".to_string(),
+                description: "The file does not exist".to_string(),
+            },
+        )
+        .unwrap();
+        f.end_errors(&mut sink).unwrap();
+        f.end_api_details(&mut sink).unwrap();
+
+        let out = render_plain(&mut f, &mut sink);
+        assert!(out.contains("ENOENT"));
+        assert!(out.contains("-2"));
+        assert!(out.contains("File not found"));
+    }
+
+    #[test]
+    fn plain_return_spec() {
+        let mut f = PlainFormatter::new();
+        let mut sink = Vec::new();
+
+        f.begin_document(&mut sink).unwrap();
+        f.begin_api_details(&mut sink, "sys_test").unwrap();
+        f.return_spec(
+            &mut sink,
+            &ReturnSpec {
+                type_name: "KAPI_TYPE_INT".to_string(),
+                description: "Returns 0 on success".to_string(),
+                return_type: 1,
+                check_type: 0,
+                success_value: Some(0),
+                success_min: None,
+                success_max: None,
+                error_values: vec![],
+            },
+        )
+        .unwrap();
+        f.end_api_details(&mut sink).unwrap();
+
+        let out = render_plain(&mut f, &mut sink);
+        assert!(out.contains("KAPI_TYPE_INT"));
+        assert!(out.contains("Returns 0 on success"));
+    }
+
+    #[test]
+    fn plain_context_flags() {
+        let mut f = PlainFormatter::new();
+        let mut sink = Vec::new();
+
+        f.begin_document(&mut sink).unwrap();
+        f.begin_api_details(&mut sink, "sys_test").unwrap();
+        f.begin_context_flags(&mut sink).unwrap();
+        f.context_flag(&mut sink, "KAPI_CTX_PROCESS").unwrap();
+        f.context_flag(&mut sink, "KAPI_CTX_SLEEPABLE").unwrap();
+        f.end_context_flags(&mut sink).unwrap();
+        f.end_api_details(&mut sink).unwrap();
+
+        let out = render_plain(&mut f, &mut sink);
+        assert!(out.contains("KAPI_CTX_PROCESS"));
+        assert!(out.contains("KAPI_CTX_SLEEPABLE"));
+    }
+
+    #[test]
+    fn plain_signal_mask_lists_its_signals() {
+        let mut f = PlainFormatter::new();
+        let mut sink = Vec::new();
+
+        f.begin_document(&mut sink).unwrap();
+        f.begin_api_details(&mut sink, "sys_test").unwrap();
+        f.begin_signal_masks(&mut sink, 1).unwrap();
+        f.signal_mask(
+            &mut sink,
+            &SignalMaskSpec {
+                name: "blocked".to_string(),
+                description: "Blocked while running".to_string(),
+                signals: vec![2, 15],
+            },
+        )
+        .unwrap();
+        f.end_signal_masks(&mut sink).unwrap();
+        f.end_api_details(&mut sink).unwrap();
+
+        let out = render_plain(&mut f, &mut sink);
+        assert!(out.contains("  blocked\n      Blocked while running\n      Signals: 2, 15\n"));
+    }
+
+    #[test]
+    fn plain_multiline_blocks_are_indented() {
+        let mut f = PlainFormatter::new();
+        let mut sink = Vec::new();
+
+        f.begin_document(&mut sink).unwrap();
+        f.begin_api_details(&mut sink, "sys_test").unwrap();
+        f.long_description(&mut sink, "First paragraph.\n\n- item one\n- item two")
+            .unwrap();
+        f.examples(&mut sink, "a();\nif (x) {\n  b();\n}").unwrap();
+        f.notes(&mut sink, "Note one.\n\nNote two.").unwrap();
+        f.end_api_details(&mut sink).unwrap();
+
+        let out = render_plain(&mut f, &mut sink);
+        assert!(out
+            .contains("Detailed Description:\n  First paragraph.\n\n  - item one\n  - item two\n"));
+        assert!(out.contains("Examples:\n  a();\n  if (x) {\n    b();\n  }\n"));
+        assert!(out.contains("Notes:\n  Note one.\n\n  Note two.\n"));
+    }
+}
diff --git a/tools/kapi/src/formatter/rst.rs b/tools/kapi/src/formatter/rst.rs
new file mode 100644
index 0000000000000..c208d876c9777
--- /dev/null
+++ b/tools/kapi/src/formatter/rst.rs
@@ -0,0 +1,802 @@
+// SPDX-License-Identifier: GPL-2.0
+// Copyright (C) 2026 Sasha Levin <sashal@kernel.org>
+
+use super::OutputFormatter;
+use crate::extractor::{
+    CapabilitySpec, ConstraintSpec, ErrorSpec, LockSpec, ParamSpec, ReturnSpec, SideEffectSpec,
+    SignalMaskSpec, SignalSpec, StateTransitionSpec,
+};
+use std::io::Write;
+
+pub struct RstFormatter;
+
+impl RstFormatter {
+    pub fn new() -> Self {
+        RstFormatter
+    }
+
+    fn section_char(level: usize) -> char {
+        match level {
+            0 => '=',
+            1 => '-',
+            2 => '~',
+            3 => '^',
+            _ => '"',
+        }
+    }
+}
+
+impl OutputFormatter for RstFormatter {
+    fn begin_document(&mut self, _w: &mut dyn Write) -> std::io::Result<()> {
+        Ok(())
+    }
+
+    fn end_document(&mut self, _w: &mut dyn Write) -> std::io::Result<()> {
+        Ok(())
+    }
+
+    fn begin_api_list(&mut self, w: &mut dyn Write, title: &str) -> std::io::Result<()> {
+        writeln!(w, "\n{title}")?;
+        writeln!(
+            w,
+            "{}",
+            Self::section_char(0).to_string().repeat(title.len())
+        )?;
+        writeln!(w)
+    }
+
+    fn api_item(&mut self, w: &mut dyn Write, name: &str, api_type: &str) -> std::io::Result<()> {
+        writeln!(w, "* **{name}** (*{api_type}*)")
+    }
+
+    fn end_api_list(&mut self, _w: &mut dyn Write) -> std::io::Result<()> {
+        Ok(())
+    }
+
+    fn total_specs(&mut self, w: &mut dyn Write, count: usize) -> std::io::Result<()> {
+        writeln!(w, "\n**Total specifications found:** {count}")
+    }
+
+    fn begin_api_details(&mut self, w: &mut dyn Write, name: &str) -> std::io::Result<()> {
+        writeln!(w, "\n{name}")?;
+        writeln!(
+            w,
+            "{}",
+            Self::section_char(0).to_string().repeat(name.len())
+        )?;
+        writeln!(w)
+    }
+
+    fn end_api_details(&mut self, _w: &mut dyn Write) -> std::io::Result<()> {
+        Ok(())
+    }
+
+    fn description(&mut self, w: &mut dyn Write, desc: &str) -> std::io::Result<()> {
+        writeln!(w, "**{desc}**")?;
+        writeln!(w)
+    }
+
+    fn long_description(&mut self, w: &mut dyn Write, desc: &str) -> std::io::Result<()> {
+        writeln!(w, "{}", super::rst_text(desc))?;
+        writeln!(w)
+    }
+
+    fn begin_context_flags(&mut self, w: &mut dyn Write) -> std::io::Result<()> {
+        let title = "Execution Context";
+        writeln!(w, "{title}")?;
+        writeln!(
+            w,
+            "{}",
+            Self::section_char(1).to_string().repeat(title.len())
+        )?;
+        writeln!(w)
+    }
+
+    fn context_flag(&mut self, w: &mut dyn Write, flag: &str) -> std::io::Result<()> {
+        writeln!(w, "* {flag}")
+    }
+
+    fn end_context_flags(&mut self, w: &mut dyn Write) -> std::io::Result<()> {
+        writeln!(w)
+    }
+
+    fn begin_parameters(&mut self, w: &mut dyn Write, count: u32) -> std::io::Result<()> {
+        let title = format!("Parameters ({count})");
+        writeln!(w, "{title}")?;
+        writeln!(
+            w,
+            "{}",
+            Self::section_char(1).to_string().repeat(title.len())
+        )?;
+        writeln!(w)
+    }
+
+    fn end_parameters(&mut self, _w: &mut dyn Write) -> std::io::Result<()> {
+        Ok(())
+    }
+
+    fn begin_errors(&mut self, w: &mut dyn Write, count: u32) -> std::io::Result<()> {
+        let title = format!("Possible Errors ({count})");
+        writeln!(w, "{title}")?;
+        writeln!(
+            w,
+            "{}",
+            Self::section_char(1).to_string().repeat(title.len())
+        )?;
+        writeln!(w)
+    }
+
+    fn end_errors(&mut self, _w: &mut dyn Write) -> std::io::Result<()> {
+        Ok(())
+    }
+
+    fn examples(&mut self, w: &mut dyn Write, examples: &str) -> std::io::Result<()> {
+        let title = "Examples";
+        writeln!(w, "{title}")?;
+        writeln!(
+            w,
+            "{}",
+            Self::section_char(1).to_string().repeat(title.len())
+        )?;
+        writeln!(w)?;
+        writeln!(w, ".. code-block:: c")?;
+        writeln!(w)?;
+        super::write_indented(w, "   ", examples)?;
+        writeln!(w)
+    }
+
+    fn notes(&mut self, w: &mut dyn Write, notes: &str) -> std::io::Result<()> {
+        let title = "Notes";
+        writeln!(w, "{title}")?;
+        writeln!(
+            w,
+            "{}",
+            Self::section_char(1).to_string().repeat(title.len())
+        )?;
+        writeln!(w)?;
+        writeln!(w, "{}", super::rst_text(notes))?;
+        writeln!(w)
+    }
+
+    fn sysfs_subsystem(&mut self, w: &mut dyn Write, subsystem: &str) -> std::io::Result<()> {
+        writeln!(w, ":Subsystem: {subsystem}")?;
+        writeln!(w)
+    }
+
+    fn sysfs_path(&mut self, w: &mut dyn Write, path: &str) -> std::io::Result<()> {
+        writeln!(w, ":Sysfs Path: {path}")?;
+        writeln!(w)
+    }
+
+    fn sysfs_permissions(&mut self, w: &mut dyn Write, perms: &str) -> std::io::Result<()> {
+        writeln!(w, ":Permissions: {perms}")?;
+        writeln!(w)
+    }
+
+    fn begin_capabilities(&mut self, w: &mut dyn Write) -> std::io::Result<()> {
+        let title = "Required Capabilities";
+        writeln!(w, "{title}")?;
+        writeln!(
+            w,
+            "{}",
+            Self::section_char(1).to_string().repeat(title.len())
+        )?;
+        writeln!(w)
+    }
+
+    fn capability(&mut self, w: &mut dyn Write, cap: &CapabilitySpec) -> std::io::Result<()> {
+        writeln!(w, "**{} ({})** - {}", cap.name, cap.capability, cap.action)?;
+        writeln!(w)?;
+        if !cap.allows.is_empty() {
+            writeln!(w, "* **Allows:** {}", cap.allows)?;
+        }
+        if !cap.without_cap.is_empty() {
+            writeln!(w, "* **Without capability:** {}", cap.without_cap)?;
+        }
+        if let Some(cond) = &cap.check_condition {
+            writeln!(w, "* **Condition:** {}", cond)?;
+        }
+        writeln!(w)
+    }
+
+    fn end_capabilities(&mut self, _w: &mut dyn Write) -> std::io::Result<()> {
+        Ok(())
+    }
+
+    fn parameter(&mut self, w: &mut dyn Write, param: &ParamSpec) -> std::io::Result<()> {
+        writeln!(
+            w,
+            "**[{}] {}** (*{}*)",
+            param.index, param.name, param.type_name
+        )?;
+        writeln!(w)?;
+        writeln!(w, "  {}", param.description)?;
+
+        // Display flags
+        let flags = super::param_flag_names(param.flags);
+        if !flags.is_empty() {
+            writeln!(w, "  :Flags: {}", flags.join(", "))?;
+        }
+
+        if let Some(constraint) = &param.constraint {
+            writeln!(w, "  :Constraint: {}", constraint)?;
+        }
+
+        if let Some(range) = super::range_text(param.min_value, param.max_value) {
+            writeln!(w, "  :Range: {}", range)?;
+        }
+
+        writeln!(w)
+    }
+
+    fn return_spec(&mut self, w: &mut dyn Write, ret: &ReturnSpec) -> std::io::Result<()> {
+        writeln!(w, "\nReturn Value")?;
+        writeln!(w, "{}\n", Self::section_char(1).to_string().repeat(12))?;
+        writeln!(w)?;
+        writeln!(w, ":Type: {}", ret.type_name)?;
+        writeln!(w, ":Description: {}", ret.description)?;
+        if let Some(success) = ret.success_value {
+            writeln!(w, ":Success value: {}", success)?;
+        }
+        writeln!(w)
+    }
+
+    fn error(&mut self, w: &mut dyn Write, error: &ErrorSpec) -> std::io::Result<()> {
+        writeln!(w, "**{}** ({})", error.name, error.error_code)?;
+        writeln!(w)?;
+        writeln!(w, "  :Condition: {}", error.condition)?;
+        if !error.description.is_empty() {
+            writeln!(w, "  :Description: {}", error.description)?;
+        }
+        writeln!(w)
+    }
+
+    fn begin_signals(&mut self, w: &mut dyn Write, count: u32) -> std::io::Result<()> {
+        let title = format!("Signals ({count})");
+        writeln!(w, "{title}")?;
+        writeln!(
+            w,
+            "{}",
+            Self::section_char(1).to_string().repeat(title.len())
+        )?;
+        writeln!(w)
+    }
+
+    fn signal(&mut self, w: &mut dyn Write, signal: &SignalSpec) -> std::io::Result<()> {
+        write!(w, "* **{}**", signal.signal_name)?;
+        if signal.signal_num != 0 {
+            write!(w, " ({})", signal.signal_num)?;
+        }
+        writeln!(w)?;
+
+        // Direction (bitmask matching C enum kapi_signal_direction)
+        let mut dirs = Vec::new();
+        if signal.direction & 1 != 0 {
+            dirs.push("receive");
+        }
+        if signal.direction & 2 != 0 {
+            dirs.push("send");
+        }
+        if signal.direction & 4 != 0 {
+            dirs.push("handle");
+        }
+        if signal.direction & 8 != 0 {
+            dirs.push("block");
+        }
+        if signal.direction & 16 != 0 {
+            dirs.push("ignore");
+        }
+        let direction = if dirs.is_empty() {
+            "unknown".to_string()
+        } else {
+            dirs.join(", ")
+        };
+        writeln!(w, "  :Direction: {}", direction)?;
+
+        // Action (matching C enum kapi_signal_action)
+        let action = match signal.action {
+            0 => "default",
+            1 => "terminate",
+            2 => "coredump",
+            3 => "stop",
+            4 => "continue",
+            5 => "custom",
+            6 => "return",
+            7 => "restart",
+            8 => "queue",
+            9 => "discard",
+            10 => "transform",
+            _ => "unknown",
+        };
+        writeln!(w, "  :Action: {}", action)?;
+
+        if let Some(target) = &signal.target {
+            writeln!(w, "  :Target: {}", target)?;
+        }
+        if let Some(cond) = &signal.condition {
+            writeln!(w, "  :Condition: {}", cond)?;
+        }
+        if let Some(desc) = &signal.description {
+            writeln!(w, "  :Description: {}", desc)?;
+        }
+        let timing = match signal.timing {
+            0 => "before",
+            1 => "during",
+            2 => "after",
+            3 => "exit",
+            _ => "",
+        };
+        if !timing.is_empty() {
+            writeln!(w, "  :Timing: {}", timing)?;
+        }
+        if signal.priority != 0 {
+            writeln!(w, "  :Priority: {}", signal.priority)?;
+        }
+        if signal.interruptible {
+            writeln!(w, "  :Interruptible: yes")?;
+        }
+        if signal.restartable {
+            writeln!(w, "  :Restartable: yes")?;
+        }
+        if let Some(queue) = &signal.queue {
+            writeln!(w, "  :Queue: {}", queue)?;
+        }
+        if signal.sa_flags_required != 0 {
+            writeln!(w, "  :SA flags required: {:#x}", signal.sa_flags_required)?;
+        }
+        if signal.sa_flags_forbidden != 0 {
+            writeln!(w, "  :SA flags forbidden: {:#x}", signal.sa_flags_forbidden)?;
+        }
+        if signal.state_required != 0 {
+            writeln!(w, "  :State required: {:#x}", signal.state_required)?;
+        }
+        if signal.state_forbidden != 0 {
+            writeln!(w, "  :State forbidden: {:#x}", signal.state_forbidden)?;
+        }
+        if let Some(error) = signal.error_on_signal {
+            writeln!(w, "  :Error on signal: {}", error)?;
+        }
+        if let Some(transform) = signal.transform_to {
+            writeln!(w, "  :Transform to: {}", transform)?;
+        }
+        writeln!(w)
+    }
+
+    fn end_signals(&mut self, _w: &mut dyn Write) -> std::io::Result<()> {
+        Ok(())
+    }
+
+    fn begin_signal_masks(&mut self, w: &mut dyn Write, count: u32) -> std::io::Result<()> {
+        let title = format!("Signal Masks ({count})");
+        writeln!(w, "{title}")?;
+        writeln!(
+            w,
+            "{}",
+            Self::section_char(1).to_string().repeat(title.len())
+        )?;
+        writeln!(w)
+    }
+
+    fn signal_mask(&mut self, w: &mut dyn Write, mask: &SignalMaskSpec) -> std::io::Result<()> {
+        writeln!(w, "* **{}**", mask.name)?;
+        if !mask.description.is_empty() {
+            writeln!(w, "  {}", mask.description)?;
+        }
+        if !mask.signals.is_empty() {
+            let signals: Vec<String> = mask.signals.iter().map(i32::to_string).collect();
+            writeln!(w, "  Signals: {}", signals.join(", "))?;
+        }
+        writeln!(w)
+    }
+
+    fn end_signal_masks(&mut self, _w: &mut dyn Write) -> std::io::Result<()> {
+        Ok(())
+    }
+
+    fn begin_side_effects(&mut self, w: &mut dyn Write, count: u32) -> std::io::Result<()> {
+        let title = format!("Side Effects ({count})");
+        writeln!(w, "{}\n", title)?;
+        writeln!(
+            w,
+            "{}\n",
+            Self::section_char(1).to_string().repeat(title.len())
+        )
+    }
+
+    fn side_effect(&mut self, w: &mut dyn Write, effect: &SideEffectSpec) -> std::io::Result<()> {
+        write!(w, "* **{}**", effect.target)?;
+        if effect.reversible {
+            write!(w, " *(reversible)*")?;
+        }
+        writeln!(w)?;
+        writeln!(w, "  {}", effect.description)?;
+        if let Some(cond) = &effect.condition {
+            writeln!(w, "  :Condition: {}", cond)?;
+        }
+        writeln!(w)
+    }
+
+    fn end_side_effects(&mut self, _w: &mut dyn Write) -> std::io::Result<()> {
+        Ok(())
+    }
+
+    fn begin_state_transitions(&mut self, w: &mut dyn Write, count: u32) -> std::io::Result<()> {
+        let title = format!("State Transitions ({count})");
+        writeln!(w, "{}\n", title)?;
+        writeln!(
+            w,
+            "{}\n",
+            Self::section_char(1).to_string().repeat(title.len())
+        )
+    }
+
+    fn state_transition(
+        &mut self,
+        w: &mut dyn Write,
+        trans: &StateTransitionSpec,
+    ) -> std::io::Result<()> {
+        writeln!(
+            w,
+            "* **{}**: {} → {}",
+            trans.object, trans.from_state, trans.to_state
+        )?;
+        writeln!(w, "  {}", trans.description)?;
+        if let Some(cond) = &trans.condition {
+            writeln!(w, "  :Condition: {}", cond)?;
+        }
+        writeln!(w)
+    }
+
+    fn end_state_transitions(&mut self, _w: &mut dyn Write) -> std::io::Result<()> {
+        Ok(())
+    }
+
+    fn begin_constraints(&mut self, w: &mut dyn Write, count: u32) -> std::io::Result<()> {
+        let title = format!("Constraints ({count})");
+        writeln!(w, "{title}")?;
+        writeln!(
+            w,
+            "{}",
+            Self::section_char(1).to_string().repeat(title.len())
+        )?;
+        writeln!(w)
+    }
+
+    fn constraint(
+        &mut self,
+        w: &mut dyn Write,
+        constraint: &ConstraintSpec,
+    ) -> std::io::Result<()> {
+        writeln!(w, "* **{}**", constraint.name)?;
+        if !constraint.description.is_empty() {
+            writeln!(w, "  {}", constraint.description)?;
+        }
+        if let Some(expr) = &constraint.expression {
+            writeln!(w, "  :Expression: ``{}``", expr)?;
+        }
+        writeln!(w)
+    }
+
+    fn end_constraints(&mut self, _w: &mut dyn Write) -> std::io::Result<()> {
+        Ok(())
+    }
+
+    fn begin_locks(&mut self, w: &mut dyn Write, count: u32) -> std::io::Result<()> {
+        let title = format!("Locks ({count})");
+        writeln!(w, "{}\n", title)?;
+        writeln!(
+            w,
+            "{}\n",
+            Self::section_char(1).to_string().repeat(title.len())
+        )
+    }
+
+    fn lock(&mut self, w: &mut dyn Write, lock: &LockSpec) -> std::io::Result<()> {
+        write!(w, "* **{}**", lock.lock_name)?;
+        let lock_type_str = match lock.lock_type {
+            1 => " *(mutex)*",
+            2 => " *(spinlock)*",
+            3 => " *(rwlock)*",
+            4 => " *(seqlock)*",
+            5 => " *(RCU)*",
+            6 => " *(semaphore)*",
+            7 => " *(custom)*",
+            _ => "",
+        };
+        writeln!(w, "{}", lock_type_str)?;
+        if !lock.description.is_empty() {
+            writeln!(w, "  {}", lock.description)?;
+        }
+        writeln!(w)
+    }
+
+    fn end_locks(&mut self, _w: &mut dyn Write) -> std::io::Result<()> {
+        Ok(())
+    }
+
+    fn begin_struct_specs(&mut self, w: &mut dyn Write, _count: u32) -> std::io::Result<()> {
+        writeln!(w)?;
+        writeln!(w, "Structure Specifications")?;
+        writeln!(w, "~~~~~~~~~~~~~~~~~~~~~~~")?;
+        writeln!(w)
+    }
+
+    fn struct_spec(
+        &mut self,
+        w: &mut dyn Write,
+        spec: &crate::extractor::StructSpec,
+    ) -> std::io::Result<()> {
+        writeln!(w, "**{}**", spec.name)?;
+        writeln!(w)?;
+
+        if !spec.description.is_empty() {
+            writeln!(w, "  {}", spec.description)?;
+            writeln!(w)?;
+        }
+
+        writeln!(w, "  :Size: {} bytes", spec.size)?;
+        writeln!(w, "  :Alignment: {} bytes", spec.alignment)?;
+        writeln!(w, "  :Fields: {}", spec.field_count)?;
+        writeln!(w)?;
+
+        if !spec.fields.is_empty() {
+            for field in &spec.fields {
+                writeln!(w, "  * **{}** ({})", field.name, field.type_name)?;
+                if !field.description.is_empty() {
+                    writeln!(w, "    {}", field.description)?;
+                }
+                if field.min_value != 0 || field.max_value != 0 {
+                    writeln!(w, "    Range: [{}, {}]", field.min_value, field.max_value)?;
+                }
+            }
+            writeln!(w)?;
+        }
+
+        Ok(())
+    }
+
+    fn end_struct_specs(&mut self, _w: &mut dyn Write) -> std::io::Result<()> {
+        Ok(())
+    }
+}
+
+#[cfg(test)]
+mod tests {
+    use super::*;
+    use crate::extractor::{ErrorSpec, LockSpec, ParamSpec, ReturnSpec};
+
+    fn render_rst(f: &mut RstFormatter, sink: &mut Vec<u8>) -> String {
+        f.end_document(sink).unwrap();
+        String::from_utf8(sink.clone()).unwrap()
+    }
+
+    #[test]
+    fn rst_api_details_has_heading() {
+        let mut f = RstFormatter::new();
+        let mut sink = Vec::new();
+
+        f.begin_document(&mut sink).unwrap();
+        f.begin_api_details(&mut sink, "sys_test").unwrap();
+        f.description(&mut sink, "A test syscall").unwrap();
+        f.end_api_details(&mut sink).unwrap();
+
+        let out = render_rst(&mut f, &mut sink);
+        assert!(out.contains("sys_test"));
+        assert!(out.contains("========"));
+        assert!(out.contains("**A test syscall**"));
+    }
+
+    #[test]
+    fn rst_api_list() {
+        let mut f = RstFormatter::new();
+        let mut sink = Vec::new();
+
+        f.begin_document(&mut sink).unwrap();
+        f.begin_api_list(&mut sink, "System Calls").unwrap();
+        f.api_item(&mut sink, "sys_open", "syscall").unwrap();
+        f.api_item(&mut sink, "sys_read", "syscall").unwrap();
+        f.end_api_list(&mut sink).unwrap();
+        f.total_specs(&mut sink, 2).unwrap();
+
+        let out = render_rst(&mut f, &mut sink);
+        assert!(out.contains("sys_open"));
+        assert!(out.contains("sys_read"));
+    }
+
+    #[test]
+    fn rst_parameters() {
+        let mut f = RstFormatter::new();
+        let mut sink = Vec::new();
+
+        f.begin_document(&mut sink).unwrap();
+        f.begin_api_details(&mut sink, "sys_write").unwrap();
+        f.begin_parameters(&mut sink, 1).unwrap();
+        f.parameter(
+            &mut sink,
+            &ParamSpec {
+                index: 0,
+                name: "fd".to_string(),
+                type_name: "unsigned int".to_string(),
+                description: "file descriptor".to_string(),
+                flags: 1,
+                param_type: 2,
+                constraint_type: 0,
+                constraint: None,
+                min_value: None,
+                max_value: None,
+                valid_mask: None,
+                enum_values: vec![],
+                size: None,
+                alignment: None,
+                size_param_idx: None,
+            },
+        )
+        .unwrap();
+        f.end_parameters(&mut sink).unwrap();
+        f.end_api_details(&mut sink).unwrap();
+
+        let out = render_rst(&mut f, &mut sink);
+        assert!(out.contains("**[0] fd**"));
+        assert!(out.contains("unsigned int"));
+        assert!(out.contains("file descriptor"));
+    }
+
+    #[test]
+    fn rst_errors() {
+        let mut f = RstFormatter::new();
+        let mut sink = Vec::new();
+
+        f.begin_document(&mut sink).unwrap();
+        f.begin_api_details(&mut sink, "sys_test").unwrap();
+        f.begin_errors(&mut sink, 1).unwrap();
+        f.error(
+            &mut sink,
+            &ErrorSpec {
+                error_code: -2,
+                name: "ENOENT".to_string(),
+                condition: "File not found".to_string(),
+                description: "The file does not exist".to_string(),
+            },
+        )
+        .unwrap();
+        f.end_errors(&mut sink).unwrap();
+        f.end_api_details(&mut sink).unwrap();
+
+        let out = render_rst(&mut f, &mut sink);
+        assert!(out.contains("**ENOENT**"));
+        assert!(out.contains("-2"));
+        assert!(out.contains("File not found"));
+    }
+
+    #[test]
+    fn rst_return_spec() {
+        let mut f = RstFormatter::new();
+        let mut sink = Vec::new();
+
+        f.begin_document(&mut sink).unwrap();
+        f.begin_api_details(&mut sink, "sys_test").unwrap();
+        f.return_spec(
+            &mut sink,
+            &ReturnSpec {
+                type_name: "KAPI_TYPE_INT".to_string(),
+                description: "Returns 0 on success".to_string(),
+                return_type: 1,
+                check_type: 0,
+                success_value: Some(0),
+                success_min: None,
+                success_max: None,
+                error_values: vec![],
+            },
+        )
+        .unwrap();
+        f.end_api_details(&mut sink).unwrap();
+
+        let out = render_rst(&mut f, &mut sink);
+        assert!(out.contains("KAPI_TYPE_INT"));
+        assert!(out.contains("Returns 0 on success"));
+        assert!(out.contains("Return Value"));
+    }
+
+    #[test]
+    fn rst_context_flags() {
+        let mut f = RstFormatter::new();
+        let mut sink = Vec::new();
+
+        f.begin_document(&mut sink).unwrap();
+        f.begin_api_details(&mut sink, "sys_test").unwrap();
+        f.begin_context_flags(&mut sink).unwrap();
+        f.context_flag(&mut sink, "KAPI_CTX_PROCESS").unwrap();
+        f.context_flag(&mut sink, "KAPI_CTX_SLEEPABLE").unwrap();
+        f.end_context_flags(&mut sink).unwrap();
+        f.end_api_details(&mut sink).unwrap();
+
+        let out = render_rst(&mut f, &mut sink);
+        assert!(out.contains("KAPI_CTX_PROCESS"));
+        assert!(out.contains("KAPI_CTX_SLEEPABLE"));
+        assert!(out.contains("Execution Context"));
+    }
+
+    #[test]
+    fn rst_signal_mask_lists_its_signals() {
+        let mut f = RstFormatter::new();
+        let mut sink = Vec::new();
+
+        f.begin_document(&mut sink).unwrap();
+        f.begin_api_details(&mut sink, "sys_test").unwrap();
+        f.begin_signal_masks(&mut sink, 1).unwrap();
+        f.signal_mask(
+            &mut sink,
+            &SignalMaskSpec {
+                name: "blocked".to_string(),
+                description: "Blocked while running".to_string(),
+                signals: vec![2, 15],
+            },
+        )
+        .unwrap();
+        f.end_signal_masks(&mut sink).unwrap();
+        f.end_api_details(&mut sink).unwrap();
+
+        let out = render_rst(&mut f, &mut sink);
+        assert!(out.contains("* **blocked**\n  Blocked while running\n  Signals: 2, 15\n"));
+    }
+
+    #[test]
+    fn rst_examples_are_a_literal_block_with_blank_lines_kept() {
+        let mut f = RstFormatter::new();
+        let mut sink = Vec::new();
+
+        f.begin_document(&mut sink).unwrap();
+        f.begin_api_details(&mut sink, "sys_test").unwrap();
+        f.examples(&mut sink, "a();\n  b();\n\nc();").unwrap();
+        f.end_api_details(&mut sink).unwrap();
+
+        let out = render_rst(&mut f, &mut sink);
+        assert!(out.contains(".. code-block:: c\n\n   a();\n     b();\n\n   c();\n"));
+    }
+
+    #[test]
+    fn rst_bullets_get_blank_lines_around_the_list() {
+        let mut f = RstFormatter::new();
+        let mut sink = Vec::new();
+
+        f.begin_document(&mut sink).unwrap();
+        f.begin_api_details(&mut sink, "sys_test").unwrap();
+        f.long_description(&mut sink, "Intro:\n- one\n- two\n\nTail.")
+            .unwrap();
+        f.notes(&mut sink, "Para one.\n\n- a\n- b\nafter").unwrap();
+        f.end_api_details(&mut sink).unwrap();
+
+        let out = render_rst(&mut f, &mut sink);
+        assert!(out.contains("Intro:\n\n- one\n- two\n\nTail.\n"));
+        assert!(out.contains("Para one.\n\n- a\n- b\n\nafter\n"));
+    }
+
+    #[test]
+    fn rst_lock_types_follow_the_kernel_enum() {
+        let mut f = RstFormatter::new();
+        let mut sink = Vec::new();
+
+        for (lock_type, label) in [
+            (1, "mutex"),
+            (2, "spinlock"),
+            (3, "rwlock"),
+            (4, "seqlock"),
+            (5, "RCU"),
+            (6, "semaphore"),
+            (7, "custom"),
+        ] {
+            f.lock(
+                &mut sink,
+                &LockSpec {
+                    lock_name: "l".to_string(),
+                    lock_type,
+                    scope: 0,
+                    description: String::new(),
+                },
+            )
+            .unwrap();
+            let out = String::from_utf8(std::mem::take(&mut sink)).unwrap();
+            assert_eq!(out, format!("* **l** *({label})*\n\n"));
+        }
+    }
+}
diff --git a/tools/kapi/src/main.rs b/tools/kapi/src/main.rs
new file mode 100644
index 0000000000000..93ed11b508e9f
--- /dev/null
+++ b/tools/kapi/src/main.rs
@@ -0,0 +1,123 @@
+// SPDX-License-Identifier: GPL-2.0
+// Copyright (C) 2026 Sasha Levin <sashal@kernel.org>
+
+//! kapi - Kernel API Specification Tool
+//!
+//! This tool extracts and displays kernel API specifications from multiple sources:
+//! - Kernel source code (kerneldoc blocks)
+//! - Compiled vmlinux binaries (`.kapi_specs` ELF section)
+//! - Running kernel via debugfs
+
+use anyhow::Result;
+use clap::Parser;
+use std::io::{self, Write};
+
+mod extractor;
+mod formatter;
+
+use extractor::{ApiExtractor, DebugfsExtractor, SourceExtractor, VmlinuxExtractor};
+use formatter::{create_formatter, OutputFormat};
+
+#[derive(Parser, Debug)]
+#[command(author, version, about, long_about = None)]
+struct Args {
+    /// Path to the vmlinux file
+    #[arg(long, value_name = "PATH", group = "input")]
+    vmlinux: Option<String>,
+
+    /// Path to kernel source directory or file
+    #[arg(long, value_name = "PATH", group = "input")]
+    source: Option<String>,
+
+    /// Path to debugfs (defaults to /sys/kernel/debug if not specified)
+    #[arg(long, value_name = "PATH", group = "input")]
+    debugfs: Option<String>,
+
+    /// Optional: Name of specific API to show details for
+    api_name: Option<String>,
+
+    /// Output format
+    #[arg(long, short = 'f', default_value = "plain")]
+    format: String,
+}
+
+fn main() -> Result<()> {
+    let args = Args::parse();
+
+    let output_format: OutputFormat = args
+        .format
+        .parse()
+        .map_err(|e: String| anyhow::anyhow!(e))?;
+
+    let extractor: Box<dyn ApiExtractor> = match (&args.vmlinux, &args.source, &args.debugfs) {
+        (Some(vmlinux_path), None, None) => Box::new(VmlinuxExtractor::new(vmlinux_path)?),
+        (None, Some(source_path), None) => Box::new(SourceExtractor::new(source_path)?),
+        (None, None, Some(_) | None) => {
+            // If debugfs is specified or no input is provided, use debugfs
+            Box::new(DebugfsExtractor::new(args.debugfs.clone())?)
+        }
+        _ => {
+            anyhow::bail!("Please specify only one of --vmlinux, --source, or --debugfs")
+        }
+    };
+
+    display_apis(extractor.as_ref(), args.api_name, output_format)
+}
+
+fn display_apis(
+    extractor: &dyn ApiExtractor,
+    api_name: Option<String>,
+    output_format: OutputFormat,
+) -> Result<()> {
+    let mut formatter = create_formatter(output_format);
+    let mut stdout = io::stdout();
+
+    formatter.begin_document(&mut stdout)?;
+
+    if let Some(api_name_req) = api_name {
+        // Use the extractor to display API details
+        if let Some(_spec) = extractor.extract_by_name(&api_name_req)? {
+            extractor.display_api_details(&api_name_req, &mut *formatter, &mut stdout)?;
+        } else {
+            eprintln!("API '{}' not found.", api_name_req);
+            if output_format == OutputFormat::Plain {
+                writeln!(stdout, "\nAvailable APIs:")?;
+                for spec in extractor.extract_all()? {
+                    writeln!(stdout, "  {} ({})", spec.name, spec.api_type)?;
+                }
+            }
+            std::process::exit(1);
+        }
+    } else {
+        // Display list of APIs using the extractor
+        let all_specs = extractor.extract_all()?;
+
+        // Helper to display API list for a specific type
+        let mut display_api_type = |api_type: &str, title: &str| -> Result<()> {
+            let filtered: Vec<_> = all_specs
+                .iter()
+                .filter(|s| s.api_type == api_type)
+                .collect();
+
+            if !filtered.is_empty() {
+                formatter.begin_api_list(&mut stdout, title)?;
+                for spec in filtered {
+                    formatter.api_item(&mut stdout, &spec.name, &spec.api_type)?;
+                }
+                formatter.end_api_list(&mut stdout)?;
+            }
+            Ok(())
+        };
+
+        display_api_type("syscall", "System Calls")?;
+        display_api_type("ioctl", "IOCTLs")?;
+        display_api_type("function", "Functions")?;
+        display_api_type("sysfs", "Sysfs Attributes")?;
+
+        formatter.total_specs(&mut stdout, all_specs.len())?;
+    }
+
+    formatter.end_document(&mut stdout)?;
+
+    Ok(())
+}
-- 
2.53.0

