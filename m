From: "Serge E. Hallyn" <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>
Subject: Re: CGroup Namespaces (v4)
Date: Mon, 16 Nov 2015 19:13:49 -0600
Message-ID: <20151117011349.GA1958@mail.hallyn.com>
References: <1447703505-29672-1-git-send-email-serge@hallyn.com>
	<CAFLxGvzVmbZHrpaTmXUAK03hsnVPwEs3SJGNFNXfthh3NL8EDg@mail.gmail.com>
	<20151116204606.GA30681@mail.hallyn.com> <564A41AF.4040208@nod.at>
	<20151116205452.GA30975@mail.hallyn.com>
	<87y4dxh9b8.fsf@x220.int.ebiederm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <87y4dxh9b8.fsf-JOvCrm2gF+uungPnsOpG7nhyD016LWXt@public.gmane.org>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/containers>,
	<mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/containers/>
List-Post: <mailto:containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
List-Help: <mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/containers>,
	<mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=subscribe>
Sender: containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
Errors-To: containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
To: "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>
Cc: Richard Weinberger <richard-/L3Ra7n9ekc@public.gmane.org>, Linux Containers <containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, LXC development mailing-list <lxc-devel-cunTk1MwBs9qMoObBWhMNEqPaTDuhLve2LY78lusg7I@public.gmane.org>, "open list:ABI/API" <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, cgroups mailinglist <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Mon, Nov 16, 2015 at 04:24:27PM -0600, Eric W. Biederman wrote:
> "Serge E. Hallyn" <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org> writes:
> 
> > On Mon, Nov 16, 2015 at 09:50:55PM +0100, Richard Weinberger wrote:
> >> Am 16.11.2015 um 21:46 schrieb Serge E. Hallyn:
> >> > On Mon, Nov 16, 2015 at 09:41:15PM +0100, Richard Weinberger wrote:
> >> >> Serge,
> >> >>
> >> >> On Mon, Nov 16, 2015 at 8:51 PM,  <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org> wrote:
> >> >>> To summarize the semantics:
> >> >>>
> >> >>> 1. CLONE_NEWCGROUP re-uses 0x02000000, which was previously CLONE_STOPPED
> >> >>>
> >> >>> 2. unsharing a cgroup namespace makes all your current cgroups your new
> >> >>> cgroup root.
> >> >>>
> >> >>> 3. /proc/pid/cgroup always shows cgroup paths relative to the reader's
> >> >>> cgroup namespce root.  A task outside of  your cgroup looks like
> >> >>>
> >> >>>         8:memory:/../../..
> >> >>>
> >> >>> 4. when a task mounts a cgroupfs, the cgroup which shows up as root depends
> >> >>> on the mounting task's  cgroup namespace.
> >> >>>
> >> >>> 5. setns to a cgroup namespace switches your cgroup namespace but not
> >> >>> your cgroups.
> >> >>>
> >> >>> With this, using github.com/hallyn/lxc #2015-11-09/cgns (and
> >> >>> github.com/hallyn/lxcfs #2015-11-10/cgns) we can start a container in a full
> >> >>> proper cgroup namespace, avoiding either cgmanager or lxcfs cgroup bind mounts.
> >> >>>
> >> >>> This is completely backward compatible and will be completely invisible
> >> >>> to any existing cgroup users (except for those running inside a cgroup
> >> >>> namespace and looking at /proc/pid/cgroup of tasks outside their
> >> >>> namespace.)
> >> >>>    cgroupns-root.
> >> >>
> >> >> IIRC one downside of this series was that only the new "sane" cgroup
> >> >> layout was supported
> >> >> and hence it was useless for everything which expected the default layout.
> >> >> Hence, still no systemd for us. :)
> >> >>
> >> >> Is this now different?
> >> > 
> >> > Yes, all hierachies are no supported.
> >> > 
> >> 
> >> Should read "now"? :-)
> >> If so, *awesome*!
> >
> > D'oh!  Yes, now :-)
> 
> I am glad to see multiple hierarchy support, that is something people
> can use today.
> 
> A couple of quick questions before I delve into a review.
> 
> Does this allow mixing of cgroupfs and cgroupfs2?  That is can I: "mount
> -t cgroupfs" inside a container and "mount -t cgroupfs2" outside a
> container? and still have reasonable things happen?  I suspect the
> semantics of cgroups prevent this but I am interested to know what happens.

As Tejun said, this is not an issue.  There's not an actual separate cgroupfs2
filesystem, it's just a separate hierarchy which controllers can be bound to
or not, which has its own set of semantics (like no tasks on leafnodes).  So
a legacy application would never be able to run on the unified hierarchy, but
this does not change that.

> Similary have you considered what it required to be able to safely set
> FS_USERNS_MOUNT?

I think the only thing we need to do is

1. go through and make sure that any ability to change mount flags is under
capable() (which I have not yet done).  The cgroup_mount() itself checks that
flags are not changed, but there may be some subtle way to effect a change
that I'm not aware of yet.

2. Make sure that to bind a new controller you must be true root.  It's
possible that a patch like the one below would suffice.

-serge

>From 37699aa868cba3efb6ea0aa2e53e0b85b619f02d Mon Sep 17 00:00:00 2001
From: Serge Hallyn <serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>
Date: Mon, 16 Nov 2015 19:11:07 -0600
Subject: [PATCH 1/1] Don't allow user namespaces to bind new subsystems

If memory was not mounted on the host, then root in a container
should not be able to mount it.

Signed-off-by: Serge Hallyn <serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>
---
 kernel/cgroup.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 0a3e893..db514b4 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -2102,6 +2102,11 @@ static struct dentry *cgroup_mount(struct file_system_type *fs_type,
 		goto out_unlock;
 	}
 
+	if (!opts.none && !capable(CAP_SYS_ADMIN)) {
+		ret = -EPERM;
+		goto out_unlock;
+	}
+
 	root = kzalloc(sizeof(*root), GFP_KERNEL);
 	if (!root) {
 		ret = -ENOMEM;
-- 
2.5.0
