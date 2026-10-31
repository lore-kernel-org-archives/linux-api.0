Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=216.40.44.14
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793457026;
	b=t9U3Vp6S/2B0Of7pD7tQSjgjrDF3QlYL8SZj2URttRWLa/oeILzlkdu5N2UM9j/mjswa
	 Q720XyV+A6Dr2PGwFsMlR2hYb/47sCKjfMJa84w66LDkJ+/D5pEcQy+gUksk3rRGz05Ge
	 3rOJENMAcAG8XYMz+Gr2cgIBUzsH9pBaBUu+em3JpHtV1sZnGU7q44lV/0TbBX8bQzMXT
	 PMLuGrGFW+BKnmbMx8PVF7Sny8Sta5E7inqEPXU/hMLZvz2u0v4MNAHr6MZ8UkCytmWuN
	 FQfTIGJ/UZHyM0UqJkTKrqwjw6yX2F+lV1ovcrAuCj7q1TxdLaBnnBAfZRdDtFEcVbQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793457026;
	h=DMARC-Filter:Received:Received:Date:From:To:Cc:Subject:Message-ID:
	 In-Reply-To:References:X-Mailer:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:X-Rspamd-Server:X-Rspamd-Queue-Id:
	 X-Stat-Signature:X-Spam-Status:X-Session-Marker:X-Session-ID:
	 DKIM-Signature:X-HE-Tag:X-HE-Meta;
	bh=L1IHNH1tOqh0ElrkxzuEZgOPCPQw1/dqe7tff8NfeaM=;
	b=GCLICxe6K69WtBEEBv4tO+kSkNa8FC33Du1uPo/O2kjUL+4R5wdSh4mjy93CX8J+xSdP
	 i5vr4Ee1XU6doEd8YgD7i33YELoAkGpRxE3K2wJvrl6HJFwQuczrnjQXdp+XMsRM1/9HL
	 aJI4WU1NP+pQqyvBI5JsU0EmvP2Wh4ab0wA0VQEzT3NNR4vydQlkM2D0Ro0BNCu4jQ3Ve
	 vyyBjhxPRJTG6PyF3FIDA5Y87LIjjn7rY3Jyyv5Hi1e6Os22m4fk1TJQw4Lnexb9VY+Kg
	 CSIYKmMK773Q94LKTjeYiumf+CiGusApxMYXSo0KLAEoLuClitTRU8A99iKCHPMTXjQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=goodmis.org;
	spf=pass smtp.mailfrom=goodmis.org;
	dkim=pass header.d=goodmis.org header.i=@goodmis.org header.a=rsa-sha256 header.s=dkim1 header.b=PBPr4zWR;
	arc=none smtp.remote-ip=216.40.44.14
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2B71606A31C;
	Sat, 31 Oct 2026 14:30:24 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D2B71606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=goodmis.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=goodmis.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=goodmis.org header.i=@goodmis.org header.a=rsa-sha256 header.s=dkim1 header.b=PBPr4zWR
Received: from omf20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 4935E14099B;
	Sat, 31 Oct 2026 14:30:14 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: rostedt@goodmis.org) by omf20.hostedemail.com (Postfix) with ESMTPA id 0384720028;
	Sat, 31 Oct 2026 14:30:09 +0000 (UTC)
Date: Sat, 31 Oct 2026 10:30:08 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: David Laight <david.laight.linux@gmail.com>
Cc: =?UTF-8?B?QW5kcsOp?= Almeida <andrealmeid@igalia.com>, Peter Zijlstra
 <peterz@infradead.org>, Juri Lelli <juri.lelli@redhat.com>, Vincent Guittot
 <vincent.guittot@linaro.org>, Christian Brauner <brauner@kernel.org>, Kees
 Cook <kees@kernel.org>, Shuah Khan <shuah@kernel.org>, willy@infradead.org,
 mathieu.desnoyers@efficios.com, Linus Torvalds
 <torvalds@linux-foundation.org>, akpm@linux-foundation.org, Yafang Shao
 <laoar.shao@gmail.com>, andrii.nakryiko@gmail.com, arnaldo.melo@gmail.com,
 Petr Mladek <pmladek@suse.com>, linux-kernel@vger.kernel.org,
 kernel-dev@igalia.com, linux-mm@kvack.org, linux-api@vger.kernel.org,
 linux-trace-kernel@vger.kernel.org
