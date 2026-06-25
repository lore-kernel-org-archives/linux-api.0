Received: from mail-wr1-f46.google.com (mail-wr1-f46.google.com [209.85.221.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AFAB3812E9
	for <linux-api@vger.kernel.org>; Thu, 25 Jun 2026 08:37:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782376658; cv=none; b=R+xUrRg9vcvOrJT01JtIB7lp9lnXjzQeg3gsFnbmY3kT0iFk2dxiCIBFh6la/ggLX6F9WsAm/m8XXhxCjBkoDic0sE6PkZc6quCY0qZ6ue1ak3uEFgPLaDJdJRjuxc5T92nSUQ6/9sb7Ub5SxKkVJ/5RyarmJHcq2wEug75vLJc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782376658; c=relaxed/simple;
	bh=D+2EqPDkxiIP7659jXJBe6+HwYhGEbOa5dHouxpNOHk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=evX1FN4n7eKPeNExAp3uil9fE3trU7FtsiLEPDUEk/ONPXsC4H4SRWX6qfWe7QigO1+gbV5hZfZzmT7Uc7CpBNw5qTh0W9ITfox546dRgCmL1xdurphoUBLlKsLIzcLY0xhM8Fz8KZ5ngiK3WBfrdnyS9GtzfbvgQkwW/avk3RA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=FiV0d9If; arc=none smtp.client-ip=209.85.221.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FiV0d9If"
Received: by mail-wr1-f46.google.com with SMTP id ffacd0b85a97d-4624a44e152so1663628f8f.2
        for <linux-api@vger.kernel.org>; Thu, 25 Jun 2026 01:37:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782376656; x=1782981456; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0J1jnzmQVNhnRjMNcripM0zyo9VQmhoRd3tOhETxEs8=;
        b=FiV0d9IfxleAJlGEoGlvmiMkRrULIYR8hhuIdDMze2XplYzVJt3F+WrT6jZs5TDmxp
         Jmz1uLTL6mtALma8rWFD/U19FLqHTNkuWqP+acUqEK5YSten6qMKZ/OXBfqIX9k3+PBl
         1lKXyzDWFGJ8/wez3NxDniWLWIevdIsoRIz4uxopkhwzt5leYD5T9tPQQRhu7GUc8CQK
         nHoECrfsBbnM1/WV1hQY9xloL7Xb7DSDCtv87YpCTnMw/970CvHgvQ2w93mHddmlK2Yb
         JQqCwSd6JkwP5TuA5b5bBDSIG2BQFg7Yl1AzxXIrWAxzN27GRxzNBntEdXG7D0kO+X46
         JBDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782376656; x=1782981456;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=0J1jnzmQVNhnRjMNcripM0zyo9VQmhoRd3tOhETxEs8=;
        b=bn4wLCrpk9SYCuEzuTxEIojIdXpk4PO/J7Y6pMjvj/VAt8WoMDrpjngibD5YWcNZ/I
         xmeyQuOL9WI31y10O3rlf+lve4Kxl1RSsQfXns6FQX3LOq0vICynMHBzkLgvL04gBoMz
         tVcEKAhUjyIz5vhe7LbSiOF2gG8fN/NNwPIvROiQP/Hj64JBbpQy8Dg9G0zxeDHOT2Y9
         JR06zdtLFb2OiUCM399fgW1mKDJjZhg4iz2//M3P9JEiO1YUoOZelW3++PeUxzh1ALS0
         M00vi5eegC949H4t6ce0zuWY3XFYwUmlxlZt1U84EhmyfsoGtOEaEYH3BFpTbKpzZUJX
         03kA==
X-Forwarded-Encrypted: i=1; AHgh+Rrwspqx9EkKWrJWMNoJ4zXrQ/w258Au4EMPX3c+r59CZJllohqNoJle9rsCZFl7mIdA1VZIX0bFCUc=@vger.kernel.org
X-Gm-Message-State: AOJu0YzxgVsvmW+ZlqDWULHmPCDObnnI8B6Wcl4VtL8MHaxMAaXLgwdP
	ijcMjA3N1/TXjm4fxOa0o0S5LEtNtVnuWXFWrrJRkGVPZjWxW95qNhNB
X-Gm-Gg: AfdE7cnw0KQM2lhP4yOiIkc7muIyyHbK69DumwwnWiV59EW9wBVm6QDjPhH2PKHIJcu
	1vS8DYmWa+uAcIGTPKxPXnrhqVk72PBMi2EWXDqATp/GNTWravRdIwPl/qmCkaDyecIuRNvy6R/
	gjB6noEuMwnlRvBq7NMFMeAoHSpnh+OujS/410T/BB9yT2FGd5/0z1LBc+l733KWyH957a4BlPt
	H+gGmuD4Q2HWW+z23OdEvWjGpNXS7dkT9fIWkd9BpcitZbMmXR+Sl2TlMd3vYH/5L6QRk2LMLFI
	o7wOpGBr2VpTE1asvPYNR/HioKhuhVa95blN7iNEUjW3/FWd6kvkD7HyidQHMiiAB6c5GF2FqlD
	2QeoUaRFCvevbBlSvCEVfeDm+g+ira7B6KUm5VHSJXVNhPRim0/Sw+URXhEOW2+UDzTdf6qxq23
	C6/BsewnOvAhAw9B79izA=
X-Received: by 2002:a05:6000:2485:b0:46c:a463:987b with SMTP id ffacd0b85a97d-46dc1e82faamr2365468f8f.41.1782376655597;
        Thu, 25 Jun 2026 01:37:35 -0700 (PDT)
Received: from localhost ([212.73.77.104])
        by smtp.gmail.com with UTF8SMTPSA id ffacd0b85a97d-46c9ed7491esm9943798f8f.37.2026.06.25.01.37.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 25 Jun 2026 01:37:35 -0700 (PDT)
From: Askar Safin <safinaskar@gmail.com>
To: linux-fsdevel@vger.kernel.org,
	Christian Brauner <brauner@kernel.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Jan Kara <jack@suse.cz>
Cc: linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-api@vger.kernel.org,
	netdev@vger.kernel.org,
	fuse-devel@lists.linux.dev,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Matthew Wilcox <willy@infradead.org>,
	Jens Axboe <axboe@kernel.dk>,
	Christoph Hellwig <hch@infradead.org>,
	David Howells <dhowells@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Pedro Falcato <pfalcato@suse.de>,
	Miklos Szeredi <miklos@szeredi.hu>,
	Andy Lutomirski <luto@amacapital.net>,
	Collin Funk <collin.funk1@gmail.com>,
	David Laight <david.laight.linux@gmail.com>,
	Stefan Metzmacher <metze@samba.org>,
	The 8472 <kernel@infinite-source.de>,
	Willy Tarreau <w@1wt.eu>,
	Joanne Koong <joannelkoong@gmail.com>,
	Val Packett <val@packett.cool>,
	Andrei Vagin <avagin@gmail.com>,
	patches@lists.linux.dev
Subject: [PATCH v2 7/7] pipe: set FMODE_NOWAIT for named FIFOs
Date: Thu, 25 Jun 2026 08:34:09 +0000
Message-ID: <20260625083409.3769242-8-safinaskar@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260625083409.3769242-1-safinaskar@gmail.com>
References: <20260625083409.3769242-1-safinaskar@gmail.com>
Precedence: bulk
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

CRIU relies on ability to do vmsplice(SPLICE_F_NONBLOCK) on named FIFOs.

Signed-off-by: Askar Safin <safinaskar@gmail.com>
---
 fs/pipe.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/fs/pipe.c b/fs/pipe.c
index c0ccf21b9..a8e9b4459 100644
--- a/fs/pipe.c
+++ b/fs/pipe.c
@@ -1156,6 +1156,12 @@ static int fifo_open(struct inode *inode, struct file *filp)
 	/* We can only do regular read/write on fifos */
 	stream_open(inode, filp);
 
+	/*
+	 * CRIU relies on ability to do vmsplice(SPLICE_F_NONBLOCK)
+	 * on named FIFOs.
+	 */
+	filp->f_mode |= FMODE_NOWAIT;
+
 	switch (filp->f_mode & (FMODE_READ | FMODE_WRITE)) {
 	case FMODE_READ:
 	/*
-- 
2.47.3

