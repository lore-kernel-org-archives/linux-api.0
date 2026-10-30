Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.47
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793399679;
	b=nF6vls50yj6Jmb0GE6SZUn136x6n7PC6hUYSHt4OekFFH1LQh2RxjUq1oujUS34ie4Me
	 OBSJ5jmgNZQct2eJtBa7bg4jldBt4YRWh8tjHjtj4tCcFLy0xaHP7pu+tgyGYbuQjSiSa
	 TAdIBUiKIVK7ums3+4uf+A8zFyC/tKtsgAvQ1h7vDFW0hHL2kWGERJk2dY+nBvu5vkpCp
	 OkIhY53JQohkCtGlbA17ESi9e1JWixqhRse3Z/joNtkYj9ThlQDvP2skJuYVdZCpV5SXy
	 n9gxyS6t6L1GhNjz9/V/Du6WzjShv6t1wijEajT27l3gDJP4oJ2vomWkOKIeQyqGSyg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793399679;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=2f8T8U81pT6wJiYZ20wPG7me1u2dTv4P3a8KjTdXm9I=;
	b=F6aYMlHtecWxEDKcMLhqRCt+54+5M8WkI78njrmkRSJ9yaoHl/ZaTKpgXAkgI1EjV1nC
	 361ZQE0a//IVB5oPwj4M6agBR2jRSfc0uNZMFqzcKv8NoSf8SQuWikl++4A1RzevErn30
	 MMDba3Ps4Ep5y84iG1UyhQ1bdHHMipXK45my/DPqt3v/VOleUh/HqCgBfVrgqFQyJ8M0D
	 YvoqCuMLodjSyCC+SQPnkJRICNFOo7hBtUSBLQKE4XW1tIfTqhs01Hhxadv3GNsCzi549
	 xEtvS7Q1dgvFdDjt8PUPG4mcxah9tUSgWWuXWinjH6oC7j/UFrg6aQoaX/dSW86fy+Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=yZsl0n+3;
	arc=none smtp.remote-ip=209.85.128.47
Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27842606A31D
	for <linux-api@vger.kernel.org>; Fri, 30 Oct 2026 22:34:39 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 27842606A31D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=yZsl0n+3
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-4a2153c8525so8156705e9.3
        for <linux-api@vger.kernel.org>; Fri, 30 Oct 2026 15:34:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793399677; x=1794004477; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=2f8T8U81pT6wJiYZ20wPG7me1u2dTv4P3a8KjTdXm9I=;
        b=yZsl0n+3eoiMCC9gov02cFeD/S5qhHwwzxe16OxOU5HzsJHErzZkBM20iunOOE+BrS
         FNdN3R0wuGENe82mBV6ik9cdd4yBkKUJJC73dGBx/9P4UoSb+zOiLy0k4CR2+79bKEju
         mSpHtEYOzFAa7Xxz/aHh5i1L85B677kmUGKGWA49gjvZ5LklFcR5MPzIzADf53FFhsHT
         PPwNzPCClxPLkDxI9l99PDGbj+TDLfi1m5aLdipF6z5rlABQ+IMsWTKsQJC/y+hAfpHR
         j6j26NUP10vMYV9p2nLGSye4mOMJD+K1pUK0kixDSLSBPgCblV8q8DvJRNUJIpGQZGUN
         lYxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793399677; x=1794004477;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=2f8T8U81pT6wJiYZ20wPG7me1u2dTv4P3a8KjTdXm9I=;
        b=cv9+Ug+ICpEijFQTD2lJ6tL6c8j5fekBCQC/CgyKI4FK9CdcABJUAWGX+KlbltaZn6
         uhFmWvoE1q+61PdsquMbgif4P3fxLMuUrt9WMP2Txpyk/xMVwPrtpo7CNB7tThPRq7XP
         ZrzpbJaZJtqGnjzWdVre5MbXNrpEX5Cb7VnDyYbm+Jj4gbvFvtnEq89ohtK+6Y/7TQRQ
         DXqg/2yCk6MYzYITfMlN8FfnhYOnZlPLcX7pGm/5tyaXgBxbzvSlKVdfBnAT+GCBQYvp
         bsrATaqvRF+AnTPpgk/+ynQKSw0lmXa0kfdciqki5+8QkjgpkhVQtvp+7b3m7zFH3GJB
         mRmw==
