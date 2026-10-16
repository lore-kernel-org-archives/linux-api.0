Received: from ewsoutbound.kpnmail.nl (ewsoutbound.kpnmail.nl [195.121.94.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62FBC4DD3D5
	for <linux-api@vger.kernel.org>; Fri, 16 Oct 2026 14:37:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.121.94.184
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792161453; cv=none; b=BBAdUuSybecGFLf0fdQZkGJdhyXEVwvCWD2yWP/E2/YTIWJP3GcoJc7m0CdEGBrJqkoCtvjEyj4P5Tnq4sQzLgc5qT1s19zForYJZBKt4quJzdm622pb+E25I3aipAW/Jom/+xP05AvEhVnLl7i8p98Cwi2SaieY/6hEO+qqwVk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792161453; c=relaxed/simple;
	bh=cIzTWHxUcROd4gLGkDGEHL5GFs3Jm7qZPq3DA+Hcrh0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ke/9ET4KzrdTk6Vo1oBV9WqMT0/ADgdp6THuEQlTsBUI1UYl98Hm+5sfQAR7ut5JmXMWGm2y9HWDD+K10uEOuZ7STQgeTtDaeDqcSa7yxj20NmjPPNMDzWlbbnd9sdZyGwYkepz8SYiR151+B3o2AZMnZfut0XUCtLhIyw/crv8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=xs4all.nl; spf=pass smtp.mailfrom=xs4all.nl; dkim=pass (2048-bit key) header.d=xs4all.nl header.i=@xs4all.nl header.b=dKqc4Om/; arc=none smtp.client-ip=195.121.94.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=xs4all.nl
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=xs4all.nl
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=xs4all.nl header.i=@xs4all.nl header.b="dKqc4Om/"
X-KPN-MessageId: 1bcde760-c96f-11f1-a5a4-005056994fde
Received: from smtp.kpnmail.nl (unknown [10.31.155.5])
	by ewsoutbound.so.kpn.org (Halon) with ESMTPS
	id 1bcde760-c96f-11f1-a5a4-005056994fde;
	Fri, 16 Oct 2026 16:37:27 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=xs4all.nl; s=xs4all01;
	h=mime-version:message-id:date:subject:to:from;
	bh=CNR3uFJPwTRoAhjv33oIH9pavfZoFdGwF4O/BFiBQq4=;
	b=dKqc4Om/D07j66P2Rd83UxCa81Yod0d8pnXmjJroIhhbnhtPs00WTgO5j2BdvZ21zvwgWx+yg0WCT
	 9o5+cH8C6qu2zOkWE5sFyALRFNtYOCnwW6Xm8QMf3xdezILhruKQJrT0T+Sk0HoM+dYF7EOfa1AVNO
	 Z7/f0rXO/d0f/GikaD1owOwaMTHBD7C7a64I9jkW9YoQoARj75x+9cKkiS2As0LyjTjmhX9YUk4dzY
	 p7043xs4LekQ+xhEQ3EyCKzLYKjSjr+fGRtQ8k8Glxdq8HBdb/zk4YDH6J8rKtNM7+qOE5/uakGApk
	 d37YbRX3q5XStFuYK84y5neMmAf9AFw==
X-KPN-MID: 33|DFT5/PeWg0KZPBAhgSX3DQjvAS+vg6xm+MOS6Dayxgdwb8lnz3tlwvetVXrdbyT
 tAj5wFhn1PUdG5mBfyhulFghiJG+87wbjmNbJPV6AriU=
X-KPN-VerifiedSender: Yes
X-CMASSUN: 33|B6NQS7m34NpHf1Zp2gsiKnZvcToOqOZHESw/8CR2gOFexdWp1T5Vq9r/W4jqQ8f
 tr1A8IhTJwWB1LcuYAVdl+g==
Received: from daedalus.home (unknown [178.228.137.172])
	by smtp.xs4all.nl (Halon) with ESMTPSA
	id 1b85c1e5-c96f-11f1-a202-00505699b758;
	Fri, 16 Oct 2026 16:37:26 +0200 (CEST)
From: Jori Koolstra <jkoolstra@xs4all.nl>
To: Christian Brauner <brauner@kernel.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Jan Kara <jack@suse.cz>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-api@vger.kernel.org,
	Jeff Layton <jlayton@kernel.org>,
	NeilBrown <neil@brown.name>,
	Amir Goldstein <amir73il@gmail.com>,
	Aleksa Sarai <cyphar@cyphar.com>,
	Jori Koolstra <jkoolstra@xs4all.nl>
Subject: [PATCH v7 10/12] vfs: short-circuit MAY_WRITE access for O_DIRECTORY opens
Date: Fri, 16 Oct 2026 16:38:04 +0200
Message-ID: <20261016143806.2946578-11-jkoolstra@xs4all.nl>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261016143806.2946578-1-jkoolstra@xs4all.nl>
References: <20261016143806.2946578-1-jkoolstra@xs4all.nl>
Precedence: bulk
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Requesting write access on a directory can never succeed. Rather
than performing a path-walk to determine whether the target is
actually a directory (-EISDIR) or not (-ENOTDIR), or does not exist
(-ENOENT), etc., we short-circuit to -ENOTDIR.

Currently O_WRONLY for directories is only blocked in may_open(),
which happens after we have the inode for the target, so after any
create via O_CREAT|O_DIRECTORY.

The advantage of short-circuiting is that we don't have to add even more
logic to lookup_open() to differentiate -EISDIR/-ENOTDIR. Also, for
filesystems that define ->atomic_open, handling this cannot even be done
at the VFS level, as we can't know ahead what the result of the lookup
will be.

Suggested-by: Christian Brauner (Amutable) <brauner@kernel.org>
Reviewed-by: NeilBrown <neil@brown.name>
Signed-off-by: Jori Koolstra <jkoolstra@xs4all.nl>
---
 fs/open.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/fs/open.c b/fs/open.c
index 4177f7226537..e8cb9153ea57 100644
--- a/fs/open.c
+++ b/fs/open.c
@@ -1319,6 +1319,15 @@ inline int build_open_flags(const struct open_how *how, struct open_flags *op)
 
 	op->intent = flags & O_PATH ? 0 : LOOKUP_OPEN;
 
+	/*
+	 * Requesting write access on a directory can never succeed. Rather
+	 * than performing a path-walk to determine whether the target is
+	 * actually a directory (-EISDIR) or not (-ENOTDIR), we short-circuit
+	 * to -ENOTDIR.
+	 */
+	if ((flags & O_DIRECTORY) && !(flags & __O_TMPFILE) && (acc_mode & MAY_WRITE))
+		return -ENOTDIR;
+
 	if (flags & O_CREAT) {
 		if (flags & O_DIRECTORY) {
 			/*
-- 
2.56.0

