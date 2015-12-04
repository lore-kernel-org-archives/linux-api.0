From: "Serge E. Hallyn" <serge@hallyn.com>
Subject: Re: [PATCH RFC] Introduce new security.nscapability xattr
Date: Fri, 4 Dec 2015 14:21:16 -0600
Message-ID: <20151204202116.GA4809@mail.hallyn.com>
References: <20151130224356.GA27972@mail.hallyn.com>
 <87two3w0el.fsf@x220.int.ebiederm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-security-module-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <87two3w0el.fsf@x220.int.ebiederm.org>
Sender: owner-linux-security-module@vger.kernel.org
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: "Serge E. Hallyn" <serge.hallyn@ubuntu.com>, lkml <linux-kernel@vger.kernel.org>, Andrew Morgan <morgan@kernel.org>, Andy Lutomirski <luto@amacapital.net>, lxc-devel@lists.linuxcontainers.org, Richard Weinberger <richard@nod.at>, LSM <linux-security-module@vger.kernel.org>, linux-api@vger.kernel.org, keescook@chromium.org
List-Id: linux-api@vger.kernel.org

Quoting Eric W. Biederman (ebiederm@xmission.com):
> "Serge E. Hallyn" <serge.hallyn@ubuntu.com> writes:
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
> 
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

really since security.capability xattrs are currently honored in all
namespaces this isn't really necessary.  Until and unless Seth's set
changes that.

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
> current filesystem is mounted in. We would look at how much space
> allows an xattr to be stored without causing filesystems a challenge
> to properly size such an array.
> 
> Given that uids are fundamentally flat that might not be particularly
> useful.  If we add an alternative way of identifying user namespaces
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
> enough userspace that it would not be a problem.
> 
> Eric
> 
> 
> > The libcap2 library's cap_set_file/cap_get_file could be switched over
> > transparently to use this to hide its use from all callers.
> >
> > Comments appreciated.
> >
> > Note - In this patch, file capabilities only work for containers which have
> > a root uid defined.  We may want to allow -1 uids to work in all
> > namespaces.  There certainly would be uses for this, but I'm a bit unsettled
> > about the implications of allowing a program privilege in a container where
> > there is no uid with privilege.  This needs more thought.

So for actually enabling (user-namespaced) containers to use these, there
are a few possibilities that come to mine.

1. A new setfcap (/getfcap) syscall.  Uses mapped uid 0 from
current_user_ns() to write a value in the security.nscapability xattr.
Userspace doesn't need to worry at all about namespace issues.

2. Just expect userspace to write a xattr;  kernel checks that no values
are changed for any other namespaces.  This could be a lot of parsing and
verifying in the kernel.

3. Switch the xattr scheme - instead of one security.nscapability xattr
with multiple entries, use security.nscapability.$(rootid).  Now the
kernel only needs to verify that the $rootid is valid for the writing
task, and we don't need a new syscall.  OTOH userspace needs to know
what it's doing.  Of course we can still hide that behind libcap2's helpers.

Any opinions on which way seems best?  1 does seem cleanest (and supports
use of seccomp if we want to forbit its use by some containers), but
involves a new pair of syscalls.  2 seems to me to be right out, but
others might disagree...

-serge
