From: "Serge E. Hallyn" <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] user-namespaced file capabilities - now with even more
 magic
Date: Fri, 27 May 2016 14:10:34 -0500
Message-ID: <20160527191034.GA11575@mail.hallyn.com>
References: <20160527071807.GA501@mail.hallyn.com>
 <87y46ve3oe.fsf@x220.int.ebiederm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <87y46ve3oe.fsf-JOvCrm2gF+uungPnsOpG7nhyD016LWXt@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>
Cc: "Serge E. Hallyn" <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Jann Horn <jann-XZ1E9jl8jIdeoWH0uzbU5w@public.gmane.org>, Seth Forshee <seth.forshee-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, LSM <linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Andrew G. Morgan" <morgan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Michael Kerrisk-manpages <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Linux Containers <containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, Mimi Zohar <zohar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Quoting Eric W. Biederman (ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org):
> > @@ -657,8 +898,11 @@ int cap_inode_setxattr(struct dentry *dentry, const char *name,
> >  		       const void *value, size_t size, int flags)
> >  {
> >  	if (!strcmp(name, XATTR_NAME_CAPS)) {
> > -		if (!capable(CAP_SETFCAP))
> > +		/* Note - we want to use Seth's newer code here instead
> > */
> ^^^^^^^^^^^^^^^  What are you referring to here?  current_in_userns?

Referring specifically to

http://kernel.ubuntu.com/git/ubuntu/ubuntu-yakkety.git/commit/security/commoncap.c?id=e1804ed91602bc8ead616c9616de70096b139fa7

I just need to think about what precisely we want the rule to be here.

It's possible we just drop Seth's patch, as mine already allows writing
capabilities (though not v2) when not in init_user_ns, so his patch isn't
needed.

Seth's patch makes it possible to write v2 capabilitie (which are not
namespaced) to a file in non-init user-ns if the userns mounted the fs.

Mine does not allow that, ever, but will silently write a v3 capability.

Seth's patch never allows writing a file capability unlesss the whole
block device was mountd by the caller's user-ns.  Mine allows writing
v3 capabilities to such files.

So yeah, maybe mine simiply obviates the need for Seths' patch.

> > +		if (current_user_ns() == &init_user_ns && !capable(CAP_SETFCAP))
> >  			return -EPERM;
> > +		/* for non-init userns we'll check permission later in
> > +		 * cap_setxattr_make_nscap() */
> >  		return 0;
> >  	}
> >  
> > @@ -683,7 +927,11 @@ int cap_inode_setxattr(struct dentry *dentry, const char *name,
> >  int cap_inode_removexattr(struct dentry *dentry, const char *name)
> >  {
> >  	if (!strcmp(name, XATTR_NAME_CAPS)) {
> > -		if (!capable(CAP_SETFCAP))
> > +		/* Note - we want to use Seth's newer code here instead */
> ^^^^^^^^^^^^^^^  What are you referring to here?  current_in_userns?
> > +		struct inode *inode = d_backing_inode(dentry);
> > +		if (!inode)
> > +			return -EINVAL;
> > +		if (!capable_wrt_inode_uidgid(inode, CAP_SETFCAP))
> >  			return -EPERM;
> >  		return 0;
> >  	}
> > @@ -1078,6 +1326,7 @@ struct security_hook_list capability_hooks[] = {
> >  	LSM_HOOK_INIT(bprm_secureexec, cap_bprm_secureexec),
> >  	LSM_HOOK_INIT(inode_need_killpriv, cap_inode_need_killpriv),
> >  	LSM_HOOK_INIT(inode_killpriv, cap_inode_killpriv),
> > +	LSM_HOOK_INIT(inode_getsecurity, cap_inode_getsecurity),
> >  	LSM_HOOK_INIT(mmap_addr, cap_mmap_addr),
> >  	LSM_HOOK_INIT(mmap_file, cap_mmap_file),
> >  	LSM_HOOK_INIT(task_fix_setuid, cap_task_fix_setuid),
> 
> Eric
