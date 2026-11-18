Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.222.176
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795013259;
	b=db3r9UUbGRgwOPAwpR6JuYxRZw7Cby3940t+16J93ATZYxBDTYfoSHOaw+ObApVfUXsS
	 JkBgEz7oP5qfK9d8Ci3LbB6+3R7m+kkyzOjKMM5Q7TThacXmXlayc7fUBloSn7t2hIFLK
	 b0inAHTrKaykcCySElkWOJvqkuMVbSL1YlmsjPo1+Yflc4HjGHmqf1zjYxONmQ5X9GOkg
	 GovvimMdUZotxbP4Qh/y1zXRI6Z1051u4vq2ugJDM9zRpkMjzoCuOa/1aKLeFRqhvx/d5
	 pjnzHEYBAGCHwikoxz8mEXWhv9JMj9FKXzUq8Lt/puYOPA3lnvKwvCsTAHBbikIjAPA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795013259;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To;
	bh=IgtmGgLwdp7YHZZLZXtmuM3LeEAEVVcvQiETOOFbu8o=;
	b=nT8cPYM/6Q+2cdq75HFR47DWtmQ0ySGuIWLKf0iuF4qOLW28nkfCEZWRod9rd8FPtApy
	 rmYKxKxRrbPo92zFOzVwRboRf459pwcpLl/W0+iAx7BBP5BgWLInKhQ2v3ck8tH4to8i/
	 39LAJrCCYX/+uHNU+l4UE9vV8vCFSfjB1yyi5PRAdmAmcnxF7yf61FFLKraoCjpbPcE+m
	 jOaaVnZiXg9Dwcy2GAzUZY6BryAyQl3rnivK0kZR7+rUkmDvmw3xkrTGz6XX60UiZJClb
	 +pzI+6ExCYYoZpiY89hGVPxrcaPhniMm54vxpljM/vr1PpRM8nW/1kWUM+MTpE4D/ng==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=toxicpanda.com;
	spf=pass smtp.mailfrom=toxicpanda.com;
	dkim=pass header.d=toxicpanda.com header.i=@toxicpanda.com header.a=rsa-sha256 header.s=google header.b=mce3LPT5;
	arc=none smtp.remote-ip=209.85.222.176
Received: from mail-qk1-f176.google.com (mail-qk1-f176.google.com [209.85.222.176])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16B2E606A331
	for <linux-api@vger.kernel.org>; Wed, 18 Nov 2026 14:47:38 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 16B2E606A331
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda.com header.i=@toxicpanda.com header.a=rsa-sha256 header.s=google header.b=mce3LPT5
Received: by mail-qk1-f176.google.com with SMTP id af79cd13be357-94961ed97bcso130465685a.1
        for <linux-api@vger.kernel.org>; Wed, 18 Nov 2026 06:47:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda.com; s=google; t=1795013258; x=1795618058; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=IgtmGgLwdp7YHZZLZXtmuM3LeEAEVVcvQiETOOFbu8o=;
        b=mce3LPT5oG7C8F/QlXxfra+ftcUqbbosr68KVWr4liElvzqRdfBEqD/aEKIHceO+Aj
         +7TrSS0VWnGw72sCUYxtMjkg2MrGffSmsRtSP06tlj7q26d8E2nSTu4Z0BSvWs0M5cd8
         KB4LmsGi40TprWi9Dp8BnOyTEmFGkNYhFFanczHDzzKTNXuNvSPbFVnO0PIil/6+GCbK
         TBiO4Rkq/COIB6DJcfaHVgLG+7qjvdh1LPzUR7FonRPcRWRDNzUcdJW0Rcnl2JL9lKHC
         h5D0d4zczwBfyJqPh8GSUOsTeJtA1998BdswYK4nrDfVV55D9/VxOJDtpGtoQt8e5N5W
         k9ew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795013258; x=1795618058;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=IgtmGgLwdp7YHZZLZXtmuM3LeEAEVVcvQiETOOFbu8o=;
        b=UhNgbu2PQ4sihAmjoLRkEDqnb0hdge/4n0g3Hv6ESIR28ZAgHqt3PkDxV/SA6u8oqP
         rh0Ji+2Um3dWGbn7+7FxXP30eR9DpDDKwCtAevBLiblk4038bRuWkf0IYuUPVmPGMbKf
         POhSwnVgN7bCdQ7FheeGpTBKN8hG7OTyqwjlVkSeSbovprmJvjwkX879HsfxmQKTMYZ7
         Odz7sCPkYFMj7Gm2KvWkbqes4036i8KsNHObA2mESisbj8LTYipGK/Ag/knuZfcB8j+l
         rXuTtaouguVbIRRMMc7XgqnD3mwqejK3d8KEw70/uOBqizuwkIXQL/WztIOe/pwR18V3
         oNSw==
X-Forwarded-Encrypted: i=1; AL+hErEkylEIlh+IfdFlWxSVXVYm32beHopenpIU1FOzcdhqD21Vul6tT6qBSTnoW/+WPtMR0tqr+aUMbhQ=@vger.kernel.org
X-Gm-Message-State: APuU4Z+xSuxubY6Q6rjrNhW/+2IifD5WGNtGM08wi4cXWDkkhsPfjgM3
	sCv5KUg4gz9dhlSvjmv4kZVyceP6/VnoPHKZVdWt0rw+dPBHl0tHipY7RKzAfG/En/I=
