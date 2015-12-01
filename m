From: "Serge E. Hallyn" <serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH RFC] Introduce new security.nscapability xattr
Date: Mon, 30 Nov 2015 21:51:50 -0600
Message-ID: <20151201035150.GB30348@mail.hallyn.com>
References: <20151130224356.GA27972@mail.hallyn.com>
 <87two3w0el.fsf@x220.int.ebiederm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <87two3w0el.fsf-JOvCrm2gF+uungPnsOpG7nhyD016LWXt@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>
Cc: "Serge E. Hallyn" <serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>, lkml <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Andrew Morgan <morgan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, lxc-devel-cunTk1MwBs9qMoObBWhMNEqPaTDuhLve2LY78lusg7I@public.gmane.org, Richard Weinberger <richard-/L3Ra7n9ekc@public.gmane.org>, LSM <linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Mon, Nov 30, 2015 at 05:08:34PM -0600, Eric W. Biederman wrote:
> "Serge E. Hallyn" <serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org> writes:
> 
> > A common way for daemons to run with minimal privilege is to start as root,
> > perhaps setuid-root, choose a desired capability set, set PR_SET_KEEPCAPS,
> > then change uid to non-root.  A simpler way to achieve this is to set file
> > capabilities on a not-setuid-root binary.  However, when installing a package
> > inside a (user-namespaced) container, packages cannot be installed with file
> > capabilities.  For this reason, containers must install ping setuid-root.
> 
> Don't ping sockets avoid that specific problem?
> 
> I expect the general case still holds.

Hah - yes, I guess do I have to update my 10 year old default example :)

> > To achieve this, we would need for containers to be able to request file
> > capabilities be added to a file without causing these to be honored in the
> > initial user namespace.
> >
> > To this end, the patch below introduces a new capability xattr format.  The
> > main enhancement over the existing security.capability xattr is that we
> > tag capability sets with a uid - the uid of the root user in the namespace
> > where the capabilities are set.  The capabilities will be ignored in any
> > other namespace.  The special case of uid == -1 (which must only ever be
> > able to be set by kuid 0) means use the capabilities in all
> > namespaces.
> 
> A quick comment on this.
> 
> We currently allow capabilities that have been gained to be valid in all
> descendent user namespaces.
> 
> Applying this principle to the on-disk capabilities would make it so
> that uid 0 would mean capabilities in all namespaces.
> 
> It might be worth it to introduce a fixed sized array with a length
> parameter of perhaps 32 entries which is a path of root uids as seen by
> the initial user namespace.  That way the entire construction of the
> user namespace could be verified.  AKA verify the current user namespace
> and the parent and the parents parent.  Up to the user namespace the

Hm, so if container b runs in container a, a has rootid 100000 and a
range of 200000, and b has root kuid 200000, range 65536, iiuc you're
suggesting that for a binary in container b we store [100000,200000] ?
I'm not sure that's helpful, though - uid 200000 in a user namespace
with 200000 mapped to root, is all powerful anyway.  I was actually
thinking (with the uid ranges) of making the connection looser, not
tighter.

> current filesystem is mounted in. We would look at how much space
> allows an xattr to be stored without causing filesystems a challenge
> to properly size such an array.
> 
> Given that uids are fundamentally flat that might not be particularly
> useful.

Right, I think that's the conclusion I've drawn above (if I'm not
misunderstanding you)

>   If we add an alternative way of identifying user namespaces
> say a privileged operation that set a uuid, then the complete path would
> be more interesting.
> 
> > An alternative format would use a pair of uids to indicate a range of rootids.
> > This would allow root in a user namespace with uids 100000-165536 mapped to
> > set the xattr once on a file, then launch nested containers wherein the file
> > could be used with privilege.  That's not what this patch does, but would be
> > a trivial change if people think it would be worthwhile.
> >
> > This patch does not actually address the real problem, which is setting the
> > xattrs from inside containers.  For that, I think the best solution is to
> > add a pair of new system calls, setfcap and getfcap. Userspace would for
> > instance call fsetfcap(fd, cap_user_header_t, cap_user_data_t), to which
> > the kernel would, if not in init_user_ns, react by writing an appropriate
> > security.nscapability xattr.
> 
> That feels hard to maintain, but you may be correct that we have a small

Hard to maintain in which sense?  Complicated for userspace software, or
becoming too complicated in the kernel's bprm-capabilities code?

> enough userspace that it would not be a problem.

Yeah I'm thinking we can hide it all behind libcap2.   Unless we go with
uid ranges, in which case we'd need a way to expose that, but that would
be an optional extension, the sane default would be transparent, so no big
deal.

-serge
