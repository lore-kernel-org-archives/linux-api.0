Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793899170;
	b=y7BXXsWPJo2ttigD+dfopBrNz6I5TTreFTwITTpZHAPfYicUJDdSFE25O6PI1AGW2PzE
	 YKNFpCLQAxzuCuYQNN0t+jCsxNnrwC1aheRofoIwAfreZLXWFyZlVUVdjI8NdPZpLFqlM
	 BouJ06EGrVhuy6y+MNlrR58kXoOCoKKepZf03NTFX6sbhL3icZwnlP90AvlpkSxLOedtW
	 OmXG9u1dOMGZWiZHbE7nsVzVlBGh7SUo+fYunAdri01sJtEKgC2dUH/pMRLT8tXdByy0j
	 yEfvQpvUI7rQai1ws/OQ9HJ9DG+tPNHpvmh6HWZVSTVIITaaKsAsUZ77ENCH4UPNGIA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793899170;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Type:
	 X-Developer-Signature:X-Developer-Key:Content-Transfer-Encoding;
	bh=pyTb+/pJLSrwt4XUdkCfU4wPbzpalLAiHr7jIUNDISI=;
	b=N1xVHhJEeKgvtR1iSVVas51dY6EC17naUGA7kZyL313593rjSsgVLDonoDhuJ/KiFXx4
	 Zrma5M7qVqpDuTYhrMINhgG8K4XGnvH4+nwO9GrY/wnXow1t6njpjisebF2T0MfrSSlea
	 zG+WVzeTWqb8LLVmFuzMP6Nrhuo9hiu+GCShx+oTT0fGSajYeNEM4wP1mpI09O7McKoza
	 +sWArOf+HfIYAN1yASB73jXJQAE3xiqR5YhzcK0n1T12jIM5tG/vvyGRzuKvSssOwV8HJ
	 oy28CyTUr5goM99sxjITNtySYKFqPMUTGG8vKZsI3ainOrt9FkMzvAMOa1/8JaG+Z5Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=WNmFQCaC;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6510E606EE9B;
	Thu,  5 Nov 2026 17:19:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=WNmFQCaC
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0613B1F00A1E;
	Thu,  5 Nov 2026 17:19:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793899170;
	bh=pyTb+/pJLSrwt4XUdkCfU4wPbzpalLAiHr7jIUNDISI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WNmFQCaCgcOEolYzgllzTZy11+7reKuDsYfH+PW1N0Yv4SzXi9OGgYFAdBqrvaBEi
	 b9ofFQxFrVHgB+a0/rZnKLKrq19RFpwdMgXJsiYbHILUSjCAx3elR89YxRGVockb8t
	 4RdhJ9UpBhS51SpxKaUPoIJvYL9OQL3Uo0Tk2oU++MllfusAeTvCMXgrhH8DacHY8w
	 ZoABlDpfMCLsodNg7U06JBBJVplYC+WoahfTTukCXLN4Ta2kk71zX3EHTj1XDO65by
	 QfRu0TIaF7hRNep6sKcMVYIHC7c8/hUcPrMCmG0znSU0bqIYMKWgolnuUP3KNJH0UD
	 0nu3gwRj+ziRw==
From: Christian Brauner <brauner@kernel.org>
To: Jann Horn <jannh@google.com>,
	Chen Linxuan via B4 Relay <devnull+me.black-desk.cn@kernel.org>
Cc: Christian Brauner <brauner@kernel.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Jan Kara <jack@suse.cz>,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-api@vger.kernel.org,
	Chen Linxuan <me@black-desk.cn>,
	stable@vger.kernel.org
Subject: Re: [PATCH] pidfd: restrict task access ioctls to the caller's pid namespace
Date: Thu,  5 Nov 2026 18:19:17 +0100
Message-ID: <20261105-stadt-diesmal-ansonsten-408471a29224@brauner>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261027-pidfd-task-access-v1-1-d46cf0fa4ca1@black-desk.cn>
References: <20261027-pidfd-task-access-v1-1-d46cf0fa4ca1@black-desk.cn>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1613; i=brauner@kernel.org; h=from:subject:message-id; bh=Qr+Jb1sJ1vPFC2VOoqGkq9cW4xW4++1uFE1E9/S8cMQ=; b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWS92TVt/qaONZ6LT3+cLR3J9MX97YWbf3b4x2ruXvtO0 OLsPoMPqzpKWRjEuBhkxRRZHNpNwuWW81RsNsrUgJnDygQyhIGLUwAmkt7M8Ic7O/nag2058/3S rnDMUFqflxHuabv32bqerz8lE/K1Z2owMmxYGG7Gc2T1mkudDWv+62w94b04/svWm/yalZ+fTzL +M48dAA==
X-Developer-Key: i=brauner@kernel.org; a=openpgp; fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
Content-Transfer-Encoding: 8bit

On Tue, 27 Oct 2026 16:22:15 +0800, Chen Linxuan via B4 Relay wrote:
> pidfds can cross pid namespace boundaries: a task may obtain one for a
> process outside of its own pid namespace hierarchy through SO_PASSPIDFD
> or SO_PEERPIDFD, via SCM_RIGHTS, or through file descriptor inheritance.
> 
> The namespace ioctls gate access with a ptrace check against the
> target's credentials only. That check does not account for the pid
> namespace relationship between the caller and the target, so a task
> inside a pid namespace can use a pidfd obtained across that boundary to
> acquire namespace file descriptors of a task outside of its hierarchy.
> 
> [...]

I think this needs to be backported. I added:

Fixes: 5b08bd408534 ("pidfs: allow retrieval of namespace file descriptors")
Cc: stable@vger.kernel.org

---

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

[1/1] pidfd: restrict task access ioctls to the caller's pid namespace
      https://git.kernel.org/vfs/vfs/c/3c40d51327f2