X-Gm-Gg: AYBFou19xBwNbUm+8hN8oknk2wbPCrPW6iZCeRn+loE/PAQ496/KFT/eVOW0KYjLYzF
	yj9wo3fbzM1H/cbLgFpBZuIYGDxRI2ONv03KHeRw0PW2bq0BQ6tjtt0npnsPIuCTQYJ2g3sx67V
	u618896dod7OXlX96H/3HRMpsyXlvL8/mUf19CkXgetm+CE+Rj3wUBE+zEDxhRwQ9/DecMqWMft
	3f6kXQVmYTjl6ZDjG78COlIHSXJr44GXm+7rAAISSt+vmVeMnGQMEcazaftbs/xRJqz8RfPFzej
	iOz6RpbERBsiDp7lv6F9lXQuHQ/4zgwYFBIyaGUoQTAMaaToPVz3zsCkE6OoJJHbl3Ut9HrUa1C
	zFrAPGQpcZivAAgKR/Yj1gZoroHk2hxslQphyJlwu4eDhK9X1ZzOD71S1lcHtyj4+pYL9xh6CzI
	UhO4vjupeXTzlwlxhHdb5DFMxWv9Pm6DyWv32bhC1ReV8UOkXPbOmnaBxLcGh6xWdeXAZeEW9md
	ETuuGGlIgjnw2c7BWjyXcRKRbmIZMq7ig9k0rmTJTiHQFXhTaQeHEDx/vYFUcJr0uaJg/ypIaFU
	K+Yi9R9atF/BgtDmWzYSNP+o3COcrVAbPQOkNd9yn+w+UFs=
X-Received: by 2002:a05:620a:880a:b0:93c:b5fd:f33f with SMTP id af79cd13be357-94999722106mr491978585a.27.1795013257845;
        Wed, 18 Nov 2026 06:47:37 -0800 (PST)
Received: from toxicpanda.com ([153.61.196.252])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-9499b81d4a0sm193898585a.43.2026.11.18.06.47.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Nov 2026 06:47:37 -0800 (PST)
Date: Wed, 18 Nov 2026 14:47:34 +0000
From: Josef Bacik <josef@toxicpanda.com>
To: Jarkko Sakkinen <jarkko@kernel.org>
Cc: linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-mm@kvack.org, linux-security-module@vger.kernel.org, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Andrew Morton <akpm@linux-foundation.org>, 
	Andy Lutomirski <luto@amacapital.net>, Ben Segall <bsegall@google.com>, 
	Christian Brauner <brauner@kernel.org>, David Hildenbrand <david@kernel.org>, 
	David Howells <dhowells@redhat.com>, Davidlohr Bueso <dave@stgolabs.net>, 
	Dietmar Eggemann <dietmar.eggemann@arm.com>, Ingo Molnar <mingo@redhat.com>, Jan Kara <jack@suse.cz>, 
	Jonathan Corbet <corbet@lwn.net>, John Johansen <john.johansen@canonical.com>, 
	Juri Lelli <juri.lelli@redhat.com>, Kees Cook <kees@kernel.org>, 
	K Prateek Nayak <kprateek.nayak@amd.com>, "Liam R. Howlett" <liam@infradead.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, Manfred Spraul <manfred@colorfullife.com>, 
	Mel Gorman <mgorman@suse.de>, Michal Hocko <mhocko@suse.com>, Mike Rapoport <rppt@kernel.org>, 
	Neal Gompa <neal@gompa.dev>, Paul Moore <paul@paul-moore.com>, 
	Pavel Tikhomirov <ptikhomirov@virtuozzo.com>, Peter Zijlstra <peterz@infradead.org>, 
	Randy Dunlap <rdunlap@infradead.org>, Serge Hallyn <sergeh@kernel.org>, 
	Shuah Khan <skhan@linuxfoundation.org>, Steven Rostedt <rostedt@goodmis.org>, 
	Suren Baghdasaryan <surenb@google.com>, Valentin Schneider <vschneid@redhat.com>, 
	Vincent Guittot <vincent.guittot@linaro.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Zygmunt Krynicki <zygmunt.krynicki@canonical.com>, alex@amutable.com
Subject: Re: [RFC PATCH v2 00/13] Namespace for namespace roots
Message-ID: <wdwc3b5edgtgvrgqfhlzhrachr5hrqb7ahipcuqdz5pffxlc5b@662cpwhxwjer>
References: <20261117231352.3816603-1-jarkko@kernel.org>
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
In-Reply-To: <20261117231352.3816603-1-jarkko@kernel.org>

On Wed, Nov 18, 2026 at 01:13:39AM +0200, Jarkko Sakkinen wrote:
> OVERVIEW
> ========
> 
> A root namespace (rootns) is a kernel object backed by a file descriptor
> that binds together:
> 
> 1. A full or partial set of detached namespaces.
> 2. A dedicated PID namespace for spawning processes into, signaling
>    members, and polling or waiting on PID 1 exit.
> 3. An initially empty mount namespace (CLONE_EMPTY_MNTNS) that must be
>    populated before going live, without inheriting host mount-tree
>    ancestors.

This is what cells is doing https://lwn.net/Articles/1102593/, you may
want to take a look at that work. Christian, Lennart, Alex, myself
and others are working towards this in a more wholistic way. There's a
lot more that goes into this outside of just the object itself. I've got
my version deployed inside Anthropic for securing containers and I've
tripped over a lot of pre-work that needs to come because we can tackle
this. Alex has my rough outline for kuid64 for example, which is
necessary for making sure we don't overlap UID's on the system and
create holes this way. The cells work/anything that wants to have clear
security boundaries is going to require that as a pre-requisite. If
you'd like I can include you in our planning so we can get something
that will solve all of our problems. Thanks,

Josef
