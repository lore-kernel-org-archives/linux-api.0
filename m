Received: from mail-lj1-f195.google.com (mail-lj1-f195.google.com [209.85.208.195])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFDF3502D62
	for <linux-api@vger.kernel.org>; Mon, 28 Sep 2026 23:43:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.195
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790638985; cv=pass; b=FLa1eNFvDFh0RzhMXNGCAQIbOPbN3cEJEK/RfbEoXCBNnjEiGIi+9sku+DcwkoTHXaplOsKPf4BWUtCtYX7MSdP5mEVwVqVk3SIv63Y5fVdApAWSVHOMZzVqvgfbUy6r4ChTMNkuNBUHuwNfiBB96mpnaUqp7m3GkLoNFT8t0ic=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790638985; c=relaxed/simple;
	bh=Jeh+2Xd4AG2I2O0hzKDIItKZ7vv+hHcdVOBN2BJoRoI=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=qMCdqXjTShNpJ2fo/UG7y6RvkE3f8Lc1fUHf4aAMPlQ75qyJkG/Ak9U1sgwGeT71Za8nP6H4G3Y2LD11gLkJJhSuJA9uWEZGlaGW/qosEJ3palkFttoarv4C9JB5EGg9TGTxdy0Pk9cZAlqgnJ4H9T6hDQR8WlPM7vOvNTYbYjM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=X/aaww2x; arc=pass smtp.client-ip=209.85.208.195
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="X/aaww2x"
Received: by mail-lj1-f195.google.com with SMTP id 38308e7fff4ca-3a65c6fdaffso2638591fa.1
        for <linux-api@vger.kernel.org>; Mon, 28 Sep 2026 16:43:03 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1790638982; cv=none;
        d=google.com; s=arc-20260327;
        b=YY7VOVppCP7hMRaB6nnRqahw0wmIEsCE1lFX9ZYebaRoRp47DPO/VgR7ln/baDNq8p
         a8BbcGUi7Ym/r1NyrEbakQhGY+sbTnrI7rEdD0gAucPtT10u3H3ezILQ1EP86qXwSh+w
         PeHISk/ZGbp7t/51uosnyQvwcmQykH7nKVJnlw60W5TUC+ryVhOoSF+PDYiIYaS3a4FF
         FHkg42pzMmhghnDBYnbg5oIig7lvZzep/zSOZ9it9QAy0AwAF9n5+K1yrKYKYkEUK3ip
         yJe4DVUxjsIGDLNeiOW/+PhWyQv932SDHAASMzfTAdUmQBA284XDC6Zk5kqAyoJ7SHmH
         tgVQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:mime-version:dkim-signature;
        bh=55HPJl5SBbsItKpLLMuAZDA3mfNkU/nrSg5Ddo58dAY=;
        fh=qtmPnBlqDhCFBQXRrMvi/FlyByECKQLFM8mZnNkxAuo=;
        b=TwugXyGOZ3nzb7DDQKO5cAwpBk/0hCVu773EJKiVl5+xMSaO6dWYAXk20WptkHTt0N
         nhYCzQmXwaDWh+5QR47vObIR9PKv59KWB/1iSKZReuXyToP7y5+9o37WdgJAoCiTyDAy
         NxpmPepqvI78lWutNnogscH+ChRIhGwprCrOduF25DFbibIwHDZ61+Q7Fwt5kv4jX/9P
         xI3GVb/VihA7K3aqShSNP5Jg+PfbmbKDFUcNyFOqZVZRy5FrHYk9YOeCnivTVoW9eZyC
         Zvu9LzQZV8+z28Yg65FLWI2kso8Rv6JhcD6t6GH0/bSWlHCBJb8KGF9NWZfDaoFx4GqM
         KeGw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790638982; x=1791243782; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:mime-version:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=55HPJl5SBbsItKpLLMuAZDA3mfNkU/nrSg5Ddo58dAY=;
        b=X/aaww2xIuWwZlHP7m7rDBRIiFEJcCTLVNt5mjripvMxDicTcv9oPrIxZXXgjAZn1g
         NExbjGXVPHQGNNoe0S768MLJ3onby4gmeEeX5+gyLfmxMuTK5jwhI9pmT17qnmuHPlnW
         67RKNEpHsF20aInDO4bE4Nd9cBfjXgKZbKS5SSut2eNoqw0Sq6hIWoQlL8sZCqgIGNPb
         kFwWKMtDg1P7AoiO3TWBsPcon/1PrNDFir6sU45ScEMX+EHJeBldcmIvWKF8ol7vq3NS
         DAT2yFQyVLmMzbtWMJfocizVeQTUVAJyrDL8DdhYM4TaKJgSmCjOEFKoCjNTWqSESGWw
         qrEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790638982; x=1791243782;
        h=content-type:cc:to:subject:message-id:date:from:mime-version
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=55HPJl5SBbsItKpLLMuAZDA3mfNkU/nrSg5Ddo58dAY=;
        b=ybja0IfKEnyMs9dGpTQkt5fReFkl44vDR59jXI78WS1OJ1cSwcEcW2zZ/YwpctSr+P
         KZSfH0U3YoHcXfrOhgUdNf+wk73AL0U2BiRMQWqw+eXwYR8kCzUY+IcPGqLm+VD91QQY
         8BTcfVMdQGxptDMT638JG5qFLU+2b9aSgedT0ER20xNvGFqHGvnoaZY8i89JR0L9xl8N
         g/YnnuWJmhQ9yQdA7ynIFZyWKz6hTgjCi0AuvsyUR4TLp7COd1U6ef97fL1eDgIGny93
         hRyTvV2nv+xQT5topN8M8FOq3L6DYCJPlKTCzsQxC6/Zop+wtlrL0VrKirupsdScAFmg
         kYrA==
