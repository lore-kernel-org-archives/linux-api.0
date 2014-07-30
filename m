From: ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org (Eric W. Biederman)
Subject: Re: [RFC PATCHv2 00/11] Adding FreeBSD's Capsicum security framework
Date: Tue, 29 Jul 2014 23:22:01 -0700
Message-ID: <87iomfgyd2.fsf@x220.int.ebiederm.org>
References: <1406296033-32693-1-git-send-email-drysdale@google.com>
	<871tt796i0.fsf@x220.int.ebiederm.org>
	<CAHse=S_7Jpb9bTXHgU8q8_UZ=ce2gwdq8C15a+jbfO_pHmV_iA@mail.gmail.com>
	<87ha21qja0.fsf@x220.int.ebiederm.org>
	<CAHse=S_w4+AMuc=-XbAK_PiaD56_ks13R53RENMHif5KRN_Kiw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAHse=S_w4+AMuc=-XbAK_PiaD56_ks13R53RENMHif5KRN_Kiw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
	(David Drysdale's message of "Tue, 29 Jul 2014 11:58:21 +0100")
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David Drysdale <drysdale-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: LSM List <linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel@vger.kernel.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Meredydd Luff <meredydd-zPN50pYk8eUaUu29zAJCuw@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, James Morris <james.l.morris-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Paolo Bonzini <pbonzini-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Paul Moore <paul-r2n+y4ga6xFZroRs9YW3xA@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org


I have cut this down to just focus on O_BENEATH openat case.

David Drysdale <drysdale-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> writes:

> On Mon, Jul 28, 2014 at 10:13 PM, Eric W. Biederman
> <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org> wrote:

>> Nope.  What you can implement today if you want fine grained limitations
>> like this is to create a mount namespace with exactly the subdirectory
>> tree you want to allow access to and to return a file descriptor that
>> points into that mount namespace.  (When complete the only user of that
>> mount namespace would be your file descriptor).
>
> How does that solve the particular example I mentioned?  The DFD
> within the mount namespace will still allow any operation on any file
> that's already in the subdirectory -- or am I misunderstanding
> something?

The goal was to bound the DFD to the directory and all of it's
subdirectories such that openat(dfd, "../../..") would open
the dfd, and that further opens of other directories would also not
allow you to escape.

Since the mount namespace only contains the choosen directory and it's
subdirectories that works easily and trivially.

So while you can indeed perform any file operation on that dfd who
cares because none of those operations can get you anywhere you aren't
supposed to be.

My point was that you can as granular as you would like by binding a dfd
to a mount namespace instead of binding a process to a mount namespace,
and the code already exists and is being maintained.

So while things are not packaged in the form that has been requested it
looks to me as if the functionality for directories already exists
within the Linux kernel.

Eric
