From: Anna Schumaker <Anna.Schumaker@netapp.com>
Subject: Re: [PATCH v1 0/8] VFS: In-kernel copy system call
Date: Thu, 10 Sep 2015 11:10:55 -0400
Message-ID: <55F19D7F.5090907@Netapp.com>
References: <1441397823-1203-1-git-send-email-Anna.Schumaker@Netapp.com>
 <55EEFCEE.5090000@draigBrady.com> <55EF279B.3020101@Netapp.com>
 <CALCETrXxRB-LXVb+=nkwfj0zEjWuXXTctkSAc9Oec0fgyOQ5Yg@mail.gmail.com>
 <55EF3EFD.3080302@draigBrady.com> <20150908212907.GD30681@birch.djwong.org>
 <CALCETrWAotvN+MBsxq4QLQBr_WAyydqMnipcaTM88rM8sSx43w@mail.gmail.com>
 <20150908223959.GE30681@birch.djwong.org> <55F07FD8.4020507@Netapp.com>
 <20150909211636.GB10399@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20150909211636.GB10399@birch.djwong.org>
Sender: linux-btrfs-owner@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Andy Lutomirski <luto@amacapital.net>, =?UTF-8?Q?P=c3=a1draig_Brady?= <P@draigbrady.com>, linux-nfs@vger.kernel.org, Linux btrfs Developers List <linux-btrfs@vger.kernel.org>, Linux FS Devel <linux-fsdevel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, Zach Brown <zab@zabbo.net>, Al Viro <viro@zeniv.linux.org.uk>, Chris Mason <clm@fb.com>, Michael Kerrisk-manpages <mtk.manpages@gmail.com>, andros@netapp.com, Christoph Hellwig <hch@infradead.org>, Coreutils <coreutils@gnu.org>, Austin S Hemmelgarn <ahferroin7@gmail.com>
List-Id: linux-api@vger.kernel.org

On 09/09/2015 05:16 PM, Darrick J. Wong wrote:
> On Wed, Sep 09, 2015 at 02:52:08PM -0400, Anna Schumaker wrote:
>> On 09/08/2015 06:39 PM, Darrick J. Wong wrote:
>>> On Tue, Sep 08, 2015 at 02:45:39PM -0700, Andy Lutomirski wrote:
>>>> On Tue, Sep 8, 2015 at 2:29 PM, Darrick J. Wong <darrick.wong@orac=
le.com> wrote:
>>>>> On Tue, Sep 08, 2015 at 09:03:09PM +0100, P=C3=A1draig Brady wrot=
e:
>>>>>> On 08/09/15 20:10, Andy Lutomirski wrote:
>>>>>>> On Tue, Sep 8, 2015 at 11:23 AM, Anna Schumaker
>>>>>>> <Anna.Schumaker@netapp.com> wrote:
>>>>>>>> On 09/08/2015 11:21 AM, P=C3=A1draig Brady wrote:
>>>>>>>>> I see copy_file_range() is a reflink() on BTRFS?
>>>>>>>>> That's a bit surprising, as it avoids the copy completely.
>>>>>>>>> cp(1) for example considered doing a BTRFS clone by default,
>>>>>>>>> but didn't due to expectations that users actually wanted
>>>>>>>>> the data duplicated on disk for resilience reasons,
>>>>>>>>> and for performance reasons so that write latencies were
>>>>>>>>> restricted to the copy operation, rather than being
>>>>>>>>> introduced at usage time as the dest file is CoW'd.
>>>>>>>>>
>>>>>>>>> If reflink() is a possibility for copy_file_range()
>>>>>>>>> then could it be done optionally with a flag?
>>>>>>>>
>>>>>>>> The idea is that filesystems get to choose how to handle copie=
s in the
>>>>>>>> default case.  BTRFS could do a reflink, but NFS could do a se=
rver side
>>>>>
>>>>> Eww, different default behaviors depending on the filesystem. :)
>>>>>
>>>>>>>> copy instead.  I can change the default behavior to only do a =
data copy
>>>>>>>> (unless the reflink flag is specified) instead, if that is des=
irable.
>>>>>>>>
>>>>>>>> What does everybody think?
>>>>>>>
>>>>>>> I think the best you could do is to have a hint asking politely=
 for
