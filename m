Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F00735F183;
	Fri, 13 Mar 2026 15:49:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773416973; cv=none; b=NPlMougPw2a6tTlocKg8EHdE3aJQH2vHgLRX1QKYSttpMXhoF6gHTZp4xF5xiRKTxdywzUMFKMmQ842RNtqCrDYxERmCuwL1rowT/cBjFgDUVxq0XvPKzvOEhutskTZNPbWi5kNCS/FsMNhOKYEsElKRrugOVBYhz5qa4pE7nns=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773416973; c=relaxed/simple;
	bh=y+DTNVJV9nqWfR3Hajp0ic/eCXFjLQRn7oaLbm1czrs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XBx4EBuvEi55WKUJWZjlhYE3tog8PdAROhNN+CRX15wWAp24IpCWj20yhuJHNWtteysd6HN1YtJDbHawMb6PvVVObcyCsKyeLW7I3hRy33romty2Fecorr0XfkuZ7Y2t+HEeM7FIgMl8xfqODFwjTZFnhB+QzEUeF6Ftv20wMIY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1Li2zfiB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1Li2zfiB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D6B3C19421;
	Fri, 13 Mar 2026 15:49:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773416973;
	bh=y+DTNVJV9nqWfR3Hajp0ic/eCXFjLQRn7oaLbm1czrs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=1Li2zfiBdoFhZSpi/L3Ur+Us+a4u3Vl0xXJC4vp3dN81VQkqN7CKhwpqB00eyI4ZP
	 MGTNbEu+QFag8iw1CLOnC+hZSnTFVJn4FRO8VtmGuNkaxzM9p3x7DGgkAWdDlit27A
	 9Y+0FCeFViFWmXcsFrwvWJpvujIycM4yGbFiriu8=
Date: Fri, 13 Mar 2026 16:49:28 +0100
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
Subject: Re: [PATCH 6/9] kernel/api: add API specification for sys_close
Message-ID: <2026031348-deceiving-calculate-0017@gregkh>
References: <20260313150928.2637368-1-sashal@kernel.org>
 <20260313150928.2637368-7-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260313150928.2637368-7-sashal@kernel.org>

On Fri, Mar 13, 2026 at 11:09:16AM -0400, Sasha Levin wrote:
> + *   Calling close() on a file descriptor while another thread is using it
> + *   (e.g., in a blocking read() or write()) has implementation-defined
> + *   behavior. On Linux, the blocked operation continues on the underlying
> + *   file and may complete even after close() returns.

I'm guessing this came from the man pages?  This is Linux, so we are the
"implementation" here :)

thanks,

greg k-h
