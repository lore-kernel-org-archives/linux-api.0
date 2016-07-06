From: ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org (Eric W. Biederman)
Subject: Re: [PATCH review 07/11] vfs: Don't create inodes with a uid or gid unknown to the vfs
Date: Wed, 06 Jul 2016 10:37:06 -0500
Message-ID: <87oa6akcbh.fsf@x220.int.ebiederm.org>
References: <87ziq03qnj.fsf@x220.int.ebiederm.org>
	<20160702172035.19568-1-ebiederm@xmission.com>
	<20160702172035.19568-7-ebiederm@xmission.com>
	<20160704075919.GA5200@quack2.suse.cz>
	<87zipwxhgp.fsf@x220.int.ebiederm.org>
	<20160706090705.GE14067@quack2.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160706090705.GE14067-4I4JzKEfoa/jFM9bn6wA6Q@public.gmane.org> (Jan Kara's message of
	"Wed, 6 Jul 2016 11:07:05 +0200")
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
Cc: Seth Forshee <seth.forshee-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, Linux Containers <containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>, Djalal Harouni <tixxdz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "Serge E. Hallyn" <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Jann Horn <jannh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org> writes:

> On Tue 05-07-16 09:55:18, Eric W. Biederman wrote:

>> To create a superblock has s_user_ns != &init_user_ns something like
>> the following has to occur.
>> 
>> setuid(1000);
>> unshare(CLONE_NEWUSER);
>> unshare(CLONE_NEWNS);
>> mount(....);
>> 
>> At which point the oridinary root user can not see the filesystem
>> with s_user_ns != &init_user_ns as it is located in another mount
>> namespace.
>> 
>> Which means root has to use setns to get into that mount namespace,
>> so there are going to be larger hints than -EOVERFLOW.
>
> OK, I see. Thanks for explanation. The inability of the admin (UID 0 in
> init_user_ns) to easily see and change any filesystem mounted in the system
> makes me somewhat nervous ;). But I guess the complexity is the price for
> the flexibility...

Certainly the price of not allowing unprivileged users to confuse
existing setuid 0 and setcap executables.

There are days I really wish I could do things the plan9 way and throw
out any legacy baggage that makes things hard to implement.  As I recall
plan9 threw out setuid, setgid and only supported the 9p filesystem to
make this all simple and almost safe.

Wonderfully and horribly I have to keep a lot more real world code
usable in this framework.

All of that said with the existence of CRIU I expect we will ultimately
have all of the interfaces needed for adminstration applications to see
everything that is going on.  Unfortunately sometimes those interfaces
and tools lag behind the rest of the work.

Eric
