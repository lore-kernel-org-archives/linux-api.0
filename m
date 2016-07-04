From: ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org (Eric W. Biederman)
Subject: Re: [PATCH review 0/11] General unprivileged mount support
Date: Mon, 04 Jul 2016 11:27:46 -0500
Message-ID: <87h9c52wsd.fsf@x220.int.ebiederm.org>
References: <87ziq03qnj.fsf@x220.int.ebiederm.org>
	<20160704085220.GC5200@quack2.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160704085220.GC5200-4I4JzKEfoa/jFM9bn6wA6Q@public.gmane.org> (Jan Kara's message of
	"Mon, 4 Jul 2016 10:52:20 +0200")
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
Cc: Seth Forshee <seth.forshee-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, Linux Containers <containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>, Djalal Harouni <tixxdz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "Serge E. Hallyn" <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Jann Horn <jannh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org> writes:

> On Sat 02-07-16 12:18:08, Eric W. Biederman wrote:
>> 
>> As well as in these patches the code is also available from:
>> git://git.kernel.org/pub/scm/linux/kernel/git/ebiederm/user-namespace.git for-testing
>> 
>> It has been a long time in coming but recently in the userns tree the
>> superblock has been expanded with a s_user_ns field indicating the user
>> namespace that owns a superblock.
>> 
>> The s_user_ns owner of a superblock has three implications.
>> - Only kuids and kgids that map into s_user_ns are allowed to be sent to a
>>  filesystem from the vfs.
>> - If the uid or gid on the filesystem does not map into s_user_ns i_uid
>>   is set to INVALID_UID and i_gid is set to INVALID_GID.
>> - The scope of permission checks can be changed from global to a
>>   capabilitiy check in s_user_ns.
>
> OK, to check that I understand it right:
>
> So the uids and gids that are stored on disk are still expected to be in
> the initial id namespace, aren't they?

No.

The general expectation is that the ids on disk are store in s_user_ns.

Id's that don't map to the initial id namespace get stored in the
generic data structures as INVALID_UID and INVALID_GID.

In practice I don't expect anyone will set up a situation knowingly
where id's don't map, but the case has to be handled because mistakes
and malicious code happens.

Eric
