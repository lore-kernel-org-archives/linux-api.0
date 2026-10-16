Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA89E237180;
	Fri, 16 Oct 2026 03:08:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792120132; cv=none; b=IBp0idHdYWsG+qbSFFTGZQLiE2NpVrqxc1JFxKn+DCDekUHeQwkkJZ20FnlMHIcw57IHZ7y8lAcdIuXxzpRYUTNH9z/VlhGaND03Febr73EYQ8FynHEpyy9XHuEVe3aemAW1k+uezOqBi06W/hLQJIg0uo9Q0Or9NuAicYlUpN4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792120132; c=relaxed/simple;
	bh=gp7PRv3WjAiMJrp0DvXpRvTv3mwC8R3NiezXzUE7FxE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=p+LMgLNjwPWVP1tZ416Are2Zy4++cn/E6CuWcqckW+NMgoBgCC4ZnpznN0JFbDnZ1MVu+P8F0LPej1qfgRa2HuIeLyPWdUsKmJqWLmyv7/8c9iU80cqcWd1L6KI98aEa2AaGAqh5ZRK2VxqLI1jzVEDVyigUSdxYZrUNDzVS1q0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cXqVUDbB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cXqVUDbB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A82361F000C4;
	Fri, 16 Oct 2026 03:08:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792120131;
	bh=Z9zRtXHe/J1k/4/9wAeq1n+PwAt+ioXmV3zyjSNrjDw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cXqVUDbB3upAVaiO1Uu/YbCN1ZcSqSZo9E14gGPWnhxhDHZLdQznYi6v5aYx14Z6g
	 ia6g+2oZuIDMWOVm8qE4vLgMZg5q/1b0qPZDjDnjNRwvbNT31RWThWBAL674ZVIkw+
	 x3VpQsl1mDlcRwBCFH2V0pzID2qYthR18VDkDirVKBrvFxlOmhotUIqgwtmj8aFZ2K
	 MrRop1rywYQnuyvWu9BJmGrs9jNTVzZpYAkaDI9oeEPWg1Ll5yt+Tssy/mwzkfa3L4
	 cDnqY+SoIlbL0Ul6mJRZyfKo7GJjTfz8Wbn1zfpYY7VF9abeXv70XEsqq29g1zUmhB
	 SyQ7+o/JX4b2w==
From: netdev-bot+sinfo@kernel.org
To: Yingjie Wang <1075151112@qq.com>
Cc: netdev@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
 kuba@kernel.org, pabeni@redhat.com, horms@kernel.org, corbet@lwn.net,
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-api@vger.kernel.org, stable@vger.kernel.org, kuniyu@google.com,
 skhan@linuxfoundation.org, rdunlap@infradead.org
Subject: Re: [PATCH net v3] net: unix: reject negative max_dgram_qlen values
Date: Fri, 16 Oct 2026 03:08:50 +0000
Message-ID: <179212013015.408196.13069488977796391147@kernel.org>
In-Reply-To: <tencent_A643419B56079E9A448D97922763FF069F08@qq.com>
References: <tencent_A643419B56079E9A448D97922763FF069F08@qq.com>
Auto-Submitted: auto-generated
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

Hi!

This is an automated message. This series looks like a fix, but its
commit messages seem to be missing some information:

 - How the issue was discovered, e.g. hit in production, hit during
   development, syzbot report, manual code inspection, LLM or static
   analysis tool scan.

 - Whether the issue was actually triggered, or is only theoretical
   (e.g. found by code inspection). If it was triggered please include
   the symptoms, like the stack trace or error messages.

Please do not repost the series just to address the above. Instead,
reply to this email with the missing information, so that reviewers
can take it into account. If the series needs another revision for
other reasons, please include the information in the commit messages
then.

The evaluation is done by an LLM so it may be wrong, if you think
that is the case please reply and explain.
