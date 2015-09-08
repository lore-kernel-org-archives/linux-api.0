From: Andy Lutomirski <luto@amacapital.net>
Subject: Re: [PATCH v1 0/8] VFS: In-kernel copy system call
Date: Tue, 8 Sep 2015 16:08:43 -0700
Message-ID: <CALCETrVsWBdqvAgwxHcG=gbcWRNPG2ZziWUg1g=siKDrDu7S2Q@mail.gmail.com>
References: <1441397823-1203-1-git-send-email-Anna.Schumaker@Netapp.com>
 <55EEFCEE.5090000@draigBrady.com> <55EF279B.3020101@Netapp.com>
 <CALCETrXxRB-LXVb+=nkwfj0zEjWuXXTctkSAc9Oec0fgyOQ5Yg@mail.gmail.com>
 <55EF3EFD.3080302@draigBrady.com> <20150908212907.GD30681@birch.djwong.org>
 <CALCETrWAotvN+MBsxq4QLQBr_WAyydqMnipcaTM88rM8sSx43w@mail.gmail.com> <20150908223959.GE30681@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20150908223959.GE30681@birch.djwong.org>
Sender: linux-btrfs-owner@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: =?UTF-8?Q?P=C3=A1draig_Brady?= <P@draigbrady.com>, Anna Schumaker <Anna.Schumaker@netapp.com>, linux-nfs@vger.kernel.org, Linux btrfs Developers List <linux-btrfs@vger.kernel.org>, Linux FS Devel <linux-fsdevel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, Zach Brown <zab@zabbo.net>, Al Viro <viro@zeniv.linux.org.uk>, Chris Mason <clm@fb.com>, Michael Kerrisk-manpages <mtk.manpages@gmail.com>, andros@netapp.com, Christoph Hellwig <hch@infradead.org>, Coreutils <coreutils@gnu.org>
List-Id: linux-api@vger.kernel.org

On Tue, Sep 8, 2015 at 3:39 PM, Darrick J. Wong <darrick.wong@oracle.co=
m> wrote:
> On Tue, Sep 08, 2015 at 02:45:39PM -0700, Andy Lutomirski wrote:
>> On Tue, Sep 8, 2015 at 2:29 PM, Darrick J. Wong <darrick.wong@oracle=
=2Ecom> wrote:
>> > On Tue, Sep 08, 2015 at 09:03:09PM +0100, P=C3=A1draig Brady wrote=
:
>> >> On 08/09/15 20:10, Andy Lutomirski wrote:
>> >> > On Tue, Sep 8, 2015 at 11:23 AM, Anna Schumaker
>> >> > <Anna.Schumaker@netapp.com> wrote:
>> >> >> On 09/08/2015 11:21 AM, P=C3=A1draig Brady wrote:
>> >> >>> I see copy_file_range() is a reflink() on BTRFS?
>> >> >>> That's a bit surprising, as it avoids the copy completely.
>> >> >>> cp(1) for example considered doing a BTRFS clone by default,
>> >> >>> but didn't due to expectations that users actually wanted
>> >> >>> the data duplicated on disk for resilience reasons,
>> >> >>> and for performance reasons so that write latencies were
>> >> >>> restricted to the copy operation, rather than being
>> >> >>> introduced at usage time as the dest file is CoW'd.
>> >> >>>
>> >> >>> If reflink() is a possibility for copy_file_range()
>> >> >>> then could it be done optionally with a flag?
>> >> >>
>> >> >> The idea is that filesystems get to choose how to handle copie=
s in the
>> >> >> default case.  BTRFS could do a reflink, but NFS could do a se=
rver side
>> >
>> > Eww, different default behaviors depending on the filesystem. :)
>> >
>> >> >> copy instead.  I can change the default behavior to only do a =
data copy
>> >> >> (unless the reflink flag is specified) instead, if that is des=
irable.
>> >> >>
>> >> >> What does everybody think?
>> >> >
>> >> > I think the best you could do is to have a hint asking politely=
 for
