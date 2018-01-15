From: "Serge E. Hallyn" <serge@hallyn.com>
Subject: Re: [manpages PATCH] capabilities.7: describe namespaced file
 capabilities
Date: Sun, 14 Jan 2018 22:31:51 -0600
Message-ID: <20180115043151.GA15983@mail.hallyn.com>
References: <20180109185218.GA21753@mail.hallyn.com>
 <5e434a9c-8ea9-afb1-700a-65f08f6e88fe@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-security-module-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <5e434a9c-8ea9-afb1-700a-65f08f6e88fe@gmail.com>
Sender: owner-linux-security-module@vger.kernel.org
To: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Cc: "Serge E. Hallyn" <serge@hallyn.com>, "Eric W. Biederman" <ebiederm@xmission.com>, linux-man@vger.kernel.org, Seth Forshee <seth.forshee@canonical.com>, linux-api@vger.kernel.org, linux-security-module@vger.kernel.org, Kees Cook <keescook@chromium.org>, Andreas Gruenbacher <agruenba@redhat.com>, Andy Lutomirski <luto@kernel.org>, "Andrew G. Morgan" <morgan@kernel.org>
List-Id: linux-api@vger.kernel.org

Quoting Michael Kerrisk (man-pages) (mtk.manpages@gmail.com):
> Hello Serge,
> 
> On 01/09/2018 07:52 PM, Serge E. Hallyn wrote:
> > Update the capabilities(7)  manpage with a description of the
> > new-ish namespaced file capability support.
> 
> Thanks for this patch. I'm trying to craft a modified version
> based on your text, so no need to send a new version at this
> stage, but I do have some questions below.

Awesome, thanks.

> > A note on userspace tools:  since the kernel will automatically
> > convert between v2 and v3 xattrs, and translate nsroot between
> > v3 xattrs, we can make do with the current getcap(8) and setcap(8)
> > tools. I.e. a user on the host can create a transient user namespace
> > with the appropriate mappings and run setcap(8) there.  The kernel
> > will automatically write a v3 xattr with the transient namespace's
> > root user as nsroot.
> >
> > Signed-off-by: Serge Hallyn <shallyn@cisco.com>
> > ---
> >  man7/capabilities.7 | 44 ++++++++++++++++++++++++++++++++++++++++++++
> >  1 file changed, 44 insertions(+)
> > 
> > diff --git a/man7/capabilities.7 b/man7/capabilities.7
> > index 166eaaf..76e7e02 100644
> > --- a/man7/capabilities.7
> > +++ b/man7/capabilities.7
> > @@ -936,6 +936,50 @@ if we specify the effective flag as being enabled for any capability,
> >  then the effective flag must also be specified as enabled
> >  for all other capabilities for which the corresponding permitted or
> >  inheritable flags is enabled.
> > +.PP
> > +Until 4.13, only VFS_CAP_REVISION_2 xattrs were supported.  These store only
> > +the capabilities to be applied to the file, with no record of the writer's
> > +credentials.  Therefore only privileged users can be trusted to write them, and
> > +.BR CAP_SETFCAP
> > +over the user namespace which mounted the filesystem (usually the initial user
> > +namespace) is required.  This makes it impossible to write file capabilities
> > +from a user namespaced container, which causes some package updates to fail.
> > +.PP
> > +In order to support setting file capabilities in containers, the
> > +kernel must be able to identify whether the task executing the
> > +file will be constrained to a subset of the resources over which
> > +the writer of the file capabilities has privilege.  To this end,
> > +since 4.13, VFS_CAP_REVISION_3 capabilities store the user ID
> > +of the root user in the writer's namespace ("nsroot").
> 
> Here, "nsroot" means the UID 0 in the namespace as it would be mapped
> into the initial userns, right?

Right.  If we can come up with a better name that would be great.

> > Hence the writer only
> > +requires
> > +.IP 1.
> > +.BR CAP_SETFCAP
> > +over the file inode, meaning the writing task must have
> > +.BR CAP_SETFCAP
> > +over a user namespace into which the inode's owning user ID is mapped.
> 
> I don't understand the above line. Could you explain with an example?

If the file is owned by uid 1000, then uid 1000 can create a new user
ns in which 1000 is mapped to .  In this namespace, the new task has
CAP_SETFCAP over the user ns, and 1000 is mapped into the userns (as
0), so the write is allowed.

In the above example, if the xattr being written was v2, then the
actual written xattr will be v3 with nsroot=1000

If the xattr was v3, with nsroot=0, then nsroot=1000 will be written.

If the xattr was v3, with nsroot=500, where 500 is not mapped from
the userns, then the write will be forbidden.

As another allowed case, if I'm uid 1000 and setting up a container
where 100005 is mapped to uid 5;  I create a userns where hostuids
100000-165535 map to namespace uids 0-65535, then as root in the
namespace I have CAP_SETFCAP over the namespace, and 100005 is
mapped in the namespace, so I can write to the file.

As a final, nested example:  I'm uid 1000 and have uids 100000-300000
as my delegated subuids.  I create a container with that full range,
and am running as root there (100000).  Now I create a nested container
where 100000-165535 (which are really 200000-265535 on the host) will
be mapped to 0-65535.  In its rootfs I write /bin/ping with cap_net_raw=pe
and just for fun make it owned by nested uid 5.

So /bin/ping is owned by
	hostuid 200005 = c1 uid 100005 = c2 uid 5
As root in the container I have CAP_SETFCAP over a userns where c2 uid 5
is mapped, so I'm allowed to write a filecap.
If I write it as v2 xattr, then the actual written xattr will be v3 with
nsroot=100000, if I simply write it as root in c1, or nsroot=200000 if
I enter the nested container before writing it.
There are several more options, but let's just pick one - and assume that
as root in the first container (hostuid 100000) I request a v3 xattr
with nsroot=100000.  The actual written xattr will ahve nsroot=200000.
now when uid 1000 in the nested container runs /bin/ping, the kernel will
see that that task's user namespace has uid 0 mapped to 200000, and so
the fscap will be honored.

-serge
