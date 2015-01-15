From: Pavel Emelyanov <xemul@parallels.com>
Subject: Re: [LSF/MM TOPIC] userfaultfd
Date: Thu, 15 Jan 2015 12:01:45 +0300
Message-ID: <54B781F9.8050703@parallels.com>
References: <20150114230130.GR6103@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <20150114230130.GR6103@redhat.com>
Sender: owner-linux-mm@kvack.org
To: Andrea Arcangeli <aarcange@redhat.com>, lsf-pc@lists.linux-foundation.org
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On 01/15/2015 02:01 AM, Andrea Arcangeli wrote:
> Hello,
> 
> I would like to attend this year (2015) LSF/MM summit. I'm
> particularly interested about the MM track, in order to get help in
> finalizing the userfaultfd feature I've been working on lately.

I'd like the +1 this. I'm also interested in this topic, especially
in the item 5 below.

> 5) postcopy live migration of binaries inside linux containers
>    (provided there is a userfaultfd command [not an external syscall
>    like the original implementation] that allows to copy memory
>    atomically in the userfaultfd "mm" and not in the manager "mm",
>    hence the main reason the external syscalls are going away, and in
>    turn MADV_USERFAULT fd-less is going away as well).

We've started to play with the userfaultfd in the CRIU project [1] to 
do the post-copy live migration of whole containers (and their parts).

One more use case I've seen on CRIU mailing list is the restore of
container from on-disk images w/o getting the whole memory in at the
restore time. The memory is to be put into tasks' address space in
n-demand manner later. It's claimed that such restore decreases the 
restore time significantly.


One more thing that userfaultfd can help with is restoring COW areas.
Right now, if we have two tasks, that share a phys page, but have one
RO mapped to do the COW later we do complex tricks with restoring the
page in common ancestor, then inheriting one on fork()-s and mremap-ing
it. Probably it's an API misuse, but it seems to be much simpler if
the page could be just "sent" to the remote mm via userfaultfd.

[1] http://criu.org/Main_Page

Thanks,
Pavel

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
