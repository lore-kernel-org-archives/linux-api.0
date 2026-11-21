Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795223354;
	b=1cgfRc6uqMdreq3dMa5ntzwiW6XrD2HJFxoy93W5U0DHxR9GXjbMv2fPmmXj0wyf/97z
	 vVSvUuxp73Cr2yz00/KVF6PnZaJjTWchYVaNctvqvuPwz0QzxKXQRe8LQhVCQ97ck03aZ
	 /qffB4g0aBFRgucHN8i3zT6UIpTDmdq9QREVVB504WBmFid+U3nrXqcEXIeIPwm6J7BOC
	 W4d3o/1IFWY5GPWQG+bX8s5EbIkevel6IHvazqMfoxW9Y9sccIaxOzN333neYpG62owLu
	 UJbiyuobu0AOIaTjnflnaqP4ZqIUgdkEN8G4Ikf/3wp1NKW9LTpEur9BYe3Z8V1aUfg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795223354;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=Dq4uYrhSligK2Yc6yPFlriNqvNi/HgVAWMNzxpJUth0=;
	b=Mk5/F8ZBXojmlehMhXENiqQDoXK4GvdiBRxKej6Cyo1ljQC+myGNMvppeourm79KxVC/
	 4fnbsmjoy6FVBgfkOD/w2My72SiAFbxiR5CBr3d52mS6eLbBofsGbhOVInkYG0itRlTIR
	 15Psp2CNkfqGNO7A4UqRMQ1V5LE/K+Qegq6D4oPZ+tZ8ZQc1Pw8J3Ss5Xte/qv/V/4xuq
	 OHPkUSe2zlrdBqrqsW0Biq/RYoa96DGrlELvDxM2CcKUYoZiNLEPgnu23Tn2edCP+p3EC
	 nqR3+jojs7ww+F9tzbrN4qRoWF0NO9/zwjbdZ3epawv8TnHzspgrAmV8zNdWKqmXrVA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=lev9yW6T;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id AAA82606A6A5;
	Sat, 21 Nov 2026 01:09:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=lev9yW6T
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id B4AB11F000C4;
	Sat, 21 Nov 2026 01:09:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795223354;
	bh=Dq4uYrhSligK2Yc6yPFlriNqvNi/HgVAWMNzxpJUth0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=lev9yW6T0RvL4iasvGrmNZTk4lNhOVNmBrF/T7i35at+a3FTHi7tKpepvNL2D7KTB
	 h0qDHLVue1JtkmyMZAHextD2GwOh4MT4ACttjuSgzOVEgr60lATGlJCU7IgUKx3fkQ
	 le6QElebQWnly9BHqqJBhk0mfDgCU4zh0d/cQGDUMeLmg4jEkVMHB1zy6d3QAGxqyV
	 O6YA0FvNSKhchFW6WlOSPRgLScQNvnzgAhLBKc9hq4A9SyGetfcf1watb19WTJdnrH
	 thztGrMxm54eA2/KEIAK0nkjpjH+bPpf3ylKRyhPpB9EbRccri3kJABFowAFM8KaY2
	 2lxX87Owry5ng==
Date: Sat, 21 Nov 2026 03:09:10 +0200
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
Message-ID: <awDvNgCFnMhOy3Y5@kernel.org>
References: <20261121000844.1863324-1-jarkko@kernel.org>
 <20261121000844.1863324-15-jarkko@kernel.org>
 <awDjC9hcKSRnCPgJ@kernel.org>
 <awDjQeXjqrhNHoWQ@kernel.org>
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
In-Reply-To: <awDjQeXjqrhNHoWQ@kernel.org>

On Sat, Nov 21, 2026 at 02:18:14AM +0200, Jarkko Sakkinen wrote:
> > Ought to be dropped but seemed too irrelevant detail for the time
> > being
> 
> I mean replaced with a syscall path.

Yeah, a lot better overall (less fallible paths).

+long rootns_waitid(int upid, struct waitid_info *infop, int options,
+                  struct rusage *ru)
 {
-       struct pid_namespace *pid_ns = task_active_pid_ns(current);
-       struct rootns_wait_args args;
+       struct pid_namespace *pid_ns;
+       unsigned int f_flags;
+       struct rootns *rootns;
+       bool nonblock;
+       int status;
+       kuid_t uid;
        long ret;

-       if (!uarg)
+       if (upid < 0 || ru)
                return -EINVAL;
-       if (copy_from_user(&args, uarg, sizeof(args)))
-               return -EFAULT;
-       if (args.flags & ~WNOHANG)
+       if (options & ~(WEXITED | WNOHANG | WNOWAIT))
                return -EINVAL;
+       if (!(options & WEXITED))
+               return -EINVAL;
+
+       CLASS(fd, f)(upid);
+       if (fd_empty(f) || !is_rootns_file(fd_file(f)))
+               return -EBADF;
+
+       f_flags = READ_ONCE(fd_file(f)->f_flags);
+       nonblock = (options & WNOHANG) || (f_flags & O_NONBLOCK);
+       rootns = fd_file(f)->private_data;
+       pid_ns = task_active_pid_ns(current);
+
        if (!pidns_is_ancestor(rootns->ns->pid_ns_for_children, pid_ns))
                return -ECHILD;
        if (READ_ONCE(rootns->state) == ROOTNS_INIT)
                return -ECHILD;

-       if (!(args.flags & WNOHANG)) {
+       if (!nonblock) {
                ret = wait_event_freezable(rootns->waitq,
                                           READ_ONCE(rootns->state) == ROOTNS_DEAD ||
                                           READ_ONCE(rootns->state) == ROOTNS_INIT);
@@ -154,15 +191,23 @@ static long rootns_wait(struct rootns *rootns, void __user *uarg)
                if (rootns->state == ROOTNS_INIT)
                        return -ECHILD;
                if (rootns->state != ROOTNS_DEAD)
-                       return 0;
+                       return (options & WNOHANG) ? 0 : -EAGAIN;
                ret = pid_nr_ns(rootns->init_pid, pid_ns);
                if (ret <= 0)
                        return -ECHILD;
-               args.status = rootns->exit_code;
+               status = rootns->exit_code;
+               uid = rootns->init_uid;
        }

-       if (copy_to_user(uarg, &args, sizeof(args)))
-               return -EFAULT;
+       if ((status & 0x7f) == 0) {
+               infop->cause = CLD_EXITED;
+               infop->status = status >> 8;
+       } else {
+               infop->cause = (status & 0x80) ? CLD_DUMPED : CLD_KILLED;
+               infop->status = status & 0x7f;
+       }
+       infop->pid = ret;
+       infop->uid = from_kuid_munged(current_user_ns(), uid);
        return ret;
 }

Br, Jarkko
