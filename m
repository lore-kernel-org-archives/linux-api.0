From: Wang Sheng-Hui <shhuiw-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] mm: update the description for madvise_remove
Date: Wed, 25 Jun 2014 09:58:45 +0800
Message-ID: <53AA2CD5.6060202@gmail.com>
References: <53A9116B.9030004@gmail.com> <alpine.DEB.2.02.1406241542040.29176@chino.kir.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <alpine.DEB.2.02.1406241542040.29176-X6Q0R45D7oAcqpCFd4KODRPsWskHk0ljAL8bYrjMMd8@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Naoya Horiguchi <n-horiguchi-PaJj6Psr51x8UrSeD/g0lQ@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Andi Kleen <ak-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Vladimir Cernov <gg.kaspersky-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-man-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

Patch to man-page.

[PATCH] madvise.2: update the description for MADV_REMOVE

Currently we have more filesystems supporting fallcate, e.g ext4/btrfs,
which can response to MADV_REMOVE gracefully.

And if filesystems don't support fallocate, the return error would be
EOPNOTSUPP, instead of ENOSYS.

Signed-off-by: Wang Sheng-Hui <shhuiw-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 man2/madvise.2 | 10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

diff --git a/man2/madvise.2 b/man2/madvise.2
index 032ead7..4ce869c 100644
--- a/man2/madvise.2
+++ b/man2/madvise.2
@@ -99,13 +99,9 @@ or zero-fill-on-demand pages for mappings
 without an underlying file.
 .TP
 .BR MADV_REMOVE " (since Linux 2.6.16)"
-Free up a given range of pages
-and its associated backing store.
-Currently,
-.\" 2.6.18-rc5
-only shmfs/tmpfs supports this; other filesystems return with the
-error
-.BR ENOSYS .
+Free up a given range of pages and its associated backing store.
+Filesystems that don't support fallocate will return error
+.BR EOPNOTSUPP.
 .\" Databases want to use this feature to drop a section of their
 .\" bufferpool (shared memory segments) - without writing back to
 .\" disk/swap space.  This feature is also useful for supporting
--=20
1.8.3.2



On 2014=E5=B9=B406=E6=9C=8825=E6=97=A5 06:44, David Rientjes wrote:
> On Tue, 24 Jun 2014, Wang Sheng-Hui wrote:
>=20
>>
>> Currently, we have more filesystems supporting fallocate, e.g
>> ext4/btrfs. Remove the outdated comment for madvise_remove.
>>
>> Signed-off-by: Wang Sheng-Hui <shhuiw-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>> ---
>>  mm/madvise.c | 3 ---
>>  1 file changed, 3 deletions(-)
>>
>> diff --git a/mm/madvise.c b/mm/madvise.c
>> index a402f8f..0938b30 100644
>> --- a/mm/madvise.c
>> +++ b/mm/madvise.c
>> @@ -292,9 +292,6 @@ static long madvise_dontneed(struct vm_area_stru=
ct *vma,
>>  /*
>>   * Application wants to free up the pages and associated backing st=
ore.
>>   * This is effectively punching a hole into the middle of a file.
>> - *
>> - * NOTE: Currently, only shmfs/tmpfs is supported for this operatio=
n.
>> - * Other filesystems return -ENOSYS.
>>   */
>>  static long madvise_remove(struct vm_area_struct *vma,
>>                                 struct vm_area_struct **prev,
>=20
> [For those without context: this patch has been merged into the -mm t=
ree.]
>=20
> This reference also exists in the man-page for madvise(2), are you=20
> planning on removing it as well?
>=20
