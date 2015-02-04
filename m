From: Konstantin Khlebnikov <khlebnikov-XoJtRXgx1JseBXzfvpsJ4g@public.gmane.org>
Subject: Re: [v8 4/5] ext4: adds FS_IOC_FSSETXATTR/FS_IOC_FSGETXATTR interface
 support
Date: Wed, 04 Feb 2015 18:22:01 +0300
Message-ID: <54D23919.3000408@yandex-team.ru>
References: <1418102548-5469-1-git-send-email-lixi@ddn.com> <1418102548-5469-5-git-send-email-lixi@ddn.com> <54C11733.7080801@yandex-team.ru> <20150123015307.GD24722@dastard> <54C23751.7000009@yandex-team.ru> <20150123233026.GP16552@dastard> <CALCETrXPCrOTrkoAMuW2os=z6anaEfv4F4D2yDxo6VtCuEtRZw@mail.gmail.com> <20150127080239.GQ16552@dastard> <54C76C3D.4070404@yandex-team.ru> <20150128003746.GR16552@dastard>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150128003746.GR16552@dastard>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>
Cc: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Li Xi <pkuelelixi-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Linux FS Devel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org>, Andreas Dilger <adilger-m1MBpc4rdrD3fQ9qLvQP4Q@public.gmane.org>, Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>, Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, dmonakhov-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On 28.01.2015 03:37, Dave Chinner wrote:
> On Tue, Jan 27, 2015 at 01:45:17PM +0300, Konstantin Khlebnikov wrote:
>> On 27.01.2015 11:02, Dave Chinner wrote:
>>> On Fri, Jan 23, 2015 at 03:59:04PM -0800, Andy Lutomirski wrote:
>>>> On Fri, Jan 23, 2015 at 3:30 PM, Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org> wrote:
>>>>> On Fri, Jan 23, 2015 at 02:58:09PM +0300, Konstantin Khlebnikov wrote:
>>>>
>>>> I think I must be missing something simple here.  In a hypothetical
>>>> world where the code used nsown_capable, if an admin wants to stick a
>>>> container in /mnt/container1 with associated prid 1 and a userns,
>>>> shouldn't it just map only prid 1 into the user ns?  Then a user in
>>>> that userns can't try to change the prid of a file to 2 because the
>>>> number "2" is unmapped for that user and translation will fail.
>>>
>>> You've effectively said "yes, project quotas are enabled, but you
>>> only have a single ID, it's always turned on and you can't change it
>>> to anything else.
>>>
>>> So, why do they need to be mapped via user namespaces to enable
>>> this? Think about it a little harder:
>>>
>>> 	- Project IDs are not user IDs.
>>> 	- Project IDs are not a security/permission mechanism.
>>> 	- Project quotas only provide a mechanism for
>>> 	  resource usage control.
>>>
>>> Think about that last one some more. Perhaps, as a hint, I should
>>> relate it to control groups? :) i.e:
>>>
>>> 	- Project quotas can be used as an effective mount ns space
>>> 	  usage controller.
>>>
>>> But this can only be safely and reliably by keeping the project IDs
>>> inaccessible from the containers themselves. I don't see why a
>>> mechanism that controls the amount of filesystem space used by a
>>> container should be considered any differently to a memory control
>>> group that limits the amount of memory the container can use.
>>>
>>> However, nobody on the container side of things would answer any of
>>> my questions about how project quotas were going to be used,
>>> limited, managed, etc back when we had to make a decision to enable
>>> XFS user ns support, I did what was needed to support the obvious
>>> container use case and close any possible loop hole that containers
>>> might be able to use to subvert that use case.
>>
>> I have a solution: Hierarchical Project Quota! Each project might have
>> parent project and so on. Each level keeps usage, limits and also keeps
>> some preallocation from parent level to reduce count of quota updates.
>
> That's an utter nightmare to manage - just ask the gluster guys who
> thought this was a good idea when they first implemented quotas.
>
> Besides, following down the path of heirarchical control groups
> doesn't seem like a good idea to me because that path has already
> proven to be a bad idea for container resource controllers. There's
> good reason why control groups have gone back to a flattened ID
> space like we already have for project quotas, so I don't think we
> want to go that way.
>
>> This might be useful even without containers : normal user quota has
>> two levels and admins might classify users into groups and set group
>> quota for them. Project quota is flat and cannot provide any control
>> if we want classify projects.
>
> I don't follow. project ID is exactly what allows you to control
> project classification.

I mean hierarchy allows to group several projects into one super-project
which sums all disk usage and could have its own limit too.

>
>> For containers hierarchy provide full virtualization: user-namespace
>> maps maps second-level and projects into subset of real projects.
>
> It's not the mapping that matters - if project quotas are used
> outside containers as a resource controller, then they can't be
> used inside containers even with a unique mapping range because
> we can only store a single project ID per inode.
>
> Besides, I'm struggling to see the use case for project quotas
> inside small containers that run single applications and typically
> only have a single user. Project quotas have traditionally been used
> to manage space in large filesystems shared by many users along
> bounds that don't follow any specific heirarchy or permission set.
>
> IOWs, you haven't described your use case for needing project quotas
> inside containers, so I've got no idea what problem you are trying
> to solve or whether project quotas are even appropriate as a
> solution.

Some people run inside containers complete distributives with multiple
services or even nested virtualization.

I've poked this code and played with some use-cases.
Hierarchical project quotas are cool and it seems the only option for
virtualization and providing seamless nested project quotas inside
containers. But, right now I'm not so interested in this feature.
Let's leave this for the future.


For now I'm more interested in participation disk space among services
in one system. As I see security model of project quota in XFS almost
non-existent for this case: it forbids linking/renaming files between
different projects but any unprivileged user might change project id
for its own files. That's strange, this operation should be privileged.

Also if user have permission for changing project id he could be
permitted to link and rename file into directory with any project id, 
because he anyway could change project, move, and revert it back.


For me perfect interface looks like couple fcntls for getting/changing 
project id:

int fcntl(fd, F_GET_PROJECT, projid_t *);
int fcntl(fd, F_SET_PROJECT, projid_t);

F_GET_PROJECT is allowed for everybody
F_SET_PROJECT requires CAP_SYS_ADMIN (or maybe CAP_FOWNER?)
(for virtualization id also must be mapped in user-ns)

ioctl XFS_IOC_FSSETXATTR should stay xfs specific.
And XFS_DIFLAG_PROJINHERIT should stay XFS-only feature too.
I don't see any use cases for that flag. For files is has no effect
for directories it's mostly equal to setting directory project id
to zero. The only difference in accounting directory itself.

Cross-project renaming/linking must be allowed if user have
permissions for changing project id at file and directory.
This is useful for sharing files between containers.

-- 
Konstantin
