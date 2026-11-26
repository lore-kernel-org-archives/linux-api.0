Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795711664;
	b=ZzxbsnJrkdnuhTZDcmnupmIWi+39c47HDtrE34oJV50HK4/S0ltMnLXOyJl7LhHGVAAZ
	 wmKb4AeyyOfdUd6pClhl/ADsfYIkDeWaOcrDdDEdpYm63NrNBFOEAsixUGUT1abS84fsP
	 YgI64Oy5lxvBZgPw7kbUukm4nEkoMgc+b2mHuHvymFAUsTiNKh6v5G8LIQxXGy5dBmsx3
	 ig7pkrFctpqWgOSOgW5dua+BaUyoWaGfWcQ/Y5QztoEpISzo4BMlMiFsrgSjjUbAFzFbN
	 in5xgNFSWHa+KYngRqTMsX4vilUyyjnJj7RkrI5SOiyX/wJwKQ6yWUifB82d432DQRw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795711664;
	h=Received:DKIM-Signature:Mime-Version:Content-Transfer-Encoding:
	 Content-Type:Date:Message-Id:Subject:Cc:To:From:References:
	 In-Reply-To;
	bh=OPyhiLuvaz7fWLByy/7xp+zcD6om0vncqH1lu9yD1QM=;
	b=Rm8KhUG/1bqKdfcB3qDBy9m4+Nslcz3LDsDpGvQ0ICRvL/sUPKF3qwUrs1X00zgexvZV
	 /LYq3h2DFryEnCqPXIuIdPpGXdLkOL0Nj2KmzbK4gpzIN7bx6svXGqdHAUWH1yT2gTWZ0
	 4fFyHUqEiccQaqe2zJ6iAhSV3YYAxFFRjuSI4PjVFKL5wmtUVickd7CgOHGI0CMsS/apU
	 A6AyNXNR21CItui4WMnQ6otifyq0aKco3INN7B4j6rV45wapJMwGCYgOrvqvK1APHw8hF
	 rmjakWw414BX4YoIibKZCMtmbkMAo/cTel/7mMwpog8prdtlXjw8mYTJuuEPw1VFgmQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=JwbsSEGS;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 040AD606A31C;
	Thu, 26 Nov 2026 16:47:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=JwbsSEGS
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBBF51F000C4;
	Thu, 26 Nov 2026 16:47:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795711663;
	bh=OPyhiLuvaz7fWLByy/7xp+zcD6om0vncqH1lu9yD1QM=;
	h=Date:Subject:Cc:To:From:References:In-Reply-To;
	b=JwbsSEGSuDUbdeGbYrF3Iq8qSdMKqQ2MtsTfSl+/l4/UaARiVByGhY8i+Hu1r2fog
	 XG86xtnpCdDdSuhKKqH1Ia5/K0QGREDEuKYuOCZ6h9UAANiEfzk7n2KA/DF/k8dWGn
	 E47BujKXFKpf0k/MfJeCjJ4dLP9G0NhfpKvpWtWP2kyi9ZrpyM9C2o+eH1mswJeDDP
	 7spQ/PCuY0nsoL1FLkjsdOjKuU/Pmii9p01EapSR3Tgxv/jpEWaMTFq6Bp+6zrRfNj
	 LsPjOIlA16BW+T5C7zpTqs44xVo2P/7PvW2puGvbaJVNjoeVTxomgGzH9DaGJlLhPN
	 DnDVP4eknj/wg==
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Post: <mailto:linux-api@vger.kernel.org>
List-Help: <mailto:linux-api+help@vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-api+owner@vger.kernel.org>
Precedence: list
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Thu, 26 Nov 2026 17:47:37 +0100
Message-Id: <DN5ANMVV3IBA.1Z2USNB5M8X3M@kernel.org>
Subject: Re: [PATCH] rust: drm: enable standard fdinfo for Rust drivers
Cc: "Janne Grunau" <j@jannau.net>, "Gary Guo" <gary@garyguo.net>, "Alice
 Ryhl" <aliceryhl@google.com>, "David Airlie" <airlied@gmail.com>, "Simona
 Vetter" <simona@ffwll.ch>, "Miguel Ojeda" <ojeda@kernel.org>, "Boqun Feng"
 <boqun@kernel.org>, =?utf-8?q?Bj=C3=B6rn_Roy_Baron?=
 <bjorn3_gh@protonmail.com>, "Benno Lossin" <lossin@kernel.org>, "Andreas
 Hindborg" <a.hindborg@kernel.org>, "Trevor Gross" <tmgross@umich.edu>,
 "Daniel Almeida" <daniel.almeida@collabora.com>, "Tamir Duberstein"
 <tamird@kernel.org>, "Alexandre Courbot" <acourbot@nvidia.com>,
 =?utf-8?q?Onur_=C3=96zkan?= <work@onurozkan.dev>, "Asahi Lina"
 <lina+kernel@asahilina.net>, "Lyude Paul" <lyude@redhat.com>,
 <dri-devel@lists.freedesktop.org>, <rust-for-linux@vger.kernel.org>,
 <linux-kernel@vger.kernel.org>, <linux-api@vger.kernel.org>
To: <peder.bergan@gmail.com>
From: "Danilo Krummrich" <dakr@kernel.org>
References: <20261119-fix-drm-rust-fdinfo-v1-1-c10f4134488d@gmail.com>
 <20261124185427.3821700-1-aliceryhl@google.com>
 <nh-b28a5938-34e4-4077-822b-71fae5f4773b@google.com>
In-Reply-To: <nh-b28a5938-34e4-4077-822b-71fae5f4773b@google.com>

On Wed Nov 25, 2026 at 8:57 AM CET, peder.bergan wrote:
> Danilo, I=E2=80=99ve prepared a v2 against drm-rust-next with the callbac=
k in
> UnregisteredDevice::FOPS. Would you like me to send it?

You mean UnregisteredDevice::VTABLE? Yes, please do.

Thanks,
Danilo
