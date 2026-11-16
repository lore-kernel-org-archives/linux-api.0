Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.218.43
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794852876;
	b=ZALlIHYe7hzNck9ZEu/S9/7AFwpR1OZrgrOCzu6jngSL2+b8FJ8vj1I7KJ98iZMyOheC
	 j9cIWuBfXUDE0wZ+Y24lYe4E4KnP6AEwtnxluDaaChEhyYO+QcmfW51FBAy0/a69LddvX
	 XeO/USAuluU8esd08DoRs19vM3/KeQEOeWnBYjGxv88Z1034wRKBMUANa2H4UGd+WQBn/
	 rmeY2EE+w9wcHKvUp4CdNXa+g1PciKSd1yBeQxMAjLThKkNuxNxRnMVgbMvG4nSbY1wPU
	 XuaqDyhyBs4gNESwqJCMIlmSuXYv53yb8TNvkxuvftMDJTgg6S1Mvj7fVaRVT2bXvwA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794852876;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=tbwNSvGvkZ6FGvVLTIjJxQ3bE6+PehswRYJGBnKvxtI=;
	b=QDUefJ6ydXoUnhdQB68s4FNAJ01oVXDykbPi9Re8CrWAZ2YTdnEaq3yYJopcgdUhJWsU
	 3ZAT5YS53LaihpLww4pHHjAftozQ/sTfVyt6plEqCSOImdZiZjZ3fPZFwDR4a9HHbxxfL
	 mThYaUMoOUU7JR8z3JQhziI5+I4am/VARImqoFb4QAuS8Nzs7o7RIErVy3NNaHHHy095M
	 sNOVK+gUB1E7CW5siCSokZlRbbzMOJRJnI1lCTAkBE4htKGgf1yn2+5AhhcY02Jfhi4TF
	 oPhDdqeR+0YENUcVl/RrTJ9/MZ7VBTQj30dfwjhbvPY4M09Fnxb47UlI8MVd4VTHFZQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=REtwaOnD;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.218.43
Received: from mail-ej1-f43.google.com (mail-ej1-f43.google.com [209.85.218.43])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA54D606A322
	for <linux-api@vger.kernel.org>; Mon, 16 Nov 2026 18:14:34 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org DA54D606A322
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=REtwaOnD
Received: by mail-ej1-f43.google.com with SMTP id a640c23a62f3a-c4d427836e9so501551766b.1
        for <linux-api@vger.kernel.org>; Mon, 16 Nov 2026 10:14:34 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1794852873; cv=none;
        d=google.com; s=arc-20260327;
        b=iZNSP28fYeHAE+MzuRsobPMDVW1TXDANr/5/Eh8rMqRqRiFuOfOEJtuYutq0pj+uuP
         bGBTmkftE+3XZvspTZVn/+8CFvynYmpsNr72Ob/BV6qpNY47uiQi+9NkhNdsZx7UUiZN
         LQ49fVZUYCnJv2Hgmh11NuNDjKRNXs4x8mMkXPPJ5Lr8OeMUcNXxuklgOcep9Qs1Al1V
         E31QsCgOIiQiNDRyg+fLq+A5JchlVu/B67xUtcRxCf9D556n4Y6Y0gZB4AOIl0WAhaSx
         7TW5EII8iyg6DRZVQf410L1KSjtIxzObeB5DP2eId5hkeS+fx06wc497s8isFsP1LlRB
         VxmA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=tbwNSvGvkZ6FGvVLTIjJxQ3bE6+PehswRYJGBnKvxtI=;
        fh=B01bQsfjY7eSXGT7VFAQ4Q3yo9ZvVOgZwqH+insVEKg=;
        b=gD4jWGBrqv98XbFFkQ9qyFwn199bwZOoXNZTgUFwU3+NobXrnUjMr9xLpSwlopaNRz
         WK5bwDL+CdZb5qOcuJP9CMUeDlId0eMLvgMZU/mtor4SiRvUAa1gutZaJwdNH5S7mJPw
         bY+S/Eo0A/Ou3OrYE/HrEODRkxNaDiqKcEgbYgasf7nfvxNUV/wqCkclq3dg/ZgdhJ6k
         /bvWTRXrx6hnyLqA4Gfm2T6mtb6a7wzDjHVDCm/7IaGyfuqjIegyfOz2PVyK3mVaU1RJ
         H0G8ZjNKRr2NCLmkARvW85BcCt1dWryVYdxVhBqsxcoNmrQimsfK2ZPJO+pUm0bT2BOT
         JgYw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794852873; x=1795457673; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=tbwNSvGvkZ6FGvVLTIjJxQ3bE6+PehswRYJGBnKvxtI=;
        b=REtwaOnDQoPmhuzfDWBecqvY2Nej4BY/Jc4KPgXp1NH++xbW04qqs5XLWElU23N/Kf
         JT129YSY9gG87GzUgRtmPPU7nYEKhNe7HzFsEnt/iUqSYBZUvSUmK5XCYL3rOgR/hWkg
         r5bgTY1lUh7wS2Lbao3cD8uS9cQAUZemxzLXULZHVyKKhcvKLiIZxS/FtShIFca0fXDV
         RJjhaLktOXMJzhtbTg7TEcdaFfcB6cd8GTXsdJ8UkF6yvS05qEbeimYnaXQwHM3DhO7K
         Px8BixiJP2UdTiHOBgaKbygtKt2z61AwQ+CYPuD9Ah9l5olPiDAcmFd7h4I+lTgm/3Qw
         c12w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794852873; x=1795457673;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=tbwNSvGvkZ6FGvVLTIjJxQ3bE6+PehswRYJGBnKvxtI=;
        b=ioBKKi7bSxWx8pkKRpNQg5ARiEDqRDwc2k8jJSGggMsbQ7kZYFKCCcF2LyVvpje8VE
         l2jI1qg4V+onuIQreIzeGoi5XPMI1EUac1SZax2reasNHCI0QmrowqfOU5zOF7jTZet0
         LAJ4OxYD3CztKwd8kzWdXDs3rrsbM3N8tOkFvB8rR/NP1WMlRw2uYXhw0JwhI5nXJIU7
         Lhh60XQIHCNvIvQyK1oEBfK7bsaBt2Fe03gr7SpSR2wv+r/XSMBQqGfUZKs/MkdVH6VM
         mmTTljpO7nRAEY2ZaEqmrT372AlkGipZFqI//M8SRu1Dy/74jl+DkHS8EmLhts/QL73C
         VaHg==
