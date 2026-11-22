Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795310401;
	b=30qhVIh9Bem/SmHnQLmdp4iUJ3x/SjXAQo2nbiQGaHrOhVdOPDfVea0X9Q4f5RNTGXSh
	 0YF1TuKq6HLw2o0nzheybgzpescvQB3k0aQ8HFxmOm7fCVp7Jd9gzhrSq9V9jjc4exi22
	 q4WJeEdN7flwjbYPXqtY68MIi7Iwpiu1VvUWOYlyb+dVki8fVJBT05aba7K6esUFs0/dY
	 gp/LQ3bkmK2SESmLPnD9vXPSYw13EBMGgH9Q5qN9QgMSq6ZIvRnj9/yj/MDlxHJBT2e8q
	 etJBbd4wri1IKu0IOo6WL/2qXdXnxy6C8KXbgVyOhZWed/beu1SPsWZrhXtbfqk8MEA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795310401;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=c/grzABhgrBQ8/IrA5G6GcEKHy2OSZTwhNr0CPP3+U4=;
	b=Mfxq3w7aOMwdeVLaisyhuP+jDVOwvvS5gY4fgtfXvSDHCfEJx6gsffslS1dQ/uOpJ7Mt
	 CAoz3/g11J3+pquIUuDlqnOlkQi7g1K1r1d+UFHWd6NsROmNttz74SwIG+4UDP730bmeq
	 QI840plpm6zTYIZnvOR6DHzeKvIePnH91UNq05I+rbuiIgTGivbSBuyAa7Ldpi78INVFq
	 kiZVjIzlfo2brv4t404HRm9ZNb6jRHpU+oRKPbVTVPKq8HLZGdN54OhH7Dnjrb91So3Jx
	 luQz97yzdZvbmZd6h08DNJjg3yRoVriy5pqlCKzCrNqYxSrXKhMtnv09h68F0ZbOlCw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=c41yvlTm;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id 014E4606A33A;
	Sun, 22 Nov 2026 01:20:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=c41yvlTm
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 00A451F000C0;
	Sun, 22 Nov 2026 01:20:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795310400;
	bh=c/grzABhgrBQ8/IrA5G6GcEKHy2OSZTwhNr0CPP3+U4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=c41yvlTmsmUggUlC3/vjinTm6vFtUxEB9z2rCyU4sjtlo4Nhf2qmcPGP+/NpenLob
	 viRQ+5vSpy+tqkKMNA5Oet6+CAkVFtRS0CJsFclAKgeel6Gcsi0XY0SD6uyqJ1U8z7
	 utsX/+EqeQkhmu19i55+Q+TtmVYAGUuXCjOvVDpyws08iMTtw55Ectr/3BW2yMv+uJ
	 EUImr8k8+n0HTGtMzfumIDfRvrzzErJiXsgowtanlgTOgRbvFf8OkSo3MpIB1F9SLa
	 3irPUYzQqOhIKnQeTnC4RPUqldnRrQNkrVz/WkTLXU9vtRScHrl6gdnDzY9+d62owQ
	 nfh+WULW4lmjw==
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
Subject: [RFC PATCH v6 26/26] MAINTAINERS: Add entry for USERLAND
Date: Sun, 22 Nov 2026 03:18:09 +0200
Message-ID: <20261122011809.2667684-27-jarkko@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261122011809.2667684-1-jarkko@kernel.org>
References: <20261122011809.2667684-1-jarkko@kernel.org>
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

