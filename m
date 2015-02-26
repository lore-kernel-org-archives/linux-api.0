From: "Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Documenting MS_LAZYTIME
Date: Thu, 26 Feb 2015 09:49:39 +0100
Message-ID: <54EEDE23.6080009@gmail.com>
References: <CAHO5Pa0k7QkV_6BDjwTVxa7LV9tFyN9nGFFcSvOC6HYO08wfrw@mail.gmail.com> <54E7578E.4090809@redhat.com> <20150221025636.GB7922@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-man-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150221025636.GB7922-AKGzg7BKzIDYtjvyW6yDsg@public.gmane.org>
Sender: linux-man-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org>, Eric Sandeen <sandeen-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, Ext4 Developers List <linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux btrfs Developers List <linux-btrfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, XFS Developers <xfs-VZNHf3L845pBDgjK7y7TUQ@public.gmane.org>, linux-man-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linux-Fsdevel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Ted,

On 02/21/2015 03:56 AM, Theodore Ts'o wrote:
> On Fri, Feb 20, 2015 at 09:49:34AM -0600, Eric Sandeen wrote:
>>
>>>               This mount option significantly reduces  writes  to  the
>>>               inode  table  for workloads that perform frequent random
>>>               writes to preallocated files.
>>
>> This seems like an overly specific description of a single workload out
>> of many which may benefit, but what do others think?  "inode table" is also
>> fairly extN-specific.
> 
> How about somethign like "This mount significantly reduces writes
> needed to update the inode's timestamps, especially mtime and actime.

What is "actime" in the preceding line? Should it be "ctime"?

> Examples of workloads where this could be a large win include frequent
> random writes to preallocated files, as well as cases where the
> MS_STRICTATIME mount option is enabled."?

I think some version of the following text could also usefully go 
into the page, but...

> (The advantage of MS_STRICTATIME | MS_LAZYTIME is that stat system
> calls will return the correctly updated atime, but those atime updates
> won't get flushed to disk unless the inode needs to be updated for
> file system / data consistency reasons, or when the inode is pushed
> out of memory, or when the file system is unmounted.)

I find the wording of there a little confusing. Is the following 
a correct rewrite:

    The advantage of MS_STRICTATIME | MS_LAZYTIME is that stat(2)
    will return the correctly updated atime, but the atime updates
    will be flushed to disk only when (1) the inode needs to be 
    updated for filesystem / data consistency reasons or (2) the 
    inode is pushed out of memory, or (3) the filesystem is 
    unmounted.)

?

Thanks,

Michael


-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Linux/UNIX System Programming Training: http://man7.org/training/
--
To unsubscribe from this list: send the line "unsubscribe linux-man" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
