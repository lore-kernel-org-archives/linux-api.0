Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793688634;
	b=BN/D1nGXhSV+OfqI9Vfu2uiaNOAReHL7Me30+6u205Lc/un8bXXs7BN4TX8v/G2LPdZA
	 9hDZFP0us03/zOtNJjaWZdAu5krS3gZVloY0MU+thoZkqQyxRGcUUO4gdDSx5zIq9c+1i
	 qzGflpbZlSWIwsHIbnaYWp3xW1Jl5xHeMXmqCP9+Z9r9ASIZBsjVlQOj4Dq/qCqrC911R
	 l72vqEWHaAK1eOMXeVuOPB3fMEZSm3Hr/Cd4zlVLswKWHCZYgXJDYvSr2tPGNLCkTXpb/
	 yQG1NLBrYPMFqH/o2LuSYeEmAwuzsflIApphD2bvFqi4Tti17ZLKGJsH4Ly6krgoNwA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793688634;
	h=Received:DKIM-Signature:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=sQblcdlkbUfmB1DaJ6Kr5GTjgM7QZjkVClqVKNQ5Z6E=;
	b=p3KsFz+XzSAmLdrJys/9XngWOz9ZnpSldQhKLOLqTGISgH35PJQ7sGyATBtJIvRtzKfL
	 TBtqCRATgBU1/5n3eRWwhKGwrxwWrVoB9wP+6zF5R+ZR3Drl/C+1rlJ28fgFZfhrCRf1x
	 ue7Q4kKCsfTzNzAK9mWJW+w3lNt7NKh354SvfwIrQjy6TTBbyWwgQkXl9nLRLgesu2rYA
	 XVNZob/z+W3HR0CnFPT70X9B+Ar1PaO8rU10PyVqQvINXaEewn0EqgFyDG/xFb5q0A1+L
	 DISvvaQCkpC2LO5glOYzX4tx3SmzCaWkpIgBIXE6hjcpOzFxWFhN3FOZwsQuoeFQHsg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=KjWvmr7u;
	arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60BA3606A331;
	Tue,  3 Nov 2026 06:50:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=KjWvmr7u
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=100.80.115.77
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1793688634;
	b=BOwc2WJCr+DcDyMswovOfjklm+xfrxY6ic/JAjoYYkQxekwW86hNa2oeYIk7wWigO2fL
	 F8uxMQ7W+QvYDBYjHaZke9ASbLo9mHpX+FMEzM3lGjrK6pmSqhWcWRRYpnjKXdGxxkke/
	 /24Lu0CVs9ELHmbhTzUdU4vc0lth6QIftLiX7Oz6PvUasOmlth3tcAhQkJxxs7uth18Vp
	 b9l9jl07ZaNQzLPlOeGbqCTik6l2RMdN4EeOTVKqfS0TKVojkBZETuXdxilFXhtVMmFnJ
	 aVJMiSpOtc8F2MJAYnwYxFIIDb7UgFs46HRG+eREJ79I7AX3AMFuG+G6+rtmZX3GFFQ==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1793688634;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=sQblcdlkbUfmB1DaJ6Kr5GTjgM7QZjkVClqVKNQ5Z6E=;
	b=XXWfe4R6eOgnoYkOWQ9Q8QzRIf+59Bfu3ALtUOKo9jKaxk77Ax88o1tyxLOimyX6gphk
	 PnCzV0JDwkQfTzRakwNPv6pi+fIA85oBGiHFzmvB0YU2DNRahSF5rzmbQDAG38sPRerel
	 SXP/AdNYFZYyjx1RAs+CjMpKWxkJDvkyOJqWMUXrIYPZxehww+DgZxJE29ZL2iQ1RZhTT
	 if8dNxr5egDUd9YKkAT4bU2TITBQ/fvlnP+u3Z0sLOaei027a+jH9ZGUWG/IXywWBIJBv
	 nWeervIVGKaH1ikO1j5pfxNgX0XmZ/Z6dvllPa8l9PbK2cv9+RFD4RNy8c7CdtWg1Lw==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id B14731F00919;
	Tue,  3 Nov 2026 06:50:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793688634;
	bh=sQblcdlkbUfmB1DaJ6Kr5GTjgM7QZjkVClqVKNQ5Z6E=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=KjWvmr7uP92FXRO4zGdMOamWGpi2urvBtJwEGPOq0HrqW+ZPCj8aJCLiUNR4Se9xx
	 /AbxZqx1IAsFt5LZq+6G9L1A71fSvqvPIlc/79XCrBqXy57WotsgMsK08B04VcrOkO
	 XXgWyZ2UHAdNQQ1ziffKOFmDttCQxI140kUUbcUDBSQEmJ7vfKWMPDY6X6l0xXJYnf
	 XoC5+DUDl1lL/BKog/v9exDe4A/wPANBxZq0SzxRqnMKHlThG6NM8jMfabBFeslaCL
	 Xm2CYz8KGm0SetbXY0hi1V9T5rowMHu+8LAUGNw5vOcVDxc+1iALywCKPvwVVaK0I9
	 h9ENEW/tbo4fA==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 1DFB2467EE;
	Tue,  3 Nov 2026 06:50:32 +0000 (UTC)
