Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793959982;
	b=Z+MhnnWrt6JPuTP4JSsqIj1oHNViJpmCiEG3ua34SX2e2vVTzaTrlN4xnhsznOZ/Mp2w
	 TFIxz3FAcIioRTbsCYh9CBQNZ6WPT9Ok+h8pWPHRoEi2UXpXmcmDO5PDm5PVMuJP8Njrh
	 kWFEJ173bLe+0+vNJ5S+hwFA0pRMsYmhQyOIapPXNolRJe+wILJjX76D2ysY6i9PsNgp9
	 //Rz1heaAVG6idkoChhug24fOGgI7+3o89TLQA8wkbrGr+mDWKRXlLcC+jmz+UErUsosF
	 MU4ruTNuq1LgPE68OqBgM+ROofJUO4x1jr6QvBhizVegUy4rvKJvktpKKto8fBIOQfA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793959982;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=nnzK0BslWJHcXFemGgfYITU9fhviw2smy0wN/ApAn14=;
	b=hZc5LuKlOx2w2Rj9dJJVWrPOd+rMzUP8RYWAtuGiHC4aOjQowbicne2HE+A55E+sOXzH
	 ShEe1Q37OPzLq5XxuCXwfDHBqCzrZlNEbhHO8p2UYS/gwAccNrcyilJqxAuoU6UZQCrE5
	 NnqikgR5l+ROns1KftFoonDvbjHqnJpq+onv5lkp0Sb3j4jmenHD8DFYxmW1ZVtMh8Ghz
	 TU28JlcNj0Mt9pQ5Jzfdqcw162gxO+xghvhZa95EVpS82A+y9u0f7vpdlBGUc6LaQhmkl
	 ySipzs+g88lP9YHGk6KbJb79+nhrWnA48URkmAmuWJHtClwdu/PQNG3kV4L3NOpulAw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="edM4/p9S";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54AFD606A326;
	Fri,  6 Nov 2026 10:13:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=edM4/p9S
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A44D81F0089F;
	Fri,  6 Nov 2026 10:12:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793959982;
	bh=nnzK0BslWJHcXFemGgfYITU9fhviw2smy0wN/ApAn14=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=edM4/p9SW7+S73fDgQfspXTjrIk9baHrV37Kd/QhylG3sLFrLKrn7Hstn6AQsz5uw
	 UpQitFXbsHcThZxWuXEdgx2CDWhWf6hbi4u2aagagDQcQos8ZBnDTihVAkxsA3Xn2S
	 DaXEaR4Ddkun5RuUbGazbbXXqJnn4U2NrjbxamgcSa5zL2fHatPp33S0Uil9R6wxXW
	 6ge5YPJC6yBuH0U/vS7kAmhEAxOiNR4kAK8TFOI7nFk/vAgdTcuJjqV3mfM6VrhrYp
	 EqVajW7CacXXOnIxA1xdsWgBIymxyAvUB9LHqQ8we47DuLvg13NGqZGYXr7xRTpXPl
	 +UVOBxUZErwXA==
Date: Fri, 6 Nov 2026 11:12:53 +0100
From: Christian Brauner <brauner@kernel.org>
To: "Serge E. Hallyn" <serge@hallyn.com>, 
	"Hallgrimur H. Gunnarsson" <halg@google.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, 
	Paul Moore <paul@paul-moore.com>, Serge Hallyn <sergeh@kernel.org>, Kees Cook <kees@kernel.org>, 
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
Message-ID: <20261106-sandalen-monopol-neugierig-23357f8efc64@brauner>
References: <20261028221705.3915340-1-halg@google.com>
 <aunVmg42/S2uUDWR@hallyn.com>
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
In-Reply-To: <aunVmg42/S2uUDWR@hallyn.com>

On Tue, Nov 03, 2026 at 06:37:46AM -0600, Serge E. Hallyn wrote:
> Kees whipped up a proof of concept BPF lsm that implemented this.  A copy
> from his email (and let's call it GPLv2 unless he wants to change it to
> something like MIT) follows:

There's no need to special-case user namespaces for this anymore.
I've added generic namespace LSM hooks for v7.4-rc1:

* namespace_init()
* namespace_install() (setns())
* namespace_free()

called from the common namespace code I added and for every namespace type.

So a policy like this can cover creation and setns() of all namespaces
and follow a namespace by its id until it's gone.

The catch is that what got merged doesn't work with the bpf LSM right
now.

namespace_free() is never called unless an LSM allocated a namespace
blob, namespace_init() sees a namespace id of zero because
the id is allocated after the hook has run, and the bpf LSM marks the
namespace arguments of both hooks as trusted although the namespace can
be freed right after.

I sent fixes for all of that (cf. [1], [2]) (cf. [3]).

[1]: https://lore.kernel.org/all/20261026-work-security-namespace_free-v1-0-ffa3ebbf71bd@kernel.org
[2]: https://lore.kernel.org/all/20261029-work-security-namespace_free-v2-0-65591dbba7b3@kernel.org
[3]: https://lore.kernel.org/all/CAHC9VhRwD1c1qKK4=Uc8cbMy27iF722C0DZeXy4WGtH-kOBOcQ@mail.gmail.com

-- 
