Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795097325;
	b=24qaEoeAnoNhJ/avfn/0+w5BGBhud0EpaTQMDwxkIHsElEeJNzchBr4VEsScibqsKBJb
	 L/mY0SZFtRkwCAm9wbH2ubIE5BR/6cyz86Wce2acpBtcAGw6LXVYzTztiTcoukzJpTFJ2
	 0MyqdtX4OvYz58lvb8zLWpNE5/igqwC4R6d7o+jGvrPMEUmfcX/myyBwooUYIob+6jhf3
	 w0DcHQWWmNTE9zg4SGykcQPm1GeW6nWkhRoPhfob5SkMMO6vSB84qsOOJK6vKFwdLCeWt
	 Rz2fmUACVM4dxZ4acNE5tUbo/n53UviEys+FRM2/Wd6Z7u0LzlCXhywTe4s1I6RWbPQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795097325;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:
	 Content-Transfer-Encoding:In-Reply-To;
	bh=deLFcMvvltUgOBB0nzekqT3DRM7PlPpuRsUgmgE0xJs=;
	b=tpozhdCkIbrCmRCUQT/JMXUO6jhIvss6p9q/a9ZdiwvG+Bau1V9yxQiyF2Vd4hinVmHu
	 GcafOyOPJ/zJQDMQr4RrUUSzkVhncJ79vV4g227GC+Ui7Ky6+7fpNDn8xJgw5oQ8wWkQS
	 adEy6f4FYLozzmax7pBVKHdgoMm1AmO+T23muQrOCENWC2aZVQl7feVqAZVK84rmA8E+N
	 YxpiFiq1U12oYXWunC6WEfZDTgM7FgvUsSzJSuhpPwkHm5nMcE45MbZlrXS76XNk73dTa
	 eIIwLdHR40Fxzd45m/oHwIDon8dVXvXCHKcnMzZtvwOus1Ui0kewOuIJPaduMJv9Njg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="VGT6CPW/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4EAA606A320;
	Thu, 19 Nov 2026 14:08:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=VGT6CPW/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B6D61F000C4;
	Thu, 19 Nov 2026 14:08:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795097325;
	bh=deLFcMvvltUgOBB0nzekqT3DRM7PlPpuRsUgmgE0xJs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=VGT6CPW/wtjf93Hbnt7vGTzxnm+m5tp5bIHpq29p+RgyV5QZXwZhn8vBEMLao+PYg
	 PCUZ1usoGhC/buvHKCHBr+3FqpWcZI8hA+G/AnsZf0kqeyDDRcuNRnBdBdvUjV8AF5
	 pbqd3WpW+PvZx1H0nHTPucGg+qChKpjfQL2yIPMnFVf3HQ8i7dLCper3SXG3Oq3Tnn
	 ljERMRXcjxXOlrsqDe8qKB1/RchUjdc/mKVygZTSK9ZQSj+CKnOlXkNaufaWLk9PPC
	 h14dMsVmUHWhkRabrbOfkgHJKFwhMsxJ0pXnGerIga4T/8beoldtWKWqL/RWlYosZL
	 wgB1vSwgzeB9A==
Date: Thu, 19 Nov 2026 15:08:37 +0100
From: Christian Brauner <brauner@kernel.org>
To: "Hallgrimur H. Gunnarsson" <halg@google.com>
Cc: =?utf-8?Q?Micka=C3=ABl_Sala=C3=BCn?= <mic@digikod.net>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Paul Moore <paul@paul-moore.com>, 
	Serge Hallyn <sergeh@kernel.org>, Kees Cook <kees@kernel.org>, 
	"David S . Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, Jan Kara <jack@suse.cz>, 
	James Morris <jmorris@namei.org>, Simon Horman <horms@kernel.org>, 
	Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
	Randy Dunlap <rdunlap@infradead.org>, Jann Horn <jannh@google.com>, 
	=?utf-8?Q?G=C3=BCnther?= Noack <gnoack@google.com>, KP Singh <kpsingh@kernel.org>, 
	Jonathan Calmels <jcalmels@3xx0.net>, Casey Schaufler <casey@schaufler-ca.com>, 
	linux-fsdevel@vger.kernel.org, linux-security-module@vger.kernel.org, linux-api@vger.kernel.org, 
	containers@lists.linux.dev, netdev@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/8] userns: per-namespace capability bounding set and
 opt-in netns loopback
Message-ID: <20261119-bagger-sagst-saatgut-096a6c993e9e@brauner>
References: <20261028221705.3915340-1-halg@google.com>
 <20261107.aighieG4Ami1@digikod.net>
 <20261118.faiBee9Taigh@digikod.net>
 <av7TsXKUE69lyiWl@google.com>
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Post: <mailto:linux-api@vger.kernel.org>
List-Help: <mailto:linux-api+help@vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-api+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <av7TsXKUE69lyiWl@google.com>

On Thu, Nov 19, 2026 at 10:47:13AM +0000, Hallgrimur H. Gunnarsson wrote:
> On Wed, Nov 18, 2026 at 03:43:03PM +0100, Mickaël Salaün wrote:
> > Hallgrimur, could you please explain why your use case would not work
> > with Landlock?  The capability split or new clone flags would be
> > complementary of course.
> 
> Apologies for the late reply.
> 
> Landlock's capability restrictions work well for self-sandboxing
> applications and launchers. The main gap for our use case is setting a
> host-wide default for unprivileged user namespaces while still permitting
> exceptions. Because Landlock restricts all capability use (not just
> capabilities acquired via user namespaces) and its domains are strictly
> irrevocable, PID 1 cannot apply a default policy at boot without
> locking out privileged services, file-capability helpers, and authorized
> workloads. Using Landlock here would require explicit opt-in enforcement
> at every unprivileged transition boundary (SSH, container/job launchers,
> etc.), where missing any entrypoint leaves unprivileged user namespaces
> unrestricted.
> 
> In v1 we had the global sysctl to tackle this. In v2 (based on Christian
> and Andy's feedback), we combine per-cred cap_userns with per-userns
> cap_bset), and PID 1 or a service manager can lower the default userns

Plus, this is useful and improves security in general without having to
use any LSM framework.
