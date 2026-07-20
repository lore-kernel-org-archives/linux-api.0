Received: from list.codeweavrs.com (list.codeweavers.com [4.36.192.163])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D7BF446828;
	Mon, 20 Jul 2026 17:35:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=4.36.192.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784568929; cv=none; b=jm3a87UDPEq+WUYAaxpcU091Z0cNu2U4kfSMai/LgR0UHdH3u+yAjVj0WoQpSCTyvb4ITcii7x/d/fBvGsklrLS7Q9l8dP43BQOGvUgC6iUiaRBYRBYR1fWUNZ8kQUY/NYMshtCILs7VaBu6gqCdewHxzvpaEGE7Ipi7tTQQ5vU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784568929; c=relaxed/simple;
	bh=BbUNTYM56/ulELyMb/+QTJintb3w3cqQTEBM2+tC2vg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=cG3RmxVPXpGQ6ob6IAL9FTFl//bFIzjCqZzXmOMqkclj+G8gjpWChC7DfPO7JOQUJaQdEaVw1b9FP1zu2ZarCKYIaV5O8CayydZk8VPod07ouGBvaCvW4DqQvDaC18UopK6M0409mAmzqYrxr00XMibUrZF4LcYFYZOTN9BppU8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=codeweavers.com; spf=pass smtp.mailfrom=codeweavers.com; dkim=pass (2048-bit key) header.d=list.codeweavers.com header.i=@list.codeweavers.com header.b=mcZB1qMQ; arc=none smtp.client-ip=4.36.192.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=codeweavers.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=codeweavers.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=list.codeweavers.com header.i=@list.codeweavers.com header.b="mcZB1qMQ"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=list.codeweavers.com; s=list; h=Content-Transfer-Encoding:Content-Type:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
	Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
	List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=lfHZg+u8ne+vOi+IymxWIYACUEM7LNtzyJvvMTkgCrU=; b=mcZB1qMQS/bbSi7AsDQXpwIRA/
	8FL9H5UT6Fl9YZrpC99VsYD2uo7Wxvg7tE9BJKOnsD7WRB6CqJ20ta6Jji8mvPbbE5Y2JvM/BVcGn
	TwgDyGrrB59KiCNpE7cmAKES4AJ66Szs2UfM1HYwFtPPKixyrkwHXAzrw5kXnOGNKJZE9kvr1uLM6
	sJn/3NxXv6E3VCP30/JVfpsxtHM5Bbp8nDfC8cB12FGqmmwLiRceSdxBFlw5x44zGc2K9B+Z1MT1e
	Fhn8yFBnZgFdb+PFIq6L2e0ZNDzderWHce55c6xveqZk1rXmgcADl3yzXsvNxqVGniFkS1WYYlHiB
	x6vH8rQQ==;
Received: from cw137ip160.mn.codeweavers.com ([10.69.137.160] helo=camazotz.mn.codeweavers.com)
	by list.codeweavrs.com with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <zfigura@codeweavers.com>)
	id 1wlrcg-001Fmy-05;
	Mon, 20 Jul 2026 12:17:46 -0500
From: Elizabeth Figura <zfigura@codeweavers.com>
To: Arnd Bergmann <arnd@arndb.de>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org,
	linux-api@vger.kernel.org,
	wine-devel@list.winehq.org,
	linux-kselftest@vger.kernel.org,
	=?UTF-8?q?Iv=C3=A1n=20Ezequiel=20Rodriguez?= <ivanrwcm25@gmail.com>,
	Elizabeth Figura <zfigura@codeweavers.com>
Subject: [PATCH 2/4] selftests: ntsync: fix wake_all CREATE_EVENT fd expectation
Date: Mon, 20 Jul 2026 12:17:38 -0500
Message-ID: <20260720171740.447035-3-zfigura@codeweavers.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260720171740.447035-1-zfigura@codeweavers.com>
References: <20260720171740.447035-1-zfigura@codeweavers.com>
Precedence: bulk
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Iván Ezequiel Rodriguez <ivanrwcm25@gmail.com>

wake_all used EXPECT_EQ(0, objs[3]) after NTSYNC_IOC_CREATE_EVENT.
The ioctl returns a non-negative file descriptor on success; check
EXPECT_LE(0, objs[3]) like the other CREATE_* paths. The incorrect
expectation was noted on list (Mar 2025) but is still present in
mainline.

Signed-off-by: Iván Ezequiel Rodriguez <ivanrwcm25@gmail.com>
Reviewed-by: Elizabeth Figura <zfigura@codeweavers.com>
Signed-off-by: Elizabeth Figura <zfigura@codeweavers.com>
---
 tools/testing/selftests/drivers/ntsync/ntsync.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/drivers/ntsync/ntsync.c b/tools/testing/selftests/drivers/ntsync/ntsync.c
index e6a37214aa46..12b4b81edf7f 100644
--- a/tools/testing/selftests/drivers/ntsync/ntsync.c
+++ b/tools/testing/selftests/drivers/ntsync/ntsync.c
@@ -968,7 +968,7 @@ TEST(wake_all)
 	auto_event_args.manual = false;
 	auto_event_args.signaled = true;
 	objs[3] = ioctl(fd, NTSYNC_IOC_CREATE_EVENT, &auto_event_args);
-	EXPECT_EQ(0, objs[3]);
+	EXPECT_LE(0, objs[3]);
 
 	wait_args.timeout = get_abs_timeout(1000);
 	wait_args.objs = (uintptr_t)objs;
-- 
2.53.0

