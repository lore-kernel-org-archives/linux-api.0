Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795188276;
	b=RfAFeDH1PfbhtfH2Bh/YaxGqKegF7yDFH95Z1b8df+ItcZWkUvuylINwZgBRkv6qm5on
	 D3h1ikB5f5QwQBNVknf16//xcRnXCGn5EJpq4lm0DCk8garWyV71H6D75D6AdsnLLR6AU
	 3QtN0Tzq90qerFr6Ng1JjfTuZYvjaCeb8OSdIH9KwdSfHtKH5YBwVmQdbZqXaq0je7muM
	 kV/WfR/omefUc6cXvBrK9bM77zdpCFoAmtgZ+Fpkwe0d4CVScJrZz0XUj8Qu5z5qte6UB
	 0w8sDsO8XID522AXeq+wkvOgF2KJ6EiyxDgBzk0A4U41EyhpvzFDSeDnY5tFcpX0Cfg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795188276;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:
	 Content-Transfer-Encoding:In-Reply-To;
	bh=zOo2EfGngcl3fu/kIhqZadaO75pP0lk1DR/lRHlyrtU=;
	b=3Bf/JDupGMB0NF5YT0guaBMQxASzyBt8w/bQYuZjpy4pLXvc+1ZMyFO9n8Eev5Ed6Alx
	 4Y7MlAXroEFDChrhA0V7TYlbTNnQKvpgcH3nTww9GJ+kb1Tfjbiohr3ZglABng4Kdh5l2
	 9iwPgdwu2OaDjYcbe9Zszk4crOqJ4hHKxZe+bcxYqgvAa5efSUBO+33YuHvzuCgBjiaBz
	 ETVN/fdmBwFGMjRFpx/o1Vl9SwdSSq2kSbCnJxpM3nU067pguiwACOZxEYHmK3ZLW4kg8
	 5Pyljq0m9B4+A3HhzhGgRqznESzl+j6HVugTTO0IJiWzmdRO+Xz99CjZcXXH5PLORHA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=XCQUtSSf;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id 1ADE6606A320;
	Fri, 20 Nov 2026 15:24:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=XCQUtSSf
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 9CC851F000CA;
	Fri, 20 Nov 2026 15:24:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795188275;
	bh=zOo2EfGngcl3fu/kIhqZadaO75pP0lk1DR/lRHlyrtU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=XCQUtSSf00g2G/Jpzjl9LRNQEFXNNRnYGZWzdtuiZBHk7dosmqWBMrC+L7eGsuwT3
	 6Y8qXJypfh+8W03R5Msm4iQvi0clPna6Y5oqS1fK2fMBPqPJtncagCqPrZrgwYA61c
	 Ir7DESMb/dns84I6WWtY5IQnf73sTx8SIKL9bvZjYjcc9pfyT2D4A8Rsc/CYWyagj2
	 DltATLAp/YBb7+MwnvRYS7P7+HT3f1+jlJHOL7W4kb+l4QjcUeVm9fOWhMSveLYD4Q
	 IO8nsOvMP1W4FNm+RhhQIMrsrDM1nc6imjdTxfwsnAexYb35pl8AoQ1Ir88SqmYiNe
	 v0OZ/2yfr0Tjg==
Date: Fri, 20 Nov 2026 17:24:31 +0200
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
Message-ID: <awBmL_4VqwinHuVN@kernel.org>
References: <20261119224312.1037966-1-jarkko@kernel.org>
 <20261119224312.1037966-4-jarkko@kernel.org>
 <e376c8f0ec5c50b417375197a5589a210f151d9b.camel@amutable.com>
 <awBLafK4jqB8fTF2@kernel.org>
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
In-Reply-To: <awBLafK4jqB8fTF2@kernel.org>

On Fri, Nov 20, 2026 at 03:30:21PM +0200, Jarkko Sakkinen wrote:
> On Fri, Nov 20, 2026 at 02:18:43PM +0100, Alexander Mikhalitsyn wrote:
> > Dear Jarkko,
> > 
> > >  	acct_exit_ns(pid_ns);
> > > +	exit_rootns(pid_ns, me);
> > 
> > We have a very similar mechanism around pidfd's to track exit
> > information for a task. As far as I can see we already have (struct
> > rootns *)->init_pid reference, so we can get exit information for free
> > (look for PIDFD_INFO_EXIT).
> 
> Thanks for mentioning. I'll see if I can leverage it.
> 
> If something like this is found, it is partly due long history of this
> code i.e., not planned/opionated choice :-) 

This non-doable or incompatible at least. I'm not sure if that would
have gain. I think this goes to acceptable redundancy. Or at least,
currently think this way.

Br, Jarkko
