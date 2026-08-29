Received: from out162-62-57-137.mail.qq.com (out162-62-57-137.mail.qq.com [162.62.57.137])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEBC92DC765;
	Sat, 29 Aug 2026 08:58:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=162.62.57.137
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787993913; cv=none; b=GMY49jyI80ZqtxBN+fLq1LH2clfPE+oO8yjl0WBe3cubk3iYopZBN11/yBJxZFD0wck9CAZN3pGA5vwhVsjWljLci6c1ScbJBmNaX7d5MhG3afnV5esfrrtQqvyrxgWLKijtYmJdS9bl/Pf0iImd111fBph4HHfwxhc76Z4sR64=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787993913; c=relaxed/simple;
	bh=FERN2EqKmyh8zsj/376CUSMZGIj8gzRHRpqVxDpwdc8=;
	h=Message-ID:From:To:Cc:Subject:Date:MIME-Version; b=KIGztEGSi85fgAwKfB2/wWhjStrmwlVHe5mG8tSq/CHOBlLoHHqz2d5MJTagE+M6XxB9DJcGE6LJkIXkyQl1+JrUot8J9br5KlpYo+EaTHT7OQN2ipihQFRH2VDFw4X5qreujyt/+r6Mzhn+PoFLxpyIpMtYQ9TuPWP5zIQ8F+4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com; spf=pass smtp.mailfrom=qq.com; dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b=gw4dNqy5; arc=none smtp.client-ip=162.62.57.137
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=qq.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b="gw4dNqy5"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qq.com; s=s201512;
	t=1787993903; bh=xCU610GmJiQDQ+65gxam5Cv3pS/7BUwvSyAngRbU1JM=;
	h=From:To:Cc:Subject:Date;
	b=gw4dNqy5d9wWQpMJmc7hsblnNMR1+sMpIhVn7w6CYlGZ3YZI5LXdWtPx0Q6NBtaS8
	 Kam4JagA9Roj+PY2u3iRUyITzBdTdD7a+5I3USqHxejQICFl3DUkxOkj2W2aYJHfzq
	 WFWxwxTyuivD4WMHwuXDOcOsSZounHoSflIPJVV4=
Received: from wang-VMware-Virtual-Platform.localdomain ([111.23.130.39])
	by newxmesmtplogicsvrsza73-0.qq.com (NewEsmtp) with SMTP
	id E950FAD0; Sat, 29 Aug 2026 16:58:21 +0800
X-QQ-mid: xmsmtpt1787993901thwg5vjaw
Message-ID: <tencent_9FDB4FAAFE9F3EF38210AC963C73897A2E09@qq.com>
X-QQ-XMAILINFO: M1rD3f8svNzn347iVFquuJ+ypcr3bdw+s5c68UOPu8DFahjxZLQRCrSY0gQtfS
	 tukcEwv2OJFKEtgLNrYk2pK9caCLK2zGewg5VIb9JVygey6UGoMEalQxIn8nyZEa2DmOz1X2uoCD
	 kNc+vTaMH2rzKLZG4o/7tTjOGCHvI6qWhJovtXDBvqyAUWKxsrq5P62MD6Nmv/d7c1LnfUG0wloU
	 L9+h9zUb7sirKnDbyXWF89xvlvhVQb5YT+9gQyEBxm5i1l7RpxpjqFD83xdIH8IVMFfGM6GWdISq
	 GnqhYof4URz00JGd5M7hntFHSFGZ8W163tX4AldONlamVQy5J4m0zsYZbDCZJzSabVrauHXMuHIy
	 PVqD8adZViBPz9bRBvL6VTgduBBCA7BzGcyTTIMIiZSE8bWMV6KN2l5la+yPj1tzlKECgCm+8O0a
	 1Ms9DDE8phAWN0SeUGK81HZW0O3g3eYv1q+42ZSoDeD5sJtukCAAGn43jG3COd9LpdkIOB5qTgRS
	 Z67dfofToT5SW7BConiZ0TehJeDko7tYlUnidEiw3CAnS+vsaccmqrPpFWP+/UC8vubEj/pduwIn
	 bFXcBPhQFWLLKkt0B1TnGmXkN/1UHWYLgQPGpawDVtw+QJFV8JB7/HNjtvZVHpDwEwGzgjxobpJ9
	 HYHjou6SQAmetqdLbsl/GKKL+sHMnHwoi15jEJCJW3/yte30+D1UUjbXFexMG/IrADgb/MMN07tu
	 5tk0F6XkEijgBglvLnSQt9i1G2EuC7Jg589AABsg5TYXC7Eawm+0HXpkgfxKC8yk98WJMGSI/PmA
	 z08Xh/whc86ag632fu2M6AHJTSRZL3b2pXEAYIayn6IuRA7CATMsgawgFTL8T8I9FxF8phAXOnlk
	 OVRUNVIT8ar9TcTWUDv/zdLrxexoF78MzOGHHDja6W1c/7+O/r64b2WI2xzpLaHO4maYJYnCoy55
	 5VZDuTq6R1yBLBb4z5ZwgW7PZxSjErqcBoJQE9E5OdR7ZiMPqTg17LaUk5FVPZcpKP2uT68c+QD6
	 33E0GQIb8n2NdDvez+RaSE+PhDpbIwkb12g2ChG3zrqzKHymXA6YO0VvBj368J4br3Unk7MyyHbW
	 6N4NDp
