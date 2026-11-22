Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795378149;
	b=eq3/dEcfB/WsPgkhcsTF1/vIV7T8QWupXUtcTA2qv3ass6kd7njzffKsQGK3nNApA20X
	 t0GgVTRqyB9Ciitrd3HMpKn6nZ7cs6Dq38oWJST5WyCbgNmXCxrpAf8XFV22vGt/1v8AC
	 3u0kwc744BeKPoVOU6ejNrHZN1OBF2MEx5Zvskp9tNm8Be/pfzcItSc9I0O37opIVbKtM
	 JU63tRES9lcmlI7B3M481M6KzmqHT01/kL4QfWRmVxvNrhiWpyjLdd65dtrBKSMpUFKYl
	 DlgMsdIX4hPuHVXt7mOwgyYaiztQ47KOjiZiKtrizcZVwpknm9mtES/BKe7NWhbFzxg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795378149;
	h=Received:DKIM-Signature:Content-Type:MIME-Version:Message-Id:
	 In-Reply-To:References:Subject:From:To:Cc:Date;
	bh=NJy4CQsDbbyrrux6ubIkfBdJ2n5S01Da1nbXLZiKzpo=;
	b=FD8r74YwPSQF3FHsTnr8Y0A493EBUnVeNB3DplHvVEKtRigJVmDybiwxzKQw6gg2KGd5
	 5LdfAWKq7BSTU7MtqprUyZeSpK9bKCDIPSmqIdbw+SRggQJ3/OFl27+aWTmIxQS10DRZ8
	 kp3yn+eKh3wmlruO2SaSeeWFzSbJh/oYQK5t1vprfsRFuDx6fj/Wji8LBuGEblC9T+RKj
	 0dzaVrw1OOHyhBXT4/XclvhOT9tqhZ3odxMI60kaZ359oSyIXkn5fFDuHjrc0zwrSOEHB
	 DXYIYUpmW8dwpY2zsPHZJuLhE34eNikkVDezmRpg/IvawBjhx/5sVWsEkIkM3UEYlGQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=FIlPxmeZ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 739E9606A33A;
	Sun, 22 Nov 2026 20:09:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=FIlPxmeZ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C4051F000C0;
	Sun, 22 Nov 2026 20:09:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795378148;
	bh=NJy4CQsDbbyrrux6ubIkfBdJ2n5S01Da1nbXLZiKzpo=;
	h=In-Reply-To:References:Subject:From:To:Cc:Date;
	b=FIlPxmeZXnL8jfb5igUreGcXeqBZ5IAPhfnC7/RLkwm2fVCUhGtqYHP5GbDuKZpgf
	 Rs8od4A00WVlmjWBGKGo1JI6rWCj5nnH1+0NbFWV3AkaIsmYJrE12X6iTuN/k1eFTU
	 qHOpyuR+Nwcq5ZCDMRP2gPk/h2EmJ/v9lcQ3KUTC29USZykod1aZwlrO8DAi15a4hD
	 zy5bQ3zQMmT/1KHgei8EgDoFnJTGd80G72XxB2rHkKNj7Sn4cPe3Z8gnlDNJs0gwsh
	 vuixGezimNtBC0ibmSBuA8VN6JWScZv4O78XVT3q/w0OUhL/QoblIvZBsuRCzQUuQ9
	 hDDVSB3o1NU7w==
Content-Type: multipart/mixed; boundary="===============0817330899429733780=="
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Post: <mailto:linux-api@vger.kernel.org>
List-Help: <mailto:linux-api+help@vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-api+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Message-Id: <777039b970038567305cede50f71dfed0a1a4a5616d06298ec2c7c6298cbcd9e@mail.kernel.org>
In-Reply-To: <20261122193539.3334213-25-jarkko@kernel.org>
References: <20261122193539.3334213-25-jarkko@kernel.org>
Subject: Re: [RFC PATCH v7 24/26] docs: Document userland uAPI
From: bot+bpf-ci@kernel.org
To: jarkko@kernel.org,linux-fsdevel@vger.kernel.org
Cc: jarkko@kernel.org,bpf@vger.kernel.org,containers@lists.linux.dev,linux-api@vger.kernel.org,linux-arch@vger.kernel.org,linux-doc@vger.kernel.org,linux-kernel@vger.kernel.org,linux-kselftest@vger.kernel.org,linux-mm@kvack.org,linux-security-module@vger.kernel.org,aleksa@amutable.com,alex@amutable.com,viro@zeniv.linux.org.uk,luto@amacapital.net,arnd@arndb.de,brauner@kernel.org,dhowells@redhat.com,ebiggers@kernel.org,giuseppe@scrivano.org,hughd@google.com,jack@suse.cz,jlayton@kernel.org,corbet@lwn.net,josef@toxicpanda.com,kees@kernel.org,kpsingh@kernel.org,lennart@poettering.net,neal@gompa.dev,oleg@redhat.com,paul@paul-moore.com,ptikhomirov@virtuozzo.com,sergeh@kernel.org,skhan@linuxfoundation.org,zygmunt.krynicki@canonical.com,ast@kernel.org,andrii@kernel.org,daniel@iogearbox.net,martin.lau@kernel.org,eddyz87@gmail.com,yonghong.song@linux.dev,mason@kernel.org,ihor.solodrai@linux.dev
Date: Sun, 22 Nov 2026 20:09:04 +0000 (UTC)

--===============0817330899429733780==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

> docs: Document userland uAPI

TL;DR: Docs nit: the sys_userns_set_idmap() kernel-doc @size text may render
with stray raw backticks around PAGE_SIZE; rewording the source comment would
avoid it.

> diff --git a/Documentation/userspace-api/userland.rst b/Documentation/userspace-api/userland.rst
> new file mode 100644
> index 000000000000..e32ea3501472
> --- /dev/null
> +++ b/Documentation/userspace-api/userland.rst

[ ... ]

> +User namespace ID mapping
> +=========================
> +
> +.. kernel-doc:: include/uapi/linux/nsfs.h
> +   :identifiers: userns_idmap_extent userns_flags userns_idmap
> +
> +.. kernel-doc:: kernel/user_namespace.c
> +   :identifiers: sys_userns_set_idmap

Will the kernel-doc for sys_userns_set_idmap() render correctly here?

The @size description in kernel/user_namespace.c reads:

  @size: Size of @map structure in bytes (%USERNS_IDMAP_SIZE_VER0..%PAGE_SIZE)

and kernel-doc turns this into:

  Size of **map** structure in bytes (``USERNS_IDMAP_SIZE_VER0``..``PAGE_SIZE``)

Because the second inline literal follows a '.', docutils does not
treat the opening double backtick as a start-string, so the built page
would show raw backticks around PAGE_SIZE.  Sphinx does not warn about
this.

Would rewording the source comment avoid it, for example
"(%USERNS_IDMAP_SIZE_VER0 to %PAGE_SIZE)" or "between
%USERNS_IDMAP_SIZE_VER0 and %PAGE_SIZE"?


---
AI reviewed your patch. Please fix the bug or email reply why it's not a bug.
See: https://github.com/kernel-patches/vmtest/blob/master/ci/claude/README.md

CI run summary: https://github.com/kernel-patches/bpf/actions/runs/45063222848
--===============0817330899429733780==--
