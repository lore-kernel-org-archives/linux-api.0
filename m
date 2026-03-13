Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 886A13A63E4;
	Fri, 13 Mar 2026 15:34:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773416041; cv=none; b=tqEtGTLyj/iOOmDsyisqwdxgIXuS+6JA3XxCD12fuDwX13sG33MfzkU5Np+N3wf4zGlL8IKRYdKoz7pq59hg14qcUEUD8nxy6sq6GX6MboaLD48ABMPf1Pd9VPGqpoyw1R4wOwkKg1bbOVKl/7Ml7NsBsWtBAD/tOFMCXtgm4kE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773416041; c=relaxed/simple;
	bh=/57rLagdpso9RADp3gWefH6GVRTYqd9uadYqHeXEKaQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VF2P1Mf9cJNmVhSE+pmJOw7u1JTMfFwRHsJklZ6J6mI0dnNzkN7Oi04ITVSXL/rshPa/qo5wQUHV8nYjnwW0twKmwsWFBM//gY0zWQFDl+hFX+5/Mus2AunbIvPXZOwBVPq4vakg89+M3DdPQMCk5zuFKRm8kJwQ7+l3ojwSrHI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Keff5Lh+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Keff5Lh+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F7E2C19421;
	Fri, 13 Mar 2026 15:34:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773416041;
	bh=/57rLagdpso9RADp3gWefH6GVRTYqd9uadYqHeXEKaQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Keff5Lh+eDjMTz8sfSiLCc8+mjV4TMqBgtlrzjUdssPeYvZRYdNjASaO/+XuoJgE1
	 kr3xoDABlmKQcEe0tDhs1A96sG19XgeX1xYPdBFY+eoEuG99IuGkvM0aoHdQ+2T2XG
	 8Ca3+Yd2+xexRuMkZ7LKqaGXCiBoRY9qmIqsyXJM=
Date: Fri, 13 Mar 2026 16:33:57 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Sasha Levin <sashal@kernel.org>
Cc: linux-api@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-kbuild@vger.kernel.org, linux-kselftest@vger.kernel.org,
	workflows@vger.kernel.org, tools@kernel.org, x86@kernel.org,
	Thomas Gleixner <tglx@kernel.org>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Dmitry Vyukov <dvyukov@google.com>,
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
Subject: Re: [PATCH 5/9] kernel/api: add API specification for sys_open
Message-ID: <2026031343-raft-panhandle-0a21@gregkh>
References: <20260313150928.2637368-1-sashal@kernel.org>
 <20260313150928.2637368-6-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260313150928.2637368-6-sashal@kernel.org>

On Fri, Mar 13, 2026 at 11:09:15AM -0400, Sasha Levin wrote:
> Signed-off-by: Sasha Levin <sashal@kernel.org>

No changelog?

> + * since-version: 1.0

I think since older versions :)

Anyway, very nice documentation, will be good to have this as part of
the kerneldocs no matter what the result of this patch series is.

thanks,

greg k-h
