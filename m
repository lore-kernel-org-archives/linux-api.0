Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=130.136.161.50
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794836470;
	b=IzTQDuglzspaGtcdEJnPCiK24ewLp3vxfm7+vG6fFPwtvN8XzbC9t3mvnepfdmp4DhPz
	 WSh7SFvx7bnI0/6LWmzXmCq4ubB/fVDcIyDkunTOTcgmNli4MMrxumcGsbH/x0g8FeJuf
	 Anb1qZrIjvVWcBBdixNsDAnWcQwJibA+ttFNOCHzDf/msXqDpcpgh8QDStteLMAaeA/hp
	 bbCqy84Satmj/9RFSCteWsFv4c6AOcDwRGiE7AKsNf1kqVNgd+zl04qv294XriBOqQ/ld
	 sdD2e3zk3xdTtTnZTCFtQaWaJNLaOTbuJ5J6paK8H7edhC2VLdEzn0US8NeoJbwN6bg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794836470;
	h=DMARC-Filter:Received:DKIM-Signature:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=KoID3t/L5HYOJLaZAHtsmuIZvdirepRozKbl1aZqCio=;
	b=lODYKiXib0GWy/5hCNJDgLNsJJVNgf44JipJxz2TBy2222y9K3Ro91QdLOJS7XE5/HB8
	 3K5EQysqeXEMfMaefJa1DLWmHmW6k6KDf9gpC73dEUyGPwP4wltQo7Fol8g782NImIHHk
	 k9P1oSNTzJgez2z8oxh3jgizeEWfpTADgqCojmITsFYbedN+eLcYq/zuu1N2v5p1q12ka
	 OrSMVY+JYvwamw8CCM/NKZuEJOm8qYuo0D7hrPaqIV1FzysHTmwehkC3/1LpCie6SjeWB
	 l8jF7sxA+LnMO/HUGkNr6rSrRRPJJ0kDHUuoMqoVXmQp87AHgZcWAH10Fkl19dHuM3Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=cs.unibo.it;
	spf=pass smtp.mailfrom=cs.unibo.it;
	dkim=pass header.d=cs.unibo.it header.i=@cs.unibo.it header.a=rsa-sha256 header.s=virtlab header.b=SlYczK8D;
	arc=none smtp.remote-ip=130.136.161.50
Received: from mail.virtlab.unibo.it (mail.virtlab.unibo.it [130.136.161.50])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A4DBE606A31C;
	Mon, 16 Nov 2026 13:41:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A4DBE606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cs.unibo.it
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cs.unibo.it
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=cs.unibo.it header.i=@cs.unibo.it header.a=rsa-sha256 header.s=virtlab header.b=SlYczK8D
Received: from eipi10.cs.unibo.it (renzopb-wl.cs.unibo.it [130.136.2.252])
	by mail.virtlab.unibo.it (Postfix) with ESMTPA id E3D2A1C024A;
	Mon, 16 Nov 2026 14:41:00 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=cs.unibo.it;
	s=virtlab; t=1794836461;
	bh=9BePSzjzJXa33FPP/d2SwB8juy+0sIML+/UiQYc++ic=;
	h=From:To:Cc:Subject:Date:From;
	b=SlYczK8D+ED2ZYMtdFF2bE5HUXOmKEiPvcjNy+jdJmHmVwWxhe6bYWWWo0XKbxB8y
	 izORiwUKhHAEK/qwEgO9ZcclBOR21ViZWOy0IC9lPP2te1JuxsyAGac6d93C13hikq
	 Zso1w9UGRImE067qXARKNSAIfGez2vDgmtKzEnAo=
From: Renzo Davoli <renzo@cs.unibo.it>
To: linux-kernel@vger.kernel.org
Cc: Renzo Davoli <renzo@cs.unibo.it>,
	Oleg Nesterov <oleg@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	"Dmitry V . Levin" <ldv@strace.io>,
	Alexey Gladkov <legion@kernel.org>,
	Eugene Syromyatnikov <evgsyr@gmail.com>,
	Charlie Jenkins <thecharlesjenkins@gmail.com>,
	Bradley Morgan <bradley.morgan@linux.dev>,
	Shuah Khan <shuah@kernel.org>,
	strace-devel@lists.strace.io,
	linux-api@vger.kernel.org,
	linux-kselftest@vger.kernel.org
Subject: [PATCH v4 0/2] ptrace: reject out of range error values in PTRACE_SET_SYSCALL_INFO
Date: Mon, 16 Nov 2026 14:40:44 +0100
Message-ID: <20261116134050.505355-1-renzo@cs.unibo.it>
X-Mailer: git-send-email 2.55.0
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

With is_error set, PTRACE_SET_SYSCALL_INFO passes info.exit.rval to
syscall_set_return_value() as an "int" error without checking it: a
positive value, or on 64-bit one outside the "int" range, turns the
error into a success or is truncated.

Patch 1 rejects with -ERANGE any error value outside [-MAX_ERRNO, -1].
Patch 2 adds a test case for this to the set_syscall_info selftest.

This series is independent of the PTRACE_SET_SYSCALL_INFO seccomp skip
and SET_IP series: they apply on top of each other in either order.

Testing (x86_64, QEMU): tools/testing/selftests/ptrace/set_syscall_info
passes 1/1 with this series applied.

Changes in v4:
* patch 1: use !IS_ERR_VALUE(rval) instead of open-coding the range
  check, no functional change. Thanks to Oleg Nesterov for the
  suggestion.
* rebased on current mainline (23c62304dde2)
* added Reviewed-by of Bradley Morgan to patch 2

Changes in v3:
* added Reviewed-by of Dmitry V. Levin and Bradley Morgan to patch 1
* new patch 2: selftest, as suggested by Dmitry V. Levin

Changes in v2:
* shorter commit message and comment, dropped Assisted-by
  (Bradley Morgan)

v3: https://lore.kernel.org/lkml/20261115152703.416254-1-renzo@cs.unibo.it/
v2: https://lore.kernel.org/lkml/20261115082540.385386-1-renzo@cs.unibo.it/
v1: https://lore.kernel.org/lkml/20261114184842.373304-1-renzo@cs.unibo.it/

Renzo Davoli (2):
  ptrace: reject out of range error values in PTRACE_SET_SYSCALL_INFO
  selftests/ptrace: check that PTRACE_SET_SYSCALL_INFO rejects invalid
    error values

 kernel/ptrace.c                               |  4 ++
 .../selftests/ptrace/set_syscall_info.c       | 51 +++++++++++++++++++
 2 files changed, 55 insertions(+)


base-commit: 23c62304dde29abe92013d85910d03a77dada35d
-- 
2.47.3

