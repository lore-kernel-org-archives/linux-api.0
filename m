From: ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org (Eric W. Biederman)
Subject: Re: [PATCH] Introduce v3 namespaced file capabilities
Date: Thu, 27 Apr 2017 12:00:25 -0500
Message-ID: <874lx9zsye.fsf@xmission.com>
References: <20170419164824.GA27843@mail.hallyn.com>
        <87wpadpb3m.fsf@xmission.com> <20170422151412.GA14861@mail.hallyn.com>
        <87vapwncws.fsf@xmission.com> <87r30d255v.fsf@xmission.com>
        <20170427165245.GA794@mail.hallyn.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170427165245.GA794-7LNsyQBKDXoIagZqoN9o3w@public.gmane.org> (Serge E. Hallyn's message
        of "Thu, 27 Apr 2017 11:52:45 -0500")
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Serge E. Hallyn" <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>
Cc: Seth Forshee <seth.forshee-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, lkml <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Andreas Gruenbacher <agruenba-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "Andrew G. Morgan" <morgan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-Id: linux-api@vger.kernel.org

"Serge E. Hallyn" <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org> writes:

> Quoting Eric W. Biederman (ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org):
>> ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org (Eric W. Biederman) writes:
>> 
>> > "Serge E. Hallyn" <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org> writes:
>> >
>> >> Quoting Eric W. Biederman (ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org):
>> >>> 
>> >>> "Serge E. Hallyn" <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org> writes:
>> >>> 
>> >>> > diff --git a/fs/xattr.c b/fs/xattr.c
>> >>> > index 7e3317c..75cc65a 100644
>> >>> > --- a/fs/xattr.c
>> >>> > +++ b/fs/xattr.c
>> >>> > @@ -170,12 +170,29 @@ int __vfs_setxattr_noperm(struct dentry *dentry, const char *name,
>> >>> >  		const void *value, size_t size, int flags)
>> >>> >  {
>> >>> >  	struct inode *inode = dentry->d_inode;
>> >>> > -	int error = -EAGAIN;
>> >>> > +	int error;
>> >>> > +	void *wvalue = NULL;
>> >>> > +	size_t wsize = 0;
>> >>> >  	int issec = !strncmp(name, XATTR_SECURITY_PREFIX,
>> >>> >  				   XATTR_SECURITY_PREFIX_LEN);
>> >>> >  
>> >>> > -	if (issec)
>> >>> > +	if (issec) {
>> >>> >  		inode->i_flags &= ~S_NOSEC;
>> >>> > +
>> >>> > +		if (!strcmp(name, "security.capability")) {
>> >>> > +			error = cap_setxattr_convert_nscap(dentry, value, size,
>> >>> > +					&wvalue, &wsize);
>> >>> > +			if (error < 0)
>> >>> > +				return error;
>> >>> > +			if (wvalue) {
>> >>> > +				value = wvalue;
>> >>> > +				size = wsize;
>> >>> > +			}
>> >>> > +		}
>> >>> > +	}
>> >>> > +
>> >>> > +	error = -EAGAIN;
>> >>> > +
>> >>> 
>> >>> Why is the conversion in __vfs_setxattr_noperm and not in setattr as
>> >>> was done for posix_acl_fix_xattr_from_user?
>> >>
>> >> I think I was thinking I wanted to catch all the vfs_setxattr operations,
>> >> but I don't think that's right.  Moving to setxattr seems right.  I'll
>> >> look around a bit more.
>> >
>> > Thanks.  This is one of these little details that we want a good answer
>> > to why there.  If you can document that in your patch description when
>> > you resend I would appreciate it.
>> 
>> Ok. Grrr.
>> 
>> Looking at this a little more getting it correct where we call the
>> conversion operation is critical. 
>> 
>> I believe the current placement of cap_setxattr_convert_nscap is
>> actively wrong.  In particular unless I am misleading something this
>> will trigger multiple conversions when setting one of these attributes
>> on overlayfs.
>> 
>> The stragey I adopted for for posix acls is:
>> 
>>    On a write from userspace convert from current_user_ns() to &init_user_ns.
>>    On a write to the filesystem convert from &init_user_ns to fs_user_ns.
>>    
>>    On a read from the filesystem convert from fs_user_ns to &init_user_ns
>>    On a read from the kernel to userspace convert from &init_user_ns
>>       to current_user_ns().
>> 
>> Overall a good strategy but no one we can trivially adopt for the
>> capability xattr as the second write to filesystem method does not
>> appear to actually exist for anything except for posix acls.
>> 
>> I need to think a little more about how we want to accomplish this for
>> the capability xattr.  My apoligies for leading you down a path that has
>> all of these bumps and then being sufficiently distracted not to help
>> you through this maze.
>> 
>> The only easy solution I can see is to just always keep things in
>> &init_user_ns inside the kernel.   That works until we bring fuse or
>> other unprivileged mounts onboard that have storage outside of the
>> kernel.
>> 
>> Seth and I will have to rework that for fuse support but that sounds
>> better than not letting such an issue prevent us from merging the code.
>
> Ok, in the meantime I've made a few updates in my tree which I think
> make the code a lot nicer (and do move the conversion to setxattr()),
> but there's a bug in that which I'm still trying to nail down.  I'll
> send a new version when I get that figured, and we can see how close
> to ok that is.
>
> Note that upstream cap_inode_removexattr and cap_inode_setxattr()
> upstream still don't respect the fs_user_ns properly either (the
> proper code is in the Ubuntu kernel, maybe it's in your -next
> tree, I don't know how you and Seth are coordinating that)

Oh yes.  The relaxation of permissions.  I remember holding off
on that until we knew the core vfs work was done.  At this point I don't
think it is necessary to keep holding off.  It seemed prudent before we
got all of the s_user_ns bits used in all of the proper places.

At this point I think it was just worry about the last little vfs bits
has been challenging enough that we just haven't gotten too it.

Eric
