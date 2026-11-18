Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=62.149.156.117
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795010933;
	b=OqvDXD+9JaURDkXWYnOgWeS6ossT2EQuNtP1UtEMfaC2F/d/W8zdqlRBPM+V6edGQuGy
	 w0kT3Yn8FbiCblAMf4FLnji7RgJyz8c0pyl/3V70/b7IiowVJnh+zWgx+xgUYvNG5mF56
	 J/fK98y06p1X5+5tVEgUMe9BBOFLYCMOcjmfBnvCLXjfcNXvyTRi3fYLNlVwRU4LWyX4c
	 p3JCXhQsHZbUqNPxESHXpt96xSFOe5J8C2vKz/VtqiPcMDVIKY49bIKpyNdiDllJqpRHc
	 9BTUlYKbXRD/MT6xKXGAkMAB+9YFKeRC9VEnP8xuSBFNLbGNpk1WOXyU+iMhOCI8qAQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795010933;
	h=DMARC-Filter:Received:DKIM-Signature:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-CMAE-Envelope;
	bh=+df84mPxPB2qRf0s9IWCLq+FM4mUd62n6vdVvrdC6HA=;
	b=wOg1VQSEJ/DBAt8mrKU6nEU/u8/IwdVqScSw24ZX5/5gGwmgTuqDo2DcwRQL1+uw2Pxv
	 ctm5hyyVrJYd2tPlHaM0FmeALd5RdNBSaMyWSmE4iGyDCSKkrlejsBuye6WkRnymqRFPI
	 6cYOzDM4aZl2Fjbr+NJKxTgmHQV3bSlrWmWsIOn1d07EET5qHR3hZbIN35Uw2xp5q6uL/
	 cm+fIL357gHfhv2tRRWXHfYjptJwS0Kgia2xaUNdUv78QskVnvlJH9mW6vfLVvGW7Rfy+
	 ITit5EowZFLZyY0o7eZmqe08hw5aLzwjaajc6VKfhAus1hQ9iNgiiTWAyBsIrbOwgEQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=enneenne.com;
	spf=pass smtp.mailfrom=enneenne.com;
	dkim=pass header.d=aruba.it header.i=@aruba.it header.a=rsa-sha256 header.s=a1 header.b="WxeeU/Gy";
	arc=none smtp.remote-ip=62.149.156.117
Received: from smtpcmd11117.aruba.it (smtpcmd11117.aruba.it [62.149.156.117])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C743060A2620
	for <linux-api@vger.kernel.org>; Wed, 18 Nov 2026 14:08:49 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C743060A2620
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=enneenne.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=enneenne.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=aruba.it header.i=@aruba.it header.a=rsa-sha256 header.s=a1 header.b=WxeeU/Gy
Received: from polimar.tail4f75e6.ts.net ([101.57.122.26])
	by Aruba SMTP with ESMTPSA
	id TgL3x51SR6VShTgL3xMvuh; Wed, 18 Nov 2026 15:08:42 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=aruba.it; s=a1;
	t=1795010922; bh=bQFBSzdwaul4KRf67gSRWGbR6PYoKg8o6esTEGD0jNs=;
	h=From:To:Subject:Date:MIME-Version;
	b=WxeeU/GyZZVGWKDWlav8NoEyVBhSiMpftt1sFyS7lgDkfZSf5ifjjw0YqP9kRK+6y
	 gTywOI89xxLSFQqQLdMLZ5cqFUc4foUfziVVYQRMp8dbitFGiI6FEfkygAHC2aByxv
	 XmjyDvWNxhZlHVVBpKN0XInRHNMvsFwcw0+6cX3am0X8dKjEaPsDYHGPvnTnoNgnOq
	 gaB30NXCODTiYQaZvBcWf5h/d3wBg2DgCcTuja93TWUw8rhN8sjQsCnFa4fK47HFvv
	 +fEZ6YWNW4oZXl1HHnC1EThzIW9P9QVSBnswY9meNS9+Oay5oj/jWSjySZa/Yn7Fa/
	 ICqksqW0C4KOQ==
From: Rodolfo Giometti <giometti@enneenne.com>
To: David Howells <dhowells@redhat.com>,
	Jarkko Sakkinen <jarkko@kernel.org>,
	keyrings@vger.kernel.org
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Jens Wiklander <jenswi@kernel.org>,
	Sumit Garg <sumit.garg@kernel.org>,
	op-tee@lists.trustedfirmware.org,
	=?UTF-8?q?Horia=20Geant=C4=83?= <horia.geanta@nxp.com>,
	Pankaj Gupta <pankaj.gupta@nxp.com>,
	Sahil Malhotra <sahil.malhotra@nxp.com>,
	Ahmad Fatoum <a.fatoum@pengutronix.de>,
	Richard Weinberger <richard@nod.at>,
	"Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
	Eric Biggers <ebiggers@kernel.org>,
	Demi Marie Obenour <demiobenour@gmail.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Paul Moore <paul@paul-moore.com>,
	James Morris <jmorris@namei.org>,
	"Serge E. Hallyn" <serge@hallyn.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	linux-crypto@vger.kernel.org,
	linux-integrity@vger.kernel.org,
	linux-security-module@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-api@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linuxppc-dev@lists.ozlabs.org,
	linux-kernel@vger.kernel.org,
	Rodolfo Giometti <giometti@enneenne.com>
