Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795223978;
	b=f8KnxNTiiTF6rUnS1pmYKpkG+J8pvkVvUK5ZXJlehbsI+0B1yGy0AibIVx5Se72+z7OT
	 QFZ/JEUcDH4fSWUu0f8Ab/59fmwaazunhisMq/nBXaIE4mHZBXbNjOq51imO72lFAiDkb
	 9mSUqKkaJCUkVKDjndducTiPN0iohX7PygHAl2A+5QkZ7QNkoQ9TNNUCJ81s4s6ZLqz3O
	 D29SEs7SML5cpc2TZwtrBLOVIsTrPGbBp/XFKC5ZaTZ42Z/gsuni4Ce8kXy5aoURcf18N
	 e8p9mHX6ChhZmF2PhIQaMAp/MtZ9O8K8255SCqdbVPZhqk7oeqt74+e1lpLPnXujFCQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795223978;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=sAnIPQrHw99t3poEK0Gyi6LO0YpQyQO6UetCOpTe8Oo=;
	b=5anC28nKkEgurdfX9QGWWSJ3LIQsRaAT4NUPrTp8xhdkRfGyK7Tm0tL4DOGaTHy3YsM4
	 0ezkCjij9OwFKNx7m8X2wLhiVmUkr6dPwzmcme3fGUlO1VDOdBe0xBx297bXhjhRT5dJE
	 NcVInZ2LFUExqPRDVgEVP+6ehGJC18JsrpwUYC46w0aD+2RooIG4VmIXDuuXSl3jJN1KI
	 IVNtmmAqX8wKtFfUX913DZq15T41VfU9pwdh4NYl1olRI7QkjlOnNo+BXkutPo3C8mBic
	 gE5oYBh45M0P4KDJV8pZklcrbMisQWFVxnqIEIyxxZStwRqCiby/WIeETzjDV/noYlQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=lurZZMoy;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id ADCEE606A6AF;
	Sat, 21 Nov 2026 01:19:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=lurZZMoy
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 8CBAA1F000CA;
	Sat, 21 Nov 2026 01:19:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795223978;
	bh=sAnIPQrHw99t3poEK0Gyi6LO0YpQyQO6UetCOpTe8Oo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=lurZZMoyYWuE9VFyNbq3lpHmBso1FtIfC4Lm5o/hP5nH13VYo2ikC0PxUrVuDeqRD
	 zhaXUEgHcooKj1ejGHybRCzXAMBVS57232dlmf4nyZ1LACxIZrpiXlbzwuqHYmZm+n
	 A9srb4NyYfKiXRxRXXawmMnQEMiL09ChNNRQb4pq+FOit3RN160L4rE+F9oOXIvJ/o
	 P034ab/AJBn8KDsIpzFhKvrOoX/KtPWgDlqYLDppY7HHPux9NG8EacFkyz+QDHgBvG
	 9VhJrofYIFh9lsO4tmk3Y0vkFoVgA1AAirmvww76cp/mlfN1QVPT/tXaX06r85/OV0
	 EQWdPpoTzi9cw==
Date: Sat, 21 Nov 2026 03:19:34 +0200
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
Subject: Re: [RFC PATCH v5 15/25] rootns: Add ROOTNS_KILL ioctl
Message-ID: <awDxps7uLbikjV5B@kernel.org>
References: <20261121000844.1863324-1-jarkko@kernel.org>
 <20261121000844.1863324-16-jarkko@kernel.org>
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
In-Reply-To: <20261121000844.1863324-16-jarkko@kernel.org>

On Sat, Nov 21, 2026 at 02:08:34AM +0200, Jarkko Sakkinen wrote:
> Signaling every process inside a container from userspace via /proc is
> racy against concurrent fork() calls.
> 
> Add the ROOTNS_KILL ioctl to require an ancestor active PID namespace,
> walk the root namespace's PID namespace IDR under tasklist_lock, and
> deliver a validated signal once to each thread group including in-flight
> forks, aggregating per-process delivery results.
> 
> Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>

Will be gone i.e., can do also  pidfd_send_signal(fd, signum, NULL, 0).

Br, Jarkko 
