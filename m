From: ebiederm@xmission.com (Eric W. Biederman)
Subject: Re: [PATCH RFC] user-namespaced file capabilities - now with more magic
Date: Fri, 20 May 2016 14:42:00 -0500
Message-ID: <87iny8h5yv.fsf@x220.int.ebiederm.org>
References: <87bn4nhejj.fsf@x220.int.ebiederm.org>
	<20160507231012.GA11076@pc.thejh.net>
	<20160511210221.GA24015@mail.hallyn.com>
	<20160516211523.GA5282@mail.hallyn.com>
	<20160516214804.GA5926@mail.hallyn.com>
	<20160518215752.GA9187@mail.hallyn.com>
	<1463691236.2465.74.camel@linux.vnet.ibm.com>
	<20160520034048.GA31216@mail.hallyn.com>
	<1463743150.2465.100.camel@linux.vnet.ibm.com>
	<87mvnklh20.fsf@x220.int.ebiederm.org>
	<20160520192607.GA11601@mail.hallyn.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <20160520192607.GA11601@mail.hallyn.com> (Serge E. Hallyn's
	message of "Fri, 20 May 2016 14:26:07 -0500")
Sender: owner-linux-security-module@vger.kernel.org
To: "Serge E. Hallyn" <serge@hallyn.com>
Cc: Mimi Zohar <zohar@linux.vnet.ibm.com>, LKML <linux-kernel@vger.kernel.org>, Jann Horn <jann@thejh.net>, Seth Forshee <seth.forshee@canonical.com>, LSM <linux-security-module@vger.kernel.org>, "Andrew G. Morgan" <morgan@kernel.org>, Kees Cook <keescook@chromium.org>, Michael Kerrisk-manpages <mtk.manpages@gmail.com>, "Serge E. Hallyn" <serge.hallyn@ubuntu.com>, Linux API <linux-api@vger.kernel.org>, Andy Lutomirski <luto@amacapital.net>, Linux Containers <containers@lists.linux-foundation.org>
List-Id: linux-api@vger.kernel.org

"Serge E. Hallyn" <serge@hallyn.com> writes:

> Quoting Eric W. Biederman (ebiederm@xmission.com):
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
> ...  Well, yes, we could simply make a new version of security.capability
> xattr, and make rootid == 0 mean it was written by the init_user_ns.  Is
> that what you mean?

Yes.

That would seem to simplify the logic to ensure the policy we enforce is
consistent with what is on disk.

Eric
