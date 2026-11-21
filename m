Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795260258;
	b=3BSIjyjV35iqqK2sNXbZSPj/NfH4zXVTzhhWVqpI8Z/HsyYZUnaAVZz0FQj2htGQHt7g
	 yKKi28yQOe2cxFuth9ls58EEvr+jJo/wLuSJGvBvEurUwB1nASjfPvswVIwUpRNtlFsSn
	 IuJALcXm7LrlzQrAQxV2PXZzftK7hfFaMBfeClaKdexjUK2UoU+G+oj4uaZ3o5OGPa5Bb
	 YzE4m66CavpoWT+jGZwWkVNhotrIcJD1a8Tlw+t/d0efPqTi4dQcld8JwCP6j7fq7IRvH
	 KiQ/DlUT5doe1AmPyBcKaIWVPhlM3l6PXtkGZpmpUa59nvUOXn5Hip5sy6BRAZgm4mw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795260258;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=GHbQtC6gIc0jGnYZ6s00mCvjyoI1Kvae0ypDCzK5JU0=;
	b=fYqbib2n19WMsoWLd0nftQhaGf5q6ZRQFDwbGA+lufDzrw5YxIyM8Be/Ow0v1uTBtKAf
	 x3Dvx/OuFC8wTu68W2XRYIoZ6igDGAcGVTMf3feTBaBgKeBRJsNFmI8bvXhOUWh6zNBg4
	 m7XQcDDcEaMZhGGcDdM68zc4gLjvmmPHozgOH5W4nuZMz8cqsUWg+QYd4nFvPIp+evD3s
	 g23lj5ME/SOqtnOhEaeuPxpbeR2EW/TPha2oCh+FRThV6mjDrN/5oIpPBfo+zUk1FqvWs
	 Fu5miR0fnEsA89ncYHlZ3fGH3DHYEvm5hAq5nFeUQs3Paqhqe5E3QyoOzryYuDcuIng==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=mB0YRm3j;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id BD9AF606A320;
	Sat, 21 Nov 2026 11:24:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=mB0YRm3j
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id EFF371F000C4;
	Sat, 21 Nov 2026 11:24:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795260258;
	bh=GHbQtC6gIc0jGnYZ6s00mCvjyoI1Kvae0ypDCzK5JU0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=mB0YRm3jiQg6+dAG4Uh+kh+x0CIpL21NhV92OyKjRc4Nza2T3tFWotVyy2F3LVDkP
	 TDWkq9Ns3VJKWe9ABDZH8j4zYwrx7d9HbeCjrlBUun5+r7vTyh0N/tLEKFB5z8ICp8
	 qxYpXHkhVSTOh/LCRPqYeZKg+ZB7e4/9BbBfT5R9OcvwUtzYXz4ilD9CAeuOvXx81g
	 Dp8xUFM1/TAxBbErZPKEA/4uf/7MxVON2JR7/HEbHbLOa29JUDaZ2np/MQ/wBSCjBn
	 X1ArG35BUmmZXAPBQRSM66IPm6GHxeW8BlPy0LNZdkeKdtQiZyQ44rkuf+WoHNXFGO
	 8tMX0FG52frPQ==
Date: Sat, 21 Nov 2026 13:24:14 +0200
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
Subject: Re: [RFC PATCH v5 15/25] rootns: Add ROOTNS_KILL ioctl
Message-ID: <awF_XiObSZVSARoh@kernel.org>
References: <20261121000844.1863324-1-jarkko@kernel.org>
 <20261121000844.1863324-16-jarkko@kernel.org>
 <awDxps7uLbikjV5B@kernel.org>
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
In-Reply-To: <awDxps7uLbikjV5B@kernel.org>

On Sat, Nov 21, 2026 at 03:19:38AM +0200, Jarkko Sakkinen wrote:
> On Sat, Nov 21, 2026 at 02:08:34AM +0200, Jarkko Sakkinen wrote:
> > Signaling every process inside a container from userspace via /proc is
> > racy against concurrent fork() calls.
> > 
> > Add the ROOTNS_KILL ioctl to require an ancestor active PID namespace,
> > walk the root namespace's PID namespace IDR under tasklist_lock, and
> > deliver a validated signal once to each thread group including in-flight
> > forks, aggregating per-process delivery results.
> > 
> > Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
> 
> Will be gone i.e., can do also  pidfd_send_signal(fd, signum, NULL, 0).

Wiring:

        case PIDFD_SELF_THREAD_GROUP:
                pid = get_task_pid(current, PIDTYPE_TGID);
                type = PIDTYPE_TGID;
                break;
        default: {
                CLASS(fd, f)(pidfd);
                if (fd_empty(f))
                        return -EBADF;

                if (is_rootns_file(fd_file(f)))
                        return rootns_send_signal(fd_file(f), sig, info, flags);

After this only ROONTS_GET_NSFD remains.

Br, Jarkko
