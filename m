Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795181422;
	b=K7WlMEesc0bVkGca6KDaWObv86lDAQOySfl6UUxafatRX2wNEVUnQKmsIUFs2v9laAMH
	 H+59n0hwoM9WLZBUNuy2GIiKpelQd1g3qrwruSctNVF4EPo7ezU3cImOHP8aIxJ093c4U
	 nCUnmoJwA2IXNckDJsEuuUzxJtnddNcxAHRZtHlduB13NkIrNX/kE+qq75i1dJquuAFUy
	 Qb2tBp4KUFqedwXYwY2FCR3MTVj54dLlDxrfzLJ6MYDferD+8anR2fbL+ouDR28BfgMz5
	 e6eeVGCbmTBLEWpGVNA9Rjdtkst9QJlHs1Rium9i/77gK3gZqH4Ae2Dqmy3jlI4cNyA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795181422;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:
	 Content-Transfer-Encoding:In-Reply-To;
	bh=r0yepTevnFJpzt2r2drCfhbGwH1m5XYOTRjJ/I5L2oA=;
	b=ZB9EAJvNAT+5sANvApeCGih4XfZ1uwKNFUcih+r94cEwI84hKIphc1cepilz2dV1c2qx
	 U5CmFTSgpModwMR607KKODkWC0duxwGbSb5KA8T0zFvj1OtEDxDFTPja9yCI7Y5YVuF9z
	 m96AUzx3MTZTtA6HH/tI0nP536RpUY944ncZf2TAInLAmF5BQUYf7BCQ7I4O+dew6pUnb
	 zRoyK8p1xfJXFvVwQyQvXKNY0fsi8yfBbSUDLjJNm0IwHjZKr6ycNhveMLaUvTU6e7jNt
	 BCyGVHSDetk/UUNpHEP/0N8W1WFDfRHMzAlBzEJgP/LVbyptWeUe9cxN4/l+o+i0Bqg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=LxHJ1pgZ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id 060D8606A320;
	Fri, 20 Nov 2026 13:30:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=LxHJ1pgZ
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 5BFB11F000D2;
	Fri, 20 Nov 2026 13:30:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795181421;
	bh=r0yepTevnFJpzt2r2drCfhbGwH1m5XYOTRjJ/I5L2oA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=LxHJ1pgZMRnjgm2kTX3LFJJa+QJ+pe4P0CEN40l/PzhoI4P8panaY+0Q3U0aDuZqY
	 d6XFuKi4YyOzKCDyY6Fpy81BvYcjjeknCdisgEAM6IWExeb3iW1nhJEJD4KaBAW+bD
	 r5iJicgG91dzqk9nzBZ8D2/JbAlMgawKAhCSuL3ug4K1sos2GJ4t7TiWGQh22c59DM
	 wVnhMwGWXmBTp2MeJ5zHRxb9ZPYDyJPmjlhQXY3V7wh+jRIoGhfeMZWEgSkpntxOIX
	 O5p3EmJ9RssCoXPKlmpEXhy+NrYqURd5KZrMIRYhlRKm4oS7b0Ay023KIpW8vNYQ1h
	 LgzIrz39Ee1bw==
