From: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
Subject: Re: [PATCH v1 0/8] VFS: In-kernel copy system call
Date: Tue, 8 Sep 2015 12:10:41 -0700
Message-ID: <CALCETrXxRB-LXVb+=nkwfj0zEjWuXXTctkSAc9Oec0fgyOQ5Yg@mail.gmail.com>
References: <1441397823-1203-1-git-send-email-Anna.Schumaker@Netapp.com>
 <55EEFCEE.5090000@draigBrady.com> <55EF279B.3020101@Netapp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <55EF279B.3020101-ZwjVKphTwtPQT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Anna Schumaker <Anna.Schumaker-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org>
Cc: =?UTF-8?Q?P=C3=A1draig_Brady?= <P@draigbrady.com>, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linux btrfs Developers List <linux-btrfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux FS Devel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Zach Brown <zab-ugsP4Wv/S6ZeoWH0uzbU5w@public.gmane.org>, Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Chris Mason <clm-b10kYP2dOMg@public.gmane.org>, "Darrick J. Wong" <darrick.wong-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Michael Kerrisk-manpages <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, andros-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Tue, Sep 8, 2015 at 11:23 AM, Anna Schumaker
<Anna.Schumaker-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org> wrote:
> On 09/08/2015 11:21 AM, P=C3=A1draig Brady wrote:
>> I see copy_file_range() is a reflink() on BTRFS?
>> That's a bit surprising, as it avoids the copy completely.
>> cp(1) for example considered doing a BTRFS clone by default,
>> but didn't due to expectations that users actually wanted
>> the data duplicated on disk for resilience reasons,
>> and for performance reasons so that write latencies were
>> restricted to the copy operation, rather than being
>> introduced at usage time as the dest file is CoW'd.
>>
>> If reflink() is a possibility for copy_file_range()
>> then could it be done optionally with a flag?
>
> The idea is that filesystems get to choose how to handle copies in th=
e default case.  BTRFS could do a reflink, but NFS could do a server si=
de copy instead.  I can change the default behavior to only do a data c=
opy (unless the reflink flag is specified) instead, if that is desirabl=
e.
>
> What does everybody think?

I think the best you could do is to have a hint asking politely for
the data to be deep-copied.  After all, some filesystems reserve the
right to transparently deduplicate.

Also, on a true COW filesystem (e.g. btrfs sometimes), there may be no
advantage to deep copying unless you actually want two copies for
locality reasons.

--Andy
