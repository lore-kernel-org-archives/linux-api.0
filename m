Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=203.205.221.149
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793027819;
	b=V0nmnv70u4oGgLAfVxOeTm/GMrhTn2h/7jZ2ubLzo3is4x5MqtQAFsVIZUje6Tl+IYd/
	 xaN6OVpYQ3ZKkdmoRsFzleLPEz5JBDwE4kFeSbG76w490zbx7Ta4E6gGARumGqPMwbg9I
	 Npieu2WkHbNxgXaHSHL6iEddzOIGpsmlBW/JEkYAIQ3iVv3CZOUHoLSt9f/Lo2fZJ7l1o
	 1dQiQjbTKCw2TOpZnPiI9p6TVOPlGx62RHGZ7CInGpPsXnhaGeGr7D5RYWLkAUYbxCC8r
	 4HQrv3hZCKKa4+yLUibacLBwyOisU6V6IMEZQCsuxFeCHmKPDWwFX0d0w8fIkn/44wQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793027819;
	h=DMARC-Filter:DKIM-Signature:Received:X-QQ-mid:Message-ID:
	 X-QQ-XMAILINFO:X-QQ-XMRINFO:From:To:Cc:Subject:Date:X-OQ-MSGID:
	 X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=V5GkPV1OJFnkZ5kXP2DE2sZbq+RcL+loOw2b9lbmerY=;
	b=SVKrKsTAoXI1dyYV4BMi+ccAIQzyXG6my1ntAiDbBfLaaZKU5iU4XruK7IwxiNGii0Dr
	 i+GmcKd66o1mLROxueJ803E685ilsg2FHQAjP7HhRs3XZ1MHqfPMVP4LXW9ex+Ses5znB
	 1IsxSHXoEA6pOZsfT4YPDnHTmYewSEmUUbUF9sk9WsRbHQPKER8K45hOd7lrj5L5uyzL1
	 SwalN2qe8pM5nc8EEhHPfwqO0/AteR4bsf8FX5lXrRmU1v0eguKPBtmVoRFc2M7AEWAQj
	 4IW//EP/uBSAg2uBPF3HFSXh1/mD/ULw37gn6sSME++HU+/ATj5kTzJCc+c7hZYvEyw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=qq.com;
	spf=pass smtp.mailfrom=qq.com;
	dkim=pass header.d=qq.com header.i=@qq.com header.a=rsa-sha256 header.s=s201512 header.b=F4T6gEQX;
	arc=none smtp.remote-ip=203.205.221.149
Received: from out203-205-221-149.mail.qq.com (out203-205-221-149.mail.qq.com [203.205.221.149])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88301606A31A;
	Mon, 26 Oct 2026 15:16:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 88301606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=qq.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=qq.com header.i=@qq.com header.a=rsa-sha256 header.s=s201512 header.b=F4T6gEQX
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qq.com; s=s201512;
	t=1793027807; bh=V5GkPV1OJFnkZ5kXP2DE2sZbq+RcL+loOw2b9lbmerY=;
	h=From:To:Cc:Subject:Date;
	b=F4T6gEQXCF9So9m4Ensh8ARd1xnIyIYn3Wlx5wy93daLNwbsn6iaNdJwxMtYTE3+P
	 UqNr00ksBn57Fq+m4SGY1tp8bXzuUwlCOvUowVwSzPKofpBVKCgxtyKF2YjRlXqJqt
	 lZMUEK5VFKUITBJQYEnClYxovg3QnAz0EtO0g7Qc=
Received: from kernel-lab.tail5e91bb.ts.net ([2409:8950:57d:63:ad3c:addd:6586:2a94])
	by newxmesmtplogicsvrsza53-0.qq.com (NewEsmtp) with SMTP
	id 42D98026; Mon, 26 Oct 2026 23:16:45 +0800
