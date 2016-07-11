From: ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org (Eric W. Biederman)
Subject: Re: [PATCH review 08/12] quota: Ensure qids map to the filesystem
Date: Mon, 11 Jul 2016 13:12:49 -0500
Message-ID: <878tx8dowu.fsf@x220.int.ebiederm.org>
References: <874m82bptc.fsf@x220.int.ebiederm.org>
	<20160706181212.16267-1-ebiederm@xmission.com>
	<20160706181212.16267-8-ebiederm@xmission.com>
	<20160711101424.GH12410@quack2.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160711101424.GH12410-4I4JzKEfoa/jFM9bn6wA6Q@public.gmane.org> (Jan Kara's message of
	"Mon, 11 Jul 2016 12:14:24 +0200")
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
Cc: Linux Containers <containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, Seth Forshee <seth.forshee-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>, Djalal Harouni <tixxdz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "Serge E. Hallyn" <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Jann Horn <jann-XZ1E9jl8jIdeoWH0uzbU5w@public.gmane.org>, Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org> writes:

> On Wed 06-07-16 13:12:08, Eric W. Biederman wrote:
>> Introduce the helper qid_has_mapping and use it to ensure that the
>> quota system only considers qids that map to the filesystems
>> s_user_ns.
>> 
>> In practice for quota supporting filesystems today this is the exact
>> same check as qid_valid.  As only 0xffffffff aka (qid_t)-1 does not
>> map into init_user_ns.
>> 
>> Replace the qid_valid calls with qid_has_mapping as values come in
>> from userspace.  This is harmless today and it prepares the quota
>> system to work on filesystems with quotas but mounted by unprivileged
>> users.
>> 
>> Call qid_has_mapping from dqget.  This ensures the passed in qid has a
>> prepresentation on the underlying filesystem.  Previously this was
>> unnecessary as filesystesm never had qids that could not map.  With
>> the introduction of filesystems outside of s_user_ns this will not
>> remain true.
>> 
>> All of this ensures the quota code never has to deal with qids that
>> don't map to the underlying filesystem.
>
> Does this and the following patch make sense when we actually don't allow
> quotas when s_user_ns is set? If things are untested, they will get broken
> so I think it is wiser to do the conversion only once we decide quota
> should be supported for namespaces != init_user_ns. Or do I miss
> something?

All of the code will get exercised in the success case.  So I don't
think there is a strong chance of bitrot.

The patches are trivially correct so I am not concerned about them.

What the patches add are a logical consistency with the rest of the vfs.
In my tree the rest of the vfs now handles uids and gids that can not be
mapped to a filesystem and returns an error.  In my tree the rest of the
vfs now effectively assumes that uids and gids are stored in s_user_ns
on a filesystem.

So I freely admit there is a slight chance that some bit-rot will occur
and the quota code will be changed in such a way that those assumptions
are broken.  Bugs happen.   I think it much less likely if all of the
generic code in the vfs makes the same assumptions.



The place where I am concerned about thorough review and testing is
someone poisoning quota files and then the kernel trying to use them.
In the preliminary work we have done in other places in the kernel and
for other filesystems there almost always winds up being some way to
confuse the kernel and get it to misbave if you can poison the disk
based inputs.  As poison disk based inputs is not something filesystems
are stronlgy concerned about.  In most cases the disk the filesystem
resides on is in the box and therefore under control of the OS at all
times.  Dave Chinner has even said he will never consider handling
poisoned disk based inputs for XFS as the run time cost is too high.


Between actually finding issues that can cause problems, and the
increased amount of kernel code executed (and thus the increase in
kernel attack surface) I am very paranoid about enabling code that
trusts data that could be poisoned data from a hostile party.


At the same time I am very uncomfortable with the fact the kernel does
not protect against malicious disks and poisoned disk images.  As
poisoned disk images are a well known exploit vector in the wild.  A
well known and demonstrated attack vector that works is to leave a usb
stick in a public place, and helpful people will place it into their
computer to try and figure out who it belongs to.  In trying to be
helpful their computer will unbeknownst to them start executing code
that does not serve the interests of the computer owner.  I hate that we
can not currently protect people from shenanigans like that.

So I intend to be as responsible and as careful as I can, but also to
push forward in the hopes that we can eventually not have to worry about
our computers betraying us when we as human beings perform reasonable
actions.

Eric
