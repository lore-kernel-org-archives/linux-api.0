Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 696DC311583;
	Mon,  1 Jun 2026 16:42:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780332137; cv=none; b=B+U9s0EM+zLNVfRg7s7ffxyoSPJvL5fMJXXK+6/MfsgKi7gTCp/0yl0GYa+DM8kksgoOMFmzKQDilor4+6m0AkIChKwdvgspbSLBszI2b6X7x96XiIBB9I9e3YGlxLuv202b2KfiRM4RTAlrgrQYxmnSJUzSVPxwIwXJ5M7bERo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780332137; c=relaxed/simple;
	bh=BgJ9kx1/tXUuldxL8l+n8NO5M2/EWoe/peBIxTf96cA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=MkJ5xaSGkZS6brEu3BPd3WjIVIGJSGwldQ6zblOmQgV1VzyHFDGIfvnz2ZinEAzs3AvlaK5HDxv/hdN0HrCviIdSovw9Xy8HdxV49jnlyxsXHYwYJNnlZfee8Awa53Y79Wka8bEoggex7/Clnnme8VOMeWCEG4yJ5yiV4eq7zOs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dN2iZrqR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dN2iZrqR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA65A1F00893;
	Mon,  1 Jun 2026 16:42:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780332134;
	bh=teSdp9I1t1pRWNp/a7/eGoyDMHv3wjAOGwFHd06Ja2A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dN2iZrqRzXR4+E4RaAy6YxsO9Bh+RosZzGkVQQ5KpR8qZlhxfn7UjHG+ybsrgORsN
	 b/LzrLkcE/p4whNsHJV1MbXOOZ/zkgf8WdoYGwawV8FSAwR6H8gBoacmdsOzR8os6G
	 oDH1IUaauW6QHuorSlKqhMjG2U5jxKn4MhGBWT6SBY61/cMFinnp7GrWrrB0O8ZXm0
	 Oj2B/kkHRo4IU/gYxVb0nJPCq3V2F5/Ycp0+POLjcf0bLac7tYCKFXZKrMknrJT+gY
	 E9/TdDDEMRJogiYq811jJR+JlPnFcJLEMKZpjCDGUO55Y5XeBfXqJSK+BqfAYAHAiP
	 Dc2Lva0V1oi0g==
From: Christian Brauner <brauner@kernel.org>
To: Askar Safin <safinaskar@gmail.com>
Cc: Christian Brauner <brauner@kernel.org>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-api@vger.kernel.org,
	netdev@vger.kernel.org,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Matthew Wilcox <willy@infradead.org>,
	Jens Axboe <axboe@kernel.dk>,
	Christoph Hellwig <hch@infradead.org>,
	David Howells <dhowells@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Pedro Falcato <pfalcato@suse.de>,
	Miklos Szeredi <miklos@szeredi.hu>,
	patches@lists.linux.dev,
	linux-fsdevel@vger.kernel.org,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 0/3] vmsplice: make vmsplice a trivial wrapper for preadv2/pwritev2
Date: Mon,  1 Jun 2026 18:23:24 +0200
Message-ID: <20260601-enthusiasmus-canceln-anlehnen-0e62317a9784@brauner>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260531010107.1953702-1-safinaskar@gmail.com>
References: <20260531010107.1953702-1-safinaskar@gmail.com>
Precedence: bulk
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
X-Developer-Signature: v=1; a=openpgp-sha256; l=1316; i=brauner@kernel.org; h=from:subject:message-id; bh=BgJ9kx1/tXUuldxL8l+n8NO5M2/EWoe/peBIxTf96cA=; b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWTJbovatvNLlrOz2euq5KJVS68r/ax6FG7+bO79T8tOz 5zmb8r6q6OUhUGMi0FWTJHFod0kXG45T8Vmo0wNmDmsTCBDGLg4BWAiVTGMDC9rZr+8fVpQ+U58 ybRti67u4dKZrbrFpkqzdgmD/nptkwhGhssXZ37z/VPKklHqHGjgG1snrZHsoFtm95j5gujhq9w LeAE=
X-Developer-Key: i=brauner@kernel.org; a=openpgp; fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
Content-Transfer-Encoding: 8bit

On Sun, 31 May 2026 01:01:04 +0000, Askar Safin wrote:
> This patchset is for VFS.
> 
> Recently we got a lot of vulnerabilities in splice/vmsplice.
> 
> Also vmsplice already was source of vulnerabilities in the past:
> CVE-2020-29374 (see https://lwn.net/Articles/849638/ ).
> 
> [...]

Applied to the vfs-7.2.vmsplice branch of the vfs/vfs.git tree.
Patches in the vfs-7.2.vmsplice branch should appear in linux-next soon.

Please report any outstanding bugs that were missed during review in a
new review to the original patch series allowing us to drop it.

It's encouraged to provide Acked-bys and Reviewed-bys even though the
patch has now been applied. If possible patch trailers will be updated.

Note that commit hashes shown below are subject to change due to rebase,
trailer updates or similar. If in doubt, please check the listed branch.

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/vfs/vfs.git
branch: vfs-7.2.vmsplice

[1/3] tee: fs/splice.c: remove unused parameter "flags" from "link_pipe"
      https://git.kernel.org/vfs/vfs/c/a9f7db50ed2f
[2/3] vmsplice: make vmsplice a trivial wrapper for preadv2/pwritev2
      https://git.kernel.org/vfs/vfs/c/e2c0b2368081
[3/3] splice: remove PIPE_BUF_FLAG_GIFT
      https://git.kernel.org/vfs/vfs/c/7d75aa8edfce
