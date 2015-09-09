From: Anna Schumaker <Anna.Schumaker@netapp.com>
Subject: Re: [PATCH v1 0/8] VFS: In-kernel copy system call
Date: Wed, 9 Sep 2015 14:52:08 -0400
Message-ID: <55F07FD8.4020507@Netapp.com>
References: <1441397823-1203-1-git-send-email-Anna.Schumaker@Netapp.com>
 <55EEFCEE.5090000@draigBrady.com> <55EF279B.3020101@Netapp.com>
 <CALCETrXxRB-LXVb+=nkwfj0zEjWuXXTctkSAc9Oec0fgyOQ5Yg@mail.gmail.com>
 <55EF3EFD.3080302@draigBrady.com> <20150908212907.GD30681@birch.djwong.org>
 <CALCETrWAotvN+MBsxq4QLQBr_WAyydqMnipcaTM88rM8sSx43w@mail.gmail.com>
 <20150908223959.GE30681@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20150908223959.GE30681@birch.djwong.org>
Sender: linux-fsdevel-owner@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>, Andy Lutomirski <luto@amacapital.net>
Cc: =?UTF-8?Q?P=c3=a1draig_Brady?= <P@draigbrady.com>, linux-nfs@vger.kernel.org, Linux btrfs Developers List <linux-btrfs@vger.kernel.org>, Linux FS Devel <linux-fsdevel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, Zach Brown <zab@zabbo.net>, Al Viro <viro@zeniv.linux.org.uk>, Chris Mason <clm@fb.com>, Michael Kerrisk-manpages <mtk.manpages@gmail.com>, andros@netapp.com, Christoph Hellwig <hch@infradead.org>, Coreutils <coreutils@gnu.org>
List-Id: linux-api@vger.kernel.org

On 09/08/2015 06:39 PM, Darrick J. Wong wrote:
> On Tue, Sep 08, 2015 at 02:45:39PM -0700, Andy Lutomirski wrote:
>> On Tue, Sep 8, 2015 at 2:29 PM, Darrick J. Wong <darrick.wong@oracle=
=2Ecom> wrote:
>>> On Tue, Sep 08, 2015 at 09:03:09PM +0100, P=C3=A1draig Brady wrote:
>>>> On 08/09/15 20:10, Andy Lutomirski wrote:
>>>>> On Tue, Sep 8, 2015 at 11:23 AM, Anna Schumaker
>>>>> <Anna.Schumaker@netapp.com> wrote:
>>>>>> On 09/08/2015 11:21 AM, P=C3=A1draig Brady wrote:
>>>>>>> I see copy_file_range() is a reflink() on BTRFS?
>>>>>>> That's a bit surprising, as it avoids the copy completely.
>>>>>>> cp(1) for example considered doing a BTRFS clone by default,
>>>>>>> but didn't due to expectations that users actually wanted
>>>>>>> the data duplicated on disk for resilience reasons,
>>>>>>> and for performance reasons so that write latencies were
>>>>>>> restricted to the copy operation, rather than being
>>>>>>> introduced at usage time as the dest file is CoW'd.
>>>>>>>
>>>>>>> If reflink() is a possibility for copy_file_range()
>>>>>>> then could it be done optionally with a flag?
>>>>>>
>>>>>> The idea is that filesystems get to choose how to handle copies =
in the
>>>>>> default case.  BTRFS could do a reflink, but NFS could do a serv=
er side
>>>
>>> Eww, different default behaviors depending on the filesystem. :)
>>>
>>>>>> copy instead.  I can change the default behavior to only do a da=
ta copy
>>>>>> (unless the reflink flag is specified) instead, if that is desir=
able.
>>>>>>
>>>>>> What does everybody think?
>>>>>
>>>>> I think the best you could do is to have a hint asking politely f=
or
>>>>> the data to be deep-copied.  After all, some filesystems reserve =
the
>>>>> right to transparently deduplicate.
>>>>>
>>>>> Also, on a true COW filesystem (e.g. btrfs sometimes), there may =
be no
>>>>> advantage to deep copying unless you actually want two copies for
>>>>> locality reasons.
>>>>
>>>> Agreed. The relink and server side copy are separate things.
>>>> There's no advantage to not doing a server side copy,
>>>> but as mentioned there may be advantages to doing deep copies on B=
TRFS
>>>> (another reason not previous mentioned in this thread, would be
>>>> to avoid ENOSPC errors at some time in the future).
>>>>
>>>> So having control over the deep copy seems useful.
>>>> It's debatable whether ALLOW_REFLINK should be on/off by default
>>>> for copy_file_range().  I'd be inclined to have such a setting off=
 by default,
