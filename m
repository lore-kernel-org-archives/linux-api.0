Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=220.197.31.5
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795695955;
	b=zBw9fDgjpWQC83LoAnJx0eiz2EmlVGcJIpq22/H8LG8qN381iwP4HQYBoAKbUfnQpRi3
	 epbbt1dx6guAZyHsmCNNhDIfak5rPmBHE+z7RXaDtPBnbdlaZFN+VUVOgSuw784WuqpfW
	 WOu9Cpo/ryJovPk8mleK7DXFXCaCRiUjgcN+r6eWg8CYmJByzvS06cQdXGSZeRUAocElf
	 2JMXYfbiK81Tmhh06GcbLkwItKNGv5Q6MZTiL1uUkadHHjwuY5O3Y2hwapkLEV3zggpnD
	 cvvjhwTD1rZ5oNmr97f0IO5F7TnlKIaaYNeUDg+DSQFgnfoCt3mQEVhKp5TfbV3dFmQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795695955;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-CM-TRANSID:X-Coremail-Antispam:
	 X-CM-SenderInfo;
	bh=3wOnEFtR2BvaWD5aTM6QC7QGxUmtIiOljLpZRC0G0Pw=;
	b=2rEUFUeXXsHBAqbSGQm6gRwVVMRQMarGs+jtEZ0wQSSBiLD7ngnWAcARPWVML/i8SXvE
	 BnKNWBgY2pgw+LJ57AUSUYzccexpPf41Ez4HfCtHieFVv9sh+wxJKbUCKsAZyUwrkvopt
	 LFE+qjxkAPtltQKdDwJFjyc/YDidpW6SWYKMI9/UOEuJyTYECEQmVXq6JwGO3KrLA43SZ
	 HqpDCLIHGKRI4dAs4kk4iUbUmzkjL4aPxJtfYYTdXZHnnSONUdt63CbIArnGBCOnoJqAI
	 UCR3xdozpj58as3z12HWpcUmhpBLneoguY7o1NCThAC/FmBC1KVNQDLjSDRMGTTXXLg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=163.com;
	spf=pass smtp.mailfrom=163.com;
	dkim=pass header.d=163.com header.i=@163.com header.a=rsa-sha256 header.s=s110527 header.b=BhohUmQE;
	arc=none smtp.remote-ip=220.197.31.5
Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.5])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8F30606A31E;
	Thu, 26 Nov 2026 12:25:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E8F30606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.a=rsa-sha256 header.s=s110527 header.b=BhohUmQE
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-ID:MIME-Version; bh=3w
	OnEFtR2BvaWD5aTM6QC7QGxUmtIiOljLpZRC0G0Pw=; b=BhohUmQEUGklsLlvCV
	QnPe5iaZ0EAA9jlQ6Valq0RttKSOZygxsCvTADjkCnZIJ1BYze21dhhNxRMYwmyD
	ay+WEtcv8ECFwFWJeZvWxcS7qGkevHukWYohJ3Sm7wUjlghLmaI7I1Y0tKRMLXJj
	p2jHAnxkVr/OK6wn17nWG5I6g=
Received: from ubuntu (unknown [])
	by gzsmtp2 (Coremail) with SMTP id PSgvCgCnJhILJQhro1cxHw--.5768S2;
	Thu, 26 Nov 2026 20:25:04 +0800 (CST)
From: Shaopei Zhu <shaopei_1012@163.com>
To: Namjae Jeon <linkinjeon@kernel.org>
Cc: Sungjong Seo <sj1557.seo@samsung.com>,
	Yuezhang Mo <yuezhang.mo@sony.com>,
	exfat@lists.linux.dev,
	linux-fsdevel@vger.kernel.org,
	linux-api@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Matthew Wilcox <willy@infradead.org>
Subject: Re: [PATCH v7] exfat: add EXFAT_IOC_COMBINE to append a file's clusters to another
Date: Thu, 26 Nov 2026 20:24:41 +0800
Message-ID: <20261126122441.912162-1-shaopei_1012@163.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <CAKYAXd_Xc0XbehABVUOncbcDYxvfFg037+FxDivkM0NZMg29qQ@mail.gmail.com>
References: <20261124230746.850528-1-shaopei_1012@163.com> <CAKYAXd_ap120uprmarov-GuO0fb1eXEgw-U8G08L1xRJ9bv18A@mail.gmail.com> <20261126075247.850895-1-shaopei_1012@163.com> <CAKYAXd_Xc0XbehABVUOncbcDYxvfFg037+FxDivkM0NZMg29qQ@mail.gmail.com>
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
X-CM-TRANSID:PSgvCgCnJhILJQhro1cxHw--.5768S2
X-Coremail-Antispam: 1Uf129KBjvJXoWxJryDJr4fZr1rtF48GrWDCFg_yoW8uFW8p3
	yfGr1DKr1DJ3sIgwn7XF4UXa4Svr4Syr45AwnxJ343uws8Wr1xKr13Kay7Xrn8Gr4vqFWj
	qr4j93yDG3s8AFJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07USQ6JUUUUU=
X-CM-SenderInfo: pvkd01phlbiiirs6il2tof0z/xtbC6QAuvGsIJSDm0wAA3o

On Thu, Nov 26, 2026 at 5:54 PM Namjae Jeon <linkinjeon@kernel.org> wrote:
> Unlinking in the ioctl does not make the operation atomic against
> power loss. It only avoids the interval between a successful ioctl and
> a later userspace unlink. I don't think that is a reason for the
> kernel to perform the unlink. exfatcombine already has the source path
> and opens the file to pass its file descriptor to the ioctl. It can
> unlink the source file after the ioctl succeeds and report an error if
> that fails. The ioctl should only append the source file's cluster
> chain to the destination file. Callers must prevent concurrent renames
> or replacements if they need the pathname to continue referring to the
> same file.

Hi Namjae,

Thank you, that is a fair point and a valuable suggestion.  I will
rework the interface as you suggest in the next version.

I went through it again.  You are right that the unlink does not make
the operation atomic: a power loss in the middle can still leave both
entries referencing the clusters until fsck.exfat has run, so it only
removed the interval after the ioctl.  The state user space has to
handle instead, an empty source next to a destination that already
holds its data, is harmless and easy to recognize.  I also looked at
the existing interfaces that move or share data between files,
FICLONERANGE, copy_file_range(), F2FS_IOC_MOVE_RANGE, EXT4_IOC_MOVE_EXT
and XFS_IOC_EXCHANGE_RANGE, and none of them removes the source; that
is left to the caller, which already has the path and the permission
checks of unlink(2).

So in v8 the ioctl only appends the cluster chain of the source and
leaves it as an empty file, written to disk after the destination.
The unlink code in the kernel goes away, and with it the bind mount,
dead parent and failed-unlink handling it needed.  exfatcombine
unlinks the source after the ioctl succeeds and reports an error if
that fails, and the uapi header documents that the caller unlinks the
source and has to prevent concurrent renames if it relies on the name.
The fstests case and the exfatprogs PR will be updated to match.

Thanks again for the review.

Shaopei

