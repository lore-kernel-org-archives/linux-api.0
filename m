Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793915593;
	b=zuR7loIORa7kJ7OLfNxRE/mqV+4PmK5HNGQBQ7u7W8l5i1c5Whs1nd1yFNxWoEYyf+Fb
	 YoEmNTXV3jiLN2gwnJFFT600/vnPaHijdEujI93wnGcz1B5/RILw82SWUgNAEi9OTxPAf
	 /dZTUdoSjzEml29T5Jq+B2i9ZxIukEtwTH7CbenNfDpduIH8QPWuQXPeqP3ni1RsNlHUe
	 DQOECalSNDe6DFMQKBFlF+5iL9NzZ/8551TewtamlkmuI9uAcMlrxszJxvJr20CUIm1Hr
	 ABENw6hSl3Oc7Ec4s9LvjocL74ESkiQMUEZmSauJUIwFttM0hu187AtslZoSh0G+Udw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793915593;
	h=Received:DKIM-Signature:From:To:Cc:In-Reply-To:References:Subject:
	 Message-Id:Date:MIME-Version:Content-Type:Content-Transfer-Encoding:
	 X-Mailer;
	bh=sG2USpY9Qzk2BNUDuSKagpHgcyzqMiC0cqV68Oi+240=;
	b=dFq5s6NjG41qKGPTQxSoh4RkYCledFz+Fwf1l7ayrFvsOkY5Zi1j+tIxSrS7knjf5YxY
	 2x7kZtPyUZ+KT5xTM2Px8+LpHJOvv/9b/J2/YUMdR5HRMdnSY3f7ICObMi5Y59H55WaB7
	 p8Vy87uRyxeHPOu93ptc5xDOrbmme2tKXosXup+7KhHG3xQkoUcqwYUXIPukApvB3E/xC
	 th1+DczVhO0UFX9Z2BE+/+t4W6FJVa19n/AzzCjHEZCkeL5U8MP4UkEAc9QU1Pldp4gS9
	 oF2v0YylJkBzNu4hHZVqz/W3DuPMh0RR1/ddn5mIr9C1xn91Rnac9V5XP3FguTMeR8A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=TDzlJLUD;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 116D8606A326;
	Thu,  5 Nov 2026 21:53:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=TDzlJLUD
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8AD71F0089F;
	Thu,  5 Nov 2026 21:53:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793915592;
	bh=sG2USpY9Qzk2BNUDuSKagpHgcyzqMiC0cqV68Oi+240=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=TDzlJLUDDSRfGqZBJG7aivEmzDqEEi4tKR44i0a+ayY9bG44AQWP6wGeTU1tPZO3K
	 qumPeM/SogAL4SVAKqk1ldXvXAFPbxwQyq0Iq/IGzDxScaWsmTAwj8nJF9uipz5I7o
	 d/qYZD3RYDd2WdoxPM1I884tREUZzBsWnPooGaOk5+mddd3f2owvyRGHABpcuP0070
	 xmsHO0n6gbuhDawekKHBMJ7pTCObrvSb6i+aJ/xSkgI5C+gPeg3nMHq78PWCTjEI0l
	 lRvJMZ36gYp8qqqIRTY+9LV4KAQTSXqOAeMSuO8D41B55S57gdagPTEW1cSuFM+py8
	 d4Bv9MXXv1I2g==
From: Christian Brauner <brauner@kernel.org>
To: Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, 
 Jeff Layton <jlayton@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, linux-fsdevel@vger.kernel.org, 
 linux-kernel@vger.kernel.org, linux-api@vger.kernel.org
In-Reply-To: <20261029-mgtime-statx-v1-1-175b5afdf2fb@kernel.org>
References: <20261029-mgtime-statx-v1-1-175b5afdf2fb@kernel.org>
Subject: Re: [PATCH] statx: add STATX_ATTR_MULTIGRAIN_TIMESTAMP
Message-Id: <20261105-fachabteilung-irrwitzig-bersten-6dbe710891ce@brauner>
Date: Thu, 05 Nov 2026 22:53:09 +0100
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Post: <mailto:linux-api@vger.kernel.org>
List-Help: <mailto:linux-api+help@vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-api+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.17-dev-ce4c1

On Thu, 29 Oct 2026 12:28:16 -0400, Jeff Layton wrote:
> Userland has no way to tell whether a file's timestamps are multigrain,
> i.e. whether successive changes after a query are guaranteed to yield
> distinct timestamps.
> 
> Add STATX_ATTR_MULTIGRAIN_TIMESTAMP and set it in vfs_getattr_nosec()
> when is_mgtime() is true (IOP_MGTIME is set from FS_MGTIME at inode
> init). Always advertise it in attributes_mask.
> 
> [...]

Applied to the vfs-7.5.misc branch of the vfs/vfs.git tree.
Patches in the vfs-7.5.misc branch should appear in linux-next soon.

Please report any outstanding bugs that were missed during review in a
new review to the original patch series allowing us to drop it.

It's encouraged to provide Acked-bys and Reviewed-bys even though the
patch has now been applied. If possible patch trailers will be updated.

Note that commit hashes shown below are subject to change due to rebase,
trailer updates or similar. If in doubt, please check the listed branch.

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/vfs/vfs.git
branch: vfs-7.5.misc

[1/1] statx: add STATX_ATTR_MULTIGRAIN_TIMESTAMP
      https://git.kernel.org/vfs/vfs/c/81f2cc03b537

