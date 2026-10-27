Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793089354;
	b=cNjnm5GNf/oT6rj1SErgg2aZJTJumEtgVUUTQi1EANemZiedVhhjHayrJn9Ee8zDkYGH
	 +V1c08Ny31amZj+70dqSuPuCeouHKf3XM7Z3fKT6UzdCErXjD+g/O7Rb5d+UW+mPFlrYg
	 nUvAREMKQtt9U6sZDfr1dIQ1619OyYyU5TRAhJumFGg/7cH0R/DAJEXdKdCLA8QYAN9Q7
	 Yt0Olvs+YK4q9YiLTJkFNuAjSW2ozmRJrX80aQV7ZSm7YD+tW4WLr9CkLzHEfvO9LH4LQ
	 j4ZJNFGdTX4/iF/oXdLDkiJM6YntM3yPwnnESdxOdDB5Ef2ZMvgufjEES2Z3V+xDTrg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793089354;
	h=Received:DKIM-Signature:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Message-Id:X-B4-Tracking:X-Change-ID:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=bQHl5Db/0ezayzRrpU0bJsA12QKy5afydCLTaoVWx0s=;
	b=LJMyOC57kC5U3BCcnaEjTMbvrG4A8OmGZKP+1A5ryMUIi3A9Q8zkD+hHjkM/8esWYWCv
	 C7o2I2XtA59zw9L/hWISJOGO1GFFvuDmW6FhQqVmh+dhysFnIVN7gFIVQ6+52nVBJGdhQ
	 FFbLDL1B3hwedfKNvTQf28KCCJBNVscTw41DGoFBSR79C0y1E/1JKCl5b80/hXNxcjpyO
	 mTH3QFJ4OoY397m5T02N9v0GF2LQ4F/7X9SNfN5srxYQfXWRZv4XcyQcX9fJbJiBrOYmz
	 VlYNhcJF1nzL746USv4wNzkZnzyhhkpBjeg/t10jGOTo2IuFXFgbv8Bc39mpJw+2DvA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=YjgDH625;
	arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36BF9606A31A;
	Tue, 27 Oct 2026 08:22:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=YjgDH625
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=100.80.115.77
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1793089353;
	b=FlfTCVBFO9ZVUeM66NMBH2BX1vKpD8WrHQGDLHKaLD7+uiyWs8S2B4GvTA16NWs6z5lP
	 dT+FlfvAqiv94EnhZ9o0aXPCgF1ztcx7oo8TQkM8SmikWbVrt30xn9Ucc+DeqY90JK/Jy
	 II/+MFt8cSoRnAd+7zuxbFAS5BGytT9jiiZ7kw548L/g6mzmmpZNJqnT3k9uMchcTCa/G
	 CsY23ClAePPLJP7vfjP1oMiTBCFsKZTm/ns3XxOkbRK9tEQekbbf0/Wn8jnVAGXkAGhmK
	 WEWiKQFkRdrD/TnRDFu+oiBHKtWhnLZRmqMRfWYVxlXUNYTTp1VfzFy9aPS9Bl9bb9Q==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1793089353;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:X-B4-Tracking:X-Change-ID:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=bQHl5Db/0ezayzRrpU0bJsA12QKy5afydCLTaoVWx0s=;
	b=SpTvHLjNs03ofh04lmqhjzbMQOHfWgTdRXPYfqcUtWB3zjtlZyiX/7Mouu7clFmk9vhP
	 OUmwbc9w/dvfqlseXTYQcDb6cv965YA572oKAb8dW4Sj9f5Rzn4IWhhAbelsu65GiciHc
	 p+CGrHpjOnUh+WXe4CENTP2MEZiRh9EpPqIcHSowILTAXDs6D/AD+CY4Pznw/hE2oUKez
	 qRteXF936sd1BP68+p/mt9BuxwynSXfMWHwHTJmd5soRzCfOXv2e7w0McfiqwAD9wqf8V
	 9Yyw8KmqDoChp9zTSgBzRJ/GipxN7p4sf2MmkLoIiexBUEfM54BTMoPG+6nThI/qWLw==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 484EB1F031EF;
	Tue, 27 Oct 2026 08:22:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793089353;
	bh=bQHl5Db/0ezayzRrpU0bJsA12QKy5afydCLTaoVWx0s=;
	h=From:Date:Subject:To:Cc:Reply-To;
	b=YjgDH625KFaeZOTEkwqJIaLTLb6sq4UCfSccTv/SOsoovpCo2ddiRQMHcAh+QRCee
	 dQ2wCZfbbKdqaxuWQ6LBWS48r/+v3TdEDzty12FE21AniMW0zXe0pfmAM8w66F1niN
	 fPnosyGOC5Si45hSzdYJAw0rEhFy4G9KCE962gP5BrvHaGWBM363yIjehY613gVNNc
	 /M2i37KRG6zXLvalnr0m18ePVbD8MwiZT2X3+U1XQphzNaAcIsoFKe0ZqNaZgbBxeD
	 uHcpJui8GKRwzfdnBCZzptQ4+F9kqauj2FoX00UIQbRD/bZ/oy7JliMBAyxBR5+5C+
	 ExBZ45h7RQ0WQ==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 9C51545035;
	Tue, 27 Oct 2026 08:22:31 +0000 (UTC)
