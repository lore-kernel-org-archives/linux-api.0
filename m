From: ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org (Eric W. Biederman)
Subject: Re: [PATCH review 0/11] General unprivileged mount support
Date: Wed, 06 Jul 2016 10:21:02 -0500
Message-ID: <87poqqlrmp.fsf@x220.int.ebiederm.org>
References: <87ziq03qnj.fsf@x220.int.ebiederm.org>
	<CALCETrVof174gPCZnD2Z-RMjR-P=NcA0mYCU9ki6=o9hpFL-BA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
In-Reply-To: <CALCETrVof174gPCZnD2Z-RMjR-P=NcA0mYCU9ki6=o9hpFL-BA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
	(Andy Lutomirski's message of "Wed, 6 Jul 2016 06:44:55 -0700")
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
>
> Minor nit: in "fs: Refuse uid/gid changes which don't map into
> s_user_ns", the changelog ends in the middle of a sentence.

This text?
> For filesystems mounted from a user namespace on-disk ids should
> be translated relative to s_users_ns rather than init_user_ns.

> When an id in the filesystem doesn't exist in s_user_ns the
> associated id in the inode will be set to INVALID_[UG]ID, which
> turns these into de facto "nobody" ids. This actually maps pretty
> well into the way most code already works, and those places where
> it didn't were fixed in previous patches. Moving forward vfs code
> needs to be careful to handle instances where ids in inodes may
> be invalid.


I don't see the changelog problem you are talking about.

Eric
