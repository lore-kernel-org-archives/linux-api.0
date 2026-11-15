Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=130.136.161.50
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794756438;
	b=fHLVGV3yZfDLMnbYJEKJYOUelxuPZaJnBa+9NsCf0xu8Od700UuB6WAdvPg2jGy3sGF8
	 cyOu2iwD+OUAmB2dfpH7LLIehYTaZ1IHqT3bqNy0rjvjMMCITRI3oRZUepqaK4kE+ZSCS
	 xmqV5OUMP0DlmsQrQ8YDGL9FAc3aJTB4NmEtxGWvKX9ZWfi7CyZt4XZhgGGjDTmXNJMTW
	 /22SvnOW/AOYXBqR1lWFJ4j3MjZdiEBeYbSFdtNpJ/p1m72cjVv8IcIr94MSIgV2DdkVC
	 c8G2ljvgYCyGVDdzCC60hnWtGSE7fhkDxkS7EFNsUPxO3b7DhbVzluCByNwRoINbXFA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794756438;
	h=DMARC-Filter:Received:DKIM-Signature:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=nUh6bd9cxpIcKPQv5U3VbvxlP1Frmgz/Z1obLKrAVUM=;
	b=TwCMVjlvn96wyEeVSDKc+ek8aDLi39CVbbyOQHs8nHxw02/jIYDK0PM6qqHTt2yjbrrg
	 I+H9cyF7DOXN5x0EbY8IkZMt71a3NkOVLMRLxj6a1/KOL+NLVpL39F4mSTpyzR+o5czpj
	 wFSxSmzc3KZCtlZ6J4JVxtQocFcsqEZ/k0b6i6jsAXWtTBoQS2Ej9M2MEQDBl/ttCNzdH
	 wG3w2iW0RfdNcm4mWT+MD31aj+Ab1CxoMSvEEwIMJ3+8yqoxBNOCqS+BP4fKQZfNabmCw
	 Tt7wwKMz08qFwvmsJKwUNM/UBNb1CArnbkWAWv3UxwaovdInx7fU6W9LW5OhxtSpgnA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=cs.unibo.it;
	spf=pass smtp.mailfrom=cs.unibo.it;
	dkim=pass header.d=cs.unibo.it header.i=@cs.unibo.it header.a=rsa-sha256 header.s=virtlab header.b=IpcEa8Ca;
	arc=none smtp.remote-ip=130.136.161.50
Received: from mail.virtlab.unibo.it (mail.virtlab.unibo.it [130.136.161.50])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 31AA4606A31D;
	Sun, 15 Nov 2026 15:27:15 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 31AA4606A31D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cs.unibo.it
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cs.unibo.it
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=cs.unibo.it header.i=@cs.unibo.it header.a=rsa-sha256 header.s=virtlab header.b=IpcEa8Ca
Received: from eipi10.cs.unibo.it (unknown [94.32.99.206])
	by mail.virtlab.unibo.it (Postfix) with ESMTPA id 142881C024A;
	Sun, 15 Nov 2026 16:27:12 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=cs.unibo.it;
	s=virtlab; t=1794756433;
	bh=LBAqvBY3t1dvNoObrX2Qa2uuZxobhSCyYtDqwrAhRTM=;
	h=From:To:Cc:Subject:Date:From;
	b=IpcEa8CabzApkTBwXGZuu5LohrMQGH2hvL26YQAo9igD0zvBdVmJVCpBOmkT0/YlL
	 PrJiA3WAYrGm15r4GHfoFMWTPXkoIjCJhXzu6LRX2uCVhpYcN2UrqwWPLTQ0p6wmhq
	 Ru6l2ZGwUsRHyZdirgpdv54HcOKQm0gYMaDFdajA=
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
Subject: [PATCH v3 0/2] ptrace: reject out of range error values in PTRACE_SET_SYSCALL_INFO
Date: Sun, 15 Nov 2026 16:26:58 +0100
Message-ID: <20261115152703.416254-1-renzo@cs.unibo.it>
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

Changes in v3:
* added Reviewed-by of Dmitry V. Levin and Bradley Morgan to patch 1
* new patch 2: selftest, as suggested by Dmitry V. Levin

Changes in v2:
* shorter commit message and comment, dropped Assisted-by
  (Bradley Morgan)

v2: https://lore.kernel.org/lkml/20261115082540.385386-1-renzo@cs.unibo.it/
v1: https://lore.kernel.org/lkml/20261114184842.373304-1-renzo@cs.unibo.it/

Renzo Davoli (2):
  ptrace: reject out of range error values in PTRACE_SET_SYSCALL_INFO
  selftests/ptrace: check that PTRACE_SET_SYSCALL_INFO rejects invalid
    error values

 kernel/ptrace.c                               |  4 ++
 .../selftests/ptrace/set_syscall_info.c       | 51 +++++++++++++++++++
 2 files changed, 55 insertions(+)


base-commit: 7e1392a42ea288d70a266f6553fe06f57f8647ea
-- 
2.47.3

