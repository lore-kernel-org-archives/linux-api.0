Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795026190;
	b=ijhw2C9JvKQNQbTH/qbKcCeOmdfZAiULIYL3vz518z3KJBNbE2MgIpCjBspyULZFjxsd
	 6mKfOrrw0aVYCCCuzJ2oIox3lzHW7xwmW56ufKwZC1vh0LAnJtQo8fDmETJUygX6kSTVc
	 zk7UHYmqiJKq5q48JZYvqN0OmejFitemse+MNC2i+yfSSlTGNZyGELC8J4gYpL5BG4a0z
	 7WbloL2kkf35w8LSOMOk85zBC7LqR8lB0Fs0napYRen/hv4mrP80S0SQLp4MTcpd2i8pF
	 i2rJTHsw/18lw62DkIqXWIBn2sqhCNJfJ6+57hWQGp7d9DZC44pUPA7etqMlDq6SAOA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795026190;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:
	 Content-Transfer-Encoding:In-Reply-To;
	bh=foArwJppdw7wxwAIXrJloa09SFBAq+aNRAw3uRfRo00=;
	b=gKJySiLWvCbKmRGb1s3OjUxYuSdEhi8fLUnkrQzC6DQmC73ZH3gZRmNhGPy8vxKhcoiF
	 QD7+BAAeQGZo5rBUH073kO7BsZeaj4mdDfsZqtXH753/UMFLBFY46WEeZTAsPudce6THr
	 yTj7Xh39PgW5/G0mXCfHrd4b+i510ECr6ka2PegzbEdTObLd2Q5HdIbkgej1thV3IW9wi
	 0qjn7/bW1Tq+JbMoFNrgcwG5TRdrCWjpfYjMhhqqQA0vU/4js9aSr80qwtk1Zh11Ie/js
	 yG8yRN6wiGWpq9CTr5jT41t9XZLoqik1CUfBV/gt6AiIzSdZVBd4sK7tRDnHbZDjNJw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=SSexoLIK;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id E676360A2601;
	Wed, 18 Nov 2026 18:23:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=SSexoLIK
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 6DD3E1F000C5;
	Wed, 18 Nov 2026 18:23:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795026189;
	bh=foArwJppdw7wxwAIXrJloa09SFBAq+aNRAw3uRfRo00=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=SSexoLIKwBoPiLX/UCNvXMAvv4Xqx3dXaulr2O2mznCKKpg7Gl+XFyR5jDdZdWAUN
	 Bm2Ym5u52HNVVRFXbz+lZpqqUqdI0QIVX/BnBolTVOjdqbWIRa9ZL/AQfHb7tP0tHy
	 Bo3R6lGQHJTvQrtUZUBLV22APvmXIw2J9PMILe+xCzHOUZKAi5UWfm9zvRyK2Mg+0I
	 M+H6ts9MMhrB3C9VnwqV5X6yDzwsL/MkVrIZfX8RVMJAzd9mqBMK3WoZuQhU6CTmSZ
	 37+m6Xg9yYUbnkS2hE09G723J8T6okkYA03L/UmQUJFycH5/CD9SmRDukHGn7s1/6U
	 Jq9Ur6XjHy3ig==
Date: Wed, 18 Nov 2026 20:23:05 +0200
From: Jarkko Sakkinen <jarkko@kernel.org>
To: Andy Lutomirski <luto@amacapital.net>
Cc: josef@toxicpanda.com, linux-fsdevel@vger.kernel.org,
	linux-api@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org, linux-security-module@vger.kernel.org,
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
	John Johansen <john.johansen@canonical.com>,
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
	Vlastimil Babka <vbabka@kernel.org>,
	Zygmunt Krynicki <zygmunt.krynicki@canonical.com>
Subject: Re: [RFC PATCH v2 00/13] Namespace for namespace roots
Message-ID: <av3tCT5lQTu7qBMz@kernel.org>
References: <20261117231352.3816603-1-jarkko@kernel.org>
 <CALCETrVUkbpoFjwSAejyA4b_9qEauAP_36i=O8Op1ifp8aUkqA@mail.gmail.com>
 <av3akYFOYaeQZauZ@kernel.org>
 <av3bkDnwmjunTleX@kernel.org>
 <CALCETrXPLeUgxyhjP4XuWS46FKB0TUHF5PcMkdMf+qeEXbyXRA@mail.gmail.com>
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
In-Reply-To: <CALCETrXPLeUgxyhjP4XuWS46FKB0TUHF5PcMkdMf+qeEXbyXRA@mail.gmail.com>

