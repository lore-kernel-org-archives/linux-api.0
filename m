Received: from mail-lr2-f9.google.com (mail-lr2-f9.google.com [74.125.230.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17DBA47DF86
	for <linux-api@vger.kernel.org>; Mon, 28 Sep 2026 23:44:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.230.73
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790639087; cv=pass; b=gtRWOizvSPaxMLTPBEhufQodWobM90GRpJ/uOEpxS8aHH0i5+lEDfi9800KgBxklrazSPOCs/D25JF6n4wi/filpahxz90h6XlTHBjZ7yyyDUphj5xh4csZ/ACnsnUAMi7xJkAgktawrgUI6zKFjlksq8HkZLqNKIyXhl1sIP/c=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790639087; c=relaxed/simple;
	bh=N8Ru2KZ4gnHPrAukAwiJge7OXCwCBTs64/BeOs5VIkw=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=HwZgBd5BISZJBSHsGCrnV26ZZy4p29uWZqHJOBEHT63xKtvWAMXSgmCyL4uGnWF3KS38Ipp2teJum9QSGj8L6D0kgKejnYGnktfxMseLHqZGzCygCHzB9Ja3hyuyiz4HyvGUkfWs3/yW3cAdQQKVtzejkbA3T/YfeViTeQU951g=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=U9xfHsZk; arc=pass smtp.client-ip=74.125.230.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="U9xfHsZk"
Received: by mail-lr2-f9.google.com with SMTP id 38308e7fff4ca-3a655c007efso22383871fa.1
        for <linux-api@vger.kernel.org>; Mon, 28 Sep 2026 16:44:45 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1790639084; cv=none;
        d=google.com; s=arc-20260327;
        b=MLg1o0K4SKI6WS9BRJiaGp5hChDPHO02ebct10aMbYVqMNxc4l+fRQIAKrEH2U2wJG
         ge8mm5WsAKeELJxyo/n3nC3+kn7mXjWQ+kiQ3q7vUdznOySVF03dq60wORXmRavj/twi
         +qtGuJg22WKjGMRuvU3JRsn2G0WF+maJ5/SuHQzzGj6K1aJBpOLLWPUxGnuUS9gCb4mc
         f7t/LOqH/3eKVLjjELTZiJ3GHyJ2oyKjoWHAOyFfnVTNTbAcKb42x8E+SnQd+DQeYgYp
         dVz+zn31xRBQFt5ZSoiw8/WJVQang5LUAMluR2MQ+xdu6Di//GbzacPTNhIMZO5DRliL
         gIxg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:mime-version:dkim-signature;
        bh=N8Ru2KZ4gnHPrAukAwiJge7OXCwCBTs64/BeOs5VIkw=;
        fh=d/ZWs5SEQ2HtReC6eEiLsf3oKeMmlJhTlwYmZW6stDg=;
        b=aQ/CijJQdZScTbwJWY6EYhc55jsbofcrYa/y+8MrUPqmSpkm3ouw+nD2p/6OjSF9hc
         Q6FhG9q5OlNd8GiIcxIhtCrWtYDLU6Emr56QwuaK/Uk6sg/is3+qZPXfi+xW+yeA6+Cd
         O2cyUCAPKkMnYu4DLxzlbkTNFgwibAD5z1ax672/2UhI/nJuYw19rV2tOpv/kFCwpXJK
         TridfY1dYh3ijZ8KGIAod44voPx4uHvZ7L9LQgLJeR+8LCJyujbJV4MAnFWMC4fL17Hw
         QrAYWa23L0YhAJa9WBRUM3RZboIdU7en1oBsE2EkQ1+xaCJapdT6Nt45VCXmtCIn7OUb
         oifQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790639084; x=1791243884; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:mime-version:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=N8Ru2KZ4gnHPrAukAwiJge7OXCwCBTs64/BeOs5VIkw=;
        b=U9xfHsZktYUjcDNnHgiPXqk0uziSRSj6H7tXw10zBThOwv3HwKy30K1k7B2wOACgfU
         G9+XYl2CnhDqDQEOQ+4WiQsAetQUkkZPDB/9ko0NFpGwmKFM1sqljbjNbT7UGzN715Lf
         mauQsojCuxseN46ZHmOVBIgl0WZ16iO6zSJJB0tSva7SsEIa4beH3e2RcKyfGTyLj+rt
         l2WDFPjrng8qXlHoRWmXRMTpSXXRSD2GTb8IuK4KEIEjgr/HHkLRFIdduM7GkzmZW+00
         Jsyhlt9jpA1yPf/hCPrxqkfx6/JYQHwNxDW2agOoOIgfqqALTw8VbUbFLrVJGTMP413L
         h9ow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790639084; x=1791243884;
        h=content-type:cc:to:subject:message-id:date:from:mime-version
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=N8Ru2KZ4gnHPrAukAwiJge7OXCwCBTs64/BeOs5VIkw=;
        b=LJApV4AsSRI2un14mOBz5E8jtjOQLNTCOwYpaG1Ony6OfEsLHnHztD8gv3uYG3ExeV
         lL50cVtOsOfULhn9QXn+nFbsbbE9B/CeurBaHDLd8F/TtPMzLL5+gYnBbKaH9q6UaZXY
         GP61XPEoxZHhSSk4v77TY1107IZ4MvHlcPV2xhF75DB1zMKzrQCCbPBVYAY668hlF7eu
         5+iuIatR25Iir3AoqoXP8OqEX3GHaQ7RIF8Ryq2CAViUZ+Y4f79J4mqagMYbSPtUXlOX
         c9g+6siv5TIHOJofjwd23lDkxIDEAwEwVCunh2hOER2vAu1BVh/tlC3TTi9mqi+IRSxf
         D2AQ==
X-Forwarded-Encrypted: i=1; AKwUvBxMmyrpI0XN48fpVDF7HhC4qO+X5kJn9hwvVdW9LDu34SQUsJKHJVOGceoY/ce32aZocLtI4v67qJ8=@vger.kernel.org
X-Gm-Message-State: AFq9FYJekrr0Ws+YAqq6iltvoV1UZrLb+axOyVtacV3vkQCV80EKycpE
	WPH8/9X8mKKNyrY7AYuBswNwisyLPXmCwFAYMGLElR9TtCswss6zjRG/YRYAI6rmDBzyva6jW5P
	h6mTiv9USgcRuuoHbLaadI3amT6ecESU=
X-Gm-Gg: AYBFou3k0ohDu8rqplaAxUAat7EGXtX0djPW9RuftXhV192UIpJusorqsz1NjTIjZRk
	6UcYHSKqrRIWEs8/820KEifg3FqxMgJ8djSvjgy4jNZXB/tIVky9uVrjIySKbINXFMcXRRSLQLK
	BuGC+iZSpNUZj83CGk8QTS1MJlJMWtPsxi/CpiQOWlPu/I9N8Kc8evmtLfZXIZiCfaCxEoo8X6T
	Ehc0qKQJMwYI7DBJhYh43+wVr3OwGylw1WpD9WhdxaVbM4c5HML/mBkRif1KlFmcAKOFB0DQMc9
	gBQ6LElaoie+37LEuP2/6iF/Z08Z2vg+QpalJBNIHBTngufvUeLH1VhBkFgQ9AAeH2VmaOCdFB0
	261Ab6ezzPkCkV7fZyDLVAuBntqI9omM/ZCxSohVd450b+wGLW74HnNQ3racrX3fqNeC8ne0=
X-Received: by 2002:a2e:b8c8:0:b0:3a6:772c:2763 with SMTP id
 38308e7fff4ca-3a6772c2ad3mr10310711fa.0.1790639083996; Mon, 28 Sep 2026
 16:44:43 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: omer zalman <omerzalman42@gmail.com>
Date: Mon, 28 Sep 2026 19:44:32 -0400
X-Gm-Features: AclHuK_VsivwmfiG4mYbPPAahvGUwAEkm-1jf-dH6-g7RAdYNo4Yu9FnxlBZi20
Message-ID: <CAGLNFZes3CXA568n+5_rgoneDh7w-2=MS34ON7n1tq3ezeZzsw@mail.gmail.com>
Subject: [PATCH] check-uapi: reject zero and malformed job counts
To: akpm@linux-foundation.org
Cc: arnd@arndb.de, quic_johmoo@quicinc.com, linux-api@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: multipart/mixed; boundary="00000000000085ee3a065c93a6a5"

--00000000000085ee3a065c93a6a5
Content-Type: text/plain; charset="UTF-8"

With -j 0, the per-header loop waits on an empty PID before any
worker starts. It counts that wait error as an ABI failure even when
the header passes. Reject non-positive or malformed job counts as
prerequisite errors before starting the check.

Signed-off-by: Omer Zalman <omerzalman42@gmail.com>

The exact git-format-patch file is attached because Gmail's web
composer removes tabs from inline diffs.

--00000000000085ee3a065c93a6a5
Content-Type: application/octet-stream; name="02-check-uapi-job-count.patch"
Content-Disposition: attachment; filename="02-check-uapi-job-count.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_mulw9q5i0>
X-Attachment-Id: f_mulw9q5i0

RnJvbSAzN2UwZDE4YjdhYWE2MjE5ODFhYzE0MzNmZDRkYmRhYzcyMTk0Njk0IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBPbWVyIFphbG1hbiA8b21lcnphbG1hbjQyQGdtYWlsLmNvbT4K
RGF0ZTogU3VuLCAyNyBTZXAgMjAyNiAwODo0MToxMCAtMDQwMApTdWJqZWN0OiBbUEFUQ0hdIGNo
ZWNrLXVhcGk6IHJlamVjdCB6ZXJvIGFuZCBtYWxmb3JtZWQgam9iIGNvdW50cwpUbzogQW5kcmV3
IE1vcnRvbiA8YWtwbUBsaW51eC1mb3VuZGF0aW9uLm9yZz4KQ2M6IEFybmQgQmVyZ21hbm4gPGFy
bmRAYXJuZGIuZGU+LCBKb2huIE1vb24gPHF1aWNfam9obW9vQHF1aWNpbmMuY29tPiwgbGludXgt
YXBpQHZnZXIua2VybmVsLm9yZywgbGludXgta2VybmVsQHZnZXIua2VybmVsLm9yZwoKRnJvbTog
T21lciBaYWxtYW4gPG9tZXJ6YWxtYW40MkBnbWFpbC5jb20+CgpXaXRoIC1qIDAsIHRoZSBwZXIt
aGVhZGVyIGxvb3Agd2FpdHMgb24gYW4gZW1wdHkgUElEIGJlZm9yZSBhbnkKd29ya2VyIHN0YXJ0
cy4gSXQgY291bnRzIHRoYXQgd2FpdCBlcnJvciBhcyBhbiBBQkkgZmFpbHVyZSBldmVuIHdoZW4K
dGhlIGhlYWRlciBwYXNzZXMuIFJlamVjdCBub24tcG9zaXRpdmUgb3IgbWFsZm9ybWVkIGpvYiBj
b3VudHMgYXMKcHJlcmVxdWlzaXRlIGVycm9ycyBiZWZvcmUgc3RhcnRpbmcgdGhlIGNoZWNrLgoK
U2lnbmVkLW9mZi1ieTogT21lciBaYWxtYW4gPG9tZXJ6YWxtYW40MkBnbWFpbC5jb20+Ci0tLQog
c2NyaXB0cy9jaGVjay11YXBpLnNoIHwgNSArKysrKwogMSBmaWxlIGNoYW5nZWQsIDUgaW5zZXJ0
aW9ucygrKQoKZGlmZiAtLWdpdCBhL3NjcmlwdHMvY2hlY2stdWFwaS5zaCBiL3NjcmlwdHMvY2hl
Y2stdWFwaS5zaAppbmRleCBlMzQ5ZDFmLi5hNWI1OTk1IDEwMDY0NAotLS0gYS9zY3JpcHRzL2No
ZWNrLXVhcGkuc2gKKysrIGIvc2NyaXB0cy9jaGVjay11YXBpLnNoCkBAIC01NzUsNiArNTc1LDEx
IEBAIG1haW4oKSB7CiAJCWV4ZWMgPiAvZGV2L251bGwgMj4mMQogCWZpCiAKKwlpZiAhIFtbICIk
TUFYX1RIUkVBRFMiID1+IF4wKlsxLTldWzAtOV0qJCBdXTsgdGhlbgorCQllcHJpbnRmICdlcnJv
ciAtIEpPQlMgbXVzdCBiZSBhIHBvc2l0aXZlIGludGVnZXJcbicKKwkJZXhpdCAiJEZBSUxfUFJF
UkVRIgorCWZpCisKIAlydW4gIiRiYXNlX3JlZiIgIiRwYXN0X3JlZiIgIiRhYmlfZXJyb3JfbG9n
IiAiJEAiCiB9CiAK
--00000000000085ee3a065c93a6a5--
