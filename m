From: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
Subject: Re: [v8 4/5] ext4: adds FS_IOC_FSSETXATTR/FS_IOC_FSGETXATTR interface
 support
Date: Thu, 05 Feb 2015 12:32:02 +0300
Message-ID: <54D33892.6090404@yandex-team.ru>
References: <1418102548-5469-5-git-send-email-lixi@ddn.com> <54C11733.7080801@yandex-team.ru> <20150123015307.GD24722@dastard> <54C23751.7000009@yandex-team.ru> <20150123233026.GP16552@dastard> <CALCETrXPCrOTrkoAMuW2os=z6anaEfv4F4D2yDxo6VtCuEtRZw@mail.gmail.com> <20150127080239.GQ16552@dastard> <54C76C3D.4070404@yandex-team.ru> <20150128003746.GR16552@dastard> <54D23919.3000408@yandex-team.ru> <20150204225844.GA12722@dastard>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20150204225844.GA12722@dastard>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Dave Chinner <david@fromorbit.com>
Cc: Andy Lutomirski <luto@amacapital.net>, Li Xi <pkuelelixi@gmail.com>, Linux FS Devel <linux-fsdevel@vger.kernel.org>, "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, Theodore Ts'o <tytso@mit.edu>, Andreas Dilger <adilger@dilger.ca>, Jan Kara <jack@suse.cz>, Al Viro <viro@zeniv.linux.org.uk>, Christoph Hellwig <hch@infradead.org>, dmonakhov@openvz.org, "Eric W. Biederman" <ebiederm@xmission.com>
List-Id: linux-api@vger.kernel.org

On 05.02.2015 01:58, Dave Chinner wrote:
> On Wed, Feb 04, 2015 at 06:22:01PM +0300, Konstantin Khlebnikov wrote:
>> On 28.01.2015 03:37, Dave Chinner wrote:
>>> On Tue, Jan 27, 2015 at 01:45:17PM +0300, Konstantin Khlebnikov wrote:
>>>> On 27.01.2015 11:02, Dave Chinner wrote:
>>>>> On Fri, Jan 23, 2015 at 03:59:04PM -0800, Andy Lutomirski wrote:
>>>>>> On Fri, Jan 23, 2015 at 3:30 PM, Dave Chinner <david@fromorbit.com> wrote:
>>>>>>> On Fri, Jan 23, 2015 at 02:58:09PM +0300, Konstantin Khlebnikov wrote:
>>>>>>
>>>>>> I think I must be missing something simple here.  In a hypothetical
>>>>>> world where the code used nsown_capable, if an admin wants to stick a
>>>>>> container in /mnt/container1 with associated prid 1 and a userns,
>>>>>> shouldn't it just map only prid 1 into the user ns?  Then a user in
>>>>>> that userns can't try to change the prid of a file to 2 because the
>>>>>> number "2" is unmapped for that user and translation will fail.
>>>>>
>>>>> You've effectively said "yes, project quotas are enabled, but you
>>>>> only have a single ID, it's always turned on and you can't change it
>>>>> to anything else.
>>>>>
>>>>> So, why do they need to be mapped via user namespaces to enable
>>>>> this? Think about it a little harder:
>>>>>
>>>>> 	- Project IDs are not user IDs.
>>>>> 	- Project IDs are not a security/permission mechanism.
>
> First, I'll just point this out again...

Ok, I get it.

>>>> This might be useful even without containers : normal user quota has
>>>> two levels and admins might classify users into groups and set group
>>>> quota for them. Project quota is flat and cannot provide any control
>>>> if we want classify projects.
>>>
>>> I don't follow. project ID is exactly what allows you to control
>>> project classification.
>>
>> I mean hierarchy allows to group several projects into one super-project
>> which sums all disk usage and could have its own limit too.
>
> Yes, I know, but you can also do this resource management from
> userspace with the existing project quota tools. It's just a matter
> of layering heirarchical limit management on top of the existing
> infrastructure.

Yes but not in all cases: it's impossible to overcommit disk limits on 
project level without overcommiting on super-project level.
Hierarchical quotas can handle this [ hypothetically useful ] use case.

>>
>> For now I'm more interested in participation disk space among services
>> in one system. As I see security model of project quota in XFS almost
>> non-existent for this case: it forbids linking/renaming files between
>> different projects but any unprivileged user might change project id
>> for its own files. That's strange, this operation should be privileged.
>
> <sigh>
>
> It's clear you don't understand the design/architecture of project
> quotas. You've clearly read the code, but you haven't understood
> the design that lead to the specific implementation in XFS.
>
> Users have *always* been allowed to set the project ID of
> their own files. How else are they going to set the project ID on
> files they create in random directories so to account them to the
> correct project they are working on?

