Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795030600;
	b=4qDWtXwEPaJsUovqoSXGwAhLxbiTuyCuY06Oyqrg5rm7kP0UJWZ5nBtIPfopPaUBrn5q
	 IYWN2hL62m9VORmjHc6sssqkpn2RnPvaKjMaHXV2q7RDMUykYx+4V1ZTHLP4/mXnKQpws
	 ipaOG85gMMKpl5Uhaz7PyO8uGi69KfLN+FxkWmYDvBt/tk4pcsfcC7WZwItmWBM/zCZAL
	 wzN9AXm9GCBsPpG6EXqQUex5mY7Ehw97ExXG9F4a39SOxM5zHx7CRFLuohcdXtTzsrRb1
	 rM+LkUYheS+yMxxIo2cDzBzYAjlJI1psGAsKIgj9HMX5b19dUs6k3SIaFGjPT9IyNPg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795030600;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=nefIhKw4pk3hNRgKls2omID/HmfGP96iHh55NTs5Fc8=;
	b=A9eEQ76Rg2TOPrQyumE21UnS9uqQDEFKi6h5FIkUBUSiDXpjXIyiTSX0QWKcYs6jTxfE
	 AOmu2Xr7DSAz20OCxv3kaJhqKmNCbW5HXm7mG8mi/bNb6JLRcfD6pQ48R4fdGurRBq2Zr
	 +VoBwe5hx6zMxeGHpaZkc4sycJsC1+lZRoTWhnhpNRvnxuDekrx2Yrf8N8k2fQ1rY42Le
	 PclZpL1DoeJ0TFMhPomFgON9ddGELXSUK3K1csIcqjq034pVDiT4hll1LknZCFxP+vfjI
	 i2SdMZmTAPEe0nnkKfBBKgyHVWuuK+XiobdId6mpcLHZOEmUmL/pwRwYXzNoiyoU62A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="beFY28m/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id 7F5C7607E700;
	Wed, 18 Nov 2026 19:36:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=beFY28m/
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 8D61A1F000C5;
	Wed, 18 Nov 2026 19:36:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795030600;
	bh=nefIhKw4pk3hNRgKls2omID/HmfGP96iHh55NTs5Fc8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=beFY28m/CXPpvXt2QSm6CHgFEu5/DafZo3FIxSdgSW/oD4ncbx2FrbDn9xPIU+lXw
	 5pWxATEIw9SZui6/I+Mp22O4ABSVFdfJPmLyUz7kOjgoFqzYeKTVFSJjNyZit2amrI
	 DBKcxZ3l3rwjcpuY1aD9WfIt7cFmH4sr0qvxFvc751CwKNwWtrb5dFR1f/rLthDbS/
	 3JUE7fDlV6jdl4uuzBw13y6rgHyz9rd2RSxmYJfxScEHTmp9i0b4Wf+C1GGAjtVzLD
	 feQObnq7LeC95R+LGfKdrKvhEUrYHw1Vffz2GCVy3QyHXPRl1RknkOPolgLOvTpR+h
	 76Y+Gx1fhGEPQ==
From: Jarkko Sakkinen <jarkko@kernel.org>
To: David Howells <dhowells@redhat.com>
Cc: Jarkko Sakkinen <jarkko@kernel.org>,
	linux-api@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org,
	linux-security-module@vger.kernel.org,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Andrew Morton <akpm@linux-foundation.org>,
	Andy Lutomirski <luto@amacapital.net>,
	Anna-Maria Behnsen <anna-maria@linutronix.de>,
	Ben Segall <bsegall@google.com>,
	Christian Brauner <brauner@kernel.org>,
	David Hildenbrand <david@kernel.org>,
	Davidlohr Bueso <dave@stgolabs.net>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Frederic Weisbecker <frederic@kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	Jan Kara <jack@suse.cz>,
	John Johansen <john.johansen@canonical.com>,
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
	Thomas Gleixner <tglx@kernel.org>,
	Valentin Schneider <vschneid@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Vincenzo Frascino <vincenzo.frascino@arm.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Zygmunt Krynicki <zygmunt.krynicki@canonical.com>
Subject: [RFC PATCH v3 13/13] MAINTAINERS: Add entry for ROOT NAMESPACE
Date: Wed, 18 Nov 2026 21:35:39 +0200
Message-ID: <20261118193539.240065-14-jarkko@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261118193539.240065-1-jarkko@kernel.org>
References: <20261118193539.240065-1-jarkko@kernel.org>
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