On Wed, Nov 18, 2026 at 09:46:02AM -0800, Andy Lutomirski wrote:
> On Wed, Nov 18, 2026 at 9:08 AM Jarkko Sakkinen <jarkko@kernel.org> wrote:
> >
> > On Wed, Nov 18, 2026 at 07:04:21PM +0200, Jarkko Sakkinen wrote:
> > > On Wed, Nov 18, 2026 at 08:59:39AM -0800, Andy Lutomirski wrote:
> > > > On Tue, Nov 17, 2026 at 3:14 PM Jarkko Sakkinen <jarkko@kernel.org> wrote:
> > > > >
> > > > > OVERVIEW
> > > > > ========
> > > > >
> > > > > A root namespace (rootns) is a kernel object backed by a file descriptor
> > > > > that binds together:
> > > > >
> > > > > 1. A full or partial set of detached namespaces.
> > > > > 2. A dedicated PID namespace for spawning processes into, signaling
> > > > >    members, and polling or waiting on PID 1 exit.
> > > > > 3. An initially empty mount namespace (CLONE_EMPTY_MNTNS) that must be
> > > > >    populated before going live, without inheriting host mount-tree
> > > > >    ancestors.
> > > > >
> > > > > Work on this feature started in 2025 from David Howells' container object
> > > > > patch set [1], which I turned into a namespace for namespace roots and
> > > > > rebuilt around that premise.
> > > > >
> > > > > While the patch set is manually written, the original motivation came
> > > > > from isolating LLM agents. Running untrusted agent workloads made it
> > > > > clear that OCI runtimes need to minimize their live configuration
> > > > > surface.
> > > > >
> > > > > Assembling mounts, credentials, and namespaces inside helper processes
> > > > > with a half-configured container is what I see as the main challenge,
> > > > > and the existential debate around namespaces and container objects is an
> > > > > unfocused discussion topic.
> > > >
> > > >
> > > > I've skimmed some of the series, and I see a bunch of good ideas that
> > > > involve using an fd to manage a thing.  But I'm wondering how much of
> > > > the value is added by that and how much is added by having a new
> > > > *type* of thing: the "rootns".
> > > >
> > > > How much of the value comes from the rootns vs the new APIs to
> > > > configure namespaces without entering them first?
> > > >
> > > > For that matter, the cells series also seems to contain a (possibly
> > > > very similar) variant of the same thing.
> > > >
> > > > Would it make sense to come up with a patchset that does *just* the
> > > > configure-a-namespace-by-fd part?  It seems to me that this should be
> > > > an easier thing to agree on, and it's a big part of the complexity of
> > > > all of this, and it solves a real problem even without
> > > > cells/rootnses/jails/whatever.
> > >
> > > Is it  more accurately scope the part that is "just the fd-part" and
> > > what you consider as "extra cruft"?
> 
> I'm not actually trying to say that anything is "extra cruft".  What I
> mean is: there seems to be somewhat of a core that is pretty similar
> between the two patchsets, and that core seems independently useful.
> 
> > >
> > > I.e., where do you draw the border?
> >
> > I'm asking this because I had similar thoughts when I started this back
> > in 2025. David had some good ideas but it did more than having a fd
> > that does not go live before everything is set up properly.
> 
> I don't know that I have a very clear border, but here's an example:
> 
> rootns has MOVE_MOUNT_T_ROOTNS_ROOT.
> 
> cells has:
> 
> +What else goes into the tree is mounted on it before it becomes a
> mount namespace.  A
> +filesystem for the cell to write to is mapped in the same way:
> +
> +.. code-block:: c
> +
> +   fs = fsopen("tmpfs", 0);
> +   fsconfig(fs, FSCONFIG_SET_STRING, "mode", "1777", 0);
> +   fsconfig(fs, FSCONFIG_CMD_CREATE, NULL, NULL, 0);
> +   mnt = fsmount(fs, 0, MOUNT_ATTR_NOSUID | MOUNT_ATTR_NODEV);
> +   mount_setattr(mnt, "", AT_EMPTY_PATH, &attr, sizeof(attr));
> +   move_mount(mnt, "", tree, "tmp", MOVE_MOUNT_F_EMPTY_PATH);
> 
> (Source: https://lore.kernel.org/all/20261105-b4-cells-v3-2-bc9095937a84@toxicpanda.com/)
> 
> I feel like you are both *so close* to something that would stand
> alone and make perfect sense.  I also feel like, if that's a goal,
> then both series are slightly off from the bulls-eye.  (Keep in mind
> that I've spend a total of about ten minutes looking at the relevant
> parts of the series.)

Thanks, there was still a lot of relevant feedback to address.

And who knows, perhaps there's a sweet spot intersection. I would not
mind that, as I only pursue for something simple and practical.

For the time being, I'll update this series simply because there's less
to change, and polish the implementation. That does not hurt even if
cells were the ultimate solution. Part of this series can still be
useful.

> 
> 
> -- 
> Andy Lutomirski
> AMA Capital Management, LLC

Br, Jarkko
