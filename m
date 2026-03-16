Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79F16146D5A;
	Mon, 16 Mar 2026 23:29:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773703788; cv=none; b=Gp2LB5bgKuW1l5yuTmZXJ36CLIFUwlPYZaBh5gTmScA8YPFyVPSW9iXQN91PgEmHleWOoyZSxZKK8pQDcsVKhtU0a9XBcSfKM5tp0nBNV2FBrm51peQW0OdAcYfcPp3xTTzXQC1OQDGDasavNiuAjPVHxjhvFBC97ueYD+gO3wg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773703788; c=relaxed/simple;
	bh=NCadKS5ZsnHD2ps3JUYPHi7Yeh7UZFaGoaJyQDUn554=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jeSqYRoNqjMW7H1EBJjwTREnlPXeIqmHlyAjKioUfmCFEGmwEhBnytIiKV1qegJiMq/WeIezPmWD7Gbi01qDCsbCmS4hn9thnJQAtQ2D9ZJmWSPI+GWyCufinJFXQtlr8GMmn5BWxKet9sNWqo/+SJ1f8wenNxGkV9plFkxKcLM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VCAQuhQY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VCAQuhQY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA388C19421;
	Mon, 16 Mar 2026 23:29:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773703788;
	bh=NCadKS5ZsnHD2ps3JUYPHi7Yeh7UZFaGoaJyQDUn554=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=VCAQuhQYZcMND8Fu7rUdMk0lzEdJMHLtiw/XbeupwvkmulIXY3GA5LMTU1qasfKuC
	 57Pm5IDe+FCqs8l6G0OoDGf9zk07bHw3z39KGe/WSDhezLZheaKZP5ywtRBBpX6Vrr
	 KjAHsVFaW+mha9DGzYwyNd5kc7/7WlY4fjYh3ByrfMNk3eqXg7kMfo7I/UfzRgbMFW
	 2RhfiFXeeH1fk5rpCoEtjh3/xrqvF+KdB++0qLnmfINKkFv+BsTX09nlPd0X+RiKcG
	 hP7ku4/qrryLZUtWArBY1UYFh3icQ0RkoussBqGzC+jiAFosp8e3s9+nvsvU4Z3qjg
	 Qt5WwQTeJ4AwQ==
Date: Mon, 16 Mar 2026 19:29:46 -0400
From: Sasha Levin <sashal@kernel.org>
To: Jakub Kicinski <kuba@kernel.org>
Cc: Dmitry Vyukov <dvyukov@google.com>,
	syzkaller <syzkaller@googlegroups.com>, linux-api@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-kbuild@vger.kernel.org,
	linux-kselftest@vger.kernel.org, workflows@vger.kernel.org,
	tools@kernel.org, x86@kernel.org, Thomas Gleixner <tglx@kernel.org>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Randy Dunlap <rdunlap@infradead.org>,
	Cyril Hrubis <chrubis@suse.cz>, Kees Cook <kees@kernel.org>,
	Jake Edge <jake@lwn.net>,
	David Laight <david.laight.linux@gmail.com>,
	Askar Safin <safinaskar@zohomail.com>,
	Gabriele Paoloni <gpaoloni@redhat.com>,
	Mauro Carvalho Chehab <mchehab@kernel.org>,
	Christian Brauner <brauner@kernel.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Andrew Morton <akpm@linux-foundation.org>,
	Masahiro Yamada <masahiroy@kernel.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Ingo Molnar <mingo@redhat.com>, Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH 0/9] Kernel API Specification Framework
Message-ID: <abiSas7bIIXkb4Uj@laps>
References: <20260313150928.2637368-1-sashal@kernel.org>
 <20260314111822.63a2ba4a@kernel.org>
 <CACT4Y+arWePyxnV3hWk5RanWZpoc7=ALQ6DV_2MCuQkNoTtJUw@mail.gmail.com>
 <20260316155756.25b985f5@kernel.org>
Precedence: bulk
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20260316155756.25b985f5@kernel.org>

On Mon, Mar 16, 2026 at 03:57:56PM -0700, Jakub Kicinski wrote:
>Didn't even think of that. LLMs should make short work of this sort of
>extraction of information from source code..

This is the primary reason that this proposal resurfaced :)

I've originally proposed[1] something like this almost a decade ago, but when I
started trying to write the actual specs I hit a brick wall: it was simply not
tractable.

With LLMs, writing the specs is something we can actually pull off, and we can
verify their correctness so LLMs don't get to hallucinate.

The specs you see in the following patches are all LLM generated.

-- 
Thanks,
Sasha
