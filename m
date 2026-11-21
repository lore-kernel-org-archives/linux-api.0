Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795224728;
	b=pfQPOdeZZYQTzcy/f15kB/NsdiWSnmTT6Ch7+zgmSRJK9YYuk04oyZRlKfZRM5x5ehu2
	 ONaozgOU0jTSJkd38uEdHhF09JO6BgrL14p3hXfdD1ZvnEp3NJxIUA+QFteLYw6aGygk1
	 fjkRtgMNVUY4gPiO9cXOPBfCgq3xYjHrg0d4/qNY8EXndEIcHEQPkNyjpEZwLAAilZIXg
	 jrveE1YPZKmsuhcK+quOcsX96cqtz2G9Nk3KPihHVPHQyKhzeueVN0Ab1ACZiLyxyEk7p
	 Agnr7rTW+xQdqyHhprg6NWY3idz5B+YoQBDbYFeOx5BtFHyhJHCDXjXLodCQny4sayA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795224728;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=5/7MyMIXr0GDno34tV42HvOi56g013l0wGScJy1uGp0=;
	b=xIbBfZHZCvRm++Hp6sOxsszaRfEN2dq7npW89yE5SIumZWDcOvjjiDNwCASC/w46a4yO
	 F3f5MzacZnZATqr+83WcL1DYRSv4YxqnWxQrvBotqH/c4Fc5UQWXIyVYF4pJ/QLh1iUKP
	 ZJhcCuGYCDCkQQd31Z9jjzl6rPpO0jE7aB3duR2AxFEW0Ah3/cZs8tDK0jntzoQ43N9wV
	 /8dhn68HI1L84X5Tmjd5s8zbBBIpOY7UpOzJIBeBUHYXsrjQRAkhLa5pzqS1V9zLddTii
	 GZS1T3iIdaT8NHimU+jj+FuQOXWr9y6vRNSqFdxrDweH9KTK9jQMAFAj9rahbfequrw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=V1FYfrGT;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id 9552A606A6AB;
	Sat, 21 Nov 2026 01:32:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=V1FYfrGT
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 8B58A1F000D2;
	Sat, 21 Nov 2026 01:32:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795224728;
	bh=5/7MyMIXr0GDno34tV42HvOi56g013l0wGScJy1uGp0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=V1FYfrGTatK4t00vmPWVjtv5HLsnbLBQJryhm1RAw1jnSsFpourNb3t1IjzSNXxX9
	 6Bq0R9I4WaCdpXZX3hs2TSXWe+ogMvOxCYptsDe9heLB/DRu3jnf1Ra6f6JDEemD1j
	 7Ztegvu2jmd0It2EtCck+YGJjbblBujYOojylXdkcLxQW+4YV4lXpMp4fzKNiIc96d
	 zWTi4ICSpKYW7JvYV71KxHiIMYRy0vFhI0sCj4pcDHT8NJHbwAYCAZIa4sbRh/LMYQ
	 Q2vVzh7EY9qiZrVGlr9vAi90q99Jbd7CoOV5MuyrCPk6oRrhEKBAi7Y4to5qFVrlj3
	 tsOSq4fsG9ZWw==
Date: Sat, 21 Nov 2026 03:32:04 +0200
From: Jarkko Sakkinen <jarkko@kernel.org>
To: linux-fsdevel@vger.kernel.org
Cc: linux-api@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org, linux-security-module@vger.kernel.org,
	Alexander Mikhalitsyn <alex@amutable.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Andy Lutomirski <luto@amacapital.net>,
	Christian Brauner <brauner@kernel.org>,
	David Howells <dhowells@redhat.com>, Jan Kara <jack@suse.cz>,
	Jonathan Corbet <corbet@lwn.net>,
	Josef Bacik <josef@toxicpanda.com>, Kees Cook <kees@kernel.org>,
	Neal Gompa <neal@gompa.dev>, Paul Moore <paul@paul-moore.com>,
	Serge Hallyn <sergeh@kernel.org>,
	Zygmunt Krynicki <zygmunt.krynicki@canonical.com>
Subject: Re: [RFC PATCH v5 12/25] rootns: Track init lifecycle via
 copy_process() and pid_namespace
Message-ID: <awD0lNmhRPaXI9Pg@kernel.org>
References: <20261121000844.1863324-1-jarkko@kernel.org>
 <20261121000844.1863324-13-jarkko@kernel.org>
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
In-Reply-To: <20261121000844.1863324-13-jarkko@kernel.org>

On Sat, Nov 21, 2026 at 02:08:31AM +0200, Jarkko Sakkinen wrote:
> A root namespace needs to record its init thread group's PID when
> bootstrapped and capture its exit status once all processes in the root
> namespace have terminated, without serializing normal fork() and exit()
> paths inside the container.
> 
> Commit the bootstrap child reaper and bind pid_ns->rootns in
> copy_rootns() after attach_pid(PIDTYPE_PID), and invoke exit_rootns()
> from zap_pid_ns_processes() after the root namespace's PID namespace has
> killed and reaped all member tasks.
> 
> Co-developed-by: David Howells <dhowells@redhat.com>
> Signed-off-by: David Howells <dhowells@redhat.com>
> Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>

ROOTNS_GET_NSFD will be the only surviving ioctl, which make access
control wise sense.

This leaves room for ROOTNS_SHARE_NSFD, which would share a namespace
from host. This makes whole a lot more sense than unsharing security
wise as it is allow listing (instead of deny listing).

It can be post-clone3 disabled. This is what we do in SGX driver i.e.,
have build phase enabled ioctls.

Br, Jarkko
