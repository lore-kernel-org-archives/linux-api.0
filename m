From: Eric Sandeen <sandeen-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: Documenting MS_LAZYTIME
Date: Mon, 23 Feb 2015 10:24:54 -0600
Message-ID: <54EB5456.5030607@redhat.com>
References: <CAHO5Pa0k7QkV_6BDjwTVxa7LV9tFyN9nGFFcSvOC6HYO08wfrw@mail.gmail.com> <54E7578E.4090809@redhat.com> <20150221025636.GB7922@thunk.org> <54EB1B19.8050808@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-man-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <54EB1B19.8050808-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-man-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Austin S Hemmelgarn <ahferroin7-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org>
Cc: Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Ext4 Developers List <linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux btrfs Developers List <linux-btrfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, XFS Developers <xfs-VZNHf3L845pBDgjK7y7TUQ@public.gmane.org>, linux-man-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linux-Fsdevel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On 2/23/15 6:20 AM, Austin S Hemmelgarn wrote:
> On 2015-02-20 21:56, Theodore Ts'o wrote:
>> On Fri, Feb 20, 2015 at 09:49:34AM -0600, Eric Sandeen wrote:
>>>
>>>>                This mount option significantly reduces  writes  to  the
>>>>                inode  table  for workloads that perform frequent random
>>>>                writes to preallocated files.
>>>
>>> This seems like an overly specific description of a single workload out
>>> of many which may benefit, but what do others think?  "inode table" is also
>>> fairly extN-specific.
>>
>> How about somethign like "This mount significantly reduces writes
>> needed to update the inode's timestamps, especially mtime and actime.
>> Examples of workloads where this could be a large win include frequent
>> random writes to preallocated files, as well as cases where the
>> MS_STRICTATIME mount option is enabled."?
>>
>> (The advantage of MS_STRICTATIME | MS_LAZYTIME is that stat system
>> calls will return the correctly updated atime, but those atime updates
>> won't get flushed to disk unless the inode needs to be updated for
>> file system / data consistency reasons, or when the inode is pushed
>> out of memory, or when the file system is unmounted.)
>>
> If you want to list some specific software, it should help with
> anything that uses sqlite (which notably includes firefox and
> chrome), as well as most RDMS software and systemd-journald.

I'm really uneasy with starting to list specific workloads and applications
here. It's going to get dated quickly, and will lead to endless cargo-cult
tuning.

I'd strongly prefer to just describe what it does (reduces the number of
certain metadata writes to disk) and leave it at that....

-Eric

--
To unsubscribe from this list: send the line "unsubscribe linux-man" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
