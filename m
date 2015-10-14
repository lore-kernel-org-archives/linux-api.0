From: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
Subject: Re: [PATCH v5 8/9] vfs: Add vfs_copy_file_range() support for
 pagecache copies
Date: Wed, 14 Oct 2015 11:38:13 -0700
Message-ID: <CALCETrWrHs6x+aZ7c=sySRCdzwdfUQZH_DL++vLL78NXXN+7FQ@mail.gmail.com>
References: <1443634014-3026-1-git-send-email-Anna.Schumaker@Netapp.com>
 <1443634014-3026-9-git-send-email-Anna.Schumaker@Netapp.com>
 <20151011142203.GA31867@infradead.org> <20151012231749.GC11398@birch.djwong.org>
 <561E980C.9010509@Netapp.com> <CALCETrU0-Q-q0u0BAPwu+mbyS+LVp6M1Hqro3xwzSm7eNCbEmg@mail.gmail.com>
 <20151014182701.GC31225@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20151014182701.GC31225-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Anna Schumaker <Anna.Schumaker-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org>, "Darrick J. Wong" <darrick.wong-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linux btrfs Developers List <linux-btrfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux FS Devel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Zach Brown <zab-ugsP4Wv/S6ZeoWH0uzbU5w@public.gmane.org>, Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Chris Mason <clm-b10kYP2dOMg@public.gmane.org>, Michael Kerrisk-manpages <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, andros-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Wed, Oct 14, 2015 at 11:27 AM, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org> wrote:
> On Wed, Oct 14, 2015 at 11:08:40AM -0700, Andy Lutomirski wrote:
>> > So what I'm hearing is that I should drop the reflink and dedup flags and change this system call only perform a full copy (with preserving of sparseness), correct?  I can make those changes, but only if everybody is in agreement that it's the best way forward.
>>
>> I personally rather like the reflink option.  That thing is quite useful.
>
> reflink is very useful, probably more useful than the copy actually. But it
> is different from a copy.  It should be a separate interface.

One might argue that reflink is like copy + immediate dedupe.  Also, I
can imagine there being network protocols over which you can't really
tell the difference between reflink and server-to-server copy.

--Andy

-- 
Andy Lutomirski
AMA Capital Management, LLC
--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
