From: Mimi Zohar <zohar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Subject: Re: [PATCH RFC] user-namespaced file capabilities - now with more
	magic
Date: Fri, 20 May 2016 15:09:04 -0400
Message-ID: <1463771344.2763.58.camel@linux.vnet.ibm.com>
References: <87h9egp2oq.fsf@x220.int.ebiederm.org>
	<CALQRfL7mfpyudWs4Z8W5Zi8CTG-9O0OvrCnRU7pk0MXtsLBd0A@mail.gmail.com>
	<20160503051921.GA31551@mail.hallyn.com>
	<87bn4nhejj.fsf@x220.int.ebiederm.org>
	<20160507231012.GA11076@pc.thejh.net>
	<20160511210221.GA24015@mail.hallyn.com>
	<20160516211523.GA5282@mail.hallyn.com>
	<20160516214804.GA5926@mail.hallyn.com>
	<20160518215752.GA9187@mail.hallyn.com>
	<1463691236.2465.74.camel@linux.vnet.ibm.com>
	<20160520034048.GA31216@mail.hallyn.com>
	<1463743150.2465.100.camel@linux.vnet.ibm.com>
	<87mvnklh20.fsf@x220.int.ebiederm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
In-Reply-To: <87mvnklh20.fsf-JOvCrm2gF+uungPnsOpG7nhyD016LWXt@public.gmane.org>
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
Cc: Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux Containers <containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, "Serge E. Hallyn" <serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Seth Forshee <seth.forshee-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, LSM <linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Michael Kerrisk-manpages <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Jann Horn <jann-XZ1E9jl8jIdeoWH0uzbU5w@public.gmane.org>, "Andrew G. Morgan" <morgan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Fri, 2016-05-20 at 13:28 -0500, Eric W. Biederman wrote:
> Mimi Zohar <zohar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org> writes:
> 
> > On Thu, 2016-05-19 at 22:40 -0500, Serge E. Hallyn wrote:
> >> Quoting Mimi Zohar (zohar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org):
> >> > On Wed, 2016-05-18 at 16:57 -0500, Serge E. Hallyn wrote:
> >
> >> > > diff --git a/fs/xattr.c b/fs/xattr.c
> >> > > index 4861322..5c0e7ae 100644
> >> > > --- a/fs/xattr.c
> >> > > +++ b/fs/xattr.c
> >> > > @@ -94,11 +94,26 @@ int __vfs_setxattr_noperm(struct dentry *dentry, const char *name,
> >> > >  {
> >> > >  	struct inode *inode = dentry->d_inode;
> >> > >  	int error = -EOPNOTSUPP;
> >> > > +	void *wvalue = NULL;
> >> > > +	size_t wsize = 0;
> >> > >  	int issec = !strncmp(name, XATTR_SECURITY_PREFIX,
> >> > >  				   XATTR_SECURITY_PREFIX_LEN);
> >> > > 
> >> > > -	if (issec)
> >> > > +	if (issec) {
> >> > >  		inode->i_flags &= ~S_NOSEC;
> >> > > +		/* if root in a non-init user_ns tries to set
> >> > > +		 * security.capability, write a security.nscapability
> >> > > +		 * in its place */
> >> > > +		if (!strcmp(name, "security.capability") &&
> >> > > +				current_user_ns() != &init_user_ns) {
> >> > > +			cap_setxattr_make_nscap(dentry, value, size, &wvalue, &wsize);
> >> > > +			if (!wvalue)
> >> > > +				return -EPERM;
> >> > > +			value = wvalue;
> >> > > +			size = wsize;
> >> > > +			name = "security.nscapability";
> >> > > +		}
> >> > 
> >> > The call to capable_wrt_inode_uidgid() is hidden behind
> >> > cap_setxattr_make_nscap().  Does it make sense to call it here instead,
> >> > before the security.capability test?  This would lay the foundation for
> >> > doing something similar for IMA.
> >> 
> >> Might make sense to move that.  Though looking at it with fresh eyes I wonder
> >> whether adding less code here at __vfs_setxattr_noperm(), i.e.
> >> 
> >> 		if (!cap_setxattr_makenscap(dentry, &value, &size, &name))
> >> 			return -EPERM;
> >> 
> >> would be cleaner.
> >
> > Yes, it would be cleaner,  but I'm suggesting you do all the hard work
> > making it generic.  Then the rest of us can follow your lead.  Its more
> > likely that you'll get it right.  At a high level, it might look like:
> >
> >                /* Permit root in a non-init user_ns to modify the security
> >                  * namespace xattr equivalents (eg. nscapability, ns_ima, etc). 
> >                  */
> >                 if ((current_user_ns() != &init_user_ns) &&
> >                         capable_wrt_inode_uidgid(inode, CAP_SETFCAP)) {
> >
> > 			if  security..capability
> > 				call capability  /* set nscapability? */
> >
> > 			else if security.ima 
> > 				call ima 	/* set ns_ima? */
> > 		}
> 
> Hmm.  I am confused about this part of the strategy.
> 
> I don't understand the capability vs nscapability distinction.  It seems
> to add complexity without benefit.

Only real root can write security xattrs, which prevents root in a
namespace from writing the included security xattrs in a tar package
from being installed.  Nobody is suggesting changing this behavior.
Serge's solution is to allow an equivalent xattr to be written.  For
capabilities, it would be ns_capability.   Similarly, IMA would write
security.ns_ima.  (I'm not sure about SELinux or Smack.)

> If I am in a nested user namespace and I try to write a capability on a
> file and it has nscapability I can't be allowed to (as a more privileged
> user namespace already wrote it).
> 
> Not rewriting an existing attribute seems to be the only benefit I can
> see to have both a capability and a nscapability attribute vs having
> a new version of the capability attribute.
> 
> Am I missing something here?

Only real root in the namespace can write the equivalent security xattr.
I'm hoping this can be done without having to modify userspace apps.  (I
hope that answers your question.)

> Mimi as for generalizing the code for handling IMA I expect it makes
> sense to refactor the code to have shared library functions (or whatever
> it takes to generalize the code) when you are ready to implement this
> kind of IMA attribute.  That way in the first implementation we can
> concentrate on getting the code clean and the sematics correct.
> 
> That alone seems to be taking a while.

There should be a generic solution that works for security xattrs, not
just capabilities.

Mimi