Subject: [RFC PATCH 5/9] MAINTAINERS: add KEYS-KEYCRYPT
Date: Wed, 18 Nov 2026 15:08:38 +0100
Message-ID: <20261118140838.606692-1-giometti@enneenne.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261118140421.584086-1-giometti@enneenne.com>
References: <20261118140421.584086-1-giometti@enneenne.com>
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
X-CMAE-Envelope: MS4xfKiEjT0uFTsYQNdRuokOTdmnkW3pULIFQvB3gvUGOb2nW6mxdjD+mMF9m5Re0nilbpCTtnbk8020gjP3W7f9zOh0nkfAeaXYYe3YEJxQiu6w1Obo1Ug2
 P9jbfhopFkA9HutyhsZaXJJKLRyx2boRdom2oOXmG9Au1qLbd4NVPVMIP+P37Mb5GP3mOcgKzg4HOg+ynv22TBQl8n1fs+wHCmV1I8znSOEoV/wkAdYPldWP
 82YijmBgZb2WjCvpwvA7n2a4KQhpD8JQNZMMntiwVfFdnckFS561VPndNgMCAbvgB1RawKGId065rbUAQ6CYN/8PDn+SIhWsv9nTL9gqDDcpjxxe/ZwHG4/u
 jPItmbgrxbA9jYbl1TsRPHrJW51lZJ+vgpYF7wemISH+J+Go3Ys5GcZ5PNj7I3aLwP9a5ajzKsUoNds/K+GqSYbd0sOx+RqsqD6lC69XHrGdQt0c+dJk/LqD
 O7AQAUIx8gjWFVPiZ+Vuq99BORNo/6JvqaXSreAIryZCm2Dk8lCtRnHAm7iJBOQTk9wQRkTag0xNkqBB2yOAYs4peIDHlzYicyUTtc3AmeNHm1Trc11tw1Jn
 42EeGjPQpc1HmteaLWvHe+L8aTr8b4w70p2+0aCVwko+flPJ/bFcJGsAVBSnQLzpbUZ3XCdhGPVPqGH4lOliQwRlrqn27Gj7ZRlrlbUdmbas5jRXiO1Mey/P
 J+qNj7JsVSmTEM54w7cwZTtT5C1JqEWsi7wBtAJLdcAAdYLwpxofHEbmCWFpY3vszYHU7MUkvuGXbAtp9YPDlDPJbFbCZqC5TU8PhY4JMJHdCgAM6bLt1HlB
 cWiJ5G634M0t3Epd0mvyznAUk+GAHQnZXAHTTUMa8o7qjzh2BplNHtzf5ddmSO6bIV9eoaNVbE37bQApYKq5rmCkQzffmUXXnSywmC76aRqYk3TZuCtW9rLf
 pcMfcjtps/7YSHZAK8rs8frBRrKvyaaC4APqkUMD4AencSJmafcAfQKkuJ6foxc9ZtAJd244MaeESe6dJdUN3i+W8uSGKExI3wRipOvW7Y485gAOr5ohkPHL
 qKYFc7Kipw67yGIrs85Ku/s66zKUUgIJ02NQZYXdqy0qi7tCIM/bdTYPW9EN+MpdwMulW/R6k50lbClv7Qs2qiMzckD3NH2CLcTs5R0+7OBGzS3waKS3rWS6
 zcs0GlKjLdQebbI3T7gulx7ubm0k45EvJKMM3f4JOodd9BwK2PTfO+1QJzogwF/l8yxiOSvD5yC7D8kMWlU14FtPUt41pNHPohz4qg1Lj3Qe958US/qjUHhb
 73Zzk0ssdMrlnK9Yjf3jLb+PM9sNE5DdCZlk6K52B9VwAPSwiSI=

Add an entry for the keycrypt key type, its sw backend and its
documentation, and one for its OP-TEE backend, so that changes to the
backend also reach the OP-TEE list.

Signed-off-by: Rodolfo Giometti <giometti@enneenne.com>
---
 MAINTAINERS | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 222b7fc2c3aa..41dc8fe1fb36 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -14813,6 +14813,24 @@ F:	Documentation/security/keys/trusted-encrypted.rst
 F:	include/keys/encrypted-type.h
 F:	security/keys/encrypted-keys/
 
+KEYS-KEYCRYPT
+M:	Rodolfo Giometti <giometti@enneenne.com>
+L:	keyrings@vger.kernel.org
+L:	linux-crypto@vger.kernel.org
+L:	linux-integrity@vger.kernel.org
+S:	Maintained
+F:	Documentation/security/keys/keycrypt.rst
+F:	include/keys/keycrypt.h
+F:	include/uapi/linux/keycrypt.h
+F:	security/keys/keycrypt/
+
+KEYS-KEYCRYPT OP-TEE BACKEND
+M:	Rodolfo Giometti <giometti@enneenne.com>
+L:	keyrings@vger.kernel.org
+L:	op-tee@lists.trustedfirmware.org (moderated for non-subscribers)
+S:	Maintained
+F:	security/keys/keycrypt/optee*
+
 KEYS-TRUSTED
 M:	James Bottomley <James.Bottomley@HansenPartnership.com>
 M:	Jarkko Sakkinen <jarkko@kernel.org>
-- 
2.43.0

