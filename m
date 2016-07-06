From: ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org (Eric W. Biederman)
Subject: Re: [PATCH review 0/11] General unprivileged mount support
Date: Wed, 06 Jul 2016 10:19:04 -0500
Message-ID: <87vb0ilrpz.fsf@x220.int.ebiederm.org>
References: <87ziq03qnj.fsf@x220.int.ebiederm.org>
	<CALCETrVJ-2-BxyBW-P9sbjzR3cTTZ0vDzVO+8dhS14jdHXW2=Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
In-Reply-To: <CALCETrVJ-2-BxyBW-P9sbjzR3cTTZ0vDzVO+8dhS14jdHXW2=Q@mail.gmail.com>
	(Andy Lutomirski's message of "Wed, 6 Jul 2016 07:01:39 -0700")
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/containers>,
	<mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/containers/>
List-Post: <mailto:containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
List-Help: <mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/containers>,
	<mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=subscribe>
Sender: containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
Errors-To: containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
To: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
Cc: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>, Jann Horn <jannh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux Containers <containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, James Bottomley <James.Bottomley-JuX6DAaQMKPCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>, Seth Forshee <seth.forshee-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Linux FS Devel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Djalal Harouni <tixxdz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org> writes:

> On Sat, Jul 2, 2016 at 10:18 AM, Eric W. Biederman
> <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org> wrote:
>>
>> As well as in these patches the code is also available from:
>> git://git.kernel.org/pub/scm/linux/kernel/git/ebiederm/user-namespace.git for-testing
>>
>> It has been a long time in coming but recently in the userns tree the
>> superblock has been expanded with a s_user_ns field indicating the user
>> namespace that owns a superblock.
>>
>
> It would be nice if global root could mount otherwise-unsafe
> filesystems with s_user_ns set to a non-init namespace.  Do you have
> plans to allow that?

Looking at the code global root would pass the permission checks that
are present in my tree today.  At the same time I don't have a provision
for global root to specify the user namespace.

The practical limitation is that the filesystems need a little bit of
gentle massaging to handle the case when s_user_ns != &init_user_ns.
I think i_uid_read and i_uid_write already provide 90% of that.

The other limitation is that s_user_ns is defined as the owner of the
filesystem and as the default translation.  Which will mean root in
s_user_ns will be trusted to remount the filesystem.

The primary target right now is a safe unprivileged mount of fuse.


I am not opposed to extensions allowing the global root to mount
otherwise-unsafe filesystems with s_user_ns != &init_user_ns as long as
it is for cases where we can trust the underlying filesystem image and
don't mind giving root in s_user_ns all interesting permissions over the
filesystem.  I think that could be an very interesting intermediary step
in getting filesystems supported.  Still my focus is true unprivileged
mounts, there are a huge number of little details that go into getting
that right, and my poor brain can't handle looking at cases beyond that.

Eric
