Received: from ms.lwn.net (ms.lwn.net [45.79.88.28])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 592E42D29B7;
	Wed, 18 Mar 2026 16:50:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.79.88.28
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773852643; cv=none; b=NyH+9zH0xZDE29rqWTQD3gLmSH0HSD3DbyJ5+RBn/8ctaAbQ6dIOCChvPIa5lAKLtZ2oujbkOgLL5fvcdSmq7xDnHdhzebRdL+bIE015v5yM3b8mboOpAp7w4kBJwcF0RTG+sNJlio0oUuByx8xJS32ANV6syB3oMVAlH99cwEA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773852643; c=relaxed/simple;
	bh=9OaN0Uw3P7eOowaB2AzTSywGE+7W/23m2yieLmnFUE0=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=KA3bSfPcRCxi5qPBBMLOs7hJ/2UG6iQBVldDUYxz8skoDhz13NsXm7oD4s29CffOcmsfPUpisENCqjPfYAenIwzGjL74JDGvXsKAPUq5rlyC8yu3vGiRYuns/jCvBJ4xqik1nr4JbwpkOCUnP3KACkGUpXT+knQUVtG2CxFokz8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lwn.net; spf=pass smtp.mailfrom=lwn.net; dkim=pass (2048-bit key) header.d=lwn.net header.i=@lwn.net header.b=GONcFPpo; arc=none smtp.client-ip=45.79.88.28
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lwn.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lwn.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=lwn.net header.i=@lwn.net header.b="GONcFPpo"
DKIM-Filter: OpenDKIM Filter v2.11.0 ms.lwn.net 90EF640423
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=lwn.net; s=20201203;
	t=1773852635; bh=2M7Isv+5gdy9BAEctVxVjLNklONTC2uyIdTw4SrIalU=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=GONcFPpoYmnGrS3SzGEF3hU7Uc9407nvyxU39NDNlEaKak4fdZYHMAmhoJhtpFZ8N
	 JNEmd0E4olpCIQCPzZGc7MlSQ8G/Hzcp6VUh9M4ArARRPkgnIfWHwSt8IHjdP8bavs
	 2AIcoHGOk9PJ539nJOAvwyX6MikHdVU5I1MkF3CF0kRIIqqaCGtD+ixo3VxfqXRIFN
	 UOQSNrtc1LMU+j+nTyXp0lfd0RM+HV5LA4aLDqPiRZVNiYIjU6MA1A5AIXrgGTD8AF
	 SllbqNakO8IJ9uuZEkF8Gc2iVkOa0vHQV1evaJk5G0xYbh6YiEfrtv+adFLD6pLass
	 HYiPipiWeKROA==
Received: from localhost (c-71-229-227-126.hsd1.co.comcast.net [71.229.227.126])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by ms.lwn.net (Postfix) with ESMTPSA id 90EF640423;
	Wed, 18 Mar 2026 16:50:35 +0000 (UTC)
From: Jonathan Corbet <corbet@lwn.net>
To: Sasha Levin <sashal@kernel.org>
Cc: linux-api@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-doc@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-kbuild@vger.kernel.org, linux-kselftest@vger.kernel.org,
 workflows@vger.kernel.org, tools@kernel.org, x86@kernel.org, Thomas
 Gleixner <tglx@kernel.org>, "Paul E. McKenney" <paulmck@kernel.org>, Greg
 Kroah-Hartman <gregkh@linuxfoundation.org>, Dmitry Vyukov
 <dvyukov@google.com>, Randy Dunlap <rdunlap@infradead.org>, Cyril Hrubis
 <chrubis@suse.cz>, Kees Cook <kees@kernel.org>, Jake Edge <jake@lwn.net>,
 David Laight <david.laight.linux@gmail.com>, Askar Safin
 <safinaskar@zohomail.com>, Gabriele Paoloni <gpaoloni@redhat.com>, Mauro
 Carvalho Chehab <mchehab@kernel.org>, Christian Brauner
 <brauner@kernel.org>, Alexander Viro <viro@zeniv.linux.org.uk>, Andrew
 Morton <akpm@linux-foundation.org>, Masahiro Yamada
 <masahiroy@kernel.org>, Shuah Khan <skhan@linuxfoundation.org>, Ingo
 Molnar <mingo@redhat.com>, Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH 1/9] kernel/api: introduce kernel API specification
 framework
In-Reply-To: <abq29NMpyXJrqv_7@laps>
References: <20260313150928.2637368-1-sashal@kernel.org>
 <20260313150928.2637368-2-sashal@kernel.org>
 <87h5qe9wig.fsf@trenco.lwn.net> <abq29NMpyXJrqv_7@laps>
Date: Wed, 18 Mar 2026 10:50:34 -0600
Message-ID: <87o6kl5bfp.fsf@trenco.lwn.net>
Precedence: bulk
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Sasha Levin <sashal@kernel.org> writes:

>>> +The framework exports specifications via debugfs that can be used
>>> +to generate documentation. Tools for automatic documentation generation
>>> +from specifications are planned for future development.
>>
>>Documentation always comes last :)
>
> So this is one thing I wanted to run by the doc maintainers: the kapi tool
> already has the capability to export these specs in .rst format. Would it be
> interesting to have a manual for kenrel APIs in Documentation/? It can be
> automatically generated and updated and would always match the kernel code at
> that point.

I suspect we could certainly find a place for it.  Maybe as a subsection
of the user-space API manual, at least for the system-call portion of
it.

Thanks,

jon
