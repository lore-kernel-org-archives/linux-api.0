Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795489524;
	b=aBgbnpcchNdgW6T/e0QgXW7XDukKV2JxAyt5pJGKSCSWIzR6SOP4incRd97YCCTx2dCF
	 Is5IJAoJtPfMEEeG3OjCAimi02uRX8qhwAKnYIUJb3J7a4zndHWR4+FMJn5/tkVHBz9Yz
	 Tpct7db5fMaSxhoX4E7V2b27NG/4BHsCHKTqKUZSmBFOO6VeRq3y1oNxoD7WYbw2i2RsQ
	 2LEwSviGubsR73ZmguRsEadwIqy3aEVJ9kfiP+d5Lil9joSvglfBelrjFFPBH1EHC/DF5
	 aBf0bn6UZmQW2RDdNrIaUj7qii46md/mkpcWYdBaHDdSIRPGMdGLQwc+TPMVXH77UhA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795489524;
	h=Received:DKIM-Signature:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=7Y0b+EXqWgsC/2mTNzo3FSSaaPYeFJP1R3fny40byqw=;
	b=3SnZh9d/3NoLrDPkucrz8Nh6YCTAIjUHBc475LI8kozvh8uUjQOXpaCRahaGHlWWxoyH
	 0aFp0pBCZGwJMmftJa9EylusV422FqLXOfwnB8aZEVw5nws0shbWYQGevykHQOvCVCjkb
	 rwmxKaqG0mhar0dJleBgA1pzEdTJwjJ6w3pYHhNekDl4GDxi0sJjH6ERchOKHe4lSaZn4
	 6NGM2O7vxfqrszm8CdNCzwpv5PDGthBgAJ3j7lU3hSeqN9dhC3s9s0E8epbJdpZLwf1p1
	 bfTHcPfNHTDJGFUKAWQoK2Jase3fPypv5E9KMPT5mqnhQF3U+IYaaZu5lOneUg5fNVQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=l8hGT3pZ;
	arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D0E7606A68F;
	Tue, 24 Nov 2026 03:05:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=l8hGT3pZ
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=100.80.115.77
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1795489523;
	b=lHXcvvxuPKK8lC5WIyb3aJbeD7cJV6E50KzyGQLhpExNXL29Wd/nnZOIAQn+VLzyUp2j
	 6zjivP/rH1hcF9TQ09f75bZDOl51en2mgY2tIB09XNZlQ9v9WASY8su4pazFAcmT5k3Ur
	 duYwKufbhM/XlIlrrU8ynf0r2H+QvhAGGOMh3ObFeSBlazwRWDoY3NoBLhrjHrrPcGKIC
	 yXf1HGXCqrxqtT/D1WSfE1GdOVsHvyn36yuQRcBzMmNzHgW9Ly/90xwcyb1YCeK/aS5Xz
	 W3gIVP18icpHqDOnnRm2LQon0IDiZLzAQztbkx7HDQBWMr3oHxVj1uEEgP+iwGcMn7w==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1795489523;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=7Y0b+EXqWgsC/2mTNzo3FSSaaPYeFJP1R3fny40byqw=;
	b=krSNT+1Z8Vt3v0A6j1ZXpS4WUnT1plhnZGfLzOEhaDXJmQqu3Vz8TFTS6+K5ONp/9AkG
	 FVTZQkziaJro1nHd5K3y2GmniiT60W4397BBZ2s3Be++0SI9kiG1HRocmC7Ffu/XoICIb
	 2K2RfptPdZ6SfApStjcIh4Ab8090Iqx7fPHYOMIE6i5FEG/pHtWKF7gSyilxdIJ4J7j3p
	 Y8S3bcUW9XT+INHcz6yUAnX9LDzRVo0pbnYOELVW1wElnByQaDvtK2HZ6r7vsetEs6jR9
	 IzerU+Ybz3odrS/qGaU4qdBnKhFl2770qHYAFWjPzmJkxE1/R+x1FkPJOUx1VN2VPJg==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 7AB101F000D1;
	Tue, 24 Nov 2026 03:05:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795489523;
	bh=7Y0b+EXqWgsC/2mTNzo3FSSaaPYeFJP1R3fny40byqw=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=l8hGT3pZACQGyJ5d5G3wZ3pFxxn748wpSS2O93SLgGF2+wM7oCQI197WfybTYL5Jq
	 SSAPOlGP0UHBv4JghShy3WgrOY7U46UimlRwryW4qGaIe803eYPwcEeMeckasqP4RZ
	 eXvJ0N06kS5OnDV39NY91GGPgfx4FjTETSeUC8xd8IG0tPyCRYhUBYLm4WVj8Jt/C/
	 Dfj1E5cT4Trv6YzpJSmTF2Z0db2FOKZprM6mPGw+2aq/4hQDI0M6/blPghp3cCDNO9
	 kOV9h73nlhSYly9gvKcP9YN3OHI3VS/J6saK8r6PMSoH+UFRBpISc3WcVausvqFo0f
	 vuesooP+ouMCA==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 07BCB4C867;
	Tue, 24 Nov 2026 03:05:09 +0000 (UTC)
From: Hermes Wu via B4 Relay <devnull+Hermes.wu.ite.com.tw@kernel.org>
Date: Tue, 24 Nov 2026 11:04:41 +0800
Subject: [PATCH v2 4/9] dt-bindings: media: ite,it6625: add audio DAI
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
Message-Id: <20261124-upstream-it6625-alsa-i2s-v2-4-a154685f6989@ite.com.tw>
References: <20261124-upstream-it6625-alsa-i2s-v2-0-a154685f6989@ite.com.tw>
In-Reply-To: <20261124-upstream-it6625-alsa-i2s-v2-0-a154685f6989@ite.com.tw>
To: Hermes Wu <Hermes.Wu@ite.com.tw>, 
 Mauro Carvalho Chehab <mchehab@kernel.org>, Rob Herring <robh@kernel.org>, 
 Krzysztof Kozlowski <krzk+dt@kernel.org>, 
 Conor Dooley <conor+dt@kernel.org>, 
 Hans Verkuil <hverkuil+cisco@kernel.org>, 
 Hans Verkuil <hverkuil@kernel.org>
Cc: linux-media@vger.kernel.org, devicetree@vger.kernel.org, 
 linux-kernel@vger.kernel.org, Mark Brown <broonie@kernel.org>, 
 Liam Girdwood <lgirdwood@gmail.com>, linux-sound@vger.kernel.org, 
 linux-api@vger.kernel.org, Hermes Wu <Hermes.wu@ite.com.tw>, 
 Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1795489507; l=2454;
 i=Hermes.wu@ite.com.tw; s=20241230; h=from:subject:message-id;
 bh=N60t6qifQy8+4kcZ9BAZBOwk+hdXLMCBdE9iiMQSH94=;
 b=HPrXDx5h7/ve3Dk3ljeUmxXH+JgyDvH5MNtJioTai6APjVXtmQ/ty+RDRfhtoIczssZivT9w8
 0LBp9CjNXM+AUDQBhiqsqBsTNPssT/WaO05kVJ4xxq1BNGSadWnuLmn
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
Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
---
 .../devicetree/bindings/media/i2c/ite,it6625.yaml  | 23 +++++++++++++++++++++-
 1 file changed, 22 insertions(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/media/i2c/ite,it6625.yaml b/Documentation/devicetree/bindings/media/i2c/ite,it6625.yaml
index b766f075dedd4668446856aceb854b24726a1266..d00a3d607e8a7893118bd25fa93136656b31703e 100644
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


