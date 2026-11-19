Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795081729;
	b=BpZVzyDAs3Fi3Sd3Hlv7pcAI8zYGBUFBTLISppfUCFdHeY4HXfNVWE+vS4V0gftqpyWP
	 XdOdmuTc4RDblutEu7/Y6/CHmZ4nqA5CIDvqCH20fQ9JD5zsixQKwtjjI2/qhpi8md+2V
	 mM796zEEc4wcx8cecVkRfXMJmc1QDNEz+vzVTf26KBp4Qn96wuDpkJv0l62maE4re0ihW
	 XbsqfO61mTTyuTfaYvinosuFmLgfSXYM2t91YpbysCez1OGKHsMl2Nbd4HvvFvj47rm2L
	 JWh3kMoe5pJ172HkQprjqkRU2I4H8zE8D9p5zumMizb+4pmUFv/BaLBQEgQWVCvAJqw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795081729;
	h=Received:DKIM-Signature:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Message-Id:X-B4-Tracking:X-Change-ID:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=zVwOWwHUXzKlToaA0R+Ga3qN0U7VwWvqFPcvbla4RKk=;
	b=YcS5Tyf8jMRXkSPQblBa4V8T1310vq45WNBbbUX4RCCdtYjfVsphwDvtRyMPJvd1wV8I
	 S0rQ1zYRzADTITg63V/wt6DWihe1NOXm6g2KgtmdinIMPr4dnaruchvL0Y5mTSRtez4Kq
	 oAOIr7mDt2EBw0Blz94uGONS1N/L20j7yUcay4F2mlrc40QXPrnvzMQlGFqg/fL1Kn0Tf
	 +PUWpz/kQcMSV2scqusAByarJ3GqdAFhq04eHbTx8yIU3uWxPxX16WuQKxiqBHbbQziWI
	 8xsHN3+xvwyOBukyB26bh5BT2ZctdMNhIML4JbsbvDFhmcaHLO/HkgW9c8JvT6lJdZA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=CA0Jifub;
	arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8F68606A320;
	Thu, 19 Nov 2026 09:48:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=CA0Jifub
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=100.80.115.77
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1795081728;
	b=E0tBF+d0g01McuoEXV82ofJuLCoSBJ5iAQnfBYaseesOs3b09SYzL5ZZJTlWTrV2lZBV
	 8Q82vJBv16AAFtgOXZvJeo8zIhbp1Xx/oEGRF5C5qFaDQp02z47bEVxNKjawsJsDIJtHU
	 pF1DkzRTb8EkxnYhyz94hxlEQjOvR9/is+weIKV8AWvSwH84A2vd1S/+sLtiF5HF+A14D
	 ylwMmkZGfLDCMH+ltDjIIKQNubkYmKs8EegYU4KH6SK/GEiUEWcurO50cqHevB8dhaX9/
	 3o5kEffQShFLNwasJYh1SDUdtGs8SIgNFjmF89z/iCx9jfD5LnGJnbu7D64LTqJ187Q==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1795081728;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:X-B4-Tracking:X-Change-ID:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=zVwOWwHUXzKlToaA0R+Ga3qN0U7VwWvqFPcvbla4RKk=;
	b=ULFlw2c1bxGu5BfrReXGMictl77HGielQGMbD6WsKUPH1mvQkBhAkvr/WH1C6qfmgwGe
	 xWzOrpicBsXGCHscQFIeVrO75kdnQjC+ZaFMz32gXs6uFMTtZfL+34XZtf8lu0ao9WAWd
	 WQlKZmUlXS3/sZx4C0Rvf+ZihV8t9fE6LY7gPZiVPVOnanrKVIypaYJNqG/JQEfewDQ9o
	 HwLR0ERFVC7XXuxppUIL0RaXouCTUsN2bQYkT/7U9XcnfSuIdB9meexNf+zScziYvFFUi
	 KX0ZbuRBuJLtayNl53Bkeoza7BE6FYMiVYRnaQv7eKxw7AoWE6LWg5Htgk/sfCjxszg==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id E61521F000C4;
	Thu, 19 Nov 2026 09:48:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795081728;
	bh=zVwOWwHUXzKlToaA0R+Ga3qN0U7VwWvqFPcvbla4RKk=;
	h=From:Date:Subject:To:Cc:Reply-To;
	b=CA0JifubC91hEHefqtbvm/LWAf/4mBz1m5sqSLBR5q7HB5/CTef777sDCzdlEd9qh
	 D9SGwTa3lP5TyMWjin0c5o96vVk2ONzT7DXKbbBpuTBe7XUpccTCnboMnX5VMK1cpg
	 MHhTQ5S0kKoaRDHA/5UgpO+9dUP1nMo0QA9RsEw6SFkLMmbZ2eoKB6e72omRZcoPmH
	 nXLpcIs9j3eodSp3Z81f1l5SkxRrmaMAsBCFgpcFMFkV/k++0NwvcM5ExrhNIoeMHi
	 iitmZzLlV0nGySp76tWYxu5uW5R1QMNkxxT9K2LkwDVUez9oCW75bm71eWIY7Kii3u
	 XoH84aEK3ySnw==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 630804B1F2;
	Thu, 19 Nov 2026 09:48:47 +0000 (UTC)
