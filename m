Received: from list.codeweavrs.com (list.codeweavers.com [4.36.192.163])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54D5142B323;
	Mon, 20 Jul 2026 17:35:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=4.36.192.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784568934; cv=none; b=Gv9TL7OOCvHfG9uKmdop2lPTvT5Z3jt31EP8EMWqhhZ24lkkbOME2oz8MIpoXUoLEB1gftF6sy6PVQX97s945U7KaiuuY6+Yd2qO2gzTfOHWC85Avpb3gWKR+bF/Z1ry4ayPx9C1b/+WXeMIAiSmP3AdIVhWyNFs2G1BB28T+HA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784568934; c=relaxed/simple;
	bh=0Wi9zUWSkOf738wjiEdsVU2AqpTcWywGE9XaO/v6oDA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Kdt1HbbS27A+JYDIwopLFwn328x1l8CqOH7v8tUkM/0MT/v04IO2+FHF0cNPHhtdIo2bbvypGMS9HYZo5WjA1H0J7iqexY+xygeQEOy66kt/qBBD58HKnmJnaOztxvRq7DkzzpWw8LgYL4vu5fTA+r0fXpPkhcHgajMUwtlRdwk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=codeweavers.com; spf=pass smtp.mailfrom=codeweavers.com; dkim=pass (2048-bit key) header.d=list.codeweavers.com header.i=@list.codeweavers.com header.b=M/eSKgYu; arc=none smtp.client-ip=4.36.192.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=codeweavers.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=codeweavers.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=list.codeweavers.com header.i=@list.codeweavers.com header.b="M/eSKgYu"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=list.codeweavers.com; s=list; h=Content-Transfer-Encoding:Content-Type:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
	Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
	List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=q8rRzJ2qbHcAJCSBy7RH5XKBgV60ML6cOeYqsoe+SkA=; b=M/eSKgYuuDLO98arTFFblc36i9
	Z50L3C7XWjZwTL1n1kkY5yy/1vV486ImLgrnHLKi6LV2G0B4ZGWEQWXiuAEF/OHFlxNL5WkU+TJVn
	eCAEJXTYFQEPSSGSyANR/TzMGIRdxgr0aKBvoklpB1sii3CTlw93PlumzQHHg5HTV2fulyVrvE4OK
	4JJV3dr+HLtq35+eDMDezvj+Ebd7P0EfsIPXEyc40MOfR0VR7WKfy8GcO2KopnBzVDvsBisAY+Q2H
	uGdKBo3Nu9Jo41N5mEgVRC5MGwmznIRcQamolMdE4XdVEPf3VuZyk+UTerh5N/MILbj1jlXXi/UkR
	BZpeeRKA==;
Received: from cw137ip160.mn.codeweavers.com ([10.69.137.160] helo=camazotz.mn.codeweavers.com)
	by list.codeweavrs.com with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <zfigura@codeweavers.com>)
	id 1wlrcg-001Fmy-06;
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
Subject: [PATCH 3/4] selftests: ntsync: add wait argument validation tests
Date: Mon, 20 Jul 2026 12:17:39 -0500
Message-ID: <20260720171740.447035-4-zfigura@codeweavers.com>
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

Add coverage for documented EINVAL cases: zero owner on wait any/all,
non-zero pad, and objects from a different /dev/ntsync instance.

Signed-off-by: Iván Ezequiel Rodriguez <ivanrwcm25@gmail.com>
Reviewed-by: Elizabeth Figura <zfigura@codeweavers.com>
Signed-off-by: Elizabeth Figura <zfigura@codeweavers.com>
---
 .../testing/selftests/drivers/ntsync/ntsync.c | 44 +++++++++++++++++++
 1 file changed, 44 insertions(+)

diff --git a/tools/testing/selftests/drivers/ntsync/ntsync.c b/tools/testing/selftests/drivers/ntsync/ntsync.c
index 12b4b81edf7f..c9fe4d5987ec 100644
--- a/tools/testing/selftests/drivers/ntsync/ntsync.c
+++ b/tools/testing/selftests/drivers/ntsync/ntsync.c
@@ -1340,4 +1340,48 @@ TEST(stress_wait)
 	close(stress_device);
 }
 
+TEST(wait_args_validation)
+{
+	struct ntsync_sem_args sem_args = { .count = 1, .max = 1 };
+	struct ntsync_wait_args wait_args = {0};
+	struct timespec timeout;
+	int fd, fd2, sem, ret;
+	__u32 index;
+
+	fd = open("/dev/ntsync", O_CLOEXEC | O_RDONLY);
+	ASSERT_GE(fd, 0);
+
+	fd2 = open("/dev/ntsync", O_CLOEXEC | O_RDONLY);
+	ASSERT_GE(fd2, 0);
+
+	sem = ioctl(fd, NTSYNC_IOC_CREATE_SEM, &sem_args);
+	EXPECT_GE(sem, 0);
+
+	ret = wait_any(fd, 1, &sem, 0, &index);
+	EXPECT_EQ(-1, ret);
+	EXPECT_EQ(EINVAL, errno);
+
+	ret = wait_all(fd, 1, &sem, 0, &index);
+	EXPECT_EQ(-1, ret);
+	EXPECT_EQ(EINVAL, errno);
+
+	clock_gettime(CLOCK_MONOTONIC, &timeout);
+	wait_args.timeout = timeout.tv_sec * 1000000000ULL + timeout.tv_nsec;
+	wait_args.count = 0;
+	wait_args.objs = 0;
+	wait_args.owner = 123;
+	wait_args.pad = 1;
+	ret = ioctl(fd, NTSYNC_IOC_WAIT_ANY, &wait_args);
+	EXPECT_EQ(-1, ret);
+	EXPECT_EQ(EINVAL, errno);
+
+	ret = wait_any(fd2, 1, &sem, 123, &index);
+	EXPECT_EQ(-1, ret);
+	EXPECT_EQ(EINVAL, errno);
+
+	close(sem);
+	close(fd2);
+	close(fd);
+}
+
 TEST_HARNESS_MAIN
-- 
2.53.0

