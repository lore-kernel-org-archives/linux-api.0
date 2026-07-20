Received: from list.codeweavrs.com (list.codeweavers.com [4.36.192.163])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7CA2438026;
	Mon, 20 Jul 2026 17:35:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=4.36.192.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784568954; cv=none; b=OiXXmW6KR7QhYqVvj4SnvndW4R3cjhw3xGJM1QGGFTXabOKOt5SWBwu+RQrTmdQih7wyv2q5R9Fe7RGIpJXoK5wLhbWKiHoNk16G5F5UKzFD+k6KTyYAvJCSqX0mb5Wjqf5uq0flaYECdhJJ7pP2lIcvE78b+IeUjUgZ0neziL0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784568954; c=relaxed/simple;
	bh=syfQgoDuHaZrDYKHpmrAqG01+IvjiRi6SEgNM2+X1oM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=K6l++if2EFEa59DoG7joZKfIqxN2DbCH2lLQC7RSGEZSUQeMdgLbA+Ysyy5CeqcXtGZOWy9q79MzLcVfYtNtrIs4wEge8W8oYn3LF9+pzozh6aWGZJC7b4qXjwi+m9ZWLrQCj/MW3p0QscOmSeUZlyqOAWZ2EmbvGlRJDDj/i3A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=codeweavers.com; spf=pass smtp.mailfrom=codeweavers.com; dkim=pass (2048-bit key) header.d=list.codeweavers.com header.i=@list.codeweavers.com header.b=V+bCGd9P; arc=none smtp.client-ip=4.36.192.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=codeweavers.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=codeweavers.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=list.codeweavers.com header.i=@list.codeweavers.com header.b="V+bCGd9P"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=list.codeweavers.com; s=list; h=Content-Transfer-Encoding:Content-Type:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
	Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
	List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=cGytKmpTZSgV/TsaLNwpn0WgDkhwBsVUwPMmrW//LJk=; b=V+bCGd9PywyXJaJMJPM1goAVDN
	E6/6Avy1QtB9EGOk93CfsN0Bc7VWp7BPvA2F5RFQKkeEV3mDjYut1xTnDe1+Ujmz5L4TaYhyeiiLW
	18ZzDdfGrcAhT/wWnj3Xi4ggNlsVT630cZsEehoEW6rAN0fRBvLfMvkn7BvPYltLNd0pYt0hfvQSN
	rX+IAvhutkAIZpBjkAJLvIIy+R/8iXjMu9FyEIKc/QI3nbg0c0SsbJm128S/tyYDRK+Y6Kvd8a4KA
	JqMXeRvg01Bp9UgRJYpeTh+uMWwnIFDNS8OOBpsY6mXVKnbBELpLpXznm70UBa+d5DRVpSNXAJpOM
	tpc2kBAA==;
Received: from cw137ip160.mn.codeweavers.com ([10.69.137.160] helo=camazotz.mn.codeweavers.com)
	by list.codeweavrs.com with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <zfigura@codeweavers.com>)
	id 1wlrcg-001Fmy-07;
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
Subject: [PATCH 4/4] ntsync: reject wait ioctls with zero owner
Date: Mon, 20 Jul 2026 12:17:40 -0500
Message-ID: <20260720171740.447035-5-zfigura@codeweavers.com>
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

setup_wait() already validates pad and flags but not owner, while
Documentation/userspace-api/ntsync.rst requires EINVAL when owner is
zero. Reject early before queueing waiters.

Signed-off-by: Iván Ezequiel Rodriguez <ivanrwcm25@gmail.com>
Reviewed-by: Elizabeth Figura <zfigura@codeweavers.com>
Signed-off-by: Elizabeth Figura <zfigura@codeweavers.com>
---
 drivers/misc/ntsync.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/misc/ntsync.c b/drivers/misc/ntsync.c
index 02c9d1192812..4a805919bb0c 100644
--- a/drivers/misc/ntsync.c
+++ b/drivers/misc/ntsync.c
@@ -875,6 +875,9 @@ static int setup_wait(struct ntsync_device *dev,
 	if (args->pad || (args->flags & ~NTSYNC_WAIT_REALTIME))
 		return -EINVAL;
 
+	if (!args->owner)
+		return -EINVAL;
+
 	if (size >= sizeof(fds))
 		return -EINVAL;
 
-- 
2.53.0

