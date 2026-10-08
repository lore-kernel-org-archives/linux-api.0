Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com [209.85.221.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F5FE38A72B
	for <linux-api@vger.kernel.org>; Thu,  8 Oct 2026 16:12:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791475932; cv=none; b=i+irbqhMP0xZ9rNhFBZ5RkbYHIJ3Z8wu4TSfwD4/J8pdsk431acMO4vBDpHBMfniLggohtchqu9nlQI6eT5bOVrTM/CUf+d3ufSZxZmwTyKwWjctS36ulpH16oZJ4Vg67rTQhCmrPJBV2b6/KUwgO6yMYmxlB5WgcLC0YoSK4IM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791475932; c=relaxed/simple;
	bh=BI0G7qBpI/7KwQFAhmOUXBzLsg9VZTTr2gCpFXZLAhc=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=nnqNu1a81jgtOz1MV9+GuxeYMfMBjYXWVHiFguFnVp6fHWSYioSDZ3EztENVjVFA2O7rg9+0evGFeCrUTvmuZG0HyrlZbk+ty5MKyE0O0gBEzdm8tOUv1l2g+2LC5GrnYXWHheB9GA/B04racuZCMD8s6loYAfOmMXYJ0IqtaGU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=cBV3HFqz; arc=none smtp.client-ip=209.85.221.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="cBV3HFqz"
Received: by mail-wr1-f53.google.com with SMTP id ffacd0b85a97d-48b042c0759so2644021f8f.2
        for <linux-api@vger.kernel.org>; Thu, 08 Oct 2026 09:12:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791475929; x=1792080729; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=IGTDk2M1CVr9/HPRZF14PhrI+tmF1KcbANTHbSO6d8s=;
        b=cBV3HFqzzOWW6/3mIA5IUdq0aM9r9hZqea0qp+sbS+quwYPN03Xl2tEzFF1fM72QhI
         /MZxGKXKbaBRh7XSSAEQfpK/r4I6uy2cIeljH9/LKXLwHoT+AvHZLRE4uvH4TSA70Df1
         xMa4MTwSXFIG6huQ31xlXGdhSIItoM1l9uQ+LTTqybNAURHWE7gP72MfEQXopxrCXrA/
         L9gjISpur6L/aZR2K/SIiuuWCC1YMR/J/aaQ5lkVlLZBUTCBfNJGMCzIZwaoA2MbFHa9
         sAWSyoUQbs1dkFjbDjGrlKLdI8gKE+FCl1emLGi4fG7+MByYp3V8EXvQ1nnU8PsYIcHZ
         6vww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791475929; x=1792080729;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=IGTDk2M1CVr9/HPRZF14PhrI+tmF1KcbANTHbSO6d8s=;
        b=uv+Wf/XBTfuePrLvfwSRmldLN4nKDFxUUqVqmVo5CcthsHa1Ck/T3fjM2rlVlxQFSI
         sCboDxpJ4I+PcYwQIlvhrDPf2MaAYBemjXPHJI3L5LG/naLQmj2sNYBGLYZLdjj29Zi9
         OIWc2DxPnDLVF6tM2sa8EqoymQVmjURNDDPedroPsegQhQN9DmeLZSiRC8EUzW3JimXH
         axHlC6KEGq+vIjMHZZPnEme9zDX9WsSls4lYDESA64SKqTSHhB+upv3EBBpOpC6KXus5
         QhnfmkmN+qzD9jAbDbJy64FULb+6LTp0332DOWad8wrKQ3f1jB4mmRJVPwjgtnRlNstZ
         dD9A==
X-Forwarded-Encrypted: i=1; AKwUvBzADbDvDLMLA+HoF32u+vBwuTzi0nzjayYOrk/Lgxh/kq/7DGJdTmTVW05TFIO3X9i5SkhaDrUegLY=@vger.kernel.org
X-Gm-Message-State: AFq9FYJw6EssuGgUozIho4a/ZZl/eaZYZ6UJlZT/E1tksDasuYkwudSm
	Fplw8G/A9FBXzx51xJt2Waw7OCRfVVrCZ+ZzKS0sZ1iDhewvMIosQCPm
X-Gm-Gg: AYBFou1zALltbc6LbUyjxlIU1Dc84b10zYFV6e5jQnJEVy97mC0KAZR60RZYwdu0NC4
	hbZC7zVAgAOeBExa7uJeMr+CY4p4ZpnCQDydraQbXqu0M6f6uBXvHWKcDzZ51edBDbpm3XgROva
	eSU6YZI9Ia8Rbf+OCVaBHrBH9HipWheD0ElJiDY/CzTFlYeqXCY0M2ObtgjV9spkvk1Ni6gFLgj
	l4Y+bhV+WQealObQRCCMVEBNuBvgWD91u10Nn4khS6b5uvAoqwuYKKgj7RijO6u0Po1BXVJ4vQb
	pdUnv6TROiEY5CSdABp/rOdK5/rE+2D1YM6+NuXjMsCPk7oXJ+cj5Zea6nkRlDgm/DW8HTsJuCL
	ncBHxV/lQfncliWVB8j/AY/oaoyllKY9kP5/o87uwb7+wVySnSzIthYwSqyimCDnx/e2YGw48hw
	f2UFGa1Ki6wLbs0OW0upSRBRr8vBotJ+rhw5ut/Lx8Laqblra63BbEE5H2mWgo99Udm675rxnax
	6g8prn9Qcrii4VsTzw/y7RBzFgwrTgUXrKk69s+46Vo4A==
X-Received: by 2002:a05:6000:25fb:b0:48c:77ad:d52d with SMTP id ffacd0b85a97d-48c77add59dmr9194549f8f.43.1791475929174;
        Thu, 08 Oct 2026 09:12:09 -0700 (PDT)
Received: from pumpkin (82-69-66-36.dsl.in-addr.zen.co.uk. [82.69.66.36])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48db650fd4bsm478599f8f.11.2026.10.08.09.12.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Oct 2026 09:12:07 -0700 (PDT)
Date: Thu, 8 Oct 2026 17:12:05 +0100
From: David Laight <david.laight.linux@gmail.com>
To: "Serge E. Hallyn" <serge@hallyn.com>
Cc: Gregory Price <gourry@gourry.net>, Sasha Levin <sashal@kernel.org>,
 linux-api@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-doc@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-kbuild@vger.kernel.org, linux-kselftest@vger.kernel.org,
 workflows@vger.kernel.org, tools@kernel.org, x86@kernel.org, Thomas
 Gleixner <tglx@kernel.org>, "Paul E . McKenney" <paulmck@kernel.org>, Greg
 Kroah-Hartman <gregkh@linuxfoundation.org>, Jonathan Corbet
 <corbet@lwn.net>, Dmitry Vyukov <dvyukov@google.com>, Randy Dunlap
 <rdunlap@infradead.org>, Cyril Hrubis <chrubis@suse.cz>, Kees Cook
 <kees@kernel.org>, Jake Edge <jake@lwn.net>, Gabriele Paoloni
 <gpaoloni@redhat.com>, Mauro Carvalho Chehab <mchehab@kernel.org>,
 Christian Brauner <brauner@kernel.org>, Alexander Viro
 <viro@zeniv.linux.org.uk>, Andrew Morton <akpm@linux-foundation.org>,
 Masahiro Yamada <masahiroy@kernel.org>, Shuah Khan
 <skhan@linuxfoundation.org>, Arnd Bergmann <arnd@arndb.de>, Nathan
 Chancellor <nathan@kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
 Masami Hiramatsu <mhiramat@kernel.org>, Mathieu Desnoyers
 <mathieu.desnoyers@efficios.com>
Subject: Re: [PATCH v5 05/11] kernel/api: add API specification for sys_open
Message-ID: <20261008171205.7239c463@pumpkin>
In-Reply-To: <asemkQ2v0di0Eea3@hallyn.com>
References: <20261008084956.2911790-1-sashal@kernel.org>
	<20261008084956.2911790-6-sashal@kernel.org>
	<aseRXi7hMWBBc0tB@hallyn.com>
	<aseWPV6ZRQM3JOMN@gourry-fedora-PF4VCD3F>
	<asemkQ2v0di0Eea3@hallyn.com>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; arm-unknown-linux-gnueabihf)
Precedence: bulk
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu, 8 Oct 2026 09:20:01 -0500
"Serge E. Hallyn" <serge@hallyn.com> wrote:

...
> 
> Even if there's just a three line comment above a fn, history proves
> that it will not reliably stay in sync as the fn changes.  An automation
> step/check is needed.

The only way it can possibly stay in step is to have the compiler process
the same source text.
Then, if you add/change a function parameter you'd be pretty much forced
to add/change the comment.
Return values would have to be documented at the C return statement and
really as an extra parameter to the return.

But, IMHO, the whole thing adds too much bloat to the source files.
When you 'grep' a source file, you don't really want another match in
a big comment at the top of every function.

David

> 
> > ~Gregory  

