Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A54633E92A0
	for <linux-api@vger.kernel.org>; Wed,  8 Jul 2026 09:34:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783503298; cv=none; b=hkYfAnhUqr1KHpF/FDzZYE4yj1rD0zxXEb+aqJHRBqBuA+xxH67G1iI1qmAC3jVV+xZUH+DVA0WzUuo/OL1lrtbL5Xm+yXqtkyDeobXrO8cefxiNHd/CCglIf1y/sEYHGyK6VWGTX9SVa+TVlGeTr4KjJigaI6qLKTxa6FbRDGQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783503298; c=relaxed/simple;
	bh=beVtjXrWuYofT5C9A2ZJDghifOTh4tK5f37wTOg0H/Q=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=SIn+bwa72TLzqI6x1OhxN1nIcSnH81LMD3+D1bZrey5yqPxTWPgkGaaZ+IllkIxK+5yJE6i+8gy4NGt5fn5/0PPVTyHh43Or+F2GhqDgpJfZjaHJmrbc6OyJejEzxX+6/i9y8qfOUyJUTz2wqbUWsP4sD387WtpPzqdzTN9a6eU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=KkZc25gT; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="KkZc25gT"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1783503294;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=LSGrhlD0yn8NtGRpP/yuLz9/lKXd3YZ5anjPExUEXbM=;
	b=KkZc25gTjMWRneQywrCnuQvrF9qgwQYE/zq6wsEEgnzKLeIeYPmx3MeVYlHNmCpxAV7ixF
	3W0alUYXj8ijw3a5sb+gRbgMf5JKDmwjwX2dOlwXGGeWeTrK/d7AWQcNNYBLMwlHa3knNc
	IKGgfB/zE7xxVfguPcjbNz+kTdKaeuc=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-257-1jWkn7APP-qkLQEIcXgpAg-1; Wed,
 08 Jul 2026 05:34:51 -0400
X-MC-Unique: 1jWkn7APP-qkLQEIcXgpAg-1
X-Mimecast-MFC-AGG-ID: 1jWkn7APP-qkLQEIcXgpAg_1783503290
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 391EB1956068;
	Wed,  8 Jul 2026 09:34:50 +0000 (UTC)
Received: from oxygen.redhat.com (unknown [10.44.33.242])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id EAC481955F43;
	Wed,  8 Jul 2026 09:34:48 +0000 (UTC)
From: Giuseppe Scrivano <gscrivan@redhat.com>
To: linux-erofs@lists.ozlabs.org
Cc: linux-fsdevel@vger.kernel.org,
	linux-api@vger.kernel.org
Subject: [PATCH 0/2] erofs: fd-based source and backing file introspection
Date: Wed,  8 Jul 2026 11:34:25 +0200
Message-ID: <20260708093446.3370200-1-gscrivan@redhat.com>
Precedence: bulk
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

This series adds two features to erofs for file-backed mounts:

1. Accept a source file descriptor via fsconfig(FSCONFIG_SET_FD,
  "source", NULL, fd) as an alternative to a path string.  This is
  useful when the backing file isn't reachable by path in the caller's
  mount namespace.  For example, composefs reusing an already-mounted
  erofs image's backing file.

2. Add an EROFS_IOC_GET_SOURCE_FD ioctl that returns a file descriptor
  to the backing image file.  This allows userspace to retrieve the
  backing file from an existing erofs mount without needing to know or
  parse the original source path.

Giuseppe Scrivano (2):
  erofs: accept source file descriptor via fsconfig
  erofs: add ioctl to retrieve the backing source file descriptor

 fs/erofs/inode.c           | 25 +++++++++++++++++++++++++
 fs/erofs/super.c           | 36 +++++++++++++++++++++++++-----------
 include/uapi/linux/erofs.h |  9 +++++++++
 3 files changed, 59 insertions(+), 11 deletions(-)
 create mode 100644 include/uapi/linux/erofs.h

--
2.55.0