>>>>>>> the data to be deep-copied.  After all, some filesystems reserv=
e the
>>>>>>> right to transparently deduplicate.
>>>>>>>
>>>>>>> Also, on a true COW filesystem (e.g. btrfs sometimes), there ma=
y be no
>>>>>>> advantage to deep copying unless you actually want two copies f=
or
>>>>>>> locality reasons.
>>>>>>
>>>>>> Agreed. The relink and server side copy are separate things.
>>>>>> There's no advantage to not doing a server side copy,
>>>>>> but as mentioned there may be advantages to doing deep copies on=
 BTRFS
>>>>>> (another reason not previous mentioned in this thread, would be
>>>>>> to avoid ENOSPC errors at some time in the future).
>>>>>>
>>>>>> So having control over the deep copy seems useful.
>>>>>> It's debatable whether ALLOW_REFLINK should be on/off by default
>>>>>> for copy_file_range().  I'd be inclined to have such a setting o=
ff by default,
>>>>>> but cp(1) at least will work with whatever is chosen.
>>>>>
>>>>> So far it looks like people are interested in at least these "mak=
e data appear
>>>>> in this other place" filesystem operations:
>>>>>
>>>>> 1. reflink
>>>>> 2. reflink, but only if the contents are the same (dedupe)
>>>>
>>>> What I meant by this was: if you ask for "regular copy", you may e=
nd
>>>> up with a reflink anyway.  Anyway, how can you reflink a range and
>>>> have the contents *not* be the same?
>>>
>>> reflink forcibly remaps fd_dest's range to fd_src's range.  If they=
 didn't
>>> match before, they will afterwards.
>>>
>>> dedupe remaps fd_dest's range to fd_src's range only if they match,=
 of course.
>>>
>>> Perhaps I should have said "...if the contents are the same before =
the call"?
>>>
>>>>
>>>>> 3. regular copy
>>>>> 4. regular copy, but make the hardware do it for us
>>>>> 5. regular copy, but require a second copy on the media (no-dedup=
e)
>>>>
>>>> If this comes from me, I have no desire to ever use this as a flag=
=2E
>>>
>>> I meant (5) as a "disable auto-dedupe for this operation" flag, not=
 as
>>> a "reallocate all the shared blocks now" op...
>>>
>>>> If someone wants to use chattr or some new operation to say "make =
this
>>>> range of this file belong just to me for purpose of optimizing fut=
ure
>>>> writes", then sure, go for it, with the understanding that there a=
re
>>>> plenty of filesystems for which that doesn't even make sense.
>>>
>>> "Unshare these blocks" sounds more like something fallocate could d=
o.
>>>
>>> So far in my XFS reflink playground, it seems that using the defrag=
 tool to
>>> un-cow a file makes most sense.  AFAICT the XFS and ext4 defraggers=
 copy a
>>> fragmented file's data to a second file and use a 'swap extents' op=
eration,
>>> after which the donor file is unlinked.
>>>
>>> Hey, if this syscall turns into a more generic "do something involv=
ing two
>>> (fd:off:len) (fd:off:len) tuples" call, I guess we could throw in "=
swap
>>> extents" as a 7th operation, to refactor the ioctls.  <smirk>
>>>
>>>>
>>>>> 6. regular copy, but don't CoW (eatmyothercopies) (joke)
>>>>>
>>>>> (Please add whatever ops I missed.)
>>>>>
>>>>> I think I can see a case for letting (4) fall back to (3) since (=
4) is an
>>>>> optimization of (3).
>>>>>
>>>>> However, I particularly don't like the idea of (1) falling back t=
o (3-5).
>>>>> Either the kernel can satisfy a request or it can't, but let's no=
t just
>>>>> assume that we should transmogrify one type of request into anoth=
er.  Userspace
>>>>> should decide if a reflink failure should turn into one of the co=
py variants,
>>>>> depending on whether the user wants to spread allocation costs ov=
er rewrites or
>>>>> pay it all up front.  Also, if we allow reflink to fall back to c=
opy, how do
>>>>> programs find out what actually took place?  Or do we simply not =
allow them to
>>>>> find out?
>>>>>
>>>>> Also, programs that expect reflink either to finish or fail quick=
ly might be
>>>>> surprised if it's possible for reflink to take a longer time than=
 usual and
