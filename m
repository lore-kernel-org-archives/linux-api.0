Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795288259;
	b=dbb1ZWMZgsnxv9QIlyzP3nN3vSt90EQLEyYgDovNQEeQENGUMz4GeKwSTgfjSFq28Ty1
	 B5MWeDLgQHgsoDBOFPVQBeU10MDkyC3n9XejgtLkGRUcVctDhLCugnBSYyAH1nq1oOAHV
	 rKartnaTO4aZ69oDBA2AONwSWPl9Ca3C9m31BQHroNl3wxPzo1cxj2Ntm+DL/0vNvLfnh
	 dov5GgF4BTYOq3Id7T+K7A7g2IZVu73vOyrYxs5+R2WJy8sNB2mzRhusJt2jrkeUuRHus
	 yQmfa60HECLQyVeHlhJi2DO7wRIh+j+gsy/vYMolNGpeTQg9ng0OMo3Oqh+2+CUVtxw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795288259;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=6ow9Xw7m3YEqTR1MIKUD5mHez4EOB5YhbjcdeDZUw2w=;
	b=aWNlVhHXFx8TmWjrxdkG0U1f7ci/0NHwXd7FKA5Afg8c5H7QfYJX3eoNuWkz7j2es4OK
	 2+NV+1yMUTngc1fbjDsdb3AQDgD2CdAQgMkY737UcqaDMPbQcOK5WJG4cC9MNheHSPXDx
	 xJfnxvYpn7lz2og/tMoCquq/66HXfTJzWVySYYgk5gIsthu/tAwQKovyeQxLH1Hn14oGb
	 Bx6+4LxggZtrJnHa+Gqu7YSLkCIsaAMGNr5O0gbwBzX6A3g5MSJuZ+9vW6Jdq2f8CQY/K
	 1ZhmSBTKle5W128UmKWH4/RidKBw75xd5+s/sHvsV4mT/pK1ENko5wOOuekrHI4SQEA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=IXVuogm5;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id 31237606A331;
	Sat, 21 Nov 2026 19:10:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=IXVuogm5
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 7792F1F000C4;
	Sat, 21 Nov 2026 19:10:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795288259;
	bh=6ow9Xw7m3YEqTR1MIKUD5mHez4EOB5YhbjcdeDZUw2w=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=IXVuogm5AmzeqYVSeKK45LIqxXSnmNzlRQhLbnpp/DOl3f1zkSIUhFKlzo1BKxucA
	 1n4pOf7fvG2ysLhBqbKKPKQ40fjvD/+RCc89Pn3FC34GLo1meaV7US384hKGg720GL
	 zTN39Od3nvrftfuqzmttAjhxmZ8OAHYMsFoJsuxQIOYi+5AtHmZDitJISN83yhuvZ7
	 C5cz36I0m/G+CslC7vHQZc2gDqh5XBIkcVNmnq7grN+CrSxpLQ3EZuD0Seh60RmCEn
	 xhylOpnoDC/9goxsijv5gq2jv7QI+VO5gaOc0nG2/c6yzMltjLvYmG27yBJusJvW2h
	 7KyizQv3JeDTw==
Date: Sat, 21 Nov 2026 21:10:55 +0200
From: Jarkko Sakkinen <jarkko@kernel.org>
To: linux-fsdevel@vger.kernel.org
Cc: linux-api@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org, linux-security-module@vger.kernel.org,
	Alexander Mikhalitsyn <alex@amutable.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Andy Lutomirski <luto@amacapital.net>,
	Christian Brauner <brauner@kernel.org>,
	David Howells <dhowells@redhat.com>, Jan Kara <jack@suse.cz>,
	Jonathan Corbet <corbet@lwn.net>,
	Josef Bacik <josef@toxicpanda.com>, Kees Cook <kees@kernel.org>,
	Neal Gompa <neal@gompa.dev>, Paul Moore <paul@paul-moore.com>,
	Serge Hallyn <sergeh@kernel.org>,
	Zygmunt Krynicki <zygmunt.krynicki@canonical.com>
Subject: Re: [RFC PATCH v5 13/25] rootns: Add rootns() system call
Message-ID: <awHsvz1vdlwsink0@kernel.org>
References: <20261121000844.1863324-1-jarkko@kernel.org>
 <20261121000844.1863324-14-jarkko@kernel.org>
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
In-Reply-To: <20261121000844.1863324-14-jarkko@kernel.org>

On Sat, Nov 21, 2026 at 02:08:32AM +0200, Jarkko Sakkinen wrote:
> Setting up an isolated namespace environment from a multithreaded
> manager process currently requires helper processes to call unshare()
> and pass file descriptors back over sockets.
> 
> Add the rootns() system call to allocate a detached rootns instance
> owning a fresh user namespace alongside dedicated empty mount
> (CLONE_EMPTY_MNTNS), PID, UTS, IPC, network, cgroup, and time
> namespaces, and return its control file descriptor. Finalize the nsproxy
> time namespace and pin active references for the lifetime of the rootns.
> 
> Co-developed-by: David Howells <dhowells@redhat.com>
> Signed-off-by: David Howells <dhowells@redhat.com>
> Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>

Syscall name is outdated. I'll rename it as container_create(). Does
not have to be final name, but is a better wip name.

Br, Jarkko