X-Forwarded-Encrypted: i=1; AL+hErHL11skq0EX+TyKgEyLLhXRTbZC/u670fbXwkqGIY5DN+BE+DR3GSl8rxp9l3P3oW50Vc2d+gQuL8k=@vger.kernel.org
X-Gm-Message-State: APuU4Z+xSgqwzYxvcm0l0igtnsjK5z8KpB3i5XEn7az0CQaYD+dEUkXY
	kbQObWIHQY/rnjXEUZQQPYqPuw8RKwpHUfHKewdfrk1HZRnzfR2iaMOOG97sSC+Vo3CXRR5N1k0
	eIzT9fZzELCOWXWGrn+D3dmqpRfCumoY=
X-Gm-Gg: AYBFou0XbeNzqguh7v/Nkp+C6bKYGNtIc+YTT4+ugvb8xt/lk6WAtfkB4AGKRfxQnvi
	YEsoNENeDAZHawZPFBHsMQ0cwhEL/cBGyXPmGwbhvlUr/ZiWSzVY6QqZT+M/s7FKQp9nqyjJDez
	6NEne2Mx0SYwi3ZO86nv0Mn5DZe75aPK9Hrgl1DG45g5e5dhSIenop91aTXKxN0qq+hE3DVzB3O
	IGI51BUV0eyECBg80VirJs+tQa+qCxCqibR7LZlkHBmb8gT46OB4xTYUIRTvYsSz5FvEotFBT1A
	M9UQGUJpXiYmRWTI0S087X3ib0WEEgjRBrsPJ/E4tT/ozup8yMbeSivpntsJ/bX8A3xjmUNkd/h
	9vjV1LTAa8UGGUPtYP4VDNRdhBMNI8qGNtj5cy9BaGZ9OcYXmDqPZa+w8YxNHlFIET1hdCA==
X-Received: by 2002:a17:907:3ccc:b0:c49:a235:8e0c with SMTP id
 a640c23a62f3a-c509637e31dmr934233266b.22.1794852873007; Mon, 16 Nov 2026
 10:14:33 -0800 (PST)
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Post: <mailto:linux-api@vger.kernel.org>
List-Help: <mailto:linux-api+help@vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-api+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261025164719.1831477-1-sashal@kernel.org>
In-Reply-To: <20261025164719.1831477-1-sashal@kernel.org>
From: Sasha Levin <levinsasha928@gmail.com>
Date: Mon, 16 Nov 2026 13:14:19 -0500
X-Gm-Features: AclHuK9sfeiUUhkQOi4L3FtpqX1XWSWrAtRgGWBj0BPLzcNiTLpwmGT382OC52c
Message-ID: <CA+1xoqcxAsRij1j10TyhNX9JXNXNkdWO3sMaVRXCqYdEXi45fg@mail.gmail.com>
Subject: Re: [GIT PULL] Kernel API specification framework for v7.4
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org, 
	linux-api@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, 
	linux-kbuild@vger.kernel.org, linux-doc@vger.kernel.org, 
	Christian Brauner <brauner@kernel.org>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Andrew Morton <akpm@linux-foundation.org>, Jonathan Corbet <corbet@lwn.net>, 
	Nathan Chancellor <nathan@kernel.org>, Nicolas Schier <nsc@kernel.org>, Thomas Gleixner <tglx@kernel.org>, 
	Mark Brown <broonie@kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Ping?

