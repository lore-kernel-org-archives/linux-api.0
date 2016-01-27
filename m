From: "Serge E. Hallyn" <serge@hallyn.com>
Subject: Re: [PATCH RFC] Introduce new security.nscapability xattr
Date: Wed, 27 Jan 2016 10:08:15 -0600
Message-ID: <20160127160815.GA28787@mail.hallyn.com>
References: <20151130224356.GA27972@mail.hallyn.com>
 <87two3w0el.fsf@x220.int.ebiederm.org>
 <20151204202116.GA4809@mail.hallyn.com>
 <20160120124816.GB32379@pc.thejh.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160120124816.GB32379@pc.thejh.net>
Sender: linux-kernel-owner@vger.kernel.org
To: Jann Horn <jann@thejh.net>
Cc: "Serge E. Hallyn" <serge@hallyn.com>, "Eric W. Biederman" <ebiederm@xmission.com>, "Serge E. Hallyn" <serge.hallyn@ubuntu.com>, lkml <linux-kernel@vger.kernel.org>, Andrew Morgan <morgan@kernel.org>, Andy Lutomirski <luto@amacapital.net>, lxc-devel@lists.linuxcontainers.org, Richard Weinberger <richard@nod.at>, LSM <linux-security-module@vger.kernel.org>, linux-api@vger.kernel.org, keescook@chromium.org
List-Id: linux-api@vger.kernel.org

On Wed, Jan 20, 2016 at 01:48:16PM +0100, Jann Horn wrote:
> On Fri, Dec 04, 2015 at 02:21:16PM -0600, Serge E. Hallyn wrote:
> > Quoting Eric W. Biederman (ebiederm@xmission.com):
> > > "Serge E. Hallyn" <serge.hallyn@ubuntu.com> writes:
> > > 
> > > > A common way for daemons to run with minimal privilege is to start as root,
> > > > perhaps setuid-root, choose a desired capability set, set PR_SET_KEEPCAPS,
> > > > then change uid to non-root.  A simpler way to achieve this is to set file
> > > > capabilities on a not-setuid-root binary.  However, when installing a package
> > > > inside a (user-namespaced) container, packages cannot be installed with file
> > > > capabilities.  For this reason, containers must install ping setuid-root.
> > > 
> > > Don't ping sockets avoid that specific problem?
> > > 
> > > I expect the general case still holds.
> > > 
> > > > To achieve this, we would need for containers to be able to request file
> > > > capabilities be added to a file without causing these to be honored in the
> > > > initial user namespace.
> > > >
> > > > To this end, the patch below introduces a new capability xattr format.  The
> > > > main enhancement over the existing security.capability xattr is that we
> > > > tag capability sets with a uid - the uid of the root user in the namespace
> > > > where the capabilities are set.  The capabilities will be ignored in any
> > > > other namespace.  The special case of uid == -1 (which must only ever be
> > > > able to be set by kuid 0) means use the capabilities in all
> > > > namespaces.
> > 
> > really since security.capability xattrs are currently honored in all
> > namespaces this isn't really necessary.  Until and unless Seth's set
> > changes that.
> > 
> > > 
> > > A quick comment on this.
> > > 
> > > We currently allow capabilities that have been gained to be valid in all
> > > descendent user namespaces.
> > > 
> > > Applying this principle to the on-disk capabilities would make it so
> > > that uid 0 would mean capabilities in all namespaces.
> > > 
> > > It might be worth it to introduce a fixed sized array with a length
> > > parameter of perhaps 32 entries which is a path of root uids as seen by
> > > the initial user namespace.  That way the entire construction of the
> > > user namespace could be verified.  AKA verify the current user namespace
> > > and the parent and the parents parent.  Up to the user namespace the
> > > current filesystem is mounted in. We would look at how much space
> > > allows an xattr to be stored without causing filesystems a challenge
> > > to properly size such an array.
> > > 
> > > Given that uids are fundamentally flat that might not be particularly
> > > useful.  If we add an alternative way of identifying user namespaces
> > > say a privileged operation that set a uuid, then the complete path would
> > > be more interesting.
> > > 
> > > > An alternative format would use a pair of uids to indicate a range of rootids.
> > > > This would allow root in a user namespace with uids 100000-165536 mapped to
> > > > set the xattr once on a file, then launch nested containers wherein the file
> > > > could be used with privilege.  That's not what this patch does, but would be
> > > > a trivial change if people think it would be worthwhile.
> > > >
> > > > This patch does not actually address the real problem, which is setting the
> > > > xattrs from inside containers.  For that, I think the best solution is to
> > > > add a pair of new system calls, setfcap and getfcap. Userspace would for
> > > > instance call fsetfcap(fd, cap_user_header_t, cap_user_data_t), to which
> > > > the kernel would, if not in init_user_ns, react by writing an appropriate
> > > > security.nscapability xattr.
> > > 
> > > That feels hard to maintain, but you may be correct that we have a small
> > > enough userspace that it would not be a problem.
> > > 
> > > Eric
> > > 
> > > 
> > > > The libcap2 library's cap_set_file/cap_get_file could be switched over
> > > > transparently to use this to hide its use from all callers.
> > > >
> > > > Comments appreciated.
> > > >
> > > > Note - In this patch, file capabilities only work for containers which have
> > > > a root uid defined.  We may want to allow -1 uids to work in all
> > > > namespaces.  There certainly would be uses for this, but I'm a bit unsettled
> > > > about the implications of allowing a program privilege in a container where
> > > > there is no uid with privilege.  This needs more thought.
> > 
> > So for actually enabling (user-namespaced) containers to use these, there
> > are a few possibilities that come to mine.
> > 
> > 1. A new setfcap (/getfcap) syscall.  Uses mapped uid 0 from
> > current_user_ns() to write a value in the security.nscapability xattr.
> > Userspace doesn't need to worry at all about namespace issues.
> 
> Your patch has an "ncaps" field and supports giving (possibly different)
> privileges to different namespace root users.
> I think that with a setfcap() syscall as you describe, it would be hard
> to add more than one security.nscapability entry to a file without
> poking holes into stuff:
> 
> If setfcap() requires inode write access, every namespace root for whom
> a security.nscapability entry can be added can overwrite the file, so
> namespace roots might be able to execute code as each other.
> 
> If setfcap() doesn't require inode write access, that isn't a big
> security issue, but it allows unprivileged users to waste disk space
> in a writable-mounted filesystem on which they have no write access
> anywhere. I'm not sure whether that is a sufficiently big problem for
> anyone to care.
> 
> 
> Another issue with this would be that it makes restoring sub-namespace
> capabilities from a backup somewhat ugly, at least if you're not in the
> init ns: You'd have to parse the capabilities attribute, then, for every
> attribute you want to restore whose rootid doesn't refer to your
> namespace, clone(CLONE_NEWUSER), map the target uid to 0 from the parent
> process, seteuid(0), do the setfcap() and exit.
> 
> It would require less synchronization with my ptrace hardening patch
> that checks whether uids are mapped (if that lands, I don't think it has
> yet?) because that would allow you to first setuid, then clone(), map
> the uid to 0 inside the namespace and setfcap(), but it'd still require
> special-case code in backup software.
> 
> 
> > 2. Just expect userspace to write a xattr;  kernel checks that no values
> > are changed for any other namespaces.  This could be a lot of parsing and
> > verifying in the kernel.
> 
> This option would allow the first problem I described with option 1 (if
> it is a problem?) to be worked around by letting a helper in the outer
> namespace add capabilities for lower namespaces - but it wouldn't be

