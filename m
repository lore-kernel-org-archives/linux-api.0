From: Dave Chinner <david@fromorbit.com>
Subject: Re: [v8 4/5] ext4: adds FS_IOC_FSSETXATTR/FS_IOC_FSGETXATTR
 interface support
Date: Wed, 28 Jan 2015 11:37:46 +1100
Message-ID: <20150128003746.GR16552@dastard>
References: <1418102548-5469-1-git-send-email-lixi@ddn.com>
 <1418102548-5469-5-git-send-email-lixi@ddn.com>
 <54C11733.7080801@yandex-team.ru>
 <20150123015307.GD24722@dastard>
 <54C23751.7000009@yandex-team.ru>
 <20150123233026.GP16552@dastard>
 <CALCETrXPCrOTrkoAMuW2os=z6anaEfv4F4D2yDxo6VtCuEtRZw@mail.gmail.com>
 <20150127080239.GQ16552@dastard>
 <54C76C3D.4070404@yandex-team.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ext4-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <54C76C3D.4070404@yandex-team.ru>
Sender: linux-ext4-owner@vger.kernel.org
To: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
Cc: Andy Lutomirski <luto@amacapital.net>, Li Xi <pkuelelixi@gmail.com>, Linux FS Devel <linux-fsdevel@vger.kernel.org>, "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, Theodore Ts'o <tytso@mit.edu>, Andreas Dilger <adilger@dilger.ca>, Jan Kara <jack@suse.cz>, Al Viro <viro@zeniv.linux.org.uk>, Christoph Hellwig <hch@infradead.org>, dmonakhov@openvz.org, "Eric W. Biederman" <ebiederm@xmission.com>
List-Id: linux-api@vger.kernel.org

On Tue, Jan 27, 2015 at 01:45:17PM +0300, Konstantin Khlebnikov wrote:
> On 27.01.2015 11:02, Dave Chinner wrote:
> >On Fri, Jan 23, 2015 at 03:59:04PM -0800, Andy Lutomirski wrote:
> >>On Fri, Jan 23, 2015 at 3:30 PM, Dave Chinner <david@fromorbit.com> wrote:
> >>>On Fri, Jan 23, 2015 at 02:58:09PM +0300, Konstantin Khlebnikov wrote:
> >>
> >>I think I must be missing something simple here.  In a hypothetical
> >>world where the code used nsown_capable, if an admin wants to stick a
> >>container in /mnt/container1 with associated prid 1 and a userns,
> >>shouldn't it just map only prid 1 into the user ns?  Then a user in
> >>that userns can't try to change the prid of a file to 2 because the
> >>number "2" is unmapped for that user and translation will fail.
> >
> >You've effectively said "yes, project quotas are enabled, but you
> >only have a single ID, it's always turned on and you can't change it
> >to anything else.
> >
> >So, why do they need to be mapped via user namespaces to enable
> >this? Think about it a little harder:
> >
> >	- Project IDs are not user IDs.
> >	- Project IDs are not a security/permission mechanism.
> >	- Project quotas only provide a mechanism for
> >	  resource usage control.
> >
> >Think about that last one some more. Perhaps, as a hint, I should
> >relate it to control groups? :) i.e:
> >
> >	- Project quotas can be used as an effective mount ns space
> >	  usage controller.
> >
> >But this can only be safely and reliably by keeping the project IDs
> >inaccessible from the containers themselves. I don't see why a
> >mechanism that controls the amount of filesystem space used by a
> >container should be considered any differently to a memory control
> >group that limits the amount of memory the container can use.
> >
> >However, nobody on the container side of things would answer any of
> >my questions about how project quotas were going to be used,
> >limited, managed, etc back when we had to make a decision to enable
> >XFS user ns support, I did what was needed to support the obvious
> >container use case and close any possible loop hole that containers
> >might be able to use to subvert that use case.
> 
> I have a solution: Hierarchical Project Quota! Each project might have
> parent project and so on. Each level keeps usage, limits and also keeps
> some preallocation from parent level to reduce count of quota updates.

That's an utter nightmare to manage - just ask the gluster guys who
thought this was a good idea when they first implemented quotas.

Besides, following down the path of heirarchical control groups
doesn't seem like a good idea to me because that path has already
proven to be a bad idea for container resource controllers. There's
good reason why control groups have gone back to a flattened ID
space like we already have for project quotas, so I don't think we
want to go that way.

> This might be useful even without containers : normal user quota has
> two levels and admins might classify users into groups and set group
> quota for them. Project quota is flat and cannot provide any control
> if we want classify projects.

I don't follow. project ID is exactly what allows you to control
project classification.

> For containers hierarchy provide full virtualization: user-namespace
> maps maps second-level and projects into subset of real projects.

It's not the mapping that matters - if project quotas are used
outside containers as a resource controller, then they can't be
used inside containers even with a unique mapping range because
we can only store a single project ID per inode.

Besides, I'm struggling to see the use case for project quotas
inside small containers that run single applications and typically
only have a single user. Project quotas have traditionally been used
to manage space in large filesystems shared by many users along
bounds that don't follow any specific heirarchy or permission set.

IOWs, you haven't described your use case for needing project quotas
inside containers, so I've got no idea what problem you are trying
to solve or whether project quotas are even appropriate as a
solution.

> Changing limits and other managing for second-level project quotas
> could be done in user-space by system service (systemd I suppose. lol),
> so we don't have to manage this stuff inside the kernel.

So you are proposing a fourth on-disk quota here i.e.  user, group,
project, new_2nd_level_project? If so, forget about using systemd to
manage it, the first thing we'll need is need full support in
existing quota tools so that the regression tests you write for
xfstests are self contained.

> [ I'm already working on prototype for ext4 ]

You really need to post a use case description and  adesign document
for review so we can actually discuss what you are planning. So far
everything you are doing strikes me as a "because they are there and
it sounds cool" type of development, not because people actually
need them. Let's have a discussion about the real problems and
architecture, not waste time on a stupid "solution looking for a
problem" discussion...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
