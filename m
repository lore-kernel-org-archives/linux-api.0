Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.208.178
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795102357;
	b=HwV9Hpub3p8daOH1jj3Ew0lmNumnECIDe4j6Qu+mNdEmpvl6ZM1x9GlLlEgR51F2vFIK
	 pu1/dYkfODTPC+aG9CvMnPfVkPV5dgMoQ3NsuEQw96f6MOTXApvh896z6kb1AQUVnEWsQ
	 VprV8HacQFgi2TA2OS6BuyXGY2WrfsnPRB4SWeOi5eKyBNxIwOnAt3TEixAPmgn2eCKyd
	 odpRQMBKZFLhZGJK3Dlf6gABM6+gQb81g4AJD83XD54enBZR5oEwiGmc0u0NUEQe+Zle3
	 ZyF/YvVMEKnCENdxWDEX1PMXlcz8AfjKlah9GWZMTY1rY4BRwyWzVS3gmhSalfK1z8Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795102357;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=f7T2TmAinoSSVrUkDLWCSHpGLO0VMoU6RTqJIGDHf8c=;
	b=Hktw4ys/faNMtRRLKP9aPRRA/zy7SWHAoyZiBx2ZMBAX+e44g95M4nYJ6oQfZmBKhEmJ
	 h+z4f3rQxHrZ5kIU+OShSCs9IxeKTzp6KLjsGusSwU6fFPE903JvTsCBC1BF/PuTJw99P
	 qIdbV1AqE4zVJHpuVZVC281bsaRmchH0TMTKHoY8LvXAkOCWm2YJz53FYwdmpIwszppkf
	 D1DGjdCgBTn2vOuN8UQBtqoiiHcru7+vSWVaJY3R4MceBipusyrFuIXJ9xm+BTl/C5418
	 67DwUBhdsRAy5ZVsUwPs7kG8FRdQC580hNPa/kqniOIokEQ8mVDf5pBoWr17PPGiw1w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=EriZpb1V;
	arc=none smtp.remote-ip=209.85.208.178
Received: from mail-lj1-f178.google.com (mail-lj1-f178.google.com [209.85.208.178])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5822B606A33A
	for <linux-api@vger.kernel.org>; Thu, 19 Nov 2026 15:32:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5822B606A33A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=EriZpb1V
Received: by mail-lj1-f178.google.com with SMTP id 38308e7fff4ca-3ab30b3212aso21399011fa.0
        for <linux-api@vger.kernel.org>; Thu, 19 Nov 2026 07:32:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795102355; x=1795707155; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=f7T2TmAinoSSVrUkDLWCSHpGLO0VMoU6RTqJIGDHf8c=;
        b=EriZpb1V/2zno0fmMO54HL34Ty+nBUS/4UO0C6MvrvxZFEYE5Wk3AXr9C+UsTd1EKu
         e7VRl67WTxEo3VDt+hkZtLmFiEHnR1zJiLfC/Bq9BJKAFBDFohxqHF5Q1gg0wFZRWOaP
         GGmxEOrPJV8MRv3PkF03h/86SpZPKw+8KkyhjjjSRymeueMiKP4mQ8rtd0qNdqm/fzoE
         MNeg/d90yqGf1ngIGXcTcG1X2LenLIoGjIMBxdm9LKyp4bnMI848kU3NoOJqH9CbrAin
         fitPeVcUyIY+ve4q72M8iKNlPUyICj34RV6qW8QMN0CuPmRvl1c9rcr7e4C4EfPjdOm/
         0D9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795102355; x=1795707155;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=f7T2TmAinoSSVrUkDLWCSHpGLO0VMoU6RTqJIGDHf8c=;
        b=xRX3M+fzI0IS1Kdvhj10iDlsyku0uHA2S1fnSxtd2jV1glhoD4ADUo/iorjbQ7muNK
         VqrCSFs0cwgAHIZwc1R/hrvqWN4HwMt+C56P651POR2sD2HYvNF6ewbIVsT5vY9JhEwb
         wG8uXK+3la290nbYCiDShc3k4AvB8ikd82ZbFaC+5IEhOVJyxVe3RXSQiIoDdOf3xwlQ
         z5H+feO8jOYoaeGigPTy9aiiM1RzoMUzb1P3ibw+lLT+ntI1GfJmGjcu2C5P15J53cPB
         WvtCGHdnFWZqcBp0edB13ahUKoY79Rev7Np0tz/U6k6O59020AKdCOOYoy5H8v4BeOBU
         0sYg==
X-Forwarded-Encrypted: i=1; AL+hErFF5CXrr/3bBJZRs5bWkdU+hj1zrO2zpihQNnESYLpuPTCTZUHILfugR4HEOs0MI9wU9LxpLsm/dZ0=@vger.kernel.org
X-Gm-Message-State: APuU4Z/Hx/K6w419loNBMJl8uwrQBQ25JHrQJ1QPx02X5+Q5RLGYdzCc
	gRjrO/hvW7Ho22PP5vnnPoPiw3iGV/2U+bSqu+2QlvC8fyZL9fnxjNfhZ50x+DETDt0=