X-Forwarded-Encrypted: i=1; AKwUvBzMycFi0Pmq1lA7vVmUmIdtIFuIT/hrlt4B85uwJkP5YE5Ivev5Sw77+lTkk5EOtCY3tvYvPc+y8/g=@vger.kernel.org
X-Gm-Message-State: AFq9FYLH79/TyL/Z+MjT8Ak2GvJ1fwQyl5xa6BvbXwDO0cJSZnbTO0r3
	G3Ma1H1C8JMJNMvB5mUZjNniRweomGwVEwZDGFEY+l3eU77TNNL3ikv6
X-Gm-Gg: AYBFou0+Xh9cCcXHIX7/85Hs5P6KRyRb0rjXbptBNeTSVbt41efEuY59e3lKoG/KHNj
	daLHCH5lqk78xeUP0c8cVDYwG+OVm73DvtI2Mr5RC6z9mlfAoKKtX4dl1cOcGeO/tlGqeN67hIz
	ql8MsjmIlNDmXT5a6bQr90DOoHSoKYrbCLROh39YL06RJ9hzf/Vo9i9rzUWTk8SuLTKLnLMGwiU
	fOW+bDkkjNjod78wVTzy9DKLdtYgTEn5lLPPF+wPhkP6oVKVvajyzZFaFhN9uUbczbSHBs1X1Me
	+hi9F0LtSYtHMJDJAPdd0XJYNfd1XVxyiwU76qa3blWjnK9y8JEwUbyGlaxDjNG7am8onY6V1VY
	lqcyPKYdcduIuzbmVsguf84r/i0Li+ok+I7TVfqbhYNMu2BeWUatck1llY/se+/tiO4jt7wHatE
	g9AQaYawVI9So4kS9Xlm6BIM7xbMoDKOAdNOVFaWnwXU+DQ08AfbfSQBV8z+ymACxQJ2/6BKBTy
	vdfCtrNi4ad1rz+wlUCc4btUwITp64gAmPGYaRBRcCMY6xtkHdV0adF06SFm2iXckNQyVk+eHpa
	U8tme4+fdaFeqlz8INv/RzwGQtbyECDN5QUO2gLBEb7NhGFwhgAB4HPyIdIh7LcaE+mOOs5dqAt
	A2oXZhCHnJBY=
X-Received: by 2002:a05:600c:4e41:b0:4a6:42cc:bf6c with SMTP id 5b1f17b1804b1-4ac16acfbd0mr76349985e9.7.1793399677342;
        Fri, 30 Oct 2026 15:34:37 -0700 (PDT)
Received: from pumpkin (82-69-66-36.dsl.in-addr.zen.co.uk. [82.69.66.36])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4aa81a896fesm183306595e9.10.2026.10.30.15.34.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Oct 2026 15:34:36 -0700 (PDT)
Date: Fri, 30 Oct 2026 22:34:35 +0000
From: David Laight <david.laight.linux@gmail.com>
To: =?UTF-8?B?QW5kcsOp?= Almeida <andrealmeid@igalia.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Juri Lelli
 <juri.lelli@redhat.com>, Vincent Guittot <vincent.guittot@linaro.org>,
 Steven Rostedt <rostedt@goodmis.org>, Christian Brauner
 <brauner@kernel.org>, Kees Cook <kees@kernel.org>, Shuah Khan
 <shuah@kernel.org>, willy@infradead.org, mathieu.desnoyers@efficios.com,
 Linus Torvalds <torvalds@linux-foundation.org>, akpm@linux-foundation.org,
 Yafang Shao <laoar.shao@gmail.com>, andrii.nakryiko@gmail.com,
 arnaldo.melo@gmail.com, Petr Mladek <pmladek@suse.com>,
 linux-kernel@vger.kernel.org, kernel-dev@igalia.com, linux-mm@kvack.org,
 linux-api@vger.kernel.org, linux-trace-kernel@vger.kernel.org
Subject: Re: [PATCH v8 2/6] treewide: Replace memcpy(..., current->comm)
 with copy_task_comm()
