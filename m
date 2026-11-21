Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795219844;
	b=PaOv+SJBJp9UoYQvuchxL2H/RMXBkuCeaEryud6vvbn4Sw18YlMTr6qa6flUKPnwTY+M
	 xv4XOdMvcb1/lJox/169hGUwn0dLsG8egRv6q9LAfuSIcrq+JlpBcixDlQOz0tDxGjWLY
	 AP3v4/1yHMGXERi1NE5FXjLifl4QT8l6Y61k+nxiUCWEmJXn6g5NW4sM4DFztWDPiqG7c
	 c/OE45UKmgpXYskRPQUc7yQo6bmWEjv3XUOhbxQ0vp7e4S2ZyCDYAUvrTeV1/7HSETTZt
	 8JybDJaNdsNt58CphPzNKwnsdQyfRHMu1TgHoOs/2v+f8YH0+qFGXw494s2lg30CFYA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795219844;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=nefIhKw4pk3hNRgKls2omID/HmfGP96iHh55NTs5Fc8=;
	b=brAsG+GlJxGDu76dTfZCxFmnvp4vXq8NrfLPmR+bhgFTuqC8wzgz5jaevLnfXXKBtECd
	 qXvazlgYcbvghfWkT7LuHcYcP9vy4qpaK7PATmfVcZL5dD3RT3mJ7QK6mYEYVXAalWeV/
	 y0DPodXEozQuD0CwN1ir99cAXyE/vG+oG9L7jkmY4LwqgHpq1zL6nP98PxtSVXD0sylvv
	 oM3xVQBezNPriZuZskzm9M2JF/p+n3Ef9qLQLDMYSk47Hntl12tPY3PaiMK4fiizIEcCi
	 MIDk4gLTY3IAz4NcvgAvbFpegmzm/1+PHLMM0L0ThDdzLbxpG4rzTuS+mk65EHv1nHA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=fBDNdFbN;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id 3495A60A262B;
	Sat, 21 Nov 2026 00:10:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=fBDNdFbN
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 84AC81F000C0;
	Sat, 21 Nov 2026 00:10:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795219844;
	bh=nefIhKw4pk3hNRgKls2omID/HmfGP96iHh55NTs5Fc8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fBDNdFbNVJ4c2R5l21BN3Q6Yj7sCXFhuqkBWMB7MGY9VGnU18lQLctOh/0TXBJw1A
	 AFhfJIKGI21WemZTyiQ43YZrKXxrNaUKh8fARfXnWGA+2KLCuwhpbxnNc8pfVOLFgB
	 aItHE1rE5obmsDbiFvA2QueDhqAkL6BlPnyhtBQXEqha+3WKl2dokM63Jy+j3tDPZx
	 BsHyfqL7xTYDzsw3Q0MEQDZ8ntZxKX9PqU50i9o16YGBTbxsAvnmWsi/sE5nQXACPp
	 c2JK74RbPnfBjJBDYCzCTBkRxFM1JCvQeDnjjgEevuQIBei9Qe5zhzaxO4Cmyd3aNQ
	 CcsrBIJqvhWeg==
From: Jarkko Sakkinen <jarkko@kernel.org>
To: linux-fsdevel@vger.kernel.org
Cc: Jarkko Sakkinen <jarkko@kernel.org>,
	linux-api@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org,
	linux-security-module@vger.kernel.org,
	Alexander Mikhalitsyn <alex@amutable.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Andy Lutomirski <luto@amacapital.net>,
	Christian Brauner <brauner@kernel.org>,
	David Howells <dhowells@redhat.com>,
	Jan Kara <jack@suse.cz>,
	Jonathan Corbet <corbet@lwn.net>,
	Josef Bacik <josef@toxicpanda.com>,
	Kees Cook <kees@kernel.org>,
	Neal Gompa <neal@gompa.dev>,
	Paul Moore <paul@paul-moore.com>,
	Serge Hallyn <sergeh@kernel.org>,
	Zygmunt Krynicki <zygmunt.krynicki@canonical.com>
Subject: [RFC PATCH v5 25/25] MAINTAINERS: Add entry for ROOT NAMESPACE
Date: Sat, 21 Nov 2026 02:08:44 +0200
Message-ID: <20261121000844.1863324-26-jarkko@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261121000844.1863324-1-jarkko@kernel.org>
References: <20261121000844.1863324-1-jarkko@kernel.org>
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

Record maintainership and mailing list routing for the root namespace
subsystem across its uAPI headers, core implementation, documentation,
and selftests.

Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
---
 MAINTAINERS | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 7cbce21ba45a..072be5ec7fd8 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -24533,6 +24533,17 @@ F:	include/linux/mfd/rohm-bd96802.h
 F:	include/linux/mfd/rohm-generic.h
 F:	include/linux/mfd/rohm-shared.h
 
+ROOT NAMESPACE
+M:	David Howells <dhowells@redhat.com>
+M:	Jarkko Sakkinen <jarkko@kernel.org>
+L:	linux-fsdevel@vger.kernel.org
+S:	Maintained
+F:	Documentation/userspace-api/rootns.rst
+F:	include/linux/rootns.h
+F:	include/uapi/linux/rootns.h
+F:	kernel/rootns.c
+F:	tools/testing/selftests/rootns/
+
 ROTATION DRIVER FOR ALLWINNER A83T
 M:	Jernej Skrabec <jernej.skrabec@gmail.com>
 L:	linux-media@vger.kernel.org
-- 
2.47.3