From: Chen Linxuan via B4 Relay <devnull+me.black-desk.cn@kernel.org>
Date: Tue, 27 Oct 2026 16:22:15 +0800
Subject: [PATCH] pidfd: restrict task access ioctls to the caller's pid
 namespace
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Post: <mailto:linux-api@vger.kernel.org>
List-Help: <mailto:linux-api+help@vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-api+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Message-Id: <20261027-pidfd-task-access-v1-1-d46cf0fa4ca1@black-desk.cn>
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/yXMQQqDMBBA0avIrB2IoRjsVcRFMhl1FKxkbCkE7
 95Ul2/xfwblJKzwrDIk/ojKayto6gpo9tvEKLEYrLFtY6zDXeIY8fC6oidiVQyuc0zBtsY/oHR
 74lG+17Mfbus7LEzHfwTn+QP6aJ3EdQAAAA==
X-Change-ID: 20261027-pidfd-task-access-b797ecb260a4
To: Christian Brauner <brauner@kernel.org>, Jann Horn <jannh@google.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, 
 linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-api@vger.kernel.org, Chen Linxuan <me@black-desk.cn>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2904; i=me@black-desk.cn;
 s=20260831; h=from:subject:message-id;
 bh=NJGDJ4tAiDZhLhTR/ki/QbOLj26AyQQxFTXud2F+Uxo=;
 b=owEBbQKS/ZANAwAKAXYe5hQ5ma6LAcsmYgBq4F9CKxRS8zvMiS4Y5tBkX2gAQZ6Z9+krgSBb7
 LCi8zk6uRGJAjMEAAEKAB0WIQTO1VElAk6xdvy0ZVp2HuYUOZmuiwUCauBfQgAKCRB2HuYUOZmu
 i0UeD/0TIMg45/Wr71eH7wN89I0/aoj2TDmRpMs9bVru+UZ4bdPCFngLgH/SlvX5qXbTKMcoWTu
 7rCblQ287n/0JHBRCJb8XogWmNO0yBE+REFNUcvLNgkbknTlNpAvLs17N8h16nAL3xUqjw93GcO
 vUXYDFbUu5rY3iU8q5IQ9rpDBq5mYM7vTkSIIY0KXR90L19CF0rqpm2P3Nq/1xWhpcRAfyc42Ii
 SGBgp53CyL0n/D90VZ7ZcHZjBiduN6cwZFma5LO39Gh12eu8qhqd6IzGDDv/LbCVg6S1vlv8c/E
 WqlTcgNTk+bDOqATlOtcvfjiVi0IxrSqlRWYphFs11fJ3Am0EPW6b8+7/nC5Qfyay4Syy9Ou8dF
 opuGz9/JrGnZGtDbfLg1kU0tLx/NsgltEqhriT3L2nZLfSWAYV3zC4A7LFw1A2PIYEBzuYwGEs1
 26ufm52NX6NrJTfmjRV27LvRm6uhO+sxDt1I6F0VbAKUUF+qA00EKr/fesJL1YNVvTdj6qJoHOi
 umDQZEUpr3IRYUQt5RhUPa7F5QF8x99WlGOW/i5m1laCXa5sMtJOM2pCVXDR31tGaIdD8/O7Agf
 +gvCZrBOevdtWPuoFcS+7ETCWiR6b6Xp+hKzs5hIDAvRyvJI41rknc86fSuvV47zqs3k9adALLE
 JjLzh7sObruOqVA==