On Sun, Oct 25, 2026 at 12:47=E2=80=AFPM Sasha Levin <sashal@kernel.org> wr=
ote:
>
> Hi Linus,
>
> Please consider pulling the kernel API specification framework. It has
> been discussed on the lists for over a year: five RFC rounds starting in
> June 2025, then v1 through v5 this year, the last on October 8:
>
>   https://lore.kernel.org/all/20261008084956.2911790-1-sashal@kernel.org/
>
> The branch has been in linux-next since next-20261009. I held off on
> sending this until the first week of the merge window was over, to let
> things calm down.
>
> There are two conflicts with what you already merged. linux-next resolved
> both the same way:
>
>  - Makefile: kbuild added '*.header-check' to the clean rule at the same
>    spot where this adds '*.apispec.h'. Keep both lines.
>
>  - fs/open.c: vfs added filp_close_sync() just above sys_close(), which i=
s
>    where this adds the sys_close() kerneldoc. Keep filp_close_sync(), the=
n
>    the new kerneldoc, then the existing "Careful here!" comment and
>    SYSCALL_DEFINE1(close).
>
> The following changes since commit a90ee4305c4a5df72c11b31dacfdc76e00fcf7=
8a:
>
>   Linux 7.3-rc6 (2026-10-04 13:45:25 -0700)
>
> are available in the Git repository at:
>
>   https://git.kernel.org/pub/scm/linux/kernel/git/sashal/kapi.git tags/ka=
pi-7.4
>
> for you to fetch changes up to ef777ef05ebcc5ea5393b4bd5af6fc3ad1b3aec9:
>
>   kernel/api: add syscall enter/exit tracepoints (2026-10-07 18:26:44 -04=
00)
>
> ----------------------------------------------------------------
> Kernel API specification framework for v7.4
>
> The contract of a kernel interface (which arguments are valid, which erro=
rs
> come back and why, what context it can be called from, what it locks and
> what it changes) only exists as prose in man pages and comments, which
> tools cannot check. This adds a way to write that contract down in a form
> that tools can consume, next to the code it describes.
>
> A spec is structured kerneldoc covering parameter types and constraints,
> return values and error codes, execution context, locking, signals,
> capabilities and side effects. At build time kernel-doc turns it into C
> data in a dedicated section of vmlinux. From there a spec can be:
>
>  - checked against syscall arguments and return values at runtime by
>    CONFIG_KAPI_RUNTIME_CHECKS, a DEBUG_KERNEL option for x86 and arches
>    without syscall wrappers; a call that violates its spec fails with
>    -EINVAL before the handler runs
>  - read as JSON from debugfs
>  - extracted from vmlinux, debugfs or the source with tools/kapi, which
>    emits JSON, RST or plain text
>  - followed with the kapi_syscall_enter/exit tracepoints
>
> The first specs cover open, close, read, write and madvise, with a KUnit
> suite and a selftest in tools/testing/selftests/kapi.
>
> Everything is behind CONFIG_KAPI_SPEC, which defaults to off. With it off
> the syscall definition macros expand as before, kernel-doc output is
> unchanged, and the only change to fs/ and mm/ is the kerneldoc text.
>
> ----------------------------------------------------------------
> Sasha Levin (11):
>       kernel/api: introduce kernel API specification framework
>       kernel/api: enable kerneldoc-based API specifications
>       kernel/api: add debugfs interface for kernel API specifications
>       tools/kapi: add kernel API specification extraction tool
>       kernel/api: add API specification for sys_open
>       kernel/api: add API specification for sys_close
>       kernel/api: add API specification for sys_read
>       kernel/api: add API specification for sys_write
>       kernel/api: add runtime verification selftest
>       kernel/api: add API specification for sys_madvise
>       kernel/api: add syscall enter/exit tracepoints
>
>  .gitignore                                       |    1 +
>  Documentation/dev-tools/index.rst                |    1 +
>  Documentation/dev-tools/kernel-api-spec.rst      |  648 +++++
>  MAINTAINERS                                      |   13 +
>  Makefile                                         |    1 +
>  arch/x86/include/asm/syscall_wrapper.h           |    3 +-
>  fs/open.c                                        |  557 ++++
>  fs/read_write.c                                  |  710 +++++
>  include/asm-generic/vmlinux.lds.h                |   14 +
>  include/linux/kapi_syscall.h                     |   35 +
>  include/linux/kernel_api_spec.h                  | 1226 ++++++++
>  include/linux/syscalls.h                         |   42 +-
>  include/trace/events/kapi.h                      |   74 +
>  init/Kconfig                                     |    2 +
>  kernel/Makefile                                  |    1 +
>  kernel/api/Kconfig                               |   74 +
>  kernel/api/Makefile                              |   13 +
>  kernel/api/internal.h                            |   25 +
>  kernel/api/kapi_debugfs.c                        |  553 ++++
>  kernel/api/kapi_kunit.c                          |  720 +++++
>  kernel/api/kernel_api_spec.c                     | 1470 ++++++++++
>  mm/madvise.c                                     |  549 ++++
>  scripts/Makefile.build                           |   26 +
>  tools/docs/kernel-doc                            |   12 +-
>  tools/kapi/.gitignore                            |    3 +
>  tools/kapi/Cargo.lock                            |  679 +++++
>  tools/kapi/Cargo.toml                            |   20 +
>  tools/kapi/Makefile                              |   33 +
>  tools/kapi/README.md                             |   33 +
>  tools/kapi/src/extractor/debugfs.rs              | 1704 +++++++++++
>  tools/kapi/src/extractor/kerneldoc_parser.rs     | 3335 ++++++++++++++++=
++++++
>  tools/kapi/src/extractor/mod.rs                  |  442 +++
>  tools/kapi/src/extractor/source_parser.rs        |  531 ++++
>  tools/kapi/src/extractor/vmlinux/binary_utils.rs |  461 +++
>  tools/kapi/src/extractor/vmlinux/mod.rs          | 1160 ++++++++
>  tools/kapi/src/formatter/json.rs                 |  659 +++++
>  tools/kapi/src/formatter/mod.rs                  |  220 ++
>  tools/kapi/src/formatter/plain.rs                |  679 +++++
>  tools/kapi/src/formatter/rst.rs                  |  802 ++++++
>  tools/kapi/src/main.rs                           |  123 +
>  tools/lib/python/kdoc/kdoc_apispec.py            | 1391 +++++++++
>  tools/lib/python/kdoc/kdoc_files.py              |   12 +-
>  tools/lib/python/kdoc/kdoc_parser.py             |  101 +-
>  tools/testing/selftests/Makefile                 |    1 +
>  tools/testing/selftests/kapi/.gitignore          |    2 +
>  tools/testing/selftests/kapi/Makefile            |    7 +
>  tools/testing/selftests/kapi/kapi_test_util.h    |   31 +
>  tools/testing/selftests/kapi/test_kapi.c         | 1163 ++++++++
>  48 files changed, 20350 insertions(+), 12 deletions(-)
>  create mode 100644 Documentation/dev-tools/kernel-api-spec.rst
>  create mode 100644 include/linux/kapi_syscall.h
>  create mode 100644 include/linux/kernel_api_spec.h
>  create mode 100644 include/trace/events/kapi.h
>  create mode 100644 kernel/api/Kconfig
>  create mode 100644 kernel/api/Makefile
>  create mode 100644 kernel/api/internal.h
>  create mode 100644 kernel/api/kapi_debugfs.c
>  create mode 100644 kernel/api/kapi_kunit.c
>  create mode 100644 kernel/api/kernel_api_spec.c
>  create mode 100644 tools/kapi/.gitignore
>  create mode 100644 tools/kapi/Cargo.lock
>  create mode 100644 tools/kapi/Cargo.toml
>  create mode 100644 tools/kapi/Makefile
>  create mode 100644 tools/kapi/README.md
>  create mode 100644 tools/kapi/src/extractor/debugfs.rs
>  create mode 100644 tools/kapi/src/extractor/kerneldoc_parser.rs
>  create mode 100644 tools/kapi/src/extractor/mod.rs
>  create mode 100644 tools/kapi/src/extractor/source_parser.rs
>  create mode 100644 tools/kapi/src/extractor/vmlinux/binary_utils.rs
>  create mode 100644 tools/kapi/src/extractor/vmlinux/mod.rs
>  create mode 100644 tools/kapi/src/formatter/json.rs
>  create mode 100644 tools/kapi/src/formatter/mod.rs
>  create mode 100644 tools/kapi/src/formatter/plain.rs
>  create mode 100644 tools/kapi/src/formatter/rst.rs
>  create mode 100644 tools/kapi/src/main.rs
>  create mode 100644 tools/lib/python/kdoc/kdoc_apispec.py
>  create mode 100644 tools/testing/selftests/kapi/.gitignore
>  create mode 100644 tools/testing/selftests/kapi/Makefile
>  create mode 100644 tools/testing/selftests/kapi/kapi_test_util.h
>  create mode 100644 tools/testing/selftests/kapi/test_kapi.c
>
> --
> Thanks,
> Sasha
