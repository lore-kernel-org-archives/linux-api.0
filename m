Received: from mail-oo2-f43.google.com (mail-oo2-f43.google.com [74.125.231.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D489380FE3
	for <linux-api@vger.kernel.org>; Thu, 10 Sep 2026 03:21:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.231.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789010490; cv=none; b=WklhoopoXGxiQVvHzXKgQOuwwev83z9WbQRa67lgq3pppAXFhRQAqC0/ptO8u59AUk8lwKbFlZpA2s1fHsC+YOndzLxSRNakwK4upMgotyW9TQDxAwLfsH2D5aKu/+jh1Xz3TGY2mnpXU9A8MKaoloLVMAOETOaaycg6P6rYkzY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789010490; c=relaxed/simple;
	bh=lPfNCdnA3E47WTLqvLWds2HgGbfhEaYVDa6MQrL3JO4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=AaaJ8aWgwpUt8FRGzeIMH5JZmfvQu4cYUAH5BEfcEPkJGsvanYlBag+61wTAbtUrUQVGgVgD3fn4Cpd2gws2nQQEfx7Va4Z0/cTBU6ZtmESW4qDYw2cdiSsvw2MCVDDCPN3g9PtugwIUaMqN8hA0sUwNxaPqeh0O67XEAQ8/Kb4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=qZu+cLBY; arc=none smtp.client-ip=74.125.231.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="qZu+cLBY"
Received: by mail-oo2-f43.google.com with SMTP id 46e09a7af769-7f4bdf26360so404276a34.0
        for <linux-api@vger.kernel.org>; Wed, 09 Sep 2026 20:21:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789010488; x=1789615288; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=SxC6tEs21vq+fRsHgV3a7gSsUUPCtrgE8Z/3GlleZx0=;
        b=qZu+cLBYPIq/DhTBjmMewbaVjnDs58l5J96Y97gU62uGg9GYhgGvErpxnMSn99EwhO
         +VkAdV6W5/sFAWJQyjQILJpz7+TQNUH4r8R8q5/Ke4evic3n/AP/de0nLuE66Sxvni39
         aEUU5IjVrNSiF8L6CmedhwnxTS9hIXBH0fx8Gz9is8tGXl728UTfRL5GzllD6dSMIIOa
         GH5hAlHbVgtRipnN4OgsXZ+cDlzUQbDvUn7KpRSOGU7yaIcwrsAp6VRq5I8UbYXdKGuN
         1TYzFmn8ktgZCOX0gGGYvxy37p7r0dtGabEHEUGlr+CTh611+qyPzDdd97z+nZeH3NQV
         7JTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789010488; x=1789615288;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=SxC6tEs21vq+fRsHgV3a7gSsUUPCtrgE8Z/3GlleZx0=;
        b=GclxaNJvlfmscC81ngvP+iNx6LewFWrG81xU1v15OfCivkOfs8xrPIUsBDbmBnJBa2
         G72LBWdWyrf9nOXLM8Ee2eHtlQnTufJSQfzfD6A+3cRHsrIUMWn3twV2wat7rko5DmUg
         ODYJsfeHCbBlO3tz6IvRWFqihGnv3tEGjZqK+I+Bn0OwBKjSRwugts/hL5K7PdIOjwaC
         DOSdRQUiTjEIzO9n04sWGrMA8Az4u0/uEKqENG+ccB/NYr9PIyWLNwF3PK78NTjCKHjq
         fb8HELsC8ExHchq4RF82T9uj49RJL+1ZIDqk3Zr7gySZgCY2PNSFbstDakr8CK6hlBaI
         LZOQ==
X-Forwarded-Encrypted: i=1; AKwUvByk/fpcbW7oxQcq7Pc+J7HNGVFdl1esR6oXnHCfhfzyRrSHy5BJpJg4CGL9LG5OdlWc3jCXOltgnew=@vger.kernel.org
X-Gm-Message-State: AFuF++mjQT4F9rR5BZXPnEEoRnfeZARnNHDj5ipLrUNAlmVYUKPAaA9R
	9i7VGP/XUsuy51Q6QVh1MRbbsX0ms7HBxINtxU/0d6WFPy3QK38FMZpU
X-Gm-Gg: AYBFou0iBthGzj3pojiYInHESVlQXWLgx4FhIceig7adm43krffw6xj7hOnC7PxPvrc
	IWVUyUnFsHqCDOdzfgDYgx/Mo+niQDT4J+z86RwoZgz8snW86sbKjM/PN0cD9ZYl+5U8gEXSdE5
	ZgIFxOS05cXFTk5mu2PeqXV4ueVaBaHyNdfRyIDhPJisHYU9ghnT0bk+h+Vo5SOgt2vdZDIp/Lj
	VlmM8TsM5xjBHp4ydzvqoExf1u2ygr6sx+3GuRme9KEEpvSUwL26C8sHKpSsBX+sR7H7I4+Hr1c
	nxDB/Wvyc521xC52zyAWfbLQWjzQdiB9Kn0okmv7JrIm8re49kqxFYsv6dZMfX6kVsscYSzqC19
	ePOnnuhOi7MzVVl+UftlrTV4AOcYRUfMeWwHeKlkAPJL/lNl0hSk1hBCOHKzxWdNOI9/hdgR1rZ
	vsK9ks2SmbLjS24Fit6uNAjHvvor9+jFS/Q6kQFJeRe18btu83d5mASiLrLmdxYzmTemoJV6UyG
	4LBjofkc+I3N28EJjg+rlmhrQGYzpQwnwzgJSGOkHwgUFz+QmXvdls=
X-Received: by 2002:a05:6830:6a95:b0:7f4:e521:7c50 with SMTP id 46e09a7af769-8026e310126mr2306948a34.0.1789010488028;
        Wed, 09 Sep 2026 20:21:28 -0700 (PDT)
Received: from localhost ([76.187.192.44])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7f9f6da9a49sm19758315a34.13.2026.09.09.20.21.27
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 09 Sep 2026 20:21:27 -0700 (PDT)
From: Andrei Aldea <andrei1998@gmail.com>
To: Jiri Kosina <jikos@kernel.org>,
	Benjamin Tissoires <bentiss@kernel.org>,
	"Derek J. Clark" <derekjohn.clark@gmail.com>
Cc: linux-input@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Lee Jones <lee@kernel.org>,
	Pavel Machek <pavel@kernel.org>,
	linux-leds@vger.kernel.org,
	linux-api@vger.kernel.org
Subject: [PATCH 00/15] HID: hid-oxp: fix and extend X2-family controller support
Date: Wed,  9 Sep 2026 22:21:00 -0500
Message-ID: <20260910032115.28669-1-andrei1998@gmail.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This 15-patch series fixes existing hid-oxp configuration and RGB issues
and adds controller and lighting support for ONEXPLAYER X2-family devices,
including the ONEXPLAYER 3 and X2 Mini Pro.

The fixes correct the M1/M2 defaults, validate input reports and RGB state,
correct brightness and color scaling, serialize RGB updates, and make
configuration state and delayed-work lifetime local to each HID interface.
They also handle controller reinitialization across system suspend.

The X2 support selects configuration interface 2, supplies the required
three-page button map, and adds the Gen3 protocol for joystick-ring zones
1, 2 and 7. The Guide button and rear logo receive independent multicolor
LED devices using zones 5 and 6, with monocolor and breathing effects.
The final patch documents the controller and lighting sysfs ABI.

Patches 1-10 contain behavioral fixes. Patch 11 groups existing declarations.
Patch 12 adds X2 button maps and interface selection; patch 13 provides the
shared LED representation; patches 14-15 add X2 lighting support.

This series is based on mainline commit
50d05c7c76c96b90462f24debacca971d2e86713.

Testing:

I tested this series on an ONEXPLAYER 3 running Bazzite 44 with kernel
7.2.0-ogc6.1.fc44.x86_64. Testing covered front controls, rear paddles,
Steam and Quick Access behavior, independent RGB effects, brightness/off
controls, and suspend/resume restoration. I also built the module with
W=1. X2 Mini Pro hardware testing remains outstanding.

All 15 patches apply cleanly to the stated base and pass git diff --check
and checkpatch.pl with zero errors and zero warnings.

Development and review:
https://github.com/OpenGamingCollective/linux-unstable/pull/13

I used LLM assistance for protocol analysis, implementation,
documentation, code review, and test orchestration.

Andrei Aldea (15):
  HID: hid-oxp: fix default M1 and M2 key mappings
  HID: hid-oxp: validate input report lengths before decoding
  HID: hid-oxp: retain fractional brightness when reading RGB status
  HID: hid-oxp: reject invalid Gen2 RGB status values
  HID: hid-oxp: fix multicolor LED intensity scaling
  HID: hid-oxp: serialize complete RGB updates
  HID: hid-oxp: select brightness policy for the new RGB effect
  HID: hid-oxp: stop configuration work during teardown
  HID: hid-oxp: keep configuration state per HID interface
  HID: hid-oxp: handle controller reinitialization across suspend
  HID: hid-oxp: group declarations and protocol definitions
  HID: hid-oxp: support three-page button maps on X2 controllers
  HID: hid-oxp: represent RGB LEDs with a common array
  HID: hid-oxp: add Gen3 joystick ring RGB support
  HID: hid-oxp: add X2 auxiliary RGB zones

 .../ABI/testing/sysfs-driver-hid-oxp          |  196 ++
 MAINTAINERS                                   |    1 +
 drivers/hid/hid-oxp.c                         | 1743 ++++++++++++++---
 3 files changed, 1623 insertions(+), 317 deletions(-)
 create mode 100644 Documentation/ABI/testing/sysfs-driver-hid-oxp


base-commit: 50d05c7c76c96b90462f24debacca971d2e86713
