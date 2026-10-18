Received: from mail-lj1-f182.google.com (mail-lj1-f182.google.com [209.85.208.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DCBA406804
	for <linux-api@vger.kernel.org>; Sun, 18 Oct 2026 19:47:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.182
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792352854; cv=pass; b=JKrz6HFkXphTR3yXy2t2ehnA+NX0D9kcnB+V1Dqqyi+G/AJzY1svzDiaYT1eqEB4VIHz5eFzIm2vpUGpOVdymCQCpAjrAe9LqYcMlmevj4DBHWCjblm+d70WILCAOYMXnp8wrn0P1Tl+F/N2V07hB7o6kgFILLhy7SnLc8LQPNo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792352854; c=relaxed/simple;
	bh=uSwsGj7z13o5NrJE21iC68UKNr7h5yOq6P5JpP5TNDM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=G/bcSyPxt62NLdYBfJgzcN7Hs7joe6LqFodeTjNaqnt3EZInXyI1THVLOYPUr7biJJxJfcnjKV0Nj1MblfAU1JzvswmXCPVAon0TX29Bk3+iEV1XvNNPdjTi5L3Pry8zuEtjQimIhB6Qp1WXWQLMO0ejdy64I0y0/NaBhxTiDaE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=amacapital.net; spf=pass smtp.mailfrom=amacapital.net; dkim=pass (2048-bit key) header.d=amacapital-net.20251104.gappssmtp.com header.i=@amacapital-net.20251104.gappssmtp.com header.b=U61hr0Px; arc=pass smtp.client-ip=209.85.208.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=amacapital.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amacapital.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amacapital-net.20251104.gappssmtp.com header.i=@amacapital-net.20251104.gappssmtp.com header.b="U61hr0Px"
Received: by mail-lj1-f182.google.com with SMTP id 38308e7fff4ca-3ab3b29a1d4so2793651fa.1
        for <linux-api@vger.kernel.org>; Sun, 18 Oct 2026 12:47:32 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792352851; cv=none;
        d=google.com; s=arc-20260327;
        b=DGG2dW4kEw0vZeDlQswgFlHrfPoJQu9cWnocPYs7z8pZcYXgG89M9TjDqvlJ8j0z30
         On2QLjM34poE0HFo5rKDnkK7HEcsph0AdpZi0wQo8GxtPm6e81LgXB7H75xqEcWlInCm
         ZLSsAeStItSPanjYYN5tWWbtl/swLjjxF7wIyOy1L1ZLuMe8yFkwz9fefuEhyLF0MzMG
         kAfpP5wBiU/UkmhK1qkvbo0V6j+YvRuyoizWMdjSJNQOSA1/axI45NAU8+BGF9Yuz+9g
         GA2h6RuKqEnmdBwsYhgNbhFvkEZplq+J/uU+4YPKZ4U9ywXU7MLY46slPKN9u1EyeFDL
         ytcg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=C9PTaRCgfnWLejuxwMwgHezQmSpb/Q49pSzLQ94ksTk=;
        fh=UzUzRDGrlyFqnQLmFEPpPvp0VPTiNJ/vS0K5sqm37II=;
        b=ezIMxRjqhDsPXFRjsAXBku5w8w6QcyTt89i4lRF5bP/es05oXGt9/8hDonemJ7EnVy
         IVtTnk4ntimPG7UTBuXwtY3GHjgMbynqKlmJJ7vQh6jq5qgGLnJsMkPtH+CzY8gZvZ7b
         nF03cGknKyX3JhqPj5m8q91XT1FuU6Xa/XgJNxBShbq+yySCJo4/omZjfyNU3HelLjyT
         9FCwQvjNX2XZYazk8GJ75qa2fyGGWWFV3buEOn8FjCkPqlpaJQs6kj8Cq/3HtVjvWD+f
         Elt/sXKFPyGN6o2fFVvfPMGDldzqezo0/1dmNxiZwWInZ9rjWm8rTgioGX+WrF6KuWQ3
         E9lQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amacapital-net.20251104.gappssmtp.com; s=20251104; t=1792352851; x=1792957651; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=C9PTaRCgfnWLejuxwMwgHezQmSpb/Q49pSzLQ94ksTk=;
        b=U61hr0PxGjsekFN/Peus8SSvsCkWL+X4cEShlWPsXJwFZsPSOlvUCsybYg9BgwgJRd
         4XnxIJgNM2UxnPRJ7LJ9ePNZaMA3S+v2khZQd28a3QJuiBcuUaNEpSAyegrHLGxeAQOF
         XWhhz9z4gvoj1jD71wUdmMg7TKUgBLlQEbfCfdSDreL0vc42Gwa+0w9MuT0mJeW9FjHk
         InbXbqmJqWqFBCaE7bhMzpyoImihsnstJokhn5vCptf2p7cb0uxL1CtKsrsoOoa51lXm
         tyklrtgAN7N7S853vG7iCSHElYqHLPGyLpCn9vrAZ76I1HHBL84qCv0LlLe1GVF1/qq2
         6Adw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792352851; x=1792957651;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=C9PTaRCgfnWLejuxwMwgHezQmSpb/Q49pSzLQ94ksTk=;
        b=s9w3QhYayPfXYRt+audTp1IBweadFTMnAOD79KVTw91AewG2f6CfE8Zcc/SSRut6M/
         M0auGUHNYEbAoWMcUL5Ip7hdMDyiU73IFYafB77JhJ7uf+v09tZrP4zfwIAsDf+tZGf1
         PpQpOkyhvZacFHLaxd6cZgXtuzmqdJjGfDAn8H7czedYNBcsqIr+gqZX7/zPG376RzE0
         miMk08Psr0CTMl6OIAq/YmK+jeYugcyKgNH57ZQcmhn5VFgJLwk4vwP1Tro7zpH1m/jU
         Akl83BVYGvLOw5TJTDoTUh5RQIpbobmujcwcdoDx+I3dVRUbGskReo+gqq/qKHCIT1tL
         +4SA==
X-Forwarded-Encrypted: i=1; AKwUvBzubSp80vmCoKJIRcptpnSCkKThN02HLpPM+zr/Ry/YhccIdNdGnyGaIOocmWF4KdlOc2tydmXk4Fo=@vger.kernel.org
X-Gm-Message-State: AFq9FYID53lvN4382oz1TfeG5nsfYOsjOAi1366Qb0jNi2EUMmcGhk3N
	a8Odj0EaelvOVSZnXQrhk4ELeyOGQaHbB4QyYcuBOiMrdjoD1zWVuNdH//aLRbwdf9cMq9uPwyb
	h0H9UDBgeZbUM5R8CeejPlbtI5fhLQ13UFgYZ6JUO
X-Gm-Gg: AYBFou0VUpf8EOjcwGxYvBFxaHjVx2U4nrccH0NLCOXnreLot++q6a7MKk3czVqvuAD
	zzHy1lQgfn4NP1b31bU/mIPdkE9lLHSX5nu0E2Zp/vFUdkmHcfmJIElYwcWW+tyvfZLXFHSJ9A+
	FSInoCney4YQ5KKEmZD0aaeJ1sbTBmfE+emtQ2PS+XryGOCXIsPboGM+qMCeiQpYXu9XW9ExGLN
	eHXMyFit4rxnD2ymF0uauKzAr1PHjJBHEyWQp8mtmWUfyo/WOuVeZWzYzg9mcG17V5aoc8QDksx
	SSCP0pRBsHcK7HmAFtUDdGUxRss8SphwdEXKIAy9oxwS79ZhdeD7
X-Received: by 2002:a05:651c:3614:b0:3ab:1639:9a79 with SMTP id
 38308e7fff4ca-3ab292b7375mr9897881fa.15.1792352851051; Sun, 18 Oct 2026
 12:47:31 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1792346472.git.jan.koester@gmx.net> <9c17a1f7f82b953e6f4d9e17f4ca19d5220d7f2b.1792346472.git.jan.koester@gmx.net>
In-Reply-To: <9c17a1f7f82b953e6f4d9e17f4ca19d5220d7f2b.1792346472.git.jan.koester@gmx.net>
From: Andy Lutomirski <luto@amacapital.net>
Date: Sun, 18 Oct 2026 12:47:19 -0700
X-Gm-Features: AclHuK_TjVvADO7YV_Of3nNvklGJn7yisT4mnRNh7189wUPwvl6Zlkl0ZNpg8pA
Message-ID: <CALCETrUjRpHSTBzO65uU-YaEj4espqnwDSaSLcXu653xJyooHg@mail.gmail.com>
Subject: Re: [RFC PATCH 09/41] uidgid: let kuid_t and kgid_t hold a UUID or a GUID
To: Jan Koester <jan.koester@gmx.net>
Cc: Christian Brauner <brauner@kernel.org>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	"Serge E. Hallyn" <serge@hallyn.com>, Jan Kara <jack@suse.cz>, "Theodore Y. Ts'o" <tytso@mit.edu>, 
	Paul Moore <paul@paul-moore.com>, Arnd Bergmann <arnd@arndb.de>, linux-fsdevel@vger.kernel.org, 
	linux-api@vger.kernel.org, linux-security-module@vger.kernel.org, 
	linux-arch@vger.kernel.org, linux-ext4@vger.kernel.org, 
	linux-nfs@vger.kernel.org, linux-cifs@vger.kernel.org, netdev@vger.kernel.org, 
	audit@vger.kernel.org, keyrings@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, Oct 18, 2026 at 11:10=E2=80=AFAM Jan Koester <jan.koester@gmx.net> =
wrote:
>
> Make kuid_t and kgid_t (and vfsuid_t and vfsgid_t, which share their
> layout) tagged unions: a classic 32 bit id, an RFC 9562 UUID, or a
> Microsoft GUID. KID_LEGACY is 0, so zeroed memory still holds the root
> ids, and KUIDT_INIT()/KGIDT_INIT() keep building classic ids, so the
> bulk of the kernel needs no change. The member is renamed from val to
> legacy so the compiler finds code that peeks at it directly.
>
> Semantics of the new ids:
>
> - They are not in any uid_map or gid_map: they exist in the initial
>   user namespace only. kuid_has_mapping() is false for them in every
>   other namespace, so no capability in a child namespace gives
>   privilege over them, and from_kuid() and friends give -1 (the
>   overflow id when munged), exactly as for any other id without a
>   mapping. Anything that can only store or report a 32 bit id thereby
>   already treats them safely.

Why?

>
> - Idmapped mounts map classic ids; UUIDs and GUIDs pass through them
>   unchanged, as long as the filesystem itself is in the initial user
>   namespace.

Okay, so they pass through but don't work.  Sounds unfortunate.

> +/* Like kuid_t and kgid_t: a classic id, a UUID or a GUID */
>  typedef struct {
> -       uid_t val;
> +       u32 type;
> +       union {
> +               uid_t legacy;

Linux is Linux.  small numerical uids are not "legacy".

> +               uuid_t uuid;
> +               guid_t guid;

I'm at a complete loss.  Is guid is only unique on Earth but uuid
unique in the entire universe?  Even Microsoft admits that GUID and
UUID are two names for the same thing.

I realize that Microsoft colossally screwed up years ago with their
little endian uuid idea, and I sincerely hope that this is not some
endian thing.
