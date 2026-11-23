Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795450817;
	b=xcvHXmGM1kmBa3DiRV6k2LnpWRi7sQWBuQZPQi4eCMFMt55RWkVS+DB0eQYG35PcvvwY
	 7N/zg1xtrNC0JyxGaO7a3IItYtHhplAg7wwOeliWoTaL6lxRPr4q6krurx8SHeKL804X4
	 gPHAqA2shH6ck9+bXOXYFkSwnkcGVUwijXFjoXgu19FZtyLBAomAicbcawkRXPmnyoFlY
	 YjuuziJJtVHPuB1UU9dAL/lBayfmMLtpNmWMqAmN7tBq8oPaG13Jd1AS9O68jRfbLHOwT
	 lR1hZzCqcwfkVqtA4S7aREufdBIOv4Y+X4F1NKcaBXYWzbQxRJaSi7ZpZTByGx/ABeg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795450817;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=GMGSS5PYQROX99GbX8HvEIwUcXDerAKEsLEch7k8S3Q=;
	b=bxU9QSzp0d4ThrMbCoT6VuYaHRbUWpQXROZnHyfLQKnEdldbrwDNtl54WiXrSAkSREAW
	 9O49yJb0FNjgxsKbh2Q6B4xOOjVAosh75l7aQjsk6FFAAUfPJxKYct7INt0TyhJUEyBaB
	 m/hjn8vW6PGRt/thJEsan1OPnGzVZG6/DZtcnoWCilBgTWg031sl270KXmhOK0pWbE8yn
	 jVE1srjcYBzH4+PyQ5yZmZjt7LWE3IfHOelBAcEzGIQBofPVZMTVO+011Oi+nBwNuvzHf
	 q7l82bAav4QtCScPJsaXAa2VpL7/4hTweJo0eNkXo+LoGoCfDqpubcbz9ippJnb6vAQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=E+DW4KoP;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id 43B63606A31F;
	Mon, 23 Nov 2026 16:20:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=E+DW4KoP
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id D6B941F000E0;
	Mon, 23 Nov 2026 16:20:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795450816;
	bh=GMGSS5PYQROX99GbX8HvEIwUcXDerAKEsLEch7k8S3Q=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=E+DW4KoPCdkP0AQy8Eb0/14XBngcdtMwfMbHwhhIHUm50tW7cOaw/xqxK7jHRXVvA
	 h6xW4/VFgnzqKgIaQzItf4e5tWtRkfeo5rxwfdP5kmIRq52BJG+Cfxbn8F26657Vbv
	 bXLwCI4mAw8CMP7UnG2kbaWYiTDo/AEU9mEpPkzvjoFO203JPq8ZSSlccM16/paxWa
	 e4WbfLjHRcHYUHgcj3QyL/+wmyhqHwMCzQ1olCaopaSvnOe5wGmYmz3Ab8BIDg76Uw
	 Z8PS45zGNNQRJqS9ctOuLCzPVW0OH6XgNAGxzR4QiA4WTETKNhkM1EDbYY1MaTvT3i
	 mCam8UCZ/+adQ==
Date: Mon, 23 Nov 2026 18:20:12 +0200
From: Jarkko Sakkinen <jarkko@kernel.org>
To: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc: linux-fsdevel@vger.kernel.org, bpf@vger.kernel.org,
	containers@lists.linux.dev, linux-api@vger.kernel.org,
	linux-arch@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org, linux-security-module@vger.kernel.org,
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
Message-ID: <awRnvFNoyAS8XRwQ@kernel.org>
References: <20261122193539.3334213-1-jarkko@kernel.org>
 <DN25ST0D5K1J.1NI5236BF2BPY@gmail.com>
 <awOQDOel_72Xwjm7@kernel.org>
 <awOUJCbB_j0BuHvo@kernel.org>
 <awQ-2UtDRtrv9fNu@kernel.org>
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
In-Reply-To: <awQ-2UtDRtrv9fNu@kernel.org>

On Mon, Nov 23, 2026 at 03:25:45PM +0200, Jarkko Sakkinen wrote:
> 1. It is possible to use file a instead of syscall for container
>    creation. This allows to split the framework in two pieces:
>    the core piece and the driver piece.
> 2. It would be possible to create Linux Container Module framework i.e.
>    LCMs. I'm underlining the technical side here, not sure if this makes
>    sense or not.

One more viable option:

3. /dev/container i.e., replace userland_open() with a device and
   appropriate wiring in file_operations. It right now has only couple of
   flags as an argument.

Has advantages and disadvantages over a syscall.

Br, Jarkko
