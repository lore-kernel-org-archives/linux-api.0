Received: from mail-yx1-f48.google.com (mail-yx1-f48.google.com [74.125.224.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EED0A2E7F20
	for <linux-api@vger.kernel.org>; Thu,  3 Sep 2026 03:22:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.224.48
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788405735; cv=pass; b=VTWwaUP25PhiIk8QcHAbQQunZMMJs/BYNZtEeodBGDykj3t49GeGuv8UQq7bAejlaozjE7SXCEGISIZyDVjZq8naPUp2dlhK0edUMrbHTdHa5tIrQs9vg1Q0nyu+vdbQ4rRh9afT6KevfLDuqFjPLvzuS9BBsdPIS4fb2ugDlgg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788405735; c=relaxed/simple;
	bh=suJWQL+4aQWtCBj/2AioU49V80rgqEFSK40x19fP1kk=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Content-Type; b=bX+lChP47l95Pcio4/SgV6yUqqLUDNl9XBro7+Mi+sT3Qd4g9shukfSoZHdSBIKH5FtiN3YHGxFb+ewXEllXppny2sXMw7yC4dF1xGJzy5AV81SbaqPgDrnf5trw1a6YEiPAKq7Dg+EoL1hczm08GmXp0/PSNZLBmA9wH1Pgc48=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=eVsKkY40; arc=pass smtp.client-ip=74.125.224.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="eVsKkY40"
Received: by mail-yx1-f48.google.com with SMTP id 956f58d0204a3-66f79f58123so1896293d50.1
        for <linux-api@vger.kernel.org>; Wed, 02 Sep 2026 20:22:12 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1788405732; cv=none;
        d=google.com; s=arc-20260327;
        b=PQMsFr44JZbqk0T08zJsOqemUU8QZOHMzY+fEZQ8mrShpLhmiYtlwRLxOfnXn5cSeA
         RrivLxiXFLYGKcXVOMO24lAbLDVPtFX7dHYoSjD4Q9X4ssZc6FhQ/lA9D7yL3ebyZ0an
         /wnoizlCA+bqD8/TDzDOEGmRCxCIzmTtGta0sZZxzXaWjfgfsZId3VGkBxjRHwb4LOUr
         SRK7aZV5m6YT1jTbcnFv52Z2IUK4laDQnxJFCVfIAhhyE99aJUqv7IJ6LKMCTEFhijuw
         PFyKtyBcV3TJvP1KIVbj//pWVzDCL8gKxMN1F6h+nHFpJz6mZk9YUB95NeUoymQI6/gC
         6ndA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=to:subject:message-id:date:from:mime-version:dkim-signature;
        bh=Npd2AbytSYM+hVHNalDI3iPyHboLv3bogOZFkb2tqn4=;
        fh=TgWddrRTcopYUqAT7MVF4+uJw/rH4NTUOa+X6CAi3BE=;
        b=ot2sVD/v0c61tFMLx1IjFy7lPy845UlzX5+94YZOP3MvXCZ2Z6ageqmAjHevYmHoS0
         64urbdWLZfLQ4VeuXjZQqE//shIiXG0lhPh9p3SHjTjxm0owMgzItJQ8S0D+hTtpkD0x
         ECzuMpZjtLE+T6IdqJPkFIUgMH95NjyrrbjKz+M1sTeIUVUWPmHqLfYVs4M33mKHU5YA
         FSgum/+jLO6mqM6OBWuDtJfCJhmSvIBLuFVD8GZ/B9/5anv+JfGBp3EZbOg0HtvNLVN5
         t3gdwRpNMWVeWaREiJMDkSbwaniOFVXiN0WeGNAMGbhx5jm7J9zDGtSk4x/xXWaBYnhU
         SwCQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788405732; x=1789010532; darn=vger.kernel.org;
        h=content-type:to:subject:message-id:date:from:mime-version:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=Npd2AbytSYM+hVHNalDI3iPyHboLv3bogOZFkb2tqn4=;
        b=eVsKkY404zWz+zLA+VXfC6sIP3m3HzY+crpNYbDXbwyPU01NERHOzuJ2svIPthFPq+
         +FoQkj1lbJSfd/iYc7da0b/efrUtz/klR6lP9fNd2LwMKErgiHGu7D89o+A2ZMfizEf+
         2AV55WwRFeH3eNGBX+3mELrkBM5XvEREGnbQc+KxELbM51A9qgZdjE+3dFboc3hWeNSw
         E4h0Nb3DI2GEuR1JuEi9iu6vbUSLgbxb3VowZEdBbj/mVcEMC67vg9PrcDy49a6CcFLa
         nsl0qcpejBjYNc5KMyPi0iOZV7tENymbl8L/DLH86zye+kQiZKx/eB1YDTdCmCKU4sI5
         lbDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788405732; x=1789010532;
        h=content-type:to:subject:message-id:date:from:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Npd2AbytSYM+hVHNalDI3iPyHboLv3bogOZFkb2tqn4=;
        b=XFjqGHpCvPiZfPZev5sStYMNvDNAGSQyw70U6JlgzzahZW1oSPgSqBrXKdAZX83SCQ
         pAWPZiaQnwRGFmASt034g70lJ2x5RQn24lMHaUaX5+5hIVxSuARrpmhSAPdPFT4HU9fH
         Ac+CdByGZlCo8HGsr8w9P09YPRhrEg5vm+cBEd6b6sUtDhnzbavPEVD3LqiqAec296lk
         BvdiuNosjcMkRSYYzgxiW7udmkiQqxW+/MTJ6hjcXgYwyPi8By3ae7/OQiZgk+wl79Aw
         4+NFRljcOICTnD01ttPcfK2CiG2uC4m/smmbrb99IIAnUkCywGbB2EZ9X2uYht1wS7ih
         oZ5Q==
X-Gm-Message-State: AFuF++kw7jBDIi0ZpBbmdUEljYCD1o/UhZbsdP1Xmy3Vfz1+D7EF34EC
	ZA4HBZZCjLVWFNYbAwnTlw/LsF9mYrrqxX3Sx2EDrkUIyq0ZyGrlcy3HNCpeyvCWrwmBaCgcbyE
	6ZRkpJ9dUqE2qNiGqvgAYnSxx+dBUgi85zbfPa58=
X-Gm-Gg: AYBFou3fywBrz97l+mKdfvb3MOe7IZeexvLv//midk98QL4JHK5DnuSBwTY9sivi5yY
	RqGMMLPWBY3neVmHHTZzJMzN1FCpmaKLJIxp6xS9Z6aSRfXriLZFvP12ctJfRReZXtXq/8EoWLA
	0+JIOVQQsqOWJ1E/vEI0UFLQIUPnGCWIVpuP8LGeMF+yKylAlfjEXhy0rIRbG9Qx9tkuqI5uSG6
	DoYPhMdUX19SiZw6ZQZWl4aZKTEVjgPLIvfkoOB3Dq+Gp9qJZf0lcKqu/vMxLFuYgZFksB0FQa4
	yV7aDUmVOHikLnl7m9VTBGLDhmy7mu3zj0t3vR3t+Sg=
X-Received: by 2002:a05:690e:1511:b0:668:db:8c35 with SMTP id
 956f58d0204a3-66f9ba3ae26mr3695399d50.20.1788405731637; Wed, 02 Sep 2026
 20:22:11 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Bing Hongtao <695097494plus@gmail.com>
Date: Thu, 3 Sep 2026 11:22:00 +0800
X-Gm-Features: AcwNN1UITLvgZjNWOaiY49lvPNF2ndk6E0-WvHQ32hdO3nTYS_pvbQSrLNxGsxo
Message-ID: <CAFJkf0UYnamaKtw=3g1SpO_8Py7LLpTQ_Gixyts1vQtGo9ny3Q@mail.gmail.com>
Subject: Subject: reasonable rlimit ranges for container processes
To: linux-api@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Hello,

Apologies if this is not the right place to ask. I could not find a
more specific venue for questions about rlimit usage in containers, so
pointers to a better list would be welcome.

I work on Kubernetes and am looking into sensible rlimit ranges for
container processes.

The ranges currently under consideration are:

  RLIMIT_NOFILE:  RLIM_INFINITY, or 256 .. 65536
  RLIMIT_MEMLOCK: RLIM_INFINITY, or 8192 .. 16 GiB
  RLIMIT_CORE:    RLIM_INFINITY, or 0 .. 16 GiB
  RLIMIT_NICE:    RLIM_INFINITY, or 0 .. 40
  RLIMIT_RTPRIO:  RLIM_INFINITY, or 0 .. 99
  RLIMIT_STACK:   RLIM_INFINITY, or 256 KiB .. 16 GiB

These ranges would apply to both the soft and hard limits, with the
soft limit required to be no greater than the hard limit.

The intention is to reject values that are likely to prevent a
container from starting, or that do not appear to have a useful
meaning in practice.

I would greatly appreciate help checking whether these ranges are
reasonable. This is not an area in which I have much experience.
Although I have done some local testing, I am still not confident that
these ranges are safe and useful across a broad range of Linux systems
and workloads.

Any corrections, suggestions, or references to earlier discussions
would be greatly appreciated.

Thanks,
Bing Hongtao
