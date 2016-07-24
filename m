From: ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org (Eric W. Biederman)
Subject: Re: [PATCH 2/5] kernel: add a helper to get an owning user namespace for a namespace
Date: Sun, 24 Jul 2016 09:30:03 -0500
Message-ID: <87shuzglck.fsf@x220.int.ebiederm.org>
References: <CANaxB-xw_xBUq=0uT14ANv-jfg2NsGaPy=jyDO9=yF03_7toSw@mail.gmail.com>
	<1468548742-32136-1-git-send-email-avagin@openvz.org>
	<1468548742-32136-2-git-send-email-avagin@openvz.org>
	<878twrmxu2.fsf@x220.int.ebiederm.org>
	<20160724063728.GA17810@outlook.office365.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160724063728.GA17810-1ViLX0X+lBJGNQ1M2rI3KwRV3xvJKrda@public.gmane.org> (Andrew Vagin's
	message of "Sat, 23 Jul 2016 23:37:29 -0700")
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andrew Vagin <avagin-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
Cc: Andrey Vagin <avagin-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>, Serge Hallyn <serge.hallyn-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, criu-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Andrew Vagin <avagin-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org> writes:

> On Sun, Jul 24, 2016 at 12:03:49AM -0500, Eric W. Biederman wrote:
>> Andrey Vagin <avagin-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org> writes:
>> 
>> > Return -EPERM if an owning user namespace is outside of a process
>> > current user namespace.
>> >
>> > diff --git a/kernel/user_namespace.c b/kernel/user_namespace.c
>> > index a5bc78c..6382e5e 100644
>> > --- a/kernel/user_namespace.c
>> > +++ b/kernel/user_namespace.c
>> > @@ -994,6 +994,30 @@ static int userns_install(struct nsproxy *nsproxy, struct ns_common *ns)
>> >  	return commit_creds(cred);
>> >  }
>> >  
>> > +struct ns_common *ns_get_owner(struct ns_common *ns)
>> > +{
>> > +	const struct cred *cred = current_cred();
>> > +	struct user_namespace *user_ns, *p;
>> > +
>> > +	user_ns = p = ns->user_ns;
>> > +	if (user_ns == NULL) { /* ns is init_user_ns */
>> > +		/* Unprivileged user should not know that it's init_user_ns. */
>> > +		if (capable(CAP_SYS_ADMIN))
>> > +			return ERR_PTR(-ENOENT);
>> > +		return ERR_PTR(-EPERM);
>> > +	}
>> 
>> This permission check is not what I meant to request.  This does not
>> handle nested user namespaces.
>
> Here I handle a case when ns is init_user_ns. init_user_ns doesn't have
> a parent, so we need to return an error. We can't return ENOENT in all
> cases, because we don't want to expose "that file descriptor is for the
> root user namespace" to unprivileged users.
> (Trevor suggested to add this check and it looks resonable for me
> too).

Apologies. I was skimming and misread the code.  I mistook that loop for
some useful part of getting the owner.  Looking in more detail...

Your code says:
+struct ns_common *ns_get_owner(struct ns_common *ns)
+{
+	const struct cred *cred = current_cred();
+	struct user_namespace *user_ns, *p;
+
+	user_ns = p = ns->user_ns;
+	if (user_ns == NULL) { /* ns is init_user_ns */
+		/* Unprivileged user should not know that it's init_user_ns. */
+		if (capable(CAP_SYS_ADMIN))
+			return ERR_PTR(-ENOENT);
+		return ERR_PTR(-EPERM);
+	}
+
+	for (;;) {
+		if (p == cred->user_ns)
+			break;
+		if (p == &init_user_ns)
+			return ERR_PTR(-EPERM);
+		p = p->parent;
+	}
+
+	return &get_user_ns(user_ns)->ns;
+}

And all else being equal it could say:

+struct ns_common *ns_get_owner(struct ns_common *ns)
s+{
+	struct user_namespace *user_ns = ns->user_ns;
+
+	/* Are we allowed to see the user namespace? */
+	if (!ns_capable(user_ns?user_ns:&init_user_ns, CAP_SYS_ADMIN))
+		return ERR_PTR(-EPERM);
+
+	if (!user_ns)
+		return ERR_PTR(-ENOENT);
+
+	return &get_user_ns(user_ns)->ns;
+}

Which I think is the root of my confusion.  You hand rolled ns_capable,
and I did not recognize it because I was skimming, and just looking to
be certain the permission check was present.

Given that you have to hand roll the pid namespace check that hand
rolling may not be so bad.  But it certainly was confusing the first
time I saw it especially without a comment.

Hmm.

I am not at all certain it makes sense to return -ENOENT.

Without the -ENOENT check the code is much cleaner, and clearer.

I may be blinkered but I don't see the value in letting someone know we
are talking about the initial namespace.  If anything that information
is likely to cause issues with weird corner cases of checkpoint/restart,
as it acts different if you are in a container or not.

When things act different in a container that almost always is a source
of a problem somewhere.

So we could simplify the filter in the code to just this.

+struct ns_common *ns_get_owner(struct ns_common *ns)
+{
+	struct user_namespace *my_user_ns = current_user_ns();
+	struct user_namespace *owner, *p;
+
+	/* See if the owner is in the current user namespace */
+	owner = p = ns->user_ns;
+	for (;;) {
+		if (!p)
+			return ERR_PTR(-EPERM);
+		if (p == my_user_ns)
+			break;
+		p = p->parent;
+	}
+
+	return &get_user_ns(owner)->ns;
+}

And on reflection I do see the point of not using ns_capable as that
requires having privileges in a namespace while all we want here
is to see if someone is in a visible namespace.

So please ignore my comments about ns_capable on the pid namespace
parent.

But please simplify the loop and put an appropriate comment on it like I
have above.  The fewer special cases the easier the code is to get
correct, and the easier it is to read.

Eric
