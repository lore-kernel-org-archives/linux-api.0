From: Mimi Zohar <zohar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Subject: Re: [PATCH RFC] user-namespaced file capabilities - now with more
 magic
Date: Thu, 19 May 2016 16:53:56 -0400
Message-ID: <1463691236.2465.74.camel@linux.vnet.ibm.com>
References: <CAGXu5jJbmSKst_RiM84-7OaX=2XettzpTh34uFFoevvoPRO76Q@mail.gmail.com>
	 <20160502035452.GA31837@mail.hallyn.com>
	 <87h9egp2oq.fsf@x220.int.ebiederm.org>
	 <CALQRfL7mfpyudWs4Z8W5Zi8CTG-9O0OvrCnRU7pk0MXtsLBd0A@mail.gmail.com>
	 <20160503051921.GA31551@mail.hallyn.com>
	 <87bn4nhejj.fsf@x220.int.ebiederm.org>
	 <20160507231012.GA11076@pc.thejh.net>
	 <20160511210221.GA24015@mail.hallyn.com>
	 <20160516211523.GA5282@mail.hallyn.com>
	 <20160516214804.GA5926@mail.hallyn.com>
	 <20160518215752.GA9187@mail.hallyn.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160518215752.GA9187-7LNsyQBKDXoIagZqoN9o3w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Serge E. Hallyn" <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>
Cc: LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Jann Horn <jann-XZ1E9jl8jIdeoWH0uzbU5w@public.gmane.org>, "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, Seth Forshee <seth.forshee-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, LSM <linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Andrew G. Morgan" <morgan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Michael Kerrisk-manpages <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "Serge E. Hallyn" <serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Linux Containers <containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Wed, 2016-05-18 at 16:57 -0500, Serge E. Hallyn wrote:
> This patch introduces a new security.nscapability xattr.  It
> is mostly like security.capability, but also lists a 'rootid'.
> This is the uid_t (in init_user_ns) of the root id (uid 0 in a
> namespace) in whose namespaces the file capabilities may take
> effect.
> 
> A privileged (cap_setfcap) process in the initial user ns may
> set and read this xattr directly.  However, its real intent is
> to be used as a transparent fallback in user namespaces.
> 
> Root in a user ns cannot be trusted to write security.capability
> xattrs, because any user on the host could map his own uid to root
> in a namespace, write the xattr, and execute the file with privilege
> on the host.
> 
> With this patch, when root in a user ns asks to write security.capability,
> the kernel will transparently write a security.nscapability xattr
> instead, filling in the kuid of the calling user's root uid.  Subsequently,
> any task executing the file which has the noted k_uid as its root uid,
> or which is in a descendent user_ns of such a user_ns, will run the
> file with capabilities.
> 
> When reading the security.capability xattr from a non-init user_ns, a valid
> security.nscapability will be shown if it exists.  Such a task is not
> allowed to read security.nscapability.  This could be accomodated, however

Add the word "directly" as "to read security.nscapability directly".

> it requires the kernel to convert the kuid_t to a valid uid in the reader's
> user_ns.  So for now it's simply not supported.

I really like the idea that the kernel transparently replaces
nscapability for capability.

> Only a single security.nscapability xattr may be written.  This patch
> could be expanded to allow a list of capabilities and rootids, however
> I do not believe that to be a worthwhile use case.

Ok

> This allows a simple setxattr to work, allows tar/untar to
> work, and allows us to tar in one namespace and untar in
> another while preserving the capability, without risking
> leaking privilege into a parent namespace.
> 
> Note - listxattr is not being handled here.  So results of that can be
> inconsistent with get/setxattr.  Fixing that will require yet more
> deceit in fs/xattr.c.
> 
> Note2 - it may be less sneaky to hide all the magic behind the
> security.nscapability xattr.  So userspace would need to know to
> use that xattr name when needed, but with the same format as
> security.capability.  The kuid_t rootid would be filled in by the
> kernel.  That's a middle ground between my last patch and this one.

The less userspace needs to differentiate between running in a namespace
and not, the better.

Note3 - capability is currently protected by EVM, when enabled.  Should
ns_capability also be a protected xattr?

> Signed-off-by: Serge Hallyn <serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>
> ---
>  fs/xattr.c                      |  18 ++-
>  include/linux/capability.h      |   8 +-
>  include/uapi/linux/capability.h |  19 +++
>  include/uapi/linux/xattr.h      |   3 +
>  security/commoncap.c            | 253 ++++++++++++++++++++++++++++++++++++++--
>  5 files changed, 291 insertions(+), 10 deletions(-)
> 
> diff --git a/fs/xattr.c b/fs/xattr.c
> index 4861322..5c0e7ae 100644
> --- a/fs/xattr.c
> +++ b/fs/xattr.c
> @@ -94,11 +94,26 @@ int __vfs_setxattr_noperm(struct dentry *dentry, const char *name,
>  {
>  	struct inode *inode = dentry->d_inode;
>  	int error = -EOPNOTSUPP;
> +	void *wvalue = NULL;
> +	size_t wsize = 0;
>  	int issec = !strncmp(name, XATTR_SECURITY_PREFIX,
>  				   XATTR_SECURITY_PREFIX_LEN);
> 
> -	if (issec)
> +	if (issec) {
>  		inode->i_flags &= ~S_NOSEC;
> +		/* if root in a non-init user_ns tries to set
> +		 * security.capability, write a security.nscapability
> +		 * in its place */
> +		if (!strcmp(name, "security.capability") &&
> +				current_user_ns() != &init_user_ns) {
> +			cap_setxattr_make_nscap(dentry, value, size, &wvalue, &wsize);
> +			if (!wvalue)
> +				return -EPERM;
> +			value = wvalue;
> +			size = wsize;
> +			name = "security.nscapability";
> +		}

The call to capable_wrt_inode_uidgid() is hidden behind
cap_setxattr_make_nscap().  Does it make sense to call it here instead,
before the security.capability test?  This would lay the foundation for
doing something similar for IMA.

(Will continue reviewing ...)

Mimi
