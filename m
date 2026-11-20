Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795178829;
	b=XVER9FJmNM/h0G5IZgn9WrLCE862G8DXPxmCZBmot2X2S7vujLutRtSGZ1K2zclMGbuP
	 XJ3R3roLsrwpVplInNJSfAMzs/bW6FnQfscZ5yg5qkxCSzTnm27ztraAsxqEKsmPvMi5Z
	 jD+Bw/4fbij2zQjHAZUsmgdDVk1rKV/73NVIDnD1nm/A+bnGHqDHPFUJwFUQO5aA76wc3
	 MOSUQD1diwRbr3lkkhUH/QhOIyxXs3RdBHlPas7L7+KbCK0v+UPlsxjpY8RmyqTdTEOjc
	 Q2h4jk74R1+LFJ2OMSZyAgGEFbcZArKa5hHBQECa5HhFK2B1eu5rVdcFdkjoNRL1MOg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795178829;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Type:
	 X-Developer-Signature:X-Developer-Key:Content-Transfer-Encoding;
	bh=LdDRBo821w3P+jIu8o4fDxJzmh+upxb4WP1I5LQVriw=;
	b=JWd9q3KrUjqdnnjzxQJttEm7mfX1DtggyEx6m8fDy02Q+qcRW78ouedTHCIbNn5Al/pR
	 tKGtQsQlE7Z2ePscsZdhMOJm6xFGquPcTivwrMiHj3DYmZ8+dCBbJpkcoEt4f6fEYWPJN
	 /wsI7HbxtTgzltznyANmdc1fqZWQFCj5ayFSX8WYedNnczrkeFfOBOo0PONqiWGLn2Q2g
	 Kz9uw0LxS6fISBjlkWpp3D2ZrovN72IlpcKEGQNi6clxhr82/Qf7apbgwEeBkDkXUBFTX
	 ef17mEwyKnqZoYkWMYkiyvllxmbQ4O8ZIDKbhth/rg4nsxpCUEa4jK2xJadev58Nv5A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="AQzd/eHL";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90A72606A332;
	Fri, 20 Nov 2026 12:47:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=AQzd/eHL
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D79F81F000CA;
	Fri, 20 Nov 2026 12:47:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795178829;
	bh=LdDRBo821w3P+jIu8o4fDxJzmh+upxb4WP1I5LQVriw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AQzd/eHLtLlryBDTbTSwdP+NNJicwq4dSqmuvhPn3EtjSLviD/dtYdLUvMH3v5bvw
	 LNYgNp1fzSAdzTC0Rev/he0B/2PC69Y9FLyTGlVBeAZR807lrBxOFv+gjVDGMKCXwl
	 W17BCgzeqCdsRMBRVHZQrwGf6xx2RgiKKrwnMulM1sypFlQLdBK3f6lVRNAAeBIvbR
	 2KShrHs6uypnJ4erxQ35aoie/ClSHOgefo36yY/TcPLveFg501anDYStR8mfF8yv6E
	 AfFelslCFMmZ2SuWTO2rS8/Yz9yDg1/BLl2J+mmQNFjVlPv03U7eN3CGLaX48FYB91
	 H1qsQb46R+/EA==
From: Christian Brauner <brauner@kernel.org>
To: Jiwoo Kim <arpe1618@gmail.com>
Cc: Christian Brauner <brauner@kernel.org>,
	Sargun Dhillon <sargun@sargun.me>,
	Arnd Bergmann <arnd@arndb.de>,
	Jann Horn <jannh@google.com>,
	Chen Linxuan <me@black-desk.cn>,
	linux-fsdevel@vger.kernel.org,
	linux-api@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] pidfd: restrict pidfd_getfd() to the caller's pid namespace
Date: Fri, 20 Nov 2026 13:46:46 +0100
Message-ID: <20261120-reglementieren-mehrbedarf-miesmacher-a12bf1df0b81@brauner>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261117152332.1221-1-arpe1618@gmail.com>
References: <20261117152332.1221-1-arpe1618@gmail.com>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1471; i=brauner@kernel.org; h=from:subject:message-id; bh=xgHWRgoMuvE14D/QKDcYhYT14B8Hr+inO75uHHhpeW4=; b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWQzOLoxP3VX9vDy+l1aviGNN+ZA9G6rA489p5ev2Mtxw 5LpHtfzjlIWBjEuBlkxRRaHdpNwueU8FZuNMjVg5rAygQxh4OIUgJt8iOGvPBtb7XOP9i7W/iDO dkmRL2qrPkaWe39+sO3q4s68v42HGf5ZOcb4tPK3ecsrBYROrfz9VYVp8kHX84LKB4QORSzekcc CAA==
X-Developer-Key: i=brauner@kernel.org; a=openpgp; fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
Content-Transfer-Encoding: 8bit

On Wed, 18 Nov 2026 00:23:32 +0900, Jiwoo Kim wrote:
> pidfds can cross pid namespace boundaries: a task can obtain one for a
> process outside of its own pid namespace hierarchy through SO_PASSPIDFD
> or SO_PEERPIDFD, via SCM_RIGHTS, or through file descriptor
> inheritance.
> 
> Commit ee8323fdc827 ("pidfd: restrict task access ioctls to the caller's
> pid namespace") made the pidfs namespace ioctls fail with -EREMOTE
> unless the target is visible in the caller's active pid namespace, as
> PIDFD_GET_INFO already does, following the rule that operations which
> grant access to additional resources of the target require this [1].
> 
> [...]

Seems fine.

---

Applied to the vfs-7.5.pidfd branch of the vfs/vfs.git tree.
Patches in the vfs-7.5.pidfd branch should appear in linux-next soon.

Please report any outstanding bugs that were missed during review in a
new review to the original patch series allowing us to drop it.

It's encouraged to provide Acked-bys and Reviewed-bys even though the
patch has now been applied. If possible patch trailers will be updated.

Note that commit hashes shown below are subject to change due to rebase,
trailer updates or similar. If in doubt, please check the listed branch.

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/vfs/vfs.git
branch: vfs-7.5.pidfd

[1/1] pidfd: restrict pidfd_getfd() to the caller's pid namespace
      https://git.kernel.org/vfs/vfs/c/0a5864ad213c
