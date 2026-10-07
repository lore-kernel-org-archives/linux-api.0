Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C0023E51F9
	for <linux-api@vger.kernel.org>; Wed,  7 Oct 2026 20:41:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791405686; cv=none; b=PznXZqH5vkawW0o01DDaEwyWoCv2EIU0tcTfFchsvPOHxZmeoKFciVBcc3jjZtyVxMj1w9CWlLgJSqe73LzhvAE1KqSaAq7R3+RrX/qV/8ATpd3J6QDfZFdyehdciwZMwzQjOB1+Xg/N9Zge0NiDicdTLVbZHjdCgHFr/sTkPuw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791405686; c=relaxed/simple;
	bh=PvtfH/k8z1BDjmBe0wFt7OCs+OdclqZtP44M/KA9cWk=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=c27+N2weM/vLZWGKgPPzSBRju+kqIlDrRxudCu40LH3OhYdwjStpprTYrdHTm22/jHlWdYLBV2l1kkgYXgP1v1DJm5ByJEhdLN9OuN6/vpt0uFGc4vWdOiRA+Kc662MOgGRiIw9vmRGO0w8W3HUk6+vaP7unWw43s6xF2SZH6nc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Pva2+NEx; arc=none smtp.client-ip=209.85.128.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Pva2+NEx"
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-4a16af2a232so19329605e9.1
        for <linux-api@vger.kernel.org>; Wed, 07 Oct 2026 13:41:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791405683; x=1792010483; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=73BVDVpDiA70xXPSPckSoCpnSylvrTOc8nuDs4dKWHg=;
        b=Pva2+NExCW+jsdAElXT7f1Z3+F9TUX40dIe/xvvL/8tZgDUKq5qyMiqslufuKp2uYm
         kBbgSD/JAKmMPYvBAgcYWaKYwrwOMlQC0NbSty3kZxibBeklP70hsJ9GeX2d1tflFKFP
         wJqHu57o6XQ/FiZL6hbI4ZzaUyFZchWKSc/74L1naK+uVy8fL88reN27MMr4z2eFJtAA
         2oEDoQHZS/4UK6GFq7RjDRtsjCWK2OlpXoi+njzSEZFsGK8J9Ofmvjzjm+G0oOH3+58H
         TwT+x1ky6gTVNWh+hq8l5QyUAKjOLhTV6FtzphG7LJ/81orlIn132KUgpAtEXUaelzxs
         ENLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791405683; x=1792010483;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=73BVDVpDiA70xXPSPckSoCpnSylvrTOc8nuDs4dKWHg=;
        b=LUpp24j2Pzjxe1N/zHEyftZjcBImXBFlFhi0MBarNYE1oOBJaGfSQCk0tyb1WqD5l0
         9rPvDYGkn1fNDidkDVPnZYcuyunoBgB7+swG6Er46n2OOtExpe6nJoXTOXz6fE9pJTCd
         SAcM6LiTHBr3CjHvwRABihxZ3ex4Vs2yIsjfp9oQdj2Ixu7vcnvKqbxOi93fBP9Dswuy
         wH5NIxaoKeshPd12skZ9PEc+FheuDe13LMghvbtL3uUoClTh2pNkie+I/aLq1Ez/ZDA7
         vIYLCqr6zEB5uP9DgSWE4csyHKFAdIXi1h5hClYT2eYgikMquPW6bRKWpKZ7yytkWsQX
         WIgw==
X-Forwarded-Encrypted: i=1; AKwUvBz/yneNTqVU8pzUQzsUkKcSA/ZOUculdMKp24sarJ7PUlCirrLJUkEjLoq9mLg1QizJElqrKo+sQXA=@vger.kernel.org
X-Gm-Message-State: AFuF++m2UG7ZQM4AE+PzeVAWQqKqY2GhOIygLMGFMFSzRQwHLwPRB529
	Txrs1HV8N1f7SyVIJxXfnHotMkmRdOpntTEuSUj0VlS5b8nCPqP6C18k
