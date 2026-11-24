Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795483176;
	b=kVEYKliK0PgBhDfT9TZfsixzmqFoJPGdu8TaE8Y1XRX5LMB10G1oREnt2cHYqDXt8CQ0
	 jqk43oDoU/bE89ZN1R6B4Ca+de1Xv8AiApESfBLnwa5kgOBYUbkFdHPFl4xbHAl1nV/Uo
	 /ad2Y8pCOTBpPnT3wzpxg/RJeKIjiWjtrHcxkLlLp/mWy8v7PgJmTemic34j/h1PxBtu6
	 aTP+ORGwt82QzVtJATgMvAo793swdq5DTjxOhsn01Aec+3/IRUfkr6RSPBHsPKNY1m+uj
	 bQROeRwPGGBndKdae+Qf4N5SRLa0dk7n8PBZWoOQrLS4ZMwZMMYHYeYuaxOQ+PQVJTw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795483176;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=TqTFyo2p9NHEAlnK/bLSQvmwgpmG1lbV/jfBCx+FnUY=;
	b=Wr8Ow0KZZm/Zsi5p8G7Vf7g4W/vB4J1QGHTGomCII7ycr37Fc4NgmK3z9kq5c9qz/sW2
	 L1+Ywh2vyJwLtlrDeiK22CI2G59foABEXmH046k8XtUmCL2cqpA77fCbP6OH91PTX4f8l
	 H7cjgw7HUDJaonI2aGi1sPvM48IqIZzJuJPZgDGGuPczfYvj8nAdRMlPC5WzWmv9UCy25
	 i5CrBC8FZaSc6hxeu5Mywmx3pZ41Jnw9qO2B9T5ePTT9AmnxCHyxec5TSYltddBygdoEb
	 R8ppsripwoN5hDsX6h1ZQttdeth+dzdHrL0LF6Zy0t3695kHdovk9hYnwPp4hmXI1kw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=FpgAv4k7;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id 673DF606A31E;
	Tue, 24 Nov 2026 01:19:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=FpgAv4k7
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 5602A1F000C6;
	Tue, 24 Nov 2026 01:19:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795483176;
	bh=TqTFyo2p9NHEAlnK/bLSQvmwgpmG1lbV/jfBCx+FnUY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=FpgAv4k7DgTjREaE3kro0UZn3XG5jzdbXdwUqCiY0H/lFIyxXhzxKdUjGfewSzdRJ
	 AQv/xvoOKqEm+aHsUnmXP7PwlobCZQd+uY7uHAZTyThrK/+fCSfOgXaaTDk8zdtC9V
	 uZXFUa2oVY74if4PpQoYMmsWfcoAzHvkyUqGZf4VbXQZrql0SqEm0LqqOBNr8pf3Bk
	 ChIpk1dvOQ0+H9x+KeXwb+c+0oJ0CqAHmhymiEOisQGz0RmR6YY6DWkqMqZDxnuKqj
	 pQYz9w2/bOPD5gPpVIjBUGn/+/+YICibM0voCPOItGdwtQz84KoY3IMZqMK5FJtKgJ
	 uPDRW+LVkgcSw==
Date: Tue, 24 Nov 2026 03:19:32 +0200
From: Jarkko Sakkinen <jarkko@kernel.org>
To: linux-fsdevel@vger.kernel.org
Cc: bpf@vger.kernel.org, containers@lists.linux.dev,
	linux-api@vger.kernel.org, linux-arch@vger.kernel.org,
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org,
	linux-security-module@vger.kernel.org,
	Aleksa Sarai <aleksa@amutable.com>,
	Alexander Mikhalitsyn <alex@amutable.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Andy Lutomirski <luto@amacapital.net>,
	Arnd Bergmann <arnd@arndb.de>,
	Christian Brauner <brauner@kernel.org>,
	David Howells <dhowells@redhat.com>,
	Eric Biggers <ebiggers@kernel.org>,
	Giuseppe Scrivano <giuseppe@scrivano.org>,
	Hugh Dickins <hughd@google.com>, Jan Kara <jack@suse.cz>,
	Jeff Layton <jlayton@kernel.org>, Jonathan Corbet <corbet@lwn.net>,
	Josef Bacik <josef@toxicpanda.com>, Kees Cook <kees@kernel.org>,
	KP Singh <kpsingh@kernel.org>,
	Lennart Poettering <lennart@poettering.net>,
	Neal Gompa <neal@gompa.dev>, Oleg Nesterov <oleg@redhat.com>,
	Paul Moore <paul@paul-moore.com>,
	Pavel Tikhomirov <ptikhomirov@virtuozzo.com>,
	Serge Hallyn <sergeh@kernel.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Zygmunt Krynicki <zygmunt.krynicki@canonical.com>
Subject: Re: [RFC PATCH v7 00/26] userland: Userland containers
Message-ID: <awTmJIErjasO4lqq@kernel.org>
References: <20261122193539.3334213-1-jarkko@kernel.org>
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
In-Reply-To: <20261122193539.3334213-1-jarkko@kernel.org>

On Sun, Nov 22, 2026 at 09:35:13PM +0200, Jarkko Sakkinen wrote:
> SYSCALLS
> ========
> 
> Two new system calls are proposed:
> 
> 1. userland_open(): open an opaque staircase-initialized container
>    object (modeled on Intel SGX enclave initialization with separate
>    build and live states) with no embryonic state, opting selected
>    shared namespaces in via an allow-list instead of unshare semantics.
> 2. userns_set_idmap(): configure all UID, GID, and project ID map
>    extents for a container user namespace in a single atomic system
>    call.

I played on patching systemd and userns_set_idmap() alone does already
a lot of good. I'm figuring out userland_open() integration next.

For the test implementation I probe the opcode's and dependening on that
use either "userland path" or "fallback path".

This auto-probing is done so that I can commit the patches to my kernel
test harness, which already has systemd, and try them out when built
against userland-enabled kernel (via LINUX_OVERRIDE_SRCDIR):

https://git.kernel.org/pub/scm/linux/kernel/git/jarkko/linux-tpmdd-test.git/tree/?h=main

The project builds a hybrid ISO, which is a bootable bootc/composefs
based operating system, and has toolbx bundled i.e., a reasonable test
environment for all of this. It is also device-installable via "npx
@puu/install"

I had to level the harness up a lot so that I could realistically test
lockdown-hibernate but it is is also pretty good emulation environment
for any possible container features.

Br, Jarkko