In this case project disk limits are almost useless and even dangerous 
because any unprivileged user could add files into limited project
witch belongs to other user.

>
> However, you keep making the assumption that project quotas ==
> directory subtree quotas.  Project quotas are *not limited* to
> directory subtrees - the subtree quota implementation is just an
> implementation that *sets the default project ID* on files as they
> are created.
>
> e.g. there are production systems out there where project quotas are
> used to track home directory space usage rather than user quotas.
> This means users can take actions like "this file actually belongs
> to project X and it shouldn't be accounted against my home
> directory". Users can create their own sub directories that account
> everything by default to project X rather than their own home
> directory.
>
> Again: project quotas are an *accounting* mechanism, not a security
> mechanism.
>
> Containers are *security mechanism* and hence we need a security
> model for container resource controller mechanisms. Project quotas
> do not provide a directory heirarchy access security model - that's
> what we use mount namespaces for. The resource controller security
> model only has to prevent users inside the container from subverting
> the resource controller mechanism, not anything else.
>
> Not surprisingly, we've implemented *exactly* the model you are
> suggesting: that modification of the resource accounting mechanism
> is a privileged operation that cannot be accessed from within the
> container. i.e. inside a userns container you can't change the
> project ID on a file, not even as root.
>
>> Also if user have permission for changing project id he could be
>> permitted to link and rename file into directory with any project
>> id, because he anyway could change project, move, and revert it
>> back.
>
> You don't appear to understand why XFS forbids linking/renaming
> across directories different project IDs. Hint: it's resource
> accounting simplification, *not a security mechanism*.
>
> Linking is obvious: you can't have the same inode accounted to
> multiple projects - it belongs to a single project and so can't be
> accounted to multiple projects. Hence if you want to link across
> different directory-based project quotas, you have to use symlinks.
>
> That's much simpler than having to decide what project the inode is
> accounted to, especially when removing links and link that owns the
> project ID is removed. How do you even know the link you are
> removing is the last link in the current project? IOWs, you have to
> search for the other owners of the inode to determine who the
> project quota is now accounted to...

But you have to search hardlinks everywhere (inode owner can hardlink it 
into any directory where he has write access because project can be 
changed temporary). And after that you have to search broken symlinks.
Also symlinks cannot share file between isolated containers which run in 
chroot while creating hardlinks is still possible but requires some
extra steps like changing project id or creating temporary directories
even if you're root.

Not so useful too. Probably that's the reason why this feature seems
never been implemented anywhere except xfs.

Could we change that? For example by adding flag into quota-info block
which makes project id more restrictive and useful?

>
> Same for rename: there are a multitude of nasty corner cases when it
> comes to accounting the quotas correctly. So, either we try to do
> something complex and likely expensive and buggy, or we can return
> EXDEV. EXDEV was very carefully chosen here, and it's not for
> security reasons. It was chosen because applications know that if a
> rename returns EXDEV, they've got to *copy* the file instead. And,
> well, that create/write/unlink process results in correct project
> quota accounting at both the source and destination.
>
> IOWs: EXDEV not a security mechanism, it's an accounting mechanism.
>
> If you can implement project quota rename accounting and handle the
> multiple handlinks problem efficiently, then you can allow those
> things to be done directly in the filesystem rather than returning
> EXDEV.
>
>> For me perfect interface looks like couple fcntls for
>> getting/changing project id:
>>
>> int fcntl(fd, F_GET_PROJECT, projid_t *);
>> int fcntl(fd, F_SET_PROJECT, projid_t);
>>
>> F_GET_PROJECT is allowed for everybody
>> F_SET_PROJECT requires CAP_SYS_ADMIN (or maybe CAP_FOWNER?)
>
> Sure, it's nice, but you're ignoring the entire the point of making
> FS_IOC_SETXATTR generic: so that the *existing tools* that manage
> project quotas work on all project quota enabled filesystems.
> i.e. so that all filesystems *behave the same* and can *run
> identical regression tests*.

As i see quota tools in xfsprogs checks file-system name and doesn't
work for anything except "xfs", so we have to patch it anywas.
xfstests are cool but I think fixing one ioctl isn't a problem.
Something else?

>
> We do not want different project quota implementations on different
> filesystems. Like user and group quotas, they need to be
> consistently implemented across all filesystems. If you want
> something new, different and incompatible with existing
> infrastructure, then that's a separate line of development and
> discussion....
>
> Cheers,
>
> Dave.
>


-- 
Konstantin
