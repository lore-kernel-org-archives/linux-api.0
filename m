From: David Herrmann <dh.herrmann-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v3 0/7] File Sealing & memfd_create()
Date: Tue, 17 Jun 2014 12:01:55 +0200
Message-ID: <CANq1E4T3KJZ++=KF2OZ_dd+NvPqg+=4Pw6O7Po3-ZxaaMHPukw@mail.gmail.com>
References: <1402655819-14325-1-git-send-email-dh.herrmann@gmail.com>
	<CALCETrVoE+JO2rLsBUHAOJdvescEEjxikj8iQ339Nxfopfc7pw@mail.gmail.com>
	<CANq1E4SaWLD=hNEc-CDJbNnrGfXE_PkxZFBhpW4tbK7wor7xPA@mail.gmail.com>
	<CALCETrU8N9EbnJ3=oQ1WQCG9Vunn3nR9Ba=J48wJm0SuH0YB4A@mail.gmail.com>
	<CANq1E4QQUKHabheq18AzkVZk3WDtAeC-6W66tVNB+EKgYOx1Vg@mail.gmail.com>
	<53A01049.6020502@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <53A01049.6020502-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Florian Weimer <fweimer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Ryan Lortie <desrt-0xnayjDhYQY@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, "linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org" <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Linux FS Devel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Greg Kroah-Hartman <greg-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org>, John Stultz <john.stultz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Lennart Poettering <lennart-mdGvqq1h2p+GdvJs77BJ7Q@public.gmane.org>, Daniel Mack <zonque-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Kay Sievers <kay-tD+1rO4QERM@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Tony Battersby <tonyb-vFAe+i1/wJI5UWNf+nJyDw@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Hi

On Tue, Jun 17, 2014 at 11:54 AM, Florian Weimer <fweimer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> On 06/13/2014 05:33 PM, David Herrmann wrote:
>>
>> On Fri, Jun 13, 2014 at 5:17 PM, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
>> wrote:
>>>
>>> Isn't the point of SEAL_SHRINK to allow servers to mmap and read
>>> safely without worrying about SIGBUS?
>>
>>
>> No, I don't think so.
>> The point of SEAL_SHRINK is to prevent a file from shrinking. SIGBUS
>> is an effect, not a cause. It's only a coincidence that "OOM during
>> reads" and "reading beyond file-boundaries" has the same effect:
>> SIGBUS.
>> We only protect against reading beyond file-boundaries due to
>> shrinking. Therefore, OOM-SIGBUS is unrelated to SEAL_SHRINK.
>>
>> Anyone dealing with mmap() _has_ to use mlock() to protect against
>> OOM-SIGBUS. Making SEAL_SHRINK protect against OOM-SIGBUS would be
>> redundant, because you can achieve the same with SEAL_SHRINK+mlock().
>
>
> I don't think this is what potential users expect because mlock requires
> capabilities which are not available to them.
>
> A couple of weeks ago, sealing was to be applied to anonymous shared memory.
> Has this changed?  Why should *reading* it trigger OOM?

The file might have holes, therefore, you'd have to allocate backing
pages. This might hit a soft-limit and fail. To avoid this, use
fallocate() to allocate pages prior to mmap() or mlock() to make the
kernel lock them in memory.

Thanks
David