X-QQ-mid: xmsmtpt1793027805tjrij2d6z
Message-ID: <tencent_FF729CBCFFA37F06072959FD798A11F55D0A@qq.com>
X-QQ-XMAILINFO: MGJQUKeBeYZp4hmXt3y7HPTOhAebEBvhnoKYgoYz2gzml9qlAj6DSQN5DVc+lA
	 LgI++NUmx17nau7w56WtJ2n2Odx7khEnWjQkoc8EW9iFTUg8VnRi5N7FHOdshEJxUFeO4TFTLAxa
	 5ViJzBTuH2nR/hGYrkS4MziqtDnwQ/B6nc4CCMpoRrKqHkXcLn7j0NIEXRQgLc8yiikDe/xPBiG3
	 Z2FeVjKx7IbZUBt7tZMinTFWUpzLuuBm9ZIOCwHTuO+XJJDEsVcyO3Kwxg4QHrZex1JYLG3QtPMH
	 93ZmrYTxLQOjSPWpVImr7SMz7aWF4xTQ17DmYxYbNjcMZ9LPCRlTTrLKc0MzcUda0SWKPCTpb1X0
	 oY/+RoukMDSGIs4Uez58hBTxWsUCe8gGkynhqQHSlt39gjpmWcllZUzcQZYVKZc6GyE+AEA++oJT
	 e0hG8/20X+j+P6f1xI7UVxhYbklAYP/gVI95Pxjsg+woZQS/ik+en1fovd4yTEM5z3EbeFW09pAD
	 l7prg687xS9zLIPWaXY042VN81To61cf+gfEllk+s/vEPQy5NcsNqEjftmLuosWia3qFKkWhJg7f
	 l91yPQbcW1lab5AorY0zjcGP5UO/kpW0Oy2rrcMcY4ohvvGKJdRL12Ph5yefJ72Ee+msJfsKWZ7q
	 6SfTqtdXK6EJ7H12JlBLv0OMYin4r1Wt7vEF3MTTvsG//HU3pghJ+yOQIxS06kReKAqQblr1Ke5c
	 ptrqwSUK1Q9TYCbtt6pmTXP1ajIPDEsHbgKHglU+zwFUbHyPFk6ZXZa1oxBXbYB0xSGvuAJkcrWh
	 MkVk9NenL2fqK2htTv0qYmEcw/0Qyrzm1lE0uHRpE8eGZNCkCxWOio6jgD7zvGcwRfkKcsO/Mz3g
	 hCbuENnknARq1HYCR6XBDd4CiiDGez/yUYQ/3al+ga9jiQC5S9LnlWZw7Mmzm9h6+pfGaD6MSbWQ
	 NTgFzKf3A9XffpGZe5lNgNwaA7h7JexSxz05SCPBC5qbfg2n4inz/0jrL1abHNiH27qyMne2r3Tc
	 kb2iaXU+thCZLA+Rp6Gpc5pvWk+Z4Go/ov3jsIZ5f6HIrhCFw+
X-QQ-XMRINFO: OWPUhxQsoeAVwkVaQIEGSKwwgKCxK/fD5g==
From: Yingjie Wang <1075151112@qq.com>
To: linux-scsi@vger.kernel.org
Cc: loberman@redhat.com,
	jmeneghi@redhat.com,
	James.Bottomley@HansenPartnership.com,
	mkp@kernel.org,
	linux-kernel@vger.kernel.org,
	linux-api@vger.kernel.org
Subject: [PATCH] scsi: st: Prevent timeout arithmetic overflow
Date: Mon, 26 Oct 2026 23:16:45 +0800
X-OQ-MSGID: <20261026151645.2212994-1-1075151112@qq.com>
X-Mailer: git-send-email 2.43.0
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Post: <mailto:linux-api@vger.kernel.org>
List-Help: <mailto:linux-api+help@vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-api+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

MT_ST_TIMEOUTS converts the requested timeout from seconds to jiffies in
signed int arithmetic. A sufficiently large value overflows before it is
stored in long_timeout or passed to blk_queue_rq_timeout(). Non-immediate
MTERASE commands also multiply long_timeout by eight, which can overflow
even when the original seconds-to-jiffies conversion fits.

These overflows can turn an administrator's timeout setting into a much
shorter request timeout. MTSETDRVBUFFER requires CAP_SYS_ADMIN, but the
driver should reject settings it cannot represent instead of accepting
a wrapped value.

