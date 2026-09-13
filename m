Received: from lb2.peda.net (peda.net [130.234.6.153])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 771CE3F58F7;
	Sun, 13 Sep 2026 19:44:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=130.234.6.153
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789328698; cv=none; b=sT8h647ducVtj2Iah7JbZBEvs4xQ9AVE31+8AaiDsxFS6IeYMM7k5sqZNbMhRfhBjt1cGnSEbknlbfZZ9xA8+D8FggP7Ml2gW3JQdOqFctnEjnZSYPsa+owqh/Dovyp9WfKFwkwK46Vz4a/NTl5HAOjrQh7euDrPPi7jlvedh3w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789328698; c=relaxed/simple;
	bh=Mbb4aMUKu+Xi5NIfK9BCI+WrSQGYSYx12PMLm1XHvHg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=k/16Yeto3xwTWAOLTCCUeDvghxi0qw3h5TTRJ79jSJYD6N9ei8ZM0v6efQUGNY+jZw8FWhLbicMh73aGLY3uId16Ec+wD0/qB9yAKmZXMXV86nzPRaK0nMfPVG++IyI030TMEYVGJfMR6Y6xdIhdqTaLSFG1j3dp/hl6jc+D6EI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=peda.net; spf=pass smtp.mailfrom=peda.net; dkim=pass (2048-bit key) header.d=peda.net header.i=@peda.net header.b=ZuDQOP8p; arc=none smtp.client-ip=130.234.6.153
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=peda.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=peda.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=peda.net header.i=@peda.net header.b="ZuDQOP8p"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=peda.net; s=default;
	t=1789328333; bh=Mbb4aMUKu+Xi5NIfK9BCI+WrSQGYSYx12PMLm1XHvHg=;
	h=From:To:Cc:Subject:Date:From;
	b=ZuDQOP8p1keo72CPNQd3mHGHLpzSPUOemwXmRbEC5FP/58lBrt+8JesivtRwI0m+E
	 Lw3CCKeULmSL+tw9LjlxQ8Qy5t1kldJO8sAkq7aVmUk8ktCPlHhuu+LJXf3JfUaKST
	 pywD7Y9t/GptI+Za+xTOOtD47trEQjruJDnU2wZINtiWXoivXAyKMvjRqcFaH0hN7h
	 5uAxBmS+4dmOzb6OrpP+XWbRS1JyXM5ZbOLs6671u+WG83vIm1rmsYDh9RZe58/eBW
	 Iawg6E38GV5vZNWDcjfibSfsFhKbJvQmChAVSnlHaKLmeCbUN51Uea067WhEbohMy+
	 1M5ovpf4V4FnQ==
Received: from desktop.lounea.fi (86-60-167-233.dynamic.lounea.fi [86.60.167.233])
	by lb2.peda.net (lb2.peda.net) with ESMTPSA id 921E3D600C1;
	Sun, 13 Sep 2026 22:38:53 +0300 (EEST)
From: Mikko Rantalainen <mikko.rantalainen@peda.net>
To: linux-fsdevel@vger.kernel.org
Cc: linux-api@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	brauner@kernel.org,
	viro@zeniv.linux.org.uk,
	jack@suse.cz,
	alx@kernel.org,
	dalias@libc.org,
	Mikko Rantalainen <mikko.rantalainen@peda.net>
Subject: [RFC PATCH 0/1] close(): stop exposing non-retryable EINTR
Date: Sun, 13 Sep 2026 22:38:14 +0300
Message-ID: <20260913193815.2862366-1-mikko.rantalainen@peda.net>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This is an RFC because it deliberately changes a long-established raw
syscall ABI. Jan Kara raised userspace-regression concerns when this was
discussed in 2025:

    https://lore.kernel.org/linux-fsdevel/ddqmhjc2rpzk2jjvunbt3l3eukcn4xzkocqzdg3j4msihdhzko@fizekvxndg2d/

while musl and Android bionic already normalize this result to success
in libc.

The Linux implementation of close() will always close the file descriptor
given as argument, except for the invalid file descriptor which will
return -EBADF.

However, currently Linux kernel will return EINTR in some cases for
close(). There is no good way for caller to recover from this case using
the original fd. Whatever action was actually interrupted cannot be
resumed or retried through this fd, because the fd has already been
consumed. Even worse, EINTR conventionally invites retrying an operation,
but retrying close() is unsafe: the same file descriptor number may
already refer to another file opened by another thread by the time
close() returns EINTR.

In addition, POSIX.1-2024 requires that if close() reports EINTR, the
descriptor must remain open. It also explicitly permits an interrupted
close() to return success after closing the descriptor.

This patch is about implementing the second option to be compatible with
both POSIX.1-2024 and real-world applications.

Since close() on Linux first relinquishes the file descriptor and only
then performs ->flush() work, interruption of that later work cannot be
recovered through the original fd. No matter how important that
close-time work was, ownership of the fd has already been irrevocably
relinquished.

For regular files, applications requiring durability already need an
explicit synchronization operation such as fsync() or fdatasync() before
relinquishing the fd. This proposal does not suppress meaningful
delayed-I/O errors such as EIO, ENOSPC, or EDQUOT; it only changes
interruption results whose conventional recovery action (retrying the
operation) is unsafe for close().

Historical discussions about this subject:

- https://inbox.sourceware.org/libc-alpha/efaffc5a404cf104f225c26dbc96e0001cede8f9.1747399542.git.alx@kernel.org/T/

- https://sourceware.org/pipermail/libc-alpha/2025-May/166675.html

- https://lkml.rescloud.iu.edu/hypermail/linux/kernel/2205.3/06731.html

- https://lwn.net/Articles/576478/

- https://yarchive.net/comp/linux/must_check.html

- https://sourceware.org/pipermail/libc-alpha/2025-May/166907.html

- https://sourceware.org/pipermail/libc-alpha/2025-May/166722.html


POSIX.1-2024 also allows EINPROGRESS after the descriptor has been closed.
I considered using that result, but it appears less useful than success
for Linux. It would preserve diagnostic information about interrupted
close-time work, but there is no operation the caller can perform on the
original fd to resume or complete that work. It would therefore turn an
irrevocably completed ownership transfer into an apparent failure without
providing a recovery path. Returning success avoids that ambiguity and
still leaves genuinely useful delayed-I/O errors such as EIO, ENOSPC, and
EDQUOT untouched.

This also matches the direction taken by musl, which initially used
EINPROGRESS for this case and later changed to success because existing
applications were prone to interpret EINPROGRESS as a failure and could
incorrectly infer that the fd was still open.

Automatically replacing EINTR with success does change the *observable*
raw syscall ABI for applications that distinguish EINTR from successful
close(). For applications that already treat the descriptor as consumed,
this changes control flow to the normal successful-close path. I would be
particularly interested in concrete examples where distinguishing EINTR
provides useful recovery semantics, given that the original fd has
already been consumed and cannot be used to resume the interrupted
close-time work.

Mikko Rantalainen (1):
  fs: don't return EINTR from close()

 fs/open.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

-- 
2.43.0

