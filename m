From: "Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Revised statx(2) man page for review
Date: Tue, 25 Apr 2017 21:40:12 +0200
Message-ID: <0f9096b0-0055-9c04-110d-4c08cb1ff056@gmail.com>
References: <f3ef2be8-dfa5-e1dd-2315-d787a2a2acc3@gmail.com>
 <20170425185032.nohoaxbke7r5w5jt@myarchbang.ff3l>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-man-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170425185032.nohoaxbke7r5w5jt-Ug7NTYnKI+9o9fKphESQjg@public.gmane.org>
Sender: linux-man-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Silvan Jegen <s.jegen-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, lkml <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-man <linux-man-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Hello Silvan,

On 04/25/2017 08:50 PM, Silvan Jegen wrote:
> Hi Michael
> 
> On Tue, Apr 25, 2017 at 01:14:26PM +0200, Michael Kerrisk (man-pages) wrote:
>>
>> [...]
>>
>> Could you please carefully review the text below, in case 
>> I added any errors.
> 
> Just a few comments below.
> 
>  
>> [...] 
>>
>>    Invoking statx():
>>        To  access  a file's status, no permissions are required on the
>>        file itself, but in the case of statx() with a  pathname,  exe‐
>>        cute  (search) permission is required on all of the directories
>>        in pathname that lead to the file.
>>
>>        statx() uses pathname, dirfd, and  flags  identify  the  target
> 
> This should be:
> 
> "statx() uses pathname, dirfd, and  flags  *to* identify  the  target"

Fixed.

>> [...] 
>>
>>        AT_STATX_SYNC_AS_STAT
>>               Do  whatever  stat(2)  does.  This is the default and is
>>               very much filesystem specific.
> 
> Since we write "Linux-specific" further above we should probably use
> 
> "very much filesystem-specific."

Fixed.

> here for consistency.
> 
> 
>>        AT_STATX_FORCE_SYNC
>>               Force the attributes to be synchronized with the server.
>>               This  may  require  that  a network filesystem perform a
>>               data writeback to get the timestamps correct.
>>
>>        AT_STATX_DONT_SYNC
>>               Don't synchronize anything, but rather just  take  what‐
>>               ever  the  system has cached if possible.  This may mean
>>               that the information returned is approximate, but, on  a
>>               network  filesystem,  it may not involve a round trip to
>>               the server - even if no lease is held.
>>
>>        The mask argument to statx() is used to tell the  kernel  which
>>        fields  the  caller is interested in.  mask is an ORed combina‐
>>        tion of the following constants:
>>
>>            STATX_TYPE          Want stx_mode & S_IFMT
>>            STATX_MODE          Want stx_mode & ~S_IFMT
>>            STATX_NLINK         Want stx_nlink
>>            STATX_UID           Want stx_uid
>>            STATX_GID           Want stx_gid
>>            STATX_ATIME         Want stx_atime
>>            STATX_MTIME         Want stx_mtime
>>            STATX_CTIME         Want stx_ctime
>>            STATX_INO           Want stx_ino
>>            STATX_SIZE          Want stx_size
>>            STATX_BLOCKS        Want stx_blocks
>>            STATX_BASIC_STATS   [All of the above]
>>            STATX_BTIME         Want stx_btime
>>            STATX_ALL           [All currently available fields]
>>
>>        Note the kernel does not reject values in mask other  than  the
> 
> We should probably either insert a colon here
> 
> "Note: the kernel does not reject values in mask other  than  the..."
> 
> or reformulate the sentence like this.
> 
> "Note that the kernel does not reject values in mask other  than  the..."

I changed to the second suggestion.

> 
> 
>> [...] 
>>
>>        stx_gid
>>               The ID of the group that may access the file.
> 
> This group ID is the gid of the file owner's primary group, no? At least
> that's what the field comment in the DESCRIPTION implies.
> 
> I think it would be more accurate to write:
> 
> "The ID of the file owner's primary group"


I made it:

    This field contains the ID of the group owner of the file.

> 
>> [...] 
>>
>>        STATX_ATTR_COMPRESSED
>>               The  file  is  compressed  by  the fs and may take extra
> 
> We write out 'filesystem' everywhere else so I think we should replace 'fs'
> with it here as well.

Indeed! (Fixed.)

>> CONFORMING TO
>>        statx() is Linux specific.
> 
> For consistency we should write:
> 
> "statx() is Linux-specific".

Fixed.

> I wrote the changes in-line but if you prefer I can 'git send-email'
> a patch as well.

This form of feedback is fine.

> Cheers and thanks for all the hard work!

You're welcome. Thanks for checking it.

Cheers,

Michael


-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Linux/UNIX System Programming Training: http://man7.org/training/
--
To unsubscribe from this list: send the line "unsubscribe linux-man" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