X-Developer-Key: i=me@black-desk.cn; a=openpgp;
 fpr=D818ACDD385CAE92D4BAC01A6269794D24791D21
X-Endpoint-Received: by B4 Relay for me@black-desk.cn/20260831 with
 auth_id=991
X-Original-From: Chen Linxuan <me@black-desk.cn>
Reply-To: me@black-desk.cn
Content-Transfer-Encoding: 7bit

From: Chen Linxuan <me@black-desk.cn>

pidfds can cross pid namespace boundaries: a task may obtain one for a
process outside of its own pid namespace hierarchy through SO_PASSPIDFD
or SO_PEERPIDFD, via SCM_RIGHTS, or through file descriptor inheritance.

The namespace ioctls gate access with a ptrace check against the
target's credentials only. That check does not account for the pid
namespace relationship between the caller and the target, so a task
inside a pid namespace can use a pidfd obtained across that boundary to
acquire namespace file descriptors of a task outside of its hierarchy.

procfs exposes the equivalent information only for tasks visible in the
reader's pid namespace, and PIDFD_GET_INFO already answers with -EREMOTE
for targets outside the caller's hierarchy. Extend that policy to the
namespace ioctls: fail with -EREMOTE unless the target is visible in the
caller's active pid namespace. Callers in ancestor pid namespaces are
unaffected.

Unlike PIDFD_GET_INFO, the visibility check is performed after the task
lookup here, so reaped targets outside of the caller's pid namespace
hierarchy answer -ESRCH instead of -EREMOTE.

Link: https://lore.kernel.org/all/CAG48ez1T5-tUHVK_iHsgUtWa-inVdrZxA3E-ZCW0iENJvasKfg@mail.gmail.com
Link: https://lore.kernel.org/all/20260925-gewischt-auftrag-tierzucht-c153cb3f9f74@brauner
Suggested-by: Jann Horn <jannh@google.com>
Suggested-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Chen Linxuan <me@black-desk.cn>
---
This patch was previously submitted as patch 1/4 of the task path ioctl
series v3. It is now submitted independently because it changes access
to existing namespace ioctls and does not depend on the new path ioctls.

The code and commit message are unchanged from v3 1/4. The patch has
been rebased onto current mainline. A revised task path ioctl series
will follow separately and depend on this patch.

Previous submission:
https://lore.kernel.org/all/20261010-pidfd-get-paths-v3-1-f245440b2b30@black-desk.cn/
---
 fs/pidfs.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/fs/pidfs.c b/fs/pidfs.c
index 7f8c323ce6cb..cfb93c4ccf23 100644
--- a/fs/pidfs.c
+++ b/fs/pidfs.c
@@ -556,6 +556,14 @@ static long pidfd_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 	if (arg)
 		return -EINVAL;
 
+	/*
+	 * Require the target to be visible in the caller's pid namespace
+	 * for operations that grant access to its resources, mirroring
+	 * procfs and PIDFD_GET_INFO.
+	 */
+	if (!pid_in_current_pidns(pidfd_pid(file)))
+		return -EREMOTE;
+
 	/*
 	 * We're trying to open a file descriptor to the namespace so perform a
 	 * filesystem cred ptrace check. Hold @task's exec_update_lock for the

---
base-commit: d135ab453a7400a34930bdda1ef4bdc8acfac80e
change-id: 20261027-pidfd-task-access-b797ecb260a4

Best regards,
--  
Chen Linxuan <me@black-desk.cn>


