Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793898503;
	b=Zh852tc7M5qHNzNMxMelO5htXUZTf0e3xC4iYf+/knoWNhdPsZ+1Q6Yo/6ky5F7H1N7k
	 J9JcX6AMV43XM9GA9PANoCu/hrJUEZDrYAnt8I1Wzda4yUw9ILH1K0tLBLHxp9/HUFuHj
	 cVe9UuelrJ8op5OJJmXivkx5wQbUSFVRDhfoEEjjSqDDRtZ0FTKNtsgGyJnofL6zMiO8n
	 It1rBqKmbIwkSx8QBDG95kVWuDKpEVWk/b3k6s0h3G8LjlvnLQZbnERrRvyXnf8u3eNij
	 BT3E8Q3OHuoHl7hRnadwRxHqTBbV3BPcJJmCyVn3nTPj5c14GxZfvTY+VyposMxGq8w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793898503;
	h=Received:DKIM-Signature:From:To:Cc:In-Reply-To:References:Subject:
	 Message-Id:Date:MIME-Version:Content-Type:Content-Transfer-Encoding:
	 X-Mailer;
	bh=U8wYmjtHMAASHb5/EoDSsqIXO68iCQ8RBmDXKLbTlSk=;
	b=SBaoJ9hVrcleewusgtK6759IeiyHfjtG1hUpBLd725Ko+RRgqZSxaecONi8hxHE8IScD
	 PdsMNC3eP5rojSGH6WujNI54iuuCulqljFt7zS0oIZEyU4NsxL1Mk+ZhxJoYz6UCeMPm/
	 j7M5e1xxIcdBuGadGB9eW2adzNrmFR/bsyZa+g9DV4qasjb8NQSKRW6xHbL5n6w72eMof
	 JfcXwgQcryAhvdRWS6RtAbl7FCcj+dcMZDT/M6yyLz+4Cl8B6eiAa4Z52DHKSxTaYXFDp
	 YGAuuDkktQq+6leGf3tWNWB+tHo75+9XLwhNHHxiiepxEtGtUrT3lCpW183EEa/H+KA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ndctuzMK;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A6C6606A33A;
	Thu,  5 Nov 2026 17:08:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ndctuzMK
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9A771F00A02;
	Thu,  5 Nov 2026 17:08:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793898503;
	bh=U8wYmjtHMAASHb5/EoDSsqIXO68iCQ8RBmDXKLbTlSk=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=ndctuzMKIe3PvgispHQ4Ipy1EiDwOj/DKB5U6UN8poRYUK1uWzZxdtX1CjYVsPeey
	 ZAJYjAGcLDaqAlbtUEKOfiAiymBvkjaJ9vS+FjFdmSE5zi8Yaj6ijFaznTZygaXxUD
	 zCDzUBA1CAuksCljns5qleIbm4JPDq0YTL59Z/Z+7jAPQCjDiNb6NGHUn1GTN2qEYh
	 EPU6auIrqZt6ytscEJKy/vIdkKc1ItYVSlzA4Zj5y1Idx0PSnzVTfmpuQI3CQ9H8CX
	 d1LBi9pF6od/fsNzwnXMyuH2eiX1OwiyPBvXK6ytODBy1hU2x4lstsDwq3ORVxCYwx
	 aqzsj6d7qm5Lw==
From: Christian Brauner <brauner@kernel.org>
To: Avi Weiss <thnkslprpt@gmail.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, 
 linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org, 
 linux-kernel@vger.kernel.org
In-Reply-To: <20261031072208.3096100-2-thnkslprpt@gmail.com>
References: <20261031072208.3096100-2-thnkslprpt@gmail.com>
Subject: Re: [PATCH] fs: clamp FIONREAD result to int range
Message-Id: <20261105-scham-hergibt-hochsehen-93528b3ac953@brauner>
Date: Thu, 05 Nov 2026 18:08:19 +0100
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

On Sat, 31 Oct 2026 09:22:09 +0200, Avi Weiss wrote:
> FIONREAD returns the difference between the file size and the current
> position in an int. When the difference is outside the int range, the
> result wraps, so a file with 4 GiB remaining can be reported as empty.
> 
> Clamp the result to the signed int range before returning it to userspace.
> Preserve negative counts for file positions past EOF.
> 
> [...]

Applied to the vfs.fixes branch of the vfs/vfs.git tree.
Patches in the vfs.fixes branch should appear in linux-next soon.

Please report any outstanding bugs that were missed during review in a
new review to the original patch series allowing us to drop it.

It's encouraged to provide Acked-bys and Reviewed-bys even though the
patch has now been applied. If possible patch trailers will be updated.

Note that commit hashes shown below are subject to change due to rebase,
trailer updates or similar. If in doubt, please check the listed branch.

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/vfs/vfs.git
branch: vfs.fixes

[1/1] fs: clamp FIONREAD result to int range
      https://git.kernel.org/vfs/vfs/c/f5ced3af5fa1

