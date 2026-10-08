Received: from mail-pj1-f44.google.com (mail-pj1-f44.google.com [209.85.216.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AC1D27E1DC
	for <linux-api@vger.kernel.org>; Thu,  8 Oct 2026 13:03:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.216.44
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791464590; cv=pass; b=S0Qj+akDt/YNVOxqJuj3b9/MABswrnwG2HiZkO6c9vl4JdKxqmAZ5T0GIpyb1pmfYFz8lFH05G5dlkf9XFIsG1dG2gAGHdFju1kGnG+JJiT7U3quGLFC1qcMcyARryUo597Oh14ZUc4Kn9chEN0LdN7PwV1qHNquwSMRUAx62lI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791464590; c=relaxed/simple;
	bh=zbj+RaISY9qEBJ+o2V/HJBoiBS/Q0644xws79i/6cIE=;
	h=MIME-Version:In-Reply-To:References:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=COwgrD1Rl1nsddjhrX1kZClPEG9evJrv8MSKNe6bmdCPmbqkJc6o65j5CywIbIZXwznNVEm8U3d+nSp3gto6vy5eHCDjxcdL/voDJtD3z7seZ3AA5hP8iuvLRN2L6ZBghxinOBo7WkR0RM25Q4kNN2KO3kNWiGzfFbLlZrKcEXs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=lvt8c1g3; arc=pass smtp.client-ip=209.85.216.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lvt8c1g3"
Received: by mail-pj1-f44.google.com with SMTP id 98e67ed59e1d1-3a49623b865so3258389a91.0
        for <linux-api@vger.kernel.org>; Thu, 08 Oct 2026 06:03:08 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1791464588; cv=none;
        d=google.com; s=arc-20260327;
        b=kD5cS0/SHdg7Rfiin6EsixYqalRQrNoHv4DrWa+DvZawaJwiEdhWqaOUD4EOxDBM0v
         jQC0GDkWPrZddFj0QoWWT95Gf5Gmpe3eTIbVfxdEB41oZRpnjkX9QHP7y8T8tHPuh1IP
         hh/q5kmuI+iP9sj3o4IvMJFtIPbWUJrjaUKzMU73tve4fNHTpcoGyZcGzp8uTF8EjpqT
         fS0gAhCvN7GiZq34bD0VwvtIcN1EP2iAOemJhDJX3mAuSUqcIMKSblwo8TCdiwcNXb7L
         Bw05kbQxQSw2LZ56Lh0OEpDejRW7cmKjyf1ReNb3mv5QJrkCKxYnxSBR/MIJiMYjPCf4
         8TCg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:references:in-reply-to
         :mime-version:dkim-signature;
        bh=wbMv8ogoXgQX443s40s5hnK9BktjeqTsYVUhK1IFyzQ=;
        fh=bnwNr6uf1o5W9/w+SVGvw70b8ihT5Oww43XCY/29BqQ=;
        b=Ra75P6c1/4O4tqmo7b821tajB0UPzwjuLSLpbbPjoA6vsy9zPwJKzCj8e/WOZLLMQm
         o+nsf6J9qlkh2bDtjfbhrBfc8YCEj0da9xFb+1gNqI6O3/ktIpNXuwvC3/ritgRVKtXc
         IOc+LpOM4HOidV+/tyctqlwQ9QTEJKgvOv2ujOxjBR6phnXOvga8m9lYR9GUNwxccp99
         P4fGZljPn2e6E0aTFFJYV+4SVuJ+CB7XM/Hx8zNwaBzld7WHP7pINfp3NErbnJvALyD2
         fEsR/lJCHBZ8SjxudbBCFZHXvGDnbfJJZVi4RKIOBUWv9c5EHLshgpsxT/PYMPxJC5rJ
         1LWA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791464588; x=1792069388; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:references
         :in-reply-to:mime-version:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=wbMv8ogoXgQX443s40s5hnK9BktjeqTsYVUhK1IFyzQ=;
        b=lvt8c1g33pjWBnAE12BZVw34YLcsRAijClYbu9gZ6Ubr7lKXTFe6fCVPs3STPFew6y
         ADp/gBaYMZH09D6jWr+muxyuoCrhzVY67QUcOwrY9qNFQwGF3F3stoq0SaADWP3NfGM/
         xet9lYE7WJDHuXcOR1XSjleIZeplL1IWo3IHZRNCZ+Pj60jOJg93ulN1pD2KpL+F6K1G
         pIpbLp9BZdfV7ud0SHSOD10EN+CUuJyVExMMdAPJxCgLZWGxRy4hapGsl/SwVTViUE5J
         OZ3vAxADhoFDKYCnhnriBFDpBi+784eyybpC4OuUt8ywlo3uaLlZ42YYrny8Bg0bF9zr
         31tg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791464588; x=1792069388;
        h=content-type:cc:to:subject:message-id:date:from:references
         :in-reply-to:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=wbMv8ogoXgQX443s40s5hnK9BktjeqTsYVUhK1IFyzQ=;
        b=jqVNswqiBAlGEK4qSb/+TUb2avy/A2XpIPRDNRYBMf4j6jgekgnoXzqnu5VW1I1RxV
         OzPL2qzqnN/LP3ZC1ngdjPO8qHy1MX6Bxikyi3rHD/EwUWW5jSrDnvkLKPt6KOYQ0Axh
         4izHtVeeU2y1NaQ7QhnPKyORSH6zjC570s9bvFLgdujQLpqu7oluFoDRBnjZ0RkY9UGU
         Ye3AdwVTM6e11v/+wjRYZmhPM1w6G6sVPQCj/mwwFFNqCjrxnxbfLpgCbxN+TstqT3Dp
         QSxLRvKmqTq9v7qvZW4RdbDH/k8OiCpMElTW9nO44Br6yNeY79pJzLSuAlUA7AgPxM41
         Wc4w==
X-Forwarded-Encrypted: i=1; AKwUvBywj1LETpaAOrhAvEdzD2B40WIX5TcZ3SFgEVmkansOE45kb0x6Rk9oMIMfw6cqldIx4ThKnijQV3Y=@vger.kernel.org
X-Gm-Message-State: AFq9FYKhNAPC2bnYS+EJDgrHFGcebq8od0TVvLq2ps8lVkGSmGIKGuJz
	kC7hWXSOgyUys0Vg+7C6V8BYWMOM7WYDQqnBIh/n48+tuOLvu0foZYEzrbQeiUSsIS1rNYAhOoL
	C/pz7STCH7Y+iDQVOewT5Vu04r9jCLx4Li2G8
X-Gm-Gg: AYBFou0rg3HtoMJ3RUriLypa+i/jnh8Q0M/r3fMa7TQz14cH0mltxJNxDec6yFsDHn4
	+AiUEg/z3ZpN9cH0fomssJde7yDcqIulOdnrJ/IgUggtGaTAsr4tVOAPu4Uh7AjXzQa/UEj8IHM
	hxitjeZE3fsVuq21WqhydUu/jtx5kAQfVDVXrart4pyMmL7f59QujzUfodUnWd9MakKlOvwH76t
	Y55qiBHnLw3WSfMqUuu9M4uHFRafjDkGI3+td56QUhaIJSK/BeldQ2eqNU1FEfoJOl1McT8SLI0
	t5paOyPHe6rI6NI+O+7P9CD3fHjEuverspEVHhYRjPnQbHbtdUTVl4av4dDcAeP9
X-Received: by 2002:a17:90a:da87:b0:3a8:80f4:98a7 with SMTP id
 98e67ed59e1d1-3a8a1bd661fmr4380072a91.24.1791464587670; Thu, 08 Oct 2026
 06:03:07 -0700 (PDT)
Received: from 77377267392 named unknown by gmailapi.google.com with HTTPREST;
 Thu, 8 Oct 2026 08:03:06 -0500
Received: from 77377267392 named unknown by gmailapi.google.com with HTTPREST;
 Thu, 8 Oct 2026 08:03:06 -0500
Precedence: bulk
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20261007224115.755ce40d.michal.pecio@gmail.com>
References: <afcecb34-0024-460f-bc21-a7f2b1754d23@rowland.harvard.edu>
 <20261007191130.8652-1-ooonea@gmail.com> <20261007224115.755ce40d.michal.pecio@gmail.com>
From: Giuseppe Piscitelli <ooonea@gmail.com>
Date: Thu, 8 Oct 2026 08:03:06 -0500
X-Gm-Features: AclHuK8d94ZlAMXeaDvgj2EgcSP4fxLFqo6_9tmG2H2aomtW-IKcOXCsjiFQUrU
Message-ID: <CACmoRBboPM3jNnfnOv5FXAJt1avBGwH2W47Pcq7RaVL+oBFt4A@mail.gmail.com>
Subject: Re: [RFC PATCH v2] USB: core: emit a device-level modalias
To: Michal Pecio <michal.pecio@gmail.com>
Cc: linux-usb@vger.kernel.org, stern@rowland.harvard.edu, 
	gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org, 
	linux-api@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Thanks, I switched to that approach: blacklisted the charging driver,
dropped the device-modalias backport, and booted the stock nixpkgs kernel.

I tested an existing libusb utility that does not claim interfaces [1].
Its optional charging request succeeded, and iLoader continued working.
I have not measured the actual charging current. The command remains
manual, rather than running on device arrival.

[1] https://github.com/FD-/usb_charge/blob/e957bcfc47262f8a47d652d7d417723578560b23/usb_charge.c#L42

Assisted-by: OpenAI Codex


On Wed, 07 Oct 2026 22:41:15 +0200, Michal Pecio <michal.pecio@gmail.com> wrote:
> On Wed,  7 Oct 2026 21:11:30 +0200, Giuseppe Piscitelli wrote:
> > On the first insertion of an iPhone (05ac:12a8) after boot, an already
> > running usbmuxd can select USB configuration 4 before the charging driver
> > apple-mfi-fastcharge loads. usbmuxd is a userspace daemon that uses libusb
> > to communicate with Apple devices; apple-mfi-fastcharge is a USB device
> > driver that enables their higher charging current.
> >
> > USB device uevents have no MODALIAS. The charging module instead loads
> > from an interface uevent. Its registration reprobes the device, unbinds
> > the generic driver and calls usb_set_configuration(udev, -1), tearing down
> > the interfaces and interrupting usbmuxd's transfers.
>
> What is actually the appeal of apple-mfi-fastcharge?
>
> It seems to just issues some control requests to the device when
> commanded by userspace. Userspace could do the same with libusb,
> apparently without unbinding drivers, changing configurations or
> even claiming USB interfaces. I just tried a simple program that
> queries GET_CONFIGURATION, with no disruption to kernel drivers
> or other libusb applications using the same device concurrently.
>
> Then simply blacklist the kernel module and all its problems are
> gone forever without one line of kernel code?
>
> Regards,
> Michal
