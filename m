From: Andrew Vagin <avagin-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
Subject: Re: [PATCH 2/5] kernel: add a helper to get an owning user namespace
	for a namespace
Date: Sat, 23 Jul 2016 23:37:29 -0700
Message-ID: <20160724063728.GA17810@outlook.office365.com>
References: <CANaxB-xw_xBUq=0uT14ANv-jfg2NsGaPy=jyDO9=yF03_7toSw@mail.gmail.com>
	<1468548742-32136-1-git-send-email-avagin@openvz.org>
	<1468548742-32136-2-git-send-email-avagin@openvz.org>
	<878twrmxu2.fsf@x220.int.ebiederm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <878twrmxu2.fsf-JOvCrm2gF+uungPnsOpG7nhyD016LWXt@public.gmane.org>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/containers>,
	<mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/containers/>
List-Post: <mailto:containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
List-Help: <mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/containers>,
	<mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=subscribe>
Sender: containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
Errors-To: containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
To: "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>
Cc: Serge Hallyn <serge.hallyn-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, Andrey Vagin <avagin-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>, criu-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>, Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Sun, Jul 24, 2016 at 12:03:49AM -0500, Eric W. Biederman wrote:
> Andrey Vagin <avagin-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org> writes:
> 
> > Return -EPERM if an owning user namespace is outside of a process
> > current user namespace.
> >
> > diff --git a/kernel/user_namespace.c b/kernel/user_namespace.c
> > index a5bc78c..6382e5e 100644
> > --- a/kernel/user_namespace.c
> > +++ b/kernel/user_namespace.c
> > @@ -994,6 +994,30 @@ static int userns_install(struct nsproxy *nsproxy, struct ns_common *ns)
> >  	return commit_creds(cred);
> >  }
> >  
> > +struct ns_common *ns_get_owner(struct ns_common *ns)
> > +{
> > +	const struct cred *cred = current_cred();
> > +	struct user_namespace *user_ns, *p;
> > +
> > +	user_ns = p = ns->user_ns;
> > +	if (user_ns == NULL) { /* ns is init_user_ns */
> > +		/* Unprivileged user should not know that it's init_user_ns. */
> > +		if (capable(CAP_SYS_ADMIN))
> > +			return ERR_PTR(-ENOENT);
> > +		return ERR_PTR(-EPERM);
> > +	}
> 
> This permission check is not what I meant to request.  This does not
> handle nested user namespaces.

Here I handle a case when ns is init_user_ns. init_user_ns doesn't have
a parent, so we need to return an error. We can't return ENOENT in all
cases, because we don't want to expose "that file descriptor is for the
root user namespace" to unprivileged users.
(Trevor suggested to add this check and it looks resonable for me too).
> 
> > +	for (;;) {
> > +		if (p == cred->user_ns)
> > +			break;
> > +		if (p == &init_user_ns)
> > +			return ERR_PTR(-EPERM);
> > +		p = p->parent;
> > +	}
> > +
> 
> The permission check really needs to be down here. And be:
> 
> 	if (!ns_capable(user_ns, CAP_SYS_ADMIN))
>         	return ERR_PTR(-EPERM).
> 
> That cleanly and easily handles more than a depth of a single user
> namespace.
> 
> > +	return &get_user_ns(user_ns)->ns;
> > +}
> > +
> >  const struct proc_ns_operations userns_operations = {
> >  	.name		= "user",
> >  	.type		= CLONE_NEWUSER,
> 
> 
> Eric
