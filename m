Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794957301;
	b=M6C2CjaXKMXrUHihCl0pRY02ptjcqPWNBsFnGcO8fS0/gNU+fohzBBkVaUUD6hDxT6TO
	 DrGomLuOi2HXaOvVGOU0YTH+OqBRj2meiItcC7Na5NyvXGubNYOhcNxuAJBY3LPLf7DiK
	 UmTW8LbNjgGsXVaiFkq6HEAu9/v42BW302gXJScIsFlAC3W0/KTGGD6qQDXuXHJPW4U7e
	 2Cw8w9WcNHRJRXAVZRhlI+RVS8VFIRebl7Cry+EkT2AVuV89nj0y2k0a6jh48zwfaMkZv
	 naj4wWfHMYHBRsRjTkovWhYRqmU3wKT5eSee8l52m41yPXlEsslCVZYXwdkDDMHZ1nw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794957301;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=nefIhKw4pk3hNRgKls2omID/HmfGP96iHh55NTs5Fc8=;
	b=duGLQdrKZT9n8M2+/tYaMRy+aFwGDov9qosD2eqR0aRLNzK44i2CrWo+qyeeDKy7d6X6
	 x+ll6/FPuQYAg0/PwTOVgKskM4+gW4qFaShznN+8d4Ql9Vc7Eib2YwJ0HjVQ+KM6szF3P
	 cpTSRDVebkqMl7nj1oF+EtC0DHcbymvdwMF/cG3nFvxLclOoZQI3WjSKD+9lJa40Hj9CY
	 Ke12OOlI3YvESMQY7GbBH9YH1IxrFE+ETkzKmbjFYVqqUN0OD0gPAxVqpFSdYr9Ev1zxm
	 X4JsyYfDyVzHpVmVtze9u0xfMcN3wXz2j5o/Mhdpa8fQ47k9NCDc51flvh384YEUtVA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=fNQgkSHv;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id CDC58606A8B0;
	Tue, 17 Nov 2026 23:15:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=fNQgkSHv
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id AF1E11F000CF;
	Tue, 17 Nov 2026 23:15:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794957301;
	bh=nefIhKw4pk3hNRgKls2omID/HmfGP96iHh55NTs5Fc8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fNQgkSHv1jzPUwUT8AmMKSYEji9oZi4HIMBMb5IcRcs5Y4gvlDtPgP0FmolN9UTBM
	 blVnkOtiPmDGJ2f+Af1BvrSe9U1xok4hMhRBcUNQUYzgUEdUTzogqFqVMbTZ7JiVGG
	 xoxqn5pC64vdPAR5ElsuRgPjFUnZGyg7fLJIz3hRTWqSAeSnsWQXL8S53jrGe83/Ny
	 s/I0RykmvZA/8ZqQJ29vAy+wjl4MuJq6DPoPd/ogJc50wCI8k8IM9tUEsm8RlQYhfu
	 8M8mFQK20cuhDgVuifAi7KTPKtKIfX1Bb1nLranRC5+rKjIkniUkVkEIMm14iI5TKy
	 HKmMwislFi4/Q==
From: Jarkko Sakkinen <jarkko@kernel.org>
To: linux-fsdevel@vger.kernel.org
Cc: Jarkko Sakkinen <jarkko@kernel.org>,
	linux-api@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org,
	linux-security-module@vger.kernel.org,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Andrew Morton <akpm@linux-foundation.org>,
	Andy Lutomirski <luto@amacapital.net>,
	Ben Segall <bsegall@google.com>,
	Christian Brauner <brauner@kernel.org>,
	David Hildenbrand <david@kernel.org>,
	David Howells <dhowells@redhat.com>,
	Davidlohr Bueso <dave@stgolabs.net>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Ingo Molnar <mingo@redhat.com>,
	Jan Kara <jack@suse.cz>,
	Jonathan Corbet <corbet@lwn.net>,
	John Johansen <john.johansen@canonical.com>,
	Juri Lelli <juri.lelli@redhat.com>,
	Kees Cook <kees@kernel.org>,
	K Prateek Nayak <kprateek.nayak@amd.com>,
	"Liam R. Howlett" <liam@infradead.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Manfred Spraul <manfred@colorfullife.com>,
	Mel Gorman <mgorman@suse.de>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Neal Gompa <neal@gompa.dev>,
	Paul Moore <paul@paul-moore.com>,
	Pavel Tikhomirov <ptikhomirov@virtuozzo.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	Serge Hallyn <sergeh@kernel.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Valentin Schneider <vschneid@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Zygmunt Krynicki <zygmunt.krynicki@canonical.com>
Subject: [RFC PATCH v2 13/13] MAINTAINERS: Add entry for ROOT NAMESPACE
Date: Wed, 18 Nov 2026 01:13:52 +0200
Message-ID: <20261117231352.3816603-14-jarkko@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261117231352.3816603-1-jarkko@kernel.org>
References: <20261117231352.3816603-1-jarkko@kernel.org>
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

