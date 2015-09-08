From: "Darrick J. Wong" <darrick.wong-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v1 0/8] VFS: In-kernel copy system call
Date: Tue, 8 Sep 2015 14:29:07 -0700
Message-ID: <20150908212907.GD30681@birch.djwong.org>
References: <1441397823-1203-1-git-send-email-Anna.Schumaker@Netapp.com>
 <55EEFCEE.5090000@draigBrady.com>
 <55EF279B.3020101@Netapp.com>
 <CALCETrXxRB-LXVb+=nkwfj0zEjWuXXTctkSAc9Oec0fgyOQ5Yg@mail.gmail.com>
 <55EF3EFD.3080302@draigBrady.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <55EF3EFD.3080302-V8g9lnOeT5ydJdNcDFJN0w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: =?iso-8859-1?Q?P=E1draig?= Brady <P@draigbrady.com>
Cc: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Anna Schumaker <Anna.Schumaker-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org>, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linux btrfs Developers List <linux-btrfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux FS Devel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Zach Brown <zab-ugsP4Wv/S6ZeoWH0uzbU5w@public.gmane.org>, Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Chris Mason <clm-b10kYP2dOMg@public.gmane.org>, Michael Kerrisk-manpages <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, andros-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Coreutils <coreutils-mXXj517/zsQ@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Tue, Sep 08, 2015 at 09:03:09PM +0100, P=E1draig Brady wrote:
> On 08/09/15 20:10, Andy Lutomirski wrote:
> > On Tue, Sep 8, 2015 at 11:23 AM, Anna Schumaker
> > <Anna.Schumaker-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org> wrote:
> >> On 09/08/2015 11:21 AM, P=E1draig Brady wrote:
> >>> I see copy_file_range() is a reflink() on BTRFS?
> >>> That's a bit surprising, as it avoids the copy completely.
> >>> cp(1) for example considered doing a BTRFS clone by default,
> >>> but didn't due to expectations that users actually wanted
> >>> the data duplicated on disk for resilience reasons,
> >>> and for performance reasons so that write latencies were
> >>> restricted to the copy operation, rather than being
> >>> introduced at usage time as the dest file is CoW'd.
> >>>
> >>> If reflink() is a possibility for copy_file_range()
> >>> then could it be done optionally with a flag?
> >>
> >> The idea is that filesystems get to choose how to handle copies in=
 the
> >> default case.  BTRFS could do a reflink, but NFS could do a server=
 side

Eww, different default behaviors depending on the filesystem. :)

> >> copy instead.  I can change the default behavior to only do a data=
 copy
> >> (unless the reflink flag is specified) instead, if that is desirab=
le.
> >>
> >> What does everybody think?
> >=20
> > I think the best you could do is to have a hint asking politely for
> > the data to be deep-copied.  After all, some filesystems reserve th=
e
> > right to transparently deduplicate.
> >=20
> > Also, on a true COW filesystem (e.g. btrfs sometimes), there may be=
 no
> > advantage to deep copying unless you actually want two copies for
> > locality reasons.
>=20
> Agreed. The relink and server side copy are separate things.
> There's no advantage to not doing a server side copy,
> but as mentioned there may be advantages to doing deep copies on BTRF=
S
> (another reason not previous mentioned in this thread, would be
> to avoid ENOSPC errors at some time in the future).
>=20
> So having control over the deep copy seems useful.
> It's debatable whether ALLOW_REFLINK should be on/off by default
> for copy_file_range().  I'd be inclined to have such a setting off by=
 default,
> but cp(1) at least will work with whatever is chosen.

So far it looks like people are interested in at least these "make data=
 appear
in this other place" filesystem operations:

1. reflink
2. reflink, but only if the contents are the same (dedupe)
3. regular copy
4. regular copy, but make the hardware do it for us
5. regular copy, but require a second copy on the media (no-dedupe)
6. regular copy, but don't CoW (eatmyothercopies) (joke)

(Please add whatever ops I missed.)

I think I can see a case for letting (4) fall back to (3) since (4) is =
an
optimization of (3).

However, I particularly don't like the idea of (1) falling back to (3-5=
).
Either the kernel can satisfy a request or it can't, but let's not just
assume that we should transmogrify one type of request into another.  U=
serspace
should decide if a reflink failure should turn into one of the copy var=
iants,
depending on whether the user wants to spread allocation costs over rew=
rites or
pay it all up front.  Also, if we allow reflink to fall back to copy, h=
ow do
programs find out what actually took place?  Or do we simply not allow =
them to
find out?

Also, programs that expect reflink either to finish or fail quickly mig=
ht be
surprised if it's possible for reflink to take a longer time than usual=
 and
with the side effect that a deep(er) copy was made.

I guess if someone asks for both (1) and (3) we can do the fallback in =
the
kernel, like how we handle it right now.

--D

>=20
> thanks,
> P=E1draig.