X-Forwarded-Encrypted: i=1; AKwUvByGE9VZvnZlIawWjuNjV6abB7UpDqzI44ARssy4gzWqSyyt62q/t4n37EFjFY+NYGakgS6KNidYQTQ=@vger.kernel.org
X-Gm-Message-State: AFq9FYIjWDxT8xTtvWntwmd0JQHT55rnHTS+mgERD1nYiwoAsmMH2Gob
	2AJUYQiylW0Fs+oTBMSQjVNrTPjixVTmdYZuB4CNnlAmZxlGLeEcVTAoaRWEnfOyVbMaISmniiw
	72HOtO1PNVSmKnsabfI5h0rp0aWt4jq8=
X-Gm-Gg: AYBFou0zD3dJR3BsJN75ng2UVeR4CU/5jiJNUM1fdF+aAlqWca9dM8Gb/VfLu/yy564
	mWawrkJBBRRJRDN07oRNovlY+mgYDNikUxNDYpbWm+LOcx3TBIJLuwW2MzrykQuyAv5bClmol1a
	eel341VJvJjWv9kL2MLZigGA66OMWmWts4JXN6aEfeOn1xkkCOjqggUuknZEDVtoGjVLYv5pPMF
	4fTA2PxKqdf8xRHeRTuNrzvprnTxSPECG022E42Wl7GhnmQopljkNETk8h9fP/ND7qpuycQxeXL
	kZnso6FO6NmT/EuXn8fM3JzgPu0OwIdnKEkTl4fUDO+XMnmqJj8f49Nm6yjjFZHkOIvjyL2mE5n
	seIiURaM5JVKzJ6faqbbgrEaGbZ9TyWFOGl7sKqozXF8mQtjbi69ljJkN4zRJt09hpFDk0Ww=
X-Received: by 2002:a2e:be1e:0:b0:3a3:61ec:43c0 with SMTP id
 38308e7fff4ca-3a76478c099mr1912061fa.17.1790638981384; Mon, 28 Sep 2026
 16:43:01 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: omer zalman <omerzalman42@gmail.com>
Date: Mon, 28 Sep 2026 19:42:49 -0400
X-Gm-Features: AclHuK-LcPc0U-LZeaKAexhC5sKfPBVUMEBBoK5mBcQvRj8Elz1BvEaJ3mu56SM
Message-ID: <CAGLNFZeWAftbDfXj3Rmb_nu206+_vSzzGoEDoQGw2=h5uc8oNA@mail.gmail.com>
Subject: [PATCH] check-uapi: preserve failure status for 256 broken headers
To: akpm@linux-foundation.org
Cc: arnd@arndb.de, quic_johmoo@quicinc.com, linux-api@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: multipart/mixed; boundary="000000000000681e61065c93a001"

--000000000000681e61065c93a001
Content-Type: text/plain; charset="UTF-8"

check_uapi_files() returns the count of failed headers. Shell exit
statuses are limited to eight bits, so 256 failures become status
zero. The caller then exits successfully despite reporting an ABI
break. Return the documented FAIL_ABI status whenever at least one
header fails, and SUCCESS otherwise.

Signed-off-by: Omer Zalman <omerzalman42@gmail.com>

