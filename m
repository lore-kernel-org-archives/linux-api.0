Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795220240;
	b=PW84MX+h+ULsm9wVpNYY/R0K+3cfRlZTCQolQPoAoFUmYDaw8aRNlqH5/Rh0sw0niX14
	 +I8BvjRVSWeddbTQyDzjMv9WS3WKPuzVdd3tXYaixGeaV/ftI6UzqUMhA53Q0ESrYySia
	 tlk88CQfp19QtzsImY8hcs5y4J2mW/KVbQjT4GL9uA8Z4DZXY3n9FRusKc1R1tYidmh2t
	 xIF41FbpvUjV4nUiJDhdrRu2FKHri9v0+a0t2wslKcbT5tlXdnl0kTayGdsa2vGQSvstR
	 9Xaw0908BSZQbaYLM5T7Zof4iTJA1gfTlKABf9fvE0G2pBU850Zerguf46eUg6lIsCw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795220240;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=FEn70tv1tCk2ukkH1jBhHBKffDpYRYRuAeEkGin2NqU=;
	b=25EqLXewxMc7Zc7HsQuUoHr0CGuLCecp9tw/XNMHBumuNIIv1eLkYWiY8eGcHyVLpGPM
	 p1vzvD7Pb+HVUdBPF/rxZWrCFNWDTP3Ueib1MJEnnUlZR5nxdt3lDo/NfacNjSyemQJ2I
	 xU0D5K+p1rYq1Es2ZM5u86lQVs81pY6/kL6WjWXg6FNebpF5Z2VDPk0gMBFtQclO7pQgO
	 lm7XDoUocvVeA5V73KsPFLqmInJU/Oqto/ixVwBJshGnmbL7WsL6Ccp5btEgX+HEiqHos
	 GPmKsSmAav4IUt7PXRhEkTiG1VYfMWL4Jhsxkx42wdhD9jo4OPnRgLRNMHaH1y7qGNA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ETsWsP6A;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id E98C7606A6AC;
	Sat, 21 Nov 2026 00:17:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ETsWsP6A
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 9CB651F000C0;
	Sat, 21 Nov 2026 00:17:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795220239;
	bh=FEn70tv1tCk2ukkH1jBhHBKffDpYRYRuAeEkGin2NqU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=ETsWsP6AHNHJbGwRscL2DvfHX26AYuoh1QNquJp7jVI5sMeKpNtDKz2tAKn5J3Zud
	 JXfLk36uOX4UHBL4JWqqA/Nx0rJZQlCxFi1lkQHtnEouytFMhUV88/2cwtZvvnc1EW
	 nL7LyVSfmtnN0dQ9rb+1lfeQJJa4XxRUJmu/4reYQlTdvxGVSZRxcFGEGXHCZa0AOA
	 K/h0ycJYeU3AYzhoTmbI9Es1yLLl8XRItcMKjCh87MgFbiMKo+UyQWX4EIL9TqqqOE
	 wgvWDMIPEi6CVs5ybIRFSa03/mO34Ruo7GCtRFy4z1mH34uhMx7vnC01H8tst2nIKR
	 6tgJNMo0prJlA==
Date: Sat, 21 Nov 2026 02:17:15 +0200
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
Subject: Re: [RFC PATCH v5 14/25] rootns: Add ROOTNS_WAIT ioctl
Message-ID: <awDjC9hcKSRnCPgJ@kernel.org>
References: <20261121000844.1863324-1-jarkko@kernel.org>
 <20261121000844.1863324-15-jarkko@kernel.org>
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
In-Reply-To: <20261121000844.1863324-15-jarkko@kernel.org>

