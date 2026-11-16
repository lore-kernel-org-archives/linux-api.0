Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=130.136.161.50
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794836471;
	b=bMY20vfiNiWIwNj6qBCPhaEcFLr3d0lVIVGB9ZL1Agb8liX905MOjou7Ecl0gKNOtgTk
	 iMUsNewbxzxW+M+lZLxJETpVBgSroZk57BnByuJVTjirWSI3Fh2G8Q2obCwMhRCyLuz6/
	 OCqTQkTaYEPaHg/iSsbYBT2mwEWSG9YJMrsSRXA4uqlix8Uz576h0/XhbOVeJ8BvIw4v2
	 JzhS1bLl2tAbvkmcJM6VACAPPZejOf+1euM7jNYGgk34JC1DcuzikLMJtq/ztIka9M9UP
	 yGGGKy0VbZoWEpzi8Ze5WTGwcAhr9ka8dhViG6JF1neZjLcRQKllrhpGD38oPT73CDQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794836471;
	h=DMARC-Filter:Received:DKIM-Signature:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=R8tr+IuT4LpsZfgPjh3KVNNJkLcBaui1JniAUqCvoT0=;
	b=r8mfr61ifHPM88qOZXFHEBfVLMDaVlA1KXbfOXYFgpIpnb2arYWWGUOpfFgZ6gIlOfsu
	 rl5Fjd1udm8/kZV8IlnNB4y+sbME7VveMP8fpWZzbUdd5o67HNsO0Lzh+0XTJ0qltmb4d
	 bqdfLrOwb6hZ6TAjJcmxbVrGbY0QU/XNtML0Lm9Mm3xeCLxlfgCZywdjhs08REI7sYvAY
	 lqOVK8lzRbXP0AHTgfJb+oD9m/umCdKvwIwKAPIfaQDLk7fjQwgHJuVEkfyfKnqOQun94
	 /Aagsit0OAhOZqJPGSX2fWne/BDaNbxPgONmq1jIcuLzq6fGpQb9nQckMXiVez/MHzg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=cs.unibo.it;
	spf=pass smtp.mailfrom=cs.unibo.it;
	dkim=pass header.d=cs.unibo.it header.i=@cs.unibo.it header.a=rsa-sha256 header.s=virtlab header.b=GtxmugVi;
	arc=none smtp.remote-ip=130.136.161.50
Received: from mail.virtlab.unibo.it (mail.virtlab.unibo.it [130.136.161.50])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8BB58606A32A;
	Mon, 16 Nov 2026 13:41:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8BB58606A32A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cs.unibo.it
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cs.unibo.it
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=cs.unibo.it header.i=@cs.unibo.it header.a=rsa-sha256 header.s=virtlab header.b=GtxmugVi
Received: from eipi10.cs.unibo.it (renzopb-wl.cs.unibo.it [130.136.2.252])
	by mail.virtlab.unibo.it (Postfix) with ESMTPA id 7E3ED1C0253;
	Mon, 16 Nov 2026 14:41:02 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=cs.unibo.it;
	s=virtlab; t=1794836462;
	bh=j0+EYF6bFzY3Rp+McJRXx4s8P0WrOL7NddiP+a0X5D4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GtxmugViDp9Jx2BG3SbyjxzC5nquN4fGnQszpoRxky10/0adeQNbJL0N2A8QiP0P5
	 8MIObmIPBdzQjISNsv/g/ZyTLiWHmJv4vMOpfgmdMIhB8c41Oxw6Gx8ovqvAbqTBIC
	 eDwX4PGeRApBkjPhfvHcJ797CdqzfuDDO5pxTZuI=
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
Subject: [PATCH v4 1/2] ptrace: reject out of range error values in PTRACE_SET_SYSCALL_INFO
Date: Mon, 16 Nov 2026 14:40:45 +0100
Message-ID: <20261116134050.505355-2-renzo@cs.unibo.it>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261116134050.505355-1-renzo@cs.unibo.it>
References: <20261116134050.505355-1-renzo@cs.unibo.it>
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
index 3f2fe68ccb14..7d51cb60c091 100644
--- a/kernel/ptrace.c
+++ b/kernel/ptrace.c
@@ -1111,6 +1111,10 @@ ptrace_set_syscall_info_exit(struct task_struct *child, struct pt_regs *regs,
 	if (rval != info->exit.rval)
 		return -ERANGE;
 
+	/* An error must be a negative errno value. */
+	if (info->exit.is_error && !IS_ERR_VALUE(rval))
+		return -ERANGE;
+
 	if (info->exit.is_error)
 		syscall_set_return_value(child, regs, rval, 0);
 	else
-- 
2.47.3

