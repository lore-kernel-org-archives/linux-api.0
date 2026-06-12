Received: from fanzine2.igalia.com (fanzine2.igalia.com [213.97.179.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 773F73D171F;
	Fri, 12 Jun 2026 16:20:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.97.179.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781281253; cv=none; b=t8W0SCEiW2ebC7igIhoWXVd45F+rcF8um9Gs3AcUzW6Zbq+qocDHdBDJkghWl83Xo5CvkT5ITxcrszBSeAnjVcJHcp4SphTNSSAodD90CR5SFsyO7cDXx3vwrbtxXVSCaMoeR9Oq/0V6HB0NWJUoApinX3yCMaUgnY7Ny6NcfDM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781281253; c=relaxed/simple;
	bh=D3riEiQCFl1ODn9tbvXDDWHsiwUs95xAILXdhqFmYVI=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=HLzdWfjUIb8fSgXtsIDvgi49MnMdL+EWVzXm4tk9e4KdWncZUo2XqF4NP4EVxiMNigMsV8n44eiqV13gwfRhTwg7zXqgDJYIqlZjB7UJLKZGEVRdrG8TH6SSHRLAgf7VVuuL34c+db0l6Kihx+Xkqa+085Hq+D/SsiYjevZlLfE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=igalia.com; spf=pass smtp.mailfrom=igalia.com; dkim=pass (2048-bit key) header.d=igalia.com header.i=@igalia.com header.b=Kks4Atna; arc=none smtp.client-ip=213.97.179.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=igalia.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=igalia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=igalia.com header.i=@igalia.com header.b="Kks4Atna"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=igalia.com;
	s=20170329; h=Cc:To:In-Reply-To:References:Message-Id:
	Content-Transfer-Encoding:Content-Type:MIME-Version:Subject:Date:From:Sender:
	Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender
	:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=zIYT/HNuvNJd7wtW3If1BoiCZk6EJ/pRukABWxJMOZ0=; b=Kks4AtnaYNx5nZiKCxP06Gd/Da
	Qf+VvfXREYGa3t5XvOfINjONUHMCCj9e2AE2gV5le9ZHaUyg1b9WY6XdCxGMO2iGdknHEo5SoPYZC
	jhPJKC4XE0xxTwrGKstcKNvDNeJzVS4TsL4dlY7Al09sb6k1aIXwnjFbLFZdp8KFQwzcW2RAv2Yvy
	QZovYPDtSm/XbnzJlaKTtWxUk5LyvBFubqs+99yIVAuj+WB6hT/QVkr+PHKMnXRtJnkpcsf0I7W9C
	8TL8E3nW4CStXph3Ly9jbvtIep6a5eSaYr+B522k8ocAYNUEc5Z7QLDNF9zXK0hd6xpbHUfJzVLQB
	ok+wvfrw==;
Received: from [189.78.222.70] (helo=[192.168.15.100])
	by fanzine2.igalia.com with esmtpsa 
	(Cipher TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256) (Exim)
	id 1wY4ca-00GgP4-2B; Fri, 12 Jun 2026 18:20:40 +0200
From: =?utf-8?q?Andr=C3=A9_Almeida?= <andrealmeid@igalia.com>
Date: Fri, 12 Jun 2026 13:20:14 -0300
Subject: [PATCH v3 1/7] sched: Update get_task_comm() comment
Precedence: bulk
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20260612-tonyk-long_name-v3-1-7989b66e8a99@igalia.com>
References: <20260612-tonyk-long_name-v3-0-7989b66e8a99@igalia.com>
In-Reply-To: <20260612-tonyk-long_name-v3-0-7989b66e8a99@igalia.com>
To: Peter Zijlstra <peterz@infradead.org>, 
 Juri Lelli <juri.lelli@redhat.com>, 
 Vincent Guittot <vincent.guittot@linaro.org>, 
 Steven Rostedt <rostedt@goodmis.org>, 
 Christian Brauner <brauner@kernel.org>, Kees Cook <kees@kernel.org>, 
 Shuah Khan <shuah@kernel.org>, willy@infradead.org, 
 mathieu.desnoyers@efficios.com, David Laight <david.laight.linux@gmail.com>, 
 Linus Torvalds <torvalds@linux-foundation.org>, akpm@linux-foundation.org, 
 Yafang Shao <laoar.shao@gmail.com>, andrii.nakryiko@gmail.com, 
 arnaldo.melo@gmail.com, Petr Mladek <pmladek@suse.com>
Cc: linux-kernel@vger.kernel.org, kernel-dev@igalia.com, linux-mm@kvack.org, 
 linux-api@vger.kernel.org, 
 =?utf-8?q?Andr=C3=A9_Almeida?= <andrealmeid@igalia.com>
X-Mailer: b4 0.15.2

Since commit 3a3f61ce5e0b ("exec: Make sure task->comm is always
NUL-terminated"), __set_task_comm() no longer uses strscpy_pad(). Update
the stale comment accordingly.

Signed-off-by: André Almeida <andrealmeid@igalia.com>
---
 include/linux/sched.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 368c7b4d7cb5..60d004a49a27 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -2005,7 +2005,7 @@ extern void __set_task_comm(struct task_struct *tsk, const char *from, bool exec
  *   User space can randomly change their names anyway, so locking for readers
  *   doesn't make sense. For writers, locking is probably necessary, as a race
  *   condition could lead to long-term mixed results.
- *   The strscpy_pad() in __set_task_comm() can ensure that the task comm is
+ *   The logic inside __set_task_comm() ensures that the task comm is
  *   always NUL-terminated and zero-padded. Therefore the race condition between
  *   reader and writer is not an issue.
  *

-- 
2.54.0

