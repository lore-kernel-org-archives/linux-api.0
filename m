From: ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org (Eric W. Biederman)
Subject: Re: [PATCH] Introduce v3 namespaced file capabilities
Date: Sat, 22 Apr 2017 20:14:11 -0500
Message-ID: <87vapwncws.fsf@xmission.com>
References: <20170419164824.GA27843@mail.hallyn.com>
        <87wpadpb3m.fsf@xmission.com> <20170422151412.GA14861@mail.hallyn.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170422151412.GA14861-7LNsyQBKDXoIagZqoN9o3w@public.gmane.org> (Serge E. Hallyn's
        message of "Sat, 22 Apr 2017 10:14:12 -0500")
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Serge E. Hallyn" <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>
Cc: Seth Forshee <seth.forshee-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, lkml <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Andreas Gruenbacher <agruenba-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "Andrew G. Morgan" <morgan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-Id: linux-api@vger.kernel.org

"Serge E. Hallyn" <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org> writes:

> Quoting Eric W. Biederman (ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org):
>> 
>> "Serge E. Hallyn" <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org> writes:
>> 
>> Overall this looks quite reasonable.
>> 
>> My only big concern was the lack of verifying of magic_etc.  As without
>
> Yes, I was relying too much on the size check.
>
>> that the code might not be future compatible with new versions of the
>> capability xattrs.  It it tends to be nice to be able to boot old
>> kernels when regression testing etc.  Even if they can't make use of
>> all of the features of a new filesystem.
>
> That certainly was my intent.
>
>> > diff --git a/fs/xattr.c b/fs/xattr.c
>> > index 7e3317c..75cc65a 100644
>> > --- a/fs/xattr.c
>> > +++ b/fs/xattr.c
>> > @@ -170,12 +170,29 @@ int __vfs_setxattr_noperm(struct dentry *dentry, const char *name,
>> >  		const void *value, size_t size, int flags)
>> >  {
>> >  	struct inode *inode = dentry->d_inode;
>> > -	int error = -EAGAIN;
>> > +	int error;
>> > +	void *wvalue = NULL;
>> > +	size_t wsize = 0;
>> >  	int issec = !strncmp(name, XATTR_SECURITY_PREFIX,
>> >  				   XATTR_SECURITY_PREFIX_LEN);
>> >  
>> > -	if (issec)
>> > +	if (issec) {
>> >  		inode->i_flags &= ~S_NOSEC;
>> > +
>> > +		if (!strcmp(name, "security.capability")) {
>> > +			error = cap_setxattr_convert_nscap(dentry, value, size,
>> > +					&wvalue, &wsize);
>> > +			if (error < 0)
>> > +				return error;
>> > +			if (wvalue) {
>> > +				value = wvalue;
>> > +				size = wsize;
>> > +			}
>> > +		}
>> > +	}
>> > +
>> > +	error = -EAGAIN;
>> > +
>> 
>> Why is the conversion in __vfs_setxattr_noperm and not in setattr as
>> was done for posix_acl_fix_xattr_from_user?
>
> I think I was thinking I wanted to catch all the vfs_setxattr operations,
> but I don't think that's right.  Moving to setxattr seems right.  I'll
> look around a bit more.

Thanks.  This is one of these little details that we want a good answer
to why there.  If you can document that in your patch description when
you resend I would appreciate it.

>> Missing version checks on the magic_etc field.
>> And the wrong error code when the code deliberately refuses to return a
>> capability.
>
> Thanks, all looks good.  Did you want to just squash these yourself and
> move on, keep them as separate patches, or have me incorporate into mine
> and resend?

Given that there is an outstanding question I would appreciate a resend
with an updated patch description, the changes squashed and possibly a
change in where cap_setxattr_convert_nscap is called.

I have the untested version on my for-testing branch and except for
a small increase in the binary size of the kernel all seems well.

Eric
