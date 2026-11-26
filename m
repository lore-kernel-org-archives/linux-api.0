Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795731577;
	b=3ZYYet/cgaJJgm+LQW66KVY2r943TwUx9XDfBHsiQzbSW9R8fwplYOgHoOgo07nqCeyc
	 1UD/OVgoyHTODdN8bEhN576uKqob5TPyOW9+3oIrfKfGPpFepqgap8L1k2q6NysSwSwNq
	 ugVNTTli/ixEkqE7ZBI4ZdAAmuJ9J9Q2CYj3Vg7b6VrQ7KXRmaiJmCWtxFvyJE1aPA9B1
	 rAY09s2ZzaZQUuaLENEuCIOScsi2bXrq0qQtuwjLPOCDAQtlyPSOMw59j79wv2k5zLnTJ
	 o8HjTAtUvfBnIs9kfLtmaMRY0JbnBRMVI4EusPh1YNi7IHBmgcXY2DtHc94P1OxSmEQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795731577;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:X-Patch-Reply:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=msVtQwJ8MB3TQUWXvhQpkRrmVLPQaGbQMTulmR3wqwE=;
	b=amqFY5TzTVxe5qZOJIGCjeRkzbNtk1LozDY0xEMnZQFZkvw61Y7gryrqAD75J4Eo+U5a
	 vc8QEz79Dwtu0pV6i6muMdJ+BQxsn1iMoJck78vBuQlyrWQEMPhu9Q6v5VedePy/QzpvM
	 WYQLAJe8DPrxN5JmXF5zxBWhFDredaFzcc/f9JL25F+qkJjUIcx1XC4amGTL5Qu1eAAUA
	 9tCjqSpcml5d2JdLYjtdYFVNXY72EWA2al8O4Mm/GUFkqufLjddk8VHvEPEeuAnJI2FI9
	 A5Wu9nEgPcVVGl39ji69TnxUIFN5gVWxGSOCpxVVFlvpuaZX+y3P29xlJGGy2UxFGag==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=iRKYnB40;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BAD3606A31C;
	Thu, 26 Nov 2026 22:19:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=iRKYnB40
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFA4E1F00897;
	Thu, 26 Nov 2026 22:19:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795731577;
	bh=msVtQwJ8MB3TQUWXvhQpkRrmVLPQaGbQMTulmR3wqwE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iRKYnB40rjL1zPUbITPs7GbPCTDfcHy4p+clJnYT+C4QGsXDU+8PG1D4vF8ZUWQ6c
	 J6NqvLgYbM8gEZnm/Sm8ABO3WTb5SQNL4ljy1kEnOM5zjiLfRlX/wzqI919zSbZNkH
	 Fzm2Xpez91t8wxKY7jNMW3YdfE0owRH+zuMKU4iELYDZnOOF2P0HLlyzpgJ1lTFdUU
	 Xl9fZ9BU7pzQ5a3sRHnQq65JO11hYWyKvm7vtBYRJqeFjnhY9E2uRTdAcPl6okru9b
	 L8Gye6g+7dc7Qmwnqed5krMzkm0fnjsO9DvdM3LY6+xknKE5T8wGg8StWXHKM74dbp
	 L0CFZL/u1DXlA==
From: Danilo Krummrich <dakr@kernel.org>
To: Peder Bergan <peder.bergan@gmail.com>
Cc: Danilo Krummrich <dakr@kernel.org>,
	Alice Ryhl <aliceryhl@google.com>,
	David Airlie <airlied@gmail.com>,
	Simona Vetter <simona@ffwll.ch>,
	Miguel Ojeda <ojeda@kernel.org>,
	Boqun Feng <boqun@kernel.org>,
	Gary Guo <gary@garyguo.net>,
	=?UTF-8?q?Bj=C3=B6rn=20Roy=20Baron?= <bjorn3_gh@protonmail.com>,
	Benno Lossin <lossin@kernel.org>,
	Andreas Hindborg <a.hindborg@kernel.org>,
	Trevor Gross <tmgross@umich.edu>,
	Daniel Almeida <daniel.almeida@collabora.com>,
	Tamir Duberstein <tamird@kernel.org>,
	Alexandre Courbot <acourbot@nvidia.com>,
	=?UTF-8?q?Onur=20=C3=96zkan?= <work@onurozkan.dev>,
	Asahi Lina <lina+kernel@asahilina.net>,
	Lyude Paul <lyude@redhat.com>,
	dri-devel@lists.freedesktop.org,
	rust-for-linux@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-api@vger.kernel.org,
	Janne Grunau <j@jannau.net>
Subject: Re: [PATCH v2] rust: drm: enable standard fdinfo for Rust drivers
Date: Thu, 26 Nov 2026 23:19:30 +0100
Message-ID: <20261126221930.3790327-1-dakr@kernel.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261126-fix-drm-rust-fdinfo-v2-1-b1653edf1e4f@gmail.com>
References: <20261126-fix-drm-rust-fdinfo-v2-1-b1653edf1e4f@gmail.com>
X-Patch-Reply: applied
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Post: <mailto:linux-api@vger.kernel.org>
List-Help: <mailto:linux-api+help@vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-api+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On Thu, 26 Nov 2026 18:39:33 +0100, Peder Bergan wrote:
> [PATCH v2] rust: drm: enable standard fdinfo for Rust drivers

Applied, thanks!

  Branch: drm-rust-next
  Tree:   https://gitlab.freedesktop.org/drm/rust/kernel.git

[1/1] rust: drm: enable standard fdinfo for Rust drivers
      commit: 02efea879e87

The patch will appear in the next linux-next integration (typically within 24
hours on weekdays).

The patch is queued up for the upcoming merge window for the next major kernel
release.
