Received: from list.codeweavrs.com (list.codeweavers.com [4.36.192.163])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DADC3E49C5;
	Thu, 23 Jul 2026 20:13:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=4.36.192.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784837602; cv=none; b=uSD0P7mrm4Aoe72DOuHo8Q3CUq58B8Ff3X/Z4kjnvC0w+Qn2BhPeMT70id8KlOqO0JwW0rL5ONxoNbz65vph9FnR7HqUvqSx0Hw2TTaNYFYb4bT8oF1rG+UpoxWY0I+ZDY5ALHNT1Hy+uiqGnHtgcCzvZPB3MwquH0eVoyGYNy4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784837602; c=relaxed/simple;
	bh=syfQgoDuHaZrDYKHpmrAqG01+IvjiRi6SEgNM2+X1oM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=n3TYDKDzkzY96jiY15feoLmHzrs9SNqpth1DhxhF1V/3V26wLTxVB4PNPcdUHZxoTWlw/vJZZg+KKLrNILnpmKu3H8ZyMERHfe6gG3TZSSPwgXHVu1Gg4vsXOIH6jW6BGRSauuOECAFJ8IjBzKNKlB7uxN8DlxlvqANC5vd3No0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=codeweavers.com; spf=pass smtp.mailfrom=codeweavers.com; dkim=pass (2048-bit key) header.d=list.codeweavers.com header.i=@list.codeweavers.com header.b=pS89HMA0; arc=none smtp.client-ip=4.36.192.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=codeweavers.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=codeweavers.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=list.codeweavers.com header.i=@list.codeweavers.com header.b="pS89HMA0"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=list.codeweavers.com; s=list; h=Content-Transfer-Encoding:Content-Type:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
	Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
	List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=cGytKmpTZSgV/TsaLNwpn0WgDkhwBsVUwPMmrW//LJk=; b=pS89HMA0RB7fMwiwXVOMws+2nB
	1U2Ib7m6jf8Msxhh0DyooJ1qT2W2I/MlKxdx5FTBem0YhgfQAlRhSC9ISi8E2kft1OXo4Poks4jT4
	x538ckI6w89QGm3A4zy3LKz7bdBYJzKjCVB7J/xqwQFRbX6flFOmRw0BXZ3TUL46kqtBOpidAY0Df
	Zx+aRs6BAy/VtrSOAnViSFE0kkV/CSXBnkMWGr2SOWEsrmhDBIT2uaFSW6CSMLecYtydQ66dRBrPm
	V1Y2FyySp4I+L49FXWYxi8pdk1fxWPdCD/MpCOpIFg4fJhXEaxNNos6fUo2USNwEbxviaG3v2Ju1V
	YQL+BEZA==;
Received: from cw137ip160.mn.codeweavers.com ([10.69.137.160] helo=camazotz.mn.codeweavers.com)
	by list.codeweavrs.com with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <zfigura@codeweavers.com>)
	id 1wmzn6-00AV4U-1e;
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
Subject: [PATCH v2 3/5] ntsync: reject wait ioctls with zero owner
Date: Thu, 23 Jul 2026 15:12:59 -0500
Message-ID: <20260723201301.11826-4-zfigura@codeweavers.com>
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