>>>> but cp(1) at least will work with whatever is chosen.
>>>
>>> So far it looks like people are interested in at least these "make =
data appear
>>> in this other place" filesystem operations:
>>>
>>> 1. reflink
>>> 2. reflink, but only if the contents are the same (dedupe)
>>
>> What I meant by this was: if you ask for "regular copy", you may end
>> up with a reflink anyway.  Anyway, how can you reflink a range and
>> have the contents *not* be the same?
>=20
> reflink forcibly remaps fd_dest's range to fd_src's range.  If they d=
idn't
> match before, they will afterwards.
>=20
> dedupe remaps fd_dest's range to fd_src's range only if they match, o=
f course.
>=20
> Perhaps I should have said "...if the contents are the same before th=
e call"?
>=20
>>
>>> 3. regular copy
>>> 4. regular copy, but make the hardware do it for us
>>> 5. regular copy, but require a second copy on the media (no-dedupe)
>>
>> If this comes from me, I have no desire to ever use this as a flag.
>=20
> I meant (5) as a "disable auto-dedupe for this operation" flag, not a=
s
> a "reallocate all the shared blocks now" op...
>=20
>> If someone wants to use chattr or some new operation to say "make th=
is
>> range of this file belong just to me for purpose of optimizing futur=
e
>> writes", then sure, go for it, with the understanding that there are
>> plenty of filesystems for which that doesn't even make sense.
>=20
> "Unshare these blocks" sounds more like something fallocate could do.
>=20
> So far in my XFS reflink playground, it seems that using the defrag t=
ool to
> un-cow a file makes most sense.  AFAICT the XFS and ext4 defraggers c=
opy a
> fragmented file's data to a second file and use a 'swap extents' oper=
ation,
> after which the donor file is unlinked.
>=20
> Hey, if this syscall turns into a more generic "do something involvin=
g two
> (fd:off:len) (fd:off:len) tuples" call, I guess we could throw in "sw=
ap
> extents" as a 7th operation, to refactor the ioctls.  <smirk>
>=20
>>
>>> 6. regular copy, but don't CoW (eatmyothercopies) (joke)
>>>
>>> (Please add whatever ops I missed.)
>>>
>>> I think I can see a case for letting (4) fall back to (3) since (4)=
 is an
>>> optimization of (3).
>>>
>>> However, I particularly don't like the idea of (1) falling back to =
(3-5).
>>> Either the kernel can satisfy a request or it can't, but let's not =
just
>>> assume that we should transmogrify one type of request into another=
=2E  Userspace
>>> should decide if a reflink failure should turn into one of the copy=
 variants,
>>> depending on whether the user wants to spread allocation costs over=
 rewrites or
>>> pay it all up front.  Also, if we allow reflink to fall back to cop=
y, how do
>>> programs find out what actually took place?  Or do we simply not al=
low them to
>>> find out?
>>>
>>> Also, programs that expect reflink either to finish or fail quickly=
 might be
>>> surprised if it's possible for reflink to take a longer time than u=
sual and
>>> with the side effect that a deep(er) copy was made.
>>>
>>> I guess if someone asks for both (1) and (3) we can do the fallback=
 in the
>>> kernel, like how we handle it right now.
>>>
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
>=20
> I don't agree with having a 'copy' flag that can reflink when we also=
 have a
> 'reflink' flag.  I guess I just don't like having a flag with differe=
nt
> meanings depending on context.
>=20
> Users should be able to get the default behavior by passing '0' for f=
lags, so
> provide FORBID_REFLINK and FORBID_COPY flags to turn off those behavi=
ors, with
> an admonishment that one should only use them if they have a goooood =
reason.
> Passing neither gets you reflink-xor-copy, which is what I think we b=
oth want
> in the general case.

I agree here that 0 for flags should do something useful, and I wanted =
to double check if reflink-xor-copy is a good default behavior.

>=20
> FORBID_REFLINK =3D 1
> FORBID_COPY =3D 2

I don't like the idea of using flags to forbid behavior.  I think it wo=
uld be more straightforward to have flags like REFLINK_ONLY or COPY_ONL=
Y so users can tell us what they want, instead of what they don't want.

While I'm thinking about flags, COPY_FILE_RANGE_REFLINK_ONLY would be a=
 bit of a mouthful.  Does anybody have suggestions for ways that I coul=
d make this shorter?

Thanks,
Anna

> CHECK_SAME =3D 4
> HW_COPY =3D 8
>=20
> DEDUPE =3D (FORBID_COPY | CHECK_SAME)
>=20
> What do you say to that?
>=20
>> An example of (b) would be a filesystem backed by deduped
>> thinly-provisioned storage that can't do anything about ENOSPC becau=
se
>> it doesn't control it in the first place.
>>
>> Another option would be to split up the copy case into "I expect to
>> overwrite a lot of the target file soon, so (c) try to commit space
>> for that or (d) try to make it time-efficient".  Of course, (d) is
>> irrelevant on filesystems with no random access (nvdimms, for
>> example).
>>
>> I guess the tl;dr is that I'm highly skeptical of any use for
>> disallowing reflinking other than forcibly committing space in cases
>> where committing space actually means something.
>=20
> That's more or less where I was going too. :)
>=20
> --D
>=20

--
To unsubscribe from this list: send the line "unsubscribe linux-fsdevel=
" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
