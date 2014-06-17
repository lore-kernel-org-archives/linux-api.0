From: David Herrmann <dh.herrmann-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v3 0/7] File Sealing & memfd_create()
Date: Tue, 17 Jun 2014 15:26:23 +0200
Message-ID: <CANq1E4SGFoq1POtrP9DD91=3nbswELK9TH49_XkjE=Wwym4f+w@mail.gmail.com>
References: <1402655819-14325-1-git-send-email-dh.herrmann@gmail.com>
	<CALCETrVoE+JO2rLsBUHAOJdvescEEjxikj8iQ339Nxfopfc7pw@mail.gmail.com>
	<CANq1E4SaWLD=hNEc-CDJbNnrGfXE_PkxZFBhpW4tbK7wor7xPA@mail.gmail.com>
	<CALCETrU8N9EbnJ3=oQ1WQCG9Vunn3nR9Ba=J48wJm0SuH0YB4A@mail.gmail.com>
	<CANq1E4QQUKHabheq18AzkVZk3WDtAeC-6W66tVNB+EKgYOx1Vg@mail.gmail.com>
	<53A01049.6020502@redhat.com>
	<CANq1E4T3KJZ++=KF2OZ_dd+NvPqg+=4Pw6O7Po3-ZxaaMHPukw@mail.gmail.com>
	<53A012C8.7060109@redhat.com>
	<CANq1E4QinvVA-O=dX4N819jVK3xSihJcpz9juFj+A3qv0MXODg@mail.gmail.com>
	<53A030E9.7010701@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <53A030E9.7010701-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Florian Weimer <fweimer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Ryan Lortie <desrt-0xnayjDhYQY@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, "linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org" <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Linux FS Devel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Greg Kroah-Hartman <greg-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org>, John Stultz <john.stultz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Lennart Poettering <lennart-mdGvqq1h2p+GdvJs77BJ7Q@public.gmane.org>, Daniel Mack <zonque-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Kay Sievers <kay-tD+1rO4QERM@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Tony Battersby <tonyb-vFAe+i1/wJI5UWNf+nJyDw@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Hi

On Tue, Jun 17, 2014 at 2:13 PM, Florian Weimer <fweimer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> On 06/17/2014 12:10 PM, David Herrmann wrote:
>
>>>> The file might have holes, therefore, you'd have to allocate backing
>>>> pages. This might hit a soft-limit and fail. To avoid this, use
>>>> fallocate() to allocate pages prior to mmap()
>>>
>>>
>>> This does not work because the consuming side does not know how the
>>> descriptor was set up if sealing does not imply that.
>>
>>
>> The consuming side has to very seals via F_GET_SEALS. After that, it
>> shall do a simple fallocate() on the whole file if it wants to go sure
>> that all pages are allocated. Why shouldn't that be possible? Please
>> elaborate.
>
>
> Hmm.  You permit general fallocate even for WRITE seals.  That's really
> unexpected.

SEAL_WRITE prevents modifications of file-content. fallocate() does
not modify file-contents, so I think it's not unexpected that
fallocate() is still allowed.

> The inode_newsize_ok check in shmem_fallocate can result in SIGXFSZ, which
> doesn't seem to be what's intended here.

It can only result in SIGXFSZ if you _increase_ the file-size with
fallocate(). You shouldn't do that if you only verify that holes are
allocated. Hence, a simple fallocate(st.st_size) cannot result in
SIGXFSZ. Obviously, this requires SEAL_SHRINK to prevent the remote
site to shrink the file while you call fallocate(). But SEAL_WRITE
usually goes together with SEAL_SHRINK for obvious reasons.

> Will the new pages attributed to the process calling fallocate, or to the
> process calling memfd_create?

Pages are always allocated by the caller and charged on current->mm
(current process).

Thanks
David
