Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794941339;
	b=n9oqEVrnka7snDOu9yKPkVMi5z8X5ErxSRyoiqI9s3JCKwAeFhKUoo/VGslXt3l51eJd
	 zOq0CgJzzZABtCa9ITQxO7UYSUCIxnJoRufggzx4+fscF/gJHBrSYygCeIPNlBXjvVhde
	 WATXQnKvo0QSjGr4L+SElDNr66fQFgZrV49k9l7dvuHP4WtFfYyC8iW7R05sf5q0FKBBr
	 paPYNnib0Sq/EO6EuunORENnDvKe4ykuWlMO00GulFgXIkRYu5lUMkbFWIZktthok/HFx
	 zVnsVigK4IdgaHlWaZKcCRmGUvc7bDtp9nS1a0tf1MKYQCd5W5Z6VJllR/E6RwDH9+w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794941339;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=EBH8GWBE2ux0ZLech9LQWrX9OAnUt3MRaq8g2z5zn/A=;
	b=NZUpwgl88rW7nUUGRwMvVt/YtlWs7wy3XD7vdUCylpZ/U6hFIORHWKCK9tT4aksFDVRO
	 54Uj4x/RETPjqryA8ygN2+Jni7ZpXU4oQa0Z7vrVkENLde5w/pTCaxU98Gud2l43vmpNy
	 M0F6qNTkHqNWIEUEId/+rOogKt3mzCqSp76rO0sw/517h/XvLb5ch1fqegwKo8MJDllJl
	 DEliN/0PAnJSqq3efC5oi6mBh8UkBEeDNd7lyoFTGLUOlNqXDIFpB21yuTQkjFQS7GedB
	 5Ewtf7LbabnINTLGlHkho5eozpgj40NDPgO19QRav5eVnwK8HH1J2Bw1zYBb5XUg7fQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=dghtSMLa;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id B3EE9606A31C;
	Tue, 17 Nov 2026 18:48:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=dghtSMLa
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id D41EE1F000C7;
	Tue, 17 Nov 2026 18:48:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794941339;
	bh=EBH8GWBE2ux0ZLech9LQWrX9OAnUt3MRaq8g2z5zn/A=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=dghtSMLaGGyJ5qkER8V/xPxhL/adkndfHqymiKb5Hw/7dfqZg1jL4wCIfsST0G+AU
	 g2psE4L2ZUXtFK0gJsGF2+u6HoRvlBYppN4yxXuNW9ix+Nm22CsC/UE7R9qFo6tcGj
	 GOSvVgfmVGOSjQDxEn+C88zqKeko75i0Gmiq1YLpH8gqCyef3aYoX5AQseW+QVIO5d
	 zr4VOhkcIGVe7KSEDGMkaFPUY1+7+1DSIkC4aZgAtQI9WW7bG9NGMxtc62tAF83oH3
	 JRcpQjqRrP581VoOpArh/92vWjCZq6isBbEnAYFFb9AGjBZlduwtgfhNIUQrTVF6MI
	 yevfi9pzlIaHg==
Date: Tue, 17 Nov 2026 20:48:55 +0200
From: Jarkko Sakkinen <jarkko@kernel.org>
To: Andy Lutomirski <luto@amacapital.net>
Cc: linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org,
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org,
	linux-security-module@vger.kernel.org,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Andrew Morton <akpm@linux-foundation.org>,
	Ben Segall <bsegall@google.com>,
	Christian Brauner <brauner@kernel.org>,
	David Hildenbrand <david@kernel.org>,
	David Howells <dhowells@redhat.com>,
	Davidlohr Bueso <dave@stgolabs.net>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Ingo Molnar <mingo@redhat.com>, Jan Kara <jack@suse.cz>,
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
	Valentin Schneider <vschneid@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Vlastimil Babka <vbabka@kernel.org>
Subject: Re: [RFC PATCH 00/13] Namespace for namespace roots
Message-ID: <avyhl79pygUmV3hr@kernel.org>
References: <20261117050841.3289652-1-jarkko@kernel.org>
 <CALCETrUBUnJVhiMkft6hTZZMe8nTpMBRTGY2v=9x5ETBSvmPZQ@mail.gmail.com>
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
In-Reply-To: <CALCETrUBUnJVhiMkft6hTZZMe8nTpMBRTGY2v=9x5ETBSvmPZQ@mail.gmail.com>

On Tue, Nov 17, 2026 at 09:44:43AM -0800, Andy Lutomirski wrote:
> Can you clarify what this new API actually does?  I've read this three
> times, and the best understanding I've come up with is that you've
> designed a way to create a group of namespaces identified by an fd and
> you're adding an API to configure and enter them cleanly.  Which
> sounds very sensible.  But I'm completely confused as to why a
> namespace needs to be owned by a "rootns" or why that ownership
> affects even newly created sub-namespaces.

I think this would postulate the patch set:

1. A subset of detached namespaces.
2. A dedicated PID namespace for spawning into, signaling members, and
   polling/waiting on init exit.
3. Initially an empty mount mount namespace that must be populated
   before going live.

I had to do some head scratching for the second question as I've worked
seriously on this already some time ago but I think it was as follows.

If recall it correctly, rootns ownership tracking was meant to stop
processes inside a rootns from calling setns() into host or other
namespaces of the other containers.

However, user_namespace already enforces namespace ownership for
setns(), and adding a separate rootns check prevents legitimately
entering a shared external namespace (such as a pre-created netns).

I will drop the rootns ownership tracking.

> 
> --Andy
> -- 
> Andy Lutomirski
> AMA Capital Management, LLC

Br, Jarkko
