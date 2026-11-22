Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795376269;
	b=GnAIQjjOaur02wXZaElJigfRlUV5dJshy2HTaIgI+JUhLsen6RkIPtY9+OiCffMEaDoV
	 /xLAvO1X6DG1okGnAPTy/viWZVo0kv6avvNbymC0Y58jXftdaRr54y0bNhoPNt1sy32mm
	 DtWs/KO5I8w/JP06HLhIa0uHgvRBS4IYDk83IPRYPUSh33803ovMfoX2jaUm+7nBfio/k
	 fjwUWLqfGvk+60mqUL4DagBlH3g/b+bUjw8jDnk1iWi9glMkeUSBWGcGDG7F1hTrvZOSH
	 6S8dRaKNXw+itfMtY+kgSzO9QTbjpPxRbwRYiBT6W8VVIKQaCjIM/Fky2o1D4n7/hZg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795376269;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=c/grzABhgrBQ8/IrA5G6GcEKHy2OSZTwhNr0CPP3+U4=;
	b=n7Aafw7dtvjp/NZMfdX9RLQK1QCayVqAxwbOzf4+eLa3Uv+7G1UxX60dilhkHJh0NjDN
	 0ADqbyDwK3O0wrRpMk8rTdAdz27KYYCYWAQvgLXq5S78mxyeFjG/ePktGRiPx24dCqJyV
	 nww4ZsW9VOQ4nWf/dO+zX8rFdVBQNM57lh6nOmPVKGjLw7SoDcq/6fLC7KcxHdh2aE95M
	 6fQGRmzhGltUr2IE0KZp6Br4q2pn9hk+nz5ON6E946Ue2vx75yN+vX73ZZgCqLS/oJSva
	 2LqHk3Fw2ySBB9LXuxHFfTjwF/CAFEgJrjxETloI0YtJ8Hiftu95QKHL2B+zm7KTtkg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=If6Azv7y;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id 3BAFC606A684;
	Sun, 22 Nov 2026 19:37:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=If6Azv7y
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id E59221F000D1;
	Sun, 22 Nov 2026 19:37:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795376268;
	bh=c/grzABhgrBQ8/IrA5G6GcEKHy2OSZTwhNr0CPP3+U4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=If6Azv7y7srTCn6OR0qdqZQAwa1W7Gt05tNg4TPPtNZ0kqbU7S/HJIrOaVSbu5He2
	 UcQYGZyFJswbruL02XotkP5Qo0sAiLgKUKGIQ8Gi8yiHFaR9w9q4Wx7olOPpVQs/Ky
	 A9rTDmfwXa5kKjKsqhuSfUcv8eeNDe3A2PZuK0tdgw2gon96AVqaD6syspi5fkJ3Wo
	 ScgOoGL5gTQFoAfLmxdcLAxxx/Ypx7zjqXVJyKlTiTYDeVpD48x/RK33TjzOrp5rLO
	 ANINvuVSa4Z5EmpoCFu4ML34znZVg9/tvfMwXoQWObjGP9ozyW5Vp36n4R0Za6rYTG
	 k9ENPgWMMUgug==
From: Jarkko Sakkinen <jarkko@kernel.org>
To: linux-fsdevel@vger.kernel.org
Cc: Jarkko Sakkinen <jarkko@kernel.org>,
	bpf@vger.kernel.org,
	containers@lists.linux.dev,
	linux-api@vger.kernel.org,
	linux-arch@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org,
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
	Hugh Dickins <hughd@google.com>,
	Jan Kara <jack@suse.cz>,
	Jeff Layton <jlayton@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Josef Bacik <josef@toxicpanda.com>,
	Kees Cook <kees@kernel.org>,
	KP Singh <kpsingh@kernel.org>,
	Lennart Poettering <lennart@poettering.net>,
	Neal Gompa <neal@gompa.dev>,
	Oleg Nesterov <oleg@redhat.com>,
	Paul Moore <paul@paul-moore.com>,
	Pavel Tikhomirov <ptikhomirov@virtuozzo.com>,
	Serge Hallyn <sergeh@kernel.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Zygmunt Krynicki <zygmunt.krynicki@canonical.com>
Subject: [RFC PATCH v7 26/26] MAINTAINERS: Add entry for USERLAND
Date: Sun, 22 Nov 2026 21:35:39 +0200
Message-ID: <20261122193539.3334213-27-jarkko@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261122193539.3334213-1-jarkko@kernel.org>
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
Content-Transfer-Encoding: 8bit

Record maintainership and mailing list routing for userlands across
their uAPI headers, core implementation, documentation, and selftests.

Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
---
 MAINTAINERS | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 7cbce21ba45a..54d8f628cb87 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -29285,6 +29285,17 @@ F:	arch/um/
 F:	arch/x86/um/
 F:	fs/hostfs/
 
+USERLAND
+M:	David Howells <dhowells@redhat.com>
+M:	Jarkko Sakkinen <jarkko@kernel.org>
+L:	linux-fsdevel@vger.kernel.org
+S:	Maintained
+F:	Documentation/userspace-api/userland.rst
+F:	include/linux/userland.h
+F:	include/uapi/linux/userland.h
+F:	kernel/userland.c
+F:	tools/testing/selftests/userland/
+
 USERSPACE COPYIN/COPYOUT (UIOVEC)
 M:	Alexander Viro <viro@zeniv.linux.org.uk>
 L:	linux-block@vger.kernel.org
-- 
2.47.3

