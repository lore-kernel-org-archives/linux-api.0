Received: from list.codeweavrs.com (list.codeweavers.com [4.36.192.163])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D89E3DAACF;
	Thu, 23 Jul 2026 20:13:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=4.36.192.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784837602; cv=none; b=Cbc/t3uEyS6uzzkILWj9FoEaqvo17GyULCZOeFMAkhZsK4tOFTOw4nqKqtW7WVGiizj0xvBpmTR37yCNnOBx6hJAkp7n/bq6Ww/hi9ZN5Q4ma8u15o/TqwRS8ai90fsyu5Iv/MvVeocUcUGXU2vD/xH/n7KIYESgBIOLoD9J4Qs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784837602; c=relaxed/simple;
	bh=0Wi9zUWSkOf738wjiEdsVU2AqpTcWywGE9XaO/v6oDA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=VgsBiXmh9OuWjfXxIolWpBoh1S/kfkQSIrcW7HxWDoOUq4hogQk4pl302aPT84FHyD29XLFx13KTgkYvW0fB8k1sQAv1A2crvxs/6aofE1cF1Y4Db0fwQyoWPcS7ie5O3k2egymUAHuxo1bIb8xM5EkXeN6u71fC9E8yeCkTAiI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=codeweavers.com; spf=pass smtp.mailfrom=codeweavers.com; dkim=pass (2048-bit key) header.d=list.codeweavers.com header.i=@list.codeweavers.com header.b=Yo7bIOWX; arc=none smtp.client-ip=4.36.192.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=codeweavers.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=codeweavers.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=list.codeweavers.com header.i=@list.codeweavers.com header.b="Yo7bIOWX"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=list.codeweavers.com; s=list; h=Content-Transfer-Encoding:Content-Type:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
	Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
	List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=q8rRzJ2qbHcAJCSBy7RH5XKBgV60ML6cOeYqsoe+SkA=; b=Yo7bIOWXwPpVndpuAQrHeCwgJB
	HMGYBDVD+nG493iWGI5Wo7b8ZAe44BRn1DdH/5DaPA5h7jC9ifH2024yLy2UsrfRjWUeckOjsot9m
	rw+m39KR0C9ioDxGex8PskR8u/+do66K1qQAwlVFqCnMgVxvVYfAribmGNV1QxrX+GFEj0SG7sO/R
	DnS0zjtehXZ2TUUcoR6tiWHNx2sD2TSQrs87izK8bcSS0nOwfvbj4jBfH2oeM1cW9scEdSj5ixxGV
	NB9dZVpArt8ymlV8ukgYDoX//xfk6pl+k65Wb8nuBOiYQiXDTrnCsJ9lpV0dmBUioMin5Ar1DBV8H
	XZYFrCVQ==;
Received: from cw137ip160.mn.codeweavers.com ([10.69.137.160] helo=camazotz.mn.codeweavers.com)
	by list.codeweavrs.com with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <zfigura@codeweavers.com>)
	id 1wmzn6-00AV4U-1c;
	Thu, 23 Jul 2026 15:13:12 -0500
From: Elizabeth Figura <zfigura@codeweavers.com>
To: Arnd Bergmann <arnd@arndb.de>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org,
	linux-api@vger.kernel.org,
	wine-devel@list.winehq.org,
	linux-kselftest@vger.kernel.org,
	linux-doc@vger.kernel.org,
	=?UTF-8?q?Iv=C3=A1n=20Ezequiel=20Rodriguez?= <ivanrwcm25@gmail.com>,
	Elizabeth Figura <zfigura@codeweavers.com>
Subject: [PATCH v2 2/5] selftests: ntsync: add wait argument validation tests
Date: Thu, 23 Jul 2026 15:12:58 -0500
Message-ID: <20260723201301.11826-3-zfigura@codeweavers.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260723201301.11826-1-zfigura@codeweavers.com>
References: <20260723201301.11826-1-zfigura@codeweavers.com>
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