From: Hermes Wu via B4 Relay <devnull+Hermes.wu.ite.com.tw@kernel.org>
Date: Tue, 03 Nov 2026 14:50:19 +0800
Subject: [PATCH 1/5] dt-bindings: media: ite,it6625: add audio DAI
 properties
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
Message-Id: <20261103-upstream-it6625-alsa-i2s-v1-1-bb91e2879b01@ite.com.tw>
References: <20261103-upstream-it6625-alsa-i2s-v1-0-bb91e2879b01@ite.com.tw>
In-Reply-To: <20261103-upstream-it6625-alsa-i2s-v1-0-bb91e2879b01@ite.com.tw>
To: Hermes Wu <Hermes.Wu@ite.com.tw>, 
 Mauro Carvalho Chehab <mchehab@kernel.org>, Rob Herring <robh@kernel.org>, 
 Krzysztof Kozlowski <krzk+dt@kernel.org>, 
 Conor Dooley <conor+dt@kernel.org>, 
 Hans Verkuil <hverkuil+cisco@kernel.org>
Cc: linux-media@vger.kernel.org, devicetree@vger.kernel.org, 
 linux-kernel@vger.kernel.org, Mark Brown <broonie@kernel.org>, 
 Liam Girdwood <lgirdwood@gmail.com>, linux-sound@vger.kernel.org, 
 linux-api@vger.kernel.org, Hermes Wu <Hermes.wu@ite.com.tw>
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1793688630; l=2381;
 i=Hermes.wu@ite.com.tw; s=20241230; h=from:subject:message-id;
 bh=YquEGnkfejE8LQ3h36bXPBE3tLh6TFPGHJoLWRG719M=;
 b=lLa4lYyu0HCAvAC77t+VFLi8mHRGaDxq0l3ShmMhyDEv9x09C/rJmAzz4NtI+UYwIy0FFRS6Z
 MWSSGIdCtJACYzF2hCf13F7H0z7i5eJ3X0FqCs3gET+azSqwYf7rqnZ
X-Developer-Key: i=Hermes.wu@ite.com.tw; a=ed25519;
 pk=qho5Dawp2WWj9CGyjtJ6/Y10xH8odjRdS6SXDaDAerU=
X-Endpoint-Received: by B4 Relay for Hermes.wu@ite.com.tw/20241230 with
 auth_id=310
X-Original-From: Hermes Wu <Hermes.wu@ite.com.tw>
Reply-To: Hermes.wu@ite.com.tw
Content-Transfer-Encoding: 7bit

From: Hermes Wu <Hermes.wu@ite.com.tw>

IT6625 and IT6626 decode the HDMI audio stream and output it on an I2S
interface, driving the bit and frame clocks themselves. The bridge has up
to eight I2S data pins.

Add '#sound-dai-cells' so the bridge can be referenced as an audio codec
DAI, and 'ite,i2s-data-lanes' to describe which data pins are connected
to the audio receiver, in HDMI channel-pair order. Without the property
only SD0 is connected.

Signed-off-by: Hermes Wu <Hermes.wu@ite.com.tw>
---
 .../devicetree/bindings/media/i2c/ite,it6625.yaml  | 23 +++++++++++++++++++++-
 1 file changed, 22 insertions(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/media/i2c/ite,it6625.yaml b/Documentation/devicetree/bindings/media/i2c/ite,it6625.yaml
index 9b621f726249189255692da02049ebcbf1d5b43c..9304a0507903e7eaee44fa565e49c6938e9eb7d8 100644
--- a/Documentation/devicetree/bindings/media/i2c/ite,it6625.yaml
+++ b/Documentation/devicetree/bindings/media/i2c/ite,it6625.yaml
@@ -43,6 +43,23 @@ properties:
   ovdd-supply:
     description: I/O supply voltage
 
+  '#sound-dai-cells':
+    const: 0
+
+  ite,i2s-data-lanes:
+    $ref: /schemas/types.yaml#/definitions/uint32-array
+    minItems: 1
+    maxItems: 8
+    uniqueItems: true
+    items:
+      enum: [ 0, 1, 2, 3, 4, 5, 6, 7 ]
+    description:
+      I2S audio data pins (SD0 - SD7) that are connected to the audio
+      receiver, in HDMI channel-pair order. The first entry is the pin
+      carrying HDMI channels 1 and 2, the second the pin carrying channels 3
+      and 4, and so on. The bridge drives the I2S bit and frame clocks. If
+      the property is absent, only SD0 is connected.
+
   ports:
     $ref: /schemas/graph.yaml#/properties/ports
     properties:
@@ -111,6 +128,7 @@ required:
   - ovdd-supply
 
 allOf:
+  - $ref: /schemas/sound/dai-common.yaml#
   - if:
       properties:
         compatible:
@@ -131,7 +149,7 @@ allOf:
                   required:
                     - bus-type
 
-additionalProperties: false
+unevaluatedProperties: false
 
 examples:
   - |
@@ -153,6 +171,9 @@ examples:
         vdd33-supply = <&vdd33_reg>;
         ovdd-supply = <&ovdd_reg>;
 
+        #sound-dai-cells = <0>;
+        ite,i2s-data-lanes = <0 1 2 3>;
+
         ports {
           #address-cells = <1>;
           #size-cells = <0>;

-- 
2.34.1