Message-ID: <20261030223435.0e802eb7@pumpkin>
In-Reply-To: <20261030-tonyk-long_name-v8-2-c9b030332254@igalia.com>
References: <20261030-tonyk-long_name-v8-0-c9b030332254@igalia.com>
	<20261030-tonyk-long_name-v8-2-c9b030332254@igalia.com>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; arm-unknown-linux-gnueabihf)
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Post: <mailto:linux-api@vger.kernel.org>
List-Help: <mailto:linux-api+help@vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-api+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Fri, 30 Oct 2026 18:38:33 -0300
Andr=C3=A9 Almeida <andrealmeid@igalia.com> wrote:

> In order to increase the size of current->comm[] and to avoid breaking any
> existing code, replace memcpy() with copy_task_comm(). This new function
> makes sure that the copy is NUL terminated. This is crucial given that the
> source buffer might be larger than the destination buffer and could
> truncate the NUL character out of it.

I suspect the trace code would be faster it is just copied the (first)
16 characters and worried about whether it was terminated later on.
It does far more 'saves' than trace reads and their performance is
much more important.

David

>=20
> Signed-off-by: Andr=C3=A9 Almeida <andrealmeid@igalia.com>
> Acked-by: Steven Rostedt <rostedt@goodmis.org>
> ---
> Changes from v4:
>  - Remove copy_task_comm() calls for structs other than struct task_struct
>  - Add checks for len > TASK_COMM_LEN and len < 0
>=20
> Changes from v3:
>  - Simplify copy_task_comm() to a memcpy + NUL char at the end of buffer
>=20
> Changes from v2:
>  - Bring back custom function.
>=20
> Changes from v1:
>  - New patch, dropped strtostr() from last version
> ---
>  include/linux/coredump.h                                  |  2 +-
>  include/linux/sched.h                                     | 15 +++++++++=
++++++
>  include/linux/tracepoint.h                                |  4 ++--
>  include/trace/events/block.h                              | 10 +++++-----
>  include/trace/events/coredump.h                           |  2 +-
>  include/trace/events/f2fs.h                               |  4 ++--
>  include/trace/events/oom.h                                |  2 +-
>  include/trace/events/osnoise.h                            |  2 +-
>  include/trace/events/sched.h                              | 10 +++++-----
>  include/trace/events/signal.h                             |  2 +-
>  include/trace/events/task.h                               |  4 ++--
>  .../testing/selftests/bpf/test_kmods/bpf_testmod-events.h |  2 +-
>  12 files changed, 37 insertions(+), 22 deletions(-)
>=20
> diff --git a/include/linux/coredump.h b/include/linux/coredump.h
> index 8e857770dd21..c3009edc2595 100644
> --- a/include/linux/coredump.h
> +++ b/include/linux/coredump.h
> @@ -79,7 +79,7 @@ void vfs_coredump(const kernel_siginfo_t *siginfo);
>  	do {	\
>  		char comm[TASK_COMM_LEN];	\
>  		/* This will always be NUL terminated. */ \
> -		memcpy(comm, current->comm, sizeof(comm)); \
> +		copy_task_comm(comm, current, sizeof(comm)); \
>  		printk_ratelimited(Level "coredump: %d(%*pE): " Format "\n",	\
>  			task_tgid_vnr(current), (int)strlen(comm), comm, ##__VA_ARGS__);	\
>  	} while (0)	\
> diff --git a/include/linux/sched.h b/include/linux/sched.h
> index 0564aabb1393..db529a93525d 100644
> --- a/include/linux/sched.h
> +++ b/include/linux/sched.h
> @@ -2042,6 +2042,21 @@ extern void __set_task_comm(struct task_struct *ts=
k, const char *from, bool exec
>  	__set_task_comm(tsk, from, false);		\
>  })
> =20
> +/*
> + * Copy task name to a buffer. Final result is always a NUL-terminated s=
tring.
> + */
> +static __always_inline void copy_task_comm(char *dst, struct task_struct=
 *tsk, size_t len)