Date: Fri, 20 Nov 2026 15:30:17 +0200
From: Jarkko Sakkinen <jarkko@kernel.org>
To: Alexander Mikhalitsyn <alex@amutable.com>
Cc: linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org,
	linux-arch@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org, linux-security-module@vger.kernel.org,
	Albert Ou <aou@eecs.berkeley.edu>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Alexandre Ghiti <alex@ghiti.fr>,
	Andreas Larsson <andreas@gaisler.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Andy Lutomirski <luto@amacapital.net>,
	Andy Lutomirski <luto@kernel.org>,
	Anna-Maria Behnsen <anna-maria@linutronix.de>,
	Arnd Bergmann <arnd@arndb.de>, Ben Segall <bsegall@google.com>,
	Borislav Petkov <bp@alien8.de>,
	Casey Schaufler <casey@schaufler-ca.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Christian Brauner <brauner@kernel.org>,
	"Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
	Chris Zankel <chris@zankel.net>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	David Hildenbrand <david@kernel.org>,
	David Howells <dhowells@redhat.com>,
	Davidlohr Bueso <dave@stgolabs.net>,
	"David S. Miller" <davem@davemloft.net>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Frederic Weisbecker <frederic@kernel.org>,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	"Hallgrimur H. Gunnarsson" <halg@google.com>,
	Heiko Carstens <hca@linux.ibm.com>, Helge Deller <deller@gmx.de>,
	"H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
	Jan Kara <jack@suse.cz>,
	John Johansen <john.johansen@canonical.com>,
	John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>,
	Jonathan Corbet <corbet@lwn.net>,
	Josef Bacik <josef@toxicpanda.com>,
	Juri Lelli <juri.lelli@redhat.com>, Kees Cook <kees@kernel.org>,
	K Prateek Nayak <kprateek.nayak@amd.com>,
	"Liam R. Howlett" <liam@infradead.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Magnus Lindholm <linmag7@gmail.com>,
	Manfred Spraul <manfred@colorfullife.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Matt Turner <mattst88@gmail.com>, Max Filippov <jcmvbkbc@gmail.com>,
	Mel Gorman <mgorman@suse.de>, Michael Ellerman <mpe@ellerman.id.au>,
	Michal Hocko <mhocko@suse.com>, Michal Simek <monstr@monstr.eu>,
	Mike Rapoport <rppt@kernel.org>, Neal Gompa <neal@gompa.dev>,
	Nicholas Piggin <npiggin@gmail.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Paul Moore <paul@paul-moore.com>, Paul Walmsley <pjw@kernel.org>,
	Pavel Tikhomirov <ptikhomirov@virtuozzo.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	Richard Henderson <richard.henderson@linaro.org>,
	Rich Felker <dalias@libc.org>,
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
	Russell King <linux@armlinux.org.uk>,
	Serge Hallyn <sergeh@kernel.org>,
	Shrikanth Hegde <sshegde@linux.ibm.com>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Sven Schnelle <svens@linux.ibm.com>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Thomas Gleixner <tglx@kernel.org>,
	Valentin Schneider <vschneid@redhat.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Vincenzo Frascino <vincenzo.frascino@arm.com>,
	Vlastimil Babka <vbabka@kernel.org>, Will Deacon <will@kernel.org>,
	Yoshinori Sato <ysato@users.sourceforge.jp>,
	Zygmunt Krynicki <zygmunt.krynicki@canonical.com>
Subject: Re: [RFC PATCH v4 03/14] rootns: Track init lifecycle via
 copy_process() and pid_namespace
Message-ID: <awBLafK4jqB8fTF2@kernel.org>
References: <20261119224312.1037966-1-jarkko@kernel.org>
 <20261119224312.1037966-4-jarkko@kernel.org>
 <e376c8f0ec5c50b417375197a5589a210f151d9b.camel@amutable.com>
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Post: <mailto:linux-api@vger.kernel.org>
List-Help: <mailto:linux-api+help@vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-api+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <e376c8f0ec5c50b417375197a5589a210f151d9b.camel@amutable.com>

On Fri, Nov 20, 2026 at 02:18:43PM +0100, Alexander Mikhalitsyn wrote:
> Dear Jarkko,
> 
> >  	acct_exit_ns(pid_ns);
> > +	exit_rootns(pid_ns, me);
> 
> We have a very similar mechanism around pidfd's to track exit
> information for a task. As far as I can see we already have (struct
> rootns *)->init_pid reference, so we can get exit information for free
> (look for PIDFD_INFO_EXIT).

Thanks for mentioning. I'll see if I can leverage it.

If something like this is found, it is partly due long history of this
code i.e., not planned/opionated choice :-) 

> 
> Kind regards,
> Alex

Br, Jarkko
