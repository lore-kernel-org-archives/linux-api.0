Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBA414D4882;
	Thu,  8 Oct 2026 15:23:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791473012; cv=none; b=oHu9RZ8FjZSKa0Zsv/1IjXakqcET1noAI0fYH4XdVz9aJ/se7AT6A1wqs3bc0+pjLwh2BXSKoDisV5CmH3x41RAto/q52NPtX+bktIxhWJcGKFDvG/GsyIH/2q8WTX7lnNCXL6cDljr9kZveCZJlX9ffq4aMeKsJuBYetzLB9HQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791473012; c=relaxed/simple;
	bh=d/577wEUSbn6X5ZPIoRW4VsvgqrlFtdBkNcXl7EbiEU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WbgzbNfhd/Tp3bKsAxTvct47f0EoHrVDXivTOKbeE2rJFtgdmNiiUCkJJ90ehDNjIBRiyEQRNj0Daf0ILjZgQGm+gyidfs9upcD/oz57tXf3juD+it6Tcrkg9HxJ3clUxvZbxhFh5YGxMXWkWy86Fraa3Hc4IcnwAvEnQYpb/FM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=a0VjaNfl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="a0VjaNfl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 709631F000FF;
	Thu,  8 Oct 2026 15:23:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791473008;
	bh=lXPTEFqRzwTPeuTho68EfUuQN7bLJC0vw2xwMTTAJXY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=a0VjaNflmJMH1Rs3dHCed0pgOoUOBYUYqNeP3E0zb2FHNW9jQPCjPQMoWnjNpALdv
	 rGhlhagAHjOLLDhgY6wSOiPeym974dEzQ+D4h+yI2me0wYsVbirGKeoJKBjHSgy1+l
	 1oYmKBoNTrQOj6cdPy/F69WuVyBZwzGbnOylxrqyPI0wMiQJ1bAOCdc5ALvwh3iuNT
	 0xNVGLnqtPcCvNc2dJtj0hFbKe4eRErp2kbSQfuEzz4IEXJ6ojWN1N0krKb6xkYS7L
	 aUbOJnXLZTXNaEEW9FKQ9FJtMv365eLlQA8nbhJFYcJocLk+iJ808F9UzJhup7MfWo
	 LugZ1P09Aa67Q==
Date: Thu, 8 Oct 2026 11:23:25 -0400
From: Sasha Levin <sashal@kernel.org>
To: "Serge E. Hallyn" <serge@hallyn.com>
Cc: Gregory Price <gourry@gourry.net>, linux-api@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-kbuild@vger.kernel.org,
	linux-kselftest@vger.kernel.org, workflows@vger.kernel.org,
	tools@kernel.org, x86@kernel.org, Thomas Gleixner <tglx@kernel.org>,
	"Paul E . McKenney" <paulmck@kernel.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Dmitry Vyukov <dvyukov@google.com>,
	Randy Dunlap <rdunlap@infradead.org>,
	Cyril Hrubis <chrubis@suse.cz>, Kees Cook <kees@kernel.org>,
	Jake Edge <jake@lwn.net>,
	David Laight <david.laight.linux@gmail.com>,
	Gabriele Paoloni <gpaoloni@redhat.com>,
	Mauro Carvalho Chehab <mchehab@kernel.org>,
	Christian Brauner <brauner@kernel.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Andrew Morton <akpm@linux-foundation.org>,
	Masahiro Yamada <masahiroy@kernel.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Nathan Chancellor <nathan@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: Re: [PATCH v5 05/11] kernel/api: add API specification for sys_open
Message-ID: <ase1bUUdnxMdVubo@laps>
References: <20261008084956.2911790-1-sashal@kernel.org>
 <20261008084956.2911790-6-sashal@kernel.org>
 <aseRXi7hMWBBc0tB@hallyn.com>
 <aseWPV6ZRQM3JOMN@gourry-fedora-PF4VCD3F>
 <asemkQ2v0di0Eea3@hallyn.com>
 <aseqx-uc_QySDiiw@laps>
 <asesqWv1gv0lPZhD@hallyn.com>
Precedence: bulk
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <asesqWv1gv0lPZhD@hallyn.com>

On Thu, Oct 08, 2026 at 09:46:01AM -0500, Serge E. Hallyn wrote:
>My point was just that whether the docs are inline or not, they will go
>stale without that automation.  So if that's the case, then the docs do
>not need to be inline.

Ah, sorry - got it.

The way I saw it working out is that the core part would be inline, but the
"speccy" part would move to a different location.  

Ultimately, this is the call of the subsystem where those specs live, and I see
different subsystems taking different approaches to this.

-- 
Thanks,
Sasha
