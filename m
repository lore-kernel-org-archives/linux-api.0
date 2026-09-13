Received: from lb2.peda.net (peda.net [130.234.6.153])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 772D53F5BC3;
	Sun, 13 Sep 2026 19:44:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=130.234.6.153
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789328697; cv=none; b=meFcXG4lkxmtQeVzeOOTpce2USGAg/auNWtIixBpVhLdUPIs08UhRPDqQ7/G7o/HhmU+V6YUFYqlh/y/nO5uizNWFs0CloK2oXV8XEYponjFeyUiYz9eghwBgZC8HdEXqwQ7iDpPoMWpaJ/uGJelvi464xrGNQs28Wlc0qn7d7E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789328697; c=relaxed/simple;
	bh=ZlBHZhkGDOLD+CD3y2zFyOo9c/IYkH9+Twj7kdWaW24=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QmZI8f1SOFRDiOb9GohVPfB375PiPablcRlOw2yg8TSwFIepEcyAfX4VNWwx+5RD5x+qL4eZhznwF+E3JjCL+2O8vlGbGudCB/Od0Mpfoso+kAfkXfypdxfaSUU/Yo6x85zSQGFfyV3ooFnKt10c+YK7NbXXsAsQR8cjbN03sUw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=peda.net; spf=pass smtp.mailfrom=peda.net; dkim=pass (2048-bit key) header.d=peda.net header.i=@peda.net header.b=XkchxK04; arc=none smtp.client-ip=130.234.6.153
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=peda.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=peda.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=peda.net header.i=@peda.net header.b="XkchxK04"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=peda.net; s=default;
	t=1789328333; bh=ZlBHZhkGDOLD+CD3y2zFyOo9c/IYkH9+Twj7kdWaW24=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XkchxK04lkVECPV5fQq5oNT29HIbv4FWlpO85JV/xSjvn5QvPF+C9kFLJkKcc4lon
	 ww2h2i08UZG2ldPbFlUDUnDi7tAsIjckYMi8PQ1/pJsfPmh1qZtqdjpEHa2JxT+hxl
	 9cpKPfaHygIiCG6sViM3PTjVxGyfs+zGPnwoM83Ws4cv96mII3saAQsnX6BADjLOsN
	 9IGU5eLiYkT/iecouNu/7tdCOeYuRplo6X3gNoj9nRJTP/XtBtlhHBbfA0XBnxbXlo
	 ruQuA9xnbSQwQuuLxkG6J1mhfsrLMRENBzFQQfSOvDynap5x9ULDWQ4dDfoMvN7oqS
	 +SQ6hZqgYtYIA==
Received: from desktop.lounea.fi (86-60-167-233.dynamic.lounea.fi [86.60.167.233])
	by lb2.peda.net (lb2.peda.net) with ESMTPSA id C6060D60257;
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
Subject: [RFC PATCH 1/1] fs: don't return EINTR from close()
Date: Sun, 13 Sep 2026 22:38:15 +0300
Message-ID: <20260913193815.2862366-2-mikko.rantalainen@peda.net>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260913193815.2862366-1-mikko.rantalainen@peda.net>
References: <20260913193815.2862366-1-mikko.rantalainen@peda.net>
Precedence: bulk
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

close() removes the file descriptor from the descriptor table before
calling filp_flush().  Consequently, once file_close_fd() succeeds,
the descriptor is closed regardless of the result returned by
filp_flush() and the same fd number may immediately be reused.

Without this patch an interruptible ->flush() can nevertheless cause
close() to return EINTR, either directly or after an internal -ERESTART*
error is translated to EINTR.

This is particularly problematic for close().  EINTR conventionally
indicates an interrupted operation that may need to be retried, but
retrying close() is unsafe: another thread may already have reused the
descriptor number, causing the retry to close an unrelated file.

There is also no recovery operation the caller can perform through the
original descriptor, since it has already been removed from the
descriptor table.

Treat interruption after descriptor removal as successful close instead.
Continue to report other errors from ->flush(), such as delayed I/O
errors.

This also makes this case compatible with POSIX.1-2024.  POSIX permits
an interrupted close() that has closed the descriptor to return success,
whereas if close() reports EINTR, POSIX requires the descriptor to
remain open.

musl and Android bionic already normalize EINTR from Linux close() to
success in userspace, providing substantial deployed precedent for this
behavior.

Signed-off-by: Mikko Rantalainen <mikko.rantalainen@peda.net>
---
 fs/open.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/fs/open.c b/fs/open.c
index 408925d7bd0b..81a43b6c5b6b 100644
--- a/fs/open.c
+++ b/fs/open.c
@@ -1513,12 +1513,17 @@ SYSCALL_DEFINE1(close, unsigned int, fd)
 	if (likely(retval == 0))
 		return 0;
 
-	/* can't restart close syscall because file table entry was cleared */
-	if (retval == -ERESTARTSYS ||
+	/*
+	 * The file descriptor has already been closed, so an interrupted
+	 * close cannot be restarted safely. Do not report EINTR after the
+	 * descriptor has been detached.
+	 */
+	if (retval == -EINTR ||
+	    retval == -ERESTARTSYS ||
 	    retval == -ERESTARTNOINTR ||
 	    retval == -ERESTARTNOHAND ||
 	    retval == -ERESTART_RESTARTBLOCK)
-		retval = -EINTR;
+		retval = 0;
 
 	return retval;
 }
-- 
2.43.0

