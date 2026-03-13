Received: from cygnus.enyo.de (cygnus.enyo.de [79.140.189.114])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 346F71DA23;
	Fri, 13 Mar 2026 19:18:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=79.140.189.114
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773429520; cv=none; b=XnejjdOYYxAVi9eZ7g45MMcsPFSzhHthXgjXMzXG2zDEj1LpSBvClAc4xlov9RlZInqEgvAfrirvmxtwBpv3ZBpSSR8xdva/kq/dRBdWLwcnxKmAmQLtto4AHXwZQX9hqT5DmpYtBzNn5nAsyk+KBmbBPrZtqlxMFdepIrkCQk8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773429520; c=relaxed/simple;
	bh=CftFV0Uf1TPCNljaXPNlNiuN3KlP2rmvuaZXN+T9qMA=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=Ej5MfRwjYQqosbXOyhg/uCY08SyfBAgYDlUuLfkduEZMJK79yW5czBHXY9kQFIEjH6Xy8ao7c+h/kNZXUiU5rKf6lUmA7hvuhNbTH7DmQbJ4XDuGLPyOKJO+ehzJJm6MNMXMay5ZvUerPyrl3Pk3KUjLmde69FGugZ4VZb5uRtE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=deneb.enyo.de; spf=pass smtp.mailfrom=deneb.enyo.de; arc=none smtp.client-ip=79.140.189.114
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=deneb.enyo.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=deneb.enyo.de
Received: from [172.17.203.2] (port=43271 helo=deneb.enyo.de)
	by albireo.enyo.de ([172.17.140.2]) with esmtps (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	id 1w17bf-0000000Cfum-13lj;
	Fri, 13 Mar 2026 18:51:31 +0000
Received: from fw by deneb.enyo.de with local (Exim 4.98.2)
	(envelope-from <fw@deneb.enyo.de>)
	id 1w17bf-00000000NiK-0daL;
	Fri, 13 Mar 2026 19:51:31 +0100
From: Florian Weimer <fw@deneb.enyo.de>
To: Roman Bakshansky <bakshansky.lists@gmail.com>
Cc: linux-api@vger.kernel.org,  linux-kernel@vger.kernel.org,
  audit@vger.kernel.org,  libc-alpha@sourceware.org
Subject: Re: [RFC] Modernizing Linux authentication logs (lastlog, btmp,
 utmp, wtmp) with SQLite
In-Reply-To: <660c10e6-f8b5-46e2-a424-e3e052992b3a@gmail.com> (Roman
	Bakshansky's message of "Fri, 13 Mar 2026 00:01:25 +0300")
References: <660c10e6-f8b5-46e2-a424-e3e052992b3a@gmail.com>
Date: Fri, 13 Mar 2026 19:51:31 +0100
Message-ID: <87cy175zrg.fsf@mid.deneb.enyo.de>
Precedence: bulk
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable

* Roman Bakshansky:

> The full RFC, including preliminary database schemas and API drafts,
> is available in the discussion repository:
>
>  =A0 =A0 https://github.com/bakshansky/linux-auth-logs

I don't understand how SQLite (without a daemon) addresses the locking
issue.  WAL mode still uses fcntl locking.
