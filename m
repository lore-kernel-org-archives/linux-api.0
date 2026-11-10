Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794330881;
	b=hHV1/5kedS8Wiq8wykukPuRqat1DjYkuzvtaEnoRnAy0zKhzAgsDe8ARWJ5uNoSk25vB
	 6zO6Hijnf3uS01a8uMVpaP5nKpL8l8JX0nNAcBiegCSC0eGGtBwl+N9ZqO1TeOf6ye/A+
	 eKTbPZet25JDAO6mLubq+dnExz7hwengyVrNHfzhHncJkajX89vdbMwqjvuuAk92ufI+0
	 CtXNbEC/KQU97Fu5kQZrryWca4fAmoCrVGczHtKh1Uq5L2nd3Opg/1UKvsYyRmy0Gedxw
	 ZuaY/Lu/egVV+u+Pt30ZLlRyIEN/Rk5/sKw1EH9CFjYPVbSBxHJ+FNpVyqfU42aSbpA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794330881;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=2CWWwBUP75y7qeaBbwDnAx9ZaNZrhjbF8wSCiL7IKSU=;
	b=0uw5m70sTqlFkyYlaOevDnHqr8MV0ti3VqGRLYWpyhzOyFwt7H9yab3kVHgD/xAA/KDI
	 5A93KrLxYn9WaA1hezkxUuLtcXk/6VeBPGYUHKJ1iAMxCBix5LXL01VVcoAsZ54ynJFZL
	 KW62kSMlIil4qfV++SSOThpc8JLfvQb+8aq4zYmN9QBuRK4b7DAugUOkGtQojpCR/IPdc
	 LpaKqklsR6qTJzym+hK9FG4AQnPYxmBbBlc6ngWIO+v1L6D40Yc61NCMjuepm4wYZE2RM
	 tPNex639WtAE1ZLVHUkBghoXNQ3RYmFYdyjSg0MbQ9XTU5y0mo5zEWmUkz9Ad2XrXPg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=jwon+Oqb;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 203D5606A31C;
	Tue, 10 Nov 2026 17:14:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=jwon+Oqb
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1424F1F008A3;
	Tue, 10 Nov 2026 17:14:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794330881;
	bh=2CWWwBUP75y7qeaBbwDnAx9ZaNZrhjbF8wSCiL7IKSU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jwon+Oqb/6PP0H1Io0CQtrXfQ71uqFebwkSxchnbrREoZ2ERqfWIEXPqB3jOOPX/O
	 lTA+de6AB7YDR5Og30I+JjzHdVEyefUXxDm1FnwIhaX7LriRmYHswKuE9bPhrih1xY
	 REHOm+pSBrN1uEssH1HOvUCtHR1HeYFCmBlPPCubUtXhHqPGf4oXDexj5MFc+IY2vb
	 ojB6jkLMyOzEH89kXQnr8xHq28MHyKbi9nimZmfBOq1OvC5ZuJ4HkaLc4rLXbFxmDl
	 Z48pcdv73bOmHUCs54lCosSsdB0bKTRkwQKg/Y3Xum2UXQHZAW34ATP5IT3fIoGzk5
	 UJDbglDwIvcfg==
From: Sasha Levin <sashal@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org,
	linux-api@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kbuild@vger.kernel.org,
	linux-doc@vger.kernel.org,
	Christian Brauner <brauner@kernel.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Nathan Chancellor <nathan@kernel.org>,
	Nicolas Schier <nsc@kernel.org>,
	Thomas Gleixner <tglx@kernel.org>,
	Mark Brown <broonie@kernel.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [GIT PULL] Kernel API specification framework for v7.4
Date: Tue, 10 Nov 2026 12:14:37 -0500
Message-ID: <20261110171437.2854704-1-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261025164719.1831477-1-sashal@kernel.org>
References: <20261025164719.1831477-1-sashal@kernel.org>
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

Hi Linus,

Ping? It didn't make rc1 and I never heard back.

Are you still planning to pull it? If not, could you tell me what you
don't like about it? I'd much rather fix whatever it is (or rethink the
approach) than send you the same thing again next cycle.

It's still the same tag, nothing changed on my end...

-- 
Thanks,
Sasha
