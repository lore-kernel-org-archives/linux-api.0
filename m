Received: from ms.lwn.net (ms.lwn.net [45.79.88.28])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90E5B2DCF61;
	Tue, 17 Mar 2026 18:37:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.79.88.28
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773772636; cv=none; b=MoOakyboGzSCSieAuhCdl0q3ON8WhVKp1mPyPKQKBegYnzmcoqotqA/uNrTuOu5k4I/vFMPmyORFcEtSIsS2Q0pgmrZ1QRegMP4JeXe/C7GsE/G/QvkO2dJz8oOULAfby0L6/5YfWQhvh6pUlq2TahEfwBdd69lfCJ35v2UUf40=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773772636; c=relaxed/simple;
	bh=jjcYOoT+KqyE0+318IMagSsAV+L00HD2nLksUrDJOkc=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=aGsvLc1liy/w9qwhzPr2mPLVCzogRpqmb3NpyK4WNKz88s+Cvd+cHpUJ2DGXtC5u1XXTsTRu5i+hQDEU06Nxie+vSoZKy31CE1cYeHNH1RBcl0axLvHf6x/qW3ElAtesiECKxTLstPX+76QJ8LasSdVO0jricilONlUJMownghQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lwn.net; spf=pass smtp.mailfrom=lwn.net; dkim=pass (2048-bit key) header.d=lwn.net header.i=@lwn.net header.b=HU23TiBs; arc=none smtp.client-ip=45.79.88.28
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lwn.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lwn.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=lwn.net header.i=@lwn.net header.b="HU23TiBs"
DKIM-Filter: OpenDKIM Filter v2.11.0 ms.lwn.net B2A7540C7C
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=lwn.net; s=20201203;
	t=1773772634; bh=Avh8bhKuzqGLIIUjaifKg+vcNZMYJQrDENcH3wShTl0=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=HU23TiBswDJw7ocrB3Ctri2W3DFMwL/2dNxFiwJ4fzzBd8CStXvB3XVumbVzMZrvZ
	 dj7BNgXi1gFXZmCIoIB6JL19enkQrRabKTa502NoNfZt+LccNv4m078xjT3IJ/8XL8
	 f8nEWjAiXLobDaMTGJny6nnvjGDM08J7647WLf+TgxNf466qqIwuoTP2AfT7RZVeix
	 PavOAT/0V+8f+D+Lsg+xMGF9SB1yxzkS6D9kikgdjau4o3cGYVOkRJa0qdanItIFmO
	 PpsCB7zvlWBRwFRhLuVv27z6PsgxW3Eu4j/DuNEAUcGxMGNwa2cbZ2C+iS/UzkDKNY
	 TSFPhLFDi6//g==
Received: from localhost (c-71-229-227-126.hsd1.co.comcast.net [71.229.227.126])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by ms.lwn.net (Postfix) with ESMTPSA id B2A7540C7C;
	Tue, 17 Mar 2026 18:37:14 +0000 (UTC)
From: Jonathan Corbet <corbet@lwn.net>
To: Sasha Levin <sashal@kernel.org>, Greg Kroah-Hartman
 <gregkh@linuxfoundation.org>
Cc: linux-api@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-doc@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-kbuild@vger.kernel.org, linux-kselftest@vger.kernel.org,
 workflows@vger.kernel.org, tools@kernel.org, x86@kernel.org, Thomas
 Gleixner <tglx@kernel.org>, "Paul E. McKenney" <paulmck@kernel.org>,
 Dmitry Vyukov <dvyukov@google.com>, Randy Dunlap <rdunlap@infradead.org>,
 Cyril Hrubis <chrubis@suse.cz>, Kees Cook <kees@kernel.org>, Jake Edge
 <jake@lwn.net>, David Laight <david.laight.linux@gmail.com>, Askar Safin
 <safinaskar@zohomail.com>, Gabriele Paoloni <gpaoloni@redhat.com>, Mauro
 Carvalho Chehab <mchehab@kernel.org>, Christian Brauner
 <brauner@kernel.org>, Alexander Viro <viro@zeniv.linux.org.uk>, Andrew
 Morton <akpm@linux-foundation.org>, Masahiro Yamada
 <masahiroy@kernel.org>, Shuah Khan <skhan@linuxfoundation.org>, Ingo
 Molnar <mingo@redhat.com>, Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH 5/9] kernel/api: add API specification for sys_open
In-Reply-To: <abQ-iIylzpuqlRv3@laps>
References: <20260313150928.2637368-1-sashal@kernel.org>
 <20260313150928.2637368-6-sashal@kernel.org>
 <2026031343-raft-panhandle-0a21@gregkh> <abQ-iIylzpuqlRv3@laps>
Date: Tue, 17 Mar 2026 12:37:13 -0600
Message-ID: <878qbq9uau.fsf@trenco.lwn.net>
Precedence: bulk
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Sasha Levin <sashal@kernel.org> writes:

> On Fri, Mar 13, 2026 at 04:33:57PM +0100, Greg Kroah-Hartman wrote:
>>On Fri, Mar 13, 2026 at 11:09:15AM -0400, Sasha Levin wrote:

>>> + * since-version: 1.0
>>
>>I think since older versions :)
>
> Right. I guess that in my mind 1.0 was the first official "release". I'll
> update it to 0.01.

That kind of raises the question of just what since-version means.  The
version-0.01 (or 1.0) version of open() surely didn't do everything
described in this specification.  So it's saying that some version of
the system call has existed since then?

Thanks,

jon
