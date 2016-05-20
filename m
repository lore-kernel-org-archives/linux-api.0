From: "Serge E. Hallyn" <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH RFC] user-namespaced file capabilities - now with more
	magic
Date: Fri, 20 May 2016 18:32:16 -0500
Message-ID: <20160520233216.GA14872@mail.hallyn.com>
References: <20160516214804.GA5926@mail.hallyn.com>
	<20160518215752.GA9187@mail.hallyn.com>
	<1463691236.2465.74.camel@linux.vnet.ibm.com>
	<20160520034048.GA31216@mail.hallyn.com>
	<1463743150.2465.100.camel@linux.vnet.ibm.com>
	<87mvnklh20.fsf@x220.int.ebiederm.org>
	<20160520192607.GA11601@mail.hallyn.com>
	<87iny8h5yv.fsf@x220.int.ebiederm.org>
	<20160520195902.GB12101@mail.hallyn.com>
	<1463786592.2763.74.camel@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1463786592.2763.74.camel-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/containers>,
	<mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/containers/>
List-Post: <mailto:containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
List-Help: <mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/containers>,
	<mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=subscribe>
Sender: containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
Errors-To: containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
To: Mimi Zohar <zohar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Cc: Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux Containers <containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, "Serge E. Hallyn" <serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Michael Kerrisk-manpages <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Seth Forshee <seth.forshee-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, LSM <linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, Jann Horn <jann-XZ1E9jl8jIdeoWH0uzbU5w@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, "Andrew G. Morgan" <morgan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Quoting Mimi Zohar (zohar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org):
> On Fri, 2016-05-20 at 14:59 -0500, Serge E. Hallyn wrote:
> > Quoting Eric W. Biederman (ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org):
> > > "Serge E. Hallyn" <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org> writes:
> > > 
> > > > Quoting Eric W. Biederman (ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org):
> > > >> Mimi Zohar <zohar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org> writes:
> > > >> 
> > > >> > On Thu, 2016-05-19 at 22:40 -0500, Serge E. Hallyn wrote:
> > > >> >> Quoting Mimi Zohar (zohar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org):
> > > >> >> > On Wed, 2016-05-18 at 16:57 -0500, Serge E. Hallyn wrote:
> > > >> >
> > > >> >> > > diff --git a/fs/xattr.c b/fs/xattr.c
> > > >> >> > > index 4861322..5c0e7ae 100644
> > > >> >> > > --- a/fs/xattr.c
> > > >> >> > > +++ b/fs/xattr.c
> > > >> >> > > @@ -94,11 +94,26 @@ int __vfs_setxattr_noperm(struct dentry *dentry, const char *name,
> > > >> >> > >  {
> > > >> >> > >  	struct inode *inode = dentry->d_inode;
> > > >> >> > >  	int error = -EOPNOTSUPP;
> > > >> >> > > +	void *wvalue = NULL;
> > > >> >> > > +	size_t wsize = 0;
> > > >> >> > >  	int issec = !strncmp(name, XATTR_SECURITY_PREFIX,
> > > >> >> > >  				   XATTR_SECURITY_PREFIX_LEN);
> > > >> >> > > 
> > > >> >> > > -	if (issec)
> > > >> >> > > +	if (issec) {
> > > >> >> > >  		inode->i_flags &= ~S_NOSEC;
> > > >> >> > > +		/* if root in a non-init user_ns tries to set
> > > >> >> > > +		 * security.capability, write a security.nscapability
> > > >> >> > > +		 * in its place */
> > > >> >> > > +		if (!strcmp(name, "security.capability") &&
> > > >> >> > > +				current_user_ns() != &init_user_ns) {
> > > >> >> > > +			cap_setxattr_make_nscap(dentry, value, size, &wvalue, &wsize);
> > > >> >> > > +			if (!wvalue)
> > > >> >> > > +				return -EPERM;
> > > >> >> > > +			value = wvalue;
> > > >> >> > > +			size = wsize;
> > > >> >> > > +			name = "security.nscapability";
> > > >> >> > > +		}
> > > >> >> > 
> > > >> >> > The call to capable_wrt_inode_uidgid() is hidden behind
> > > >> >> > cap_setxattr_make_nscap().  Does it make sense to call it here instead,
> > > >> >> > before the security.capability test?  This would lay the foundation for
> > > >> >> > doing something similar for IMA.
> > > >> >> 
> > > >> >> Might make sense to move that.  Though looking at it with fresh eyes I wonder
> > > >> >> whether adding less code here at __vfs_setxattr_noperm(), i.e.
> > > >> >> 
> > > >> >> 		if (!cap_setxattr_makenscap(dentry, &value, &size, &name))
> > > >> >> 			return -EPERM;
> > > >> >> 
> > > >> >> would be cleaner.
> > > >> >
> > > >> > Yes, it would be cleaner,  but I'm suggesting you do all the hard work
> > > >> > making it generic.  Then the rest of us can follow your lead.  Its more
> > > >> > likely that you'll get it right.  At a high level, it might look like:
> > > >> >
> > > >> >                /* Permit root in a non-init user_ns to modify the security
> > > >> >                  * namespace xattr equivalents (eg. nscapability, ns_ima, etc). 
> > > >> >                  */
> > > >> >                 if ((current_user_ns() != &init_user_ns) &&
> > > >> >                         capable_wrt_inode_uidgid(inode, CAP_SETFCAP)) {
> > > >> >
> > > >> > 			if  security..capability
> > > >> > 				call capability  /* set nscapability? */
> > > >> >
> > > >> > 			else if security.ima 
> > > >> > 				call ima 	/* set ns_ima? */
> > > >> > 		}
> > > >> 
> > > >> Hmm.  I am confused about this part of the strategy.
> > > >> 
> > > >> I don't understand the capability vs nscapability distinction.  It seems
> > > >> to add complexity without benefit.
> > > >
> > > > ...  Well, yes, we could simply make a new version of security.capability
> > > > xattr, and make rootid == 0 mean it was written by the init_user_ns.  Is
> > > > that what you mean?
> > > 
> > > Yes.
> > > 
> > > That would seem to simplify the logic to ensure the policy we enforce is
> > > consistent with what is on disk.
> > 
> > I'll give that a shot.  I think the reason I did it this way was that I'm
> > still kind of stuck in the not-magic way of thinking about it.  But yeah
> > with the kernel magically writing inthe kuid there's probably no reason not
> > to.
> 
> Totally confused.  Will this method allow multiple instances of the
> xattr on disk? 

No, but we don't actually want that anyway.  The current behavior for
security.capability is that it works in all user namespaces.  So we
want to continue the behavior that if root in the init_user_ns sets a
capability, that works in all namespaces.  Allowing other namespaces
to set the capability would only be confusing.

So in the patchset I had, security.capability can only be set by
init_user_ns but works in all namespaces.  security.nscapability
cannot be set if secrity.capability is set.  And security.nscapability
works in all child namespaces of the root uid which set the cap.

-serge
