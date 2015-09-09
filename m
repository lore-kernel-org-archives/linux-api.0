From: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
Subject: Re: [PATCH v1 0/8] VFS: In-kernel copy system call
Date: Wed, 9 Sep 2015 13:37:44 -0700
Message-ID: <CALCETrXPcxHWGwqhtkGStVabWDOsRbBy+VzrN+XxVZA_F9O0qA@mail.gmail.com>
References: <1441397823-1203-1-git-send-email-Anna.Schumaker@Netapp.com>
 <55EEFCEE.5090000@draigBrady.com> <55EF279B.3020101@Netapp.com>
 <CALCETrXxRB-LXVb+=nkwfj0zEjWuXXTctkSAc9Oec0fgyOQ5Yg@mail.gmail.com>
 <55EF3EFD.3080302@draigBrady.com> <20150908212907.GD30681@birch.djwong.org>
 <CALCETrWAotvN+MBsxq4QLQBr_WAyydqMnipcaTM88rM8sSx43w@mail.gmail.com>
 <20150908223959.GE30681@birch.djwong.org> <CALCETrVsWBdqvAgwxHcG=gbcWRNPG2ZziWUg1g=siKDrDu7S2Q@mail.gmail.com>
 <20150909200921.GD9511@ret.masoncoding.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150909200921.GD9511-DzB2rL6jT1BHfPKRx072akEOCMrvLtNR@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Chris Mason <clm-b10kYP2dOMg@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, "Darrick J. Wong" <darrick.wong-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, =?UTF-8?Q?P=C3=A1draig_Brady?= <P@draigbrady.com>, Anna Schumaker <Anna.Schumaker-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org>, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linux btrfs Developers List <linux-btrfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux FS Devel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Zach Brown <zab-ugsP4Wv/S6ZeoWH0uzbU5w@public.gmane.org>, Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Michael Kerrisk-manpages <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, andros-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Coreutils <coreutils-mXXj517/zsQ@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Wed, Sep 9, 2015 at 1:09 PM, Chris Mason <clm-b10kYP2dOMg@public.gmane.org> wrote:
> On Tue, Sep 08, 2015 at 04:08:43PM -0700, Andy Lutomirski wrote:
>> On Tue, Sep 8, 2015 at 3:39 PM, Darrick J. Wong <darrick.wong-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org> wrote:
>> > On Tue, Sep 08, 2015 at 02:45:39PM -0700, Andy Lutomirski wrote:
>> >> What I meant by this was: if you ask for "regular copy", you may end
>> >> up with a reflink anyway.  Anyway, how can you reflink a range and
>> >> have the contents *not* be the same?
>> >
>> > reflink forcibly remaps fd_dest's range to fd_src's range.  If they didn't
>> > match before, they will afterwards.
>> >
>> > dedupe remaps fd_dest's range to fd_src's range only if they match, of course.
>> >
>> > Perhaps I should have said "...if the contents are the same before the call"?
>> >
>>
>> Oh, I see.
>>
>> Can we have a clean way to figure out whether two file ranges are the
>> same in a way that allows false negatives?  I.e. return 1 if the
>> ranges are reflinks of each other and 0 if not?  Pretty please?  I've
>> implemented that in the past on btrfs by syncing the ranges and then
>> comparing FIEMAP output, but that's hideous.
>
> I'd almost rather have a separate call, maybe unshare_file_range()?
>
> Is that the end goal to the sharing check?

My use case was archival.  I can reflink data between a working copy
and some archived copy and then I can very efficiently tell if the
working copy has been changed by checking if the reflink is still
linked.

It would be even better if I could enumerate which parts of one file
match which parts of another file.

--Andy
--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
