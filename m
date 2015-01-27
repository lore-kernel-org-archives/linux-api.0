From: Konstantin Khlebnikov <khlebnikov-XoJtRXgx1JseBXzfvpsJ4g@public.gmane.org>
Subject: Re: [v8 4/5] ext4: adds FS_IOC_FSSETXATTR/FS_IOC_FSGETXATTR interface
 support
Date: Tue, 27 Jan 2015 13:45:17 +0300
Message-ID: <54C76C3D.4070404@yandex-team.ru>
References: <1418102548-5469-1-git-send-email-lixi@ddn.com> <1418102548-5469-5-git-send-email-lixi@ddn.com> <54C11733.7080801@yandex-team.ru> <20150123015307.GD24722@dastard> <54C23751.7000009@yandex-team.ru> <20150123233026.GP16552@dastard> <CALCETrXPCrOTrkoAMuW2os=z6anaEfv4F4D2yDxo6VtCuEtRZw@mail.gmail.com> <20150127080239.GQ16552@dastard>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150127080239.GQ16552@dastard>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
Cc: Li Xi <pkuelelixi-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Linux FS Devel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org>, Andreas Dilger <adilger-m1MBpc4rdrD3fQ9qLvQP4Q@public.gmane.org>, Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>, Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, dmonakhov-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On 27.01.2015 11:02, Dave Chinner wrote:
> On Fri, Jan 23, 2015 at 03:59:04PM -0800, Andy Lutomirski wrote:
>> On Fri, Jan 23, 2015 at 3:30 PM, Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org> wrote:
>>> On Fri, Jan 23, 2015 at 02:58:09PM +0300, Konstantin Khlebnikov wrote:
>>>> On 23.01.2015 04:53, Dave Chinner wrote:
>>>>> On Thu, Jan 22, 2015 at 06:28:51PM +0300, Konstantin Khlebnikov wrote:
>>>>>>> +  kprojid = make_kprojid(&init_user_ns, (projid_t)projid);
>>>>>>
>>>>>> Maybe current_user_ns()?
>>>>>> This code should be user-namespace aware from the beginning.
>>>>>
>>>>> No, the code is correct. Project quotas have nothing to do with
>>>>> UIDs and so should never have been included in the uid/gid
>>>>> namespace mapping infrastructure in the first place.
>>>>
>>>> Right, but user-namespace provides id mapping for project-id too.
>>>> This infrastructure adds support for nested project quotas with
>>>> virtualized ids in sub-containers. I couldn't say that this is
>>>> must have feature but implementation is trivial because whole
>>>> infrastructure is already here.
>>>
>>> This is an extremely common misunderstanding of project IDs. Project
>>> IDs are completely separate to the UID/GID namespace.  Project
>>> quotas were originally designed specifically for
>>> accounting/enforcing quotas in situations where uid/gid
>>> accounting/enforcing is not possible. This design intent goes back
>>> 25 years - it predates XFS...
>>>
>>> IOWs, mapping prids via user namespaces defeats the purpose
>>> for which prids were originally intended for.
>>>
>>>>> Point in case: directory subtree quotas can be used as a resource
>>>>> controller for limiting space usage within separate containers that
>>>>> share the same underlying (large) filesystem via mount namespaces.
>>>>
>>>> That's exactly my use-case: 'sub-volumes' for containers with
>>>> quota for space usage/inodes count.
>>>
>>> That doesn't require mapped project IDs. Hard container space limits
>>> can only be controlled by the init namespace, and because inodes can
>>> hold only one project ID the current ns cannot be allowed to change
>>> the project ID on the inode because that allows them to escape the
>>> resource limits set on the project ID associated with the sub-mount
>>> set up by the init namespace...
>>>
>>> i.e.
>>>
>>> /mnt                    prid = 0, default for entire fs.
>>> /mnt/container1/        prid = 1, inherit, 10GB space limit
>>> /mnt/container2/        prid = 2, inherit, 50GB space limit
>>> .....
>>> /mnt/containerN/        prid = N, inherit, 20GB space limit
>>>
>>> And you clone the mount namespace for each container so the root is
>>> at the appropriate /mnt/containerX/.  Now the containers have a
>>> fixed amount of space they can use in the parent filesystem they
>>> know nothing about, and it is enforced by directory subquotas
>>> controlled by the init namespace.  This "fixed amount of space" is
>>> reflected in the container namespace when "df" is run as it will
>>> report the project quota space limits. Adding or removing space to a
>>> container is as simple as changing the project quota limits from the
>>> init namespace. i.e. an admin operation controlled by the host, not
>>> the container....
>>>
>>> Allowing the container to modify the prid and/or the inherit bit of
>>> inodes in it's namespace then means the user can define their own
>>> space usage limits, even turn them off. It's not a resource
>>> container at that point because the user can define their own
>>> limits.  Hence, only if the current_ns cannot change project quotas
>>> will we have a hard fence on space usage that the container *cannot
>>> exceed*.
>>
>> I think I must be missing something simple here.  In a hypothetical
>> world where the code used nsown_capable, if an admin wants to stick a
>> container in /mnt/container1 with associated prid 1 and a userns,
>> shouldn't it just map only prid 1 into the user ns?  Then a user in
>> that userns can't try to change the prid of a file to 2 because the
>> number "2" is unmapped for that user and translation will fail.
>
> You've effectively said "yes, project quotas are enabled, but you
> only have a single ID, it's always turned on and you can't change it
> to anything else.
>
> So, why do they need to be mapped via user namespaces to enable
> this? Think about it a little harder:
>
> 	- Project IDs are not user IDs.
> 	- Project IDs are not a security/permission mechanism.
> 	- Project quotas only provide a mechanism for
> 	  resource usage control.
>
> Think about that last one some more. Perhaps, as a hint, I should
> relate it to control groups? :) i.e:
>
> 	- Project quotas can be used as an effective mount ns space
> 	  usage controller.
>
> But this can only be safely and reliably by keeping the project IDs
> inaccessible from the containers themselves. I don't see why a
> mechanism that controls the amount of filesystem space used by a
> container should be considered any differently to a memory control
> group that limits the amount of memory the container can use.
>
> However, nobody on the container side of things would answer any of
> my questions about how project quotas were going to be used,
> limited, managed, etc back when we had to make a decision to enable
> XFS user ns support, I did what was needed to support the obvious
> container use case and close any possible loop hole that containers
> might be able to use to subvert that use case.

I have a solution: Hierarchical Project Quota! Each project might have
parent project and so on. Each level keeps usage, limits and also keeps
some preallocation from parent level to reduce count of quota updates.

This might be useful even without containers : normal user quota has
two levels and admins might classify users into groups and set group
quota for them. Project quota is flat and cannot provide any control
if we want classify projects.

For containers hierarchy provide full virtualization: user-namespace
maps maps second-level and projects into subset of real projects.

Changing limits and other managing for second-level project quotas
could be done in user-space by system service (systemd I suppose. lol),
so we don't have to manage this stuff inside the kernel.

[ I'm already working on prototype for ext4 ]

>
> If we want to do anything different, then there's a *lot* of
> userns aware regression tests needed to be written for xfstests....
>
> Cheers,
>
> Dave.
>
