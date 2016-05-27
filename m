From: ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org (Eric W. Biederman)
Subject: Re: [PATCH] user-namespaced file capabilities - now with even more magic
Date: Fri, 27 May 2016 14:33:45 -0500
Message-ID: <87y46vcn3a.fsf@x220.int.ebiederm.org>
References: <20160527071807.GA501@mail.hallyn.com>
	<87y46ve3oe.fsf@x220.int.ebiederm.org>
	<20160527191034.GA11575@mail.hallyn.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160527191034.GA11575-7LNsyQBKDXoIagZqoN9o3w@public.gmane.org> (Serge E. Hallyn's
	message of "Fri, 27 May 2016 14:10:34 -0500")
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Serge E. Hallyn" <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>
Cc: LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Jann Horn <jann-XZ1E9jl8jIdeoWH0uzbU5w@public.gmane.org>, Seth Forshee <seth.forshee-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, LSM <linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Andrew G. Morgan" <morgan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Michael Kerrisk-manpages <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Linux Containers <containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, Mimi Zohar <zohar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
List-Id: linux-api@vger.kernel.org

"Serge E. Hallyn" <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org> writes:

> Quoting Eric W. Biederman (ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org):
>> > @@ -657,8 +898,11 @@ int cap_inode_setxattr(struct dentry *dentry, const char *name,
>> >  		       const void *value, size_t size, int flags)
>> >  {
>> >  	if (!strcmp(name, XATTR_NAME_CAPS)) {
>> > -		if (!capable(CAP_SETFCAP))
>> > +		/* Note - we want to use Seth's newer code here instead
>> > */
>> ^^^^^^^^^^^^^^^  What are you referring to here?  current_in_userns?
>
> Referring specifically to
>
> http://kernel.ubuntu.com/git/ubuntu/ubuntu-yakkety.git/commit/security/commoncap.c?id=e1804ed91602bc8ead616c9616de70096b139fa7
>
> I just need to think about what precisely we want the rule to be here.
>
> It's possible we just drop Seth's patch, as mine already allows writing
> capabilities (though not v2) when not in init_user_ns, so his patch isn't
> needed.
>
> Seth's patch makes it possible to write v2 capabilitie (which are not
> namespaced) to a file in non-init user-ns if the userns mounted the fs.
>
> Mine does not allow that, ever, but will silently write a v3 capability.
>
> Seth's patch never allows writing a file capability unlesss the whole
> block device was mountd by the caller's user-ns.  Mine allows writing
> v3 capabilities to such files.
>
> So yeah, maybe mine simiply obviates the need for Seths' patch.

Hmm.

While there is an obvious conflict the two patches are doing different
things.

s_user_ns is the owning user namespace of the filesystem.  And as such
it is fine to write the old capability in that context.

You are making it possible to write the capability in child user
namespaces, and I presume not allowing stomping a capability set by
a more privileged user.

Unless you update your code to decide to write a v2 capability if rootid
is zero and v3 otherwise the code will still have interesting
entanglement issues.  Even then the code needs to look at s_user_ns to
see what rootid should be.

Earlier today I pushed a for-testing branch to my user-namespace.git
tree and that has the start of the s_user_ns stuff that I am pretty much
ready to merge at this point.  I still need to rebase onto 4.7-rc1 and
retest before I get farther.  But I am serious about getting this stuff
reviewed and merged into my tree and into Linus' tree next merge window.

It is way past time.

Eric