Check the decoded seconds before multiplication, using the smaller of
INT_MAX and MAX_JIFFY_OFFSET as the jiffies limit. This keeps both the
signed timeout arguments and the relative jiffies interval in range.
For MTERASE, multiply in u64 and clamp to the same limit, so a valid long
timeout remains usable without wrapping when it is extended for erasure.
Zero retains its existing behavior, and timeouts within the limit are
unchanged.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Cc: stable@vger.kernel.org
Signed-off-by: Yingjie Wang <1075151112@qq.com>
---
Validation of this revision:
- Built drivers/scsi/st.o with x86_64 and i386 defconfig, CHR_DEV_ST=y,
  HZ=1000 and W=1 (GCC 13.3). Both builds needed
  -Wno-error=format-truncation for an existing create_one_cdev() warning,
  also seen when compiling the base st.c with the same headers.
- Host-side checks of the extracted fixed arithmetic covered both timeout
  selectors, zero/default values, range rejection and erase saturation,
  with modeled 32/64-bit limits and seven HZ values from 12 to 12287.
  These are not device runtime tests. This revision has not been
  boot-tested.

 drivers/scsi/st.c | 21 ++++++++++++++-------
 1 file changed, 14 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/st.c b/drivers/scsi/st.c
index e9d41e3cc2dd3..fccb83e75a66c 100644
--- a/drivers/scsi/st.c
+++ b/drivers/scsi/st.c
@@ -172,6 +172,8 @@ static int debugging = DEBUG;
 
 #define ST_TIMEOUT (900 * HZ)
 #define ST_LONG_TIMEOUT (14000 * HZ)
+/* Fit the signed timeout arguments and the jiffies interval. */
+#define ST_MAX_TIMEOUT min_t(unsigned long, INT_MAX, MAX_JIFFY_OFFSET)
 
 /* Remove mode bits and auto-rewind bit (7) */
 #define TAPE_NR(x) ( ((iminor(x) & ~255) >> (ST_NBR_MODE_BITS + 1)) | \
@@ -2306,6 +2308,7 @@ static void st_log_options(struct scsi_tape * STp, struct st_modedef * STm)
 
 static int st_set_options(struct scsi_tape *STp, long options)
 {
+	unsigned int seconds;
 	int value;
 	long code;
 	struct st_modedef *STm;
@@ -2403,15 +2406,18 @@ static int st_set_options(struct scsi_tape *STp, long options)
 		}
 	} else if (code == MT_ST_TIMEOUTS) {
 		value = (options & ~MT_ST_OPTIONS);
+		seconds = value & ~MT_ST_SET_LONG_TIMEOUT;
+		if (seconds > ST_MAX_TIMEOUT / HZ)
+			return -EINVAL;
 		if ((value & MT_ST_SET_LONG_TIMEOUT) != 0) {
-			STp->long_timeout = (value & ~MT_ST_SET_LONG_TIMEOUT) * HZ;
-			DEBC_printk(STp, "Long timeout set to %d seconds.\n",
-				    (value & ~MT_ST_SET_LONG_TIMEOUT));
+			STp->long_timeout = seconds * HZ;
+			DEBC_printk(STp, "Long timeout set to %u seconds.\n",
+				    seconds);
 		} else {
 			blk_queue_rq_timeout(STp->device->request_queue,
-					     value * HZ);
-			DEBC_printk(STp, "Normal timeout set to %d seconds.\n",
-				    value);
+					     seconds * HZ);
+			DEBC_printk(STp, "Normal timeout set to %u seconds.\n",
+				    seconds);
 		}
 	} else if (code == MT_ST_SET_CLN) {
 		value = (options & ~MT_ST_OPTIONS) & 0xff;
@@ -2942,7 +2948,8 @@ static int st_int_ioctl(struct scsi_tape *STp, unsigned int cmd_in, unsigned lon
 			timeout = STp->device->request_queue->rq_timeout;
 		}
 		else
-			timeout = STp->long_timeout * 8;
+			timeout = min_t(u64, (u64)STp->long_timeout * 8,
+					ST_MAX_TIMEOUT);
 
 		DEBC_printk(STp, "Erasing tape.\n");
 		break;

base-commit: 3650bb41391b51d9dcf87b0480ecafeb1526252f