X-Gm-Gg: AZFdTZf2QVjPVbveyvhn74xuqJB0wHk+JRYwD1vg6e4I0a6kQXn8/NBUQJXzCBvt/8h
	PwgBRC5Us5r/zZInktWjPTFWKhFXz/3jDpG44guj8L8MsaUn0IIuLdqkR8pARHrCj3himhWzd6i
	A9iAc5ysMtwEWCRGYx8yf5hD7jqixF+yX0vg4BniGGt/PAHqFB7E3wAMFuROYouqHnAzwYSy7iH
	1+JiKRlaXLLdqITTcfJDoWH7va9DBiGjfuR/5b+vHR26dnznZGYf88YQr2uUIrWcM7SF1gT72b6
	WHmP3UIN6o8MOhWubo35CU6LkvfPKCk7yuRGQROar01ldzpFf8aCtl9j1v8bhlYCNYMnObLG+OU
	0gVIbUWgHngrps3sTZmQeYUppqWSqZfLlNBuj2CS2y/syVzkkbrrhu4nIBq1ITGHJu+dt962L2t
	4+KHpnd5oG3IHmSAyi64dUrZOk0mK352VQYjTWklXGn7/Rq13QHQxvU0POTZw63r61VsmBXZmy+
	xA9zSxHKWcSJUrySCiiYXo+GRhoUS5iCkyBJzBTuLzOvao7DDZHiQu00zHuOaeWR9EtJEHINFjf
	lAsmhJK7DxP2/IxR0YWciYrv7/dfmxKb3/pW1mPTzgBNaGJCiF3GNrSM0ewRb11KEATbOC49oJ7
	uTAPVLckhewTEwCgcCxpa9bF3nK77IjQJ4oOCa1DklvcpDs6dw9EX9FfJnFo=
X-Received: by 2002:a05:651c:a149:b0:3aa:ef31:e51e with SMTP id 38308e7fff4ca-3ae7fa644d5mr1204161fa.19.1795102355312;
        Thu, 19 Nov 2026 07:32:35 -0800 (PST)
Received: from Lauri-G-Pro-14-M4.intra.lakuz.com (n2vuxegwnwppvr5uhf9-1.v6.elisa-laajakaista.fi. [2001:99a:2ab:bb00:c16c:a39e:e605:54b5])
        by smtp.gmail.com with ESMTPSA id 38308e7fff4ca-3ae6ebe67e2sm11532121fa.33.2026.11.19.07.32.33
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 19 Nov 2026 07:32:33 -0800 (PST)
From: Lauri Gates <lauri.gates@gmail.com>
To: koraynilay <koray.fra@gmail.com>
Cc: Dave Chinner <dgc@kernel.org>,
	Christian Brauner <brauner@kernel.org>,
	Christoph Hellwig <hch@infradead.org>,
	linux-xfs@vger.kernel.org,
	Carlos Maiolino <cem@kernel.org>,
	Christian Brauner <christian@brauner.io>,
	"Darrick J. Wong" <djwong@kernel.org>,
	linux-api@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-btrfs@vger.kernel.org,
	ocfs2-devel@lists.linux.dev,
	linux-nfs@vger.kernel.org,
	linux-cifs@vger.kernel.org,
	Amir Goldstein <amir73il@gmail.com>
Subject: Re: Concurrent FIEMAP on reflinked files serialises on the AGF buffer lock
Date: Thu, 19 Nov 2026 17:32:22 +0200
Message-ID: <20261119153222.65195-1-lauri.gates@gmail.com>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <DMZ4VQ7SZ07T.29WMPQ0BQZGSS@gmail.com>
References: <DMZ4VQ7SZ07T.29WMPQ0BQZGSS@gmail.com>
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

On Thu, Nov 19, 2026 at 01:00PM +0200, koraynilay wrote:
> It doesn't seem like an FS_XFLAG_NOSHARED flag would touch this new
> change, but I thought it was worth pointing out, especially because this
> patch would also add FS_XFLAG_PROJID and a new FS_FILE_ATTR_XFLAGS_MASK
> to have a way to include both legacy and newly added xflags, so
> FS_XFLAG_NOSHARED would maybe also go there (correct me if I'm wrong).

Thanks, that is useful. I agree it would go there, whichever meaning
it ends up with: as a newly added flag its bit would be added to
FS_FILE_ATTR_XFLAGS_MASK next to FS_XFLAG_PROJID, since your
fileattr_to_file_attr() masks the value with it as well as the mask
bit.

Your mask also changes the question I asked Christian. With it, a
plain "may share" flag works the way stx_attributes_mask does: a
filesystem that sets the bit in fsx_xflags_mask answers, and one that
does not (btrfs today) reads as "not reported" rather than "not
shared". The inverted meaning was only there because file_attr had no
such mask.

One constraint for that case: the flag has to stay out of
FS_XFLAGS_MASK. As I read your fileattr_to_file_attr(), every bit in
FS_XFLAGS_MASK is reported as supported on every filesystem, so a
plain flag there would read as "supported, not shared" on btrfs.
Outside FS_XFLAGS_MASK the flag is also never seen through the legacy
FS_IOC_FSGETXATTR, which masks with FS_XFLAGS_MASK. That is fine,
since only file_getattr() needs to report it.

Christian, with this mask on the way, would you take a plain flag
(say FS_XFLAG_MAYSHARE, "may have extents shared with another file")
that filesystems advertise through fsx_xflags_mask? If so, I'll build
the RFC on top of koraynilay's series instead of using the inverted
FS_XFLAG_NOSHARED.

Thanks,
Lauri