From: Peder Bergan via B4 Relay <devnull+peder.bergan.gmail.com@kernel.org>
Date: Thu, 19 Nov 2026 10:48:47 +0100
Subject: [PATCH] rust: drm: enable standard fdinfo for Rust drivers
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Post: <mailto:linux-api@vger.kernel.org>
List-Help: <mailto:linux-api+help@vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-api+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Message-Id: <20261119-fix-drm-rust-fdinfo-v1-1-c10f4134488d@gmail.com>
X-B4-Tracking: v=1; b=H4sIAP7F/moC/0WM0QrCMAxFf2Xk2aCZ4Jy/IntY29RFsJNkE2Hs3
 20n4uO53HMWMFZhg0u1gPJLTMaUgXYV+KFPN0YJmaE+1CciajHKG4M+UGebMAZJccQzUxMbCqH
 1R8jmUznftuq1+7LN7s5+KqnycL0xOu2TH8r0C+7/5c1f1w8kFOGgoQAAAA==
X-Change-ID: 20261119-fix-drm-rust-fdinfo-8e17f71dd9c3
To: Danilo Krummrich <dakr@kernel.org>, Alice Ryhl <aliceryhl@google.com>
Cc: David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>, 
 Miguel Ojeda <ojeda@kernel.org>, Boqun Feng <boqun@kernel.org>, 
 Gary Guo <gary@garyguo.net>, 
 =?utf-8?q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
 Benno Lossin <lossin@kernel.org>, Andreas Hindborg <a.hindborg@kernel.org>, 
 Trevor Gross <tmgross@umich.edu>, 
 Daniel Almeida <daniel.almeida@collabora.com>, 
 Tamir Duberstein <tamird@kernel.org>, 
 Alexandre Courbot <acourbot@nvidia.com>, 
 =?utf-8?q?Onur_=C3=96zkan?= <work@onurozkan.dev>, 
 Asahi Lina <lina+kernel@asahilina.net>, Lyude Paul <lyude@redhat.com>, 
 dri-devel@lists.freedesktop.org, rust-for-linux@vger.kernel.org, 
 linux-kernel@vger.kernel.org, linux-api@vger.kernel.org
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1795081726; l=1843;
 i=peder.bergan@gmail.com; s=kernel-contributions;
 h=from:subject:message-id;
 bh=xxqWVMVxZbBkPwfGR3DEyfjXL1JPRrrX4MkbzxGWQrE=;
 b=rPGVsN+1pazjTfjzZNIzCQIkNRmJM51jRUZ7lIiSyXuBw8ULl6w8n77Lj/7Cw4gLW85fu/kcM
 4snU6fRBnW0DNdVdLHz9Y6n9NGKz3jLwgSUWfzSlS2DrR/b8IgOqxz5
X-Developer-Key: i=peder.bergan@gmail.com; a=ed25519;
 pk=39790pn1YZCulHBoUG1uiQI1Hm01EvhBEa2zVrS/yN0=
X-Endpoint-Received: by B4 Relay for
 peder.bergan@gmail.com/kernel-contributions with auth_id=1395
X-Original-From: Peder Bergan <peder.bergan@gmail.com>
Reply-To: peder.bergan@gmail.com
Content-Transfer-Encoding: 7bit

From: Peder Bergan <peder.bergan@gmail.com>

DRM monitoring tools use drm-driver and drm-client-id in procfs fdinfo
to identify DRM clients. The common Rust DRM file operations leave
show_fdinfo unset, so these entries are missing for those clients.

Set show_fdinfo to drm_show_fdinfo. The DRM core helper emits the
standard client information and calls the separate driver statistics
hook if the driver provides one.

Fixes: c284d3e42338 ("rust: drm: gem: Add GEM object abstraction")
Closes: https://github.com/Rust-for-Linux/linux/issues/1266
Signed-off-by: Peder Bergan <peder.bergan@gmail.com>
---
Matt Mireles reported the missing fdinfo fields on an Asahi kernel and
suggested using this helper.

The x86-64 LLVM=1 CLIPPY=1 build adds the drm_show_fdinfo callback to
nova-drm.ko's file operations table.

The pending move of the file operations into drm::device [1] should
carry this assignment into UnregisteredDevice::FOPS.

[1] https://lore.kernel.org/dri-devel/20261118163203.2483856-4-dakr@kernel.org/

OpenAI Codex assisted with coding and testing.
---
 rust/kernel/drm/gem/mod.rs | 1 +
 1 file changed, 1 insertion(+)

diff --git a/rust/kernel/drm/gem/mod.rs b/rust/kernel/drm/gem/mod.rs
index 85657a39e146..b37695f870d4 100644
--- a/rust/kernel/drm/gem/mod.rs
+++ b/rust/kernel/drm/gem/mod.rs
@@ -388,6 +388,7 @@ pub(super) const fn create_fops(owner: *mut bindings::module) -> bindings::file_
     fops.read = Some(bindings::drm_read);
     fops.llseek = Some(bindings::noop_llseek);
     fops.mmap = Some(bindings::drm_gem_mmap);
+    fops.show_fdinfo = Some(bindings::drm_show_fdinfo);
     fops.fop_flags = bindings::FOP_UNSIGNED_OFFSET;
 
     fops

---
base-commit: 6628e7d4c6b25c8d18f1345e3a20d21829aae7e4
change-id: 20261119-fix-drm-rust-fdinfo-8e17f71dd9c3

Best regards,
--  
Peder Bergan <peder.bergan@gmail.com>


