Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=130.136.161.50
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794756438;
	b=19fFR4JMyDfwDAL2+8EtVm13yH63KOQ5AV9AtjYR6u+teWuVeNz3VOOTiMaF/wxHnZOk
	 fgbphYJhLUi+d6JrKpb+bgz4ngrdgYFNm4BTXTlsujMGwlduSx2Sia9Kx7VW4z2WylIc4
	 ZnLHA+FOlymPtRZwpWFp7QlmS8l5+zarv/iYl0vw88PjC+kNcOcGWxnzQFHjSRuLyYjTI
	 FW1iwiEzCO7fY6PcwGjefX7JT4Orqv81E0YRe/sKNTzgILZB2xvnZezWuI92SP3YAN0LX
	 CUTvkaCag4feQa2rlgmKiwqtyx1X0sxNW9EQ0kkYKmQ704by6dtQTrUu1wcqW15N2qA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794756438;
	h=DMARC-Filter:Received:DKIM-Signature:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=Jqs5mGHWqZhkPcXA6vkQe/a5jCyc1cIZkVLVyXhIyDk=;
	b=kN2Fn7RBrQUU9j1JyKi509q853RKoF7dgOibTz/oRDoVS+ucliF/m2jnlP8UWSMp0xkZ
	 7nWPRUobekphEB0/0/6OvxN5DTZ4klMYQTkGzRQdm8My4Xr0FIASQnJGNNFWtYCLDQskd
	 albXyEWBT2ZqLwYvQXv+W1RET6PhLzrLCVWhN6/1BhZ2+VNh9WOxWscQ01gpb2FSH8MYc
	 ROolhpQc/Gquj/Yoflepq6kZhwzktk9vpq0xZS6fukWnte3gKcQpp2cKXePRmLsAzVwgx
	 30OYXN2PArWIww2/PIP+Q6zVtDEMgzN+0iD/mZUXAqQV2s5/7g+kNUbai8/vE0HYS8w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=cs.unibo.it;
	spf=pass smtp.mailfrom=cs.unibo.it;
	dkim=pass header.d=cs.unibo.it header.i=@cs.unibo.it header.a=rsa-sha256 header.s=virtlab header.b="wV1hSr/u";
	arc=none smtp.remote-ip=130.136.161.50
Received: from mail.virtlab.unibo.it (mail.virtlab.unibo.it [130.136.161.50])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 124A2606A31E;
	Sun, 15 Nov 2026 15:27:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 124A2606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cs.unibo.it
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cs.unibo.it
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=cs.unibo.it header.i=@cs.unibo.it header.a=rsa-sha256 header.s=virtlab header.b=wV1hSr/u
Received: from eipi10.cs.unibo.it (unknown [94.32.99.206])
	by mail.virtlab.unibo.it (Postfix) with ESMTPA id DB5AD1C025B;
	Sun, 15 Nov 2026 16:27:15 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=cs.unibo.it;
	s=virtlab; t=1794756436;
	bh=byz3CRUOvsFL0LQAtZ5XZxH1hZQWgzGyJoVd5UlRfLE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wV1hSr/uoPCv1YVpVHsAbD2S2ZPhQmYqFkTvs+vmoRHc2jmIxPBSZ7SIlUMcfc03Q
	 ymD38bvH1kC+CmE6+EBrwSshro1AY/LhFHbBptjOSleNtfVW64SrwgOKzSt6J+zlfg
	 kE/XkkDMg0v643HPsh2CWGQ7sySdOMy8a+s1GykI=
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
Subject: [PATCH v3 1/2] ptrace: reject out of range error values in PTRACE_SET_SYSCALL_INFO
Date: Sun, 15 Nov 2026 16:26:59 +0100
Message-ID: <20261115152703.416254-2-renzo@cs.unibo.it>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261115152703.416254-1-renzo@cs.unibo.it>
References: <20261115152703.416254-1-renzo@cs.unibo.it>
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

Reject with -ERANGE any error value outside [-MAX_ERRNO, -1].

Fixes: 26bb32768fe6 ("ptrace: introduce PTRACE_SET_SYSCALL_INFO request")
Reviewed-by: Dmitry V. Levin <ldv@strace.io>
Reviewed-by: Bradley Morgan <bradley.morgan@linux.dev>
Signed-off-by: Renzo Davoli <renzo@cs.unibo.it>
---
 kernel/ptrace.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/kernel/ptrace.c b/kernel/ptrace.c
index 3f2fe68ccb14..1ffacfcef8d4 100644
--- a/kernel/ptrace.c
+++ b/kernel/ptrace.c
@@ -1111,6 +1111,10 @@ ptrace_set_syscall_info_exit(struct task_struct *child, struct pt_regs *regs,
 	if (rval != info->exit.rval)
 		return -ERANGE;
 
+	/* An error must be a negative errno value. */
+	if (info->exit.is_error && (rval < -MAX_ERRNO || rval >= 0))
+		return -ERANGE;
+
 	if (info->exit.is_error)
 		syscall_set_return_value(child, regs, rval, 0);
 	else
-- 
2.47.3