> +{
> +	const char *_src =3D tsk->comm;
> +	size_t _len =3D min(len, TASK_COMM_LEN);
> +
> +	if (!_len)
> +		return;
> +
> +	memcpy(dst, _src, _len);
> +	dst[_len - 1] =3D '\0';
> +}
> +
>  static __always_inline void scheduler_ipi(void)
>  {
>  	/*
> diff --git a/include/linux/tracepoint.h b/include/linux/tracepoint.h
> index e0d838c9ce93..9b0094fa44c6 100644
> --- a/include/linux/tracepoint.h
> +++ b/include/linux/tracepoint.h
> @@ -637,10 +637,10 @@ static inline struct tracepoint *tracepoint_ptr_der=
ef(tracepoint_ptr_t *p)
>   *	*
>   *
>   *	TP_fast_assign(
> - *		memcpy(__entry->next_comm, next->comm, TASK_COMM_LEN);
> + *		copy_task_comm(__entry->next_comm, next, TASK_COMM_LEN);
>   *		__entry->prev_pid	=3D prev->pid;
>   *		__entry->prev_prio	=3D prev->prio;
> - *		memcpy(__entry->prev_comm, prev->comm, TASK_COMM_LEN);
> + *		copy_task_comm(__entry->prev_comm, prev, TASK_COMM_LEN);
>   *		__entry->next_pid	=3D next->pid;
>   *		__entry->next_prio	=3D next->prio;
>   *	),
> diff --git a/include/trace/events/block.h b/include/trace/events/block.h
> index 9c97a16850b9..1e3a9ded03bd 100644
> --- a/include/trace/events/block.h
> +++ b/include/trace/events/block.h
> @@ -213,7 +213,7 @@ DECLARE_EVENT_CLASS(block_rq,
> =20
>  		blk_fill_rwbs(__entry->rwbs, rq->cmd_flags);
>  		__get_str(cmd)[0] =3D '\0';
> -		memcpy(__entry->comm, current->comm, TASK_COMM_LEN);
> +		copy_task_comm(__entry->comm, current, TASK_COMM_LEN);
>  	),
> =20
>  	TP_printk("%d,%d %s %u (%s) %llu + %u %s,%u,%u [%s]",
> @@ -410,7 +410,7 @@ DECLARE_EVENT_CLASS(block_bio,
>  		__entry->sector		=3D bio->bi_iter.bi_sector;
>  		__entry->nr_sector	=3D bio_sectors(bio);
>  		blk_fill_rwbs(__entry->rwbs, bio->bi_opf);
> -		memcpy(__entry->comm, current->comm, TASK_COMM_LEN);
> +		copy_task_comm(__entry->comm, current, TASK_COMM_LEN);
>  	),
> =20
>  	TP_printk("%d,%d %s %llu + %u [%s]",
> @@ -493,7 +493,7 @@ TRACE_EVENT(block_plug,
>  	),
> =20
>  	TP_fast_assign(
> -		memcpy(__entry->comm, current->comm, TASK_COMM_LEN);
> +		copy_task_comm(__entry->comm, current, TASK_COMM_LEN);
>  	),
> =20
>  	TP_printk("[%s]", __entry->comm)
> @@ -512,7 +512,7 @@ DECLARE_EVENT_CLASS(block_unplug,
> =20
>  	TP_fast_assign(
>  		__entry->nr_rq =3D depth;
> -		memcpy(__entry->comm, current->comm, TASK_COMM_LEN);
> +		copy_task_comm(__entry->comm, current, TASK_COMM_LEN);
>  	),
> =20
>  	TP_printk("[%s] %d", __entry->comm, __entry->nr_rq)
> @@ -563,7 +563,7 @@ TRACE_EVENT(block_split,
>  		__entry->sector		=3D bio->bi_iter.bi_sector;
>  		__entry->new_sector	=3D new_sector;
>  		blk_fill_rwbs(__entry->rwbs, bio->bi_opf);
> -		memcpy(__entry->comm, current->comm, TASK_COMM_LEN);
> +		copy_task_comm(__entry->comm, current, TASK_COMM_LEN);
>  	),
> =20
>  	TP_printk("%d,%d %s %llu / %llu [%s]",
> diff --git a/include/trace/events/coredump.h b/include/trace/events/cored=
ump.h
> index c7b9c53fc498..fdd20bc46bb0 100644
> --- a/include/trace/events/coredump.h
> +++ b/include/trace/events/coredump.h
> @@ -32,7 +32,7 @@ TRACE_EVENT(coredump,
> =20
>  	TP_fast_assign(
>  		__entry->sig =3D sig;
> -		memcpy(__entry->comm, current->comm, TASK_COMM_LEN);
> +		copy_task_comm(__entry->comm, current, TASK_COMM_LEN);
>  	),
> =20
>  	TP_printk("sig=3D%d comm=3D%s",
> diff --git a/include/trace/events/f2fs.h b/include/trace/events/f2fs.h
> index df4cd346ae72..e3f2047f9de8 100644
> --- a/include/trace/events/f2fs.h
> +++ b/include/trace/events/f2fs.h
> @@ -2589,7 +2589,7 @@ TRACE_EVENT(f2fs_lock_elapsed_time,
> =20
>  	TP_fast_assign(
>  		__entry->dev		=3D sbi->sb->s_dev;
> -		memcpy(__entry->comm, p->comm, TASK_COMM_LEN);
> +		copy_task_comm(__entry->comm, p, TASK_COMM_LEN);
>  		__entry->pid		=3D p->pid;
>  		__entry->prio		=3D p->prio;
>  		__entry->ioprio_class	=3D IOPRIO_PRIO_CLASS(ioprio);
> @@ -2642,7 +2642,7 @@ DECLARE_EVENT_CLASS(f2fs_priority_update,
> =20
>  	TP_fast_assign(
>  		__entry->dev		=3D sbi->sb->s_dev;
> -		memcpy(__entry->comm, p->comm, TASK_COMM_LEN);
> +		copy_task_comm(__entry->comm, p, TASK_COMM_LEN);
>  		__entry->pid		=3D p->pid;
>  		__entry->lock_name	=3D lock_name;
>  		__entry->is_write	=3D is_write;
> diff --git a/include/trace/events/oom.h b/include/trace/events/oom.h
> index 9f0a5d1482c4..8bcdc4ffc8d3 100644
> --- a/include/trace/events/oom.h
> +++ b/include/trace/events/oom.h
> @@ -23,7 +23,7 @@ TRACE_EVENT(oom_score_adj_update,
> =20
>  	TP_fast_assign(
>  		__entry->pid =3D task->pid;
> -		memcpy(__entry->comm, task->comm, TASK_COMM_LEN);
> +		copy_task_comm(__entry->comm, task, TASK_COMM_LEN);
>  		__entry->oom_score_adj =3D task->signal->oom_score_adj;
>  	),
> =20
> diff --git a/include/trace/events/osnoise.h b/include/trace/events/osnois=
e.h
> index 3f4273623801..2cf047bb9fb7 100644
> --- a/include/trace/events/osnoise.h
> +++ b/include/trace/events/osnoise.h
> @@ -116,7 +116,7 @@ TRACE_EVENT(thread_noise,
>  	),
> =20
>  	TP_fast_assign(
> -		memcpy(__entry->comm, t->comm, TASK_COMM_LEN);
> +		copy_task_comm(__entry->comm, t, TASK_COMM_LEN);
>  		__entry->pid =3D t->pid;
>  		__entry->start =3D start;
>  		__entry->duration =3D duration;
> diff --git a/include/trace/events/sched.h b/include/trace/events/sched.h
> index 535860581f15..afb24e9dac91 100644
> --- a/include/trace/events/sched.h
> +++ b/include/trace/events/sched.h
> @@ -152,7 +152,7 @@ DECLARE_EVENT_CLASS(sched_wakeup_template,
>  	),
> =20
>  	TP_fast_assign(
> -		memcpy(__entry->comm, p->comm, TASK_COMM_LEN);
> +		copy_task_comm(__entry->comm, p, TASK_COMM_LEN);
>  		__entry->pid		=3D p->pid;
>  		__entry->prio		=3D p->prio; /* XXX SCHED_DEADLINE */
>  		__entry->target_cpu	=3D task_cpu(p);
> @@ -237,11 +237,11 @@ TRACE_EVENT(sched_switch,
>  	),
> =20
>  	TP_fast_assign(
> -		memcpy(__entry->prev_comm, prev->comm, TASK_COMM_LEN);
> +		copy_task_comm(__entry->prev_comm, prev, TASK_COMM_LEN);
>  		__entry->prev_pid	=3D prev->pid;
>  		__entry->prev_prio	=3D prev->prio;
>  		__entry->prev_state	=3D __trace_sched_switch_state(preempt, prev_state=
, prev);
> -		memcpy(__entry->next_comm, next->comm, TASK_COMM_LEN);
> +		copy_task_comm(__entry->next_comm, next, TASK_COMM_LEN);
>  		__entry->next_pid	=3D next->pid;
>  		__entry->next_prio	=3D next->prio;
>  		/* XXX SCHED_DEADLINE */
> @@ -346,7 +346,7 @@ TRACE_EVENT(sched_process_exit,
>  	),
> =20
>  	TP_fast_assign(
> -		memcpy(__entry->comm, p->comm, TASK_COMM_LEN);
> +		copy_task_comm(__entry->comm, p, TASK_COMM_LEN);
>  		__entry->pid		=3D p->pid;
>  		__entry->prio		=3D p->prio; /* XXX SCHED_DEADLINE */
>  		__entry->group_dead	=3D group_dead;
> @@ -787,7 +787,7 @@ TRACE_EVENT(sched_skip_cpuset_numa,
>  	),
> =20
>  	TP_fast_assign(
> -		memcpy(__entry->comm, tsk->comm, TASK_COMM_LEN);
> +		copy_task_comm(__entry->comm, tsk, TASK_COMM_LEN);
>  		__entry->pid		 =3D task_pid_nr(tsk);
>  		__entry->tgid		 =3D task_tgid_nr(tsk);
>  		__entry->ngid		 =3D task_numa_group_id(tsk);
> diff --git a/include/trace/events/signal.h b/include/trace/events/signal.h
> index 1db7e4b07c01..8fffe6d9bdcc 100644
> --- a/include/trace/events/signal.h
> +++ b/include/trace/events/signal.h
> @@ -67,7 +67,7 @@ TRACE_EVENT(signal_generate,
>  	TP_fast_assign(
>  		__entry->sig	=3D sig;
>  		TP_STORE_SIGINFO(__entry, info);
> -		memcpy(__entry->comm, task->comm, TASK_COMM_LEN);
> +		copy_task_comm(__entry->comm, task, TASK_COMM_LEN);
>  		__entry->pid	=3D task->pid;
>  		__entry->group	=3D group;
>  		__entry->result	=3D result;
> diff --git a/include/trace/events/task.h b/include/trace/events/task.h
> index b9a129eb54d9..e3faaeb997ef 100644
> --- a/include/trace/events/task.h
> +++ b/include/trace/events/task.h
> @@ -21,7 +21,7 @@ TRACE_EVENT(task_newtask,
> =20
>  	TP_fast_assign(
>  		__entry->pid =3D task->pid;
> -		memcpy(__entry->comm, task->comm, TASK_COMM_LEN);
> +		copy_task_comm(__entry->comm, task, TASK_COMM_LEN);
>  		__entry->clone_flags =3D clone_flags;
>  		__entry->oom_score_adj =3D task->signal->oom_score_adj;
>  	),
> @@ -46,7 +46,7 @@ TRACE_EVENT(task_rename,
> =20
>  	TP_fast_assign(
>  		__entry->pid =3D task->pid;
> -		memcpy(entry->oldcomm, task->comm, TASK_COMM_LEN);
> +		copy_task_comm(entry->oldcomm, task, TASK_COMM_LEN);
>  		strscpy(entry->newcomm, comm, TASK_COMM_LEN);
>  		__entry->oom_score_adj =3D task->signal->oom_score_adj;
>  	),
> diff --git a/tools/testing/selftests/bpf/test_kmods/bpf_testmod-events.h =
b/tools/testing/selftests/bpf/test_kmods/bpf_testmod-events.h
> index 45a5e41f3a92..a197622e113c 100644
> --- a/tools/testing/selftests/bpf/test_kmods/bpf_testmod-events.h
> +++ b/tools/testing/selftests/bpf/test_kmods/bpf_testmod-events.h
> @@ -20,7 +20,7 @@ TRACE_EVENT(bpf_testmod_test_read,
>  	),
>  	TP_fast_assign(
>  		__entry->pid =3D task->pid;
> -		memcpy(__entry->comm, task->comm, TASK_COMM_LEN);
> +		copy_task_comm(__entry->comm, task, TASK_COMM_LEN);
>  		__entry->off =3D ctx->off;
>  		__entry->len =3D ctx->len;
>  	),
>=20

