From: "Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Documenting MS_LAZYTIME
Date: Tue, 03 Mar 2015 08:14:08 +0100
Message-ID: <54F55F40.6010508@gmail.com>
References: <CAHO5Pa0k7QkV_6BDjwTVxa7LV9tFyN9nGFFcSvOC6HYO08wfrw@mail.gmail.com> <54E7578E.4090809@redhat.com> <20150221025636.GB7922@thunk.org> <54EEDE23.6080009@gmail.com> <20150226133113.GD11217@thunk.org> <54EF2161.90607@gmail.com> <20150227000409.GC17174@thunk.org> <54F02446.2050008@gmail.com> <20150227175159.GC11031@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-man-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150227175159.GC11031-PTl6brltDGh4DFYR7WNSRA@public.gmane.org>
Sender: linux-man-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Darrick J. Wong" <darrick.wong-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org>, Eric Sandeen <sandeen-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Ext4 Developers List <linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux btrfs Developers List <linux-btrfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, XFS Developers <xfs-VZNHf3L845pBDgjK7y7TUQ@public.gmane.org>, linux-man-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linux-Fsdevel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On 02/27/2015 06:51 PM, Darrick J. Wong wrote:
> On Fri, Feb 27, 2015 at 09:01:10AM +0100, Michael Kerrisk (man-pages) wrote:
>> On 02/27/2015 01:04 AM, Theodore Ts'o wrote:
>>> On Thu, Feb 26, 2015 at 02:36:33PM +0100, Michael Kerrisk (man-pages) wrote:
>>>>
>>>>     The disadvantage of MS_STRICTATIME | MS_LAZYTIME is that
>>>>     in the case of a system crash, the atime and mtime fields
>>>>     on disk might be out of date by at most 24 hours.
>>>
>>> I'd change to "The disadvantage of MS_LAZYTIME is that..."  and
>>> perhaps move that so it's clear it applies to any use of MS_LAZYTIME
>>> has this as a downside.
>>>
>>> Does that make sense?
>>
>> Thanks, Ted. Got it. So, now we have:
>>
>>        MS_LAZYTIME (since Linux 3.20)
> 
> "since Linux 4.0".

D'oh! Yes, thanks. Fixed.

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