Subject: Re: [PATCH v8 2/6] treewide: Replace memcpy(..., current->comm)
 with copy_task_comm()
Message-ID: <20261031103008.6849760c@gandalf.local.home>
In-Reply-To: <20261030223435.0e802eb7@pumpkin>
References: <20261030-tonyk-long_name-v8-0-c9b030332254@igalia.com>
	<20261030-tonyk-long_name-v8-2-c9b030332254@igalia.com>
	<20261030223435.0e802eb7@pumpkin>
X-Mailer: Claws Mail 3.20.0git84 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Post: <mailto:linux-api@vger.kernel.org>
List-Help: <mailto:linux-api+help@vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-api+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspamout02
X-Rspamd-Queue-Id: 0384720028
X-Stat-Signature: i41crhwziuyr3iypubash458fx7ndnz1
X-Session-Marker: 726F737465647440676F6F646D69732E6F7267
X-Session-ID: U2FsdGVkX19PtJe/63eTC/xkaNfGiJ5uBmq6C/NDxGc=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=goodmis.org; h=date:from:to:cc:subject:message-id:in-reply-to:references:mime-version:content-type:content-transfer-encoding; s=dkim1; bh=L1IHNH1tOqh0ElrkxzuEZgOPCPQw1/dqe7tff8NfeaM=; b=PBPr4zWR7xVHQn7lESfrz+Z1k17LvdUKBJmd2JiZzRU1ujzKeO/PrCrGKGtiwiDF5DLaYsAiiQQNfvl8+m7MVwHesisvOoYWP38K5QcNZctHRcGRLZWBeIKzL3bXzxWQhtIeVG9ptEHsI1JSApLrFLUAEMfvHs1zMpQ/KilPFY4=
X-HE-Tag: 1793457009-500293
X-HE-Meta: U2FsdGVkX1+c070Bb41la7t5jN1BzuwNBvpfmTjGU4SkaREpJRXrGLs7S8FI42GHbjriLE/xEuJ5Auuyk4NWkxHcvVv1VEM3mLXOs5T70MxInifBc+GQ96BONclagQH1D+0PZuikD+2lnCVmIYMoxylnYzJSoASeydma1oSFAyF00NPjCIo+BnZjFzGTYnScxuLxJXwH5blA0wGD9LBWOl8fLRUkt/B5BlpfHgiFxsoIN0HSPEZ7vY1Z1BvuTrKEgD+gOECzIPifjoMyxeGTN1xLr7WXtvxc/17+8WTz0VMW2Z+EqFGGjL9uMHfno3NQpDvZMFP23xaBmE3P7h8wAEJ7XvVIyI3s

On Fri, 30 Oct 2026 22:34:35 +0000
David Laight <david.laight.linux@gmail.com> wrote:

> I suspect the trace code would be faster it is just copied the (first)
> 16 characters and worried about whether it was terminated later on.
> It does far more 'saves' than trace reads and their performance is
> much more important.

I'm assuming that the compiler would optimize:

+/*
+ * Copy task name to a buffer. Final result is always a NUL-terminated string.
+ */
+static __always_inline void copy_task_comm(char *dst, struct task_struct *tsk, size_t len)
+{
+	const char *_src = tsk->comm;
+	size_t _len = min(len, TASK_COMM_LEN);
+
+	if (!_len)
+		return;
+
+	memcpy(dst, _src, _len);
+	dst[_len - 1] = '\0';
+}
+

to basically:

	memcpy(dst, src, _len);
	dst[_len - 1] = '\0';

Where it already figured out _len at build time. Adding a single write of
the nul byte without any branches would likely be a couple of cycles at
max. It's all hot cache (from the memcpy) and writing a immediate.

I'm not worried that one line will cause any measurable overhead to the
tracing.

-- Steve