>>>>> with the side effect that a deep(er) copy was made.
>>>>>
>>>>> I guess if someone asks for both (1) and (3) we can do the fallba=
ck in the
>>>>> kernel, like how we handle it right now.
>>>>>
>>>>
>>>> I think we should focus on what the actual legit use cases might b=
e.
>>>> Certainly we want to support a mode that's "reflink or fail".  We
>>>> could have these flags:
>>>>
>>>> COPY_FILE_RANGE_ALLOW_REFLINK
>>>> COPY_FILE_RANGE_ALLOW_COPY
>>>>
>>>> Setting neither gets -EINVAL.  Setting both works as is.  Setting =
just
>>>> ALLOW_REFLINK will fail if a reflink can't be supported.  Setting =
just
>>>> ALLOW_COPY will make a best-effort attempt not to reflink but
>>>> expressly permits reflinking in cases where either (a) plain old
>>>> write(2) might also result in a reflink or (b) there is no advanta=
ge
>>>> to not reflinking.
>>>
>>> I don't agree with having a 'copy' flag that can reflink when we al=
so have a
>>> 'reflink' flag.  I guess I just don't like having a flag with diffe=
rent
>>> meanings depending on context.
>>>
>>> Users should be able to get the default behavior by passing '0' for=
 flags, so
>>> provide FORBID_REFLINK and FORBID_COPY flags to turn off those beha=
viors, with
>>> an admonishment that one should only use them if they have a gooooo=
d reason.
>>> Passing neither gets you reflink-xor-copy, which is what I think we=
 both want
>>> in the general case.
>>
>> I agree here that 0 for flags should do something useful, and I want=
ed to
>> double check if reflink-xor-copy is a good default behavior.
>=20
> Ok.
>=20
>>>
>>> FORBID_REFLINK =3D 1
>>> FORBID_COPY =3D 2
>>
>> I don't like the idea of using flags to forbid behavior.  I think it=
 would be
>> more straightforward to have flags like REFLINK_ONLY or COPY_ONLY so=
 users
>> can tell us what they want, instead of what they don't want.
>=20
> Seems fine to me.
>=20
>> While I'm thinking about flags, COPY_FILE_RANGE_REFLINK_ONLY would b=
e a bit
>> of a mouthful.  Does anybody have suggestions for ways that I could =
make this
>> shorter?
>=20
> CFR_REFLINK_ONLY?

That could work!  Although I might do as Austin suggests and drop the _=
ONLY part, and then make the man page clear about what's going on.

Would you expect to trigger a NFS server side copy by passing the pagec=
ache copy flag?  Or would that only happen if I pass flags=3D0?

Anna

>=20
> --D
>=20
>>
>> Thanks,
>> Anna
>>
>>> CHECK_SAME =3D 4
>>> HW_COPY =3D 8
>>>
>>> DEDUPE =3D (FORBID_COPY | CHECK_SAME)
>>>
>>> What do you say to that?
>>>
>>>> An example of (b) would be a filesystem backed by deduped
>>>> thinly-provisioned storage that can't do anything about ENOSPC bec=
ause
>>>> it doesn't control it in the first place.
>>>>
>>>> Another option would be to split up the copy case into "I expect t=
o
>>>> overwrite a lot of the target file soon, so (c) try to commit spac=
e
>>>> for that or (d) try to make it time-efficient".  Of course, (d) is
>>>> irrelevant on filesystems with no random access (nvdimms, for
>>>> example).
>>>>
>>>> I guess the tl;dr is that I'm highly skeptical of any use for
>>>> disallowing reflinking other than forcibly committing space in cas=
es
>>>> where committing space actually means something.
>>>
>>> That's more or less where I was going too. :)
>>>
>>> --D
>>>
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-api"=
 in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
