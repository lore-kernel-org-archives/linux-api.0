From: "Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: shmctl(SHM_STAT) vs. /proc/sysvipc/shm permissions discrepancies
Date: Tue, 19 Dec 2017 17:45:40 +0100
Message-ID: <CAKgNAkjJrmCFY-h2oqKS3zM_D+Csx-17A27mh08WKahyOVzrgQ@mail.gmail.com>
References: <20171219094848.GE2787@dhcp22.suse.cz>
Reply-To: mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171219094848.GE2787-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Manfred Spraul <manfred-nhLOkwUX5cPe2c5cEj3t2g@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Mike Waychison <mikew-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org" <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Hello Michal,

On 19 December 2017 at 10:48, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
> Hi,
> we have been contacted by our partner about the following permission
> discrepancy
>
> 1. Create a shared memory segment with permissions 600 with user A using
>    shmget(key, 1024, 0600 | IPC_CREAT)
> 2. ipcs -m should return an output as follows:
>
> ------ Shared Memory Segments --------
> key        shmid      owner      perms      bytes      nattch     status
> 0x58b74326 759562241  A          600        1024       0
>
> 3. Try to read the metadata with shmctl(0, SHM_STAT,...) as user B.
> 4. shmctl will return -EACCES
>
> The supper set information provided by shmctl can be retrieved by
> reading /proc/sysvipc/shm which does not require read permissions
> because it is 444.
>
> It seems that the discrepancy is there since ae7817745eef ("[PATCH] ipc:
> add generic struct ipc_ids seq_file iteration") when the proc interface
> has been introduced. The changelog is really modest on information or
> intention but I suspect this just got overlooked during review. SHM_STAT
> has always been about read permission and it is explicitly documented
> that way.

Yes, this was always a weirdness on Linux. Back before we got
/proc/sysvipc, it meant that ipcs(1) on Linux did not did not display
all IPC objects (unlike most other implementations, where ipcs(1)
showed everyone's objects, regardless of permissions). I remember
having an email conversation with Andries Brouwer about this, around
15 years ago. Eventually, an October 2012 series of util-linux patches
by Sami Kerola switched ipcs(1) to use /proc/sysvipc so that ipcs(1)
does now show all System V IPC objects.

> I am not a security expert to judge whether this leak can have some
> interesting consequences but I am really interested whether this is
> something we want to keep that way.  Do we want to filter and dump only
> shmids the caller has access to?

Do you mean change /proc/sysvipc/* output? I don't think that should
be changed. Modern ipcs(1) relies on it to do The Right Thing.

> This would break the delegation AFAICS.
> Do we want to make the file root only? That would probably break an
> existing userspace as well.
>
> Or should we simply allow SHM_STAT for processes without a read permission
> because the same information can be read by other means already?
>
> Any other ideas?

The situation is certainly odd. The only risk that I see is that
modifying *_STAT behavior could lead to behavior changes in (strange?)
programs that expect SHM_STAT / MSG_STAT / SEM_STAT to return only
information about objects for which they have read permission. But, is
there a pressing reason to make the change? (Okay, I guess iterating
using *_STAT is nicer than parsing /proc/sysvipc/*.)

Cheers,

Michael


> --
> Michal Hocko
> SUSE Labs
> --
> To unsubscribe from this list: send the line "unsubscribe linux-api" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Linux/UNIX System Programming Training: http://man7.org/training/