X-Gm-Gg: AYBFou1A8zHC2mbmjfYljtTfzVb1aquV9Bzf+AUvlkL7cjUbe2VrTo5lcOoB1Hbmezu
	IxF0cOhMvS+dmKomQk6zjUgW3/7HFmVWNlTKdPqCyTiW/c/fLN2lo2eMrEZ6DUt2FxPiJPDpNxs
	wuavOqzgDIIqQ1v2Lg1HZtsw1i4Klu3awI0LZpvsp5YKyo/RRnKWl98ojQJ1XLWfX9pHlSAuh6d
	TfearYkCkegJUzL6JJqdkeizdBxcLHuXP9Gb6yOT2/gOzwgrpNTYzUGLHxDO1BAEYiktAEeAOuK
	1fSeee4Seu1LIhWCbcpumgi7Y3v9LnDSpvMs8StyUwF2AZpZJWaB5SLXuGVjm7zVtPHenHx42L8
	zyH1bqPScRYWG2GCJ2J2a46Dz+x/U2YnOoiZMwnJb/D9X6zCbDmOacYNp9DjAXwu4dmQcLDENrh
	h6c1SI4u8WVGQlm9D//ay0DeAsWi/2CRot8WQM3EvKmC5eIIElN8tlhQ7voFGlLxcZXC+i6VBqV
	pFMXw1V8Q==
X-Received: by 2002:a05:600c:3f08:b0:4a1:7703:e537 with SMTP id 5b1f17b1804b1-4a180313b66mr53230165e9.10.1791405683281;
        Wed, 07 Oct 2026 13:41:23 -0700 (PDT)
Received: from foxbook (bez186.neoplus.adsl.tpnet.pl. [83.28.37.186])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a18044c970sm50776585e9.4.2026.10.07.13.41.22
        (version=TLS1_2 cipher=AES128-SHA bits=128/128);
        Wed, 07 Oct 2026 13:41:22 -0700 (PDT)
Date: Wed, 7 Oct 2026 22:41:15 +0200
From: Michal Pecio <michal.pecio@gmail.com>
To: Giuseppe Piscitelli <ooonea@gmail.com>
Cc: linux-usb@vger.kernel.org, stern@rowland.harvard.edu,
 gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
 linux-api@vger.kernel.org
Subject: Re: [RFC PATCH v2] USB: core: emit a device-level modalias
Message-ID: <20261007224115.755ce40d.michal.pecio@gmail.com>
In-Reply-To: <20261007191130.8652-1-ooonea@gmail.com>
References: <afcecb34-0024-460f-bc21-a7f2b1754d23@rowland.harvard.edu>
	<20261007191130.8652-1-ooonea@gmail.com>
Precedence: bulk
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed,  7 Oct 2026 21:11:30 +0200, Giuseppe Piscitelli wrote:
> On the first insertion of an iPhone (05ac:12a8) after boot, an already
> running usbmuxd can select USB configuration 4 before the charging driver
> apple-mfi-fastcharge loads. usbmuxd is a userspace daemon that uses libusb
> to communicate with Apple devices; apple-mfi-fastcharge is a USB device
> driver that enables their higher charging current.
> 
> USB device uevents have no MODALIAS. The charging module instead loads
> from an interface uevent. Its registration reprobes the device, unbinds
> the generic driver and calls usb_set_configuration(udev, -1), tearing down
> the interfaces and interrupting usbmuxd's transfers.

What is actually the appeal of apple-mfi-fastcharge?

It seems to just issues some control requests to the device when
commanded by userspace. Userspace could do the same with libusb,
apparently without unbinding drivers, changing configurations or
even claiming USB interfaces. I just tried a simple program that
queries GET_CONFIGURATION, with no disruption to kernel drivers
or other libusb applications using the same device concurrently.

Then simply blacklist the kernel module and all its problems are
gone forever without one line of kernel code?

Regards,
Michal
