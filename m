Received: from sender4-op-o15.zoho.com (sender4-op-o15.zoho.com [136.143.188.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 025406FBF;
	Sat,  4 Jul 2026 13:21:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=136.143.188.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783171287; cv=pass; b=DOBVbGztOqtBq30szUxzcSELQt5HPHtsoNGSGtlf/jJOU9HqwniFefIiomM7X+rz5kVLE+YDOqOaEmwUNEBHMXu5AL7qisJ57YCjr+CnERJqXvc6gDeicuLPrKxi74lecw4MBlbijpl6fhqC5OJRLw9KjsF3IoEd5/WH835Py/E=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783171287; c=relaxed/simple;
	bh=mDzTIdZazAIkO+ZIeXqTNrPNl0f5rj/73pijf4BO9pc=;
	h=Date:From:To:Cc:Message-ID:In-Reply-To:References:Subject:
	 MIME-Version:Content-Type; b=sDETOOiSKsPAWBRCsxN1qxrm9/a7Mq11cP8Jihbq57QrnfPQmr8FhF+DT7Vxjg+mNb9w8DqV6qU5cH1S3OR3hj86Eeyhz9V5fooIje0VMsmtaFz5+HV/OTINBeFq/DFO0yIsKsrfiCK/ay+6NyfySw/qvFcYpy9Mov7pB+xCZZM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.beauty; spf=pass smtp.mailfrom=linux.beauty; dkim=pass (1024-bit key) header.d=linux.beauty header.i=me@linux.beauty header.b=fHNX0rg6; arc=pass smtp.client-ip=136.143.188.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.beauty
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.beauty
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.beauty header.i=me@linux.beauty header.b="fHNX0rg6"
ARC-Seal: i=1; a=rsa-sha256; t=1783171244; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=dHNyqRIT7IQ0kr5zYrqM0mKfXavHvMTsYaRzLl0DjpxUbjsXtN0CQpFwiLm7yu0rL+H1CDEf39XX8wuRYXYBQ/UnAmvDg4cLWdtn7l9E6POwJaoXP4sqVhixKgsP4aBc74DsXAItIPpLt12pZhOvno3Punn/i/uUqFS9H5iK9KY=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1783171244; h=Content-Type:Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=mDzTIdZazAIkO+ZIeXqTNrPNl0f5rj/73pijf4BO9pc=; 
	b=MCglm6GRXlPD5hcCbftTbiMpdT+rkleIZRVITBt1zP2bXYlU5EgkA1kmQqkIg85qGj6LeRWCvAguz0oCDZ8lTodRYI7OTOi5YvTNIsJBaTCoIBV1rlyKL0IEoECqqesc1qrKxzZqmu1pzuTABNCLlcfrRC39QugdsedHfgm2LHc=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=linux.beauty;
	spf=pass  smtp.mailfrom=me@linux.beauty;
	dmarc=pass header.from=<me@linux.beauty>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1783171244;
	s=zmail; d=linux.beauty; i=me@linux.beauty;
	h=Date:Date:From:From:To:To:Cc:Cc:Message-ID:In-Reply-To:References:Subject:Subject:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-Id:Reply-To;
	bh=mDzTIdZazAIkO+ZIeXqTNrPNl0f5rj/73pijf4BO9pc=;
	b=fHNX0rg6NtqLgEQOrIwZHz2DSvFrCVB/YZptvfSMMUa5UQhWu4ogy7VBNSCHLUmR
	zoLMo6ztX8tlxZVTGZSsh/S4MGoU+z4uSXe9PdGy08HFgFCqJ9LVcUeXgg/1Rjc8Kwf
	FwUr6htfNrR6Wq/azfLFsjjgL+2Hetcz9xf3JFyg=
Received: from mail.zoho.com by mx.zohomail.com
	with SMTP id 1783171244368989.4027705624679; Sat, 4 Jul 2026 06:20:44 -0700 (PDT)
Received: from mail.zoho.com by mx.zohomail.com
	with SMTP id 1783171242006432.66307911146623; Sat, 4 Jul 2026 06:20:42 -0700 (PDT)
Date: Sat, 04 Jul 2026 21:20:41 +0800
From: Li Chen <me@linux.beauty>
To: "John Ericson" <mail@johnericson.me>
Cc: "Cong Wang" <cwang@multikernel.io>,
	"Christian Brauner" <brauner@kernel.org>,
	"linux-arch" <linux-arch@vger.kernel.org>,
	"linux-kernel" <linux-kernel@vger.kernel.org>,
	"linux-fsdevel" <linux-fsdevel@vger.kernel.org>,
	"linux-api" <linux-api@vger.kernel.org>,
	"Arnd Bergmann" <arnd@arndb.de>, "Andy Lutomirski" <luto@kernel.org>,
	"Thomas Gleixner" <tglx@kernel.org>,
	"Ingo Molnar" <mingo@redhat.com>, "Borislav Petkov" <bp@alien8.de>,
	"Dave Hansen" <dave.hansen@linux.intel.com>,
	"H. Peter Anvin" <hpa@zytor.com>, "Jan Kara" <jack@suse.cz>,
	"Jonathan Corbet" <corbet@lwn.net>,
	"Shuah Khan" <skhan@linuxfoundation.org>,
	"Alexander Viro" <viro@zeniv.linux.org.uk>,
	"Kees Cook" <kees@kernel.org>,
	"Sergei Zimmerman" <sergei@zimmerman.foo>,
	"Farid Zakaria" <farid.m.zakaria@gmail.com>
Message-ID: <19f2d49d806.2efa03c49662153.3517116418763791597@linux.beauty>
In-Reply-To: <a49ce818-f38d-41b0-bbf7-80b8aad998b1@app.fastmail.com>
References: <a49ce818-f38d-41b0-bbf7-80b8aad998b1@app.fastmail.com>
Subject: Re: [RFC] Null Namespaces
Precedence: bulk
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Importance: Medium
User-Agent: Zoho Mail
X-Mailer: Zoho Mail

Hi John,

Sorry for the silence. I got pulled into some work stuff recently and
only caught up with these threads now. I still have not studied every
patch line by line, but I wanted to say that I really appreciate you
pushing on this.

The embryonic-process framing lines up well with the direction I have
been trying to move toward after the earlier feedback: make the
not-yet-runnable state explicit, and keep task creation separate from the
state installed into the new task.

For my next process-builder RFC, I plan to keep the first step small: a
pidfd-based builder for posix_spawn-style semantics, with limited action
support; it will not yet have the pristine/no-source backend.=20
So cwd/root, non-CLOEXEC fds, and
other selected source state can still be inherited unless actions or
attributes say otherwise.

I think the lower-authority/null-namespace side should be an explicit
mode, not the default for the posix_spawn-compatible path. Otherwise it
would change existing expectations around cwd/root, inherited fds, and
other source state.

Longer term, I would like to add that lower-authority side as follow-up
work: pristine/no-source process creation, where resources are installed
deliberately instead of starting from the parent's fs/fd/mm state. I had
an earlier experimental local branch that tried to separate pristine task
allocation from source-state installation, but that is not the RFC I plan
to send first.

For that later mode, Christian's nullfs/failfs direction also looks like
the more practical way to express the low-authority fs state.

Thanks again for pushing this forward.

Regards,
Li=E2=80=8B


