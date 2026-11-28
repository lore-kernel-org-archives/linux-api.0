Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795828136;
	b=FNkfPSoHVCw3SiUPPSEmvmw+Wh5U8xLcNwhuOrvIo2uJFSlQwS6tO2lE3ScIZJEKHLfk
	 EkPLcVyyvqJ7abf9pEv0sKTVTAC6mJcsVq2DYl+nONgESZhk26d4Z+d4ZzHGyS3/Ws4vb
	 VOVCkQdhf0jHOWB2pmpN/48IRB44RxC8VxSvwqRyWIzs2lMPsPwLY6l/Sj7EKzvR7XI+t
	 fQWkbpMBqj7LkgvA/yFW6N4aBe0S6BnMDZrXOgIAEomIzrjXtCLWrI8OQqq3rZ4dC3ral
	 j9tdryGAUXgifOoLnoxLDQOQ/vHYi6xjpL4pApIiFE48F1D4c11Sn4xxwGt8r/Ntogw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795828136;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=BiX6ZyljcdQPQcS9kGO9WzZ1LmpsTkhRSgDRiHn9c1o=;
	b=B8F6SatI2g49+Upcak7smdW9E5GuosVTBUYE/rCLQS8TbTtMjOmKc2EOhvpeSLGfGp9z
	 w/pi4V2bkR0Wq1M6MXtKSKwi3vA+xtCuJCtNyhbK5bkrtnzhOVZxzpy1c8DJJIoBZpf+/
	 KbpyMoCis7wd5S9R743/Nj7UKyEY5XhkO1bp/jHohwGvZf0bmGmbuaA1NDw7zsTxdTAuS
	 lvYzrRzUwB3wMzcgI3mu5arnE3IeoE8firc0RY07wCmsAT1gvPKkFwriEG90VF1mvxeBA
	 rXRVqraVfV+XtcBdAXzc4BKWmE1gGMLDwJe5TS3LnjeSKyzwc6oiRRa0YQd+T2QjHEQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=m7iLJfrH;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id A6D99606A31F;
	Sat, 28 Nov 2026 01:08:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=m7iLJfrH
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 91B211F00893;
	Sat, 28 Nov 2026 01:08:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795828136;
	bh=BiX6ZyljcdQPQcS9kGO9WzZ1LmpsTkhRSgDRiHn9c1o=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=m7iLJfrHpA8eePZ6FYzysI93EHHYYCIo2ytcOQKp7ORyyDMSYxAtkEvF/yx09Cg4R
	 iJpoHjXY0fVAvXCIvIs1NJ/9w+qIsCt6RlwL4ajRU1yO+cHTh7Kqs9xPXT70wa2ztz
	 w9aAxfd4oLS/lkq6tKivYGYmqxvSr9+PmXk6sL5aSxkY+3hL8PAK3/XCPEqMlKxIz+
	 HQtEFMtzRMrzi4vfR0aKtXsT0Hn90k3NcrBuaz2Pdcy1JZLE49YB2Eq7UcGR+3pIPL
	 0oJTU3Xa3CDhp1P5hE3sz1DkIOuyxJP2Em7qSR+Y9YvoBlBS1Ske2Iz2DgAlZ38EGJ
	 V6CXPjiHUEcjA==
Date: Sat, 28 Nov 2026 03:08:52 +0200
From: Jarkko Sakkinen <jarkko@kernel.org>
To: Askar Safin <safinaskar@gmail.com>
Cc: aleksa@amutable.com, alex@amutable.com, arnd@arndb.de,
	bpf@vger.kernel.org, brauner@kernel.org, containers@lists.linux.dev,
	corbet@lwn.net, dhowells@redhat.com, ebiggers@kernel.org,
	giuseppe@scrivano.org, hughd@google.com, jack@suse.cz,
	jlayton@kernel.org, josef@toxicpanda.com, kees@kernel.org,
	kpsingh@kernel.org, lennart@poettering.net,
	linux-api@vger.kernel.org, linux-arch@vger.kernel.org,
	linux-doc@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org, linux-security-module@vger.kernel.org,
	luto@amacapital.net, neal@gompa.dev, oleg@redhat.com,
	paul@paul-moore.com, ptikhomirov@virtuozzo.com, sergeh@kernel.org,
	skhan@linuxfoundation.org, viro@zeniv.linux.org.uk,
	zygmunt.krynicki@canonical.com
Subject: Re: [RFC PATCH v7 00/26] userland: Userland containers
Message-ID: <awoppInSWN0XVPz-@kernel.org>
References: <20261122193539.3334213-1-jarkko@kernel.org>
 <20261128005541.873229-1-safinaskar@gmail.com>
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Post: <mailto:linux-api@vger.kernel.org>
List-Help: <mailto:linux-api+help@vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-api+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261128005541.873229-1-safinaskar@gmail.com>

On Sat, Nov 28, 2026 at 03:55:41AM +0300, Askar Safin wrote:
> Jarkko Sakkinen <jarkko@kernel.org>:
> > Work on this feature started in 2025 after reviewing David Howells'
> > container object patch set [1], whose underlying mechanics made sense to
> 
> > [1] https://lore.kernel.org/all/155059610368.17079.2220554006494174417.stgit@warthog.procyon.org.uk/
> > [2] https://lwn.net/Articles/1102593/
> 
> You put wrong link in "[1]". This is not Howells' container patchset. This
> is Howells' fsopen/fsmount patchset.
> 
> Link "[2]" seems to be wrong, too. It is not something "earlier", this is
> very recent LWN article.

Thanks for pointing that out: https://lwn.net/Articles/780364/

Br, Jarkko