On Sat, Nov 21, 2026 at 02:08:33AM +0200, Jarkko Sakkinen wrote:
> wait4() and waitid() only allow a parent or subreaper to collect exit
> status, so an external manager holding a rootns file descriptor cannot
> wait on a rootns init process forked by another process or observe exit
> status multiple times across observers.
> 
> Add the ROOTNS_WAIT ioctl and struct rootns_wait_args to wait freezably
> and interruptibly on a rootns file descriptor until its init thread group
> exits and report the recorded wait status. Return the init TGID
> translated into the caller's active PID namespace, 0 for WNOHANG while
> running, or -ECHILD if init was never started or is not visible to the
> caller.
> 
> Co-developed-by: David Howells <dhowells@redhat.com>
> Signed-off-by: David Howells <dhowells@redhat.com>
> Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
> ---
>  include/uapi/linux/rootns.h | 26 +++++++++++++++++++++
>  kernel/rootns.c             | 46 +++++++++++++++++++++++++++++++++++++
>  2 files changed, 72 insertions(+)
> 
> diff --git a/include/uapi/linux/rootns.h b/include/uapi/linux/rootns.h
> index bd643bdfb43c..3fd215185398 100644
> --- a/include/uapi/linux/rootns.h
> +++ b/include/uapi/linux/rootns.h
> @@ -8,6 +8,7 @@
>  #define _UAPI_LINUX_ROOTNS_H
>  
>  #include <linux/ioctl.h>
> +#include <linux/types.h>
>  
>  /**
>   * enum rootns_flags - Flags for rootns()
> @@ -24,6 +25,16 @@ enum rootns_flags {
>  	ROOTNS_ALL_FLAGS	= 0x00000003,
>  };
>  
> +/**
> + * struct rootns_wait_args - Arguments for %ROOTNS_WAIT
> + * @flags: Wait options (0 or %WNOHANG).
> + * @status: Output wait status of rootns init in waitpid(2) format.
> + */
> +struct rootns_wait_args {
> +	__u32 flags;
> +	__s32 status;
> +};
> +
>  #define ROOTNS_IOCTL_MAGIC	0xB9
>  
>  /**
> @@ -41,4 +52,19 @@ enum rootns_flags {
>   */
>  #define ROOTNS_GET_NSFD		_IO(ROOTNS_IOCTL_MAGIC, 0x01)
>  
> +/**
> + * DOC: ROOTNS_WAIT
> + *
> + * ``ioctl(rootnsfd, ROOTNS_WAIT, &args)`` waits interruptibly (unless
> + * ``WNOHANG`` is set in ``args.flags``) until ``rootnsfd`` reaches
> + * ``ROOTNS_DEAD``, then writes the recorded exit status of ``rootns`` init
> + * into ``args.status``.
> + *
> + * Returns the caller-visible TGID of ``rootns`` init on success, ``0`` if
> + * ``WNOHANG`` is set and the ``rootns`` has not terminated, or ``-1`` with
> + * ``errno`` set to ``ECHILD`` if init was never started or is not visible in
> + * the caller's active PID namespace.
> + */
> +#define ROOTNS_WAIT		_IOWR(ROOTNS_IOCTL_MAGIC, 0x02, struct rootns_wait_args)
> +
>  #endif /* _UAPI_LINUX_ROOTNS_H */
> diff --git a/kernel/rootns.c b/kernel/rootns.c
> index 5d59fc9a591d..cb74ddc8363c 100644
> --- a/kernel/rootns.c
> +++ b/kernel/rootns.c
> @@ -117,6 +117,47 @@ static long rootns_get_nsfd(struct rootns *rootns, unsigned long nstype)
>  	return nsproxy_open_namespace(rootns->ns, rootns->user_ns, nstype);
>  }
>  
> +static long rootns_wait(struct rootns *rootns, void __user *uarg)
> +{
> +	struct pid_namespace *pid_ns = task_active_pid_ns(current);
> +	struct rootns_wait_args args;
> +	long ret;
> +
> +	if (!uarg)
> +		return -EINVAL;
> +	if (copy_from_user(&args, uarg, sizeof(args)))
> +		return -EFAULT;
> +	if (args.flags & ~WNOHANG)
> +		return -EINVAL;
> +	if (!pidns_is_ancestor(rootns->ns->pid_ns_for_children, pid_ns))
> +		return -ECHILD;
> +	if (READ_ONCE(rootns->state) == ROOTNS_INIT)
> +		return -ECHILD;
> +
> +	if (!(args.flags & WNOHANG)) {
> +		ret = wait_event_freezable(rootns->waitq,
> +					   READ_ONCE(rootns->state) == ROOTNS_DEAD ||
> +					   READ_ONCE(rootns->state) == ROOTNS_INIT);
> +		if (ret)
> +			return ret;
> +	}
> +
> +	scoped_guard(spinlock, &rootns->lock) {
> +		if (rootns->state == ROOTNS_INIT)
> +			return -ECHILD;
> +		if (rootns->state != ROOTNS_DEAD)
> +			return 0;
> +		ret = pid_nr_ns(rootns->init_pid, pid_ns);
> +		if (ret <= 0)
> +			return -ECHILD;
> +		args.status = rootns->exit_code;
> +	}
> +
> +	if (copy_to_user(uarg, &args, sizeof(args)))
> +		return -EFAULT;
> +	return ret;
> +}
> +
>  static long rootns_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
>  {
>  	struct rootns *rootns = file->private_data;
> @@ -124,6 +165,8 @@ static long rootns_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
>  	switch (cmd) {
>  	case ROOTNS_GET_NSFD:
>  		return rootns_get_nsfd(rootns, arg);
> +	case ROOTNS_WAIT:
> +		return rootns_wait(rootns, (void __user *)arg);
>  	default:
>  		return -ENOIOCTLCMD;
>  	}
> @@ -134,6 +177,8 @@ static long rootns_compat_ioctl(struct file *file, unsigned int cmd,
>  				unsigned long arg)
>  {
>  	switch (cmd) {
> +	case ROOTNS_WAIT:
> +		return rootns_ioctl(file, cmd, (unsigned long)compat_ptr(arg));
>  	case ROOTNS_GET_NSFD:
>  		return rootns_ioctl(file, cmd, arg);
>  	default:
> @@ -328,3 +373,4 @@ SYSCALL_DEFINE1(rootns, unsigned int, flags)
>  
>  	return fd;
>  }
> +
> -- 
> 2.47.3
> 

Ought to be dropped but seemed too irrelevant detail for the time
being.

Br, Jarkko
