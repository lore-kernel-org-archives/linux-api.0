From: Eric Dumazet <dada1-fPLkHRcR87vqlBn2x/YWAg@public.gmane.org>
Subject: Re: [PATCH 2/4] Convert epoll to a bitlock
Date: Wed, 04 Feb 2009 03:48:07 +0100
Message-ID: <498901E7.4050405@cosmosbay.com>
References: <1233598811-6871-1-git-send-email-corbet@lwn.net> <1233598811-6871-3-git-send-email-corbet@lwn.net> <20090203133942.2ecec281.akpm@linux-foundation.org> <4988BD4E.8080206@cosmosbay.com> <alpine.DEB.1.10.0902031446280.23050@alien.or.mcafeemobile.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <alpine.DEB.1.10.0902031446280.23050-GPJ85BhbkB8RepQJljzAVbITYcZ0+W3JAL8bYrjMMd8@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Davide Libenzi <davidel-AhlLAIvw+VEjIGhXcJzhZg@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, andi-Vw/NltI1exuRpAAqCnN02g@public.gmane.org, oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, viro-3bDd1+5oDREiFSDQTTA3OLVCufUGDwFn@public.gmane.org, David Miller <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>, hch-jcswGhMUV9g@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, mpm-VDJrAJ4Gl5ZBDgjK7y7TUQ@public.gmane.org, Alan Cox <alan-qBU/x9rampVanCEyBjwyrvXRex20P6io@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Davide Libenzi a =E9crit :
> On Tue, 3 Feb 2009, Eric Dumazet wrote:
>=20
>> Andrew Morton a =E9crit :
>>> On Mon,  2 Feb 2009 11:20:09 -0700
>>> Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org> wrote:
>>>
>>>> Matt Mackall suggested converting epoll's ep_lock to a bitlock as =
a way of
>>>> saving space in struct file.  This patch makes that change.
>>> hrm.  bit_spin_lock() makes people upset (large penguiny people).  =
iirc
>>> it doesn't have all the correct/well-understood memory/compiler
>>> ordering semantics which spinlocks have.  And lockdep doesn't know =
about
>>> it.
>>>
>> In a previous attempt (2005), I suggested using a single global lock=
=2E
>>
>> http://search.luky.org/linux-kernel.2005/msg50862.html
>>
>> Probably an array of hashed spinlocks would be more than enough.
>=20
> That could be done, although I'm not sure it's worth going that way t=
o=20
> save 4 bytes. The effective saving rate is not even 4/sizeof(struct f=
ile)=20
> since struct file never comes alone, and when you allocate a struct f=
ile=20
> you always carry more allocations behind (at least for the cases wher=
e you=20
> tend to have a lot of them around, so size would matter).
> The add/remove path in epoll is not a super-hot one, so it could be d=
one.=20
> I dunno how this change matter with the patchset though.

Back in 2005, I saved 4 bytes per file, and because of HWCACHE alignmen=
t, sizeof(struct file)
shrinked by 64 bytes. With more than 1.000.000 sockets opened on a busy=
 server, it saved
64 MB of ram. At that time, this mattered (8GB of ram), but in 2009, 64=
 MB is so small
I dont care anymore about sizeof(struct file)

AFAIK, I just checked on x86_64 and got : sizeof(struct file)=3D0xc0 , =
so thats perfect :)

(Only thing I still do is to move private_data in the first cache line =
of struct file, because
it speedups a lot socket operation, when dealing with 1.000.000 sockets=
 : one cache line miss
avoided per socket syscall)

diff --git a/include/linux/fs.h b/include/linux/fs.h
index 6022f44..03b2227 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -842,6 +842,8 @@ struct file {
 #define f_dentry       f_path.dentry
 #define f_vfsmnt       f_path.mnt
        const struct file_operations    *f_op;
+       /* needed for tty driver, and maybe others */
+       void                    *private_data;
        atomic_long_t           f_count;
        unsigned int            f_flags;
        fmode_t                 f_mode;
@@ -854,8 +856,6 @@ struct file {
 #ifdef CONFIG_SECURITY
        void                    *f_security;
 #endif
-       /* needed for tty driver, and maybe others */
-       void                    *private_data;

 #ifdef CONFIG_EPOLL
        /* Used by fs/eventpoll.c to link all the hooks to this file */


--
To unsubscribe from this list: send the line "unsubscribe linux-api" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