The exact git-format-patch file is attached because Gmail's web
composer removes tabs from inline diffs.

--000000000000681e61065c93a001
Content-Type: application/octet-stream; 
	name="01-check-uapi-failure-status.patch"
Content-Disposition: attachment; 
	filename="01-check-uapi-failure-status.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_mulw6ufo0>
X-Attachment-Id: f_mulw6ufo0

RnJvbSA4NTcwMTQyYzY4MTIzNTlhZGJlZDQzMWY1OTBkMGQzN2Y2NWVjNzkxIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBPbWVyIFphbG1hbiA8b21lcnphbG1hbjQyQGdtYWlsLmNvbT4K
RGF0ZTogU3VuLCAyNyBTZXAgMjAyNiAwODo0MToxMCAtMDQwMApTdWJqZWN0OiBbUEFUQ0hdIGNo
ZWNrLXVhcGk6IHByZXNlcnZlIGZhaWx1cmUgc3RhdHVzIGZvciAyNTYgYnJva2VuIGhlYWRlcnMK
VG86IEFuZHJldyBNb3J0b24gPGFrcG1AbGludXgtZm91bmRhdGlvbi5vcmc+CkNjOiBBcm5kIEJl
cmdtYW5uIDxhcm5kQGFybmRiLmRlPiwgSm9obiBNb29uIDxxdWljX2pvaG1vb0BxdWljaW5jLmNv
bT4sIGxpbnV4LWFwaUB2Z2VyLmtlcm5lbC5vcmcsIGxpbnV4LWtlcm5lbEB2Z2VyLmtlcm5lbC5v
cmcKCkZyb206IE9tZXIgWmFsbWFuIDxvbWVyemFsbWFuNDJAZ21haWwuY29tPgoKY2hlY2tfdWFw
aV9maWxlcygpIHJldHVybnMgdGhlIGNvdW50IG9mIGZhaWxlZCBoZWFkZXJzLiBTaGVsbCBleGl0
CnN0YXR1c2VzIGFyZSBsaW1pdGVkIHRvIGVpZ2h0IGJpdHMsIHNvIDI1NiBmYWlsdXJlcyBiZWNv
bWUgc3RhdHVzCnplcm8uIFRoZSBjYWxsZXIgdGhlbiBleGl0cyBzdWNjZXNzZnVsbHkgZGVzcGl0
ZSByZXBvcnRpbmcgYW4gQUJJCmJyZWFrLiBSZXR1cm4gdGhlIGRvY3VtZW50ZWQgRkFJTF9BQkkg
c3RhdHVzIHdoZW5ldmVyIGF0IGxlYXN0IG9uZQpoZWFkZXIgZmFpbHMsIGFuZCBTVUNDRVNTIG90
aGVyd2lzZS4KClNpZ25lZC1vZmYtYnk6IE9tZXIgWmFsbWFuIDxvbWVyemFsbWFuNDJAZ21haWwu
Y29tPgotLS0KIHNjcmlwdHMvY2hlY2stdWFwaS5zaCB8IDUgKysrKy0KIDEgZmlsZSBjaGFuZ2Vk
LCA0IGluc2VydGlvbnMoKyksIDEgZGVsZXRpb24oLSkKCmRpZmYgLS1naXQgYS9zY3JpcHRzL2No
ZWNrLXVhcGkuc2ggYi9zY3JpcHRzL2NoZWNrLXVhcGkuc2gKaW5kZXggYzhiZWVjNS4uZTM0OWQx
ZiAxMDA2NDQKLS0tIGEvc2NyaXB0cy9jaGVjay11YXBpLnNoCisrKyBiL3NjcmlwdHMvY2hlY2st
dWFwaS5zaApAQCAtMjk1LDcgKzI5NSwxMCBAQCBjaGVja191YXBpX2ZpbGVzKCkgewogCQkJIiR0
b3RhbCIgIiRBUkNIIgogCWZpCiAKLQlyZXR1cm4gIiRmYWlsZWQiCisJaWYgWyAiJGZhaWxlZCIg
LWd0IDAgXTsgdGhlbgorCQlyZXR1cm4gIiRGQUlMX0FCSSIKKwlmaQorCXJldHVybiAiJFNVQ0NF
U1MiCiB9CiAKICMgQ2hlY2sgYW4gaW5kaXZpZHVhbCBmaWxlIGZvciBVQVBJIGNvbXBhdGliaWxp
dHkK
--000000000000681e61065c93a001--