X-QQ-XMRINFO: OWPUhxQsoeAVwkVaQIEGSKwwgKCxK/fD5g==
From: Yingjie Wang <1075151112@qq.com>
To: netdev@vger.kernel.org
Cc: davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com,
	horms@kernel.org,
	corbet@lwn.net,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-api@vger.kernel.org,
	stable@vger.kernel.org,
	kuniyu@google.com,
	Yingjie Wang <1075151112@qq.com>
Subject: [PATCH net v2] net: unix: reject negative max_dgram_qlen values
Date: Sat, 29 Aug 2026 16:58:20 +0800
X-OQ-MSGID: <20260829085820.474780-1-1075151112@qq.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

net.unix.max_dgram_qlen is parsed into a signed int but copied to the
u32 sock::sk_max_ack_backlog when an AF_UNIX socket is created.  As a
result, negative values are accepted and converted to large queue limits;
for example, -1 becomes UINT_MAX.  A nonblocking sender can then continue
enqueueing instead of receiving EAGAIN at a finite limit.

The -1 convention in the listen(2) backlog path is separate from this
sysctl; max_dgram_qlen has no documented sentinel value.  Keep it a
non-negative queue length rather than relying on the signed-to-unsigned
conversion.

Using a signed min/max handler would reject negative values, but would
also restrict the maximum to INT_MAX even though both sk_max_ack_backlog
and sk_buff_head::qlen are u32.

Make the backing value unsigned and use proc_douintvec_minmax.  This
rejects negative input while letting userspace configure the full u32
range directly.  The default, zero, and existing nonnegative values
remain unchanged.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Cc: stable@vger.kernel.org
Assisted-by: Codex:gpt-5
Signed-off-by: Yingjie Wang <1075151112@qq.com>
---
v2:
  - Change the backing value and handler to unsigned, preserving the full
    u32 range (Kuniyuki Iwashima).
  - Update the commit message to explain why a signed minimum would cap the
    interface at INT_MAX.
  - Document the sysctl as unsigned and clarify that the listen(2) -1
    convention is not a documented max_dgram_qlen sentinel.
v1: https://lore.kernel.org/netdev/tencent_4AD5738B48FDD2FC84E21FE59338C8DBAA05@qq.com/

 Documentation/networking/ip-sysctl.rst | 5 +++--
 include/net/netns/unix.h               | 2 +-
 net/unix/sysctl_net_unix.c             | 4 ++--
 3 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/Documentation/networking/ip-sysctl.rst b/Documentation/networking/ip-sysctl.rst
index 208f469..2fe1ca8 100644
--- a/Documentation/networking/ip-sysctl.rst
+++ b/Documentation/networking/ip-sysctl.rst
@@ -3818,8 +3818,9 @@ l3mdev_accept - BOOLEAN
 ``/proc/sys/net/unix/*``
 ========================
 
-max_dgram_qlen - INTEGER
+max_dgram_qlen - UNSIGNED INTEGER
 	The maximum length of dgram socket receive queue
 
-	Default: 10
+	Negative values are rejected.
 
+	Default: 10
diff --git a/include/net/netns/unix.h b/include/net/netns/unix.h
index 9859d13..e233c42 100644
--- a/include/net/netns/unix.h
+++ b/include/net/netns/unix.h
@@ -15,7 +15,7 @@ struct unix_table {
 struct ctl_table_header;
 struct netns_unix {
 	struct unix_table	table;
-	int			sysctl_max_dgram_qlen;
+	unsigned int		sysctl_max_dgram_qlen;
 	struct ctl_table_header	*ctl;
 };
 
diff --git a/net/unix/sysctl_net_unix.c b/net/unix/sysctl_net_unix.c
index 47660d5..8f6f065 100644
--- a/net/unix/sysctl_net_unix.c
+++ b/net/unix/sysctl_net_unix.c
@@ -17,9 +17,9 @@ static const struct ctl_table unix_table[] = {
 	{
 		.procname	= "max_dgram_qlen",
 		.data		= &init_net.unx.sysctl_max_dgram_qlen,
-		.maxlen		= sizeof(int),
+		.maxlen		= sizeof(unsigned int),
 		.mode		= 0644,
-		.proc_handler	= proc_dointvec
+		.proc_handler	= proc_douintvec_minmax,
 	},
 };
 
-- 
2.43.0