>> >> > the data to be deep-copied.  After all, some filesystems reserv=
e the
>> >> > right to transparently deduplicate.
>> >> >
>> >> > Also, on a true COW filesystem (e.g. btrfs sometimes), there ma=
y be no
>> >> > advantage to deep copying unless you actually want two copies f=
or
>> >> > locality reasons.
>> >>
>> >> Agreed. The relink and server side copy are separate things.
>> >> There's no advantage to not doing a server side copy,
>> >> but as mentioned there may be advantages to doing deep copies on =
BTRFS
>> >> (another reason not previous mentioned in this thread, would be
>> >> to avoid ENOSPC errors at some time in the future).
>> >>
>> >> So having control over the deep copy seems useful.
>> >> It's debatable whether ALLOW_REFLINK should be on/off by default
>> >> for copy_file_range().  I'd be inclined to have such a setting of=
f by default,
>> >> but cp(1) at least will work with whatever is chosen.
>> >
>> > So far it looks like people are interested in at least these "make=
 data appear
>> > in this other place" filesystem operations:
>> >
>> > 1. reflink
>> > 2. reflink, but only if the contents are the same (dedupe)
>>
>> What I meant by this was: if you ask for "regular copy", you may end
>> up with a reflink anyway.  Anyway, how can you reflink a range and
>> have the contents *not* be the same?
>
> reflink forcibly remaps fd_dest's range to fd_src's range.  If they d=
idn't
> match before, they will afterwards.
>
> dedupe remaps fd_dest's range to fd_src's range only if they match, o=
f course.
>
> Perhaps I should have said "...if the contents are the same before th=
e call"?
>

Oh, I see.

Can we have a clean way to figure out whether two file ranges are the
same in a way that allows false negatives?  I.e. return 1 if the
ranges are reflinks of each other and 0 if not?  Pretty please?  I've
implemented that in the past on btrfs by syncing the ranges and then
comparing FIEMAP output, but that's hideous.

>>
>> > 3. regular copy
>> > 4. regular copy, but make the hardware do it for us
>> > 5. regular copy, but require a second copy on the media (no-dedupe=
)
>>
>> If this comes from me, I have no desire to ever use this as a flag.
>
> I meant (5) as a "disable auto-dedupe for this operation" flag, not a=
s
> a "reallocate all the shared blocks now" op...

Hmm, interesting.  What effect does it have on systems that do
deferred auto-dedupe?

>>
>> I think we should focus on what the actual legit use cases might be.
>> Certainly we want to support a mode that's "reflink or fail".  We
>> could have these flags:
>>
>> COPY_FILE_RANGE_ALLOW_REFLINK
>> COPY_FILE_RANGE_ALLOW_COPY
>>
>> Setting neither gets -EINVAL.  Setting both works as is.  Setting ju=
st
>> ALLOW_REFLINK will fail if a reflink can't be supported.  Setting ju=
st
>> ALLOW_COPY will make a best-effort attempt not to reflink but
>> expressly permits reflinking in cases where either (a) plain old
>> write(2) might also result in a reflink or (b) there is no advantage
>> to not reflinking.
>
> I don't agree with having a 'copy' flag that can reflink when we also=
 have a
> 'reflink' flag.  I guess I just don't like having a flag with differe=
nt
> meanings depending on context.
>
> Users should be able to get the default behavior by passing '0' for f=
lags, so
> provide FORBID_REFLINK and FORBID_COPY flags to turn off those behavi=
ors, with
> an admonishment that one should only use them if they have a goooood =
reason.
> Passing neither gets you reflink-xor-copy, which is what I think we b=
oth want
> in the general case.
>
> FORBID_REFLINK =3D 1
> FORBID_COPY =3D 2
> CHECK_SAME =3D 4
> HW_COPY =3D 8
>
> DEDUPE =3D (FORBID_COPY | CHECK_SAME)
>
> What do you say to that?

What does HW_COPY mean?

If we have enough weird combinations, maybe having a mode instead of
flags makes sense.

--Andy
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
