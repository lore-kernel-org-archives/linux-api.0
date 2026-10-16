Received: from ewsoutbound.kpnmail.nl (ewsoutbound.kpnmail.nl [195.121.94.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9439D4CDA3B
	for <linux-api@vger.kernel.org>; Fri, 16 Oct 2026 14:37:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.121.94.184
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792161439; cv=none; b=cYEUjsM1TdzIj9LRnsEia9NYzc6wq/lwJV+o2wGzoRBwQxE9m7izzoKZe8+TOM4xV+vFYM+9dtbFel4kgUFYEe8yUPdZI/UPo0lyHUF0IGWLVMEDRi7zqT1z4aj69AbGpW4RWKby/wAFqIslbVXvo1p0SnfPuBJbVwVq2Rc7CLs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792161439; c=relaxed/simple;
	bh=pxw9X7GFfrnGr+oBpwK3JU0BudTL64mDfSFKZuVflJo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B7vGll0gvMaYuTBcYIY/cudWgDLym9zZ9sG9+PBbVjFugP3DiDjGPqo9qWU7Hf3JdNsLJnmYkjXI0oYUn5jxo65wHwRp/OMgPyv5vPFU2v+TEHNBpPBvEJCGGqTmi7cvZ62zKtUpGPT7Pb3I31Ouwszowgkg4kM54SYPs0Pp9fQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=xs4all.nl; spf=pass smtp.mailfrom=xs4all.nl; dkim=pass (2048-bit key) header.d=xs4all.nl header.i=@xs4all.nl header.b=Vc0mXS+y; arc=none smtp.client-ip=195.121.94.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=xs4all.nl
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=xs4all.nl
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=xs4all.nl header.i=@xs4all.nl header.b="Vc0mXS+y"
X-KPN-MessageId: 12ab2848-c96f-11f1-a5a4-005056994fde
Received: from smtp.kpnmail.nl (unknown [10.31.155.5])
	by ewsoutbound.so.kpn.org (Halon) with ESMTPS
	id 12ab2848-c96f-11f1-a5a4-005056994fde;
	Fri, 16 Oct 2026 16:37:11 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=xs4all.nl; s=xs4all01;
	h=mime-version:message-id:date:subject:to:from;
	bh=d2sNLBgtHRcDVLf3/7VYRBsiYi+o3czrWxvpiAbCzMI=;
	b=Vc0mXS+yPHkbfXl5cgREJE06EtW64Av82zJY2BuMXOUHJYPTZ/4QtrYUCYrODgb9sfa0/+2u9YQqi
	 9cIPmw0ItU4+xtBWSNcOsSWPeuRzTA4cVm5aZ5ZJbLoK0norAX5/cNsXlojzI1MWeAjgGHGl1Hxc+7
	 Tq3DJysNMzAQR2DShuqsGh3/PfV9caRIXQMATfBa+semNkeendsebg5IO9Fin7ndM5+Zg8oU88veMx
	 O7d4Xu6hjFQcE7InV52R7Ewi1Y4aeQmfhs386JE8Syo3VpQA0klWs78b1LC/8uxB2KEtKX0VNyROGt
	 3SwXM2yWGjnLghTU8iKnyr+dsvObHLQ==
X-KPN-MID: 33|f9qZXpR8sqgrMx5/NUPpVy3lN8CY3WqIrspFOC9ZhEkyyBtvbW2kdg96GwywnhW
 Nqt3fO3kIk9T2SXJbz6/tjIXJOwI2BSlmcirmypfVM6A=
X-KPN-VerifiedSender: Yes
X-CMASSUN: 33|Sr7xoVn1lht9mnjiUn9G4xDSyKUH5+J3Eic0eDPk5JUsVKwUJTnYqwjI01ILUvl
 gK80n4pIxUZZods0SeCd3wQ==
Received: from daedalus.home (unknown [178.228.137.172])
	by smtp.xs4all.nl (Halon) with ESMTPSA
	id 126994b7-c96f-11f1-a202-00505699b758;
	Fri, 16 Oct 2026 16:37:11 +0200 (CEST)
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
Subject: [PATCH v7 06/12] vfs: lookup_open(): lock the parent as I_MUTEX_PARENT
Date: Fri, 16 Oct 2026 16:38:00 +0200
Message-ID: <20261016143806.2946578-7-jkoolstra@xs4all.nl>
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

lookup_open() takes the parent directory's i_rwsem with inode_lock(),
that is, in the I_MUTEX_NORMAL class, before creating the last
component. Every other VFS path that locks a directory in order to
create something in it goes through start_dirop() and friends, which
use inode_lock_nested(dir, I_MUTEX_PARENT).

Lock the parent as I_MUTEX_PARENT here too, so that lookup_open()
matches the rest of the VFS before it starts calling ->mkdir(), which
until now was only ever reached with the parent held that way.

No functional change intended.

Signed-off-by: Jori Koolstra <jkoolstra@xs4all.nl>
---
 fs/namei.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/namei.c b/fs/namei.c
index b864aa426102..0cae8b4c071d 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -4511,7 +4511,7 @@ static struct dentry *lookup_open(struct nameidata *nd, struct file *file,
 		 */
 	}
 	if (open_flag & O_CREAT)
-		inode_lock(dir_inode);
+		inode_lock_nested(dir_inode, I_MUTEX_PARENT);
 	else
 		inode_lock_shared(dir_inode);
 
-- 
2.56.0

