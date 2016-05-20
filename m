From: ebiederm@xmission.com (Eric W. Biederman)
Subject: Re: [PATCH RFC] user-namespaced file capabilities - now with more magic
Date: Fri, 20 May 2016 14:11:46 -0500
Message-ID: <87a8jkk0i5.fsf@x220.int.ebiederm.org>
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
	<1463771344.2763.58.camel@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <1463771344.2763.58.camel@linux.vnet.ibm.com> (Mimi Zohar's
	message of "Fri, 20 May 2016 15:09:04 -0400")
Sender: owner-linux-security-module@vger.kernel.org
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
Cc: "Serge E. Hallyn" <serge@hallyn.com>, LKML <linux-kernel@vger.kernel.org>, Jann Horn <jann@thejh.net>, Seth Forshee <seth.forshee@canonical.com>, LSM <linux-security-module@vger.kernel.org>, "Andrew G. Morgan" <morgan@kernel.org>, Kees Cook <keescook@chromium.org>, Michael Kerrisk-manpages <mtk.manpages@gmail.com>, "Serge E. Hallyn" <serge.hallyn@ubuntu.com>, Linux API <linux-api@vger.kernel.org>, Andy Lutomirski <luto@amacapital.net>, Linux Containers <containers@lists.linux-foundation.org>
List-Id: linux-api@vger.kernel.org

Mimi Zohar <zohar@linux.vnet.ibm.com> writes:

> On Fri, 2016-05-20 at 13:28 -0500, Eric W. Biederman wrote:
>> Mimi Zohar <zohar@linux.vnet.ibm.com> writes:
>> 
>> > On Thu, 2016-05-19 at 22:40 -0500, Serge E. Hallyn wrote:
>> >> Quoting Mimi Zohar (zohar@linux.vnet.ibm.com):
>> >> > On Wed, 2016-05-18 at 16:57 -0500, Serge E. Hallyn wrote:
>> >
>> >> > > diff --git a/fs/xattr.c b/fs/xattr.c
>> >> > > index 4861322..5c0e7ae 100644
>> >> > > --- a/fs/xattr.c
>> >> > > +++ b/fs/xattr.c
>> >> > > @@ -94,11 +94,26 @@ int __vfs_setxattr_noperm(struct dentry *dentry, const char *name,
>> >> > >  {
>> >> > >  	struct inode *inode = dentry->d_inode;
>> >> > >  	int error = -EOPNOTSUPP;
>> >> > > +	void *wvalue = NULL;
>> >> > > +	size_t wsize = 0;
>> >> > >  	int issec = !strncmp(name, XATTR_SECURITY_PREFIX,
>> >> > >  				   XATTR_SECURITY_PREFIX_LEN);
>> >> > > 
>> >> > > -	if (issec)
>> >> > > +	if (issec) {
>> >> > >  		inode->i_flags &= ~S_NOSEC;
>> >> > > +		/* if root in a non-init user_ns tries to set
>> >> > > +		 * security.capability, write a security.nscapability
>> >> > > +		 * in its place */
>> >> > > +		if (!strcmp(name, "security.capability") &&
>> >> > > +				current_user_ns() != &init_user_ns) {
>> >> > > +			cap_setxattr_make_nscap(dentry, value, size, &wvalue, &wsize);
>> >> > > +			if (!wvalue)
>> >> > > +				return -EPERM;
>> >> > > +			value = wvalue;
>> >> > > +			size = wsize;
>> >> > > +			name = "security.nscapability";
>> >> > > +		}
>> >> > 
>> >> > The call to capable_wrt_inode_uidgid() is hidden behind
>> >> > cap_setxattr_make_nscap().  Does it make sense to call it here instead,
>> >> > before the security.capability test?  This would lay the foundation for
>> >> > doing something similar for IMA.
>> >> 
>> >> Might make sense to move that.  Though looking at it with fresh eyes I wonder
>> >> whether adding less code here at __vfs_setxattr_noperm(), i.e.
>> >> 
>> >> 		if (!cap_setxattr_makenscap(dentry, &value, &size, &name))
>> >> 			return -EPERM;
>> >> 
>> >> would be cleaner.
>> >
>> > Yes, it would be cleaner,  but I'm suggesting you do all the hard work
>> > making it generic.  Then the rest of us can follow your lead.  Its more
>> > likely that you'll get it right.  At a high level, it might look like:
>> >
>> >                /* Permit root in a non-init user_ns to modify the security
>> >                  * namespace xattr equivalents (eg. nscapability, ns_ima, etc). 
>> >                  */
>> >                 if ((current_user_ns() != &init_user_ns) &&
>> >                         capable_wrt_inode_uidgid(inode, CAP_SETFCAP)) {
>> >
>> > 			if  security..capability
>> > 				call capability  /* set nscapability? */
>> >
>> > 			else if security.ima 
>> > 				call ima 	/* set ns_ima? */
>> > 		}
>> 
>> Hmm.  I am confused about this part of the strategy.
>> 
>> I don't understand the capability vs nscapability distinction.  It seems
>> to add complexity without benefit.
>
> Only real root can write security xattrs, which prevents root in a
> namespace from writing the included security xattrs in a tar package
> from being installed.  Nobody is suggesting changing this behavior.
> Serge's solution is to allow an equivalent xattr to be written.  For
> capabilities, it would be ns_capability.   Similarly, IMA would write
> security.ns_ima.  (I'm not sure about SELinux or Smack.)

nscapability is an xattr in the security namespace.  So root in a
namespace can write to a specific security xattr.

I am saying that at least at a quick examinination that having two
attributes that control the same things appears to be a mistake, as it
just makes it easy for them to get out of sync and generally be
confusing.

>> If I am in a nested user namespace and I try to write a capability on a
>> file and it has nscapability I can't be allowed to (as a more privileged
>> user namespace already wrote it).
>> 
>> Not rewriting an existing attribute seems to be the only benefit I can
>> see to have both a capability and a nscapability attribute vs having
>> a new version of the capability attribute.
>> 
>> Am I missing something here?
>
> Only real root in the namespace can write the equivalent security xattr.
> I'm hoping this can be done without having to modify userspace apps.  (I
> hope that answers your question.)

But it is possible and actually desirable to have user namespaces nested
in user namespaces nested in user namespaces.  Which means the existing
xattr must be examined before being written.

At which point I don't see a gain by having both a capability and an
nscapability attribute.

>> Mimi as for generalizing the code for handling IMA I expect it makes
>> sense to refactor the code to have shared library functions (or whatever
>> it takes to generalize the code) when you are ready to implement this
>> kind of IMA attribute.  That way in the first implementation we can
>> concentrate on getting the code clean and the sematics correct.
>> 
>> That alone seems to be taking a while.
>
> There should be a generic solution that works for security xattrs, not
> just capabilities.

However we don't have to start there.  We can think about it but we
probably should not start there.

We certainly need infrastructure to support this case.  Security modules
deliberately can be very unique so in general it is not possible to come
up with a design for all cases.  Especially as nesting of user
namespaces does not imply nesting of security module contexts.

Eric
