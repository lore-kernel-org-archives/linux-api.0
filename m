Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795044795;
	b=CPlIcTdGizxVwTir/bryFJvhS+OoYiEuJdKXO40N1yvleNF91bTAvHxvcTE68zK/0lvd
	 Ea+XvE9YWvdZk1tFbXq111b2nhgHW8ov5aFQ7IcsfpezDyS88nHeqMho/ED8A+pgKUHvb
	 TjT086XXXL5zj5TkYg5XKXZO5d7DJ6P4BgW+pStYQs4XPJeVyyKfXwBKrGJIq1wPqFJ0v
	 TQ8AeLAT1eFiPchUpU1NCrU3gsPHeO6HSGa0Oqlp+wi/qFxIwkknPU2g4f5Rkj5TIypBH
	 bl0GGci0F2ftl3IOMLdMKdaW7Clw7djqck+3qDTX77kPZVLX45RznukAHstOvwoVTBw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795044795;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=p9akWZSnCYRnWbaIGtILHQRc1MGkbrWkyT1jQUBXFMs=;
	b=NRw3o4pbGpnMG/i1Je3+PXEEAq2Nos3W6rezGtnDgKxENmvBoUwwqMyISnkJG/czcT8z
	 QCE6SEk4QGsl7BJyAWSDsiuIcPG4+ylz+Ev/9sLeJSV3deWF547+99O4bmRQ8WDJR+v73
	 9lr8rZeN1V2L4d6kpESVGUuuJ4BhuDrSrdgh5uqisspBc8U/5w1gqLBzuOxZ6bLl71/06
	 yvJpodDXwb05Whs1OLoJIbu1SQB28PrbvTefkKwDCcAmLDIIOTMzFgvpNsZNKChXoBLnA
	 WpWt4n/qsrZDKtQ7XIEpTaJof0MXOZD+2JWDUa5mk/ZOnkCnIkLex2bnLRfe4pLhPow==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=S152Qfzk;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id CCD6A60A3803;
	Wed, 18 Nov 2026 23:33:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=S152Qfzk
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id D36691F000C4;
	Wed, 18 Nov 2026 23:33:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795044795;
	bh=p9akWZSnCYRnWbaIGtILHQRc1MGkbrWkyT1jQUBXFMs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=S152QfzkH/YqVHGzcaAyRIHXf05iUtkydNnkRs9gCIC04KoHBy3vN9DuOm1O3Q1eR
	 Q6asZNJIfzOO8s55fR940xAjljy7DSHPQlNmAazhL4OBJpGf/2M+b3XU6dS6ylQVHT
	 NwV1iVNwjV7fb+uYu4H3R2ow+82tgiBtGA+dYFfDOcNFN6HdfihgXLmH+ZRGm7Sewc
	 ghLiT4JntEq1W9eHpsNzEgrxVl9GV9sYIfv+wgjPvGzCmoCG1CHMoNJJF4CJUBRLcb
	 nYbcySuhRvuyXd3EJn5ttwyDsZz+kOlcBtjEISdkmYIHvY0cFueAOlZy+mnw8o/9Jv
	 IEBuRomvBIcTg==
Date: Thu, 19 Nov 2026 01:33:11 +0200
From: Jarkko Sakkinen <jarkko@kernel.org>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: David Howells <dhowells@redhat.com>, linux-api@vger.kernel.org,
	linux-doc@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org, linux-security-module@vger.kernel.org,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Andrew Morton <akpm@linux-foundation.org>,
	Andy Lutomirski <luto@amacapital.net>,
	Anna-Maria Behnsen <anna-maria@linutronix.de>,
	Ben Segall <bsegall@google.com>,
	Christian Brauner <brauner@kernel.org>,
	David Hildenbrand <david@kernel.org>,
	Davidlohr Bueso <dave@stgolabs.net>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Frederic Weisbecker <frederic@kernel.org>,
	Ingo Molnar <mingo@redhat.com>, Jan Kara <jack@suse.cz>,
	John Johansen <john.johansen@canonical.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Juri Lelli <juri.lelli@redhat.com>, Kees Cook <kees@kernel.org>,
	K Prateek Nayak <kprateek.nayak@amd.com>,
	"Liam R. Howlett" <liam@infradead.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Manfred Spraul <manfred@colorfullife.com>,
	Mel Gorman <mgorman@suse.de>, Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>, Neal Gompa <neal@gompa.dev>,
	Paul Moore <paul@paul-moore.com>,
	Pavel Tikhomirov <ptikhomirov@virtuozzo.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	Serge Hallyn <sergeh@kernel.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Valentin Schneider <vschneid@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Vincenzo Frascino <vincenzo.frascino@arm.com>,
	Zygmunt Krynicki <zygmunt.krynicki@canonical.com>
Subject: Re: [RFC PATCH v3 00/13] Namespace for namespace roots
Message-ID: <av41t-SRVZjOBqi7@kernel.org>
References: <20261118193539.240065-1-jarkko@kernel.org>
 <9bc43f9b-d721-408c-bf78-0f08f6ec4bb2@kernel.org>
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Post: <mailto:linux-api@vger.kernel.org>
List-Help: <mailto:linux-api+help@vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-api+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9bc43f9b-d721-408c-bf78-0f08f6ec4bb2@kernel.org>

On Wed, Nov 18, 2026 at 11:36:20PM +0100, Vlastimil Babka (SUSE) wrote:
> On 11/18/26 20:35, Jarkko Sakkinen wrote:
> > VERSIONS
> > ========
> > 
> > v2: https://lore.kernel.org/linux-fsdevel/20261117231352.3816603-1-jarkko@kernel.org/
> > v1: https://lore.kernel.org/linux-fsdevel/20261117050841.3289652-1-jarkko@kernel.org/
> 
> 3 versions in 2 days, with 13 patches and such a vast CC list? Maybe slow
> down a bit, please?

It has been a version per day (or along the lines), which is not
spectacular but I'll pause for now.

v2 and v3 address the initial architectural bottlenecks that came up.
Those really required updated changes + kselftest providing the evidence
because I was not immediately sure myself whether they can be addressed
without experimentation.

I would presume whatever happens to this would be more in details, and
can be projected without extending feature and/or test coverage.

Br, Jarkko
