Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794892180;
	b=Fs//nxSDMQoMoMnm/FZTPtZhJ66eSWywbeuMZ3tih9FhvBkg5JRmUV/8OOUCmtrKuM9z
	 ecq33sl9NTjauMue9VBHXCDGqQFDSNMRztH0lqFMhD5qT4hgTeuB+MtK3+JQD8QGh0QZf
	 /Nlv81/S5RTLg1inU/uM3KE3w8kEsgyfp8jX2xJga73mJ84zW8+yvS/tygesBLo2PCTYX
	 SYt90OK8QhCv985FZTFylJF3noCzAU5JVPO6AX/NDucr/QJK8CwadWToMIBWGRIb2aioc
	 rvYCGGspnQydDUiZ1fTDwLDW52DpvsLeCrheBTQdIj3h1Ll8fZjctLisitd/na9Q7rg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794892180;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=sBuq7agc2LJ6hWE7imheP/OC6f3LlJfwcnXlMy2Xfu8=;
	b=RLj4Vfd79JsQ3wjCutqDPRqBfNCZIkncBgNpBGejaLGFhhluhMATF5EOhaWzgvh6m4HF
	 +Emeiuyg4GMgjOA6JO7HeUpwUHTt26NL3LzWjsFUmKEsp9YfTzbMNFkvNFWahT6UmkFSU
	 a2QJEKS0rSTSSS5Yy9c2TSRSbWVU+HIErU1iNZokF+OYT2BmUCgAxFqQF7/mHopA+2Ocf
	 WEtNSl9GrxjXfg/5hAt9Ogk0XPQAOSgPEMrPbxytWVpRn/p9fkF07yV89KintIQd0ZC+b
	 HNb6msPJdD1ZozZQHL5gTDnuhJbvBMJ97kt+pXMOKznqR4sO0ZYlZddBYnUiXGpMbZg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=m2Y1P68o;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id 763FC606A329;
	Tue, 17 Nov 2026 05:09:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=m2Y1P68o
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 6AEF51F000C9;
	Tue, 17 Nov 2026 05:09:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794892180;
	bh=sBuq7agc2LJ6hWE7imheP/OC6f3LlJfwcnXlMy2Xfu8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=m2Y1P68oF3q8KRZXuY1dLQyCw7Xuffv8OmSRl/XRANK/TJRucEcvKZ7ML40C9WIT0
	 2QSfuZcJpGeTlHq+kA/FndpXIuAZ4/3IXJ8L4y/OEa7LznWrwu48E9xD0mykdM9fFO
	 tDPfqB26b7brXwbYtUkwUSptl5IZRMT3T2K5LcWWhbIiGUgWlt80bOOqg+3i4AaMHT
	 UD9v8ntxI8rcuw6SzeqpkMe2yhb3NtfpAVtK73/KsvfyLGBqCC5hZBuk5nU7J23Ca0
	 ZTLJ06fyDF7PqeD6U5CQnM7LbniWVBmO6Pr5VN367BVf723Hm2KNrL10kIac9yrhZA
	 1QYYVTl3wgyRA==
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
	Ben Segall <bsegall@google.com>,
	Christian Brauner <brauner@kernel.org>,
	David Hildenbrand <david@kernel.org>,
	David Howells <dhowells@redhat.com>,
	Davidlohr Bueso <dave@stgolabs.net>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Ingo Molnar <mingo@redhat.com>,
	Jan Kara <jack@suse.cz>,
	Jonathan Corbet <corbet@lwn.net>,
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
	Vlastimil Babka <vbabka@kernel.org>
Subject: [RFC PATCH 13/13] MAINTAINERS: Add entry for ROOT NAMESPACE
Date: Tue, 17 Nov 2026 07:08:41 +0200
Message-ID: <20261117050841.3289652-14-jarkko@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261117050841.3289652-1-jarkko@kernel.org>
References: <20261117050841.3289652-1-jarkko@kernel.org>
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
index 7e7753a54125..1019266bc077 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -24534,6 +24534,17 @@ F:	include/linux/mfd/rohm-bd96802.h
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

