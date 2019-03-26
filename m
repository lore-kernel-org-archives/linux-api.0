From: Christian Brauner <christian@brauner.io>
Subject: Re: [PATCH v1 2/4] pid: add pidctl()
Date: Tue, 26 Mar 2019 18:17:03 +0100
Message-ID: <20190326171702.smehtebw4e656ehl@brauner.io>
References: <20190326155513.26964-1-christian@brauner.io>
 <20190326155513.26964-3-christian@brauner.io>
 <20190326170601.GA101741@google.com>
 <20190326170827.p2wlwsscf5u6f3i7@brauner.io>
 <20190326171525.GA116974@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190326171525.GA116974@google.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Joel Fernandes <joel@joelfernandes.org>
Cc: jannh@google.com, khlebnikov@yandex-team.ru, luto@kernel.org, dhowells@redhat.com, serge@hallyn.com, ebiederm@xmission.com, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, arnd@arndb.de, keescook@chromium.org, adobriyan@gmail.com, tglx@linutronix.de, mtk.manpages@gmail.com, bl0pbl33p@gmail.com, ldv@altlinux.org, akpm@linux-foundation.org, oleg@redhat.com, nagarathnam.muthusamy@oracle.com, cyphar@cyphar.com, viro@zeniv.linux.org.uk, dancol@google.com
List-Id: linux-api@vger.kernel.org

On Tue, Mar 26, 2019 at 01:15:25PM -0400, Joel Fernandes wrote:
> On Tue, Mar 26, 2019 at 06:08:28PM +0100, Christian Brauner wrote:
> [snip]
> > > > +	struct pid *struct_pid;
> > > > +	pid_t result;
> > > > +
> > > > +	if (flags)
> > > > +		return -EINVAL;
> > > > +
> > > > +	switch (cmd) {
> > > > +	case PIDCMD_QUERY_PID:
> > > > +		break;
> > > > +	case PIDCMD_QUERY_PIDNS:
> > > > +		if (pid)
> > > > +			return -EINVAL;
> > > > +		break;
> > > > +	case PIDCMD_GET_PIDFD:
> > > > +		break;
> > > > +	default:
> > > > +		return -EOPNOTSUPP;
> > > > +	}
> > > > +
> > > > +	source_ns = get_pid_ns_by_fd(source);
> > > > +	if (IS_ERR(source_ns))
> > > > +		return PTR_ERR(source_ns);
> > > > +
> > > > +	target_ns = get_pid_ns_by_fd(target);
> > > > +	if (IS_ERR(target_ns)) {
> > > > +		put_pid_ns(source_ns);
> > > > +		return PTR_ERR(target_ns);
> > > > +	}
> > > > +
> > > > +	if (cmd == PIDCMD_QUERY_PIDNS) {
> > > > +		result = pidns_related(source_ns, target_ns);
> > > > +	} else {
> > > > +		rcu_read_lock();
> > > > +		struct_pid = get_pid(find_pid_ns(pid, source_ns));
> > > > +		rcu_read_unlock();
> > > > +
> > > > +		if (struct_pid)
> > > > +			result = pid_nr_ns(struct_pid, target_ns);
> > > > +		else
> > > > +			result = -ESRCH;
> > > > +
> > > > +		if (cmd == PIDCMD_GET_PIDFD && (result > 0))
> > > > +			result = pidfd_create_fd(struct_pid, O_CLOEXEC);
> > > 
> > > pidfd_create_fd already does put_pid on errors..
> > 
> > it also takes its own reference
> > 
> > > 
> > > > +
> > > > +		if (!result)
> > > > +			result = -ENOENT;
> > > > +
> > > > +		put_pid(struct_pid);
> > > 
> > > so on error you would put_pid twice which seems odd..  I would suggest, don't
> > > release the pid ref from within pidfd_create_fd, release the ref from the
> > > caller. Speaking of which, I added to my list to convert the pid->count to
> > > refcount_t at some point :)
> > 
> > as i said, pidfd_create_fd takes its own reference
> 
> Oh. That was easy to miss. Fair enough. I take that comment back.
> 
> Please also reply to the other comments I posted, thanks. Generally on LKML,
> I have seen there is an expectation to reply to all reviewer's review
> comments even if you agree with them. This helps keep the review going
> smoothly. Just my 2 cents.

I tend to do it in multiple mails depending on whether or not I need to
think about a comment or not.