Note that regardless, the fscaps would still be stored as an xattr.
The setfcap/getfacp syscalls would be for convenience, but a suitably
privileged task in the init_user_ns could just write the xattr.

You've made a good point here and in your prev email: when a namespaced
file cap exists for say uid 1000, perhaps it should apply for every
descendent ns of uid 1000.  In this case maybe it makes sense to drop
the nscaps field and actually only allow one namespace fscap.  It must
be set by the owner of the file (i.e., uid 1000, or uid 0 if a
host-root-owned file) or someone privileged over it (i.e. uid 100000
who is root in his ns and i_sb->s_user_ns->owner for the file).

So if the host has /bin/ping with cap_net_raw=ep, any user in any
ns which can reach and xecute it can run the file with those privileges
(in their own ns).  If uid 1000 creates a user_ns with root 100000,
that container can create a $rootfs/bin/ping with cap_net_raw=ep
with uid tag 100000.  If that container creates a sub-container owned
by uid 150000, that container can also run $rootfs/bin/ping with
cap_net_raw=ep, but uid 1001 on the host does not.  Now we don't have
the risk of wasting disk space, and restoring a cap-endowed file in
a sub-userns is trivial.

In this case we can probably also do away with the setfcap() syscall,
as userspace only needs to look for the "0 x y" /proc/self/uid_map
entry and enter x in the xattr.

Does this seem reasonable and somewhat risk-averse?
