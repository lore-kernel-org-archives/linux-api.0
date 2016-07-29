From: ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org (Eric W. Biederman)
Subject: Re: [PATCH 0/5 RFC] Add an interface to discover relationships between namespaces
Date: Fri, 29 Jul 2016 13:05:48 -0500
Message-ID: <87h9b8e2v7.fsf@x220.int.ebiederm.org>
References: <1515f5f2-5a49-fcab-61f4-8b627d3ba3e2@gmail.com>
	<CANaxB-w8H8Wo8FmtmBBZTpJX-ZDGRQx0rbm9E5c9WbduQ_Ukmw@mail.gmail.com>
	<e2811bf1-4b86-e115-bcdb-301d6f2546eb@gmail.com>
	<87lh0pg8jx.fsf@x220.int.ebiederm.org>
	<44ca0e41-dc92-45b1-2a6c-c41a048a072d@gmail.com>
	<87r3ahepb4.fsf@x220.int.ebiederm.org>
	<20160726025455.GC26206@outlook.office365.com>
	<3390535b-0660-757f-aeba-c03d936b3485@gmail.com>
	<20160726182524.GA328@outlook.office365.com>
	<CAKgNAkjmOu+vfiMDyeYQkkf7wQBH9PVmJ4nH2CTg43GrN-k7eA@mail.gmail.com>
	<20160726203955.GA9415@outlook.office365.com>
	<ca0787a3-b270-e962-46d1-7e63c9335a55@gmail.com>
	<87popxkjjp.fsf@x220.int.ebiederm.org>
	<40e35f1a-10e6-b7a5-936e-a09f008be0d0@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <40e35f1a-10e6-b7a5-936e-a09f008be0d0-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> (Michael
	Kerrisk's message of "Thu, 28 Jul 2016 21:00:32 +0200")
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Andrew Vagin <avagin-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>, Andrey Vagin <avagin-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>, "Serge E. Hallyn" <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>, "criu@openvz.org" <criu-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux Containers <containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, James Bottomley <James.Bottomley-JuX6DAaQMKPCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>, linux-fsdevel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>
List-Id: linux-api@vger.kernel.org

"Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> writes:

> Hi Eric,
>
> On 07/28/2016 02:56 PM, Eric W. Biederman wrote:
>> "Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> writes:
>>
>>> On 07/26/2016 10:39 PM, Andrew Vagin wrote:
>>>> On Tue, Jul 26, 2016 at 09:17:31PM +0200, Michael Kerrisk (man-pages) wrote:
>>
>>>> If we want to compare two file descriptors of the current process,
>>>> it is one of cases for which kcmp can be used. We can call kcmp to
>>>> compare two namespaces which are opened in other processes.
>>>
>>> Is there really a use case there? I assume we're talking about the
>>> scenario where a process in one namespace opens a /proc/PID/ns/*
>>> file descriptor and passes that FD to another process via a UNIX
>>> domain socket. Is that correct?
>>>
>>> So, supposing that we want to build a map of the relationships
>>> between namespaces using the proposed kcmp() API, and there are
>>> say N namespaces? Does this mena we make (N * (N-1) / 2) calls
>>> to kcmp()?
>>
>> Potentially.  The numbers are small enough O(N^2) isn't fatal.
>
> Define "small", please.
>
> O(N^2) makes me nervous about what other use cases lurk out
> there that may get bitten by this.

Worst case for N (One namespace per thread) is about 60k.
A typical heavy use case may be 1000 namespaces of any type.
So we are talking about O(N^2) that rarely happens and should be done in
a couple of seconds.

>> Where kcmp shines is that it allows migration to happen.  Inode numbers
>> to change (which they very much will today), and still have things work.
>
>
>> We can keep it O(Nlog(N)) by taking advantage of not just the equality
>> but the ordering relationship.  Although Ugh.
>
> Yes, that sounds pretty ugly...

Actually having thought about this a little more if kcmp returns an
ordering by inode and migration preserves the relative order of
the inodes (which should just be a creation order) it should be quite
solvable.

Switch from an order by inode number to an order by object creation
time, and guarantee that all creations are have an order (which with
task_list_lock we practically already have) and it should be even easier
to create.  (A 64bit nanosecond resolution timestamp is good for 544
years of uptime).  A 64bit number that increments each time an object is
created should have an even better lifespan.

I don't know if we can find a way to give that guarantee for other kcmp
comparisons but it is worth a thought.

>>One disadvantage of
>> kcmp currently is that the way the ordering relationship is defined
>> the order is not preserved over migration :(
>
> So, does kcmp() fully solve the proble(s) at hand? It sounds like
> not, if I understand your last point correctly.

There are 3 possibilities I see for migration in migration, ordered
in order of implementation difficulty.
1) Have a clear signal that migration happened and a nested migration
   needs to restart.
2) Use kcmp so that only the relative order needs to be preserved.
3) Preserve the device number and inode numbers.

At a practical level I think (2) may actually in net be the simplest.
It requires a little more care to implement and you have to opt in,
but it should not require any rolling back of activity (merely careful
ordering of object creation).

I definititely like kcmp knowing how to compare things by inode
(aka st_dev, st_inode) because then even if you have to restart
the comparisons after a migration the exact details you are comparing
are hidden and so it is easier to support and harder to get wrong.

I can imagine how to preserve inode numbers by creating a new instance
of nsfs instance and using the old inode numbers upon restore.  I don't
currently see how we could possibly preserve st_dev over migration short of
a device number namespace.

So if we are going to continue with making device numbers be a legacy
attribute applications should not care about we need a way to compare
things by not looking at st_dev.  Which brings us back to kcmp.

Hmm.  Hotplugging as disk and plugging it back likely will change the
device number and give the same kind of challenge with st_dev (although
you can't keep a file descriptor open across that kind of event).  So
certainly a hotplug event on a device should be enough to say don't care
about the device number.

Eric
