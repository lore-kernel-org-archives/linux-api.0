From: Andy Lutomirski <luto@amacapital.net>
Subject: Re: [v8 4/5] ext4: adds FS_IOC_FSSETXATTR/FS_IOC_FSGETXATTR interface support
Date: Fri, 23 Jan 2015 15:59:04 -0800
Message-ID: <CALCETrXPCrOTrkoAMuW2os=z6anaEfv4F4D2yDxo6VtCuEtRZw@mail.gmail.com>
References: <1418102548-5469-1-git-send-email-lixi@ddn.com>
 <1418102548-5469-5-git-send-email-lixi@ddn.com> <54C11733.7080801@yandex-team.ru>
 <20150123015307.GD24722@dastard> <54C23751.7000009@yandex-team.ru> <20150123233026.GP16552@dastard>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20150123233026.GP16552@dastard>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Dave Chinner <david@fromorbit.com>
Cc: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>, Li Xi <pkuelelixi@gmail.com>, Linux FS Devel <linux-fsdevel@vger.kernel.org>, "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, Theodore Ts'o <tytso@mit.edu>, Andreas Dilger <adilger@dilger.ca>, Jan Kara <jack@suse.cz>, Al Viro <viro@zeniv.linux.org.uk>, Christoph Hellwig <hch@infradead.org>, dmonakhov@openvz.org, "Eric W. Biederman" <ebiederm@xmission.com>
List-Id: linux-api@vger.kernel.org

On Fri, Jan 23, 2015 at 3:30 PM, Dave Chinner <david@fromorbit.com> wrote:
> On Fri, Jan 23, 2015 at 02:58:09PM +0300, Konstantin Khlebnikov wrote:
>> On 23.01.2015 04:53, Dave Chinner wrote:
>> >On Thu, Jan 22, 2015 at 06:28:51PM +0300, Konstantin Khlebnikov wrote:
>> >>>+  kprojid = make_kprojid(&init_user_ns, (projid_t)projid);
>> >>
>> >>Maybe current_user_ns()?
>> >>This code should be user-namespace aware from the beginning.
>> >
>> >No, the code is correct. Project quotas have nothing to do with
>> >UIDs and so should never have been included in the uid/gid
>> >namespace mapping infrastructure in the first place.
>>
>> Right, but user-namespace provides id mapping for project-id too.
>> This infrastructure adds support for nested project quotas with
>> virtualized ids in sub-containers. I couldn't say that this is
>> must have feature but implementation is trivial because whole
>> infrastructure is already here.
>
> This is an extremely common misunderstanding of project IDs. Project
> IDs are completely separate to the UID/GID namespace.  Project
> quotas were originally designed specifically for
> accounting/enforcing quotas in situations where uid/gid
> accounting/enforcing is not possible. This design intent goes back
> 25 years - it predates XFS...
>
> IOWs, mapping prids via user namespaces defeats the purpose
> for which prids were originally intended for.
>
>> >Point in case: directory subtree quotas can be used as a resource
>> >controller for limiting space usage within separate containers that
>> >share the same underlying (large) filesystem via mount namespaces.
>>
>> That's exactly my use-case: 'sub-volumes' for containers with
>> quota for space usage/inodes count.
>
> That doesn't require mapped project IDs. Hard container space limits
> can only be controlled by the init namespace, and because inodes can
> hold only one project ID the current ns cannot be allowed to change
> the project ID on the inode because that allows them to escape the
> resource limits set on the project ID associated with the sub-mount
> set up by the init namespace...
>
> i.e.
>
> /mnt                    prid = 0, default for entire fs.
> /mnt/container1/        prid = 1, inherit, 10GB space limit
> /mnt/container2/        prid = 2, inherit, 50GB space limit
> .....
> /mnt/containerN/        prid = N, inherit, 20GB space limit
>
> And you clone the mount namespace for each container so the root is
> at the appropriate /mnt/containerX/.  Now the containers have a
> fixed amount of space they can use in the parent filesystem they
> know nothing about, and it is enforced by directory subquotas
> controlled by the init namespace.  This "fixed amount of space" is
> reflected in the container namespace when "df" is run as it will
> report the project quota space limits. Adding or removing space to a
> container is as simple as changing the project quota limits from the
> init namespace. i.e. an admin operation controlled by the host, not
> the container....
>
> Allowing the container to modify the prid and/or the inherit bit of
> inodes in it's namespace then means the user can define their own
> space usage limits, even turn them off. It's not a resource
> container at that point because the user can define their own
> limits.  Hence, only if the current_ns cannot change project quotas
> will we have a hard fence on space usage that the container *cannot
> exceed*.

I think I must be missing something simple here.  In a hypothetical
world where the code used nsown_capable, if an admin wants to stick a
container in /mnt/container1 with associated prid 1 and a userns,
shouldn't it just map only prid 1 into the user ns?  Then a user in
that userns can't try to change the prid of a file to 2 because the
number "2" is unmapped for that user and translation will fail.

--Andy
