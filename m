From: Dave Chinner <david@fromorbit.com>
Subject: Re: [v8 4/5] ext4: adds FS_IOC_FSSETXATTR/FS_IOC_FSGETXATTR
 interface support
Date: Sat, 24 Jan 2015 10:30:26 +1100
Message-ID: <20150123233026.GP16552@dastard>
References: <1418102548-5469-1-git-send-email-lixi@ddn.com>
 <1418102548-5469-5-git-send-email-lixi@ddn.com>
 <54C11733.7080801@yandex-team.ru>
 <20150123015307.GD24722@dastard>
 <54C23751.7000009@yandex-team.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <54C23751.7000009@yandex-team.ru>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
Cc: Li Xi <pkuelelixi@gmail.com>, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, linux-api@vger.kernel.org, tytso@mit.edu, adilger@dilger.ca, jack@suse.cz, viro@zeniv.linux.org.uk, hch@infradead.org, dmonakhov@openvz.org, "Eric W. Biederman" <ebiederm@xmission.com>
List-Id: linux-api@vger.kernel.org

On Fri, Jan 23, 2015 at 02:58:09PM +0300, Konstantin Khlebnikov wrote:
> On 23.01.2015 04:53, Dave Chinner wrote:
> >On Thu, Jan 22, 2015 at 06:28:51PM +0300, Konstantin Khlebnikov wrote:
> >>>+	kprojid = make_kprojid(&init_user_ns, (projid_t)projid);
> >>
> >>Maybe current_user_ns()?
> >>This code should be user-namespace aware from the beginning.
> >
> >No, the code is correct. Project quotas have nothing to do with
> >UIDs and so should never have been included in the uid/gid
> >namespace mapping infrastructure in the first place.
> 
> Right, but user-namespace provides id mapping for project-id too.
> This infrastructure adds support for nested project quotas with
> virtualized ids in sub-containers. I couldn't say that this is
> must have feature but implementation is trivial because whole
> infrastructure is already here.

This is an extremely common misunderstanding of project IDs. Project
IDs are completely separate to the UID/GID namespace.  Project
quotas were originally designed specifically for
accounting/enforcing quotas in situations where uid/gid
accounting/enforcing is not possible. This design intent goes back
25 years - it predates XFS...

IOWs, mapping prids via user namespaces defeats the purpose
for which prids were originally intended for.

> >Point in case: directory subtree quotas can be used as a resource
> >controller for limiting space usage within separate containers that
> >share the same underlying (large) filesystem via mount namespaces.
> 
> That's exactly my use-case: 'sub-volumes' for containers with
> quota for space usage/inodes count.

That doesn't require mapped project IDs. Hard container space limits
can only be controlled by the init namespace, and because inodes can
hold only one project ID the current ns cannot be allowed to change
the project ID on the inode because that allows them to escape the
resource limits set on the project ID associated with the sub-mount
set up by the init namespace...

i.e.

/mnt			prid = 0, default for entire fs.
/mnt/container1/	prid = 1, inherit, 10GB space limit
/mnt/container2/	prid = 2, inherit, 50GB space limit
.....
/mnt/containerN/	prid = N, inherit, 20GB space limit

And you clone the mount namespace for each container so the root is
at the appropriate /mnt/containerX/.  Now the containers have a
fixed amount of space they can use in the parent filesystem they
know nothing about, and it is enforced by directory subquotas
controlled by the init namespace.  This "fixed amount of space" is
reflected in the container namespace when "df" is run as it will
report the project quota space limits. Adding or removing space to a
container is as simple as changing the project quota limits from the
init namespace. i.e. an admin operation controlled by the host, not
the container....

Allowing the container to modify the prid and/or the inherit bit of
inodes in it's namespace then means the user can define their own
space usage limits, even turn them off. It's not a resource
container at that point because the user can define their own
limits.  Hence, only if the current_ns cannot change project quotas
will we have a hard fence on space usage that the container *cannot
exceed*.

Yes, I know there are other use cases for project quotas *within* a
container as controlled by the user (same as existing project quota
usages), but we don't have the capability of storing multiple
project IDs on each inode, nor accounting/enforcement across
multiple project IDs on an inode. Nor, really, do we want to (on
disk format changes required) and hence we can have one or the
other but not both.

Further, in a containerised system, providing the admin with a
trivial and easy to manage mechanism to provide hard limits on
shared filesystem space usage of each container is far more
important than catering to the occasional user who might have a need
for project quotas inside a container.

These are the points I brought up when I initially reviewed the user
namespace patches - the userns developer ignored my concerns and the
code was merged without acknowledging them, let alone addressing
them.

As we (the XFS guys) have no way of knowing when such a distinction
should be made, and with the user ns developers being completely
unresponsive on the subject, we made the decision ourselves.  Our
only concern was to be consistent, safe and predictable and that
means we choose to only allow project quotas to be used as an
external container resource hardwall limit and hence *never* allow
access to project quotas inside container namespaces.

That's the long and the short of it. project IDs are independent of
user IDs and they cannot be sanely used both inside and outside user
namespaces at the same time. Hence they should never have been
included in the user namespace mappings in the first place.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
