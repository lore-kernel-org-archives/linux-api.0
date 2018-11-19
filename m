From: Christian Brauner <christian@brauner.io>
Subject: Re: [PATCH v1 2/2] signal: add procfd_signal() syscall
Date: Mon, 19 Nov 2018 22:21:28 +0100
Message-ID: <20181119212126.u2nkijmula6wcfqi@brauner.io>
References: <20181119103241.5229-1-christian@brauner.io>
 <20181119103241.5229-3-christian@brauner.io>
 <20181119202857.k5zw742xjfrw677j@yavin>
 <20181119205518.btew3vxwgva4w3zh@brauner.io>
 <20181119211810.73ptfhnwdmkngfi4@yavin>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20181119211810.73ptfhnwdmkngfi4@yavin>
Sender: linux-kernel-owner@vger.kernel.org
To: Aleksa Sarai <cyphar@cyphar.com>
Cc: ebiederm@xmission.com, linux-kernel@vger.kernel.org, serge@hallyn.com, jannh@google.com, luto@kernel.org, akpm@linux-foundation.org, oleg@redhat.com, viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org, dancol@google.com, timmurray@google.com, linux-man@vger.kernel.org, Kees Cook <keescook@chromium.org>
List-Id: linux-api@vger.kernel.org

On Tue, Nov 20, 2018 at 08:18:10AM +1100, Aleksa Sarai wrote:
> On 2018-11-19, Christian Brauner <christian@brauner.io> wrote:
> > On Tue, Nov 20, 2018 at 07:28:57AM +1100, Aleksa Sarai wrote:
> > > On 2018-11-19, Christian Brauner <christian@brauner.io> wrote:
> > > > +	if (info) {
> > > > +		ret = __copy_siginfo_from_user(sig, &kinfo, info);
> > > > +		if (unlikely(ret))
> > > > +			goto err;
> > > > +		/*
> > > > +		 * Not even root can pretend to send signals from the kernel.
> > > > +		 * Nor can they impersonate a kill()/tgkill(), which adds
> > > > +		 * source info.
> > > > +		 */
> > > > +		ret = -EPERM;
> > > > +		if ((kinfo.si_code >= 0 || kinfo.si_code == SI_TKILL) &&
> > > > +		    (task_pid(current) != pid))
> > > > +			goto err;
> > > > +	} else {
> > > > +		prepare_kill_siginfo(sig, &kinfo);
> > > > +	}
> > > 
> > > I wonder whether we should also have a pidns restriction here, since
> > > currently it isn't possible for a container process using a pidns to
> > > signal processes outside its pidns. AFAICS, this isn't done through an
> > > explicit check -- it's a side-effect of processes in a pidns not being
> > > able to address non-descendant-pidns processes.
> > > 
> > > But maybe it's reasonable to allow sending a procfd to a different pidns
> > > and the same operations working on it? If we extend the procfd API to
> > 
> > No, I don't think so. I really don't want any fancy semantics in here.
> > Fancy doesn't get merged and fancy is hard to maintain. So we should do
> > something like:
> > 
> > if (proc_pid_ns() != current_pid_ns)
> > 	return EINVAL
> 
> This isn't quite sufficient. The key thing is that you have to be in an
> *ancestor* (or same) pidns, not the *same* pidns. Ideally you can re-use
> the check already in pidns_get_parent, and expose it. It would be
> something as trivial as:
> 
> bool pidns_is_descendant(struct pid_namespace *ns,
>                          struct pid_namespace *ancestor)
> {
>     for (;;) {
>         if (!ns)
>             return false;
>         if (ns == ancestor)
>             break;
>         ns = ns->parent;
>     }
>     return true;
> }

That can be done without a loop by comparing the level counter for the
two pid namespaces.

> 
> And you can rewrite pidns_get_parent to use it. So you would instead be
> doing:
> 
>     if (pidns_is_descendant(proc_pid_ns, task_active_pid_ns(current)))
>         return -EPERM;
> 
> (Or you can just copy the 5-line loop into procfd_signal -- though I
> imagine we'll need this for all of the procfd_* APIs.)
> 
> -- 
> Aleksa Sarai
> Senior Software Engineer (Containers)
> SUSE Linux GmbH
> <https://www.cyphar.com/>
