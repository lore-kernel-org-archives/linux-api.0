Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B2354B8DD8
	for <linux-api@vger.kernel.org>; Thu, 23 Jul 2026 12:53:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784811239; cv=none; b=KbnfDX7Z8FTXCkddSwbuqL/F57j0zRMqxpBzgL1YR52m8bLyZMXBOu4kWrZ92efRKr9KWkPZkM3hg/1REyZnEzgH5lJESZFEPbutxYAXmvIhdfCQzDD9ywNxF1PL1ovuTyIlyNRDYXYsAMZm3keQy8g2SnG2hOO/qBcsIfkC/7M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784811239; c=relaxed/simple;
	bh=hZB8/53s4mO4kIFJXxMOcWTQ6DBSxoSBcbhXg6lHpPU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=agbr8gIPjPXGwlkL4u7EmIk1nF7PDgykviJqVDH0vF3SXoi5co8Ebdjiz+dOCOSHk+/CmzDw5j9gkNqzs94BwHEpc6Bfz/Mx3hJG+kwJoAqXcMXgpUXrd+LQG20QOexG0Ztf4klV4ED8RBq2p9hpZRW1fUJMogFMA+YOU9cmF40=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DAA841F000E9
	for <linux-api@vger.kernel.org>; Thu, 23 Jul 2026 12:53:55 +0000 (UTC)
Received: by mail-lf1-f52.google.com with SMTP id 2adb3069b0e04-5b28c91fba5so505823e87.1
        for <linux-api@vger.kernel.org>; Thu, 23 Jul 2026 05:53:55 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+RrpopRJjksgfU2xRiEpY78/zmBXQy1Mf2wkaKexHJYwgJAfvUSM1TRrrtbZWnedFHVjRg7VhYw7LEY=@vger.kernel.org
X-Gm-Message-State: AOJu0YwmGW48kaKTiioYtZmhPKCm4mBbePWMN9i9WzTB2AWYdi+M5I0K
	myvxl/YHkKPFWNbAJD9zDEbFm1yo0fBC/W+5HMCqfG5it6hTBnw4RxIQfxBuuJBxrQvqdSY60pR
	dSFO0F6CfngvkR/q7/eqtn82apW5KH4phrpE7h6iB
X-Received: by 2002:a05:6512:1323:b0:5ae:a4a4:b6ca with SMTP id
 2adb3069b0e04-5b2b3332127mr450440e87.14.1784811234312; Thu, 23 Jul 2026
 05:53:54 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260723-work-failfs-v1-0-3f69b9a9e958@kernel.org>
In-Reply-To: <20260723-work-failfs-v1-0-3f69b9a9e958@kernel.org>
From: Andy Lutomirski <luto@kernel.org>
Date: Thu, 23 Jul 2026 05:53:42 -0700
X-Gmail-Original-Message-ID: <CALCETrXSDhrDzdGsknz0EpZkowm3OAPihyEU5Xf_Mb2CTr0SmQ@mail.gmail.com>
X-Gm-Features: AUfX_mzGKgWr2cRO8ep-8-hB43raCc8FcPMOawRl5wUYGrxfGA1kDuSSAZzVQBw
Message-ID: <CALCETrXSDhrDzdGsknz0EpZkowm3OAPihyEU5Xf_Mb2CTr0SmQ@mail.gmail.com>
Subject: Re: [PATCH RFC 0/7] fs: add failfs
To: Christian Brauner <brauner@kernel.org>
Cc: linux-fsdevel@vger.kernel.org, Andy Lutomirski <luto@kernel.org>, 
	Jann Horn <jannh@google.com>, John Ericson <mail@johnericson.me>, linux-api@vger.kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Kees Cook <kees@kernel.org>, 
	Farid Zakaria <farid.m.zakaria@gmail.com>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Jan Kara <jack@suse.cz>, linux-kernel@vger.kernel.org, 
	Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jul 23, 2026 at 4:39=E2=80=AFAM Christian Brauner <brauner@kernel.o=
rg> wrote:
>

[snipped excellent list of things one cannot do with failfs]

> A plain readlink() of
> such a link still works and shows "/".

This seems awkward to me.  I feel like ls -ld /proc/PID/{cwd,exe}
should probably show something distinctive instead of "/".  Maybe
readlink() should show "[failfs] /" or similar?  Both admins or
developers trying to see what's going on and CRIU might want this.
IMO it's too bad that we don't have a nicely parseable readlink output
for oddities like links to deleted files, but oh well.

--Andy
